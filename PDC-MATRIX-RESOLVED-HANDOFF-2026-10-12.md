# Pre-deployment matrix: resolved after Dan and Lee's review (12 October 2026)

**From:** the dashboard session · **To:** the reporting-tools session, for the combined handoff to Lee (DL-1) · **With:**
`PDC-MATRIX-RESOLVED-2026-10-12.xlsx` (the reviewed workbook with two new columns on Matrix, "Decision (Dan and Lee,
12 Oct)" and "Who builds", and "Resolved (12 Oct)" on Questions).

**Dan's rule for this review:** any line without a comment is approved as proposed. That approves 40 of the 53 lines
as they stood in the dashboard-reviewed copy (states, evidence, "complete when", N/A, owner, source). The thirteen
commented lines and the seven questions are resolved below. Three decisions change the shape of the checklist; the
rest add a source, a checkbox or a field.

## 1. Lines that change shape

| Line | Was | Now |
|---|---|---|
| **B-03** CMs and deficiencies repaired | a Yes/No question | computed: every PM and CM is in the plan; a work order not completed at freeze needs an **approved non-conformity**. The line reads "Work orders not completed: n", each with its NC reference. Complete when every open item has one. Feeds G-01. |
| **B-04** modifications during the period | a Yes/No question | computed: a modification has a work order and an **MOC**, which is a task in the plan. The line lists the MOC tasks. Zero is a valid answer. |
| **H-07** pre-deployment call | a line recorded at the call | the call is a **review, not a Q and A**. The mandatory stump test (DL-1 sets it for every rig) is its own section with a breakout percentage, a milestone for BOP testing. **At 90% of testing an automated Teams chat** goes to every party: "90% completion notice for <rig> maintenance plan; the pre-deployment call is to be arranged; relevant teams to start reviewing the pre-deployment information and voice concerns in this channel." The call then records date, attendees (the people who reviewed, each with an acknowledgement post back, as the AAB tool does) and outcome. |

## 2. Lines that gain a source, a checkbox or a field

| Line | Decision | Builds |
|---|---|---|
| A-01 header | from the plan including the **plan id** DL-1 generates | DL-1 |
| B-06 precharge | evidence is the issued **Precharge Pro** sheet; Precharge Pro gets an optional plan id line; a sheet carrying it files into 06 Precharge and the pre-deployment section on its own; pre-answered Yes with date and link; crew confirms the charging valves | Precharge Pro (Dan), SACRED, DL-1 shows |
| B-07 BOP hop | Yes/No checkbox; a precharge carried from the previous well is readable from Precharge Pro | DL-1, Precharge Pro flag |
| B-09 cycle count reset | Yes/No checkbox now; **PLATO** later (live BOP control-system data, every rig but Sevan Louisiana) through a PLATO to SACRED API | DL-1 now; SACRED + PLATO (plan item 63) |
| B-10 elastomers | pre-answer from CBM posts where the rig has CBM, else from the ram configuration, install dates and the C-03 photographs; crew confirms | SACRED, DL-1 shows |
| B-13 Electrical and Marine aware | checkbox plus **directive number** field | DL-1 |
| B-14 Mux cables | two checks: BOP controls training guide acknowledged; toolbox talk confirmed | DL-1 |
| B-15 TB-WCE-73 | checkbox; AAB C10078078 acknowledgement state shown by SACRED (register) and by DL-1 (Maximo) | both |
| B-16 urgent transfers | pre-answer from SSCE requests; crew confirms; **also an AAR item** (IRT, transfers, hotshots); process to be added to the directive | SACRED, DL-1 AAR, Dan |
| B-17 overdue AABs | populated, not asked, from the AAB register and DL-1's Maximo pull; form keeps Yes/No; an AAB to be conducted is a task in the plan | both |
| B-18 riser torque tools | checkbox plus reference: compliance with AAB C10247907 | DL-1 |
| B-19 handling equipment | SSS-007 / DIR-37-0165 is an **offline task in every plan**; at 100% the line auto-populates | DL-1 template |
| B-20 TSC onboard | pre-answer from rig visit reports: count and names | SACRED |
| B-M1 milling | if Yes: AAR follow-up and scope challenge for the next BWM; **new scope-challenge line in every plan**, "was any milling conducted in the previous well or during the current campaign?" (triggers an annular inspection); Dan provides the directive | DL-1, SACRED AAR, Dan |
| C-01 designation | try auto-population; manual fallback | DL-1 / SACRED |
| C-03 cavity table | cycle counts manual now, PLATO later (dry fire, wet fire, acoustic by rule); install date from SSORT; Dan reviews how it populates | SACRED, PLATO later |
| C-04 ram packers | visual of the rubbers in the blocks with install date, PN, SN; manual where no data | SACRED where data exists |
| D-01 to D-03 photographs | as C-04: no CBM on some rigs, so the photographs are taken for the checklist against the slot label | SACRED slot match; crew |
| E-04 EWS pages | manual, dated as close to completion as possible before the call (daily checks suspended during BWM); **retaken after deployment** during testing of the first double riser joints: new line **E-04b** | DL-1 |
| G-01 non-compliance | SACRED pre-lists deferrals; DL-1 adds Synergi cases and Maximo NCs; manual additions | both |
| H-05, H-06 sign-offs | Operations Director optional; WCE Manager optional; add **Lee Arnold, Head of** (optional) and **Regional Superintendent** (optional) | DL-1 |
| States, N/A | an N/A is reviewed and signed off by rig management | DL-1, SACRED shows the approver |

