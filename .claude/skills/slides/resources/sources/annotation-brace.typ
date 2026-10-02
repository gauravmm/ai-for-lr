// Reusable annotation braces with a consistent 16pt width and 1.6pt stroke.
// Import with: #import "/annotation-brace.typ": annotation-brace
// Right brace: #annotation-brace(100pt, "#5a5a5a")
// Left brace: #annotation-brace(100pt, "#5a5a5a", direction: "left")
// Colors are SVG color strings; height is an absolute length.

#let annotation-brace(height, color, direction: "right") = {
  assert(direction in ("left", "right"), message: "Brace direction must be left or right.")
  let transform = if direction == "left" { " transform='translate(16 0) scale(-1 1)'" } else { "" }
  let h = height / 1pt
  let mid = h / 2
  let path = (
    "M 1 1 C 8 1 8 5 8 13 L 8 "
      + str(mid - 12)
      + " C 8 "
      + str(mid - 4)
      + " 11 "
      + str(mid)
      + " 15 "
      + str(mid)
      + " C 11 "
      + str(mid)
      + " 8 "
      + str(mid + 4)
      + " 8 "
      + str(mid + 12)
      + " L 8 "
      + str(h - 13)
      + " C 8 "
      + str(h - 5)
      + " 8 "
      + str(h - 1)
      + " 1 "
      + str(h - 1)
  )
  let svg = bytes(
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 "
      + str(h)
      + "'><path d='"
      + path
      + "'" + transform + " fill='none' stroke='"
      + color
      + "' stroke-width='1.6'/></svg>",
  )
  image(svg, width: 16pt, height: height)
}
