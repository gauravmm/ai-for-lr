# 01-intro slides

Slide numbers match the presentation footer. Only the final state of each numbered slide is included; unnumbered title and section pages are also included. Intermediate animation steps and focus slides are omitted. Open the linked images for diagrams, screenshots and details missing from the searchable text.

## Slide unnumbered · PDF page 1 · Title

[Slide image](page-001.png)

Introduction to Agentic AI
A*STAR Leadership Retreat


Dr Gaurav Manek
2026-10-08
ocelliq.com/astar-lr

## Slide 1 · PDF page 2 · Outline

[Slide image](page-002.png)

Outline

                                              AI for leadership

     1. Background                            This course is for business leaders, not
     2. What is AI?                           engineers.
     3. What makes it agentic?
                                              1. Focus on AI governance.
     4. Governing agentic AI
                                              2. Identifying high-value applications
     5. Case studies
                                              3. Mitigating specific risks
     Hands-on:                                4. Organizational policy levers
     Set policies for and govern a complex
                                              Zero coding.
     AI workflow

                                             Go to https://ocelliq.com/astar-lr/,
                                             Your TAs will help set up.
ocelliq.com/astar-lr                                                                     1 / 73

## Slide 2 · PDF page 3 · About Me

[Slide image](page-003.png)

About Me


                       Dr. Gaurav Manek
                       • Founder, Ocellivision
                       • Technical Lead, ATLAS @ IMCB
                       • PhD in AI/ML — Carnegie-Mellon University (2023)
                       • Founder, Visigoth.ai (SaaS)


                       For follow-up questions:
                          gaurav_manek@a-star.edu.sg
                          gauravmanek


ocelliq.com/astar-lr                                                        2 / 73

## Slide 3 · PDF page 4 · About Our TAs

[Slide image](page-004.png)

About Our TAs




         Dr. Aarthi      Dr. Adaikalavan   Dr. Gokce Oguz   Dr. Chinh Tran-To   Ms. Dong Jiahui   Mr. Guai Zi Wei
        Ravikrishnan       Ramasamy                                 Su
            ASRL           ASRL / GIS        ASRL / GIS            BII               BDH               ETO




       Dr. Audrey Lee   Dr. Benedict Wong Dr. Benjamin Chew Dr. Farzam Farbiz Dr. Amhed Missael Mr. Xavier Wilbin
                                                                               Vargas Velazquez
             GIS              IAIC              IAIC              IAIC              IMCB              IMCB




ocelliq.com/astar-lr                                                                                                3 / 73

## Slide unnumbered · PDF page 5 · Industry Landscape

[Slide image](page-005.png)

1.   Industry Landscape

## Slide 5 · PDF page 8 · Industrial revolution

[Slide image](page-008.png)

1.1 Industrial revolution

                                                             Promise                                                      Risk



                                                                                            Amazon · 20261
                                                                                                                                   OpenAI · Aug 20265

                     Risk in missing this
                                                                                                                Risk in moving too quickly
                        opportunity
                                  Microsoft · Jan 20252

                                                                                                                                     The Guardian · Apr 2026
                                                                                                                                                               6
                                                                                        Anthropic · Nov 20253
             Gartner newsroom · article excerpt
                                                      · September 16, 2026

            Gartner Forecasts Worldwide AI
                                           Spending
            to Grow 49.5% in 2026
            2026 forecast: $2.7 trillion in global
                                                                    spending on AI.
            Excerpt rendered for this presentation;

                                                                                                                            CNN · Sep 20267
                                                      website screenshot unavailable.
                                                                    Gartner · Sep 2026 · article excerpt4



ocelliq.com/astar-lr                                                                                                                                               5 / 73

## Slide 6 · PDF page 9 · Gold Rush of our age

[Slide image](page-009.png)

1.2 Gold Rush of our age
     Global AI infrastructure spending in 20264

     US$1.48T               ≈5× Apollo missions8 (US$309 billion)
                            ≈3× Great Wall of China rebuild9 (US$452 billion)
                            ≈1× Cumulative global datacenter spend until the
                                mid-2000s10
     Global AI-server electricity consumption in 202611

     175 TWh                ≈3× Singapore electricity consumption in 202412 (58 TWh)
                            ≈2× Three Gorges’ designed annual output13 (88.2 TWh)




ocelliq.com/astar-lr                                                               6 / 73

## Slide 7 · PDF page 11 · Who Controls What in AI

[Slide image](page-011.png)

1.3 Who Controls What in AI

                             1. Business need
                             Outcomes · priorities · success metrics
      Your direct control
                             2. Policy                                        This workshop.
                             Rules · accountability · human oversight

                             3. Orchestration
                             Workflows · integrations · approvals
            Your technical
               team owns
                             4. Engineering
                             Tools · prompts · evaluation · deployment

                             5. Infrastructure                                Background.
                             Inference · latency · capacity · cost
      External providers
                             model     chips      power      data
                              dev                           centres network
ocelliq.com/astar-lr                                                                           7 / 73

## Slide unnumbered · PDF page 12 · WhatisAI?

[Slide image](page-012.png)

2.   What is AI?

## Slide 9 · PDF page 14 · What Does"AI"Mean?

[Slide image](page-014.png)

2.1 What Does “AI” Mean?




     • “AI” is a marketing and technical term             Jevons paradox 20
       ‣ From rule-based systems to neural networks
       ‣ Promises to revolutionize everything             AI won’t make working easier.
     • Massive returns in software, marketing, etc.       It raises the bar for everyone
       ‣ Just starting in some conservative industries.   and increases competition.
                                                          The only competitive moat left
     • Turn prediction into a commodity.19                is your speed of integration.
     Not magic                                            Adopt early, or get left behind.




ocelliq.com/astar-lr                                                                         9 / 73

## Slide 10 · PDF page 16 · What is a Large Language Model?

[Slide image](page-016.png)

2.2 What is a Large Language Model?

                         An LLM is Fancy Autocomplete
     An LLM predicts the next token / word / step
     An LLM predicts the next token given / using / from
     An LLM predicts the next token given every / all / the
     An LLM predicts the next token given every thing / word / token
     An LLM predicts the next token given everything before / so / in
     An LLM predicts the next token given everything before “.” / “,” / “and”
     An LLM predicts the next token given everything before . (end) / It / This

     1 token ≈ ¾ of an English word, a punctuation mark, or a digit.22
     Unit of computation: pay per token in and out. The context window is sized in tokens.



ocelliq.com/astar-lr                                                                         10 / 73

## Slide 11 · PDF page 18 · What is a Large Language Model?

[Slide image](page-018.png)

2.3 What is a Large Language Model?


                         An LLM is Fancy Autocomplete
     • Blocks of linear algebra                     LLMs are black boxes: we have limited
       ‣ arranged in creative ways                  understanding of how they work.
       ‣ trained on every scrap of human media
                                                    LLMs are stochastic: Identical runs often
       ‣ unimaginable amounts of computation
                                                    produce different output.
       ‣ learn statistical patterns, not explicit
         rules about the world                      • Sunny skies ☀️, 30°C.
                                                    • 30°C with plenty of sunshine.
     • Behaviour surprisingly emerges at scale
                                                    • It's sunny and 30°C today.
       ‣ Exhibits strengths and weaknesses very
         different from humans                      Agent engineering extracts useful work
                                                    despite these limits.

