# Day 2 trainer's script: Tuesday 20 October 2026

**Workshop:** WCE SME Technical Review and Open Workshop, Houston · **Day 2:** Training review, part 2: precharge,
dashboards, Argo Navis, the loop · **Presenter:** Dan Plant, with Lee Arnold for Argo Navis and the loop

**Builds on screen (frozen to Friday 23 October):** WCGRRT **REV 174**, SSORT **REV 169**, Argo Navis **REV 16**,
scanner **v3.11** (runs every 10 minutes), the dashboards and pages under `/sacred/` on
`http://sdrlazneuiis01d.corp.local:8080`. Precharge Pro as live on the day (the pack was built on **Rev 87**; check
the badge before 08:00).

## How to read this script

**This is a demonstration day.** Dan drives everything on the projector. Delegates follow on their own laptops: they
open the same page and look at the same thing, but they **post nothing, save nothing to the server, and press no Post,
Save, Post to OEM or Post AAB button.** Every step they would do for real is written up in the **Training Manual**; each
step below points at the guide ("Manual: How to …").

Each module keeps the same shape: time and presenter, what they should be able to do, a timing table, then numbered
steps. A step can carry:

- **SAY:** the key points, in plain words.
- **CLICK/SHOW:** the clicks on the projector, in order.
- **THE ROOM SEES:** what should be on the screen, so you know the click worked.
- **TRAP:** where people go wrong. Say it before they find it.
- **They follow:** what delegates open and look at on their laptops.

`[Slide n]` is the slide to have up, numbered to the Day 2 deck. If you run over, cut the "If asked" answers, not the
traps.

**If something does not work in front of the room:** say what you expected, say what you see, and say what you will
do about it. "I expected the report on the page within ten minutes. The stamp says the last scan was 09:40, so the
scanner is behind. I will ring the office at the break; we carry on." That is the lesson the tools exist to teach.

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

1. **I drive; you follow.** Open the page, look where I point. Nobody posts or saves anything today. The how-to for
   every step is in your Training Manual.
2. **Argo Navis: open the landing page, never the test plan.** An opened plan saves itself on each completed step and
   every 30 minutes, and the plan has one save file. Only I open it, on the projector.
3. **Everything is under MOC.** One line, every time it comes up: "That is managed under MOC; not today's subject."

---

# Opening (08:00–08:05)

`[Slide 1]` title. `[Slide 2]` the Day 2 agenda.

1. **SAY:** "Yesterday was the rig tools and the post. Today is what happens after the post: the precharge, the
   dashboards, the planning tool, and the loop that joins them. Then we stop and ask what you want next."
2. **SAY:** the three rules, from the slide. "I go through it; you follow on your laptop; the Training Manual has every
   step written down, so you do not need to take notes on the clicks."
3. **SAY:** "The action list is on the wall. Anything hard, wrong or missing goes on it, with a name. Thursday's forum
   argues from that list."

---

# Module 5: the precharge process

**08:05–10:00 · Dan · `[Slide 3]` to `[Slide 6]`**
**Tools:** the precharge request form (Rev 3, inside SSORT and as a standalone page), Precharge Pro, the issued sheet
and its PDF. **Pack:** `tools/received/training/precharge/` (module files, screenshots, the three training files, the
issued PDF).

### What they should be able to do by 10:00

- Say what a correct request needs, and name the three mistakes the form catches.
- Say what the calculation does with the request, and what it will not do (post a failing sheet).
- Read an issued sheet and its PDF: header, conditions, the number to charge to, the temperature table.
- Describe the loop after the post: who is emailed, what is attached, where the record lives, the two signatures.

### Timing

| Part | Minutes | Clock | Slide |
|---|---|---|---|
| 5.1 The request: the form and the three mistakes | 20 | 08:05–08:25 | 3, 4 |
| 5.2 The calculation: a clean run, a real failure, a dual stack | 35 | 08:25–09:00 | 4 |
| 5.3 Three rigs side by side (demonstration) | 20 | 09:00–09:20 | 6 |
| 5.4 The issued sheet and its PDF | 15 | 09:20–09:35 | 4 |
| 5.5 The loop, where the record lives, two signatures, under MOC | 15 | 09:35–09:50 | 5 |
| Questions | 10 | 09:50–10:00 | 6 |

### Before 08:00

- Request form (standalone) and Precharge Pro open on the projector laptop. Badge checked. Ctrl+F5.
- The three training files and `TRAINING-01_West-Tellus_issued_precharge.pdf` on the desktop.
- The Precharge tab of the Rig Visit Dashboard open; Outlook showing a past ISSUED email in test mode if you have one.
- **Every number below was produced by Rev 87.** If one does not reproduce on the day, find out why before teaching it.

---

## 5.1 The request (08:05–08:25) `[Slide 3]` then `[Slide 4]`

**They follow:** open the request form (standalone page). Look; do not make a file. **Manual: How to fill a precharge
request.**

1. **SAY:** "A precharge is only as good as the request. Every recalculation and delay we have had traces back to a
   field on this form, not to the arithmetic."
   - **CLICK/SHOW:** the empty form; then the **Guide** button. "If a rig asks what a field means, point them here."
   - **TRAP:** it is the request form, not "the Precharge Pro form". It shares no code with the calculator.
2. **CLICK/SHOW:** Rig, BOP, Well; **Requested by**.
   - **SAY:** "The BOP selector only appears on two-stack rigs. Put a person in Requested by, not a shared mailbox."
3. **CLICK/SHOW:** **Check my entries** on the empty form.
   - **THE ROOM SEES:** seven mandatory fields flagged: rig, well, minimum shear, MAWHP, water depth, subsea and deck
     temperature.
4. **CLICK/SHOW:** **Where it came from** (shear source); the two unit selectors.
   - **SAY:** "The form starts in metres and Celsius. Set the selectors first."
   - **TRAP:** 7,000 / 38 / 78 typed with the selectors on metric is 22,966 feet and two Celsius temperatures. It
     catches the office too.
5. **CLICK/SHOW:** **Well hop** and the depth list; pump cut-in and cut-out; the changes box.
   - **SAY:** "A hop lists every depth. Cut-in sits below cut-out. Anything changed on the stack goes in the box."

**The three mistakes, live. Read each warning out loud.**

6. **Wrong estimator column:** MAWHP **3,500**, shear **5,200**.
   - **THE ROOM SEES:** the warning about reading the 15,000 psi column.
   - **SAY:** "It warns, it does not block, because occasionally the number really is that high. It makes you look."
7. **Temperatures:** unit °F, subsea **4**; then deck **38**, subsea **50**.
   - **SAY:** "4 °F subsea is Celsius typed under Fahrenheit. Deck below subsea usually means they are swapped."
8. **Pumps:** cut-in **3,000**, cut-out **2,800**. "Cannot cut in above cut-out."
9. **The hard block:** Well hop = yes, list empty.
   - **SAY:** "Warnings make you look; errors stop you. Anything never valid blocks."
10. **CLICK/SHOW:** correct the fields and make the file (projector only).
    - **SAY:** "On a real job the rig posts this from SSORT. Today nothing is posted."
    - **TRAP:** the form is inside SSORT and standalone. Raise it once, from one place.

