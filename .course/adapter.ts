/** Local, dependency-free Anthropic Messages → EIP Chat Completions adapter.
 * Node 24 strips the erasable TypeScript annotations directly.
 * Deliberate omissions: prompt-cache hints, metadata and output_config.effort.
 * Thinking, server tools, documents and structured-output formats fail explicitly.
 */
import { createServer, type IncomingMessage, type ServerResponse } from 'node:http';
import { createHash, randomBytes, timingSafeEqual } from 'node:crypto';
import { readFile, lstat, writeFile, rename, unlink } from 'node:fs/promises';
import { once } from 'node:events';
import { pathToFileURL } from 'node:url';

export type AdapterConfig = {
  upstream_base_url: string; api_key: string; eip_api_key: string;
  eip_system_name: 'AAH'; models: string[]; local_token: string;
  expires_at: string; port: number;
};
type Json = Record<string, any>;
type Fetcher = typeof fetch;
const MAX_BODY = 16 * 1024 * 1024;
const MAX_RESPONSE = 32 * 1024 * 1024;
const MAX_EVENT = 4 * 1024 * 1024;
const REQUEST_TIMEOUT = 300_000;
const IDLE_TIMEOUT = 60_000;
const MAX_CONCURRENT = 8;

export class AdapterError extends Error {
  status: number;
  kind: string;
  constructor(status: number, message: string, kind = 'invalid_request_error') {
    super(message); this.status = status; this.kind = kind;
  }
}
function invalid(message: string): never { throw new AdapterError(400, message); }
function object(value: unknown): value is Json { return !!value && typeof value === 'object' && !Array.isArray(value); }
function string(value: unknown, label: string): string {
  if (typeof value !== 'string') invalid(`${label} must be text.`);
  return value as string;
}
function array(value: unknown, label: string): any[] {
  if (!Array.isArray(value)) invalid(`${label} must be an array.`);
  return value as any[];
}
function headerSecret(value: unknown): value is string {
  return typeof value === 'string' && value.length >= 8 && value.length <= 16_384 && /^[\x21-\x7e]+$/.test(value);
}
function secureURL(value: unknown): URL {
  if (typeof value !== 'string') invalid('The upstream URL must use HTTPS.');
  let url: URL;
  try { url = new URL(value as string); } catch { invalid('The upstream URL is invalid.'); }
  if (url!.protocol !== 'https:' || url!.username || url!.password || url!.search || url!.hash) invalid('The upstream URL must use HTTPS without credentials, query or fragment.');
  return url!;
}
export function validateConfig(value: unknown): AdapterConfig {
  if (!object(value)) invalid('Invalid adapter configuration.');
  secureURL(value.upstream_base_url);
  if (!headerSecret(value.api_key) || !headerSecret(value.eip_api_key) || !headerSecret(value.local_token)) invalid('Invalid adapter credential configuration.');
  if (value.eip_system_name !== 'AAH') invalid('Unsupported EIP system name.');
  if (!Array.isArray(value.models) || !value.models.length || value.models.some((m: unknown) => typeof m !== 'string' || !m || /[\r\n]/.test(m))) invalid('Invalid model allowlist.');
  if (!Number.isInteger(value.port) || value.port < 0 || value.port > 65535) invalid('Invalid local adapter port.');
  if (typeof value.expires_at !== 'string' || !Number.isFinite(Date.parse(value.expires_at))) invalid('Invalid collection cutoff.');
  return value as AdapterConfig;
}
function sourceImage(block: Json): Json {
  const source = block.source;
  if (!object(source)) invalid('Image source is required.');
  if (source.type === 'base64') {
    if (!['image/png', 'image/jpeg', 'image/webp', 'image/gif'].includes(source.media_type)) invalid('Unsupported image media type.');
    if (typeof source.data !== 'string' || !source.data.length || !/^[A-Za-z0-9+/]*={0,2}$/.test(source.data)) invalid('Invalid base64 image data.');
    return { type: 'image_url', image_url: { url: `data:${source.media_type};base64,${source.data}` } };
  }
  if (source.type === 'url') {
    secureURL(source.url);
    return { type: 'image_url', image_url: { url: source.url } };
  }
  invalid('Unsupported image source type.');
}
function blocks(value: unknown): Json[] {
  if (typeof value === 'string') return [{ type: 'text', text: value }];
  return array(value, 'Message content').map((block) => {
    if (!object(block) || typeof block.type !== 'string') invalid('Invalid message content block.');
    return block;
  });
}
function textBlocks(value: unknown, label: string): string {
  return blocks(value).map((block) => {
    if (block.type !== 'text') invalid(`${label} supports text blocks only.`);
    return string(block.text, 'Text block');
  }).join('\n\n');
}

