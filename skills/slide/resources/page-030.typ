== LLM intelligence fails in common ways

#lblock(center: true)[
  LLMs fail in *common* ways that are a *foreseeable* source of business risk.
]

- *Overconfidence:* expresses certainty independent of correctness.#cite-source("https://aclanthology.org/2024.trustnlp-1.13/")[Tobias Groot and Matias Valdenegro-Toro. _Overconfidence is Key: Verbalized Uncertainty Evaluation in Large Language and Vision-Language Models_. TrustNLP 2024, pp. 145-171.]

- *Credulity/Sycophancy:* accepts falsehoods or agrees with you despite contradictions.#cite-source("https://www.anthropic.com/research/towards-understanding-sycophancy-in-language-models")[Sharma et al. _Towards Understanding Sycophancy in Language Models_. 2023.]
- *Hallucinations:* invents facts, citations, or details that sound plausible.
- *Theory-of-mind / world-model failure:* misjudges what people know or how actions affect the world.#cite-source("https://arxiv.org/abs/2305.14763")[Shapira et al. _Clever Hans or Neural Theory of Mind? Stress Testing Social Reasoning in Large Language Models_. arXiv:2305.14763, 2023.]
- *Specification gaming / reward hacking:* exploits a rule or reward while missing the intended goal.#cite-source("https://www.anthropic.com/research/reward-tampering")[Anthropic. _Sycophancy to Subterfuge: Investigating Reward Tampering in Language Models_. 17 June 2024. Controlled training experiments; not established as common production behavior.]

#v(1fr)


#cite-source(
  "https://doi.org/10.1017/S0140525X00005756",
  display: false,
)[John R. Searle. \ _Minds, brains, and programs_. \ Behavioral and Brain Sciences 3(3), 417-424, 1980. Chinese Room argument.]

#cite-source(
  "https://openai.com/index/the-instruction-hierarchy/",
  display: false,
)[Wallace et al. _The Instruction Hierarchy: Training LLMs to Prioritize Privileged Instructions_. OpenAI, 2024.]
#cite-source(
  "https://arxiv.org/abs/2307.03172",
  display: false,
)[Liu et al. _Lost in the Middle: How Language Models Use Long Contexts_. arXiv:2307.03172 (2023); Transactions of the Association for Computational Linguistics, 2024.]

#speaker-note[
  - Overconfidence happens because models are trained to provide correct output and confident output. Even if they fail at "correct", there is no incentive to fail at "confident". In humans, we generally express ourselves with confidence depending on belief.
]
