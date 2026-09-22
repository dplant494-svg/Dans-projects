# Management of Change — Level 3 Advisory AABs issued and tracked through the Seadrill Bulletin Board and the WCE Dashboard

**Draft for Synergi entry** · **Date:** 22 September 2026 · **Draft 1**
**Change owner:** Daniel Plant, Subsea Superintendent, Technical Services · **Initiator:** Eric Rachall, AAB gatekeeper
**Companion documents:** `AAB-LOOP-PLAN.md` (the process), `AAB-LOOP-FLOWCHART.html` (the flow), `AAB-HAZID-DRAFT.md` and `AAB-HAZID-Register.xlsx` (the risk assessment)

Items in **[square brackets]** are filled in from the directive or the Synergi form when Dan sends them. Nothing in brackets is invented.

---

## 1. Title

Issue, distribution, acknowledgement and tracking of Level 3 Advisory Technical Alerts, Advisories and Bulletins (AABs) through the Seadrill Bulletin Board tool and the Well Control Equipment (WCE) Dashboard, in place of the Maximo workflow.

## 2. Type of change

| Field | Entry |
|---|---|
| Permanent or temporary | **Permanent** |
| Category | Process and procedure (document and system) |
| Safety-critical | The AAB process is a barrier: it is how a known equipment defect reaches the rigs that carry the equipment. The change alters the route, not the intent. Treated as safety-critical for review purposes |
| Directive affected | **[AAB directive number and title]**, current revision **[rev]** |
| Other documents affected | WCE Technical Services procedures that reference the Maximo AAB workflow **[list]**; the Compliance Checklist P1 item "Maximo AAB Review" (WCGRRT REV 151+) |
| Systems affected | Maximo (Level 3 AAB workflow retired); SharePoint WellControl / PostedReports; Power Automate (AAB Notifications flow); the WCE Dashboard on `sacred`; the Seadrill Bulletin Board tool |

## 3. Description of the change

### 3.1 Current state

Level 3 Advisory AABs are raised and tracked in Maximo. The rig's awareness of an advisory depends on the rig opening the Maximo record; acknowledgement and closure are Maximo work-order states; there is no fleet view of which rigs have not acknowledged, and an AAB that goes unread is not visible as such to Technical Services. **[Confirm against the directive: the issuing route, the distribution rule, the acknowledgement rule and the response period it states.]**

### 3.2 Proposed state

1. The AAB gatekeeper raises a Level 3 Advisory AAB in the **Seadrill Bulletin Board** (a single HTML tool, Rev 5): number, revision, title, SFI codes, category, issue and due dates, the three advisory sections (what has happened, why it matters, what the rig must do), reference documents, the bulletin PDF and any further attachments, photographs, and the rigs it applies to.
2. **Post AAB** sends one record through the estate's HTTP intake to SharePoint `WellControl/PostedReports`. A local **Save** always works with no network. The posted file is never modified afterwards.
3. The **AAB Notifications** flow emails each applicable rig's contacts (Subsea Supervisor, Technical Section Leader, OIM, Assistant Rig Manager, Rig Manager, from the notification workbook's Rigs sheet) with the bulletin attached and a link to the AAB on the dashboard; Technical Services and the gatekeeper in copy. A rig with no contacts on the sheet produces a **NO RIG CONTACT** email to the office, never silence.
4. The rig **acknowledges** on the dashboard's AAB acknowledgement page (name, role, date) and later **closes the action** (name, date, comment, evidence photographs). Each is a second posted record. The flow tells the gatekeeper and the office.
5. The **dashboard scanner** groups revisions by AAB number, joins acknowledgements to AABs per rig, computes each rig's state (outstanding, acknowledged, closed, overdue) and shows it on the dashboard's AAB tab: **overdue count first, then percent acknowledged**, then the detail per AAB and per rig.
6. **Overdue** AABs are chased daily by email to the rig contacts, gatekeeper and office in copy, until the acknowledgement arrives.
7. A **revision** is a new post. A revision marked *requires re-acknowledgement* returns every applicable rig to outstanding; earlier acknowledgements are kept as history. A **withdrawn** AAB is a revision with status withdrawn **[if Dan decides withdrawal exists]**.

### 3.3 What does not change

- Levels 1 and 2 AABs: unchanged, in Maximo, under the directive as it stands. Dan is reviewing those separately.
- The content of an AAB: the same sections and the same bulletin PDF the directive requires.
- The gatekeeper role: Eric Rachall issues; nobody else issues from this tool.
- Maximo as the maintenance system of record for work orders raised as a result of an AAB.

## 4. Reason for the change

- **Visibility.** One unacknowledged AAB on one rig is invisible in Maximo and visible on the dashboard the day it goes overdue.
- **Reach.** The rig is told by email with the bulletin attached and a link; it does not have to go looking.
- **Two states, not one.** "We have read it" and "we have done it" are recorded separately, with evidence for the second.
- **Proven pattern.** This is the fifth instance of the notification loop already in service for precharge (11 September 2026), rig visit reports, CBM to OEM and SSCE requests: the same intake, the same workbook, the same dashboard.
- **Audit.** Every post is an immutable file in SharePoint with version history; every acknowledgement is its own file signed by name and role.

## 5. Scope and boundaries

| In scope | Out of scope |
|---|---|
| Level 3 Advisory AABs for the thirteen WCE units: West Neptune, Auriga, Saturn, Jupiter, Tellus, Carina, Polaris, Vela, Gemini, Capella, Sonangol Libongos, Sonangol Quenguela, Sevan Louisiana | Levels 1 and 2 |
| Issue, distribution, acknowledgement, action closure, overdue chase, revision, withdrawal, fleet reporting | Work orders arising from an AAB (stay in Maximo) |
| The Bulletin Board tool, the acknowledgement page, the AAB Notifications flow, the dashboard AAB tab | Non-WCE disciplines **[unless the directive is company-wide; confirm]** |

