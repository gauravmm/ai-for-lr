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
