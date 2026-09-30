# Training class handoff 2 — the reporting tools (WCGRRT and SSORT), Day 1

**To:** the reporting-tools session · **From:** the dashboard session, via Dan · **Date:** 30 September 2026
**Supersedes:** `TRAINING-HANDOFF-REPORTING-TOOLS.md` (29 Sep) where the two differ. **Received from you so far:**
the Day 1 deck (19 slides, 29 Sep), which is good and is in the pack. Nothing else yet.
**Class:** Monday 19 and Tuesday 20 October 2026, Houston. **Your draft by 5 October, final by 12 October.**

## 1. Four decisions since the first handoff (Dan, 30 September)

1. **No sandbox. Trainees post for real.** The exercise posts go through the live intake on the
   `SSCE Equipment` asset, land on the fleet dashboard under SSCE Equipment (a non-rig bucket that
   never enters a fleet count; every notification flow treats it as test mode, office only), and Dan
   deletes the files from PostedReports after the class. So the exercise sheet says **Post**, not
   "save locally for the trainer", and your deck's slide 16 ("What you produce") and any "training
   folder" wording change to match. The known-good sample files are still wanted, as "what good
   looks like", not as the delivery route.
2. **Brad Waldron will not attend.** The SSORT segment is Dan alone. Nothing in your deck names Brad
   as far as we can see; please check the script does not lean on him.
3. **MOC is one line.** No MOC content in the class: every module says the change is under MOC and
   moves on. Do not write MOC material.
4. **The TSC Help Centre is in Day 2** (ten minutes hands on, in the loop module). See §4.

## 2. The one thing to settle first: file names in a room of ten people

Ten trainees posting the same report type on the same asset on the same day produce **the same
file name**, and on the dashboard a same-name post is an update, not a second row (rolling handoff
entry 42.8, answered 30 Sep). So the exercise as written would leave one report of each type on the
dashboard, the last one posted, and nine people would watch theirs disappear.

**Please state the exact file name pattern for each report type the exercise uses** (daily report,
surface test, CBM inspection, pre-deployment checklist) as the frozen build writes it, and which
fields feed it. Then choose one of these and put it on the exercise sheet:

- **Per-trainee report dates** (our recommendation, no tool change): each trainee is given a date
  from 1 to 10 October 2026 to enter as the report date. Ten dates, ten files per type, all under
  SSCE Equipment, all deleted afterwards. The dashboard files them by date, so each trainee finds
  their own row by their date.
- Or a per-trainee token in whichever field reaches the filename, if one does.

Either way, **list the file names the class will produce** so Dan can delete exactly those.

## 3. Still owed from the 29 September handoff

| # | Item | Status |
|---|---|---|
| 1 | Walkthrough script per module (four), markdown, what the trainer clicks and says | owed |
| 2 | Screenshots, PNG, light mode, 1600 px, asset SSCE Equipment, numbered to the script | owed (one zip) |
| 3 | Three questions per module with answers, twelve in all | owed |
| 4 | Exercise sheet (now: posts, per §2) and the four known-good sample files | owed |
| 5 | One slide's worth per module | **received as the deck** |
| a | Word for word what a trainee sees when Post fails, per tool | your slide 18 has it; confirm that text is canonical for the workbook table |
| b | The current guards list before Post | your slide 17 has it; confirm, and add anything shipped since |
| c | Which REV the class trains on | WCGRRT REV 166 on slide 3; **SSORT REV is missing**: 151 today, 152 announced. Name it and freeze it |

## 4. New asks

1. **SSORT 152 and the class.** If 152 (test records on a CBM equipment entry, `cbmatt`) is deployed
   by 12 October, module 3 gains one step ("attach the pressure test chart to 6.1.2, note the task
   number") and the exercise's CBM report carries one attached PDF; the dashboard shows it under the
   equipment entry from v2.73, already installed. If 152 is not deployed by then, it stays out of
   the class and the frozen build is 151. Say which.
2. **The assistance request button (the Help Centre's Post from the tools).** Day 2 has ten minutes
   on the Help Centre: a request posted from the tool on SSCE Equipment, rig down ticked, then the
   email, the Teams chat, the receipt and the acknowledgement from the page. If your Post button is
   in the frozen build, that first step is yours to script (one screen, one paragraph). If it is not,
   Dan drops the sample file in and the step is ours. Say which, and if yours, send the one screen.
3. **Load latest posted** (week plan item 21): confirm it is in REV 166 as the class will use it in
   module 2, or say it is not, and it comes out of the agenda.
4. **Deck edits**: slide 16 for posting (§1.1), slide 3 for the SSORT REV, and the trap list on the
   exercise sheet mirrored on slide 17 if it changed.

## 5. Dates

| What | When |
|---|---|
| Your draft: scripts, questions, exercise sheet, samples, screenshots zip, deck edits | **5 October** |
| Review round, one | 5 to 12 October |
| Final | **12 October** |
| Class | 19 October (Day 1), 20 October (Day 2) |

Nothing else is needed from you for Day 2; the dashboard, precharge, AAB, Help Centre and loop
modules are ours and are built.
