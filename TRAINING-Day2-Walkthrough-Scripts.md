# Day 2 walkthrough scripts — precharge, the dashboards, the AAB, the loop, what is coming

**Class:** Tuesday 20 October 2026, Houston · **Frozen builds:** WCGRRT **REV 167**, SSORT **REV 156**, Precharge Pro
**Rev 87**, scanner **v2.76**, dashboard as deployed on the sacred share (build freeze from 12 October: nothing on the
pages changes before the class either, unless a rig is losing work)
**Led by:** Dan (every module; Lee opens Day 1, not Day 2; Eric may take the review minutes in the AAB module; Manpreet
may take the ten minutes on the CoC tracker if he attends)
**Asset:** `SSCE Equipment` throughout. Every post the room makes lands on that asset and puts every notification flow
into test mode, so no rig and no OEM receives a test. **Built by:** the dashboard session, 2 October 2026, draft 1.

**How to read this.** Same conventions as Day 1. Numbered steps are what the trainer does and says. `SAY:` is a line to
say more or less as written. `[SHOT n]` marks a screenshot for the workbook; the numbering continues from Day 1, 25 to
48, and matches `TRAINING-Day2-Screenshot-List.md`. `TRAP:` is something the room will get wrong if it is not said.

**Before the room arrives.** Everyone brought their own laptop on Monday; they bring it again. On the trainer's laptop,
open in tabs: the Rig Visit Dashboard filtered to SSCE Equipment (it will show Monday's forty rows, which is the whole
point), the BOP Fleet Planning Dashboard, the SSCE Requests Dashboard, the CoC tracker (a **local copy**, not the share),
the Seadrill Bulletin Board, the TSC Help Centre, and the precharge calculator signed in. Press Ctrl+F5 on each once.
Confirm the dashboard's "last scan" stamp is within the last ten minutes; if it is not, the scanner is not running and
nothing posted today will appear, so stop and ring the office before you start.

---

# Module 5 — the precharge process
**08:00 – 10:00 · Precharge Pro Rev 87, the request form Rev 3, the issued sheet**

This module is the Precharge Pro session's pack, run as written. The three module files, the nine questions, the three
exercise files with their answer key and the 32 screenshots are in `tools/received/training/precharge/`. This page gives
the timings and the three things the pack leaves to the trainer.

### What they should be able to do by 10:00
Raise a precharge request from the rig, read what the calculation did with it, read an issued sheet and its PDF, and
say which number on the sheet they are responsible for checking against the stack.

### Timings
| | Minutes | From the pack |
|---|---|---|
| 1. The request: who raises it, what it carries, where it goes | 35 | `MODULE-1-The-request.md`, shots 01-01 to 01-10 |
| 2. The calculation: what Precharge Pro does with the request, and what it will not do | 40 | `MODULE-2-The-calculation.md`, shots 02-01 to 02-12 |
| 3. The issued sheet and its PDF: reading it, filing it, the email with the PDF only | 30 | `MODULE-3-The-issued-sheet-and-its-PDF.md`, shots 03-01 to 03-10 |
| Questions | 15 | the nine, in the workbook |

### The three things the pack leaves to the trainer

1. **The training wells.** The exercise files use real, verified rigs with the well names `TRAINING-01 NOT ISSUED` to
   `TRAINING-04 NOT ISSUED`. **SAY:** "These are the only files in this course on a real rig name, and the well name
   says why: nothing from this room is issued. If you ever see a well called TRAINING on a real sheet, it is not a sheet."
2. **The arithmetic is not yours and it is not mine.** **SAY:** "The calculation in Precharge Pro has not been touched by
   anyone since it was verified against the issued sheets. If a number looks wrong, the answer is never to adjust the
   calculator; it is to check the inputs on the request and ring Dan. The tool is the record of what was calculated; the
   stack is the record of what was done."
3. **Where the request goes.** **SAY:** "Post from the request form and the office sees it on the dashboard within ten
   minutes and gets an email. The issued sheet comes back the same way, as a PDF, and only the PDF: the email never
   carries the data file, because the PDF is the signed document and the data file is not." `[SHOT 25]` the issued email
   with its single PDF attachment, from the pack's module 3.

