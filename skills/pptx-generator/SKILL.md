---
name: pptx-generator
description: Build a short (1-4 slide) editable leadership deck from the supplied A*STAR-branded corporate PowerPoint template and a verified semantic slide plan. Use for Task 2 slide creation or revision; the tool does not verify procurement claims.
---

# Leadership deck generator

Use the supplied template and this package's commands. First inspect the template with `npm run inspect -- --template <path-to-template.pptx>`; it lists one slide per approved archetype (`context`, `gate_focus`, `decision_summary`, `cover`, in that order) with its required and unsupported shape names. Choose the archetypes your deck needs and write a plan matching [slide-plan.schema.json](slide-plan.schema.json): shared `audience` and `sources` at the top, then a `slides` array (1-4 entries), each an object starting with its `archetype`. A single-slide `decision_summary` plan is still the simple case and is exactly what Task 2 expects. A neutral valid plan and a deliberately invalid plan are in [examples](examples/), including a three-slide `context` + `gate_focus` + `decision_summary` deck. Keep every figure, status, and source locator tied to your verified Task 1 record.

Run `npm run build -- --template <path-to-template.pptx> --plan <plan.json> --output <new-deck.pptx>`, then `npm run validate -- --template <path-to-template.pptx> --plan <plan.json> --output <new-deck.pptx>`. The output is a new file; the template remains unchanged. With LibreOffice installed, validation also renders the deck to PDF; pass `--require-render` to require that check.

The plan accepts semantic fields only. Do not submit coordinates, font or style overrides, raw OOXML, arbitrary shapes, or unknown archetypes. Each built slide uses existing named template shapes: `gate_focus`/`decision_summary` for the mandatory-gate table and scoring comparison, `context` for the procurement problem statement and evaluation criteria, `cover` for a title slide. For procurement decisions, put mandatory gate results ahead of scores and keep exact source locators visible. Do not treat this deck as independent evidence.

If inspection reports missing elements, change to a supported template. If validation reports overflow or an unsupported object, shorten the wording or choose another archetype. Do not patch the PPTX XML or bypass the schema. Read [limitations](references/limitations.md) when adapting a different corporate template.