---

## 5.2 The calculation (08:25–09:00) `[Slide 4]`

**They follow:** open Precharge Pro, `http://sdrlazneuiis01d.corp.local:8080/sacred/precharge/` (password given out
loud only, never written). Select West Tellus and watch the hardware block fill. Type nothing else. **Manual: How to
read a precharge calculation.**

**Part A: West Tellus, a clean run (15 min)**

11. **CLICK/SHOW:** the revision in the header. "Check it every time: it tells you which method produced a sheet."
12. **CLICK/SHOW:** Asset **West Tellus**.
    - **SAY:** "Thirteen assets, each from its own OEM sizing document. Grey is rig hardware: not editable; a wrong
      value is a change request under MOC. White is per well."
13. **CLICK/SHOW:** well **`TRAINING-01 NOT ISSUED`**, 7,000 ft, subsea 38 °F, deck 78 °F, shear 2,600, MAWHP 3,900.
    - **SAY:** "A well called TRAINING is never a real sheet. There is no Calculate button: every keystroke reruns."
14. **CLICK/SHOW:** the green banner.
    - **THE ROOM SEES:** **SET PRECHARGE (DCB TABLE): 3,725 PSIG** / 3,740 PSIA @ 78 °F, **CHECKS PASS ✓**.
    - **SAY:** "3,725 PSIG at 78 °F is the answer. The yellow column is the one you charge to. Table value 3,704,
      rounded up to the nearest 25: never down."
15. **CLICK/SHOW:** the Method C drawdown block.
    - **SAY:** "Charge at 0, at depth at 1, the ram fires to 2. Condition 2: 4,045 at the ram against 2,600 required.
      P1 3,333 psia pairs only with the subsea temperature."

**Part B: a tubular it cannot shear (12 min). The most valuable minutes of the morning.**

16. **CLICK/SHOW:** shear to **4,105**. Nothing else.
    - **THE ROOM SEES:** red FAILS PER PRECHARGE TABLE: 4,045 vs 4,105; 46.4 gal vs 50.6 gal.
    - **SAY:** "A real open item. Two failures: 60 psi short and 4.2 gallons short. Either one stops the ram."
17. **CLICK/SHOW:** the green OPTIMUM banner: 3,900 PSIG; CSR closing 4,114 vs 4,105.
    - **TRAP:** the banner's last sentence still says "closes at 4,045". Stale text (F-68, cosmetic). **The right
      figure is 4,114.** Say it first.
18. **CLICK/SHOW:** the NOV Contractual Petrobras Checks panel.
    - **SAY, slowly:** "One cut passes. The second fails by **minus five psi and minus 0.74 of a gallon**. That is the
      argument for the tool: it finds the five-psi failure at two in the morning."
19. **CLICK/SHOW:** Save, Export, Generate PDF: "A failing sheet can go into review. It cannot go to the rig."
20. **CLICK/SHOW:** press **Post to Dashboard** on the failing sheet. It is refused; read the refusal from the slide:

    > THIS SHEET FAILS THE NOV CONTRACTUAL PETROBRAS CHECK. It cannot be posted to the dashboard: CSR + USR: pressure
    > 4159 vs 4164 PSIG required (-5), volume 100.46 vs 101.20 gal needed (-0.74); CSR + LSR: the same. Saving,
    > exporting and printing are still allowed - take it into review.

    - **SAY:** "Nothing left the browser. The answer is never to lower the requirement until it passes."
    - **TRAP:** dismiss the dialog. This is the only Post press of the morning, and only because it is refused. Set
      shear back to 2,600.

**Part C: West Neptune, dual stack (8 min)**

21. **CLICK/SHOW:** Asset **West Neptune**; `TRAINING-02 NOT ISSUED`; 6,500 ft; 40 / 78 °F; MAWHP 12,000. Point at
    the **BOP** selector and the shear preset 3,826.
    - **SAY:** "Read the label, not the position: the shear field is not the same on every rig family."
22. **CLICK/SHOW:** the Precharge Summary, one row per accumulator; then BOP 1 to 2. **Ask the room:** "What changed?"
    - **SAY:** "Only the header. Same hardware, one gas density. The selector files the sheet against the right stack."

---

## 5.3 Three rigs side by side (09:00–09:20) `[Slide 6]`

**They follow:** watch the projector; in Precharge Pro, select each rig as Dan does and look at the hardware block.
**Manual: How to read a precharge calculation** has all three cases written out.

23. **CLICK/SHOW:** **Load .json** for each training file from the desktop, in turn.

    | Rig | Training well | What the room sees |
    |---|---|---|
    | West Tellus | `TRAINING-01 NOT ISSUED` | **3,725 PSIG**, checks pass |
    | West Neptune BOP 1 | `TRAINING-02 NOT ISSUED` | per accumulator: Blue POD Pilot 5,156; Manifold Reg. Pilot 3,743; LMRP, Stack and Upper Annular Reg. Pilots 3,293 each (subsea, PSIG) |
    | West Gemini | `TRAINING-03 NOT ISSUED` | **4,750 PSIG** API optimum; BSR closes at 3,679 > 2,050 |

24. **SAY, for Gemini:** "Piston bottles, not DCBs, so no OEM table: the tool computes the API optimum. The method
    belongs to the equipment."
25. **SAY:** "When a number differs from what you expect, check two things first: the units left on metric, and the
    rig picked."
    - **TRAP:** nobody presses Post to Dashboard on a passing sheet. Rigs charge bottles against these numbers.

---

## 5.4 The issued sheet and its PDF (09:20–09:35) `[Slide 4]`

**They follow:** open `TRAINING-01_West-Tellus_issued_precharge.pdf` from the pack. **Manual: How to read an issued
precharge sheet.**

26. **CLICK/SHOW:** back on clean Tellus. The header, then the conditions block.
    - **SAY:** "Header: are you holding the right sheet? Conditions: check them against the request."
27. **CLICK/SHOW:** the PDF, page 1, then **page 3**, the precharge against temperature. Read the sentence:

    > "The accumulator holds a fixed gas charge. As the surface temperature is subject to change during the precharge
    > process, target the precharge for the ACTUAL temperature at that moment: read off the curve / table below."

    - **SAY:** "If it is 60 °F on deck, not 78, you read the table. You do not charge to 3,725 and hope."
    - **TRAP:** the temperature table is on **page 3**, not page 2.
28. **SAY:** "**The PDF is the controlled document.** Not the screen, not the email body, not a phone photo."
    - **TRAP:** that sentence is on the posted copy, not on the PDF. Do not hunt for it.
29. **CLICK/SHOW:** the filename. "The download uses underscores; the posted copy starts `Seadrill_` with hyphens.
    Same document (F-69)." Point at **Post to Dashboard**. **Do not click it.**

---

## 5.5 The loop, where the record lives, two signatures, under MOC (09:35–09:50) `[Slide 5]`

**They follow:** open the Rig Visit Dashboard, Precharge tab. **Manual: How a precharge is requested and issued.**