**TRAP:** the request form lives in two places, on the share and inside SSORT, and they are the same form. A crew that
raises it from SSORT and again from the share has raised it twice; the dashboard shows both. Raise it once.

---

# Module 6 — the Rig Visit Dashboard, tab by tab
**10:15 – 12:00 · the dashboard on the sacred share, scanner v2.76**

### What they should be able to do by 12:00
Find their own report from Monday, open it, read the CBM heatmap and the grade history, see what "needs attention" means
and where it is counted, read a rig's daily checks, use the Errors button, print a report, and ask Ask SACRED AI one
question about their own post.

### 1. Orientation and the first find (15 min)

1. Open the dashboard. Point at the banner: the Seadrill blue, the gold rule, **Ask SACRED AI**, **TSC Help Centre**,
   the "last scan" stamp on the right. `[SHOT 26]`
2. **SAY:** "This page is written by a script every ten minutes from every report the fleet has posted. Nobody types
   anything into it. If it is wrong, a report is wrong, and you fix the report by re-posting it."
3. **SAY:** "The stamp on the right is the time of the last scan. If it is more than ten minutes old, the scanner has
   stopped and the office already has an email about it. Do not keep refreshing; ring."
4. Set the rig filter to `SSCE Equipment` and the time filter to **30 days**. `[SHOT 27]` Forty rows from Monday, one
   set per trainee, filed by their allocated date.
5. **SAY:** "Find your four." Give them two minutes. Everybody finds their own daily report, surface test, CBM
   inspection and pre-deployment checklist by date.
6. **TRAP:** someone's row is missing. It is one of Day 1's five checks, in order: rig, date, what the tool said,
   someone posted over it, ring the office. Walk the room through it on the spot; it is the best teaching moment of the
   day, so do not apologise for it.

### 2. Report List (10 min)

7. Point at the columns: date, rig, type, who, size, the attachment and photograph counts, the OEM chip where a CBM
   report went to NOV. `[SHOT 28]`
8. **SAY:** "The type column names the report the way the file was named: daily report, surface test, CBM inspection
   with the equipment beside it, pre-deployment checklist. If your CBM report says the wrong equipment, it was the wrong
   equipment in the tool."
9. Open one CBM report from Monday. Scroll: the header, the graded tasks with photographs, **Test records and
   documents attached (2)** with the task number under each file, the sign-off. `[SHOT 29]`
10. **SAY:** "What you see here is the whole report. The office prints from this page; NOV get an HTML copy of the same
    content by email. There is no second version anywhere."
11. Press **Print** on the report. Show the print view. **SAY:** "This is the PDF the office keeps. It comes from the
    posted file, so it is the same for everyone who prints it."
12. Point at the **Errors** button. Open it. `[SHOT 30]` **SAY:** "Two kinds of thing live here: a file that could not be
    read, and a file over the size ceiling. Neither is hidden. If your report is here, it is here because of the file,
    and the fix is at the source: smaller photographs, or a repost."

### 3. Rig Monitoring (15 min)

13. Open **Rig Monitoring**. One tile per rig. `[SHOT 31]`
14. **SAY:** "This is the page a superintendent opens first in the morning. Each tile: the latest daily report, the
    daily checks, the BOP planning status, anything needing attention, counted once."
15. Click a rig's **Daily Checks and FLM** link. The readings history. `[SHOT 32]` **SAY:** "Daily checks are not in the
    Report List, on purpose: dozens a week per rig would bury the reports. They are here, and a failed or commented
    reading lifts the tile."
16. **TRAP, say it slowly:** "Needs attention means a reading was marked failed, or carried a comment, or an action was
    raised and is still with the rig. It is a count of things people wrote. It is not a computed judgement about your
    equipment, and nothing on this page ever is. The grade a crew gave is the grade; the rule the dashboard applies to it
    is written down and the same for every rig."
17. Point at the potable-water flush items on a tile if any rig has them: the two readings where a bare tick is
    meaningful. **SAY:** "On those two, a tick is a record, not a pass. The rule is inverted there and the tile knows it."

### 4. CBM Heatmap and the grade history (20 min)

