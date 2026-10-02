#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

// `step` selects the leak walkthrough (1 = plain, 2-3 = unauthorized access, 4 = segmentation policy for PI 1, 5 = misclassified document).
// `ingest` highlights document flow: "pi1", "pi2", "tech" (producers submit documents) or "hr" (HR reads Appraisal and PA).
#let atlas-flow(step, ingest: none) = {
  let grey = luma(140)
  let faint = luma(195)
  let red = rgb("#c62828")
  let tag = luma(105)
  let flow = rgb("#eb811b")
  let green = rgb("#2e7d32")
  // Step 4 spotlights PI 1 on both sides and greys out Licensing and PI 2's Project Update.
  let focus = step == 4
  let pi1-label = if focus { text(weight: "bold")[PI 1] } else [PI 1]
  let pi1-stroke = if focus { 0.9pt + black } else { 0.5pt + faint }
  let d-size = (width: 6cm, height: 1.5cm)
  let e-size = (width: 3.2cm, height: 1.5cm)

  let header(pos, body, name) = node(pos, body, name: name, stroke: none)

  let ingest-flows = (
    pi1: (("p-pi1",), ("d-loa", "d-pu1", "d-appr")),
    pi2: (("p-pi2",), ("d-loa", "d-pu2", "d-appr")),
    tech: (("p-contracts", "p-tech"), ("d-lic",)),
    hr: (("d-pa", "d-appr"), ("c-hr",)),
  )
  let ingest-edges = if ingest == none { () } else {
    let (srcs, dsts) = ingest-flows.at(ingest)
    srcs
      .map(s => dsts.map(d => edge(
        label(s + ".east"),
        label(d + ".west"),
        "->",
        snap-to: (none, none),
        stroke: 1.1pt + flow,
      )))
      .flatten()
  }

  // Step 5: Tech-biz's document is filed correctly (green) or misfiled as an LOA (red); only the misfiled LOA feeds ED.
  let misclass-edges = if step == 5 {
    (
      edge(<p-tech.east>, <d-lic.west>, "->", snap-to: (none, none), stroke: 2.2pt + green, bend: 15deg, layer: 1),
      edge(<p-tech.east>, <d-loa.west>, "->", snap-to: (none, none), stroke: 2.2pt + red, bend: 15deg, layer: 1),
      edge(<d-loa.east>, <c-ed.west>, "->", snap-to: (none, none), stroke: 2.2pt + black, bend: 15deg, layer: 1),
    )
  } else { () }

  let flow-diagram = diagram(
    spacing: (0.5cm, 0.2cm),
    node-inset: 3pt,
    node-corner-radius: 2pt,
    node-stroke: none,

    header((0, 0), text(weight: "bold")[Producers], <h-p>),
    header((2, 0), text(font: "Cinzel", weight: "bold", tracking: 0.15em)[ATLAS], <h-a>),
    header((4, 0), text(weight: "bold")[Consumers], <h-c>),

    node((0, 1), [ED], name: <p-ed>, stroke: 0.5pt + faint, ..e-size),
    node((0, 2), pi1-label, name: <p-pi1>, stroke: pi1-stroke, ..e-size),
    node((0, 3), [PI 2], name: <p-pi2>, stroke: 0.5pt + faint, ..e-size),
    node((0, 4), [Contracts], name: <p-contracts>, stroke: 0.5pt + faint, ..e-size),
    node((0, 5), [HR], name: <p-hr>, stroke: 0.5pt + faint, ..e-size),
    node((0, 6), [Tech-biz], name: <p-tech>, stroke: 0.5pt + faint, ..e-size),
    node((0, 7), text(fill: faint)[⋯], name: <p-dots>, stroke: none),

    node((4, 1), [ED], name: <c-ed>, stroke: 0.5pt + faint, ..e-size),
    node((4, 2), pi1-label, name: <c-pi1>, stroke: pi1-stroke, ..e-size),
    node((4, 3), [PI 2], name: <c-pi2>, stroke: 0.5pt + faint, ..e-size),
    node((4, 4), [Contracts], name: <c-contracts>, stroke: 0.5pt + faint, ..e-size),
    node((4, 5), [HR], name: <c-hr>, stroke: 0.5pt + faint, ..e-size),
    node((4, 6), [Tech-biz], name: <c-tech>, stroke: 0.5pt + faint, ..e-size),
    node((4, 7), text(fill: faint)[⋯], name: <c-dots>, stroke: none),

    node(
      (2, 1),
      [PA],
      name: <d-pa>,
      stroke: 0.7pt + black,
      fill: white,
      ..d-size,
    ),
    node(
      (2, 2),
      [LOA],
      name: <d-loa>,
      stroke: 0.7pt + black,
      fill: white,
      ..d-size,
    ),
    node(
      (2, 3),
      [PI 1 Project Update],
      name: <d-pu1>,
      stroke: 0.7pt + black,
      fill: white,
      ..d-size,
    ),
    node(
      (2, 4),
      if focus { text(fill: faint)[PI 2 Project Update] } else [PI 2 Project Update],
      name: <d-pu2>,
      stroke: 0.7pt + if focus { faint } else { black },
      fill: white,
      ..d-size,
    ),

    node(
      (2, 5),
      [Appraisal],
      name: <d-appr>,
      stroke: 0.7pt + black,
      fill: white,
      ..d-size,
    ),
    node(
      (2, 6),
      if focus { text(fill: faint)[Licensing] } else [Licensing],
      name: <d-lic>,
      stroke: 0.7pt + if focus { faint } else { black },
      fill: white,
      ..d-size,
    ),

    node(
      enclose: (<h-p>, <h-c>, <p-dots>, <c-dots>),
      name: <frame>,
      fill: none,
      stroke: none,
      corner-radius: 4pt,
      inset: 8pt,
      snap: false,
    ),

    node(
      enclose: (<d-pa>, <d-lic>),
      name: <atlas-box>,
      fill: none,
      stroke: stroke(paint: luma(110), thickness: 0.8pt, dash: "dashed"),
      corner-radius: 4pt,
      inset: 6pt,
      snap: false,
    ),

    edge(<p-pi1.east>, <d-pu1.west>, "->", snap-to: (none, none), stroke: 0.55pt + grey),
    edge(<d-pu1.east>, <c-pi1.west>, "->", snap-to: (none, none), stroke: 0.55pt + grey),
    edge(<p-pi2.east>, <d-pu2.west>, "->", snap-to: (none, none), stroke: 0.55pt + if focus { faint } else { grey }),
    edge(<d-pu2.east>, <c-pi2.west>, "->", snap-to: (none, none), stroke: 0.55pt + if focus { faint } else { grey }),
    edge(<p-ed.east>, <d-pa.west>, "->", snap-to: (none, none), stroke: 0.4pt + faint),
    edge(<d-pa.east>, <c-ed.west>, "->", snap-to: (none, none), stroke: 0.4pt + faint),
    edge(<p-contracts.east>, <d-loa.west>, "->", snap-to: (none, none), stroke: 0.4pt + faint),
    edge(<d-loa.east>, <c-contracts.west>, "->", snap-to: (none, none), stroke: 0.4pt + faint),
    edge(<p-hr.east>, <d-appr.west>, "->", snap-to: (none, none), stroke: 0.4pt + faint),
    edge(<d-appr.east>, <c-hr.west>, "->", snap-to: (none, none), stroke: 0.4pt + faint),
    edge(<p-tech.east>, <d-lic.west>, "->", snap-to: (none, none), stroke: 0.4pt + faint),
    edge(<d-lic.east>, <c-tech.west>, "->", snap-to: (none, none), stroke: 0.4pt + faint),

    if step == 2 {
      edge(<d-pu2.east>, <c-pi1.west>, "->", snap-to: (none, none), stroke: 2.2pt + red, bend: 15deg, layer: 1)
    } else {
      fletcher.hide(edge(<d-pu2.east>, <c-pi1.west>, "->", snap-to: (none, none), stroke: 1.1pt + red, bend: 25deg))
    },

    if step == 3 {
      edge(<p-pi1.east>, <d-pu2.west>, "->", snap-to: (none, none), stroke: 2.2pt + red, bend: 15deg, layer: 1)
    } else {
      fletcher.hide(edge(<p-pi1.east>, <d-pu2.west>, "->", snap-to: (none, none), stroke: 1.1pt + red, bend: -25deg))
    },

    ..ingest-edges,
    ..misclass-edges,
  )

  let caption = (
    none,
    text(fill: black)[What is the biggest risk of doing this naively, with a single chatbot that everyone talks to?],
    [What if PI 1 reads PI 2's private data?],
    [What if PI 1 writes into PI 2's project?],
    [*Segmentation policy:* anything from or to PI 1 is limited to what PI 1 is permitted to do.],
    [What if the LLM misreads the document?],
  ).at(step)
  // Use "pi1" to highlight PI 1's submissions or "tech" to highlight Contracts and Tech-biz submitting Licensing documents; both leave the caption blank.
  let ingest-captions = (
    pi1: [],
    pi2: [Each business unit continuously submits paperwork as they produce it.],
    tech: [],
    hr: [Each consumer asks questions about the documents relevant to their role.],
  )
  let caption = if ingest != none { ingest-captions.at(ingest) } else { caption }

  // The caption slot has a fixed two-line height (even when empty) so the diagram doesn't move between subslides.
  box(stack(
    dir: ttb,
    spacing: 6pt,
    flow-diagram,
    align(center, box(
      width: 14cm,
      height: 2.6em,
      text(fill: if focus or ingest != none { black } else { red }, style: "italic", caption),
    )),
  ))
}