30. **CLICK/SHOW:** the slide's loop, one box at a time:
    1. The rig fills the request and posts it from SSORT.
    2. The scanner puts it in the office's precharge inbox within ten minutes; amber after 48 hours.
    3. The office is emailed (office only).
    4. The office opens it in the calculator, works it, checks it.
    5. The office posts the issued sheet. **The ISSUED email goes To the rig's subsea supervisor, TSL, assistant rig
       manager and rig manager, office on Cc, with the PDF and only the PDF.**
    6. The Precharge tab shows the issued sheet against the request.
    - **SAY:** "Rig people on To, never Cc: rigs filter Cc. The data file never goes in the email."
31. **CLICK/SHOW:** the Precharge tab. "A corrected re-post shows REVISED; the newer one wins. An issued sheet is never
    reset by a re-post."
32. **SAY:** "Three places, one record: the posted files in the reports library; the PDF in the email, which the rig
    works from; and on a BWM plan, the plan's project folder and close-out pack."
33. **CLICK/SHOW:** the foot of PDF page 2: `Calculated: ______  Verified: ______`.
    - **SAY:** "**Two signatures.** One works it up, a second checks it. The generation timestamp is not a signature."
34. **SAY:** "All of this is under MOC. What is yours on the rig: a correct request, once; the header and conditions
    checked; charging to the table for today's deck temperature; two signatures. The arithmetic is not yours, nor
    mine. If a number looks wrong, check the request and ring the office."

### Questions (09:50–10:00) `[Slide 6]`

35. Review questions 5.1 to 5.3 (answers at the end of this script). Take answers round the room.

### If asked

- **"Can we have the calculator on the rig?"** No. The rig requests; the office calculates, checks and issues. That is
  the two-signature control. Action list if you want it discussed.
- **"Why no SSCE Equipment asset?"** Nothing in the calculator changes for a class, so we show verified rigs under
  training well names.
- **"Our deck is 95 °F."** Read the page 3 table. Off the table: ring the office before charging.
- **"Who signs Verified?"** A second competent person in the office who did not work it up.

**Closing line:** "The tool's job is to stop a five-psi failure reaching your rig. Your job is the right request, once,
and charging to the table for the temperature in front of you. Back at 10:15."

---

# Module 6: the SACRED dashboards

**10:15–12:00 · Dan · `[Slide 7]` to `[Slide 13]`**
**Pages:** the Rig Visit Dashboard, `BOP Fleet Planning Dashboard.html`, the CoC tracker, `SSCE Requests
Dashboard.html`, `/sacred/aab/` (the Seadrill Bulletin Board) and the AABs tab. Ask SACRED AI on Dan's laptop only.

### What they should be able to do by 12:00

- Find a report, open it in the full-report viewer, and say how it is printed.
- Read the "last scan" stamp and the Errors button.
- Read Rig Monitoring, the CBM Heatmap and a grade history; tell a condition grade from a test result.
- Find a rig's plan and break-in work on the BOP Fleet Planning page.
- Say where CoC figures come from and where an SSCE request is raised and approved.
- Follow an AAB from advisory to acknowledgement to Technical Services' close.
- Say what Ask SACRED AI does, and that it is an answer, not a record.

### Timing

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

### Before 10:15

- Tabs open: Rig Visit Dashboard; BOP Fleet Planning; CoC tracker (**local copy**); SSCE Requests; the Bulletin Board
  rig page and fleet compliance page (office password typed at the break, never on screen); Outlook; Ask SACRED AI.
  Ctrl+F5 on each.
- The "last scan" stamp is within ten minutes. If not, ring the office before you start.
- Pick, in advance: one existing advisory with a crew acknowledged and one outstanding (an existing test AAB on SSCE
  Equipment or West Vela, or a live one), and a past AAB email in Outlook.

---

## 6.1 Orientation (10:15–10:23) `[Slide 7]` then `[Slide 8]`

**They follow:** open the Rig Visit Dashboard. **Manual: How to find a report on the dashboard.**

1. **CLICK/SHOW:** the banner: **Ask SACRED AI**, **TSC Help Centre**, the "last scan" stamp.
   - **SAY:** "A script writes this page every ten minutes from every posted report. Nobody types into it. If it is
     wrong, a report is wrong; fix the report by re-posting."
   - **SAY:** "Stamp more than ten minutes old: the scanner has stopped, and the office has an email within the hour.
     Do not keep refreshing; ring."
2. **CLICK/SHOW:** rig **SSCE Equipment**, **30 days**.
   - **THE ROOM SEES:** the SSCE Equipment reports, including Monday's.
   - **SAY:** "If you cannot find a report, five checks in order: right rig? right date? what did the tool say after
     Post? did someone post over it? is it still in the outbox (📤 waiting to send)? Then ring."

## 6.2 Report List, the full-report viewer, the Errors button (10:23–10:35) `[Slide 8]` then `[Slide 9]`

**They follow:** open the same CBM report in the viewer and scroll. **Manual: How to open and print a full report.**

3. **CLICK/SHOW:** the columns: date, rig, type, who, size, attachments, photographs, the OEM chip on a CBM to NOV.
4. **CLICK/SHOW:** one CBM report in the full-report viewer: header, graded tasks and photographs, **Test records and
   documents attached**, NOV's usage table, sign-off.
   - **SAY:** "This is the whole report. NOV get the same content by email. There is no second version."
5. **CLICK/SHOW:** **Print**. "The PDF the office keeps, from the posted file."
6. **CLICK/SHOW:** **Errors**.
   - **THE ROOM SEES:** unreadable files, files over the size ceiling, help requests with no delivery receipt.
   - **TRAP:** "Not a list of your mistakes. A failed BOP test is a report, not an error."

## 6.3 Rig Monitoring (10:35–10:45) `[Slide 8]`

**They follow:** open Rig Monitoring; find a rig's tile. **Manual: How to read Rig Monitoring.**

7. **CLICK/SHOW:** one tile per rig; then a rig's **Daily Checks and FLM** link.
   - **SAY:** "The superintendent's first page. Daily checks are kept out of the Report List on purpose; they are here,
     and a failed or commented reading lifts the tile."
8. **TRAP, slowly:** "Needs attention counts things people wrote: a failed reading, a commented reading, a visit action
   still with the rig. It is never a judgement the dashboard made."
9. **CLICK/SHOW:** a potable-water flush item if there is one. "There a tick is a record, not a pass."

## 6.4 CBM Heatmap and the grade history (10:45–10:57) `[Slide 9]`

**They follow:** open CBM Heatmap; click any cell. **Manual: How to read the CBM Heatmap.**

10. **CLICK/SHOW:** the Heatmap. **SAY the legend:** "Green 1–2 acceptable, amber 3 monitor, red 4–5 fail, grey no
    grade. Three is where someone found something."
11. **CLICK/SHOW:** a cell: the grade history. "One inspection is a snapshot; three are a trend. Grade honestly."
12. **CLICK/SHOW:** the SSCE Equipment Riser Adapter: condition grades, and the two tests graded **1 and 5**.
    - **TRAP:** "On a test, NOV grade 1 pass and 5 fail. A 5 on a test is a failed test to act on, not a condemned
      component."

