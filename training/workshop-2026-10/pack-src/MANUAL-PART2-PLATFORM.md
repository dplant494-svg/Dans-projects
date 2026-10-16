# Part 2 — Precharge, the SACRED dashboards, Argo Navis and getting help

**Training Manual for Subsea Superintendents · WCE SME Technical Review and Open Workshop, 19–20 October 2026**

This part of the manual covers what you saw demonstrated on Tuesday 20 October: the precharge process, the SACRED
dashboards, planning and running a Between Well Maintenance (BWM) plan in Argo Navis, the Daily Summary Report, and how
to get help. It is written to be used back on the rig, one guide at a time.

**Builds this manual describes:** Argo Navis **REV 16**, SSORT **REV 169**, WCGRRT **REV 174**, the SACRED pages on
`http://sdrlazneuiis01d.corp.local:8080/sacred/`, and the scanner that refreshes them every ten minutes. Precharge Pro
was **Rev 87** when the pictures were taken. Always check the revision badge on the screen in front of you; if it is
newer, a written note on what changed will have reached you first.

## How to use this part

Each guide has the same shape:

- **When you need this:** the situation that sends you to the guide.
- **Steps:** numbered, in the order you click. Words in **bold** are buttons, tabs or labels exactly as they appear on
  the screen.
- **Pictures:** taken from the real tools, mostly on test plans and training wells. Names such as `SAMPLE SSS`,
  `T. Leader` or `TRAINING-01 NOT ISSUED` are test data.
- **Watch out:** the places people go wrong, in a box like this:

> **Watch out:** a box like this is a trap someone has already fallen into. Read it before you click.

**Three things that are true everywhere in this part:**

1. **The file is the record; the page is a view of it.** Nobody types into a dashboard. If a page is wrong, a posted
   report is wrong, and you fix the report by posting it again.
2. **Every notification carries a link to the page**, and every notification writes a **receipt**: what was sent, to
   whom, and when.
3. **Everything here is under MOC.** Changes to the tools, the calculator, rig hardware records or the processes go
   through Management of Change. This manual does not teach MOC.

## Contents

**Precharge**
- How to request a precharge
- How to read the issued sheet and its PDF
- Where the precharge record lives

**The SACRED dashboards**
- How to find a report on the Rig Visit Dashboard
- How to read Rig Monitoring
- How to read the CBM Heatmap and a grade history
- How to open and print a report in the full-report viewer
- How to use the Errors button
- How to read the BOP Fleet Planning page
- How to use the CoC dashboard and follow an SSCE request
- How to acknowledge an AAB on the Seadrill Bulletin Board
- How to ask the TSC Help Centre for help

**Argo Navis**
- How to open an existing plan
- How to start a new schedule
- How to save a plan
- How to challenge the scope and defer work with a reason
- How to read SFI groups, BOP %, the BOP ready date and float
- How to post a plan for review, and how reviewers verify it
- How to freeze the scope (Hold 1)
- How to execute: complete a task, use a checklist, raise break-in work, read the chronology
- How to post the Daily Summary Report
- How to close out a plan, and what is in the close-out pack

**The Daily Summary Report requirement (one page)**

**Glossary · Where to get help · Links**

---

# Precharge

The rig asks for a precharge with the **request form**. The office loads the request into the calculator, **Precharge
Pro**, works it out, has it checked, and issues the sheet. The **PDF** goes to the rig by email, and that PDF is the
controlled document you charge from.

You raise the request and you work from the issued PDF. **You do not run or adjust the calculation.** That is the
office's job, under two signatures.

## How to request a precharge

**When you need this:** a new well, a well hop, a change to the stack, or any time the rig needs a precharge issued.

The request form is the same form in two places: inside **SSORT** (📨 **Requests** → **Request Type** → **BOP
Precharge Request**), and as a standalone page. It is deliberately plain and unbranded. It is not the calculator and
shares no code with it.

**Steps**

1. Open the request form, from SSORT or the standalone page. Raise it from **one** place only.
2. If you are unsure what a field means, press **Guide** at the top right. Everything on the form is explained there.
3. **Rig & Well:** choose the **Rig**. On a rig with two stacks, choose **Which BOP**. Type the **Well name**.
4. Type **Raised by** and the **Email**. Put a person, not a shared mailbox.
5. **Set the units first.** The form starts in **metres** and **°C**. If you work in feet and °F, change both unit
   selectors (water depth and subsea temperature) **before** you type any numbers.
6. **The one we cannot proceed without:** type the **Minimum shear pressure required (PSIG)** and the **MAWHP**. Then
   choose **Where the shear pressure came from**. It is optional, and it is the most useful optional field on the form.

   [IMG tools/received/training/precharge/screenshots/01-04.png]

7. **Well conditions:** type **Water depth**, **Subsea temperature at depth** and **Deck temp while precharging**.
   Subsea sets the gas density at depth; deck is what your gauge reads while you charge. Do not swap them.
8. **Well hop planned?** If **Yes**, list every water depth for the hop.
9. **Anything changed on the stack?** Fill this in only if something has changed: rams, bottles, banks, the pump cut-in
   and cut-out. Cut-in must be below cut-out.
10. Press **Check my entries**. Seven fields stop the file if they are empty: rig, well name, minimum shear pressure,
    MAWHP, water depth, subsea temperature and deck temperature.
11. Read every amber box under **Worth a second look**. Correct anything that is wrong. Wait for the green line **No
    blocking problems — you can create the file.**

    [IMG tools/received/training/precharge/screenshots/01-05.png]

12. Press **Post to Dashboard** to send it to the office. If there is no connection, press **Create request file
    (.json)** and email the file to Technical Services.

**What the form catches**

| What you typed | What the form says | Warning or block |
|---|---|---|
| A shear pressure that is high for the MAWHP (e.g. MAWHP 3,500, shear 5,200) | "Check the wellbore column … not the 15,000 psi column" | Warning: it makes you look |
| A subsea temperature of 4 °F | Probably Celsius typed with the selector on Fahrenheit | Warning |
| Deck temperature below subsea | The two are probably swapped | Warning |
| Pump cut-in above cut-out | The pumps cannot cut in above where they cut out | Warning |
| Well hop = Yes with no depths | You must list the depths | **Block: no file** |

> **Watch out: the 15,000 psi column.** The single most common error on this form is reading the shear estimator's
> 15,000 psi column instead of the column for your MASP. The form warns but does not block, because the number can
> genuinely be that high. Check it.

> **Watch out: units.** Typing 7,000, 38 and 78 meaning feet and °F, with the selectors left on metric, asks for
> 22,966 ft and two Celsius temperatures. Setting the units is part of filling in the form.

