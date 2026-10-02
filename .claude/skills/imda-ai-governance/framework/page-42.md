# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 42

Model AI Governance Framework for Agentic AI
| Implement technical controls and processes

42

2.3.3
When deploying, continuously monitor and test

Pre-deployment testing establishes a useful baseline but needs to be complemented by continuous
monitoring and testing during deployment. Agents adapt to real-time conditions and their behaviour may
change. For multi-agent systems especially, failure modes such as miscoordination or emergent behaviours
may only manifest through agent behaviour over time and under realistic conditions. This section provides
recommendations to mitigate such risks, including:

•
Gradual deployment of agents
•
Continuous testing and monitoring
•
Robust change management

Gradual deployment of agents

Organisations should consider gradually rolling out agents into production to control the amount of
risk exposure. Such rollouts can be controlled based on:

•
Users of agents e.g. rolling out to trained or experienced users first
•
Tools and protocols available to agent e.g. restricting agents to more secure, whitelisted MCP
servers first
•
Systems exposed to agent e.g. using agents in lower-risk internal systems first

GovTech: Phased rollouts of coding assistants to incrementally monitor risks while
preparing controls for new features

The Government Technology Agency of Singapore, or GovTech, is a statutory board in Singapore that
develops digital government services and drives public sector transformation.

In Oct 2025, GovTech rolled out two agentic coding assistants within the organisation, namely Windsurf
and GitHub Copilot (Agent Mode), before rolling out Claude Code in Apr 2026. After extensive tests on
common vectors for failures and threats (such as agentic AI manipulation, hallucination, and compromise
of MCP servers) and implementation of corresponding technical controls, GovTech adopted a phased
approach for rolling out these agentic capabilities. This enabled it to empower development teams with
enhanced productivity early, while monitoring risks and incrementally developing further controls for new
AI features as the technology evolves.

In the first phase, the rollout was limited to contain the blast radius of any potential risks:

•
Internal employees: Agentic coding assistants were only rolled out to GovTech employees, a
smaller group of developers within a single organisation that could be trained, educated on the
using agents responsibly versus the whole of government.
•
No MCP allowed: Users were only allowed to use the built-in capabilities of the agent e.g. multi-
step reasoning to plan and execute tasks within the developer’s environment without access to
MCP servers.
•
Low-risk systems: Systems that were not critical infrastructure and had lower levels of data
access.
