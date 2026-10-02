== Cost of AI by Minimum Hosting Cost

#slide(config: config-page(margin: (x: 0em)))[
  #image("media/charts/cost-vs-aaii-by-hardware.svg")

  #cite-source(
    "https://huggingface.co/moonshotai/Kimi-K3",
    display: false,
  )[Moonshot AI. _Kimi K3 model card_. 2.8T total parameters; native MXFP4 weights. Read 2 October 2026.]
  #cite-source(
    "https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash",
    display: false,
  )[DeepSeek. _DeepSeek V4.1 Flash model card_. 552B backbone plus 196B Engram lookup parameters. Read 2 October 2026.]
  #cite-source(
    "https://huggingface.co/zai-org/GLM-5.3-Flash",
    display: false,
  )[Z.ai. _GLM 5.3 Flash model card_. 320B total parameters. Read 2 October 2026.]

  #speaker-note[
    Indicative hardware purchase budgets in Singapore dollars, using total parameters and resident-memory estimates in data/model_parameters.csv, data/model_hardware.csv, and data/hosting_tiers.json.
  ]
]