> **Watch out: raise it once.** The form inside SSORT and the standalone page are the same form. A request raised from
> both arrives twice.

## How to read the issued sheet and its PDF

**When you need this:** the ISSUED email has arrived and you are about to charge the bottles.

The ISSUED email carries **the PDF and only the PDF**. It goes **To** the rig's subsea supervisor, TSL, assistant rig
manager and rig manager (never Cc, because rigs filter Cc), with the office on Cc.

**Steps**

1. Open the PDF attached to the ISSUED email. **The PDF is the controlled document.** Not the email body, not a
   screenshot, not a figure someone read out on the phone.
2. **Check the header.** Rig, well, and on a two-stack rig the BOP. This is your first check that you are holding the
   right sheet.

   [IMG tools/received/training/precharge/screenshots/03-01.png]

3. **Check the conditions** in the line under the header and in the summary against what you asked for: water depth,
   subsea temperature, deck (set) temperature, required shear, MAWHP. Wrong conditions means the right answer to the
   wrong question.
4. **Find the number you charge to.** In the green verdict, **SET PRECHARGE … PSIG (gauge — charge to this)**, at the
   deck temperature it is quoted for. It is gauge pressure. On rigs with several banks, the **Precharge Summary** gives
   one figure per accumulator, each by its own method; charge each to its own figure.

   [IMG tools/received/training/precharge/screenshots/02-06.png]

   [IMG tools/received/training/precharge/screenshots/03-07.png]

5. **Check that the checks passed.** The checks table shows each criterion, the margin and **PASS**. You should be able
   to see why it passed, not only that it did.
6. **Read the temperature table for today's deck temperature.** Turn to **page 3**, *Precharge vs Temperature*. The
   sheet says: "target the precharge for the ACTUAL temperature at that moment: read off the curve / table below." If
   the sheet was quoted at 78 °F and the deck is 60 °F this morning, you charge to the 60 °F value, not the headline.

   [IMG tools/received/training/precharge/screenshots/03-08.png]

7. **Check the two signatures** at the foot of the PDF: **Calculated** (the person who worked it up) and **Verified**
   (a second person who checked it). The line "Generated by Seadrill Precharge Tool" with a time is the tool's own
   record. **It is not a signature and replaces neither name.**

   [IMG tools/received/training/precharge/screenshots/03-10.png]

8. If a number looks wrong, check the inputs on your request first, then ring the office. **Nobody adjusts the
   calculation**, on the rig or in the office.

**The three things to check first, every time:** the header (rig, well, BOP); the conditions against your request; the
revision of the tool that produced it (if two sheets for the same well disagree, start there).

> **Watch out: the temperature table is on page 3**, not page 2. Page 2 holds the rest of the contractual tables.

> **Watch out: the same PDF can carry two names.** The downloaded copy uses underscores
> (`West_Tellus_…_precharge.pdf`); the posted copy starts `Seadrill_` with hyphens. They are the same document.

> **Watch out: a failing sheet never reaches you.** If the calculation fails a check, the calculator refuses to post
> it. It can still be printed for an engineering review. The answer to a failure is to go back to the operator and the
> OEM, never to lower the requirement until it passes. This is what a failure looks like in the office:

[IMG tools/received/training/precharge/screenshots/02-10.png]

## Where the precharge record lives

**When you need this:** someone asks which sheet was issued, or an auditor asks for the record.

Three places, one record:

| Where | What it is |
|---|---|
| **The reports library** (and the **Precharge** tab on the Rig Visit Dashboard) | The posted request and the issued sheet, by rig. A re-posted request with a correction shows as **REVISED**; the newer one wins. An issued sheet is never reset by a re-post. |
| **The PDF in the ISSUED email** | The controlled document the rig works from. |
| **The BWM plan's project folder** (on a BWM) | The issued precharge is filed with the plan and joins the **close-out pack** that goes to eDocs. |

**Steps to find it on the dashboard**

1. Open the **Rig Visit Dashboard**.
2. Click the **Precharge** tab.
3. Find your rig. Each row shows the request and, once issued, the issued sheet against it.

> **Watch out:** the office is emailed when a request arrives; that email is office only. The rig hears back through the
> ISSUED email. If you have heard nothing in 48 hours, the request shows amber in the office's inbox; ring them.

---

# The SACRED dashboards

All the pages below are under `http://sdrlazneuiis01d.corp.local:8080/sacred/`. They are written by the **scanner**,
which reads every posted file every ten minutes. Nobody types into them.

**Before you read any page, read the "last scan" stamp** at the top right of the Rig Visit Dashboard. If it is more than
ten minutes old, the scanner has stopped. The office already has an email about it. Do not keep refreshing: ring.

## How to find a report on the Rig Visit Dashboard

**When you need this:** you want to see a report your rig posted, or check that a post arrived.

**Steps**

1. Open the **Rig Visit Dashboard** (`/sacred/dashboard/dashboard.html`). Press **Ctrl+F5** so you are not looking at an
   old copy.
2. Read the **last scan** stamp at the top right.
3. Set the **rig filter** to your rig.
4. Set the **time filter** (7 days, 30 days and so on).
5. Look down the **Report List**: date, rig, type, who, size, the number of attachments and photographs, and an **OEM**
   chip on a CBM report that went to NOV.
6. Click a row to open the report (see the full-report viewer, below).

**If your report is not there, check in this order:**

1. Is the rig right?
2. Is the date right? The list files a report by its own date, not by when it arrived.
3. What did the tool say after **Post**?
4. Did someone post over it?
5. Is it still waiting on the laptop? Open the tool, wait three seconds, and look for **📤 n waiting to send**. If you
   see it, press **Send now**.

Then ring the office.

> **Watch out:** the type column names the report the way the file was named. If your CBM report shows the wrong
> equipment, the wrong equipment was chosen in the tool. Fix it at the source and post again.

## How to read Rig Monitoring

**When you need this:** first thing in the morning, to see every rig at a glance.

**Steps**

1. On the Rig Visit Dashboard, click **Rig Monitoring**. There is one tile per rig.
2. Each tile shows the latest daily report, the daily checks, the BOP planning status, and anything needing attention,
   counted once.
3. Click a rig's **Daily Checks and FLM** link to see the readings history. Daily checks are kept out of the Report
   List on purpose, so they do not bury the reports.
4. A failed or commented reading lifts the tile.

**What "needs attention" counts:** a reading marked failed; a reading with a comment; an action raised on a visit and
still with the rig. That is all.

> **Watch out: "needs attention" is a count of what people wrote.** It is not a judgement the dashboard made about your
> equipment. Nothing on this page ever is.

> **Watch out: potable-water flush readings.** On those two readings a tick is a record, not a pass. The tile applies
> the rule the right way round.