## 6. Risk assessment

HAZID held **[date]**, register `AAB-HAZID-Register.xlsx`, summary in `AAB-HAZID-DRAFT.md`. Fifteen hazards identified; the ones that set the design: an AAB not reaching a rig (H1), a rig omitted from the applicable list (H2), acknowledgement without action (H3), loss of the record now that Maximo is not the register (H8), unauthorised issue (H9), a rig that cannot reach the dashboard server (H7, West Gemini today). No hazard is left without a control; the residual risks are recorded in the register against the **[Seadrill matrix]**.

## 7. Stakeholders and consultation

| Who | Role in the change | Consulted |
|---|---|---|
| Eric Rachall | AAB gatekeeper; owns the Bulletin Board and the record it posts | 15 and 22 September 2026 (brief, Rev 4, Rev 5 handoff) |
| Daniel Plant | Change owner; owns the dashboard side, routing, the acknowledgement page, the KPI | throughout |
| Lee Arnold, Joao Almeida, Ronnie Peeples | Technical Services management; approvers; in copy of every AAB email | **[date]** |
| Subsea Superintendents (Brad Waldron, Paul Calhoun, Jacob James, Eric Rachall, Stephen Sagerian, Steve Rice, Siti Yusree, Brent Sherman) | Rig-facing; verify acknowledgement during rig visits | **[date]** |
| Rig OIMs, Subsea Supervisors, TSLs, ARMs, Rig Managers | Recipients and acknowledgers | via the directive revision and the training pack (week plan item 22) |
| IT | `sacred` server, SharePoint, Power Automate; the West Gemini route | ticket **[number]** |
| **[Document controller / QHSE]** | directive revision and MOC approval | **[date]** |

## 8. Implementation plan

| Step | What | Owner | Evidence of completion |
|---|---|---|---|
| 1 | Bulletin Board Rev 5 built and tested with a saved (not posted) record | Eric | Rev 5 file and its dashboard handoff at schema 2.0 |
| 2 | Scanner, dashboard AAB tab and acknowledgement page built and tested on synthetic records | Dan (dashboard session) | test-set run: one AAB, one acknowledgement, status computed |
| 3 | AAB Notifications flow built in test mode; Settings `TestMode` obeyed | Dan | test-mode email with the would-have recipients listed |
| 4 | End-to-end trial on one rig with a real AAB: post, email, acknowledge, close, chase on a due date set to yesterday | Dan + Eric + one rig | dashboard shows the trial closed; emails on file |
| 5 | Directive revised: issuing route, distribution, acknowledgement, tracking, response period, roles **[section numbers]** | Eric drafts, **[owner]** approves | revised directive issued |
| 6 | Training: half a day inside the three-day class (item 22) for office; a one-page bulletin to the rigs on how to acknowledge | Dan | attendance; bulletin sent |
| 7 | Cut-over date set; from that date Level 3 AABs are issued only from the Bulletin Board; open Maximo Level 3 records listed and either re-issued through the tool or closed in Maximo with a note | Eric | cut-over list |
| 8 | Compliance Checklist P1 wording updated in WCGRRT to point at the dashboard AAB tab | reporting-tools session | REV note |

Temporary measures during transition: both routes may exist between step 4 and step 7; the cut-over list in step 7 is the control, and Maximo is not used for new Level 3 AABs after the date.

## 9. Verification after implementation

- 30 days after cut-over: every Level 3 AAB issued since the date is on the dashboard; every applicable rig has either acknowledged or appears in the overdue count; no NO RIG CONTACT email has gone unanswered.
- Spot check by a Subsea Superintendent on the next rig visit: the rig can open the acknowledgement page, sees its open AABs, and the printed cover matches the dashboard.
- The HAZID actions closed or dated.

## 10. Close-out criteria

Directive revised and issued; cut-over complete; verification in §9 passed; HAZID actions closed; this MOC signed off by **[approvers]**.

## 11. Approvals

| Role | Name | Date |
|---|---|---|
| Change owner | Daniel Plant | |
| Initiator | Eric Rachall | |
| Technical Services management | Lee Arnold / Joao Almeida / Ronnie Peeples | |
| **[QHSE / document control]** | | |

---

## Appendix A — Directive sections that no longer describe what happens (to be completed against the directive text)

Eric's brief asks for an advisory on the directive. Until the directive is in hand this is the checklist of what to look for; each row becomes a specific section reference.

| Directive topic | What it probably says | What is true after the change |
|---|---|---|
| How a Level 3 AAB is raised | in Maximo, by **[role]** | in the Seadrill Bulletin Board, by the gatekeeper |
| Distribution | Maximo notification / **[method]** | email per applicable rig from the notification workbook, bulletin attached, dashboard link; office in copy |
| Acknowledgement | **[Maximo state / signature]** | acknowledgement page on the dashboard, by name and role; recorded as a posted file |
| Action closure | **[Maximo work order closure]** | close-action record with comment and evidence photographs; work orders still in Maximo |
| Response period | **[days]** | due date set per AAB by the gatekeeper, default 14 days **[if Dan confirms]** |
| Tracking and reporting | **[Maximo report]** | dashboard AAB tab: overdue first, then % acknowledged; daily chase |
| Revision and withdrawal | **[rule]** | revision is a new post; re-acknowledgement resets rigs; withdrawal is a revision with status withdrawn |
| Record retention | Maximo | SharePoint PostedReports with version history; posted files immutable |
