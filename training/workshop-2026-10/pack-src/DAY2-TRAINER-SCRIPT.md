# Day 2 trainer's script: Tuesday 20 October 2026

**Workshop:** WCE SME Technical Review and Open Workshop, Houston · **Day 2:** Training review, part 2: precharge,
dashboards, Argo Navis, the loop · **Presenter:** Dan Plant, with Lee Arnold for Argo Navis and the loop

**Builds on screen (frozen to Friday 23 October):** WCGRRT **REV 174**, SSORT **REV 169**, Argo Navis **REV 16**,
scanner **v3.11** (every 10 minutes), the pages under `/sacred/` on `http://sdrlazneuiis01d.corp.local:8080`. Precharge
Pro as live on the day (pack built on **Rev 87**; check the badge before 08:00).

## How to read this script

**This is a demonstration day.** Dan drives everything on the projector. Delegates follow on their own laptops: they
open the same page and look at the same thing, but they **post nothing, save nothing to the server, and press no Post,
Save, Post to OEM or Post AAB button.** Every step is written up in the **Training Manual**; each part below points at
its guide ("Manual: How to …").

Each step can carry: **SAY** (the key points), **CLICK/SHOW** (the clicks, in order), **THE ROOM SEES** (proof the
click worked), **TRAP** (say it before they find it) and **They follow** (what delegates open and look at). `[Slide n]`
is the Day 2 deck. If you run over, cut "If asked", not the traps.

**If something does not work in front of the room:** say what you expected, what you see, and what you will do. "I
expected the report within ten minutes. The stamp says the last scan was 09:40, so the scanner is behind. I will ring
the office at the break." That is the lesson the tools exist to teach.

**The day in one table**

| Time | Module | Presenter | Slides |
|---|---|---|---|
| 08:00–10:00 | 5 · The precharge process | Dan | 1–6 |
| 10:00–10:15 | Break | | |
| 10:15–12:00 | 6 · The SACRED dashboards | Dan | 7–13 |
| 12:00–13:00 | Lunch | | |
| 13:00–14:30 | 7 · Argo Navis: planning and executing BWM, with the **hold point** | Dan, Lee | 14–23 |
| 14:30–14:45 | Break | | |
| 14:45–15:30 | 8 · The loop, and the TSC Help Centre | Dan, Lee | 24–27 |
| 15:30–16:15 | 9 · What is coming | Dan | 28 |
| 16:15–17:00 | 10 · Feedback | All | 29–30 |

**Three rules for the whole day. Say them at 08:00 and again at 13:00.**

1. **I drive; you follow.** Open the page, look where I point. Nobody posts or saves anything. The how-to for every
   step is in your Training Manual.
2. **Argo Navis: open the landing page, never the test plan.** An opened plan saves itself on each completed step and
   every 30 minutes, and the plan has one save file. Only I open it, on the projector.
3. **Everything is under MOC.** One line, every time: "That is managed under MOC; not today's subject."

---

# Opening (08:00–08:05)

`[Slide 1]` title. `[Slide 2]` the Day 2 agenda.

1. **SAY:** "Yesterday was the rig tools and the post. Today is what happens after the post: the precharge, the
   dashboards, the planning tool and the loop that joins them. Then we ask what you want next."
2. **SAY:** the three rules. "You do not need notes on the clicks: they are all in the Training Manual."
3. **SAY:** "Anything hard, wrong or missing goes on the action list on the wall, with a name. Thursday argues from it."

---

# Module 5: the precharge process

**08:05–10:00 · Dan · `[Slide 3]` to `[Slide 6]`** · Tools: the request form (Rev 3, in SSORT and standalone), Precharge
Pro, the issued sheet and PDF. Pack: `tools/received/training/precharge/`.

**By 10:00 they can:** say what a correct request needs and the three mistakes the form catches; say what the
calculation will not do (post a failing sheet); read an issued sheet and its PDF; describe the loop after the post and
the two signatures.

| Part | Minutes | Clock | Slide |
|---|---|---|---|
| 5.1 The request: the form and the three mistakes | 20 | 08:05–08:25 | 3, 4 |
| 5.2 The calculation: a clean run, a real failure, a dual stack | 35 | 08:25–09:00 | 4 |
| 5.3 Three rigs side by side (demonstration) | 20 | 09:00–09:20 | 6 |
| 5.4 The issued sheet and its PDF | 15 | 09:20–09:35 | 4 |
| 5.5 The loop, where the record lives, two signatures, under MOC | 15 | 09:35–09:50 | 5 |
| Questions | 10 | 09:50–10:00 | 6 |

**Before 08:00:** request form and Precharge Pro open, badge checked, Ctrl+F5; the three training files and
`TRAINING-01_West-Tellus_issued_precharge.pdf` on the desktop; the dashboard's Precharge tab open; a past ISSUED test
email in Outlook if you have one. **Every number below is from Rev 87;** if one does not reproduce, find out why first.

## 5.1 The request (08:05–08:25) `[Slide 3]` then `[Slide 4]`

**They follow:** open the standalone request form; look, make no file. **Manual: How to fill a precharge request.**

1. **SAY:** "A precharge is only as good as the request. Every recalculation we have had traces to a field on this form,
   not to the arithmetic."
   - **CLICK/SHOW:** the empty form; the **Guide** button. "If a rig asks what a field means, point them here."
   - **TRAP:** it is the request form, not "the Precharge Pro form". It shares no code with the calculator.
2. **CLICK/SHOW:** Rig, BOP, Well, **Requested by**. "BOP only shows on two-stack rigs. A person, not a shared mailbox."
3. **CLICK/SHOW:** **Check my entries** on the empty form.
   - **THE ROOM SEES:** seven mandatory fields flagged: rig, well, minimum shear, MAWHP, water depth, subsea and deck
     temperature.
4. **CLICK/SHOW:** **Where it came from**; the two unit selectors. "The form starts metric. Set the selectors first."
   - **TRAP:** 7,000 / 38 / 78 typed on metric is 22,966 feet and two Celsius temperatures. It catches the office too.
5. **CLICK/SHOW:** **Well hop** and its depth list, pump cut-in and cut-out, the changes box.

**The three mistakes, live. Read each warning out loud.**

6. **Wrong estimator column:** MAWHP **3,500**, shear **5,200**. The warning about the 15,000 psi column. "It warns,
   not blocks: occasionally the number really is that high. It makes you look."
7. **Temperatures:** °F, subsea **4**; then deck **38**, subsea **50**. "Celsius typed under Fahrenheit; deck below
   subsea usually means swapped."
