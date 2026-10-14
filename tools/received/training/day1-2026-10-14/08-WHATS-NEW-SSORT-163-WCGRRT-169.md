# What changed for the class: SSORT 159 → 163, WCGRRT 168 → 169

**From:** the reporting-tools session · **Date:** 13 October 2026 · **For:** the trainer and the dashboard session
**Why:** on 13 October Dan moved the pack to the builds that are live: **WCGRRT REV 169** and **SSORT REV 165**.

> **Since then: SSORT 164 (13 Oct) and SSORT 165 (14 Oct, the class build).** 164 fixed the 📦 Daily Log tab, which Day 1
> does not teach: the month's PDF now lists the month's entries, and a stray Post Report that posted blank reports is gone.
> **165 adds the FRM-00-0168 Rev 9 additions to the pre-deployment checklist**, which the class does use: ROV panel valve
> orientation and line-up (a tick and captioned photographs), and riser running and pulling (three ticks, and maintenance by
> 3rd party / CBM / Seadrill). Module 3 step 66b and the exercise's report 4 cover it; shots 23b and 23c show it. The badge
> reads REV 165 · 2026-10-14.


**The freeze starts on 15 October, so these are the builds on the 19th.** Both are hash-verified on the servers today:

| Tool | Revision | sha256 | Bytes | Deployed |
|---|---|---|---|---|
| WCGRRT | **REV 169** | `9af1e76a986da12644293335f67512982794d7ee8374a141d8db766b75bc7b6b` | 3,345,420 | 10 October |
| SSORT | **REV 165** | `f4c982426a054d78a5bef9573dde60f227a70705d5a872a99d192b4d0bfa3426` | 7,350,417 | 14 October |

---

## What a trainee will see that is new

| # | What | Tool / rev | In the script | Shot |
|---|---|---|---|---|
| 1 | **Drag a photo onto a photo box** | WCGRRT 169 | M1 step 14 | — (drag cannot be photographed) |
| 2 | **Model and Serial Number marked "\* required by NOV"**, per unit. Copy-to-all and Duplicate no longer carry them; Post to OEM asks if they are blank | SSORT 160 | M3 steps 49a–49b | **18a**, **18b** |
| 3 | **C&K Stabs: Stab Identification** (part no., serial, Maximo asset no. per stab) | SSORT 160 | M3 step 49b (mention only) | — |
| 4 | **The Technical Assistance Request**: 📨 Requests → Technical Assistance Request, the DIR-00-0116 checklist, Practice send | SSORT 161 | M3 section 6, steps 70a–70g (new, 10 min) | **25**, **26** |
| 5 | **SFI code picker** on the assistance request | SSORT 163 | M3 step 70e | **27** |
| 6 | **Maintenance plan (DL-1)** picker in Vessel Information | SSORT 162 (live in 163) | M3 step 46a | **17a** |
| 7 | **🔗 Link to plan** on the pre-deployment checklist and every surface test tile | SSORT 162 (live in 163) | M3 step 66a | **23a** |
| 8 | **FRM-00-0168 Rev 9 additions** on the pre-deployment checklist: ROV panel valve orientation and line-up (tick + captioned photos), riser running and pulling (3 ticks), riser maintenance by 3rd party / CBM / Seadrill | SSORT 165 | M3 step 66b; exercise report 4 | **23b**, **23c** |

**Module 3's timings:** CBM goes from 40 to 35 minutes and test records from 20 to 15, making room for the 10-minute
assistance request. The module still ends at 14:30.

**Unchanged, and still true on 165 / 169:**

- the date guard and stale-entry marking (WCGRRT);
- the fail-closed rig guard;
- the CBM grades, attachments and Post to OEM (NOV still receives the attachments);
- the pre-deployment gate;
- SSORT's silent post failure. Post Report still gives no warning; the two new controls above are the exceptions;
- one report type per workspace.

---

## Three errors in the 159 pack, found while moving it and corrected

1. **SSORT's button is 📤 Post Report.** The exercise sheet said *📤 Post to Dashboard* twice. That label belongs to the Daily
   Checks form on the Daily Log tab, which the class does not use. **Corrected** on the exercise sheet.
2. **File names.** The class's file names in the exercise sheet and the reply's §1.3 were the pre-158 ones. On 163 they are:

   ```
   seadrill-report_SSCE-Equipment_2026-10-0n_daily-report.json
   seadrill-report_SSCE-Equipment_2026-10-0n_surface-bop-testing_BOP-Function-Test.json
   seadrill-report_SSCE-Equipment_2026-10-0n_cbm-inspection_Riser-Adapter-SNTRN-0n.json
   seadrill-report_SSCE-Equipment_2026-10-0n_pre-deployment-checklist.json
   seadrill-oem_SSCE-Equipment_2026-10-0n_Riser-Adapter_<timestamp>_cbm.json       (Post to OEM, unchanged)
   ```

   Each trainee now enters serial **`TRN-0n`** (matching their date) on the CBM. That satisfies "required by NOV", and keeps
   the names distinct. **For Dan's clean-up after the class:** these are the 40 report files, plus one OEM file per trainee.

