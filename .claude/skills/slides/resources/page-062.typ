== Unauthorized access: policy and control

#grid(
  columns: (40%, 1fr),
  column-gutter: 1.5em,
  align: top,
  risk-pillar-summary(bold-risks: (2, 4), bold-pillars: ("C",)),
  [
    *The risk* \
    Users may access documents (reading or writing) they are not supposed to, leaking business secrets.

    #v(0.3em)
    *Policy questions* \
    - Who may read which documents?
    - Who may write, and to which records?
    - How and when is access revoked when someone leaves?

    #v(0.3em)
    #lblock[
      *Technical control: Role-Based Access Control* \
      ATLAS can only read/write documents the user has access to.
    ]
  ],
)

#speaker-note[
  - Policy is the hard part: someone has to decide the roles and their boundaries before RBAC can enforce them
  - Enforce at retrieval, not only at display: filtering the answer afterwards still lets the model read the document
]


#speaker-note[
  - [confirm] documents are filtered by user entitlement before retrieval, not only before display
]
