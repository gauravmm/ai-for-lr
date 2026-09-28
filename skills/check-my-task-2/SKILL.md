---
name: check-my-task-2
description: Review a participant's corrected leadership deck for Task 2 against their verified Task 1 record and list what to fix. Manual only; run it when the user types /check-my-task-2, and do not read or apply it otherwise.
disable-model-invocation: true
---

# Check my Task 2

The participant asks you to review their Task 2 deck: a corrected, editable version of the initial leadership deck (INITIAL-03) built with the `pptx-generator` skill from their verified Task 1 result (see `README.md`, Task 2). Act as a careful reviewer, not a co-author. Point to what needs fixing and why; do not rebuild the deck unless they ask.

Judge the deck against their Task 1 record and the case files you open during this review, not against an earlier conversation.

## Find the work

1. Locate the `.pptx`, the slide plan JSON it was built from, and their Task 1 claim table. Ask if any is missing; `git status` shows files they created.
2. From `skills/pptx-generator/`, run `npm run validate -- --template assets/corporate-template.pptx --plan <plan.json> --output <deck.pptx> --require-render`. Then look at the rendered pages yourself: the validator can pass a title that wraps into the line below it.

## Checks

Keep a list of findings with the slide number each one affects.

1. **Same shape as INITIAL-03.** Compare with `case/05-initial-output/INITIAL-03-initial-leadership-selection-deck.pdf.md`. The deck has the same slides in the same order with the same layouts (`overview`, `context`, `gate_focus`), and only the content has changed.
2. **Every figure traces.** Each number, date, price, score and PASS/FAIL on the slides matches a row in the Task 1 record, and that row's source. List any value with no row behind it.
3. **Gate before scores.** Mandatory compliance appears before any weighted comparison. Only bids that pass every gate appear in the score comparison; a failed bid must not look like a lower-ranked option.
4. **One message, one ask.** The title or recommendation states one main message, and the deck names the approval or next action sought. It does not claim to award the contract.
5. **Source notes.** Source lines use exact locators (`RFQ-02 T1 M6`, `Mandatory Gate!J2`), not "N/A" or document-level references. Where the template leaves no room, the supporting material holds them.
6. **Uncertainty not hidden.** Anything left unresolved in Task 1 appears on a slide or in the supporting material. Visual emphasis (colour, bar length, ordering) does not make an uncertain or ineligible option look settled or attractive.
7. **Specific wording.** Short gate reasons still say what failed and by how much ("M2: SAT <date>, after <deadline>"), not only that something did ("over limit").
8. **Human approval.** The deck leaves due diligence, bidder contact and the award with named people or bodies.

## Report

Keep it short and business-facing:

- **Verdict:** ready for the committee, or needs fixes.
- **Fixes:** one line each, most important first, naming the slide and the value or wording to change.
- **Done well:** one or two lines.

Suggest they run `/check-my-task-2` again after rebuilding.
