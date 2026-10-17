# Start here, Dan: the workshop pack and what you need to do

**Workshop:** Monday 19 to Thursday 22 October 2026, Seadrill Houston. **You present:** Monday and Tuesday (the training review), plus two Thursday sessions: CBM lessons learned (08:00) and SACRED as the repository (14:00). On Wednesday, 09:00–12:00, you work with Adam Sewell on the web app and the SACRED handover.

**How the two training days run (your decision, 16 Oct):**

- You demonstrate every step on screen, in the agenda's order.
- The delegates follow on their laptops and **post nothing**.
- Each delegate takes away the **Training Manual**, every how-to guide in one book.

There are no exercises, no allocated dates, no scanning the room's posts and no clean-up of 40 files. The only posts are your own demonstration ones.

## What's in this zip

| File | What it is | Print? |
|---|---|---|
| `00-START-HERE-Dan.pdf` | This guide | No |
| `01-Joining-Instructions-and-Agenda.pdf` | **Updated for the demo format**; send this one to Lee | 1 for you |
| `02-Presenter-Script-Day1-and-Day2.pdf` | **Your script for both days**: what to show and say, module by module, with every screen pictured; questions the room may ask, with answers | **1 for you**, 1 for Lee |
| `03-Training-Manual.pdf` | **One per delegate**: how-to guides for WCGRRT, SSORT, precharge, the dashboards, Argo Navis and the Help Centre; the Daily Summary Report requirement; the glossary; the feedback sheet | **1 per delegate + 2 spare** |
| `04-Monday-0745-Card.pdf` | One page per desk: links, badge check, how today works | **1 per delegate** |
| `05-Day-1-Deck.pptx` | Monday's slides (tools session, 21 slides). Skip the exercise-rule slides, or say "this is how it would work on the rig". | No: present from it |
| `06-Day-2-Deck.pptx` | Tuesday's slides (30), matching the script's `[Slide n]` cues | No: present from it |
| `07-Day-2-Hold-Point-P6-Route.pdf` | The half page on the WCGRRT route for P6 projects | 1 for you |
| `09-Wednesday-Adam-Session-Brief.pdf` | Your 09:00–12:00 working session with Adam Sewell: the web app and the SACRED handover | 1 for you, 1 for Adam |
| `10-Thursday-CBM-Lessons-Learned.pptx` / `11-Thursday-SACRED-Repository.pptx` | Your two Thursday sessions | No: present from them |
| `12-Thursday-Presenter-Notes.pdf` | What to say on each Thursday slide | 1 for you |
| `08-UAT-Sign-off-Form.pdf` | One per delegate, signed in Tuesday's feedback session (ORR item 9), worded for the demo format | **1 per delegate** |
| `Trainer-demo-files/` | Three TRAINING photos and a TRAINING test chart, for **your** demo reports | Copy to your laptop's Desktop |
| `Day-1-sample-reports-what-good-looks-like/` | Four finished reports, if you want to show one | No |
| `Day-2-precharge-exercise-files/` | The three precharge training requests you work through on screen | No |
| `screenshots-Day-1/` and `sources-markdown/` | Every Day 1 screen; the editable text | No |

## Saturday 17 October

1. **The SSCE Equipment guard in the CBM to OEM flow (10 minutes).** It's recommended, not essential now. Without it, you can't demonstrate Post to OEM safely: you show the confirm box and cancel.
   1. Open Power Automate, then **CBM to OEM**, then **Edit**, then the **TestMode** Compose card.
   2. Clear the Inputs box, click **fx**, paste the expression below, then click **Add** and **Save**:
      ```
      or(equals(toLower(trim(coalesce(first(body('SettingsRow')?['value'])?['Value'],'no'))),'yes'), equals(toLower(trim(coalesce(body('Parse_JSON')?['meta']?['asset'],''))),'ssce equipment'))
      ```
   3. **Prove it:** in SSORT, on SSCE Equipment, press **Post to OEM** on a scratch Riser Adapter CBM. Only the Office four should get `[TEST MODE]`. Then delete the file from PostedReports.
