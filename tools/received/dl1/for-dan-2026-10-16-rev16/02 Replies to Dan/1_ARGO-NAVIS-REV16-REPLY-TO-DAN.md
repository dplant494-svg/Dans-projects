# Argo Navis REV 16: reply to Handoff 3 and the 16 Oct pm update

**From:** Lee Arnold and the Argo Navis session · **To:** Dan Plant and the SACRED dashboard session ·
**Re:** `ARGO-NAVIS-HANDOFF-3-LOAD-LATEST-SCHEDULE.md`, `ARGO-NAVIS-UPDATE-FOR-LEE-2026-10-16-PM.md` ·
**Package:** `Argo-Navis_REV16_2026-10-16.zip` (it replaces REV 15)

**Good news first:** posting works on the server now that `argo-config.json` carries the real address. REV 16 adds
everything Handoff 3 asked for, the pm update's points, and Lee's own chronology review.

## Why Continue refused your files

We reproduced it on REV 15:

- **`SAMPLE_3_…_plan_BOP1_v1_frozen.json`** was refused because REV 15's Continue looked for `scheduleBuilderState`
  only at the **top level**. A `plan` post carries it at **`plan.scheduleBuilderState`**, as the contract has it.
- **`SAMPLE_West-Vela_DL1_planning-report_BOP1_v2.json`** has the state at the top level, and **it opens in REV 15 on
  our side**: it goes straight to Execute. We cannot reproduce that refusal. Could you say which copy you opened? If
  it came through a store that wraps or renames the record, REV 16 now opens that too (below).
- **A related defect found and fixed:** a `plan` post embedded the state as it was *before* the post. So a frozen plan
  reopened as "proposed" at the previous version. REV 16 embeds it as it will be once posted, and the test reopens a
  frozen post as frozen v1.

## L1 to L6

| # | Status (REV 16) |
|---|---|
| **L1** | **Done.** When Argo Navis opens, a **landing page** offers **New schedule** or **Existing schedule**. **Existing:** a rig dropdown (the rig last used on this PC by default), whose plans are listed newest first with BOP, plan, stage, saved by, saved at and copy (server or this PC). It comes from `plans-state/index.json`, and the path is fetched exactly as given. **One plan opens straight away**; with BOP1 and BOP2, the user picks. The plan opens **where it was left**: the step travels in the saved state. **Show test plans** is ticked by default while `dryRun` is on. **Continue from a file on this PC** stays as a link. Opening the tool with `?new` skips the landing page. |
| **L2** | **Done.** **💾 Save** is on the plan bar and at the foot of Execute. It is also automatic on every completed step and every 30 minutes while there are changes. Each save posts **`meta.kind = "plan-session"`** with `planid`, `asset`, `rigkey`, `bopNo`, `stage` (Building, Scope Challenge, Scope Challenge - deferrals, Schedule built, Under review v n, Frozen v n, Executing (v n), Closed), `by`, `saved` and `rev`, the whole `scheduleBuilderState`, and `dryRun`. **One fixed file name per plan:** `West-Vela_DL1_session_WVE-BOP1-20261014.json`. A save is never a scope version or a review, carries no tiles, and is never downloaded. After a save: "Saved to server (available to other PCs within about 10 minutes)". |
| **L3** | **Already so since REV 13.** The plan id (`<rig code>-<BOP>-<commencement>`) is given at set-up (Step 2), so a plan can be saved from the Scope Challenge on, before any review. |
| **L4** | **Done.** Continue and the landing page open **any record carrying the state**: at the top level, inside `plan`, inside `session`, or inside the intake wrapper `{FileName, FileContent}` (decoded), with or without a BOM. If none is found, the message names the keys and `meta.kind` it saw. |
| **L5** | **Done.** The previous-report snapshot already lived inside `scheduleBuilderState.report`; it now survives a save and reload, which the test proves. The step and the view also travel (`ui`). |
| **L6** | **Done.** Every save also keeps a copy on this PC. When this PC's copy is newer than the server's, the landing page asks: "The copy on this PC (saved Thu 10/16 14:20) is newer than the server copy (saved 07:05): open this PC's copy / open the server copy". |

## From the 16 Oct pm update

- **One way out, and it posts.** **Sync to Dashboard is now ⇪ Post report** at the foot of Execute. It is the same
  action as Post daily report on the plan bar, so there is one at the top and one at the bottom. A plain **Download a
  copy** link stays for emailing. **The folder-picking route is gone.**
- **The "Server save ON / OFF" chip** on the plan bar always gives the reason:
  - opened from a file;
  - no `argo-config.json`;
  - config not valid;
  - the last save failed (HTTP n).

  **It is never silent.** A failed manual save says so, and an automatic one shows a warning. The copy on this PC is
  kept either way.
- **Test plans shown by default while `dryRun` is on:** done.
- **Milestone dates on the stars (handoff 4):** done, and more, after Lee's own review ("it needs the dates across the
  top"):
  - **a date axis** across the top, with day gridlines and a **Now** line;
  - **each milestone is a numbered star at its exact time.** It used to sit at noon of its date, and milestones on the
    same date were merged into one star;
  - a dashed line through the rows;
  - **a key** under the chart giving each milestone's full name, date and time, achieved or estimated, and status
    colour.

  This applies on both Schedule and Execute.
- **We did not receive `ARGO-NAVIS-REV16-PLAN-REVIEW-FROM-SACRED.md` or handoff 4.** We built from the points listed in
  your pm update. Please resend them if they hold more.

## Found and fixed while testing

- **Setting up a new plan after opening another one kept the first plan's posting state** ("frozen v2"). A new plan id
  now starts clean.
- **Autosave races and false "changed" flags.** A save timed by a completed step no longer races a manual save. Post
  receipts and the step on screen no longer count as "changes".

## What is in the pack

| Where | What |
|---|---|
| `For Dan\01 Deploy package\Argo-Navis_REV16_2026-10-16.zip` | The tool; HTML SHA-256 `299eed6e…441a3`. The JPC is still built in, and `argo-config.json` stays as you have it. |
| `For Dan\04 JSON samples\REV 16 session save (test, West Vela BOP1)\` | **The session save sample** (`dryRun:true`): `SAMPLE_West-Vela_DL1_session_WVE-BOP1-20261014.json`. |
| `For Dan\06 Screenshots\ArgoNavis_REV16_*` | The landing page, the chronology with dates and stars (Schedule and Execute), and the plan bar with Save and the chip. |

**Tests:**

- The full suite passes on REV 16, and `planningData` is byte-identical to REV 15.
- `_rev16test` covers every L point, Dan's two files, the chronology, and Post report.
- The http server test passes. The landing page reads a staged `plans-state/index.json`, opens the plan from its path,
  and **Save** posts the `plan-session` (202, fixed name) to the stand-in intake.

## Next

**Deploy REV 16.** Lee then makes the first **dryRun save and daily report** from the server page and tells you when,
so you can watch it arrive in `plans-state` and in the [TEST MODE] email.
