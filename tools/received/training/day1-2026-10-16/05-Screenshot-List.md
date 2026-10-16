# Day 1 screenshot list — 24 shots, numbered to the walkthrough scripts, plus those added for SSORT 163–169 / WCGRRT 174

> **16 October: the frozen builds are WCGRRT 174 / SSORT 169.** Retaken and new shots are in `screenshots-169/` (1600 px, light
> mode, nothing posted: every post was answered inside the test browser). Retaken: **1, 15, 17**. New: **18c, 23d, 28a, 28b, 29,
> 30, 31, 32**. Shot 15 can now be captured. See `09-WHATS-NEW-SSORT-169-WCGRRT-174.md`.

> **13 October:** the class builds are now WCGRRT 169 / SSORT 166. **Shots 1 and 17 are retaken, and seven new shots added
> (17a, 18a, 18b, 23a, 23b, 23c, 25, 26, 27)**, all in `screenshots-163/`, taken by the tools session at 1600 px with nothing posted.
> See `08-WHATS-NEW-SSORT-163-WCGRRT-169.md` for which of the dashboard's own shots may want retaking (18, 19, 23: optional).

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
| 1 | `01-wcgrrt-rev-badge.png` | WCGRRT top bar with the **REV 174** badge legible. **Retaken 16 Oct: `screenshots-169/`** |
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
| 14 | ~~`14-reference-attachment.png`~~ | **CANNOT EXIST — dropped.** WCGRRT REV 169 (as 168) has no attach-a-document control on a Well Control daily report: the schedule attach lives inside `#planning-meta-block` (`display:none` unless the discipline is Planning) and the reference document belongs to the Vendor Surveillance report. Module 2 now *says* this instead. The attachment shots are 21 and 22, in SSORT. |
| 15 | `15-post-receipt.png` | The receipt after a post: *✓ Posted — n entries · n photographs · n.n MB* and the *Posted <file>* box under the button. **Taken 16 Oct: `screenshots-169/`** |
| 16 | `16-dashboard-row.png` | The dashboard filtered to SSCE Equipment with the posted report visible |

## Module 3 — SSORT CBM, grades, pre-deployment, OEM

| # | File | What must be on screen |
|---|---|---|
| 17 | `17-ssort-rev-badge.png` | SSORT top bar with the **REV 169** badge legible. **Retaken 16 Oct: `screenshots-169/`** |
| 17a | `17a-plan-picker.png` | **New (SSORT 162/163).** Vessel Information: Maintenance plan (DL-1), *No open plan for SSCE Equipment. Posts go out as normal.* |
| 18 | `18-cbm-riser-adapter.png` | CBM tile with **Riser Adapter** selected and section 1.1 open |
| 18c | `18c-cbm-usage-table.png` | **New (SSORT 169).** Gate Valves: *Usage Data at Date of Removal from Service* with the trainer's training values |
| 18a | `18a-cbm-model-serial-required.png` | **New (SSORT 160).** Recipient Details, Model and Serial Number blank and marked **\* REQUIRED BY NOV** |
| 18b | `18b-cbm-unit-identity-filled.png` | **New (SSORT 160).** The Riser Adapter tile with model and serial filled |
| 19 | `19-grade-buttons.png` | Task **1.1.1** with grade **3** selected — buttons 1–5, N/A and the ⓘ scale all visible |
| 20 | `20-grade-scale.png` | The GRADE LEVEL EVALUATION GUIDE panel open, all five levels readable |
| 21 | `21-attachments-empty.png` | **Test Records & Attachments** open and empty, showing the intro line and **+ Attach test record** |
| 22 | `22-attachments-filled.png` | Two files attached with notes filled (`1.2.1 mud seal test…`), and the footer total reading `2 attached · nnn KB` |
| 23 | `23-pre-deployment.png` | The pre-deployment checklist showing the packer attestation and the cavity photograph slots |
| 23d | `23d-pdc-cavity-placeholder.png` | **New (SSORT 167).** Before the cavity count is set: *set this BOP's cavity count above to load the boxes…* |
| 23b | `23b-pdc-rev9-rov-panel.png` | **New (SSORT 165).** FRM-00-0168 Rev 9 Additions: the ROV panel tick and two captioned valve photographs |
| 23c | `23c-pdc-rev9-riser.png` | **New (SSORT 165).** The riser ticks; maintenance by 3rd party (named), CBM, Seadrill |
| 23a | `23a-link-to-plan.png` | **New (SSORT 162/163).** 🔗 Link to plan beside Generate Checklist PDF on the checklist header |
| 24 | `24-post-to-oem.png` | The **✉ Post to OEM + Dashboard** button and its confirm dialog open, with the attachment sentence visible |
| 25 | `25-tar-form.png` | **New (SSORT 161).** The Technical Assistance Request, rig down, Practice send ticked |
| 26 | `26-tar-dir-checklist.png` | **New.** *What the directive asks (DIR-00-0116)* at seven hours down: MANDATORY NOTIFICATION |
| 28a | `28a-outbox-not-posted-toast.png` | **New (WCGRRT 170).** No connection: *⚠ NOT posted… waiting to send…* and the orange **📤 1 waiting to send** button |
| 28b | `28b-outbox-waiting-list.png` | **New.** The waiting list: the file, Save file, Remove, Send now |
| 29 | `29-outbox-sent.png` | **New.** Connection back: *✓ Sent 1 waiting report to the dashboard.*, the button gone |
| 30 | `30-ssort-posted-receipt.png` | **New (SSORT 168).** The line under 📤 Post Report: *✓ Posted to the dashboard <time> · <file> · <size>* |
| 31 | `31-ssort-not-posted.png` | **New (SSORT 168).** SSORT with no connection: *⚠ NOT posted … waiting to send* |
| 32 | `32-cbm-pdf-usage-and-headings.png` | **New (SSORT 169).** The CBM PDF: the usage table, dates DD/MMM/YYYY, readable headings |
| 27 | `27-tar-sfi-picker.png` | **New (SSORT 163).** SFI code picked, manufacturer / model filled, Maximo asset number shown. *West Capella, display only* |

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
| ~~**15**~~ | **Captured 16 Oct.** The test browser answers the post itself, so the receipt shows with nothing sent. |
| **16** `16-dashboard-row.png` | Needs a posted report on the dashboard, so the same applies. Take it from any real SSCE Equipment row, or during the class. |

Everything else in the table above was captured by the dashboard session itself (see
`07-SCREENSHOTS-STATUS.md`). The two badge shots, 1 and 17, are retaken on the frozen builds
(WCGRRT REV 169, SSORT REV 166); done by the tools session on 13 October.
