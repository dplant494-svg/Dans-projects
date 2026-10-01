# Teams message to Luis (ISIT) for today's ORR meeting, 1 October 2026

**Attach:** `Operation_Readiness_Review_ORR_Checklist_SACRED_v2.xlsx` and
`SACRED-to-Production-Programme-Chart-2026-10-01.pdf` (draft 3).

---

Luis, thank you for coordinating today's meeting. Attached are two documents:

1. **The Operational Readiness checklist, populated from our side (v2).** Of the 30 items, 3 are met, 26 are open with a named owner and a date, and 1 is not applicable. Most of the open items are ISIT actions, and the workbook has the known error log, the support model (RACI), the service components and the open actions as separate sheets.
2. **The SACRED to Production programme chart, draft 3, issued today.** It has been updated since the version IT received, so please read this one.

Two things have changed since IT last saw the plan:

- **The database is no longer an IT ask.** I have built it on Microsoft Fabric myself (SQL database `SACRED DATA`, loaded from the scanner's own export under my sign-in). No server, no secret, nothing installed, no ISIT resource. The only item that will reach IT is Fabric capacity on Lee's cost centre in mid-November, which is a licence line.
- **The critical date is Sunday 18 October.** That is when the scanner files move from my PC to the sacred server, with Adam Snyder, while I am in Houston. Every date after it moves day for day with it. Three things must be in place before then, and they are all ISIT's:
  1. A service account for the scheduled task: read on the three WellControl report libraries, write on the Digests library and on the two IIS folders behind the sacred share.
  2. ISIT's decisions by **10 October** on the library path to the server, Service Desk Plus and SIAM (ORR items 8 and the known error log).
  3. The Teams app approval for Ask SACRED AI, submitted 16 September.

**On today's call:** I am happy to walk through our progress. But there is a substantial amount in the checklist for ISIT to review, and most of the open actions need an ISIT owner to commit to a date, which the people on today's call may not be able to do without reading it first. I would suggest we use today for the overview and the three 18 October dependencies above, and reconvene early next week, before the 10 October decision date, once everyone has read both documents. That way the decisions are made in the meeting rather than taken away, and the 18 October date holds.

Dan

---

## Shorter version, if Teams needs it

Luis, thank you for coordinating today's meeting. Attached are the Operational Readiness checklist populated from our side (v2: 3 of 30 met, 26 open with owners and dates, mostly ISIT actions) and the programme chart, draft 3 of today, updated since the version IT had.

Two changes: the database is built on Fabric by me and needs no IT resource; and the critical date is Sunday 18 October, when the scanner moves to the sacred server with Adam while I am in Houston. Before then ISIT need to provide the service account, the 10 October decisions on the library path, SDP and SIAM, and the Teams app approval.

Given how much there is for ISIT to review, I suggest today covers the overview and the 18 October dependencies, and we reconvene early next week, before 10 October, once everyone has read both documents, so decisions can be made in the room.

Dan
