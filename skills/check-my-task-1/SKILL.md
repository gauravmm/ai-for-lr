---
name: check-my-task-1
description: Review a participant's finished Task 1 verification work and list what to fix before it goes to leadership. Manual only; run it when the user types /check-my-task-1, and do not read or apply it otherwise.
disable-model-invocation: true
---

# Check my Task 1

The participant asks you to review their Task 1 work: one corrected key conclusion, a claim-to-source table and one reusable verification prompt (see `README.md`, Task 1). Act as a careful reviewer, not a co-author. Point to what needs fixing and why; do not rewrite their work unless they ask.

Base every judgement on the case files you open during this review. Do not rely on an earlier conversation's conclusions, and do not state the "right answer" unprompted: say which claim to re-check and where to look.

## Find the work

1. Ask which files or chat messages hold their answer if it is not obvious. `git status` shows files they created.
2. Note anything that exists only in chat. A claim table that was never saved cannot be reviewed by anyone else; recommend saving it (for example as JSON matching `attribution.schema.json`).

## Checks

Work through these in order and keep a list of findings with the claim ID each one affects.

1. **Deliverables.** A single corrected key conclusion, a table and a reusable verification prompt are all present. The prompt is the item most often forgotten.
2. **Schema.** Every row has the fields in `attribution.schema.json`, and `documentary_status` and `verification_status` use its vocabulary.
3. **Re-check the sources yourself.** For every decision-relevant row (all rows if there are 15 or fewer, otherwise the gate and recommendation rows plus a sample), open the cited document at the cited locator and confirm the source value. Read `X.pdf.md` when it exists. Recompute every calculation.
4. **Exact locators.** A locator names a section, table row or workbook cell (`RFQ-02 T1 M6`, `Mandatory Gate!J2`). Document-level citations such as "EMAIL-02 (thread)" or ranges of documents are not locators.
5. **Authority and dates.** Where records disagree, the table says which one governs and why. Signed submissions and formal addenda outrank emails and working files; a later email does not amend a closed tender unless the tender's own rules say so. Check the addendum register before accepting any claimed amendment. Check too that each date or figure is the one the requirement names, such as the acceptance date rather than delivery or installation.
6. **Gates before scores.** Mandatory requirements are settled for every bid before any weighted score is used. A bid that fails a gate is excluded, not ranked lower, and the remaining scores are not rescaled.
7. **Uncertainty kept visible.** A missing figure is marked `unresolved` or `unsupported`, not estimated. A comparison between offers of different scope (for example prices that cover different service periods) is flagged as not like-for-like even when the subtraction is right. Where two submitted records give different figures and nothing says which governs, the row stays `unresolved` with both values. A table with nothing unresolved deserves a second look.
8. **What changed.** Each correction states the original claim, the new value and the reason.
9. **Human authority.** Contacting bidders, amending the tender and awarding the contract stay with named people. The work does not negotiate or assume approvals.

## Report

Keep it short and business-facing:

- **Verdict:** ready for leadership, or needs fixes.
- **Fixes:** one line each, most important first, naming the claim ID and the document to re-open.
- **Done well:** one or two lines.

Suggest they run `/check-my-task-1` again after fixing.
