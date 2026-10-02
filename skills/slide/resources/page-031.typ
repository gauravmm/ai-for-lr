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