18. Open **CBM Heatmap**. `[SHOT 33]` Rows are rigs, columns are equipment classes, colour is the latest grade.
19. **SAY the legend:** "Green, one and two, acceptable. Amber, three, monitor. Red, four and five, fail. Grey, no grade
    on record. That is NOV's universal scale, and three is the one to look at because three is where someone found
    something."
20. Click a cell. The grade history for that component on that rig: every graded task, every date, every grade, the
    photographs behind them. `[SHOT 34]`
21. **SAY:** "This is why you grade honestly. One inspection is a snapshot. Three inspections are a trend, and the trend
    is what the fleet acts on."
22. Find Monday's Riser Adapter from the room: three condition grades and, from REV 156, the two tests graded **1 and
    5**. `[SHOT 35]`
23. **SAY:** "Those two are not condition grades. They are a pass and a fail on a pressure test, which is how NOV
    grade their own tests. On this page they read as acceptable and fail, which is right; the next release will say
    PASS and FAIL in words. One report now carries two kinds of grade, and the note under each task in SSORT tells you
    which."
24. **TRAP:** a grade 5 on a test is a failed test, not a condemned component. Say it before someone reads the red cell
    as a stack problem.
25. Show the cavity record on a report that has one: the per-cavity rows and the verdict the crew recorded. **SAY:**
    "Shown as a record, never as a verdict the dashboard made."

### 5. Compliance, Investigations, Failures, Lessons learned, R53 events, AABs (15 min)

26. **Compliance.** `[SHOT 36]` The latest checklist per rig, the actions raised during visits across the fleet with
    overdue flagged from the deadline the visitor wrote, the certification expiry watch at ninety days. **SAY:** "An
    action is overdue because of the date you typed. It is confirmed because you ticked 'left with rig'. The dashboard
    adds nothing."
27. **Investigations, Failures, Lessons learned, R53 events:** one minute each; what each list is and where it comes from.
    **SAY:** "Each of these is a report type or a block in a report. Nothing here was typed into the dashboard."
28. **AABs:** the tab is the Bulletin Board's register; module 7 covers the loop.

### 6. Ask SACRED AI (10 min)

29. Press **Ask SACRED AI**. `[SHOT 37]` **SAY:** "This is a Copilot agent that reads a digest of every posted report.
    It answers from the reports, not from the internet, and it says which report it read."
30. Ask it about the room's own posts: "Which SSCE Equipment reports were posted on [date] and what did the Riser
    Adapter inspection grade?" Read the answer and the sources.
31. **SAY:** "It is an answer, not a record. It can be wrong, it tells you where it looked, and the report is the
    record. Use it to find, not to decide."
32. **TRAP:** today it opens for Dan and Lee only, until IT approve the Teams app. Say so; do not let the room try it on
    their own laptops and conclude it is broken. From the Lovable move it becomes a button that works for everyone
    signed in.

### 7. Close (5 min)

33. Questions. Module 6 questions are in the workbook.

---

# Module 7 — BOP Fleet Planning, the CoC tracker, SSCE Requests, the AAB and the Bulletin Board
**13:00 – 14:30 · four pages, four jobs**

### What they should be able to do by 14:30
Read the fleet planning page and the break-in list; use the CoC tracker and say where its data comes from; raise and
follow an SSCE request; create, acknowledge and close an advisory on the Bulletin Board.

### 1. BOP Fleet Planning Status (20 min)

34. Open the BOP Fleet Planning Dashboard. Tile view. `[SHOT 38]` **SAY:** "One tile per rig from the weekly planning
    workbooks: the BOP in service, the next test, the planned work. Switch to Map view for the same thing on the map."
35. Open a rig; **View schedule**. `[SHOT 39]`
36. Press **Break-in Work**. `[SHOT 40]` **SAY:** "Break-in work is unplanned work that interrupted the plan. It comes
    from the planning report, it is counted here, and the office is emailed when a new one appears. If your break-in is
    not here, it was not in the report."
37. **TRAP:** the planning page updates from the weekly workbooks, not from a daily report. A change made on Tuesday
    appears when the workbook is posted, not ten minutes later.

### 2. The CoC tracker (10 min)

