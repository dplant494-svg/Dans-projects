# Operational Readiness Review, SACRED: the gap against ISIT's 30 criteria

**For:** ISIT PMO, via Dan Plant · **Date:** 30 September 2026 · **Live document:**
`Operation_Readiness_Review_ORR_Checklist_SACRED_v1.xlsx` (the ISIT checklist filled in, plus six sheets:
Support Model (RACI), Service components, Known error log, Test summary, DR and early-life support, Open actions)
**Context:** the programme chart sent to IT (server handover Sunday 18 October 2026 with Adam Snyder; supported
service February 2027) and the reply to IT's ten questions of 28 September.

## The score, honestly

| | Count |
|---|---|
| Criteria met today | 3 (1 service owner; 11 known errors and workarounds; 12 recurring tasks scheduled) |
| Not met, with an owner and a date on each | 26 |
| Not applicable | 1 (26, no project-delivered equipment) |
| Rated High if not met | 2 (8 the library path to the server; 16 security and architecture review) |
| Rated Medium | 10 |
| Rated Low | 14 |

Every "not met" line has the evidence that exists, what is missing, who owns it and a date. Twelve of the 26
are ISIT's own configuration (ManageEngine, CMDB, Service Desk, SIAM, SDP decision, backups, capacity) and
cannot be met from our side; they are on the "Open actions" sheet with the ISIT role named.

## The three things that matter before 18 October

1. **How the three report libraries reach the server (criterion 8, High).** Today OneDrive sync under Dan's
   account feeds the scanner. Under a service account on a server that has to be a scheduled pull or a sync
   under that account; the migration handoff §2 sets out both. Until it is decided and built, a server scanner
   reads nothing. Decision by 10 October, built on the 18th with Adam Snyder.
2. **The service account** (criteria 7, 8, 12): read on the three report libraries, write on Digests and on
   the two IIS folders. No secret, nothing to rotate.
3. **Backup of `D:\TSC-Dashboard`** (criterion 7): the script, the config and the state files. SharePoint is
   the system of record and the share is regenerated from it, so the exposure is one full rescan and possible
   repeat notifications, not data.

## The one thing that matters before February

**Security and architecture review (criterion 16, High).** Not done. The ten-question reply covers the
security facts (accounts, no secrets, permissions, the signed intake URL, the hashed password gates, no external
services); the build is submitted for the Architecture, Security and Governance review after the transfer, by
31 October (milestone M8b on the chart).

## What was written tonight to close what could be closed

- A **RACI** for every component, with the contact and escalation path (criteria 2, 18).
- A **service components** list for the CMDB owner (22): server, shares, libraries, sync path, six flows, the
  agent, the four tools, the workbook, the database.
- A **known error log** of eleven items with the workaround and the planned fix (11).
- A **test summary** of what was proven, how and when, from 11 September to today, plus the two planned proofs
  (the dual run and the class UAT) (9, 19).
- A **DR and early-life support** page: what is the system of record, what to back up, a rebuild-from-nothing
  procedure under an hour, rollback, the early-life proposal (18 Oct to 6 Nov dual run; ISIT shadow-run to
  February), and a DR test proposal during the dual run (5, 28, 29, 30).
- An **open actions** sheet: nineteen actions, each with an owner and a date.

## What is handed to the other tool maintainers

Criteria 6, 7, 9, 11, 19, 22 and 27 have a tool-side half that only the tool maintainers hold (their runbooks,
their test records, their known errors, their component entries, their local-save retention). The asks are in
`ORR-HANDOFF-FOR-TOOLS.md`, one section per maintainer, due 7 October, and land on the same sheets.

## Dates on the Open actions sheet

| Date | What |
|---|---|
| 7 Oct | tool maintainers' returns |
| 9 Oct | Digests freshness alert built |
| 10 Oct | ISIT decisions: library path to the server, SDP required or not, SIAM applicable or not |
| 18 Oct | transfer; service account; backup; RACI confirmed; early-life support accepted; DR procedure handed over |
| 20 Oct | UAT sign-off from the WCE SME class |
| 31 Oct | security and architecture submission; Fabric capacity decision |
| 6 Nov | Dan's PC task disabled; runbooks reviewed; ManageEngine, CMDB, Service Desk configured; retention agreed; DR rebuild tested |
| Feb 2027 | ISIT accept the service (M11) |
