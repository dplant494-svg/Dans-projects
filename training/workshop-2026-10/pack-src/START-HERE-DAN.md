# Start here, Dan: the workshop pack and what you need to do

**Workshop:** Monday 19 to Thursday 22 October 2026, Seadrill Houston. **You present:** Monday and Tuesday (the training review), plus the CBM lessons learned and the SACRED repository sessions on Thursday.

## What's in this zip

| File | What it is | Print? |
|---|---|---|
| `00-START-HERE-Dan.pdf` | This guide | No |
| `01-Joining-Instructions-and-Agenda.pdf` | Already sent to the delegates | 1 for you |
| `02-Trainer-Script-Day1-and-Day2.pdf` | **Your script for both days**: what to say, click and watch for, with every screen pictured; the answers to every question | **1 for you**, plus 1 for Lee |
| `03-Trainee-Workbook.pdf` | One per delegate: exercise sheets, the usage table, questions with answer lines, Day 2 exercises, the hold point decisions table, the feedback sheet | **1 per delegate + 2 spare** |
| `04-Monday-0745-Card.pdf` | One page on each desk: links, badge check, USB files, Print to PDF | **1 per delegate** |
| `05-Day-1-Deck.pptx` | Monday's slides, from the tools session (21 slides) | No: present from it |
| `06-Day-2-Deck.pptx` | Tuesday's slides: precharge, dashboards, Argo Navis with the hold point, the loop, what is coming, feedback | No: present from it |
| `07-Day-2-Hold-Point-P6-Route.pdf` | The tools session's half page on the WCGRRT route for P6 projects | 1 for you |
| `08-UAT-Sign-off-Form.pdf` | One per delegate, signed in Tuesday's feedback session (ORR item 9) | **1 per delegate** |
| `USB-stick-for-delegates/` | Three TRAINING photos and a TRAINING test chart PDF for exercise report 3 | Copy onto a USB stick |
| `Day-1-sample-reports-backup/` | The four "what good looks like" reports, in case a laptop fails | No |
| `Day-2-precharge-exercise-files/` | The three precharge training requests and the issued sheet | No |
| `screenshots-Day-1/` | Every Day 1 screen, for slides or questions | No |
| `sources-markdown/` | The editable text of the scripts and workbook | No |

## Saturday 17 October

1. **The SSCE Equipment guard in the CBM to OEM flow (10 min, first thing).** Without it, report 3's Post to OEM emails NOV ten times.
   - Open Power Automate, then **CBM to OEM**, then **Edit**, then the **TestMode** Compose card.
   - Clear the Inputs box, click **fx**, paste the expression below, then click **Add** and **Save**:
     ```
     or(equals(toLower(trim(coalesce(first(body('SettingsRow')?['value'])?['Value'],'no'))),'yes'), equals(toLower(trim(coalesce(body('Parse_JSON')?['meta']?['asset'],''))),'ssce equipment'))
     ```
   - **Prove it:** in SSORT REV 169, on SSCE Equipment, make a scratch Riser Adapter CBM and press **Post to OEM**. Only the Office four should get `[TEST MODE]`. Then delete the file and its dashboard copy from PostedReports.
   - **Check the Rig Visit Notifications flow too.** If it has a TestMode card, make the same change there. If it hasn't, tell me.
   - **If you run out of time:** report 3 is Post Report only, and you show Post to OEM once yourself. The trainer's front page says so.
2. **The Pct fix** in the Argo Navis Plan Notifications flow: Compose **Pct** =
   ```
   replace(string(coalesce(body('Parse_JSON')?['progress']?['pctComplete'], '')), '%', '')
   ```
3. **The two Argo Navis test reports** (`samples/Argo-Navis_test_reports_2026-10-17.zip`): drop pair 1 into PostedReports, check the email and the chat line, then drop pair 2. Delete all four afterwards.
4. **The USB stick:** copy the `USB-stick-for-delegates` folder onto it. Two sticks if you can.
5. **Read the trainer's script once, start to finish.** Mark anything you don't understand and ask me.
6. **Rehearse Day 1, module by module, with me playing the room.** Open WCGRRT and SSORT, check the badges (WCGRRT REV 174, SSORT REV 169), and do the exercise yourself once on SSCE Equipment with date 2026-10-11 and serial TRN-11, so you know exactly what the delegates will see.
   - Then delete your four rehearsal posts from PostedReports.
   - Then check the tool shows nothing waiting to send.

## Sunday 18 October

1. **Rehearse Day 2:**
   - **Precharge:** walk through the three training requests.
   - **Dashboards:** click through each tab you'll show.
   - **Argo Navis:** open the West Vela test plan (WVE-BOP1-20261012) from the landing page and rehearse the hold point slides.
2. **A full run of both days against the clock**, timing each module. The times are in the script.
3. **Print everything** (the Print column above). Workbooks are double-sided and stapled; the card and the UAT form are single sheets.
4. **Check Monday's room kit:**
   - the projector adapter for your laptop;
   - a spare charger;
   - the USB sticks;
   - a printed delegate list with each person's date (2026-10-01 to 2026-10-10) and serial (TRN-01 to TRN-10).

## Monday 19 October (Day 1)

- **07:15:** you're in the room. Laptop on the projector, both tools open, badges checked, the Day 1 deck open.
- **07:45:** a card on each desk. Walk the room: badge check, USB files copied, Print to PDF there.
- **08:00:** Lee opens. Be set up and past the badge check before Lee finishes.
- **08:30 to 17:00:** follow the script. Say KE-06, KE-08 and KE-13 up front: they're on the script's front page.
- **Before anyone leaves:** every laptop opens both tools and waits three seconds. If **📤 n waiting to send** shows, press **Send now**.

## Tuesday 20 October (Day 2)

- **07:45:** the Day 2 deck open; Argo Navis open on the test plan; the precharge training files to hand.
- **13:00, Argo Navis:** the delegates follow along, but **only you press Save or Post**.
- **The hold point:** fill in the decisions table on screen as the room agrees each one. It goes onto the action list.
- **16:15, feedback:** hand out the UAT forms. Collect them signed, with Lee as witness.
- **Before anyone leaves:** the "waiting to send" check again.

## Thursday 22 October

- **08:00:** CBM lessons learned and the CBM workshop (you, with the group).
- **14:00:** SACRED as the governed WCE technical repository (30 minutes).

## After the class (Friday)

1. **Check every laptop had nothing waiting to send** (done Monday and Tuesday).
2. **Delete the class's posts from PostedReports:**
   - 40 report files, dated 2026-10-01 to 2026-10-10 on SSCE Equipment;
   - every `seadrill-oem_SSCE-Equipment_…` file;
   - your rehearsal posts, if any are left.

   The dashboard clears them on the next scan.
3. **File the signed UAT forms** (ORR item 9), and send me a count of who signed each line.
4. **Send me the hold point decisions and the action list.** I'll update the requirements, Lee's handoff and the plan.

## Who to call

- **Tools, on the day:** frozen. Nothing deploys before 23 Oct unless you ask the tools session.
- **Argo Navis:** Lee is in the room.
- **Anything SACRED:** this session.
