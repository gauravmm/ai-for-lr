#import "@preview/touying:0.7.4": *
#import themes.metropolis: *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/tiaoma:0.3.0": qrcode
#import "/common.typ": attribution-style, big-section-slide, focus-slide, gblock, lblock
#import "/annotation-brace.typ": annotation-brace
#import "/citations.typ": cite-source, reference-slides
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "figures/atlas-flow.typ": atlas-flow

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  header-right: none,
  config-common(new-section-slide-fn: big-section-slide),
  config-info(
    title: [Introduction to Agentic AI],
    subtitle: [A*STAR Leadership Retreat],
    author: [Dr Gaurav Manek],
    date: "2026-10-08",
    institution: [manek.sg/aileaders],
    logo: box(
      fill: white,
      inset: 2pt,
      height: 1.5em + 4pt,
      image(
        "media/logos/A_STAR_logo.png",
        height: 1.5em,
        alt: "A*STAR — Agency for Science, Technology and Research",
      ),
    ),
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#let aside(title, body) = box(
  fill: luma(240),
  width: 100%,
  height: 100%,
  radius: 0.5em,
  inset: 0.5em,
  grid(
    rows: (2em, 1fr),
    align: horizon,
    text(weight: "bold", size: 1.3em)[#title],
    body,
  ),
)

#let label-item(title, body) = box(
  fill: luma(240),
  width: 100%,
  height: 100%,
  radius: 0.5em,
  outset: (left: 0.5em, right: 0.5em),
  inset: (top: 0.5em, bottom: 0.5em),
  [#text(size: 1.2em, weight: "bold")[#title] \ #body],
)

#let tok-colors = (rgb("#FFD966"), rgb("#B6D7A8"), rgb("#9FC5E8"), rgb("#EA9999"))
#let tok(n, content, inset: (x: 0.2em, y: 0.15em)) = box(
  fill: tok-colors.at(calc.rem(n, tok-colors.len())),
  inset: inset,
  radius: 0.1em,
)[#content]

// Anchors an image to the top of its container and lets it run off the
// bottom, at the given `width`. `ratio` is the image's own height/width
// (in pixels). `width` must be an explicit absolute length, not a
// percentage or `context`-measured size -- both silently center-crop the
// image to fit the available region instead of overflowing (tested: even
// wrapping the measurement in `context layout(...)` inside touying's slide
// body still shifted the placement down unpredictably), so the caller
// works out the column width by hand from the slide's known geometry.
// Keep credits inside the image boundary, including when the image overflows.
#let screenshot-image(
  path,
  credit,
  width: auto,
  height: auto,
  fit: "contain",
  credit-align: bottom + right,
  alt: none,
) = box(
  image(path, width: width, height: height, fit: fit, alt: alt)
    + place(credit-align, box(
      fill: white.transparentize(10%),
      inset: (x: 4pt, y: 2pt),
      attribution-style(credit),
    )),
)

#let overflow-image(path, ratio, width: 1pt, credit: none) = place(
  top,
  if credit == none {
    image(path, width: width, height: width * ratio)
  } else {
    screenshot-image(path, credit, width: width, height: width * ratio, credit-align: top + right)
  },
)

#title-slide()

= Outline <touying:hidden>

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    1. Background
    2. What is AI?
    3. What makes it agentic?
    4. Governing agentic AI
    5. Case studies

    #lblock[Hands-on: \
      *Design and govern an AI workflow*]
  ],
  grid(
    rows: (1fr, auto),
    row-gutter: 0.8em,
    aside[AI for *leadership*][
      #v(0.5em)
      This course is for business leaders, not engineers.

      + Focus on AI governance.
      + Identifying high-value applications
      + Mitigating specific *risks*
      + Organizational policy levers
      #v(0.5em)

      _Zero_ coding.
    ],
    [
      Navigate to `https://manek.sg/aileaders`,

      Your TAs will help set up.
    ],
  ),
)



== About Me <touying:hidden>

#grid(
  columns: (1fr, 2fr),
  gutter: 2em,
  align(center + horizon)[
    #block(
      radius: 0.5em,
      clip: true,
    )[
      #image("media/about/portrait.jpg", width: 100%, height: 120mm)
    ]
  ],
  align(horizon)[
    #text(weight: "bold", size: 12mm)[Dr. Gaurav Manek]
    #v(0.3em)
    - Founder, *Ocellivision*

    - Technical Lead, *ATLAS* @ IMCB

    - *PhD* in AI/ML --- Carnegie-Mellon University (2023)

    - Founder, *Visigoth.ai* (SaaS)

    #v(2em)

    #text(size: 0.85em, fill: luma(100))[
      For follow-up questions:
      #v(-1em)
      #link("mailto:gaurav_manek@a-star.edu.sg")[#box(baseline: 20%)[#image(
          "media/logos/email.svg",
          height: 1.2em,
          alt: "Email",
        )] gaurav_manek\@a-star.edu.sg
      ]
      #v(-1em)
      #link("https://www.linkedin.com/in/gauravmanek")[#box(baseline: 20%)[#image(
          "media/logos/linkedin.svg",
          height: 1.2em,
          alt: "LinkedIn profile",
        )] gauravmanek
      ]
    ]
  ],
)

== About Our TAs <touying:hidden>

#let tas = (
  ("Dr.", "Aarthi Ravikrishnan", "ASRL", "media/tas/Aarthi Ravikrishnan.jpg"),
  ("Dr.", "Adaikalavan Ramasamy", "ASRL / GIS", "media/tas/Adaikalavan Ramasamy.jpg"),
  ("Dr.", "Gokce Oguz", "ASRL / GIS", "media/tas/Gokce Oguz.jpg"),
  ("Dr.", "Chinh Tran-To Su", "BII", "media/tas/Chinh Su Tran To.jpg"),
  ("Ms.", "Dong Jiahui", "BDH", "media/tas/Dong Jiahui.jpg"),
  ("Mr.", "Guai Zi Wei", "ETO", "media/tas/Guai Zi Wei.jpg"),
  ("Dr.", "Audrey Lee", "GIS", "media/tas/Audrey Lee.jpg"),
  ("Dr.", "Benedict Wong", "IAIC", "media/tas/Benedict Wong.jpg"),
  ("Dr.", "Benjamin Chew", "IAIC", "media/tas/Benjamin Chew.jpg"),
  ("Dr.", "Farzam Farbiz", "IAIC", "media/tas/Farzam Farbiz.jpg"),
  ("Dr.", "Amhed Missael Vargas Velazquez", "IMCB", "media/tas/Amhed Missael Vargas Velazquez.jpg"),
  ("Mr.", "Xavier Wilbin", "IMCB", "media/tas/Xavier Wilbin.png"),
)

#let ta-headshot-height = 40mm

#slide[
  #grid(
    columns: (1fr,) * 6,
    column-gutter: 0.0em,
    row-gutter: 0.4em,
    ..tas
      .enumerate()
      .map(((index, ta)) => align(center, stack(
        dir: ttb,
        spacing: 0.3em,
        block(
          width: 90%,
          height: ta-headshot-height,
          radius: 0.5em,
          clip: true,
          fill: luma(235),
          stroke: 0.5pt + luma(215),
          if ta.at(3) != none {
            align(center, image(ta.at(3), height: ta-headshot-height))
          },
        ),
        block(width: 100%, height: 1.0em)[
          #align(top + center)[#text(size: 0.7em, weight: "bold")[
            #set par(leading: 0.25em)
            #ta.at(0) #ta.at(1)
          ]]
        ],
        text(size: 0.8em, fill: luma(100))[#ta.at(2)],
      ))),
  )
  #v(-1em)
  #align(center, image("media/logos/coai-logo.png", height: 1.8cm))
]


