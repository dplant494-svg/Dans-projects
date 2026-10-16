# Handoff 3 to Lee: a landing page, saving to the server at any stage, and loading the latest by rig

**From:** SACRED (Dan Plant's dashboard session). **Date:** 16 Oct 2026. **For:** Lee Arnold and his Argo Navis Claude session.

## What happened

Dan deployed REV 15 and tried to make the first test daily post. **He could not get a schedule open.**
- **Continue Existing Schedule** refused both `SAMPLE_3_West-Vela_DL1_plan_BOP1_v1_frozen.json` and **your REV 15 sample `SAMPLE_West-Vela_DL1_planning-report_BOP1_v2.json`** with: "This file wasn't produced by Schedule Builder (no saved session state found) - Continue only works with this tool's own exports."
- The REV 15 sample **does** carry `scheduleBuilderState`: 378 KB, status frozen.

**Dan (16 Oct):**
- "We need the ability to save it at the intervals too. If the rig are halfway through executing, and deferring for the scope freeze, they don't want to redo and re-review."
- "Maybe we need a landing page, 'New schedule' or 'Existing'. When you hit Existing you get a dropdown for the rig, and it loads in the last saved for that rig, and they go from there."

A rig should never have to find a file or rebuild a plan. Shared laptops, crew changes and the server page all mean there is no "last Sync" file to hand.

## The ask

| # | Ask |
|---|---|
| L1 | **A landing page** when Argo Navis opens, with two big choices. <ul><li>**New schedule:** today's Step 1, as now.</li><li>**Existing schedule:** a **rig dropdown**, defaulting to the rig last used on this PC. Pick the rig and its plans show newest first: BOP, plan id, stage, saved by, saved at. One plan opens straight away; if the rig has two (BOP1 and BOP2), the user picks one. The latest saved state loads **exactly where they left off**, whatever the stage: building, Scope Challenge, deferrals, under review, frozen or executing. Test plans show only when "Show test plans" is ticked.</li></ul> Keep **Continue from a file** as a small link underneath, for working offline on a PC. |
| L2 | **Save to the server, at any stage.** <ul><li>**A Save button** on the plan bar, and **an automatic save** when a step is completed and every 30 minutes while there are unsaved changes.</li><li>**It posts through the intake as a session save:** `meta.kind = "plan-session"`, plus `meta.planid`, `meta.asset`, `meta.rigkey`, `meta.bopNo`, `meta.stage` (e.g. "Scope Challenge - deferrals", "Under review v2", "Executing") and `meta.by`.</li><li>**It carries the whole `scheduleBuilderState`,** and `dryRun` as for any post.</li><li>**One fixed file name per plan,** e.g. `West-Vela_DL1_session_WVE-BOP1-20261012.json`. Each save then **replaces** the last in PostedReports instead of piling up.</li></ul> **A save is never a scope version and never a review.** Nothing is re-posted for review, and nobody is told. |
| L3 | **The plan id from the start.** A save needs `meta.planid`. If the plan id only exists after "Post for review" today, please give the plan its id when it is created (rig, BOP, window start), so it can be saved before review. |
| L4 | **Continue must accept a posted record.** Continue (and the landing page) must open a session save, and also a posted planning report: both carry `scheduleBuilderState`. Please say exactly why the REV 15 sample was refused. |
| L5 | **"Since last report" after loading.** The previous-report snapshot must survive a save and reload, so the done list stays right. If it lives outside `scheduleBuilderState` today, put it inside. |
| L6 | **Which copy wins.** If this PC holds a newer local session than the server copy (the rig worked offline), say so and offer both: "Local copy saved 14:20 is newer than the server copy saved 07:05: open local / open server." |

## What SACRED does (scanner v3.08, built and tested)

- **A session save (`plan-session`) is a record, never a report.** It is not listed on the dashboard, not filed in the project folder, not printed, and not emailed. The Plan Notifications flow ignores it, because its kind is not `plan`.
- **For each plan, the newest saved state wins,** whether it came from a session save or a daily report. It is published beside the tool:

| Served at | What it is |
|---|---|
| `/sacred/dl1/plans-state/index.json` | The list for the rig dropdown: `{ generatedat, scanner, count, plans: [ { planid, rig, rigkey, bop, istest, path, file, kind, stage, by, saved } ] }` |
| `/sacred/dl1/plans-state/<planId>.json` (test: `<planId>.test.json`) | That newest post, unchanged: open it and read `scheduleBuilderState` |
| `/sacred/dl1/plans-status/<planId>.json` | Gains `latestschedule: { path, file, saved }` |

Example from SACRED's test copy (a session save made from your REV 15 sample):

```json
{"generatedat":"2026-10-16T12:58:24Z","scanner":"3.08","count":1,"plans":[{"planid":"WVE-BOP1-20261012","rig":"West Vela","rigkey":"vela","bop":"BOP1","istest":true,"path":"plans-state/WVE-BOP1-20261012.test.json","file":"West-Vela_DL1_session_WVE-BOP1-20261012.json","kind":"session","stage":"scope challenge (deferrals)","by":"SAMPLE SSS","saved":"2026-10-16T12:58:13Z"}]}
```

**Timing.** A save reaches the server within about one scan (10 minutes), plus OneDrive sync. Show "Saved to server (available to other PCs within about 10 minutes)" after a save, so nobody expects it on another laptop instantly.

## Please reply with

- L1 to L6: done, or not and why, with the REV number.
- The reason Continue refused the REV 15 sample.
- One session save sample with `dryRun: true`.
- **The first real test, once L1 to L4 are in:** build a West Vela test plan in Argo Navis, save it, reopen it from the landing page on another PC, freeze it, and press Post daily report. Dan and Lee should both get the [TEST MODE] email.
