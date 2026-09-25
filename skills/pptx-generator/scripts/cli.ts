import { Automizer, modify } from 'pptx-automizer';
import { Ajv2020 } from 'ajv/dist/2020.js';
import JSZip from 'jszip';
import { DOMParser } from '@xmldom/xmldom';
import { createHash } from 'node:crypto';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { existsSync } from 'node:fs';
import { mkdir, mkdtemp, readFile, realpath, rm } from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';

const execFileAsync = promisify(execFile);
const slideNumber = { decision_summary: 1, gate_focus: 2, comparison_focus: 3 } as const;
type Archetype = keyof typeof slideNumber;
type Gate = { vendor: string; status: 'PASS' | 'FAIL' | 'UNVERIFIED'; reason: string };
type Comparison = { vendor: string; score: number; label: string };
type Source = { documentId: string; locator: string };
type Plan = { schemaVersion: 1; archetype: Archetype; audience: string; title: string; recommendation: string; decision: string; gates: Gate[]; comparison: Comparison[]; sources: Source[] };
type Element = { name: string; id: string; creationId: string; type: string; visualType: string; position: { x: number; y: number; cx: number; cy: number }; hasTextBody: boolean; getText: () => string[]; getXmlElement: () => { getElementsByTagName: (tag: string) => { length: number } } };
type Slide = { number: number; id?: number; elements: Element[]; info: unknown };

const packageDir = path.resolve(import.meta.dirname, '..');
const schema = JSON.parse(await readFile(path.join(packageDir, 'slide-plan.schema.json'), 'utf8'));
const ajv = new Ajv2020({ allErrors: true, strict: true, multipleOfPrecision: 8 });
const validateSchema = ajv.compile(schema);
const required = [
  'AUDIENCE', 'TITLE', 'RECOMMENDATION', 'GATE_TABLE', 'COMPARISON_CHART', 'DECISION', 'SOURCE_NOTES',
  ...[1, 2, 3, 4, 5].flatMap(i => [`GATE_VENDOR_${i}`, `GATE_STATUS_${i}`, `GATE_REASON_${i}`]),
  ...[1, 2, 3].flatMap(i => [`SCORE_VENDOR_${i}`, `SCORE_BAR_${i}`, `SCORE_VALUE_${i}`, `SCORE_LABEL_${i}`, `SCORE_TRACK_${i}`]),
];
const mutable = new Set(required.filter(x => !['GATE_TABLE', 'COMPARISON_CHART'].includes(x) && !x.startsWith('SCORE_TRACK_')));
const licenseLine = 'Fictional training case; not A*STAR policy or Singapore procurement law.';

function option(args: string[], name: string, requiredOption = true): string | undefined {
  const index = args.indexOf(`--${name}`);
  if (index < 0) {
    if (requiredOption) throw new Error(`Missing --${name}`);
    return undefined;
  }
  if (!args[index + 1] || args[index + 1].startsWith('--')) throw new Error(`Missing value for --${name}`);
  return args[index + 1];
}

function fail(message: string): never { throw new Error(message); }
function sha256(bytes: Buffer): string { return createHash('sha256').update(bytes).digest('hex'); }
function normalized(s: string): string { return s.replace(/\s+/g, ' ').trim(); }

function parsePlan(raw: unknown): Plan {
  if (!validateSchema(raw)) fail(`Invalid slide plan: ${ajv.errorsText(validateSchema.errors, { separator: '; ' })}`);
  const checkText = (value: unknown): void => {
    if (typeof value === 'string' && /<\??\/?(?:p|a|r|mc|c|dgm):|<\?xml|<!DOCTYPE/i.test(value)) fail('Raw OOXML is not allowed in a slide plan');
    if (Array.isArray(value)) value.forEach(checkText);
    else if (value && typeof value === 'object') Object.values(value).forEach(checkText);
  };
  checkText(raw);
  const plan = raw as Plan;
  const keys = plan.gates.map(g => g.vendor.toLowerCase());
  if (new Set(keys).size !== keys.length) fail('Duplicate gate vendor');
  const comparisons = plan.comparison.map(c => c.vendor.toLowerCase());
  if (new Set(comparisons).size !== comparisons.length) fail('Duplicate comparison vendor');
  for (const vendor of comparisons) {
    const gate = plan.gates.find(g => g.vendor.toLowerCase() === vendor);
    if (!gate || gate.status !== 'PASS') fail(`Scored vendor ${vendor} must pass the mandatory gate`);
  }
  if (plan.comparison.some((c, i) => i > 0 && c.score > plan.comparison[i - 1].score)) fail('Comparison must be sorted by score descending');
  if (plan.sources.map(s => `${s.documentId}:${s.locator}`).join('; ').length > 170) fail('Source notes exceed the template text box; shorten locators without losing precision');
  return plan;
}

