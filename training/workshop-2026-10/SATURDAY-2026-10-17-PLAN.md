# Saturday 17 October: the plan

**For:** Dan · **Workshop:** Monday 19 to Thursday 22 October, Houston.

## Do we have everything to finish the workshop? Yes, apart from one flow change (step 1)

The tools session answered W1 to W10 on time. Their reply is `10-REPLY-WORKSHOP-PACK-2026-10-16.md` in `tools/received/training/day1-2026-10-16/`.

**What they settled:**

- **Frozen builds:** WCGRRT 174 and SSORT 169, hashes recorded. Nothing deploys before Friday 23 Oct.
- **The pack is updated:** Day 1 script, exercise sheet, Q&A, 21-slide deck, the 4 samples, the new screenshots, the KE list to say to the room, and what the laptops need. The Day 2 hold point half page is in too.
- **Screenshots:** we hold the full set:
  - base shots: `tools/received/training/day1/screenshots/`, 24 files;
  - the SSORT 163 / WCGRRT 169 shots: `screenshots-163/`;
  - the SSORT 169 / WCGRRT 174 shots: `screenshots-169/`.
- **Argo Navis REV 16:** live and proven end to end on Friday, with Lee's REV 16 screenshots.

**The one gap is W10.1: Post to OEM on SSCE Equipment.** Our CBM to OEM flow only goes to test mode on the Settings switch. It has **no SSCE Equipment check**: on 22 Sep an SSCE Equipment post went to the NOV addresses. So ten delegates pressing Post to OEM in report 3 would send NOV ten emails. The joining instructions promise "notifications for it go to the office only", so this needs fixing. Step 1 fixes it.

## The steps, in order

### 1. The SSCE Equipment guard in the CBM to OEM flow (10 minutes, morning)

1. Open Power Automate, then **CBM to OEM** (the flow that emails NOV), then **Edit**.
2. Find the **Compose** card named **TestMode**. It sits just after SettingsRow, near the top.
3. Click in its **Inputs** box and delete what's there. Then click **fx**, paste this, and click **Add**:
   ```
   or(equals(toLower(trim(coalesce(first(body('SettingsRow')?['value'])?['Value'],'no'))),'yes'), equals(toLower(trim(coalesce(body('Parse_JSON')?['meta']?['asset'],''))),'ssce equipment'))
   ```
4. **Save.** Open **Code view** on TestMode: it must start with `@`.
5. **Prove it:**
   - In SSORT (REV 169), on **SSCE Equipment**, make a scratch **Riser Adapter** CBM with one photo, and press **✉ Post to OEM**.
   - Within a minute the Office four get `[TEST MODE] [Seadrill CBM Report for OEM review] …`. The red line says who it *would* have gone to. **NOV gets nothing.**
   - Then delete the `seadrill-oem_SSCE-Equipment_…` file and its dashboard copy from PostedReports.
6. **Also check the Rig Visit Notifications flow.** If it has a **TestMode** card, make the same change there. If it has none, tell me and I'll give you the cards: the class posts ten daily reports on SSCE Equipment on Monday.
7. **If there's no time, the fallback is the tools session's (c):** report 3 uses 📤 Post Report only, and the trainer shows Post to OEM once. Tell me and I'll change the sheet and step 66.

### 2. The two Argo Navis test reports (5 minutes, any time)

- **What:** `samples/Argo-Navis_test_reports_2026-10-17.zip`. Drop 1 (both files) into PostedReports; about 35 minutes later, drop 2.
- **Expect:**
  - the `[TEST MODE]` email to you and Lee for 17 Oct 1900, then for 18 Oct 0700;
  - the chat line "Progress 19.84% …".
- **Before that, the Pct fix in the Plan Notifications flow:** Compose **Pct** =
  ```
  replace(string(coalesce(body('Parse_JSON')?['progress']?['pctComplete'], '')), '%', '')
  ```
- **Afterwards:** delete the four files from PostedReports.

### 3. SACRED builds the workshop pack (this session, from late morning)

| What | Contents |
|---|---|
| **Trainee workbook** (PDF) | Day 1 exercises from `03-Exercise-Sheet.md`, with each delegate's dates and serials; spaces to record what the tool said; the usage-table values; the closing "nothing waiting to send" tick; Day 2 exercises for precharge, dashboards and Argo Navis (test plan) |
| **Trainer's script** (PDF), for a first-time instructor | Day 1 from `02-Walkthrough-Scripts.md` (steps 41–42a, 49c, 64, 70, 73, 78 as changed); Day 2 written here; per module: what to say, what to click, what the room sees, the traps, the timing; the KE list to say up front (KE-06, KE-08, KE-13) |
| **Day 2 deck** | The dashboards; precharge; Argo Navis with the **daily reporting hold point** (the BWM route) and the tools session's P6 half page (the WCGRRT route) side by side; the loop; what is coming |
| **The 07:45 Monday card** (one page) | The two links, the badge check (WCGRRT REV 174, SSORT REV 169), a normal window (not InPrivate), Ctrl+F5, Print to PDF available, the photos and test chart copied from the USB stick |

### 4. Things only you can do over the weekend

- [ ] **The USB stick:** two or three `.jpg` photos and the trainer's sample test-chart PDF for report 3 (W9.5).
- [ ] **Your laptop:** open both tools, and check the badges read WCGRRT · REV 174 and SSORT · REV 169.
- [ ] **The Office list on the Settings workbook:** check it's who you want getting ten `[TEST MODE]` emails per exercise step.
- [ ] **Rehearsal, Saturday:** read the script once, then a dry run module by module, with this session as the room (plan item 60).
- [ ] **Rehearsal, Sunday:** a full run against the clock, then print the workbook.

### 5. After the class (Thursday, before anyone leaves, then Friday)

- **Every laptop:** open both tools, wait 3 seconds, and if **📤 n waiting to send** shows, press **Send now** (script step 78). Only then do the clean-up.
- **The clean-up:** delete the class's 40 report files plus each `seadrill-oem_…` copy from PostedReports. The names are in the W3 table.

## Still open, not for the workshop

- **Lee:** handoff 5 (BOP NC deferrals at the scope freeze), the CORE globe, and the sign-off order and B-16 / B-M1 (agree these at the workshop).
- **Manpreet:** his list (sent 16 Oct).
- **ISIT:** the eDocs connector. **Nick:** PLATO.
- **The scanner's move to the server:** the programme chart says the week of 19 Oct, which clashes with the workshop. Check with Adam Snyder.
- **Rolling handoff 73:** Daily Notes entries in the same shift overwrite each other in PostedReports. Fix after the class.
- **Rolling handoff 81:** fill the NOV usage table from PLATO later.
