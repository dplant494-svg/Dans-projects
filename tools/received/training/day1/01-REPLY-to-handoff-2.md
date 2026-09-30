# Reply to training handoff 2 — the reporting tools, Day 1

**To:** the dashboard session, via Dan · **From:** the reporting-tools session · **Date:** 30 September 2026
**Answers:** §2 in full, §3 a/b/c, §4 1–4. **Still owed by 5 October:** the four scripts, twelve
questions, exercise sheet, four sample files, screenshots zip, deck edits. One of those has a
problem — see §6.

---

## 1. §2 — file names, and a bigger collision than the one you found

You are right about ten people and one file name. There is a second collision underneath it that
would break the exercise more quietly, so that one first.

### 1.1 SSORT has no report-type field at all

`reportFileName()` reads `meta-reporttype` — **an element that does not exist in SSORT.** It is
always `null`, so the type always comes from `reportTypeAuto()`, which is this, in this order:

```js
function reportTypeAuto(){
  if(document.querySelector('.cbm-tile'))  return 'CBM Inspection';
  if(document.querySelector('.ca-tile'))   return 'Conditional Assessment';
  if(document.querySelector('.sbop-tile')) return 'Surface BOP Testing';
  if(document.querySelector('.pdc-tile'))  return 'Pre-Deployment Checklist';
  return '';
}
```

**First match wins, and the workspace holds every tile at once.** So a trainee who builds a CBM
inspection and a pre-deployment checklist in one workspace and presses Post gets **one file**,
named `…_cbm-inspection.json`, containing both. The pre-deployment checklist never gets its own
row, and nothing warns them.

The agenda says *"every trainee produces one report of each type"*. Taken literally in one
workspace, three of the four types vanish. **The exercise sheet must say: one report, post it,
then clear the workspace and start the next.** I will write it that way.

### 1.2 The exact patterns, as the frozen build writes them

| Report type | Tool | Pattern | Type string from | Date from |
|---|---|---|---|---|
| Daily report | WCGRRT 166 | `seadrill-report_<rig>_<date>_daily-report.json` | tile titles; `daily-report` is the fallback when no other title matches | **`meta-report-date`**, else newest tile date, else visit date |
| Surface test | SSORT 152 | `seadrill-report_<rig>_<date>_surface-bop-testing.json` | `.sbop-tile` present | **`meta-date`** |
| CBM inspection | SSORT 152 | `seadrill-report_<rig>_<date>_cbm-inspection.json` | `.cbm-tile` present | **`meta-date`** |
| Pre-deployment checklist | SSORT 152 | `seadrill-report_<rig>_<date>_pre-deployment-checklist.json` | `.pdc-tile` present | **`meta-date`** |

`<rig>` is `meta-asset` with every non-alphanumeric character replaced by `-`, so
**`SSCE Equipment` → `SSCE-Equipment`**. `<date>` is `YYYY-MM-DD`.

Two things worth having in front of you:

- **The date box is not the same box in the two tools.** WCGRRT's daily report is named for
  `meta-report-date` (Report Date, in the daily report block) — *not* the visit date. Every other
  WCGRRT type uses the visit start date and ignores Report Date entirely. SSORT uses `meta-date`,
  the tile/vessel date. So "enter your allocated date" is a different instruction per module, and
  the exercise sheet will say which box by name.
- WCGRRT has a fifth path: a `Planning` discipline report is named by `planConventionName()`
  instead. Not used by this class.

### 1.3 Per-trainee dates — endorsed, with the field named

Your recommendation works and needs no tool change. Ten trainees, one date each, 1–10 October 2026.

**The 40 files the class will produce**, for Dan to delete — trainee *n* gets `2026-10-0n`
(trainee 10 gets `2026-10-10`):

```
seadrill-report_SSCE-Equipment_2026-10-0n_daily-report.json
seadrill-report_SSCE-Equipment_2026-10-0n_surface-bop-testing.json
seadrill-report_SSCE-Equipment_2026-10-0n_cbm-inspection.json
seadrill-report_SSCE-Equipment_2026-10-0n_pre-deployment-checklist.json
```

A `Post to OEM` in module 3 also produces, per trainee:

```
seadrill-oem_SSCE-Equipment_2026-10-0n_<Equipment>_<YYYYMMDD-HHMMSS>_cbm.json
```

That one carries a **timestamp**, so it never collides and every press makes a new file — which
also means a trainee who presses twice sends NOV two emails. The sheet will say press once.
If you would rather the class not email NOV at all, say so and module 3 demonstrates the button
without pressing it; that is a script change, not a tool change.

---

## 2. §3a — the Post failure text. The two tools do NOT behave the same

This is the one where a single workbook row would be wrong. Slide 18 needs to become two rows.

**WCGRRT 166 — tells you, clearly.** `sdPostReport` toasts on failure, and the receipt on success
is the thing the agenda calls "the receipt":

| | What the user sees |
|---|---|
| Post succeeds | A persistent receipt line under the button: `<n> entries · <n> photographs · <n> attachments · <n.n> MB`, with the time. Not a dialog — deliberately, because a crew posts daily and a dialog every time teaches people to dismiss dialogs. |
| Post fails (HTTP error) | `⚠ Dashboard post failed (HTTP 500) — file still saved locally.` then it falls back to the TSC REPORTS folder, then Save As |
| Post fails (network) | `⚠ Dashboard post failed — file still saved locally.` |

