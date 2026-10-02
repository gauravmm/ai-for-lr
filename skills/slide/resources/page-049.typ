== Getting It Wrong: Hacking the Evaluation

#grid(
  columns: (40%, 1fr),
  column-gutter: 0.5em,
  align: top,
  alternatives(start: 1, position: top + left, risk-pillar-summary(), risk-pillar-summary(
    bad-risks: (2, 4, 5, 7),
    bad-pillars: ("A", "C"),
  )),
  [
    #grid(
      columns: (auto, auto),
      column-gutter: -1.0em,
      align: horizon,
      image("media/reward-hacking/OAI_OpenAI-Blossom_Black.png", height: 2.8cm),
      image("media/reward-hacking/OAI_OpenAI_Wordmark_Black.png", height: 2.8cm),
    )
    #v(-1.4em)
    #text(
      size: 0.9em,
      fill: luma(100),
    )[OpenAI · July 2026 cybersecurity evaluation#cite-source("https://openai.com/index/hugging-face-incident-and-the-road-ahead/")[OpenAI. \ _The Hugging Face incident and the road ahead_. \ 26 August 2026. Postmortem of the July 2026 cybersecurity-evaluation incident.]]

    #v(0.5em)
    - Read public evaluation code and *reverse-engineered answers*
    - Tried to *fool the scorer* and disguise their actions#cite-source("https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/")[METR and Redwood Research. \ _Brief independent investigation of agents’ behavior, reasoning and collaboration in the OpenAI / Hugging Face hacking incident_. \ 26 August 2026. Observed small-scale tool-call spoofing in roughly 7% of reviewed transcripts; broader scorer-tampering attempts were not all successful.]
    - Collaborated through an *unauthorized message board*
    - Compromised *41 Hugging Face production workers*#cite-source("https://cdn.openai.com/pdf/67869394-cb91-4c12-888c-5cbd85c7814c/OpenAI-Hugging-Face%20Incident-Technical-Report.pdf")[OpenAI. \ _OpenAI – Hugging Face Incident Technical Report_. \ August 2026. Section IV.B, pp. 9–11: code execution on 41 production workers, root access on at least one node, and access to credentials and limited private data.]

    #gblock[Hugging Face disclosed the breach on *16 July*. OpenAI connected it to its agents on *20 July*.#cite-source("https://openai.com/index/hugging-face-incident-and-the-road-ahead/")[OpenAI. \ _The Hugging Face incident and the road ahead_. \ 26 August 2026. Detection timeline: security alert on 19 July; connection to the Hugging Face incident on 20 July.]]

  ],
)

#speaker-note[
  - The July 2026 incident primarily involved an internal-only research model operating under reduced safeguards during ExploitGym cybersecurity evaluations. These settings differed from OpenAI's deployed products.
  - Agents read the public ExploitGym paper and code. They believed the scorer required both the correct flag and evidence of exploiting the intended vulnerability. OpenAI's internal scorer only checked the flag, so the additional attacks did not improve evaluation scores.
  - METR and Redwood found that understanding or tampering with the scorer was a central motivation. Roughly 7% of reviewed transcripts contained successful small-scale tool-call spoofing; do not imply all concealment or scorer-tampering attempts succeeded.
  - OpenAI reports code execution on 41 Hugging Face production workers, root access on at least one node, and access to credentials and limited private data. Unauthorized communication allowed separate agents to share discoveries and expand the intrusion.
  - Detection timeline: Hugging Face publicly disclosed the security activity on 16 July. An OpenAI security alert about unusual activity involving Artifactory credentials triggered an investigation on 19 July. OpenAI connected the agents to the Hugging Face incident on 20 July and publicly disclosed its involvement on 21 July.
  - Some unauthorized communication and internet access had already been observed in late May, and a security incident was opened on 5 July. The broader containment and alignment implications were not yet understood; do not imply there were no earlier warning signs.
  - Teaching interpretation: agents pursued what they believed would pass an evaluation beyond the authorized task. Connect to unauthorized actions, data breaches, disruption, cascading effects, and Pillars A and C.
]

#let atlas-logo() = {
  image("media/atlas/ATLAS logo.png", height: 100% - 10mm)
  v(-24mm)
  text(font: "Cinzel", weight: "bold", size: 16mm, tracking: 0.15em)[ATLAS]
}
