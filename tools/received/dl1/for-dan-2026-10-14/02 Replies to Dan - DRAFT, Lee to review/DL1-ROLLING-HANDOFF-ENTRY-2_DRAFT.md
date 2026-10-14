## Entry 2 (12 October 2026, DRAFT for Lee): Argo Navis REV 13 built locally; posting moves to REV 14; what REV 14 needs from SACRED

**From:** Lee Arnold and the Argo Navis (DL-1) session · **To:** Dan Plant and the dashboard session ·
**Re:** the Argo Navis handoff pack of 12 October (resolved pre-deployment matrix, JPC REV 4, SSORT 163 Link to plan,
branding) · **Status:** NEEDS ACTION: the questions in 2.6 · **Nothing posts yet.**

**2.1 Numbering, once more.**

- **REV 13 is built and local only:** Argo Navis branding, the plan structure, the pre-deployment checklist and the job
  plan checklist pop-up.
- **The posting build is now REV 14.**
- SACRED's replies that say "REV 11", and entry 1's "REV 13", both mean **REV 14**.
- `planningData` is unchanged and byte-identical to REV 9 and REV 12 on the regression run. The engine is unchanged when
  the new SSS-007 task is held back. With it, every plan gains one 4 h Offline Ancillary task, and the finish date does
  not move.

**2.2 Name.** The tool is **Argo Navis** (Schedule Builder), using the pack's draft concept assets.

- Following the pack's rule, the Seadrill logo is **not** shown beside the mark; "Seadrill" is written as text.
- **The tool code in data and file names stays `DL1`** (`_DL1_<kind>_`), so nothing keyed on it changes.

**2.3 The plan, as REV 14 will post it** (built in REV 13, shown in the tool today):

- **`planId`** = `<rigCode>-<BOPn>-<commence yyyymmdd>`, e.g. `WVE-BOP1-20261005`, exactly as entry 63 assumes.
- **Sections:**
  - `predeployment`: one task, `pdc`, `type:"checklist"`, PRE-DEPLOYMENT CHECKLIST.
  - `surface-testing`: nine tasks, `type:"test"`.
    - Seven carry SSORT's exact `testType`: `test:function` BOP Function Test, `test:soak` Soak Test, `test:drawdown`
      Surface Drawdown Test, `test:acoustic` Acoustic Function Testing, `test:rov` ROV Function Testing, `test:eds` EDS
      Testing, `test:ehbs` EHBS Testing.
    - `test:pressure` and `test:drift` are attachments in the plan.
    - ACOUSTIC is **pre-filled N/A** on West Vela, West Neptune and Sevan Louisiana. The owner confirms it, with a reason
      and a rig-management approver.
  - `maintenance`: every executed task, with `taskId` `wo:<WONUM>` and these types:
    - `maintenance`;
    - `moc` (with `ref`, the MOC number; B-04);
    - `aab` (with `ref`; B-17);
    - `template` (the SSS-007 / DIR-37-0165 handling-equipment task, now in every plan; B-19);
    - `manual`.
  - `daily`: empty until the daily section exists (SSORT stage 3).
- **Scope-challenge line in every plan (B-M1):** "Was any milling conducted in the previous well or during the current
  campaign?"
  - It must be answered before the schedule is built.
  - A Yes prompts an annular inspection task and is recorded for the AAR.
- **Testing breakout %:** duration-weighted over the Testing branch plus the Drift Test.
  - REV 14 sends it on every `plan-progress`, so SACRED can detect 90 % and send the Teams notice (item 53, event 6).
  - REV 13 already shows the 90 % banner locally.

**2.4 The pre-deployment checklist (Argo Navis primary).** It is built from the resolved matrix's "Decision" and "Who
builds" columns.

- **Keys:** SSORT's exact keys, one stack per checklist (`pdcbop_desig:"Single"`, stack in `s1`).
  - Verified key for key for 5, 6 and 7 cavities against `README-PDC-AND-TESTS-SSORT-161.md` §2–§7. As a check on our
    spec, a dual 7-cavity stack comes to your 242.
  - The two optional new sign-offs (Head of Well Control Equipment, Regional Superintendent) travel outside the SSORT key
    set, under `argo.optionalSignoffs`.