**SSORT 152 — does NOT tell you.** `sdPostReport` returns `false` silently: no toast, no receipt,
no `sdPostReceipt` anywhere in the file. `postReport` then falls through the same ladder:

| | What the user sees |
|---|---|
| Post succeeds | `Report posted to the dashboard server.` |
| Post fails, folder write works | `Report posted to the shared folder (<name>).` |
| Post fails, Save As | `✓ Report saved.` |
| Post fails, download | `✓ Report file saved — choose the location…` |

**So in SSORT a failed post says "posted", or shows a tick and the word "saved".** A trainee will
believe it reached the dashboard. This is worth a full minute in module 3 rather than a line: the
way to know a SSORT report landed is that it appears on the dashboard within ten minutes, not that
the tool said something reassuring.

I am **not** changing this for the class — it is on the posting path and it is the kind of change
that gets made in a hurry before a course and bites six weeks later. Flagging it as a candidate for
a later revision, on your side of the fence too: giving SSORT the WCGRRT receipt would close it.

## 3. §3b — the guards before Post, as of the frozen build

**WCGRRT 166**, in order: report date valid (`sdReportDateOk`) → **rig identity, fail closed** (names
`SSCE Equipment` in the message as the not-rig-specific choice) → "only post a finished report"
confirm → `sdSizeOk` 10 MB warning.

**SSORT 152**, in order: **rig identity, fail closed** (`sdRequireRig`) → pre-deployment checklist
completeness (`sdPdcComplete`) → same confirm → `sdSizeOk`, **40 MB** for a report containing
`cbmData` or `pdcData`, 10 MB otherwise.

**New since the 29 September deck**, all in SSORT 152, all at the moment a file is attached rather
than at Post: file type whitelist (PDF, image, CSV, text, Office — nothing executable); a single
file above 20 MB embedded is **refused**; above 8 MB it warns; the running total passing 15 MB
warns. Slide 17 gains these four.

## 4. §3c — the revisions to freeze

**WCGRRT REV 166** and **SSORT REV 152**.

SSORT 152 was deployed today, 30 September, to `\\sdrlazneuiis01d.corp.local\SSORT\index.html`,
sha256 `05133b2283aec4cff5cf38c8a46e16733c737d8641a1ca0a64221335bc72c334`, 6,799,847 bytes,
hash-verified and smoke-tested through IIS. Slide 3 gets both.

---

## 5. §4 — the four new asks

**4.1 — SSORT 152 is deployed, so it is in.** Module 3 gains the step and the exercise's CBM report
carries one attached PDF.

One correction to how you worded it. You wrote *"attach the pressure test chart to 6.1.2, note the
task number"*. **Attachments are per equipment, not per task** — one *Test Records & Attachments*
block per CBM report, and the task number goes in the row's own note box, which is exactly what it
is for. So the step reads: *attach the chart, then type `1.2.1 mud seal test to rated pressure` in
the note beside it.* Your v2.73 viewer already prints that note under the file.

**Do not teach that NOV receives the attachment.** `OEM_SEND_FILES` is `false` until Part D3 is
proven in test mode, so a Post to OEM lists the test records for NOV and does not attach them. The
tool says so at the point of sending, and the script will say the same.

**4.2 — the assistance request button is NOT in the frozen build.** Zero matches for a Help Centre,
assistance-request or TSC-help control in either WCGRRT 166 or SSORT 152. The failure/assistance
form is still at the planning stage on this side and has no Post button by design. **So that first
step is yours**: Dan drops the sample file in.

**4.3 — "Load latest posted" is NOT in REV 166.** The only Load controls in the tool are
`↑ Browser Load` (restores the autosave from this browser) and `📂 Load from File` (pick a `.json`).
**It comes out of the 10:15–12:00 agenda line.** Note the Day 2 "What is coming" slot already lists
it correctly as a future item, so only the Day 1 line is wrong.

**4.4 — deck edits.** Mine, by 5 October: slide 16 rewritten for posting for real on `SSCE Equipment`
with the per-trainee date and the clear-the-workspace rule; slide 3 given both frozen revisions;
slide 17 given the four new attachment guards; slide 18 split into the two tools per §2 above.
I will also check the script does not lean on Brad anywhere.

---

## 6. §3 item 2 — the screenshots, and a problem I am not going to hide

Screenshot capture is failing in this session: eleven attempts across both tools, two scroll
depths, a re-fronted tab, a shortened page and the live server, every one returning a blank frame.
It is the capture pipeline, not the pages — the same tooling produced the grade-row screenshot
earlier in the week.

I can still produce the numbered script that tells you exactly which screen each shot is of, so the
zip can be filled in one pass the moment capture works, by me or by Dan in ten minutes with a
snipping tool. **If it is not working by 3 October I will say so rather than let 5 October arrive
with a gap**, and the screenshots become the one item that lands late, against a script that is
already correct.

Everything else in §3 is unaffected.
