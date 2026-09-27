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

// Physical order of archetype source slides in corporate-template.pptx. Must match
// scripts/make-template.ts's TEMPLATE_ARCHETYPES constant exactly: inspect()/build()
// identify a source slide by its position in the template file, not by name.
const TEMPLATE_ARCHETYPES = ['decision_summary', 'gate_focus', 'context', 'cover'] as const;
type Archetype = (typeof TEMPLATE_ARCHETYPES)[number];
const slideNumber = Object.fromEntries(TEMPLATE_ARCHETYPES.map((a, i) => [a, i + 1])) as Record<Archetype, number>;

type Gate = { vendor: string; status: 'PASS' | 'FAIL' | 'UNVERIFIED'; reason: string };
type Comparison = { vendor: string; score: number; label: string };
type Criterion = { name: string; weight: number };
type Source = { documentId: string; locator: string };
type GateComparisonSlide = { archetype: 'decision_summary' | 'gate_focus'; title: string; recommendation: string; decision: string; gates: Gate[]; comparison: Comparison[] };
type ContextSlide = { archetype: 'context'; title: string; problem: string; mandatoryGates: string[]; criteria: Criterion[] };
type CoverSlide = { archetype: 'cover'; title: string; subtitle: string };
type PlanSlide = GateComparisonSlide | ContextSlide | CoverSlide;
type Plan = { schemaVersion: 1; audience: string; sources: Source[]; slides: PlanSlide[] };

type Element = { name: string; id: string; creationId: string; type: string; visualType: string; position: { x: number; y: number; cx: number; cy: number }; hasTextBody: boolean; getText: () => string[]; getXmlElement: () => { getElementsByTagName: (tag: string) => { length: number } } };
type TemplateSlide = { number: number; id?: number; elements: Element[]; info: unknown };

const packageDir = path.resolve(import.meta.dirname, '..');
const schema = JSON.parse(await readFile(path.join(packageDir, 'slide-plan.schema.json'), 'utf8'));
const ajv = new Ajv2020({ allErrors: true, strict: true, multipleOfPrecision: 8 });
const validateSchema = ajv.compile(schema);
const licenseLine = 'Fictional training case; not organisational policy or Singapore procurement law.';

// Every slide carries these three fields regardless of archetype (deck-level audience
// and sources land on each slide's own AUDIENCE / SOURCE_NOTES shapes).
const SHARED = ['TITLE', 'AUDIENCE', 'SOURCE_NOTES'];
// GATE_TABLE / COMPARISON_CHART / GATES_HEADER / CRITERIA_HEADER are fixed section
// headers baked into the template; their presence is required but their text is not
// plan-controlled, unlike every other required shape.
const GATE_COMPARISON_STATIC = ['GATE_TABLE', 'COMPARISON_CHART'];
const CONTEXT_STATIC = ['GATES_HEADER', 'CRITERIA_HEADER'];
const GATE_COMPARISON_REQUIRED = [
  ...SHARED, 'RECOMMENDATION', 'DECISION', ...GATE_COMPARISON_STATIC,
  ...[1, 2, 3, 4, 5].flatMap(i => [`GATE_VENDOR_${i}`, `GATE_STATUS_${i}`, `GATE_REASON_${i}`]),
  ...[1, 2, 3].flatMap(i => [`SCORE_VENDOR_${i}`, `SCORE_BAR_${i}`, `SCORE_VALUE_${i}`, `SCORE_LABEL_${i}`, `SCORE_TRACK_${i}`]),
];
const CONTEXT_REQUIRED = [
  ...SHARED, 'PROBLEM', ...CONTEXT_STATIC,
  ...[1, 2, 3, 4, 5, 6, 7].map(i => `GATE_LINE_${i}`),
  ...[1, 2, 3, 4].flatMap(i => [`CRITERION_NAME_${i}`, `CRITERION_WEIGHT_${i}`]),
];
const COVER_REQUIRED = [...SHARED, 'SUBTITLE'];

