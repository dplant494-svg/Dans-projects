# Day 2 workbook questions — three per module, with answers

**Frozen builds:** WCGRRT REV 167, SSORT REV 156, Precharge Pro Rev 87, scanner v2.76. Answers are for the trainer's
copy; the trainee workbook carries the questions and the blank lines only. Module 5's nine questions are the Precharge
Pro pack's own and are not repeated here; module 7's AAB questions are in `TRAINING-MODULE-AAB.md`.

---

## Module 6 — the Rig Visit Dashboard

**6.1 — The "last scan" stamp on the banner reads 07:40 and it is now 08:30. Your report was posted at 08:05. What
has happened, and what do you do?**

> The scanner has stopped: nothing has been scanned for fifty minutes and your post is sitting in the library
> unread. Refreshing changes nothing. Ring the office. Dan and Lee already have an email about it, because the
> freshness check runs every hour. Your post is not lost; it appears the first scan after the scanner is back.

**6.2 — A rig's tile on Rig Monitoring says "needs attention: 3". Name the three kinds of thing that can be counted
there, and say what the dashboard adds to them.**

> A daily-check reading marked failed; a daily-check reading with a comment; an action raised during a visit that is
> still with the rig. **The dashboard adds nothing.** Every one of the three is something a person wrote in a tool. The
> rule that counts them is written down and is the same for every rig; it is never a judgement about the equipment.

**6.3 — On the CBM Heatmap a Riser Adapter cell is red. You open the history and the red is a grade 5 on task 1.2.2,
"test mud boost valve in close position". Is the riser adapter condemned?**

> No. Task 1.2.2 is a pressure test, and from REV 156 tests are graded the way NOV grade them: 1 is a pass, 5 is a
> fail, no middle grade. A 5 there is a failed test, which needs acting on, not a condition grade on the component. The
> condition grades on the same report are the 1 to 5 tasks in the General Inspections section. The note under each task
> in SSORT says which kind it is; the next dashboard release says PASS or FAIL in words.

---

## Module 7 — BOP Fleet Planning, the CoC tracker, SSCE Requests, the AAB

**7.1 — You changed the BOP test date in Tuesday's planning meeting. When does the Fleet Planning page show it, and
why not within ten minutes?**

> When the weekly planning workbook is posted. The planning page is built from the workbooks, not from a daily
> report, so the ten-minute scan has nothing new to read until the workbook goes up. A daily report that mentions the
> change does not move the planning page.

**7.2 — On the CoC tracker, your rig shows 140 components with "no date on file". Where is the fix, and what does the
tracker do with those rows in the meantime?**

> The fix is in Maximo: the issued and expiry dates are blank on those asset records, and the tracker never guesses a
> date from loose text. Until they are entered, those rows are "no date on file", which is counted separately from
> expired and from valid, and they appear on the next refresh of the tracker from the extract.

**7.3 — You submit an SSCE request from the Shared Capital register and the page says the file was downloaded and
tells you where to put it. Did the request fail?**

> No. The form posts straight to the intake; if the post cannot be made (the flow down, offline, a policy change) it
> downloads the same file and tells you the folder it belongs in. Put it there and the scanner picks it up on the next
> pass; the request reaches the SSCE Requests Dashboard either way. A request is never lost; what you must not do is
> submit it again.

---

## Module 8 — the loop and the TSC Help Centre

**8.1 — Draw the loop. Eight boxes, in order.**

> The tool on the rig; one file; the intake; the SharePoint library; the scanner; the page; the notification with a
> link to the page; the receipt. Every loop in SACRED is that one pattern.

**8.2 — You raise a help request and get an email reply from the office two hours later. What is the subject line,
and why does it matter?**

> The same subject as the request, with RE: in front. The acknowledgement goes back on the same subject and into the
> same Teams chat so it lands in the same conversation; the rig is never asked to look somewhere new. If a reply arrives
> under a different subject, it did not come through the Help Centre.

**8.3 — Which of these goes where: a hydraulic leak that has stopped the job; a question about why the CBM form
shows fewer grade buttons; an advisory to every rig about a bolt batch.**

> The leak that stopped the job is a failure notification (coming, module 9), raised from the rig and emailed by
> directive. The grade-button question is a TSC Help Centre request. The bolt batch is an AAB, Priority 3, on the
> Seadrill Bulletin Board, acknowledged by each rig. Three loops, three different audiences, the same pattern.

---

## Module 9 — what is coming

**9.1 — The scanner moves from Dan's laptop to a server this week. Name one thing that changes for the rig and one
that does not.**

> Changes: nothing in what you do; possibly, later, the link in your bookmarks once ISIT name the production server,
> and you will be told. Does not change: the tools, the posting, the ten-minute scan, the dashboard, the notifications.

**9.2 — When the pages move to Lovable in January, what happens to the tool on your laptop on day one?**

> Nothing. It posts the same file to the same place. The dashboard changes: it looks different, you sign in with your
> Seadrill account instead of a password, and Ask SACRED AI works for everyone signed in. A two-page "what moved"
> comes before the cutover.

**9.3 — The photo-grading model suggests a grade 4 from your photograph. What is recorded?**

> Whatever you grade. The suggestion is a suggestion; the grade is yours, and only a grade a person gave is ever
> recorded or shown. A computed judgement is never displayed as a recorded fact anywhere in SACRED.
