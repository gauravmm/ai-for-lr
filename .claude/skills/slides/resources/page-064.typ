== Erroneous action: policy and control

#grid(
  columns: (40%, 1fr),
  column-gutter: 1.5em,
  align: top,
  risk-pillar-summary(bold-risks: (1,), bold-pillars: ("B", "D")),
  [
    *The problem*

    The LLM misreads or misfiles a document, and the error flows into every later answer.

    #v(0.3em)
    *Policy questions*

    - Which conclusions need immediate human sign-off?
    - Which conclusions are "safe" to fix when discovered?
    - Who owns the correction?

  ],
)

#speaker-note[
  - The database records claims, not just documents: each conclusion links to the document and the page or section that supports it
  - Correcting one source flags every conclusion that depends on it, so only those need re-checking
]