ocelliq.com/astar-lr                                                                            11 / 73

## Slide 12 · PDF page 21 · Cost of AI

[Slide image](page-021.png)

2.4 Cost of AI
                                         60                                                                                                                              Claude Opus 5.5


                                                  Tremendous variety available!
                                                                                                                                                          Claude Sonnet 5.5
                                                                                                                                                                                           GPT-6 Astra
                                                                                                                                                        Gemini 4 Argon
                                                                                                                                                          GPT-6.1 Sol                        Claude Fable 5.1
                                                  Prices span three orders of magnitude.
Artificial Analysis Intelligence Index




                                         50                                                                                 Muse Spark 1.3
                                                                                                                   MiMo-V2.6-Pro             Grok 4.7
                                                                                                                                                                   Kimi K3
                                                                                                   GLM 5.3 Flash
                                                                                                                                         GLM 5.3
                                                                             DeepSeek V4.1 Flash
                                         40
                                                       Qwen3.8 27B




                                         30




                                         20




                                         10                                                                                                                                       Open weights
                                                  →      OpenRouter volume                                                                                                        Closed

                                              $0.001                                  $0.01                                  $0.10                                              $1.00
                                                                               Cost per task (100K input / 8K output tokens), log scale

          ocelliq.com/astar-lr                                                                                                                                                                     12 / 73

## Slide 13 · PDF page 23 · Cost of AI by Lab(Closed-Source)

[Slide image](page-023.png)

2.5 Cost of AI by Lab (Closed-Source)
                                         60                                                                                                                              Claude Opus 5.5


                                                  OpenAI, Anthropic, and Google
                                                                                                                                                          Claude Sonnet 5.5
                                                                                                                                                                                            GPT-6 Astra
                                                                                                                                                        Gemini 4 Argon
                                                  compete at the frontier.                                                                                GPT-6.1 Sol                           Claude Fable 5.1
Artificial Analysis Intelligence Index




                                         50                                                                                 Muse Spark 1.3
                                                                                                                   MiMo-V2.6-Pro             Grok 4.7
                                                                                                                                                                   Kimi K3
                                                                                                   GLM 5.3 Flash
                                                                                                                                         GLM 5.3
                                                                             DeepSeek V4.1 Flash
                                         40
                                                       Qwen3.8 27B




                                         30




                                         20
                                                                                                                                                                                       OpenAI
                                                                                                                                                                                       Google
                                                                                                                                                                                       Anthropic
                                         10                                                                                                                                            SpaceXAI
                                                  →      OpenRouter volume                                                                                                             Other

                                              $0.001                                  $0.01                                  $0.10                                              $1.00
                                                                               Cost per task (100K input / 8K output tokens), log scale

          ocelliq.com/astar-lr                                                                                                                                                                        13 / 73

## Slide 14 · PDF page 25 · Cost of AI by Launch DateNew→12+ months

[Slide image](page-025.png)

2.6 Cost of AI by Launch Date                                  New      →      12+ months

                                         60                                                                                                                                     Claude Opus 5.5


                                                  The AI revolution is ongoing, not
                                                                                                                                                                 Claude Sonnet 5.5
                                                                                                                                                                                                  GPT-6 Astra
                                                                                                                                                               Gemini 4 Argon
                                                  complete.                                                                                                      GPT-6.1 Sol                        Claude Fable 5.1
Artificial Analysis Intelligence Index




                                         50                                                                                        Muse Spark 1.3
                                                                                                                          MiMo-V2.6-Pro             Grok 4.7
                                                                                                                                                                          Kimi K3
                                                Highest intelligence prior to 9 Jun 2026                GLM 5.3 Flash
                                                                                                                                                GLM 5.3
                                                                                  DeepSeek V4.1 Flash
                                         40
                                                       Qwen3.8 27B




                                         30




                                         20




                                         10
                                                  →      OpenRouter volume

                                              $0.001                                       $0.01                                    $0.10                                              $1.00
                                                                                     Cost per task (100K input / 8K output tokens), log scale

          ocelliq.com/astar-lr                                                                                                                                                                            14 / 73

## Slide 15 · PDF page 26 · Cost of AI by Minimum Hosting Cost

[Slide image](page-026.png)

2.7 Cost of AI by Minimum Hosting Cost
                                         60                                                                                                                                    Claude Opus 5.5
                                                                                                                                                               Claude Sonnet 5.5
                                                                                                                                                                                                   GPT-6 Astra
                                                                                                                                                             Gemini 4 Argon
                                                                                                                                                               GPT-6.1 Sol                            Claude Fable 5.1
Artificial Analysis Intelligence Index




                                         50                                                                                      Muse Spark 1.3
                                                                                                                        MiMo-V2.6-Pro             Grok 4.7
                                                                                                                                                                        Kimi K3 (2.8T)
                                                                                                        GLM 5.3 Flash
                                                                DeepSeek V4.1 Flash                                                           GLM 5.3
                                         40
                                                       Qwen3.8 27B




                                         30




                                         20                                                                                                                      Indicative hosting hardware (SGD)
                                                                                                                                                                         ≤S$5k             ≤S$500k
                                                                                                                                                                         ≤S$10k            >S$500k
                                                                                                                                                                         ≤S$25k            Other
                                                                                                                                                                         ≤S$100k
                                         10
                                                  →      OpenRouter volume                                                                                   Higher tiers: 4 / 8 / 16 sessions budgeted

                                              $0.001                                       $0.01                                  $0.10                                                  $1.00
                                                                                      API cost per task (US$, 100K input / 8K output), log scale

          ocelliq.com/astar-lr                                                                                                                                                                              15 / 73

## Slide unnumbered · PDF page 27 · What makes AI Agentic?

[Slide image](page-027.png)

3.   What makes AI Agentic?

## Slide 17 · PDF page 28 · What makes AIAgentic?

[Slide image](page-028.png)

3.1 What makes AI Agentic?

     Simple LLM                                      Agentic AI
                       Your prompt                                                              Your prompt             System
                                                                                           agentic loop




                                                       observe, steer, or add context
                                                                                                                         Tools
                                                                                                     LLM            • Web search
                        Inference                                                                                   • Code execution
                                                                                                                    • File read/write
                                                                                                   Harness          • MCP Tools
                                                                                                                    • APIs / databases
                                                                                                                    • Other agents

                                                                                                                         Skills
                          Done                                                                      Done


        “Given this question, what do I answer?”                                        “Given this goal, what do I do next?”

     A agent is an LLM with a harness, which provides tools to interact the world.
ocelliq.com/astar-lr                                                                                                                     17 / 73

## Slide 18 · PDF page 29 · Anatomy of an Agent