8. **Pumps:** cut-in **3,000**, cut-out **2,800**. "Cannot cut in above cut-out."
9. **The hard block:** Well hop = yes, list empty. "Warnings make you look; errors stop you."
10. **CLICK/SHOW:** correct the fields and make the file (projector only). "On a real job the rig posts this from
    SSORT. Today nothing is posted."
    - **TRAP:** the form is in SSORT and standalone. Raise it once, from one place.

## 5.2 The calculation (08:25–09:00) `[Slide 4]`

**They follow:** open Precharge Pro, `/sacred/precharge/` (password out loud only, never written); select West Tellus
and watch the hardware block fill; type nothing else. **Manual: How to read a precharge calculation.**

**Part A: West Tellus, a clean run (15 min)**

11. **CLICK/SHOW:** the revision in the header. "Check it every time: it says which method produced a sheet."
12. **CLICK/SHOW:** Asset **West Tellus**. "Thirteen assets, each from its own OEM sizing document. Grey is rig hardware:
    a wrong value is a change request under MOC. White is per well."
13. **CLICK/SHOW:** well **`TRAINING-01 NOT ISSUED`**, 7,000 ft, 38 / 78 °F, shear 2,600, MAWHP 3,900. "A TRAINING well
    is never a real sheet. No Calculate button: every keystroke reruns."
14. **CLICK/SHOW:** the green banner.
    - **THE ROOM SEES:** **SET PRECHARGE (DCB TABLE): 3,725 PSIG** / 3,740 PSIA @ 78 °F, **CHECKS PASS ✓**.
    - **SAY:** "3,725 PSIG at 78 °F. Charge to the yellow column. Table 3,704, rounded up to 25, never down."
15. **CLICK/SHOW:** Method C drawdown. "Charge at 0, at depth at 1, fired to 2. Condition 2: 4,045 at the ram against
    2,600. P1 3,333 psia pairs only with the subsea temperature."

**Part B: a tubular it cannot shear (12 min). The most valuable minutes of the morning.**

16. **CLICK/SHOW:** shear to **4,105**, nothing else.
    - **THE ROOM SEES:** red FAILS PER PRECHARGE TABLE: 4,045 vs 4,105; 46.4 vs 50.6 gal.
    - **SAY:** "A real open item. 60 psi and 4.2 gallons short. Either one stops the ram."
17. **CLICK/SHOW:** the green OPTIMUM banner: 3,900 PSIG; CSR closing 4,114 vs 4,105.
    - **TRAP:** its last sentence still says "closes at 4,045" (F-68, cosmetic). **The right figure is 4,114.**
18. **CLICK/SHOW:** the NOV Contractual Petrobras Checks panel. **SAY, slowly:** "The second cut fails by **minus five
    psi and minus 0.74 of a gallon**. The tool finds the five-psi failure at two in the morning."
19. **CLICK/SHOW:** Save, Export, Generate PDF. "A failing sheet can go into review. It cannot go to the rig."
20. **CLICK/SHOW:** press **Post to Dashboard**. It is refused; read the refusal from the slide:

    > THIS SHEET FAILS THE NOV CONTRACTUAL PETROBRAS CHECK. It cannot be posted to the dashboard: CSR + USR: pressure
    > 4159 vs 4164 PSIG required (-5), volume 100.46 vs 101.20 gal needed (-0.74); CSR + LSR: the same. Saving,
    > exporting and printing are still allowed - take it into review.

    - **SAY:** "Nothing left the browser. Never lower the requirement until it passes."
    - **TRAP:** the only Post press of the morning, and only because it is refused. Dismiss; shear back to 2,600.

**Part C: West Neptune, dual stack (8 min)**

21. **CLICK/SHOW:** **West Neptune**; `TRAINING-02 NOT ISSUED`; 6,500 ft; 40 / 78 °F; MAWHP 12,000. The **BOP**
    selector; shear preset 3,826. "Read the label, not the position: fields differ by rig family."
22. **CLICK/SHOW:** the Precharge Summary, one row per accumulator; BOP 1 to 2. **Ask:** "What changed?" "Only the
    header. Same hardware, one gas density. The selector files the sheet against the right stack."

## 5.3 Three rigs side by side (09:00–09:20) `[Slide 6]`

**They follow:** select each rig in Precharge Pro as Dan does; look at the hardware block. **Manual: How to read a
precharge calculation** has all three cases.

23. **CLICK/SHOW:** **Load .json** for each training file in turn.

    | Rig | Training well | The room sees |
    |---|---|---|
    | West Tellus | `TRAINING-01 NOT ISSUED` | **3,725 PSIG**, checks pass |
    | West Neptune BOP 1 | `TRAINING-02 NOT ISSUED` | Blue POD Pilot 5,156; Manifold Reg. Pilot 3,743; LMRP, Stack, Upper Annular Reg. Pilots 3,293 each (subsea, PSIG) |
    | West Gemini | `TRAINING-03 NOT ISSUED` | **4,750 PSIG** API optimum; BSR closes 3,679 > 2,050 |

24. **SAY, Gemini:** "Piston bottles, no OEM table, so the API optimum. The method belongs to the equipment."
25. **SAY:** "An unexpected number: check the units left on metric and the rig picked, first."
    - **TRAP:** nobody presses Post to Dashboard on a passing sheet. Rigs charge bottles against these numbers.

## 5.4 The issued sheet and its PDF (09:20–09:35) `[Slide 4]`

**They follow:** open `TRAINING-01_West-Tellus_issued_precharge.pdf`. **Manual: How to read an issued precharge
sheet.**

26. **CLICK/SHOW:** clean Tellus: the header ("the right sheet?"), the conditions ("check against the request").
27. **CLICK/SHOW:** the PDF page 1, then **page 3**, precharge against temperature. Read:

    > "The accumulator holds a fixed gas charge. As the surface temperature is subject to change during the precharge
    > process, target the precharge for the ACTUAL temperature at that moment: read off the curve / table below."

    - **SAY:** "60 °F on deck, not 78: read the table. Do not charge to 3,725 and hope."
    - **TRAP:** the table is on **page 3**, not page 2.
28. **SAY:** "**The PDF is the controlled document.** Not the screen, not the email body, not a phone photo."
    - **TRAP:** that sentence is on the posted copy, not the PDF. Do not hunt for it.
29. **CLICK/SHOW:** the filename: download uses underscores, posted copy `Seadrill_` with hyphens; same document (F-69).
    Point at **Post to Dashboard**; **do not click it.**

## 5.5 The loop, where the record lives, two signatures, under MOC (09:35–09:50) `[Slide 5]`

**They follow:** open the Rig Visit Dashboard, Precharge tab. **Manual: How a precharge is requested and issued.**

