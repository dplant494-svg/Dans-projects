# Training class pack — who supplies what, module by module (29 September 2026)

**Class:** week plan item 22, two days, agenda `WCE-Training-Class-Agenda.pdf` (draft 3, 29 Sep).
**Owner:** Dan. **Pack built by:** the dashboard session. **Content from:** four handoffs, sent 29 Sep.

| Day, time | Module | Content from | Handoff |
|---|---|---|---|
| 1, 08:00 | WCGRRT: rig visit and daily reports | Reporting-tools session | `TRAINING-HANDOFF-REPORTING-TOOLS.md` |
| 1, 10:15 | WCGRRT: surface tests, attachments, Post, Load latest posted | Reporting-tools session | same |
| 1, 13:00 | SSORT: CBM, pre-deployment, Post to OEM | Reporting-tools session, Brad Waldron | same |
| 1, 14:45 | Exercise on SSCE Equipment via the training folder | Reporting-tools session (sheet and samples); dashboard session (`config.training.json`, sandbox) | same |
| 2, 08:00 | Precharge process | Precharge Pro session (form, calculator, sheet, PDF); dashboard session (loop, inbox); Dan and Lee (signatures, MOC) | `TRAINING-HANDOFF-PRECHARGE.md`, `TRAINING-HANDOFF-LEE.md` |
| 2, 10:15 | Rig Visit Dashboard tab by tab | Dashboard session | none needed |
| 2, 13:00 | BOP Fleet Planning, SSCE Requests | Dashboard session | none needed |
| 2, 13:00 | WCE COC Dashboard (the Certification Tracker) and the request cycle | COC Tracker session (Lee's tool) | `TRAINING-HANDOFF-COC-TRACKER.md` |
| 2, 13:00 | AAB tab and the Seadrill Bulletin Board | Dashboard session, all of it: the module is written (`TRAINING-MODULE-AAB.md`), the slides and the guide are done; Eric may take the review minutes on the day | none needed |
| 2, 14:45 | The loop: how the tools connect today and the plan to connect the rest (added 29 Sep) | Dashboard session; SPARC session (SPARC, Maximo, connection order); COC Tracker session (five minutes) | `TRAINING-HANDOFF-SPARC.md` §1, `TRAINING-HANDOFF-COC-TRACKER.md` §2 |
| 2, 15:30 | What is coming | Dashboard session; SPARC session (five minutes) | `TRAINING-HANDOFF-SPARC.md` §2 |
| 2, 16:15 | Feedback session | Dan | none |

## The decks

- **Day 1:** `WCE_Reporting_Tools_-_Day_1_Training.pptx`, built by the reporting-tools session (19 slides, received 29 Sep).
- **Day 2:** `WCE_Reporting_Tools_-_Day_2_Training.pptx`, built by the dashboard session on 29 Sep in the same template and
  the same slide patterns (title, module dividers, three-column content, the checks table, the closing line): 24 slides,
  the two-day agenda with the AAB in it, precharge process, the Rig Visit Dashboard, fleet planning and SSCE/COC, the AAB
  (four slides), the loop (three slides including "what a failure looks like, and who sees it"), what is coming, feedback.
  The Precharge Pro, COC Dashboard and SPARC walkthrough slides drop in when those handoffs come back.

## What the dashboard session builds, once the content is in

- Slide decks per module on the Seadrill template (the AAB pair and the SACRED deck seed them). The AAB
  module is complete: trainer's script, mistakes, workbook questions, slide content (`TRAINING-MODULE-AAB.md`).
- The trainee workbook: the exercise, the questions from every handoff, the "why did it stop me" table.
- The trainer's script with the answers, module by module, from the walkthrough scripts.
- `config.training.json`: a second scanner configuration reading a training folder and deploying to the
  sandbox site, so nothing from the class touches the fleet dashboard.
- The Rig Visit Dashboard, BOP Fleet Planning, SSCE Requests, AAB and "what is coming" modules in full.

## For Dan: what goes to Lee's side

Two tool handoffs for the sessions that maintain his tools, and one page for him:

- `TRAINING-HANDOFF-COC-TRACKER.md`: the WCE COC Dashboard, which is the Certification Tracker (one
  tool): what it is, a walkthrough with a request and its decision, the three mistakes, the frozen
  build, and its five minutes in the loop module.
- `TRAINING-HANDOFF-SPARC.md`: SPARC and Maximo in the loop module, the connection plan in his order,
  and where SPARC goes next.
- `TRAINING-HANDOFF-LEE.md`: the precharge MOC, the AAB pilot MOC and HAZID status, the pre-deployment
  MOC if through. None of those are reachable from this side.

**Pinned until the server migration is signed off** (week plan item 22): the pack is built after the
handoffs are in and the server task is running, so the class trains on the estate as it will be.
