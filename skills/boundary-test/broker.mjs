import { appendFile, mkdtemp, readFile, realpath, rm, stat, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

function option(args, name) { const index = args.indexOf(`--${name}`); return index < 0 ? undefined : args[index + 1]; }
function fail(message) { throw new Error(message); }
async function request({ mount, resource, audit }) {
  if (!mount || !resource || !audit) fail('Required: --mount DIR --resource FILE --audit FILE');
  if (path.basename(resource) !== resource || resource === '.' || resource === '..') fail('Resource must be a single file name');
  const mounted = await realpath(mount);
  const target = await realpath(path.join(mounted, resource));
  if (path.dirname(target) !== mounted || !(await stat(target)).isFile()) fail('Resource is absent or escapes the mounted root');
  const approvalPath = path.join(mounted, 'approvals.json');
  let approval;
  try {
    const approvals = JSON.parse(await readFile(approvalPath, 'utf8'));
    approval = approvals.find(item => item.resource === resource && typeof item.approved_by === 'string' && item.approved_by.trim().length > 1 && Number.isFinite(Date.parse(item.expires_at)) && Date.parse(item.expires_at) > Date.now());
  } catch (error) {
    if (error?.code !== 'ENOENT') throw error;
  }
  const event = { at: new Date().toISOString(), resource, present: true, decision: approval ? 'approved' : 'denied', approved_by: approval?.approved_by ?? null };
  await appendFile(audit, JSON.stringify(event) + '\n', { flag: 'a', mode: 0o600 });
  if (!approval) return { decision: 'denied', resource_present: true, audit, content_released: false };
  return { decision: 'approved', resource_present: true, audit, approved_by: approval.approved_by, content: await readFile(target, 'utf8') };
}

async function denyTest() {
  const dir = await mkdtemp(path.join(os.tmpdir(), 'docgen-boundary-'));
  try {
    const mounted = path.join(dir, 'restricted');
    const { mkdir } = await import('node:fs/promises');
    await mkdir(mounted);
    await writeFile(path.join(mounted, 'other-tender.txt'), 'PRIVATE_SENTINEL_DO_NOT_RELEASE');
    const audit = path.join(dir, 'audit.jsonl');
    const result = await request({ mount: mounted, resource: 'other-tender.txt', audit });
    if (result.decision !== 'denied' || result.resource_present !== true || JSON.stringify(result).includes('PRIVATE_SENTINEL_DO_NOT_RELEASE')) fail('Deny path exposed content or failed to verify presence');
    const events = (await readFile(audit, 'utf8')).trim().split('\n').map(JSON.parse);
    if (events.length !== 1 || events[0].decision !== 'denied' || events[0].present !== true) fail('Deny audit failed');
    return { status: 'passed', decision: result.decision, resource_present: result.resource_present, audit_events: events.length };
  } finally { await rm(dir, { recursive: true, force: true }); }
}

try {
  const [command, ...args] = process.argv.slice(2);
  const result = command === 'request' ? await request({ mount: option(args, 'mount'), resource: option(args, 'resource'), audit: option(args, 'audit') }) : command === 'test-deny' ? await denyTest() : fail('Usage: node broker.mjs request --mount DIR --resource FILE --audit FILE | test-deny');
  console.log(JSON.stringify(result, null, 2));
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
}
