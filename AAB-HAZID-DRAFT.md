# HAZID — Level 3 Advisory AABs through the Seadrill Bulletin Board and the WCE Dashboard

**Draft 1 for the workshop** · **Date:** 22 September 2026, on the Seadrill template 23 September · **The document:** `AAB-HAZID.docx`, built on Lee Arnold's `Seadrill_HAZID_Template.docx` (DIR-37-0147 format: cover, revision history, introduction, requirements with the risk matrix, process basis, the 13-column register, summary, ALARP, conclusion, references, signature block). **Working register:** `AAB-HAZID-Register.xlsx`
**MOC:** `AAB-MOC-DRAFT.md` · **Process:** `AAB-LOOP-PLAN.md`, `AAB-LOOP-FLOWCHART.html`

Rankings use the Seadrill scale from DIR-37-0147 as the template prints it: consequence 1 (Fatality / Major) to 5 (Negligible), frequency A (Frequent) to E (Very Rare), colour from the matrix table in the template (see `hazid/README.md`). They are the drafter's and are there to be argued with in the room, not accepted. Still in **[square brackets]** in the docx: the AAB directive number and title, the FRM document number, the Synergi MOC case number.

## 1. Scope of the study

The change of process by which Level 3 Advisory AABs are issued, distributed to the rigs, acknowledged, actioned, chased and reported, moving from the Maximo workflow to the Seadrill Bulletin Board tool, the estate's posting intake, the AAB Notifications flow and the WCE Dashboard. Thirteen units. Levels 1 and 2 are outside the study.

The study asks one question of every step: **how could a rig fail to be told, fail to understand, fail to act, or be shown as done when it is not, and would we see it?**

## 2. Method

Guideword walk-through of the ten steps on the flowchart (issue, post, notify, record, acknowledge, post acknowledgement, notify the gatekeeper, compute status, report, chase), with the transition from Maximo and the organisation around the process as two further nodes. For each hazard: causes, consequences, the controls already in the design, a risk ranking, additional controls and an action party, residual ranking.

**[Facilitator, attendees, date, MOC reference, risk matrix reference: from the template.]** Suggested attendees: Dan Plant (change owner), Eric Rachall (gatekeeper), one Subsea Superintendent, one rig OIM or Subsea Supervisor by call, Lee Arnold or Joao Almeida, IT for the server and flow items, QHSE for the matrix.

## 3. The hazards, in one page

| Ref | Step | Hazard | Key control in the design | Additional control proposed |
|---|---|---|---|---|
| H1 | Notify | AAB does not reach a rig | NO RIG CONTACT branch, office in copy, dashboard fleet view | daily overdue chase; monthly Rigs sheet review; sent-log |
| H2 | Issue | Rig omitted from or wrongly on the applicable list | preview with rig chips, rig list as data, revision | check against the SFI equipment register; second reader for fleet-wide AABs |
| H3 | Acknowledge | Acknowledged but not actioned | two states; closure needs comment and evidence photographs; visit verification | own colour for "acknowledged, action open"; gatekeeper reviews evidence |
| H4 | Revise | Rig works to a superseded revision | revision on header, subject and dashboard; re-acknowledgement reset | cover page states superseded revisions are withdrawn; open list shows current only |
| H5 | Issue | Wrong or missing attachment | preview, primary flag, refusal to post without a PDF unless ticked | gatekeeper opens the attachment from the preview |
| H6 | Post | Post fails or is truncated | local save; HTTP status and server text; size guard; Errors list | confirm on the dashboard within 20 minutes |
| H7 | Acknowledge | Rig cannot reach the dashboard server (West Gemini today) | email carries the bulletin; acknowledgement by reply, entered by Technical Services | IT ticket on the route |
| H8 | Record | Loss of the record now that Maximo is not the register | immutable posts, SharePoint versions, scanner never archives AAB files, server copies | retention rule with IT; quarterly export |
| H9 | Security | Unauthorised or accidental issue | endpoint not in the file; originator on the record; office in copy; test mode | endpoint held by two people; withdrawal revision |
| H10 | Acknowledge | Acknowledgement by the wrong person | name and role required; expected role shown; email to gatekeeper | fixed role list; password gate if misused |
| H11 | Transition | AABs in both Maximo and the tool | cut-over date; open Maximo list re-issued or closed | P1 checklist item repointed; Maximo Level 3 workflow retired |
| H12 | Notify | Notification fatigue | one email per rig to its own contacts; office in copy only | quarterly recipient review; chase once a day |
| H13 | Organisation | Dependence on one gatekeeper, one dashboard owner | two holders of tool and endpoint; documents in the repository; training | named deputy in the directive |
| H14 | Systems | Scanner or flow stops | generated-at stamp; flow failure notification; issue email independent of the scanner | stale-data banner after 2 hours; monthly run-history check |
| H15 | Content | Advisory content wrong or unclear | mandatory sections; preview; references; revision route | second reader for a Level 3 needing physical intervention |

The register carries the full wording of causes, consequences, controls, rankings and action parties.

## 4. What the study found that changes the design

Three items came out of writing the register and go back into the build, so the workshop starts from a design that already answers them:

1. **The archive script must never move an AAB or an acknowledgement file** (H8). The scanner's `Archive-ProblemFiles.ps1` moves unusable posts on Dan's say-so; AAB files are to be excluded by rule, the way oversized reports are.
2. **"Acknowledged, action open" needs its own state on the dashboard** (H3), distinct from acknowledged-and-closed, or the KPI hides the gap the two-state design exists to show.
3. **A stale-data banner on the dashboard** (H14) when the scanner has not run for two hours, so an outage is visible to the reader, not only to Dan.

All three are on the dashboard side and are in the plan's build list.

## 5. Residual risk statement (draft)

With the controls in the design and the additional controls above, no hazard in the register carries a residual ranking above **[matrix threshold]**; the two that sit highest (H1 a rig not told, H3 acknowledged but not actioned) are the two the daily chase and the two-state design were built for, and both are visible on the dashboard the day they occur. The change reduces risk against the current Maximo route for every hazard where a comparison can be made, because the current route has no fleet view, no chase and no evidence of action.

**[Sign-off block from the template.]**
