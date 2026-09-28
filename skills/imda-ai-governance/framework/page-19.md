# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 19

Model AI Governance Framework for Agentic AI
| Assess and bound the risks upfront

19

2.1.2
Bound risks through design by defining agents limits and permissions

Having selected an appropriate agent use case, organisations can further bound the risks by defining
appropriate limits and permission policies for each agent.

Agent limits

Organisations should consider defining limits on:

•
Agent’s access to tools and systems: Define least-privilege policies that give agents only the
minimum tools and data access needed for it to complete its task.18 For example, a coding assistant
may not require access to a broad web search tool, especially if it already has curated access to
the latest software documentation. Structuring agents around functional boundaries (e.g.
separating IT helpdesk from HR self-service) can act as a natural constraint.

•
Agent’s autonomy: For process-driven tasks, SOPs and protocols are frequently used to improve
consistency and reduce unpredictability.19 Define similar SOPs for agentic workflows that an agent
is constrained to follow, rather than giving the agent the freedom to define every step of the
workflow.

•
Agent’s area of impact: Design mechanisms and procedures to take agents offline and limit their
potential scope of impact when they malfunction. This can include running agents in self-contained
environments with limited network and data access, particularly when they are carrying out high-
risk tasks such as code execution.20

In general, prefer deterministic rather than non-deterministic limits, and bound by design. For example,
rather than relying on prompts to instruct the agent against accessing certain tools, impose access controls
that prevent the tool from being called by the agent at all. This is elaborated in 2.3.1 Implement technical
controls and processes. Where limits are non-deterministic or less reliable, layer on more monitoring
measures or incorporate human-in-the-loop review to catch any failures.

18
See PwC, The rise – and risks – of agentic AI.
19
Grab introduced an LLM agent framework leveraging on Standard Operating Procedures (SOPs) to guide AI-
driven execution (see Introducing the SOP-driven LLM agent frameworks).
20
See McKinsey, Deploying agentic AI with safety and security: A playbook for technology leaders.
