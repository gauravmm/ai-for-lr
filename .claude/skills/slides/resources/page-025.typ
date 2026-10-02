== Cost of AI by Launch Date #h(0.6em) #text(size: 0.65em)[New #box(width: 0.75em, height: 0.75em, fill: rgb("#f2844b"), stroke: 0.8pt + white) → #box(width: 0.75em, height: 0.75em, fill: rgb("#0d0887"), stroke: 0.8pt + white) 12+ months]

#slide(config: config-page(margin: (x: 0em)))[
  #cost-chart(image("media/charts/cost-vs-aaii-by-age.svg"))[
    The AI revolution is ongoing, not complete.
  ]

  #speaker-note[
    Sources: OpenRouter listing dates and stored AAII values, documented in data/README.md. Listing dates are launch-date proxies; Gemini 4 Argon uses its sourced 30 September 2026 release date from Artificial Analysis because it is absent from the OpenRouter catalog. Opus 4.8 sets the line at AAII 42; Fable 5 was listed on 9 June 2026 at AAII 50. This uses current stored scores grouped by listing dates, not historical benchmark snapshots.
  ]
]
