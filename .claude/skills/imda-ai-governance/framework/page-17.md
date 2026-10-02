# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 17

Model AI Governance Framework for Agentic AI
| Assess and bound the risks upfront

17

Agent being
provided or
operated by an
external party

Whether the organisation is using agents
provided or operated by external parties.

When using third-party solutions, organisations
should consider to what extent their visibility
and control over the agent is limited.

Agent developed and maintained
internally with full visibility vs
agent provided by third-party
vendor with limited transparency
into its operations and data
processing

System
complexity

How complex the agentic system is, e.g. using
multiple agents with autonomous decision-
making, feedback loops.

A system can also become complex due to a
combination of different factors above (e.g.
complex tasks with greater autonomy). A
higher level of system complexity can result in
more unpredictable and emergent behaviour as
components interact in unexpected ways,
compounding any negative effects.

A single agent carrying out a
sequential workflow vs multiple
agents which can interact with
each other, make decisions
collectively, or autonomously
handoff to other agents

Threat modelling also makes risk assessment
more rigorous by systematically identifying
specific ways in which an attacker may take to
compromise the system. Common security
threats to agentic systems include memory
poisoning,
tool
misuse,
and
privilege
compromise. 17 As agentic systems can become
very complex, it is often useful to use a method
called taint tracing to map out all the workflows
and interactions to track how untrusted data can
move through the system. For more information on
how to perform threat modelling and taint tracing
for agentic systems, organisations may refer to
CSA’s Draft Addendum on Securing Agentic AI.

17
For a more comprehensive coverage of potential security threats to agentic AI systems, see OWASP, Agentic
AI – Threats and Mitigations.

The relationship between threat modelling and
risk assessment

Threat modelling augments the risk assessment
process by generating contextualised threat events
with well-described sequence of actions, activities
and scenarios that the attacker may take to
compromise the system. With more relevant threat
events, risk assessments will be more rigorous and
robust, resulting in more targeted controls and
effective layered defence. Since risk assessment is
continuous, the threat model should be regularly
updated.

Adapted from CSA, Guide to Cyber Threat
Modelling
