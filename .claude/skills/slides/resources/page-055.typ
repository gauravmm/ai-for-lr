== IMCB ATLAS: Document Flow

#grid(
  columns: (90mm, 1fr),
  gutter: 1em,
  align(center + horizon, atlas-logo()),
  align(center + horizon)[
    #only(1)[#atlas-flow(1, ingest: "pi2")]
    #only(2)[#atlas-flow(1, ingest: "hr")]
  ],
)
