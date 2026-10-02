// Shared helpers for the slide decks in this repository.
#import "@preview/touying:0.7.4": *
#import themes.metropolis: *

#let attribution-style(body) = text(size: 0.65em, fill: luma(100), body)

// Mark focus pages so the student resource exporter can omit them.
#let focus-slide(config: (:), align: horizon + center, body) = themes.metropolis.focus-slide(
  config: config,
  align: align,
  [#metadata(none)<slide-export-focus>#body],
)

#let big-section-slide(config: (:), level: 1, numbered: true, body) = touying-slide-wrapper(self => {
  let slide-body = {
    set std.align(horizon)
    show: pad.with(x: 12%, y: 20%)
    set text(size: 1.9em)
    let section-number = text(weight: "bold", size: 3em, fill: luma(160))[
      #utils.display-current-heading(
        level: level,
        numbered: numbered,
        style: (setting: body => body, numbered: true, current-heading) => setting({
          if numbered and current-heading.numbering != none {
            numbering(
              current-heading.numbering,
              ..counter(heading).at(current-heading.location()),
            )
          }
        }),
      )
    ]
    let section-title = utils.display-current-heading(
      level: level,
      numbered: numbered,
      style: (setting: body => body, numbered: true, current-heading) => setting(
        current-heading.body,
      ),
    )
    grid(
      columns: (1fr, 16cm, 1fr),
      column-gutter: .8em,
      align: (right + bottom, left + bottom),
      section-number,
      stack(
        dir: ttb,
        spacing: .3em,
        text(self.colors.neutral-darkest, section-title),
        block(
          height: 2pt,
          width: 100%,
          spacing: 0pt,
          components.progress-bar(height: 2pt, self.colors.primary, self.colors.primary-light),
        ),
      ),
    )
    text(self.colors.neutral-dark, body)
  }
  self = utils.merge-dicts(self, config-page(fill: self.colors.neutral-lightest))
  touying-slide(self: self, config: config, slide-body)
})

#let gblock(body, inset: (x: 0em, y: 0.4em), outset: (x: 0.4em, y: 0.4em), width: 100%) = block(
  fill: luma(235),
  inset: inset,
  outset: outset,
  radius: 0.4em,
  width: width,
)[#body]

#let lblock-center = center
#let lblock(
  body,
  inset: (x: 0em, y: 0.4em),
  outset: (x: 0.4em, y: 0.4em),
  width: 100%,
  fill: white,
  center: false,
) = block(
  fill: fill,
  stroke: 0.5pt + luma(220),
  inset: inset,
  outset: outset,
  radius: 0.4em,
  width: width,
)[
  #{
    if center {
      set align(lblock-center)
      body
    } else {
      body
    }
  }
]