## 6.5 The other tabs, one line each (10:57–11:02) `[Slide 8]`

13. **CLICK/SHOW** each for a few seconds: **Compliance** (latest checklist, overdue visit actions, certificate expiry
    at ninety days); **Investigations, Failures, Lessons learned, R53 events**; **Precharge** (seen at 09:40); **AABs**
    (6.8).
    - **SAY:** "Every row was posted from a tool. Nothing was typed into the dashboard."

## 6.6 The BOP Fleet Planning page (11:02–11:17) `[Slide 10]`

**They follow:** open `BOP Fleet Planning Dashboard.html`; find West Vela's tile. **Manual: How to read the BOP Fleet
Planning page.**

14. **CLICK/SHOW:** the globe, **Tile view**, **Map view**; West Vela's tile: % complete, BOP %, BOP ready date, the
    latest Daily Summary Report.
    - **SAY:** "This afternoon you see this tile from the other end, in Argo Navis."
15. **CLICK/SHOW:** **View schedule**, then **Break-in Work**.
    - **SAY:** "Break-in is unplanned work that interrupted the plan. If it is not here, it was not in the report."
16. **CLICK/SHOW:** the button that opens Argo Navis. "The door we go through at 13:00."
    - **TRAP:** "The page updates when the rig posts, not when a meeting agrees something."
    - **TRAP:** test plans show here while test mode is on. They are marked test; do not read them as a real rig.

## 6.7 The CoC dashboard and SSCE requests (11:17–11:27) `[Slide 11]`

**They follow:** look at the projector (the tracker is shown from a local copy). **Manual: How to use the CoC tracker
and raise an SSCE request.**

17. **CLICK/SHOW:** the CoC tracker: KPI tiles, status split, table by vessel.
    - **SAY:** "The master record is Maximo; the tracker is a snapshot of the Maximo extract."
    - **TRAP:** "'No date on file' is not 'valid'. The dates are blank in Maximo; the fix is in Maximo."
18. **CLICK/SHOW:** one vessel, one row: Maximo ID, certificate history, the same part in Shared Capital; the
    **Request** button and the pre-filled SSCE form. **Do not submit.**
    - **SAY:** "An SSCE request is raised here only. Central Spares approve it on the SSCE Requests Dashboard; Argo
      Navis reads the approval back."
19. **CLICK/SHOW:** `SSCE Requests Dashboard.html`: status and approver's comment.
    - **TRAP:** tracker annotations live in your own browser only. Anything shared goes in Maximo or Synergi.

## 6.8 The AAB tab and the Seadrill Bulletin Board (11:27–11:47) `[Slide 12]`

**They follow:** open `/sacred/aab/` and the dashboard's AABs tab; look only. Do not press Acknowledge. **Manual: How to
acknowledge an AAB.**

**No new advisory is posted today.** Show existing records. Only if a live post is essential, post on **SSCE
Equipment** only, never a real rig and never All rigs.

20. **SAY:** "An AAB is an Alert, Advisory or Bulletin. This board carries Priority 3 only: for information, no cost,
    no work order. Each crew's Technical Section Leader acknowledges with a comment, and attaches evidence when asked.
    The rig never closes an advisory; Technical Services close."
21. **CLICK/SHOW:** an existing advisory's content (open the record, or **Load AAB file** of a saved draft into the
    create page and **Preview AAB**; do not Post). Walk it: number and revision, Priority 3, title, category, due
    date, SFI, the evidence tick, **Applies to**, the three paragraphs, the bulletin with its **BULLETIN** badge.
    - **CLICK/SHOW:** Outlook: the past AAB email. "On a real advisory the rig is on To, never Cc."
22. **CLICK/SHOW:** the rig page for the advisory you picked. Ctrl+F5.
    - **THE ROOM SEES:** its state, and which crews have acknowledged.
    - **CLICK/SHOW:** open **Acknowledge this advisory** and walk the fields: name, role **Technical Section Leader**,
      crew, date, comment, photographs. **Close it without posting.**
    - **SAY:** "The comment is required every time. With evidence asked for, it refuses an acknowledgement with
      nothing attached."
23. **CLICK/SHOW:** the fleet compliance page: **Awaiting your review**, the register row, the rig chip (who is left).
    - **SAY:** "Technical Services review both crews and the evidence, then close it with a name and a comment.
      Closing is a review decision, never automatic, never the rig's." Point at Close; do not press it.
24. **CLICK/SHOW:** the dashboard's **AABs** tab and the six states in the legend.
    - **SAY:** "Overdue is a date: any open state past due. Partly acknowledged is one crew done. Both can be true."
    - **TRAP:** the AAB is not the Help Centre and not a failure report. A question goes to the Help Centre.

## 6.9 Ask SACRED AI (11:47–11:55) `[Slide 13]`

25. **SAY first:** "This opens for Lee and me only, until IT approve it. Do not press it on your laptop; it will not
    open, and the dashboard is not broken."
26. **CLICK/SHOW:** on Dan's laptop: "Which SSCE Equipment reports were posted on 19 October 2026, and what did the
    Riser Adapter inspection grade?" Read the answer and the sources. Then: "Which rigs graded a riser adapter task 4 or
    5 in the last ninety days?"
27. **SAY:** "It is an answer, not a record. It says where it looked; the report is the record. Use it to find, not to
    decide."
    - **TRAP:** if it is wrong or slow: "That is exactly why it is not the record." Do not argue with it.

### Questions and close (11:55–12:00)

28. Review questions 6.1 to 6.3.

### If asked

- **"Why can't I see my report?"** The five checks, then ring. Most often the wrong date, or still in the outbox.
- **"Can the dashboard email me when my rig posts?"** The notifications already do it where needed (precharge, CBM to
  OEM, AAB, help requests, Daily Summary Report). Others: action list.
- **"Who can see our reports?"** Everyone with dashboard access. A post is permanent and visible.
- **"Can a rig close its own AAB?"** No. The rig acknowledges; Technical Services close.

**Closing line:** "Every page this morning is a view of files the rigs posted. Fix the file and the page fixes itself.
Back at 13:00, laptops on, Argo Navis landing page open."

---

# Module 7: Argo Navis: planning and executing Between Well Maintenance

**13:00–14:30 · Dan and Lee · `[Slide 14]` to `[Slide 23]`**
**Tool:** Argo Navis **REV 16**, `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/`, in `dryRun` test mode (every
email goes to Dan and Lee only, marked **[TEST MODE]**). **Test plan:** West Vela BOP1, **`WVE-BOP1-20261012`**
(marked test), opened on the projector only.

**Roles.** Dan drives and is the only person with the test plan open. Lee answers planning questions and chairs the
hold point.

### What they should be able to do by 14:30

- Say how a plan is saved (Save, automatic saves, one file per plan) and what the Server save chip tells them.
- Read the Scope Challenge: deferrals and their reasons, SFI groups.
- Say why SFI 331 and 332 drive BOP % and the BOP ready date, and why riser or MPD work does not.
- Describe review by the regional reviewers, the scope freeze (Hold 1) and Refresh review.
- Describe executing: complete, break-in, checklist, the chronology.
- State the daily reporting requirement agreed at the hold point.
- Say what close-out does and what goes into the close-out pack.

