# Peregrine technical compliance schedule

PRG-02 · Version 1.0 · 2026-08-24 · Peregrine Instrumentation · submitted

Fictional training case; all people, organisations, products, rules and events are invented.

### PRG-02 T1

| Row | Requirement | CE-24 response |
| --- | --- | --- |
| T-01 | Per-run positions | 24 |
| T-02 | Temperature range, °C | −40 to 125 |
| T-03 | Load range, N | 0 to 500 |
| T-04 | Electrical bias, V | 0 to 24 |
| T-05 | Raw export | CSV and JSON, local without hosted subscription |
| T-06 | Training | Eight staff on site |

PRG-02 §2 — Two consecutive runs can process 48 samples over time, but the submitted CE-24 has 24 simultaneous positions. A capacity expansion is not included.

## PRG-02 §3 Configuration and measurement record

PRG-02 §3.1 — The CE-24 is built around a compact chamber with individually logged positions and reusable run profiles. The proposed workflow is to schedule cohorts in successive controlled cycles, export each run separately and combine results later in the research analysis store. The offered chamber remains the 24-position configuration shown in the technical schedule.

PRG-02 §3.2 — The position count in row T-01 is a simultaneous capacity for the delivered Compact Encabulator CE-24; it does not aggregate separate runs. Each active position is associated with a channel identifier in the exported record. The controller associates setpoints, readings and event timestamps with a run so the laboratory can compare specimens under the same programmed conditions.

## PRG-02 §4 Export and verification

PRG-02 §4.1 — CSV and JSON exports can be saved to the Institute's local storage without an ongoing hosted account. The supplier will provide a field guide covering timestamp format, units, channel identifiers, event codes and file naming. During SAT, a sample file and an event log will be produced from the installed configuration and reconciled with selected values displayed by the controller.

## PRG-02 §5 Test record conventions

PRG-02 §5.1 — For the delivered CE-24, each specimen position is given a channel identifier before a controlled run starts. The operator records the run identifier, specimen mapping and selected profile, then reviews any warnings before release. Peregrine's per-run controller records actual readings separately from programmed setpoints so the research team can distinguish a prescribed condition from a measured response. The 24-position count is the installed simultaneous configuration described in row T-01.

PRG-02 §5.2 — At acceptance, a representative run should exercise the installed compact chamber, export a raw file and verify that the event record can be linked back to a position and timestamp. The operator guide should show which fields identify units, profile state, alarms and missing observations. A derivative chart or summary report may help interpretation, but the retained CSV or JSON source remains the laboratory's reproducible research record.

## Workbook cells

Every cell by sheet, row and column letter. Formula cells show the stored result followed by the formula.

### Sheet: Technical

| Row | A | B | C |
| --- | --- | --- | --- |
| 1 | Row | Requirement | CE-24 response |
| 2 | T-01 | Per-run positions | 24 |
| 3 | T-02 | Temperature range, °C | −40 to 125 |
| 4 | T-03 | Load range, N | 0 to 500 |
| 5 | T-04 | Electrical bias, V | 0 to 24 |
| 6 | T-05 | Raw export | CSV and JSON, local |
| 7 | T-06 | Training places | 8 |