3. **The deck in PowerPoint.** Rendered through PowerPoint on 13 October, **10 of the 20 slides drew their text piled up at
   the top-left**: the title, the opening, all four module dividers and the four Title-and-Content slides. Their text boxes
   stored a height of zero. The checks table (now slide 19) also ran off the bottom, so the last two rows, the two *post
   failed* lines, were never on screen.
   - **Fixed:** each of those boxes now has an explicit size at its layout's position.
   - **The table:** rows tightened to 10.5 pt, so all 15 checks show.
   - **Text unchanged:** no wording moved except the edits listed below.

   Every slide was re-rendered and checked. If the dashboard built anything from the deck's look, re-export from this copy.

**The deck's own edits:**

- **Slide 3:** WCGRRT REV 169 and SSORT REV 165, and what each added.
- **New slide 16, *New this month, on SSORT 165*:** model and serial, the assistance request, the plan picker and Link to
  plan.
- **Slide 18:** the exercise's CBM includes its model and serial.
- **Slide 19:** the SSORT *silent* row names its two exceptions.

The deck goes from 20 slides to 21.

---

## Screenshots: in `screenshots-163/`, 1600 px, light mode

Taken on the class builds (headless Edge, `fetch` blocked so **nothing was posted**), on asset `SSCE Equipment`. The one
exception is 27: the SFI list holds no codes for SSCE Equipment, so it is shown on West Capella, for display only, as shot 11
already does.

| File | Replaces or adds |
|---|---|
| `01-wcgrrt-rev-badge.png` | **Replaces 1**: the badge reads WCGRRT · REV 169 |
| `17-ssort-rev-badge.png` | **Replaces 17**: the badge reads SSORT · REV 165; Vessel Information shows the new plan picker |
| `17a-plan-picker.png` | **New**: *No open plan for SSCE Equipment. Posts go out as normal.* |
| `18a-cbm-model-serial-required.png` | **New**: Recipient Details blank, both fields marked \* REQUIRED BY NOV |
| `18b-cbm-unit-identity-filled.png` | **New**: the same Riser Adapter tile with model and serial filled |
| `23a-link-to-plan.png` | **New**: 🔗 Link to plan beside Generate Checklist PDF |
| `25-tar-form.png` | **New**: the whole request, rig down, Practice send ticked, *Practice send (office only)* |
| `26-tar-dir-checklist.png` | **New**: the DIR-00-0116 list at seven hours down, MANDATORY NOTIFICATION |
| `23b-pdc-rev9-rov-panel.png` | **New (165)**: the Rev 9 section, ROV panel tick and two captioned photographs |
| `23c-pdc-rev9-riser.png` | **New (165)**: the riser ticks and maintenance by 3rd party (named) / CBM / Seadrill |
| `27-tar-sfi-picker.png` | **New**: SFI 331.BOP1.200 picked, manufacturer and model filled, Maximo asset C1004805 |

**The dashboard's own shots that may now be out of date:**

- **18 and 19.** If Recipient Details is in frame, it lacks the red "required by NOV" marks. 18a and 18b cover the point,
  so a retake is optional.
- **23.** The pre-deployment tile header now carries 🔗 Link to plan. That is visible if the header is in frame; 23a covers
  it.
- Everything else is unchanged between the builds.

The badge also shows a date, *2026-09-23*, on both tools. **It is not the build date.** It is a constant
(`SSORT_REV_DATE`, and its WCGRRT twin) last changed at SSORT 156 / WCGRRT 166 and not bumped since. If a trainee asks, the
revision number is the thing to read. It is logged as a wording fix for after the class; the tools do not change for it
before then.

---

## The sample reports, rebuilt on 165 / 169

- **How:** each file was loaded through the tool's own **📂 Load from File** and rebuilt by `buildReportPayload`, with
  nothing posted.
- **What changed:** a deep comparison shows nothing besides `meta.rev` and the export time. The CBM sample also gained its
  model and serial.
- **Renamed:** two samples take the names 163 now gives them. See `samples/README.md`.

---

## For Dan

- **Practice send in the room?** Module 3 step 70g leaves it to you. Pressing it once emails the Technical Services office
  only, marked TEST; nobody else. Not pressing it costs nothing: the screenshots show the form.
- **The deck** is updated, gains one slide and is fixed to draw properly in PowerPoint: see error 3 above. Run it through once
  in PowerPoint before the 19th.
