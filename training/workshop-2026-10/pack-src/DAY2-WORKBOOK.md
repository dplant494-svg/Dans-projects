# Day 2 workbook: Tuesday 20 October 2026

**WCE SME Technical Review and Open Workshop, Houston · Training review, part 2: precharge, dashboards, Argo Navis, the
loop**

**Name:** ______________________________  **Rig:** ______________________________

## Today

| Time | Session | Presenter |
|---|---|---|
| 08:00–10:00 | Module 5 · The precharge process | Dan Plant |
| 10:00–10:15 | Break | |
| 10:15–12:00 | Module 6 · The SACRED dashboards | Dan Plant |
| 12:00–13:00 | Lunch | |
| 13:00–14:30 | Module 7 · Argo Navis: planning and executing Between Well Maintenance, with the **hold point on daily reporting** | Dan Plant, Lee Arnold |
| 14:30–14:45 | Break | |
| 14:45–15:30 | Module 8 · The loop, and the TSC Help Centre hands on | Dan Plant, Lee Arnold |
| 15:30–16:15 | Module 9 · What is coming | Dan Plant |
| 16:15–17:00 | Module 10 · Feedback | All |

## Three rules for today

1. **Precharge: nothing is posted.** We work on real, verified rigs under training well names such as
   `TRAINING-01 NOT ISSUED`. Nobody presses Post to Dashboard.
2. **Argo Navis: only the trainer presses Save, Post for review, Post daily report or Post close-out.** There is one save
   file per plan, so ten people saving would overwrite each other, and every post sends a test email. You open the test
   plan and look; you do not change it.
3. **Everything is under MOC** (Management of Change, the company process for approving changes). We do not teach MOC
   today.

## Words used today

| Word | What it means |
|---|---|
| **BWM** | Between Well Maintenance: the maintenance window on the BOP between wells. |
| **SFI** | The equipment code used in Maximo. **331** is the BOP stack, **332** the BOP control system. |
| **NC** | A Maximo Non-Conformity: the approved record that lets a work order go past its due date. |
| **Scope freeze** | The point where the reviewers have verified the plan's scope and it is locked. |
| **Break-in work** | Unplanned work found after the freeze, raised by the rig, numbered BRK-001 onwards. |
| **Daily Summary Report** | The twice-daily progress report on a BWM plan, posted by the rig and emailed automatically. |
| **Scanner** | The script that reads every posted file every ten minutes and builds the dashboard pages. |
| **Receipt** | The record a notification writes: what was sent, to whom, and when. |
| **AAB** | Alert, Advisory or Bulletin. The Bulletin Board carries Priority 3 advisories (for information). |
| **SSCE** | Subsea shared capital equipment: certified spares held centrally and allocated to rigs on request. |
| **PSIG / PSIA** | Pressure on the gauge / absolute pressure. They differ by atmospheric pressure, about 14.7 psi. |
| **FVR** | Functional volume requirement: the volume of fluid the bottles must deliver to close the rams. |

---

# Module 5: the precharge process (08:00–10:00)

The rig asks for a precharge with the **request form**, which it finds inside SSORT. The office loads that request into
the calculator, **Precharge Pro**, works it out and checks it. The office then issues the sheet. The **PDF** goes to
the rig by email, and that PDF is the **controlled document** you charge from. A calculated figure is only as good as
the request behind it. A sheet that fails its checks can never be sent to a rig. Today we work on real, verified rigs
under training well names, and **nothing is posted**.

## 5A. The request form: what I saw

| What | What the form showed or said |
|---|---|
| The seven fields that stop the file | 1 ________________ 2 ________________ 3 ________________ 4 ________________ |
| | 5 ________________ 6 ________________ 7 ________________ |
| The units the form starts in | Depth: __________  Temperature: __________ |
| Mistake 1: MAWHP 3,500, shear 5,200. The warning names which column? | ________________________________________ |
| Mistake 2: subsea 4 °F. What has probably happened? | ________________________________________ |
| Mistake 3: pump cut-in 3,000, cut-out 2,800. The warning says | ________________________________________ |
| Well hop = yes, no depths. Warning or block? | ________________________________________ |