## How to read the CBM Heatmap and a grade history

**When you need this:** to see the condition of an equipment class across the fleet, or the trend on one component.

**Steps**

1. On the Rig Visit Dashboard, click **CBM Heatmap**. Rows are rigs; columns are equipment classes; the colour is the
   latest grade.
2. Read the colour with NOV's scale:

   | Colour | Grade | Meaning |
   |---|---|---|
   | Green | 1 and 2 | Acceptable |
   | Amber | 3 | Monitor: someone found something |
   | Red | 4 and 5 | Fail |
   | Grey | none | No grade on record |

3. Click a cell. The **grade history** opens: every graded task, every date, every grade, and the photographs.
4. Read it as a trend. One inspection is a snapshot; three are a trend, and the trend is what the fleet acts on.

**Condition grade or test result?** One CBM report can carry both.

| Kind of task | How it is graded | What a 5 means |
|---|---|---|
| **Condition** (an inspection) | 1 to 5 on NOV's condition scale | The component has failed its inspection |
| **Test** (e.g. a pressure test) | **1 = pass, 5 = fail**, nothing in between | **A failed test** that needs acting on |

The note under each task in SSORT says which kind it is.

> **Watch out:** a red cell from a grade 5 on a **test** is a failed test, not a condemned component. Read the task
> before you read the stack as having a problem.

## How to open and print a report in the full-report viewer

**When you need this:** to read a whole report, or to print the copy the office keeps.

**Steps**

1. In the Report List, click the report.
2. Scroll down through it: the header; the graded tasks with photographs; **Test records and documents attached**, with
   the task number under each file; NOV's usage table on the classes that carry one; the sign-off.
3. Press **Print** to make the PDF.

This is the whole report. The office prints from this page; NOV get a copy of the same content by email. There is no
second version anywhere, and because the PDF is made from the posted file it is the same for everyone who prints it.

## How to use the Errors button

**When you need this:** a report did not appear, or appears without its photographs.

**Steps**

1. On the Rig Visit Dashboard, press **Errors**.
2. Read the list. Three kinds of thing live there:
   - files the scanner could not read;
   - files over the size ceiling;
   - help requests with no delivery receipt after an hour.
3. If your report is listed, the fix is at the source: make the photographs smaller, or post again.

> **Watch out:** the Errors button is not a list of failures in the field. A failed BOP test is a report, not an error.

## How to read the BOP Fleet Planning page

**When you need this:** to see where every rig's BOP plan stands, or to check that your rig's latest Daily Summary
Report has landed.

**Steps**

1. Open the **BOP Fleet Planning Dashboard** (`/sacred/BOP Fleet Planning Dashboard.html`).
2. Choose **Tile view** (one tile per rig) or **Map view** (the same on the globe).
3. Find your rig's tile. It shows the plan's **% complete**, **BOP %**, the **BOP ready date** and the latest Daily
   Summary Report.
4. Read the BOP ready date against the **need date** and the **float**:
   - **BOP ready date:** when the BOP group (SFI 331 and 332 and the BOP sequence) will be finished and the BOP ready to
     deploy.
   - **Need date:** when drilling is ready for the BOP.
   - **Float:** the difference. Positive is spare time; negative is rig downtime.
   - Green is inside the need date; amber is within two days of it; red is past it.
5. Press **View schedule** for the full schedule, then **Break-in Work** for the unplanned work that interrupted the
   plan.
6. The button on this page opens **Argo Navis** on the plan.

> **Watch out: the page updates when the rig posts.** On a BWM that is the Argo Navis Daily Summary Report; on a P6
> project it is WCGRRT's Planning Report. A change agreed in a meeting shows when it is in the next report, not before.

> **Watch out: test plans.** While test mode is on, test plans appear here marked **test**. Never read a test tile as a
> real rig's state.

> **Watch out:** if your break-in is not on the Break-in Work list, it was not in the report.

## How to use the CoC dashboard and follow an SSCE request

**When you need this:** to check a certificate of conformance, or to request a certified spare from Shared Capital.

The **WCE Certificate of Conformance (CoC) tracker** is a snapshot of the Maximo extract. **Maximo is the master
record.**

**Steps: reading the CoC tracker**

1. Open the CoC tracker (linked from SACRED). Read today's figures off the KPI tiles.
2. Read the status tiers: **Expired**; **Due within 6 months**; **Due within 1 year**; **Due within 18 months**;
   **Valid**; **No date on file**.
3. Open a vessel page and a row. You see the Maximo ID, the certificate history (the newest kept, older ones under a
   **+n** badge), and the same OEM part held in Shared Capital.
4. Use **Ctrl+K** to search. Send the page's address rather than a screenshot: the link opens the same view.

**Steps: raising and following an SSCE request**

1. In the tracker, find the Shared Capital spare and press **Request** beside it.
2. The **SSCE Application Form** opens pre-filled with the asset and the spare. Complete it and submit.
3. It goes to Central Spares for approval on the **SSCE Requests Dashboard** (`/sacred/SSCE Requests Dashboard.html`).
   Within ten minutes it shows there as **Pending**.
4. The approver approves or denies it, with a comment. **Approved** means the spare shows as allocated once the office
   has checked and replaced the live tracker.
5. Argo Navis reads the approval back onto the plan (the SSCE column on the Scope Challenge).

> **Watch out: "No date on file" is not "Valid".** It means the issue and expiry dates are blank in Maximo. The fix is in
> Maximo, not in the tracker.

> **Watch out: annotations live in your browser only.** Ticks, remarks or a Synergi number you add to a row do not
> travel with the file and are not shared. Anything that must be shared goes in Maximo or Synergi.

> **Watch out:** an SSCE request is raised in one place only, the tracker. There is never a second copy to reconcile.

## How to acknowledge an AAB on the Bulletin Board

**When you need this:** an AAB email has arrived for your rig.

An **AAB** is an Alert, Advisory or Bulletin. The Seadrill Bulletin Board carries **Priority 3** only: for information,
no cost, no work order, no approval chain. Priority 1 and 2 stay in the corporate process.

**What the rig owes:** each crew's **Technical Section Leader** reads it and acknowledges it, once per crew, with a
comment every time, and attaches evidence when the advisory asks for it. **The rig never closes an advisory.**
Technical Services review and close.

**Steps**

1. Open the link in the AAB email. It opens the rig page (`/sacred/aab/bulletin-board.html`) already set to your rig.
   Press **Ctrl+F5**.
2. Find the advisory. Its state reads **outstanding**.
3. Read the three sections (**What has happened**, **Why it matters**, **What the rig must do**), the reference
   documents, and the bulletin (marked **BULLETIN**).