/** Preserve visible text/images and tool call/result identity; no source header is forwarded. */
export function translateRequest(input: unknown, config: AdapterConfig): Json {
  if (!object(input)) invalid('Messages request must be a JSON object.');
  if (typeof input.model !== 'string' || !config.models.includes(input.model)) invalid('The requested model is not permitted for this course.');
  if (!Number.isInteger(input.max_tokens) || input.max_tokens < 1 || input.max_tokens > 1_000_000) invalid('max_tokens must be a positive integer.');
  if (input.stream !== undefined && typeof input.stream !== 'boolean') invalid('stream must be boolean.');
  if (input.thinking !== undefined && (!object(input.thinking) || input.thinking.type !== 'disabled')) invalid('This course adapter does not support thinking; disable thinking and retry.');
  if (input.output_config !== undefined) {
    if (!object(input.output_config) || Object.keys(input.output_config).some((key) => key !== 'effort') || (input.output_config.effort !== undefined && typeof input.output_config.effort !== 'string')) invalid('Structured output configuration is not supported by this adapter.');
  }
  if (input.context_management !== undefined && (!object(input.context_management) || Object.keys(input.context_management).some((key) => key !== 'edits') || (input.context_management.edits !== undefined && (!Array.isArray(input.context_management.edits) || input.context_management.edits.length)))) invalid('Server-side context management is not supported by this adapter.');
  const allowed = new Set(['model', 'messages', 'max_tokens', 'system', 'stream', 'temperature', 'top_p', 'stop_sequences', 'tools', 'tool_choice', 'metadata', 'thinking', 'cache_control', 'output_config', 'context_management', 'service_tier']);
  if (Object.keys(input).some((key) => !allowed.has(key))) invalid('This request contains an unsupported Messages option.');
  const messages: Json[] = [];
  if (input.system !== undefined) messages.push({ role: 'system', content: textBlocks(input.system, 'System prompt') });
  const declaredCalls = new Set<string>();
  for (const message of array(input.messages, 'messages')) {
    if (!object(message) || !['user', 'assistant', 'system'].includes(message.role)) invalid('Messages must have user, assistant or system roles.');
    if (message.role === 'system') { messages.push({ role: 'system', content: textBlocks(message.content, 'System message') }); continue; }
    const content = blocks(message.content);
    if (message.role === 'assistant') {
      const text: string[] = []; const toolCalls: Json[] = [];
      for (const block of content) {
        if (block.type === 'text') text.push(string(block.text, 'Text block'));
        else if (block.type === 'tool_use') {
          if (typeof block.id !== 'string' || !block.id || typeof block.name !== 'string' || !block.name || !object(block.input)) invalid('Invalid tool_use block.');
          if (declaredCalls.has(block.id)) invalid('Duplicate tool call identity.');
          declaredCalls.add(block.id);
          toolCalls.push({ id: block.id, type: 'function', function: { name: block.name, arguments: JSON.stringify(block.input) } });
        } else invalid('Unsupported assistant content block; thinking and server-tool blocks cannot be translated.');
      }
      messages.push({ role: 'assistant', content: text.length ? text.join('\n\n') : null, ...(toolCalls.length ? { tool_calls: toolCalls } : {}) });
      continue;
    }
    let userParts: Json[] = [];
    const toolImages: Json[] = [];
    function flushUser() { if (userParts.length) { messages.push({ role: 'user', content: userParts }); userParts = []; } }
    for (const block of content) {
      if (block.type === 'text') userParts.push({ type: 'text', text: string(block.text, 'Text block') });
      else if (block.type === 'image') userParts.push(sourceImage(block));
      else if (block.type === 'tool_result') {
        flushUser();
        if (typeof block.tool_use_id !== 'string' || !declaredCalls.has(block.tool_use_id)) invalid('Tool result has no matching tool call.');
        const resultText: string[] = [];
        for (const result of blocks(block.content ?? '')) {
          if (result.type === 'text') resultText.push(string(result.text, 'Tool result text'));
          else if (result.type === 'image') {
            resultText.push('[Image from this tool result is included in the following user message.]');
            toolImages.push({ type: 'text', text: `Image from tool result ${block.tool_use_id}:` }, sourceImage(result));
          } else invalid('Unsupported tool-result content block.');
        }
        messages.push({ role: 'tool', tool_call_id: block.tool_use_id, content: `${block.is_error ? '[Tool error]\n' : ''}${resultText.join('\n\n')}` });
      } else invalid('Unsupported user content block; documents and server tools cannot be translated.');
    }
    if (toolImages.length) userParts.unshift(...toolImages);
    flushUser();
  }
  if (!messages.some((message) => message.role !== 'system')) invalid('At least one conversation message is required.');
  const result: Json = { model: input.model, messages, max_tokens: input.max_tokens, stream: input.stream === true, thinking: { type: 'disabled' } };
  for (const name of ['temperature', 'top_p']) {
    if (input[name] !== undefined) {
      if (typeof input[name] !== 'number' || !Number.isFinite(input[name])) invalid(`${name} must be a finite number.`);
      result[name] = input[name];
    }
  }
  if (input.stop_sequences !== undefined) {
    const stop = array(input.stop_sequences, 'stop_sequences');
    if (stop.length > 4 || stop.some((v) => typeof v !== 'string')) invalid('At most four text stop sequences are supported.');
    result.stop = stop;
  }
  if (input.tools !== undefined) {
    result.tools = array(input.tools, 'tools').map((tool) => {
      if (!object(tool) || (tool.type !== undefined && tool.type !== 'custom') || typeof tool.name !== 'string' || !tool.name || !object(tool.input_schema)) invalid('Only ordinary custom tools with JSON object schemas are supported.');
      if (tool.description !== undefined && typeof tool.description !== 'string') invalid('Tool description must be text.');
      return { type: 'function', function: { name: tool.name, ...(tool.description !== undefined ? { description: tool.description } : {}), parameters: tool.input_schema } };
    });
    if (!result.tools.length) delete result.tools;
  }
  if (input.tool_choice !== undefined) {
    const choice = input.tool_choice;
    if (!object(choice)) invalid('Invalid tool_choice.');
    if (choice.type === 'auto') result.tool_choice = 'auto';
    else if (choice.type === 'none') result.tool_choice = 'none';
    else if (choice.type === 'any') result.tool_choice = 'required';
    else if (choice.type === 'tool' && typeof choice.name === 'string' && result.tools?.some((tool: Json) => tool.function.name === choice.name)) result.tool_choice = { type: 'function', function: { name: choice.name } };
    else invalid('Unsupported tool_choice.');
    if (choice.disable_parallel_tool_use !== undefined) {
      if (typeof choice.disable_parallel_tool_use !== 'boolean') invalid('disable_parallel_tool_use must be boolean.');
      result.parallel_tool_calls = !choice.disable_parallel_tool_use;
    }
  }
  if (result.stream) result.stream_options = { include_usage: true };
  return result;
}
function usage(value: unknown): Json | undefined {
  if (!object(value)) return undefined;
  const result: Json = {};
  if (Number.isInteger(value.prompt_tokens) && value.prompt_tokens >= 0) result.input_tokens = value.prompt_tokens;
  if (Number.isInteger(value.completion_tokens) && value.completion_tokens >= 0) result.output_tokens = value.completion_tokens;
  return Object.keys(result).length ? result : undefined;
}
function finish(reason: unknown): string {
  if (reason === 'stop') return 'end_turn';
  if (reason === 'length') return 'max_tokens';
  if (reason === 'tool_calls' || reason === 'function_call') return 'tool_use';
  if (reason === 'content_filter') throw new AdapterError(502, 'The upstream provider filtered this response.', 'api_error');
  throw new AdapterError(502, 'The upstream response has an unsupported completion reason.', 'api_error');
}
function upstreamError(message: string): AdapterError { return new AdapterError(502, message, 'api_error'); }
function visibleContent(message: Json) {
  if (message.refusal) throw upstreamError('The upstream provider refused this response.');
  if (message.reasoning_content || message.reasoning || message.thinking || message.thinking_blocks?.length || message.reasoning_details?.length) throw upstreamError('The upstream returned unsupported thinking content.');
  if (message.function_call) throw upstreamError('The upstream returned an unsupported legacy function call.');
}
export function translateResponse(body: unknown, model: string): Json {
  if (!object(body) || !Array.isArray(body.choices) || body.choices.length !== 1) throw upstreamError('The upstream returned an invalid completion.');
  const choice = body.choices[0]; const message = choice?.message;
  if (!object(message)) throw upstreamError('The upstream returned an invalid message.');
  visibleContent(message);
  const content: Json[] = [];
  if (message.content !== undefined && message.content !== null) {
    if (typeof message.content !== 'string') throw upstreamError('The upstream returned unsupported message content.');
    if (message.content) content.push({ type: 'text', text: message.content });
  }
  if (message.tool_calls !== undefined) {
    if (!Array.isArray(message.tool_calls)) throw upstreamError('The upstream returned invalid tool calls.');
    const toolIds = new Set<string>();
    for (const call of message.tool_calls) {
      if (!object(call) || call.type !== 'function' || typeof call.id !== 'string' || !call.id || typeof call.function?.name !== 'string' || !call.function.name || typeof call.function.arguments !== 'string') throw upstreamError('The upstream returned an invalid tool call.');
      if (toolIds.has(call.id)) throw upstreamError('The upstream returned duplicate tool identities.');
      toolIds.add(call.id);
      let input: unknown;
      try { input = JSON.parse(call.function.arguments); } catch { throw upstreamError('The upstream returned incomplete tool arguments.'); }
      if (!object(input)) throw upstreamError('The upstream returned non-object tool arguments.');
      content.push({ type: 'tool_use', id: call.id, name: call.function.name, input });
    }
  }
  const reported = usage(body.usage);
  return { id: `msg_${randomBytes(16).toString('hex')}`, type: 'message', role: 'assistant', model, content, stop_reason: finish(choice.finish_reason), stop_sequence: null, usage: { input_tokens: reported?.input_tokens ?? 0, output_tokens: reported?.output_tokens ?? 0 }, ...(reported?.input_tokens !== undefined && reported?.output_tokens !== undefined ? {} : { adapter_usage: reported ? 'partial' : 'unavailable' }) };
}