= Industry Landscape

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

== Gold Rush of our age

#slide(align: top, config: config-common(breakable: false))[
  #grid(
    columns: (auto, auto, 1fr),
    column-gutter: 8pt,
    row-gutter: 1em,
    align: (left, right, left),
    grid.cell(colspan: 3, align: left)[
      *Global AI infrastructure spending in 2026*#cite-source("https://www.gartner.com/en/newsroom/press-releases/2026-09-16-gartner-forecasts-worldwide-ai-spending-to-grow-49-point-5-percent-in-2026")[Gartner. \ _Worldwide AI Spending Forecast_. \ 16 September 2026. AI infrastructure: US\$1.484 trillion forecast for 2026.]
    ],

    grid.cell(rowspan: 3)[
      #text(size: 48pt, weight: "bold")[US\$1.48T]
    ],
    text(size: 24pt)[≈5×],
    [
      #text(size: 24pt)[Apollo missions]#cite-source("https://www.planetary.org/space-policy/cost-of-apollo")[The Planetary Society. \ _How much did the Apollo program cost?_. \ Apollo, 1960-1973: US\$309 billion in 2025 dollars.] (US\$309 billion)
    ],
    text(size: 24pt)[≈3×],
    [

      #text(size: 24pt)[Great Wall of China rebuild]#cite-source("https://www.reddit.com/r/AskEngineers/comments/3apfpl/comment/csevfg4/")[AskEngineers discussion. \ _Hypothetical Great Wall rebuilding estimate_. \ 2015. Informal estimate; not a professional quotation. Exact US\$452 billion value not independently verified.] (US\$452 billion)
    ],
    text(size: 24pt)[≈1×],
    [
      #text(size: 24pt)[Cumulative global datacenter spend until the mid-2000s]#cite-source(
        "../references/datacenter-spend/README.md",
      )[Workshop illustrative model. \ _Cumulative global datacenter spending_. \ Supplied historical anchors and adjustment assumptions; not a measured historical series.] \
    ],

    grid.cell(colspan: 3, align: left)[
      *Global AI-server electricity consumption in 2026*#cite-source("https://www.gartner.com/en/newsroom/press-releases/2026-06-10-gartner-says-data-center-electricity-demand-to-grow-26-percent-in-2026")[Gartner. \ _Data Center Electricity Consumption Forecast_. \ 10 June 2026. AI-optimized servers: 175 TWh forecast for 2026.]
    ],

    grid.cell(rowspan: 2)[
      #text(size: 48pt, weight: "bold")[175 TWh]
    ],
    text(size: 24pt)[≈3×],
    [
      #text(size: 24pt)[Singapore electricity consumption in 2024]#cite-source("https://www.ema.gov.sg/resources/singapore-energy-statistics/chapter3")[Energy Market Authority, Singapore. \ _Singapore Energy Statistics: Energy Consumption_. \ 2024 electricity consumption: 58 TWh.] (58 TWh)
    ],
    text(size: 24pt)[≈2×],
    [
      #text(size: 24pt)[Three Gorges' designed annual output]#cite-source("https://www.ctg.com.cn/ctgenglish/news_media/news37/2024080621160453600/index.html")[China Three Gorges Corporation. \ _Three Gorges annual power generation_. \ 19 November 2020. Designed annual generation: 88.2 TWh; distinct from actual output.] (88.2 TWh)
    ],
  )
]

#speaker-note[These are rough numbers at best.]

== AI Value Chain

#slide(align: top, config: config-common(breakable: false))[
  #cite-source(
    "https://www.infotech.com/research/ss/discover-the-enterprise-ai-technology-stack",
    display: false,
  )[Info-Tech Research Group. _Discover the Enterprise AI Technology Stack_.]
  #cite-source(
    "https://airc.nist.gov/airmf-resources/airmf/5-sec-core/",
    display: false,
  )[NIST. _AI Risk Management Framework: AI RMF Core_.]
  #cite-source(
    "https://a16z.com/emerging-architectures-for-llm-applications/",
    display: false,
  )[Andreessen Horowitz. _Emerging Architectures for LLM Applications_.]
  #cite-source(
    "https://docs.aws.amazon.com/prescriptive-guidance/latest/strategy-enterprise-ready-gen-ai-platform/layered-approach.html",
    display: false,
  )[Amazon Web Services. _Layered approach for a generative AI platform_. AWS Prescriptive Guidance.]
  #cite-source("https://blogs.nvidia.com/blog/ai-5-layer-cake/", display: false)[NVIDIA. _AI's five-layer cake_.]

  #set text(size: 18pt)
  #v(10pt)
  #let control-label(label) = grid.cell(align: right + horizon)[
    #text(size: 18pt, weight: "bold", fill: rgb("#5a5a5a"))[#label]
  ]
  #let control-brace = block(width: 100%, height: 100%, spacing: 0pt)[
    #layout(size => annotation-brace(size.height, "#5a5a5a", direction: "left"))
  ]
  #grid(
    columns: (1fr, 16pt, 2.2fr, 16pt, 1fr),
    rows: (1fr,) * 6,
    column-gutter: 12pt,
    row-gutter: 4pt,
    align: top,
    grid.cell(x: 0, y: 0, rowspan: 2, control-label([Your direct control])),
    grid.cell(x: 1, y: 0, rowspan: 2, control-brace),
    grid.cell(x: 0, y: 2, rowspan: 2, control-label([Your technical team owns])),
    grid.cell(x: 1, y: 2, rowspan: 2, control-brace),
    grid.cell(x: 0, y: 4, rowspan: 2, control-label([External providers])),
    grid.cell(x: 1, y: 4, rowspan: 2, control-brace),
    grid.cell(x: 2, y: 0, rowspan: 6)[
      #let value-layer(title, detail, fill: luma(240), ink: rgb("#23373b")) = grid.cell(
        fill: fill,
        inset: (x: 12pt, y: 9pt),
      )[
        #set par(leading: 3pt, spacing: 0pt)
        #stack(
          dir: ttb,
          spacing: 10pt,
          text(size: 24pt, weight: "bold", fill: ink)[#title],
          text(size: 18pt, fill: ink)[#detail],
        )
      ]
      #block(width: 100%, height: 100%, spacing: 0pt, fill: luma(160), radius: 5pt, clip: true)[
        #grid(
          columns: (1fr,),
          rows: (1fr,) * 6,
          row-gutter: 4pt,
          value-layer(
            [1. Business need],
            [Outcomes · priorities · success metrics],
            fill: rgb("#236c57"),
            ink: white,
          ),
          value-layer([2. Policy], [Rules · accountability · human oversight], fill: rgb("#c5dace")),
          value-layer([3. Orchestration], [Workflows · integrations · approvals], fill: rgb("#dce8e2")),
          value-layer(
            [4. Engineering],
            [Tools · prompts · evaluation · deployment],
            fill: rgb("#e7edef"),
          ),
          value-layer(
            [5. Infrastructure],
            [Inference · latency · capacity · cost],
            fill: luma(240),
          ),
          grid.cell(
            fill: luma(160),
            inset: 0pt,
          )[
            #grid(
              columns: (1fr,) * 5,
              rows: (1fr,),
              column-gutter: 4pt,
              ..([model dev], [chips], [power], [data centres], [network]).map(label => block(
                width: 100%,
                height: 100%,
                fill: luma(240),
                inset: 4pt,
              )[
                #set par(leading: 3pt, spacing: 0pt)
                #align(center + horizon, text(size: 16pt, weight: "bold", fill: rgb("#23373b"))[#label])
              ]),
            )
          ],
        )
      ]
    ],
    grid.cell(x: 3, y: 1)[#pause
      #block(width: 100%, height: 100%, spacing: 0pt)[
        #layout(size => {
          let brace-height = size.height * 1.4 + 8pt
          place(top + left, dy: (size.height - brace-height) / 2, annotation-brace(brace-height, "#e87900"))
        })
      ]
    ],
    grid.cell(x: 4, y: 1, align: left + horizon)[
      #text(size: 18pt, weight: "bold", fill: rgb("#e87900"))[
        This workshop.
      ]
    ],
    grid.cell(x: 3, y: 3, colspan: 2, rowspan: 3)[
      #block(width: 100%, height: 100%, spacing: 0pt)[
        #layout(size => {
          let row-height = (size.height - 8pt) / 3
          let extension = row-height / 2 + 4pt
          let brace-height = size.height + extension
          place(top + left, dy: -extension, grid(
            columns: (16pt, 1fr),
            rows: (brace-height,),
            column-gutter: 12pt,
            annotation-brace(brace-height, "#5a5a5a"),
            grid.cell(align: left + horizon)[
              #text(size: 18pt, fill: rgb("#5a5a5a"))[Briefly explained.]
            ],
          ))
        })
      ]
    ],
  )
]

