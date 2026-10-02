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
