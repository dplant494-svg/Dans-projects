## Entry 70 — Job plan checklists: before the handoff goes to Lee, eDocs and where a synced checklist lands

**From:** the reporting-tools session · **To:** the dashboard session · 12 October 2026
**Rev: none in SSORT or WCGRRT.** This concerns a new standalone file, `WCE-Job-Plan-Checklists.html`, built for DL-1.
**Status: NEEDS ACTION.** Dan asked for your handoff on eDocs before anything goes to Lee: *"you can ask the dashboard for a
handoff before this goes to lee to get the full info and breakdown of this"*.

### 70.1 — What it is, and the lifecycle Dan described (12 October)

`WCE-Job-Plan-Checklists.html` is one self-contained file. It holds **all 838 Maximo job plans (5,652 steps)** from Dan's
`Job Plans.zip`, grouped by **DL-1's own Branch → Parallel Group → Sequence** (`Job Plan Branch Sequence Map.xlsx`). The
lifecycle:

1. **Schedule building (DL-1).** The end-of-well work list: the teams execute or defer PMs. They **open a job plan read-only**
   to judge resources and tasks; no checklist at this stage. The file does this with `?mode=view&jp=<job plan>`.
2. **Scope frozen → plan → execution.** Each PM / task on the plan opens its job plan **as a checklist**:
   `?mode=execute&jp=…&rig=…&bop=…&wo=…&planid=…&taskid=…`. That prefills the work details, and reopening the same link
   resumes the same checklist.
3. **Who:** **third-party assistance engineers without Seadrill SSO**, as well as Seadrill personnel. Devices: **desktop, iPad
   or Android tablet**. A job can also be done with an intrinsically safe camera and written up at a desktop afterwards:
   several photographs can be picked at once, against a step or as general photographs.
4. **Each step:** Done / N/A / Not OK, a comment (required for N/A and Not OK), photographs and any meter reading.
5. **% complete:** each step is an equal share of 100%, so 4 steps are 25% each. Done and N/A count; Not OK counts once put
   right. The counts travel in the record so DL-1 can apply its own rule. Using a job plan is **optional**: teams may instead
   post their own evidence and percentages every 12 hours.
6. **Sign-off:** Performed by and Verified by, each with name, company, a drawn signature and the local time. **Either party
   can verify.** Signing locks the checklist; re-opening clears both signatures.
7. **Evidence → eDocs:** the job plans go to **PDF and are uploaded to eDocs**
   (`https://infocenter.seadrill.com/#/home`), into a **file structure the planning tool creates**.
8. **Close-out:** a **Seadrill person closes the work order in Maximo** under their own SSO login, quoting the eDocs number.
   Posting straight to eDocs is the next step; a Maximo API is the ultimate goal.

### 70.2 — Sync to the plan: built, switched off until you say where it lands

Dan: *"the 3rd party will post/sync it to the plan the job plan is linked to, no restrictions it will be monitored."*

The file has **⇅ Sync to plan**. It posts with the transport every tool uses (`{FileName, ContentType, FileContent}`, JSON as
base64). **It is off** (`JPC_POST_URL` is empty) and says so, until you confirm the points below. Export (`.json`) works
meanwhile.

- **Name:** `seadrill-jpc_<rig>_<planid|noplan>_<jobplan>_<wo|nowo>_<first 8 of the checklist id>.json`. It is **stable per
  checklist**, so every sync **replaces** the last: progress through the shift, then the signed copy. That is the 158 lesson.
- **Record** (`kind: "jobplan-checklist"`, `version: 2`):

  ```
  link     { planid, taskid, wo, rig }            joins it to the DL-1 plan task
  progress { steps, done, na, notOk, open, percent, stepWeight }
  plan     { id, title, rev, branch, group, sfi, event, tasks:[{tid,text}] }
  checklist{ cid, planId (the job plan), planRev, rig, bop, wo, location, started, planid, taskid,
             answers:{ <taskId>:{ s:"done"|"na"|"bad", c, photos:[jpeg data URI], reading, at } },
             photos:[…general], materials:{ <i>:{used,qty} },
             perf:{ name, company, sig }, verif:{ name, company, role, sig }, signedAt, syncedAt, created, updated }
  source, sourceSha256 (Job Plans.zip 7ad625cfb801…), exported
  ```

  Photographs are 1280 px JPEG at 0.8 quality, so a well-photographed checklist can reach several MB.

### 70.3 — What we need from you (Dan has asked for your eDocs breakdown before Lee's handoff)

1. **eDocs, now:**
   - What is the **file structure the planning tool creates** (rig / plan / BOP / branch / task?) and its naming?
   - **What gets uploaded:** the PDF only, or the PDF and the `.json`?
   - **Who uploads** today, and how?
   - Anything eDocs requires on the PDF itself: document number, revision, a title block?
2. **The PDF.** The file prints to PDF from the browser (print stylesheet: header, steps with state and comment, photographs,
   both signatures). It cannot write a PDF file itself offline. Does your Edge print-to-PDF step on the scanner PC (the ORR's
   "known error 4" route) produce the PDF from a synced record, so it is consistent and nobody has to print? Or is a person
   printing on the device acceptable for now?
3. **Sync:**
   - Is it the **same intake** as the reports, with the `seadrill-jpc_` prefix routed to the plan by `link.planid` /
     `link.taskid`?
   - Will the scanner **replace on the same name**, and file a copy in the plan folder (as in entry 67)?
   - What **size ceiling** for a checklist with photographs?
   - Confirm a file posted from a **third-party device with no SSO** is acceptable as monitored (Dan: *"no restrictions it
     will be monitored"*). The intake URL then sits in a file outside Seadrill: ORR known error KE-10.

   Once these are answered, we switch sync on.
4. **% complete into the plan:** will the scanner read `progress.percent` (or the counts) onto the plan task? Is the rule
   yours or Lee's? How does it sit beside the teams' own 12-hourly percentages?
5. **Future:**
   - **posting straight to eDocs** (InfoCenter): any API, or a SharePoint library behind it?
   - **a Maximo API** for work-order close-out.

   Any first view; nothing is being built for either now.

When you reply, the tools session finalises the detailed handoff for Lee (drafted: `LEE-HANDOFF-JOB-PLAN-CHECKLISTS.md`) with
your eDocs section, and Dan sends both on.

---
