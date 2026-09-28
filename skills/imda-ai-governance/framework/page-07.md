# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 7

Model AI Governance Framework for Agentic AI
| Introduction to Agentic AI

7

1.
Model: an SLM, LLM or MLLM that serves as the central reasoning and planning engine, or the “brain”
of the agent. It processes instructions, interprets user inputs, and generates contextually
appropriate responses.

2.
Instructions: Natural language commands that define an agent's role, capabilities, and behavioural
constraints e.g. a system prompt for an LLM.

3.
Memory: Information that is stored and accessible to the LLM, either in short or long-term storage.
Sometimes added to allow the model to obtain information from previous user interactions or
external knowledge sources.

In addition, an agent has other components that enable it to complete more complex tasks:

4.
Planningand reasoning: The model is usually trained to reason and plan, meaning that it can output
a series of steps needed for a task.

5.
Tools: Tools enable the agent to take actions and interact with other systems, such as writing to
files and databases, controlling devices, or performing transactions. The model calls tools to
complete a task. Agents themselves can also be called as tools, e.g. one supervisor agent invokes
another specialist agent for a certain task.

6.
Protocols: Standardised ways for agents to communicate with tools and other agents. For example,
the Model Context Protocol (MCP) has been developed for agents to communicate with tools,
whereas the Agent2Agent Protocol (A2A) defines a standard for agents to communicate with each
other.4 This is a fast-developing space and more protocols are being developed to standardise
agent interactions, especially in agentic commerce.5

Apart from these enabling components, an agent usually also has components for safe and reliable
performance:6

7.
Controls: Controls limit the agent’s action-space and autonomy. While there are many types of
controls, the ones most relevant to agents are:

a.
Access controls: These limit what an agent is allowed to see, use or change, including
restricting access to sensitive data, tools and systems.
b.
Guardrails: Guardrails monitor and constrain an agent’s behaviour before, during or after it
acts. It can help detect unsafe instructions, policy violations, or actions that appear
inconsistent with user intent.
c.
Human approvals: Requirements for a human to review or approve agent actions.

8.
Log ging and monitoring
: Records agent actions, decisions, and interactions across all
components to enable monitoring, debugging, and accountability.

4
See Anthropic, Model Context Protocol and Google, Agent2Agent Protocol.
5
See OpenAI, Agentic Commerce Protocol, Alipay, Agentic Mobile Protocol, and Google, Universal Commerce
Protocol.
6
More information on this can be found in 2.3 Implement technical controls and processes.
