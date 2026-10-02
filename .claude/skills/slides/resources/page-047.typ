== Getting It Right: Hippocratic AI

#grid(
  columns: (40%, 1fr),
  column-gutter: 0.5em,
  align: top,
  alternatives(start: 1, position: top + left, risk-pillar-summary(), risk-pillar-summary(
    good-risks: (1, 2, 6),
    good-pillars: ("A", "C", "D"),
  )),
  [
    #text(weight: "bold", size: 1.3em)[Hippocratic AI]#cite-source(
      "https://hippocraticai.com/hippocratic-ai-launches-polaris-5-0/",
    )[Hippocratic AI. \ _Hippocratic AI Launches Polaris 5.0_. \ 2026 company announcement. Patient-volume, clinician-validation and safety statistics are company-reported. Scope: #link("https://hippocraticai.com/new-products/")[non-diagnostic clinical conversations].]\
    #text(size: 0.9em, fill: luma(100))[Voice agents for healthcare]

    #v(0.5em)
    - Post-discharge follow-up, medication walkthroughs
    - Company reports *0 severe-harm events* and 180M+ patient interactions
    - "Polaris" safety, validated by 7,500+ clinicians
    - *Narrow scope* --- non-diagnostic patient support

    Speculation:

    - AI provides a conversational interface layered on top of a provably-correct decision system.
    - Check what the AI is saying mid-conversation with automated guardrails.

  ],
)

#speaker-note[
  - Hippocratic: alignment by *scope*, not by post-hoc guardrails --- low blast radius is a design choice
  - Tie back to designing for imperfect agents
]
