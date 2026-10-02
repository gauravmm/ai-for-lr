---
name: slide
description: Explain the course slides, answer /slide followed by a number, or search the presentation for a concept such as agent risks, hallucinations, or governance. Use the bundled slide images, rendered text, and Typst source.
---

# Course slides

Use the bundled presentation material to explain a slide or answer requests such as “Check the slides and explain XYZ concept to me.” Resources live next to this skill in [resources/](resources/index.md); resolve paths relative to this skill directory even when it is installed through a link.

- For `/slide <number>`, open `resources/index.md` and find the number in its Slide column. Numbers match the presentation footer, not PDF page numbers.
- For a concept question, search `resources/search.md` or the `resources/page-*.txt` and `resources/page-*.typ` files with `rg` (or `grep`). The indexes link matching pages to their images and source excerpts. Open the images for the relevant slides to read diagrams, screenshots and charts; text extraction alone can miss their meaning.
- Read the rendered text and the corresponding `.typ` source for detail, citations and speaker notes. If an excerpt uses a helper, find its definition in `resources/sources/`. Excerpts are exact source blocks and can cover multiple pages; use the image to determine what is actually displayed.
- Each slide image shows its final state; intermediate animation steps and focus slides are omitted. Unnumbered title and section pages have their own entries in the index.
- Answer in plain language suitable for business leaders. Cite the deck and slide number and, when useful, link the local image. Distinguish what the slide says, the speaker notes, and your own explanation. Preserve uncertainty and source qualifications; a cited example is not proof of a universal rule.

If the requested number or concept is absent, say what you searched and identify the nearest relevant slides. If `resources/index.md` is missing, the instructor needs to rebuild the presentation with `./compile.sh`; do not invent slide contents.
