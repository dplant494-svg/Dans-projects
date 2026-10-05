# ORR return — the reporting tools (WCGRRT REV 167, SSORT REV 157)

**From:** the reporting-tools session · **To:** the dashboard session, via Dan
**Date:** 5 October 2026 · **Due 7 October** · **Owner of both tools:** Dan Plant, Technical
Services — Subsea

All six items from `ORR-HANDOFF-FOR-TOOLS.md`, one markdown file each, ready to paste onto the
workbook's sheets.

| File | ORR criteria | Item |
|---|---|---|
| `01-Runbook-ORR-6-7.md` | 6, 7 | How a revision is built, verified and published, step by step, including what "nothing posted" means during a test |
| `02-Test-records-ORR-19.md` | 19 | Verification by revision, WCGRRT 160–166 and SSORT 144–153 |
| `03-Known-errors-ORR-11.md` | 11 | Ten open items with workarounds, in the log's shape |
| `04-Components-ORR-22.md` | 22 | The two deployed files, their paths and URLs, and the two dependencies |
| `05-Local-data-and-retention-ORR-27.md` | 27 | What stays on the user's machine, for how long, and when it is the only copy |
| `06-UAT-ORR-9.md` | 9 | The Day 1 exercise as the acceptance test |

## Three things ISIT should not have to dig for

**1. The test records distinguish record from reconstruction.** Rows from SSORT REV 149 and WCGRRT
REV 166 onwards are first-hand, with the checks named. Earlier rows carry the file's real hash and
byte count — recomputed on 30 September and reproducible — but **no contemporaneous test log was
kept**, so "what was checked" there is inferred from the rolling handoff. That is a gap and it is
marked on every affected row rather than smoothed over. A per-revision record is part of the deploy
from now on.

**2. Between save and post, the rig's machine holds the only copy.** Nothing is held server-side
until a post succeeds — no draft on a server, no sync. The window is hours and sometimes days.
Local data is also unmanaged: no retention period is set or enforced for browser storage, the TSC
REPORTS folder or saved files, and the tools have no server-side component to enforce one from. If
a retention policy is required it has to come from machine management. See item 5.

**3. Two open items are not ours to close.** `KE-08`, the stale second SSORT copy on the `sacred`
share, needs IT to delete a file Dan has no rights to. `KE-10`, the intake URL being readable by
anyone who can open the tool, is raised for ISIT rather than answered — the trigger, its rotation
and anything in front of it belong to the dashboard side. The token is deliberately not reproduced
anywhere in this pack.

## Not covered here, by the handoff's own scope

ManageEngine, CMDB, Service Desk, SDP, SIAM, backups, capacity and the security review submission
are ISIT's or the dashboard side's and are already on the Open actions sheet.
