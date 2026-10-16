# Argo Navis hosting: reply to Dan's handoff of 13 October (DRAFT for Lee, not sent)

**From:** Lee Arnold and the Argo Navis session · **To:** Dan Plant and the SACRED dashboard session ·
**Re:** `ARGO-NAVIS-HOSTING-HANDOFF-FOR-LEE-2026-10-13.md` · **Posting build:** still REV 14

## Update 14 October: reply to `ARGO-NAVIS-HANDOFF-FOR-LEE-2026-10-14.md`

1. **The rules files are on the share.**
   - **Location:** `\\SEADRILL23339\Well Control Data\Job Plans\`, 18 files, copied 14 Oct and verified by hash.
   - **What's there:**
     - `Job Plans and Durations.xlsm`;
     - `Job Plan Branch  Sequence Map.xlsx`;
     - 13 `Job plan detailed *.xlsx` (including `- missing plans 2026-10-13`);
     - `Electrical - WCE`, `MPD` and `WCE Job Plan List.xlsx`.
   - **Please add the folder to the scanner's config.** They publish flat into `data/`.
   - From today these share copies are the ones to edit.
2. **Deploy package:** `Argo-Navis_REV13_2026-10-14.zip`, SHA-256 `31e76a15…638627`. It includes the Rev 9 lines and the
   server read. It replaces the 13 Oct package. REV 14 follows with posting.
3. **FRM-00-0168 Rev 9: all five lines are in, with SSORT 165's keys exactly.**
   - **C-05** ROV panel line-up: a tick plus captioned photos, complete when every photo is captioned.
   - **R · Riser:**
     - R-01 running and pulling checklist, and R-03 seals: N/A only if no riser is run, with a reason and
       rig-management approval;
     - R-02 drops inspection;
     - R-04 maintenance by: a 3rd party must be named.
   - **Your suggestions:**
     - **R-04 is pre-filled from the plan's executed riser tasks:** CBM-type plans → CBM, others → Seadrill; the crew
       confirms and adds any 3rd party.
     - **R-02 is pre-filled only when a plan task names a drops inspection.** None exists in the WO feed today.
     - **C-05 keeps free photographs** for now, as you chose.
4. **Optional sign-offs** (Ops Director, WCE Manager, Head of WCE, Regional Superintendent) never count towards "ready to
   sign" or "pre-deployment complete". They were built that way in REV 13.
5. **Testing %:** REV 14 will post `planningData.testingPct`, an additive number of 0–100: the duration-weighted
   progress of the Testing branch plus the Drift Test, the same figure that drives Argo Navis's own 90 % banner. Please
   read that key once it appears; until then, your own computation stands.
6. **Review state:** yes. REV 14 shows "n of m verified", the state and who is outstanding on the plan header, read
   from `plans-open.json`.
7. **The drafts** (Entry 2, the Maximo data request) are with Lee.

---
## The five asks

**1. Where the rules files live.**

- **Agreed location:** `\\SEADRILL23339\Well Control Data\Job Plans\`, beside the feed. The scanner already reads that
  share, so the files publish the same way. Argo Navis's folder scan already looks one level down, so PCs that pick the
  feed folder find them too.
- **The files to publish into `data/`:**
  - `Job Plans and Durations.xlsm`
  - `Job Plan Branch  Sequence Map.xlsx` (double space; its **Excluded** sheet is now read by Argo Navis, see below)
  - the 13 `Job plan detailed *.xlsx` workbooks, including the new `Job plan detailed - missing plans 2026-10-13.xlsx`
    (52 plans Lee exported today)
  - the three `* Job Plan List.xlsx` exports
- **They are copied flat into `data/`**, as the scanner does with the feed. Argo Navis does not need the subfolder.
- **Pending:** Lee to copy them onto the share. It was unreachable from his PC at the time of writing. Until then, the
  master copies are in Lee's project folder.

**2. The same-origin read: built, in REV 13** (not REV 14), so the rigs can use Argo Navis read-only while posting is
built.

- **When it applies:** when the page is served over http(s) and `data/index.json` answers.
- **Step 1:**
  - takes every file listed in the index through the normal folder scan, with the same file-matching rules and
    precedence;
  - shows **"Connected automatically (SACRED server, data/ of <generatedAt>)"** with the WO.csv date;
  - **Reload Everything** re-fetches.
- **Feed date:** `sourceModified` is used as the feed's date, so the red stale-feed banner reflects the share, not the
  copy.
- **The folder pickers stay** for a PC with the shares. On a PC or `file://` nothing changes.
- **Tested** over http on a staging folder laid out like `/sacred/dl1/`:
  - every input loaded with no clicks (WO.csv 2,631 rows, 872 job plans, Branch Map 851 + 21 excluded, 855 saved job
    plans, 3 lists);
  - Reload re-fetched;
  - the checklist file beside the tool answered.

  Test: `Tests\Run-ServerTest.ps1`.
