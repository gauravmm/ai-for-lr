---
name: imda-ai-governance
description: Apply Singapore IMDA's Model AI Governance Framework for Agentic AI (v1.5) when designing, bounding, reviewing or explaining an AI-agent workflow. Use for the procurement workflow or any question about agent risk, human approval, controls or user responsibilities.
---

# IMDA Model AI Governance Framework for Agentic AI

You are advising business leaders in a short workshop. Use the notes below as your working summary of the framework, and open the full text in [framework/](framework/) whenever you need exact wording, detail or a case study. Each file is one page of the official document (`framework/page-13.md` is printed page 13). Cite page numbers, e.g. "(IMDA p. 29)", and never attribute to the framework anything you have not found in these notes or pages. Keep answers short and focused on the business decision: who is accountable, what the agent may and may not do, where a human must approve, and what evidence shows the control works.

Source: IMDA, *Model AI Governance Framework for Agentic AI*, Version 1.5, published 20 May 2026, updated 5 June 2026. Official PDF: <https://www.imda.gov.sg/-/media/imda/files/about/emerging-tech-and-research/artificial-intelligence/mgf-for-agentic-ai.pdf>.

## Core structure

The framework has four mutually reinforcing dimensions (p. 13):

1. Assess and bound risks upfront.
2. Make humans meaningfully accountable.
3. Implement technical controls and processes.
4. Enable end-user responsibility.

Treat them as an iterative loop: monitoring or testing may show a need to reassess the use case, tighten boundaries, change approval points or retrain users.

## 1. Assess and bound risks upfront (pp. 15–24)

- Judge whether an agent is appropriate at all before designing controls; a deterministic workflow may be better (p. 15).
- Impact depends on the domain, access to sensitive data and external systems, scope and reversibility of actions, and how many or how critical the affected processes are (pp. 15–16).
- Likelihood depends on autonomy, task complexity, exposure to external systems, system complexity and reliance on third-party components (pp. 16–17).
- Limit tool and data access, autonomy and area of impact. Prefer enforced system-level restrictions to prompt-only rules (p. 19).
- Authority should be scoped, least-privilege, non-transferable and time- or session-bounded. An agent must never hold more authority than the human who authorised it (p. 24).

## 2. Make humans meaningfully accountable (pp. 25–32)

- Name responsibilities across the agent lifecycle, inside and outside the organisation; "a human" is not an owner (pp. 25–28).
- Require approval at significant boundaries: high-stakes decisions, irreversible actions (sending communications, payments, deletions), atypical behaviour, or user-defined thresholds (p. 29).
- Keep approval requests short and contextual, show the material risk, and ask for the right kind of input: approve/reject, edit the plan, or written justification (p. 29).
- Check that oversight stays meaningful; override rates and review times can reveal rubber-stamping, alert fatigue or automation bias (p. 30).
- Deny by default when no approval mechanism is available or no policy covers a new action (p. 30).

## 3. Implement technical controls and processes (pp. 33–45)

- Use structural, rule-based safeguards for clearly definable higher-risk actions; use model-based checks only where fixed rules cannot capture the risk (pp. 33–34).
- Apply least privilege at the tool layer: strict tool inputs, no unnecessary write access, only trusted tool servers, sandboxed code, structured messages between agents, limited shared memory (p. 34).
- Test the whole workflow, not just the final answer: task execution, policy compliance, tool choice and order, permissions, robustness, realistic environments and repeated runs (p. 38).
- Roll out gradually, limiting initial users, tools and connected systems (p. 42).
- Log and monitor user–agent, agent–tool and model activity, with thresholds, interventions, tamper-proof audit trails and feedback loops matched to the risk (p. 44).

## 4. Enable end-user responsibility (pp. 46–49)

- Tell users what the agent can access and do, and where to escalate a malfunction (p. 46).
- Train users on failure modes, data-use rules and their oversight duties, and keep enough human skill for review and business continuity (pp. 46–49).

## Case studies worth citing

- **Dayos (p. 18):** actions tiered by severity, reversibility and feasibility of oversight. Low-risk reversible actions are automated and audited; moderate-risk actions need approval; high-risk, hard-to-reverse actions are prohibited.
- **OCBC (p. 20):** agents extract, draft and check, but cannot self-initiate or make final onboarding, credit or risk decisions; designated humans validate and approve.
- **Tencent (pp. 30–31):** default permissions distinguish reading, editing, shell commands, network access and tool-server use; suspicious commands trigger fresh approval.
- **GovTech (pp. 42–43):** first rollout limited to trained internal users, lower-risk systems and no external tool-server access while logging and controls were prepared.

## Applying it to the procurement workflow blueprint

A bounded tender-analysis workflow should state:

- **Owner and purpose:** the accountable owner, intended output, decision supported and acceptable residual risk.
- **Data boundary:** the assigned case, authoritative sources, prohibited sources, memory or retention rule, and time-bounded access.
- **Action boundary:** permitted, prohibited and approval-required actions at every stage.
- **Workflow:** separate collection, verification, drafting, review and sharing, so one error is not silently amplified.
- **Stops and escalation:** missing or conflicting evidence, sensitive information, an atypical action, a failed control or an unavailable approver.
- **Control evidence:** describe how permissions, approvals and handoffs would be checked; distinguish proposed checks from observed results. The workshop does not require a boundary-test exercise.
- **Pilot:** trained users, low-risk cases, few tools, no external sharing, and named success and safety measures.

## Page index

| Pages | Section |
| --- | --- |
| 3–4 | Executive summary |
| 5 | What's new in version 1.5 |
| 6–9 | 1.1 What is agentic AI: core components, multi-agent setups, how design affects limits |
| 10–12 | 1.2 Risks: sources, types, systemic and multi-agent risks |
| 13–14 | 2 The framework's four dimensions |
| 15–18 | 2.1.1 Determine suitable use cases |
| 19–24 | 2.1.2 Bound risks through agent limits and permissions |
| 25–28 | 2.2.1 Allocate responsibilities inside and outside the organisation |
| 29–32 | 2.2.2 Design for meaningful human oversight |
| 33–37 | 2.3.1 Technical controls during design and development |
| 38–41 | 2.3.2 Test agents before deploying |
| 42–45 | 2.3.3 Monitor and test continuously when deploying |
| 46–49 | 2.4 Enable end-user responsibility |
| 50–51 | Annex A: Further resources |
| 52–53 | Annex B: Call for feedback; acknowledgements |
