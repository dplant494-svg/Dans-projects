# Plan 2: Dan Plant, transition SACRED to Lovable

**Status:** draft 1, 2 October 2026. Purchase order for Lovable cut; the go-ahead is expected but not official.
Nothing in this plan starts until it is, except phase 0.
**Resource named:** Dan Plant (application owner and builder-owner of SACRED), about two days a week for twelve
weeks from the go-ahead, peaking in the parity phases.
**Others:** Viren (Lovable platform owner), Adam Snyder (ISIT infrastructure and UAT), Luis (ISIT PM), Saroj /
Infosys (supportability), Jason (follow-ups), Lee Arnold (co-owner, data owner).
**Runs beside:** the SACRED to Production plan (`WEEK-PLAN-2026-09-14.md`, chart draft 5). This plan replaces only
the "scanner and pages" column of that one. The server transfer, UAT, the flows, the database export, the training
class and the ORR all carry on, because the rigs keep using SACRED throughout.
**Reference:** `LOVABLE-REBUILD-NOTES.md` (what carries over, what is rebuilt, the ten things the platform cannot do
alone) and `SACRED-WHAT-IT-IS-MADE-OF.md`.

## Principles

1. **The live SACRED keeps running until the new one proves parity.** The scanner moves to the UAT server in the week
   of 19 October as planned; the rigs do not stop posting for a day.
2. **The rig tools do not change on day one.** They post the same file to the same trigger. The trigger writes to
   both stores during the parity run.
