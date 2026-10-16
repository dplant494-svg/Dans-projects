# What changed for the class: SSORT 166 → 169, WCGRRT 169 → 174

**From:** the reporting-tools session · **Date:** Friday 16 October 2026 · **For:** the trainer and SACRED (workbook and script)

**The frozen builds for Monday 19 October.** They were re-hashed on the servers today, and **nothing deploys before Friday
23 October unless Dan asks.**

| Tool | Revision | sha256 | Bytes | Deployed |
|---|---|---|---|---|
| WCGRRT | **REV 174** | `b3b7e87773d02ebfc1f9c2421dd1fdcaa570f09fcbf1d5620a01646fc59a9eaa` | 3,376,514 | 15 October |
| SSORT | **REV 169** | `94f4afed950fca4314f8e2273b71cf562552062e4235dc13597d118d63cc5c96` | 7,365,124 | 15 October |

**Badges:** `WCGRRT · REV 174 · 2026-10-15` and `SSORT · REV 169 · 2026-10-15`. The badge dates are current now.

---

## What a delegate will see that is new

| # | What | Tool / rev | In the script | Shot |
|---|---|---|---|---|
| 1 | **The outbox.** With no connection, Post says *⚠ NOT posted to the dashboard (no connection?). It is waiting to send and will go by itself when the connection is back.* An orange **📤 n waiting to send** button appears, and the report sends itself when the connection is back. Nothing to re-post | WCGRRT 170, SSORT 167 | M1/M2 steps 41–42a (new wording); M4 step 78 (new) | **28a, 28b, 29** |
| 2 | **SSORT says whether it posted** (closes KE-01). *✓ Posted to the dashboard. It shows there within ten minutes.* plus a line under 📤 Post Report: *✓ Posted to the dashboard 13:09 · file · size*. With no connection: *⚠ NOT posted … waiting to send* | SSORT 167/168 | M3 step 70 (rewritten) | **30, 31** |
| 3 | **Two report types in one workspace: SSORT asks** before posting them as one (closes KE-03) | SSORT 167 | M4 step 73; exercise rule 1 | — (a native dialog; text quoted) |
| 4 | **Cavity photograph slots: the checklist says why they are missing** (closes KE-07) | SSORT 167 | M3 step 64 | **23d** |
| 5 | **NOV's usage data table** on Upper / Lower SBOP, Gate Valves, Poslock Door and U2B Door CBMs | SSORT 169 | M3 step 49c (new) | **18c, 32** |
| 6 | **Readable table headings in every SSORT PDF** (were white on pale; KE-19) | SSORT 169 | M3 step 49c (one line) | **32** |
| 7 | **The receipt in WCGRRT** reads *✓ Posted — n entries · n photographs · n.n MB*, with a box under the button | unchanged since 168, now photographed | M2 step 38 (wording) | **15** |

**Not on Day 1, but on screen if someone wanders:**

- **Daily Notes and Lesson Learned file names** now end `_<Shift>_<Equipment>` (SSORT 168). They are on the Daily Log tab, which
  Day 1 does not teach. There's no step to change.
- **WCGRRT's Planning Report is the twice-daily Daily Summary Report** (WCGRRT 172–174): report time, BOP %, quality and
  lessons. That is Day 2 (see `11-DAY2-HOLD-POINT-DAILY-SUMMARY-REPORT.md`). Module 1 step 10 still says *"pick Planning and
  you get a planning report"*, which is true.
- **The "Dashboard Post URL" menu item is gone from SSORT** (KE-05). Nothing in the script used it.
- **Project location shows in Planning mode** (WCGRRT 172). It doesn't apply to the Well Control daily report.

---

## Every script step that moved: old → new (`02-Walkthrough-Scripts.md`)

**Header and set-up**

| Where | Old | New |
|---|---|---|
| Header | Frozen builds WCGRRT REV 169, SSORT REV 166 | **WCGRRT REV 174, SSORT REV 169**, frozen 16–23 Oct; points to this file |
| Freeze line | Build freeze 15 October | **16 to 23 October.** Nothing deploys unless Dan asks |
| Before the room arrives | Open REV 169 and REV 166 … check the badges | Open **REV 174** and **REV 169** … check the badges, **and that neither tool shows an orange 📤 n waiting to send button** |

**Module 1**