async function loadPlan(file: string): Promise<Plan> { return parsePlan(JSON.parse(await readFile(file, 'utf8'))); }

async function inspect(template: string) {
  const full = path.resolve(template);
  if (!existsSync(full)) fail(`Template not found: ${full}`);
  const automizer = new Automizer({ templateDir: path.dirname(full), outputDir: path.dirname(full), removeExistingSlides: true, verbosity: 0 });
  const pres = automizer.loadRoot(path.basename(full)).load(path.basename(full), 'corporate');
  const info = await pres.getInfo();
  const slides = info.slidesByTemplate('corporate') as Slide[];
  const zip = await JSZip.loadAsync(await readFile(full));
  const presentation = await zip.file('ppt/presentation.xml')?.async('string');
  if (!presentation) fail('Template has no ppt/presentation.xml');
  const doc = new DOMParser().parseFromString(presentation, 'application/xml');
  const size = doc.getElementsByTagName('p:sldSz')[0];
  if (!size) fail('Template has no slide dimensions');
  const width = Number(size.getAttribute('cx'));
  const height = Number(size.getAttribute('cy'));
  const data = {
    template: full,
    sha256: sha256(await readFile(full)),
    dimensions: { widthEmu: width, heightEmu: height, widthInches: width / 914400, heightInches: height / 914400 },
    masters: Object.keys(zip.files).filter(n => /^ppt\/slideMasters\/slideMaster\d+\.xml$/.test(n)),
    layouts: Object.keys(zip.files).filter(n => /^ppt\/slideLayouts\/slideLayout\d+\.xml$/.test(n)),
    themeParts: Object.keys(zip.files).filter(n => /^ppt\/theme\/theme\d+\.xml$/.test(n)),
    slides: slides.map((slide, index) => ({
      number: slide.number,
      archetype: (Object.keys(slideNumber) as Archetype[])[index] ?? null,
      creationId: slide.id ?? null,
      missingRequired: required.filter(name => !slide.elements.some(el => el.name === name)),
      unsupportedElements: slide.elements.filter(el => !['sp', 'pic'].includes(el.type) || ['chart', 'smartArt', 'diagram', '3dModel'].includes(el.visualType)).map(el => ({ name: el.name, type: el.type, visualType: el.visualType })),
      unsupportedLinks: slide.elements.filter(el => ['a:hlinkClick', 'a:hlinkHover', 'p:oleObj'].some(tag => el.getXmlElement().getElementsByTagName(tag).length > 0)).map(el => el.name),
      elements: slide.elements.map(el => ({
        name: el.name, creationId: el.creationId || null, type: el.type, visualType: el.visualType,
        boundsEmu: el.position, editable: mutable.has(el.name) && (el.hasTextBody || el.name.startsWith('SCORE_BAR_')),
        permittedProperty: el.name.startsWith('SCORE_BAR_') ? ['width'] : mutable.has(el.name) ? ['text'] : [],
      })),
    })),
  };
  if (slides.length !== 3) fail(`Expected 3 template archetype slides; found ${slides.length}`);
  return data;
}

function nameMap(elements: { name: string; boundsEmu: { cx: number } }[]) { return new Map(elements.map(e => [e.name, e])); }

function sourceText(sources: Source[]) {
  return `Sources: ${sources.map(s => `${s.documentId} ${s.locator}`).join('; ')}. ${licenseLine}`;
}