[Slide image](page-029.png)

3.2 Anatomy of an Agent


     Tools include:
     • Sending and receiving emails/messages     Agentic AI
     • Interacting with your ERP software                                                Your prompt       System
       ‣ Approving/denying transactions
                                                                                    agentic loop
     • Controlling machines




                                                   observe, steer, or add context
                                                                                                            Tools
     • Performing scientific analysis                                                         LLM      • Web search
     • Spending money or resources                                                                     • Code execution
                                                                                                       • File read/write
       ‣ Reserving rooms                                                                    Harness    • MCP Tools
       ‣ Purchasing equipment                                                                          • APIs / databases
                                                                                                       • Other agents
     • Connecting to a database
                                                                                                            Skills
                                                                                             Done
     Skills are human-language instructions on
     how to do something.

ocelliq.com/astar-lr                                                                                                        18 / 73

## Slide 19 · PDF page 30 · What does it this look like?

[Slide image](page-030.png)

3.3 What does it this look like?




     • Everyday AI apps hide what           Your input →
       happens behind the scenes.
     • Today, you’ll get a first taste
       of the professional AI tools
       your technical teams use.             Tool call →

     • You’ll see the full trace: your     Tool output →
       input, tool calls, tool outputs,
       and the agent’s response.          Agent output →




ocelliq.com/astar-lr                                       19 / 73

## Slide unnumbered · PDF page 31 · LLM intelligence ≠ Human intelligence

[Slide image](page-031.png)

4.
     LLM intelligence
     ≠ Human intelligence

## Slide 21 · PDF page 32 · LLM intelligence fails in common ways

[Slide image](page-032.png)

4.1 LLM intelligence fails in common ways

                 LLMs fail in common ways that are a foreseeable source of business risk.

     • Overconfidence: expresses certainty independent of correctness.30
     • Credulity/Sycophancy: accepts falsehoods or agrees with you despite contradictions.31
     • Hallucinations: invents facts, citations, or details that sound plausible.
     • Theory-of-mind / world-model failure: misjudges what people know or how actions
       affect the world.32
     • Specification gaming / reward hacking: exploits a rule or reward while missing the
       intended goal.33




ocelliq.com/astar-lr                                                                           21 / 73

## Slide 22 · PDF page 33 · Theory of Mind:Understanding Intentions

[Slide image](page-033.png)

4.2 Theory of Mind: Understanding Intentions
     Project Vend: an AI shopkeeper37
     Anthropic ran an experiment with an AI
     shopkeeper that could set prices.
     • Employees persuaded it to offer discounts
       and give away stock.
     • 25% employee discount when
       approximately 99% of customers were
       employees.
     • Products sold below cost; the shop lost
       money.

     Should the agent represent the owners
     or shoppers interests?

                                                   Anthropic · 27 June 202537
ocelliq.com/astar-lr                                                            22 / 73

## Slide 23 · PDF page 34 · Hallucinations

[Slide image](page-034.png)

4.3 Hallucinations


     Hallucination: the model        TechCrunch38

     states something confidently,
     fluently, and wrong.

     An American military AI
     hallucinated nuclear
     weapons components on a
     Chinese vessel’s cargo
     manifest.7
     “entirely false” but it also
     “almost started a war”


ocelliq.com/astar-lr                           23 / 73

## Slide 24 · PDF page 35 · Hallucinations

[Slide image](page-035.png)

4.4 Hallucinations




     AI may hallucinate medically relevant
     abnormalities when denoising scans.

     AI-enhanced PET/SPECT denoising can look
     “visually compelling and nearly
     indistinguishable” from a reference scan —
     while inventing lesions or erasing real ones.39




                                                       Xia et al. · DREAM · Fig. 539
ocelliq.com/astar-lr                                                              24 / 73

## Slide 25 · PDF page 36 · Hallucinations

[Slide image](page-036.png)

4.5 Hallucinations

     South Africa withdrew its
     draft AI policy.

     Its reference list contained fictitious
     sources that appeared to have been
     generated by AI.40


      “AI-generated citations were included
      without proper verification. This
      should not have happened.”
      Solly Malatsi, Minister of Communications and Digital
      Technologies

                                                              Reuters / MyJoyOnline40
ocelliq.com/astar-lr                                                                    25 / 73

## Slide unnumbered · PDF page 37 · Governing Agentic AI

[Slide image](page-037.png)

5.   Governing Agentic AI

## Slide 27 · PDF page 39 · IMDA Model Governance framework

[Slide image](page-039.png)

5.1 IMDA Model Governance framework


                        IMDA publishes the Model AI Governance Framework for
                        Agentic AI (v1.5, May 2026)41
                        It gives you the structure and tools to weigh risks and write
                        policies for your own organization.
                        Alternatives include:

                                                                      OWASP43
                                     ISO/IEC 4200142
                                                                      Agentic AI:
                                     AI management
                                                                      Threats and
                                     systems
                                                                      Mitigations



ocelliq.com/astar-lr                                                                    27 / 73

## Slide 28 · PDF page 40 · The Four Pillars

[Slide image](page-040.png)

5.2 The Four Pillars 41


                           A.   Assess and bound the risks upfront
                                is an agent appropriate? what is the minimum
                                authority it needs? what’s the blast radius?


                           B.
                            Make humans meaningfully accountable
                            name individuals, responsibilities, and require human
                            approval at real decision points.


                           C.   Implement technical controls and processes
                                enforce safeguards structurally for provable
                                guarantees, not only in the prompt.


                           D.   Enable end-user responsibility
                                equip end-users and consumers to operate and
                                oversee the agent responsibly.

ocelliq.com/astar-lr                                                            28 / 73

## Slide 29 · PDF page 42 · The Seven Risks

[Slide image](page-042.png)

5.3 The Seven Risks 41

      1.     Erroneous actions
             mistakes from flawed reasoning or execution.

      2.     Unauthorized actions
             acting outside the agent’s permitted scope.
                                                                       old risks, new target
      3.     Biased or unfair actions
             outputs that produce unfair outcomes across groups.       well-understood problems,

      4.     Data breaches
             exposure or manipulation of sensitive data.
                                                                       established mitigations


      5.     Disruption to connected systems
             disrupting a system the agent touches.
                                                                   }
           When you have autonomous or multi-agent systems:

      6.    Speed and volume
            agents outpace real-time human oversight.
                                                                       risk multiplier


      7.    Cascading or compounding effects
            a mistake in one step amplifies downstream.
                                                                   }
                                                                       speed and reach outrun
                                                                       existing safeguards
ocelliq.com/astar-lr                                                                            29 / 73

## Slide 30 · PDF page 43 · Even the Experts Get Burned

[Slide image](page-043.png)

5.4 Even the Experts Get Burned

         Seven Risks
      ✘ Erroneous actions
      ✘ Unauthorized actions
      3. Biased or unfair actions
      4. Data breaches
      5. Disrupt connected systems
      ✘ Speed and volume
      7. Cascading effects
        Four Pillars
                                         Meta’s director of AI alignment had OpenClaw
     ✘ Assess and bound risks
                                         expunge her emails without approval.44
     B. Make humans accountable
     ✘ Technical controls                I had to run to my Mac mini like I was defusing a bomb.
     D. Enable end-user responsibility                                            — Summer Yue