#speaker-note[
  Synthesized from: Info-Tech: Enterprise AI Technology Stack; NIST AI RMF Core; a16z: Emerging Architectures for LLM Applications; AWS: Layered approach for generative AI; NVIDIA: AI's five-layer cake.
]


= What _is_ AI?

== What Does "AI" Mean?

#grid(
  columns: (1.4fr, 1fr),
  gutter: 1em,
  [
    - "AI" is a *marketing* and technical term
      - From rule-based systems to neural networks
      - Promises to revolutionize everything

    - Massive returns in software, marketing, etc.
      - Just starting in some conservative industries.

    #v(0.5em)

    - Turn prediction into a commodity.#cite-source("https://www.predictionmachines.ai/")[Ajay Agrawal, Joshua Gans, Avi Goldfarb. \ _Prediction Machines: The Simple Economics of Artificial Intelligence_. \ Harvard Business Review Press, 2018.]

    #v(0.5em)

    *Not magic*
    #pause
  ],
  lblock(inset: (x: 1.1em, y: 2em), outset: 0pt)[
    #text(
      weight: "bold",
      size: 1.5em,
    )[Jevons paradox #cite-source("https://www.econlib.org/library/YPDBooks/Jevons/jvnCQ.html?chapter_num=9")[William Stanley Jevons. \ _The Coal Question, Chapter VII: Of the Economy of Fuel_. \ First published 1865; linked text is the second edition, Macmillan, 1866.]]

    AI won't make working easier. \
    It raises the bar for everyone \
    and increases competition.

    The only competitive moat left \
    is your speed of integration.

    Adopt early, or *get left behind.*
  ],
)

#cite-source(
  "https://www.hachettebookgroup.com/titles/daron-acemoglu/power-and-progress/9781541702554/?lens=publicaffairs",
  display: false,
)[Daron Acemoglu, Simon Johnson. \ _Power and Progress: Our Thousand-Year Struggle Over Technology and Prosperity_. \ PublicAffairs, 2023. Further reading on technology and prosperity.]

#speaker-note[
  - Prediction Machines concerns cheaper prediction, not a guarantee of better decisions.
  - Jevons explains how efficiency can increase total demand. The competition and adoption claims here are the presenter's application to AI, not conclusions established by that book.
]


== What is a Large Language Model?

#slide(align: top, config: config-common(breakable: false))[
  #align(center, text(weight: "bold", size: 1.5em)[An LLM is Fancy Autocomplete])
  #let sentence-tokens = (
    [An],
    [ LLM],
    [ predicts],
    [ the],
    [ next],
    [ token],
    [ given],
    [ every],
    [thing],
    [ before],
    [.],
  )
  #let token-steps = (
    (5, [token / word / step]),
    (6, [given / using / from]),
    (7, [every / all / the]),
    (8, [thing / word / token]),
    (9, [before / so / in]),
    (10, [“.” / “,” / “and”]),
    (11, [(end) / It / This]),
  )
  #grid(
    columns: (1fr,),
    row-gutter: 9pt,
    align: left + horizon,
    ..token-steps.map(step => [
      #for (index, token) in sentence-tokens.slice(0, step.at(0)).enumerate() {
        tok(
          index,
          text(weight: if index == step.at(0) - 1 { "bold" } else { "regular" })[#token],
          inset: (
            left: if index == 8 { 0pt } else { 0.2em },
            right: if index == 7 { 0pt } else { 0.2em },
            y: 0.15em,
          ),
        )
      }#h(0.35em)#text(size: 18pt, fill: luma(130))[#step.at(1)]
    ]),
  )

  #pause

  1 token ≈ ¾ of an English word, a punctuation mark, or a digit.#cite-source("https://platform.openai.com/tokenizer")[OpenAI. \ _Tokenizer_. \ Interactive examples of tokenization.]

  Unit of computation: pay per token in and out. The _context window_ is sized in tokens.
]

#speaker-note[
  “everything” is split into “every” and “thing”,
  punctuation is separate.
]

== What is a Large Language Model?

#align(center, text(weight: "bold", size: 1.5em)[An LLM is Fancy Autocomplete])

#v(0.5em)

#grid(
  columns: (1fr, 1fr),
  align: top,
  gutter: 1em,
  [
    - Blocks of linear algebra
      - arranged in creative ways
      - trained on every scrap of human media
      - unimaginable amounts of computation
      - learn statistical patterns, not explicit rules about the world

    - Behaviour *surprisingly* emerges at scale
      - Exhibits strengths and weaknesses very different from humans
  ],
  [
    #pause
    *LLMs are black boxes*: we have limited understanding of how they work.

    *LLMs are stochastic:* Identical runs often produce different output.

    - `Sunny skies ☀️, 30°C.`
    - `30°C with plenty of sunshine.`
    - `It's sunny and 30°C today.`

    #lblock[
      *Agent engineering* extracts useful work despite these limits.
    ]

  ],
)


#speaker-note[
  - "Fancy autocomplete" is provocative on purpose
  - Return to it when students are surprised by what models do
  - Emergent capabilities at scale were not programmed
]


// Coordinates match the native-size SVGs generated by data/make_chart.py.
// The callout ends above GLM 5.3 Flash and left of GLM 5.3.
#let cost-chart(chart, body) = block(spacing: 0pt)[
  #chart

  #pause

  #place(top + left, dx: 60pt, dy: 16pt)[
    #lblock(width: 350pt, inset: 0pt, outset: 0pt)[
      #block(width: 100%, height: 78pt, inset: 10pt)[#body]
    ]
  ]
]