### Timing

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

### Before 13:00 (at lunch)

- Argo Navis on the projector: badge **REV 16**; status strip shows Maximo data loaded.
- Landing page → **Existing schedule** → **West Vela** → **Show test plans**. Note the stage of `WVE-BOP1-20261012`
  (16 October: **Executing (v2)**). The script assumes frozen and executing; review and freeze are shown from the record.
- Plan bar: **Server save ON**; **Test post** ticked; BOP ready chip showing.
- On a sticky note: one in-progress task to complete, one task with a ☑ **Checklist**, one area and task for a break-in.
- Help Centre on the **Plans** tab, West Vela's card. `edocs/SAMPLE-closeout-pack.pdf` on the desktop.
- Lee has slides 19 to 21 and a pen for the decisions table.

---

## 7.1 The class rule, opening the plan, saving (13:00–13:10) `[Slide 14]` then `[Slide 15]`

**They follow:** open `/sacred/dl1/` and look at the landing page and the list of West Vela plans. **Do not press Open.**
**Manual: How to open and save an Argo Navis plan.**

1. **SAY:** "The one tool on the fleet that builds the schedule itself: it reads the rig's open PMs from Maximo, orders
   the work, stacks the hours and gives you dates. Then the rig reports against it twice a day."
2. **SAY the class rule, slowly:** "Open the landing page; do not open the test plan. An opened plan saves itself on
   each completed step and every 30 minutes, and there is one save file. If you open it, you can overwrite mine."
   - **TRAP:** if anyone has opened it by mistake, they close the tab straight away and tell Dan.
3. **CLICK/SHOW:** the landing page: **New schedule**, **Existing schedule** → **West Vela** → **Show test plans**.
   - **THE ROOM SEES:** BOP, plan, stage, saved by, saved at, copy (Server or this PC); `WVE-BOP1-20261012`, **test**.
   - **SAY:** "The plan id is rig code, BOP and commencement date."
4. **CLICK/SHOW:** **Open** (projector only).
   - **THE ROOM SEES:** the plan on Execute & Report. The plan bar: plan id, scope version, **Frozen**, BOP ready chip,
     **Server save ON**, **💾 Save**, **Post for review**, **Freeze scope**, **Post daily report**, **Post close-out**,
     **Export**, **Refresh review**.
   - **TRAP:** "The copy on this PC is newer than the server copy": choose **open the server copy**.
5. **CLICK/SHOW:** point at **💾 Save** and the **Server save** chip. Do not press Save yet; it is pressed at 13:55.
   - **SAY:** "Save keeps the plan at any stage; it also saves itself on each completed step and every 30 minutes. A save
     is never a review. One file per plan: each save replaces the last."
   - **SAY:** "If the chip says OFF, it says why: opened from a file, no configuration, or the last save failed. Never
     silent. A copy is always kept on this PC too."

## 7.2 Scope challenge, deferrals, SFI groups, BOP %, BOP ready date (13:10–13:30) `[Slide 15]` then `[Slide 16]`

**They follow:** the projector. **Manual: How to challenge the scope and read the BOP ready date.**

6. **CLICK/SHOW:** the **Scope Challenge** tab.
   - **SAY:** "Every PM in the window arrives ticked Execute. Untick what you defer. That is the scope challenge: what is
     genuinely getting done this time."
7. **CLICK/SHOW:** the boxes: Active in Maximo, Captured (execute and deferred), Not captured, Added by hand. "Nothing
   quietly falls off the list."
8. **CLICK/SHOW:** a deferred work order, its reason, the **NC** column.
   - **SAY:** "A deferral needs a reason. Past its Maximo due date it needs a Maximo NC reference, and the schedule will
     not build until every ticked NC has one."
   - **TRAP:** the milling question is answered on every plan. Yes adds an annular inspection.
9. **CLICK/SHOW:** the SFI headings: 331, 332, 302, 314, 315, 334 to 339.
   - **SAY:** "Grouped by equipment code, not by who maintains it."
10. `[Slide 16]` **SAY:** "**SFI 331 and 332 are the BOP group**, with the BOP sequence from landing on the beams to the
    drift test."
    - **CLICK/SHOW:** **Schedule** tab, the BOP ready banner: date, need date, float.
    - **SAY:** "BOP % and the BOP ready date use the BOP group only. Green inside the need date, amber within two days,
      red past it."
11. **CLICK/SHOW:** **Simulate** (purple striped ribbon). Defer one BOP-group task: the BOP ready date moves. Defer a
    riser task: it does not. **Reset to the real plan.**
    - **SAY:** "Nothing can be posted, saved or downloaded from a simulation."
12. **SAY (coming, not in REV 16):** "A BOP PM under an NC left out of the window will show a red critical flag at the
    freeze, with a reason required."

## 7.3 Review by the regional reviewers and the scope freeze (13:30–13:40) `[Slide 17]`

**They follow:** open the Help Centre, **Plans** tab, West Vela's card (read only). **Manual: How a plan is reviewed
and frozen.**

13. **SAY:** "With the scope challenged and the schedule built, the rig presses **Post for review**. SACRED emails the
    reviewers, opens the plan's Teams chat and lists it on the Plans tab."
14. **CLICK/SHOW:** the Plans tab card: region, required reviewers, who verified, "n of m verified", comments, versions.
    - **SAY:** "A requested change makes a new scope version, and review starts again on it."
15. **CLICK/SHOW:** in Argo Navis, the state beside the plan id.
    - **SAY:** "**Hold 1: Freeze scope works only when every required reviewer has verified this version.** An override
      needs a name and a reason and shows red. After the freeze, new work is break-in work."
16. **CLICK/SHOW:** **Refresh review**.
    - **SAY:** "It re-reads the review state; it matters only before the freeze."
    - **TRAP:** nothing changing after the freeze is correct. **Post for review** is greyed on a frozen plan.
17. **If the plan is not frozen on the day:** show the record on the Plans tab and say what Post for review and Freeze
    scope would do. Do not press them.

## 7.4 Executing: complete, break-ins, checklists, the chronology (13:40–13:55) `[Slide 18]`

**They follow:** the projector. **Manual: How to execute and update a BWM plan.**

18. **CLICK/SHOW:** **Execute & Report**: dates, the yellow **Now** line, numbered milestone stars, the key; Next 24 Hours.
19. **CLICK/SHOW:** the chosen task: **Complete**; then **Calculate Project**.
    - **THE ROOM SEES:** % complete, BOP % and dates re-forecast.
    - **TRAP:** "Type all percentages first, then Calculate Project once. Nothing moves until you do."
20. **CLICK/SHOW:** ☑ **Checklist** on the chosen task: Done / N/A / Not OK, photographs, materials, **Performed by**,
    **Verified by**. Close with ✕.
    - **SAY:** "N/A and Not OK need a comment; Not OK asks for a CM or Synergi reference. The checklist % drives the task."