ocelliq.com/astar-lr                                                                          30 / 73

## Slide 31 · PDF page 45 · Getting It Right:Ask D.A.V.I.D.

[Slide image](page-045.png)

5.5 Getting It Right: Ask D.A.V.I.D.

        Seven Risks                      Ask D.A.V.I.D.45 (JPMorgan)
     1. Erroneous actions                Multi-agent investment research
     ✓ Unauthorized actions
     3. Biased or unfair actions         • Supervisor agent + specialist sub-agents (SQL,
     ✓ Data breaches                       RAG, analytics)
     5. Disrupt connected systems        • Human advisor reviews every output before it
     6. Speed and volume                   reaches a client
                                         • ~95% reduction in research time
     7. Cascading effects
                                         • Internal-only tool.
        Four Pillars
                                         Speculation:
     ✓ Assess and bound risks
     ✓ Make humans accountable           • Restricted to pre-approved data sources.
     ✓ Technical controls
     D. Enable end-user responsibility
ocelliq.com/astar-lr                                                                        31 / 73

## Slide 32 · PDF page 47 · Getting It Right:Hippocratic AI

[Slide image](page-047.png)

5.6 Getting It Right: Hippocratic AI

        Seven Risks                    Hippocratic AI46
     ✓ Erroneous actions               Voice agents for healthcare
     ✓ Unauthorized actions
     3. Biased or unfair actions       • Post-discharge follow-up, medication walkthroughs
     4. Data breaches                  • Company reports 0 severe-harm events and
     5. Disrupt connected systems        180M+ patient interactions
                                       • “Polaris” safety, validated by 7,500+ clinicians
     ✓ Speed and volume
                                       • Narrow scope — non-diagnostic patient support
     7. Cascading effects
                                      Speculation:
        Four Pillars
     ✓ Assess and bound risks         • AI provides a conversational interface layered on
     B. Make humans accountable         top of a provably-correct decision system.
     ✓ Technical controls             • Check what the AI is saying mid-conversation with
     ✓ Enable end-user responsibility   automated guardrails.

ocelliq.com/astar-lr                                                                     32 / 73

## Slide 33 · PDF page 49 · Getting It Wrong:Klarna

[Slide image](page-049.png)

5.7 Getting It Wrong: Klarna

         Seven Risks
      1. Erroneous actions
      2. Unauthorized actions            Customer support that went “too far”
      ✘ Biased or unfair actions
                                         • Feb 2024: claimed work of 700 reps, projected $40M
      4. Data breaches
                                           profit boost47
      5. Disrupt connected systems
                                         • Quality decayed on disputes, fraud, bereavement
      ✘ Speed and volume
                                         • May 2025: CEO walked it back48
      7. Cascading effects
                                           ‣ “we went too far”
        Four Pillars                       ‣ “what you end up having is lower quality”
     ✘ Assess and bound risks
     ✘ Make humans accountable
     C. Technical controls
     D. Enable end-user responsibility
ocelliq.com/astar-lr                                                                        33 / 73

## Slide 34 · PDF page 51 · Getting It Wrong:Hacking the Evaluation

[Slide image](page-051.png)

5.8 Getting It Wrong: Hacking the Evaluation

         Seven Risks
      1. Erroneous actions
      ✘ Unauthorized actions
      3. Biased or unfair actions        OpenAI · July 2026 cybersecurity evaluation5
      ✘ Data breaches
                                         • Read public evaluation code and reverse-
      ✘ Disrupt connected systems
                                           engineered answers
      6. Speed and volume
                                         • Tried to fool the scorer and disguise their actions49
      ✘ Cascading effects                • Collaborated through an unauthorized message
        Four Pillars                       board
     ✘ Assess and bound risks            • Compromised 41 Hugging Face production
     B. Make humans accountable            workers50
     ✘ Technical controls
                                         Hugging Face disclosed the breach on 16 July.
     D. Enable end-user responsibility
                                         OpenAI connected it to its agents on 20 July.5
ocelliq.com/astar-lr                                                                           34 / 73

## Slide unnumbered · PDF page 52 · IMDA Framework applied to IMCB's ATLAS

[Slide image](page-052.png)

6.
     IMDA Framework
     applied to IMCB’s ATLAS

## Slide 36 · PDF page 53 · IMCB ATLAS

[Slide image](page-053.png)

6.1 IMCB ATLAS

                       ATLAS is IMCB’s AI business intelligence platform.
                       It answers questions about grants, personnel, and contracts
                       where facts are spread across many business units.
                       • “What is the current renewal/mid-grant reporting?”
                       • “Is the grant extension consistent with staff contracts?”
                       • “Has this PA stalled out?”
                       • “Was the virement complete before the tender?”
                       • Consumes a variety of business function documents
                         (LOA, PA, Contracts, etc.)
                       Answers different questions for different people
                       (management, PIs, staff)

           AT L A S    High-risk application of AI.

ocelliq.com/astar-lr                                                                 36 / 73

## Slide 37 · PDF page 55 · IMCB ATLAS:Document Flow

[Slide image](page-055.png)

6.2 IMCB ATLAS: Document Flow
                             Producers             AT L A S           Consumers
                                 ED                   PA                  ED

                                 PI 1                LOA                  PI 1

                                 PI 2         PI 1 Project Update         PI 2

                             Contracts        PI 2 Project Update      Contracts

                                 HR                Appraisal              HR

                              Tech-biz             Licensing            Tech-biz
                                  ⋯                                         ⋯

           AT L A S
                                      Each consumer asks questions about the
                                         documents relevant to their role.
ocelliq.com/astar-lr                                                               37 / 73

## Slide 38 · PDF page 56 · Unauthorized access& data breach

[Slide image](page-056.png)

6.3 Unauthorized access & data breach
         Seven Risks                     Producers            AT L A S            Consumers
      1. Erroneous actions
                                            ED                   PA                    ED
      2. Unauthorized actions
      3. Biased or unfair actions           PI 1                LOA                    PI 1
      4. Data breaches
      5. Disrupt connected systems          PI 2         PI 1 Project Update           PI 2
      6. Speed and volume
      7. Cascading effects               Contracts       PI 2 Project Update        Contracts

        Four Pillars                        HR                Appraisal                HR
     A. Assess and bound risks
     B. Make humans accountable           Tech-biz            Licensing              Tech-biz
     C. Technical controls                   ⋯                                          ⋯
     D. Enable end-user responsibility       What is the biggest risk of doing this naively,
                                             with a single chatbot that everyone talks to?
ocelliq.com/astar-lr                                                                            38 / 73

## Slide 39 · PDF page 58 · Your AI workspace

[Slide image](page-058.png)

6.4 Your AI workspace




           Files         Current Document   Claude