## 5B. The calculation: what I saw (West Tellus, `TRAINING-01 NOT ISSUED`)

| What | Value on screen |
|---|---|
| Revision in the header | ______________ |
| SET PRECHARGE (the number you charge to) | ______________ PSIG at ______ °F |
| Condition 2: shear ram closing pressure, against 2,600 required | ______________ PSIG |
| With shear raised to 4,105: the OPTIMUM precharge | ______________ PSIG |
| The second cut on the contractual panel fails by | ______ psi and ______ gal |
| What happened when Post to Dashboard was pressed | ________________________________________ |
| West Neptune: what changed when BOP 1 was switched to BOP 2? | ________________________________________ |

## 5C. Exercise: work your group's case (09:00–09:20)

Your group works one case in the calculator. Record the number you would charge to, and why it passed. **Save it if
you like. Do not post.** The trainer then loads the known-good file so you can compare.

| Group | Rig | Training well | Water depth | Subsea / deck temperature | Shear | MAWHP |
|---|---|---|---|---|---|---|
| A | West Tellus | `TRAINING-01 NOT ISSUED` | 7,000 ft | 38 °F / 78 °F | 2,600 PSIG | 3,900 psi |
| B | West Neptune, BOP 1 | `TRAINING-02 NOT ISSUED` | 6,500 ft | 40 °F / 78 °F | preset (3,826) | 12,000 psi |
| C | West Gemini | `TRAINING-03 NOT ISSUED` | 5,000 ft | 42 °F / 78 °F | preset (2,050) | 10,000 psi |

**Before you start:** set both unit selectors to feet and °F, and check the header reads your rig and training well.

| | My group's result |
|---|---|
| My group | ______ |
| The number to charge to (or, for B, the subsea precharge for each accumulator) | ________________________________________ |
| | ________________________________________ |
| Did the checks pass? What is the margin? | ________________________________________ |
| Did my answer match the known-good file? If not, why? | ________________________________________ |

## 5D. The issued sheet, its PDF, and the loop

| What | What I saw |
|---|---|
| The three things to check first on an issued sheet | 1 __________________ 2 __________________ 3 __________________ |
| The page of the PDF that carries the precharge-against-temperature table | page ______ |
| The two signature lines at the foot of the PDF | ______________________ and ______________________ |
| Is the "Generated by" timestamp a signature? | ______ |
| Who the ISSUED email goes **To** | ________________________________________ |
| Who is on **Cc** | ________________________________________ |
| What is attached to the ISSUED email | ________________________________________ |
| Where I can see requests and issued sheets on the dashboard | ________________________________________ |

## Questions: Module 5

**5.1** A rig sends a request with MAWHP 3,500 psi and a minimum shear pressure of 5,200 PSIG. What does the form do,
what is the likely cause, and why does it not simply reject it?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

**5.2** The contractual panel shows one shear passing and the second shear failing by −5 psi and −0.74 gal. Can the
sheet be posted, and what may still be done with it?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

**5.3** The sheet quotes 3,725 PSIG at a deck temperature of 78 °F. On the day the deck is 60 °F. What do you charge
to, and where do you find it?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

---

# Module 6: the SACRED dashboards (10:15–12:00)

Every posted report is read by the **scanner** every ten minutes. The scanner builds the pages you look at: the **Rig
Visit Dashboard**, the **BOP Fleet Planning** page, the **SSCE Requests** dashboard and the **AAB** register. Nobody
types into these pages. If something on a page is wrong, the report behind it is wrong, and you fix the report by
posting it again. This session goes through each page and what it is for. You follow along on your own laptop, from
the SACRED bookmark. **Ask SACRED AI** is shown from the trainer's laptop only, because it does not open for you yet.

