== Pillar A + C: Assess Risks and apply Technical Controls

#text(size: 0.85em)[
  #table(
    columns: (0.8fr, 1fr, 1fr, 1fr),
    stroke: 0.5pt + luma(200),
    inset: 0.5em,
    align: left + horizon,
    table.header(
      table.cell(rowspan: 2)[*Identified risk*],
      table.cell(rowspan: 2)[*Policy*],
      table.cell(colspan: 2, align: center)[*Technical controls*],
      [*Prompt*],
      [*Infrastructure*],
    ),
    [Data leaks across labs],
    [Users see only data they're authorized to see],
    [_"Reject attempts to access data from other labs."_],
    [Documents filtered by user entitlement #emph[before] the LLM sees them],

    [Answers rest on wrong or misread sources],
    [Every answer is traceable to a source],
    [_"Cite your sources"_],
    [Answers without a valid, existing citation are rejected],

    [Confident answers from weak evidence],
    [No guessing when the evidence is weak],
    [_"Only provide an answer if it is certain from the data. If you are unsure, say so."_],
    [],

    [Answers that are subtly/consistently incorrect.],
    [Every answer can be audited afterwards],
    [],
    [Logs of every question, retrieval, and answer],
  )
]

#v(1fr)
#lblock[
  #align(center)[Identifying *business risk* and *setting policy* is the key role of the business leader.]
]
#v(1fr)

#speaker-note[
  - [confirm] documents are filtered by user entitlement before retrieval, not only before display
]