21. **CLICK/SHOW:** **Break-in Work**: area, SFI, the task it follows, hours, description starting "TRAINING".
    - **THE ROOM SEES:** **BRK-nnn**; after Calculate Project, the finish, float and BOP ready date move.
    - **SAY:** "After the freeze the rig controls new work: no work order, no approval. Every break-in goes in the daily
      report. The rig is now the planner on the ground."
    - **TRAP:** "A delay is not a break-in. Waiting for a crane goes in Waiting / NPT, against the task it holds up."
22. **CLICK/SHOW:** the Deferrals & Non-Conformities table. "Every deferral is listed and printed in the report."

## 7.5 Post the first daily report, then the HOLD POINT (13:55–14:10) `[Slide 19]` `[Slide 20]` `[Slide 21]`

23. **CLICK/SHOW:** **Report Time (after shift handover)**; **Project & Rig People**; **Preview as SACRED prints it**.
    - **SAY:** "The report time is the rig's own handover. People are filled once and updated at crew change."
24. **CLICK/SHOW:** **💾 Save**, then **Post daily report** (Dan only). Write the time on the whiteboard.
    - **THE ROOM SEES:** "Saved to server …", then the post confirmation.
    - **SAY:** "**Hold 2: Post daily report only after the freeze.** Within about 35 minutes it is printed from WCGRRT's
      template and emailed. In test mode, to Lee and me only. We look for it at 14:45."

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

28. **SAY:** "Two routes, one report. BWM plans post from Argo Navis. P6 projects post WCGRRT's **Planning Report**:
    Discipline = Planning, the same twice-daily rule, and **Import ERT** fills it from the P6 export. Same printed
    report, same flow, same people; the BOP Fleet Planning tiles update from either."
    - **TRAP:** a P6 project has no plan chat, so no Teams line. The email carries the link.
    - **Manual: How to post a Planning Report from WCGRRT (P6 projects).**

## 7.7 Close-out and the close-out pack (14:15–14:25) `[Slide 23]`

29. **CLICK/SHOW:** **Post close-out**, greyed. **Do not press it.**
    - **SAY:** "Available when every task is complete and every deferral has a reason. It closes the plan with the eDocs
      reference. Our plan is mid-job."
30. **CLICK/SHOW:** `edocs/SAMPLE-closeout-pack.pdf`: the cover, the contents sheet with dates and SHA-256
    fingerprints, then the plan, checklist, tests, CBM, precharge, evidence and close-out.
    - **SAY:** "SACRED joins every record for the plan into one pack, under 08 AAR and Close-out. That goes to eDocs; by
      hand until ISIT set up the connection."
31. **SAY:** "The life of a plan: open, challenge the scope, build, post for review, verify, freeze, execute, report
    twice a day, close out, pack to eDocs." `[Slide 15]` for ten seconds.
    - **Manual: How to close out a plan.**

### Questions (14:25–14:30)

32. Review questions 7.1 to 7.3. **Before the break:** Dan closes the test plan on the projector.

### If asked

- **"Two people on the rig with the plan open?"** One save file: the last save wins. Agree who holds the pen per shift
  (decision 1).
- **"Can we work offline?"** Not yet; it comes after ISIT's HTTPS (Module 9).
- **"What if the post fails?"** The tool shows the error and saves the file to Downloads. Send both to the office.
- **"Does a break-in need a work order?"** No. If it becomes real corrective work, raise the CM in Maximo.
- **"Is the BOP ready date the end of the plan?"** No: the finish of the BOP group.

**Closing line:** "The rig is now the planner on the ground. What you put in Argo Navis is what the fleet sees. Back at
14:45."

---

# Module 8: the loop, and the TSC Help Centre

**14:45–15:30 · Dan and Lee · `[Slide 24]` to `[Slide 27]`**

### What they should be able to do by 15:30

- Draw the loop: tool, file, intake, library, scanner, page, notification with a link, receipt.
- Say how the tools connect today, what is still to come, and what a failure looks like at each step.
- Follow a help request to the email, the Teams chat, the receipt and the acknowledgement.

### Timing

| Part | Minutes | Clock | Slide |
|---|---|---|---|
| 8.0 Did the daily report arrive? | 2 | 14:45–14:47 | 24 |
| 8.1 How the tools connect today, and how the rest will be | 8 | 14:47–14:55 | 25 |
| 8.2 Help Centre, part 1: Dan posts one request | 5 | 14:55–15:00 | 27 |
| 8.3 What a failure looks like, and who sees it | 10 | 15:00–15:10 | 26 |
| 8.4 Help Centre, part 2: the email, the chat, the receipt, the acknowledgement | 15 | 15:10–15:25 | 27 |
| Questions and close | 5 | 15:25–15:30 | 27 |

## 8.0 Did the daily report arrive? (14:45–14:47) `[Slide 24]`

1. **CLICK/SHOW:** Outlook.
   - **THE ROOM SEES:** `[TEST MODE] West Vela BOP1 BWM Reporting <date> <time>`, to Dan and Lee, PDF attached, the
     dashboard link. Open the PDF for ten seconds; click the link.
   - **If not arrived:** "It can take 35 minutes. We look again at 15:25. If it is still missing, that is a failure at
     one step of the loop, and I will show you how we find which."

## 8.1 How the tools connect today, and how the rest will be (14:47–14:55) `[Slide 25]`

2. **CLICK/SHOW:** draw on the whiteboard, one box at a time: **the tool → one file → the intake → the reports library →
   the scanner → the page → the notification with a link → the receipt.**
3. **SAY:** "Every loop in two days is that one pattern: daily report, CBM to NOV, precharge, AAB, Argo Navis, help
   request. The file is the record; the dashboard is a view. Every notification links to the page. Every notification
   writes a receipt."
4. **SAY (Lee):** "Not joined yet: the close-out pack into eDocs, PLATO cycle counts, Maximo CMs into the plan, tablets
   offline. Module 9 has the dates."

## 8.2 Help Centre, part 1: Dan posts one request (14:55–15:00) `[Slide 27]`

**They follow:** open SSORT and find the help request page. Look; **do not post.** **Manual: How to raise a TSC Help
Centre request.**

5. **SAY:** "The Help Centre is for a problem that is not a report: a tool, equipment or dashboard question. It posts
   the same way a report does."
6. **CLICK/SHOW:** in SSORT REV 169, asset **SSCE Equipment**: title starting **TRAINING**, category, two lines, one
   photograph. **Post** (Dan only). Write the time on the board.
   - **SAY:** "SSCE Equipment means the email and chat go to the office only."
   - **TRAP:** check the asset reads **SSCE Equipment** before Post. On a real rig name, the rig's people are emailed.

## 8.3 What a failure looks like, and who sees it (15:00–15:10) `[Slide 26]`