## 6A. The Rig Visit Dashboard: follow along

| What | What I saw |
|---|---|
| Time on the "last scan" stamp when I looked | ______ at ______ (my clock) |
| My four Monday reports found? (rig SSCE Equipment, 30 days) | Daily report ☐ Surface test ☐ CBM ☐ Pre-deployment ☐ |
| If one was missing: which of the five checks found it? | ________________________________________ |
| In the full-report viewer, my CBM report shows how many attached test records? | ______ |
| What the Errors button lists | ________________________________________ |
| On Rig Monitoring, the three things "needs attention" counts | 1 __________________ 2 __________________ 3 __________________ |
| The CBM Heatmap colours | Green = ______  Amber = ______  Red = ______  Grey = ______ |
| The Riser Adapter tests graded 1 and 5 mean | 1 = ______  5 = ______ |

## 6B. The BOP Fleet Planning page

| What | What I saw |
|---|---|
| The three views on the page | ______________ ______________ ______________ |
| West Vela's tile: % complete / BOP % / BOP ready date | ______ / ______ / ______ |
| Where break-in work is listed | ________________________________________ |
| What makes this page update | ________________________________________ |

## 6C. The CoC dashboard and SSCE requests

| What | What I saw |
|---|---|
| Where the CoC figures come from (the master record) | ________________________________________ |
| Today's figures: expired / no date on file | ______ / ______ |
| Where an SSCE request is raised | ________________________________________ |
| Where it is approved | ________________________________________ |
| Where tracker annotations (ticks, remarks) are kept | ________________________________________ |

## 6D. The AAB and the Seadrill Bulletin Board

| What | What I saw |
|---|---|
| Which priority the Bulletin Board carries | ______ |
| Who on the rig acknowledges, and how many times | ________________________________________ |
| What every acknowledgement must contain | ________________________________________ |
| Who closes the case | ________________________________________ |
| The state chip after crew A acknowledged | ________________________________________ |

## 6E. Ask SACRED AI (watched on the trainer's screen)

The question asked: ______________________________________________________________

Which reports it said it read: ____________________________________________________

Is its answer a record? ______  Why not? ______________________________________________

## Questions: Module 6

**6.1** The "last scan" stamp reads 07:40. It is now 08:30, and you posted at 08:05. What has happened, and what do
you do?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

**6.2** On the CBM Heatmap a Riser Adapter cell is red. The history shows a grade 5 on a task that is a pressure test.
Is the riser adapter condemned?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

**6.3** A West Vela advisory shows "acknowledged" on the fleet compliance page. Who acts next? Can the rig close its
own case?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

---

# Module 7: Argo Navis: planning and executing Between Well Maintenance (13:00–14:30)

**Argo Navis** builds the BWM schedule from the rig's open Maximo PMs, then tracks it. A plan goes through these
stages:

1. The rig **challenges the scope**: what is really being done this time, and what is deferred, with a reason.
2. The **regional reviewers** verify the scope.
3. The scope is **frozen**.
4. The rig **executes** the plan. New work found after the freeze is **break-in work**.
5. The rig **posts a Daily Summary Report twice a day**.
6. The plan is **closed out**, and the **close-out pack** is filed for eDocs.

Today we use one test plan in test mode: **West Vela BOP1, plan `WVE-BOP1-20261012`**. Emails from it go to Dan and Lee
only, marked [TEST MODE].

**Open it on your own laptop:** `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/`

**The class rule.** You open and look. **Only the trainer presses Save, Post for review, Post daily report or Post
close-out.** Argo Navis also saves by itself when a step is completed and every 30 minutes while something has changed.
So:

- **Do not type, tick or change anything** on the real plan.
- **Move between pages with the step tabs** at the top, not the Next buttons.
- **To try something, press Simulate** on the BOP ready banner. Nothing can be posted from a simulation. Press **Reset
  to the real plan** when you are done.
