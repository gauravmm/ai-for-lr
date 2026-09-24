# Template and engine limits

The package supports three source slide archetypes with text and existing bar shapes. It rebuilds the output by importing one source slide, so it does not edit a slide in place in a larger deck. Preserve corporate theme and masters in the source PPTX. The source slide must contain every named shape described by `inspect`; complex content should live on source slides, not only in layouts.

Animations, embedded objects, unusual media, hyperlinks, extended charts, and relationship-bearing shapes are outside the allowlist. Editing such shapes may damage the package. Choose an approved archetype or have a human curate another template slide, then update the wrapper's allowlist and revalidate. The engine's published compatibility testing centers on PowerPoint 2019; test the actual distributed template in the target PowerPoint version before workshop use.

`validate` checks OOXML package structure, required shape names, bounds, simple text capacity, semantic content, source notes, slide count, and PDF renderability when LibreOffice is available. It cannot prove visual legibility in every font environment or that a procurement claim is true. Review the rendered PDF at presentation size.
