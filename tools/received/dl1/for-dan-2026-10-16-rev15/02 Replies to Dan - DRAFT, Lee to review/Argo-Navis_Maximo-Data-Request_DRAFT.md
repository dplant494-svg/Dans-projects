# Argo Navis: Maximo data it does not have today. One request for Manpreet (DRAFT)

**From:** Lee Arnold and the Argo Navis (DL-1) session · **For:** Dan Plant to send to Manpreet · **Date:** 12 October
2026, updated 14 Oct · **Status:** draft for Lee's review. Dan sends it to Manpreet once Lee has reviewed it.

**Why this exists.** Dan asked (resolved matrix, G-01) for the Maximo data Argo Navis lacks, collected so that one request
can go to Manpreet. Argo Navis reads the daily WO extract at `\\SEADRILL23339\Well Control Data\WO.csv`. Its 15 columns
are:

```
SITEID, WONUM, DESCRIPTION, WOPRIORITY, PERSONGROUP, CREWWORKGROUP, ASSETNUM, ASSET_DESCRIPTION, LOCATION, ROUTE,
STATUS, WORKTYPE, TARGCOMPDATE, REPORTDATE, JPNUM
```

Each item below names:

- the pre-deployment line or plan feature that needs it;
- what Argo Navis does without it today;
- the Maximo object it most likely comes from. **The field names are our best reading of standard Maximo and need
  Manpreet's confirmation;** Seadrill's configuration may differ.

## The request, in priority order

| # | Data | Needed for | Today without it | Likely Maximo source |
|---|---|---|---|---|
| 1 | **Corrective work orders** (CM), not only PMs | B-03 "all CMs and known deficiencies repaired, WOs closed out"; the plan must hold every PM **and CM** | `WORKTYPE` is `PM` on every row (2,631 of 2,631 on 2026-09-25), so no CM can be listed or tracked | `WORKORDER` with `WORKTYPE` in (CM, EM…), same sites and SFI locations as today |
| 2 | **Status date and actual start / finish** per WO | B-03 "work orders not completed at freeze" and the deferral record; actual durations | Only `STATUS`, `TARGCOMPDATE` and `REPORTDATE`; completion is typed in Argo Navis | `WORKORDER.STATUSDATE`, `ACTSTART`, `ACTFINISH`; `WOSTATUS` history if available |
| 3 | **Maximo Non-Conformity records** linked to the WO: number, status, approval, approver, date | B-03 (each open WO needs an **approved** NC); G-01 (the NC number on the form) | The planner types the NC reference (REV 11). It is checked for being non-blank only; approval cannot be seen | The NC application or object Seadrill uses, with its link to `WONUM` (to be confirmed with Manpreet) |
| 4 | **AAB records per rig with acknowledgement state** (outstanding / partly acknowledged / overdue / closed) | B-15 (AAB C10078078 state), B-17 (overdue AABs, populated not asked), B-18 (AAB C10247907 compliance), AAB tasks in the plan | AABs are known only as eDOCS documents in the WCE Reference Hub, with no state; B-15 and B-17 are answered by hand | Wherever Maximo holds the AAB actions per asset or site (to be confirmed); SACRED's AAB register covers it on the dashboard side |
| 5 | **Asset part number, serial number and install date per BOP position** (annulars, connectors, each ram cavity's FWD / AFT packer) | C-02, C-03, C-04 stack table; D-01 to D-03 slot matching | Typed by the crew. The CoC Tracker has part / serial per **asset**, but nothing maps an asset to a stack **position** | `ASSET` (`ITEMNUM`, `SERIALNUM`, `INSTALLDATE`) under the stack's `LOCATION` hierarchy, plus **a location → position map** (e.g. `331.BOP1.365` → `UPR`) |
| 6 | **MOC ↔ WO link** | B-04 (a modification has a WO and an MOC, which is a task in the plan) | MOC tasks are added by hand, with candidates from Synergi MoCs in the WCE Hub | A Synergi MoC number on the WO (a WO attribute or worklog), or the WO number on the Synergi case |
| 7 | **`PMNUM`** on every WO | Plan task identity across re-issued WOs; SACRED's `maximo-reference.json` (DL-1 reply Q24 item 4) | Not in the extract | `WORKORDER.PMNUM` |
| 8 | **Job plan revision**, and **per-site variants** | Linking a checklist to the revision it was made under; rigs whose make / model needs its own procedure (job plan handoff §9 Q7) | `JPNUM` only; the job plan export is a point-in-time snapshot | `JOBPLAN.PLUSCREVNUM` (or the revision field in use), `JOBPLAN.SITEID` |
| 9 | **Well name** for the rig's current / next well | A-01 header (rig, well, stack, date) | Typed | Not in Maximo as far as we know; the daily log / drilling programme may be the source |
| 10 | **Meter readings / cycle counts** per BOP function | B-09, C-03 cycle counts | Typed; PLATO is the planned source (SACRED item 63) | Maximo meters if they are kept; otherwise PLATO only |

**Added 13 Oct:**

- **Detailed job plan exports still missing.** Lee has exported 52 of the 54 job plans that had no saved detailed export
  (`Job plan detailed - missing plans 2026-10-13.xlsx`). Still needed: **0900-UR0007** (MPD integrated riser joint
  service) and **0900-UR90021**.
- **The Electrical job plan list export holds only 23 plans.** Generic electrical plans with live WOs (e.g.
  0900-EE90061, 13 APPR WOs on 6 rigs) are missing from it. Please export the full list of electrical job plans used on
  WCE and MPD equipment.

## Practical notes for the extract

- **Keep the column names stable.** Argo Navis finds columns by name, and a rename fails silently: it happened once, when
  `DESCRIPTION_1` became `ASSET_DESCRIPTION`. Additions are always safe.
- **Keep `WOPRIORITY` and `WORKTYPE` stable, and carry the CM rows in the same extract (item 1)** (added 14 Oct, at
  SACRED's request). SACRED's AAB and precharge pre-fills key on the same WO numbers. A second extract for CMs, or
  recoded priority and work-type values, would split the two tools' view of the same work order.
- **Deliver the file complete, or not at all.** The 24-hour task has been leaving partial files. The scanner now
  refuses a file until it is complete. Writing to a temporary name and renaming at the end avoids this.
- **Encoding.** The extract decodes as Windows-1252. UTF-8 would be preferred, but either works.
- **Where to put it.** A second file beside `WO.csv` is simplest for items 1–4 and 7, which are per WO. Items 5 and 8 are
  better as their own files: `assets-by-position.csv` and `jobplans.csv`.

**Items 3 and 4 decide the most.** With them, B-03, G-01, B-15 and B-17 become computed lines instead of typed ones, as
the resolved matrix intends.