2. **The Pct fix** in the Argo Navis Plan Notifications flow: Compose **Pct** =
   ```
   replace(string(coalesce(body('Parse_JSON')?['progress']?['pctComplete'], '')), '%', '')
   ```
3. **The two Argo Navis test reports** (`samples/Argo-Navis_test_reports_2026-10-17.zip`): drop pair 1 into PostedReports, check the email and chat line, then drop pair 2. Delete all four afterwards.
4. **Send Lee the updated agenda** (`01-…pdf`). It now says the sessions are demonstrated, with a Training Manual.
5. **Read the presenter's script once, start to finish.** Note anything unclear and ask me.
6. **Rehearse Day 1 with me playing the room.** Open both tools and check the badges: WCGRRT **REV 174**, SSORT **REV 169**. Do the Module 4 run-through once yourself: SSCE Equipment, date **2026-10-11**, serial **TRN-11**. Then delete those four rehearsal posts, so Monday's run-through posts are new.

## Sunday 18 October

1. **Rehearse Day 2:**
   - work the three precharge training requests;
   - click through each dashboard tab you'll show;
   - open the West Vela test plan (WVE-BOP1-20261012) in Argo Navis;
   - rehearse the hold point slides (19 to 21).
2. **A full run of both days against the clock.** The times are in the script.
3. **Print** (see the Print column above). The manual is double-sided and bound or stapled.
4. **Room kit:**
   - the projector adapter;
   - a spare charger;
   - `Trainer-demo-files` on your Desktop;
   - the Settings workbook and Power Automate in a browser tab, in case you need them.

## Monday 19 October (Day 1)

- **07:15:** laptop on the projector, both tools open, badges checked, Day 1 deck open.
- **07:45:** a card and a manual on each desk. Walk the room checking badges.
- **08:00:** Lee opens.
- **08:30–14:30:** Modules 1–3. Say KE-06, KE-08 and KE-13 up front (script front page).
- **14:45–17:00:** the run-through. Build all four reports on screen and post them (dated 2026-10-11), then show them on the dashboard.
- **Before anyone leaves:** every laptop opens both tools and waits three seconds. If **waiting to send** shows, press **Send now**.

## Tuesday 20 October (Day 2)

- **08:00:** precharge, worked through on screen.
- **10:15:** the dashboards.
- **13:00:** Argo Navis. Delegates may open the landing page, but **not the test plan**: you show it.
  - **At the hold point (slides 19–21),** fill in the decisions table as the room agrees each one.
- **14:45:** the loop. You post one Help Centre request on SSCE Equipment and show the email, chat and receipt.
- **16:15:** feedback. The UAT forms are signed, with Lee as witness.

## Wednesday 21 October

- **08:00–09:00:** in the room for Lee's standards overview.
- **09:00–12:00: your working session with Adam Sewell.** You're out of the standards workshop for this. The topics are the web app and the start of the SACRED handover. Your brief is `09-Wednesday-Adam-Session-Brief.pdf`: the agenda, what to bring, questions to settle, a decisions table, and what not to do.
- **13:00 onwards:** back in the room: Ronnie Peeples on API Std 53 and BSEE, then TOMs. Note anything that should live in SACRED, for Thursday at 14:00.

## Thursday 22 October

- **08:00–09:00: CBM lessons learned and the CBM workshop** (`10-Thursday-CBM-Lessons-Learned.pptx`).
- **14:00–14:30: SACRED as the governed WCE technical repository** (`11-Thursday-SACRED-Repository.pptx`). This comes straight after Eric Rachall's West Tellus debrief.
- **Your notes for both:** `12-Thursday-Presenter-Notes.pdf`.

## After the class

1. **Delete your demonstration posts from PostedReports:**
   - the four reports dated 2026-10-11 on SSCE Equipment;
   - any `seadrill-oem_SSCE-Equipment_…` copy;
   - the Help Centre test request, if you want it gone.
2. **File the signed UAT forms** (ORR item 9).
3. **Send me the hold point decisions and the action list.** I'll update the requirements, Lee's handoffs and the plan.
