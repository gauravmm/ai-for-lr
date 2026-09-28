# Tender compliance and weighted scoring workbook

EVAL-01 · Version 0.9 · 2026-09-03 · Evaluation Panel working file · evaluation

Fictional training case; all people, organisations, products, rules and events are invented.

### EVAL-01 Gate

| Vendor | M1 | M2 | M3 | M4 | M5 | M6 | M7 | Gate | Support end used | Source |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Northstar | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pass | 2030-03-31 | EMAIL-02 thread |
| Meridian | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pass | 2030-03-31 | MER-05 §1.1 |
| Helix | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pass | 2030-03-31 | HLX-05 §1.1 |
| Peregrine | Pass | Pass | Fail | Pass | Pass | Pass | Pass | Fail | 2030-03-31 | PRG-02 T-01 |
| Aperture | Fail | Fail | Pass | Pass | Pass | Pass | Pass | Fail | 2030-03-31 | APR-03 C6; APR-04 I-04 |

### EVAL-01 Score

| Vendor | Technical | Cost | Delivery | Service | Weighted total |
| --- | --- | --- | --- | --- | --- |
| Northstar | 94 | 94 | 92 | 82 | 91.8 |
| Meridian | 90 | 84 | 86 | 82 | 86.2 |
| Helix | 86 | 62 | 96 | 90 | 81.4 |
| Peregrine | — | — | — | — | Not scored |
| Aperture | — | — | — | — | Not scored |

EVAL-01 §1 — Working workbook. Northstar's support end date is a typed input sourced at thread level from EMAIL-02; the M6 and M7 gate cells follow that input. Scores are arithmetically calculated from locked panel scores.

## Workbook cells

Every cell by sheet, row and column letter. Formula cells show the stored result followed by the formula.

### Sheet: Mandatory Gate

| Row | A | B | C | D | E | F | G | H | I | J | K |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Vendor | M1 | M2 | M3 | M4 | M5 | M6 | M7 | Gate | Support end used | Source |
| 2 | Northstar | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pass [=IF(COUNTIF(B2:H2,"Fail")=0,"Pass","Fail")] | 2030-03-31 | EMAIL-02 thread |
| 3 | Meridian | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pass [=IF(COUNTIF(B3:H3,"Fail")=0,"Pass","Fail")] | 2030-03-31 | MER-05 §1.1 |
| 4 | Helix | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pass [=IF(COUNTIF(B4:H4,"Fail")=0,"Pass","Fail")] | 2030-03-31 | HLX-05 §1.1 |
| 5 | Peregrine | Pass | Pass | Fail | Pass | Pass | Pass | Pass | Fail [=IF(COUNTIF(B5:H5,"Fail")=0,"Pass","Fail")] | 2030-03-31 | PRG-02 T-01 |
| 6 | Aperture | Fail | Fail | Pass | Pass | Pass | Pass | Pass | Fail [=IF(COUNTIF(B6:H6,"Fail")=0,"Pass","Fail")] | 2030-03-31 | APR-03 C6; APR-04 I-04 |

### Sheet: Weighted Scores

| Row | A | B | C | D | E | F |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Vendor | Technical | Cost | Delivery | Service | Weighted total |
| 2 | Northstar | 94 | 94 | 92 | 82 | 91.8 [=ROUND(B2*35%+C2*30%+D2*20%+E2*15%,1)] |
| 3 | Meridian | 90 | 84 | 86 | 82 | 86.2 [=ROUND(B3*35%+C3*30%+D3*20%+E3*15%,1)] |
| 4 | Helix | 86 | 62 | 96 | 90 | 81.4 [=ROUND(B4*35%+C4*30%+D4*20%+E4*15%,1)] |
