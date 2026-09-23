# Management of Change — Priority 3 Advisory AABs distributed and acknowledged through the Seadrill Bulletin Board and the WCE Dashboard

**Draft 3 for the Synergi case** · **Date:** 23 September 2026 (draft 1 was 22 September, before the directives; draft 2 after them; draft 3 with Dan's rule that the HAZID is gospel and the case carries approvals plus HAZID actions only)
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
| **Every AAB is filed in eDocs** and entered in Maximo for evaluation, "regardless of relevance or applicability" | §2.2.2 | The Bulletin Board record carries the **eDocs reference** and the Maximo parent case number. **Dan, 23 Sep: the Maximo parent case is kept** for the corporate evaluation trail, marked "distributed via the Seadrill Bulletin Board"; the child cases and the acknowledgement move to the board and the dashboard |
| **What kind of change this is** | DIR-37-0015 §2: a Synergi MOC is required for major **people, process or system** changes; **System Changes** include "changes / introduction of new Seadrill systems … e.g. MAXIMO to develop and track Maintenance Work Orders"; **Procedural Changes** (implementation of directives, procedures) are covered by DIR-00-0001. §3 Technical / Physical changes do not apply: no equipment, drawing or system program changes | This is a **Seadrill System Change** (introduction of a new system for the distribution and acknowledgement of Priority 3 AABs) with a **procedural change** (the revision of DIR-37-0161) handled under DIR-00-0001. The Synergi case type is the one for Seadrill changes, **[Dan: the exact type name in the Synergi "new case" list; the CAR26 example is "Management of Change - Physical Changes", which is not ours]** |
| **Deviation until the directive is revised** | DIR-37-0015 §3 note: "Changes to, or deviations from, Seadrill directives … shall be handled according to DIR-00-0011 Handling of non-conformities" | Running Priority 3 AABs outside Maximo before DIR-37-0161 is revised is a deviation. **Dan, 23 Sep: the route is a pilot under a documented DIR-00-0011 deviation, using this MOC and the HAZID as its basis, while the directive revision goes through.** The deviation case is raised alongside this MOC and connected to it (§6); its end date is the date the revised directive is issued |
| **HAZID and actions** | DIR-37-0015 §3.4: the HAZID is Seadrill's standard HAZID; every action listed in it gets a Synergi action titled **"HAZID Action # (number)"** with an action responsible, verified complete by the MOC owner before close | `AAB-HAZID.docx` is the HAZID; its sixteen entries become sixteen Synergi actions (§4.2), beside the six approval actions (§4.1), and nothing else |
| **Supporting documents** | §3.3: attached to the case or referenced by eDocs number | §6 below |
| **Scope of the change** | DIR-37-0161 covers internal and external AABs for all equipment, single point of entry `aab.operations.excellence@seadrill.com` | **Dan, 23 Sep: every Priority 3 advisory WCE Technical Services issues is created on the Bulletin Board by the gatekeeper, including ones derived from OEM notifications.** The board is a separate passworded requests dashboard on the sacred server, like the precharge pages, open to all subsea superintendents and the offices; it is not a mailbox. The common mailbox, eDocs filing and the Maximo parent case are unchanged |

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

## 2. Check list — replaced by the HAZID (Dan, 23 Sep)

The Synergi checklist on the CAR26 example (authority approval, CAT, class, cost, design review, FAT
and so on) is the Physical Changes checklist and is not used for this case. **The rule for this MOC,
and for the MOC tool that follows it: the HAZID comes first and is gospel; the MOC case is created
from it; its actions are the mandatory approval actions DIR-37-0015 requires plus one Synergi action
per HAZID register entry, titled "HAZID Action # n" (§3.4), and nothing else.** Whatever checklist
Synergi attaches to the case type is answered with one line each: "see HAZID entry Hn" or "not
applicable, see HAZID scope".

Sequence, as it was actually done here: `AAB-HAZID.docx` (16 entries, draft 2) → this case → the
DIR-00-0011 deviation case connected to it → the pilot when HAZID Action # 16, the go-live gate, is
signed.

## 3. General classifications

| Field | Entry |
|---|---|
| Change category | System change (Seadrill change, DIR-37-0015 §2), permanent |
| Discipline | Well Control Equipment, Technical Services — Subsea |
| Safety-critical | The AAB route is how a known equipment defect reaches the rigs that carry the equipment; the change is treated as safety-related for review even though Priority 3 is information only |
| Client / regulatory impact | None identified; Priority 3 is not mandatory and carries no operational or cost impact (DIR-37-0161 §2.2.3, both tick boxes No) |
| Other rigs | All thirteen WCE units from the start; no rig-by-rig roll-out |

## 4. Actions (two kinds only)

### 4.1 Mandatory approval actions (DIR-37-0015 §3.1 to §3.3, §2; the ones Dan named)

| # | Action | Responsible |
|---|---|---|
| AP1 | Technical Services review of the change and the HAZID (at least one Technical Services reviewer on every technical MOC, §3.2) | Lee Arnold, Technical Authority WCE |
| AP2 | Corporate Reviewer (SME) review: merit of the change and effectiveness of the change management plan; evaluation of implementation on other rigs (§3.1; here all thirteen from the start) | Daniel Plant, Subsea Superintendent, as Technical Superintendent for the discipline |
| AP3 | Directive owner's approval of the DIR-37-0161 revision route and of the pilot under a DIR-00-0011 deviation | Arnaud Gabaut, Director of Technical Services **[confirm current holder]** |
| AP4 | Directive approver's approval of the revision when issued | Vice President Technical Services & ISIT |
| AP5 | Assurance, Quality & Enterprise Risk / QHSE review of the deviation case and this MOC | **[name]** |
| AP6 | MOC owner's verification that every HAZID action is complete per the change plan, then close-out (§3.4) | Daniel Plant |

### 4.2 HAZID actions (one per register entry; the action text is the register's Proposed Risk Reducing Measure; the responsible is the register's action party)

| Synergi action title | Register entry | Responsible |
|---|---|---|
| HAZID Action # 1 | H1 advisory not received: daily chase, monthly Rigs sheet review, sent-log | D. Plant |
| HAZID Action # 2 | H2 wrong applicable rigs: SFI check, second reader for fleet-wide AABs | E. Rachall |
| HAZID Action # 3 | H3 acknowledged but not actioned: third state on the dashboard, closure evidence review, quarterly sample | D. Plant / E. Rachall |
| HAZID Action # 4 | H4 superseded revision in use: cover wording, current revision only in the open list | D. Plant |
| HAZID Action # 5 | H5 wrong or missing attachment: open the attachment from the preview before posting | E. Rachall |
| HAZID Action # 6 | H6 post fails or is cut short: confirm on the dashboard within 20 minutes, re-post from the saved file | E. Rachall |
| HAZID Action # 7 | H7 rig cannot reach the server: West Gemini route ticket or the reply route accepted | D. Plant / IT |
| HAZID Action # 8 | H8 loss of the register: retention rule with IT, quarterly export | D. Plant |
| HAZID Action # 9 | H9 unauthorised or accidental issue: endpoint held by two people, test mode for every test | E. Rachall / D. Plant |
| HAZID Action # 10 | H10 acknowledgement by the wrong person: role list from the directive, name and crew recorded | D. Plant |
| HAZID Action # 11 | H11 two registers during cut-over: cut-over list, P1 item re-pointed, Maximo child route retired for Priority 3 | E. Rachall |
| HAZID Action # 12 | H12 notification fatigue: quarterly recipient review, chase once a day | D. Plant |
| HAZID Action # 13 | H13 single-person dependence: named deputy in the directive revision, handover document | E. Rachall / D. Plant |
| HAZID Action # 14 | H14 scanner or flow stops: stale-data banner, monthly flow check | D. Plant |
| HAZID Action # 15 | H15 advisory content wrong or unclear: second reader for advisories needing physical intervention | E. Rachall |
| HAZID Action # 16 | H16 implemented out of order or untested: the six-point go-live gate (Rev 5 proven; dashboard side proven; flow in test mode; one advisory end to end on one rig with both TSLs and the chase; rig bulletin and office training; deviation case open) | D. Plant |

The build steps of the earlier draft (Rev 5, the dashboard side, the flow, the trial, the training, the cut-over) are the content of HAZID Action # 16 and # 11, not actions of their own.

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

- Connected cases: the DIR-00-0011 deviation case for the pilot (raised with this MOC); the first Priority 3 AAB issued through the tool (its number entered here).
- Attachments: `AAB-HAZID.docx`; `AAB-LOOP-PLAN.md`; `AAB-LOOP-FLOWCHART.html`; `AAB-REV5-HANDOFF-FOR-ERIC.md` and Eric's schema 2.0 handoff; `INTEGRATION-CONTRACT.md` (dashboard side); the draft directive revision; the rig bulletin. Filed in eDocs **[numbers]** and referenced here.

## 7. Comments

Draft 2 replaces draft 1 after DIR-37-0161 and DIR-37-0015 were read on 23 September 2026. Three things changed: the terminology (Priority, not Level), the acknowledger (both crews' TSLs, from the directive, not a decision left open), and the case type (a Seadrill system change under §2, not a technical change under §3). Decided: pilot under deviation; scope (every WCE-issued Priority 3, created on the board); Maximo parent case kept. Open: the Synergi case type name.

## 8. Signatures

| Role (DIR-37-0015 §3.1 as applicable) | Name | Date |
|---|---|---|
| Change originator / MOC owner | Daniel Plant | |
| Initiator | Eric Rachall | |
| Technical Services reviewer (at least one required, §3.2) | Lee Arnold, Technical Authority WCE | |
| Directive owner, DIR-37-0161 | Arnaud Gabaut, Director of Technical Services **[confirm current holder]** | |
| Directive approver | VP Technical Services & ISIT | |
| **[QHSE / Assurance, Quality & Enterprise Risk]** | | |