## 3. The seven questions

1. **One per stack: yes.** Two projects with their own identifiers on a dual rig; PMs and job plans follow the SFI
   structure; pre-deployment runs separately; one BOP deploys at a time.
2. **Slot label on every photograph: yes.** The designation carries the required set and the configuration, embedded
   in all tools; SSORT and WCGRRT pull it from the project folder so the pre-run condition is always visible.
3. **N/A** as proposed, plus the rig-management sign-off above.
4. **The call is recorded** with the attendees being those who reviewed, each with an acknowledgement post back.
5. **Sign-offs in order.** Dan and Lee give the order later; the flow is built to send in sequence.
6. **Dan asked for Q6 to be explained.** Today SSORT lets a pre-deployment checklist post with only its small gate
   (designation, cavities, packers Yes, the photographs); the 21 questions and the five sign-offs can be empty. The
   question is whether the plan's "pre-deployment complete" requires all 21 lines and all sign-offs. Proposed: **yes
   for the plan** (the matrix states already enforce it: nothing signs until every line is closed), while the SSORT
   emergency copy keeps its light gate. Dan to confirm with one word.
7. **Planning tool pre-deployment is primary.** The SSORT sheet stays for emergencies only (a quick BOP downtime
   pull); a downtime recovery plan and a short BWM are a future development.

## 4. Asks that travel with this handoff

- **To DL-1's session (Lee):** with G-01, identify the Maximo data DL-1 does not have today, so a handoff to Manpreet
  can ask for it in one go (Dan's ask).
- **To the tools session:** the slot label on photographs (Q2) in SSORT and WCGRRT; the project-folder read of the
  designation set; Precharge Pro's plan id line is Dan's own tool.
- **New on the SACRED plan:** item 63 PLATO integration (B-09 and C-03), the 90% testing notice as event 6 of item 53,
  the AAR items (B-16, B-M1) and E-04b with the DL-1 close-out work.
- **Dan:** the directives for B-16 and B-M1; the sign-off order (Q5); the one-word answer to Q6.

Over to the tools session to fold this into `LEE-HANDOFF-JOB-PLAN-CHECKLISTS.md` (or alongside it); Dan sends the
combined pack to Lee.