30. **CLICK/SHOW:** the slide's loop, one box at a time:
    1. The rig fills the request and posts it from SSORT.
    2. The scanner puts it in the office's precharge inbox within ten minutes; amber after 48 hours.
    3. The office is emailed (office only).
    4. The office opens it in the calculator, works it, checks it.
    5. The office posts the issued sheet. **ISSUED email To the rig's subsea supervisor, TSL, assistant rig manager and
       rig manager, office on Cc, with the PDF and only the PDF.**
    6. The Precharge tab shows the issued sheet against the request.
    - **SAY:** "Rig people on To, never Cc: rigs filter Cc. The data file never goes in the email."
31. **CLICK/SHOW:** the Precharge tab. "A corrected re-post shows REVISED; newer wins. An issued sheet is never reset."
32. **SAY:** "Three places, one record: the reports library; the PDF in the email; on a BWM plan, the project folder and
    close-out pack."
33. **CLICK/SHOW:** foot of PDF page 2: `Calculated: ______  Verified: ______`. "**Two signatures.** The generation
    timestamp is not a signature."
34. **SAY:** "All under MOC. Yours on the rig: a correct request, once; header and conditions checked; charging to the
    table for today's temperature; two signatures. The arithmetic is not yours, nor mine: check the request, ring us."

### Questions (09:50–10:00) `[Slide 6]`

35. Review questions 5.1 to 5.3 (answers at the end). Take answers round the room.

### If asked

- **"Calculator on the rig?"** No: the rig requests, the office calculates, checks and issues. Action list.
- **"No SSCE Equipment asset?"** Nothing in the calculator changes for a class; we show verified rigs under TRAINING
  wells.
- **"Our deck is 95 °F."** Page 3 table. Off the table: ring the office before charging.
- **"Who signs Verified?"** A second competent person in the office who did not work it up.

**Closing line:** "The tool's job is to stop a five-psi failure reaching your rig. Yours is the right request, once,
and charging to the table for the temperature in front of you. Back at 10:15."

---

# Module 6: the SACRED dashboards

**10:15–12:00 · Dan · `[Slide 7]` to `[Slide 13]`** · Pages: Rig Visit Dashboard, BOP Fleet Planning, CoC tracker, SSCE
Requests, `/sacred/aab/` (the Seadrill Bulletin Board) and the AABs tab. Ask SACRED AI on Dan's laptop only.

**By 12:00 they can:** find and print a report; read the stamp and the Errors button; read Rig Monitoring, the Heatmap
and a grade history (condition grade vs test result); find a rig's plan and break-ins; say where CoC figures come from
and where an SSCE request is raised; follow an AAB to acknowledgement and close; say Ask SACRED AI is not a record.

