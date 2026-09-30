# Day 1 screenshot list — 24 shots, numbered to the walkthrough scripts

**Spec (from the handoff):** PNG, light mode, 1600 px wide, asset `SSCE Equipment`, numbered to the
script. Delivered as one zip, `TRAINING-Day1-Screenshots.zip`, files named `01-rev-badge.png` and so
on.

**Status: not yet captured.** Screenshot capture is failing in the build session — every attempt
returns a blank frame, on both tools and on the live server. The list below is final and correct, so
the zip can be filled in one pass by whoever gets there first. Each row says exactly what must be on
screen, which is the part that is easy to get wrong and expensive to redo.

**Capture settings for whoever takes them:** browser at 1600 px wide, light mode, no personal data on
screen, asset `SSCE Equipment` in every shot, and the revision badge visible wherever the script
points at it (shots 1 and 17 especially).

---

## Module 1 — WCGRRT rig visit and daily reports

| # | File | What must be on screen |
|---|---|---|
| 1 | `01-wcgrrt-rev-badge.png` | WCGRRT top bar with the **REV 166** badge legible, and the toolbar buttons visible |
| 2 | `02-visit-information.png` | Visit Information block, Rig / Asset showing `SSCE Equipment`, discipline and both visit dates filled |
| 3 | `03-no-rig-guard.png` | The fail-closed dialog: *"Cannot post: no Rig / Asset selected…"* — full text readable |
| 4 | `04-add-daily-entry.png` | The section dropdown open, **📋 Daily Report Entry** highlighted |
| 5 | `05-equipment-entry.png` | One equipment entry filled: make, model, serial, work done |
| 6 | `06-captioned-photos.png` | Two photographs on the entry, **both captions visible and filled** |
| 7 | `07-report-date.png` | The Daily Report block with **Report Date** clearly the focus — this is the box the module turns on |
| 8 | `08-report-date-guard.png` | The date dialog: *"This report is dated … That is 18 days ago…"* — full text readable |
| 9 | `09-restore-bar.png` | The restore bar after a reload: *"Unsaved session from … found in this browser"* with **Restore** and **Dismiss** |

## Module 2 — WCGRRT test forms, attachments and Post

| # | File | What must be on screen |
|---|---|---|
| 10 | `10-bop-function-test.png` | The BOP function test form, populated |
| 11 | `11-eds-sequences.png` | The EDS form showing a rig's own sequences — pick a rig with a full sequence list, not `SSCE Equipment`, for this one shot |
| 12 | `12-acoustic-no-system.png` | The acoustic form on **West Vela**, showing the no-system message — this is the trap in the script |
| 13 | `13-ehbs-drawdown.png` | EHBS and drawdown forms, either together or side by side |
| 14 | ~~`14-reference-attachment.png`~~ | **CANNOT EXIST — dropped.** WCGRRT REV 166 has no attach-a-document control on a Well Control daily report: the schedule attach lives inside `#planning-meta-block` (`display:none` unless the discipline is Planning) and the reference document belongs to the Vendor Surveillance report. Module 2 now *says* this instead. The attachment shots are 21 and 22, in SSORT. |
| 15 | `15-post-receipt.png` | The receipt line under Post: `n entries · n photographs · n attachments · n.n MB` and the time |
| 16 | `16-dashboard-row.png` | The dashboard filtered to SSCE Equipment with the posted report visible |

## Module 3 — SSORT CBM, grades, pre-deployment, OEM

| # | File | What must be on screen |
|---|---|---|
| 17 | `17-ssort-rev-badge.png` | SSORT top bar with the **REV 153** badge legible, and the section dropdown showing the six SSORT types |
| 18 | `18-cbm-riser-adapter.png` | CBM tile with **Riser Adapter** selected and section 1.1 open |
| 19 | `19-grade-buttons.png` | Task **1.1.1** with grade **3** selected — buttons 1–5, N/A and the ⓘ scale all visible |
| 20 | `20-grade-scale.png` | The GRADE LEVEL EVALUATION GUIDE panel open, all five levels readable |
| 21 | `21-attachments-empty.png` | **Test Records & Attachments** open and empty, showing the intro line and **+ Attach test record** |
| 22 | `22-attachments-filled.png` | Two files attached with notes filled (`1.2.1 mud seal test…`), and the footer total reading `2 attached · nnn KB` |
| 23 | `23-pre-deployment.png` | The pre-deployment checklist showing the packer attestation and the cavity photograph slots |
| 24 | `24-post-to-oem.png` | The **✉ Post to OEM + Dashboard** button and its confirm dialog open, with the attachment sentence visible |

---

## Two notes for whoever captures these

- **Shot 11 is the one exception to `SSCE Equipment`.** The EDS form needs a real rig to show a real
  sequence list. Use any rig with a full set; no rig data is sensitive here, but keep the asset name
  out of the caption in the workbook so it does not read as that rig's record.
- **Shots 3, 8, 20 and 24 are dialogs and panels.** They are the ones people actually need in the
  workbook, because they are the text a trainee has to read and act on. If time is short, capture
  those four first.

## Four shots that cannot be captured, and why

Stated here rather than left as gaps in a zip.

| # | Why |
|---|---|
| **3** `03-no-rig-guard.png` | A native browser dialog. The automation that drives the tool dismisses these before a capture can happen, so there is no way to photograph one from here. **The full text is quoted verbatim in module 1 step 7** and is the thing the workbook actually needs. Capture it by hand in ten seconds if you want the picture. |
| **8** `08-report-date-guard.png` | Same reason. Text quoted verbatim in module 1 step 20. |
| **24** `24-post-to-oem.png` | The confirm is a native dialog, same reason. **The button in context was captured** and the confirm wording is quoted in module 3 step 69 and on the exercise sheet. |
| **15** `15-post-receipt.png` | The receipt only appears after a **successful post**, and nothing is posted from a build session — that is Dan's rule and it is the right one. Capture this one live: it will be on screen the first time anyone posts in module 2 or the exercise. |
| **16** `16-dashboard-row.png` | Needs a posted report on the dashboard, so the same applies. Take it from any real SSCE Equipment row, or during the class. |

Everything else in the table above was captured on the deployed builds (WCGRRT REV 166, SSORT
REV 153) on 30 September.
