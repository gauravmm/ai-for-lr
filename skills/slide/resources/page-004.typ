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