| Step | Old | New |
|---|---|---|
| M1 header | 08:30–10:00 · WCGRRT REV 169 | **WCGRRT REV 174** |
| 2 | "This is REV 169." | "This is **REV 174**." |
| 14 | Drag-and-drop "(new in REV 169 …)" | "(**since** REV 169 …)" |

**Module 2**

| Step | Old | New |
|---|---|---|
| M2 header, agenda note | REV 169 | **REV 174** |
| 38 | Receipt quoted as `4 entries · 11 photographs · 1 attachment · 3.2 MB` | The message **`✓ Posted — 4 entries · 11 photographs · 1 attachment · 3.2 MB`**, and the box under the button, *Posted seadrill-report_…_daily-report.json* with the same counts. `[SHOT 15]` |
| 41 | Failure = *⚠ Dashboard post failed (HTTP 500) — file still saved locally.* | Details below the table. `[SHOT 28a]` `[SHOT 28b]` `[SHOT 29]` |
| 42 | SAY: "your work is not lost … ring the office and send them the file … must not assume it went" | Details below the table |
| **42a (new)** | — | Details below the table |

**Step 41, new wording:**

- **What it shows: no connection, the outbox.** The live demo is airplane mode on the trainer laptop, Post, then the network back
  on.
- **The message:** *⚠ NOT posted to the dashboard (no connection?). It is waiting to send and will go by itself when the
  connection is back. A copy is in your TSC REPORTS folder.*
- **The orange 📤 1 waiting to send button.** Clicking it opens a list with Save file, Remove and Send now.
- **When the connection is back:** *✓ Sent 1 waiting report to the dashboard.*
- **With no report folder set,** a Save As box comes first.

**Step 42, new SAY:** "Your work is not lost and you do not post it again. It sends itself when the connection is back: when
you next open the tool, or within two minutes while it is open. The orange button tells you something is still waiting. If it
says it could not be kept on this device, send the saved file to the office."

**Step 42a, new TRAP:**

- **A waiting report lives in this browser on this laptop.** Don't clear browsing data, and don't post from InPrivate, while
  something waits.
- **An HTTP error rather than no connection** shows *⚠ Dashboard post failed (HTTP 500) — file still saved locally.*, and that
  report waits to send the same way.

**Module 3**

| Step | Old | New |
|---|---|---|
| M3 header | SSORT REV 166 | **SSORT REV 169** |
| 45 | Badge: REV 166 | Badge: **REV 169** |
| **49c (new, after 49b)** | — | Details below the table. `[SHOT 18c]` `[SHOT 32]` |
| 64 | TRAP: no cavity slots until designation and count are set, "which a trainee reads as no photographs wanted" | "Set it up before you demonstrate". The checklist now says why, in a red dashed box: *"… set this BOP's cavity count above to load the boxes. They are required before this checklist can be posted."* `[SHOT 23d]` |
| 70 | SAY: "In SSORT, if the dashboard post fails you do not get a warning … WCGRRT warns you; SSORT does not." | Details below the table. `[SHOT 30]` `[SHOT 31]` |

**Step 49c, NOV's usage data:**

- **Do:** switch the equipment to **Gate Valves** and open *Usage Data at Date of Removal from Service*.
- **Fill it** with the trainer's training values: `TRAINING-PN-00`, `TRN-GV-00`, 2026-01-01 → 2026-10-19, wet 1000, pressure
  100.
- **SAY:** five classes only; wet cycles from the rig's count, pressure cycles from rig records; it prints in the PDF and NOV's
  copy, DD/MMM/YYYY; Duplicate leaves it blank.
- **Then** switch back to **Riser Adapter**. The exercise's CBM doesn't carry the table.

**Step 70, new SAY:** "SSORT now tells you whether it posted, the same as WCGRRT."

- *✓ Posted to the dashboard. It shows there within ten minutes.*, and a line under 📤 Post Report.
- *⚠ NOT posted … waiting to send*, with the orange 📤 button.
- Post to OEM says *Posted to the dashboard, and sent for OEM delivery.*
- "The dashboard ten minutes later is still where you confirm it."

**Module 4**