function requiredFor(archetype: Archetype): string[] {
  return archetype === 'context' ? CONTEXT_REQUIRED : archetype === 'cover' ? COVER_REQUIRED : GATE_COMPARISON_REQUIRED;
}
function staticFor(archetype: Archetype): string[] {
  return archetype === 'context' ? CONTEXT_STATIC : archetype === 'cover' ? [] : GATE_COMPARISON_STATIC;
}

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
  if (plan.sources.map(s => `${s.documentId}:${s.locator}`).join('; ').length > 170) fail('Source notes exceed the template text box; shorten locators without losing precision');
  for (const [index, slide] of plan.slides.entries()) {
    if (slide.archetype !== 'decision_summary' && slide.archetype !== 'gate_focus') continue;
    const label = `slide ${index + 1} (${slide.archetype})`;
    const vendorKeys = slide.gates.map(g => g.vendor.toLowerCase());
    if (new Set(vendorKeys).size !== vendorKeys.length) fail(`Duplicate gate vendor on ${label}`);
    const comparisonKeys = slide.comparison.map(c => c.vendor.toLowerCase());
    if (new Set(comparisonKeys).size !== comparisonKeys.length) fail(`Duplicate comparison vendor on ${label}`);
    for (const vendor of comparisonKeys) {
      const gate = slide.gates.find(g => g.vendor.toLowerCase() === vendor);
      if (!gate || gate.status !== 'PASS') fail(`Scored vendor ${vendor} must pass the mandatory gate on the same slide (${label})`);
    }
    if (slide.comparison.some((c, i) => i > 0 && c.score > slide.comparison[i - 1].score)) fail(`Comparison must be sorted by score descending on ${label}`);
  }
  return plan;
}

async function loadPlan(file: string): Promise<Plan> { return parsePlan(JSON.parse(await readFile(file, 'utf8'))); }

async function inspect(template: string) {
  const full = path.resolve(template);
  if (!existsSync(full)) fail(`Template not found: ${full}`);
  const automizer = new Automizer({ templateDir: path.dirname(full), outputDir: path.dirname(full), removeExistingSlides: true, verbosity: 0 });
  const pres = automizer.loadRoot(path.basename(full)).load(path.basename(full), 'corporate');
  const info = await pres.getInfo();
  const slides = info.slidesByTemplate('corporate') as TemplateSlide[];
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
    slides: slides.map((slide, index) => {
      const archetype = TEMPLATE_ARCHETYPES[index] ?? null;
      const required = archetype ? requiredFor(archetype) : [];
      const staticNames = new Set(archetype ? staticFor(archetype) : []);
      const mutable = new Set(required.filter(x => !staticNames.has(x) && !x.startsWith('SCORE_TRACK_')));
      return {
        number: slide.number,
        archetype,
        creationId: slide.id ?? null,
        missingRequired: required.filter(name => !slide.elements.some(el => el.name === name)),
        unsupportedElements: slide.elements.filter(el => !['sp', 'pic'].includes(el.type) || ['chart', 'smartArt', 'diagram', '3dModel'].includes(el.visualType)).map(el => ({ name: el.name, type: el.type, visualType: el.visualType })),
        unsupportedLinks: slide.elements.filter(el => ['a:hlinkClick', 'a:hlinkHover', 'p:oleObj'].some(tag => el.getXmlElement().getElementsByTagName(tag).length > 0)).map(el => el.name),
        elements: slide.elements.map(el => ({
          name: el.name, creationId: el.creationId || null, type: el.type, visualType: el.visualType,
          boundsEmu: el.position, editable: mutable.has(el.name) && (el.hasTextBody || el.name.startsWith('SCORE_BAR_')),
          permittedProperty: el.name.startsWith('SCORE_BAR_') ? ['width'] : mutable.has(el.name) ? ['text'] : [],
        })),
      };
    }),
  };
  if (slides.length !== TEMPLATE_ARCHETYPES.length) fail(`Expected ${TEMPLATE_ARCHETYPES.length} template archetype slides; found ${slides.length}`);
  return data;
}

