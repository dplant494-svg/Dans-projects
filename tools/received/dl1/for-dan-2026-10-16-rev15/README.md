# For Dan: everything Argo Navis sends to Dan Plant and SACRED

**Updated:** 15 Oct 2026, evening.

| REV | State |
|---|---|
| **REV 13** | Live at `/sacred/dl1/` |
| **REV 14** | Posting and review holds. Packaged, never deployed. |
| **REV 15** | REV 14 plus Dan's Handoff 2: the Daily Summary Report and eight planning changes. **The package in `01`.** |

**Copies only.** Edit the originals, then copy them here again:

- replies: `Synergi-Edocs Project\DL-1 SACRED reply\`;
- workbooks and screenshots: the `Schedule Builder\` root;
- packages: `Deploy\`.

**Left out on purpose:**

- **Any intake address.** This folder and the zip are scanned and clean. REV 15 reads the address at run time from Dan's
  `argo-config.json`, and so does the built-in checklist.
- **Dan's original checklist file.** REV 15 carries it built in, with the address removed.
- **The rules files.** They are on the share.

## 01 Deploy package: REV 15

| File | What it is |
|---|---|
| `Argo-Navis_REV15_2026-10-15.zip` | `index.html` + `Seadrill BOP Schedule Builder.html` (identical) + `DEPLOY-README.txt`. It replaces REV 13 at `/sacred/dl1/`. **Dan places `argo-config.json` beside it** (`dryRun:true` first). `Argo-Navis-Job-Plan-Checklists.html` is no longer needed. |
| `DEPLOY-README.txt` | The install note. HTML SHA-256 `b35f2b1bfff354e941dc6c688f8382e43fe13b973f047402704291e7f8302b46`. |

**Zip SHA-256:** `17a2be5c74ee62377941a2589b3356b513139c148f5758c374b7b6994ec06576`.

## 02 For Lee to review, then send

| File | What it is |
|---|---|
| `ARGO-NAVIS-REV15-REPLY-TO-DAN_DRAFT.md` | **The reply to Handoff 2:** A1–A7 and B1–B8 with status, the A6 confirmation (break-ins move the schedule), what Lee added (event PMs), the sample, and 4 questions. |
| `ARGO-NAVIS-REV14-REPLY-TO-DAN_DRAFT.md` | **Send it with the REV 15 reply if it has not gone yet.** It explains posting, the review holds, and the `argo-config.json` that REV 15 still needs. |
| `Argo-Navis_Maximo-Data-Request_DRAFT.md` | The request for Manpreet, through Dan. |

## 03 Sent to Dan (reference)

The earlier replies and Dan's notes, for the thread.

## 04 JSON samples

- **`REV 15 Daily Summary Report (test post, West Vela BOP1)\`** (**the sample Dan asked for**):
  - `SAMPLE_…planning-report_BOP1_v2.json`: every A3 and A4 key filled, with dummy people marked SAMPLE, `dryRun:true`,
    report time 0700;
  - `SAMPLE_…plan-progress_BOP1_v2.json`: the progress post from the same press;
  - `SAMPLE_preview_as_SACRED_prints_it.html`: Dan's own `planReportDocHTML` on that record.
- **`REV 14 posts (test posts, West Vela BOP1)\`:** the seven posting files of REV 14.
- **Also:** the REV 13 samples and the REV 10 dry-run shapes.

## 05 Job plans

| File | What it is |
|---|---|
| `Branch_Map_Additions_302_315_DRAFT_for_Dan_2026-10-15.xlsx` | **New.** 31 proposed rows for the SFI 302 / 315 job plans in Manpreet's extract of 15 Oct (129 WOs): Offline Ancillary, one group per SFI. **For Dan to review.** |
| `Job_Plan_Gap_Report_2026-10-15.xlsx` | **New.** The gap report on the 15 Oct feed: 67 plans / 377 WOs. It supersedes v2 of 13 Oct. |
| `Branch_Map_Additions_DRAFT_for_Dan_2026-10-13.xlsx` | The 36 rows Dan accepted on 14 Oct. |
| `Job_Plan_Gap_Report_2026-10-13_v2.xlsx`, `Missing_Job_Plans_for_Maximo_2026-09-26.csv` | Earlier. |

## 06 Screenshots

**`ArgoNavis_REV15_*`:**

- event PMs with no WO, and SFI groups;
- the timeline by SFI with milestone stars;
- the links editor;
- the daily report and rig people;
- break-ins in the schedule, with NC on deferrals;
- the built-in checklist.

The REV 14 and REV 13 screens are kept too.

## 07 User guide and QA-QC

| File | Live page |
|---|---|
| `SCHEDULE-BUILDER-USER-GUIDE.html` (v20, REV 15 section) | https://claude.ai/artifact/Q4N7HuGZVRvasGQJ5AA4Gn |
| `DL1_QAQC_Requirements_and_Punch_List.html` (DR-01…12, QA-44…47) | https://claude.ai/artifact/MwPHdrm57c3rPidS5yn3GN |

The live pages are private until Lee shares them.

## Waiting on Dan

1. **`argo-config.json`** beside `index.html`, then REV 15 deployed and a first test post.
2. **Confirm that the BOP ready date is the BOP set's finish** (QA-44), and send SSORT 163's `sfiGroup` names.
3. **The 31 SFI 302/315 Branch Map rows** (QA-45).
4. **The event PM exports** on the scanner (QA-46), once Lee puts them on the share.
5. **Still open from before:** `review.comments`, the freeze version, the sign-off order, B-16 / B-M1, and the eDocs
   prefix.
