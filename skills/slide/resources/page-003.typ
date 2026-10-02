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
