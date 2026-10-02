// Write the full reference at its point of use; numbering follows first use.
// Repeated URLs reuse the same number, including Touying overlay duplicates.
#import "@preview/touying:0.7.4": themes, config-common

#let citation-sources() = {
  let sources = ()
  for entry in query(<clm-source>) {
    let source = entry.value
    if not sources.any(existing => existing.key == source.key) {
      sources.push(source)
    }
  }
  sources
}

// display: false registers a source used only in the speaker notes.
// key can identify the same work when different section URLs are needed.
// Keep the output to ordinary metadata/content: Touying's speaker-note
// markers are not supported in headings or context-generated content.
#let cite-source(url, body, key: none, display: true) = {
  let key = if key == none { url } else { key }
  [#metadata((key: key, url: url, body: body))<clm-source>]
  if display {
    context {
      let sources = citation-sources()
      let index = sources.position(source => source.key == key)
      // A standalone layout measurement may precede metadata placement.
      if index != none {
        link(url, super(str(index + 1)))
      }
    }
  }
}

// No source markers are emitted here, so the query cannot grow itself.
// Breakable slides paginate the collected references without fixed ranges.
#let reference-slides() = themes.metropolis.slide(
  title: [References],
  align: top,
  config: config-common(breakable: true),
)[
  #set text(size: 18pt)
  #set par(leading: 0.4em)
  #context {
    for (index, source) in citation-sources().enumerate() {
      block(breakable: false, below: 12pt, grid(
        columns: (26pt, 1fr),
        column-gutter: 8pt,
        align: top,
        text(weight: "bold")[#(index + 1).],
        link(source.url, source.body),
      ))
    }
  }
]
