# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 8

Model AI Governance Framework for Agentic AI
| Introduction to Agentic AI

8

1.1.2
Multi-agent setups

In an agentic system, it is common for multiple agents to be set up to work together. This allows each
agent to specialise in a certain function or task and/or work in parallel. Having multiple agents specialising
in different tasks also means that each agent’s tools and permissions can be separately scoped and defined,
compared to a single agent with access to many tools.

Three simple design patterns for multi-agent systems are:7

•
Sequential: Agents work one after another in a linear or otherwise structured workflow e.g. a graph.
Each agent’s output becomes the next agent’s input.
•
Supervisor: One supervising agent coordinates specialised agents under it, calling specific agents
as tools when required.
•
Swarm: Agents work at the same time, handing off to another agent when needed.

There is no universally correct architecture for a multi-agent setup, and the task at hand can require different
or hybrid patterns. 8 A well-defined task with a step-by-step workflow can lend itself to a sequential
architecture, whereas a more open-ended task that requires brainstorming or pursuing different lines of
inquiry may benefit from a swarm architecture.

1.1.3
How agent design affects the limits and capabilities of each agent

While each agent may have the same core components, the design of each component can
significantly affect what the agent can do.

It is generally helpful to distinguish between two concepts when considering what an agent can do:9

7
Adapted from AWS, Multi-Agent Collaboration Patterns with Strands Agents and Amazon Nova. See also
Claude, Building multi-agent systems: When and how to use them.
8
For examples, see AWS, Inside AWS Security Agent: A multi-agent architecture for automated penetration
testing, Langchain, Choosing the Right Multi-Agent Architecture.
9
See WEF, AI Agents in Action: Foundations for Evaluation and Governance.

Action-space
(or authority, capabilities)

Range of actions the agent can take,
including transactions it can execute,
determined by the tools it is allowed to use
and permissions on those tools

Autonomy
(or decision-making)

Degree to which an agent can decide how to act
towards a goal, such as by defining the steps to
be taken, determined by its instructions and
level of human involvement