- **Photographs:** `[{src, caption, slot}]`. **Yes to the `slot` field** (entry 67.2): please add it in SSORT too.
  - A slot can instead be evidenced by a **linked CBM post** (file name), listed under `argo.cbmLinks`.
- **States:** Not started, In progress, **Pre-filled (confirm)**, Complete, Evidence linked, N/A.
  - Pre-filled never counts.
  - An N/A needs a reason and a rig-management approver.
- **"Ready to sign":**
  - every non-optional line closed;
  - plus SSORT's post gate as a floor;
  - E-04b (after deployment) is excluded.
- **"Pre-deployment complete" (Q6 yes)** = ready, plus every required sign-off. Optional roles never block.
- **Sign-off:**
  - typed name and date, per Dan, for now;
  - sent in order, with the order held in one table, **TSL → SS Supervisor → Rig Manager** as a placeholder;
  - the first signature fixes a **SHA-256 of the checklist**;
  - any change after that cuts a new revision, the signatures lapse, and the old revision is kept (entry 68.2.3–4).
- **Export:** `{kind:"pre-deployment-checklist", meta:{reporttype:"Pre-Deployment Checklist", planid}, complete, ready,
  pdcData, argo:{states, signoffs, history, tests, cbmLinks…}}`.
- **BOP designation (Q2: format and location):** `designation_<planId>.json` =
  `{planId, rig, bop, mfr, cav, status, rows:[{pos, spec}], photoSlots:[{section, slot}]}`.
  - REV 14 posts it with the first `plan`.
  - Please file it in **01 Plan and Scope**, where SSORT and WCGRRT can read it.

**2.5 Job plans.**

- Argo Navis's own viewer stays for **schedule building**. It carries the NOV AX → eDOCS links, revision flags and parts,
  which the JPC file does not have.
- **JPC REV 4 pops up for execution** (`embed=1&mode=execute&jp&rig&bop&wo&planid&taskid`, `taskid` = `wo:<WONUM>`).
- **The JPC file is not copied into our project**, because it embeds the intake URL. Argo Navis expects it **beside
  itself on the server**, and the location can be changed per machine.
- **% rule (Lee):**
  - when a task has a checklist, the checklist % drives the task %; otherwise the team's typed / 12-hourly % does;
  - Not OK steps don't count, and they prompt for a CM / Synergi reference;
  - Argo Navis stays the only writer of task and plan %, as entry 70.3.4 proposes.
- A signed checklist shows as Evidence linked on the task.

**2.6 What REV 14 needs from SACRED** (please answer here):

1. **Photographs in posts.** The DL-1 reply noted that bodies of several hundred KB fail, while JPC syncs up to 25 MB.
   What limit applies to `pdcData`, which is up to 42 slot photos plus 14 electrical? Should photos go as separate
   `plan-evidence` posts (one per slot) with `pdcData` carrying references?
2. **Read-back.** Argo Navis is a local file. Which file on the share should REV 14 read for:
   - the plan-link evidence state per task (SSORT records linked with `seadrill-planlink_`);
   - checklist states (`checklistPct` / `checklistSigned`);
   - the H-07 call record and the attendees' acknowledgements;
   - SACRED's pre-fills (B-06 precharge, B-10 CBM, B-15 and B-17 AAB register, B-20 visit reports)?

   One `plans-status/<planId>.json` would do.
3. **JPC hosting.** Will the JPC file sit at `/SSORT/` or `/sacred/` on the IIS server, and under what name? Argo Navis
   then defaults to that.
4. **The sign-off order** (Dan, Q5); the directives for B-16 and B-M1 (Dan); the eDocs prefix (Dan, with document
   control).
5. **`edocsRef`** on `plan-closeout`: agreed, REV 14 will carry it.

**2.7 For Manpreet.** The Maximo data Argo Navis lacks is listed in `Argo-Navis_Maximo-Data-Request_DRAFT.md` (Dan's G-01
ask): one request, in priority order. CM work orders, NC records and AAB states would turn B-03, G-01, B-15 and B-17 into
computed lines.
