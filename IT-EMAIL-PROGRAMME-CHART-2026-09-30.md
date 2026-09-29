# Email to IT — the SACRED to Production programme chart, 30 September 2026

**To:** [IT contact from the Copilot-agent questions thread]; Adam Snyder
**Cc:** Lee Arnold
**Subject:** SACRED to production: programme chart, scanner transfer to the server on 18 October
**Attach:** `SACRED-to-Production-Programme-Chart-2026-09-30.pdf` (two pages)

---

Hi [name], Adam,

Attached is the current programme chart for taking the Well Control Equipment dashboards and their
scanner into production on the sacred server, with the milestones and what has changed since the
11 September version.

The one date I need in your calendars: **Sunday 18 October**, when I am in Houston, is when the
scanner files move from my PC to the sacred server (`sdrlazneuiis01d`, `D:\TSC-Dashboard`). Adam
and I do it together that day, and the scheduled task is registered under a service account so
ISIT own it from then on. The two days after it are the training class in Houston, so the server
copy is what the class sees.

What I need from ISIT before the 18th:

1. A service account for the scheduled task, with read on the three WellControl report libraries,
   write on the Digests library, and write on the two IIS folders behind the sacred share. No
   secrets, nothing to rotate; the mechanism is the same as today.
2. The Teams app approval for the Ask SACRED AI agent, submitted 16 September. Nobody but me can
   open it until then.

The chart is honest about what is an estimate. Everything to the right of 18 October moves with
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
- 18 October 2026 is a Sunday. It is on the chart and in the email as you gave it; if the transfer
  is actually the Monday morning before the class starts, say so and the chart is rebuilt in a minute.
- The chart is built here, not by the reporting-tools session, so the applications rows carry their
  dates from the joint plan of 11 to 14 September. If you want their latest, send them the PDF and
  they can correct their five bars.
- Attach the PDF, not the HTML.
