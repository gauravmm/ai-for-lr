== What makes AI _Agentic_?

#speaker-note[
  Editorial overlap: Conceptual overlap with the governance section: "Anatomy of an Agent" and "Where we're starting from" reuse the agent loop; the latter extends it into a workflow.
]

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  row-gutter: 0.8em,
  align: top,
  // Shared rows align the headings, diagram tops, and quotes independently.
  [*Simple LLM*], [*Agentic AI*],
  include "figures/simple-llm.typ", include "figures/agentic-loop.typ",
  lblock(center: true)[
    _"Given this question, what do I answer?"_
  ],
  lblock(center: true)[
    _"Given this goal, what do I do next?"_
  ],
)
A *agent* is an LLM with a harness, which provides *tools* to interact the world.

#v(-.6em)