4. Press **Acknowledge this advisory**.
5. Type your name; choose your role (**Technical Section Leader**); choose your crew (A or B); the date.
6. Type a **comment**. It is required every time.
7. If evidence is asked for, attach a photograph or a document.
8. Press **Post**. The page says **Posted** and your crew greys out. An email goes to the originator and the rig.
9. The other crew's TSL does the same on their tour.
10. Watch for the closure email from Technical Services.

**The states on the dashboard's AABs tab:** an advisory moves from outstanding, to partly acknowledged (one crew done),
to acknowledged (both crews), to closed by Technical Services. **Overdue** is a date, not an opinion: any open state past
the due date. Partly acknowledged and overdue can both be true at once.

> **Watch out:** the page refuses an acknowledgement with no comment, and refuses one with nothing attached when
> evidence is asked for.

> **Watch out:** if the email has arrived but the page says no advisory applies, the scanner has not run since the post,
> or your browser has an old copy. Wait ten minutes, then **Ctrl+F5**. If your acknowledgement fails to post, the page
> downloads it as a file: email the file to the originator and it is filed by hand.

> **Watch out:** an AAB is not the Help Centre. A question goes to the Help Centre. An advisory to the fleet is an AAB.

## How to ask the TSC Help Centre for help

**When you need this:** the rig needs Technical Services on a problem that is not a report: rig down, a BOP equipment
failure, a tool question, a dashboard question.

The request is posted from the tool, the same way a report is. Within a minute or so it emails Technical Services, the
subsea superintendents, BOP Controls and your rig's SSS, TSL, rig manager and assistant rig manager, and it opens a
Teams chat with them.

**Steps: post the request**

1. In SSORT, open the **📨 Requests** tab. No report or trip needs to be open.
2. Check the **rig** is your rig.
3. **Request Type → Technical Assistance Request** (it sits in the same list as the BOP Precharge Request).
4. Choose the mode: **RIG DOWN (DT)** or **BOP EQUIPMENT FAILURE (non-DT)**.
5. Type the **subject**: one line. It becomes the email subject and the name of the Teams chat.
6. Type the **date and time of occurrence**, the **description**, and **raised by**.
7. Under **Equipment affected**, pick the SFI code. It fills the manufacturer and model and gives the Maximo asset
   number.
8. Add a photograph if it helps.
9. Read **What the directive asks (DIR-00-0116)**. It is worked out from your occurrence time: the Synergi Downtime case,
   the OEM ticket, and from six hours rig down the mandatory notification. **The tool reminds you; it does not do them
   for you.**
10. Press **Send**, and read what it says:
    - **Received by the server:** it went. The emails follow within about ten minutes.
    - **NOT received — nobody has been emailed:** it did not go. The request is saved as a file. Email that file to the
      Technical Services office mailbox and phone the office.

**Steps: follow it**

1. **The email** arrives with your request in the body and your attachments attached.
2. **The Teams chat** opens, named `<Rig> – <date> – <subject>`, with the request as its first message.
3. **The receipt:** on the Help Centre the office sees **Sent to N at hh:mm** beside your request (or **pending** in the
   first twenty minutes). That is the proof of what was sent to whom.
4. **The acknowledgement** comes back under **the same email subject with RE: in front**, so it lands in the same Outlook
   conversation, and the same words go into the same Teams chat. You never have to look anywhere new.
5. Updates and the close come back the same way.

> **Watch out:** allow up to fifteen minutes before deciding a request has not shown. Then check the rig on the form and
> the message the tool gave after **Send**.

> **Watch out:** a rig-down request still open after six hours automatically gets a second chat with the downtime group
> and the rig's management, as the directive asks.

> **Watch out: which loop?** A question goes to the **Help Centre**. An advisory to the fleet is an **AAB**. Progress
> on a BWM plan is the **Daily Summary Report**.

---

# Argo Navis

Argo Navis is the one tool on the fleet that **builds the schedule itself**. It reads the rig's open PMs from Maximo,
works out what order the work has to happen in, stacks up the hours and gives you dates. Then the rig reports against it
twice a day.

**Address:** `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/`. Use Chrome or Edge on a laptop or desktop.

**The life of a plan:** open it → challenge the scope → build the schedule → **Post for review** → the reviewers
verify → **Freeze scope** (Hold 1) → execute, with break-ins and checklists → **Post daily report** twice a day
(Hold 2) → **Post close-out** → the close-out pack goes to eDocs.

**The plan bar.** Every page under the step tabs carries the plan bar: the plan id, the scope version and its state,
the BOP ready chip, **Server save ON / OFF**, and the buttons **💾 Save**, **Post for review**, **Freeze scope**,
**Post daily report**, **Post close-out**, **Export** and **Refresh review**. A button that is greyed is not yet
available at this stage.

## How to open an existing plan

**When you need this:** every time after the plan has been set up. You never have to find a file or rebuild a plan.

**Steps**

1. Open Argo Navis. The landing page offers **New schedule** on the left and **Existing schedule** on the right.
2. Under **Existing schedule**, choose your rig in the dropdown. It defaults to the rig last used on this PC.
3. The rig's plans are listed newest first: **BOP**, **Plan**, **Stage**, **Saved by**, **Saved** (when), and
   **Copy** (Server or this PC).
4. Press **Open** on the plan you want. With one plan it opens straight away; with BOP1 and BOP2 you choose.
5. The plan opens **on the step it was left on**.

[IMG tools/received/dl1/for-dan-2026-10-16-rev16/05 Screenshots/ArgoNavis_REV16_Landing_Existing.png]

The **plan id** is the rig code, the BOP and the commencement date, e.g. `WVE-BOP1-20261012`. It is given when the plan
is set up.

> **Watch out:** if the landing page says "The copy on this PC is newer than the server copy", think before you choose.
> If you did not save the newer work on this PC yourself, choose **open the server copy**.

> **Watch out: test plans.** While test mode is on, **Show test plans** is ticked and test plans carry a **test** tag.
> Do not work on a test plan by mistake.

> **Watch out:** **Continue from a file on this PC…** still works for any plan, planning report or save file Argo
> Navis made. Use it only if the office asks you to; the landing page is the normal way in.

## How to start a new schedule

**When you need this:** a new BWM campaign. Usually the planner sets this up; this is a brief guide.

**Steps**

1. On the landing page, press **+ New schedule**.
2. **Step 1, Import Data.** When opened from SACRED, everything loads by itself. Check the green strip: **Maximo data
   loaded**, with the work order feed, the rules and the CoC register dates. Note the rig's **Sequenceable %** in the
   fleet backlog table: a low figure means a thin schedule.
