# Day 2 trainer's script: Tuesday 20 October 2026

**Workshop:** WCE SME Technical Review and Open Workshop, Houston · **Day 2:** Training review, part 2: precharge,
dashboards, Argo Navis, the loop · **Presenter:** Dan Plant, with Lee Arnold for Argo Navis and the loop

**Builds on screen (frozen to Friday 23 October):** WCGRRT **REV 174**, SSORT **REV 169**, Argo Navis **REV 16**,
scanner **v3.11** (runs every 10 minutes), the dashboards and pages under `/sacred/` on
`http://sdrlazneuiis01d.corp.local:8080`. Precharge Pro as live on the day (the pack was built on **Rev 87**; check
the badge before 08:00).

## How to read this script

Each module has the same shape:

- A header with the **time** and the **presenter**.
- **What they should be able to do by HH:MM.** If the room can do this by the end, the module worked.
- A **timing table.** Keep to it. If you run over, cut the "If asked" answers, not the traps.
- **Numbered steps.** Each step can carry four kinds of line:
  - **SAY:** short, plain words you can read out as written.
  - **CLICK/SHOW:** exactly what to click or point at on the projector.
  - **THE ROOM SEES:** what should be on the screen, so you know the click worked.
  - **TRAP:** where people go wrong. Say it before they find it.
- `[Slide n]` is the slide to have up, numbered to the Day 2 deck.
- **If asked:** the questions you can expect, with an answer.
- A **closing line** to end the module on.

**If something does not work in front of the room:** say what you expected, say what you see, and say what you will
do about it. "I expected the report on the page within ten minutes. It is not there. The stamp says the last scan was
at 09:40, so the scanner is behind. I will ring the office at the break; we carry on." That is the lesson the tools
exist to teach, so it is never a failure of the class.

**The day in one table**

| Time | Module | Presenter | Slides |
|---|---|---|---|
| 08:00–10:00 | 5 · The precharge process | Dan | 1–6 |
| 10:00–10:15 | Break | | |
| 10:15–12:00 | 6 · The SACRED dashboards | Dan | 7–13 |
| 12:00–13:00 | Lunch | | |
| 13:00–14:30 | 7 · Argo Navis: planning and executing BWM, with the **hold point** | Dan, Lee | 14–23 |
| 14:30–14:45 | Break | | |
| 14:45–15:30 | 8 · The loop, and the TSC Help Centre hands on | Dan, Lee | 24–27 |
| 15:30–16:15 | 9 · What is coming | Dan | 28 |
| 16:15–17:00 | 10 · Feedback | All | 29–30 |

**Three rules for the whole day. Say them at 08:00 and again at 13:00.**

1. **Precharge: nothing is posted.** We work on verified rigs under training well names (`TRAINING-01 NOT ISSUED` and
   so on). Nobody presses Post to Dashboard.
2. **Argo Navis: only the trainer presses Save, Post for review, Post daily report or Post close-out.** The test plan
   has one save file; ten people saving would overwrite each other, and every post sends a test email.
3. **Everything is under MOC.** We do not teach MOC content today. One line, every time it comes up: "That is
   managed under MOC; not today's subject."

---

# Opening (08:00–08:05)

`[Slide 1]` title. `[Slide 2]` the Day 2 agenda.

1. **SAY:** "Good morning. Yesterday you posted forty reports from the rig tools. Today is about what happens to
   them and to everything else after the post: the precharge, the dashboards, the planning tool, and the loop that
   joins them. Then we stop and ask what you want next."
2. **SAY:** "Three rules for today." Read the three rules above, from the slide.
3. **SAY:** "The action list is on the wall. Anything that is hard, wrong or missing goes on it today, with a name.
   Thursday's forum argues from that list, not from memory."
4. **CLICK/SHOW:** point at the agenda slide, the four sessions before lunch and after.
5. **TRAP:** someone will open yesterday's tools to "check their posts". Say: "Your Monday posts are on the dashboard;
   we look at them at 10:15. Leave the tools closed until then."

---

# Module 5: the precharge process

**08:05–10:00 · Dan · `[Slide 3]` to `[Slide 6]`**
**Tools:** the precharge request form (Rev 3, inside SSORT and as a standalone page), Precharge Pro (the calculator),
the issued sheet and its PDF. **Pack:** `tools/received/training/precharge/` (three module files, 32 screenshots, three
exercise files, the issued PDF, the answer key).

### What they should be able to do by 10:00

- Fill a precharge request correctly, and name the three mistakes the form catches.
- Say what the calculation does with the request, and what it will not do (post a failing sheet).
- Read an issued sheet and its PDF: header, conditions, the number to charge to, the temperature table.
- Describe the loop after the post: who is emailed, what is attached, where the record lives, and the two signatures.
- Say which number on the sheet they check against the stack, and that the arithmetic is not theirs to adjust.

### Timing

| Part | Minutes | Clock | Slide | Source |
|---|---|---|---|---|
| 5.1 The request: the form and the three mistakes | 20 | 08:05–08:25 | 3, 4 | `MODULE-1-The-request.md`, shots 01-01 to 01-10 |
| 5.2 The calculation: a clean run, a real failure, a dual stack | 35 | 08:25–09:00 | 4 | `MODULE-2-The-calculation.md`, shots 02-01 to 02-17 |
| 5.3 The exercise: three training files | 20 | 09:00–09:20 | 6 | `exercise-files/`, answer key |
| 5.4 The issued sheet and its PDF | 15 | 09:20–09:35 | 4 | `MODULE-3-The-issued-sheet-and-its-PDF.md`, shots 03-01 to 03-10, the PDF |
| 5.5 The loop, where the record lives, two signatures, under MOC | 15 | 09:35–09:50 | 5 | this script |
| Questions (workbook 5.1 to 5.3) | 10 | 09:50–10:00 | 6 | workbook |

### Before 08:00

- Open the request form (standalone page) and Precharge Pro on the projector laptop. Check the badge. Ctrl+F5.
- Have the three exercise files and `TRAINING-01_West-Tellus_issued_precharge.pdf` on the desktop.
- Have the Precharge tab of the Rig Visit Dashboard open in a tab (for 5.5), and Outlook showing a past ISSUED
  email if you have one in test mode.
- **Every number below was produced by Rev 87.** If a number does not reproduce on the day, stop and find out why
  before teaching it. Say so to the room if it happens: that is the discipline the tool enforces.

---

## 5.1 The request (08:05–08:25) `[Slide 3]` then `[Slide 4]`

1. **SAY:** "A precharge is only as good as the request. Every recalculation and every delay we have had traces back
   to a field on this form, not to the arithmetic."
   - **CLICK/SHOW:** open the request form. `[shot 01-01]`
   - **THE ROOM SEES:** the empty form, corporate logo only.
   - **TRAP:** do not call it "the Precharge Pro form". It is deliberately unbranded. Call it the request form.
2. **SAY:** "This is what the rig fills in. It is not the calculator; it shares no code with it. It makes a small file
   that loads straight into the calculator at our end."
3. **CLICK/SHOW:** the **Guide** button in the header. `[shot 01-02]`
   - **SAY:** "Everything I am about to say is in here. If a rig asks what a field means, point them at the Guide."
4. **CLICK/SHOW:** close the Guide. Walk the top block: Rig, BOP, Well.
   - **SAY:** "The BOP selector only appears on rigs with two stacks. If you have one stack you will not see it. That
     is correct, not a missing field."
5. **CLICK/SHOW:** **Requested by** and the email.
   - **SAY:** "Put a person, not a mailbox. We lose a day every time this is a shared address."
6. **CLICK/SHOW:** press **Check my entries** with the form empty. `[shot 01-03]`
   - **THE ROOM SEES:** the seven mandatory fields flagged.
   - **SAY:** "Seven fields stop the file: rig, well name, minimum shear pressure, MAWHP, water depth, subsea
     temperature, deck temperature. Miss one and there is no file. An incomplete request that looks complete is worse
     than no request."
7. **CLICK/SHOW:** **Minimum shear pressure** and **Where it came from**. `[shot 01-04]`
   - **SAY:** "Tell us the source. It is optional, and it is the most useful optional field on the form."
8. **CLICK/SHOW:** the two unit selectors.
   - **SAY:** "The form starts in metric: metres and Celsius. Set the two selectors first. Type 7,000, 38 and 78
     meaning feet and Fahrenheit with the selectors left on metric, and you have asked for 22,966 feet and two
     Celsius temperatures."
   - **TRAP:** this is the one that catches the office too. Setting the units is part of filling the form, not an
     afterthought.
9. **CLICK/SHOW:** **Well hop** and the depth list; pump cut-in and cut-out; the free-text changes box.
   - **SAY:** "A hop is one precharge used across several wells without pulling the BOP. Say yes and you must list
     every depth. Cut-in sits below cut-out. And anything changed on the stack since the last request goes in the
     box: rams, bottles, anything."

**The three mistakes, done live. Read each warning out loud.**

10. **Mistake 1, the wrong estimator column.** **CLICK/SHOW:** MAWHP **3,500**, shear **5,200**. `[shot 01-05]`
    - **THE ROOM SEES:** the warning: "The shear pressure looks high for a MAWHP of 3,500 psi. Check you have read
      the column matching your MASP and not the 15,000 psi column; that is the single most common error on this
      form."
    - **SAY:** "People read the 15,000 column because it is the widest and the worst case. Against a MASP of 3,500
      that is thousands of psi too high. It warns; it does not block, because occasionally the number really is that
      high. It makes you look."
11. **Mistake 2, temperatures.** **CLICK/SHOW:** unit °F, subsea **4**. `[shot 01-06]` Then deck **38**, subsea **50**.
    `[shot 01-07]`
    - **SAY:** "4 °F subsea is seawater at minus fifteen Celsius: someone typed Celsius with the selector on
      Fahrenheit. And deck below subsea usually means the two are swapped. Subsea sets the gas density at depth; deck
      is what your gauge reads while you charge. Swap them and both halves of the calculation go wrong."
12. **Mistake 3, the pumps.** **CLICK/SHOW:** cut-in **3,000**, cut-out **2,800**. `[shot 01-08]`
    - **SAY:** "The pumps cannot cut in above where they cut out. A classic."
13. **The hard block.** **CLICK/SHOW:** Well hop = yes, list empty. `[shot 01-09]`
    - **SAY:** "This one stops you. Warnings make you look; errors stop you. Anything that can legitimately be unusual
      warns. Anything that is never valid blocks."
14. **CLICK/SHOW:** correct every field and make the file. `[shot 01-10]`
    - **SAY:** "That file loads straight into the calculator. On a real job the rig posts it from SSORT and the
      office gets it. Today we do not post."
    - **TRAP:** the form lives inside SSORT and as a standalone page. They are the same form. A crew that raises it
      from both has raised it twice, and the office sees both. Raise it once.

---

## 5.2 The calculation (08:25–09:00) `[Slide 4]`