- **If you see "Saved to server" on your own screen,** tell the trainer.

## 7A. Opening the plan and saving: follow along

| What | What I saw |
|---|---|
| The two choices on the landing page | ______________________ and ______________________ |
| The test plan's stage on the landing list | ________________________________________ |
| Saved by / saved at | ______________________ / ______________________ |
| The step the plan opened on | ________________________________________ |
| The Server save chip reads | ON ☐  OFF ☐   Reason if OFF: __________________________ |
| Three things that make Argo Navis save | 1 __________________ 2 __________________ 3 __________________ |
| Does a save tell anyone or start a review? | ______ |

## 7B. The scope challenge, SFI groups and the BOP ready date

| What | What I saw |
|---|---|
| Active in Maximo / captured (execute) / captured (deferred) / not captured | ______ / ______ / ______ / ______ |
| One deferred work order and its reason | WO ______________ reason ______________ |
| The SFI groups on this plan | ________________________________________ |
| The two SFIs in the BOP group | ______ and ______ |
| BOP ready date / need date / float | ______________ / ______________ / ______ |
| In Simulate: did deferring a BOP task move the BOP ready date? | ______ |
| In Simulate: did deferring a riser task move it? | ______  Why? ______________________ |

## 7C. Review and the scope freeze

| What | What I saw |
|---|---|
| Where the reviewers verify the scope | ________________________________________ |
| Region and number of required reviewers for West Vela | ______ / ______ |
| "n of m verified" on the plan bar | ________________________________________ |
| Hold 1: Freeze scope works only when | ________________________________________ |
| What a freeze without full verification needs, and how it shows | ________________________________________ |
| When Refresh review matters | ________________________________________ |

## 7D. Executing (watched on the trainer's screen; look, do not change)

| What | What I saw |
|---|---|
| The task the trainer completed, and its % after Calculate Project | ______________ / ______ |
| What "Complete" means | ________________________________________ |
| The checklist's three choices for each step | ______ ______ ______ |
| The two sign-off lines on a checklist | ______________ and ______________ |
| The break-in number the tool gave | BRK-______ |
| What the break-in moved | ________________________________________ |
| Where a wait (crane, permit, weather) goes instead | ________________________________________ |
| What the yellow line and the numbered stars on the chronology are | ________________________________________ |

## 7E. HOLD POINT: daily reporting requirements (about 13:55–14:10, discussion)

At the point where the first daily report is posted, the session stops to agree the requirement for the fleet.

**What is already settled (slides 19 and 20):**

- **The rig posts the report,** from Argo Navis. The planner no longer issues it.
- **It is posted twice a day, after each shift handover.** The report time is the rig's own time.
- **A red "Daily report due" chip** shows when more than 14 hours have passed since the last report.
- **What is inside:**
  - the project header (rig, BOP, project type, data date and time, rig manager, OIM, TSL, DSL, subsea supervisor);
  - the maintenance day, and the original and current finish;
  - plan variance and float to the BOP need date, in hours;
  - the critical path and SIMOPS;
  - project % and BOP % complete;
  - milestones;
  - break-in work and delays;
  - quality and rig reliability actions;
  - lessons learned;
  - work completed in the last cycle and planned for the next;
  - general comments.
- **Who it goes to:** it is emailed automatically, with the PDF attached and a link to the full schedule on the BOP
  Fleet Planning page.
  - **To:** the rig manager, assistant rig manager, subsea supervisor, TSL, DSL, electrical supervisor and MPD
    supervisor of the rig, and the WCE office planning list.
  - **Cc:** all TSC WCE Managers, Superintendents and Planners.
  - A line also goes into the plan's Teams chat.

Time the trainer posted the test report: ______  Time the [TEST MODE] email arrived on the trainer's screen: ______

**Decisions to agree.** Fill this in as the room agrees each line. Anything not agreed goes on the action list with an
owner.

