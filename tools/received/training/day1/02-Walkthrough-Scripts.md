# Day 1 walkthrough scripts — the reporting tools

**Class:** Monday 19 October 2026, Houston · **Frozen builds:** WCGRRT **REV 168**, SSORT **REV 156**
**Led by:** Dan (all four modules; Brad Waldron is not attending and nothing below depends on him)
**Asset:** `SSCE Equipment` throughout. Nothing is posted on a real rig name.
**Build freeze: 12 October 2026.** From that date neither tool changes before the class unless a rig
is losing work, so what is written here will still be what is on screen on the 19th.

**How to read this.** Numbered steps are what the trainer does and says. `SAY:` is a line to say more
or less as written, because it is either a safety point or a thing people get wrong. `[SHOT n]` marks
a screenshot for the workbook; the numbering runs continuously 1–24 across all four modules and
matches `TRAINING-Day1-Screenshot-List.md`. `TRAP:` is something the room will get wrong if it is not
said out loud.

**Before the room arrives:** open WCGRRT REV 168 and SSORT REV 156 in two browser tabs from
`\\sdrlazneuiis01d.corp.local\sacred\` and `…\SSORT\`. In both tabs press **⊘ New Trip** so there is
no leftover state from setting up. Have the dashboard open in a third tab on the SSCE Equipment
filter. Confirm both tools show the frozen revision in the badge before you start — if either does
not, stop and say so rather than teach a different build.

---

# Opening — not yours
**08:00 – 08:30 · Lee Arnold**

Safety minute, roles and responsibilities, expectations for the week. Day 1 and Day 2 of the class
sit inside Lee's WCE SME workshop (19 to 22 October), so he opens it. Nothing below starts until
08:30; be set up and on the badge check before he finishes.

---

# Module 1 — WCGRRT: rig visit and daily reports
**08:30 – 10:00 · WCGRRT REV 168**

### What they should be able to do by 10:00
Start a trip, set the rig identity, add a daily report entry with equipment entries and captioned
photographs, understand which date names the file, and explain the two mistakes made during the West
Capella week and what the tool now does about them.

### 1. Open the tool and read the badge (5 min)

1. Load WCGRRT from the share. Point at the revision badge. `[SHOT 1]`
2. **SAY:** "This is REV 166. Everything today is that build. When a revision ships you get told in
   the handoff — you do not need to hunt for it, but you do need to know which one you are on when
   you ring the office about something that looks wrong."
3. Point out **⊘ New Trip**, **↓ Browser Save**, **↑ Browser Load**, **💾 Save to File**,
   **📂 Load from File**, **⎙ Print / PDF**, **📤 Post Report**.
4. **SAY:** "Browser Save keeps it in this browser on this machine. Save to File gives you a `.json`
   you can email or keep. Post Report is the one that puts it on the dashboard. They are three
   different things and only the third one reaches anybody else."

### 2. Visit Information — rig identity first (15 min)

5. In **Visit Information**, set **Rig / Asset** to `SSCE Equipment` (under *Not rig-specific*).
   `[SHOT 2]`
6. **SAY:** "Rig identity is the one field the tool will not let you skip. Everything on the
   dashboard hangs off it."
7. Demonstrate the guard: clear Rig / Asset, press **📤 Post Report**, show the dialog, cancel.
   `[SHOT 3]`

   > Cannot post: no Rig / Asset selected.
   > Set Rig / Asset in Visit Information first — a report with no rig cannot be attributed and will
   > not display correctly on the dashboard.
   > If this work is not rig-specific (for example a vendor audit on corporate equipment), choose
   > "SSCE Equipment" under "Not rig-specific".

8. **SAY:** "This is a fail-closed guard and it exists because nine reports once landed in a bucket
   called Unattributed in a single scan. Nobody could tell whose work it was. The tool now refuses
   rather than guess."
9. Set **Discipline**, **Visit Classification**, **Visit Start Date** and **Visit End Date**. Restore
   `SSCE Equipment`.
10. **SAY:** "Discipline changes the form. Pick Planning and the BOP blocks disappear and you get a
    planning report instead. That is deliberate — you only see the boxes your job needs."

### 3. A daily report entry (35 min)

11. From the section dropdown choose **📋 Daily Report Entry** and add it. `[SHOT 4]`
12. Set the tile's date. Fill the narrative.
13. Add an **equipment entry**; fill make, model, serial, and the work done. `[SHOT 5]`
14. Add two photographs to the entry and **caption both**. `[SHOT 6]`
15. **SAY:** "Caption every photograph. An uncaptioned photograph on the dashboard is a picture of a
    flange that nobody can place. Thirty seconds now saves the office ringing the rig."
16. **SAY:** "Photographs are compressed on the way in — a 6 MB phone picture lands at about 300 KB.
    You do not need to shrink them first and you should not reduce quality to save space."

### 4. The report date, and the Capella-week mistakes (40 min)

This is the heart of the module. Do not rush it.

17. Point at **Report Date** in the daily report block. `[SHOT 7]`
18. **SAY:** "This box, and not the visit date, is what names the posted file for a daily report. A
    daily report is one per rig per day, and it is named for the day it covers."
19. **SAY:** "Two things went wrong in the West Capella week. First, reports were posted before they
    were finished, so the office worked from half a report. Second — and this is the one that cost
    real work — entry dates were left on yesterday, so two different days were posted under one file
    name and the second one replaced the first. A day's work disappeared. It was recovered from
    Brad's own saved copies, and it should never have needed recovering."
20. Demonstrate the guard. Set **Report Date** to a date a couple of weeks back, press
    **📤 Post Report**, and show the dialog. **Cancel it.** `[SHOT 8]`

    > This report is dated 2026-10-01.
    > That is 18 days ago.
    > The date sets the posted filename, so posting it will replace any report already filed for
    > 2026-10-01. If you meant today, cancel and change the Report Date field.
    > Post it as 2026-10-01?

21. **SAY:** "Read that dialog rather than clicking through it. It is telling you that you are about
    to overwrite a day. Today or yesterday and it stays quiet; anything else and it asks."
22. **TRAP:** the room will meet this dialog again in the exercise, because every trainee is given a
    date in early October. Tell them now that it is expected there and that they should click through
    it *then* — and that on the rig it almost always means they have the wrong date.
23. **SAY:** "And on finishing before posting: Post asks you to confirm that this is a finished
    report. It is visible to everyone with dashboard access the moment it lands."

### 5. Close (10 min)

24. Press **↓ Browser Save**. Reload the page. Show the restore bar and press **Restore**. `[SHOT 9]`
25. **SAY:** "If the tool closes, the iPad dies, or you close the tab by accident, that bar brings it
    back. It is per browser and per machine — it will not follow you to another computer."
26. Take questions. Module 1 questions are in the workbook.

---

# Module 2 — WCGRRT: the surface test forms, attachments and Post
**10:15 – 12:00 · WCGRRT REV 168**

> **Agenda correction.** The agenda line for this module lists *"Load latest posted"*. **That feature
> is not in REV 167** — the only Load controls are `↑ Browser Load` and `📂 Load from File`. It is
> correctly listed on Day 2 under "What is coming". Take it out of this module.

### What they should be able to do by 12:00
Fill the rig-specific test forms, attach a document, post a report, read the receipt, and know what a
failed post looks like.

### 1. The rig-specific forms (45 min)

> **BEFORE THIS MODULE — the one setup step that will catch you out.** Four of the seven test
> records are keyed to the rig and **`SSCE Equipment` holds none of them.** Verified on the frozen
> build, 30 September: on `SSCE Equipment` the ROV, acoustic, EDS and EHBS forms all render a single
> line instead of a form —
>
> - *"No ROV function sheet on file for SSCE Equipment."*
> - *"No acoustic function table held for SSCE Equipment. Tell the office and it will be added."*
> - *"No EDS verification sheet on file for SSCE Equipment."*
> - *"No EHBS test held for SSCE Equipment. Tell the office and it will be added."*
>
> **So switch Rig / Asset to a real rig for this module** — West Polaris for EDS, West Vela for the
> acoustic point in step 32 — and **switch it back to `SSCE Equipment` before anybody posts
> anything.** The three that do work on `SSCE Equipment` are the BOP Function Test, the Soak Test
> and the Surface Drawdown Test.

27. **SAY:** "These forms know your rig. Pick the vessel first or they will not load — you get one
    line telling you so instead of a form. And note the difference between the two lines you might
    see: *no sheet on file for this asset* means nobody has loaded it yet, so tell the office.
    *No system fitted* means your rig genuinely does not have one, and there is nothing to record."
28. Add the BOP function test entry; show the form. `[SHOT 10]`
29. **Switch Rig / Asset to West Polaris.** Add the **EDS** form, pick a sequence, and show that the
    steps are this rig's own. `[SHOT 11]`
    **TRAP:** the sequence dropdown must be used — pick nothing and the steps table never renders,
    which reads as a broken form.
30. **SAY:** "EDS sequences come from the rig's own NOV verification sheet. If a step looks wrong for
    your stack, that is worth a phone call — one rig was found stamped Rev H while carrying Rev G
    content, and it was rebuilt from the NOV document."
31. Show the **acoustic** form. `[SHOT 12]`
32. **TRAP:** West Vela, West Neptune and Sevan Louisiana have **no acoustic system**. The form says
    so rather than presenting an empty test. Say it out loud — crews on those three rigs have asked
    whether the form is broken.
33. Show **EHBS** and **drawdown**. `[SHOT 13]`
34. **SAY:** "EHBS comes in three flavours across the fleet — single, sequenced and DMAS — and you
    get your rig's one. You do not choose it and you should not need to know which you are."

### 2. Attachments — say where they are and are NOT (10 min)

35. **SAY, and get this right because it is easy to promise the wrong thing:** "On a Well Control
    daily report in WCGRRT there is **no** attach-a-document control. Attaching a PDF exists in two
    other places — the P6 schedule on a Planning report, and the reference document on a Vendor
    Surveillance report — and neither of those is what you fill in on a normal day."
36. **SAY:** "Where you *can* attach a document is the CBM inspection in SSORT, and we do that after
    lunch. That is new this week and it is the right home for a pressure test chart."
37. **SAY:** "So on a daily report, evidence means photographs, captioned. If you have a document
    that matters — a chart, a certificate — it belongs on the CBM inspection for that equipment, or
    emailed to the office, not squeezed into a daily report as a photograph of a screen."
38. **SAY:** "And when you do attach one in SSORT: a PDF or an Office file cannot be squeezed the
    way a photograph can. It carries its full size into every copy of the report, so the tool warns
    you over 8 MB and refuses a single file over 20 MB. If it is a scan, a photograph of the
    document is far lighter and just as readable."

### 3. Post, and the receipt (30 min)

36a. **Switch Rig / Asset back to `SSCE Equipment` now.** Nothing may be posted on a real rig name
     from this room. Check it before step 37 and check it again before the exercise.

37. Press **📤 Post Report**. Read the confirm out loud. Accept it.
38. Show the **receipt** line under the button. `[SHOT 15]`

    > `4 entries · 11 photographs · 1 attachment · 3.2 MB` — and the time

39. **SAY:** "That receipt is your proof. It tells you what went, not just that something went. If
    the photograph count is lower than you expect, you have found a problem before the office does."
40. **SAY:** "It is a line under the button and not a pop-up on purpose. A crew posts every day, and
    a dialog every day teaches people to dismiss dialogs without reading them."
41. Show what a failure looks like:

    > ⚠ Dashboard post failed (HTTP 500) — file still saved locally.

42. **SAY:** "If you see that, your work is not lost — the tool falls back to your TSC REPORTS folder
    or asks you where to save. Ring the office and send them the file. What you must not do is
    assume it went."
43. Switch to the dashboard tab and find the report under SSCE Equipment. `[SHOT 16]`
44. **SAY:** "Ten minutes is the scan. If it is not there after ten minutes, it did not land,
    whatever the tool said."

---

# Module 3 — SSORT: CBM, the grade scale, pre-deployment, Post to OEM
**13:00 – 14:30 · SSORT REV 156**

### What they should be able to do by 14:30
Complete a CBM inspection with grades, photographs and an attached test record; complete a
pre-deployment checklist; and send a CBM report to NOV.

### 1. SSORT is a different tool (5 min)

45. Open SSORT. Point at the badge: **REV 156**. `[SHOT 17]`
46. **SAY:** "Different tool, different job, and the section list is different: CBM Inspection,
    Surface BOP Testing, Calculators, Pre-Deployment Checklist, Conditional Assessment, R53 Report.
    Vessel Information here, Visit Information over there."

### 2. A CBM inspection (40 min)

47. Add **🩺 CBM Inspection**. Set **Rig / Vessel** to `SSCE Equipment`.
48. Choose **Riser Adapter** from the equipment dropdown. `[SHOT 18]`
49. **SAY:** "Twenty-three equipment classes, each one built from NOV's own condition-based monitoring
    schedule. What you see is what NOV asks for on that component — not a Seadrill invention."
50. Walk section **1.1 General Inspections**. Grade task 1.1.1. `[SHOT 19]`
51. Press the **ⓘ scale** button and show the five levels. `[SHOT 20]`
52. **SAY the scale:** "One, as new. Two, slight wear, no action. Three, needs monitoring — and three
    is the one that matters, because three is where you have found something. Four, immediate repair.
    Five, not fit for continued use."
53. **SAY:** "Grade 3 is not a pass and it is not a failure. On the dashboard it shows amber:
    acceptable with findings, monitor. If you are tempted to put 2 because the equipment is going
    back in anyway, put 3 and write what you saw. The grade history per component is how the fleet
    spots a component going off."
53a. **Scroll down to section 1.2 Testing and stop.** The grade row there shows **1, 5 and N/A
    only**, with a yellow line saying *"NOV publishes only grades 1 and 5 for this item."*
    **SAY:** "This is new. NOV grade their own pressure tests and dimensional checks as a pass or a
    fail — grade 1 passed, grade 5 failed, no middle grade — so that is what the tool offers. A
    test is an outcome, not a condition. You will see the same two buttons on every Testing and
    Intrusive task in every class."
53b. **SAY:** "So one CBM report now carries two different kinds of grade. On the inspection tasks
    it is a condition, one to five. On the tests it is a pass or a fail. The note under each task
    tells you which you are looking at — read it rather than assuming."
54. Add a note and two photographs to the graded task.
55. **SAY:** "Riser Adapter had no grading and no photographs at all until last week. Brad found it
    from the rig. If you find another one like it, say so — that is how it got fixed."

### 3. Test records — new in REV 152 (20 min)

56. Open **Test Records & Attachments**. `[SHOT 21]`
57. Attach a pressure-test chart PDF. In the note beside it type
    `1.2.1 mud seal test to rated pressure`. `[SHOT 22]`
58. **SAY:** "This is new this week and it is the thing NOV's own schedule has been asking for all
    along — 'record time held and attach test graph'. Until REV 152 there was nowhere to put it, so
    charts were going in as photographs of a screen."
59. **SAY:** "The attachment belongs to the equipment, not to one task. The note is where you say
    which task it evidences — type the task number. That note is what the office reads under the
    file on the dashboard."
60. **TRAP:** photographs of the equipment go on the task, not here. Here is for documents: test
    charts, NDE reports, certificates, torque records.
61. Show the guards: a single file over 20 MB is refused outright; over 8 MB it warns; the running
    total passing 15 MB warns; and anything executable is refused.
62. **SAY:** "If a file is refused, do not go hunting for a way round it. Re-export it smaller, or
    attach the pages that matter. A report too big to post is worse than a report with three pages of
    chart instead of forty."

### 4. Pre-deployment checklist (15 min)

63. Add **🚀 Pre-Deployment Checklist**. `[SHOT 23]`
64. **TRAP, and set it up before you demonstrate:** the cavity photograph slots do not exist until
    the checklist's **own** BOP designation is set to Single or Dual **and** its cavity count is
    chosen. Until then there are no slots at all, which a trainee reads as "no photographs wanted".
    Set both, then show that a 7-cavity stack asks for **42 named slots** — 14 in each of the three
    sections, every box labelled for the position it belongs to (UBSR — FWD, UBSR — AFT, and so on).
65. Show the twenty questions, the packer attestation and the cavity photographs.
66. **SAY:** "The cavity photographs and the packer attestation are mandatory before posting. The
    tool will stop you. That is not bureaucracy — it is the evidence that the stack was fit to run,
    and it is the first thing anyone asks for afterwards."

### 5. Post to OEM (10 min)

66. Point at **✉ Post to OEM + Dashboard**. **Do not press it yet** — pressing is in the exercise.
    `[SHOT 24]`
67. **SAY:** "This button now does two things in one press, and the dashboard copy goes first. NOV
    review these as condition-based monitoring and cannot see our dashboard, so they get the report
    by email while the office gets the dashboard row."
68. **SAY:** "Press it once. Every press sends another email. The confirm tells you what is about to
    happen — read it."
69. **SAY:** "Your attached test records go to the dashboard AND they are attached to the email NOV
    receives — that went live on 30 September. The confirm tells you so. If it ever says they are
    only listed, then the email side is switched off and you should say so to whoever asks."
70. **SAY:** "And know what the tool does not tell you. In SSORT, if the dashboard post fails you do
    not get a warning — you get 'Report posted to the shared folder' or a tick and the word saved.
    The only proof a SSORT report landed is that it appears on the dashboard. WCGRRT warns you;
    SSORT does not. That is on the list to fix."

---

# Module 4 — the exercise
**14:45 – 17:00 · both tools · all**

The exercise sheet is `TRAINING-Day1-Exercise-Sheet.md`, one per trainee. The trainer's job in this
module is to stay out of the way and watch for four things.

### Before they start (10 min)

71. Hand out the sheets. Read out the allocated dates and make sure every trainee has written theirs
    at the top of their sheet.
72. **SAY:** "Four reports, one at a time. Post each one, then clear the workspace before you start
    the next. Do not build all four in one workspace."
73. **SAY:** "Why: SSORT names the file after the first report type it finds in the workspace. Build
    a CBM inspection and a pre-deployment checklist together and you get one file called
    cbm-inspection with both inside, and the checklist never appears as its own row. Nothing warns
    you. One at a time."
74. **SAY:** "Your date will make WCGRRT ask whether you really mean it. You do. Click through it
    that once — and remember what it is for."

### What to watch for (the whole module)

- **Someone posting with no rig set.** They will get the fail-closed dialog. Good — let it happen.
- **Someone building all four in one workspace.** Catch it early; the fix is to post what they have,
  clear, and carry on.
- **Someone pressing Post to OEM twice** because nothing seemed to happen. Show them the button text
  changed to `✓ Posted & sent for OEM delivery`.
- **Someone whose report has not appeared after ten minutes.** Check the receipt in WCGRRT. In SSORT
  check the toast wording — "posted to the shared folder" means it did not reach the dashboard.

### Close (15 min)

75. On the dashboard, filter to SSCE Equipment and show the forty rows, one set per trainee, filed by
    date. Let each trainee find their own four.
76. **SAY:** "That is the whole loop: you filled a form on the rig, pressed one button, and the office
    can see it, print it, and trend it against the rest of the fleet."
77. Remind them these posts are deleted after the class, and that on a real rig they are permanent and
    visible to everyone with dashboard access.