**Part A: West Tellus, a clean run (15 min)**

15. **CLICK/SHOW:** open Precharge Pro, `http://sdrlazneuiis01d.corp.local:8080/sacred/precharge/`. `[shot 02-01]`
    - **SAY:** "This tool produces the number the rig charges the bottles to. It runs in the browser; there is no
      server doing the maths."
16. **CLICK/SHOW:** the revision in the header. `[shot 02-02]`
    - **SAY:** "Check this every time. The revision tells you which version of the method produced a sheet."
17. **CLICK/SHOW:** open the Asset dropdown; select **West Tellus**.
    - **SAY:** "Thirteen assets, not interchangeable. Each carries its own bottle sizes, volumes, ratios and MOPs from
      its own OEM sizing document. Pick the wrong rig and you get another rig's answer."
    - **THE ROOM SEES:** the greyed hardware block fill in. `[shot 02-04]`
    - **SAY:** "Grey is rig hardware. You cannot edit it and should not want to. If one is wrong, that is a change
      request under MOC, not a thing you type over. White is per-well: your job."
18. **CLICK/SHOW:** type well **`TRAINING-01 NOT ISSUED`**, water depth **7,000 ft**, subsea **38 °F**, deck **78 °F**,
    shear **2,600**, MAWHP **3,900**. `[shot 02-05]`
    - **SAY:** "The only real rig names in this module carry a well name that says why: nothing from this room is
      issued. If you ever see a well called TRAINING on a real sheet, it is not a sheet."
    - **SAY:** "There is no Calculate button. Every keystroke reruns the whole thing."
19. **CLICK/SHOW:** the green verdict banner. Read it aloud. `[shot 02-06]`
    - **THE ROOM SEES:** **SET PRECHARGE (DCB TABLE): 3,725 PSIG** (gauge) / 3,740 PSIA @ 78 °F, **CHECKS PASS ✓**.
    - **SAY:** "3,725 PSIG is the answer. Gauge pressure, at 78 °F. Everything else on this page justifies that
      number or proves it is safe."
20. **CLICK/SHOW:** the PSIG/PSIA pair and the highlighted column; then "table value 3,704, rounded up to the nearest
    25".
    - **SAY:** "The yellow column is always the one you charge to. And we round up, never down: rounding down would put
      you under the table."
21. **CLICK/SHOW:** open the Method C drawdown block. `[shot 02-08]`
    - **SAY:** "Four conditions. You charge at 0. The stack goes to depth and is charged at 1. The ram fires and the
      pressure falls to 2. Condition 2 is what is left at the ram when it closes: 4,045 against 2,600 required."
    - **SAY, pointing at P1 3,333 psia:** "That subsea figure pairs only with the subsea temperature."

**Part B: the same rig, a tubular it cannot shear (12 min). The most valuable minutes of the morning.**

22. **CLICK/SHOW:** change shear from 2,600 to **4,105**. Nothing else. `[shot 02-10]`
    - **SAY:** "4,105 is the hardest tubular we have today. It is a real open item, not a made-up example."
    - **THE ROOM SEES:** the red banner: FAILS PER PRECHARGE TABLE, closing 4,045 vs required 4,105; usable 46.4 gal vs
      FVR need 50.6 gal.
    - **SAY:** "Two separate failures: not enough pressure, 60 psi short; not enough volume, 4.2 gallons short. Either
      one means the ram does not complete its stroke."
23. **CLICK/SHOW:** the green OPTIMUM banner below. `[shot 02-11]`
    - **THE ROOM SEES:** OPTIMUM PRECHARGE 3,900 PSIG; CSR closing 4,114 vs shear 4,105.
    - **SAY:** "It does not just fail you. It finds the lowest precharge that passes, adds 50, rounds up to the nearest
      100: 3,900."
    - **TRAP:** the last sentence of that banner still says "closes at 4,045 > required shear 4,105". That is stale
      text from before the optimum and it contradicts itself (finding F-68, cosmetic, in the register). **The right
      figure is 4,114.** Say it before anyone reads the last line.
24. **CLICK/SHOW:** the NOV Contractual Petrobras Checks panel. `[shot 02-12]`, then `[shot 02-12b]` beside it.
    - **SAY, slowly:** "One cut passes. The second cut fails by **minus five psi and minus 0.74 of a gallon**. Nobody
      would see that by eye on a sheet that otherwise looks healthy. That is the whole argument for the tool: not that
      it is faster, but that it finds the five-psi failure at two in the morning."
25. **CLICK/SHOW:** point at Save, Export, Generate PDF.
    - **SAY:** "A failing sheet can still be saved and printed, to take into review. What it cannot do is go to the
      rig."
26. **CLICK/SHOW:** press **Post to Dashboard**. It is refused. Read the refusal out from the slide (the dialog is a
    browser box, so there is no screenshot):

    > THIS SHEET FAILS THE NOV CONTRACTUAL PETROBRAS CHECK. It cannot be posted to the dashboard: CSR + USR: pressure
    > 4159 vs 4164 PSIG required (-5), volume 100.46 vs 101.20 gal needed (-0.74); CSR + LSR: the same. Saving,
    > exporting and printing are still allowed - take it into review.

    - **SAY:** "Nothing left the browser. No file, no email, no dashboard entry. And when it happens for real, the
      answer is never to lower the requirement until it passes. It goes back to the operator and NOV."
    - **TRAP:** **dismiss the dialog. Do not post.** The refusal is the demonstration. Set shear back to 2,600 before
      you move on.

**Part C: West Neptune, dual stack (8 min)**

27. **CLICK/SHOW:** Asset **West Neptune**; well **`TRAINING-02 NOT ISSUED`**; 6,500 ft; subsea 40 °F; deck 78 °F;
    MAWHP 12,000. `[shot 02-14]` Point at the **BOP** selector. `[shot 02-15]`
    - **SAY:** "Only rigs with two stacks get this selector. And the shear field is prefilled at 3,826 here: read the
      label, not the position. It is not the same field on every rig family."
28. **CLICK/SHOW:** the Precharge Summary, one row per accumulator. `[shot 02-16]`
    - **SAY:** "On a rig like this the answer is not one number. It is a number per accumulator, each by its own
      method. The method belongs to the equipment, not to the engineer."
29. **CLICK/SHOW:** switch BOP from 1 to 2. `[shot 02-17]` **Ask the room:** "What changed?"
    - **SAY:** "Only the header. Both stacks are the same hardware and the rig uses one gas density, so the precharge
      is the same. The selector labels the sheet so it is filed against the right stack. It is not a calculation
      input. And it does not make the stacks interchangeable: if their hardware ever differs, that is MOC."

---

## 5.3 The exercise: three training files (09:00–09:20) `[Slide 6]`

**Set-up.** Three groups, one case each. Give the calculator password **out loud only**; never write it on the
board or in the workbook. If the calculator will not open on a delegate's laptop, that group works the case from the
projector.

| Group | Rig | Training well | Inputs (from the workbook) | Known-good answer |
|---|---|---|---|---|
| A | West Tellus | `TRAINING-01 NOT ISSUED` | 7,000 ft · 38 / 78 °F · shear 2,600 · MAWHP 3,900 | **3,725 PSIG**, checks pass |
| B | West Neptune BOP 1 | `TRAINING-02 NOT ISSUED` | 6,500 ft · 40 / 78 °F · MAWHP 12,000 · shear preset 3,826 | per accumulator: Blue POD Pilot **5,156**; Manifold Reg. Pilot **3,743**; LMRP, Stack and Upper Annular Reg. Pilots **3,293** each (subsea precharge, PSIG) |
| C | West Gemini | `TRAINING-03 NOT ISSUED` | 5,000 ft · 42 / 78 °F · MAWHP 10,000 · shear preset 2,050 | **4,750 PSIG** API optimum; BSR closes at 3,679 > 2,050 |

30. **SAY:** "Ten minutes. Enter your case, record the number you would charge to, and say why it passed. Save it if
    you like. **Do not post.**"
31. **CLICK/SHOW** (at 09:12): **Load .json** with each group's file in turn, from the desktop. Compare with their
    answer.
    - **THE ROOM SEES:** the header reads `<rig> — TRAINING-0n NOT ISSUED` and the same figures.
32. **SAY, for Gemini:** "Gemini's dedicated shear is piston bottles, not DCBs. There is no OEM table, so the tool
    computes the API optimum. Put it beside Tellus: the method belongs to the equipment."
33. **SAY, for Neptune:** "Switch to BOP 2: every number stays. The label moves."
34. **If a group is quick:** Group A sets shear to 4,105 and watches the refusal from 5.2 happen on their own screen.
    - **TRAP:** a delegate who reaches for Post to Dashboard on a passing sheet: stop them. "Nothing is posted from
      this room." Rigs charge bottles against these numbers; a training sheet must never escape.
    - **TRAP:** a group that gets a different answer has almost always left the units on metric, or picked the wrong
      rig. Check those two before anything else.

---

## 5.4 The issued sheet and its PDF (09:20–09:35) `[Slide 4]`

35. **CLICK/SHOW:** back on the clean Tellus run (shear 2,600). Point at the header. `[shot 03-01]`
    - **SAY:** "Rig and well, and BOP on a two-stack rig. Your first check that you are holding the right sheet."
36. **CLICK/SHOW:** the conditions block. `[shot 03-02]`
    - **SAY:** "Everything the rig told us, echoed back. Check it against the request. Wrong conditions means the right
      answer to the wrong question."
37. **CLICK/SHOW:** the temperature table. `[shot 03-03]`
    - **SAY:** "The precharge is only correct at the temperature it is quoted at. If it is 60 °F on deck, not 78, you
      read the table. You do not charge to 3,725 and hope."
38. **CLICK/SHOW:** open `TRAINING-01_West-Tellus_issued_precharge.pdf` (three pages). Page 1. `[shot 03-07]`
    - **SAY:** "This is built from the calculation data, not photographed from the screen, so it cannot drift from what
      was calculated."
39. **CLICK/SHOW:** **page 3**, the precharge against temperature. `[shot 03-08]` Read the sentence:

    > "The accumulator holds a fixed gas charge. As the surface temperature is subject to change during the precharge
    > process, target the precharge for the ACTUAL temperature at that moment: read off the curve / table below."

    - **SAY:** "That is the whole answer to 'it said 78 on the sheet but it is 60 on deck this morning'."
    - **TRAP:** the temperature table is on **page 3**, not page 2. Page 2 is the rest of the contractual tables.
40. **SAY:** "**The PDF is the controlled document.** Not the screen, not the email body, not a screenshot on a phone."
    - **TRAP:** that sentence is not printed on the PDF. It is on the posted copy, which says it about the PDF. Make
      the point; do not hunt for it on the page.
41. **CLICK/SHOW:** the filename.
    - **SAY:** "Rig, well, and BOP where there is one. You may see the same PDF under two names: the download uses
      underscores, the posted copy starts `Seadrill_` with hyphens. Same document." (Finding F-69; nothing changes
      before the class.)
