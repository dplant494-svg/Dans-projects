# Day 1 workbook questions — three per module, with answers

**Frozen builds:** WCGRRT REV 174, SSORT REV 169. Answers are for the trainer's copy; the trainee
workbook carries the questions and the blank lines only.

---

## Module 1 — WCGRRT: rig visit and daily reports

**1.1 — You are filling in a daily report on 19 October for work you did on 18 October. Which date
goes in Report Date, and what happens to the file name if you leave it on today?**

> **18 October.** A daily report is named for the day it covers, and Report Date is the box that
> names the file — not the visit date. Leave it on the 19th and the report is filed as the 19th. If
> a report for the 19th already exists it is replaced, and the 18th's work is never filed at all.
> This is exactly what happened during the West Capella week.

**1.2 — The tool refuses to post and tells you no Rig / Asset is selected. You are at an OEM's
premises auditing equipment that belongs to no rig. What do you select?**

> **`SSCE Equipment`, under "Not rig-specific".** The dialog names it. It is a real bucket on the
> dashboard that never enters a fleet count, so the report is attributed and filed without pretending
> it belongs to a rig. What you must not do is pick the nearest rig to get past the dialog.

**1.3 — Name the three ways of saving in WCGRRT and say which of them another person can see.**

> **↓ Browser Save** — this browser, this machine, nobody else. **💾 Save to File** — a `.json` you
> can keep or email; only whoever you send it to. **📤 Post Report** — the dashboard, visible to
> everyone with dashboard access. **Only the third one reaches anybody else.** Browser Save is not a
> backup you can rely on — it does not follow you to another computer.

---

## Module 2 — WCGRRT: the test forms, attachments and Post

**2.1 — You open the acoustic form on West Vela and it tells you there is no system. Is the tool
broken?**

> **No.** West Vela, West Neptune and Sevan Louisiana have no acoustic system, and the form says so
> rather than presenting an empty test to fill in. The same principle applies across the rig-specific
> forms: they are built from your rig's own configuration. If a form shows something that does not
> match your stack — an EDS step that is not yours, for instance — that is worth a phone call.

**2.2 — You post a report and the receipt reads `4 entries · 3 photographs · 0 attachments · 1.1 MB`,
but you took eleven photographs. What has happened and what do you do?**

> The receipt tells you what actually went, and eight photographs did not. Most likely they were
> never attached to an entry, or were added to a tile that was later removed. **Do not re-post
> blindly** — go back, find the missing photographs, and post again. The receipt exists precisely so
> you catch this before the office does. Re-posting the same rig, date and type replaces the earlier
> file, so a corrected re-post is safe.

**2.3 — You press Post with no connection. What does the tool say, where is your report, and what do you do?**

> Both tools now say the same: **⚠ NOT posted to the dashboard (no connection?). It is waiting to send and will go by itself
> when the connection is back.** An orange **📤 1 waiting to send** button appears. The report is kept on this laptop (and a
> copy saved), and it **sends itself** when the connection returns: when the tool is next opened, or within two minutes while
> it is open. **Do not post it again.** Click the button to see what is waiting (Send now, Save file, Remove). If it says the
> report could **not** be kept on this device, send the saved file to the office. The dashboard ten minutes later is still
> the proof.

---

## Module 3 — SSORT: CBM, grades, pre-deployment, OEM

**3.1 — You find moderate corrosion on a riser adapter weld. It is going back in service. Do you
grade it 2 or 3, and what is the consequence of each?**

> **3.** Grade 2 is "slight wear, no further action"; grade 3 is "requires monitoring", which is what
> you have actually found. On the dashboard 3 shows amber — acceptable with findings, monitor — and
> it starts a grade history for that component. Putting 2 because the equipment is going back in
> anyway hides a trend, and the trend across the fleet is the whole point of condition-based
> monitoring. Grade 3 is not a failure and it does not stop the job.

**3.2 — You have a pressure-test chart as a PDF. Where does it go, and what do you type beside it?**