| # | Decision | Agreed | Owner |
|---|---|---|---|
| 1 | Who on each rig posts the Daily Summary Report | | |
| 2 | The two report times per rig (the handovers) | | |
| 3 | What has to be correct before it is posted (progress and actual finishes, break-ins raised, people on board) | | |
| 4 | What happens when a report is late: who notices, who chases, by when | | |
| 5 | The planner's role once the rig posts | | |
| 6 | Form control: does it keep PPDSR030918, at a new revision? Who approves? | | |
| 7 | P6 projects only: how the rig gets a fresh ERT (the P6 export) for each report | | |

My own notes from the hold point:

______________________________________________________________________________

______________________________________________________________________________

## 7F. Two routes, and the close-out

| What | What I wrote down |
|---|---|
| The route for a BWM plan | ________________________________________ |
| The route for a P6 project | ________________________________________ |
| What the two routes have in common | ________________________________________ |
| When Post close-out becomes available | ________________________________________ |
| What is in the close-out pack, in order | ________________________________________ |
| | ________________________________________ |
| Which project folder it is filed in | ________________________________________ |

## Questions: Module 7

**7.1** Why does only the trainer press Save today, and what is the difference between Save and Post for review?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

**7.2** Two days after the scope freeze, the crew finds a damaged hydraulic fitting that must be replaced. What do you
do in Argo Navis, and what does it change?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

**7.3** Riser work on the plan will finish two days after the BOP stack work. Does that move the BOP ready date? Why?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

---

# Module 8: the loop, and the TSC Help Centre hands on (14:45–15:30)

Every tool you have used in the last two days works the same way. The tool on the rig makes **one file**. The file is
posted to the **intake** and lands in the **reports library**. The **scanner** reads it and builds the **page**. A
**notification** goes out with a link to the page, and a **receipt** records who it went to. When you can draw that
loop, you can find any failure in it. The hands-on part is the **TSC Help Centre**: the rig's way to reach Technical
Services with a question that is not a report.

## 8A. Draw the loop

Eight boxes, in order:

1. ________________ → 2. ________________ → 3. ________________ → 4. ________________ →

5. ________________ → 6. ________________ → 7. ________________ → 8. ________________

## 8B. Help Centre hands on (in pairs, one request per pair)

From SSORT, raise a help request. Check **the asset reads SSCE Equipment before you press Post**. On SSCE Equipment the
email and the chat go to the office only.

- A short title starting **TRAINING**.
- The category.
- Two lines of text.
- One photograph from the USB stick.

