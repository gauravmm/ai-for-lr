== Hallucinations

#slide(config: config-common(breakable: false))[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,
    [
      *Hallucination*: the model states something confidently, fluently, and *wrong*.

      #v(0.6em)

      An American military AI hallucinated  nuclear weapons components on a Chinese vessel's cargo manifest.#cite-source("https://ktvz.com/politics/cnn-us-politics/2026/09/18/exclusive-us-military-had-close-call-after-using-ai-for-false-intelligence-report-sources-say/")[CNN, syndicated by KTVZ. \ _US military close call after a false AI intelligence report_. \ 18 September 2026. Reporting based on unnamed sources, not an official incident finding.]

      “entirely false” but it also *“almost started a war”*
    ],
    overflow-image(
      "media/hallucination/edition.cnn.com-2026-09-18-politics-us-military-ai-false-in.png",
      1548.0 / 800.0,
      width: 240.6pt,
    ),
    overflow-image(
      "media/hallucination/techcrunch.com-2026-09-18-ai-hallucination-nearly-triggers-.png",
      1504.0 / 800.0,
      width: 240.6pt,
      credit: [TechCrunch#cite-source("https://techcrunch.com/2026/09/18/ai-hallucination-nearly-triggers-us-military-operation/")[Aditya Mehta, TechCrunch. _AI hallucination nearly triggers US military operation_. 18 September 2026.]],
    ),
  )
]

#speaker-note[
  - CNN + TechCrunch coverage of the same Sep 2026 near-miss: a hallucinated intel report circulated as real, nearly triggering a strike before it was caught
  - Images run off the bottom on purpose --- full articles, only the headline + lead need to land on the slide
  - Callback to "Security Issues" slide's one-liner; this is the worked example
]