3. **Step 2, Commencement Setup.** Fill in six fields:
   - **Commencement Date:** the moment the BOP lands on the beams. Every date counts forward from here.
   - **Rig.**
   - **BOP:** BOP1 or BOP2. You get that stack and its pods plus shared rig equipment.
   - **Type of Pull:** BWM, HOP or Unplanned.
   - **BOP Deployment Date + days:** when the BOP goes back subsea. It sets the scope window (work due up to the
     deployment date plus 21 days) and gives you the float.
   - **Schedule Name:** fills itself in. It is read-only on purpose.
4. Read the coverage note under the fields: how many work orders there are for the rig, for the BOP, and how many will
   reach Step 3.
5. Go on to **Step 3, Scope Challenge** (next guide). The plan can be saved from here on.
6. **Step 4, Schedule:** set the four fixed durations (Rack Back, Split BOP/LMRP, Stack Up, Drift Test); tick **Resources
   available to run BOP and LMRP simultaneously?** only if you have two crews; enter the **crew available per
   discipline**; press **Generate Schedule**.

> **Watch out: crew numbers.** Left blank, the tool will schedule eighteen or more jobs at once, which no rig can do.
> Put real numbers in and the dates become achievable.

## How to save a plan

**When you need this:** whenever you have done work on the plan you want to keep.

**Steps**

1. Press **💾 Save** on the plan bar (it is also at the foot of Execute & Report).
2. Read the message: "Saved to server (available to other PCs within about 10 minutes)".
3. Check the chip on the plan bar reads **Server save ON**, with the time it was last saved.

[IMG tools/received/dl1/for-dan-2026-10-16-rev16/05 Screenshots/ArgoNavis_REV16_Save_Chip.png]

**What you need to know about saving**

- **Automatic saves.** Argo Navis also saves itself each time a step is completed and every 30 minutes while there are
  changes.
- **One file per plan.** Each save replaces the last. If two people on the rig have the plan open, the last save wins.
  Agree who holds the pen on each shift.
- **A save is never a review.** Nobody is told and nothing is re-reviewed. Posting is separate.
- **A copy is always kept on this PC too.**
- **Server save OFF** always says why: the plan was opened from a file; there is no configuration; the configuration is
  not valid; or the last save failed (with the error number). It is never silent.

> **Watch out: Server save OFF means the server does not have your latest work.** Other PCs, the office and the
> dashboard cannot see it. Read the reason on the chip. If the last save failed, try **💾 Save** again; if it still
> fails, send the office the reason and keep the PC copy.

> **Watch out: Simulate.** Nothing can be saved, posted or downloaded while a simulation is running (see below).

## How to challenge the scope and defer work with a reason

**When you need this:** before the schedule is built and posted for review. This is the part that needs your judgement,
not the computer's.

**Steps**

1. Click the **Scope Challenge** tab (step 3).
2. Answer the **milling question** at the top: "Was any milling conducted in the previous well or during the current
   campaign?" It is answered on every plan. **Yes** means debris may have reached the packers: press **Prefill annular
   inspection task**, set its hours, and note what was milled.
3. Read the boxes across the top. **Every active PM is accounted for:**
   - **Active in Maximo:** every open PM for this rig and BOP.
   - **Captured by the window:** how many to execute and how many deferred.
   - **Not captured:** due after the window (listed under the orange bar; tick **Execute** on one to bring it in).
   - **Manual tasks:** added by hand.

   [IMG tools/received/dl1/for-dan-2026-10-16-rev15/06 Screenshots/ArgoNavis_REV13_Scope_Challenge.png]

4. Every PM inside the window arrives ticked **Execute**. **Untick** each one you are deferring to a later window.
5. When you untick one, choose **Deferred because** (parts not available, access, crew, superseded and so on).
6. If a work order will not be done before its Maximo due date, whether deferred or finishing late, tick **NC** and type
   the Maximo Non-Conformity reference. Where Maximo already holds one it is filled in and tagged **MAXIMO**. An orange
   **NC?** is only a prompt; you decide.
7. Use **Add Task** for work with no PM behind it (choose the type: **Work**, **MOC** with its number, or **AAB** with its
   number).
8. Check durations (**Duration**) and **Techs** on the big jobs; overtype if you know better.

   [IMG tools/received/dl1/for-dan-2026-10-16-rev15/06 Screenshots/ArgoNavis_REV14_Deferral_Reason.png]

9. Go on to **Schedule** and press **Generate Schedule**.

> **Watch out: the schedule cannot be built until every ticked NC has its reference.** A red banner names the work
> orders still missing one.

> **Watch out:** every plan carries **SSS-007 BOP handling equipment function test**, marked **EVERY PLAN**. It cannot
> be removed.

> **Watch out: "Unassigned" or 0 h.** The work order's job plan is not on the Branch Map, so the tool cannot sequence
> it. Type a duration and branch, or ask the planner to add the job plan. Do not leave it at 0 h.

> **Watch out: coming soon (not in REV 16).** A BOP PM under an NC that is left out of the window will show a red
> critical flag at the scope freeze, and a reason will be required. The maintenance window is the chance to do it.

## How to read SFI groups, BOP %, the BOP ready date and float

**When you need this:** to understand what holds the BOP, and what does not.

Work is grouped by **SFI**, the equipment code, not by who maintains it. So BOP control work that Electrical own still
comes through, and MPD work sits in 339.

| SFI | Equipment |
|---|---|
| **331** | BOP stack |
| **332** | BOP control system |
| 302 | Heave / motion compensation |
| 314 | Hoisting / handling |
| 315 | Subsea support utilities |
| 334 | Diverter |
| 335 | Riser system |
| 336 | Choke & kill |
| 337 | Wellhead connector |
| 339 | MPD / other |

**The BOP group = SFI 331 + SFI 332, plus the BOP sequence** from landing on the beams to the drift test.

- **BOP %** is worked out on the BOP group only.
- **The BOP ready date** is the finish of the BOP group only. Riser or MPD work finishing later does not hold the BOP.
- **The need date** is when drilling is ready for the BOP. Type it into the banner.
- **Float** = need date minus BOP ready date. Green: inside the need date. Amber: within two days. Red: past it, with
  the days of rig downtime.

**Steps**

1. Open the **Schedule** tab. The **BOP READY TO DEPLOY** banner is at the top, with **NEED DATE** and **FLOAT**. The
   same appears as a chip on the plan bar on every page.

   [IMG tools/received/dl1/for-dan-2026-10-16-rev15/06 Screenshots/ArgoNavis_REV14_BOP_Ready_Banner.png]

2. The dates move every time you press **Generate Schedule** or **Calculate Project**.
3. To try a change without committing it, press **Simulate** on the banner. Defer a task, slide a duration, mark work
   done, and watch the BOP ready date move. Defer a BOP-group task and it moves; defer a riser task and it does not.
