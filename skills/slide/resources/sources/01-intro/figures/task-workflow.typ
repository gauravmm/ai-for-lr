#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let sub = rgb("#eef3ec") // green: per-bid subagents

// Stage header above each column.
#let stage(x, body) = node(
  (x, -0.7),
  text(size: 0.8em, weight: "bold", tracking: 0.08em)[#body],
  stroke: none,
  fill: none,
)

// Stage description below each column.
#let note(x, body) = node(
  (x, 4.9),
  box(width: 9em, height: 1.5em, align(center + top, text(size: 0.75em, style: "italic", body))),
  stroke: none,
  fill: none,
)

// Tighter leading keeps the two-line centre nodes within one lane height.
#set par(leading: 0.35em)

#diagram(
  spacing: (1.3em, 0em),
  // uniform rows: the multi-line centre nodes would otherwise stretch the middle lane
  cell-size: (0pt, 2em),
  node-stroke: 0.8pt,
  node-corner-radius: 4pt,
  node-fill: luma(240),
  node-shape: fletcher.shapes.rect,

  stage(1, [INGEST]),
  stage(2.7, [VERIFY]),
  stage(4.4, [DRAFT]),
  stage(5.8, [REVIEW]),

  // What each stage does, in a row along the bottom.
  note(1, [Understand the requirements]),
  note(2.7, [Check each bid for completeness and correctness]),
  note(4.4, [Score each correct bid using the competitive criteria]),
  note(5.8, [Update the slides]),

  // ── 1. extract documents and criteria ──
  node((1, 2), align(center)[Extract docs\ & criteria]),

  // ── 2. one subagent per bid, so no bid's documents leak into another's evaluation ──
  ..(
    ("Aperture", "aperture-reliability-systems"),
    ("Helix", "helix-test-infrastructure"),
    ("Meridian", "meridian-scientific-systems"),
    ("Northstar", "northstar-metrology"),
    ("Peregrine", "peregrine-instrumentation"),
  )
    .enumerate()
    .map(((y, (name, logo))) => node(
      (2.7, y),
      box(width: 7em, grid(
        columns: (auto, 1fr),
        column-gutter: 0.4em,
        align: horizon,
        image("/docgen/assets/logos/" + logo + ".png", height: 1.3em), align(center, name),
      )),
      fill: sub,
      name: label("v" + str(y)),
      inset: 3pt,
    )),
  ..range(5).map(y => edge((1, 2), (name: "v" + str(y), anchor: "west"), "-|>", snap-to: (auto, none))),

  // ── 3. synthesize and score ──
  node((4.4, 2), align(center)[Synthesize\ & score]),
  ..range(5).map(y => edge((name: "v" + str(y), anchor: "east"), (4.4, 2), "-|>", snap-to: (none, auto))),

  // ── 4. write the slide ──
  node((5.8, 2), align(center)[Write\ slide]),
  edge((4.4, 2), (5.8, 2), "-|>"),
)
