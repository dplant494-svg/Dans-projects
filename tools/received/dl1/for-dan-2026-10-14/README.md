# For Dan: everything Argo Navis sends to Dan Plant and SACRED

**Assembled:** 14 Oct 2026 · **Build:** REV 13 (local, read-only) · **Posting build:** REV 14 (not yet built)

Everything here is a **copy**. The originals stay where they're edited:

- the replies are in `Synergi-Edocs Project\DL-1 SACRED reply\`;
- the workbooks and screenshots are in the `Schedule Builder\` root;
- the package is in `Deploy\`.

If an original changes, copy it here again.

**Left out on purpose:**

- **The job plan checklist file** (`Argo-Navis-Job-Plan-Checklists.html`). It is Dan's, he already has it, and it
  carries the SACRED intake URL.
- **Anything carrying a SACRED URL.** This folder was scanned and is clean.
- **The 18 rules files.** They are already on the share at `\\SEADRILL23339\Well Control Data\Job Plans\` (copied 14 Oct,
  verified by hash). Dan's scanner reads them there.

## 01 Deploy package: send as is

| File | What it is |
|---|---|
| `Argo-Navis_REV13_2026-10-14.zip` | `index.html` + `Seadrill BOP Schedule Builder.html` (identical) + `DEPLOY-README.txt`. Dan drops the contents into `C:\TSC-Dashboard\tools\argo-navis\` and runs Deploy; it serves at `/sacred/dl1/`. It replaces the 13 Oct package. |
| `DEPLOY-README.txt` | Install note. HTML SHA-256 `31e76a1514a9c5387032cce9fe770b5d1f28f2baad99884c7fbe699328638627`. |

- **Zip SHA-256:** `9d57b75767082b3498f7dfd883579d885be037eeafd276cbdeb7ae99bbee1419`.
- **REV 13 posts nothing.** It reads `data/index.json` from the same server.

## 02 Replies to Dan: DRAFTS, Lee to review before sending

| File | What it answers |
|---|---|
| `ARGO-NAVIS-HOSTING-REPLY-TO-DAN_DRAFT.md` | **The main reply.** It answers Dan's hosting handoff of 13 Oct and, in its 14 Oct update at the top, his handoff of 14 Oct: rules files on the share, the new package, Rev 9 lines, optional sign-offs, the testing % key, review state. |
| `DL1-ROLLING-HANDOFF-ENTRY-2_DRAFT.md` | Rolling-handoff entry 2. **Open:** photo-size limit, read-back file, JPC hosting; the sign-off order is a placeholder pending Dan. |
| `Argo-Navis_Maximo-Data-Request_DRAFT.md` | The data request for Manpreet, through Dan: CM WOs, NC records, AAB states, asset per BOP position, the UR0007/UR90021 plans, the Electrical list. |
| `PDC-MATRIX-PROPOSAL-dashboard-reviewed_Lee-DRAFT.xlsx` | Dan's pre-deployment matrix, with a Lee column drafted in reply to entry 69. |

## 03 Earlier replies (11 Oct): reference

| File | What it is |
|---|---|
| `DL1-REPLY-TO-SACRED.md` | The full DL-1 reply of 11 Oct. |
| `DL1-ROLLING-HANDOFF.md` | The rolling handoff, entry 1. |

## 04 JSON samples

**Made today from REV 13** on the test data:

- WO.csv of 25 Sep;
- West Vela BOP1, commencing 5 Oct;
- 146 items, 916.5 h, finish 15 Oct, 97 % coverage. This is the current test baseline.

| File | What it is |
|---|---|
| `SAMPLE_REV13_West-Vela_BOP1_planning-report.json` | The planning-report payload (`buildPayload`, version 3, additive keys) as REV 13 builds it. REV 14 adds `planningData.testingPct`. |
| `SAMPLE_REV13_pre-deployment_WVE-BOP1-20261005_rev1.json` | The pre-deployment checklist export, as written by the **Export for SSORT** button. `pdcData` uses SSORT 165's keys exactly, including the Rev 9 `pdc_r9_*` keys; this one is for a 7-cavity single stack. It is not yet ready or complete: it shows the as-started state. |
| `SAMPLE_REV13_designation_WVE-BOP1-20261005.json` | The BOP designation set: the required rows and the 42 photograph slots. SSORT and WCGRRT read it from the plan folder once REV 14 posts it. |

**`Posting shape (REV 10 dry-run, 11 Oct)\`** holds the three `plan`, `plan-progress` and `planning-report` files sent
with the 11 Oct reply. They show the shape REV 14 will post. They were built before REV 13's changes: no SSS-007 task,
Excluded plans not yet deferred.

## 05 Job plans: for Dan's Branch Map and Maximo

| File | What it is |
|---|---|
| `Branch_Map_Additions_DRAFT_for_Dan_2026-10-13.xlsx` | 36 proposed rows in the Branch Map's own columns, for plans on neither sheet (30 High, 4 Medium, 2 Low confidence). **Dan's map is not edited.** |
| `Job_Plan_Gap_Report_2026-10-13_v2.xlsx` | The current gap report: 42 plans / 201 WOs missing from the Branch Map, Durations, saved plans, lists or JPC. Excluded plans (12 / 87 WOs) are on their own sheet. It supersedes the 54-plan first version. |
| `Missing_Job_Plans_for_Maximo_2026-09-26.csv` | The original 26 Sep list. All 48 of its plans are reconciled in the gap report. |

## 06 Screenshots: REV 13

The screens behind the replies:

- pre-deployment top, photos, and the Rev 9 lines;
- the Execute checklist pop-up;
- the Scope Challenge;
- the "Unassigned" label;
- the job plan gaps;
- matched Lessons & References.

## 07 User guide and QA-QC

| File | Live page |
|---|---|
| `SCHEDULE-BUILDER-USER-GUIDE.html` | https://claude.ai/artifact/Q4N7HuGZVRvasGQJ5AA4Gn |
| `DL1_QAQC_Requirements_and_Punch_List.html` | https://claude.ai/artifact/MwPHdrm57c3rPidS5yn3GN |

The live pages are private until Lee shares them. Send the files if Dan can't open the links.

## Still to come (not in this folder)

- **The REV 14 deploy package, with posting.** It adds `testingPct`, review state from `plans-open.json`, `edocsRef`,
  and `deferred[]` with the "Excluded on Branch Map" reason.
- **The feed:** WO.csv on the share was still the 25 Sep extract on 13 Oct; Manpreet's 24-hour task is due.
