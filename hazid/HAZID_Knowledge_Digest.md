# HAZID Knowledge Digest

Condensed, structured extraction of the two governing Seadrill directives held in this folder. Read this instead of re-parsing the full PDFs every time a HAZID is generated. If a figure here ever looks like it might have changed (new directive revision dropped into this folder), re-verify against the source PDF before relying on it.

Source documents (verified present in this repo):
- **DIR-37-0147 "Risk Assessment"**, v2.02 — `DIR-37-0147_Risk_Assessment.pdf`
- **DIR-00-0100 "Rig Asset Management Platform" (RAMP)**, v8.06 — `DIR-00-0100_Rig_Asset_Management_Platform.pdf`

---

## 1. PIMED Task Process (DIR-37-0147 §2.3–2.5)

All tasks/activities follow **PIMED**: **P**lan → **I**dentify → **M**anage → **E**xecute → **D**ebrief.

- **Plan** — objective, relevant directives/procedures, equipment, competence, authority to proceed.
- **Identify** — inspect worksite/equipment/tools, set correct Tempo, identify hazards using P.E.A.R (§2 below), plus **On-the-Day Risk** (equipment status, weather awareness, personnel review, human factors — discussed at the Pre-Task Meeting).
- **Manage** — eliminate hazards where practicable → reduce risk to ALARP → mitigate consequence. Pre-Task Meeting run by the Supervisor covers objective, procedure, equipment, hazards, controls, planned Time Out For Safety (TOFS).
- **Execute** — monitor for unsafe acts/conditions; call a TOFS on any change of plan; re-evaluate hazards/controls/tempo before continuing.
- **Debrief** — verbal or written; was the objective achieved, was the procedure followed, what went well/could improve, any actions, who owns them. Record substantive actions/lessons learned in Synergi.