3. **One system of record.** Decide before any data is loaded twice whether Supabase (Lovable's database) or
   Fabric holds the record. Recommendation: Supabase becomes the record on cutover and Fabric is dropped, unless
   Power BI on Fabric has started by then.
4. **Nothing is rewritten that can be carried.** The data model (export schema 2, the DDL), the posting contract,
   the rules, the HAZID, the precharge arithmetic (ported, then re-verified), the training material.
5. **Decisions and asks first, build second.** Every ISIT ask below is raised the day the go-ahead is official,
   because each one has a lead time longer than the build step that needs it.

## Phase 0: before it is official (now to the go-ahead)

| What | Who | Dan's time |
|---|---|---|
| One-page to Viren, Adam, Saroj (sent) | Dan | done |
| Half-day render test: Lovable builds the Reports list and Rig Monitoring from the dashboard's data file and the database export. Pass = the same counts as the live page for the same day | Viren with Dan | 0.5 day |
| Three decisions on paper: hosting (Lovable-hosted on the public internet, or exported and self-hosted by ISIT); sign-in (Entra SSO, which needs an app registration); system of record (principle 3) | Luis, Viren, Dan, Lee | 0.5 day |
| Raise the ISIT asks with lead times now: Entra app registration for SSO and Graph; rig network provisioning for the Lovable URL; data region and the security review route for the new store | Dan asks, ISIT own | 0.5 day |
| Who builds: Dan prompting Lovable as builder-owner (his model today), or Infosys building with Dan as product owner. Name it on the RACI | Luis, Viren, Dan | decision |

## Phase 1: foundations (weeks 1 to 3 after the go-ahead)

| What | Acceptance | Dan's time |
|---|---|---|
| Lovable project and Supabase schema from `database/ddl-v1.sql` + `ddl-v2-add.sql` (22 tables, 6 views, `needs_attention` defined once) | the five proof counts from `DATABASE-BUILD-PLAN.md` match the manifest after loading the 21 export CSVs | 2 days |
| Sign-in with Seadrill accounts | a rig user and an office user sign in with their own account; no separate password anywhere | depends on the app registration |
| Upload endpoint that accepts the posting contract as it is (`meta.asset`, one JSON, size ceilings 10 / 40 MB) | the sample reports in `sample-reports/` load; a rejected oversize file gets the same message the tools expect; nothing posted from a test | 1 day |
| Test mode in the platform, same rule as the flows: while on, no rig or NOV address is mailed | demonstrated | 0.5 day |
| Storage limits set for the 40 MB ceiling and the heavy windows | a 40 MB CBM report with photographs uploads | 0.5 day |

## Phase 2: page parity (weeks 3 to 8)

One tab at a time, each accepted against the live dashboard for the same day. Order by use:

1. Reports list and the report viewer (every report type, photographs, attachments, the OEM chip).
2. Rig Monitoring (latest per rig, daily checks, the potable-water rule, BWM status).
3. CBM (grades 1 to 5 with the universal scale, `cbmlabels`, the cavity record shown as a record not a verdict, the
   latest-grade view, the OEM copies and their `files[]`).
4. Compliance (checklists, actions raised during visits, certification expiry watch).
5. Bulletin Board (AAB register, rig page, the overdue chase).
6. Precharge (requests, issued sheets, the calculator ported from Rev 87 and re-verified against the issued PDFs and
   the training wells `TRAINING-01` to `TRAINING-04`; the password gate replaced by sign-in).
7. Help Centre (requests, acknowledgements, receipts).
8. Errors and the "needs attention" surfaces.

Acceptance for every tab: the same counts and the same attention flags as `reports-data.js` for the same day, checked
by Dan against the live page. Dan's time: about one day per tab, eight days.

## Phase 3: the loops (weeks 6 to 10)

| What | How | Dan's time |
|---|---|---|
| Intake dual-write | the HTTP trigger flow gains one action: send the file to the Lovable endpoint as well as SharePoint; the tools do not change | 0.5 day |
| Notification flows | unchanged; the dashboard link in each becomes the Lovable URL (one field per flow, 13 email cards) | 0.5 day |
| Receipts | written by the platform instead of the scanner; same content | with the builder |
| Ask SACRED AI | re-point the Copilot Studio agent at the new source, or an assistant inside the app; decide after the render test | 1 day |
| Freshness alert | the platform's own monitoring replaces the hourly Digests check | 0.5 day |
| Maximo item export | the daily 06:00 file loads into the new store once the landing folder is known (same open item as today) | 0.5 day |

## Phase 4: the parity run (two clean weeks)

Both systems live. Rigs post to the trigger, which writes to both. Every day Dan compares the counts and the
attention flags; a difference is a defect on one side and is written down. In the same two weeks: the DR rebuild
of the Lovable app from the export, backup and restore of the new store proven, ORR workbook v3 written for the new
stack (the server rows close, the hosted-store rows open), and the security submission made for the new store, which
is the larger review. Dan's time: one day a week plus the ORR, four days.

## Phase 5: cutover (one day, then a month of watching)

1. The dashboard link in the flows and on the SharePoint tiles becomes the Lovable URL.
2. The sacred pages are replaced by one redirect page; the scanner task is disabled, not deleted, for a month.
3. The rig tools get one revision: the "View on dashboard" link and the receipt text. Posting path unchanged.
4. Training delta: a two-page "what moved" for the trained crews, because names and places change. The HAZID and the
   MOC are revised the same week.
5. Fabric is dropped or becomes a mirror (principle 3).
6. After a clean month, the scanner, the share and the server rows on the ORR are closed.

Dan's time: two days, then an hour a day for the month.

## Phase 6: later, not in this plan

The rig tools as hosted forms with offline auto-save (a rebuild of their own; two reasons to do it: live posting and
no unmanaged data on rig machines); Power BI on the new store; the photo-grading model (plan item 30).

## Timeline, if the go-ahead is mid-October

| When | Milestone |
|---|---|
| mid-Oct | go-ahead; phase 0 decisions and asks |
| week of 19 Oct | the production plan's transfer and the class go ahead unchanged; Dan is in Houston, so phase 1 starts the week after |
| early Nov | phase 1 done: schema loaded, sign-in working (app registration permitting), endpoint accepting the contract |
| mid-Nov to mid-Dec | phase 2 page parity, one tab at a time |
| December | phase 3 loops; agent source decided |
| January 2027 | phase 4 parity run and the security submission |
| February 2027 | phase 5 cutover: this becomes the production go-live the ISIT notes already date (M11), on Lovable instead of the sacred server |

The dates move with the app registration more than with anything else. Without SSO there is no production on either
platform, which the ORR already says.

## Risks, and what is done about each

| Risk | What is done |
|---|---|
| Dan's time is the single resource for two plans at once | the production plan's remaining Dan items are the transfer week, the class, the flows and the audit; after the class, this plan is the main work and the production plan is ISIT's |
| Scope creep into the rig tools | principle 2; phase 6 is where that lives |
| Two stores with different data | principle 3, decided in phase 0; dual-write only during the parity run |
| The security review of a hosted store outside the tenancy takes longer than the build | submitted in phase 4, raised as a route question in phase 0 |
| Vendor features assumed (SSO, data region, file limits, self-hosting) | Viren confirms against the purchased licence in phase 0, before the plan is dated |
| Nobody owns the app after the build | the RACI names the application owner in phase 0; today that is Dan |
| The trained crews meet a different screen in February | phase 5 training delta, HAZID and MOC revised the same week |

## What this plan asks of others, in one list

- **Viren:** confirm SSO, data region, self-hosting and file limits on the licence; the half-day render test; the
  platform's monitoring and backup arrangements.
- **ISIT (Adam, Luis):** the Entra app registration (SSO and Graph); rig network provisioning for the new URL; the
  security review route for the new store; a decision on hosting.
- **Lee:** the system-of-record decision with Dan; the data-owner sign-off on the new store; the RACI.
- **Saroj / Infosys:** supportability gaps assessed against the Lovable stack, not the sacred server.

Questions: Dan Plant, Technical Superintendent, Well Control Engineering.
