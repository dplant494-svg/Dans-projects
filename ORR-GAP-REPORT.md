# Operational Readiness Review, SACRED: the gap against ISIT's 30 criteria

**For:** ISIT PMO, via Dan Plant · **Date:** 30 September 2026, v2 (evening: the reporting-tools and Precharge Pro maintainers' returns pasted in; COC tracker and SPARC to follow via Lee) · **Live document:**
`Operation_Readiness_Review_ORR_Checklist_SACRED_v2.xlsx` (the ISIT checklist filled in, plus six sheets:
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

## v2: what the two tool maintainers' returns added, the same evening

Both returned in full within hours (filed under `tools/received/orr/`). Pasted onto the sheets: two
runbooks, test records by revision, twenty more known errors, the tools' components with live hashes, the
retention facts, and the acceptance tests. Five things ISIT should not have to dig for:

1. **A stale second SSORT is served from the sacred share** (`sacred\index.html`, four revisions behind,
   badged wrongly). Dan cannot delete it. ISIT to delete, by 10 October.
2. **The intake URL, with its signature, is a literal in both tool files.** Anyone who can open a tool can
   post into the intake. Raised for ISIT to rate with the security submission; the token is nowhere in
   this pack.
3. **The precharge gate is a curtain, not a lock**, and the requests folder is reachable by URL without
   it; five of seven live request files carry an employee name and work email. Server-side IIS
   authentication before production closes both. Not changed before the class.
4. **Local data on rig machines is unmanaged and unbounded**: between save and post the rig holds the only
   copy, and browser storage and the TSC REPORTS folder hold personnel names and photographs indefinitely.
   The tools cannot enforce a policy; it has to come from machine management. For the retention decision.
5. **The test records say what is a record and what is a reconstruction.** First-hand from SSORT 149 and
   WCGRRT 166 (late September); earlier revisions have real hashes but no log kept on the day. The
   precharge calculator is verified per rig: 4 of 13, 2 in progress, 7 not yet reviewed, and its
   gate-check harness cannot currently run.

None of the five changes the score; all five are on the Open actions sheet with owners and dates.
