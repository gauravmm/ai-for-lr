== AI-driven AI analysis

The simplest solution is to have a single ATLAS chatbot and tell it who can see which files. What *business risk* does this expose you to?

*1. Use AI to analyze ATLAS*
#v(-0.8em)
#let atlas-skill-prompt = lblock(inset: 0.6em, outset: 0pt)[
  #set text(font: "DejaVu Sans Mono")
  #underline(stroke: (paint: luma(100), thickness: 1pt, dash: "dotted"), offset: 3pt)[/slides] Explain what could go wrong if ATLAS had one shared chatbot without access control?
]
#only(1)[#block(width: 100%)[
  #layout(size => context {
    let prompt = atlas-skill-prompt
    let prompt-height = measure(prompt, width: size.width).height
    // Route the callout below the box, through the left margin, to /slides.
    let target-y = (0.6em + 0.45em).to-absolute()
    let arrow-height = (prompt-height + 1.5em.to-absolute() - target-y) / 1pt
    let svg = bytes(
      "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 "
        + str(arrow-height + 12)
        + "'>"
        + "<path d='M 56 "
        + str(arrow-height + 6)
        + " H 12 Q 4 "
        + str(arrow-height + 6)
        + " 4 "
        + str(arrow-height - 2)
        + " V 14 Q 4 6 12 6 H 32' fill='none' stroke='#646464' stroke-width='2.8'/>"
        + "<path d='M 24 1 L 32 6 L 24 11' fill='none' stroke='#646464' stroke-width='2.8'/>"
        + "</svg>",
    )
    [
      #prompt
      #place(top + left, dx: -24pt, dy: target-y - 6pt, image(
        svg,
        width: 64pt,
        height: (arrow-height + 12) * 1pt,
        alt: "Hooked arrow from Invoking a skill to the /slides command.",
      ))
      #place(top + left, dx: 38pt, dy: prompt-height + 1em, text(fill: luma(100))[Invoking the "/slides" skill])
    ]
  })
]]
#pause
#only("2-")[#atlas-skill-prompt]

*2. Apply the governance framework*
#v(-0.8em)
#lblock(inset: 0.6em, outset: 0pt)[
  #set text(font: "DejaVu Sans Mono")
  Explain with #underline(stroke: (paint: luma(100), thickness: 1pt, dash: "dotted"), offset: 3pt)[/imda-ai-governance] the risks for an executive audience in two sentences.
]

*3. Control the risk*
#v(-0.8em)
#lblock(inset: 0.6em, outset: 0pt)[
  #set text(font: "DejaVu Sans Mono")
  Explain a technical control for this.
]

#speaker-note[
  - First, students enter the ATLAS prompt in their AI chat.
  - Reveal the follow-up prompt and ask students to send it in the same chat.
  - Discuss: Does the proposed control enforce the boundary, or merely ask the AI to respect it?
  - Compare their answers with the failure examples and access-control solution on the following slides.
]
