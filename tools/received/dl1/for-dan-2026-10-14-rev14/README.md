# For Dan: everything Argo Navis sends to Dan Plant and SACRED

**Updated:** 14 Oct 2026, evening. **REV 13** is live at `/sacred/dl1/` (Dan deployed it 17:39). **REV 14** (posting,
review holds, the BOP ready date) is the package in `01`.

**Everything here is a copy.** Edit the originals, then copy them here again:

- replies: `Synergi-Edocs Project\DL-1 SACRED reply\`;
- workbooks and screenshots: the `Schedule Builder\` root;
- packages: `Deploy\`.

**Left out on purpose:**

- **The job plan checklist file:** Dan's, and it carries the intake URL.
- **Any intake address:** this folder and the zip were scanned and are clean. REV 14 reads the address at run time from
  Dan's `argo-config.json` on the server.
- **The 18 rules files:** they are on the share, `\\SEADRILL23339\Well Control Data\Job Plans\`.

## 01 Deploy package: send when Lee is happy with REV 14

| File | What it is |
|---|---|
| `Argo-Navis_REV14_2026-10-14.zip` | `index.html` + `Seadrill BOP Schedule Builder.html` (identical) + `DEPLOY-README.txt`. It replaces REV 13 at `/sacred/dl1/`. |
| `DEPLOY-README.txt` | The install note, including the `argo-config.json` Dan places beside `index.html`. HTML SHA-256 `1f0d6a2c8a625d50810d3afcc65c016a41405a940fad6071df539ab27e525792`. |

- **Zip SHA-256:** `71973b7cd88afd5630723e276e08b4bce8f90f08cadac3f637ff9fba920f495d`.
- **The REV 13 package** Dan already deployed stays in `Deploy\`.

## 02 For Lee to review, then send

| File | What it is |
|---|---|
| `ARGO-NAVIS-REV14-REPLY-TO-DAN_DRAFT.md` | **The reply to Dan's evening note.** It covers what REV 14 does, the `argo-config.json` ask, the choices made (freeze keeps the verified version; both review field names are read; `review.comments` is asked for; `testingPct` and `edocsRef` are settled), and the suggested first live test post. |
| `Argo-Navis_Maximo-Data-Request_DRAFT.md` | The request for Manpreet. Dan sends it once Lee has reviewed it. Updated 14 Oct with Dan's ask: keep `WOPRIORITY`/`WORKTYPE` stable and carry CM rows in the same extract, and deliver the file complete or not at all. |

## 03 Sent to Dan (reference)

These are the earlier replies Dan has now answered: the hosting reply, Entry 2, the PDC matrix column, the 11 Oct DL-1
reply and handoff. Dan's own evening note (`ARGO-NAVIS-REPLY-FOR-LEE-2026-10-14-EVENING.md`) is here too, for the thread.

## 04 JSON samples

**`REV 14 posts (test posts, West Vela BOP1)\`** holds the seven files REV 14 posts, in order. All are `dryRun:true`.
They were captured from the golden test data with a dummy intake; nothing was posted.

1. `plan` v1, proposed (Post for review).
2. `designation`, with the `meta` block Dan asked for.
3. `plan` v1, frozen (same version as verified).
4. `plan-progress`, a full snapshot.
5. `planning-report` (the second file from Post progress).
6. `pre-deployment` (Post checklist).
7. `plan-closeout`, with `edocsRef` and `projectComplete`.

**Also here:**

- The REV 13 samples of 14 Oct: the planning report, the pre-deployment export and the designation, without `meta`,
  which REV 14 adds.
- The 11 Oct REV 10 dry-run shapes.

## 05 Job plans

| File | What it is |
|---|---|
| `Branch_Map_Additions_DRAFT_for_Dan_2026-10-13.xlsx` | The 36 proposed rows. **Dan accepted all 36 on 14 Oct** and pastes them into the map on the share. |
| `Job_Plan_Gap_Report_2026-10-13_v2.xlsx` | 42 plans / 201 WOs. After the 36 rows, only 0900-UR0007 and UR90021 should stay Unassigned. |
| `Missing_Job_Plans_for_Maximo_2026-09-26.csv` | The original list. |

## 06 Screenshots

- **`ArgoNavis_REV14_*`:** the server status strip, the plan bar with read-back, the BOP ready banner, Simulate, and the
  deferral reason.
- **`ArgoNavis_REV13_*`:** the earlier screens.

## 07 User guide and QA-QC

| File | Live page |
|---|---|
| `SCHEDULE-BUILDER-USER-GUIDE.html` (v19, with the REV 14 section) | https://claude.ai/artifact/Q4N7HuGZVRvasGQJ5AA4Gn |
| `DL1_QAQC_Requirements_and_Punch_List.html` (PO-01…15, QA-41…43 added) | https://claude.ai/artifact/MwPHdrm57c3rPidS5yn3GN |

The live pages are private until Lee shares them.

## Waiting on Dan

1. **`argo-config.json`** beside `index.html`, with `dryRun:true`, then REV 14 deployed and a first test post (QA-41).
2. **`review.comments`** in `plans-open.json` (QA-42).
3. **Confirm that Freeze keeps the verified scope version** (QA-43).
4. **Still open from before:** the sign-off order, the B-16 / B-M1 directives, the eDocs prefix (ISIT next week), and
   the WO feed refresh (still 25 Sep).