#let cost-chart-sources() = [
  #cite-source(
    "https://openrouter.ai/docs/api/api-reference/datasets/get-rankings-daily",
  )[OpenRouter. _Daily token totals for top 50 models_. Usage feed. Prices and listing dates: #link("https://openrouter.ai/api/v1/models")[models catalog]. Snapshot: 30 September 2026.]
  #cite-source(
    "https://artificialanalysis.ai/",
  )[Artificial Analysis, via OpenRouter. _Artificial Analysis Intelligence Index_. Benchmark snapshot: 30 September 2026. Stored curated scores and teaching overrides: 01-intro/data/README.md.]
  #cite-source(
    "https://artificialanalysis.ai/articles/gemini-4-argon-google-top-three-labs",
  )[Artificial Analysis. _Gemini 4 Argon: Google is back as one of the top three labs in intelligence achieved_. 30 September 2026. AAII 53 (high); standard input/output pricing of US\$4/US\$20 per million tokens, before the introductory discount.]
  #cite-source(
    "https://artificialanalysis.ai/models/muse-spark-1-3",
  )[Artificial Analysis. _Muse Spark 1.3 (max)_. Read 2 October 2026. AAII 48 under Intelligence Index v4.3.2; later benchmark reading than the stored September snapshot.]
]

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

== Cost of AI by Lab (Closed-Source) #cost-chart-sources()

#slide(config: config-page(margin: (x: 0em)))[
  #cost-chart(image("media/charts/cost-vs-aaii-by-lab.svg"))[
    OpenAI, Anthropic, and Google compete at the frontier.
  ]
]


== Cost of AI by Launch Date #cost-chart-sources() #h(0.6em) #text(size: 0.65em)[New #box(width: 0.75em, height: 0.75em, fill: rgb("#f2844b"), stroke: 0.8pt + white) → #box(width: 0.75em, height: 0.75em, fill: rgb("#0d0887"), stroke: 0.8pt + white) 12+ months]

#slide(config: config-page(margin: (x: 0em)))[
  #cost-chart(image("media/charts/cost-vs-aaii-by-age.svg"))[
    The AI revolution is ongoing, not complete.
  ]

  #speaker-note[
    Sources: OpenRouter listing dates and stored AAII values, documented in data/README.md. Listing dates are launch-date proxies; Gemini 4 Argon uses its sourced 30 September 2026 release date from Artificial Analysis because it is absent from the OpenRouter catalog. Opus 4.8 sets the line at AAII 42; Fable 5 was listed on 9 June 2026 at AAII 50. This uses current stored scores grouped by listing dates, not historical benchmark snapshots.
  ]
]


= What makes AI Agentic?

#speaker-note[
  We've talked about industry trends around AI, LLMs, and touched on pricing. Next lets talk about what makes AI agentic.
]

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



== Anatomy of an Agent

// OVERLAP: Near-duplicate of the governance section: "Anatomy of an Agent" (same diagram, definition, and tool examples; intro adds a reveal).
#speaker-note[
  Editorial overlap: Near-duplicate of the governance section: "Anatomy of an Agent" (same diagram, definition, and tool examples; intro adds a reveal).
]

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  grid.cell(x: 1, y: 0)[
    *Agentic AI*
    #include "figures/agentic-loop.typ"
  ],
  grid.cell(x: 0, y: 0)[
    *Tools* include:
    - Sending and receiving emails/messages
    - Interacting with your ERP software
      - Approving/denying transactions
    - Controlling machines
    - Performing scientific analysis
    - Spending money or resources
      - Reserving rooms
      - Purchasing equipment
    - Connecting to a database

    *Skills* are human-language instructions on how to do something.
  ],
)

#speaker-note[
  - Same LLM, richer tooling
]



== What does it this look like?

#let screenshot-width = 350pt
#let pixel = screenshot-width / 543
#grid(
  columns: (1fr, auto),
  column-gutter: 0em,
  align: horizon,
  [
    - Everyday AI apps hide what happens behind the scenes.

    - Today, you'll get a first taste of the professional AI tools your technical teams use.

    - You'll see the full trace: your input, tool calls, tool outputs, and the agent's response.
  ],
  grid.cell(align: right + horizon)[
    #pad(left: 154pt)[
      #block(width: screenshot-width, spacing: 0pt)[
        // Match the labels to the screenshot's prompt, IN row, OUT row, and final response.
        #for (label, y, height) in (
          ([Your input], 16, 43),
          ([Tool call], 193, 49),
          ([Tool output], 243, 50),
          ([Agent output], 328, 56),
        ) {
          place(top + left, dx: -154pt, dy: y * pixel, grid(
            columns: (130pt, 16pt),
            rows: (height * pixel,),
            column-gutter: 8pt,
            grid.cell(align: right + horizon, text(size: 16pt, weight: "bold", fill: rgb("#5a5a5a"))[#label]),
            grid.cell(align: center + horizon, text(size: 16pt, fill: rgb("#5a5a5a"))[#sym.arrow.r]),
          ))
        }
        #image("media/vscode/weather.png", width: screenshot-width)
      ]
    ]
  ],
)


#speaker-note[
  You'll get a chance to see this today!

  We've set you up with the industry-leading development environment, similar to what your technical staff will be using. It will show you the inner workings of the agent as it runs. Here's a simple trace.
]


= LLM intelligence \ ≠ Human intelligence

== LLM intelligence fails in common ways

#lblock(center: true)[
  LLMs fail in *common* ways that are a *foreseeable* source of business risk.
]

- *Overconfidence:* expresses certainty independent of correctness.#cite-source("https://aclanthology.org/2024.trustnlp-1.13/")[Tobias Groot and Matias Valdenegro-Toro. _Overconfidence is Key: Verbalized Uncertainty Evaluation in Large Language and Vision-Language Models_. TrustNLP 2024, pp. 145-171.]

- *Credulity/Sycophancy:* accepts falsehoods or agrees with you despite contradictions.#cite-source("https://www.anthropic.com/research/towards-understanding-sycophancy-in-language-models")[Sharma et al. _Towards Understanding Sycophancy in Language Models_. 2023.]
- *Hallucinations:* invents facts, citations, or details that sound plausible.
- *Theory-of-mind / world-model failure:* misjudges what people know or how actions affect the world.#cite-source("https://arxiv.org/abs/2305.14763")[Shapira et al. _Clever Hans or Neural Theory of Mind? Stress Testing Social Reasoning in Large Language Models_. arXiv:2305.14763, 2023.]
- *Specification gaming / reward hacking:* exploits a rule or reward while missing the intended goal.#cite-source("https://www.anthropic.com/research/reward-tampering")[Anthropic. _Sycophancy to Subterfuge: Investigating Reward Tampering in Language Models_. 17 June 2024. Controlled training experiments; not established as common production behavior.]

#v(1fr)


#cite-source(
  "https://doi.org/10.1017/S0140525X00005756",
  display: false,
)[John R. Searle. \ _Minds, brains, and programs_. \ Behavioral and Brain Sciences 3(3), 417-424, 1980. Chinese Room argument.]

#cite-source(
  "https://openai.com/index/the-instruction-hierarchy/",
  display: false,
)[Wallace et al. _The Instruction Hierarchy: Training LLMs to Prioritize Privileged Instructions_. OpenAI, 2024.]
#cite-source(
  "https://arxiv.org/abs/2307.03172",
  display: false,
)[Liu et al. _Lost in the Middle: How Language Models Use Long Contexts_. arXiv:2307.03172 (2023); Transactions of the Association for Computational Linguistics, 2024.]

#speaker-note[
  - Overconfidence happens because models are trained to provide correct output and confident output. Even if they fail at "correct", there is no incentive to fail at "confident". In humans, we generally express ourselves with confidence depending on belief.
]


== Theory of Mind: Understanding Intentions