| Part | Minutes | Clock | Slide |
|---|---|---|---|
| 6.1 Orientation and the stamp | 8 | 10:15–10:23 | 7, 8 |
| 6.2 Report List, the full-report viewer, the Errors button | 12 | 10:23–10:35 | 8, 9 |
| 6.3 Rig Monitoring | 10 | 10:35–10:45 | 8 |
| 6.4 CBM Heatmap and the grade history | 12 | 10:45–10:57 | 9 |
| 6.5 The other tabs, one line each | 5 | 10:57–11:02 | 8 |
| 6.6 BOP Fleet Planning page | 15 | 11:02–11:17 | 10 |
| 6.7 CoC dashboard and SSCE requests | 10 | 11:17–11:27 | 11 |
| 6.8 The AAB tab and the Bulletin Board: advisory to acknowledgement | 20 | 11:27–11:47 | 12 |
| 6.9 Ask SACRED AI (Dan's laptop) | 8 | 11:47–11:55 | 13 |
| Questions and close | 5 | 11:55–12:00 | 13 |

**Before 10:15:** tabs open and Ctrl+F5: the dashboard, BOP Fleet Planning, CoC tracker (**local copy**), SSCE
Requests, the Bulletin Board rig and fleet compliance pages (office password typed at the break, never on screen),
Outlook, Ask SACRED AI. Stamp within ten minutes, or ring the office. The existing advisories to show are picked (see
the checklist).

## 6.1 Orientation (10:15–10:23) `[Slide 7]` then `[Slide 8]`

**They follow:** open the Rig Visit Dashboard. **Manual: How to find a report on the dashboard.**

1. **CLICK/SHOW:** the banner: **Ask SACRED AI**, **TSC Help Centre**, the "last scan" stamp.
   - **SAY:** "A script writes this page every ten minutes from every posted report. Nobody types into it. Wrong page,
     wrong report: re-post the report. Stamp over ten minutes old: the scanner has stopped; ring, do not refresh."
2. **CLICK/SHOW:** rig **SSCE Equipment**, **30 days**: the SSCE Equipment reports, including Monday's.
   - **SAY:** "Cannot find a report? Five checks: right rig? right date? what did the tool say after Post? posted over?
     still in the outbox (📤 waiting to send)? Then ring."

## 6.2 Report List, the full-report viewer, the Errors button (10:23–10:35) `[Slide 8]` then `[Slide 9]`

**They follow:** open the same CBM report in the viewer and scroll. **Manual: How to open and print a full report.**

3. **CLICK/SHOW:** the columns, and the OEM chip on a CBM sent to NOV.
4. **CLICK/SHOW:** a CBM report in the viewer: header, graded tasks and photographs, **Test records and documents
   attached**, NOV's usage table, sign-off. "The whole report; NOV get the same content. No second version."
5. **CLICK/SHOW:** **Print**: the PDF the office keeps, made from the posted file.
6. **CLICK/SHOW:** **Errors**: unreadable files, oversized files, help requests with no receipt.
   - **TRAP:** "Not a list of your mistakes. A failed BOP test is a report, not an error."

## 6.3 Rig Monitoring (10:35–10:45) `[Slide 8]`

**They follow:** open Rig Monitoring; find a tile. **Manual: How to read Rig Monitoring.**

7. **CLICK/SHOW:** the tiles; a rig's **Daily Checks and FLM** link. "Daily checks live here, not in the Report List; a
   failed or commented reading lifts the tile."
8. **TRAP, slowly:** "Needs attention counts things people wrote: a failed reading, a comment, a visit action still with
   the rig. Never a judgement the dashboard made."
9. **CLICK/SHOW:** a potable-water flush item if any: "There a tick is a record, not a pass."

## 6.4 CBM Heatmap and the grade history (10:45–10:57) `[Slide 9]`

**They follow:** open the CBM Heatmap; click any cell. **Manual: How to read the CBM Heatmap.**

10. **SAY the legend:** "Green 1–2, amber 3 monitor, red 4–5 fail, grey no grade. Three is where someone found
    something."
11. **CLICK/SHOW:** a cell's grade history. "One inspection is a snapshot; three are a trend. Grade honestly."
12. **CLICK/SHOW:** the SSCE Equipment Riser Adapter: the two tests graded **1 and 5**.
    - **TRAP:** "On a test NOV grade 1 pass, 5 fail. A 5 is a failed test to act on, not a condemned component."

## 6.5 The other tabs, one line each (10:57–11:02) `[Slide 8]`

13. **CLICK/SHOW:** **Compliance** (latest checklist, overdue visit actions, certificate expiry at 90 days);
    **Investigations, Failures, Lessons learned, R53 events**; **Precharge**; **AABs** (6.8). "Every row was posted
    from a tool."

## 6.6 The BOP Fleet Planning page (11:02–11:17) `[Slide 10]`

**They follow:** open the BOP Fleet Planning page; find West Vela. **Manual: How to read the BOP Fleet Planning page.**

14. **CLICK/SHOW:** globe, **Tile view**, **Map view**; West Vela's tile: % complete, BOP %, BOP ready date, latest
    Daily Summary Report. "This afternoon you see this tile from the other end."
15. **CLICK/SHOW:** **View schedule**, **Break-in Work**. "If a break-in is not here, it was not in the report."
16. **CLICK/SHOW:** the button to Argo Navis: "the door at 13:00".
    - **TRAP:** the page updates when the rig posts, not when a meeting agrees. Test plans show while test mode is on;
      they are marked test.

## 6.7 The CoC dashboard and SSCE requests (11:17–11:27) `[Slide 11]`

**They follow:** the projector (local copy). **Manual: How to use the CoC tracker and raise an SSCE request.**

17. **CLICK/SHOW:** KPI tiles, status split, vessel table. "Maximo is the master; this is a snapshot of its extract."
    - **TRAP:** "'No date on file' is not 'valid'. The dates are blank in Maximo; fix it there."
18. **CLICK/SHOW:** a vessel row: Maximo ID, certificate history, the part in Shared Capital; **Request** and the
    pre-filled SSCE form. **Do not submit.** "Raised here only; Central Spares approve on the SSCE Requests Dashboard;
    Argo Navis reads the approval back."
19. **CLICK/SHOW:** the SSCE Requests Dashboard: status, approver's comment.
    - **TRAP:** tracker annotations live in your own browser only. Shared things go in Maximo or Synergi.

## 6.8 The AAB tab and the Seadrill Bulletin Board (11:27–11:47) `[Slide 12]`

**They follow:** open `/sacred/aab/` and the AABs tab; look only, no Acknowledge. **Manual: How to acknowledge an AAB.**

**No new advisory is posted.** Show existing records. Only if a live post is essential: **SSCE Equipment** only, never a
real rig, never All rigs.

20. **SAY:** "An Alert, Advisory or Bulletin. Priority 3 only: information, no cost, no work order. Each crew's TSL
    acknowledges with a comment, and evidence when asked. The rig never closes it; Technical Services close."
21. **CLICK/SHOW:** an existing advisory (or **Load AAB file** of a saved draft and **Preview AAB**; no Post): number
    and revision, Priority 3, title, category, due date, SFI, evidence tick, **Applies to**, the three paragraphs, the
    **BULLETIN** badge. Then Outlook: the past AAB email. "Rig on To, never Cc."
22. **CLICK/SHOW:** the rig page for that advisory (Ctrl+F5): its state and which crews have acknowledged. Open
    **Acknowledge this advisory** and walk the fields (name, role **Technical Section Leader**, crew, date, comment,
    photographs); **close it without posting.** "Comment required every time; with evidence asked for, nothing
    attached is refused."
23. **CLICK/SHOW:** the fleet compliance page: **Awaiting your review**, the register row, the rig chip (who is left).
    Point at Close; do not press it. "Closing is a review decision, with a name and comment. Never automatic, never the
    rig's."
24. **CLICK/SHOW:** the AABs tab, the six states. "Overdue is a date. Partly acknowledged is one crew done. Both can be
    true."
    - **TRAP:** an AAB is not the Help Centre and not a failure report.

## 6.9 Ask SACRED AI (11:47–11:55) `[Slide 13]`

25. **SAY first:** "Lee and me only, until IT approve it. Do not press it on your laptop; it will not open."
26. **CLICK/SHOW:** ask "Which SSCE Equipment reports were posted on 19 October 2026, and what did the Riser Adapter
    inspection grade?"; read the answer and sources. Then "Which rigs graded a riser adapter task 4 or 5 in the last
    ninety days?"
27. **SAY:** "An answer, not a record. It says where it looked. Use it to find, not to decide."
    - **TRAP:** wrong or slow? "That is exactly why it is not the record." Do not argue with it.

### Questions and close (11:55–12:00)

28. Review questions 6.1 to 6.3.

### If asked

- **"Why can't I see my report?"** The five checks, then ring. Usually the wrong date, or the outbox.
- **"Can it email me when my rig posts?"** It already does where needed (precharge, CBM to OEM, AAB, help, Daily
  Summary). Others: action list.
- **"Who can see our reports?"** Everyone with dashboard access. A post is permanent and visible.

**Closing line:** "Every page this morning is a view of files the rigs posted. Fix the file and the page fixes itself.
Back at 13:00, Argo Navis landing page open."

---

# Module 7: Argo Navis: planning and executing Between Well Maintenance

**13:00–14:30 · Dan and Lee · `[Slide 14]` to `[Slide 23]`** · Argo Navis **REV 16**, `/sacred/dl1/`, `dryRun` test
mode (every email to Dan and Lee only, **[TEST MODE]**). Test plan **`WVE-BOP1-20261012`** (West Vela BOP1, marked
test), **open on the projector only**. Dan drives; Lee answers planning questions and chairs the hold point.

**By 14:30 they can:** say how a plan is saved and what the Server save chip says; read the Scope Challenge; say why SFI
331/332 drive BOP % and the BOP ready date; describe review, the freeze (Hold 1) and Refresh review; describe executing
(complete, break-in, checklist, chronology); state the daily reporting requirement; say what close-out produces.

| Part | Minutes | Clock | Slide |
|---|---|---|---|
| 7.1 The class rule, opening the plan, saving | 10 | 13:00–13:10 | 14, 15 |
| 7.2 Scope challenge, deferrals, SFI groups, BOP %, BOP ready date | 20 | 13:10–13:30 | 15, 16 |
| 7.3 Review by the regional reviewers and the scope freeze | 10 | 13:30–13:40 | 17 |
| 7.4 Executing: complete, break-ins, checklists, the chronology | 15 | 13:40–13:55 | 18 |
| 7.5 Post the first daily report, then the **HOLD POINT** | 15 | 13:55–14:10 | 19, 20, 21 |
| 7.6 Two routes: Argo Navis (BWM) and WCGRRT Planning Report (P6) | 5 | 14:10–14:15 | 22 |
| 7.7 Close-out and the close-out pack | 10 | 14:15–14:25 | 23 |
| Questions | 5 | 14:25–14:30 | 23 |

**Before 13:00:** badge **REV 16**; Maximo data loaded. Landing page → **Existing schedule** → **West Vela** → **Show
test plans**; note the stage (16 October: **Executing (v2)**; the script assumes frozen and executing). Plan bar:
**Server save ON**, **Test post** ticked. Sticky note: a task to complete, a ☑ **Checklist** task, a break-in area.
Help Centre on **Plans**, West Vela's card. `edocs/SAMPLE-closeout-pack.pdf` on the desktop. Lee has slides 19–21 and a
pen.

## 7.1 The class rule, opening the plan, saving (13:00–13:10) `[Slide 14]` then `[Slide 15]`

**They follow:** open `/sacred/dl1/`; look at the landing page and West Vela's plan list. **Do not press Open.**
**Manual: How to open and save an Argo Navis plan.**

1. **SAY:** "The one tool that builds the schedule itself: open PMs from Maximo, the order of work, the hours, the
   dates. Then the rig reports against it twice a day."
2. **SAY the class rule, slowly:** "Landing page only. An opened plan saves itself on each completed step and every 30
   minutes, and there is one save file. If you open it, you can overwrite mine."
   - **TRAP:** opened it by mistake? Close the tab now and tell Dan.
3. **CLICK/SHOW:** **New schedule** / **Existing schedule** → **West Vela** → **Show test plans**: BOP, plan, stage,
   saved by, saved at, copy. "Plan id: rig code, BOP, commencement date."
4. **CLICK/SHOW:** **Open** (projector only). The plan bar: id, scope version, **Frozen**, BOP ready chip, **Server save
   ON**, **💾 Save**, **Post for review**, **Freeze scope**, **Post daily report**, **Post close-out**, **Export**,
   **Refresh review**.
   - **TRAP:** "The copy on this PC is newer": choose **open the server copy**.
5. **CLICK/SHOW:** point at **💾 Save** and the chip; Save is pressed at 13:55, not now.
   - **SAY:** "Save keeps the plan at any stage; it also saves itself. A save is never a review. Each save replaces the
     last. Chip OFF always says why: opened from a file, no configuration, or the last save failed."

## 7.2 Scope challenge, deferrals, SFI groups, BOP %, BOP ready date (13:10–13:30) `[Slide 15]` then `[Slide 16]`

**They follow:** the projector. **Manual: How to challenge the scope and read the BOP ready date.**

6. **CLICK/SHOW:** **Scope Challenge**. "Every PM in the window arrives ticked Execute. Untick what you defer: what is
   genuinely getting done this time."
7. **CLICK/SHOW:** the boxes: Active in Maximo, Captured, Not captured, Added by hand. "Nothing quietly falls off."
8. **CLICK/SHOW:** a deferral, its reason, the **NC** column. "Past its Maximo due date it needs an NC reference; the
   schedule will not build without one."
   - **TRAP:** the milling question is answered on every plan; yes adds an annular inspection.
9. **CLICK/SHOW:** the SFI headings (331, 332, 302, 314, 315, 334–339): "by equipment code, not by who maintains it."
10. `[Slide 16]` **SAY:** "**SFI 331 and 332 are the BOP group**, with the BOP sequence from the beams to the drift
    test." **CLICK/SHOW:** **Schedule**, the BOP ready banner: date, need date, float. "Green inside the need date,
    amber within two days, red past it. Riser or MPD work does not hold the BOP."
11. **CLICK/SHOW:** **Simulate** (purple ribbon). Defer a BOP-group task: the date moves; a riser task: it does not.
    **Reset to the real plan.** "Nothing can be posted or saved from a simulation."
12. **SAY (coming, not in REV 16):** a BOP PM under NC left out of the window will show red at the freeze.

## 7.3 Review by the regional reviewers and the scope freeze (13:30–13:40) `[Slide 17]`

**They follow:** open the Help Centre, **Plans** tab, West Vela's card (read only). **Manual: How a plan is reviewed
and frozen.**

13. **SAY:** "**Post for review** sends the scope to SACRED: it emails the reviewers, opens the Teams chat, lists the plan
    on the Plans tab."
14. **CLICK/SHOW:** the card: region, required reviewers, "n of m verified", comments, versions. "A change makes a new
    version, and review starts again."
15. **SAY:** "**Hold 1: Freeze scope works only when every required reviewer has verified this version.** An override
    needs a name and reason and shows red. After the freeze, new work is break-in work."
16. **CLICK/SHOW:** **Refresh review**: "matters only before the freeze."
    - **TRAP:** nothing changing after the freeze is correct; **Post for review** is greyed on a frozen plan.
17. **If not frozen on the day:** show the record and say what Post for review and Freeze would do. Do not press them.

## 7.4 Executing: complete, break-ins, checklists, the chronology (13:40–13:55) `[Slide 18]`

**They follow:** the projector. **Manual: How to execute and update a BWM plan.**

18. **CLICK/SHOW:** **Execute & Report**: the **Now** line, milestone stars and key, Next 24 Hours.
19. **CLICK/SHOW:** the chosen task **Complete**, then **Calculate Project**: %, BOP % and dates re-forecast.
    - **TRAP:** "Type all percentages, then Calculate Project once. Nothing moves until you do."
20. **CLICK/SHOW:** ☑ **Checklist**: Done / N/A / Not OK, photographs, materials, **Performed by**, **Verified by**; close
    with ✕. "N/A and Not OK need a comment; Not OK asks for a CM or Synergi reference."
21. **CLICK/SHOW:** **Break-in Work**: area, SFI, the task it follows, hours, "TRAINING …". **BRK-nnn**; after Calculate
    Project the finish, float and BOP ready date move.
    - **SAY:** "No work order, no approval: the rig controls it, and reports it. The rig is the planner on the ground."
    - **TRAP:** "A delay is not a break-in. Waiting for a crane is Waiting / NPT, against the task it holds up."
22. **CLICK/SHOW:** the Deferrals & Non-Conformities table: every deferral listed and printed.

## 7.5 Post the first daily report, then the HOLD POINT (13:55–14:10) `[Slide 19]` `[Slide 20]` `[Slide 21]`

23. **CLICK/SHOW:** **Report Time (after shift handover)**; **Project & Rig People**; **Preview as SACRED prints it**.
    "The rig's own handover time. People filled once, updated at crew change."
24. **CLICK/SHOW:** **💾 Save**, then **Post daily report** (Dan only). Time on the whiteboard.
    - **SAY:** "**Hold 2: Post daily report only after the freeze.** Within about 35 minutes it is printed and emailed;
      in test mode to Lee and me only. We look at 14:45." **Manual: How to post the Daily Summary Report.**

**HOLD POINT: daily reporting requirements (15 minutes, discussion). Lee chairs the decisions; Dan writes them up.**

25. `[Slide 19]` **When and by whom.** **SAY:** "We stop here to agree the requirement, because from now on the rig
    sends this report, not the planner."
    - The rig posts the Daily Summary Report **twice a day, after each shift handover**, from Argo Navis.
    - The report time is the rig's own.
    - A red **Daily report due** chip shows on the plan bar when more than 14 hours have passed since the last one.
26. `[Slide 20]` **What is inside and who it goes to.** Read the slide, do not dwell:
    - **Inside:** the project header (rig, BOP, project type, data date and time, rig manager, OIM, TSL, DSL, subsea
      supervisor); maintenance day; original and current finish; plan variance and float to the BOP need date in
      hours; critical path and SIMOPS; project % and BOP % complete; milestones (baseline, estimated, actual);
      break-in work and delays; quality and rig reliability actions; lessons learned; work completed in the last
      cycle and planned for the next; general comments.
    - **Who it goes to:** emailed automatically with the PDF attached and a link to the full schedule on the BOP Fleet
      Planning page. **To:** the rig's rig manager, assistant rig manager, subsea supervisor, TSL, DSL, electrical
      supervisor and MPD supervisor, and the WCE office planning list. **Cc:** all TSC WCE Managers, Superintendents
      and Planners. A line also goes into the plan's Teams chat. No Gantt in the email: the schedule is on the
      dashboard.
    - **SAY:** "This was proven end to end on 16 October: a test report on this plan, printed and emailed as
      '[TEST MODE] West Vela BOP1 BWM Reporting 2026/10/17 0700'."
27. `[Slide 21]` **To agree.** Lee takes each line in turn; Dan fills the decisions table on the slide and in his
    copy; anything not settled goes on the action list with an owner and a date.

    | # | Decision | What to settle |
    |---|---|---|
    | 1 | Who on each rig posts it | A role, not a name: for example the subsea supervisor, with the TSL as back-up. |
    | 2 | The two report times per rig | The handovers: 0600/1800 or 0700/1900, per rig. |
    | 3 | What has to be correct before it is posted | Progress and actual finishes; any break-in work raised; the people on board for the crew in place. |
    | 4 | What happens when a report is late | Who notices (the Daily report due chip after 14 hours), who chases, by when. |
    | 5 | The planner's role once the rig posts | For example: reviews each report, maintains the Branch Map and durations, supports the rig. |
    | 6 | Form control | Does it keep PPDSR030918, at a new revision, for a system-made report? Who approves? |
    | 7 | P6 projects only: how the rig gets a fresh ERT for each report | One tab per report, named with its date (e.g. "Oct15 0700"), from the office planner. |

    - **SAY at the start:** "We are agreeing what the fleet does. If the room cannot agree a line in two minutes, it goes
      on the action list with an owner, and we move on."
    - **TRAP:** the discussion will drift into the content of the report or into P6. Bring it back: "Content is on
      slide 20 and is settled. We are agreeing who, when and what must be right first."
    - **TRAP:** timebox. At 14:10 stop, even if two lines are open. They go on the action list.

## 7.6 Two routes: Argo Navis (BWM) and WCGRRT Planning Report (P6) (14:10–14:15) `[Slide 22]`

28. **SAY:** "Two routes, one report. BWM posts from Argo Navis; P6 projects post WCGRRT's **Planning Report**
    (Discipline = Planning, same twice-daily rule, **Import ERT** fills it). Same print, same flow, same people; the
    tiles update from either."
    - **TRAP:** a P6 project has no plan chat, so no Teams line; the email carries the link.

## 7.7 Close-out and the close-out pack (14:15–14:25) `[Slide 23]`

**They follow:** open `edocs/SAMPLE-closeout-pack.pdf` from the pack. **Manual: How to close out a plan.**

29. **CLICK/SHOW:** **Post close-out**, greyed; **do not press it.** "Available when every task is complete and every
    deferral has a reason; it closes the plan with the eDocs reference."
30. **CLICK/SHOW:** the pack: cover, contents with dates and SHA-256 fingerprints, then the plan, checklist, tests, CBM,
    precharge, evidence, close-out. "Filed under 08 AAR and Close-out; to eDocs by hand until ISIT's connection."
31. **SAY:** "Open, challenge, build, post for review, verify, freeze, execute, report twice a day, close out, eDocs."
    `[Slide 15]` for ten seconds.

### Questions (14:25–14:30)

32. Review questions 7.1 to 7.3. **Before the break:** Dan closes the test plan.

### If asked

- **"Two people with the plan open?"** One save file; last save wins. Agree who holds the pen per shift (decision 1).
- **"Offline?"** Not yet; after ISIT's HTTPS (Module 9).
- **"The post fails?"** The error shows and the file saves to Downloads. Send both to the office.
- **"Is the BOP ready date the end of the plan?"** No: the finish of the BOP group.

**Closing line:** "The rig is now the planner on the ground. What you put in Argo Navis is what the fleet sees. Back at
14:45."

---

# Module 8: the loop, and the TSC Help Centre

**14:45–15:30 · Dan and Lee · `[Slide 24]` to `[Slide 27]`**

**By 15:30 they can:** draw the loop; say what is joined today and what is to come; say what a failure looks like at each
step and who sees it; follow a help request to the email, chat, receipt and acknowledgement.

| Part | Minutes | Clock | Slide |
|---|---|---|---|
| 8.0 Did the daily report arrive? | 2 | 14:45–14:47 | 24 |
| 8.1 How the tools connect today, and how the rest will be | 8 | 14:47–14:55 | 25 |
| 8.2 Help Centre, part 1: Dan posts one request | 5 | 14:55–15:00 | 27 |
| 8.3 What a failure looks like, and who sees it | 10 | 15:00–15:10 | 26 |
| 8.4 Help Centre, part 2: the email, the chat, the receipt, the acknowledgement | 15 | 15:10–15:25 | 27 |
| Questions and close | 5 | 15:25–15:30 | 27 |

## 8.0 Did the daily report arrive? (14:45–14:47) `[Slide 24]`

1. **CLICK/SHOW:** Outlook: `[TEST MODE] West Vela BOP1 BWM Reporting <date> <time>`, to Dan and Lee, PDF attached;
   open the PDF for ten seconds; click the dashboard link.
   - **If not arrived:** "Up to 35 minutes. We look again at 15:25; if still missing, it is a failure at one step of the
     loop, and I will show you how we find which."

## 8.1 How the tools connect today, and how the rest will be (14:47–14:55) `[Slide 25]`

2. **CLICK/SHOW:** draw it, one box at a time: **the tool → one file → the intake → the reports library → the scanner →
   the page → the notification with a link → the receipt.**
3. **SAY:** "Every loop in two days is this pattern. The file is the record; the dashboard is a view. Every
   notification links to the page and writes a receipt."
4. **SAY (Lee):** "Not joined yet: close-out pack into eDocs, PLATO cycle counts, Maximo CMs, tablets offline. Module 9."

## 8.2 Help Centre, part 1: Dan posts one request (14:55–15:00) `[Slide 27]`

**They follow:** open SSORT, **📨 Requests** tab; look, **do not post.** **Manual: How to raise a Technical Assistance
Request in SSORT.**

5. **SAY:** "For a problem that is not a report. It posts the same way a report does."
6. **CLICK/SHOW:** SSORT REV 169, rig **SSCE Equipment**, Request Type **Technical Assistance Request**: subject
   starting **TRAINING**, occurrence time, description, raised by, one photograph. **Post** (Dan only). Time on the
   board.
   - **TRAP:** the rig must read **SSCE Equipment** before Post (office only). On a real rig, the rig's people are
     emailed.

## 8.3 What a failure looks like, and who sees it (15:00–15:10) `[Slide 26]`

7. **SAY:** "Step by step, what a failure looks like and who sees it." Point at each box.

   | Step | What a failure looks like | Who sees it |
   |---|---|---|
   | The tool | WCGRRT and SSORT say under Post whether it posted. No connection: **📤 n waiting to send**; **Send now**. | The rig. |
   | Intake and library | No row on the dashboard after ten minutes. | The rig. |
   | The scanner | The stamp goes stale; the office is emailed within the hour; the Status page shows it. | The office first. |
   | The page | An unreadable or oversized file, on **Errors**. | Everyone. |
   | The notification | A **NOT SENT** email to the office with the request as text. | The office. |
   | The receipt | **No delivery receipt yet** in amber after 20 minutes; on Errors after an hour. | The office. |
   | Argo Navis | **Server save OFF** with its reason; failed post saved to Downloads; **Daily report due** after 14 h. | The rig; the office on the tile. |

8. **SAY:** "Nothing fails silently on the office side. On the rig, watch the outbox."
9. **CLICK/SHOW:** `/sacred/status/` for thirty seconds: scan time, each rig's last build (old = amber).

## 8.4 Help Centre, part 2 (15:10–15:25) `[Slide 27]`

**They follow:** the projector (office side is password-gated). **Manual: How the Help Centre answers a request.**

10. **CLICK/SHOW:** the TSC Help Centre (password typed with the projector frozen): Dan's request, **Sent to N at
    hh:mm** or **pending**. "Allow a quarter of an hour."
11. **CLICK/SHOW:** Outlook: the `[TEST MODE]` email, photograph attached, the red line naming who it would reach.
12. **CLICK/SHOW:** Teams: `[TEST] SSCE Equipment - <date> - …`. "On a real request, the help list and the rig's people."
13. **CLICK/SHOW:** **Acknowledge** it: who is dealing, a line of text. "Back under the same subject with RE:, into the
    same chat. The rig never looks anywhere new."
14. **CLICK/SHOW:** the receipt: to whom, how many, when, mode. "'We never got it' starts here."
15. **CLICK/SHOW:** close the request.
    - **TRAP:** "A question: Help Centre. An advisory to the fleet: AAB. BWM progress: Daily Summary Report."

### Questions and close (15:25–15:30)

16. Outlook again if the daily report was late. Review questions 8.1 to 8.3.

**If asked:** "Can the rig see the Help Centre?" They get the email, chat and acknowledgement; the office side is gated.
"The six-hour chat?" A rig-down request open six hours gets a chat with the downtime group and rig management,
automatically.

**Closing line:** "Post, scan, page, notification, receipt. If you can draw it, you can find any failure in it."

---

# Module 9: what is coming

**15:30–16:15 · Dan · `[Slide 28]`** · **By 16:15 they can** say what changes in the next six months, what does not,
and who owns each change.

| Part | Minutes | Clock |
|---|---|---|
| 9.1 On the rig | 15 | 15:30–15:45 |
| 9.2 In the office | 15 | 15:45–16:00 |
| 9.3 What does not change, and questions | 15 | 16:00–16:15 |

**SAY to open:** "Everything here has an owner and a plan. Nothing is a promise until it ships with a written note."

## 9.1 On the rig (15:30–15:45)

1. **Tablets, offline.** The outbox already works; SSORT and WCGRRT on tablets with no signal are built on the tools
   side. ISIT's HTTPS is the blocker (requested end of October), then a tablet test, then Intune.
2. **Argo Navis, NC deferrals at the freeze:** BOP PM under NC left out: red, reason required; other SFIs amber; open
   overdue with no NC: red. Sent to Lee 16 October; not built.
3. **Event and CBM PMs in every plan,** grouped by component.
4. **The rig's own work order slice** on a rig or tablet.
5. **Maximo CM work orders** (Manpreet has the request): until then unplanned work is a break-in.
6. **PLATO cycle counts** into the cavity and usage tables; needs an export or read-only account from Nick.

## 9.2 In the office (15:45–16:00)

7. **The scanner moves to the server** with a service account; nothing you do changes; date with ISIT.
8. **eDocs:** the pack is built; automatic copying needs ISIT's eDocs connector. By hand until then.
9. **The Fabric database:** scanner output as tables; Argo Navis plan tables next.
10. **The pages rebuilt, Ask SACRED AI for everyone:** Seadrill sign-in; same post target on day one; go-live early
    2027 with a two-page "what moved" first.
11. **Seadrill CORE (Lee):** standards as a linked map per rig; Thursday's work feeds it.

## 9.3 What does not change (16:00–16:15)

12. **SAY:** "The tools, the post, the ten-minute scan, the dashboard, the notifications, the precharge request and the
    PDF as the controlled document. Every change ships with a written note first."
13. Review questions 9.1 to 9.3. **If asked:** tablets: after HTTPS, a test, then Intune; links: possibly change once,
    with notice.

**Closing line:** "That is the next six months. Now the most important part of the day: what you want next."

---

# Module 10: feedback

**16:15–17:00 · All; Dan chairs, Lee takes the action list · `[Slide 29]` then `[Slide 30]`** · **By 17:00** each
delegate's points are on the action list with a name and a date.

| Part | Minutes | Clock |
|---|---|---|
| 10.1 The feedback sheet, in silence | 10 | 16:15–16:25 |
| 10.2 Round the room: what is hard on the rig today | 12 | 16:25–16:37 |
| 10.3 Round the room: what the tools should do next | 12 | 16:37–16:49 |
| 10.4 The UAT sign-off | 8 | 16:49–16:57 |
| 10.5 Close | 3 | 16:57–17:00 |

1. `[Slide 29]` **SAY:** "Ten minutes on your own: three things hard on the rig today; three things the tools should do
   next. Say what, not why."
2. **Round one:** one hard thing each; Lee writes it with a name and date.
   - **TRAP:** do not answer or defend. "Thank you, that is on the list." Debate is for Thursday.
3. **Round two:** one thing the tools should do next. Same list.
4. **UAT sign-off** (WCGRRT REV 174, SSORT REV 169, Argo Navis REV 16). Read the statements; each delegate signs their
   own line. "Not a test. If a line is not true for you, do not sign it; write why on the back."
5. `[Slide 30]` **SAY:** "Everything I showed today is in your Training Manual, step by step. Today's test request and
   report are removed from the library this week. On a real rig a post is permanent and visible. Tomorrow 08:00:
   technical standards." Collect the sheets and UAT forms.

**Closing line:** "Two days ago these were tools you were sent. Now you have seen them work end to end, and the list on
the wall is what we build next."

---

# Trainer's checklist for Tuesday morning (one page)

**Monday evening**

- [ ] Argo Navis: open **`WVE-BOP1-20261012`** on Dan's laptop only; stage (expected **Executing**); Server save ON;
      Test post ticked. Sticky note: task to complete, checklist task, break-in area. Close it.
- [ ] Help Centre Plans tab shows West Vela's card and reviewers.
- [ ] Desktop: `edocs/SAMPLE-closeout-pack.pdf`, the three precharge training files,
      `TRAINING-01_West-Tellus_issued_precharge.pdf`, one photograph for the help request.
- [ ] AAB: existing advisories picked (one partly acknowledged, one outstanding); a past AAB email found in Outlook.
- [ ] Ask SACRED AI opens on Dan's laptop.
- [ ] Training Manuals, one per delegate; feedback sheets; UAT forms naming REV 174 / 169 / REV 16.

**07:30 Tuesday**

- [ ] Badges: WCGRRT **REV 174**, SSORT **REV 169**, Argo Navis **REV 16**. Ctrl+F5 on every page.
- [ ] "Last scan" stamp within ten minutes, or ring the office before 08:00.
- [ ] Request form and Precharge Pro open; badge noted; Tellus reproduces **3,725 PSIG**.
- [ ] Tabs for 10:15: dashboard (SSCE Equipment, 30 days), BOP Fleet Planning, CoC (local copy), SSCE Requests,
      Bulletin Board rig and fleet pages, Outlook, Teams.
- [ ] Action list on the wall, Lee has the pen; slides 1–30 in order; slide 21's table blank.

**During the day**

- [ ] 08:00 and 13:00: the three rules (I drive, you post nothing; Argo Navis landing page only; MOC).
- [ ] 13:55: Save and Post daily report (Dan only); time on the board; Outlook at 14:45 and 15:25.
- [ ] 14:30: Dan closes the test plan. 14:55: Dan posts one help request on **SSCE Equipment**.
- [ ] 17:00: feedback sheets and UAT forms collected.

**After the class**

- [ ] Delete the help request from the reports library.
- [ ] Write up the hold point decisions; send to Lee with the action list.

---

# Answers to the review questions

**5.1 MAWHP 3,500 psi, minimum shear 5,200 PSIG: what does the form do, the likely cause, and why not reject it?** A
**warning**: check you read the column for your MASP, not the 15,000 psi column. It warns, not blocks, because the value
can legitimately be that high; the requester confirms.

**5.2 One shear passes, the second fails by −5 psi and −0.74 gal: can it be posted, and what can be done?** **No.** Post
to Dashboard is refused and nothing leaves the browser. Save, Export and PDF still work, for review. Never lower the
requirement until it passes.

**5.3 Sheet says 3,725 PSIG at 78 °F; the deck is 60 °F.** **Not 3,725.** Read 60 °F from the table on **page 3**.

**6.1 Stamp 07:40, time 08:30, you posted 08:05.** The scanner has stopped. Do not refresh; ring the office (they
already have an email). The post appears on the first scan after it restarts.

**6.2 Red Riser Adapter cell; grade 5 on a pressure test. Condemned?** No. On a test 1 is pass, 5 fail: a **failed
test** to act on, not a condition grade.

**6.3 A West Vela advisory shows "acknowledged". Who acts next; can the rig close it?** Technical Services review the
acknowledgements and evidence and close it with a name and comment. **The rig cannot close its own case.**

**7.1 Why did only the trainer open the test plan, and Save vs Post for review?** **One save file per plan**, and an
opened plan saves itself on each completed step and every 30 minutes, so several copies open overwrite each other.
**Save** keeps the plan; nobody is told. **Post for review** sends a scope version to SACRED: reviewers emailed, plan
chat opened, listed on the Plans tab.

**7.2 Two days after the freeze, a damaged hydraulic fitting must be replaced.** **Break-in Work**: BRK-nnn, no work
order or approval; it moves the finish, float, critical path and (in the BOP group) the BOP ready date, and goes in the
next Daily Summary Report. No new review. (A pure wait is Waiting / NPT.)

**7.3 Riser work finishes two days after the BOP stack. Does the BOP ready date move?** **No.** It uses the **BOP group
only**: SFI 331, 332 and the BOP sequence.

**8.1 The loop, eight boxes.** Tool; one file; intake; reports library; scanner; page; notification with a link;
receipt.

**8.2 Daily Summary posted 07:10, no email by 08:00: two places to look.** (1) **The dashboard:** the tile, and is the
stamp fresh? Stale: the office knows first. (2) **The tool:** an error, Server save OFF, a file in Downloads, the
outbox? The rig sees that first. A failed notification reaches the office as NOT SENT. Allow about 35 minutes.

**8.3 Which goes where: a CBM grade-button question; a bolt-batch advisory to every rig; twice-daily BWM progress.**
**TSC Help Centre**; an **AAB** (Priority 3, acknowledged by each rig's TSLs); the **Daily Summary Report** from Argo
Navis.

**9.1 What stops SSORT and WCGRRT opening on a tablet with no signal?** **HTTPS on the server**; ISIT own it, requested
for end of October.

**9.2 Once built, a BOP PM under NC left out at the freeze?** A **red critical flag**; a reason for each, details posted
for the reviewers; other SFIs amber. Not in REV 16.

**9.3 The scanner moves to the server: what changes for the rig?** Nothing in what you do. Date being confirmed with ISIT.
