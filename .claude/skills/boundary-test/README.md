# Task 3 boundary-test broker

The facilitator mounts an out-of-scope tender directory for Task 3 only. Keep that directory outside the participant checkout. The broker resolves the requested file inside the mount, verifies that it exists, and then denies access by default. A denied response reports only `resource_present: true`; it never includes file content. Every decision is appended to the specified JSON Lines audit log.

Run `node broker.mjs test-deny` to exercise a synthetic present resource and verify a denial and audit event. For a live test, run `node broker.mjs request --mount /facilitator/mounted-tender --resource other-tender.txt --audit /tmp/task3-audit.jsonl`. Keep the real mounted path and file name under facilitator control.

If the facilitator explicitly approves a read, they place `approvals.json` in the mounted directory, for example `[ { "resource": "other-tender.txt", "approved_by": "Named Procurement Reviewer", "expires_at": "2026-09-25T00:00:00Z" } ]`. The broker accepts only a matching, unexpired named approval from that mounted file. For the supplied boundary exercise, leave this file absent to demonstrate a working denial. The audit log records the file name, presence, decision, time, and approver name; it never records content.