42. **CLICK/SHOW:** point at **Post to Dashboard** on the clean sheet. **Do not click it.**
    - **SAY:** "This is where it leaves the calculator. Which takes us to the loop."

---

## 5.5 The loop, where the record lives, two signatures, under MOC (09:35–09:50) `[Slide 5]`

43. **SAY:** "Here is the whole loop, start to finish."
    - **CLICK/SHOW:** the slide's loop, one box at a time:
      1. The rig fills the request and posts it from SSORT.
      2. It lands in the reports library. The scanner reads it within ten minutes and puts it in the office's
         precharge inbox, newest at the top, amber after 48 hours.
      3. The office is emailed that a request is in. That email is office only.
      4. The office opens the request straight into the calculator, works it, checks it.
      5. The office posts the issued sheet. **The ISSUED email goes To the rig's subsea supervisor, TSL, assistant rig
         manager and rig manager, with the office on Cc, and it carries the PDF and only the PDF.**
      6. The dashboard's Precharge tab shows the issued sheet against the original request.
    - **SAY:** "The rig's people are always on To, never Cc, because rigs filter Cc and a precharge must not be missed.
      And the email never carries the data file: the PDF is the signed document; the data file is not."
44. **CLICK/SHOW:** the Precharge tab on the Rig Visit Dashboard.
    - **THE ROOM SEES:** requests and issued sheets by rig.
    - **SAY:** "A re-posted request with a correction shows as REVISED. The newer one wins. An issued sheet is never
      reset by a re-post."
45. **SAY, where the record lives:** "Three places, one record. The posted files sit in the reports library, the
    record of what was requested and what was issued. The PDF in the email is the controlled document the rig works
    from. On a BWM plan, the issued precharge is also filed in the plan's project folder and joins the close-out pack
    you will see this afternoon."
46. **CLICK/SHOW:** the foot of PDF page 2. `[shot 03-10]`
    - **THE ROOM SEES:** `Calculated: ______  Verified: ______  Date: ...` and "Generated by Seadrill Precharge Tool"
      with a timestamp.
    - **SAY:** "**Two signatures.** One person works it up: Calculated. A second person checks it: Verified. The
      generation timestamp is the tool's own record. It is not a signature and it replaces neither name."
47. **SAY:** "All of this, the calculator, the request form and the process, is under MOC. If a rig's hardware changes,
    that is a change request and an MOC. We are not teaching MOC today."
48. **SAY:** "What is yours on the rig: a correct request, once; the sheet's header and conditions checked against your
    request; charging to the table for today's deck temperature; and the two signatures on the sheet you work from.
    The arithmetic is not yours, and it is not mine either. If a number looks wrong, check the inputs on the request
    and ring the office. Nobody adjusts the calculator."

### Questions (09:50–10:00) `[Slide 6]`

49. Workbook questions 5.1 to 5.3. Give them three minutes, then take answers round the room. Answers are at the end of
    this script.

### If asked

- **"Can we have the calculator on the rig?"** No. The rig raises the request; the office calculates, checks and
  issues. That is the two-signature control. Put it on the action list if you want it discussed.
- **"Why is there no SSCE Equipment asset in the calculator?"** Because nothing in the calculator changes for a class.
  So we use real, verified rigs (Tellus, Neptune, Gemini) under training well names. Rigs not yet through the rig-by-rig
  check are deliberately not used.
- **"The sheet says 78 °F but our deck is 95 °F."** Read the temperature table for 95 °F on page 3. If 95 °F is off the
  table, ring the office before charging.
- **"Why does BOP 2 give the same number as BOP 1?"** Same hardware, one gas density. The selector labels the sheet.
- **"Who signs Verified?"** A second competent person in the office who did not work the sheet up. If you want it
  named per region, that is an action-list item.

**Closing line:** "The tool's job is to stop a five-psi failure reaching your rig. Your job is to send us the right
request once, and charge to the table for the temperature in front of you. Break: back at 10:15."

**At the break:** open the Settings workbook and set **TestMode (B2) to Yes** for the AAB demonstration in Module 6.
Set it back to **No** at 12:00. While it is Yes, every flow that reads it sends to the office only.

---

# Module 6: the SACRED dashboards

**10:15–12:00 · Dan · `[Slide 7]` to `[Slide 13]`**
**Pages:** the Rig Visit Dashboard, `BOP Fleet Planning Dashboard.html`, the WCE Certificate of Conformance (CoC)
tracker, `SSCE Requests Dashboard.html`, `/sacred/aab/` (the Seadrill Bulletin Board) and the dashboard's AABs tab, all on
`http://sdrlazneuiis01d.corp.local:8080/sacred/`. Ask SACRED AI on Dan's laptop only.

### What they should be able to do by 12:00

- Find their own Monday reports, open one in the full-report viewer, and print it.
- Read the "last scan" stamp and say what a stale stamp means.
- Use the Errors button and say what lives there.
- Read Rig Monitoring and say what "needs attention" counts (and what it does not).
- Read the CBM Heatmap and a grade history, and tell a condition grade from a test result.
- Read the BOP Fleet Planning page and find a rig's plan and its break-in work.
- Say where the CoC figures come from and where an SSCE request is raised and approved.
- Follow an AAB from advisory to acknowledgement to Technical Services' close.
- Say what Ask SACRED AI does, and that it is an answer, not a record.

### Timing

