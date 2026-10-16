# REV 16 plan: SACRED's review

**Date:** 16 Oct 2026. **To:** Lee, via Dan. **Re:** your REV 16 plan (landing page, save at any stage, load by rig, Continue on posted records).

**Approved as planned.** It answers L1 to L6, and the plan-post defect fix (a frozen plan reloading as "proposed") is a good catch.

**Checked on SACRED's side.** A session save in **exactly your body shape** went through scanner v3.08:
- `{version:3, exportedAt, dryRun, meta:{kind:'plan-session', planid, asset, rigkey, bopNo, stage, by, saved, rev, discipline:'Planning', planningOnly:true}, scheduleBuilderState}`, named `West-Vela_DL1_session_<planId>.json`.
- **It was recognised as a save,** before the blank-post check, so there is no warning.
- **It was published** to `plans-state/<planId>.test.json`, and `index.json` shows `kind: session`, `stage: Scope Challenge - deferrals` and `by`.
- **It is kept out of everything else:** not on the dashboard, not filed in the project folder, not printed, not emailed. The Plan Notifications flow ignores it, because its kind is not `plan`.

## Four points

1. **The `path` in `index.json` already includes the folder:** `"path": "plans-state/WVE-BOP1-20261012.test.json"`, relative to `/sacred/dl1/`. Fetch `path` as it is. Prefixing it with `plans-state/` again gives a 404.
2. **Never fall back silently.** Your plan says "no config: local save only, silently". Today Dan's REV 15 **Post report** and **Sync to Dashboard** both fell back to a download without a word, so nothing reached PostedReports and Dan could not tell why (see `ARGO-NAVIS-QUESTION-SYNC-VS-POST.md`).
   - **Please show a server status chip on the plan bar at all times:** "Server save ON" in green, or "Server save OFF: argo-config.json not found / unreadable / no intakeUrl" in red.
   - **After each save, say where it went:** "Saved to server and this PC", or "Saved on this PC only: server save is off (reason)".
3. **Please answer the Sync versus Post question in the REV 16 reply.** Our wish is **one** button that posts. If Sync to Dashboard is the old folder route, remove it, or relabel it "Download a copy".
4. **Test plans while dryRun is on.** With `argo-config.json` at `dryRun: true`, every save is a test save and lands as `<planId>.test.json`. The landing page then shows nothing until "Show test plans" is ticked. **While dryRun is on, tick it by default,** or show a line: "Test mode: showing test plans".

**Timing, for the user guide.** A save reaches the server copy after the next scan (every 10 minutes), plus OneDrive sync. L6's local-versus-server prompt covers the gap.

**Go:** build REV 16. Dan deploys it, and you make the first dryRun save and daily post on the server page when you are ready.
