# ISIT meeting on SACRED, 1 October 2026: the notes, and what they change

**Received:** 2 October 2026 from Dan (the IT side's notes). **Filed by:** the dashboard session.
**Related:** `SACRED-WHAT-IT-IS-MADE-OF.md` (one page for Viren's Lovable feasibility and Infosys's gap work),
`WEEK-PLAN-2026-09-14.md` item 41, programme chart draft 5.

## The notes as received

**SACRED Support Status**
- SACRED currently running in a sandbox, not production
- No formal support capability; current support is "best effort"
- Operational Readiness Review and project plan completed and shared
- Multiple rigs have intermittent access due to selective test provisioning

**Production Readiness & Timeline**
- Target production go-live planned February 2027
- Full ISIT support expected once in production (budget release January 2027)
- Production readiness gaps identified
  - Infrastructure, hosting, backups, DNS, and ServiceNow support queues
  - Monitoring, observability, logging, auditing, SAML, and integrations
  - Application supportability, database management, and SDLC controls
- Significant development and security work required before formal handover

**Lovable Migration Option**
- Migration to Lovable platform proposed to reduce infrastructure and integration work
- Lovable licences have been procured; Viren is owner of that platform
- Migration expected to reduce support and documentation overhead in production

**UAT And Testing Environment**
- UAT environment agreed as the immediate next step for wider testing
- UAT will be supported on a best-effort basis until formal production handover
- Wider vessel testing intended to produce clearer support and resource requirements
- Heavy reporting load expected during specific operational windows (7–10 day periods)

**Next Steps**
- Adam: Provide estimated effort and requirements to build the UAT environment
- Adam + Daniel: Meet in Houston next week to define UAT requirements and testers
- Jason: Schedule a 30-minute follow-up next week to review progress
- Viren: Confirm feasibility and high-level plan for migrating SACRED to Lovable
- Saroj/Infosys: Deliver refined supportability gaps and effort estimates for production readiness
- Daniel: Ensure ORR, project plan, and failure logs remain current and accessible to IT
- Luis: Discuss timing and funding options with Arnold and Torsten for earlier support

## What the notes agree with, and what they change

**Agreed, and already on the chart.** Production in February 2027 is M11. The sandbox point is M2a (raised by Dan
on 1 October, now ISIT's own words). "Best effort until handover" is the early-life support proposal on the ORR's
"DR and early-life support" sheet. "Multiple rigs have intermittent access" is item 24 (the West Gemini's edge
router drops the route to the server; diagnosed 21 September, ticket sent); ISIT's phrase "selective test
provisioning" is the first time the cause has been named from their side, and it means the fix is theirs.

**New: a UAT environment comes before production.** This was not on any chart. It is the right thing for ISIT to
want (a second server they build, under their service account, where wider vessel testing happens) and it changes
the critical path: the transfer in the week of 19 October now lands on the sandbox *or* on UAT, depending on how
fast Adam can build it. Draft 5 of the chart shows UAT as its own row: Adam's estimate and the requirements next
week, the build as an estimate through mid-November, wider vessel testing from then into January, production in
February. Dan's dual run and the "two clean weeks" happen wherever the server task first runs.

**New: a budget date.** Full ISIT support is funded from January 2027. Everything ISIT do before then is best
effort, which is what the ORR says today. Luis is asking Arnold and Torsten whether it can start earlier.

**New: the Lovable question.** ISIT propose moving SACRED to Lovable to cut infrastructure and integration work.
This needs a decision on facts, not a position. `SACRED-WHAT-IT-IS-MADE-OF.md` lists the five parts of SACRED,
which of them could move to a hosted app platform and which cannot (the rig-side tools run offline on rig
laptops; the posting contract and the notification flows live in the Microsoft tenancy), and what a migration
would and would not remove. The honest summary: Lovable could replace the IIS server and the static pages, which
is ISIT's hosting burden; it would not remove the integration work, it would move it, and it would add a second
data store outside the tenancy. Viren's feasibility should be judged against that page. Until the decision is
made, nothing on the pages is duplicated and nothing is stopped.

**The gap list is ours to answer, not to argue.** Infrastructure, hosting, backups, DNS, ServiceNow queues,
monitoring, logging, auditing, SAML, supportability, database management, SDLC controls. Most are ISIT's own
rows on the ORR (the server, backups, the queues, the service account). Three are new words for things that
exist: logging (the scanner's run log and the last-successful-scan stamp), auditing (every post is a file in
SharePoint with its version history; every notification writes a receipt), SDLC (the Git repository, the HANDOFF
log per scanner version, the integration contract and the rolling handoff with the tools). SAML is the one that is
genuinely absent: the pages have no sign-in because IIS serves them to the internal network; the precharge gate
is a curtain (F-25). An authenticated path is on the chart for M10 and the IIS authentication row.

## Actions for Dan from the notes

| Who | What | By |
|---|---|---|
| Dan | Keep the ORR, the chart and the failure logs current and reachable by IT: the workbook v2, the chart PDF and `ORR-GAP-REPORT.md` go to one SharePoint folder IT can open, refreshed on every change (not emailed copies) | this week |
| Dan + Adam | UAT requirements and testers, Houston next week (the notes say next week; the chart has Dan in Houston the week of 19 October: confirm which) | week of 5 Oct |
| Dan | Send `SACRED-WHAT-IT-IS-MADE-OF.md` to Viren, Adam and Saroj before Viren's feasibility work starts | this week |
| Dan | Name the UAT testers: one per rig class, plus Lee's SMEs from the 19 to 22 October workshop | with Adam |
| Dan | Give Adam the 7 to 10 day heavy windows (BOP test periods, pre-deployment) with dates, so UAT capacity is sized to them | with Adam |
| Dan | Jason's 30-minute follow-up: have the UAT row and the Lovable page in front of you | next week |

## Questions for ISIT at the follow-up

1. Is the UAT server the sandbox renamed, or a second server? If a second, does the week-of-19-October transfer go
   to UAT directly (preferred: one move, not two)?
2. For the Lovable feasibility: which of the five parts is in scope? The rig-side tools cannot move; the flows and
   SharePoint stay. Is the proposal the dashboard pages only?
3. The "selective test provisioning" that blocks rigs: which rigs, and when is it lifted? Wider vessel testing on
   UAT cannot start on rigs that cannot reach the server.
4. Does the January budget cover the service account, the shared mailbox, the UAT server and the production home,
   or are those sandbox-era asks that need funding now?
