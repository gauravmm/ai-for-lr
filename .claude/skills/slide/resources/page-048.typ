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
