# Procurement agent design

Evaluate the procurement case in `case/` and prepare an evidence-based recommendation and a leadership slide.

## Instructions for the running agent

Act as the orchestrator and use your built-in subagent tools to run the tasks below. Do not write orchestration code or make direct API calls. Pass each subagent only the inputs it needs, collect its results, and pass those results to the next stage.

## Workflow

1. **Ingest:** one agent extracts the case documents and evaluation criteria, keeping source document and location references.
2. **Verify:** one subagent per bidder (Aperture, Helix, Meridian, Northstar, Peregrine) receives only the criteria and that bidder's submission. It evaluates each criterion and recommends pass or fail for each mandatory gate, with supporting evidence. Separate bidder contexts help avoid mixing details between bids.
3. **Draft:** one subagent synthesises the verification results and scores only eligible bids. Check mandatory gates before weighted scoring.
4. **Review:** one subagent writes the result out to a leadership slide, including the recommendation, supporting evidence, and unresolved issues.

## Basic boundaries

- Use the supplied case evidence and preserve references to the documents and their locations. Flag missing or conflicting evidence; do not invent facts or amendments.
- Keep award decisions with the committee and bidder contact with Procurement approval.
- Record the student's agreed access limits, permitted tools, human approvals, stop conditions, and evidence logs in this file as the design develops. Record boundary-test results here after running the workflow.