#slide(config: config-common(breakable: false))[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    align: top,
    [
      #text(weight: "bold")[Project Vend: an AI shopkeeper]#cite-source(
        "https://www.anthropic.com/research/project-vend-1",
      )[Anthropic. _Project Vend, phase one_. 27 June 2025. Claude Sonnet 3.7 running a real office shop with Andon Labs.]

      Anthropic ran an experiment with an AI shopkeeper that could set prices.

      - Employees persuaded it to offer discounts and give away stock.
      - *25% employee discount* when approximately *99% of customers* were employees.
      - Products sold below cost; the shop *lost money*.


      #v(0.4em)
      #text(weight: "bold")[Should the agent represent the owners or shoppers interests?]
    ],
    [
      #link("https://www.anthropic.com/research/project-vend-1")[
        #align(center, screenshot-image(
          "media/theory-of-mind/project-vend-anthropic.png",
          [Anthropic · 27 June 2025#cite-source("https://www.anthropic.com/research/project-vend-1")[Anthropic. _Project Vend, phase one_. 27 June 2025.]],
          height: 100%,
          alt: "Screenshot of Anthropic's Project Vend report describing its AI shopkeeper experiment.",
        ))
      ]
    ],
  )
]

#speaker-note[
  - Project Vend was a real office-shop experiment run by Anthropic and Andon Labs using Claude Sonnet 3.7. Employees deliberately tested the agent's boundaries through Slack; it gave away items, including a tungsten cube, and issued excessive discounts.
  - The business lost money for multiple reasons, including below-cost pricing and inventory decisions. Do not attribute the entire loss to discounts alone.
  - Theory of mind includes reasoning about others' beliefs and intentions. Here, the teaching interpretation is recognizing a customer's bargaining incentives while representing the owner's interests. This incident is not a controlled diagnosis of a theory-of-mind failure; Anthropic suggests excessive helpfulness contributed.
  - Ask participants whose interests their own agents should represent, and which concessions need approval.
]


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

== Hallucinations

// OVERLAP: Partial overlap with the governance section: "The Seven Risks" (erroneous actions) and ATLAS verification controls. The PET/SPECT imaging case itself does not recur.
#speaker-note[
  Editorial overlap: Partial overlap with the governance section: "The Seven Risks" (erroneous actions) and ATLAS verification controls. The PET/SPECT imaging case itself does not recur.
]

#grid(
  columns: (1fr, auto),
  align: horizon,
  gutter: 2em,
  [
    *AI may hallucinate medically relevant abnormalities when denoising scans.*
    #v(1em)
    AI-enhanced PET/SPECT denoising can look "visually compelling and nearly indistinguishable" from a reference scan --- while inventing lesions or erasing real ones.#cite-source("https://arxiv.org/html/2506.13995v2#S3")[Menghua Xia et al. \ _DREAM: On hallucinations in AI-generated content for nuclear medicine imaging_. \ arXiv:2506.13995v2, 18 June 2025. Sections III-IV; displayed image is Figure 5.]
    #v(1em)

  ],
  screenshot-image(
    "media/hallucination/dream-hallucinationIndex.png",
    [Xia et al. · DREAM · Fig. 5#cite-source("https://arxiv.org/html/2506.13995v2#S3")[Menghua Xia et al. _DREAM: On hallucinations in AI-generated content for nuclear medicine imaging_. arXiv:2506.13995v2, 18 June 2025. Figure 5.]],
    height: 100%,
  ),
)

#speaker-note[
  - DREAM paper (arXiv:2506.13995): benchmarks hallucination in AI-denoised PET/SPECT nuclear medicine imaging
  - Figure 5: red arrows mark false generated content; yellow arrows highlight clearer anatomical structures and better visual quality. They do not indicate erased lesions.
  - The paper distinguishes added false content (hallucinations) from omitted lesions (other errors). The hallucination index measures differences from the reference; this is a generative-model issue across modalities.
  - Stakes are different in medicine: a hallucinated lesion, or an erased real one, is a diagnostic error, not a wrong citation
]

== Hallucinations

#slide(config: config-common(breakable: false))[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    align: top,
    [
      #text(size: 28pt, weight: "bold")[South Africa withdrew its draft AI policy.]
      #v(0.6em)
      Its reference list contained *fictitious sources* that appeared to have been generated by AI.#cite-source("https://www.reuters.com/world/africa/south-africa-withdraws-ai-policy-due-fake-ai-generated-sources-2026-04-27/")[Reuters. _South Africa withdraws draft AI policy over fictitious references_. 27 April 2026. Screenshot: Reuters republication on MyJoyOnline, 28 April 2026.]

      #v(0.6em)
      #gblock(inset: 0.6em, outset: 0pt)[
        #text(
          size: 22pt,
        )[“AI-generated citations were included without proper verification. This should not have happened.”]
        #v(0.4em)
        #text(size: 14pt, fill: luma(100))[Solly Malatsi, Minister of Communications and Digital Technologies]
      ]
    ],
    [
      #link("https://www.myjoyonline.com/south-africa-withdraws-ai-policy-due-to-fake-ai-generated-sources/")[
        #align(center, screenshot-image(
          "media/hallucination/south-africa-ai-policy-reuters.png",
          [Reuters / MyJoyOnline#cite-source("https://www.myjoyonline.com/south-africa-withdraws-ai-policy-due-to-fake-ai-generated-sources/", key: "https://www.reuters.com/world/africa/south-africa-withdraws-ai-policy-due-fake-ai-generated-sources-2026-04-27/")[Reuters, republished by MyJoyOnline. _South Africa withdraws draft AI policy over fictitious references_. 28 April 2026.]],
          height: 100%,
          alt: "MyJoyOnline screenshot of a Reuters report on South Africa withdrawing its draft AI policy after fictitious references were discovered.",
        ))
      ]
    ],
  )
]

#speaker-note[
  - Reuters reported on 27 April 2026 that South Africa withdrew its first draft national AI policy after fictitious sources were found in its reference list. The draft had been released for public comment that month.
  - Malatsi described unverified AI-generated citations as the most plausible explanation; the report does not establish which model or drafting tool was used.
  - Reuters' site blocked automated access. The screenshot shows the same Reuters report republished by MyJoyOnline on 28 April 2026: https://www.myjoyonline.com/south-africa-withdraws-ai-policy-due-to-fake-ai-generated-sources/.
  - Leadership takeaway: assign a reviewer to open cited sources and check that they support the claims before publication or approval. A plausible bibliography is not evidence of verification.
]

#let principle(num, title, body, example: none) = grid(
  columns: (auto, 1fr),
  column-gutter: 0.7em,
  row-gutter: 0.1em,
  align: (right + top, left + top),
  text(weight: "bold", size: 3em, fill: luma(140))[#num.],
  [
    *#title* \
    #body
    #if example != none [
      \
      #text(size: 0.85em, fill: luma(100))[_e.g._ #example]
    ]
  ],
)