38. Run `TRAINING-COC-TRACKER-MODULE.md` as written: the fleet dashboard, the tiers, one row per asset, a vessel page,
    search and a shareable address, annotations in the browser, refresh from Maximo, exports, the Shared Capital
    register. `[SHOT 41]` the fleet dashboard; `[SHOT 42]` a vessel page with the detail panel open.
39. **SAY whichever is true on the day** about where an SSCE request is raised: from the rebuilt tracker, or from the
    older COC Dashboard on the SSORT share until the port lands. The decision was due 10 October.

### 3. SSCE Requests (15 min)

40. From the Shared Capital register, open the request form on one item. Fill it on `SSCE Equipment` as the site unit,
    priority 3, planning, with a justification that says TRAINING. **Submit.** `[SHOT 43]` the form; `[SHOT 44]` the
    confirmation.
41. **SAY:** "The form posts straight to the same place the reports go. If the post fails, it downloads the file and
    tells you where to put it, so a request is never lost."
42. Open the SSCE Requests Dashboard. The request is there within ten minutes, Pending. `[SHOT 45]`
43. **SAY:** "An approver reviews it here, with a comment, and approves or denies. When it is approved the item shows
    as unavailable on the tracker's review copy, and the office replaces the live tracker after checking it. Nothing
    writes to the live file on its own."
44. Approve it in the room (test mode; the decision file lands the same way). Show the status change.
45. **TRAP:** the request is about a Central Spares part leaving the yard. The returning equipment block is the part
    going back. Both serials are on the form because the tracker knows them; the date of return is the one thing the
    applicant has to know.

### 4. The AAB and the Seadrill Bulletin Board (40 min)

46. Run `TRAINING-MODULE-AAB.md` as written: what an AAB is and what the loop does (5); creating and posting an advisory
    on the create page (12); acknowledging on the rig page (10); Technical Services review and close on the fleet
    compliance page (8); the dashboard's AABs tab (5). Shots `[SHOT 46]` the create page, `[SHOT 47]` the rig page with
    an acknowledgement, `[SHOT 48]` the register.
47. **SAY, once, at the start:** "Everything you do in this module is on SSCE Equipment and in test mode. Nothing goes to
    a rig. On a real advisory the rig is on the To line, never on copy, and the acknowledgement is the record."
48. **SAY, once, at the end:** "The AAB loop is a pilot under deviation, with the MOC and the HAZID. The HAZID is the rule
    book for it. Priority 3 only; priority 1 and 2 stay in the corporate process because they raise costs, work orders
    and approvals."

---

# Module 8 — the loop, and the TSC Help Centre hands on
**14:45 – 15:30**

### What they should be able to do by 15:30
Draw the loop on a whiteboard from memory; raise a help request from the tool and follow it to the email, the Teams
chat and the receipt; know who acknowledges and how.

### 1. The loop (20 min)

49. On the whiteboard, draw it: **the tool on the rig → one file → the intake → the SharePoint library → the scanner →
    the page → the notification with a link to the page → the receipt.** `[SHOT 49]` the slide.
50. **SAY:** "Every loop you have seen today is that one pattern. Precharge, CBM to NOV, the AAB, the help request. Post,
    scan, page, notification, receipt. When something new is built, it is built on the same pattern, which is why it
    takes days and not months."
51. **SAY:** "Three things to hold onto. One: the file is the record, and the dashboard is a view of it. Two: every
    notification carries a link to the page so a report is read once, on the dashboard, not forwarded. Three: a receipt
    is written for every notification that went, so the office can prove what was sent to whom."
52. **SAY what a failure looks like, and who sees it:** "A failed post: WCGRRT tells you; SSORT does not, and the proof
    is the dashboard. A stopped scanner: the stamp goes stale and Dan and Lee get an email within the hour. A notification
    that bounced: the office sees it on the NOT SENT branch, not the rig. Nothing fails silently on the office side; one
    thing fails silently on the rig side, and you know which."

### 2. The TSC Help Centre, hands on (20 min)

53. In SSORT (or WCGRRT), open the help request. Raise one on `SSCE Equipment`: a short title, the category, the text,
    one photograph. **Post.** `[SHOT 50]`
