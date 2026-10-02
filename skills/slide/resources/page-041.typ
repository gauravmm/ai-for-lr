== Even the Experts Get Burned

#grid(
  columns: (40%, 1fr),
  column-gutter: 0.5em,
  align: top,
  risk-pillar-summary(bad-risks: (1, 2, 6), bad-pillars: ("A", "C")),
  [
    #align(center, image("media/alignment/openclaw-logo-text-dark.png", width: 50%))
    #v(-0.5em)

    #image("media/alignment/meta_email-governance.png", width: 100%)
    #v(-0.5em)

    *Meta's director of AI alignment had OpenClaw expunge her emails without approval.*#cite-source("https://x.com/summeryue0/status/2025774069124399363")[Summer Yue. \ _First-person account of OpenClaw deleting her inbox_. \ 22 February 2026. Post and screenshots; does not establish permanent loss of all messages.]
    #v(-0.2em)
    _I had to run to my Mac mini like I was defusing a bomb._
    #v(-0.5em)
    #align(right)[--- Summer Yue]
  ],
)

#speaker-note[
  - Even alignment researchers get bitten by ungoverned agent access
  - Unauthorized actions:
    - She said "confirm before acting", but that's not a binding limit
    -
  - Mitigations:
    - Cannot permanently delete emails, only put them in trash.
    - Cannot delete emails more than 1 day old.
]
