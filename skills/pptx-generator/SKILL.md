---
name: pptx-generator
description: Build one editable leadership decision slide from the supplied corporate PowerPoint template and a verified semantic slide plan. Use for Task 2 slide creation or revision; the tool does not verify procurement claims.
---

# Leadership slide generator

Use the supplied template and this package's commands. First inspect the template with `npm run inspect -- --template <path-to-template.pptx>`; choose an approved archetype and write a plan matching [slide-plan.schema.json](slide-plan.schema.json). A neutral valid plan and a deliberately invalid plan are in [examples](examples/). Keep every figure, status, and source locator tied to your verified Task 1 record.

Run `npm run build -- --template <path-to-template.pptx> --plan <plan.json> --output <new-slide.pptx>`, then `npm run validate -- --template <path-to-template.pptx> --plan <plan.json> --output <new-slide.pptx>`. The output is a new file; the template remains unchanged. With LibreOffice installed, validation also renders the slide to PDF; pass `--require-render` to require that check.

The plan accepts semantic fields only. Do not submit coordinates, font or style overrides, raw OOXML, arbitrary shapes, or unknown archetypes. The built slide uses existing named template shapes. For procurement decisions, put mandatory gate results ahead of scores and keep exact source locators visible. Do not treat this slide as independent evidence.

If inspection reports missing elements, change to a supported template. If validation reports overflow or an unsupported object, shorten the wording or choose another archetype. Do not patch the PPTX XML or bypass the schema. Read [limitations](references/limitations.md) when adapting a different corporate template.
