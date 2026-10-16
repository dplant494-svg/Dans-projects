# Argo Navis REV 16: handover to Dan Plant and SACRED, 16 October 2026

**From:** Lee Arnold and the Argo Navis session · **To:** Dan Plant and the SACRED dashboard session
**Supersedes:** every earlier Argo Navis package; REV 16 contains REV 14 and REV 15.

**Start here.** This page says what to deploy, what to read, what each file is, and what we need back.

## 1. Deploy (5 minutes)

1. **Unzip `01 Deploy package\Argo-Navis_REV16_2026-10-16.zip`** into `C:\TSC-Dashboard\tools\argo-navis\` and run
   Deploy, as before. It serves at `/sacred/dl1/`.
   - **HTML SHA-256:** `299eed6eed769216bdfb5d9b432c020b11a90daef78d18d39ef60d828a52e945`
   - **Zip SHA-256:** `d73832051e983067ef3647ec0bdf8476719692ab7e52b4e44fa1151a416441a3`
2. **Keep `argo-config.json` beside `index.html` exactly as you have it now**, with the real address and `dryRun:
   true`.
   - The tool reads it at run time.
   - The package contains no address.
3. **`Argo-Navis-Job-Plan-Checklists.html` is no longer needed** beside the tool. The checklists are built into REV 16,
   with the address removed, and take it from `argo-config.json`. You may leave the old file or remove it.
4. **Nothing else changes on the server.** `data/`, `plans-open.json`, `plans-status/` and `plans-state/` are read
   exactly as your scanner (v3.08) writes them.

**Then:** Lee makes the **first dryRun Save and Post daily report** from the server page and tells you when, so you can
watch them arrive:

- the session in `plans-state`;
- the report printed, with the [TEST MODE] email.

## 2. Read, in this order (`02 Replies to Dan`)

| File | Answers |
|---|---|
| `1_ARGO-NAVIS-REV16-REPLY-TO-DAN.md` | **Handoff 3 (L1–L6) and your 16 Oct pm update.** Why Continue refused your files. The landing page, saving at any stage, Post report, the server-save chip, and the chronology with dates and milestone stars. |
| `2_ARGO-NAVIS-REV15-REPLY-TO-DAN.md` | **Handoff 2 (A1–A7, B1–B8) and the report-time addendum.** The Daily Summary Report and the eight planning changes, with A6 confirmed: break-ins move the schedule. |
| `3_ARGO-NAVIS-REV14-REPLY-TO-DAN.md` | **Your 14 Oct evening note.** Posting, the review holds, the BOP ready date, Simulate, `argo-config.json`, and the designation `meta`. |
| `4_Argo-Navis_Maximo-Data-Request.md` | **For Manpreet, through you:** CM work orders, NC records, AAB states, asset per BOP position, PMNUM, the two missing job plans, and keeping `WOPRIORITY`/`WORKTYPE` stable. |

## 3. Everything you asked for, in one place

| Ask | REV | Status |
|---|---|---|
| Designation `meta` | 14 | Done |
| Server status strip | 14 | Done |
| Review holds: Post for review → Freeze (Hold 1) → Progress (Hold 2) → Close-out | 14 | Done |
| BOP ready date, need date, float, Simulate | 14 | Done |
| A1 Daily report twice daily, after shift handover; report time is the rig's | 15 | Done |
| A2/A3 WCGRRT 172 keys via `planning-rules.js` (embedded byte-for-byte) | 15 | Done |
| A4 Rig people per project | 15 | Done |
| A5 Cycle lists against the previous report | 15 | Done |
| A6 Break-in hours in the schedule and critical path | 15 | **Confirmed, done** |
| A7 "DL-1" retired where people read | 15 | Done |
| B1 SFI groups, 331 + 332 = BOP | 15 | Done |
| B2 BOP % on the BOP set | 15 | Done; the ready date uses the same set (**please confirm**) |
| B3 Editable links | 15 | Done |
| B4 Complete = 100 % at the time marked | 15 | Done |
| B5 Checklists built in | 15 | Done |
| B6 Milestone stars | 15 → 16 | Done; REV 16 adds dates across the top and exact times |
| B7 NC number on deferred PMs | 15 | Done, from Manpreet's new `NC` column, or typed |
| B8 SFI 302 / 315 shown | 15 | Done; Branch Map rows proposed (section 5) |
| L1 Landing page, Existing by rig | 16 | Done |
| L2 Save at any stage (`plan-session`, one file per plan) | 16 | Done |
| L3 Plan id from the start | 13 | Already so: given at set-up |
| L4 Continue opens posted records | 16 | Done |
| L5 "Since last report" survives a reload | 16 | Done |
| L6 Newer local copy offered | 16 | Done |
| Sync to Dashboard becomes Post report | 16 | Done |
| Fetch `index.json` paths as given | 16 | Done |
| Server save ON / OFF chip with the reason, never silent | 16 | Done |
| Test plans shown by default while `dryRun` is on | 16 | Done |

## 4. Samples (`03 JSON samples`)

All are `dryRun: true`, made on test data with dummy names marked SAMPLE.

| Folder | What it is |
|---|---|
| `REV16 session save\` | **The session save you asked for:** `West-Vela_DL1_session_WVE-BOP1-20261014.json` (`meta.kind = "plan-session"`, fixed name, the whole `scheduleBuilderState`). |
| `REV15 daily report\` | A Daily Summary Report with every A3/A4 key filled (`…planning-report_BOP1_v2.json`), its `plan-progress` partner, and `preview_as_SACRED_prints_it.html` (your `planReportDocHTML` on that record). |
| `REV14 posts\` | The seven posts in order: plan proposed, designation, plan frozen, progress, planning report, pre-deployment checklist, close-out. |

## 5. Job plans (`04 Job plans`)

| File | What it is |
|---|---|
| `Branch_Map_Additions_302_315_DRAFT_for_Dan_2026-10-15.xlsx` | **For your review:** 31 proposed Branch Map rows for the SFI 302 / 315 job plans in Manpreet's extract of 15 Oct (129 WOs): Offline Ancillary, one group per SFI. **Accept, change or "not this", as with the 36 rows.** |
| `Job_Plan_Gap_Report_2026-10-15.xlsx` | The gap report on the 15 Oct feed: 67 plans, 377 WOs. |

## 6. Screenshots and guides

- **`05 Screenshots`:**
  - **REV 16:** the landing page; the chronology with dates, Now line and numbered milestone stars (Schedule and
    Execute); the plan bar with Save and the server-save chip;
  - **REV 15:** SFI groups and event PMs, links, the daily report and rig people, break-ins and NC, the built-in
    checklist.
- **`06 User guide and QA-QC`:** the Argo Navis field guide (REV 16 sections) and the QA/QC requirements with the punch
  list. Lee can share the live pages too.

## 7. What we need back

1. **Deploy REV 16** and tell Lee, who then makes the first dryRun save and daily post.
2. **Confirm that the BOP ready date is the finish of the BOP set** (SFI 331/332 + the BOP sequence), not the whole plan
   (QA-44).
3. **The 31 SFI 302 / 315 Branch Map rows:** your decisions.
4. **SSORT 163's `sfiGroup` names**, if they differ from the WCE Reference Hub's.
5. **Which copy of the REV 15 planning-report sample Continue refused.** It opens on our side. Also, please resend
   `ARGO-NAVIS-REV16-PLAN-REVIEW-FROM-SACRED.md` and handoff 4 if they hold more than your pm update.
6. **The event PM exports** (`BWM_Event_PMs_Maximo_*.csv`, `CBM_Event_PMs_Maximo_*.csv`): OK to publish them through
   the scanner once Lee puts them in the share's `Job Plans` folder?
7. **Still open from before:**
   - `review.comments` in `plans-open.json`;
   - confirm that Freeze keeps the verified scope version;
   - the sign-off order;
   - the B-16 / B-M1 directives;
   - the eDocs prefix;
   - Manpreet's data request.

## 8. How it was checked

- **The full test suite passes on REV 16.** Its schedule output and report figures are byte-identical to REV 15, so the
  engine is unchanged.
- **The http server test passes:**
  - the landing page reads a staged `plans-state/index.json` and opens the plan from its path;
  - **Save** and **Post** reach a local stand-in intake (202);
  - the runner decodes what arrived.
- **Security:**
  - no intake address is in this folder or the package; both are scanned;
  - the original checklist file, which carries the address, is not included;
  - nothing was posted to the real intake from Lee's PC.