7. **SAY:** "Step by step, what a failure looks like and who sees it." Point at each box.

   | Step | What a failure looks like | Who sees it |
   |---|---|---|
   | The tool | WCGRRT and SSORT say under Post whether it posted. With no connection: **📤 n waiting to send**; press **Send now**. | The rig, on screen. |
   | Intake and library | No row on the dashboard after ten minutes. | The rig, on the dashboard. |
   | The scanner | The "last scan" stamp goes stale; the office is emailed within the hour; the Status page shows it. | The office first. |
   | The page | An unreadable or oversized file, on the **Errors** button. | Everyone. |
   | The notification | A **NOT SENT** email to the office with the request as text; the receipt says so. | The office. |
   | The receipt | **No delivery receipt yet** in amber after 20 minutes; after an hour, on the Errors button. | The office. |
   | Argo Navis | **Server save OFF** with its reason; a failed post saves to Downloads; **Daily report due** after 14 hours. | The rig; the office on the tile. |

8. **SAY:** "Nothing fails silently on the office side. On the rig side, watch the outbox."
9. **CLICK/SHOW:** `/sacred/status/` for thirty seconds: scan time, the build each rig last posted from (old = amber).

## 8.4 Help Centre, part 2 (15:10–15:25) `[Slide 27]`

**They follow:** the projector (the office side is password-gated). **Manual: How the Help Centre answers a request.**

10. **CLICK/SHOW:** the TSC Help Centre from the dashboard button (password typed with the projector frozen).
    - **THE ROOM SEES:** Dan's request with **Sent to N at hh:mm** (or **pending** in the first twenty minutes).
    - **SAY:** "Allow up to a quarter of an hour: the scanner reads every ten minutes and the flow polls."
11. **CLICK/SHOW:** Outlook: the `[TEST MODE]` email, photograph attached, the red line naming who it would have gone to.
12. **CLICK/SHOW:** Teams: `[TEST] SSCE Equipment - <date> - …`, the request as first message.
    - **SAY:** "On a real request the chat includes the help list and the rig's people."
13. **CLICK/SHOW:** **Acknowledge** Dan's request: who is dealing with it, a line of text.
    - **SAY:** "It comes back under the same subject with RE:, and into the same chat. The rig never looks anywhere new."
14. **CLICK/SHOW:** the receipt: to whom, how many, when, mode (test). "Proof of what was sent. 'We never got it' starts
    here."
15. **CLICK/SHOW:** close Dan's request.
    - **TRAP:** "A question goes to the Help Centre. An advisory to the fleet is an AAB. Progress on a BWM plan is the
      Daily Summary Report."

### Questions and close (15:25–15:30)

16. Check Outlook for the daily report if it had not arrived. Review questions 8.1 to 8.3.

### If asked

- **"Can the rig see the Help Centre page?"** The rig gets the email, chat and acknowledgement; the office side is
  password-gated.
- **"What is the six-hour chat?"** A rig-down request open after six hours gets a chat with the downtime group and the
  rig's management. Automatic.

**Closing line:** "One pattern: post, scan, page, notification, receipt. If you can draw it, you can find any failure in
it. Next: what is coming."

---

# Module 9: what is coming

**15:30–16:15 · Dan · `[Slide 28]`**

### What they should be able to do by 16:15

Say what changes on the rig and in the office in the next six months, what does not, and who owns each change.

| Part | Minutes | Clock |
|---|---|---|
| 9.1 On the rig | 15 | 15:30–15:45 |
| 9.2 In the office | 15 | 15:45–16:00 |
| 9.3 What does not change, and questions | 15 | 16:00–16:15 |

**SAY to open:** "Everything here has an owner and a plan. Where a date depends on someone outside this room, I say so.
Nothing is a promise until it ships with a written note to you first."

## 9.1 On the rig (15:30–15:45)

1. **Tablets, offline.** "The outbox already holds a post when the signal drops. Next: SSORT and WCGRRT on iPads and
   Android tablets with no signal. The tools side is built; ISIT's HTTPS on the server is the blocker (requested for
   end of October). Then a tablet test, then Intune."
2. **Argo Navis: NC deferrals at the freeze.** "A BOP PM under NC left out of the window: red critical flag and a
   reason. Other SFIs amber. Open overdue work orders with no NC: red. Sent to Lee on 16 October; not built."
3. **Event and CBM PMs in every plan,** grouped by component.
4. **The rig's own work order slice** on a rig or tablet, instead of the whole fleet's.
5. **Maximo corrective work orders.** "Today only PMs come through; unplanned work is a break-in. Manpreet has the
   request for CM rows and original target dates."
6. **PLATO cycle counts.** "Cycle counts and NOV's usage table filled from PLATO, not by hand. Needs a scheduled export
   or read-only account from Nick."

## 9.2 In the office (15:45–16:00)

7. **The scanner moves to the server** with a service account. Nothing you do changes. Date being confirmed with ISIT.
8. **eDocs.** The close-out pack is built today; automatic copying with a Project complete button needs ISIT's eDocs
   connector. Filed by hand until then.
9. **The Fabric database.** Everything the scanner reads is exported as tables; Argo Navis plan tables are next.
10. **The pages rebuilt, Ask SACRED AI for everyone.** A hosted platform with Seadrill sign-in; tools post to the same
    place on day one; production go-live planned early 2027, with a two-page "what moved" before it.
11. **Seadrill CORE (Lee).** The company-wide app for Technical Services' standards: the same globe; a click on a rig
    opens its requirements as a linked map. Thursday's standards work feeds it.

## 9.3 What does not change (16:00–16:15)

12. **SAY:** "The tools, the post, the ten-minute scan, the dashboard, the notifications, the precharge request and the
    PDF as the controlled document. Every change ships with a written note first."
13. Review questions 9.1 to 9.3.

### If asked

- **"When do we get tablets?"** After HTTPS, a tablet test, then Intune. No date until HTTPS is done.
- **"Will the links change?"** Possibly once, when the pages move. You will be told before.

**Closing line:** "That is the next six months. Now the most important part of the day: what you want next."

---

# Module 10: feedback

**16:15–17:00 · All; Dan chairs, Lee takes the action list · `[Slide 29]` then `[Slide 30]`**

### What they should be able to do by 17:00

Each delegate has written down what is hard on the rig today and what the tools should do next, and each point is on
the action list with a name and a date.

| Part | Minutes | Clock |
|---|---|---|
| 10.1 The feedback sheet, in silence | 10 | 16:15–16:25 |
| 10.2 Round the room: what is hard on the rig today | 12 | 16:25–16:37 |
| 10.3 Round the room: what the tools should do next | 12 | 16:37–16:49 |
| 10.4 The UAT sign-off | 8 | 16:49–16:57 |
| 10.5 Close | 3 | 16:57–17:00 |

1. `[Slide 29]` **SAY:** "Ten minutes, on your own, the feedback sheet. Three things hard on the rig today; three things
   the tools should do next. Say what, not why."
2. **Round one.** One hard thing each. Lee writes it on the action list with a name and a date.
   - **TRAP:** do not answer or defend. "Thank you, that is on the list." Debate is for Thursday.
3. **Round two.** One thing the tools should do next. Same list.
4. **The UAT sign-off** (WCGRRT REV 174, SSORT REV 169, Argo Navis REV 16). Read the statements out; each delegate
   signs their own line.
   - **SAY:** "Not a test you can fail. It records that you have seen the tools do what we said. If a line is not true
     for you, do not sign it; write why on the back."
