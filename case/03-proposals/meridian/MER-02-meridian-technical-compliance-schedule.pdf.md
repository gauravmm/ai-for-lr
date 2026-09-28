# Meridian technical compliance schedule

MER-02 · Version 1.0 · 2026-08-26 · Meridian Scientific Systems · submitted

Fictional training case; all people, organisations, products, rules and events are invented.

### MER-02 T1

| Row | Requirement | RE-300 response |
| --- | --- | --- |
| T-01 | Per-run positions | 52 |
| T-02 | Temperature range, °C | −40 to 125 |
| T-03 | Load range, N | 0 to 500 |
| T-04 | Electrical bias, V | 0 to 24 |
| T-05 | Raw export | CSV and JSON, local without hosted subscription |
| T-06 | Training | Eight staff on site |

## MER-02 §3 Configuration and measurement record

MER-02 §3.1 — The RE-300 provides individually identified positions within a shared environmental profile. Meridian's controller records the applied profile beside measured values and flags interrupted runs for review. The laboratory can retain the native export file, its documented field definitions and the run metadata in its own research store.

MER-02 §3.2 — The position count in row T-01 is a simultaneous capacity for the delivered Reliance RE-300; it does not aggregate separate runs. Each active position is associated with a channel identifier in the exported record. The controller associates setpoints, readings and event timestamps with a run so the laboratory can compare specimens under the same programmed conditions.

## MER-02 §4 Export and verification

MER-02 §4.1 — CSV and JSON exports can be saved to the Institute's local storage without an ongoing hosted account. The supplier will provide a field guide covering timestamp format, units, channel identifiers, event codes and file naming. During SAT, a sample file and an event log will be produced from the installed configuration and reconciled with selected values displayed by the controller.

## MER-02 §5 Test record conventions

MER-02 §5.1 — For the delivered RE-300, each specimen position is given a channel identifier before a controlled run starts. The operator records the run identifier, specimen mapping and selected profile, then reviews any warnings before release. Meridian's event-oriented controller records actual readings separately from programmed setpoints so the research team can distinguish a prescribed condition from a measured response. The 52-position count is the installed simultaneous configuration described in row T-01.

MER-02 §5.2 — At acceptance, a representative run should exercise the installed reliability platform, export a raw file and verify that the event record can be linked back to a position and timestamp. The operator guide should show which fields identify units, profile state, alarms and missing observations. A derivative chart or summary report may help interpretation, but the retained CSV or JSON source remains the laboratory's reproducible research record.

## Workbook cells

Every cell by sheet, row and column letter. Formula cells show the stored result followed by the formula.

### Sheet: Technical

| Row | A | B | C |
| --- | --- | --- | --- |
| 1 | Row | Requirement | RE-300 response |
| 2 | T-01 | Per-run positions | 52 |
| 3 | T-02 | Temperature range, °C | −40 to 125 |
| 4 | T-03 | Load range, N | 0 to 500 |
| 5 | T-04 | Electrical bias, V | 0 to 24 |
| 6 | T-05 | Raw export | CSV and JSON, local |
| 7 | T-06 | Training places | 8 |