ocelliq.com/astar-lr                                 39 / 73

## Slide 40 · PDF page 60 · AI-driven AI analysis

[Slide image](page-060.png)

6.5 AI-driven AI analysis

     The simplest solution is to have a single ATLAS chatbot and tell it who can see which files.
     What business risk does this expose you to?
     1. Use AI to analyze ATLAS
      /slides Explain what could go wrong if ATLAS had one shared
      chatbot without access control?

     2. Apply the governance framework
      Explain with /imda-ai-governance the risks for an executive
      audience in two sentences.

     3. Control the risk
      Explain a technical control for this.

ocelliq.com/astar-lr                                                                                40 / 73

## Slide 41 · PDF page 63 · Unauthorized access& data breach

[Slide image](page-063.png)

6.6 Unauthorized access & data breach
        Seven Risks                      Producers            AT L A S            Consumers
     1. Erroneous actions
                                            ED                   PA                    ED
     ✓ Unauthorized actions
     3. Biased or unfair actions           PI 1                 LOA                   PI 1
     ✓ Data breaches
     5. Disrupt connected systems           PI 2        PI 1 Project Update           PI 2
     6. Speed and volume
     7. Cascading effects                Contracts      PI 2 Project Update        Contracts

        Four Pillars                        HR               Appraisal                 HR
     A. Assess and bound risks
     B. Make humans accountable           Tech-biz           Licensing              Tech-biz
     C. Technical controls                  ⋯                                          ⋯
     D. Enable end-user responsibility     Access control policy: ATLAS can only read or
                                           write documents that PI 1 is authorised to access.
ocelliq.com/astar-lr                                                                            41 / 73

## Slide 42 · PDF page 64 · Unauthorized access:policy and control

[Slide image](page-064.png)

6.7 Unauthorized access: policy and control

         Seven Risks                     The risk
      1. Erroneous actions               Users may access documents (reading or writing)
      2. Unauthorized actions            they are not supposed to, leaking business secrets.
      3. Biased or unfair actions
                                         Policy questions
      4. Data breaches
                                         • Who may read which documents?
      5. Disrupt connected systems
                                         • Who may write, and to which records?
      6. Speed and volume
                                         • How and when is access revoked when someone
      7. Cascading effects
                                           leaves?
        Four Pillars
     A. Assess and bound risks           Technical control: Role-Based Access Control
     B. Make humans accountable          ATLAS can only read/write documents the user has
     C. Technical controls               access to.
     D. Enable end-user responsibility

ocelliq.com/astar-lr                                                                           42 / 73

## Slide 43 · PDF page 65 · Erroneous action

[Slide image](page-065.png)

6.8 Erroneous action
         Seven Risks                     Producers         AT L A S          Consumers
      1. Erroneous actions
                                            ED                 PA                ED
      2. Unauthorized actions
      3. Biased or unfair actions           PI 1           LOA                   PI 1
      4. Data breaches
      5. Disrupt connected systems          PI 2       PI 1 Project Update       PI 2
      6. Speed and volume
      7. Cascading effects               Contracts     PI 2 Project Update    Contracts

        Four Pillars                        HR             Appraisal             HR
     A. Assess and bound risks
     B. Make humans accountable           Tech-biz         Licensing           Tech-biz
     C. Technical controls                   ⋯                                     ⋯
     D. Enable end-user responsibility        What if the LLM misreads the document?

ocelliq.com/astar-lr                                                                      43 / 73

## Slide 44 · PDF page 66 · Cascading effects

[Slide image](page-066.png)

6.9 Cascading effects
         Seven Risks                     Producers           AT L A S           Consumers
      1. Erroneous actions
                                            ED                  PA                   ED
      2. Unauthorized actions
      3. Biased or unfair actions           PI 1             LOA                     PI 1
      4. Data breaches
      5. Disrupt connected systems          PI 2        PI 1 Project Update          PI 2
      6. Speed and volume
      7. Cascading effects               Contracts      PI 2 Project Update       Contracts

        Four Pillars                        HR               Appraisal               HR
     A. Assess and bound risks
     B. Make humans accountable           Tech-biz           Licensing            Tech-biz
     C. Technical controls                  ⋯                                         ⋯
     D. Enable end-user responsibility     What if the error flows into downstream business
                                                               decisions?
ocelliq.com/astar-lr                                                                          44 / 73

## Slide 45 · PDF page 67 · Erroneous action:policy and control

[Slide image](page-067.png)

6.10 Erroneous action: policy and control

         Seven Risks                     The problem
      1. Erroneous actions
                                         The LLM misreads or misfiles a document, and the
      2. Unauthorized actions            error flows into every later answer.
      3. Biased or unfair actions
      4. Data breaches                   Policy questions
      5. Disrupt connected systems       • Which conclusions are high-risk and need
      6. Speed and volume                  immediate human verification?
      7. Cascading effects               • Which conclusions are safe to check only when
        Four Pillars                       an error is discovered?
     A. Assess and bound risks           • Once an error is discovered, who owns the
     B. Make humans accountable            correction?
     C. Technical controls               • How can we accurately and simply communicate
     D. Enable end-user responsibility     the veracity of information to consumers?

ocelliq.com/astar-lr                                                                        45 / 73

## Slide 46 · PDF page 68 · AI-driven AI analysis

[Slide image](page-068.png)

6.11 AI-driven AI analysis

     How can human oversight catch documents that AI files incorrectly?
     1. Use AI to analyze ATLAS
      /slides What could go wrong if ATLAS files a document
      incorrectly? Explain with /imda-ai-governance.

     2. Balance risk with cost
      Give me an example of the same information being low or high
      risk based on use?

     3. Choose the right level of oversight
      Suggest a human check for each use, balancing the risk with
      the effort involved.

ocelliq.com/astar-lr                                                      46 / 73

## Slide 47 · PDF page 69 · Erroneous action:policy and control

[Slide image](page-069.png)

6.12 Erroneous action: policy and control


     Pillar B: Make humans meaningfully         Pillar D: Enable end user responsibility
     accountable
                                                How can we ensure consumers are not led
     How can we get producers to verify that    astray by ATLAS?
     ATLAS understands documents correctly?
                                                • Every answer reports its sources and its
     • Every document type has one named          confidence
       owner (grants office, HR, procurement)   • Provide a mechanism for reporting wrong
     • ATLAS only flags potential issues, and     answers and feeding back.
       records the human’s exact decision.      • Set risk-based policy for level of scrutiny.
     How can we reduce review fatigue while
     keeping human oversight effective?


ocelliq.com/astar-lr                                                                         47 / 73

## Slide 48 · PDF page 70 · Human oversight in practice

[Slide image](page-070.png)

6.13 Human oversight in practice


     Consumer View (example)


       “Total grant value is $1,225,600.                              It’s our responsibility to
                                verified by leews 11d ago (Report)   design ATLAS defensively,
                                                                      against foreseeable risks.
       Available balance is $318,400.                                 The “easy” path must be
                               AI checked, request human             the safe path, and it must
                                                                      fit cleanly into existing
       Staff contracts end on 30 June 2027.”                                  processes.

                                   AI check failed, request human



