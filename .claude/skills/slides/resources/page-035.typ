== Hallucinations

// OVERLAP: Partial overlap with the governance section: "The Seven Risks" (erroneous actions) and ATLAS verification controls. The PET/SPECT imaging case itself does not recur.
#speaker-note[
  Editorial overlap: Partial overlap with the governance section: "The Seven Risks" (erroneous actions) and ATLAS verification controls. The PET/SPECT imaging case itself does not recur.
]

#grid(
  columns: (1fr, auto),
  align: horizon,
  gutter: 2em,
  [
    *AI may hallucinate medically relevant abnormalities when denoising scans.*
    #v(1em)
    AI-enhanced PET/SPECT denoising can look "visually compelling and nearly indistinguishable" from a reference scan --- while inventing lesions or erasing real ones.#cite-source("https://arxiv.org/html/2506.13995v2#S3")[Menghua Xia et al. \ _DREAM: On hallucinations in AI-generated content for nuclear medicine imaging_. \ arXiv:2506.13995v2, 18 June 2025. Sections III-IV; displayed image is Figure 5.]
    #v(1em)

  ],
  screenshot-image(
    "media/hallucination/dream-hallucinationIndex.png",
    [Xia et al. · DREAM · Fig. 5#cite-source("https://arxiv.org/html/2506.13995v2#S3")[Menghua Xia et al. _DREAM: On hallucinations in AI-generated content for nuclear medicine imaging_. arXiv:2506.13995v2, 18 June 2025. Figure 5.]],
    height: 100%,
  ),
)

#speaker-note[
  - DREAM paper (arXiv:2506.13995): benchmarks hallucination in AI-denoised PET/SPECT nuclear medicine imaging
  - Figure 5: red arrows mark false generated content; yellow arrows highlight clearer anatomical structures and better visual quality. They do not indicate erased lesions.
  - The paper distinguishes added false content (hallucinations) from omitted lesions (other errors). The hallucination index measures differences from the reference; this is a generative-model issue across modalities.
  - Stakes are different in medicine: a hallucinated lesion, or an erased real one, is a diagnostic error, not a wrong citation
]
