# Management of Change — Priority 3 Advisory AABs distributed and acknowledged through the Seadrill Bulletin Board and the WCE Dashboard

**Draft 2 for the Synergi case** · **Date:** 23 September 2026 (draft 1 was 22 September, before the directives were in hand)
**Change originator / MOC owner:** Daniel Plant, Subsea Superintendent, Technical Services · **Initiator:** Eric Rachall, AAB gatekeeper
**Governed by:** DIR-37-0015 Management of Change v1.08 (Peter Smith; approved Torsten Sauer-Petersen) · **Directive changed:** DIR-37-0161 Management of Technical Alerts, Advisories and Bulletins v6.07 (Arnaud Gabaut; approved Torsten Sauer-Petersen)
**Attachments:** `AAB-HAZID.docx` (Seadrill HAZID, DIR-37-0147), `AAB-LOOP-PLAN.md`, `AAB-LOOP-FLOWCHART.html`, `AAB-REV5-HANDOFF-FOR-ERIC.md`

Laid out in the order the Synergi case screen asks for it (Where and What · Check list · General classifications · Action · Connected cases · Attachments · Comments · Signatures), from the MOC-PROJ-CAR26 case Dan sent as the example. Items in **[square brackets]** are the decisions Dan still owns (§0). Nothing in brackets is invented.

---

## 0. What the two directives settle, and what they leave to Dan

Read against DIR-37-0161 v6.07 and DIR-37-0015 v1.08 on 23 September:

| Point | What the directive says | Consequence for this MOC |
|---|---|---|
| **The word is Priority, not Level** | DIR-37-0161 §2.2.3: Priority 1 Safety Alert (notification within 96 hours), Priority 2 Bulletin / Product Obsolescence (action required), **Priority 3 Notification / Advisory: information only, "Not required by Corporate, for information only"** | The tool, the record and every document say **Priority 3 Advisory**. The record keeps `level: 3` for compatibility and adds `priority: 3` |
| **Who acknowledges a Priority 3** | §2.2.4: "For Priority 3 AABs, **both TSLs** must review the AAB and acknowledge having done so by ticking the box by their respective names and adding a comment." Rig Manager, ARM, both OIMs and both TSLs are for Priority 1 and 2 only | Decision 2 in the plan is settled by the directive: the **Technical Section Leader of each crew** acknowledges. The acknowledgement page records the TSL's name and crew, and a rig is fully acknowledged when both crews' TSLs have done so. The 15 September decision "one acknowledgement per rig by a named role" becomes two, one per crew, unless Dan takes a deviation |
| **Follow-up on a Priority 3** | §2.2.4: "Typically there is no follow up required on these AABs since they are informational only. However, the TSL has the option to add additional reviewers" | The **action-closed** state is optional on a Priority 3 and is used only when the gatekeeper marks "action requested"; it never blocks acknowledgement |
| **Every AAB is filed in eDocs** and entered in Maximo for evaluation, "regardless of relevance or applicability" | §2.2.2 | The Bulletin Board record carries the **eDocs reference** so the filing trail is unbroken. **[Dan: does a WCE-originated Priority 3 still get a Maximo parent case for the corporate evaluation trail, marked "distributed via the Seadrill Bulletin Board", or does the dashboard record replace it? The directive's wording ("all AABs will be entered into Maximo") argues for keeping the parent case; the child cases and the acknowledgement move to the dashboard]** |
| **What kind of change this is** | DIR-37-0015 §2: a Synergi MOC is required for major **people, process or system** changes; **System Changes** include "changes / introduction of new Seadrill systems … e.g. MAXIMO to develop and track Maintenance Work Orders"; **Procedural Changes** (implementation of directives, procedures) are covered by DIR-00-0001. §3 Technical / Physical changes do not apply: no equipment, drawing or system program changes | This is a **Seadrill System Change** (introduction of a new system for the distribution and acknowledgement of Priority 3 AABs) with a **procedural change** (the revision of DIR-37-0161) handled under DIR-00-0001. The Synergi case type is the one for Seadrill changes, **[Dan: the exact type name in the Synergi "new case" list; the CAR26 example is "Management of Change - Physical Changes", which is not ours]** |
| **Deviation until the directive is revised** | DIR-37-0015 §3 note: "Changes to, or deviations from, Seadrill directives … shall be handled according to DIR-00-0011 Handling of non-conformities" | Running Priority 3 AABs outside Maximo before DIR-37-0161 is revised is a deviation. **[Dan: revise the directive first (owner Arnaud Gabaut, approver VP Technical Services & ISIT) and cut over after, or run a pilot on one rig under a documented DIR-00-0011 deviation while the revision goes through]** |
| **HAZID and actions** | DIR-37-0015 §3.4: the HAZID is Seadrill's standard HAZID; every action listed in it gets a Synergi action titled **"HAZID Action # (number)"** with an action responsible, verified complete by the MOC owner before close | `AAB-HAZID.docx` is the HAZID; its fifteen entries become fifteen Synergi actions (§4 below) |
| **Supporting documents** | §3.3: attached to the case or referenced by eDocs number | §6 below |
| **Scope of the change** | DIR-37-0161 covers internal and external AABs for all equipment, single point of entry `aab.operations.excellence@seadrill.com` | **[Dan: does the Bulletin Board carry Priority 3 advisories originated by WCE Technical Services only (Eric as gatekeeper), or every Priority 3 AAB including OEM notifications received through the common mailbox? Draft 2 assumes WCE-originated only; the wider scope needs the Document Controller in the loop and a different owner]** |

## 1. Where and What

| Field | Entry |
|---|---|
| Title | Priority 3 Advisory AABs distributed and acknowledged through the Seadrill Bulletin Board and the WCE Dashboard |
| Type | Management of Change — Seadrill change (System change) **[exact Synergi type]** |
| Description | Priority 3 (Notification / Advisory, information only) AABs originated by WCE Technical Services are issued from the Seadrill Bulletin Board tool, distributed by the AAB Notifications flow to each applicable rig's contacts with the bulletin attached, acknowledged by both crews' Technical Section Leaders on the dashboard's acknowledgement page, and tracked on the WCE Dashboard AAB tab (overdue count first, then percent acknowledged), in place of the Maximo child AAB cases and their tick-box acknowledgement for this priority. Priority 1 and 2 AABs, external AABs received through the common mailbox, eDocs filing, Maximo work orders and the corporate evaluation trail are unchanged. The change alters the route of a Priority 3 advisory, not its content, its priority or the gatekeeper |
| Date | 23 September 2026 |
| Start date | on approval of this case |
| End date | cut-over date plus 30 days for the verification in §4, **[date]** |
| Areas | Technical Services — Well Control Equipment |
| Assigned to | Technical Services — Subsea; Daniel Plant |
| Rig | all thirteen WCE units: West Neptune, West Auriga, West Saturn, West Jupiter, West Tellus, West Carina, West Polaris, West Vela, West Gemini, West Capella, Sonangol Libongos, Sonangol Quenguela, Sevan Louisiana |
| Responsible unit | Technical Services — Subsea |
| Identified by unit | Technical Services — Subsea |
| Contact person for change | Daniel Plant |
| Connected AAB numbers | none yet; the first Priority 3 issued through the tool is entered here, as DIR-37-0161's Synergi Number rule requires |

## 2. Check list

The CAR26 example carries the Physical Changes checklist (authority approval, CAT, class, cost, design review, FAT, functional design spec, obsolete equipment, and so on). For a Seadrill system change the checklist is the one Synergi attaches to that type **[Dan: confirm]**; the items below are the evaluation this change needs against DIR-37-0015 §2 and the §3.5.2 guidewords that apply to a communication system, written so they drop into whichever checklist Synergi presents.

| Item | Evaluation |
|---|---|
| Scope of work | §1 Description; the process in `AAB-LOOP-PLAN.md` and the flowchart. In scope: Priority 3 WCE advisories, thirteen units, issue, distribution, acknowledgement, optional action closure, chase, revision, withdrawal, fleet reporting. Out of scope: Priority 1 and 2, external AABs via the common mailbox, work orders, Maximo system changes |
| Risk evaluation | HAZID attached (`AAB-HAZID.docx`, DIR-37-0147 format): 15 entries, highest untreated Yellow, all Green after the proposed measures; 15 Synergi actions in §4 |
| Does the change require an update to the HSE Case or risk assessment documents (MAHRA, bowties)? | No. The AAB process is a communication route to the rigs; no barrier, SECE or performance standard changes. The HAZID records this at entry H8 (records) and H1 (distribution) |
| Authority approval | Not a class, flag or regulatory matter. The directive owner (Director of Technical Services, DIR-37-0161 §1.3) and the approver (VP Technical Services & ISIT) approve the directive revision |
| Employee participation | Subsea Superintendents consulted 22 September (recipient tables); rig TSLs are the acknowledgers and are addressed by the directive revision and a one-page rig bulletin (item 22 training pack); Eric Rachall as gatekeeper throughout |
| Maintenance system update | None to Maximo's maintenance data. **[Dan: parent AAB case for the evaluation trail, yes or no, per §0]** |
| Documentation | DIR-37-0161 revised (§5 below); the tool's handoff, the dashboard contract and the loop documents filed in eDocs **[numbers]**; the Compliance Checklist P1 item wording "Maximo AAB Review" updated in WCGRRT |
| Communication (DIR-37-0015 §3.5.2 guideword: "right personnel can be given information at the right time in the right way") | The email per rig with the bulletin attached and the dashboard link; NO RIG CONTACT branch so a lookup miss is a message to the office, never silence; daily overdue chase; HAZID entries H1, H12 |
| Operator error / crew competence (§3.5.2) | Acknowledgement by name, role and crew; expected role shown on the page; second reader for advisories requiring physical intervention; training pack; HAZID H3, H10, H13, H15 |
| Cost estimate | No purchase. Built with existing licences (Power Automate, SharePoint, the sacred server) and existing tools; effort is Technical Services time |
| Obsolete equipment | Not applicable |
| Temporary changes | None. If the pilot route in §0 is chosen, the deviation is recorded under DIR-00-0011 with an end date equal to the directive revision date |

## 3. General classifications

| Field | Entry |
|---|---|
| Change category | System change (Seadrill change, DIR-37-0015 §2), permanent |
| Discipline | Well Control Equipment, Technical Services — Subsea |
| Safety-critical | The AAB route is how a known equipment defect reaches the rigs that carry the equipment; the change is treated as safety-related for review even though Priority 3 is information only |
| Client / regulatory impact | None identified; Priority 3 is not mandatory and carries no operational or cost impact (DIR-37-0161 §2.2.3, both tick boxes No) |
| Other rigs | All thirteen WCE units from the start; no rig-by-rig roll-out |

## 4. Actions (each becomes a Synergi action; the HAZID ones titled "HAZID Action # n" per DIR-37-0015 §3.4)

| # | Action | Responsible | Due | Evidence |
|---|---|---|---|---|
| A1 | Revise DIR-37-0161 §2.1 (TSL acknowledgement route), §2.2.3 (Priority 3 handling), §2.2.4 (distribution and acknowledgement for Priority 3), §4 (flowchart), §6 (references); route to the owner and the VP Technical Services & ISIT | Eric Rachall drafts; Daniel Plant | before cut-over | revised directive issued |
| A2 | Bulletin Board Rev 5 built and tested on the saved test records (not posted) | Eric Rachall | | Rev 5 file and its schema 2.0 handoff |
| A3 | Scanner, dashboard AAB tab, acknowledgement page with TSL name and crew; "acknowledged, action open" as its own state; stale-data banner; archive script never moves an AAB file | Daniel Plant | | test-set run, screenshots |
| A4 | AAB Notifications flow with issued, acknowledged, NO RIG CONTACT and daily chase branches, sent-log, built in test mode | Daniel Plant | | test-mode run with the would-have recipients listed |
| A5 | End-to-end trial on one rig in test mode: issue, email, both TSLs acknowledge, chase on a due date set to yesterday | Daniel Plant, Eric Rachall, one rig | | dashboard shows the trial; emails on file |
| A6 | Rig bulletin: how to acknowledge, one page; office training inside the three-day class | Daniel Plant | | bulletin sent; attendance |
| A7 | Cut-over: open Maximo Priority 3 WCE advisories listed, re-issued through the tool or closed in Maximo with a note; the date recorded in this case | Eric Rachall | | cut-over list |
| A8 | Compliance Checklist P1 wording updated in WCGRRT to point at the dashboard AAB tab | reporting-tools session, Daniel Plant | | REV note |
| A9 | Retention rule for PostedReports agreed with IT for at least the directive's retention period; quarterly export to the Technical Services archive | Daniel Plant, IT | | written rule |
| A10 | West Gemini route ticket closed, or the reply route for that rig accepted in writing | Daniel Plant, IT | | ticket |
| HAZID Action # 1 to # 15 | one per register entry H1 to H15, the proposed measure as the action text, the action party from the register | as the register | | as the register |

## 5. The directive revision in outline (DIR-37-0161 v6.07 → v7, Priority 3 only)

| Section | Now | After |
|---|---|---|
| 2.1 Roles | OIM / TSL "responsible for reviewing and actioning child AAB for respective rig"; TSL adds the craft supervisor as a reviewer in Maximo | For Priority 3 WCE advisories: the TSL of each crew acknowledges on the WCE Dashboard acknowledgement page; the craft supervisor is named in the acknowledgement comment where relevant |
| 2.2.2 Filing | eDocs registration and Maximo parent case for every AAB | Unchanged for eDocs. **[Maximo parent case kept for the evaluation trail, marked "distributed via the Seadrill Bulletin Board", or replaced by the dashboard record]** |
| 2.2.3 Evaluation and approval | Discipline manager evaluates in Maximo; Priority 3 scope carries "Not required by Corporate, for information only" | Unchanged in substance; for a WCE Priority 3 the gatekeeper issues from the Bulletin Board with the discipline manager's approval recorded in the record (originator, approver); the standard verbiage is carried on the record and the PDF |
| 2.2.4 Distribution | Maximo creates child cases per site; both TSLs tick the box and comment | The AAB Notifications flow emails each applicable rig's contacts with the bulletin; both TSLs acknowledge on the acknowledgement page; the dashboard AAB tab is the fleet register; overdue advisories are chased daily; Technical Services reviews the tab, not the WTSREV queue, for this priority |
| 4 Guidelines | Maximo QRGs and the Maximo AAB flowchart | Add the Bulletin Board flowchart (`AAB-LOOP-FLOWCHART.html`) and the rig bulletin |
| 6 References | eDocs list, DIR-37-0015, DIR-00-0019, DIR-00-0100 | Add the tool handoff, the dashboard contract and the acknowledgement page guide, by eDocs number |

## 6. Connected cases and attachments

- Connected cases: the first Priority 3 AAB issued through the tool (its number entered here); the DIR-00-0011 deviation case if the pilot route is chosen.
- Attachments: `AAB-HAZID.docx`; `AAB-LOOP-PLAN.md`; `AAB-LOOP-FLOWCHART.html`; `AAB-REV5-HANDOFF-FOR-ERIC.md` and Eric's schema 2.0 handoff; `INTEGRATION-CONTRACT.md` (dashboard side); the draft directive revision; the rig bulletin. Filed in eDocs **[numbers]** and referenced here.

## 7. Comments

Draft 2 replaces draft 1 after DIR-37-0161 and DIR-37-0015 were read on 23 September 2026. Three things changed: the terminology (Priority, not Level), the acknowledger (both crews' TSLs, from the directive, not a decision left open), and the case type (a Seadrill system change under §2, not a technical change under §3). The five items in §0 marked for Dan are the only open points.

## 8. Signatures

| Role (DIR-37-0015 §3.1 as applicable) | Name | Date |
|---|---|---|
| Change originator / MOC owner | Daniel Plant | |
| Initiator | Eric Rachall | |
| Technical Services reviewer (at least one required, §3.2) | Lee Arnold, Technical Authority WCE | |
| Directive owner, DIR-37-0161 | Arnaud Gabaut, Director of Technical Services **[confirm current holder]** | |
| Directive approver | VP Technical Services & ISIT | |
| **[QHSE / Assurance, Quality & Enterprise Risk]** | | |
