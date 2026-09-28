# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 37

Model AI Governance Framework for Agentic AI
| Implement technical controls and processes

37

Stability Solutions: Differing controls on internal-facing vs external-facing agents

Stability Solutions is a company based in the US and Singapore that builds and provides blockchain-
powered infrastructure to record, preserve, and verify the integrity of data at scale. Their solutions
include the Global Trust Network (“GTN”, a high-throughput cryptoless public blockchain, currently
used in supply chain and logistics), and Monolith, an application that records the provenance of creative
works by allowing creators to digitally fingerprint any file, issue C2PA manifests and provenance
metadata, and embed IP licenses and AI training permissions, recording all of this in a robust, verifiable,
and machine-readable format on the GTN.

Stability deploys their in-house agentic AI system, L3, which currently comprises 26 AI agents that run
24/7 across almost all company functions, including product development, software engineering, and
marketing. Its internal agents have action-taking capabilities e.g. consolidating and archiving
information across the entire company, sending daily morning briefs, monitoring and resolving network
issues, acting as digital twins or personal assistants, and supporting engineering and development
activities such as planning projects and writing code. L3 is optimised to have access to as much
information as possible, enabling it to coordinate across teams (e.g. if the engineering team is planning
an upgrade, L3 will inform them of planned marketing activities to avoid any disruptions).

When Stability developed its first external-facing agent, Howard, to showcase L3’s features and answer
questions about L3 and the company, it recognised that the risk level was higher as the agent could be
compromised by untrusted third parties. Compared to internal-facing agents, additional guardrails had
to be implemented:

1.
Controls on data access: The agent has its own memory, which is formed from
information received from L3. L3’s agents, being aware of the agent’s role and risks
associated with it, curate a special dataset for the agent.

2.
Controls on interactions: The agent interacts through chats, either via Slack or a web
interface. Stability’s human employees vet third party inputs before they are sent to the
agent. This enables them to filter out prompt attacks or invasive questions designed to
extract sensitive information such as personal data and trade secrets. As the agent
improves in safety and reliability, this control is expected to become unnecessary.

3.
Controls on agent configuration: Express guardrails and defined personality protocols
were implemented to minimise the likelihood of the agent disclosing sensitive
information, such as trade secrets, personal or confidential data.