> **Test Records & Attachments**, on the equipment — not on the individual task, and not into a
> photograph slot. In the note beside the file type the task it evidences, for example
> `1.2.1 mud seal test to rated pressure`. That note is printed under the file on the dashboard, and
> it is the only thing connecting the chart to the task. Photographs of the equipment itself still go
> on the task.

**3.3 — You press Post to OEM + Dashboard. Name both things that happen, in order, and say what NOV
receives of your attachments.**

> **The dashboard post goes first** — the whole report, every section, under the normal file name.
> **Then the OEM copy** is emailed to NOV's distribution list, copied to the office. Your attached
> test records go **both ways**: onto the dashboard, and as real attachments on NOV's email, live
> since 30 September. The confirm tells you which before you press. Press once — every press sends
> another email.

**3.4 (optional) — You are starting the CBM on the second of three gate valves. You pressed "Save details & copy to all
equipment" on the first. Which fields do you still have to fill in, and why?**

> **Model and Serial Number**, read off this valve. Since SSORT 160 copy-to-all copies the shared visit details (company, PO,
> job, rig, configuration, witnesses) but never the unit's model or serial, because NOV need to know which unit each CBM is
> for. Before that change one unit's serial was carried onto others in the same report. The serial also names the file, so
> each valve posts as its own file.

**3.6 (optional) — You are writing up a CBM on a gate valve that has just come out of service. What does NOV's usage table
ask for, and where do the numbers come from?**

> Part No., Serial No., Date in Service, Date out of Service, **Wet Cycle Count** and **Pressure Cycles**: NOV's section 8.1,
> *Usage Data at date of removal from service*. Wet cycles come from the rig's own count, pressure cycles from the rig's
> records. The table is on Upper and Lower SBOP, Gate Valves, Poslock Door and U2B Door CBMs only. It prints in the CBM PDF
> and in NOV's copy, and Duplicate does not carry it to the next unit.

**3.5 (optional) — Your rig has been down for 40 minutes with a BOP problem and you want Technical Services involved. Where
do you go, and what tells you it actually reached them?**

> **📨 Requests → Request Type → Technical Assistance Request**, rig down mode. No report or trip needs to be open. It is not
> the Synergi case and not a report. After Send, *Received by the server* means it went and the emails follow within ten
> minutes; *NOT received — nobody has been emailed* means it did not, the request is saved as a file, and you email it to
> technicalservices@seadrill.com and phone the office. The DIR-00-0116 list on the form tells you what else is due and when.

---

## Module 4 — the exercise and the loop

**4.1 — Why must you post one report at a time and clear the workspace between them?**

> Because SSORT names the posted file after the **first** report type it finds in the workspace, in a
> fixed order. Build a CBM inspection and a pre-deployment checklist together and both go up as one
> file named `…_cbm-inspection.json`; the checklist never gets its own row on the dashboard. Since SSORT 167 the tool asks
> you before it does that; press Cancel. One report, post, **⊘ New Trip**, next.

**4.2 — Ten people in this room post a daily report on the same asset on the same day. What happens,
and what stopped it happening today?**

> They would all produce the same file name, and on the dashboard a same-name post is an update, not
> a second row — so nine people would watch their report disappear as the next one replaced it. Today
> each trainee was given **their own report date**, which is part of the file name. On a rig the same
> mechanism is a feature: a corrected re-post of the same day deliberately replaces the earlier one.

**4.3 — Your report is not on the dashboard twenty minutes after you posted it. Walk through what you
check, in order.**

> **1.** Is the rig right? A report with the wrong asset is filed under that asset, not lost.
> **2.** Is the date right? It is filed under the date in the file name, not today.
> **3.** What did the line under 📤 Post Report say? *⚠ NOT posted … waiting to send* means it has not gone yet. Is there an
> orange **📤 n waiting to send** button? Connect, and press Send now.
> **4.** Has someone else posted the same rig, date and type after you and replaced it?
> **5.** Still nothing — ring the office and send them the `.json`. Your work is not lost; the tool
> always falls back to saving it locally.