5. `[Slide 30]` **Close.** **SAY:** "Everything I showed today is in your Training Manual, step by step. Today's test
   request and report are removed from the library this week. On a real rig a post is permanent and visible. Thank
   you. Tomorrow at 08:00: technical standards." Collect the feedback sheets and UAT forms.

**Closing line:** "Two days ago these were tools you were sent. Now you have seen them work end to end, and the list on
the wall is what we build next."

---

# Trainer's checklist for Tuesday morning (one page)

**Monday evening**

- [ ] Argo Navis: open **`WVE-BOP1-20261012`** (West Vela, test) on Dan's laptop only; note its stage (expected
      **Executing**); Server save ON; Test post ticked. Sticky note: the task to complete, the checklist task, the
      break-in area. Close it.
- [ ] Help Centre: the Plans tab shows West Vela's card and its reviewers.
- [ ] On the desktop: `edocs/SAMPLE-closeout-pack.pdf`, the three precharge training files,
      `TRAINING-01_West-Tellus_issued_precharge.pdf`, one photograph for the help request.
- [ ] AAB: the existing advisories to show picked (one partly acknowledged, one outstanding) and a past AAB email
      found in Outlook.
- [ ] Ask SACRED AI opens on Dan's laptop.
- [ ] Training Manuals printed, one per delegate; feedback sheets; UAT forms naming REV 174 / 169 / REV 16.

**07:30 Tuesday**

- [ ] Projector laptop: WCGRRT **REV 174**, SSORT **REV 169**, Argo Navis **REV 16** badges. Ctrl+F5 on every page.
- [ ] Dashboard "last scan" stamp within ten minutes. If not: ring the office before 08:00.
- [ ] Request form and Precharge Pro open; badge noted; the Tellus clean run reproduces **3,725 PSIG**.
- [ ] Tabs for 10:15: Rig Visit Dashboard (SSCE Equipment, 30 days), BOP Fleet Planning, CoC tracker (local copy),
      SSCE Requests, Bulletin Board rig and fleet pages, Outlook, Teams.
- [ ] Action list on the wall; Lee has the pen. Slides 1 to 30 in order; slide 21's decisions table blank.

**During the day**

- [ ] 08:00 and 13:00: say the three rules (I drive, you follow and post nothing; Argo Navis landing page only;
      everything under MOC).
- [ ] 13:55: Save and Post daily report (Dan only); time on the board; check Outlook at 14:45 and 15:25.
- [ ] 14:30: Dan closes the test plan.
- [ ] 14:55: Dan posts the one help request, on **SSCE Equipment**.
- [ ] 17:00: feedback sheets and UAT forms collected.

**After the class**

- [ ] Delete the help request from the reports library.
- [ ] Write the hold point decisions up and send them to Lee with the action list.

---

# Answers to the review questions

## Module 5: the precharge process

**5.1 A rig sends a request with MAWHP 3,500 psi and a minimum shear pressure of 5,200 PSIG. What does the form do,
what is the likely cause, and why does it not simply reject it?**

> A **warning**: the shear looks high for that MAWHP; check you read the column matching your MASP, not the 15,000 psi
> column. It warns rather than blocks because the value can legitimately be that high. The requester must confirm.

**5.2 The contractual panel shows one shear passing and the second failing by −5 psi and −0.74 gal. Can the sheet be
posted, and what may still be done with it?**

> **No.** Post to Dashboard is refused, naming both failing cases; nothing leaves the browser. Save, Export and
> Generate PDF still work, for an engineering review. Never lower the requirement until it passes.

**5.3 The sheet quotes 3,725 PSIG at 78 °F. The deck is 60 °F. What do you charge to, and where do you find it?**

> **Not 3,725.** Read the 60 °F value from the precharge-against-temperature table on **page 3** of the PDF.

## Module 6: the SACRED dashboards

**6.1 The "last scan" stamp reads 07:40. It is 08:30. You posted at 08:05. What has happened, and what do you do?**

> The scanner has stopped. Refreshing changes nothing. Ring the office (they already have an email). Your post is not
> lost; it appears on the first scan after the scanner is back.

**6.2 A Riser Adapter cell is red; the history shows a grade 5 on a pressure test. Is the riser adapter condemned?**

> No. On a test NOV grade 1 pass, 5 fail. A 5 is a **failed test** to act on, not a condition grade.

**6.3 A West Vela advisory shows "acknowledged". Who acts next, and can the rig close its own case?**

> Technical Services review the acknowledgements and evidence, then close it with a name and a comment. **The rig
> cannot close its own case.**

## Module 7: Argo Navis

**7.1 Why did nobody but the trainer open the test plan today, and what is the difference between Save and Post for
review?**

> There is **one save file per plan**, and an opened plan saves itself on each completed step and every 30 minutes, so
> several people with it open would overwrite each other. **Save** keeps the plan as it is; nobody is told. **Post for
> review** sends a scope version to SACRED, which emails the reviewers, opens the plan chat and lists it on the Plans tab.

**7.2 Two days after the freeze, the crew finds a damaged hydraulic fitting that must be replaced. What do you do in
Argo Navis, and what does it change?**

> Raise **Break-in Work** (area, SFI, the task it follows, hours). It is numbered BRK-nnn, needs no work order or
> approval, moves the finish, float, critical path and, in the BOP group, the BOP ready date, and goes in the next
> Daily Summary Report. No new review: the scope is locked. (A pure wait goes in Waiting / NPT.)

**7.3 Riser work finishes two days after the BOP stack work. Does that move the BOP ready date?**

> **No.** The BOP ready date uses the **BOP group only**: SFI 331, SFI 332 and the BOP sequence.

## Module 8: the loop

**8.1 Draw the loop. Eight boxes, in order.**

> The tool; one file; the intake; the reports library; the scanner; the page; the notification with a link; the receipt.

**8.2 Your rig posted its Daily Summary Report at 07:10. At 08:00 nobody has the email. Name two places to look, and who
sees each failure first.**

> (1) **The dashboard:** is it on the BOP Fleet Planning tile, and is the stamp fresh? A stale stamp: the office knows
> first. (2) **The tool:** an error, Server save OFF, a file in Downloads, or the outbox? The rig sees that first. A
> notification that failed goes to the office as NOT SENT. Allow about 35 minutes.

**8.3 Which goes where: a question about the CBM form's grade buttons; an advisory to every rig about a bolt batch; the
twice-daily progress on a BWM plan.**

> **TSC Help Centre**; an **AAB** (Priority 3, acknowledged by each rig's TSLs); the **Daily Summary Report** from Argo
> Navis.

## Module 9: what is coming

**9.1 What stops SSORT and WCGRRT opening on a tablet with no signal, and who owns it?**

> **HTTPS on the server.** ISIT; requested for the end of October. The tools side and the outbox already work.

**9.2 Once built, what will Argo Navis do if a BOP PM under an NC is left out of the window at the freeze?**

> A **red critical flag**; the planner gives a reason for each, and the details are posted for the reviewers. Other
> SFIs amber. Not in REV 16.

**9.3 The scanner moves from Dan's laptop to the server. What changes for the rig?**

> Nothing in what you do. The date is being confirmed with ISIT.
