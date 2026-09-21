# Moving the dashboard scanner to the sacred server — step by step

**For:** Dan (steps 1–4, 8) and IT (steps 5–7)
**Date:** 2026-09-09
**Companion:** `SCANNER-SERVER-MIGRATION-IT-HANDOFF.pdf` (the why and the
design), `PRECHARGE-SACRED-SERVER-HANDOFF.md` (the calculator folder).

The rule for the whole move: **Dan's PC keeps running until the server is
proven.** Two scanners in parallel is safe. Nothing is deleted on the PC.

---

## Step 1 — Dan: freeze a clean copy (5 minutes)

1. Run one last scan by hand so the state files are fresh. Press R if asked.
   ```
   C:\TSC-Dashboard\scripts\Update-Dashboard.ps1
   ```
2. Check `C:\TSC-Dashboard\precharge\` contains all of:
   `calculator.html`, `set-password.html`, `gate-config.js`, `gate-fragment.html`.
3. Check `C:\TSC-Dashboard\config.json` opens in Notepad and has the three
   `reportFolders`, `deployPath`, `prechargeDeployPath` lines (it does today).

## Step 2 — Dan: copy the folder to the server (10 minutes)

IT needs the folder at **`D:\TSC-Dashboard`** on the server. You cannot write
to the server's `D:` drive yourself, so hand it over through the share:

1. In File Explorer open `\\sdrlazneuiis01d.corp.local\sacred`.
2. Create a folder there called **`_INSTALL-TSC-Dashboard`**.
3. Copy the **whole** of `C:\TSC-Dashboard` into it (drag the folder in; wait
   for the copy to finish — it includes the `dashboard\reports` copies, so it
   may take a few minutes).
4. Copy `config.server.json` (sent with this note) into
   `_INSTALL-TSC-Dashboard\TSC-Dashboard\` as well — do **not** rename it yet.

IT will move it out of the web root in step 5. Until they do, the folder sits
inside the sandbox website, which is acceptable for the day but not longer.

## Step 3 — Dan: tell IT exactly this (copy and paste)

> The scanner package is at `\\sdrlazneuiis01d.corp.local\sacred\_INSTALL-TSC-Dashboard\TSC-Dashboard`.
> Please:
> 1. Move it to `D:\TSC-Dashboard` (out of the web root) and delete `_INSTALL-TSC-Dashboard`.
> 2. `Get-ChildItem D:\TSC-Dashboard -Recurse | Unblock-File`
> 3. Set up a read-only, server-local mirror of the three SharePoint libraries listed in `config.server.json` (see the migration handoff §2), then put those three folder paths into `config.server.json` and rename it to `config.json`, replacing the old one.
> 4. Register the scheduled task exactly as in the migration handoff §3 step 4 (every 10 minutes, "do not start a new instance", run as a service account with read on the mirror folders and write on the `sacred` and `SSORT` content folders, "run whether user is logged on or not").
> 5. Run it once by hand as that account and send me the console output.
> 6. Give my account write access to `D:\TSC-Dashboard\scripts` and `D:\TSC-Dashboard\precharge` so I can drop script and calculator updates without a ticket.
> The handoff PDF is attached.

## Step 4 — Dan: nothing, until IT sends the first-run output

Do not disable anything on your PC yet.

## Step 5 — IT: install (from the message above)

Covered by the message in step 3 and the migration handoff §3. Two notes:

- `Register-DashboardTask.ps1` in `scripts\` registers the task under the
  account that runs it and does not set "do not start a new instance"; for a
  service account it is simpler to create the task in Task Scheduler by hand
  with the action `powershell.exe -NoProfile -ExecutionPolicy Bypass -File D:\TSC-Dashboard\scripts\Update-Dashboard.ps1`, start-in `D:\TSC-Dashboard\scripts`.
- The three `reportFolders` are the only lines in `config.json` that must
  change for the server. Every other path is a UNC path to this same server
  and works as-is.

## Step 6 — IT: first run by hand

Expected console output ends with lines like:

```
Wrote 2xx report(s) to D:\TSC-Dashboard\dashboard\reports-data.js
Precharge inbox: 3 request(s) indexed (...)
Deployed data file to \\sdrlazneuiis01d.corp.local\sacred\dashboard
Report copies: N new/updated, 25x total in ...\sacred\dashboard\reports
Deployed BWM snapshot data to \\sdrlazneuiis01d.corp.local\sacred
Deployed SSCE requests data to \\sdrlazneuiis01d.corp.local\sacred
```

The report count should match Dan's PC the same hour. A handful of yellow
warnings about files with no rig identity and oversized files are expected
and correct. Anything red, or a count far below Dan's, means `reportFolders`
is pointing at the wrong place — nothing else in the config differs.

## Step 7 — IT and Dan: prove it

1. Dashboards load and show a fresh "updated x min ago" stamp:
   `http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html`
2. Dan posts a test report from a report tool. It appears on the dashboard
   within 10 minutes with nobody running anything.
3. Dan opens the calculator, logs in, and sees the requests:
   `http://sdrlazneuiis01d.corp.local:8080/sacred/precharge/calculator.html`
