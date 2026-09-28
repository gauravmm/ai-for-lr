# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 14

Model AI Governance Framework for Agentic AI
| The four dimensions

14

IMDA: Applying the four dimensions of the framework to OpenClaw

In May 2026, IMDA released a case study on responsible deployment of OpenClaw, applying this
framework and drawing from the practical experiences of GovTech, CSA, and industry players such as
Grab and Microsoft who had experimented with it.

OpenClaw is an open-source AI agent platform that acts as an autonomous personal assistant through
common chat interfaces such as Telegram and Slack. Itcan automate everyday tasks such as compiling
research, handling customer enquiries or debugging code. Itwas launched with limited security controls
and deploying it safely is non-trivial. Concerns include its lack of maturity and hardening, access control
and authentication gaps, exposure of sensitive data, supply chain risks from third-party skills, and
memory poisoning risks.

The framework can be applied to deploy OpenClaw (and similar) agents responsibly:

1.
Assess and bound the risks upfront

•
Avoid deploying OpenClaw as-is in mission-critical environments, including systems that
handle sensitive data or financial transactions
•
Avoid creating a single “all-powerful” agent with unrestricted access, instead use multiple
agents with narrow, clearly defined rules
•
Avoid installing OpenClaw on primary work or personal devices containing sensitive data,
and granting it unrestricted access to files and applications

2.
Make humans meaningfully accountable

•
Adopt a risk-based approach to determine the appropriate level of agent autonomy based
on data sensitivity and task criticality
•
Enforce human approval through system-level controls where possible, vs prompt-layer
guardrails, which may be bypassed or “forgotten”

3.
Implement technical controls and processes

•
During design and development, review and tighten OpenClaw configurations which are
permissive by default e.g. restrict messaging channel access, using dedicated identities
and credentials for the agent
•
Before deployment, test and verify that safety controls and human-in-the-loop is working
as intended e.g. attempt disallowed actions to ensure restrictions work
•
After deployment, ensure all agent actions are logged and attributable, and avoid leaving
the agent unsupervised for extended periods

4.
Enable end-user responsibility

•
Provide personnel training to improve employees’ awareness of autonomous agent risks
and reinforce their responsibility to prevent careless misuse

See the full case study here.