function nameMap(elements: { name: string; boundsEmu: { cx: number } }[]) { return new Map(elements.map(e => [e.name, e])); }

function sourceText(sources: Source[]) {
  return `Sources: ${sources.map(s => `${s.documentId} ${s.locator}`).join('; ')}. ${licenseLine}`;
}

function planTextFor(plan: Plan, slide: PlanSlide): Record<string, string> {
  const fields: Record<string, string> = { TITLE: slide.title, AUDIENCE: plan.audience, SOURCE_NOTES: sourceText(plan.sources) };
  if (slide.archetype === 'context') {
    fields.PROBLEM = slide.problem;
    for (let i = 1; i <= 7; i++) fields[`GATE_LINE_${i}`] = slide.mandatoryGates[i - 1] ?? '';
    for (let i = 1; i <= 4; i++) {
      const item = slide.criteria[i - 1];
      fields[`CRITERION_NAME_${i}`] = item?.name ?? '';
      fields[`CRITERION_WEIGHT_${i}`] = item ? `${item.weight}%` : '';
    }
    return fields;
  }
  if (slide.archetype === 'cover') { fields.SUBTITLE = slide.subtitle; return fields; }
  fields.RECOMMENDATION = slide.recommendation;
  fields.DECISION = slide.decision;
  for (let i = 1; i <= 5; i++) {
    const item = slide.gates[i - 1];
    fields[`GATE_VENDOR_${i}`] = item?.vendor ?? '';
    fields[`GATE_STATUS_${i}`] = item?.status ?? '';
    fields[`GATE_REASON_${i}`] = item?.reason ?? '';
  }
  for (let i = 1; i <= 3; i++) {
    const item = slide.comparison[i - 1];
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
  const automizer = new Automizer({ templateDir: path.dirname(fullTemplate), outputDir: path.dirname(fullOutput), removeExistingSlides: true, verbosity: 0 });
  const pres = automizer.loadRoot(path.basename(fullTemplate)).load(path.basename(fullTemplate), 'corporate');
  for (const slide of plan.slides) {
    const source = templateInfo.slides[slideNumber[slide.archetype] - 1];
    if (source.missingRequired.length) fail(`Template archetype ${slide.archetype} is missing elements: ${source.missingRequired.join(', ')}`);
    if (source.unsupportedElements.length || source.unsupportedLinks.length) fail(`Template archetype ${slide.archetype} contains unsupported content: ${JSON.stringify({ elements: source.unsupportedElements, links: source.unsupportedLinks })}`);
    const elements = nameMap(source.elements);
    const required = requiredFor(slide.archetype);
    pres.addSlide('corporate', slideNumber[slide.archetype], async s => {
      const actual = await s.getAllElements();
      const actualNames = new Set(actual.map(e => e.name));
      for (const name of required) if (!actualNames.has(name)) fail(`Source slide lost required element ${name}`);
      for (const [name, value] of Object.entries(planTextFor(plan, slide))) s.modifyElement(name, [modify.setText(value)]);
      if (slide.archetype === 'decision_summary' || slide.archetype === 'gate_focus') {
        for (let i = 1; i <= 3; i++) {
          const bar = elements.get(`SCORE_BAR_${i}`), track = elements.get(`SCORE_TRACK_${i}`);
          if (!bar || !track) fail(`Missing score bar/track ${i}`);
          const item = slide.comparison[i - 1];
          if (item) s.modifyElement(`SCORE_BAR_${i}`, [modify.setPosition({ w: Math.max(1, Math.round(track.boundsEmu.cx * item.score / 100)) })]);
          else {
            s.modifyElement(`SCORE_BAR_${i}`, [modify.setPosition({ x: 0, y: 0, w: 1, h: 1 })]);
            s.modifyElement(`SCORE_TRACK_${i}`, [modify.setPosition({ x: 0, y: 0, w: 1, h: 1 })]);
          }
        }
      }
    });
  }
  await mkdir(path.dirname(fullOutput), { recursive: true });
  await pres.write(path.basename(fullOutput));
  if (sha256(await readFile(fullTemplate)) !== templateInfo.sha256) fail('Template changed during build');
  return { output: fullOutput, templateSha256: templateInfo.sha256, outputSha256: sha256(await readFile(fullOutput)), slides: plan.slides.length };
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

type PackagedElement = { name: string; text: string; x: number; y: number; width: number; height: number };

async function packageSlides(zip: JSZip): Promise<PackagedElement[][]> {
  const pres = parseXml(await xml(zip, 'ppt/presentation.xml'), 'ppt/presentation.xml');
  const slideRefs = Array.from(pres.getElementsByTagName('p:sldId'));
  if (!slideRefs.length) fail('Output presentation has no visible slides');
  const rels = parseXml(await xml(zip, 'ppt/_rels/presentation.xml.rels'), 'ppt/_rels/presentation.xml.rels');
  const relationships = Array.from(rels.getElementsByTagName('Relationship'));
  const slides: PackagedElement[][] = [];
  for (const ref of slideRefs) {
    const relId = ref.getAttribute('r:id');
    const relation = relationships.find(n => n.getAttribute('Id') === relId);
    if (!relation) fail('Visible slide relationship missing');
    const slideName = path.posix.normalize(path.posix.join('ppt', relation.getAttribute('Target') ?? ''));
    if (!/^ppt\/slides\/slide\d+\.xml$/.test(slideName)) fail(`Unexpected visible slide target ${slideName}`);
    const doc = parseXml(await xml(zip, slideName), slideName);
    const elements = [...Array.from(doc.getElementsByTagName('p:sp')), ...Array.from(doc.getElementsByTagName('p:pic')), ...Array.from(doc.getElementsByTagName('p:graphicFrame'))];
    slides.push(elements.map(el => {
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
    }));
  }
  return slides;
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

// Rough per-shape text-capacity heuristic: how many characters of Open Sans at a given
// point size can plausibly fit across `lines` lines of the shape's actual output width.
// It cannot prove legibility; it catches gross overflow before a human reviews the render.
function fontSizeFor(name: string, archetype: Archetype): number {
  if (name === 'TITLE') return archetype === 'cover' ? 26 : 24;
  if (name === 'SUBTITLE') return 14;
  if (name === 'RECOMMENDATION') return 15;
  if (name === 'DECISION') return 14;
  if (name === 'SOURCE_NOTES') return 8.5;
  if (name === 'PROBLEM') return 13;
  if (name.startsWith('GATE_STATUS_')) return 8.5;
  if (name.startsWith('GATE_REASON_')) return 9;
  if (name.startsWith('GATE_LINE_')) return 9.5;
  if (name.startsWith('SCORE_LABEL_')) return 8.5;
  if (name.startsWith('CRITERION_')) return 10.5;
  return 10.5;
}
function linesFor(name: string): number {
  if (name === 'SOURCE_NOTES') return 2;
  if (name === 'PROBLEM') return 4;
  if (name === 'TITLE' || name === 'SUBTITLE') return 2;
  return 1;
}

async function validate(template: string, planFile: string, output: string, requireRender: boolean) {
  const plan = await loadPlan(planFile);
  const templateInfo = await inspect(template);
  const outputBytes = await readFile(output);
  const archive = await JSZip.loadAsync(outputBytes, { checkCRC32: true });
  const sourceArchive = await JSZip.loadAsync(await readFile(template));
  const generatedSlides = await packageSlides(archive);
  if (generatedSlides.length !== plan.slides.length) fail(`Output has ${generatedSlides.length} slide(s); plan describes ${plan.slides.length}`);

  const allElements: PackagedElement[] = [];
  for (const [index, slide] of plan.slides.entries()) {
    const label = `slide ${index + 1} (${slide.archetype})`;
    const generated = generatedSlides[index];
    const source = templateInfo.slides[slideNumber[slide.archetype] - 1];
    const names = generated.map(e => e.name);
    const duplicates = names.filter((name, i) => names.indexOf(name) !== i);
    if (duplicates.length) fail(`Duplicate output element names on ${label}: ${duplicates.join(', ')}`);
    const sourceNames = new Set(source.elements.map(e => e.name));
    const extra = names.filter(n => !sourceNames.has(n));
    const missing = source.elements.map(e => e.name).filter(n => !names.includes(n));
    if (extra.length || missing.length) fail(`Output shape inventory differs on ${label}: extra [${extra.join(', ')}], missing [${missing.join(', ')}]`);
    const required = requiredFor(slide.archetype);
    for (const name of required) if (!names.includes(name)) fail(`Required output element missing on ${label}: ${name}`);
    const byName = new Map(generated.map(e => [e.name, e]));
    const expected = planTextFor(plan, slide);
    for (const [name, value] of Object.entries(expected)) {
      if (byName.get(name)?.text !== normalized(value)) fail(`Text mismatch in ${name} on ${label}`);
    }
    if (!byName.get('SOURCE_NOTES')?.text.includes(licenseLine)) fail(`Training disclaimer missing from source notes on ${label}`);
    for (const [name, value] of Object.entries(expected)) {
      const item = byName.get(name);
      if (!item || !value) continue;
      const lines = linesFor(name);
      const capacity = Math.floor(item.width / 914400 * 72 / (fontSizeFor(name, slide.archetype) * 0.6)) * lines;
      if (value.length > capacity) fail(`${name} likely overflows its Open Sans text box on ${label} (${value.length} chars; heuristic capacity ${capacity}); shorten it or choose another archetype`);
    }
    if (slide.archetype === 'decision_summary' || slide.archetype === 'gate_focus') {
      for (let i = 1; i <= 3; i++) {
        const score = slide.comparison[i - 1]?.score ?? 0;
        const trackWidth = byName.get(`SCORE_TRACK_${i}`)?.width ?? 0;
        const barWidth = byName.get(`SCORE_BAR_${i}`)?.width ?? 0;
        if (Math.abs(barWidth - Math.max(1, Math.round(trackWidth * score / 100))) > 2) fail(`Score bar ${i} does not match ${score} on ${label}`);
      }
    }
    allElements.push(...generated);
  }

  const outputPresentation = await xml(archive, 'ppt/presentation.xml');
  const templatePresentation = await xml(sourceArchive, 'ppt/presentation.xml');
  const outSize = parseXml(outputPresentation, 'output presentation').getElementsByTagName('p:sldSz')[0];
  const inSize = parseXml(templatePresentation, 'template presentation').getElementsByTagName('p:sldSz')[0];
  if (outSize?.getAttribute('cx') !== inSize?.getAttribute('cx') || outSize?.getAttribute('cy') !== inSize?.getAttribute('cy')) fail('Slide size changed');
  const slideWidth = Number(outSize?.getAttribute('cx') ?? 0), slideHeight = Number(outSize?.getAttribute('cy') ?? 0);
  for (const item of allElements) if (item.x < 0 || item.y < 0 || item.width < 0 || item.height < 0 || item.x + item.width > slideWidth + 1000 || item.y + item.height > slideHeight + 1000) fail(`Element outside slide bounds: ${item.name}`);
  const outThemes = Object.keys(archive.files).filter(n => /^ppt\/theme\/theme\d+\.xml$/.test(n));
  if (outThemes.length < 1) fail('Output theme missing');
  if (!(await xml(archive, outThemes[0])).includes('Open Sans')) fail('Output theme does not use the required Open Sans font');
  if (!Object.keys(archive.files).some(n => /^ppt\/slideMasters\/slideMaster\d+\.xml$/.test(n))) fail('Output master missing');
  for (const name of Object.keys(archive.files).filter(n => /\.(xml|rels)$/.test(n))) parseXml(await xml(archive, name), name);
  if (!archive.file('[Content_Types].xml')) fail('Content type registry missing');
  const rendered = await render(path.resolve(output), requireRender);
  return { status: 'passed', output: path.resolve(output), outputSha256: sha256(outputBytes), slideCount: plan.slides.length, elements: allElements.length, sources: plan.sources.length, render: rendered };
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
