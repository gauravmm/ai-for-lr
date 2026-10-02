== Unauthorized access & data breach

#grid(
  columns: (40%, 1fr),
  column-gutter: 1.5em,
  align: top,
  [
    #only(1)[#risk-pillar-summary(bad-risks: (4,))]
    #only(2)[#risk-pillar-summary(bad-risks: (2,))]
    #only(3)[#risk-pillar-summary(good-risks: (2, 4), bold-pillars: ("C",))]
  ],
  align(center)[
    #only(1)[#atlas-flow(2)]
    #only(2)[#atlas-flow(3)]
    #only(3)[#atlas-flow(4)]
  ],
)

#speaker-note[
  - Unauthorized access: PI 1 reads PI 2's project update --- an entitlement-boundary failure
  - Unauthorized injection: PI 1 writes into PI 2's project record --- ATLAS must not let askers edit across boundaries
  - Fix: a segmentation policy scopes every request to the requester --- anything from or to PI 1 is limited to what PI 1 is permitted to do, so unrelated documents (e.g. Licensing) are out of reach
]
