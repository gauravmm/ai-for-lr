# A*STAR Leadership Retreat AI tutorial

Welcome to the AI tutorial hands-on portion, delivered by Dr. Gaurav Manek. [Add me on LinkedIn!](https://www.linkedin.com/in/gauravmanek/).

To get started, open this as a GitHub codespace and wait for setup to finish. Enter your approved email and Course Password to use A*STAR-funded Claude tokens.

## ATLAS Task [10 minutes]

You can give the AI access to background information:

- The slides with `/slides`.
- IMDA's AI governance framework with `/imda-ai-governance`.

It may also choose to read these by itself. There are two questions to understand

## Procurement Agent Task [40 minutes]

Develop the strategy with your AI agent and complete the risk analysis workflow blueprint below. You can tell your agent to understand the workflow with `/slides explain the Procurement Agent design to me.`

As you make technical decisions, tell your agent to save them to `AGENT-DESIGN.md`. We'll use that to make slides later!

### Workflow

![Tender-analysis workflow: Ingest, Verify, Draft, Review](media/task-workflow.png)

The workflow is in four stages:

1. **Ingest:** one agent extracts the case documents and the evaluation criteria.
2. **Verify:** one subagent per bidder (Aperture, Helix, Meridian, Northstar, Peregrine) receives only the criteria and that bidder's submission, evaluates it against each criterion, and recommends whether it passes or fails each mandatory gate. Separate bidder contexts help avoid mixing evidence; your technical team must enforce file and tool access limits.
3. **Draft:** one subagent synthesises the verification results and scores the eligible bids.
4. **Review:** one subagent writes the result out to a leadership slide.

When your design is ready, run the procurement task in the agent chat:

> `Run the agent specified in AGENT-DESIGN.md on the procurement case in case/.`

Then check your risk assessment separately:

> `/risk-assessment Analyze my risk assessment in AGENT-DESIGN.md.`

The checking skill reconciles all four stages against IMDA's framework and saves issues and guiding questions in `RISK-REVIEW.md`. Revise your assessment and ask it to check again; it offers worked answers only after 3–4 unsuccessful attempts on an issue.

#### Blueprint

| Stage | Allowed data and tools | Permitted action | Approval-required or prohibited action | Stop and escalation | Evidence log |
| --- | --- | --- | --- | --- | --- |
| Ingest | [which files?] | [read and classify] | [cross-case access prohibited] | [scope mismatch] | [file access log] |
| Verify | [submitted sources] | [extract and calculate] | [do not invent amendments] | [missing or conflicting source] | [attribution chain] |
| Draft | [verified claims] | [draft recommendation and slide] | [award requires committee] | [unsupported decision] | [versioned outputs] |
| Review | [draft outputs] | [route to people] | [bidder contact requires procurement approval] | [approval absent] | [review record] |

#### Risk Analysis

Copy this template for each stage (Ingest, Verify, Draft, Review) and save your decisions in `AGENT-DESIGN.md`. For Verify, specify the limits for each bidder's subagent.

- **Stage:** [Name and purpose of this stage.]
- **Human owner:** [Who is accountable for its outputs?]
- **Allowed data and tools:** [Which files and tools can it access? How are those limits enforced?]
- **Permitted actions:** [What can it do without approval, and what should it produce?]
- **Approval-required actions:** [What needs approval, from whom, and what must they check?]
- **Prohibited actions:** [What must it never do, even if asked?]
- **Stop and escalation:** [What makes it stop, who resolves the issue, and when can it resume?]
- **Evidence log:** [Record sources and locations, calculations, actions, approvals, and outputs. Where will this log be saved?]

For this stage, list the risks below. Rate severity and likelihood before controls as Low, Medium, or High, with a brief reason. For residual risk, describe and rate what remains after controls. Mark untested controls as proposed.

| Risk / failure | Business impact | Severity | Likelihood | Control | Residual risk | Human owner | Test / evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| [What could go wrong?] | [Who or what is affected?] | [Rating and reason] | [Rating and reason] | [How is it prevented or detected, and where is the control enforced?] | [What remains, and how serious is it?] | [Who manages or accepts this risk?] | [How will you test the control, and what result will you record?] |

#### Starter Prompts

If you have any questions about how to weigh risks and develop technical controls, ask your AI! The command `/imda-ai-governance` will give it access to the full IMDA framework, and it comes with an encyclopedic knowledge of technical controls. Ask questions like:

- **Get help prompting:** `Suggest prompts to help me design and test this workflow.`
- **Find the biggest risks:** `What are the three biggest risks, and how can we reduce them?`
- **Understand agent isolation:** `Why use one agent per bidder, and what risks remain?`
- **Define minimum access:** `Which files and tools does each stage need, and how can we enforce those limits?`
- **Make human review meaningful:** `Who should approve the work, when, and what should they check?`
- **Handle conflicting evidence:** `What should the agent do when evidence is missing or conflicting?`
- **Test the controls:** `Give me three ways to test whether our controls work.`
- **Challenge the design:** `Adversarially review the workflow in AGENT-DESIGN.md and explain whether you could bypass its controls.`

## Finished early? Try the firetruck simulator

For advanced students or anyone who has finished the workshop tasks, type `/firetruck` in a new Claude chat. Dispatch limited fire trucks through a city while assessing late, incomplete, contradictory, or false reports. The game is preinstalled and starts automatically in Codespaces.

---

All people, organisations, products, rules, and events in this case are fictional and supplied for training.