/** Parse UTF-8 SSE incrementally, including split CRLF and multiline data fields. */
export async function* sseData(body: ReadableStream<Uint8Array>, signal?: AbortSignal): AsyncGenerator<string> {
  const reader = body.getReader(); const decoder = new TextDecoder('utf-8', { fatal: true });
  let buffer = ''; let lines: string[] = []; let bytes = 0;
  try {
    while (true) {
      let timer: ReturnType<typeof setTimeout> | undefined;
      const timeout = new Promise<never>((_, reject) => { timer = setTimeout(() => reject(upstreamError('The upstream stream timed out.')), IDLE_TIMEOUT); timer.unref(); });
      let abortRead: (() => void) | undefined;
      const interrupted = new Promise<never>((_, reject) => {
        abortRead = () => reject(upstreamError('The upstream request was interrupted.'));
        if (signal?.aborted) abortRead();
        else signal?.addEventListener('abort', abortRead, { once: true });
      });
      const { value, done } = await Promise.race([reader.read(), timeout, interrupted]).finally(() => {
        if (timer) clearTimeout(timer);
        if (abortRead) signal?.removeEventListener('abort', abortRead);
      });
      if (signal?.aborted) throw upstreamError('The upstream request was interrupted.');
      if (value) bytes += value.byteLength;
      if (bytes > MAX_RESPONSE) throw upstreamError('The upstream response exceeded the size limit.');
      buffer += decoder.decode(value, { stream: !done });
      let newline: number;
      while ((newline = buffer.indexOf('\n')) >= 0) {
        const line = buffer.slice(0, newline).replace(/\r$/, ''); buffer = buffer.slice(newline + 1);
        if (!line) { if (lines.length) yield lines.join('\n'); lines = []; }
        else if (line.startsWith('data:')) { lines.push(line.slice(5).replace(/^ /, '')); if (lines.reduce((sum, part) => sum + part.length, 0) > MAX_EVENT) throw upstreamError('The upstream event exceeded the size limit.'); }
      }
      if (buffer.length > MAX_EVENT) throw upstreamError('The upstream event exceeded the size limit.');
      if (done) {
        if (buffer.startsWith('data:')) lines.push(buffer.slice(5).replace(/^ /, '').replace(/\r$/, ''));
        if (lines.length) yield lines.join('\n');
        break;
      }
    }
  } finally { await reader.cancel().catch(() => {}); reader.releaseLock(); }
}

