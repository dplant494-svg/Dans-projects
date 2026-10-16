# Reply to SACRED: the workshop pack, final for Monday 19 October (W1–W10)

**From:** the tools session, via Dan. **Date:** Friday 16 October 2026, ahead of the Saturday 12:00 Houston deadline.
**Also logged as:** rolling handoff entry 86.
**The pack:** `TRAINING-Day1-Pack/` and `WCE-Training-Day1-Pack.zip`. Start with `09-WHATS-NEW-SSORT-169-WCGRRT-174.md`.

All ten asks are answered. **One needs action from you before Monday: W10.1, Post to OEM on SSCE Equipment.**

---

## W1 — The builds on screen on Monday: frozen

| Tool | Revision | sha256 | Bytes |
|---|---|---|---|
| WCGRRT | **REV 174** | `b3b7e87773d02ebfc1f9c2421dd1fdcaa570f09fcbf1d5620a01646fc59a9eaa` | 3,376,514 |
| SSORT | **REV 169** | `94f4afed950fca4314f8e2273b71cf562552062e4235dc13597d118d63cc5c96` | 7,365,124 |

- **Both re-hashed on the servers today.**
- **Your list stopped at WCGRRT 172.** 173 (the cycle in the posted planning file name) and 174 (the rig's own report time)
  also deployed on 15 October, entries 84 and 85. **174 is the one on screen.** Both changes are in Planning mode only, which
  Day 1 doesn't touch.
- **Nothing deploys to either tool before Friday 23 October unless Dan asks.** Recorded in the README, the script header and
  memory.

## W2 — The script steps that changed

**Every step, old → new, is in `09-WHATS-NEW-SSORT-169-WCGRRT-174.md`.** The script, the exercise sheet and the Q&A in the
pack are already edited to match.

**In short:**

- **Module 1/2:**
  - **Steps 41–42 are rewritten for the outbox,** with a new **42a** TRAP: a waiting report lives in that browser on that laptop.
  - **Step 38's receipt wording** is corrected.
- **Module 3:**
  - **New step 49c**, NOV's usage table, after 49b.
  - **Step 64:** the checklist now *says* why the cavity slots are missing.
  - **Step 70 is rewritten:** SSORT now tells you whether it posted.
- **Module 4:**
  - **Step 73:** SSORT now asks about two report types.
  - **The watch list** gives the new wording.
  - **New step 78:** check no laptop has anything waiting to send before anyone leaves.
- **Exercise sheet:**
  - The SSORT date box is **Log Date**, not "Report Date". This was wrong in the 13 Oct pack too.
  - **Rule 1** now says SSORT asks about two report types.
  - **Report 2's note** gives the new posted / not-posted wording.
  - **A closing tick** for the waiting button.
- **Daily Notes and Lesson Learned names:** there are no Day 1 steps to change. They are on the Daily Log tab, which Day 1 doesn't
  teach.

## W3 — The exercise

**Report 3 does not need the usage table.**

- **Why not:** the exercise's CBM is **Riser Adapter**, and NOV's table is only on Upper / Lower SBOP, Gate Valves, Poslock
  Door and U2B Door.
- **Where it is taught instead:** module 3 step 49c, by the trainer on Gate Valves, with the trainer's values in row 00.
- **If Dan wants delegates to try it hands-on:** they switch a scratch CBM tile to Gate Valves in module 3, fill in their own
  row, and press **⊘ New Trip**. Nothing is posted.

**The values are obviously training numbers, never real-looking ones:**

| Delegate | Part No. | Serial No. | Date in Service | Date out of Service | Wet Cycle Count | Pressure Cycles |
|---|---|---|---|---|---|---|
| Trainer (00) | `TRAINING-PN-00` | `TRN-GV-00` | 2026-01-01 | 2026-10-19 | 1000 | 100 |
| 01 | `TRAINING-PN-01` | `TRN-GV-01` | 2026-01-01 | 2026-10-01 | 100 | 10 |
| 02 | `TRAINING-PN-02` | `TRN-GV-02` | 2026-01-02 | 2026-10-02 | 200 | 20 |
| 03 | `TRAINING-PN-03` | `TRN-GV-03` | 2026-01-03 | 2026-10-03 | 300 | 30 |
| 04 | `TRAINING-PN-04` | `TRN-GV-04` | 2026-01-04 | 2026-10-04 | 400 | 40 |
| 05 | `TRAINING-PN-05` | `TRN-GV-05` | 2026-01-05 | 2026-10-05 | 500 | 50 |
| 06 | `TRAINING-PN-06` | `TRN-GV-06` | 2026-01-06 | 2026-10-06 | 600 | 60 |
| 07 | `TRAINING-PN-07` | `TRN-GV-07` | 2026-01-07 | 2026-10-07 | 700 | 70 |
| 08 | `TRAINING-PN-08` | `TRN-GV-08` | 2026-01-08 | 2026-10-08 | 800 | 80 |
| 09 | `TRAINING-PN-09` | `TRN-GV-09` | 2026-01-09 | 2026-10-09 | 900 | 90 |
| 10 | `TRAINING-PN-10` | `TRN-GV-10` | 2026-01-10 | 2026-10-10 | 1000 | 100 |

**The allocated dates (1–10 Oct) and serials (`TRN-0n`) still work on the frozen builds.** Tested on 169 / 174 for delegates
01 and 10, with nothing sent:

```
seadrill-report_SSCE-Equipment_2026-10-01_daily-report.json                          (WCGRRT; the back-dated question appears, as the sheet says)
seadrill-report_SSCE-Equipment_2026-10-01_surface-bop-testing_BOP-Function-Test.json
seadrill-report_SSCE-Equipment_2026-10-01_cbm-inspection_Riser-Adapter-SNTRN-01.json
seadrill-report_SSCE-Equipment_2026-10-01_pre-deployment-checklist.json
… and the same with 2026-10-10 / SNTRN-10 for delegate 10.
```

**All 40 names are distinct.** The exercise sheet's file names are unchanged.

## W4 — Screenshots

**What's new:**

- **Retaken, or newly takeable:** 1, 15 and 17.
- **New:** 18c, 23d, 28a, 28b, 29, 30, 31 and 32.
- **Where:** all in `screenshots-169/`, at 1600 px, light mode, asset SSCE Equipment, nothing posted. The table `old shot →
  new file` is in `09-…`.

**Outbox:**

- **28a:** the post waiting, with the message and the orange button.
- **28b:** the waiting list.
- **29:** sent, with the button gone.
- **30 / 31** show SSORT's posted and not-posted lines.

**Usage table:**

- **18c:** the form.
- **32:** the PDF.

**Every other shot is unchanged on 169 / 174.**

## W5 — Samples

**What's there:** the four in `samples/`, rebuilt on SSORT 169 / WCGRRT 174 through Load from File and `buildReportPayload`.

**What changed:** a deep comparison shows nothing but `meta.rev` and the export time. The names and sizes are as before.

## W6 — The deck

**Still 21 slides.** Four slides change; the details are in `09-…`:

| Slide | Change |
|---|---|
| **3** | The builds and what each added |
| **16** | *New this month, on WCGRRT 174 and SSORT 169*: the outbox, SSORT's posted messages and the two-type question, NOV's usage data |
| **19** | The SSORT "SILENT" row is now **WAITS** for both tools, plus **one new row:** *Two report types in one workspace → ASKS* |
| **20** | Now *No connection when you post* |

**Rendered through PowerPoint and checked.** Nothing overflows.

## W7 — Known errors to say before the room finds them

**The open ones, one line each:**

| KE | What | Workaround | Can a delegate hit it on Monday? |
|---|---|---|---|
| KE-06 | Four WCGRRT test records (ROV, acoustic, EDS, EHBS) hold nothing for SSCE Equipment; each shows one line instead of a form | Use a real rig for those forms, then switch back to SSCE Equipment before posting | **Yes:** module 2. The script already handles it |
| KE-08 | A stale SSORT (REV 116) is still served from the `sacred` share | Open SSORT only from `…\SSORT\` (`:8080/SSORT/index.html`); check the badge says REV 169 | **Yes,** if someone opens SSORT from the wrong link. The badge check catches it |
| KE-13 | A browser can keep showing an older revision from its cache | Check the badge; Ctrl+F5, or close and reopen | **Yes,** on a laptop that had the tools open last week. 07:45 badge check |
| KE-17 | Pre-deployment sign-off is a typed name, not a signature (accepted) | Treat names as a record; confirm with the people for a real deployment | Only as a question in the exercise |
| KE-02 | Four SSORT role keys always post empty | Take the roles from WCGRRT's report | No: invisible to delegates |
| KE-09 | Post to OEM's 30 MB refusal counts attachments | Post to the dashboard as normal (40 MB); split the OEM copy by equipment | Unlikely: exercise files are small |
| KE-10 | The intake address is readable inside the tool files | None at the tool (ISIT review) | No |

**Closed since the last pack, and now behaving differently on screen:**

- **KE-01:** SSORT says whether it posted.
- **KE-03:** asks about two report types.
- **KE-05:** the Post URL menu item is gone.
- **KE-07:** the cavity-count message.
- **KE-19:** readable PDF headings.

**Two things to say that are not KEs:**

1. **A failed WCGRRT post on a laptop with no TSC REPORTS folder set first opens a Save As box.** Save it; the report is
   *also* waiting to send.
2. **The back-dated question in WCGRRT is expected in the exercise.** The script already says so.

## W8 — The Day 2 hold point

**Half a page:** `11-DAY2-HOLD-POINT-DAILY-SUMMARY-REPORT.md`, covering:

- who posts;
- the report time;
- what it prints;
- what replaces the planner's three-a-week email (your scanner and the "Daily Summary Report" flow);
- the five things to agree at the hold point: who posts per rig, the two times per rig, ERT supply per report, the planner's
  role, and form control.

## W9 — What the delegates' laptops need

**Nothing to install.** For the "please bring" list or the 07:45 slot:

1. **The browser:** Edge or Chrome, current, on the Seadrill network. On VPN if outside the office: opening the tools needs the
   intranet server. A normal window, **not InPrivate**, because the autosave and the outbox keep work in the browser.
2. **The links:**
   - `http://sdrlazneuiis01d.corp.local:8080/sacred/WCE%20Rig%20Vist%20Reporting%20Tool%20V0.html`
   - `http://sdrlazneuiis01d.corp.local:8080/SSORT/index.html`

   Open them from these, not from a saved copy, and not from `sacred\index.html` (KE-08).
3. **At 07:45, the badge check:** WCGRRT · REV 174, SSORT · REV 169. If either is wrong, Ctrl+F5 (KE-13).
4. **Downloads allowed:** Save to File and the no-connection fallback save a `.json`. Print to PDF must be available for the
   checklist and CBM PDFs ("Microsoft Print to PDF" / "Save as PDF").
5. **Files on the laptop for the exercise:** two or three photographs (any `.jpg`) and the trainer's sample test-chart PDF for
   report 3. Put them on a shared folder or a USB stick and have delegates copy them to the Desktop at 07:45.
6. **Screen:** 1366 px wide or more is comfortable. The forms are wide.
7. **The tablet install files:** not taught, as you assumed. They only work once the server is on HTTPS (ISIT).

## W10 — SSCE Equipment and notifications, and the clean-up

**1. ⚠ Post to OEM on SSCE Equipment: please confirm before Monday.**

- **What the tool does:** SSORT **does not** route a Post to OEM differently on SSCE Equipment. It posts the normal OEM copy,
  `seadrill-oem_SSCE-Equipment_<date>_Riser-Adapter_<stamp>_cbm.json`, to the same intake.
- **Who decides NOV:** **your OEM flow** decides who receives it. Only the **Technical Assistance Request** has a test route
  built into the tool: SSCE Equipment and Practice send go to the Technical Services office only, marked TEST.
- **The risk:** unless the OEM flow already treats `meta.asset = "SSCE Equipment"` as office-only, **ten delegates pressing Post
  to OEM in report 3 would send NOV ten test emails.**
- **Please confirm one of these:**
  - **(a)** the flow already routes SSCE Equipment to the office; **or**
  - **(b)** you add that condition before Monday; **or**
  - **(c)** report 3 changes to **📤 Post Report** only, and the trainer demonstrates Post to OEM once.

  If none is confirmed by Saturday, we recommend **(c)**. It is a one-line change to the sheet and step 66, and we can make
  it.
- **No tool change** is proposed during the freeze.

**2. The other flows:**

- **The Technical Assistance Request:** office only on SSCE Equipment, done in the tool.
- **The Daily Summary Report flow:** sends tests to Dan only, as you said. The class doesn't post planning reports.
- **Report posts themselves:** the tools send no email. **Please confirm no other flow keyed on posted reports** (for example a
  failure or grade alert) **emails anyone for SSCE Equipment.**

**3. Outbox re-sends:**

- **Only a post that failed is kept.** A post that reached the server is never re-sent.
- **A re-send is byte-for-byte the same file under the same name,** so it is routed exactly as the original would have been,
  just later. That includes OEM copies: they go through the same outbox.
- **The Technical Assistance Request is never queued.**

**4. Dan's clean-up still works, with one condition: nothing may be left waiting on a delegate's laptop.**

- **The risk:** a report still waiting after the class would send itself the next time that laptop opens either tool on the
  network, and put a class post back after the clean-up.
- **What prevents it:** the new script step 78 and the exercise sheet's closing tick. On every laptop, open both tools,
  wait three seconds, and if an orange **📤 n waiting to send** button shows, press **Send now** (or Remove), *before*
  anyone leaves.
- **When to clean up:** after that check. The queue is per browser on each laptop, and nothing syncs between laptops.

**The class's files for the clean-up are unchanged:**

- **Reports:** 40 files, plus one `seadrill-oem_…` per Post to OEM.
- **The names:** in W3.
- **Planning:** none on Day 1.