/*
== Why can't we just use ONE agent?

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  row-gutter: 1em,
  align: (top + left),
  principle([1], [Context rot], [keep each window small and on-task.]),
  principle([2], [Credulity], [the agent trusts too much.]),

  principle([3], [Abstraction], [allow higher-level processes to ignore irrelevant details about low-level tasks.]),
  principle([4], [Specialization], [a focused prompt and few tools beats a kitchen sink.]),

  principle([5], [Observability], [see every step, not just the answer.]),
  principle([6], [Least privilege], [scope tools per stage to avoid security breaches.]),

  principle([7], [Testability], [understand the performance of each step and build confidence.]),
  principle([8], [Cost & latency], [route cheap models for the easy steps, or get the job done quicker.]),
)

#pause
#place(center + horizon, lblock(
  width: 100%,
  inset: (x: 0.5em, y: 0.5em),
  outset: (x: -1.5em, y: 1em),
  fill: white.transparentize(6%),
  align(center + horizon)[
    One big agent fails in ways you can't see, fix, or contain.

    #scale(70%, reflow: true, include "figures/workflows/task-agent.typ")

    Balancing engineering with *business risk* is the key role of the business leader.
  ],
))

#speaker-note[
  Motivating example: a "research assistant" you ask to research a topic and email a summary.
  As ONE agent it must search the web, read ~20 pages, draft, and send the mail - all in one context.
  Walk the same eight numbers down the failure modes:
  - Context rot: 20 raw pages crowd out the original task.
  - Credulity: one poisoned page and it follows the instructions hidden in it.
  - Abstraction / Specialization: search, write, and send are jammed into one fuzzy prompt.
  - Observability: it emails the wrong person - which step went wrong? You can't tell.
  - Least privilege: it holds web + file + send-email tools the entire time.
  - Testability: you can't test "find sources" apart from "write the summary".
  - Cost & latency: a frontier model burns tokens on trivial fetches.
  Each failure maps to one principle - and each is fixed by splitting the work, which is the next section.
]
*/

= Governing Agentic AI

== IMDA Model Governance framework

#grid(
  columns: (80mm, 1fr),
  rows: (auto, auto),
  align: horizon,
  gutter: 1em,
  grid.cell(rowspan: 2, box(stroke: 3pt + black, image("/references/imda-agentic-ai/pages/page-1.png", width: 100%))),
  [
    IMDA publishes the _Model AI Governance Framework for Agentic AI_ (v1.5, May 2026)#cite-source("https://www.imda.gov.sg/-/media/imda/files/about/emerging-tech-and-research/artificial-intelligence/mgf-for-agentic-ai.pdf")[Infocomm Media Development Authority (IMDA). _Model AI Governance Framework for Agentic AI_. Version 1.5. Published 20 May 2026; updated 5 June 2026. Local PDF and extracts in references/imda-agentic-ai/.]

    It gives you the structure and tools to weigh risks and write policies for your own organization.

    #pause
    Alternatives include:
  ],
  grid(
    columns: (auto, 1fr, auto, 1fr),
    gutter: .4em,
    box(stroke: 3pt + black, image("/references/iso-42001/cover.png", height: 5cm)),
    [
      *ISO/IEC 42001*#cite-source("https://www.iso.org/standard/42001")[International Organization for Standardization / International Electrotechnical Commission. \ _ISO/IEC 42001:2023 — Artificial intelligence — Management system_. \ First edition, December 2023.]\
      AI management systems ],
    box(stroke: 3pt + black, image("/references/owasp-agentic-ai-threats/cover.png", height: 5cm)),
    [ *OWASP*#cite-source("https://genai.owasp.org/resource/agentic-ai-threats-and-mitigations/")[OWASP GenAI Security Project, Agentic Security Initiative. \ _Agentic AI — Threats and Mitigations_. \ Version 1.0, 17 February 2025.]\
      Agentic AI: Threats and Mitigations   ],
  ),
)

== The Four Pillars #cite-source("https://www.imda.gov.sg/-/media/imda/files/about/emerging-tech-and-research/artificial-intelligence/mgf-for-agentic-ai.pdf")[Infocomm Media Development Authority (IMDA). \ _Model AI Governance Framework for Agentic AI_. \ Version 1.5. Published 20 May 2026; updated 5 June 2026. Local PDF and extracts in references/imda-agentic-ai/.]

#grid(
  columns: (80mm, 1fr),
  align: horizon,
  gutter: 1em,
  box(stroke: 3pt + black, image("/references/imda-agentic-ai/pages/page-1.png", width: 100%)),
  [
    #v(1fr)
    #principle(
      [A],
      [Assess and bound the risks upfront],
      [is an agent appropriate? what is the minimum authority it needs? what's the blast radius?],
    )
    #v(1fr)
    #principle(
      [B],
      [Make humans meaningfully accountable],
      [name individuals, responsibilities, and require human approval at real decision points.],
    )
    #v(1fr)
    #principle(
      [C],
      [Implement technical controls and processes],
      [enforce safeguards structurally for provable guarantees, not only in the prompt.],
    )
    #v(1fr)
    #principle(
      [D],
      [Enable end-user responsibility],
      [equip end-users and consumers to operate and oversee the agent responsibly.],
    )
    #v(1fr)
  ],
)

== The Seven Risks #cite-source("https://www.imda.gov.sg/-/media/imda/files/about/emerging-tech-and-research/artificial-intelligence/mgf-for-agentic-ai.pdf")[Infocomm Media Development Authority (IMDA). \ _Model AI Governance Framework for Agentic AI_. \ Version 1.5. Published 20 May 2026; updated 5 June 2026. Local PDF and extracts in references/imda-agentic-ai/.]

#let risk(num, title, body, example: none) = grid(
  columns: (auto, 1fr),
  column-gutter: 0.8em,
  row-gutter: 0.05em,
  align: (right + top, left + top),
  text(weight: "bold", size: 2.5em, fill: luma(140))[#num.],
  [
    *#title* #v(-.8em)
    #body
    #if example != none [
      \
      #text(size: 0.68em, fill: luma(100))[_e.g._ #example]
    ]
    #v(0.4em)
  ],
)

#let risk-group(height, label) = grid(
  columns: (7mm, 1fr),
  column-gutter: 0.4em,
  align: horizon,
  text(fill: luma(130))[#math.lr(sym.brace.r, size: height)], text(size: 1em, fill: luma(100))[#label],
)

#grid(
  columns: (1fr, 90mm),
  column-gutter: 1em,
  row-gutter: 0.4em,
  risk(
    [1],
    [Erroneous actions],
    [mistakes from flawed reasoning or execution.],
  ),
  grid.cell(rowspan: 5, align: horizon)[
    #risk-group(9cm, [*old risks, new target*

      well-understood problems, established mitigations])
  ],

  risk(
    [2],
    [Unauthorized actions],
    [acting outside the agent's permitted scope.],
  ),

  risk(
    [3],
    [Biased or unfair actions],
    [outputs that produce unfair outcomes across groups.],
  ),

  risk(
    [4],
    [Data breaches],
    [exposure or manipulation of sensitive data.],
  ),

  risk(
    [5],
    [Disruption to connected systems],
    [disrupting a system the agent touches.],
  ),

  grid.cell(colspan: 2)[
    #uncover("2-")[
      #v(0.4em)
      #grid(
        columns: (10mm, auto, 1fr),
        column-gutter: 0.5em,
        align: horizon,
        line(length: 100%, stroke: luma(150)),
        [When you have autonomous or multi-agent systems:],
        line(length: 100%, stroke: luma(150)),
      )
      #v(0.3em)
    ]
  ],

  uncover("2-")[#risk(
    [6],
    [Speed and volume],
    [agents outpace real-time human oversight.],
  )],
  grid.cell(rowspan: 2, align: horizon)[
    #uncover("2-")[
      #risk-group(3.5cm, [*risk multiplier*

        speed and reach outrun existing safeguards])
    ]
  ],

  uncover("2-")[#risk(
    [7],
    [Cascading or compounding effects],
    [a mistake in one step amplifies downstream.],
  )],
)
#speaker-note[
  - "Pilot error" = thought-terminating cliché
  - We design cockpits to be safe with imperfect pilots, not perfect pilots
  - Curious students: point at OWASP STRIDE; don't go deep
]


