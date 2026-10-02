== Industrial revolution

// Article images staggered into headline clouds; Gartner uses a labelled excerpt.
#let news-shot(
  path,
  url,
  source,
  reference,
  width: 290pt,
  height: 110pt,
  ratio: 1,
  top-offset: 0pt,
  angle: 0deg,
) = rotate(
  angle,
  reflow: false,
)[
  #link(url)[
    #block(width: width, fill: white, stroke: 0.6pt + luma(210), inset: 4pt)[
      #block(width: 100%, height: height, clip: true)[
        #place(top + left, dy: top-offset, image(path, width: width - 8pt, height: (width - 8pt) * ratio))
        #place(bottom + right, box(
          fill: white.transparentize(10%),
          inset: (x: 4pt, y: 2pt),
          attribution-style[#source#cite-source(url, reference)],
        ))
      ]
    ]
  ]
]

#slide(align: top, config: config-common(breakable: false))[
  #set text(size: 18pt)
  #v(10pt)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 32pt,
    [
      #align(center, text(size: 24pt, weight: "bold", fill: rgb("#236c57"))[Promise])
      #v(-8pt)
      #block(width: 100%, height: 325pt)[
        #place(top + left, dx: 0pt, dy: 4pt, news-shot(
          "media/industry-landscape/promise/amazon-ai-opportunity.png",
          "https://www.aboutamazon.com/news/aws/amazon-ceo-andy-jassy-aws-ai",
          [Amazon · 2026],
          [Amazon News. _Amazon CEO Andy Jassy talks 6 truths surrounding the rise of AI_. 2026.],
          width: 300pt,
          height: 82pt,
          ratio: 370 / 1200,
          angle: -3deg,
        ))
        #place(top + left, dx: 50pt, dy: 85pt, news-shot(
          "media/industry-landscape/promise/microsoft-golden-opportunity.png",
          "https://blogs.microsoft.com/on-the-issues/2025/01/03/the-golden-opportunity-for-american-ai/",
          [Microsoft · Jan 2025],
          [Microsoft. _The golden opportunity for American AI_. 3 January 2025.],
          width: 280pt,
          height: 88pt,
          ratio: 265 / 710,
          angle: 3deg,
        ))
        #place(top + left, dx: 5pt, dy: 155pt, news-shot(
          "media/industry-landscape/promise/anthropic-productivity-gains.png",
          "https://www.anthropic.com/research/estimating-productivity-gains",
          [Anthropic · Nov 2025],
          [Anthropic. _Estimating AI productivity gains from Claude conversations_. 25 November 2025. Research projections.],
          width: 305pt,
          height: 83pt,
          ratio: 350 / 1200,
          angle: -2deg,
        ))
        #place(top + left, dx: 35pt, dy: 235pt, news-shot(
          "media/industry-landscape/promise/gartner-ai-spending.svg",
          "https://www.gartner.com/en/newsroom/press-releases/2026-09-16-gartner-forecasts-worldwide-ai-spending-to-grow-49-point-5-percent-in-2026",
          [Gartner · Sep 2026 · article excerpt],
          [Gartner. _Worldwide AI Spending Forecast_. 16 September 2026. AI infrastructure: US\$1.484 trillion forecast for 2026.],
          width: 295pt,
          height: 75pt,
          ratio: 320 / 1200,
          angle: 2deg,
        ))
      ]
    ],
    [
      #align(center, text(size: 24pt, weight: "bold", fill: rgb("#a44335"))[Risk])
      #v(-8pt)
      #block(width: 100%, height: 325pt)[
        #place(top + left, dx: 10pt, dy: 0pt, news-shot(
          "media/alignment/openai.com-index-hugging-face-incident-and-the-road-ahead.png",
          "https://openai.com/index/hugging-face-incident-and-the-road-ahead/",
          [OpenAI · Aug 2026],
          [OpenAI. _The Hugging Face incident and the road ahead_. 26 August 2026. Postmortem of the July 2026 cybersecurity-evaluation incident.],
          width: 300pt,
          height: 105pt,
          ratio: 1548 / 936,
          top-offset: -35pt,
          angle: -3deg,
        ))
        #place(top + left, dx: 55pt, dy: 112pt, news-shot(
          "media/industry-landscape/risk/guardian-database-loss.png",
          "https://www.theguardian.com/technology/2026/apr/29/claude-ai-deletes-firm-database",
          [The Guardian · Apr 2026],
          [The Guardian. _AI agent deletes a firm's database_. 29 April 2026.],
          width: 295pt,
          height: 96pt,
          ratio: 197 / 620,
          angle: 3deg,
        ))
        #place(top + left, dx: 0pt, dy: 200pt, news-shot(
          "media/hallucination/edition.cnn.com-2026-09-18-politics-us-military-ai-false-in.png",
          "https://ktvz.com/politics/cnn-us-politics/2026/09/18/exclusive-us-military-had-close-call-after-using-ai-for-false-intelligence-report-sources-say/",
          [CNN · Sep 2026],
          [CNN, syndicated by KTVZ. _US military close call after a false AI intelligence report_. 18 September 2026. Reporting based on unnamed sources, not an official incident finding.],
          width: 255pt,
          height: 110pt,
          ratio: 1548 / 800,
          top-offset: -44pt,
          angle: -2deg,
        ))
      ]
    ],
  )

  #pause
  #place(horizon + right, block(
    fill: black,
    stroke: 4pt + white,
    radius: 1em,
    width: 50% - 16pt,
    height: 5em,
    inset: (x: 18pt, y: 24pt),
    outset: 0pt,
    align(center)[
      #text(size: 26pt, weight: "bold", fill: white)[Risk in moving too quickly]
    ],
  ))
  #pause
  #place(horizon + left, block(
    fill: black,
    stroke: 4pt + white,
    radius: 1em,
    width: 50% - 16pt,
    height: 5em,
    inset: (x: 18pt, y: 24pt),
    outset: 0pt,
    align(center)[
      #text(size: 26pt, weight: "bold", fill: white)[Risk in missing this opportunity]
    ],
  ))
]

#speaker-note[
  The next slide compares Gartner's broader AI infrastructure spending forecast with the Apollo programme and major public infrastructure investment. The electricity comparison uses forecast global AI-server consumption, Singapore's measured annual consumption, and Three Gorges Dam's designed annual generation.
]
