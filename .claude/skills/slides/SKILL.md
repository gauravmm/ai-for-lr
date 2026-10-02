---
name: slides
description: Explain the course slides, answer /slides followed by a number, or search the presentation for a concept such as agent risks, hallucinations, or governance. Use the bundled slide images, rendered text, and Typst source.
---

# Course slides

Use the bundled presentation material to explain a slide or answer requests such as “Check the slides and explain XYZ concept to me.” Resources live next to this skill in [resources/](resources/index.md); resolve paths relative to this skill directory even when it is installed through a link.

- For `/slides <number>`, open `resources/index.md` and find the number in its Slide column. Numbers match the presentation footer, not PDF page numbers.
- For a concept question, search `resources/search.md` or the `resources/page-*.txt` and `resources/page-*.typ` files with `rg` (or `grep`). The indexes link matching pages to their images and source excerpts. Open the images for the relevant slides to read diagrams, screenshots and charts; text extraction alone can miss their meaning.
- Read the rendered text and the corresponding `.typ` source for detail, citations and speaker notes. If an excerpt uses a helper, find its definition in `resources/sources/`. Excerpts are exact source blocks and can cover multiple pages; use the image to determine what is actually displayed.
- Each slide image shows its final state; intermediate animation steps and focus slides are omitted. Unnumbered title and section pages have their own entries in the index.
- Answers are read aloud to executives in a live workshop. Reply in about two short sentences of plain language, with no headings, lists or jargon. Leave out slide numbers, citations and image links unless asked. Do not suggest next steps or exercises that appear on later slides; the instructor reaches them after discussion. Stay faithful to the slides: keep their qualifications, and do not present a cited example as a universal rule.

If a concept is not in the slides, begin with "(Not found in the slides.)" and then give the same short answer from your own knowledge; search the web first when the answer depends on recent facts, such as prices, models or regulations, and never attribute that answer to the slides. If a slide number does not exist, say so and name the nearest slide. If `resources/index.md` is missing, the instructor needs to rebuild the presentation with `./compile.sh`; do not invent slide contents.