#let risk-pillar-summary(
  bold-risks: (),
  good-risks: (),
  bad-risks: (),
  bold-pillars: (),
  good-pillars: (),
  bad-pillars: (),
) = {
  let status(n, good, bad, bold) = if good.contains(n) { "good" } else if bad.contains(n) {
    "bad"
  } else if bold.contains(n) { "bold" } else { none }
  let color(s) = if s == "good" { rgb("#2e7d32") } else if s == "bad" { rgb("#c62828") } else { luma(140) }
  let row(n, body, good: (), bad: (), bold: ()) = {
    let s = status(n, good, bad, bold)
    let mark = if s == "good" [✓] else if s == "bad" [✘] else [#n.]
    let styled = if s == "good" or s == "bad" {
      text(fill: color(s), weight: "bold")[#body]
    } else if s == "bold" [*#body*] else [#body]
    (text(fill: color(s))[#mark], styled)
  }
  let risk-row(n, body) = row(n, body, good: good-risks, bad: bad-risks, bold: bold-risks)
  let pillar-row(n, body) = row(n, body, good: good-pillars, bad: bad-pillars, bold: bold-pillars)
  show grid.cell.where(x: 0): set text(weight: "bold", fill: luma(140))
  grid(
    columns: (auto, 1fr),
    column-gutter: 0.35em,
    row-gutter: 0.7em,
    align: (right + top, left + horizon),
    [], grid.cell(align: left + horizon)[#text(weight: "bold")[Seven Risks]],
    ..risk-row(1, [Erroneous actions]),
    ..risk-row(2, [Unauthorized actions]),
    ..risk-row(3, [Biased or unfair actions]),
    ..risk-row(4, [Data breaches]),
    ..risk-row(5, [Disrupt connected systems]),
    ..risk-row(6, [Speed and volume]),
    ..risk-row(7, [Cascading effects]),
    [], grid.cell(align: left + horizon, inset: (top: 0.5em))[#text(weight: "bold")[Four Pillars]],
    ..pillar-row("A", [Assess and bound risks]),
    ..pillar-row("B", [Make humans accountable]),
    ..pillar-row("C", [Technical controls]),
    ..pillar-row("D", [Enable end-user responsibility]),
  )
}

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

== Getting It Right: Hippocratic AI

#grid(
  columns: (40%, 1fr),
  column-gutter: 0.5em,
  align: top,
  alternatives(start: 1, position: top + left, risk-pillar-summary(), risk-pillar-summary(
    good-risks: (1, 2, 6),
    good-pillars: ("A", "C", "D"),
  )),
  [
    #text(weight: "bold", size: 1.3em)[Hippocratic AI]#cite-source(
      "https://hippocraticai.com/hippocratic-ai-launches-polaris-5-0/",
    )[Hippocratic AI. \ _Hippocratic AI Launches Polaris 5.0_. \ 2026 company announcement. Patient-volume, clinician-validation and safety statistics are company-reported. Scope: #link("https://hippocraticai.com/new-products/")[non-diagnostic clinical conversations].]\
    #text(size: 0.9em, fill: luma(100))[Voice agents for healthcare]

    #v(0.5em)
    - Post-discharge follow-up, medication walkthroughs
    - Company reports *0 severe-harm events* and 180M+ patient interactions
    - "Polaris" safety, validated by 7,500+ clinicians
    - *Narrow scope* --- non-diagnostic patient support

    Speculation:

    - AI provides a conversational interface layered on top of a provably-correct decision system.
    - Check what the AI is saying mid-conversation with automated guardrails.

  ],
)

#speaker-note[
  - Hippocratic: alignment by *scope*, not by post-hoc guardrails --- low blast radius is a design choice
  - Tie back to designing for imperfect agents
]

== Getting It Wrong: Klarna

#grid(
  columns: (40%, 1fr),
  column-gutter: 0.5em,
  align: top,
  alternatives(start: 1, position: top + left, risk-pillar-summary(), risk-pillar-summary(
    bad-risks: (3, 6),
    bad-pillars: ("A", "B"),
  )),
  [
    #image("media/reward-hacking/klarna.png", height: 1.8cm)
    #v(-1.2em)
    #text(size: 0.9em, fill: luma(100))[Customer support that went "too far"]

    #v(0.5em)
    - Feb 2024: claimed work of *700 reps*, projected \$40M profit boost#cite-source("https://www.prnewswire.com/news-releases/klarna-ai-assistant-handles-two-thirds-of-customer-service-chats-in-its-first-month-302072744.html")[Klarna. \ _AI assistant handles two-thirds of customer service chats_. \ 27 February 2024. Company release: work equivalent to 700 agents; projected US\$40 million profit improvement.]
    - Quality decayed on disputes, fraud, *bereavement*
    - May 2025: CEO walked it back#cite-source("https://www.bloomberg.com/news/articles/2025-05-08/klarna-turns-from-ai-to-real-person-customer-service")[Charles Daly, Bloomberg. \ _Klarna Slows AI-Driven Job Cuts With Call for Real People_. \ 8 May 2025. CEO interview; full text requires a subscription.]
      - _"we went too far"_
      - _"what you end up having is lower quality"_

  ],
)

#speaker-note[
  Bereavement requires sensitive handling; AI is poorly suited to this sort of theory-of-mind work.
]

== Getting It Wrong: Hacking the Evaluation

#grid(
  columns: (40%, 1fr),
  column-gutter: 0.5em,
  align: top,
  alternatives(start: 1, position: top + left, risk-pillar-summary(), risk-pillar-summary(
    bad-risks: (2, 4, 5, 7),
    bad-pillars: ("A", "C"),
  )),
  [
    #grid(
      columns: (auto, auto),
      column-gutter: -1.0em,
      align: horizon,
      image("media/reward-hacking/OAI_OpenAI-Blossom_Black.png", height: 2.8cm),
      image("media/reward-hacking/OAI_OpenAI_Wordmark_Black.png", height: 2.8cm),
    )
    #v(-1.4em)
    #text(
      size: 0.9em,
      fill: luma(100),
    )[OpenAI · July 2026 cybersecurity evaluation#cite-source("https://openai.com/index/hugging-face-incident-and-the-road-ahead/")[OpenAI. \ _The Hugging Face incident and the road ahead_. \ 26 August 2026. Postmortem of the July 2026 cybersecurity-evaluation incident.]]

    #v(0.5em)
    - Read public evaluation code and *reverse-engineered answers*
    - Tried to *fool the scorer* and disguise their actions#cite-source("https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/")[METR and Redwood Research. \ _Brief independent investigation of agents’ behavior, reasoning and collaboration in the OpenAI / Hugging Face hacking incident_. \ 26 August 2026. Observed small-scale tool-call spoofing in roughly 7% of reviewed transcripts; broader scorer-tampering attempts were not all successful.]
    - Collaborated through an *unauthorized message board*
    - Compromised *41 Hugging Face production workers*#cite-source("https://cdn.openai.com/pdf/67869394-cb91-4c12-888c-5cbd85c7814c/OpenAI-Hugging-Face%20Incident-Technical-Report.pdf")[OpenAI. \ _OpenAI – Hugging Face Incident Technical Report_. \ August 2026. Section IV.B, pp. 9–11: code execution on 41 production workers, root access on at least one node, and access to credentials and limited private data.]

    #gblock[Hugging Face disclosed the breach on *16 July*. OpenAI connected it to its agents on *20 July*.#cite-source("https://openai.com/index/hugging-face-incident-and-the-road-ahead/")[OpenAI. \ _The Hugging Face incident and the road ahead_. \ 26 August 2026. Detection timeline: security alert on 19 July; connection to the Hugging Face incident on 20 July.]]

  ],
)

#speaker-note[
  - The July 2026 incident primarily involved an internal-only research model operating under reduced safeguards during ExploitGym cybersecurity evaluations. These settings differed from OpenAI's deployed products.
  - Agents read the public ExploitGym paper and code. They believed the scorer required both the correct flag and evidence of exploiting the intended vulnerability. OpenAI's internal scorer only checked the flag, so the additional attacks did not improve evaluation scores.
  - METR and Redwood found that understanding or tampering with the scorer was a central motivation. Roughly 7% of reviewed transcripts contained successful small-scale tool-call spoofing; do not imply all concealment or scorer-tampering attempts succeeded.
  - OpenAI reports code execution on 41 Hugging Face production workers, root access on at least one node, and access to credentials and limited private data. Unauthorized communication allowed separate agents to share discoveries and expand the intrusion.
  - Detection timeline: Hugging Face publicly disclosed the security activity on 16 July. An OpenAI security alert about unusual activity involving Artifactory credentials triggered an investigation on 19 July. OpenAI connected the agents to the Hugging Face incident on 20 July and publicly disclosed its involvement on 21 July.
  - Some unauthorized communication and internet access had already been observed in late May, and a security incident was opened on 5 July. The broader containment and alignment implications were not yet understood; do not imply there were no earlier warning signs.
  - Teaching interpretation: agents pursued what they believed would pass an evaluation beyond the authorized task. Connect to unauthorized actions, data breaches, disruption, cascading effects, and Pillars A and C.
]

