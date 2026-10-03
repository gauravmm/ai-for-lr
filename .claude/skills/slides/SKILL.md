---
name: slides
description: Explain the course slides, answer /slides followed by a number, or search the presentation for a concept such as agent risks, hallucinations, or governance. Use the bundled slide images and searchable slide summary.
---

# Course slides

Use the bundled presentation material to explain a slide or answer requests such as “Check the slides and explain XYZ concept to me.” Resources live next to this skill in [resources/slides.md](resources/slides.md); resolve paths relative to this skill directory even when it is installed through a link.

- For `/slides <number>`, find its `## Slide <number> ·` heading in `resources/slides.md`. Numbers match the presentation footer, not PDF page numbers. Open the linked slide image.
- For a concept question, search `resources/slides.md` with `rg` (or `grep`), then open the linked images for relevant slides. The summary contains rendered slide text; diagrams, screenshots and charts may contain details that text extraction misses.
- Read the image when the summary does not provide enough detail. The resources do not include slide sources or speaker notes.
- Each slide image shows its final state; intermediate animation steps and focus slides are omitted. Unnumbered title and section pages have their own headings in the summary.
- Answers are read aloud to executives in a live workshop. Reply in about two short sentences of plain language, with no headings, lists or jargon. Leave out slide numbers, citations and image links unless asked. Do not suggest next steps or exercises that appear on later slides; the instructor reaches them after discussion. Stay faithful to the slides: keep their qualifications, and do not present a cited example as a universal rule.

If a concept is not in the slides, begin with "(Not found in the slides.)" and then give the same short answer from your own knowledge; search the web first when the answer depends on recent facts, such as prices, models or regulations, and never attribute that answer to the slides. If a slide number does not exist, say so and name the nearest slide. If `resources/slides.md` is missing, the instructor needs to rebuild the presentation with `./compile.sh`; do not invent slide contents.