54. **SAY:** "This is for the rig to reach Technical Services with a problem that is not a report: a tool question, an
    equipment question, a dashboard question. It posts the same way a report does."
55. Within ten minutes: the request is on the Help Centre page (open it from the dashboard's **TSC Help Centre** button;
    the password is the gate for the office side). `[SHOT 51]` **SAY:** "And the office got an email with a link to this
    page, and a Teams chat was opened with the people on the help list. In test mode today that is the office list only."
56. Acknowledge it on the Help Centre page as the office would: who is dealing with it, a line of text. **SAY:** "That
    acknowledgement goes back on the same email subject, so it lands in the same conversation, and into the same Teams
    chat. The rig is not asked to look anywhere new."
57. Show the receipt: the file the flow wrote, what was sent to whom and when. `[SHOT 52]`
58. **TRAP:** the Help Centre is not the AAB and it is not a failure report. A failure that stops a job is the failure
    notification (module 9, coming). An advisory to the fleet is an AAB. A question is the Help Centre.

### 3. Close (5 min)

59. Questions. Module 8 questions are in the workbook.

---

# Module 9 — what is coming
**15:30 – 16:15**

### What they should be able to do by 16:15
Say what changes for the rig in the next six months and what does not.

60. **The server, this week (5 min).** **SAY:** "Until this week the scanner ran on my laptop. This week it moves to a
    server ISIT own, with a service account, on the same schedule. Nothing you do changes. The link in your bookmarks
    may change once, later, when ISIT name the production server; you will be told."
61. **UAT, and what that word means here (5 min).** **SAY:** "IT call what you are doing user acceptance testing. You
    are the testers; the rigs' real use is the test. Keep posting. What IT are testing is whether they can run it."
62. **Lovable, the rebuild of the pages (10 min).** **SAY:** "SACRED's pages are being rebuilt on a hosted platform
    called Lovable over the winter. For you: the tools on your laptop do not change on day one; they post to the same
    place. The dashboard will look different and will have a sign-in with your Seadrill account instead of a password.
    Ask SACRED AI becomes a button inside it that works for everyone. Cutover is planned for January; you will get a
    two-page 'what moved' before it." `[SHOT 53]` the transition chart.
63. **The things on the list, one line each (15 min):**
    - **Load latest posted** in WCGRRT: pull the last posted report back into the tool to carry on from it.
    - **Photographs and attachments out of the report file:** smaller posts, the 10 MB ceiling stops biting.
    - **SSORT's receipt:** SSORT will tell you when a post failed, the way WCGRRT does.
    - **The failure notification:** a BOP equipment failure or downtime raised from the rig, emailed by directive.
    - **The riser tally** on SACRED (Rohit's tool) and, later, per rig.
    - **Photo grading:** a model that suggests the CBM grade from the photograph; a suggestion, never a grade.
    - **The pass/fail wording** on test grades, from the next release.
    - **SPARC and Maximo** (five minutes from Lee's SPARC maintainer, `TRAINING-HANDOFF-SPARC.md` §2): the parts
      catalogue inside SSORT, the daily item export, where it lands.
64. **SAY to close:** "Everything on that list is on a plan with a date and an owner, and every change ships with a
    written handoff before it does. You will never meet a revision cold."

---

# Module 10 — feedback
**16:15 – 17:00 · Dan chairs; Lee takes the action list**

65. Hand out `TRAINING-Day2-Feedback-Sheet.md`. Ten minutes in silence: everyone writes three things.
66. Round the room: one thing each that is hard on the rig today. Straight onto Lee's workshop action list, with a name
    and a date, on the wall. **SAY:** "Thursday's efficiency forum argues from what you wrote today, not from memory."
67. Round the room: one thing each the tools should do next. Same list.
68. **The UAT sign-off** (`TRAINING-UAT-Sign-off-Form.md`): read the six statements out loud. Each trainee signs their
    own line. **SAY:** "This is not a test you can fail. It is the record that the people who will use it have used it,
    and that it did what we said. If a line is not true for you, do not sign it; write why on the back, and it goes on
    the list."
69. Collect the sheets. Remind the room: Monday's posts are deleted from PostedReports this week; on a real rig a post is
    permanent and visible to everyone with dashboard access. Close.
