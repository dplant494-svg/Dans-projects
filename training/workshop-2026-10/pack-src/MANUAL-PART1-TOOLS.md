# Part 1 — The reporting tools

**What this part covers:** the two reporting tools you use on the rig.

- **WCGRRT** (the Well Control rig visit and daily report tool), build **REV 174**.
- **SSORT** (the subsea operations reporting tool: CBM, surface tests, pre-deployment, requests), build **REV 169**.

Both builds are the ones shown at the workshop. When a new revision ships you are told in the handoff. You do not need
to hunt for it, but you do need to know which one you are on when you ring the office.

**How to use this part.** Each guide starts with *When you need this*, then numbered steps in the order you click.
A picture of the screen follows the step it shows. The **Watch out** box at the end of each guide lists the traps.
The last two guides are a table of known errors and a one-page quick reference card.

**The buttons in this part.** Buttons are written in **bold** with their icon, exactly as they read on screen, for
example **📤 Post Report**. Messages the tool shows you are written in *italics*.

---

## How to open the tools and check the badge

**When you need this:** every time you start work in either tool.

**What you need on the laptop:**

- Edge or Chrome, kept up to date.
- The Seadrill network. Outside the office, connect to the VPN first: the tools open from the intranet server.
- A **normal** browser window. Never an InPrivate or Incognito window.
- Downloads allowed, and **Microsoft Print to PDF** (or *Save as PDF*) available for the checklist and CBM PDFs.
- A screen 1366 px wide or more is comfortable. The forms are wide.

Nothing needs installing.

**The two links.** Save these as favourites and always open the tools from them:

```
WCGRRT:  http://sdrlazneuiis01d.corp.local:8080/sacred/WCE%20Rig%20Vist%20Reporting%20Tool%20V0.html
SSORT:   http://sdrlazneuiis01d.corp.local:8080/SSORT/index.html
```

1. Open WCGRRT from its link.
2. Look at the revision badge in the top bar. It must read **WCGRRT · REV 174**.

[SHOT 1]

3. Open SSORT from its link, in a second tab.
4. Look at its badge. It must read **SSORT · REV 169**.

[SHOT 17]

5. If either badge shows an older number, press **Ctrl+F5**. If it still shows the old number, close the browser
   completely and open it again from the link.
6. Wait three seconds in each tool and look at the bottom right of the screen. If an orange **📤 n waiting to send**
   button appears, something from an earlier session has not reached the dashboard yet. See
   *How to post when there is no connection* before you do anything else.
7. If you are starting fresh work, press **⊘ New Trip** so nothing is carried over from last time.

> **Watch out**
>
> - **Never open SSORT from `sacred\index.html`.** An old SSORT (REV 116) is still on the server there. It looks
>   like SSORT and it is years out of date. Use the `…/SSORT/index.html` link only, and check the badge says REV 169.
> - **Never open a tool from a saved copy** on your desktop or in an email. A saved copy is frozen at the day it was
>   saved and does not get fixes.
> - **Never work in an InPrivate window.** The autosave and the "waiting to send" store live in the browser. An
>   InPrivate window throws them away when it closes, and your work goes with it.
> - **A browser can keep showing an older revision from its cache,** especially on a laptop that had the tools open
>   last week. The badge is how you catch it. Ctrl+F5 fixes it.
> - When you ring the office about something that looks wrong, **say which revision the badge shows.**

---

## How to start a WCGRRT report and set the rig identity

**When you need this:** at the start of every rig visit or daily report in WCGRRT.

**The toolbar.** Learn these seven buttons first:

| Button | What it does |
|---|---|
| **⊘ New Trip** | Clears the form and starts again |
| **↓ Browser Save** | Keeps your work in this browser on this laptop |
| **↑ Browser Load** | Brings back what you saved with Browser Save |
| **💾 Save to File** | Saves a `.json` file you can keep or email |
| **📂 Load from File** | Opens a `.json` you saved earlier, or one someone sent you |
| **⎙ Print / PDF** | Prints the report, or saves it as a PDF |
| **📤 Post Report** | Sends the report to the dashboard |

