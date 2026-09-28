# Aperture technical compliance schedule

APR-02 · Version 1.0 · 2026-08-27 · Aperture Reliability Systems · submitted

Fictional training case; all people, organisations, products, rules and events are invented.

### APR-02 T1

| Row | Requirement | AR-72 response |
| --- | --- | --- |
| T-01 | Per-run positions | 72 |
| T-02 | Temperature range, °C | −40 to 125 |
| T-03 | Load range, N | 0 to 500 |
| T-04 | Electrical bias, V | 0 to 24 |
| T-05 | Raw export | CSV and JSON, local without hosted subscription |
| T-06 | Training | Eight staff on site |

## APR-02 §3 Configuration and measurement record

APR-02 §3.1 — The AR-72 architecture provides a broad bank of addressable test positions and a detailed local event history. Aperture expects the chamber to support larger cohorts and reduce the number of separate runs needed for a given study. Run records include position identifiers, applied profiles, measured values and alarm events for later analysis.

APR-02 §3.2 — The position count in row T-01 is a simultaneous capacity for the delivered Atlas Encabulator AR-72; it does not aggregate separate runs. Each active position is associated with a channel identifier in the exported record. The controller associates setpoints, readings and event timestamps with a run so the laboratory can compare specimens under the same programmed conditions.

## APR-02 §4 Export and verification

APR-02 §4.1 — CSV and JSON exports can be saved to the Institute's local storage without an ongoing hosted account. The supplier will provide a field guide covering timestamp format, units, channel identifiers, event codes and file naming. During SAT, a sample file and an event log will be produced from the installed configuration and reconciled with selected values displayed by the controller.

## APR-02 §5 Test record conventions

APR-02 §5.1 — For the delivered AR-72, each specimen position is given a channel identifier before a controlled run starts. The operator records the run identifier, specimen mapping and selected profile, then reviews any warnings before release. Aperture's broad channel logger records actual readings separately from programmed setpoints so the research team can distinguish a prescribed condition from a measured response. The 72-position count is the installed simultaneous configuration described in row T-01.

APR-02 §5.2 — At acceptance, a representative run should exercise the installed large-cohort chamber, export a raw file and verify that the event record can be linked back to a position and timestamp. The operator guide should show which fields identify units, profile state, alarms and missing observations. A derivative chart or summary report may help interpretation, but the retained CSV or JSON source remains the laboratory's reproducible research record.

## Workbook cells

Every cell by sheet, row and column letter. Formula cells show the stored result followed by the formula.

### Sheet: Technical

| Row | A | B | C |
| --- | --- | --- | --- |
| 1 | Row | Requirement | AR-72 response |
| 2 | T-01 | Per-run positions | 72 |
| 3 | T-02 | Temperature range, °C | −40 to 125 |
| 4 | T-03 | Load range, N | 0 to 500 |
| 5 | T-04 | Electrical bias, V | 0 to 24 |
| 6 | T-05 | Raw export | CSV and JSON, local |
| 7 | T-06 | Training places | 8 |