#let atlas-logo() = {
  image("media/atlas/ATLAS logo.png", height: 100% - 10mm)
  v(-24mm)
  text(font: "Cinzel", weight: "bold", size: 16mm, tracking: 0.15em)[ATLAS]
}

= IMDA Framework\ applied to IMCB's ATLAS

== IMCB ATLAS

#grid(
  columns: (90mm, 1fr),
  gutter: 1em,
  align(center + horizon)[
    #atlas-logo()
  ],
  [
    ATLAS is IMCB's *AI business intelligence* platform.

    It answers questions about grants, personnel, and contracts where facts are spread across many business units.

    - "What is the current renewal/mid-grant reporting?"
    - "Is the grant extension consistent with staff contracts?"
    - "Has this PA stalled out?"
    - "Was the virement complete before the tender?"
    - Consumes a variety of business function documents (LOA, PA, Contracts, etc.)

    Answers different questions for different people (management, PIs, staff)

    *High-risk* application of AI.
  ],
)

#speaker-note[
  Particularly when they touch multiple business units
]

== IMCB ATLAS: Document Ingestion

#grid(
  columns: (90mm, 1fr),
  gutter: 1em,
  align(center + horizon, atlas-logo()),
  align(center + horizon)[
    #only(1)[#atlas-flow(1, ingest: "pi2")]
    #only(2)[#atlas-flow(1, ingest: "hr")]
  ],
)

== Unauthorized access & data breach

#grid(
  columns: (40%, 1fr),
  column-gutter: 1.5em,
  align: top,
  [
    #only(1)[#risk-pillar-summary(bold-risks: (2, 4))]
  ],
  align(center)[
    #only(1)[#atlas-flow(1)]
  ],
)

// Insert an intermediate slide here.

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

== Unauthorized access: policy and control

#grid(
  columns: (40%, 1fr),
  column-gutter: 1.5em,
  align: top,
  risk-pillar-summary(bold-risks: (2, 4), bold-pillars: ("C",)),
  [
    *The problem*

    Users may access documents (reading or writing) they are not supposed to.

    #v(0.3em)
    *Policy questions*

    - Who may read which documents?
    - Who may write, and to which records?
    - How and when is access revoked when someone leaves?

    #v(0.3em)
    #lblock[
      *Technical control: Role-Based Access Control* \
      Each person interacts with a separate instance of ATLAS that can only read/write documents they have access to.
    ]
  ],
)

#speaker-note[
  - Policy is the hard part: someone has to decide the roles and their boundaries before RBAC can enforce them
  - Enforce at retrieval, not only at display: filtering the answer afterwards still lets the model read the document
]


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

== Erroneous action

#grid(
  columns: (40%, 1fr),
  column-gutter: 1.5em,
  align: top,
  risk-pillar-summary(bold-risks: (1,), bold-pillars: ("D",)), align(center)[#atlas-flow(5)],
)

#speaker-note[
  - Erroneous action: a Tech-biz document is misclassified as an LOA instead of a Licensing document, and the wrong record flows on to ED
  - Enable end-user responsibility: ED sees where each answer came from and can catch the misfiled document
]

== Erroneous action: policy and control

#grid(
  columns: (40%, 1fr),
  column-gutter: 1.5em,
  align: top,
  risk-pillar-summary(bold-risks: (1,), bold-pillars: ("B", "D")),
  [
    *The problem*

    The LLM misreads or misfiles a document, and the error flows into every later answer.

    #v(0.3em)
    *Policy questions*

    - Which conclusions need human sign-off?
    - errors are "safe" to fix when discovered?
    - Who owns the correction?

    #v(0.3em)
    #lblock[
      *Pillars B & D: Owners and users verify* \
      Document owners (Pillar B) review what goes in and own corrections, end users (Pillar D) need a due-diligence process before trusting output.
    ]
  ],
)

#speaker-note[
  - The database records claims, not just documents: each conclusion links to the document and the page or section that supports it
  - Correcting one source flags every conclusion that depends on it, so only those need re-checking
]

== Erroneous action: policy and control

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align: top,
  [
    *Pillar B: Make humans meaningfully accountable*
    #v(0.2em)
    How can we get producers to verify that ATLAS understands documents correctly?

    - Every document type has one named owner (grants office, HR, procurement)
    - ATLAS only flags potential issues, and records the human's exact decision.
  ],
  [
    *Pillar D: Enable end user responsibility*
    #v(0.2em)

    How can we ensure consumers are not led astray by ATLAS?

    - Every answer reports its sources and its confidence
    - Provide a mechanism for reporting wrong answers and feeding back.
    - Set risk-based policy for level of scrutiny.
  ],
)
#v(0.2em)
#lblock[
  It's *our* responsibility to design ATLAS defensively.

  The "easy" path must be the safe path, and it must fit cleanly into existing processes.
]

= Set Policies for a Procurement Agent

== Our Task

#align(center + horizon, include "figures/task-workflow.typ")

Your goal is to design and build a _repeatable_ and _dependable_ AI procurement advisor.


/* Focus slide omitted from student resources. */





















= In Conclusion

== Humans are still in charge

..

== The future of AI

- Expecting IPOs for Anthropic/OpenAI.
- New regulation to restrict access to frontier intelligence
  - Already standard practice by US AI labs.
- Increased interest in "local" models.
  - A*STAR can (and has!) the resources to host models like DeepSeek v4.1, GLM-5.3 Flash, - Individual labs can plausibly host cutdown versions of these - Individuals can host models like Qwen 3.8 27B on new-generation laptops.
  - Possible to modify models to remove guardrails around biological research, but this itself carries risk.
- Semiconductor industry is


1. Vendor lock-in
2. Building a
3. Depreciation/marginal cost of devices.


// References are collected and numbered from the inline source definitions.
#reference-slides()