4. When you have finished, press **Reset to the real plan**.

   [IMG tools/received/dl1/for-dan-2026-10-16-rev15/06 Screenshots/ArgoNavis_REV14_Simulate.png]

> **Watch out:** in a simulation nothing can be posted, saved or downloaded. If you leave Simulate without resetting and
> then see odd dates, press **Reset to the real plan**, or close the tab without saving.

> **Watch out: float and Queued are different.** Float says whether a task can slip without moving the end. Queued says
> how long it waited for crew. A task with float may still have no crew free to start it early.

## How to post a plan for review, and how reviewers verify it

**When you need this:** the scope is challenged and the schedule built, and the plan needs the regional reviewers'
verification.

**Steps (the rig or planner)**

1. Check the Scope Challenge is answered and the schedule built.
2. Press **Post for review** on the plan bar. It sends **scope version 1** to SACRED.
3. SACRED emails the reviewers, opens the plan's Teams chat, and lists the plan on the **Help Centre's Plans tab**.
4. Watch the state beside the plan id: **Awaiting review**, **Changes requested** (with the reviewer's comment),
   **Verified**, **Frozen** or **Closed**, with "**n of m verified**" and who is outstanding.
5. Press **Refresh review** to re-read the state. SACRED updates it every ten minutes.
6. If a reviewer asks for changes, make them and press **Post for review** again. It posts the next scope version, and
   review starts again on that version.

[IMG tools/received/dl1/for-dan-2026-10-16-rev15/06 Screenshots/ArgoNavis_REV14_Plan_Bar_Review.png]

**Steps (the reviewer)**

1. Open the **TSC Help Centre** (`/sacred/help/help-centre.html`) and click the **Plans** tab.
2. Find the rig's card. It shows the region, the required reviewers, who has verified, "n of m verified", the comments
   and the scope versions.
3. Read the scope. Then either **verify** it, or **ask for changes** with a comment.

> **Watch out: Refresh review matters only before the freeze.** After the freeze the scope is locked, so there is
> nothing to refresh into. Pressing it and seeing nothing change is correct.

> **Watch out:** the reviewers for your region are named on the plan's card on the Plans tab.

## How to freeze the scope (Hold 1)

**When you need this:** every required reviewer has verified the current scope version.

**Steps**

1. Check the plan bar reads **Verified** and "**m of m verified**".
2. Press **Freeze scope**. It freezes the version the reviewers verified.
3. The state now reads **Frozen**. From now on new work is **break-in work**.

**Hold 1:** **Freeze scope** works only when every required reviewer has verified this version. You can **Freeze without
full verification…**, but you must give your name and a reason, and it shows **red** on the dashboard.

> **Watch out:** after the freeze **Post for review** is greyed. Do not look for a way round it. New work is a break-in.

## How to execute: complete a task, use a checklist, raise break-in work, read the chronology

**When you need this:** every shift, from the freeze until close-out.

Work on the **Execute & Report** tab (step 5). Set the **Report Date** first; almost everything on the page is worked
out from it.

### Complete a task

1. In **Task & Milestone Actuals**, find the task.
2. Set its status, its actual dates, and its **% complete**.
3. Do the same for every task that has moved.
4. Press **Calculate Project** **once**. The % complete, BOP % and the dates re-forecast.

**Complete** means 100 per cent, finished at the moment you mark it. If you later correct an actual finish, you are asked
why. Milestones tick themselves (for example, "LMRP Complete" goes green when every LMRP task is complete).

> **Watch out: type all your percentages first, then press Calculate Project once.** Ticking a step or typing a % does
> nothing to the dates until you do.

### Use a job plan checklist

1. Press **☑ Checklist** under the task's % box. The job plan opens as a checklist inside Argo Navis.
2. Fill in **Work details** (rig, BOP, Maximo work order, date started).
3. For each step, press **✓ Done**, **N/A** or **✕ Not OK**. **N/A** and **Not OK** need a comment. **Not OK** asks for a
   CM or Synergi reference.
4. Add photographs and the materials used.
5. Sign it off: **Performed by** and **Verified by**, Seadrill or third party.
6. Press **✕ Close** to return to the plan, then **Calculate Project**.

[IMG tools/received/dl1/for-dan-2026-10-16-rev15/06 Screenshots/ArgoNavis_REV15_Checklist_Built_In.png]

The checklist's % drives the task's % (Done and N/A count; each step is an equal share). A signed checklist shows
**SIGNED ✔ · evidence linked**.

### Raise break-in work

After the freeze, the rig controls new work. A break-in needs **no work order and no approval**.

1. Scroll to **Break-in Work**.
2. Choose the **Type** and type a **Description**.
3. Choose the **Area** and the **SFI**.
4. Under **After**, name the task or job plan it comes after.
5. Type the hours in **Dur (h)**, and who it was **Requested by** (Rig, Client, Office or OEM). Add a Synergi or MOC
   reference if it is a real scope change.
6. Press **+ Add**. It is numbered **BRK-001** onwards automatically.
7. Press **Calculate Project**. The finish, the float, the critical path and, for BOP-group work, the BOP ready date move.
8. When it is done, press **Close** on its row and record the lesson learned.

[IMG tools/received/dl1/for-dan-2026-10-16-rev15/06 Screenshots/ArgoNavis_REV15_Breakins_and_NC.png]

Every break-in goes in the Daily Summary Report. The **Deferrals & Non-Conformities** table above it lists every
deferral and NC, and prints in the report. Deferring after the freeze still needs a reason.

> **Watch out: a delay is not a break-in.** Waiting for a crane, a permit or the weather goes in **Waiting / NPT**, and
> you name the task it holds up. NPT does not move the dates, because the delay already shows in your actuals. If the
> wait turned into real work, it is a break-in instead, not both.

> **Watch out:** only PM work orders come through the Maximo feed today. Unplanned work is a break-in. If it becomes real
> corrective work, raise the CM in Maximo as normal.

### Read the chronology

1. On Execute & Report, scroll to **Chronology**.
2. The dates run across the top. The **yellow line is Now**.
3. Rows are SFI groups, the BOP group (**BOP · SFI 331 + 332**) first. **Branch** switches to rows by branch.
4. Each **numbered star** is a milestone at its exact time; the dashed line runs down through the work.
5. The **key** underneath gives each milestone's name, date and time, and whether it is **achieved** or **estimated**.
6. The red outline marks the critical path: the task currently bounding the finish.
7. Under it, **Next 24 Hours — Focus List** is the rig's list for the day.

[IMG tools/received/dl1/for-dan-2026-10-16-rev16/05 Screenshots/ArgoNavis_REV16_Execute_Chronology_Now.png]

## How to post the Daily Summary Report

**When you need this:** twice a day, after each shift handover, from the scope freeze until close-out.

**Hold 2:** **Post daily report** is available only after the freeze.

**Steps**

1. Update the actuals, raise any break-ins, and press **Calculate Project** (previous guide).
2. On **Execute & Report**, set the **Report Time (after shift handover)**. It is the rig's own handover time, not a fixed
   0600 or 1800. Leave it blank and it uses the time you post.
3. Check **Project & Rig People**: rig manager, assistant rig manager, OIM, TSL, DSL, subsea supervisor, planner and
   the rest. They are filled in once and updated at crew change; they print on every report.
4. Check **Quality / Rig Reliability** items (they stay until removed), **Lessons learned since the last report**, and
   **Comments**.
5. Press **Preview as SACRED prints it** and read the report as it will be printed.
6. Press **Post daily report** on the plan bar (or **⇪ Post report** at the foot of Execute; it is the same action).
7. Within about 35 minutes SACRED prints the PDF and the Daily Summary Report flow emails it, with a line in the plan's
   Teams chat. The BOP Fleet Planning tile updates.

[IMG tools/received/dl1/for-dan-2026-10-16-rev15/06 Screenshots/ArgoNavis_REV15_Daily_Report_and_Rig_People.png]

> **Watch out: the red "Daily report due" chip** appears on the plan bar when more than 14 hours have passed since the
> last report. It is seen by the rig on the plan bar and by the office on the tile.

> **Watch out: if a post fails**, the tool shows the error and saves the file to your Downloads. Send both to the
> office. **Download a copy** is still there for emailing, but it does not post.

> **Watch out:** allow about 35 minutes before calling a report late. If it has not arrived, check the BOP Fleet
> Planning tile and the "last scan" stamp, then the plan bar for an error or **Server save OFF**.

## How to close out a plan, and what is in the close-out pack

**When you need this:** every task is complete and the BOP is ready to go.

**Steps**

1. Check every task is complete, and every deferred work order has a reason.
2. Press **Post close-out** on the plan bar. (It is greyed until those two things are true.)
3. Give the eDocs reference of the close-out record.
4. The plan's state reads **Closed**.

**The close-out pack.** When a plan is closed, SACRED joins every record filed for it into **one PDF**, in the plan's
project folder under **08 AAR and Close-out**:

- a cover: rig, BOP, plan id, scope version, closed-out date, and the eDocs number;
- a contents sheet listing every file in the project folder with its date and fingerprint (SHA-256);
- then the plan, the pre-deployment checklist, the tests, the CBM records, the precharge, the evidence and the
  close-out, each on a new page with its own title block.

That pack is what goes to eDocs. Until the automatic eDocs connection is set up by ISIT, it is filed by hand.

---

# The Daily Summary Report requirement

*One page. Keep it by the rig's planning PC.*

**What it is.** The twice-daily progress report on a BWM plan (form PPDSR030918's content), made by the system. It
replaces the planner's hand-made Word report. **The rig sends it, not the planner: the rig is the planner on the
ground.**

**When and by whom**

- **Twice a day, after each shift handover.**
- **Posted by the rig**, from Argo Navis (**Post daily report**).
- **The report time is the rig's own**: the time of the handover.
- **Available only after the scope freeze** (Hold 2).
- A red **Daily report due** chip shows after 14 hours with no report.

**What is inside**

- The project header: rig, BOP, project type, data date and time; rig manager, OIM, TSL, DSL, subsea supervisor.
- Maintenance day ("Day X of Y"); original and current finish, with times.
- Plan variance (hours) and float to the BOP need date (hours).
- Critical path and SIMOPS; **project % and BOP % complete**.
- Milestones: baseline, estimated, actual.
- Break-in work and delays (new ones since the last report marked).
- Quality and rig reliability actions; lessons learned since the last report.
- Work completed in the last cycle, and planned for the next.
- General comments.

**What must be correct before you post**

- Progress and actual finishes, with **Calculate Project** pressed after the last change.
- Every break-in raised, with its hours.
- Delays logged in Waiting / NPT, against the task they hold up.
- The people on board for the crew in place.
- The report time set to the handover.

**Who it goes to** (emailed automatically, PDF attached, with a link to the full schedule on the BOP Fleet Planning
page; no Gantt in the email)

| | Who |
|---|---|
| **To** | The rig's rig manager, assistant rig manager, subsea supervisor, TSL, DSL, electrical supervisor and MPD supervisor; and the WCE office planning leads |
| **Cc** | All TSC WCE managers, superintendents and planners |
| **Teams** | A line in the plan's Teams chat with the % and the link (Argo Navis plans only) |
| **Subject** | `<Rig> <BOP> <type> Reporting yyyy/MM/dd HHMM` |

**Two routes, one report**

| | **BWM plans** | **P6 projects** (complex capex) |
|---|---|---|
| Posted from | **Argo Navis**: **Post daily report** | **WCGRRT**: the **Planning Report** (Discipline = Planning) |
| The numbers come from | The plan in Argo Navis | **📥 Import ERT**, the P6 export: done and next lists, milestones, critical path, % and BOP % |
| Same twice-daily rule and report time | Yes | Yes |
| Teams line | Yes | No (no plan chat; the email carries the link) |

Both print the same Daily Summary Report from the same rules and are emailed by the same flow to the same people. Each
post is named with the date, rig, type, BOP and report time, so two reports a day never overwrite each other. The BOP
Fleet Planning tiles update from either.

**Agreed at the workshop** *(write in the hold point decisions)*

| # | Decision | What was agreed |
|---|---|---|
| 1 | Who on each rig posts it (a role) | ______________________________________________________________ |
| | | ______________________________________________________________ |
| 2 | The two report times on my rig | ______________________________________________________________ |
| 3 | What has to be correct before it is posted | ______________________________________________________________ |
| | | ______________________________________________________________ |
| 4 | When a report is late: who notices, who chases, by when | ______________________________________________________________ |
| | | ______________________________________________________________ |
| 5 | The planner's role once the rig posts | ______________________________________________________________ |
| | | ______________________________________________________________ |
| 6 | Form control (PPDSR030918, new revision? who approves?) | ______________________________________________________________ |
| 7 | P6 only: how the rig gets a fresh ERT for each report | ______________________________________________________________ |

Actions from the hold point (owner and date):

______________________________________________________________________________________________________________

______________________________________________________________________________________________________________

______________________________________________________________________________________________________________

______________________________________________________________________________________________________________

---

# Glossary

| Term | What it means |
|---|---|
| **AAB** | Alert, Advisory or Bulletin. The Seadrill Bulletin Board carries Priority 3 (for information). Each crew's TSL acknowledges; Technical Services close. |
| **Argo Navis** | The BWM planning tool that builds the schedule from Maximo and takes the rig's reports. Formerly called DL-1. |
| **BOP %** | Per cent complete of the BOP group only (SFI 331 + 332 and the BOP sequence), weighted by hours. |
| **BOP group** | SFI 331 (BOP stack) and SFI 332 (BOP control system), with the BOP sequence from landing on the beams to the drift test. |
| **BOP ready date** | When the BOP group will be finished and the BOP ready to deploy. Not the end of the whole plan. |
| **Branch Map** | The Job Plan Branch & Sequence Map: the rules that say which branch each job belongs to and in what order. |
| **Break-in work** | Unplanned work found after the scope freeze, raised by the rig, numbered BRK-001 onwards. No work order, no approval. It moves the schedule. |
| **BWM** | Between Well Maintenance: the maintenance window on the BOP between wells. |
| **Calculate Project** | The button on Execute & Report that applies the percentages and re-forecasts the dates. |
| **CBM** | Condition-Based Maintenance. CBM reports carry condition grades (1 to 5) and test results (1 pass, 5 fail). |
| **CoC** | Certificate of Conformance. The CoC tracker is a snapshot of the Maximo extract; Maximo is the master record. |
| **Controlled document** | The version that counts. For a precharge, the issued PDF. |
| **Daily Summary Report** | The twice-daily progress report on a BWM plan (or P6 project), posted by the rig and emailed automatically. |
| **Deferral** | A PM unticked from this window to a later one. It needs a reason. |
| **ERT** | The P6 export the WCGRRT Planning Report imports on a P6 project. |
| **Float** | Need date minus BOP ready date. Positive is spare time; negative is rig downtime. |
| **Hold 1** | Freeze scope works only when every required reviewer has verified the version (or with a named, reasoned override shown red). |
| **Hold 2** | Post daily report is available only after the freeze. |
| **KE** | Known error: an open defect in a tool, logged with its workaround (KE-06, KE-08…). Quote the KE number when you ring the office. |
| **MAWHP / MASP** | Maximum anticipated wellhead / surface pressure. |
| **MOC** | Management of Change: the company process for approving changes. |
| **NC** | A Maximo Non-Conformity: the approved record that lets a work order go past its due date. |
| **Need date** | When drilling is ready for the BOP. |
| **NPT** | Non-productive time: waiting (permit, crane, weather). Logged, but it does not move the dates. |
| **PDC** | Pre-Deployment Checklist (FRM-00-0168): signed by TSL, subsea supervisor and rig manager before the BOP is deployed. |
| **PSIG / PSIA** | Pressure on the gauge / absolute pressure. They differ by atmospheric pressure, about 14.7 psi. You charge to PSIG. |
| **Receipt** | The record a notification writes: what was sent, to whom, and when. |
| **Scanner** | The script that reads every posted file every ten minutes and builds the SACRED pages. |
| **Scope challenge** | Step 3 of Argo Navis: deciding what is genuinely being done in this window. |
| **Scope freeze** | The point where the reviewers have verified the scope and it is locked (Hold 1). |
| **Scope version** | Each Post for review makes a new version (v1, v2…). Review starts again on each. |
| **Server save ON / OFF** | The chip on the Argo Navis plan bar that says whether the server holds your latest save, and if not, why. |
| **SFI** | The equipment code used in Maximo, e.g. 331 BOP stack, 332 BOP control system, 335 riser, 339 MPD. |
| **Simulate** | Try changes to the plan on screen; nothing can be saved or posted until you press Reset to the real plan. |
| **SSCE** | Subsea Shared Capital Equipment: certified spares held centrally and allocated to rigs on request. |
| **TSC** | Technical Services Centre. The TSC Help Centre is where the office answers the rig's help requests. |
| **TSL** | Technical Section Leader. |

---

# Where to get help

| What you need | Who, and how |
|---|---|
| A problem on the rig: rig down, an equipment failure, a question about a tool or a page | **The TSC Help Centre.** Raise a **Technical Assistance Request** from SSORT (📨 Requests). It reaches Technical Services, the subsea superintendents, BOP Controls and your rig's people, with a Teams chat. |
| The request will not send | Email the saved file to the Technical Services office mailbox and **phone the office**. |
| A precharge question, or a number that looks wrong | **The Technical Services office** (the precharge team). Check your request's inputs first. |
| The dashboards, the scanner, notifications, the AAB board, the CoC link | **Dan Plant**, Subsea Technical Services (SACRED and the dashboards). |
| Argo Navis: planning, the plan, reviewers, the Branch Map, durations | **Lee Arnold**, Planning (Argo Navis). The Branch Map changes go through Dan. |
| CoC data that is wrong | Fix it in **Maximo**, with your rig's CoC owner. Questions on the tracker's data go to its owner through Dan. |
| A change to any tool, the calculator or a process | Raise it under **MOC**. Ideas for what the tools should do next go on the action list through Dan. |

Use names and roles as above; your office address book holds the current contact details.

---

# Links

All addresses are on the Seadrill network. If a page looks out of date, press **Ctrl+F5**.

| Page | Address | Who uses it |
|---|---|---|
| SACRED home | `http://sdrlazneuiis01d.corp.local:8080/sacred/` | Everyone |
| Rig Visit Dashboard (Report List, Rig Monitoring, CBM Heatmap, Compliance, Precharge, AABs tabs; Errors button) | `http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html` | Everyone |
| BOP Fleet Planning Dashboard | `http://sdrlazneuiis01d.corp.local:8080/sacred/BOP%20Fleet%20Planning%20Dashboard.html` | Everyone |
| Argo Navis (REV 16) | `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/` | Rig and planners |
| Seadrill Bulletin Board (AAB rig page) | `http://sdrlazneuiis01d.corp.local:8080/sacred/aab/bulletin-board.html` | TSLs |
| TSC Help Centre (incl. the Plans tab for reviewers) | `http://sdrlazneuiis01d.corp.local:8080/sacred/help/help-centre.html` | Office and reviewers (password) |
| SSCE Requests Dashboard | `http://sdrlazneuiis01d.corp.local:8080/sacred/SSCE%20Requests%20Dashboard.html` | Requesters and Central Spares |
| Status page (last scan, each rig's build) | `http://sdrlazneuiis01d.corp.local:8080/sacred/status/` | Everyone |
| Precharge request form | Inside SSORT: 📨 Requests → BOP Precharge Request (or the standalone request page) | Rig |
| Technical Assistance Request | Inside SSORT: 📨 Requests → Technical Assistance Request | Rig |
| WCE CoC tracker | Linked from SACRED | Everyone |
