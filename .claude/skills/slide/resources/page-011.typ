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