| What | What I saw |
|---|---|
| Time we pressed Post | ______ |
| What the tool said after Post | ________________________________________ |
| Time the request appeared on the Help Centre page | ______ |
| What it showed beside the request (receipt) | ________________________________________ |
| The subject of the office email (on the trainer's screen) | ________________________________________ |
| The name of the Teams chat | ________________________________________ |
| How the acknowledgement came back (subject and chat) | ________________________________________ |

## 8C. What a failure looks like, and who sees it

| Step | What a failure looks like | Who sees it first |
|---|---|---|
| The tool on the rig | | |
| The scanner | | |
| The page | | |
| The notification | | |
| The receipt | | |
| Argo Navis | | |

## Questions: Module 8

**8.1** Draw the loop. Eight boxes, in order.

______________________________________________________________________________

______________________________________________________________________________

**8.2** Your rig posted its Daily Summary Report at 07:10. At 08:00 nobody has the email. Name two places to look, and
who sees each failure first.

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

**8.3** Which goes where: a question about why the CBM form shows fewer grade buttons; an advisory to every rig about a
bolt batch; the twice-daily progress on a BWM plan?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

---

# Module 9: what is coming (15:30–16:15)

Over the next six months the tools change on the rig and in the office. Some changes depend on people outside this
room: IT (ISIT), the Maximo team and the PLATO owner. Each change has an owner and a plan. You will get a written note
before any of them reaches you. Write down the ones that matter to your rig.

## 9A. My notes

| Change | When / waiting on | What it means for my rig |
|---|---|---|
| Tablets that work with no signal | | |
| NC deferrals flagged at the scope freeze (Argo Navis) | | |
| Event PMs and CBM PMs in every plan | | |
| Maximo corrective work orders into the plan | | |
| PLATO cycle counts | | |
| The scanner moves to the server | | |
| The close-out pack copied to eDocs | | |
| The database (Fabric) | | |
| The pages rebuilt, with a Seadrill sign-in and Ask SACRED AI for everyone | | |
| Seadrill CORE | | |

The one change I most want, and why:

______________________________________________________________________________

## Questions: Module 9

**9.1** What is the one thing stopping SSORT and WCGRRT opening on a tablet with no signal, and who owns it?

______________________________________________________________________________

______________________________________________________________________________

**9.2** Once it is built, what will Argo Navis do if a BOP PM under an NC is left out of the window at the scope
freeze?

______________________________________________________________________________

______________________________________________________________________________

______________________________________________________________________________

**9.3** The scanner moves from Dan's laptop to the server. What changes for the rig?

______________________________________________________________________________

______________________________________________________________________________

---

# Module 10: feedback sheet: WCE reporting tools and SACRED, 19 and 20 October 2026

**Name:** ______________________  **Rig:** ______________________  **Date:** 20 October 2026

Ten minutes, on your own, before the round of the room. Short answers; a sentence each is enough. What you write here
goes onto the workshop action list with a name and a date against it, and Thursday's efficiency forum starts from it.

## 1. What is hard on the rig today

Three things about reporting, planning, requests, certificates or getting an answer from the office that cost you time
or go wrong. Say what, not why.

1. ______________________________________________________________________________

2. ______________________________________________________________________________

3. ______________________________________________________________________________

## 2. What the tools should do next

Three things you would change or add. Anything: a button, a word, a form, a page, a notification, a thing that should
stop asking you.

1. ______________________________________________________________________________

2. ______________________________________________________________________________

3. ______________________________________________________________________________

## 3. Two days: what landed and what did not

| | Clear | Needs another go | Not for me |
|---|---|---|---|
| Day 1 · WCGRRT: rig visit and daily reports | ☐ | ☐ | ☐ |
| Day 1 · WCGRRT: BOP testing, attachments, Post and the receipt | ☐ | ☐ | ☐ |
| Day 1 · SSORT: CBM, grades, the pre-deployment checklist, Post to OEM | ☐ | ☐ | ☐ |
| Day 1 · the exercise | ☐ | ☐ | ☐ |
| Day 2 · the precharge process | ☐ | ☐ | ☐ |
| Day 2 · the Rig Visit Dashboard | ☐ | ☐ | ☐ |
| Day 2 · BOP Fleet Planning, the CoC dashboard, SSCE requests | ☐ | ☐ | ☐ |
| Day 2 · the AAB and the Bulletin Board | ☐ | ☐ | ☐ |
| Day 2 · Argo Navis: scope, review, freeze, execute, close-out | ☐ | ☐ | ☐ |
| Day 2 · the daily reporting hold point | ☐ | ☐ | ☐ |
| Day 2 · the loop and the Help Centre | ☐ | ☐ | ☐ |
| Day 2 · what is coming | ☐ | ☐ | ☐ |

## 4. One thing

The one thing you will do differently on your next hitch because of these two days:

______________________________________________________________________________

## 5. Anything else

______________________________________________________________________________

______________________________________________________________________________

*Hand this page to Dan before you leave. The sheets are kept with the class record. Nothing on them is attributed to a
rig in any report without asking you first.*

**Before you leave:** open both tools on your laptop and wait three seconds. If **📤 n waiting to send** shows, press
**Send now**.