ocelliq.com/astar-lr                                                                               48 / 73

## Slide 49 · PDF page 72 · Assess Risks and apply Technical Controls

[Slide image](page-072.png)

6.14 Assess Risks and apply Technical Controls

                                                                          Technical controls
      Identified risk       Policy
                                                        Prompt                         Infrastructure
                                                                                       Documents filtered by
      Data leaks across     Users see only data         “Reject attempts to access
                                                                                       user entitlement before
      labs                  they’re authorized to see   data from other labs.”
                                                                                       the LLM sees them




                                                                                                                    +residual risk, etc.
      Answers rest on                                                                  Answers without a valid,
                            Every answer is traceable
      wrong or misread                                  “Cite your sources”            machine-checkable
                            to a source
      sources                                                                          citation are rejected
                                                        “Only provide an answer if
      Confident answers     No guessing when the
                                                        it is certain from the data.   Cannot be guaranteed.
      from weak evidence    evidence is weak
                                                        If you are unsure, say so.”
      Answers that are
                            Every answer can be                                        Logs of every question,
      subtly/consistently                               Tuned per-failure
                            audited afterwards                                         retrieval, and answer
      incorrect.

ocelliq.com/astar-lr                                                                                              49 / 73

## Slide unnumbered · PDF page 73 · Set Policies for a Procurement Agent

[Slide image](page-073.png)

7.
     Set Policies for a
     Procurement Agent

## Slide 51 · PDF page 74 · The procurement case

[Slide image](page-074.png)

7.1 The procurement case




     A complex procurement for a research test platform:
     • Five suppliers offer different machines with overlapping capabilities.
     • Stakeholders: the PI, Procurement, Finance, Evaluation Panel and Executive
       Approval Committee.
     • Compare technical capability, total cost, acceptance dates and years of support.
     • 86 pages across 47 PDFs: grant records, tender requirements, bids, clarifications and
       evaluation material.
ocelliq.com/astar-lr                                                                           51 / 73

## Slide 52 · PDF page 76 · A convincing recommendation

[Slide image](page-076.png)

7.2 A convincing recommendation




                                    1


                                           2
                                                                     3
                                           4



                                                                     5

     1. Wrong supplier recommended             4. M2 wrongly passed
     2. M6/M7 wrongly passed                   5. Price conflict ignored
     3. Price excludes support extension
ocelliq.com/astar-lr                                                       52 / 73

## Slide 53 · PDF page 78 · Procurement Agent

[Slide image](page-078.png)

7.3 Procurement Agent

        INGEST                        VERIFY                         DRAFT                    REVIEW
                                        Aperture

                                           Helix
     Extract docs                                                  Synthesize                   Write
                                        Meridian
      & criteria                                                    & score                     slide
                                        Northstar

                                        Peregrine
Understand the requirements       Check each bid for         Score each correct bid using   Update the slides
                              completeness and correctness     the competitive criteria


     Your goal is to design and build a repeatable and dependable AI procurement advisor.

       Begin by assessing Verify. Why do we verify each bid in a separate subagent?

ocelliq.com/astar-lr                                                                                       53 / 73

## Slide 54 · PDF page 82 · Verify:check each offered commitment

[Slide image](page-082.png)

7.4 Verify: check each offered commitment

         Seven Risks                     • Use evidence from another bidder.
      1. Erroneous actions               • Miss a mandatory gate or misread a date or price.
      2. Unauthorized actions            • Treat a future promise as a submitted
      3. Biased or unfair actions          commitment.
      4. Data breaches                   • Pass an unresolved conflict to the next stage.
      5. Disrupt connected systems
                                          What would you want to check before accepting
      6. Speed and volume
                                          a pass?
      7. Cascading effects
        Four Pillars
     A. Assess and bound risks
     B. Make humans accountable
     C. Technical controls
     D. Enable end-user responsibility

ocelliq.com/astar-lr                                                                       54 / 73

## Slide 55 · PDF page 83 · Verify:stage boundaries

[Slide image](page-083.png)

7.5 Verify: stage boundaries


     Stage and purpose         Each bidder’s verifier checks all mandatory gates (seven here).
     Accountable owner         The Evaluation Panel is accountable for each gate decision.
     Allowed data and tools Use only the criteria, assigned bid, reader and calculator.
     Permitted actions         Recommend pass, fail or unresolved for each gate.
     Human approvals           The Panel approves gates; Procurement, Finance or the technical
                               owner (PI) resolves disputes.
     Prohibited actions        Do not invent terms, use rival bids or contact suppliers.
     Stop and escalation       Pause until the responsible reviewer resolves missing or
                               conflicting evidence.
     Evidence log              Record sources, calculations, gate results and open issues.

ocelliq.com/astar-lr                                                                             55 / 73

## Slide 56 · PDF page 87 · Ingest:preserve the evidence

[Slide image](page-087.png)

7.6 Ingest: preserve the evidence

         Seven Risks                     • Extract the wrong clause, date or table row.
      1. Erroneous actions               • Treat a generated summary as an authoritative
      2. Unauthorized actions              source.
      3. Biased or unfair actions        • Follow instructions hidden inside a document.
      4. Data breaches                   • Read material outside the assigned case.
      5. Disrupt connected systems
                                          Which sources should the next stage be able to
      6. Speed and volume
                                          trace?
      7. Cascading effects
        Four Pillars
     A. Assess and bound risks
     B. Make humans accountable
     C. Technical controls
     D. Enable end-user responsibility

ocelliq.com/astar-lr                                                                       56 / 73

## Slide 57 · PDF page 88 · Ingest:stage boundaries

[Slide image](page-088.png)

7.7 Ingest: stage boundaries


     Stage and purpose        Extract the criteria and prepare source packets.
     Accountable owner        Procurement (Mira Tan) owns this stage.
     Allowed data and tools Use only this case and a scoped reader or extractor.
     Permitted actions        Extract and classify evidence, citing its source.
     Human approvals          Procurement approves criteria; the technical owner (PI) and
                              Finance check their parts.
     Prohibited actions       Do not read other cases, edit sources or send material.
     Stop and escalation      Ask Procurement to resolve unclear criteria before handoff.
     Evidence log             Record files, source locations, versions and exceptions.


ocelliq.com/astar-lr                                                                        57 / 73

## Slide 58 · PDF page 92 · Draft:settle gates before scoring

[Slide image](page-092.png)

7.8 Draft: settle gates before scoring

         Seven Risks                      • Rank a bid using an unsupported gate result.
      1. Erroneous actions                • Invent scores, weights or a missing price.
      2. Unauthorized actions             • Lose a conflict when combining verifier reports.
      3. Biased or unfair actions         • Use a stale packet after evidence changes.
      4. Data breaches
                                           What must be settled before a bid can be ranked?
      5. Disrupt connected systems
      6. Speed and volume
      7. Cascading effects
        Four Pillars
     A. Assess and bound risks
     B. Make humans accountable
     C. Technical controls
     D. Enable end-user responsibility

