# Teams message to Luis (ISIT) for today's ORR meeting, 1 October 2026

**Attach:** `Operation_Readiness_Review_ORR_Checklist_SACRED_v2.xlsx` (updated this afternoon: transfer week, and
the production-home action added) and `SACRED-to-Production-Programme-Chart-2026-10-01.pdf` (draft 4).

---

Luis, thank you for coordinating today's meeting. Attached are two documents:

1. **The Operational Readiness checklist, populated from our side (v2).** Of the 30 items, 3 are met, 26 are open with a named owner and a date, and 1 is not applicable. Most of the open items are ISIT actions. The workbook also has the known error log, the support model (RACI), the service components and the open actions as separate sheets.
2. **The SACRED to Production programme chart, draft 4, issued today.** It has been updated since the version IT received, so please read this one.

Three things have changed since IT last saw the plan:

- **The transfer is now the week of 19 October.** I am in Houston that week for the WCE SME workshop, and the scanner files move from my PC to the sacred server with Adam Snyder on one of those days. Every date after it moves with it.
- **The database is no longer an IT ask.** I have built it on Microsoft Fabric myself (SQL database `SACRED DATA`, loaded from the scanner's own export under my sign-in). No server, no secret, nothing installed, no ISIT resource. The only item that will reach IT is Fabric capacity on Lee's cost centre in mid-November, which is a licence line.
- **A critical item that is not in the readiness checklist: the production home.** The sacred server (`sdrlazneuiis01d`) is the sandbox. Moving the scanner to it under a service account makes the task ISIT's, but it does not put anything into production: the pages, the share and the task would still be running on the sandbox. ISIT need to decide whether that server becomes the production server or a production server is built, and to plan the cutover, because the server name is in the dashboard links the notification emails carry, the SSORT write-back share, the scanner config and the rigs' bookmarks. I have added it to the Open actions sheet (ISIT Infrastructure, decision by 10 October) and to the chart as M2a. Has this been accounted for on your side?

Before the week of the 19th, ISIT need to provide:

1. A service account for the scheduled task: read on the three WellControl report libraries, write on the Digests library and on the two IIS folders behind the sacred share.
2. The decisions by **10 October** on the library path to the server, Service Desk Plus, SIAM, and the production home above.
3. The Teams app approval for Ask SACRED AI, submitted 16 September.

**On today's call:** I am happy to walk through our progress. But there is a substantial amount in the checklist for ISIT to review, most of the open actions need an ISIT owner to commit to a date, and the production-home question needs Infrastructure in the room. The people on today's call may not be able to do that without reading the documents first. I would suggest we use today for the overview, the three dependencies above and the production-home question, and reconvene early next week, before the 10 October decision date, once everyone has read both documents. That way the decisions are made in the meeting rather than taken away, and the transfer week holds.

Dan

---

## Shorter version, if Teams needs it

Luis, thank you for coordinating today's meeting. Attached are the Operational Readiness checklist populated from our side (v2: 3 of 30 met, 26 open with owners and dates, mostly ISIT actions) and the programme chart, draft 4 of today, updated since the version IT had.

Three changes: the transfer is now the week of 19 October, when I am in Houston with Adam; the database is built on Fabric by me and needs no IT resource; and one critical item that is not in the checklist: the sacred server is the sandbox, so even after the transfer nothing is in production until ISIT name the production home and plan the cutover. Has that been accounted for? It is on the Open actions sheet with a 10 October decision date, alongside the service account, the library-path decision and the Teams app approval.

Given how much there is for ISIT to review, I suggest today covers the overview and those dependencies, and we reconvene early next week, before 10 October, once everyone has read both documents, so the decisions can be made in the room.

Dan