function planText(plan: Plan): Record<string, string> {
  const fields: Record<string, string> = {
    AUDIENCE: plan.audience,
    TITLE: plan.title,
    RECOMMENDATION: plan.recommendation,
    DECISION: plan.decision,
    SOURCE_NOTES: sourceText(plan.sources),
  };
  for (let i = 1; i <= 5; i++) {
    const item = plan.gates[i - 1];
    fields[`GATE_VENDOR_${i}`] = item?.vendor ?? '';
    fields[`GATE_STATUS_${i}`] = item?.status ?? '';
    fields[`GATE_REASON_${i}`] = item?.reason ?? '';
  }
  for (let i = 1; i <= 3; i++) {
    const item = plan.comparison[i - 1];
    fields[`SCORE_VENDOR_${i}`] = item?.vendor ?? '';
    fields[`SCORE_VALUE_${i}`] = item ? item.score.toFixed(1) : '';
    fields[`SCORE_LABEL_${i}`] = item?.label ?? '';
  }
  return fields;
}

async function build(template: string, planFile: string, output: string) {
  const plan = await loadPlan(planFile);
  const fullTemplate = path.resolve(template), fullOutput = path.resolve(output);
  const templateReal = await realpath(fullTemplate);
  const outputReal = existsSync(fullOutput) ? await realpath(fullOutput) : fullOutput;
  if (templateReal === outputReal) fail('Output path must differ from template path');
  const templateInfo = await inspect(fullTemplate);
  const source = templateInfo.slides[slideNumber[plan.archetype] - 1];
  if (source.missingRequired.length) fail(`Template archetype is missing elements: ${source.missingRequired.join(', ')}`);
  if (source.unsupportedElements.length || source.unsupportedLinks.length) fail(`Template archetype contains unsupported content: ${JSON.stringify({ elements: source.unsupportedElements, links: source.unsupportedLinks })}`);
  const elements = nameMap(source.elements);
  const automizer = new Automizer({ templateDir: path.dirname(fullTemplate), outputDir: path.dirname(fullOutput), removeExistingSlides: true, verbosity: 0 });
  const pres = automizer.loadRoot(path.basename(fullTemplate)).load(path.basename(fullTemplate), 'corporate');
  pres.addSlide('corporate', slideNumber[plan.archetype], async slide => {
    const actual = await slide.getAllElements();
    const actualNames = new Set(actual.map(e => e.name));
    for (const name of required) if (!actualNames.has(name)) fail(`Source slide lost required element ${name}`);
    for (const [name, value] of Object.entries(planText(plan))) slide.modifyElement(name, [modify.setText(value)]);
    for (let i = 1; i <= 3; i++) {
      const bar = elements.get(`SCORE_BAR_${i}`), track = elements.get(`SCORE_TRACK_${i}`);
      if (!bar || !track) fail(`Missing score bar/track ${i}`);
      const item = plan.comparison[i - 1];
      if (item) slide.modifyElement(`SCORE_BAR_${i}`, [modify.setPosition({ w: Math.max(1, Math.round(track.boundsEmu.cx * item.score / 100)) })]);
      else {
        slide.modifyElement(`SCORE_BAR_${i}`, [modify.setPosition({ x: 0, y: 0, w: 1, h: 1 })]);
        slide.modifyElement(`SCORE_TRACK_${i}`, [modify.setPosition({ x: 0, y: 0, w: 1, h: 1 })]);
      }
    }
  });
  await mkdir(path.dirname(fullOutput), { recursive: true });
  await pres.write(path.basename(fullOutput));
  if (sha256(await readFile(fullTemplate)) !== templateInfo.sha256) fail('Template changed during build');
  return { output: fullOutput, templateSha256: templateInfo.sha256, outputSha256: sha256(await readFile(fullOutput)) };
}

function xml(zip: JSZip, name: string): Promise<string> {
  const file = zip.file(name);
  if (!file) fail(`Missing package part: ${name}`);
  return file.async('string');
}

function parseXml(source: string, label: string) {
  const errors: string[] = [];
  const doc = new DOMParser({ errorHandler: (level, message) => { if (level !== 'warning') errors.push(message); } }).parseFromString(source, 'application/xml');
  if (errors.length || doc.getElementsByTagName('parsererror').length) fail(`Malformed XML in ${label}: ${errors.join('; ')}`);
  return doc;
}