ocelliq.com/astar-lr                                                                           58 / 73

## Slide 59 · PDF page 93 · Draft:stage boundaries

[Slide image](page-093.png)

7.9 Draft: stage boundaries



     Stage and purpose        Combine verification results and calculate scores.
     Accountable owner        The Evaluation Panel owns this stage; Finance (Joel) checks costs.
     Allowed data and tools Use reviewed packets, a calculator and a draft writer.
     Permitted actions        Score only eligible bids and draft the recommendation.
     Human approvals          The Panel approves gates and scores; Finance checks sums.
     Prohibited actions       Do not invent scores or prices, or award the tender.
     Stop and escalation      Return open gates or stale packets to their reviewer.
     Evidence log             Record input versions, formulae, open issues and edits.


ocelliq.com/astar-lr                                                                           59 / 73

## Slide 60 · PDF page 97 · Review:make human approval meaningful

[Slide image](page-097.png)

7.10 Review: make human approval meaningful

         Seven Risks                     • Leave a decisive caveat out of a polished slide.
      1. Erroneous actions               • Mistake a draft recommendation for approval.
      2. Unauthorized actions            • Rubber-stamp claims without checking sources.
      3. Biased or unfair actions        • Use an approval for an outdated version.
      4. Data breaches
                                          What evidence would help a reviewer make a
      5. Disrupt connected systems
                                          real decision?
      6. Speed and volume
      7. Cascading effects
        Four Pillars
     A. Assess and bound risks
     B. Make humans accountable
     C. Technical controls
     D. Enable end-user responsibility

ocelliq.com/astar-lr                                                                          60 / 73

## Slide 61 · PDF page 98 · Review:stage boundaries

[Slide image](page-098.png)

7.11 Review: stage boundaries


     Stage and purpose        Prepare the leadership slide and supporting review pack.
     Accountable owner        Procurement (Mira Tan) owns this stage; specialists check claims.
     Allowed data and tools Use the draft, source excerpts, review records and writer.
     Permitted actions        Reconcile claims with evidence and show unresolved issues.
     Human approvals          Procurement approves routing; the committee awards the tender.
     Prohibited actions       Do not contact suppliers, amend bids or invent sign-off.
     Stop and escalation      Hold release and ask Procurement about missing or stale
                              approval.
     Evidence log             Record claims, edits, reviewers, decisions and versions.


ocelliq.com/astar-lr                                                                          61 / 73

## Slide unnumbered · PDF page 99 · Where do we go from here?

[Slide image](page-099.png)

8.   Where do we go from here?

## Slide 63 · PDF page 100 · Workflows get complicated

[Slide image](page-100.png)

8.1 Workflows get complicated


                        web     draft
                   Search agent A        Critic                             Slides    GATE

                               revise
    Task /                                        reject
                   Search agent B        Critic            ✕   Synthesize   Email     GATE       Output
    query

                   Search agent C        Critic                              Log      GATE




                                    Today, we’ve only scratched the surface.
               AI engineering offers new and effective tools for putting policy into practice.


ocelliq.com/astar-lr                                                                                63 / 73

## Slide 64 · PDF page 101 · Humans are still in charge

[Slide image](page-101.png)

8.2 Humans are still in charge

         Seven Risks                     Our frameworks are tools to operationalize this.
      1. Erroneous actions
      2. Unauthorized actions
      3. Biased or unfair actions
      4. Data breaches
      5. Disrupt connected systems
      6. Speed and volume
      7. Cascading effects
        Four Pillars
     A. Assess and bound risks
     B. Make humans accountable
     C. Technical controls
     D. Enable end-user responsibility                 IBM Training Manual, 1979

ocelliq.com/astar-lr                                                                        64 / 73

## Slide 65 · PDF page 102 · The future of AI

[Slide image](page-102.png)

8.3 The future of AI

     • IPOs for Anthropic/OpenAI expected.          • New regulations on the use of AI
       ‣ Huge upheaval in market.                     ‣ EU AI Act; South Korea’s AI Basic Act.
       ‣ Will affect closed- and open-weight          ‣ China’s AI-content labelling, and bans on
         markets                                        virtual AI partners.
                                                      ‣ NYC bias audits for hiring tools.
     • Regulations to restrict access to frontier
       intelligence                              • Resist vendor lock-in
       ‣ Synthetic biology research is tightly     ‣ Pace of development mean long-term
         limited.                                    value is still unknown
       ‣ This will expand.                         ‣ Expensive value-added services may be
                                                     much cheaper or obsolete in months.
     • Increased interest in “local” models.
                                                   ‣ Keep your data exportable and your
       ‣ Provides freedom and control, sometimes
                                                     workflows portable.
         cost savings.
       ‣ Hardware depreciates quickly.
ocelliq.com/astar-lr                                                                           65 / 73

## Slide unnumbered · PDF page 103 · The future of AI

[Slide image](page-103.png)

OcelliQ.com/astar-lr
      Download the course slides.
Free AI training slides and exercises for   Connect with me on
   your institute: beginner to expert.          LinkedIn.

## Slide 67 · PDF page 104 · References

[Slide image](page-104.png)

References
     1.   Amazon News. Amazon CEO Andy Jassy talks 6 truths surrounding the rise of AI. 2026.
     2.   Microsoft. The golden opportunity for American AI. 3 January 2025.
     3.   Anthropic. Estimating AI productivity gains from Claude conversations. 25 November 2025.
          Research projections.
     4.   Gartner. Worldwide AI Spending Forecast. 16 September 2026. AI infrastructure: US$1.484 trillion
          forecast for 2026.
     5.   OpenAI. The Hugging Face incident and the road ahead. 26 August 2026. Postmortem of the July
          2026 cybersecurity-evaluation incident.
     6.   The Guardian. AI agent deletes a firm’s database. 29 April 2026.
     7.   CNN, syndicated by KTVZ. US military close call after a false AI intelligence report. 18 September
          2026. Reporting based on unnamed sources, not an official incident finding.
     8.   The Planetary Society.
          How much did the Apollo program cost?.
          Apollo, 1960-1973: US$309 billion in 2025 dollars.
     9.   AskEngineers discussion.
          Hypothetical Great Wall rebuilding estimate.
          2015. Informal estimate; not a professional quotation. Exact US$452 billion value not
          independently verified.
ocelliq.com/astar-lr                                                                                           67 / 73

## Slide 68 · PDF page 105 · References

[Slide image](page-105.png)

