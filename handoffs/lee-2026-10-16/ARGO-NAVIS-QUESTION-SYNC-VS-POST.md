# Question to Lee: "Sync to Dashboard" versus "Post report", and why both only downloaded a file

**From:** SACRED, via Dan. **Date:** 16 Oct 2026. **REV:** 15, served at `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/`.

## What Dan did and saw

On REV 15, opened from the server, Dan pressed **Sync to Dashboard** and then **Post report**. **Both only downloaded a .json file** to his Downloads folder:
- nothing arrived in PostedReports;
- nothing appeared in the Between Wells Maintenance library.

`argo-config.json` (with `intakeUrl` and `dryRun: true`) sits in `C:\TSC-Dashboard\tools\argo-navis\` and was published to `/sacred/dl1/` by Deploy-Dashboard.ps1, beside `index.html`.

## Please answer

1. **What is the difference between "Sync to Dashboard" and "Post report"?** Your guide says Sync "saves the JSON to the shared reporting folder" (a folder picked once), while posting goes through the intake. Does a rig need both, or only Post? If Sync is the old WCGRRT-style route, can it be removed or relabelled, so the rig has **one** button that posts?
2. **Why would both fall back to a download on the server page?** Tell us exactly what Argo Navis checks before it posts:
   - `argo-config.json` found at `./argo-config.json`;
   - valid JSON;
   - `intakeUrl` present;
   - anything else.

   **Please make it say so on screen**, e.g. a red strip "Posting is off: argo-config.json not found / not readable / no intakeUrl", instead of silently saving a file.
3. **Where does Sync's "shared reporting folder" point?** When is the folder picker shown, and why would it download instead? Dan was never asked to pick a folder.
4. **What should Dan check right now,** in the browser's developer tools (F12, Console / Network), to see which of these it is?