| Step | Old | New |
|---|---|---|
| 73 | "… the checklist never appears as its own row. Nothing warns you. One at a time." | "… SSORT now asks you before it does that: *This workspace holds CBM Inspection and Pre-Deployment Checklist. It posts as ONE report…* Press Cancel and post them one at a time." |
| Watch list | "Check the receipt in WCGRRT. In SSORT check the toast wording — 'posted to the shared folder' means it did not reach the dashboard." | "Read the line under 📤 Post Report in either tool: *✓ Posted…* or *⚠ NOT posted … waiting to send*. Look for the orange 📤 button." |
| **78 (new, last)** | — | Details below the table |

**Step 78, before anyone leaves:**

- **On every laptop,** open both tools and wait three seconds.
- **If a 📤 n waiting to send button shows,** press **Send now** while on the network (or **Remove** if Dan says).
- **Nothing may be left waiting:** it would send itself after Dan's clean-up.

**Exercise sheet (`03-Exercise-Sheet.md`)**

| Where | Old | New |
|---|---|---|
| Rule 1 | "Nothing warns you." | SSORT asks first: press **Cancel** |
| Rule 2 table, reports 2–4 | "**Report Date** in Vessel Information" (SSORT) | **"Log Date"** in Vessel Information. That is SSORT's label; the old wording was wrong |
| Report 1 | — | **New line:** if it says *⚠ NOT posted … waiting to send*, don't post again; tell the trainer |
| Report 2 note | "'Report posted to the shared folder' … SSORT does not warn you when a post fails." | The *✓ Posted…* and *⚠ NOT posted … waiting to send* wording, and what each means |
| End | — | **New tick:** no orange 📤 button in either tool before you leave |

**Questions (`04-Questions-and-Answers.md`)**

- **2.3** is rewritten for the outbox.
- **3.6 (optional, new):** the usage table.
- **4.1** and **4.3** now give the new wording.

---

## Screenshots: `screenshots-169/`, 1600 px, light mode, asset SSCE Equipment

**Nothing was posted.** The test browser answered every post itself, and where a post had to fail, the connection was cut
inside the test browser.

| Old shot | New file | |
|---|---|---|
| 1 (`screenshots-163/01-…`) | `01-wcgrrt-rev-badge.png` | **Replaces**: WCGRRT · REV 174 |
| 15 (could not be taken) | `15-post-receipt.png` | **Now taken**: *✓ Posted — 3 entries · 2 photographs · 0.0 MB* and the box under the button |
| 17 (`screenshots-163/17-…`) | `17-ssort-rev-badge.png` | **Replaces**: SSORT · REV 169 |
| — | `18c-cbm-usage-table.png` | **New**: the usage table on Gate Valves, trainer values |
| 23 (dashboard's own) | `23d-pdc-cavity-placeholder.png` | **New, beside 23**: the red box before the cavity count is set. Shot 23 itself is still right once the count is set |
| — | `28a-outbox-not-posted-toast.png` | **New**: no connection: the message and the orange button |
| — | `28b-outbox-waiting-list.png` | **New**: the waiting list |
| — | `29-outbox-sent.png` | **New**: *✓ Sent 1 waiting report to the dashboard.* |
| — | `30-ssort-posted-receipt.png` | **New**: SSORT's line under Post Report |
| — | `31-ssort-not-posted.png` | **New**: SSORT with no connection |
| — | `32-cbm-pdf-usage-and-headings.png` | **New**: the usage table in the CBM PDF, readable headings |

**Every other shot is unchanged on 169 / 174** (2–14, 16, 18–23c, 24–27). The screens they show haven't changed.

## Samples: rebuilt on SSORT 169 / WCGRRT 174

**How:** the same four, each loaded through 📂 Load from File and rebuilt by `buildReportPayload`.

**The result:** a deep comparison shows nothing changed but `meta.rev` and the export time. The names are unchanged.

## The deck: still 21 slides

| Slide | Change |
|---|---|
| **3** | WCGRRT REV 174, SSORT REV 169, and what each added |
| **16** | *New this month, on WCGRRT 174 and SSORT 169*: the outbox, SSORT saying whether it posted (and asking about two report types), NOV's usage data |
| **19** | The two "post failed" rows become **No connection when you post → WAITS** for both tools. **One row added:** *Two report types in one workspace, SSORT, ASKS* |
| **20** | Was *When Post fails*; now *No connection when you post*: what you see (both tools), what it means, what you do |

**All four slides were rendered through PowerPoint and checked;** the 17-row table fits.