References
     10. Workshop illustrative model.
         Cumulative global datacenter spending.
         Supplied historical anchors and adjustment assumptions; not a measured historical series.
     11. Gartner.
         Data Center Electricity Consumption Forecast.
         10 June 2026. AI-optimized servers: 175 TWh forecast for 2026.
     12. Energy Market Authority, Singapore.
         Singapore Energy Statistics: Energy Consumption.
         2024 electricity consumption: 58 TWh.
     13. China Three Gorges Corporation.
         Three Gorges annual power generation.
         19 November 2020. Designed annual generation: 88.2 TWh; distinct from actual output.
     14. Info-Tech Research Group. Discover the Enterprise AI Technology Stack.
     15. NIST. AI Risk Management Framework: AI RMF Core.
     16. Andreessen Horowitz. Emerging Architectures for LLM Applications.
     17. Amazon Web Services. Layered approach for a generative AI platform. AWS Prescriptive Guidance.
     18. NVIDIA. AI’s five-layer cake.

ocelliq.com/astar-lr                                                                                  68 / 73

## Slide 69 · PDF page 106 · References

[Slide image](page-106.png)

References
     19. Ajay Agrawal, Joshua Gans, Avi Goldfarb.
         Prediction Machines: The Simple Economics of Artificial Intelligence.
         Harvard Business Review Press, 2018.
     20. William Stanley Jevons.
         The Coal Question, Chapter VII: Of the Economy of Fuel.
         First published 1865; linked text is the second edition, Macmillan, 1866.
     21. Daron Acemoglu, Simon Johnson.
         Power and Progress: Our Thousand-Year Struggle Over Technology and Prosperity.
         PublicAffairs, 2023. Further reading on technology and prosperity.
     22. OpenAI.
         Tokenizer.
         Interactive examples of tokenization.
     23. OpenRouter. Daily token totals for top 50 models. Usage feed. Prices and listing dates: models
         catalog. Snapshot: 30 September 2026.
     24. Artificial Analysis, via OpenRouter. Artificial Analysis Intelligence Index. Benchmark snapshot: 30
         September 2026. Stored curated scores and teaching overrides: 01-intro/data/README.md.
     25. Artificial Analysis. Gemini 4 Argon: Google is back as one of the top three labs in intelligence
         achieved. 30 September 2026. AAII 53 (high); standard input/output pricing of US$4/US$20 per
         million tokens, before the introductory discount.
ocelliq.com/astar-lr                                                                                           69 / 73

## Slide 70 · PDF page 107 · References

[Slide image](page-107.png)

References
     26. Artificial Analysis. Muse Spark 1.3 (max). Read 2 October 2026. AAII 48 under Intelligence Index
         v4.3.2; later benchmark reading than the stored September snapshot.
     27. Moonshot AI. Kimi K3 model card. 2.8T total parameters; native MXFP4 weights. Read 2 October
         2026.
     28. DeepSeek. DeepSeek V4.1 Flash model card. 552B backbone plus 196B Engram lookup parameters.
         Read 2 October 2026.
     29. Z.ai. GLM 5.3 Flash model card. 320B total parameters. Read 2 October 2026.
     30. Tobias Groot and Matias Valdenegro-Toro. Overconfidence is Key: Verbalized Uncertainty Evaluation
         in Large Language and Vision-Language Models. TrustNLP 2024, pp. 145-171.
     31. Sharma et al. Towards Understanding Sycophancy in Language Models. 2023.
     32. Shapira et al. Clever Hans or Neural Theory of Mind? Stress Testing Social Reasoning in Large
         Language Models. arXiv:2305.14763, 2023.
     33. Anthropic. Sycophancy to Subterfuge: Investigating Reward Tampering in Language Models. 17 June
         2024. Controlled training experiments; not established as common production behavior.
     34. John R. Searle.
         Minds, brains, and programs.
         Behavioral and Brain Sciences 3(3), 417-424, 1980. Chinese Room argument.

ocelliq.com/astar-lr                                                                                    70 / 73

## Slide 71 · PDF page 108 · References

[Slide image](page-108.png)

References
     35. Wallace et al. The Instruction Hierarchy: Training LLMs to Prioritize Privileged Instructions. OpenAI,
         2024.
     36. Liu et al. Lost in the Middle: How Language Models Use Long Contexts. arXiv:2307.03172 (2023);
         Transactions of the Association for Computational Linguistics, 2024.
     37. Anthropic. Project Vend, phase one. 27 June 2025. Claude Sonnet 3.7 running a real office shop with
         Andon Labs.
     38. Aditya Mehta, TechCrunch. AI hallucination nearly triggers US military operation. 18 September
         2026.
     39. Menghua Xia et al.
         DREAM: On hallucinations in AI-generated content for nuclear medicine imaging.
         arXiv:2506.13995v2, 18 June 2025. Sections III-IV; displayed image is Figure 5.
     40. Reuters. South Africa withdraws draft AI policy over fictitious references. 27 April 2026. Screenshot:
         Reuters republication on MyJoyOnline, 28 April 2026.
     41. Infocomm Media Development Authority (IMDA). Model AI Governance Framework for Agentic AI.
         Version 1.5. Published 20 May 2026; updated 5 June 2026. Local PDF and extracts in references/
         imda-agentic-ai/.



ocelliq.com/astar-lr                                                                                          71 / 73

## Slide 72 · PDF page 109 · References

[Slide image](page-109.png)

References
     42. International Organization for Standardization / International Electrotechnical Commission.
         ISO/IEC 42001:2023 — Artificial intelligence — Management system.
         First edition, December 2023.
     43. OWASP GenAI Security Project, Agentic Security Initiative.
         Agentic AI — Threats and Mitigations.
         Version 1.0, 17 February 2025.
     44. Summer Yue.
         First-person account of OpenClaw deleting her inbox.
         22 February 2026. Post and screenshots; does not establish permanent loss of all messages.
     45. David Odomirok and Zheng Xue, JPMorgan Chase Private Bank.
         Investment Research with LangGraph: Ask D.A.V.I.D..
         LangChain Interrupt, May 2025. Primary conference presentation; 95% time-reduction figure
         unverified.
     46. Hippocratic AI.
         Hippocratic AI Launches Polaris 5.0.
         2026 company announcement. Patient-volume, clinician-validation and safety statistics are
         company-reported. Scope: non-diagnostic clinical conversations.


ocelliq.com/astar-lr                                                                                   72 / 73

## Slide 73 · PDF page 110 · References

[Slide image](page-110.png)

References
     47. Klarna.
         AI assistant handles two-thirds of customer service chats.
         27 February 2024. Company release: work equivalent to 700 agents; projected US$40 million profit
         improvement.
     48. Charles Daly, Bloomberg.
         Klarna Slows AI-Driven Job Cuts With Call for Real People.
         8 May 2025. CEO interview; full text requires a subscription.
     49. METR and Redwood Research.
         Brief independent investigation of agents’ behavior, reasoning and collaboration in the OpenAI /
         Hugging Face hacking incident.
         26 August 2026. Observed small-scale tool-call spoofing in roughly 7% of reviewed transcripts;
         broader scorer-tampering attempts were not all successful.
     50. OpenAI.
         OpenAI – Hugging Face Incident Technical Report.
         August 2026. Section IV.B, pp. 9–11: code execution on 41 production workers, root access on at
         least one node, and access to credentials and limited private data.




ocelliq.com/astar-lr                                                                                    73 / 73
