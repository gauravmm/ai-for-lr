== The Seven Risks #cite-source("https://www.imda.gov.sg/-/media/imda/files/about/emerging-tech-and-research/artificial-intelligence/mgf-for-agentic-ai.pdf")[Infocomm Media Development Authority (IMDA). \ _Model AI Governance Framework for Agentic AI_. \ Version 1.5. Published 20 May 2026; updated 5 June 2026. Local PDF and extracts in references/imda-agentic-ai/.]

#let risk(num, title, body, example: none) = grid(
  columns: (auto, 1fr),
  column-gutter: 0.8em,
  row-gutter: 0.05em,
  align: (right + top, left + top),
  text(weight: "bold", size: 2.5em, fill: luma(140))[#num.],
  [
    *#title* #v(-.8em)
    #body
    #if example != none [
      \
      #text(size: 0.68em, fill: luma(100))[_e.g._ #example]
    ]
    #v(0.4em)
  ],
)

#let risk-group(height, label) = grid(
  columns: (7mm, 1fr),
  column-gutter: 0.4em,
  align: horizon,
  text(fill: luma(130))[#math.lr(sym.brace.r, size: height)], text(size: 1em, fill: luma(100))[#label],
)

#grid(
  columns: (1fr, 90mm),
  column-gutter: 1em,
  row-gutter: 0.4em,
  risk(
    [1],
    [Erroneous actions],
    [mistakes from flawed reasoning or execution.],
  ),
  grid.cell(rowspan: 5, align: horizon)[
    #risk-group(9cm, [*old risks, new target*

      well-understood problems, established mitigations])
  ],

  risk(
    [2],
    [Unauthorized actions],
    [acting outside the agent's permitted scope.],
  ),

  risk(
    [3],
    [Biased or unfair actions],
    [outputs that produce unfair outcomes across groups.],
  ),

  risk(
    [4],
    [Data breaches],
    [exposure or manipulation of sensitive data.],
  ),

  risk(
    [5],
    [Disruption to connected systems],
    [disrupting a system the agent touches.],
  ),

  grid.cell(colspan: 2)[
    #uncover("2-")[
      #v(0.4em)
      #grid(
        columns: (10mm, auto, 1fr),
        column-gutter: 0.5em,
        align: horizon,
        line(length: 100%, stroke: luma(150)),
        [When you have autonomous or multi-agent systems:],
        line(length: 100%, stroke: luma(150)),
      )
      #v(0.3em)
    ]
  ],

  uncover("2-")[#risk(
    [6],
    [Speed and volume],
    [agents outpace real-time human oversight.],
  )],
  grid.cell(rowspan: 2, align: horizon)[
    #uncover("2-")[
      #risk-group(3.5cm, [*risk multiplier*

        speed and reach outrun existing safeguards])
    ]
  ],

  uncover("2-")[#risk(
    [7],
    [Cascading or compounding effects],
    [a mistake in one step amplifies downstream.],
  )],
)
#speaker-note[
  - "Pilot error" = thought-terminating cliché
  - We design cockpits to be safe with imperfect pilots, not perfect pilots
  - Curious students: point at OWASP STRIDE; don't go deep
]


#let risk-pillar-summary(
  bold-risks: (),
  good-risks: (),
  bad-risks: (),
  bold-pillars: (),
  good-pillars: (),
  bad-pillars: (),
) = {
  let status(n, good, bad, bold) = if good.contains(n) { "good" } else if bad.contains(n) {
    "bad"
  } else if bold.contains(n) { "bold" } else { none }
  let color(s) = if s == "good" { rgb("#2e7d32") } else if s == "bad" { rgb("#c62828") } else { luma(140) }
  let row(n, body, good: (), bad: (), bold: ()) = {
    let s = status(n, good, bad, bold)
    let mark = if s == "good" [✓] else if s == "bad" [✘] else [#n.]
    let styled = if s == "good" or s == "bad" {
      text(fill: color(s), weight: "bold")[#body]
    } else if s == "bold" [*#body*] else [#body]
    (text(fill: color(s))[#mark], styled)
  }
  let risk-row(n, body) = row(n, body, good: good-risks, bad: bad-risks, bold: bold-risks)
  let pillar-row(n, body) = row(n, body, good: good-pillars, bad: bad-pillars, bold: bold-pillars)
  show grid.cell.where(x: 0): set text(weight: "bold", fill: luma(140))
  grid(
    columns: (auto, 1fr),
    column-gutter: 0.35em,
    row-gutter: 0.7em,
    align: (right + top, left + horizon),
    [], grid.cell(align: left + horizon)[#text(weight: "bold")[Seven Risks]],
    ..risk-row(1, [Erroneous actions]),
    ..risk-row(2, [Unauthorized actions]),
    ..risk-row(3, [Biased or unfair actions]),
    ..risk-row(4, [Data breaches]),
    ..risk-row(5, [Disrupt connected systems]),
    ..risk-row(6, [Speed and volume]),
    ..risk-row(7, [Cascading effects]),
    [], grid.cell(align: left + horizon, inset: (top: 0.5em))[#text(weight: "bold")[Four Pillars]],
    ..pillar-row("A", [Assess and bound risks]),
    ..pillar-row("B", [Make humans accountable]),
    ..pillar-row("C", [Technical controls]),
    ..pillar-row("D", [Enable end-user responsibility]),
  )
}