1. Press **⊘ New Trip**.
2. Open **Visit Information**.
3. Set **Rig / Asset** to your rig. Do this first: everything on the dashboard hangs off it.
4. If the work belongs to no rig (for example an audit at an OEM's premises, or corporate equipment), choose
   **SSCE Equipment** under *Not rig-specific*.
5. Set **Discipline**. The form changes to suit it: you only see the boxes your job needs.
6. Set **Visit Classification**.
7. Set **Visit Start Date** and **Visit End Date**.

[SHOT 2]

**If you forget the rig.** Press **📤 Post Report** with no Rig / Asset set and the tool refuses:

> *Cannot post: no Rig / Asset selected. Set Rig / Asset in Visit Information first — a report with no rig cannot be
> attributed and will not display correctly on the dashboard. If this work is not rig-specific (for example a vendor
> audit on corporate equipment), choose "SSCE Equipment" under "Not rig-specific".*

8. Close the message.
9. Go back to **Visit Information** and set **Rig / Asset**.
10. Post again.

[SHOT 3]

> **Watch out**
>
> - **Never pick the nearest rig just to get past the no-rig message.** The report is then filed as that rig's work,
>   in that rig's history. Choose your own rig, or SSCE Equipment for non-rig work.
> - **SSCE Equipment is a real place on the dashboard.** It is filed and attributed like any rig, but it never enters
>   a fleet count. It is the right home for vendor audits and corporate equipment.
> - The guard is there because nine reports once landed in a bucket called *Unattributed* in a single scan, and
>   nobody could tell whose work they were. The tool now refuses rather than guess.
> - **Discipline = Planning gives you a different report** (the Daily Summary Report), not the Well Control daily
>   report in this part. Check Discipline before you start filling in.

---

## How to add a daily report entry, equipment and captioned photographs in WCGRRT

**When you need this:** every day you report work on the rig in WCGRRT.

1. Open the section dropdown.
2. Choose **📋 Daily Report Entry** and add it.

[SHOT 4]

3. Set the **Report Date** (see the next guide: this is the box that names the file).
4. Write the narrative: what was done, what was found, what is outstanding.
5. Add an **equipment entry**.
6. Fill in **make**, **model**, **serial** and the **work done**.

[SHOT 5]

7. Add a photograph to the entry. There are two ways:
   - tap or click the photograph box and pick the file; **or**
   - drag the photograph from a folder straight onto the box.
8. Type a **caption** under the photograph: what it is, where it is, and what it shows.
9. Repeat for each photograph. Caption every one.

[SHOT 6]

10. Add more equipment entries the same way, one for each item worked on.
11. Press **↓ Browser Save** every so often as you go.

> **Watch out**
>
> - **Caption every photograph.** An uncaptioned photograph on the dashboard is a picture of a flange nobody can
>   place. Thirty seconds now saves the office ringing the rig.
> - **One photograph per box.** Drop several at once and only the first is used. A file that is not a picture is
>   refused with a message.
> - **Do not shrink photographs first.** The tool compresses them on the way in: a 6 MB phone picture lands at about
>   300 KB. Do not lower the quality to save space.
> - **There is no "attach a document" button on a Well Control daily report.** On a daily report, evidence means
>   captioned photographs. A chart or certificate belongs on the CBM inspection in SSORT (see *How to attach test
>   records to a CBM*), or emailed to the office. Do not post a photograph of a screen instead.

---

## How to set the Report Date in WCGRRT — the box that names the file

**When you need this:** every daily report, before you post. This is the single most important box in WCGRRT.

**Why it matters.** A daily report is one per rig per day, and it is named for the day it covers. The **Report Date**
in the Daily Report block names the posted file. **The visit dates do not.** The file looks like this:

```
seadrill-report_<Rig>_<Report Date>_daily-report.json
```

On the dashboard, a post with the same file name **replaces** the earlier one. That is how a corrected report
replaces a wrong one. It is also how a day's work can disappear.

1. Find **Report Date** in the Daily Report block.

[SHOT 7]

2. Set it to **the day the work was done**, not the day you are typing. Work done on the 18th, written up on the
   19th, has Report Date = the 18th.
3. Check it again before you post.
4. Press **📤 Post Report**.
5. If the Report Date is anything other than today or yesterday, the tool asks you:

   > *This report is dated [date]. That is [n] days ago. The date sets the posted filename, so posting it will replace
   > any report already filed for [date]. If you meant today, cancel and change the Report Date field. Post it as
   > [date]?*

6. **Read it.** On the rig this question almost always means the date is wrong.
   - Wrong date: press **Cancel**, correct **Report Date**, and post again.
   - You really are posting a late report for that day: press **OK**.

[SHOT 8]

**The West Capella week.** Two things went wrong on one rig in one week, and the tool now guards against both:

- **Reports were posted before they were finished,** so the office worked from half a report. Post now asks you to
  confirm that the report is finished. It is visible to everyone with dashboard access the moment it lands.
- **Report dates were left on yesterday.** Two different days were posted under one file name, the second replaced
  the first, and a whole day's work vanished from the dashboard. It had to be recovered from private saved copies.
  The back-dated question above exists because of this.

> **Watch out**
>
> - **Report Date, not Visit Start Date,** names a daily report. Check it every day: it is easy to leave it on
>   yesterday.
> - **Today or yesterday, the tool stays quiet.** It only asks for older dates. So a wrong "yesterday" will not be
>   caught for you. Look at the box.
> - **One daily report per rig per day.** If two people post a daily report for the same rig and the same Report
>   Date, the second replaces the first. Agree on the rig who posts the daily report.
> - **Do not click through the back-dated question out of habit.** It is telling you that you are about to
>   overwrite a day.

---

## How to save your work in WCGRRT: the three saves and the restore bar

**When you need this:** throughout the day, and before you close the laptop.

**The three saves are three different things. Only one of them reaches anybody else.**

| Button | Where your work goes | Who can see it |
|---|---|---|
| **↓ Browser Save** | This browser, on this laptop | Nobody else. It does not follow you to another computer |
| **💾 Save to File** | A `.json` file on the laptop | Whoever you send the file to |
| **📤 Post Report** | The dashboard | Everyone with dashboard access |

**To keep a working copy in the browser:**

1. Press **↓ Browser Save**.
2. To bring it back later, press **↑ Browser Load**.

**To keep a copy you can email or move:**

1. Press **💾 Save to File**.
2. Save the `.json` somewhere you can find it, for example your TSC REPORTS folder.
3. To open it again, on this laptop or another, press **📂 Load from File** and pick the file.

**If the tool closes by accident** (the tab is closed, the laptop restarts, the tablet battery dies):

1. Open WCGRRT again from its link.
2. A bar appears at the top: *Unsaved session from [time] found in this browser*.
3. Press **Restore** to bring your work back, or **Dismiss** to throw it away.

[SHOT 9]

> **Watch out**
>
> - **Browser Save is not a backup.** It lives in one browser on one laptop. Clearing browsing data, an InPrivate
>   window, or a different laptop and it is gone. For anything that matters, also **💾 Save to File**.
> - **The restore bar is per browser and per laptop.** It will not follow you to another computer.
> - **Press Dismiss only when you are sure.** Dismiss throws the unsaved session away.
> - **Saving is not posting.** Nothing reaches the office until you press **📤 Post Report** and read the receipt.

---

## How to fill in the rig-specific test forms in WCGRRT

**When you need this:** when you record a BOP function test, EDS verification, acoustic test, EHBS test, ROV test,
soak test or surface drawdown test in WCGRRT.

**These forms know your rig.** They are built from your rig's own configuration: its EDS sequences from its NOV
verification sheet, its EHBS type, whether it has an acoustic system. So **set Rig / Asset first**, or the forms will
not load.

1. Check **Rig / Asset** in Visit Information is your rig.
2. From the section dropdown, add the test entry you need.
3. **BOP function test:** fill in the form line by line.

[SHOT 10]

4. **EDS:** pick a sequence from the **sequence dropdown**. The steps table appears, with your rig's own steps.
   Record each step.

[SHOT 11]

5. **Acoustic:** fill in the acoustic function table. If your rig has no acoustic system, the form says so instead
   of showing an empty test. There is nothing to record.

[SHOT 12]

6. **EHBS and surface drawdown:** fill in the forms. EHBS comes in three types across the fleet (single, sequenced
   and DMAS). You get your rig's one automatically. You do not choose it.

[SHOT 13]

7. Press **↓ Browser Save**.

**Two different one-line messages.** Instead of a form you may see one line. They mean different things:

| The line says | What it means | What you do |
|---|---|---|
| *No … sheet on file for [rig]* or *No … held for [rig]. Tell the office and it will be added.* | Nobody has loaded that form for this rig yet | Tell the office |
| *… no acoustic system* (or another "not fitted" message) | Your rig genuinely does not have one | Nothing to record |

> **Watch out**
>
> - **EDS: you must pick a sequence.** Pick nothing and the steps table never appears, which looks like a broken
>   form. It is not.
> - **If a step does not match your stack, ring the office.** One rig was found stamped Rev H while carrying Rev G
>   content, and it was rebuilt from the NOV document.
> - **West Vela, West Neptune and Sevan Louisiana have no acoustic system.** The form saying so is correct.
> - **On SSCE Equipment, four forms hold nothing** (ROV, acoustic, EDS and EHBS). Each shows one line instead of a
>   form. Only the BOP Function Test, the Soak Test and the Surface Drawdown Test work on SSCE Equipment. If you only
>   need to *look* at a rig's form, switch Rig / Asset to that rig, then **switch back before you post.** Never post
>   non-rig work on a rig's name.

---

## How to post a WCGRRT report and read the receipt

**When you need this:** when the report is finished and checked.

1. Check **Rig / Asset** is right.
2. Check **Report Date** is the day the work was done.
3. Check every photograph has a caption.
4. Press **📤 Post Report**.
5. Read the confirm. It asks you to confirm that this is a finished report. Press **OK**.
6. If the back-dated question appears, read it (see *How to set the Report Date*).
7. Read the **receipt**. It appears as a message and stays as a box under the button:

   > *✓ Posted — [n] entries · [n] photographs · [n] attachments · [n.n] MB*
   > *Posted seadrill-report_[Rig]_[date]_daily-report.json*

[SHOT 15]

8. **Compare the counts with what you meant to send.** Entries, photographs, size.
9. After about ten minutes, open the dashboard, filter to your rig and find the report.

[SHOT 16]

**If the counts are wrong** (for example the receipt says 3 photographs and you took 11):

1. Do not simply post again.
2. Go back through the entries and find the missing photographs. Most often they were never added to an entry, or
   were on an entry you removed.
3. Add them, check the captions, and post again.
4. The new post has the same rig, date and type, so it **replaces** the first one. A corrected re-post is safe.

> **Watch out**
>
> - **The receipt is your proof.** It tells you *what* went, not just that something went. A lower photograph count
>   than you expected is a problem you have found before the office has.
> - **The receipt is a line, not a pop-up,** on purpose. Read it every time.
> - **Ten minutes is the dashboard scan.** If the report is not on the dashboard after ten minutes, it did not land,
>   whatever the tool said. See *Known errors and what to do*.
> - **A posted report is permanent** and visible to everyone with dashboard access. On the rig it is the evidence
>   that a BOP was fit to run.

---

## How to post when there is no connection: the outbox

**When you need this:** whenever you press Post (in either tool) and the rig's connection is down, slow or gone.

**Both tools now behave the same way.** If the post cannot reach the dashboard, your report is kept on the laptop
and sends itself when the connection is back. You do not post it again.

**What you see:**

1. You press **📤 Post Report** (or **✉ Post to OEM + Dashboard** in SSORT) with no connection.
2. The tool says:

   > *⚠ NOT posted to the dashboard (no connection?). It is waiting to send and will go by itself when the connection
   > is back. A copy is in your TSC REPORTS folder.*

3. An orange **📤 1 waiting to send** button appears at the bottom right. The number is how many reports are waiting.

[SHOT 28a]

4. If the laptop has no TSC REPORTS folder set, a **Save As** box opens first. Save the file. The report is **also**
   waiting to send.

**To see what is waiting:**

1. Click the orange **📤 n waiting to send** button.
2. The list shows each waiting report by file name, with three buttons:
   - **💾 Save file** — saves a copy of that report as a `.json`;
   - **✕ Remove** — takes it out of the waiting list (it will not be sent);
   - **Send now** — tries to send it straight away.

[SHOT 28b]

**When the connection comes back:**

1. Do nothing. The report sends itself when you next open the tool, or within two minutes while the tool is open.
2. Or, to send it at once, click the orange button and press **Send now**.
3. The tool says *✓ Sent 1 waiting report to the dashboard.* and the orange button disappears.

[SHOT 29]

4. Ten minutes later, check the dashboard. That is still the proof.

**Before you leave the laptop** (end of hitch, handover, or before anyone clears the browser):

1. Open both tools and wait three seconds.
2. If an orange **📤 n waiting to send** button shows, connect to the network and press **Send now**.
3. If it cannot send, press **💾 Save file** for each report and email the files to the office.
4. Only leave when neither tool shows the orange button.

> **Watch out**
>
> - **Do not post it again.** The waiting report is already queued. Posting again only adds a second copy.
> - **A waiting report lives in this browser, on this laptop.** Do not clear browsing data, and do not post from an
>   InPrivate window, while something is waiting. Nothing syncs between laptops.
> - **If the message says the report could not be kept on this device,** it will not send itself. Send the saved
>   file to the office yourself.
> - **A server error looks different from no connection:** *⚠ Dashboard post failed (HTTP 500) — file still saved
>   locally.* That report waits to send in the same way.
> - **Only a post that failed is kept.** A post that reached the server is never sent twice.
> - **Press Remove only if you are sure** the report must not go (for example it was posted on the wrong rig).

---

## How SSORT differs: the workspace, ⊘ New Trip, Log Date and one report per workspace

**When you need this:** before your first SSORT report, and every time you start a new one.

**SSORT is a different tool with a different job.** Its sections are CBM Inspection, Surface BOP Testing, Calculators,
Pre-Deployment Checklist, Conditional Assessment and R53 Report. There is a **📨 Requests** tab along the top for the
Technical Assistance Request and the BOP Precharge Request.

**Two names to learn:**

| WCGRRT | SSORT |
|---|---|
| Visit Information | **Vessel Information** |
| Rig / Asset | **Rig / Vessel** |
| Report Date (names a daily report) | **Log Date** (names every SSORT report) |

1. Open SSORT and check the badge says **REV 169**.
2. Press **⊘ New Trip** to clear the workspace.
3. In **Vessel Information**, set **Rig / Vessel** to your rig (or **SSCE Equipment** for non-rig work).
4. Set **Log Date** to the day the work was done. It names the file, just as Report Date does in WCGRRT.
5. Look at **Maintenance plan (DL-1)**, beside Log Date. This links your reports to the rig's maintenance plan in
   Argo Navis:
   - one open plan for your rig: it is picked for you;
   - a two-stack rig: pick the right stack;
   - no plan: it says so, and posts go out as normal. Leave it alone.

[SHOT 17a]

6. Add **one** report section (CBM, surface test, checklist and so on) and fill it in.
7. Post it (see *How to post an SSORT report*).
8. Press **⊘ New Trip** before you start the next, different report.

**Why one report type per workspace.** SSORT names the posted file after the **first** report type it finds in the
workspace. Build a CBM inspection and a pre-deployment checklist together and both go up as **one** file named
`…_cbm-inspection.json`. The checklist never gets its own row on the dashboard. SSORT now asks you first:

> *This workspace holds CBM Inspection and Pre-Deployment Checklist. It posts as ONE report…*

9. If you see that question, press **Cancel**. Post one report, press **⊘ New Trip**, then build the next.

**Recording a surface BOP test in SSORT.**

1. **⊘ New Trip**, then set **Rig / Vessel** and **Log Date**.
2. Add **🧪 Surface BOP Testing**.
3. Choose the test (for example **BOP Function Test**) and complete the test record.
4. Add a photograph and caption it.
5. Press **📤 Post Report**.

The test type is part of the file name, so two different tests on the same day do not overwrite each other:

```
seadrill-report_<Rig>_<Log Date>_surface-bop-testing_BOP-Function-Test.json
```

> **Watch out**
>
> - **One report, post, ⊘ New Trip, next.** It is the one habit that matters most in SSORT.
> - **Log Date, not today's date,** names the file. A same-name post on the dashboard replaces the earlier one.
> - **An empty workspace will not post.** Press **📤 Post Report** with no report sections and SSORT says *Nothing
>   to post*. That is correct: add the section first.
> - **SSCE Equipment has no maintenance plan.** The plan box says *No open plan for SSCE Equipment. Posts go out as
>   normal.* That is expected.

---

## How to complete a CBM inspection in SSORT

**When you need this:** when you inspect a component under condition-based monitoring (CBM), for NOV's review and
the fleet's grade history.

**What you are filling in.** There are twenty-three equipment classes. Each is built from NOV's own CBM schedule for
that component. What you see is what NOV asks for, not a Seadrill invention.

1. **⊘ New Trip**, then set **Rig / Vessel** and **Log Date**.
2. Add **🩺 CBM Inspection**.
3. Choose the equipment class from the equipment dropdown (for example **Riser Adapter**).

[SHOT 18]

4. Open **Recipient Details**.
5. Look at **Model** and **Serial Number**. Both are marked **\* REQUIRED BY NOV**.

[SHOT 18a]

6. Read the model and serial **off the unit itself** and type them in. Do this for every unit, every time.

[SHOT 18b]

7. On **C&K Stabs** only, fill in the **Stab Identification** table under Recipient Details: part number, serial and
   Seadrill Maximo asset number for each of the four stabs.
8. Open section **1.1 General Inspections**.
9. For each task, press a grade button: **1**, **2**, **3**, **4**, **5** or **N/A**.

[SHOT 19]

10. If you are unsure which grade, press **ⓘ scale**. The **GRADE LEVEL EVALUATION GUIDE** opens.

[SHOT 20]

11. Write a **note** on each graded task: what you saw, where, and how much.
12. Add photographs of the equipment **to the task**, and caption them.
13. Scroll to section **1.2 Testing**. Here the grade row shows **1**, **5** and **N/A** only, with a yellow line:
    *NOV publishes only grades 1 and 5 for this item.* Grade 1 = passed, grade 5 = failed.
14. Work through every section the same way.
15. Complete the sign-off block.
16. Press **↓ Browser Save**.

**The grade scale (inspection tasks):**

| Grade | Means |
|---|---|
| **1** | As new |
| **2** | Slight wear, no further action |
| **3** | Requires monitoring: you have found something. Shows **amber** on the dashboard: acceptable with findings, monitor |
| **4** | Immediate repair |
| **5** | Not fit for continued use |

**On tests** (Testing and Intrusive tasks, in every class) there is no middle grade: **1 = pass, 5 = fail.** A test
is an outcome, not a condition. One CBM report can carry both kinds of grade. The note under each task tells you
which you are looking at.

**Several units of the same class** (for example three gate valves):

1. Fill in the first unit, including its model and serial.
2. Press **Save details & copy to all equipment**. This copies the shared visit details (company, PO, job, rig,
   configuration and witnesses) to the other units.
3. On each other unit, type **its own** model and serial, read off that unit.
4. **Duplicate** also starts the copy with the model and serial blank.

The serial names the file, so two units inspected on the same day do not overwrite each other:

```
seadrill-report_<Rig>_<Log Date>_cbm-inspection_Riser-Adapter-SN<serial>.json
```

With no serial, the model is used instead.

> **Watch out**
>
> - **Grade what you found, not what happens next.** Moderate corrosion going back in service is a **3**, not a 2.
>   Putting 2 because "it is going back in anyway" hides a trend, and the trend across the fleet is the whole point.
>   Grade 3 is not a failure and it does not stop the job.
> - **Never leave model and serial blank.** NOV cannot review a CBM without knowing which unit it is. If you do,
>   **✉ Post to OEM + Dashboard** asks: *NOV need this unit's model and serial number to review the CBM, and they are
>   blank. Cancel goes back so you can enter them in Recipient Details. OK sends it anyway.* Press **Cancel** and
>   fill them in. **OK** is only for a plate nobody can read.
> - **A serial already filled in on a new section did not come from the tool.** Copy-to-all and Duplicate never copy
>   it. Before 9 October they did, and one posted report carried another valve's serial. Check it against the plate.
> - **If you find a class with no grades or no photograph boxes, tell the office.** Riser Adapter had none until a
>   rig reported it, and that is how it was fixed.

---

## How to attach test records to a CBM in SSORT

**When you need this:** when you have a document that evidences a CBM task: a pressure-test chart, an NDE report, a
certificate, a torque record. NOV's schedule asks you to "record time held and attach test graph".

1. In the CBM inspection, open **Test Records & Attachments**. It belongs to the equipment, not to one task.

[SHOT 21]

2. Press **+ Attach test record** and pick the file (for example the chart PDF).
3. In the **note** beside the file, type the task it evidences, starting with the task number. For example:
   `1.2.1 mud seal test to rated pressure`.
4. Attach any other records the same way, each with its own note.
5. Check the footer total, for example *2 attached · 410 KB*.

[SHOT 22]

**The size limits:**

| What | What the tool does |
|---|---|
| One file over **8 MB** | Warns you |
| One file over **20 MB** | Refuses it |
| All attachments together over **15 MB** | Warns you |
| Anything executable | Refuses it |
| The OEM copy (report plus attachments) over **30 MB** | **✉ Post to OEM** refuses (the dashboard post allows 40 MB) |

> **Watch out**
>
> - **Photographs of the equipment go on the task, not here.** This box is for documents.
> - **The note is the only link between the file and the task.** It is printed under the file on the dashboard.
>   Always start it with the task number.
> - **A PDF cannot be squeezed the way a photograph can.** It carries its full size into every copy of the report.
>   If it is a scan, a photograph of the document is far lighter and just as readable.
> - **If a file is refused, do not hunt for a way round it.** Re-export it smaller, or attach only the pages that
>   matter. A report too big to post is worse than one with three pages of chart instead of forty.
> - **If Post to OEM refuses for size,** post to the dashboard as normal, then send the OEM copy split by equipment.

---

## How to fill in NOV's usage data table in SSORT

**When you need this:** when you write up a CBM on a unit that has just come out of service, on one of the five
classes that carry NOV's table.

**The five classes:** Upper SBOP, Lower SBOP, Gate Valves, Poslock Door and U2B Door. No other class has the table.

1. In the CBM inspection, choose the equipment class (for example **Gate Valves**).
2. Scroll past **5 · Product Bulletins** to **Usage Data at Date of Removal from Service**. This is NOV's own table,
   section 8.1 of their CBM document.
3. Fill in each column:
   - **Part No.** and **Serial No.** — off the unit;
   - **Date in Service** and **Date out of Service** — the service period;
   - **Wet Cycle Count** — from the rig's own count;
   - **Pressure Cycles** — from the rig's records.

[SHOT 18c]

4. Press **↓ Browser Save**.
5. To check it, generate the CBM PDF. The table prints there, with dates shown as **DD/MMM/YYYY** (for example
   19/OCT/2026), and the table headings are readable.

[SHOT 32]

> **Watch out**
>
> - **The table belongs to one unit.** Duplicate starts the copy with it blank, like the model and serial. Fill it in
>   for each unit.
> - **The numbers come from the rig's records,** not from memory. NOV use them to judge the unit's life.
> - **Dates print as DD/MMM/YYYY** on the PDF and in NOV's copy (19/OCT/2026, not 10/19/2026). That is expected.
> - **It goes to NOV.** The table prints in the CBM PDF and in the copy NOV receive.

---

## How to complete the pre-deployment checklist in SSORT

**When you need this:** before a BOP is deployed. The checklist is the evidence that the stack was fit to run, and it
is the first thing anyone asks for afterwards.

1. **⊘ New Trip**, then set **Rig / Vessel** and **Log Date**.
2. Add **🚀 Pre-Deployment Checklist**.
3. **Set the checklist's own BOP designation** (Single or Dual) **and its cavity count first.** Until you do, the
   photograph boxes are not there. A red dashed box tells you so:

   > *Ram packer attestation and cavity, door and packer photographs — set this BOP's cavity count above to load the
   > boxes. They are required before this checklist can be posted.*

[SHOT 23d]

4. Once the count is set, the boxes load. A 7-cavity stack asks for **42 named photographs**: 14 in each of three
   sections, every box labelled for its position (UBSR — FWD, UBSR — AFT, and so on).
5. Answer the **twenty questions**.
6. Complete the **packer attestation**.
7. Add a photograph to **every** cavity, door and packer box, in the position its label names.

[SHOT 23]

8. Scroll to **FRM-00-0168 Rev 9 Additions**, below Electrical Scope.
9. **ROV panel:** tick the valve orientation and line-up line. Photograph **every** ROV panel valve so its
   orientation and line-up can be seen. Caption each with the panel and the valve, for example
   *ROV panel A, 5 Upper Shear Ram Close, open*.

[SHOT 23b]

10. **Riser:** tick the running and pulling riser checklist, the drops inspection and the seals.
11. **Riser maintenance by:** tick all that apply: **3rd party**, **CBM** or **Seadrill**. If you tick 3rd party, type
    the company's name.

[SHOT 23c]

12. Complete the sign-off names.
13. Press **Generate Checklist PDF** if you need a printed copy.
14. Press **📤 Post Report**. The tool will stop you if a mandatory box is empty. Fill it and post again.

**Linking the checklist to the maintenance plan.** Beside **Generate Checklist PDF** is **🔗 Link to plan**. It is on
every Surface BOP Testing tile too.

[SHOT 23a]

15. On a rig with an Argo Navis plan, press **🔗 Link to plan** instead of **📤 Post Report**. It posts the checklist
    exactly as Post Report does, **then** records it as evidence against the right task in the plan.
16. If the report did not reach the server, it says *NOT linked*, and nothing changes. Try again when connected.

> **Watch out**
>
> - **No photograph boxes? Set the cavity count.** It is the checklist's own designation and count, not the one in
>   another section. The red box tells you.
> - **The cavity photographs and the packer attestation are mandatory.** That is not bureaucracy: it is the evidence
>   that the stack was fit to run.
> - **Tick 3rd party and you must name the company,** or the checklist will not post.
> - **Sign-off is a typed name, not a signature.** Treat the names as a record, and confirm with the people named.
> - **🔗 Link to plan needs a plan.** With no plan picked it says *Pick the maintenance plan first: Vessel Information →
>   'Maintenance plan (DL-1)'.* With no plan for the rig (SSCE Equipment, for example), use **📤 Post Report**.
> - **Link to plan also keeps to one report type per workspace.** It refuses if the workspace would post as a
>   different type, so a test tile in a CBM workspace cannot be linked.

---

## How to post an SSORT report, and how to send a CBM to NOV

**When you need this:** when an SSORT report is finished. Use **📤 Post Report** for the dashboard only. Use
**✉ Post to OEM + Dashboard** for a CBM that NOV must review.

**Posting to the dashboard:**

1. Check **Rig / Vessel** and **Log Date**.
2. Check the workspace holds **one** report type.
3. Press **📤 Post Report**.
4. Read the message:
   - *✓ Posted to the dashboard. It shows there within ten minutes.* — it went.
   - *⚠ NOT posted to the dashboard (no connection?). It is waiting to send…* — it has **not** gone yet. See *How to
     post when there is no connection*.
5. Read the line that stays under **📤 Post Report**. It keeps the time, the file name and the size:

   > *✓ Posted to the dashboard 13:09 · [file] · [size]*

[SHOT 30]

   With no connection, the line reads *⚠ NOT posted … waiting to send*, and the orange **📤** button appears, exactly
   as in WCGRRT.

[SHOT 31]

6. After ten minutes, check the dashboard.

**Sending a CBM to NOV:**

1. Check the model and serial are filled in for every unit.
2. Check each attached test record has its task number in the note.
3. Press **✉ Post to OEM + Dashboard**.
4. **Read the confirm before you press OK.** It tells you what is about to happen, including what happens to your
   attachments.

[SHOT 24]

5. Press **OK** **once**.
6. Two things happen, in this order:
   - **first, the dashboard post**: the whole report, every section, under the normal file name;
   - **then the OEM copy**: emailed to NOV's distribution list, copied to the office.
7. The tool says *Posted to the dashboard, and sent for OEM delivery.*
8. The button text changes to **✓ Posted & sent for OEM delivery**.

**What NOV receives:** the CBM report, including the usage data table where the class has one. Your attached test
records go **both ways**: onto the dashboard, and as real attachments on NOV's email.

> **Watch out**
>
> - **Press Post to OEM once.** Every press sends NOV another email. If nothing seems to happen, look at the button
>   text, not the button.
> - **NOV cannot see our dashboard.** They review CBMs from the email. The office reviews from the dashboard row.
> - **If the confirm ever says attachments are only *listed* for NOV,** the email side is switched off. Tell whoever
>   asks, and tell the office.
> - **Never use Post to OEM to practise.** It goes to NOV. Practise with **📤 Post Report** on SSCE Equipment.
> - **The OEM copy has a 30 MB limit** that counts attachments. See *How to attach test records to a CBM*.
> - **A posted message is not the last word.** The dashboard ten minutes later is still where you confirm it landed.

---

## How to raise a Technical Assistance Request in SSORT

**When you need this:** the rig is down, or BOP equipment has failed, and you want Technical Services involved. Raise
it as early as you like: thirty minutes in is the point of it.

**What it is.** It is form FRM-00-0169 inside the tool. It is **not** the Synergi case and it is **not** a report.
You do not need a trip started or a report open.

**Who it reaches.** Within a minute it emails the Technical Services office, the subsea superintendents, BOP Controls,
and your rig's SSS, TSL, Rig Manager and ARM, and opens a Teams chat with them.

1. Go to the **📨 Requests** tab.
2. Set the rig.
3. In **Request Type**, choose **Technical Assistance Request** (it is in the same list as the BOP Precharge
   Request).
4. Choose the mode:
   - **RIG DOWN (DT)**; or
   - **BOP EQUIPMENT FAILURE (non-DT)**.
5. Fill in the required fields:
   - **Subject** — one line; it becomes the email subject and the Teams chat name;
   - **Date and time of occurrence**;
   - **Description**;
   - **Raised by**.

[SHOT 25]

6. Read **What the directive asks (DIR-00-0116)**. It is worked out from the occurrence time you gave:
   - the **Synergi Downtime case** by 07:00 the next day;
   - the **OEM ticket**;
   - **ATT-00-0028-ENG** once over two hours;
   - from six hours rig down, a red **MANDATORY NOTIFICATION**, with the **Flash Alert** due twelve hours from the
     event.

[SHOT 26]

7. **Equipment affected:** pick the **SFI code** for your rig. The tool fills in the manufacturer and model and shows
   the Maximo asset number.

[SHOT 27]

8. Press **Send**.
9. Read the answer:
   - *Received by the server* — it went. The emails follow within ten minutes, confirmed on the TSC Help Centre.
   - *NOT received — nobody has been emailed* — it did not go. The request is saved as a file. Email that file to
     technicalservices@seadrill.com **and** phone the office.

**To practise.** Tick **Practice send**. The button reads *Practice send (office only)*. It goes to the Technical
Services office only, marked TEST. A request on SSCE Equipment does the same.

> **Watch out**
>
> - **The directive list is a reminder, not the action.** The tool does not raise the Synergi case, the OEM ticket or
>   the Flash Alert for you. You still do them, on time.
> - **The request is never put in the outbox.** If it was not received, it will not send itself later. Email the
>   saved file and phone.
> - **It never says "sent" when it was not.** Believe *NOT received*.
> - **SSCE Equipment has no SFI list,** so the picker says so. On your rig you see your own codes.
> - **Do not use the real send to test.** Use Practice send.

---

## Known errors and what to do

**When you need this:** when something in either tool looks wrong. These are the known issues you can meet on the
rig, in plain words, with what to do. Quote the KE number when you ring the office.

| KE | What you see | What to do |
|---|---|---|
| **KE-06** | On **SSCE Equipment**, the ROV, acoustic, EDS and EHBS forms in WCGRRT show one line instead of a form | Normal: those forms only exist for real rigs. On SSCE Equipment use the BOP Function, Soak or Surface Drawdown test. To look at a rig's form, switch to that rig, then switch back before posting |
| **KE-08** | SSORT opens, but the badge shows **REV 116**, or the screens look old | You opened the old copy at `sacred\index.html`. Close it. Open SSORT from the `…/SSORT/index.html` link. Check the badge says REV 169 |
| **KE-13** | Either tool shows an older revision than the one you were told about | The browser is showing a cached copy. Press **Ctrl+F5**. If that fails, close the browser and reopen from the link |
| **KE-17** | Pre-deployment sign-off is a typed name, not a signature | Accepted as it is. Treat the names as a record and confirm with the people named |
| **KE-09** | **✉ Post to OEM** refuses a CBM as too big, though the dashboard post works | The 30 MB OEM limit counts attachments. Post to the dashboard as normal (40 MB limit), and send the OEM copy split by equipment |

**Two things that are not errors:**

- **A Save As box opens when a WCGRRT post fails.** The laptop has no TSC REPORTS folder set. Save the file. The
  report is **also** waiting to send.
- **WCGRRT asks whether you really mean an old Report Date.** It is the back-dated question, and it is meant to
  stop you. Read it.

**If your report is not on the dashboard after twenty minutes,** check in this order:

1. **Is the rig right?** A report on the wrong rig is filed under that rig, not lost.
2. **Is the date right?** It is filed under the date in the file name (Report Date or Log Date), not today.
3. **What did the line under 📤 Post Report say?** *⚠ NOT posted … waiting to send* means it has not gone yet. Is
   there an orange **📤 n waiting to send** button? Connect, and press **Send now**.
4. **Has someone else posted the same rig, date and type after you,** and replaced yours?
5. **Still nothing?** Ring the office and send them the `.json` (**💾 Save to File**, or **💾 Save file** from the
   waiting list). Your work is not lost: the tools always fall back to saving it on the laptop.

> **Watch out**
>
> - **Always give the office the badge revision** and the exact wording of any message. A screenshot is better.
> - **Do not work round a refusal.** A refused file, a no-rig message or a back-dated question is the tool doing its
>   job. Fix the cause.
> - **If you find something new,** report it. Several fixes in these builds started with a rig saying "this looks
>   wrong".

---

## Quick reference card

| Task | Tool | Button or box | Where it shows up |
|---|---|---|---|
| Check you are on the right build | Both | The badge: **WCGRRT · REV 174**, **SSORT · REV 169**; **Ctrl+F5** if not | Top bar |
| Start fresh | Both | **⊘ New Trip** | Clears the form |
| Set the rig | WCGRRT | **Rig / Asset**, in Visit Information | Every dashboard row hangs off it |
| Set the rig | SSORT | **Rig / Vessel**, in Vessel Information | As above |
| Non-rig work | Both | **SSCE Equipment**, under *Not rig-specific* | Its own place on the dashboard; no fleet count |
| Name a daily report | WCGRRT | **Report Date**, in the Daily Report block | `…_<Report Date>_daily-report.json` |
| Name an SSORT report | SSORT | **Log Date**, in Vessel Information | `…_<Log Date>_<report type>….json` |
| Add a daily entry | WCGRRT | Section dropdown → **📋 Daily Report Entry** | The report |
| Add photographs | Both | Click the box, or drag the photograph onto it; caption it | On the entry or task |
| Keep a copy in this browser | WCGRRT | **↓ Browser Save** / **↑ Browser Load** | This browser on this laptop only |
| Keep a copy you can email | WCGRRT | **💾 Save to File** / **📂 Load from File** | A `.json` file |
| Get work back after a crash | WCGRRT | **Restore**, on the restore bar | Top of the form |
| Record a rig test | WCGRRT | Section dropdown → the test entry | The report |
| Record a surface test | SSORT | **🧪 Surface BOP Testing** | `…_surface-bop-testing_<test>.json` |
| CBM inspection | SSORT | **🩺 CBM Inspection**; model and serial in **Recipient Details** | `…_cbm-inspection_<class>-SN<serial>.json` |
| Check a grade | SSORT | **ⓘ scale** | Grade guide panel |
| Attach a test chart | SSORT | **Test Records & Attachments** → **+ Attach test record**; task number in the note | Under the equipment on the dashboard, and on NOV's email |
| NOV usage data | SSORT | **Usage Data at Date of Removal from Service** (five classes) | CBM PDF and NOV's copy |
| Pre-deployment checklist | SSORT | **🚀 Pre-Deployment Checklist**; cavity count first | `…_pre-deployment-checklist.json` |
| Link to the maintenance plan | SSORT | **🔗 Link to plan** (needs a plan) | Dashboard, and the task in Argo Navis |
| Post to the dashboard | Both | **📤 Post Report** | Receipt or line under the button; dashboard within ten minutes |
| Send a CBM to NOV | SSORT | **✉ Post to OEM + Dashboard** — press once | Dashboard first, then NOV's email |
| See what is waiting to send | Both | Orange **📤 n waiting to send** → **Send now** | Bottom right of the screen |
| Rig down, need help | SSORT | **📨 Requests** → **Technical Assistance Request** → **Send** | Emails and a Teams chat within ten minutes |
| Prove it landed | Dashboard | Filter to your rig, ten minutes after posting | The dashboard row |

**Five habits:**

1. **Check the badge** before you start.
2. **Set the rig first, then the date** that names the file.
3. **Caption every photograph.**
4. **One report, post, ⊘ New Trip, next** (SSORT).
5. **Read the line under the Post button,** and check the dashboard ten minutes later.
