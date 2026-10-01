# Email to IT — the SACRED to Production programme chart, 30 September 2026

**To:** [IT contact from the Copilot-agent questions thread]; Adam Snyder
**Cc:** Lee Arnold
**Subject:** SACRED to production: programme chart, scanner transfer to the server in the week of 19 October
**Attach:** `SACRED-to-Production-Programme-Chart-2026-10-01.pdf` (two pages, draft 4 of 1 October)

---

Hi [name], Adam,

Attached is the current programme chart for taking the Well Control Equipment dashboards and their
scanner into production on the sacred server, with the milestones and what has changed since the
11 September version.

The one week I need in your calendars: **the week of 19 October**, when I am in Houston for the
WCE SME workshop, is when the scanner files move from my PC to the sacred server (`sdrlazneuiis01d`,
`D:\TSC-Dashboard`). Adam and I do it together on one of those days, and the scheduled task is
registered under a service account so ISIT own it from then on.

One thing I want to put on the table now, because it is not in the readiness checklist: the sacred
server is the sandbox. Moving the scanner to it makes the task yours, but it does not put anything in
production. ISIT need to decide whether that server becomes the production server or a production
server is built, and plan the cutover, because the server name sits in the dashboard links the
notification emails carry, the SSORT write-back share, the scanner config and the rigs' bookmarks. It
is on the chart as M2a with a decision date of 10 October.

What I need from ISIT before the week of the 19th:

1. A service account for the scheduled task, with read on the three WellControl report libraries,
   write on the Digests library, and write on the two IIS folders behind the sacred share. No
   secrets, nothing to rotate; the mechanism is the same as today.
2. The Teams app approval for the Ask SACRED AI agent, submitted 16 September. Nobody but me can
   open it until then.

One thing has come off your list since the last version: **the database**. I have built it myself on
Microsoft Fabric (a SQL database called `SACRED DATA` in my workspace, 22 tables and 6 views, loaded
from the scanner's own export under my sign-in). It needs no IT resource, no server, no secret and
nothing installed. The only item that will come your way is Fabric capacity on Lee's cost centre when
the trial ends in mid-November, which is a licence line, not engineering time. The January row on the
earlier chart that said "first IT resource" is gone.

The chart is honest about what is an estimate. Everything to the right of the transfer week moves with
it. The scanner today is v2.71, no modules, nothing installed, and the migration steps and the
acceptance checklist are in the handoff you already have (`SCANNER-SERVER-MIGRATION-IT-HANDOFF.pdf`).

Happy to walk through it on a call, or on the day in Houston.

Kind regards,

Dan Plant
Technical Superintendent, Well Control Engineering
[phone]

---

## Notes for Dan (not part of the email)

- Fill in the IT contact's name (the same person who sent the ten questions) and your phone.
- The transfer is the week of 19 October (draft 4). Name the day with Adam when you have it and the
  chart takes a single date again.
- The chart is built here, not by the reporting-tools session, so the applications rows carry their
  dates from the joint plan of 11 to 14 September. If you want their latest, send them the PDF and
  they can correct their five bars.
- Attach the PDF, not the HTML.
- Draft 4 (1 October) is the one to send: the transfer week, the database built by you on Fabric with no IT
  resource, and the production-home question. Earlier files are superseded.
