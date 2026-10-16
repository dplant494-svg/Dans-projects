# Handoff 3 to Lee: "Load latest schedule" from the server, by rig

**From:** SACRED (Dan Plant's dashboard session). **Date:** 16 Oct 2026. **For:** Lee Arnold and his Argo Navis Claude session.

## What happened

Dan deployed REV 15 and tried to make the first test daily post. **He could not get a schedule open.**
- **Continue Existing Schedule** refused both `SAMPLE_3_West-Vela_DL1_plan_BOP1_v1_frozen.json` and **your REV 15 sample `SAMPLE_West-Vela_DL1_planning-report_BOP1_v2.json`** with: "This file wasn't produced by Schedule Builder (no saved session state found) - Continue only works with this tool's own exports."
- The REV 15 sample **does** carry `scheduleBuilderState`: 378 KB, status frozen. So Continue checks for something the posted planning report does not have.

**Dan:** "This is an issue. We need a Load latest schedule button here, then rig specific."

A rig should not have to find a file. On a shared or new laptop, after a crew change, or on the server page, there is no "last Sync" file to hand.

## What SACRED now publishes (scanner v3.07)

For every plan, the scanner finds the **newest post under that plan that carries `scheduleBuilderState`**: the planning report from **Post daily report**, or a Sync file. It publishes a copy beside the tool:

| Served at | What it is |
|---|---|
| `/sacred/dl1/plans-state/index.json` | The list, for your picker: `{ generatedat, scanner, count, plans: [ { planid, rig, rigkey, bop, istest, path, file, saved } ] }` |
| `/sacred/dl1/plans-state/<planId>.json` | The newest such post for a live plan, **unchanged**: the posted record as the rig sent it |
| `/sacred/dl1/plans-state/<planId>.test.json` | The same for a test plan (`dryRun`, `meta.sample` or SSCE Equipment) |
| `/sacred/dl1/plans-status/<planId>.json` | Gains `latestschedule: { path, file, saved }` when one exists |

Example `index.json`, from your REV 15 sample on SACRED's test copy:

```json
{"generatedat":"2026-10-16T12:55:49Z","scanner":"3.07","count":1,"plans":[{"planid":"WVE-BOP1-20261012","rig":"West Vela","rigkey":"vela","bop":"BOP1","istest":true,"path":"plans-state/WVE-BOP1-20261012.test.json","file":"SAMPLE_West-Vela_DL1_planning-report_BOP1_v2.json","saved":"2026-10-16T02:04:18Z"}]}
```

- **How fresh it is:** the scan runs every 10 minutes, so the server copy is at most one scan behind the rig's last post.
- **Where to read it:** the same folder you already read `plans-open.json` and `plans-status` from, so the same-origin fetch works.

## The ask

| # | Ask |
|---|---|
| L1 | **A "Load latest schedule" button at the top of Step 1**, beside Continue Existing Schedule, shown when `plans-state/index.json` answers (the server page). <ul><li>**Pick a rig:** default to the rig last used on this PC, or a rig chosen from the list.</li><li>**See that rig's plans,** newest first: BOP, plan id, saved date and time, a TEST tag on test plans. **Live plans come first;** test plans show only when "Show test plans" is ticked.</li><li>**Click one:** it fetches `path` and opens it exactly as Continue would, landing in Step 5 with the frozen baseline and the "since last report" snapshot.</li></ul> |
| L2 | **Continue Existing Schedule must accept a posted planning report** (and a plan-progress post, if it carries the state). Today it refuses your own REV 15 sample. Please read `scheduleBuilderState` from the posted record, or say what marker Continue looks for, and post it on every report that carries the state. |
| L3 | **"Since last report" after loading.** If the server copy is the rig's last post, the previous-report snapshot is that post's own state, so the done list is right. Say if Argo Navis keeps that snapshot somewhere the posted record does not carry. If so, post it too. |
| L4 | **Which copy wins.** If the PC has a newer local session than the server copy (the rig worked offline and has not posted), say so and offer both: "Local copy saved 14:20 is newer than the server copy saved 07:05: open local / open server." |

## Please reply with

- L1 to L4: done, or not and why, with the REV number.
- **The exact reason Continue refused the REV 15 sample**, so Dan's test daily post can go ahead now: either by loading a file that works, or by Lee pressing Post daily report on his own West Vela test plan.