| Part | Minutes | Clock | Slide |
|---|---|---|---|
| 6.1 Orientation, the stamp, and the AAB posted to start its clock | 8 | 10:15–10:23 | 7, 8 |
| 6.2 Report List and the full-report viewer, the Errors button | 12 | 10:23–10:35 | 8, 9 |
| 6.3 Rig Monitoring | 10 | 10:35–10:45 | 8 |
| 6.4 CBM Heatmap and the grade history | 12 | 10:45–10:57 | 9 |
| 6.5 The other tabs, one line each | 5 | 10:57–11:02 | 8 |
| 6.6 BOP Fleet Planning page | 15 | 11:02–11:17 | 10 |
| 6.7 CoC dashboard and SSCE requests | 10 | 11:17–11:27 | 11 |
| 6.8 The AAB tab and the Bulletin Board: advisory to acknowledgement | 20 | 11:27–11:47 | 12 |
| 6.9 Ask SACRED AI (Dan's laptop) | 8 | 11:47–11:55 | 13 |
| Questions and close | 5 | 11:55–12:00 | 13 |

### Before 10:15

- Tabs open on the projector laptop: the Rig Visit Dashboard; the BOP Fleet Planning Dashboard; the CoC tracker (a
  **local copy**, not the share); the SSCE Requests Dashboard; the Bulletin Board create page and fleet compliance
  page (office password typed at the break, never on screen); Outlook; Ask SACRED AI. Ctrl+F5 on each.
- The "last scan" stamp is within ten minutes. If not, ring the office before you start.
- **TestMode (B2) is Yes** (set at the break).

---

## 6.1 Orientation (10:15–10:23) `[Slide 7]` then `[Slide 8]`

1. **CLICK/SHOW (first, so its clock starts):** on the Bulletin Board create page, post the training advisory now
   (the full steps are in 6.8, step 33; the short form: number `C1025TEST1`, revision 0, title starting `TEST`,
   category BOP, due in 14 days, SFI 331, evidence photographs asked for, applies to **West Vela only**, three test
   paragraphs, the test bulletin PDF, **Post AAB**).
   - **SAY:** "I have just issued a training advisory. The rig page will show it after the next scan. We come back to
     it at half past eleven."
   - **TRAP:** check TestMode reads Yes before you press Post AAB. If it reads No, the West Vela rig's people get it.
2. **CLICK/SHOW:** the Rig Visit Dashboard. Point at the banner: **Ask SACRED AI**, **TSC Help Centre**, the "last scan"
   stamp on the right.
   - **SAY:** "This page is written by a script every ten minutes from every report the fleet has posted. Nobody types
     into it. If it is wrong, a report is wrong, and you fix the report by re-posting it."
3. **SAY:** "The stamp is the time of the last scan. More than ten minutes old means the scanner has stopped, and the
   office has an email about it within the hour. Do not keep refreshing; ring."
4. **CLICK/SHOW:** rig filter **SSCE Equipment**, time filter **30 days**.
   - **THE ROOM SEES:** Monday's forty rows, each delegate's four on their own allocated date.
   - **SAY:** "Find your four. Two minutes." (Delegates use their own laptops.)
   - **TRAP:** someone's row is missing. Walk it in the open, using Monday's five checks in order: right rig? right
     date? what did the tool say after Post? did someone post over it? did it sit in the outbox (📤 waiting to send)?
     Then ring the office. Do not apologise for it; it is the best teaching moment of the morning.

## 6.2 Report List, the full-report viewer, the Errors button (10:23–10:35) `[Slide 8]` then `[Slide 9]`

5. **CLICK/SHOW:** the Report List columns: date, rig, type, who, size, attachment and photograph counts, the OEM chip
   on a CBM report that went to NOV.
   - **SAY:** "The type column names the report the way the file was named. If your CBM report shows the wrong
     equipment, it was the wrong equipment in the tool."
6. **CLICK/SHOW:** open one Monday CBM report in the full-report viewer. Scroll: the header, the graded tasks with
   photographs, **Test records and documents attached** with the task number under each file, NOV's usage table on the
   classes that carry one, the sign-off.
   - **SAY:** "This is the whole report. The office prints from this page; NOV get a copy of the same content by email.
     There is no second version anywhere."
7. **CLICK/SHOW:** **Print** on the report.
   - **SAY:** "This is the PDF the office keeps. It comes from the posted file, so it is the same for everyone."
8. **CLICK/SHOW:** the **Errors** button. Open it.
   - **THE ROOM SEES:** the list: unreadable files, files over the size ceiling, help requests with no delivery receipt.
   - **SAY:** "Nothing is hidden. If your report is here, it is because of the file, and the fix is at the source:
     smaller photographs, or a repost."
   - **TRAP:** "The Errors button is not a list of your mistakes in the field. It is a list of files the scanner could
     not read. A failed BOP test is a report, not an error."

## 6.3 Rig Monitoring (10:35–10:45) `[Slide 8]`

9. **CLICK/SHOW:** **Rig Monitoring**. One tile per rig.
   - **SAY:** "The page a superintendent opens first in the morning. Each tile: the latest daily report, the daily
     checks, the BOP planning status, anything needing attention, counted once."
10. **CLICK/SHOW:** a rig's **Daily Checks and FLM** link.
    - **SAY:** "Daily checks are kept out of the Report List on purpose; dozens a week per rig would bury the reports.
      They are here, and a failed or commented reading lifts the tile."
11. **TRAP, say it slowly:** "Needs attention counts things people wrote: a reading marked failed, a reading with a
    comment, an action raised on a visit and still with the rig. It is not a judgement the dashboard made about your
    equipment. Nothing on this page ever is."
12. **CLICK/SHOW:** a potable-water flush item if any rig has one.
    - **SAY:** "On those two readings a tick is a record, not a pass. The tile knows the rule is the other way round
      there."

## 6.4 CBM Heatmap and the grade history (10:45–10:57) `[Slide 9]`

13. **CLICK/SHOW:** **CBM Heatmap**. Rows are rigs, columns are equipment classes, colour is the latest grade.
    - **SAY the legend:** "Green, one and two, acceptable. Amber, three, monitor. Red, four and five, fail. Grey, no
      grade on record. That is NOV's scale, and three is the one to look at: three is where someone found something."
14. **CLICK/SHOW:** click a cell. The grade history: every graded task, every date, every grade, the photographs.
    - **SAY:** "One inspection is a snapshot. Three are a trend, and the trend is what the fleet acts on. That is why you
      grade honestly."
15. **CLICK/SHOW:** the class's Riser Adapter from Monday: condition grades, and the two tests graded **1 and 5**.
    - **SAY:** "Those two are not condition grades. They are a pass and a fail on a pressure test, the way NOV grade
      their own tests: 1 pass, 5 fail. The note under each task in SSORT says which kind it is."
    - **TRAP:** "A 5 on a test is a failed test that needs acting on. It is not a condemned component. Say that before
      anyone reads the red cell as a stack problem."

## 6.5 The other tabs, one line each (10:57–11:02) `[Slide 8]`

16. **CLICK/SHOW** each tab for a few seconds:
    - **Compliance:** the latest checklist per rig; actions raised on visits, overdue from the date the visitor typed;
      certification expiry watch at ninety days.
    - **Investigations, Failures, Lessons learned, R53 events:** each is a report type or a block inside a report.
    - **Precharge:** requests and issued sheets (you saw it at 09:40).
    - **AABs:** the Bulletin Board's register; 6.8 covers it.
    - **SAY:** "Every row here was posted by someone from a tool. Nothing was typed into the dashboard."

## 6.6 The BOP Fleet Planning page (11:02–11:17) `[Slide 10]`

17. **CLICK/SHOW:** `BOP Fleet Planning Dashboard.html`. The globe tab, then **Tile view**, then **Map view**.
    - **SAY:** "This is the front page for planning: every rig, where it is, and the state of its BOP plan. One tile per
      rig."
18. **CLICK/SHOW:** West Vela's tile.
    - **THE ROOM SEES:** the test plan's tile: % complete, BOP %, the BOP ready date, the latest Daily Summary Report.
    - **SAY:** "This afternoon you will build this tile from the other end, in Argo Navis. What the rig posts is what
      this tile shows, within ten minutes."
19. **CLICK/SHOW:** **View schedule**, then **Break-in Work**.
    - **SAY:** "Break-in work is unplanned work that interrupted the plan. It comes from the rig's report, it is counted
      here, and every break-in is in the daily report. If your break-in is not here, it was not in the report."
20. **CLICK/SHOW:** the button that opens Argo Navis from this page.
    - **SAY:** "This is the door to Argo Navis. We go through it at 13:00."
21. **TRAP:** "This page updates when the rig posts: Argo Navis's daily report for BWM, or WCGRRT's planning report for a
    P6 project. A change agreed in a meeting shows up when it is in the next report, not before."
    - **TRAP:** the test plans are visible here and on Argo Navis's landing page while test mode is on. They are marked
      test. Do not read a test tile as a real rig's state.

## 6.7 The CoC dashboard and SSCE requests (11:17–11:27) `[Slide 11]`

22. **CLICK/SHOW:** the CoC tracker (local copy). The fleet dashboard: KPI tiles, the status split, the table by
    vessel.
    - **SAY:** "This is the WCE Certificate of Conformance tracker. The master record is Maximo; the tracker is a
      snapshot of the Maximo extract, refreshed from it. Read today's figures off the tiles."
23. **CLICK/SHOW:** the tiers: expired; due within 6 months; within 1 year; within 18 months; valid; no date on file.
    - **TRAP:** "'No date on file' is not 'valid'. It means the issued and expiry dates are blank in Maximo for that
      row. The fix is in Maximo, not in the tracker."
24. **CLICK/SHOW:** one vessel page, one row opened: Maximo ID, certificate history (the newest kept, older ones under a
    +n badge), the same OEM part held in Shared Capital.
25. **CLICK/SHOW:** a Shared Capital spare, and the **Request** button beside it. Show the SSCE application form,
    pre-filled. **Do not submit.**
    - **SAY:** "An SSCE request is raised in one place only: here, from the tracker. It goes to Central Spares for
      approval on the SSCE Requests Dashboard. Argo Navis reads the approval back onto the plan."
26. **CLICK/SHOW:** `SSCE Requests Dashboard.html`. A request, its status (pending, approved, denied), the approver's
    comment.
    - **SAY:** "Approved means the spare shows as allocated. The office checks before the live tracker changes; nothing
      writes to the live file on its own."
    - **TRAP:** annotations on the tracker (ticks, remarks, a Synergi number) live in your own browser only. They do not
      travel with the file. Anything that must be shared goes in Maximo or Synergi.

## 6.8 The AAB tab and the Seadrill Bulletin Board (11:27–11:47) `[Slide 12]`

27. **SAY (2 min):** "An AAB is an Alert, Advisory or Bulletin. This board carries Priority 3 only: for information, no
    cost, no work order, no approval chain. Priority 1 and 2 stay in the corporate process. What the rig owes: each
    crew's Technical Section Leader reads it and acknowledges it with a comment, and attaches evidence when asked. The
    rig never closes an advisory. Technical Services review and close."
28. **SAY:** "Everything here is in test mode. On a real advisory the rig is on To, never on Cc, and the acknowledgement
    is the record."
29. **CLICK/SHOW (4 min):** the create page as filled at 10:15 (use **Load AAB file** if you saved a draft). Walk it
    quickly: number and revision, Priority 3 fixed, title, category, due date, SFI 331, the evidence tick, **Applies to**
    West Vela only, originator, the three paragraphs (what has happened, why it matters, what the rig must do), the
    bulletin with its **BULLETIN** badge.
    - **CLICK/SHOW:** Outlook: the issued email, `[TEST MODE] [AAB C1025TEST1 rev 0] … - West Vela`, the red line
      naming who it would have gone to.
30. **CLICK/SHOW (6 min):** the rig page for West Vela (`/sacred/aab/`, West Vela selected). Ctrl+F5.
    - **THE ROOM SEES:** the advisory, state **outstanding**.
    - **CLICK/SHOW:** **Acknowledge this advisory** as crew A: name, role **Technical Section Leader**, crew A, today, a
      comment, one photograph. Post.
    - **SAY:** "The comment is required every time. With evidence asked for, the page refuses an acknowledgement with
      nothing attached."
    - **CLICK/SHOW (one mistake on purpose):** try to post crew B with no comment. Refused.
31. **CLICK/SHOW (5 min):** the fleet compliance page. **Awaiting your review**, the register row, West Vela's chip.
    Click the chip: who is left to acknowledge.
    - **SAY:** "After the next scan the chip moves on. Technical Services review both crews and the evidence and then
      close it, with a name and a comment. Closing is a review decision, never automatic, and never the rig's."
    - If the scan has run and both crews are in: **close it** and show the closure email. If not, show where the button
      is and say what it will do.
32. **CLICK/SHOW (3 min):** the Rig Visit Dashboard's **AABs** tab: one row per advisory, the six states in the legend.
    - **SAY:** "Overdue is a date, not an opinion: any open state past the due date. Partly acknowledged is one crew
      done and one not. Both can be true at once."
33. *(Reference: the full create-page steps used at 10:15.)* AAB Number `C1025TEST1`; Revision 0; Level Priority 3
    (fixed); Title `TEST Ram packer extrusion on 18-3/4in 15K double ram BOP`; Category BOP; Issue Date today; Due Date
    14 days out; SFI 331; tick "asks the rig to attach evidence photographs"; Applies to: West Vela only (never **All
    rigs**); originator name and email (Dan's); the three test paragraphs; one reference line; the test bulletin PDF;
    one photograph with a caption; **Preview AAB**; **Post AAB**; green box "Posted".
    - **TRAP:** the AAB is not the Help Centre and not a failure report. A question goes to the Help Centre. An
      advisory to the fleet is an AAB.

## 6.9 Ask SACRED AI (11:47–11:55) `[Slide 13]`

34. **SAY first:** "This opens for Lee and me only, until IT approve it for everyone. Please do not press the button
    on your own laptop; it will not open for you, and the dashboard is not broken."
35. **CLICK/SHOW:** on Dan's laptop, on the projector, press **Ask SACRED AI**.
    - **SAY:** "It is an assistant that reads a digest of every posted report. It answers from the reports, not from the
      internet, and it says which report it read."
36. **CLICK/SHOW:** ask: "Which SSCE Equipment reports were posted on 19 October 2026, and what did the Riser Adapter
    inspection grade?" Read the answer and the sources out. Then one fleet question, for example: "Which rigs graded a
    riser adapter task 4 or 5 in the last ninety days?"
37. **SAY:** "It is an answer, not a record. It can be wrong, it tells you where it looked, and the report is the
    record. Use it to find, not to decide."
    - **TRAP:** if the answer is wrong or slow, say so: "That is exactly why it is not the record." Do not argue with
      it in front of the room.

### Questions and close (11:55–12:00)

38. Workbook questions 6.1 to 6.3 (take one answer each; the rest after lunch if short of time).
39. **Set TestMode (B2) back to No** before you leave for lunch. Write it on the whiteboard at 10:15 so you do not forget.

### If asked

- **"Why can't I see my report?"** The five checks, then ring. Most often: the wrong date, or it is still in the outbox
  waiting to send.
- **"Can the dashboard send me an email when my rig posts?"** The notifications do that already for the reports that
  need it (precharge, CBM to OEM, AAB, help requests, the Daily Summary Report). Others: action list.
- **"Who can see our reports?"** Everyone with dashboard access. A post is permanent and visible.
- **"Why is the CoC figure different from last month?"** The tracker refreshes from the Maximo extract; the figures
  move as Maximo is updated.
- **"Can a rig close its own AAB?"** No. The rig acknowledges; Technical Services close. Never the same person.

**Closing line:** "Every page you saw this morning is a view of files the rigs posted. Fix the file, and the page fixes
itself. Lunch: back at 13:00, laptops on, Argo Navis open."

---

# Module 7: Argo Navis: planning and executing Between Well Maintenance

**13:00–14:30 · Dan and Lee · `[Slide 14]` to `[Slide 23]`**
**Tool:** Argo Navis **REV 16**, `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/`, in `dryRun` test mode (every
email goes to Dan and Lee only, marked **[TEST MODE]**). **Test plan:** **West Vela BOP1, plan
`WVE-BOP1-20261012`** (marked test).

**Roles.** Dan drives the projector and is the **only person who presses Save or any Post button**. Lee answers the
planning questions, watches the room, and verifies on the Help Centre Plans tab if a review is shown live.

### What they should be able to do by 14:30

- Open a rig's plan from the landing page and say how a plan is saved (Save, automatic saves, one file per plan) and
  what the Server save chip tells them.
- Read the Scope Challenge: what a deferral is, why it needs a reason, and how tasks are grouped by SFI.
- Say why SFI 331 and 332 drive BOP % and the BOP ready date, and why riser or MPD work does not.
- Describe review by the regional reviewers and the scope freeze (Hold 1), and what Refresh review does.
- Execute: complete a task, raise break-in work, use a built-in job plan checklist, read the chronology.
- State the daily reporting requirement agreed at the hold point.
- Say what close-out does and what goes into the close-out pack for eDocs.

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

- Open Argo Navis on the projector. Badge reads **REV 16**. The status strip shows Maximo data loaded.
- Landing page → **Existing schedule** → **West Vela** → **Show test plans** ticked. Note the stage of
  `WVE-BOP1-20261012` (on 16 October it read **Executing (v2)**, saved by SAMPLE SSS). The script below assumes it is
  **frozen and executing**: review and the freeze are shown from the record, and you do not press Post for review or
  Freeze scope. If it is at an earlier stage on the day, see the note at 7.3.
- Plan bar check: **Server save ON**; **Test post** ticked; BOP ready chip showing.
- Pick, in advance: one in-progress task to complete; one task with a ☑ **Checklist**; one area and task for a break-in.
  Write them on a sticky note.
- Help Centre open on the **Plans** tab (`/sacred/help/help-centre.html`), on West Vela's card.
- `edocs/SAMPLE-closeout-pack.pdf` on the desktop.
- Lee has the hold point slides 19 to 21 and a pen for the decisions table.

---

## 7.1 The class rule, opening the plan, saving (13:00–13:10) `[Slide 14]` then `[Slide 15]`

1. **SAY:** "This afternoon is the one tool on the fleet that builds the schedule itself. It reads the rig's open PMs
   from Maximo, works out what order the work has to happen in, stacks up the hours and gives you dates. Then the rig
   reports against it twice a day."
2. **SAY the class rule, slowly:** "Open Argo Navis on your own laptop and follow me. Open the test plan from the
   landing page. Look at anything you like. **But only I press Save, Post for review, Post daily report or Post
   close-out.** There is one save file per plan. If ten of us save, we overwrite each other, and every post sends a
   test email."
   - **TRAP:** Argo Navis also **saves itself** when a step is completed and every 30 minutes while there are changes.
     So, on your laptops: **do not type, tick or change anything on the real plan.** Move between pages with the step
     tabs at the top, not the Next buttons. If you want to try something, use **Simulate** (7.2): nothing can be posted
     from a simulation.
   - **TRAP:** if anyone sees a "Saved to server" message on their own screen, tell Dan straight away. He will reopen
     and save the trainer's copy.
3. **CLICK/SHOW:** open `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/`. (Delegates do the same.)
   - **THE ROOM SEES:** the landing page: **New schedule** on the left, **Existing schedule** on the right.
4. **CLICK/SHOW:** **Existing schedule** → rig **West Vela** → **Show test plans** ticked.
   - **THE ROOM SEES:** the plans for West Vela, newest first: BOP, plan, stage, saved by, saved at, copy (Server or this
     PC). `WVE-BOP1-20261012`, marked **test**.
   - **SAY:** "The plan id is the rig code, the BOP and the commencement date. It is given when the plan is set up, so
     the plan can be saved from the Scope Challenge onwards."
5. **CLICK/SHOW:** **Open** on `WVE-BOP1-20261012`.
   - **THE ROOM SEES:** the plan opens on the step it was left on (Execute & Report). The plan bar: plan id, scope
     version, **Frozen**, the BOP ready chip, **Server save ON**, and the buttons **💾 Save**, **Post for review**,
     **Freeze scope**, **Post daily report**, **Post close-out**, **Export**, **Refresh review**.
   - **TRAP:** a delegate whose landing page offers "The copy on this PC is newer than the server copy": tell them to
     choose **open the server copy**. Their PC copy is from an earlier session.
6. **CLICK/SHOW:** the **💾 Save** button and the **Server save ON / OFF** chip.
   - **SAY:** "Save keeps the plan as it is, at any stage. It also saves itself on each completed step and every 30
     minutes. A save is never a review: nobody is told, nothing is re-reviewed. Other PCs see it within about ten
     minutes. One file per plan, so each save replaces the last."
   - **SAY:** "The chip tells you whether the server has your plan. If it says OFF, it tells you why: opened from a
     file, no configuration, or the last save failed. It is never silent. A copy is always kept on this PC too."
   - **CLICK/SHOW:** press **💾 Save** once (trainer only).
   - **THE ROOM SEES:** "Saved to server (available to other PCs within about 10 minutes)".

## 7.2 Scope challenge, deferrals, SFI groups, BOP %, BOP ready date (13:10–13:30) `[Slide 15]` then `[Slide 16]`

7. **CLICK/SHOW:** the **Scope Challenge** tab (step 3). (Delegates use the tab, not Next.)
   - **SAY:** "This is the part that needs your judgement, not the computer's. Every PM inside the window arrives
     ticked Execute. Untick what you are deferring to a later window. That is the scope challenge: what is genuinely
     getting done this time."
8. **CLICK/SHOW:** the boxes at the top: Active in Maximo, Captured by the window (execute and deferred), Not captured,
   Added by hand.
   - **SAY:** "Every active PM is accounted for. Nothing quietly falls off the list."
9. **CLICK/SHOW:** a deferred work order and its reason; the **NC** column.
   - **SAY:** "Deferring a work order asks why: parts, access, crew, superseded. If a work order will not be done before
     its Maximo due date, it needs a Maximo Non-Conformity reference, and the schedule cannot be built until every
     ticked NC has one. The NC number comes from Maximo where it exists."
   - **TRAP:** "The milling question at the top is answered on every plan. Yes means debris may have reached the
     packers, and an annular inspection task is added."
10. **CLICK/SHOW:** the grouping by **SFI**. The headings: 331, 332, 302, 314, 315, 334 to 339.
    - **SAY:** "Work is grouped by SFI, the equipment code, not by who maintains it. So the BOP control work that
      Electrical own still comes through, and MPD's work sits in 339."
11. `[Slide 16]` **SAY:** "**SFI 331 (the BOP stack) and SFI 332 (the BOP control system) are one group: the BOP
    group**, together with the BOP sequence from landing on the beams to the drift test."
    - **CLICK/SHOW:** the **Schedule** tab and the BOP ready banner at the top: BOP ready date, need date, float.
    - **SAY:** "BOP % complete and the BOP ready date are worked out on the BOP group only. Riser or MPD work finishing
      later does not hold the BOP. Green is inside the need date, amber within two days, red past it, with the days of
      rig downtime."
12. **CLICK/SHOW:** press **Simulate** on the banner. (Delegates may do this on their own laptops.)
    - **THE ROOM SEES:** the purple striped ribbon: you are in a simulation.
    - **CLICK/SHOW:** defer one BOP-group task, or slide a duration; watch the BOP ready date move. Then defer a riser
      task; the BOP ready date does not move.
    - **SAY:** "That is the point of the BOP group. Nothing can be posted, saved or downloaded from a simulation."
    - **CLICK/SHOW:** **Reset to the real plan**.
    - **TRAP:** a delegate who leaves Simulate without Reset and then sees odd dates: **Reset to the real plan**, or
      close the tab without saving.
13. **SAY (coming, not built):** "One rule is on its way, from 16 October. A BOP PM under an NC is normally deferred
    because the BOP was subsea. The maintenance window is the chance to do it. So a BOP PM under NC that is left out of
    the window will show a red critical flag at the scope freeze, and the planner will have to give a reason. That is
    not in REV 16 yet."

## 7.3 Review by the regional reviewers and the scope freeze (13:30–13:40) `[Slide 17]`

14. **SAY:** "When the scope is challenged and the schedule built, the rig presses **Post for review**. That sends scope
    version 1 to SACRED. SACRED emails the reviewers, opens the plan's Teams chat and lists the plan on the Help
    Centre's Plans tab."
15. **CLICK/SHOW:** the Help Centre, **Plans** tab, West Vela's card.
    - **THE ROOM SEES:** the region (GOM), the required reviewers, who has verified, "n of m verified", any comments,
      the scope versions.
    - **SAY:** "The required reviewers include the regional ones. Each reads the scope here and verifies it, or asks
      for changes with a comment. A change makes a new scope version, and the review starts again on that version."
16. **CLICK/SHOW:** back in Argo Navis, the state beside the plan id: Awaiting review, Changes requested, Verified,
    Frozen or Closed, with "n of m verified" and who is outstanding.
17. **SAY:** "**Hold 1: Freeze scope works only when every required reviewer has verified this version.** You can
    freeze without full verification, but you must give your name and a reason, and it shows red on the dashboard."
    - **SAY:** "Freezing locks the scope at the version the reviewers verified. From then on, new work is break-in
      work."
18. **CLICK/SHOW:** **Refresh review**.
    - **SAY:** "Refresh review re-reads the review state from SACRED. SACRED updates it every ten minutes. It matters
      only before the freeze. After the freeze, the scope is locked, so there is nothing to refresh into."
    - **TRAP:** "Pressing Refresh review after the freeze and seeing nothing change is correct. It is not broken."
    - **TRAP:** "**Post for review** is greyed on a frozen plan. Do not look for a way round it. New work after the
      freeze is a break-in."
19. **If the test plan is at an earlier stage on the day** (not frozen): press **Post for review** (trainer only); Lee
    verifies on the Plans tab; press **Refresh review** and show "1 of n verified"; press **Freeze scope** and let the
    room read the Hold 1 refusal. **Do not use the override** unless Lee agrees; if you do, the reason is "TRAINING,
    class demonstration" and it shows red.

## 7.4 Executing: complete, break-ins, checklists, the chronology (13:40–13:55) `[Slide 18]`

20. **CLICK/SHOW:** the **Execute & Report** tab. The chronology: dates across the top, the yellow **Now** line,
    numbered milestone stars, the key underneath with each milestone's name, date, time, achieved or estimated.
    - **SAY:** "Rows by SFI group, the BOP group first. Each star is a milestone at its exact time; the key tells you
      which. The Next 24 Hours list under it is the rig's focus list for the day."
21. **CLICK/SHOW:** the in-progress task you chose. Mark it **Complete** (trainer only).
    - **SAY:** "Complete means 100 per cent, finished at the moment you mark it. If you correct an actual finish later,
      you are asked why."
    - **CLICK/SHOW:** **Calculate Project**.
    - **THE ROOM SEES:** the % complete, BOP %, and dates re-forecast.
    - **TRAP:** "Type all your percentages first, then press Calculate Project once. Ticking a step or typing a % does
      nothing to the dates until you do."
22. **CLICK/SHOW:** the ☑ **Checklist** button on the task you chose.
    - **THE ROOM SEES:** the job plan as a checklist, inside Argo Navis: each step Done / N/A / Not OK, photographs,
      materials used, **Performed by** and **Verified by**.
    - **SAY:** "The job plan checklists are built in. N/A and Not OK need a comment. A Not OK step asks for a CM or
      Synergi reference. The checklist's % drives the task's %. Signed, it shows SIGNED with the evidence linked."
    - **TRAP:** delegates may open the checklist on their laptops to look. **Close it with ✕ without ticking anything.**
23. **CLICK/SHOW:** **Break-in Work**: raise one (trainer only). Pick the area, the SFI and the task it comes after;
    give the hours and a description starting "TRAINING".
    - **THE ROOM SEES:** **BRK-nnn**, numbered automatically; after Calculate Project, the finish, the float and the
      BOP ready date move.
    - **SAY:** "After the freeze, the rig controls new work. It needs no work order and no approval. It is numbered
      BRK-001 onwards. Its hours move the schedule and the critical path, and every break-in goes in the daily
      report. The rig is now the planner on the ground."
    - **TRAP:** "A delay is not a break-in. Waiting for a crane, a permit, the weather: that goes in Waiting / NPT, and
      you name the task it holds up. NPT does not move the dates, because the delay already shows in your actuals.
      If the wait turned into real work, it is a break-in instead, not both."
24. **CLICK/SHOW:** the Deferrals & Non-Conformities table under the actuals.
    - **SAY:** "Deferring a work order after the freeze still needs a reason. Every deferral and NC is listed here and
      printed in the report."

## 7.5 Post the first daily report, then the HOLD POINT (13:55–14:10) `[Slide 19]` `[Slide 20]` `[Slide 21]`

25. **CLICK/SHOW:** on Execute & Report: the **Report Time (after shift handover)** box; **Project & Rig People**.
    - **SAY:** "The report time is the rig's own: the time of your handover, not a fixed 0600 or 1800. Leave it blank
      and it uses the time you post. The people are filled once and updated at crew change; they print on every
      report."
26. **CLICK/SHOW:** **Preview as SACRED prints it**.
    - **THE ROOM SEES:** the Daily Summary Report as it will be printed.
27. **CLICK/SHOW:** **Post daily report** on the plan bar (trainer only). Note the time on the whiteboard.
    - **SAY:** "**Hold 2: Post daily report is available only after the freeze.** It has gone. Within about 35 minutes
      the scanner prints the PDF from WCGRRT's template and the Daily Summary Report flow emails it. In test mode that
      is to Lee and me only, marked [TEST MODE]. We will look for it at 14:45."

**HOLD POINT: daily reporting requirements (15 minutes, discussion). Lee chairs the decisions; Dan writes them up.**

28. `[Slide 19]` **When and by whom.** **SAY:** "We stop here to agree the requirement, because from now on the rig
    sends this report, not the planner."
    - The rig posts the Daily Summary Report **twice a day, after each shift handover**, from Argo Navis.
    - The report time is the rig's own.
    - A red **Daily report due** chip shows on the plan bar when more than 14 hours have passed since the last one.
29. `[Slide 20]` **What is inside and who it goes to.** Read the slide, do not dwell:
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
30. `[Slide 21]` **To agree.** Lee takes each line in turn; Dan fills the decisions table on the slide and in his
    workbook; anything not settled goes on the action list with an owner and a date.

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

31. **SAY:** "Two routes, one report. Between Well Maintenance plans are in Argo Navis, and the rig posts from there.
    P6 projects, the complex capex ones, post WCGRRT's **Planning Report** instead: Discipline = Planning, the same
    twice-daily rule, the same report time, and **Import ERT** fills the lists, milestones, critical path and % from
    the P6 export."
32. **SAY:** "Both print the same Daily Summary Report, cut from the same rules, and both are emailed by the same flow
    to the same people. The post is named with the date, rig, type, BOP and report time, so two reports a day never
    overwrite each other. The BOP Fleet Planning tiles update from either."
    - **TRAP:** "On a P6 project there is no plan chat, so no Teams line. The email carries the link."

## 7.7 Close-out and the close-out pack (14:15–14:25) `[Slide 23]`

33. **CLICK/SHOW:** **Post close-out** on the plan bar. **Do not press it.**
    - **SAY:** "Close-out is available when every task is complete and every deferred work order has a reason. It
      closes the plan, with the eDocs reference of the close-out record. Our test plan is mid-job, so it is greyed."
34. **CLICK/SHOW:** open `edocs/SAMPLE-closeout-pack.pdf` (built on 16 October from a West Vela test close-out).
    - **THE ROOM SEES:** one PDF: a cover (rig, BOP, plan id, scope version, closed-out date, a blank eDocs number), a
      contents sheet listing every file in the project folder with its date and fingerprint (SHA-256), then the plan,
      the pre-deployment checklist, the tests, the CBM records, the precharge, the evidence and the close-out, each on a
      new page with its own title block.
    - **SAY:** "When a plan is closed, SACRED joins every record filed for it into this one pack, in the plan's
      project folder under 08 AAR and Close-out. That is what goes to eDocs. The connection that copies it into eDocs
      automatically is waiting on ISIT; until then it is filed by hand."
35. **SAY:** "So the life of a plan is: open it, challenge the scope, build the schedule, post for review, the
    reviewers verify, freeze, execute with break-ins and checklists, report twice a day, close out, and the pack goes to
    eDocs." `[Slide 15]` (back to the life-cycle slide for ten seconds).

### Questions (14:25–14:30)

36. Workbook questions 7.1 to 7.3.
37. **Before the break, say:** "Close Argo Navis on your laptops now, without saving. If it asks, choose not to keep
    changes."

### If asked

- **"What if two people on the rig both have the plan open?"** One save file per plan: the last save wins. Agree who
  holds the pen on each shift; that is part of decision 1.
- **"Can we work offline?"** Not yet for Argo Navis. A copy is kept on the PC, and the tablets-offline work comes after
  ISIT's HTTPS (Module 9).
- **"What if the post fails?"** The tool shows the error and saves the file to your Downloads. Send both to the office.
- **"Does a break-in need a work order?"** No. It is BRK-numbered. If it becomes real corrective work, raise the CM in
  Maximo as normal.
- **"Why does my rig show a thin schedule?"** The Branch Map cannot sequence every job plan yet; Step 1 shows the
  "Sequenceable %" per rig. Low % means a thin schedule.
- **"Who are the reviewers for my region?"** They are listed on the plan's card on the Plans tab. Changes to the list:
  action list.
- **"Is the BOP ready date the end of the whole plan?"** No. It is the finish of the BOP group: SFI 331 and 332 and the
  BOP sequence.

**Closing line:** "The rig is now the planner on the ground. Argo Navis gives you the plan, the clock and the report;
what you put in it is what the fleet sees. Break: back at 14:45."

---

# Module 8: the loop, and the TSC Help Centre hands on

**14:45–15:30 · Dan and Lee · `[Slide 24]` to `[Slide 27]`**

### What they should be able to do by 15:30

- Draw the loop from memory: tool, file, intake, library, scanner, page, notification with a link, receipt.
- Say how the tools connect today and which pieces are still to come.
- Say what a failure looks like at each step and who sees it.
- Raise a help request from the tool and follow it to the email, the Teams chat, the receipt and the acknowledgement.

### Timing

| Part | Minutes | Clock | Slide |
|---|---|---|---|
| 8.0 Did the daily report arrive? | 2 | 14:45–14:47 | 24 |
| 8.1 How the tools connect today, and how the rest will be | 8 | 14:47–14:55 | 25 |
| 8.2 Help Centre, part 1: post the requests (so their clock starts) | 5 | 14:55–15:00 | 27 |
| 8.3 What a failure looks like, and who sees it | 10 | 15:00–15:10 | 26 |
| 8.4 Help Centre, part 2: the page, the email, the chat, the receipt, the acknowledgement | 15 | 15:10–15:25 | 27 |
| Questions and close | 5 | 15:25–15:30 | 27 |

---

## 8.0 Did the daily report arrive? (14:45–14:47) `[Slide 24]`

1. **CLICK/SHOW:** Outlook, on the projector.
   - **THE ROOM SEES (if it has arrived):** `[TEST MODE] West Vela BOP1 BWM Reporting <date> <time>`, to Dan and Lee,
     with the PDF attached, the header and milestones in the body, and the dashboard link.
   - **SAY:** "That is the report Argo Navis posted at five to two, printed and emailed with nobody touching it."
   - **CLICK/SHOW:** open the PDF for ten seconds; click the dashboard link.
   - **If it has not arrived:** **SAY:** "It can take about 35 minutes. We will look again at 15:25. If it is still not
     here, that is a failure at one step of the loop, and in a minute I will show you how we find which."

## 8.1 How the tools connect today, and how the rest will be (14:47–14:55) `[Slide 25]`

2. **CLICK/SHOW:** draw it on the whiteboard, one box at a time, while you say it:
   **the tool on the rig → one file → the intake → the reports library → the scanner → the page → the notification with
   a link to the page → the receipt.**
3. **SAY:** "Every loop you have seen in two days is that one pattern. The daily report, the CBM to NOV, the precharge,
   the AAB, the Argo Navis daily report, the help request. Post, scan, page, notification, receipt. When something new
   is built, it is built on the same pattern, which is why it takes days and not months."
4. **SAY:** "Three things to hold onto. One: the file is the record, and the dashboard is a view of it. Two: every
   notification carries a link to the page, so a report is read once, on the dashboard, not forwarded around. Three: a
   receipt is written for every notification that went, so the office can prove what was sent to whom."
5. **SAY, how the rest will be (Lee):** "What is not joined yet: the close-out pack copied into eDocs automatically
   (waiting on ISIT); BOP cycle counts from PLATO; Maximo's corrective work orders into the plan; the tablets working
   offline. Module 9 has the dates."

## 8.2 Help Centre, part 1: post the requests (14:55–15:00) `[Slide 27]`

6. **SAY:** "The Help Centre is for the rig to reach Technical Services with a problem that is not a report: a tool
   question, an equipment question, a dashboard question. It posts the same way a report does."
7. **Hands on, in pairs.** One help request per pair, from SSORT REV 169 on **SSCE Equipment**:
   - a short title starting **TRAINING**; the category; two lines of text; one photograph from the USB stick.
   - **Post.** Note the time in the workbook.
   - **SAY:** "SSCE Equipment means the email and the chat go to the office only. Nothing reaches a rig."
   - **TRAP:** one post per pair, not one per person. Each post opens a Teams chat for the office.
   - **TRAP:** the asset must read **SSCE Equipment** before Post. On a real rig name, the rig's people are emailed.
8. **CLICK/SHOW:** Dan posts one as well, from the projector, so the room can watch one end to end.

## 8.3 What a failure looks like, and who sees it (15:00–15:10) `[Slide 26]`

9. **SAY:** "Now, step by step, what a failure looks like and who sees it." Point at each box on the whiteboard.

   | Step | What a failure looks like | Who sees it |
   |---|---|---|
   | The tool on the rig | WCGRRT tells you under Post whether it posted. SSORT says so under 📤 Post Report. With no connection the post waits on the laptop: **📤 n waiting to send**; press **Send now**. | The rig, on the screen. |
   | The intake and the library | A post that never arrived: no row on the dashboard after ten minutes. | The rig, on the dashboard. |
   | The scanner | The "last scan" stamp goes stale. The office gets an email within the hour. The Status page shows it. | The office first; anyone who reads the stamp. |
   | The page | A file the scanner cannot read, or one over the size ceiling: listed on the **Errors** button. | Everyone with the dashboard. |
   | The notification | The email could not be sent: a **NOT SENT** email goes to the office with the whole request as text, and the receipt says so. | The office. |
   | The receipt | No receipt: the Help Centre shows **No delivery receipt yet** in amber after 20 minutes; after an hour it is on the Errors button. | The office, on the page. |
   | Argo Navis | The **Server save OFF** chip, always with the reason; a failed post shows the error and saves the file to Downloads; the **Daily report due** chip after 14 hours. | The rig, on the plan bar; the office, on the tile. |

10. **SAY:** "Nothing fails silently on the office side. On the rig side, the one to watch is the outbox: a post that
    could not go waits on your laptop. Open the tool, wait three seconds, and if you see 📤 waiting to send, press Send
    now. A late post is not a fault; the dashboard dates it by its own date."
11. **CLICK/SHOW:** `/sacred/status/`, the Status page, for thirty seconds: the scan time, and the build each rig last
    posted from.
    - **SAY:** "If your rig is still on an old build, it shows amber here."

## 8.4 Help Centre, part 2 (15:10–15:25) `[Slide 27]`

12. **CLICK/SHOW:** open the TSC Help Centre from the dashboard's **TSC Help Centre** button
    (`/sacred/help/help-centre.html`). The office side needs a password: type it with the projector frozen or off.
    - **THE ROOM SEES:** the requests, including the class's, each with **Sent to N at hh:mm** (or **pending** in the first
      twenty minutes).
    - **SAY:** "The scanner reads the requests every ten minutes, and the flow polls for new ones, so allow up to a
      quarter of an hour."
13. **CLICK/SHOW:** Outlook: the office email for Dan's request, `[TEST MODE]`, with the photograph attached and the
    red line naming who it would have gone to on a real rig.
14. **CLICK/SHOW:** Teams: the chat `[TEST] SSCE Equipment - <date> - …`, with the request as its first message.
    - **SAY:** "On a real request, the chat is opened with the people on the help list and the rig's people. Today it
      is the office only."
15. **CLICK/SHOW:** on the Help Centre page, **Acknowledge** Dan's request: who is dealing with it, a line of text.
    - **SAY:** "The acknowledgement goes back under the same email subject with RE: in front, so it lands in the same
      conversation, and into the same Teams chat. The rig is never asked to look anywhere new."
    - Wait for the scan if needed; meanwhile acknowledge one pair's request as well.
16. **CLICK/SHOW:** the receipt beside the request: sent to whom, how many, when, and the mode (test).
    - **SAY:** "That is the proof of what was sent to whom. If anyone says 'we never got it', this is where we look."
17. **CLICK/SHOW:** close Dan's request from the page.
    - **TRAP:** "The Help Centre is not the AAB and not the daily report. A question goes here. An advisory to the fleet
      is an AAB. Progress on a BWM plan is the Daily Summary Report."

### Questions and close (15:25–15:30)

18. Check Outlook once more for the daily report if it had not arrived at 14:45.
19. Workbook questions 8.1 to 8.3.

### If asked

- **"Can the rig see the Help Centre page?"** The rig gets the email, the chat and the acknowledgement. The office
  side of the page is password-gated for the people who answer.
- **"What is the six-hour chat?"** A rig-down request still open after six hours gets a chat with the downtime group and
  the rig's management, as the directive asks. It is automatic.
- **"Why didn't my request show yet?"** The flow polls; allow up to fifteen minutes, then check the asset and the post
  message in the tool.

**Closing line:** "One pattern: post, scan, page, notification, receipt. If you can draw it, you can find any failure
in it. Next: what is coming."

---

# Module 9: what is coming

**15:30–16:15 · Dan · `[Slide 28]`**

### What they should be able to do by 16:15

Say what changes on the rig and in the office in the next six months, what does not, and who owns each change.

### Timing

| Part | Minutes | Clock |
|---|---|---|
| 9.1 On the rig | 15 | 15:30–15:45 |
| 9.2 In the office | 15 | 15:45–16:00 |
| 9.3 What does not change, and questions (workbook 9.1 to 9.3) | 15 | 16:00–16:15 |

**SAY to open:** "Everything on this list has an owner and is on a plan. Where a date depends on someone outside this
room, I will say so. Nothing here is a promise until it ships with a written note to you first."

## 9.1 On the rig (15:30–15:45)

1. **Tablets, offline.** **SAY:** "The tools already keep a post on the device when the signal drops and send it when it
   comes back. That is the outbox you saw on Monday. The next step is installing SSORT and WCGRRT on iPads and Android
   tablets so they open with no signal. The tools side is built. The one thing left is ISIT putting HTTPS on the
   server; it was requested for the end of October. Then a tablet test, then the rollout through Intune."
2. **Argo Navis: NC deferrals at the scope freeze.** **SAY:** "You heard it at 13:25. A BOP PM under an NC, left out of
   the window, will show a red critical flag at the freeze, with a reason required and the details listed for the
   reviewers. Other SFIs show amber. Open, overdue work orders with no NC will show red on the plan. Sent to Lee on 16
   October; not built yet."
3. **Argo Navis: event PMs and CBM PMs in every plan.** **SAY:** "Maximo's event-based BWM PMs, and the CBM programme PMs
   on CBM rigs, come into every plan, grouped by component so a door's BWM, 3-monthly and 6-monthly run together."
4. **Argo Navis: the rig's own work order slice.** **SAY:** "On a rig or tablet, Argo Navis will load just that rig's
   work orders instead of the whole fleet's."
5. **Maximo corrective work orders.** **SAY:** "Today only PM work orders come through the feed, so unplanned work is a
   break-in. Manpreet has the request for the CM rows, plus the original target dates that show when an NC moved a
   date."
6. **PLATO cycle counts.** **SAY:** "PLATO is the live feed from the BOP control systems. The aim is cycle counts on the
   cavity table and NOV's usage table filled from PLATO, not by hand. The data is in Nick's system; we need a
   scheduled export or a read-only account from him."

## 9.2 In the office (15:45–16:00)

7. **The scanner moves to the server.** **SAY:** "The scanner, the script that builds every page every ten minutes, still
   runs on my laptop. It moves onto the SACRED server with a service account. Nothing you do changes. The date is being
   confirmed with ISIT; it was planned for this week and will not happen while we are here."
8. **eDocs.** **SAY:** "The close-out pack you saw at 14:20 is built today. Copying it into eDocs automatically, with a
   Project complete button, needs ISIT to set up the eDocs connector: a key, a service account and a licence. Until
   then the pack is filed by hand."
9. **The Fabric database.** **SAY:** "Everything the scanner reads is also exported as tables for a database, so the
   fleet's records can be queried and reported on. The Argo Navis plan tables are next to be loaded."
10. **The rebuild of the pages, and Ask SACRED AI for everyone.** **SAY:** "The SACRED pages are planned to move onto a
    hosted platform, with a sign-in using your Seadrill account instead of a password. Ask SACRED AI comes with it, for
    everyone signed in. The tools on your laptop post to the same place on day one. The plan is a production go-live
    in early 2027, and you get a two-page 'what moved' before it."
11. **Seadrill CORE.** **SAY (Lee):** "CORE, Central Operations and Resource Environment, is the company-wide app for
    Technical Services' standards that Lee is building: the same globe as the planning page, and a click on a rig opens
    its requirements as a linked map: region, vessel, SFI, maintenance, regulatory. Early days; Thursday's standards
    work feeds it."

## 9.3 What does not change (16:00–16:15)

12. **SAY:** "What does not change: the tools you used on Monday, the post, the ten-minute scan, the dashboard, the
    notifications, the precharge request and the PDF as the controlled document. Every change ships with a written note
    to you before it does. You will never meet a revision cold."
13. Workbook questions 9.1 to 9.3. Take answers round the room.

### If asked

- **"When do we get tablets?"** After ISIT's HTTPS, then a test on one tablet, then Intune. No date until HTTPS is done.
- **"Will the links change?"** Possibly once, when the pages move platform. You will be told before.
- **"Can PLATO replace our hand counts now?"** Not yet. The cycle-count lines are manual until the PLATO feed is in.

**Closing line:** "That is the next six months. Now the most important part of the day: what you want next."

---

# Module 10: feedback

**16:15–17:00 · All; Dan chairs, Lee takes the action list · `[Slide 29]` then `[Slide 30]`**

### What they should be able to do by 17:00

Each delegate has written down what is hard on the rig today and what the tools should do next, and each point is on
the action list with a name and a date.

### Timing

| Part | Minutes | Clock |
|---|---|---|
| 10.1 The feedback sheet, in silence | 10 | 16:15–16:25 |
| 10.2 Round the room: what is hard on the rig today | 12 | 16:25–16:37 |
| 10.3 Round the room: what the tools should do next | 12 | 16:37–16:49 |
| 10.4 The UAT sign-off | 8 | 16:49–16:57 |
| 10.5 Close | 3 | 16:57–17:00 |

1. `[Slide 29]` **SAY:** "Ten minutes, on your own, the feedback sheet at the back of your workbook. Three things that are
   hard on the rig today; three things the tools should do next. Say what, not why."
2. **Round one.** One thing each that is hard on the rig today. Lee writes each on the action list with a name and a date.
   - **SAY:** "Thursday's efficiency forum argues from what you wrote today, not from memory."
   - **TRAP:** do not answer or defend. Write it down. "Thank you, that is on the list." Debate is for Thursday.
3. **Round two.** One thing each the tools should do next. Same list.
4. **The UAT sign-off** (the separate sheet, naming WCGRRT REV 174, SSORT REV 169 and Argo Navis REV 16). Read the
   statements out. Each delegate signs their own line.
   - **SAY:** "This is not a test you can fail. It is the record that the people who will use the tools have used them,
     and that they did what we said. If a line is not true for you, do not sign it; write why on the back, and it goes
     on the list."
5. `[Slide 30]` **Close.** **SAY:** "Before you leave: open both tools on your laptop, wait three seconds, and if you see
   📤 waiting to send, press Send now. Monday's posts and today's test requests are removed from the library this week.
   On a real rig a post is permanent and visible. Thank you. Tomorrow at 08:00: technical standards."
6. Collect the feedback sheets and the UAT forms.

**Closing line:** "Two days ago these were tools you were sent. Now they are tools you have used, and the list on the
wall is what we build next."

---

# Trainer's checklist for Tuesday morning (one page)

**Monday evening**

- [ ] Argo Navis: open **`WVE-BOP1-20261012`** (West Vela, test) from the landing page; note its stage (expected
      **Executing**); Server save ON; Test post ticked. Pick the task to complete, the checklist task and the break-in
      area; write them on a sticky note.
- [ ] Help Centre: the Plans tab shows West Vela's card and its reviewers.
- [ ] `edocs/SAMPLE-closeout-pack.pdf`, the three precharge exercise files and `TRAINING-01_West-Tellus_issued_precharge.pdf`
      on the desktop.
- [ ] The AAB test bulletin PDF and one photograph on the desktop.
- [ ] USB stick: three training photographs for the help requests.
- [ ] Ask SACRED AI opens on Dan's laptop.
- [ ] The workbooks printed; the feedback sheet at the back; the UAT forms naming REV 174 / 169 / REV 16.

**07:30 Tuesday**

- [ ] Projector laptop: WCGRRT **REV 174**, SSORT **REV 169**, Argo Navis **REV 16** badges. Ctrl+F5 on every page.
- [ ] Dashboard "last scan" stamp within ten minutes. If not: ring the office before 08:00.
- [ ] Request form and Precharge Pro open; the badge noted; the Tellus clean run reproduces **3,725 PSIG**.
- [ ] Tabs for 10:15: Rig Visit Dashboard (SSCE Equipment, 30 days), BOP Fleet Planning, CoC tracker (local copy),
      SSCE Requests, Bulletin Board create and fleet pages, Outlook, Teams.
- [ ] Settings workbook open in a tab, ready to set **TestMode (B2) Yes at 10:00** and **No at 12:00**. Written on the
      whiteboard.
- [ ] Action list on the wall; Lee has the pen.
- [ ] Slides 1 to 30 in order; slide 21's decisions table blank.

**During the day**

- [ ] 08:00 and 13:00: say the three rules (nothing posted in precharge; only the trainer presses Save or Post in Argo
      Navis; everything under MOC).
- [ ] 10:15: post the training AAB first, with TestMode Yes.
- [ ] 12:00: TestMode back to **No**.
- [ ] 13:55: Post daily report; write the time on the board; check Outlook at 14:45 and 15:25.
- [ ] 14:30: delegates close Argo Navis without saving.
- [ ] 17:00: every laptop checked for 📤 waiting to send; sheets and forms collected.

**After the class**

- [ ] Delete the class's help requests and the test AAB files from the reports library; close the test AAB.
- [ ] Write the hold point decisions up and send them to Lee with the action list.

---

# Answers to the workbook questions

## Module 5: the precharge process

**5.1 A rig sends a request with MAWHP 3,500 psi and a minimum shear pressure of 5,200 PSIG. What does the form do,
what is the likely cause, and why does it not simply reject it?**

> It shows a **warning**: the shear pressure looks high for that MAWHP; check you read the column matching your MASP
> and not the 15,000 psi column, the most common error on the form. The likely cause is reading the estimator's 15,000
> psi worst-case column. It warns rather than blocks because the value can legitimately be that high; a hard block on a
> valid case only teaches people to work round the form. The requester must confirm.

**5.2 The contractual panel shows one shear passing and the second shear failing by −5 psi and −0.74 gal. Can the
sheet be posted, and what may still be done with it?**

> **No.** Post to Dashboard is refused, with a message naming both failing cases and their margins. Nothing leaves the
> browser: no file, no email, no dashboard entry. Save, Export and Generate PDF still work, so the sheet can go into an
> engineering review. The next step is to raise the precharge or confirm the acoustic bank precharge, never to lower the
> requirement until it passes.

**5.3 The sheet quotes 3,725 PSIG at 78 °F deck temperature. On the day the deck is 60 °F. What do you charge to, and
where do you find it?**

> **Not 3,725.** A precharge is only correct at the temperature it is quoted at. Read the value for 60 °F from the
> precharge-against-temperature table on **page 3** of the PDF. The table is always printed on the issued PDF for this
> reason.

**Exercise record answers (5.3 exercise in the workbook):** Group A 3,725 PSIG, checks pass; Group B per accumulator
(Blue POD Pilot 5,156; Manifold Reg. Pilot 3,743; LMRP, Stack and Upper Annular Reg. Pilots 3,293 PSIG subsea), and the
numbers do not change for BOP 2; Group C 4,750 PSIG API optimum, BSR closes at 3,679 against 2,050. The two signature
lines are **Calculated** and **Verified**; the generation timestamp is not a signature. The ISSUED email goes To the
rig's subsea supervisor, TSL, assistant rig manager and rig manager (office on Cc), and carries the PDF only.

## Module 6: the SACRED dashboards

**6.1 The "last scan" stamp reads 07:40. It is 08:30. You posted at 08:05. What has happened, and what do you do?**

> The scanner has stopped: nothing has been scanned for fifty minutes, so your post is sitting in the library unread.
> Refreshing changes nothing. Ring the office; they already have an email, because the freshness check runs every hour.
> Your post is not lost; it appears on the first scan after the scanner is back.

**6.2 On the CBM Heatmap a Riser Adapter cell is red. The history shows a grade 5 on a task that is a pressure test.
Is the riser adapter condemned?**

> No. On a test, NOV grade 1 for a pass and 5 for a fail, with no middle grade. A 5 there is a **failed test**, which
> needs acting on, not a condition grade on the component. The condition grades are the 1-to-5 inspection tasks. The
> note under each task in SSORT says which kind it is.

**6.3 A West Vela advisory shows "acknowledged" on the fleet compliance page. Who acts next, and can the rig close its
own case?**

> Technical Services act next: they review both crews' acknowledgements and the evidence on the fleet compliance page,
> then close it with a name and a comment. **The rig cannot close its own case**, and Technical Services cannot
> acknowledge for the rig. The rig acknowledges; Technical Services close.

**Exercise record answers (Module 6 follow-along):** "needs attention" counts a failed reading, a commented reading,
or a visit action still with the rig; the Errors button lists unreadable files, files over the size ceiling and help
requests without a delivery receipt; the SSCE request is raised from the CoC tracker and approved on the SSCE Requests
Dashboard; the AAB states shown in the legend are six, with overdue a date past the due date.

## Module 7: Argo Navis

**7.1 Why does only the trainer press Save today, and what is the difference between Save and Post for review?**

> There is **one save file per plan**, so each save replaces the last: ten people saving would overwrite each other, and
> every post sends a test email. **Save** keeps the plan as it is, at any stage; nobody is told and nothing is reviewed.
> **Post for review** sends a scope version to SACRED, which emails the reviewers, opens the plan chat and lists it on
> the Help Centre Plans tab for verification.

**7.2 Two days after the scope freeze, the crew finds a damaged hydraulic fitting that must be replaced. What do you do
in Argo Navis, and what does it change?**

> Raise it as **Break-in Work**: pick the area, the SFI and the task it follows, give the hours. It is numbered BRK-nnn
> automatically, needs no work order and no approval: the rig controls it. Its hours move the finish, the float, the
> critical path and, if it is in the BOP group, the BOP ready date. It is reported in the next Daily Summary Report. You
> do not post for review again: after the freeze the scope is locked. (A pure wait, such as for a crane, goes in Waiting /
> NPT instead.)

**7.3 Riser work on the plan will finish two days after the BOP stack work. Does that move the BOP ready date? Why?**

> **No.** BOP % and the BOP ready date are worked out on the **BOP group only**: SFI 331 (the BOP stack) and SFI 332
> (the BOP control system), with the BOP sequence from landing on the beams to the drift test. Riser or MPD work
> finishing later does not hold the BOP.

**Exercise record answers (Module 7 follow-along):** the landing page offers New schedule and Existing schedule; the
plan opens on the step it was left on; the chip reads Server save ON; Hold 1 is the freeze (every required reviewer
verified, or an override with name and reason, shown red); Hold 2 is Post daily report (only after the freeze); Refresh
review matters only before the freeze; the close-out pack goes in 08 AAR and Close-out and is what goes to eDocs.

## Module 8: the loop

**8.1 Draw the loop. Eight boxes, in order.**

> The tool on the rig; one file; the intake; the reports library; the scanner; the page; the notification with a link
> to the page; the receipt.

**8.2 Your rig posted its Daily Summary Report at 07:10. At 08:00 nobody has the email. Name two places to look, and
who sees each failure first.**

> (1) **The dashboard:** is the report on the BOP Fleet Planning tile, and is the "last scan" stamp fresh? A stale stamp
> means the scanner stopped; the office has the email first. (2) **The tool:** did Argo Navis show an error, the Server
> save OFF chip, or a file saved to Downloads? Did the post wait in the outbox? The rig sees that first. A notification
> that could not be sent goes to the office as NOT SENT. Allow about 35 minutes before calling it late.

**8.3 Which goes where: a question about why the CBM form shows fewer grade buttons; an advisory to every rig about a
bolt batch; the twice-daily progress on a BWM plan.**

> The grade-button question is a **TSC Help Centre** request. The bolt batch is an **AAB**, Priority 3, on the Seadrill
> Bulletin Board, acknowledged by each rig's TSLs. The progress is the **Daily Summary Report**, posted from Argo Navis.
> Three loops, three audiences, one pattern.

**Exercise record answers (Help Centre hands-on):** the email is marked [TEST MODE] and goes to the office only on SSCE
Equipment; the chat is named `[TEST] SSCE Equipment - <date> - …`; the receipt shows **Sent to N at hh:mm**; the
acknowledgement comes back under the same subject with **RE:** in front, and into the same chat.

## Module 9: what is coming

**9.1 What is the one thing stopping SSORT and WCGRRT opening on a tablet with no signal, and who owns it?**

> **HTTPS on the server.** Tablets keep an offline web app only over HTTPS; the server answers on HTTP today. ISIT own
> it; it was requested for the end of October. The tools side is already built, and the outbox already works.

**9.2 What will Argo Navis do, once Handoff 5 is built, if a BOP PM under an NC is left out of the window at the scope
freeze?**

> Show a **red critical flag** on the Scope Challenge, the plan bar and the freeze. The freeze cannot go through
> silently: the planner gives a reason for each one, and the details (work order, NC number, dates, days deferred, what
> the rig intends, who descoped it) are posted for the reviewers. Other SFIs under NC show amber. It is coming, not built
> in REV 16.

**9.3 The scanner moves from Dan's laptop to the server. What changes for the rig?**

> Nothing in what you do. The tools, the posting, the ten-minute scan, the dashboard and the notifications all stay the
> same. The date is being confirmed with ISIT.