4. Dan deletes the test report at source; it disappears within 10 minutes
   (proves the mirror also mirrors deletions).

## Step 8 — Dan: switch your PC off the job (only after step 7 passes)

1. Press the Windows key, type **Task Scheduler**, open it.
2. Click **Task Scheduler Library** on the left.
3. Find **Refresh Reports Dashboard**, right-click it, choose **Disable**.
   Do not delete it — it is the rollback.
4. Leave `C:\TSC-Dashboard` on your PC untouched.

From now on, script updates from me go to `D:\TSC-Dashboard\scripts\` on the
server, and calculator revisions go to `D:\TSC-Dashboard\precharge\` followed
by one run of `D:\TSC-Dashboard\scripts\Deploy-Dashboard.ps1`.

## Rollback

Re-enable the task on Dan's PC and disable the server one. Nothing else.

---

## Addendum, 21 September 2026 — what changed since this page was written (scanner v2.60)

Read with the steps above; nothing above is withdrawn.

- **`Register-DashboardTask.ps1` now sets the 60-minute time limit and "do not start a new
  instance" itself**, so IT can use it instead of creating the task by hand, provided it is
  run as the service account (it registers the task for the account running it). The action
  and start-in folder are as in step 5.
- **`config.server.json` has three more keys** than the 9 September copy: `digestPath` (the
  Copilot digests library, which the scanner writes and Copilot indexes, so the mirror for
  that one must sync **back** to SharePoint, not only down), `dashboardUrl`, and `copilotUrl`
  (copy the value from Dan's `config.json`). IT fills `digestPath` with the same method as
  the report folders.
- **Files the server rebuilds on its first run, safe to copy or not:** `scan-state.json`,
  `scan-lock.json`, the `scan-cache\` folder (photo-stripped report copies, up to a few
  hundred MB), `notified-state.json`, `break-ins-*.json`, `ssce-notified-state.json`. The
  `archive\` folder holds posts Dan moved out of the report folders on 17 September (one is
  74.8 MB); it is not needed on the server.
- **A new `tools\served\` folder** in the package: any `.html` in it is published by
  `Deploy-Dashboard.ps1` to `sacred\tools\` for the reporting tools to be opened from an
  address on the rigs. Empty today apart from a README.
- **The scanner's own lock** (`scan-lock.json`) makes a second scan started while one is
  running stop with one line, and a run that dies releases it, so the task's "do not start a
  new instance" and the lock cover each other.
- **Two scanners in parallel remain safe** while Dan's PC task is still enabled: both write
  the same outputs, and the server's `reports\_replaced\` folder keeps any report copy that
  gets overwritten, so nothing is lost while both run.
- **Timing to expect on the server's first full scan:** every report read once and cached,
  every digest written once: on Dan's PC that took about 18 minutes before the caches, and
  93 to 126 s on every full scan after. The 60-minute limit covers it.