A HAZID document (this template's output) is normally an **engineering/equipment-acceptance risk assessment that feeds the Plan step** for the eventual field activity — the actual field task itself is still separately controlled by a TBRA and/or 5-Point Check at the worksite.

## 2. Risk Evaluation — P.E.A.R, Consequence, Frequency (DIR-37-0147 §2.1)

**P.E.A.R** = consequence priority order: **P**eople → **E**nvironment → **A**sset → **R**eputation.

**Consequence ranking** (1 = high severity, 5 = low severity) — evaluated per the Seadrill Risk Matrix (FRM-37-0138).

**Frequency / likelihood classification (A–E):**

| Code | Descriptor | Meaning |
|---|---|---|
| A | Frequent | Multiple annual events on the rig |
| B | Likely | Annual event on the rig |
| C | Unlikely | Annual event in the company |
| D | Rare | Annual event in the industry |
| E | Very Rare | Decade event in the industry |

**Acceptance criteria (risk matrix colors):**

| Color | Meaning | Required action |
|---|---|---|
| 🔴 Red | Unacceptable risk | Activity/acceptance **cannot proceed** without mitigation; controls must reduce risk to at least Yellow. If it stays Red after controls, the activity does not take place. |
| 🟡 Yellow | Additional controls required | May proceed once risk is reduced to ALARP, even if it remains Yellow. |
| 🟢 Green | Generally acceptable | Additional controls only where reasonably practicable / resources justify it. |

**All risk shall be reduced to ALARP** (As Low As Reasonably Practicable) regardless of starting color.

## 3. Hierarchy of Controls (DIR-37-0147 §2.2)

Evaluate from the top down; higher = more effective, always prefer higher options where practicable:

1. **Elimination** — remove the hazard entirely.
2. **Substitution** — replace with a lower-risk equipment/process/material.
3. **Engineering** — physical barriers between person and hazard (guards, grating, ventilation, and — for equipment-acceptance HAZIDs — proof-load testing, NDE, dimensional verification, positive-lock indication, etc.).
4. **Administrative** — procedures, training, competency, work scheduling, signage, certification/QA sign-off.
5. **PPE** — last line of defence; least effective, protects only after the hazard is realized.

For engineering/equipment-recertification HAZIDs (the kind this structure is built to produce), the two controls that do almost all the work are **Engineering** (testing/NDE/inspection evidence) and **Administrative** (qualified procedures, certification, Technical Authority acceptance) — see the worked examples in `03_Examples/`.

## 4. Risk Assessment Levels — TBRA vs 5-Point Check (DIR-37-0147 §2.6)

These apply to the **field/task-level** risk assessment (not the equipment-acceptance HAZID itself, which is a separate document type), but are relevant when a HAZID's "Proposed Risk Reducing Measures" hand off to an offshore activity.

**TBRA (Task Based Risk Assessment, FRM-37-0015)** is mandatory (unless covered by the Standard Operating Manual) when:
- A Permit to Work is required (DIR-00-0020)
- Simultaneous Operations (SIMOPS) are involved
- 3+ people / multiple Supervisors, disciplines or Service Providers are involved
- Prolonged, multi-step activity
- Entry into a Red Zone is required
- Deemed necessary by OIM / Area Supervisor / Supervisor, or requested by any crew member

**5-Point Check** is used for everything else — a quick, informal (verbal/mental) check immediately before starting a task, done by every person involved even after a TBRA has been completed.

## 5. RAMP — Equipment Identification & Criticality (DIR-00-0100 §4)

The Rig Asset Management Platform (RAMP, implemented in Maximo/SAMS) governs how equipment is identified, classified for criticality, and maintained. Relevant when a HAZID covers equipment acceptance/return-to-service:

**Criticality classes:**
- **SCE — Safety Critical Equipment**: functional fault could cause serious health/safety consequences. Derived from the MAHRA (Major Accident Hazard Risk Assessment) process and/or Consequence Database.
- **ECE — Environmental Critical Equipment**: functional fault could cause serious environmental consequences. Derived from MAHRA / ENVID / Consequence Database.
- **OCE — Operational Critical Equipment**: failure likely to cause operational downtime, revenue loss, or reputational impact. Derived from the Consequence Database or Discipline Manager review.
- **Client Critical**: an additional rig-specific criticality flag above corporate standard (local/regional/client requirements) — set via a Synergi MoC case.
- **SECE (Safety & Environmental Critical Element)**: equipment marked Safety and/or Environmental Critical also gets a **SECE Group/Tag** populated, identifying which barrier function it performs, plus a **Performance Standard** (from the MAHRA/bowtie) and a barrier function test (action code `TEST BARR`) in Maximo.

**Equipment Criticality Review Matrix** (§4.3.1.1) — used to score/rank equipment (Safety = P column; Environmental = U1–U4 by discharge type; Operational = Material Damages **M** / Production Losses **S**), each cross-referenced against most-probable-frequency bands (1 event/6 months → 1 event/10 years). Resulting numeric score thresholds:

| Score | Criticality | Typical action |
|---|---|---|
| ≥ 100 | High Critical | Must be regularly controlled/inspected to control identified failure consequences |
| 20–75 | Medium Criticality | Must be regularly controlled/inspected to control identified failure consequences |
| 1–15 | Low Criticality | May only require routine inspection; corrective maintenance/run-to-failure may be acceptable |

**Rotating / Additional Repairable Assets** (§6.3.1): condition-enabled, typically >US$100,000, sent onshore for repair, and the *same* asset (not an exchange) typically comes back and can move between rigs — e.g. Top Drives, Thrusters, BOPs, Risers, and riser-handling tools. Managed with serial-number traceability in Maximo; repairs are tracked as Corrective Maintenance.

**Maintenance priority (§5.2.6):** corporate-minimum PM priority is driven by the Consequence Database's maximum criticality ranking — ≥100 → P1, 20–75 → P2, <20 → P3.

**Third-party/service-provider equipment** entering service on a Seadrill unit is governed by DIR-00-0239 (Management of Service Providers Onboard) and any modification/repair scope by DIR-37-0015 (Management of Change Requests).

**Certification tracking**: certificate/recertification validity should be tracked in Maximo with mandatory Certification and Expiration dates (the pattern used for Risers in the Riser Portal, §5.11), with supporting documents filed in eDocs (DIR-37-0019).

## 6. Reference Document Index

### Verified — confirmed present and read in this repo
| Number | Title |
|---|---|
| DIR-37-0147 | Risk Assessment (this digest's primary source) |
| DIR-00-0100 | Rig Asset Management Platform (RAMP) |
| FRM-37-0138 | Seadrill Risk Matrix *(referenced by DIR-37-0147; matrix image itself not reproduced here beyond the acceptance-criteria table above)* |
| FRM-37-0015 | Task Based Risk Assessment (TBRA) |
| FRM-00-0034 | PIMED – Task Process Workflow |
| DIR-00-0020 | Permit to Work Directive |
| DIR-00-0149 | Standard Operating Manual (SOM) |
| DIR-37-0015 | Management of Change Requests |
| DIR-00-0239 | Management of Service Providers Onboard |
| DIR-37-0019 | Management of Technical Documentation (eDocs) |
| DIR-00-0034 | Major Accident Hazard Management |
| DIR-00-0021 | Environmental Management (ENVID) |
| SYS-00-0033 | Reliability Centred Maintenance (RCM) process |
| SYS-00-0034 | RAMP Equipment Structure and Coding |

### Unverified — only seen cited inside the example HAZID documents in `03_Examples/`, not confirmed against an actual source document in this repo
Treat these as **plausible but unconfirmed** until the real document is supplied or checked in the Seadrill Management System (SMS). Do not present them to a reader as verified.

| Number | Title (as cited in examples) |
|---|---|
| MAN-00-0002 | Major Accident Hazard and Barrier Management Manual |
| MAN-00-0003 | Seadrill Safety Studies and Interrelations |
| MAN-00-0004 | Seadrill Safety Critical Elements and Activities |
| MAN-00-0005 | Seadrill HSE Cases and Regulatory Submissions |
| MAN-00-0006 | Seadrill Major Accident Hazard ALARP Demonstration |
| DIR-00-0011 | Handling of Non-Conformities |
| FRM-37-0142 | Seadrill HAZID Guidewords |
| FRM-37-0143 | Seadrill HAZID Worksheet |
| FRM-00-0045 | Standard Bowties – Drillship and Semi-Submersible |
| FRM-00-0166 | Barrier Accountabilities and Responsibilities |

## 7. How this maps to a generated HAZID document

- **Section 2 "Requirements" of the template** = §1–3 of this digest (Risk Matrix, Hierarchy of Controls, PIMED/TBRA).
- **Equipment criticality classification stated in the HAZID's Introduction/Scope** = §5 of this digest (SCE/ECE/OCE/SECE, Rotating Asset status).
- **"Existing Risk Controls" / "Proposed Risk Reducing Measures" columns** in the Risk Register should apply the Hierarchy of Controls (§3) in order, and reference the Consequence(1-5)/Frequency(A-E)/Color model (§2) for every row.
- **Any Seadrill document number cited in a generated HAZID** should come from the "Verified" table in §6 wherever possible; if a document from the "Unverified" table is used (because it matches the style of the two examples), flag it to the user as unconfirmed rather than presenting it as a checked fact.