- **Your index shape is used as sent.** Files are matched by `name`; a name containing a path separator is ignored.

**3. `review` in `plans-open.json`: yes, useful.**

- REV 14 will read `plans-open.json` (same origin) for the plan it posted, and show "2 of 3 verified", the state, and
  who is outstanding on the plan header and the Pre-deployment page.
- It's of no use before REV 14 posts plans, so it isn't built yet.

**4. The two drafts.** Entry 2 and the Maximo data request for Manpreet are with Lee for review. The data request now
also lists `0900-UR0007` and `0900-UR90021`, the two plans still without a saved job plan.

**5. The folder to deploy.**

- **Please deploy the package, not the REV folder.** The REV folders are working folders: REV 13 holds a stray copy of
  the CoC Tracker page and a reference export.
- `Scripts\Build-DeployPackage.ps1 -Rev 13` builds `Deploy\Argo-Navis_REV13_<date>\` and a `.zip` containing:
  - `index.html` (the tool, so `/sacred/dl1/` opens it);
  - the same file under its usual name;
  - `DEPLOY-README.txt` with the SHA-256.
- **Package of 13 Oct:** `Argo-Navis_REV13_2026-10-13.zip`, SHA-256 `3efe9735…8619a`.
- **Not included, on purpose:**
  - **the job plan checklist file:** yours, and it carries the intake URL. Please place
    `Argo-Navis-Job-Plan-Checklists.html` beside `index.html`; Argo Navis opens it by that relative name;
  - **`data/`:** yours, from the scanner.
- **REV 13 does not post anything.** REV 14 adds posting and comes as a new package.

## Two things REV 13 now does that affect SACRED's picture

- **The Branch Map's Excluded sheet is read.**
  - The plans you flagged red ("not done by subsea or electrical department": in-service subsea tests, riser gantry
    crane) used to come into the BWM as Unassigned and ticked to Execute. They now arrive **deferred**, with a red badge.
  - In scope fleet-wide: 12 plans, 87 WOs.
  - REV 14's `deferred[]` will carry them with the reason "Excluded on Branch Map".
- **Durations and branches for missing plans.**
  - Where a plan is missing from Job Plans and Durations, Argo Navis now uses the saved Maximo job plan's own duration,
    flagged "Maximo".
  - For the 36 plans on neither Branch Map sheet, `Branch_Map_Additions_DRAFT_for_Dan_2026-10-13.xlsx` proposes rows in
    your map's own columns for you to review: 30 High, 4 Medium, 2 Low confidence. Your map is not edited.

## Still open on our side

- **The feed:** WO.csv on the share was still the 25 Sep extract on 13 Oct. Good that Manpreet's 24-hour task starts
  13–14 Oct; the stale-feed banner clears by itself once it runs.
- **The checklist file's hosted name:** please confirm it will be `/sacred/dl1/Argo-Navis-Job-Plan-Checklists.html`.
