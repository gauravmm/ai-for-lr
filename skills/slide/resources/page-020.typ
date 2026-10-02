== Cost of AI #cost-chart-sources()

#slide(config: config-page(margin: (x: 0em)))[
  #cost-chart(image("media/charts/cost-vs-aaii.svg"))[
    Tremendous variety available!

    Prices span three orders of magnitude.
  ]

  #speaker-note[
    Sources: OpenRouter catalog and daily rankings, Artificial Analysis benchmarks, and data/README.md. Snapshot: 30 September 2026, plus the sourced Gemini 4 Argon addition on 1 October and Muse Spark 1.3 score on 2 October. 184 models retained; 140 have AAII scores and are plotted. Muse Spark 1.1, 1.2, and 1.3 are plotted, with 1.3 named explicitly. Its AAII 48 (max) comes from #link("https://artificialanalysis.ai/models/muse-spark-1-3")[Artificial Analysis] under Intelligence Index v4.3.2, a later benchmark reading than the stored September snapshot; the chart mixes benchmark readings. Contributor tiers have no separate stored AAII score and remain unplotted. Usage is censored by the daily top-50 feed, and unknown volume uses the minimum marker size. Argon has 1 nominal token/month, a placeholder at the user's request, not measured OpenRouter usage; it draws at the minimum size without changing the usage scale. Its AAII 53 (high), standard US\$4/US\$20 per million input/output prices, and 30 September release date come from #link("https://artificialanalysis.ai/articles/gemini-4-argon-google-top-three-labs")[Artificial Analysis]; the chart excludes the temporary 50% discount and uses US\$0.56 per 100K-input/8K-output task. Qwen3.8 27B keeps the instructor price/score override.
  ]
]
