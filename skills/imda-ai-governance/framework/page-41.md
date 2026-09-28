# IMDA Model AI Governance Framework for Agentic AI v1.5 — page 41

Model AI Governance Framework for Agentic AI
| Implement technical controls and processes

41

City Developments Limited x Knovel Engineering: Testing data access boundaries in
agentic systems

City Developments Limited (CDL) is a Singapore-based developer and asset owner/operator, with a
portfolio spanning residential, commercial, hospitality, and integrated developments. Knovel
Engineering is a Singapore-based AI consultancy that helps enterprises and government agencies
operationalize trusted AI.

As part of the Global AI Assurance Sandbox, Knovel tested CDL’s internal agentic system, which
answers queries by retrieving business insights, accessing internal knowledge, and performing
task‑oriented workflows. Agent orchestration handles multi‑step tasks such as summarising sector
performance or retrieving specific operational metrics.

CDL identified data leakage as a key risk of its system and prioritised it for testing. The aim was to
determine if data access controls and boundaries were properly enforced across users i.e. a user would
only be able to obtain information that s/he had access rights to.

To test this, Knovel adopted the following methodology:

•
Used a matrix of 7 user accounts x 4 domains (Property, Financial, Commercial Hospitality) to
validate adherence to boundaries
•
Logged into user accounts with restricted domain access and conducted multi-turn
conversations that progressively introduced indirect queries targeting out of scope domains
(e.g., a Property-domain user asking about Hotel A’s Q4 revenue)
•
Compared outputs from restricted accounts with those from legitimately authorised ones to
detect info leakage
•
Additionally, the system's tendency to be helpful was exploited by providing partially correct
system prompts and tool call structures, observing whether the system inadvertently corrected
or completed redacted information.

For more details on this case study, including insights from the testing and other risks that were tested,
see here.
