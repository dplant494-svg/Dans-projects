# Argo Navis: reply to the "For Dan" pack of 14 October (evening)

**From:** Dan Plant and the SACRED dashboard session · **To:** Lee Arnold and the Argo Navis session ·
**Re:** `For Dan` folder (README of 14 Oct), `ARGO-NAVIS-HOSTING-REPLY-TO-DAN_DRAFT.md`, `DL1-ROLLING-HANDOFF-ENTRY-2_DRAFT.md`,
`Argo-Navis_Maximo-Data-Request_DRAFT.md`, the Branch Map additions, the gap report · **Status:** answers to 2.6; two
asks back (the designation file's `meta`, and the read-back file name agreed below).

## What we did with the pack today

1. **REV 13 package (`Argo-Navis_REV13_2026-10-14.zip`).** Hash checked (`9d57b757…bee1419`, HTML `31e76a15…638627`),
   scanned for the intake URL (clean). Dan drops it into `C:\TSC-Dashboard\tools\argo-navis\` and runs Deploy; it serves
   at `/sacred/dl1/` with `data/index.json` beside it, which the scanner has been writing since v2.91.
2. **The rules files on the share.** Thank you. The scanner's config gains the folder
   `\\SEADRILL23339\Well Control Data\Job Plans` (pattern `*`), published flat into `data/` with the feed, as agreed.
   Lock files (`~$…`) are skipped for that run.
3. **Your three REV 13 samples through the scanner (scratch, same code as Dan's v2.94):**
   - `SAMPLE_REV13_West-Vela_BOP1_planning-report.json` (payload version 3): filed as a Planning Report for West Vela,
     nothing to change.
   - `SAMPLE_REV13_pre-deployment_WVE-BOP1-20261005_rev1.json`: filed as a Pre-Deployment Checklist for West Vela
     BOP1 under plan `WVE-BOP1-20261005`, 173 `pdcData` keys including the five Rev 9 groups, rendered by the same
     viewer as SSORT 165's posts. The `argo` block rides along untouched (additive). Nothing to change.
   - `SAMPLE_REV13_designation_WVE-BOP1-20261005.json`: **listed as "unrecognised: no meta block"**. Every post into
     the intake carries `meta`; that is how the scanner attributes a file to a rig and a plan. Please add
     `meta: { "reporttype": "BOP Designation", "planid": "<planId>", "asset": "<rig>", "bopNo": "<BOPn>", "rigkey": "<code>" }`
     to the designation export (keep the top-level keys as they are). With that, scanner v2.95 files it into the plan
     folder as `01 Plan and Scope\designation_<planId>.json`, where SSORT and WCGRRT read it (your 2.4 ask).
4. **Branch Map additions.** Turned into a tick page for Dan (`BRANCH-MAP-ADDITIONS-REVIEW-2026-10-14.html`): accept,
   change or not-this per row with a note, and a Copy decisions button. Dan's decisions come back to you as a list of
   job plans; your workbook stays the source and the map is edited by Dan only.
5. **Gap report v2 and the Maximo data request.** Filed. The data request goes to Manpreet through Dan once you have
   reviewed it; Dan already has Manpreet on the CoC extract this week (the 24-hour task is dropping a partial file, which
   the scanner now refuses until it is complete). One ask to add to your request: **`WOPRIORITY` and `WORKTYPE` stay
   stable** and the extract carries the CM rows (your item 1), because SACRED's AAB and precharge pre-fills key on the
   same WO numbers.
6. **Your matrix column (`PDC-MATRIX-PROPOSAL-dashboard-reviewed_Lee-DRAFT.xlsx`).** Read. Your "Change" rows (B-03,
   B-04, B-06, B-10, B-12, B-17, C-02, C-03, D-01 to D-03, G-01) all refine the dashboard's reading with DL-1 as the
   source, and none contradicts the resolved matrix Dan and Lee issued on 12 Oct (`PDC-MATRIX-RESOLVED-2026-10-12.xlsx`),
   which stays the record. Two points taken into SACRED: B-12 is never auto-completed from E-04 (agreed, the viewer
   shows E-04 beside B-12 only), and D-01 to D-03 accept a linked CBM photograph only from this window and after the
   last change-out on that cavity (noted for the link offer on the dashboard side: the CBM post date against the plan window).

## Answers to 2.6

**1. Photographs in posts.** Keep them inline in `pdcData`, as SSORT does; no separate `plan-evidence` posts.
- SSORT 165 posts 42-slot checklists and 20 MB rig-visit reports through the same intake every day; the scanner's
  ceiling for `pdcData` is 40 MB per post (v2.50), and it warns above 10 MB but still files the report.
- JPEG at SSORT's quality (0.82) is the reference; 56 photographs at that setting sit comfortably inside the ceiling.
- The "several hundred KB fail" seen in the DL-1 reply does not match what the intake carries daily, so it is not a
  size limit. When REV 14 first posts, send the HTTP status and response body of a failing post and we will find it
  (the usual suspects: a `Content-Type` other than `application/json`, a preflight on a non-simple header, or a
  `no-cors` fetch that cannot see the reply).

**2. Read-back.** Agreed, one file per plan: **`/sacred/dl1/plans-status/<planId>.json`**, written by the scanner
beside `plans-open.json` (v2.95, this week). First version carries what SACRED holds today:
```
{ "planid", "generatedAt", "scopeversion",
  "review": { state, verifiedCount, requiredCount, outstanding[] },           // as plans-open.json
  "links": [ { taskid, file, kind, reporttype, posted, dryRun } ],            // seadrill-planlink_ records per task
  "checklists": [ { taskid, checklistPct, checklistSigned, file, posted } ],  // from JPC posts, when they arrive
  "call": { held, at, attendees[], acknowledged[] },                          // H-07 from the Help Centre, when recorded
  "prefills": { "precharge": { issued, file, at }, "cbm": [ { file, class, posted } ],
                "aab": [ { aabNumber, state, acknowledgedAt } ], "visits": [ { file, posted } ] } }
```
Keys lower case, additive, absent when nothing is known. Same-origin read like `data/index.json`.

**3. JPC hosting.** Confirmed: **`/sacred/dl1/Argo-Navis-Job-Plan-Checklists.html`**. Dan places the file beside
`index.html` in `tools\argo-navis\`; Deploy publishes the folder as it is. Default Argo Navis to that relative name.

**4. Sign-off order, B-16 and B-M1 directives, eDocs prefix.** Still with Dan. Your placeholder order
TSL → SS Supervisor → Rig Manager stands until he says otherwise; the deck for the ISIT sit-down next week carries
the eDocs question.

**5. `edocsRef` on `plan-closeout`.** Agreed.

## Two more from our side

- **Rig region for the reviewers.** The scanner takes a rig's region from its newest BWM post. West Vela's sample plan
  had none, so only the "All" reviewers were required. Next scanner version falls back to Dan's Rigs table; nothing
  for Argo Navis to carry, but if the plan `meta` ever carries `region`, we will read it first.
- **The review loop is proven live today** on your 11 Oct sample: posted, notified (email and plan chat), filed on the
  Plans tab with scope by section, verified by two positions, "Verified by all" banner. REV 14's header read of
  `plans-open.json` will show the same numbers.

## Added 14 Oct, later: the Branch Map decisions

Dan reviewed the 36 proposed rows the same evening: **all 36 accepted as proposed**, including the two Low-confidence
ones. Record in `BRANCH-MAP-ADDITIONS-DECISIONS-2026-10-14.md`. Dan pastes columns A to L into the map on the share; from
then on your Unassigned count for in-scope work should drop to the two plans still without a saved job plan
(0900-UR0007, 0900-UR90021).

## Added 14 Oct, later: REV 13 live on the server, and one ask for REV 14 from Dan

Dan deployed REV 13 at 17:39 and opened it from the planning dashboard's Argo Navis button. All three inputs connected
automatically: the WO feed (WO.csv of 25 Sep, Synergi lessons, WCE Reference Hub), the rules (Job Plans and Durations,
the Branch Map with the 36 new rows, the saved workbooks, the Maximo lists) and the CoC Tracker direct from SSORT
(3,968 components, register of 30 Sep). The Houston PC question is closed.

**Dan's ask for REV 14, the Step 1 to 3 block.** Since the inputs load on their own from the server, replace the three
connect rows with one status strip when the page is served over http and `data/index.json` answers:

- green **Maximo data loaded**: one line with WO.csv's date, the rules files' index date and the CoC Tracker's register
  date, and one Reload button;
- red **Maximo data not loaded**, naming which of the three is missing;
- amber when the feed is stale (the existing stale-feed rule), so a crew sees it before planning on old work orders;
- the folder pickers hidden on the server, behind a small "Connect folders manually" link for a PC working off the
  shares; on `file://` the page stays as it is today.
