# Tender-analysis workflow

Text description of `task-workflow.png`, the four-stage workflow diagram for Task 3. Arrows run left to right.

## INGEST: Understand the requirements

One node, **Extract docs & criteria**. It has five arrows out, one to each Verify node.

## VERIFY: Check each bid for completeness and correctness

Five nodes stacked vertically, one per bidder, each shown with its logo:

1. Aperture
2. Helix
3. Meridian
4. Northstar
5. Peregrine

Each bidder node receives one arrow from Extract docs & criteria and sends one arrow to Synthesize & score. There are no arrows between bidder nodes: each bid is checked in isolation.

## DRAFT: Score each correct bid using the competitive criteria

One node, **Synthesize & score**. It receives all five Verify arrows and sends one arrow to Write slide.

## REVIEW: Update the slides

One node, **Write slide**. It receives the arrow from Synthesize & score and is the end of the workflow.
