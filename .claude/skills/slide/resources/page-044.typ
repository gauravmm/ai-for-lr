== Getting It Right: Ask D.A.V.I.D.

#grid(
  columns: (40%, 1fr),
  column-gutter: 0.5em,
  align: top,
  alternatives(start: 1, position: top + left, risk-pillar-summary(), risk-pillar-summary(
    good-risks: (2, 4),
    good-pillars: ("A", "B", "C"),
  )),
  [
    #text(weight: "bold", size: 1.3em)[Ask D.A.V.I.D.]#cite-source(
      "https://www.youtube.com/watch?v=yMalr0jiOAc",
    )[David Odomirok and Zheng Xue, JPMorgan Chase Private Bank. \ _Investment Research with LangGraph: Ask D.A.V.I.D._. \ LangChain Interrupt, May 2025. Primary conference presentation; 95% time-reduction figure unverified.] #text(
      size: 0.8em,
      fill: luma(120),
    )[(JPMorgan)]\
    #text(size: 0.9em, fill: luma(100))[Multi-agent investment research]

    #v(0.5em)
    - *Supervisor* agent + *specialist* sub-agents (SQL, RAG, analytics)
    - Human advisor *reviews every output* before it reaches a client
    // Citation audit: no primary support found for the 95% figure; verify before presenting.
    - \~95% reduction in research time
    - Internal-only tool.

    Speculation:

    - Restricted to pre-approved data sources.

  ],
)

#speaker-note[
  - Source: JPMorgan speakers David Odomirok and Zheng Xue, LangChain Interrupt 2025. The talk supports the architecture and human oversight; the 95% time-reduction figure remains unverified.
  - Ask David: supervisor + specialists + HITL --- exactly what students will build today
  - Tie back to designing for imperfect agents
]