async function packageSlide(zip: JSZip) {
  const pres = parseXml(await xml(zip, 'ppt/presentation.xml'), 'ppt/presentation.xml');
  const slideRefs = pres.getElementsByTagName('p:sldId');
  if (slideRefs.length !== 1) fail(`Expected exactly one output slide, found ${slideRefs.length}`);
  const relId = slideRefs[0].getAttribute('r:id');
  const rels = parseXml(await xml(zip, 'ppt/_rels/presentation.xml.rels'), 'ppt/_rels/presentation.xml.rels');
  const relation = Array.from(rels.getElementsByTagName('Relationship')).find(n => n.getAttribute('Id') === relId);
  if (!relation) fail('Visible slide relationship missing');
  const slideName = path.posix.normalize(path.posix.join('ppt', relation.getAttribute('Target') ?? ''));
  if (!/^ppt\/slides\/slide\d+\.xml$/.test(slideName)) fail(`Unexpected visible slide target ${slideName}`);
  const doc = parseXml(await xml(zip, slideName), slideName);
  const elements = [...Array.from(doc.getElementsByTagName('p:sp')), ...Array.from(doc.getElementsByTagName('p:pic')), ...Array.from(doc.getElementsByTagName('p:graphicFrame'))];
  const data = elements.map(el => {
    const nv = el.getElementsByTagName('p:cNvPr')[0];
    const xfrm = el.getElementsByTagName('a:xfrm')[0];
    const ext = xfrm?.getElementsByTagName('a:ext')[0];
    const off = xfrm?.getElementsByTagName('a:off')[0];
    return {
      name: nv?.getAttribute('name') ?? '',
      text: normalized(Array.from(el.getElementsByTagName('a:t')).map(n => n.textContent ?? '').join('')),
      x: Number(off?.getAttribute('x') ?? 0), y: Number(off?.getAttribute('y') ?? 0),
      width: Number(ext?.getAttribute('cx') ?? 0), height: Number(ext?.getAttribute('cy') ?? 0),
    };
  });
  return { elements: data, zip, presentation: pres };
}

async function render(pptxFile: string, requireRender: boolean) {
  const candidates = ['libreoffice', 'soffice'];
  let cmd: string | null = null;
  for (const candidate of candidates) {
    try { await execFileAsync('which', [candidate]); cmd = candidate; break; } catch { /* try next */ }
  }
  if (!cmd) {
    if (requireRender) fail('LibreOffice is required for --require-render');
    return { status: 'skipped', reason: 'LibreOffice executable unavailable' };
  }
  const dir = await mkdtemp(path.join(os.tmpdir(), 'pptx-validation-'));
  try {
    await execFileAsync(cmd, ['-env:UserInstallation=file://' + path.join(dir, 'profile'), '--headless', '--convert-to', 'pdf', '--outdir', dir, pptxFile], { timeout: 60000 });
    const pdf = path.join(dir, path.basename(pptxFile, '.pptx') + '.pdf');
    const bytes = await readFile(pdf);
    if (!bytes.subarray(0, 5).equals(Buffer.from('%PDF-'))) fail('LibreOffice did not produce a valid PDF');
    return { status: 'passed', bytes: bytes.length };
  } finally { await rm(dir, { recursive: true, force: true }); }
}

