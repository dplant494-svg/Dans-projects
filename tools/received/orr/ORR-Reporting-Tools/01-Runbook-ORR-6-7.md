# ORR 6, 7 — Runbook: building, verifying and publishing a tool revision

**Tools:** WCGRRT (rig visit reporting) and SSORT (subsea onboard reporting)
**Current:** WCGRRT **REV 167**, SSORT **REV 154** · **Owner:** Dan Plant, Technical Services — Subsea
**Date:** 30 September 2026

Both tools are **single self-contained HTML files**. There is no build system, no package manager, no
server-side code and no database. A revision is one file; deploying is copying that file onto a
share. A support engineer needs nothing installed beyond a text editor and a browser.

---

## 1. Never edit what is deployed

Each revision lives in its own folder under
`C:\Users\danplant\Claude\Projects\Subsea Superintendent Reporting Template\`:

```
SSORT REV 153\index.html
WCGRRT REV 166\WCE Rig Vist Reporting Tool V0.html
```

**To make a change, copy the current folder to the next number and edit the copy.** The deployed
folder is never edited, so the file on the share always has an exact, untouched twin on disk to
compare against and to roll back to.

**The revision constant is the first edit**, before anything else: `SSORT_REV` in SSORT, `TOOL_REV`
in WCGRRT. Bumping it last is how WCGRRT REV 163 shipped stamped `REV 162` (see the Known error log),
which makes a posted report's provenance unreliable for that revision.

## 2. Verify before it leaves the folder

Run these against the new file. All are mechanical and repeatable; the first three are the ones that
catch real breakage.

| # | Check | Why |
|---|---|---|
| 1 | **Every `<script>` block parses** (`node --check`, or `new vm.Script()` per block) | The file is one document; a syntax error anywhere kills every feature, not one |
| 2 | **Script extraction reconciles to the file length** | A stray `</script>` inside a string literal silently truncates the extraction, so check 1 would pass on a fragment. Confirm the extracted bytes account for the expected share of the file (≈97% today) |
| 3 | **No duplicate top-level declarations** | Two declarations of one name hoist and the **last one silently wins**. This shipped once (`acousticTestHTML`) and the wrong renderer ran for weeks |
| 4 | **The posting path is byte-identical** to the previous revision unless the change is deliberately there: `sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportFileName`, `sdSizeOk`, `buildReportPayload` | These five carry every report off the rig |
| 5 | **Zero `mode:'no-cors'`** anywhere | A no-cors POST always reports success, so a failed post would look like a good one |
| 6 | **Photo compression unchanged** (`0.82`, 8 occurrences today) and the size ceilings unchanged (10 MB general, 40 MB CBM/PDC, 30 MB OEM copy) | Changing these changes what evidence reaches the office |
| 7 | **The inspection schedule is unchanged** (`CBM_SCHED`) unless that is the change | It is NOV's maintenance schedule; task ids are payload keys |

**A build script that writes the file only if every assertion passes is the practice, not an
optional extra.** The scripts used for REV 151, 152 and 153 each refuse to write on any failure and
print what failed. Keep that pattern.

## 3. Smoke test in a browser — off the share first

Serve the candidate locally (a PowerShell `HttpListener` one-liner is enough; no Node or Python is
required on a support machine) and open it:

1. Check the **revision badge** reads the new number.
2. Create one report of each type the change touches, on asset **`SSCE Equipment`** only.
3. Exercise the guard or feature that changed, and read the message the crew will read.
4. **Zero console errors.**
5. Save locally. **Post nothing.**

## 4. Publish

```
copy "SSORT REV 153\index.html"  "\\sdrlazneuiis01d.corp.local\SSORT\index.html"
copy "WCGRRT REV 166\WCE Rig Vist Reporting Tool V0.html"  "\\sdrlazneuiis01d.corp.local\sacred\WCE Rig Vist Reporting Tool V0.html"
```

**Before the copy:** hash the live file and confirm it still matches the *previous* revision folder.
If it does not, someone else has changed it and the copy must stop until that is understood.

**After the copy:** hash the live file and confirm it matches the new folder exactly.

```powershell
Get-FileHash -Algorithm SHA256 "\\sdrlazneuiis01d.corp.local\SSORT\index.html"
```

Both hashes go in the test record (ORR 19).

## 5. Smoke test again, through IIS

Open the **served URL**, not the share path, because that is what a rig gets:

- SSORT — `http://sdrlazneuiis01d.corp.local:8080/SSORT/index.html`
- WCGRRT — `http://sdrlazneuiis01d.corp.local:8080/sacred/WCE Rig Vist Reporting Tool V0.html`

Confirm the badge, repeat the feature check, confirm zero console errors, then **clear the test
state from that origin** (the tools autosave to `localStorage`, so a test leaves a restorable
session behind on the server's origin that the next person would be offered).

## 6. What "nothing posted" means during a test

Posting is a real action: it puts a report on the fleet dashboard where everyone with access sees
it, and from SSORT's CBM report it also emails NOV's distribution list. **A test must never post.**

Three layers, all used:

1. **Asset `SSCE Equipment` only.** A non-rig bucket that never enters a fleet count and which every
   notification flow treats as test mode, office only. Never a real rig name.
2. **Disable the transport in the page before exercising a Post button.** In the browser console:
   `window.fetch = function(){ throw new Error('disabled'); }` and stub `sdPostReport` to return
   `false`. Then the button's whole path can be exercised — guards, confirms, payload assembly — and
   nothing can leave.
3. **Cancel at the confirm** if only the wording is being checked.

Posting a real report is the tool owner's action, on a real rig name, deliberately.

## 7. Rollback

Copy the previous revision folder's file back over the share path and hash-verify. Because no
revision folder is ever edited after it ships, every previous revision is intact on disk. There is
no state to migrate: a report file written by an older revision is read by a newer one and vice
versa, because payload keys are only ever added, never renamed or removed.

## 8. The rule that protects the dashboard

**New payload keys only: additive, lower case, and announced in `DASHBOARD-ROLLING-HANDOFF.md`
before they ship.** Never rename, re-type or remove an existing key; never change the filename
logic. The dashboard scanner and viewer are built against that contract, and a rig's posted report
from any revision has to keep rendering.
