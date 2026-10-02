# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 12

Model AI Governance Framework for Agentic AI
| Introduction to Agentic AI

12

•
Cascading or compounding effects: A mistake in one step can propagate and amplify across later
steps, resulting in outsized impact. For example, in supply chain management, an initial
hallucinated inventory figure could potentially cause downstream actions to reorder excessive or
insufficient stock.

Multi-agent systems exacerbate these risks because of the increase in number of interacting agents.
For example, multi-agent systems often require agents to share context, memory, and intermediate outputs
with other agents. This increases the likelihood for sensitive data to be unintentionally logged, passed to
less secure agents, or exposed through prompt injection attacks.

The extent to which multi-agent systems introduce qualitatively different risks is still being studied,
but some of the more pertinent ones include:14

•
Agent sprawl: As more AI agents are created and deployed within the organisation, this can lead to
the uncontrolled proliferation of AI agents without centralised management. This can lead to issues
with provenance, incompatibility between old and new agents, and/or difficulties in managing
agents from different generations that may not communicate well.

•
Collaborative failures

o
Miscoordination: Agents working together can lead to unintended failures through bad
communication or miscoordination. For example, agents working on the same task may
interpret the user’s intent differently, and work towards different goals.
o
Conflict:Agents optimising different goals can come into conflict. For example, a customer
support agent may offer refunds to resolve complaints quickly, while a revenue protection
agent may block refunds above a certain threshold.
o
Collusion: Agents may develop behaviours that appear coordinated, even if no explicit
instruction to collude was given. For example, pricing agents used by different
organisations could observe each other’s prices and converge on higher prices rather than
competing. This behaviour has already been studied for pricing algorithms15 and is being
studied for LLM-based agents.

•
Unpredictability and other emergent behaviours: When multiple non-deterministic agents work
together, the number of possible outcomes grows exponentially. This can cause emergent
behaviours that cannot be predicted from testing each agent individually.

Finally, multiple agents can interact both within a system or across systems. When agents cross
system or organisational boundaries, it becomes more difficult to test for and anticipate the spectrum of
potential outcomes, especially if an organisation does not have white-box access to these external systems.

14
See Gradient Institute, Risk Analysis Techniques for Governed LLM-based Multi-Agent Systems.
15
See Bichler, Durmann, & Oberlechner, Algorithmic Pricing and Algorithmic Collusion.
