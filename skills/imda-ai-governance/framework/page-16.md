# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 16

Model AI Governance Framework for Agentic AI
| Assess and bound the risks upfront

16

access to sandboxed or internal
tools

Scope of agent’s
actions

Whether an agent can only read from or can
also modify the data and systems it has access
to.

Whether the agent can complete a small or
wide range of actions using tools available to it.

Read vs write: Agent that can
only read from a database
cannot impact the database, vs
agent that can write to it

Many actions vs a few: Agent
that can only choose from a few
pre-defined tools, vs one who
has access to a computer use
tool that can navigate any user
interface

Reversibility of
agent’s actions

If the agent can modify data and systems,
whether such modifications are easily
reversed. Modifications may not be easily
reversed if they trigger downstream obligations
e.g. entering into a contract or sale.

Agent that schedules meetings
can easily reschedule them if an
error is made, vs agent that
sends email communications to
external parties

Factors affecting likelihood (probability of the risk manifesting)

Factor
Description
Illustration

Agent’s level of
autonomy

Whether the agent can define the entire
workflow or must follow a well-defined
procedure.

A higher level of autonomy can result in higher
unpredictability, increasing likelihood of error.

Agent is provided with a SOP
and instructed to follow it when
carrying out a task, vs agent is
instructed to use its best
judgment to select and execute
every step

Task complexity
How complex the task is, in relation to the
number of steps required to complete it and
the level of analysis required at each step.

A higher level of task complexity similarly
increases unpredictability and the likelihood of
error.

Agent is required to extract key
action points from a meeting
transcript, vs agent is tasked to
follow a nuanced data sharing
policy when handling external
requests for information

Agent’s access
to external
systems

Whether the agent is exposed to external
systems, and who maintains these systems.

A higher level of exposure makes the agent
more vulnerable to prompt injections and
cyberattacks.

Agent who can only access an
internal knowledge base which
is maintained by trusted internal
teams, vs an agent who can
access the web containing
untrusted data