async function validate(template: string, planFile: string, output: string, requireRender: boolean) {
  const plan = await loadPlan(planFile);
  const templateInfo = await inspect(template);
  const source = templateInfo.slides[slideNumber[plan.archetype] - 1];
  const outputBytes = await readFile(output);
  const archive = await JSZip.loadAsync(outputBytes, { checkCRC32: true });
  const sourceArchive = await JSZip.loadAsync(await readFile(template));
  const generated = await packageSlide(archive);
  const names = generated.elements.map(e => e.name);
  const duplicates = names.filter((name, index) => names.indexOf(name) !== index);
  if (duplicates.length) fail(`Duplicate output element names: ${duplicates.join(', ')}`);
  const sourceNames = new Set(source.elements.map(e => e.name));
  const extra = names.filter(n => !sourceNames.has(n));
  const missing = source.elements.map(e => e.name).filter(n => !names.includes(n));
  if (extra.length || missing.length) fail(`Output shape inventory differs: extra [${extra.join(', ')}], missing [${missing.join(', ')}]`);
  for (const name of required) if (!names.includes(name)) fail(`Required output element missing: ${name}`);
  const byName = new Map(generated.elements.map(e => [e.name, e]));
  const expected = planText(plan);
  for (const [name, value] of Object.entries(expected)) {
    if (byName.get(name)?.text !== normalized(value)) fail(`Text mismatch in ${name}`);
  }
  if (!byName.get('SOURCE_NOTES')?.text.includes(licenseLine)) fail('Training disclaimer missing from source notes');
  const fontSize = (name: string): number => name === 'TITLE' ? 27 : name === 'RECOMMENDATION' ? 17 : name === 'DECISION' ? 15 : name === 'SOURCE_NOTES' ? 9 : name.startsWith('GATE_STATUS_') ? 8.5 : name.startsWith('GATE_REASON_') ? 10 : name.startsWith('SCORE_LABEL_') ? 9 : 11;
  for (const [name, value] of Object.entries(expected)) {
    const item = byName.get(name);
    if (!item || !value) continue;
    const lines = name === 'SOURCE_NOTES' ? 2 : 1;
    const capacity = Math.floor(item.width / 914400 * 72 / (fontSize(name) * 0.6)) * lines;
    if (value.length > capacity) fail(`${name} likely overflows its Liberation Sans text box (${value.length} chars; heuristic capacity ${capacity}); shorten it or choose another archetype`);
  }
  for (let i = 1; i <= 3; i++) {
    const score = plan.comparison[i - 1]?.score ?? 0;
    const trackWidth = byName.get(`SCORE_TRACK_${i}`)?.width ?? 0;
    const barWidth = byName.get(`SCORE_BAR_${i}`)?.width ?? 0;
    if (Math.abs(barWidth - Math.max(1, Math.round(trackWidth * score / 100))) > 2) fail(`Score bar ${i} does not match ${score}`);
  }
  const outputPresentation = await xml(archive, 'ppt/presentation.xml');
  const templatePresentation = await xml(sourceArchive, 'ppt/presentation.xml');
  const outSize = parseXml(outputPresentation, 'output presentation').getElementsByTagName('p:sldSz')[0];
  const inSize = parseXml(templatePresentation, 'template presentation').getElementsByTagName('p:sldSz')[0];
  if (outSize?.getAttribute('cx') !== inSize?.getAttribute('cx') || outSize?.getAttribute('cy') !== inSize?.getAttribute('cy')) fail('Slide size changed');
  const slideWidth = Number(outSize?.getAttribute('cx') ?? 0), slideHeight = Number(outSize?.getAttribute('cy') ?? 0);
  for (const item of generated.elements) if (item.x < 0 || item.y < 0 || item.width < 0 || item.height < 0 || item.x + item.width > slideWidth + 1000 || item.y + item.height > slideHeight + 1000) fail(`Element outside slide bounds: ${item.name}`);
  const outThemes = Object.keys(archive.files).filter(n => /^ppt\/theme\/theme\d+\.xml$/.test(n));
  if (outThemes.length < 1) fail('Output theme missing');
  if (!(await xml(archive, outThemes[0])).includes('Liberation Sans')) fail('Output theme does not use the required Liberation Sans font');
  if (!Object.keys(archive.files).some(n => /^ppt\/slideMasters\/slideMaster\d+\.xml$/.test(n))) fail('Output master missing');
  for (const name of Object.keys(archive.files).filter(n => /\.(xml|rels)$/.test(n))) parseXml(await xml(archive, name), name);
  if (!archive.file('[Content_Types].xml')) fail('Content type registry missing');
  const rendered = await render(path.resolve(output), requireRender);
  return { status: 'passed', output: path.resolve(output), outputSha256: sha256(outputBytes), slideCount: 1, elements: generated.elements.length, sources: plan.sources.length, render: rendered };
}

const [command, ...args] = process.argv.slice(2);
try {
  let result: unknown;
  if (command === 'inspect') result = await inspect(option(args, 'template')!);
  else if (command === 'build') result = await build(option(args, 'template')!, option(args, 'plan')!, option(args, 'output')!);
  else if (command === 'validate') result = await validate(option(args, 'template')!, option(args, 'plan')!, option(args, 'output')!, args.includes('--require-render'));
  else fail('Usage: inspect --template FILE | build --template FILE --plan FILE --output FILE | validate --template FILE --plan FILE --output FILE [--require-render]');
  console.log(JSON.stringify(result, null, 2));
} catch (error) {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
}