type EventSink = (name: string, data: Json) => Promise<void>;
/** Translate parallel incremental function arguments without pretending partial JSON is complete. */
export async function translateStream(body: ReadableStream<Uint8Array>, model: string, emit: EventSink, signal?: AbortSignal): Promise<void> {
  const tools = new Map<number, { index: number; id: string; name: string; arguments: string; emitted: number; started: boolean }>();
  let textIndex: number | undefined; let nextIndex = 0; let reason: string | undefined; let reported: Json | undefined; let ended = false;
  const id = `msg_${randomBytes(16).toString('hex')}`;
  await emit('message_start', { type: 'message_start', message: { id, type: 'message', role: 'assistant', model, content: [], stop_reason: null, stop_sequence: null, usage: { input_tokens: 0, output_tokens: 0 } } });
  for await (const data of sseData(body, signal)) {
    if (data === '[DONE]') { ended = true; break; }
    let chunk: Json;
    try { chunk = JSON.parse(data); } catch { throw upstreamError('The upstream stream contained invalid JSON.'); }
    if (!object(chunk) || chunk.error) throw upstreamError('The upstream provider reported a streaming error.');
    const snapshot = usage(chunk.usage); if (snapshot) reported = { ...reported, ...snapshot };
    if (!Array.isArray(chunk.choices)) throw upstreamError('The upstream stream contained invalid choices.');
    if (!chunk.choices.length) continue;
    if (chunk.choices.length !== 1 || (chunk.choices[0].index !== undefined && chunk.choices[0].index !== 0)) throw upstreamError('Multiple upstream completions are unsupported.');
    const choice = chunk.choices[0]; const delta = choice.delta ?? {};
    if (!object(delta)) throw upstreamError('The upstream stream contained an invalid delta.');
    visibleContent(delta);
    if (delta.content !== undefined && delta.content !== null) {
      if (typeof delta.content !== 'string') throw upstreamError('The upstream returned unsupported streaming content.');
      if (delta.content) {
        if (textIndex === undefined) { textIndex = nextIndex++; await emit('content_block_start', { type: 'content_block_start', index: textIndex, content_block: { type: 'text', text: '' } }); }
        await emit('content_block_delta', { type: 'content_block_delta', index: textIndex, delta: { type: 'text_delta', text: delta.content } });
      }
    }
    if (delta.tool_calls !== undefined) {
      if (!Array.isArray(delta.tool_calls)) throw upstreamError('The upstream stream contained invalid tool calls.');
      for (const call of delta.tool_calls) {
        if (!object(call) || !Number.isInteger(call.index) || call.index < 0 || call.index > 1024 || (call.type !== undefined && call.type !== 'function')) throw upstreamError('The upstream stream contained an invalid tool call.');
        let tool = tools.get(call.index);
        if (!tool) { tool = { index: -1, id: '', name: '', arguments: '', emitted: 0, started: false }; tools.set(call.index, tool); }
        if (call.id !== undefined) {
          if (typeof call.id !== 'string' || (tool.started && call.id !== tool.id)) throw upstreamError('The upstream changed a tool identity.');
          tool.id = call.id;
        }
        if (call.function !== undefined && !object(call.function)) throw upstreamError('The upstream returned an invalid function delta.');
        if (call.function?.name !== undefined) {
          if (typeof call.function.name !== 'string') throw upstreamError('The upstream returned an invalid tool name.');
          if (tool.started && call.function.name !== tool.name) throw upstreamError('The upstream changed a tool name.');
          tool.name = call.function.name;
        }
        if (call.function?.arguments !== undefined) {
          if (typeof call.function.arguments !== 'string') throw upstreamError('The upstream returned invalid tool argument fragments.');
          tool.arguments += call.function.arguments;
          if (tool.arguments.length > MAX_EVENT) throw upstreamError('The upstream tool arguments exceeded the size limit.');
        }
        if (!tool.started && tool.id && tool.name) {
          if ([...tools.values()].some((other) => other !== tool && other.started && other.id === tool!.id)) throw upstreamError('The upstream returned duplicate tool identities.');
          tool.index = nextIndex++; tool.started = true; await emit('content_block_start', { type: 'content_block_start', index: tool.index, content_block: { type: 'tool_use', id: tool.id, name: tool.name, input: {} } }); }
        if (tool.started && tool.emitted < tool.arguments.length) {
          await emit('content_block_delta', { type: 'content_block_delta', index: tool.index, delta: { type: 'input_json_delta', partial_json: tool.arguments.slice(tool.emitted) } });
          tool.emitted = tool.arguments.length;
        }
      }
    }
    if (choice.finish_reason !== null && choice.finish_reason !== undefined) reason = finish(choice.finish_reason);
  }
  if (!ended || !reason) throw upstreamError('The upstream stream ended before a complete response.');
  for (const tool of tools.values()) {
    let input: unknown;
    try { input = JSON.parse(tool.arguments); } catch { throw upstreamError('The upstream returned incomplete tool arguments.'); }
    if (!tool.started || !object(input)) throw upstreamError('The upstream returned an incomplete tool call.');
  }
  for (let index = 0; index < nextIndex; index++) await emit('content_block_stop', { type: 'content_block_stop', index });
  await emit('message_delta', { type: 'message_delta', delta: { stop_reason: reason, stop_sequence: null }, usage: reported ?? { output_tokens: 0 }, ...(reported?.input_tokens !== undefined && reported?.output_tokens !== undefined ? {} : { adapter_usage: reported ? 'partial' : 'unavailable' }) });
  await emit('message_stop', { type: 'message_stop' });
}
function errorBody(error: unknown): Json {
  const safe = error instanceof AdapterError ? error : upstreamError('The adapter could not complete this request.');
  return { type: 'error', error: { type: safe.kind, message: safe.message } };
}
function jsonResponse(response: ServerResponse, status: number, body: Json) {
  if (response.destroyed || response.writableEnded) return;
  response.writeHead(status, { 'content-type': 'application/json', 'cache-control': 'no-store' }); response.end(JSON.stringify(body));
}
async function readRequest(request: IncomingMessage): Promise<unknown> {
  const declared = Number(request.headers['content-length'] ?? 0);
  if (!Number.isFinite(declared) || declared > MAX_BODY) throw new AdapterError(413, 'Messages request exceeds the size limit.');
  const chunks: Buffer[] = []; let length = 0;
  for await (const chunk of request) {
    length += chunk.length;
    if (length > MAX_BODY) throw new AdapterError(413, 'Messages request exceeds the size limit.');
    chunks.push(Buffer.from(chunk));
  }
  try { return JSON.parse(Buffer.concat(chunks).toString('utf8')); } catch { invalid('Messages request is not valid JSON.'); }
}
async function readResponse(response: Response): Promise<unknown> {
  if (!response.body) throw upstreamError('The upstream response body is missing.');
  const reader = response.body.getReader(); const chunks: Uint8Array[] = []; let length = 0;
  try {
    while (true) {
      const { done, value } = await reader.read(); if (done) break;
      length += value.byteLength; if (length > MAX_RESPONSE) throw upstreamError('The upstream response exceeded the size limit.');
      chunks.push(value);
    }
    try { return JSON.parse(Buffer.concat(chunks).toString('utf8')); } catch { throw upstreamError('The upstream returned invalid JSON.'); }
  } finally { await reader.cancel().catch(() => {}); reader.releaseLock(); }
}
function equalToken(left: unknown, right: string): boolean {
  if (typeof left !== 'string') return false;
  const a = Buffer.from(left); const b = Buffer.from(right);
  return a.length === b.length && timingSafeEqual(a, b);
}
function authenticated(request: IncomingMessage, token: string): boolean {
  const authorization = request.headers.authorization;
  if (authorization !== undefined) return authorization.startsWith('Bearer ') && equalToken(authorization.slice(7), token);
  return equalToken(request.headers['x-api-key'], token);
}
async function configSnapshot(path: string): Promise<{ raw: Buffer; fingerprint: string }> {
  const stat = await lstat(path);
  if (!stat.isFile() || (stat.mode & 0o077) !== 0 || stat.size > 64 * 1024) throw new Error('Invalid configuration file.');
  const raw = await readFile(path);
  return { raw, fingerprint: createHash('sha256').update(raw).digest('hex') };
}
export async function startAdapter(options: { configPath: string; readyPath: string; fetcher?: Fetcher }) {
  const initial = await configSnapshot(options.configPath);
  const config = validateConfig(JSON.parse(initial.raw.toString('utf8')));
  if (Date.parse(config.expires_at) <= Date.now()) throw new Error('Course collection cutoff reached.');
  const fetcher = options.fetcher ?? fetch;
  const upstreamURL = `${config.upstream_base_url.replace(/\/+$/, '')}/chat/completions`;
  const pending = new Set<AbortController>(); let stopping = false; let poll: ReturnType<typeof setInterval> | undefined;
  let onClosed: () => void;
  const closed = new Promise<void>((resolve) => { onClosed = resolve; });
  // Resolve callbacks are invoked only after the server has been created below.
  async function removeReady() {
    try { const ready = JSON.parse(await readFile(options.readyPath, 'utf8')); if (ready.pid === process.pid) await unlink(options.readyPath); } catch {}
  }
  async function close() {
    if (stopping) return closed;
    stopping = true; if (poll) clearInterval(poll);
    for (const controller of pending) controller.abort();
    server.closeIdleConnections(); server.closeAllConnections();
    server.close(async () => { await removeReady(); onClosed(); });
    return closed;
  }
  async function validConfiguration(): Promise<boolean> {
    try { return !stopping && Date.parse(config.expires_at) > Date.now() && (await configSnapshot(options.configPath)).fingerprint === initial.fingerprint; } catch { return false; }
  }
  const server = createServer(async (request, response) => {
    let controller: AbortController | undefined; let timeout: ReturnType<typeof setTimeout> | undefined;
    try {
      if (!(await validConfiguration())) { jsonResponse(response, 401, errorBody(new AdapterError(401, 'Course authorization is no longer active.', 'authentication_error'))); void close(); return; }
      const path = new URL(request.url ?? '/', 'http://127.0.0.1').pathname;
      if (!authenticated(request, config.local_token)) { jsonResponse(response, 401, errorBody(new AdapterError(401, 'Local adapter authentication required.', 'authentication_error'))); return; }
      if (request.method === 'GET' && path === '/healthz') { jsonResponse(response, 200, { status: 'ok' }); return; }
      if (request.method === 'POST' && path === '/shutdown') { jsonResponse(response, 200, { stopped: true }); setImmediate(() => { void close(); }); return; }
      if (request.method !== 'POST' || path !== '/v1/messages') { jsonResponse(response, 404, errorBody(new AdapterError(404, 'This adapter supports Messages only; token counting is unavailable.'))); return; }
      if (pending.size >= MAX_CONCURRENT) { jsonResponse(response, 429, errorBody(new AdapterError(429, 'Too many concurrent local requests.', 'rate_limit_error'))); return; }
      controller = new AbortController(); pending.add(controller);
      request.once('aborted', () => controller?.abort());
      response.once('close', () => { if (!response.writableEnded) controller?.abort(); });
      timeout = setTimeout(() => controller?.abort(), REQUEST_TIMEOUT); timeout.unref();
      const translated = translateRequest(await readRequest(request), config);
      if (!(await validConfiguration())) throw new AdapterError(401, 'Course authorization is no longer active.', 'authentication_error');
      const upstream = await fetcher(upstreamURL, { method: 'POST', headers: { 'content-type': 'application/json', 'authorization': `Bearer ${config.api_key}`, 'x-api-key': config.eip_api_key, 'x-system-name': config.eip_system_name }, body: JSON.stringify(translated), signal: controller.signal, redirect: 'error' });
      if (!upstream.ok) {
        await upstream.body?.cancel();
        // Preserve definitive client/auth failures so Claude does not repeatedly
        // retry a denied request as though the provider had a transient 502.
        const status = upstream.status >= 400 && upstream.status < 500 ? upstream.status : 502;
        const kind = status === 401 ? 'authentication_error' : status === 403 ? 'permission_error' : status === 404 ? 'not_found_error' : status === 429 ? 'rate_limit_error' : status < 500 ? 'invalid_request_error' : 'api_error';
        throw new AdapterError(status, `The upstream provider rejected the request (HTTP ${upstream.status}).`, kind);
      }
      if (translated.stream) {
        if (!upstream.body || !upstream.headers.get('content-type')?.includes('text/event-stream')) throw upstreamError('The upstream did not return an event stream.');
        response.writeHead(200, { 'content-type': 'text/event-stream', 'cache-control': 'no-store', 'connection': 'keep-alive', 'x-accel-buffering': 'no' });
        const emit: EventSink = async (name, value) => {
          if (response.destroyed || controller!.signal.aborted) throw upstreamError('The request was interrupted.');
          if (!response.write(`event: ${name}\ndata: ${JSON.stringify(value)}\n\n`)) await once(response, 'drain', { signal: controller!.signal });
        };
        await translateStream(upstream.body, configModel(translated), emit, controller.signal);
        response.end();
      } else jsonResponse(response, 200, translateResponse(await readResponse(upstream), configModel(translated)));
    } catch (error) {
      controller?.abort();
      if (!response.destroyed && !response.writableEnded) {
        if (response.headersSent) response.end(`event: error\ndata: ${JSON.stringify(errorBody(error))}\n\n`);
        else jsonResponse(response, error instanceof AdapterError ? error.status : 502, errorBody(error));
      }
    } finally { if (timeout) clearTimeout(timeout); if (controller) pending.delete(controller); }
  });
  server.requestTimeout = 30_000; server.headersTimeout = 10_000; server.keepAliveTimeout = 5_000;
  await new Promise<void>((resolve, reject) => { server.once('error', reject); server.listen(config.port, '127.0.0.1', () => { server.removeListener('error', reject); resolve(); }); });
  const address = server.address();
  if (!address || typeof address === 'string') { await close(); throw new Error('Adapter failed to bind.'); }
  const url = `http://127.0.0.1:${address.port}`;
  const temporary = `${options.readyPath}.${process.pid}.${randomBytes(8).toString('hex')}.tmp`;
  try { await writeFile(temporary, JSON.stringify({ url, pid: process.pid }), { mode: 0o600, flag: 'wx' }); await rename(temporary, options.readyPath); }
  catch (error) { await unlink(temporary).catch(() => {}); await close(); throw error; }
  poll = setInterval(() => { void validConfiguration().then((valid) => { if (!valid) void close(); }); }, 1000); poll.unref();
  return { url, close, closed };
}
function configModel(request: Json): string { return request.model; }
async function main() {
  const args = process.argv.slice(2); const configIndex = args.indexOf('--config'); const readyIndex = args.indexOf('--ready-file');
  if (configIndex < 0 || readyIndex < 0 || !args[configIndex + 1] || !args[readyIndex + 1]) throw new Error('Adapter configuration paths are required.');
  const adapter = await startAdapter({ configPath: args[configIndex + 1], readyPath: args[readyIndex + 1] });
  process.once('SIGTERM', () => { void adapter.close(); }); process.once('SIGINT', () => { void adapter.close(); });
  await adapter.closed;
}
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main().catch(() => { process.stderr.write('Course adapter could not start. Check course login and local configuration.\n'); process.exitCode = 1; });
}
