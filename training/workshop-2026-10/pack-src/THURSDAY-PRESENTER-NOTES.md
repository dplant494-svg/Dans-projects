# Thursday 22 October: presenter notes

**For:** Dan Plant, Technical Services – Subsea. **Room:** the Subsea Superintendents, Lee Arnold and the group, WCE SME Workshop, Houston.
**Decks:** `10-Thursday-CBM-Lessons-Learned.pptx` (13 slides) and `11-Thursday-SACRED-Repository.pptx` (8 slides). The same notes are in each slide's speaker notes.

Before 08:00, have these open in tabs:

- the dashboard on the CBM heatmap;
- SSORT at REV 169;
- a blank action list.

Fill each blank table on the slide itself while the room talks. Keep the edited deck: it is the record.

---

## Deck 1: CBM lessons learned and the CBM workshop (08:00–09:00)

*What implementation taught us; who signs what, where the record lives, and the one change that removes the most double handling.*

### Timing

| Slide | Title | Time | Minutes |
|---|---|---|---|
| 1 | Title | 08:00 | 1 |
| 2 | The hour | 08:01 | 2 |
| 3 | The CBM path today | 08:03 | 4 |
| 4 | Two kinds of grade on one report | 08:07 | 4 |
| 5 | One unit, one record | 08:11 | 4 |
| 6 | What went wrong, and what we fixed | 08:15 | 7 |
| 7 | The file-name collision, in numbers | 08:22 | 3 |
| 8 | What the office sees | 08:25 | 3 |
| 9 | What is coming for CBM | 08:28 | 3 |
| 10 | Part 2 · The CBM workshop | 08:31 | 1 |
| 11 | Who signs what, and where the record lives | 08:32 | 10 |
| 12 | The one change that removes the most double handling | 08:42 | 14 |
| 13 | Thank you: the action list | 08:56 | 3 |
| | Spare | 08:59 | 1 |

If Part 1 runs long, cut slides 8 and 9 to a sentence each. Do not cut slides 11 or 12.

### What Dan says

**1. Title.**
- One hour on CBM: what putting it into SSORT and SACRED taught us.
- Then a workshop on two things we have not agreed: who signs what, and where the record lives.
- The output is lines on the action list, each with an owner and a date.

**2. The hour.**
- Thirty minutes from me, twenty-five minutes from you.
- In Part 2 I fill in the tables on screen as you speak.
- If I run long, I cut my part, not yours.

**3. The CBM path today.**
- The crew inspects in SSORT. One press posts to the dashboard and emails NOV.
- NOV asked for this (Dave Cargill, 15 September): they cannot see our dashboard.
- PostedReports is the record. The NOV email, the dashboard and the database are copies built from it.
- Coming: the CBM programme PMs from Maximo in the Argo Navis plan, so the inspection is planned, not remembered.

**4. Two kinds of grade on one report.**
- Inspection tasks use NOV's five levels. Green is 1 and 2, amber is 3, red is 4 and 5.
- Grade 3 is "acceptable with findings", not a fail. Put 3 and write what you saw. Don't round down to 2.
- Tests use NOV's own pass or fail: 1 passed, 5 failed, nothing in between. Since 2 October that applies to every Testing and Intrusive task.
- Read the note under each task before you grade it.

**5. One unit, one record.**
- **Model and serial:** NOV can't review a CBM without them. Since SSORT 160 they belong to each unit and are never copied across.
- **Test records:** NOV's wording says "attach test graph". Before SSORT 152 there was nowhere to put one, so crews photographed the screen.
- **Usage data:** this is NOV's table 8.1, on five classes, added on 15 October. The crew types it today; PLATO should fill it later.

**6. What went wrong, and what we fixed.**
- Seven problems, in the order we met them. Each was fixed in the tool, not by asking people to be more careful. The last one is still open.
- **Riser Adapter:** Brad Waldron reported it from the rig on 29 September, and it was fixed that week.
- **Positional keys:** grades were stored by their place in the list, so 38 of 65 changed meaning when NOV's schedule changed. Now every grade has a name and every post carries its build.
- **Truncated Upper SBOP:** the tool was not at fault. The file was cut in transfer, and Brad's own saved copy was whole. Send files through the tool, not by Teams or email.
- **Still open:** a wrong-year inspection date hides a report from the dashboard. The crew and the reviewer need to check it.

**7. The file-name collision, in numbers.**
- SSORT named CBMs by rig and date, so a second unit inspected the same day overwrote the first.
- West Capella sent 13 CBMs to NOV and the dashboard kept 4. NOV had them all.
- We recovered 8. SSORT 158–159 now name each file by equipment and serial.
- For any tool that joins SACRED: decide what makes a record unique before the first post.

**8. What the office sees.**
- The heatmap puts components in rows and rigs in columns, coloured by the latest grade. Click a cell to open the inspection.
- The grid on the slide is an illustration. Show the live heatmap if there is time.
- A blank cell means nothing has been posted, not good news.
- The database holds every grade, usage table and send to NOV. "Where are the 4s and 5s?" is one query.

**9. What is coming for CBM.**
- **Event PMs:** Lee's design. Maximo has 422 CBM programme PMs. CBM rigs get the box ticked by default. GOM and GOA never do (BSEE).
- Carina's CBM PMs are not in Maximo yet. Manpreet is checking.
- **PLATO:** it already holds the cycle counts, so the usage table should fill from it. That needs the Grafana export and an ISIT account.
- **Photo review:** it flags changes and never changes a grade. It needs IT approval first.

**10. Part 2.**
- Twenty-two minutes, and your answers are what count.
- The next slide is my proposal. Correct it.

**11. Who signs what, and where the record lives.**
- This is a proposal built from how the tools run today. Go row by row: is that right on your rigs?
- The crew who grades is not the person who posts. The SSS checks the report before it goes to NOV.
- PostedReports is the master record. eDocs is where the controlled copy should end up; the connector is waiting on ISIT.
- Tick "Agreed?" row by row. Any row not agreed goes on the action list with an owner.

**12. The one change that removes the most double handling.**
- Go round the room, one answer each: where do your crews do the same work twice?
- The prompts on the left are guesses. Strike out any that are wrong.
- Write each answer in the person's own words.
- Then a show of hands. The winner goes to the top of the action list with an owner and a date before we leave this slide.

**13. Thank you.**
- Three things go on the action list: the sign-off table, the one change, and any CBM class or task that is still wrong.
- Riser Adapter got fixed because Brad told us. That is how the rest gets fixed.

### Questions to ask the room

1. Is grade 3 being used as "found something, monitor", or are crews rounding down to 2?
2. Does the SSS check every CBM before Post to OEM, or does the inspector post their own?
3. Who in the office acts on a grade 4 or 5, and how fast? Is a CM work order raised every time?
4. Has NOV replied to any CBM email? Who answered, and where is that reply kept?
5. Which record do you trust: the dashboard, the NOV email or the PDF on the rig? Should eDocs be the controlled copy?
6. Is there a CBM class, task or wording that is still wrong on your rig?
7. Should the TSL be on the NOV email, or only the Subsea Supervisor?

### What goes on the action list

- The sign-off table (slide 11), as agreed. Each row not agreed gets an owner and a date.
- The one change (slide 12), with an owner and a date. Add the runners-up below it.
- An owner to chase each "coming" item: event PMs (Lee), the PLATO feed (Dan and Nick, then ISIT), photo review (IT approval).
- A rule for crews and reviewers: check the inspection date before posting.
- Any CBM class or task the room says is still wrong. Dan takes these to the tools session.
- The eDocs connector for ISIT, if the room agrees eDocs holds the controlled copy.

---

## Deck 2: SACRED as the governed WCE technical repository (14:00–14:30)

*Document accuracy and revision control, lessons-learned capability, usability: what the group used on Days 1 and 2.* It follows Eric Rachall's West Tellus visit debrief (13:00–14:00).

### Timing

| Slide | Title | Time | Minutes |
|---|---|---|---|
| 1 | Title | 14:00 | 1 |
| 2 | What SACRED holds today | 14:01 | 3 |
| 3 | How a document stays accurate and controlled | 14:04 | 4 |
| 4 | Lessons learned: what SACRED can do now | 14:08 | 3 |
| 5 | The first test: the West Tellus debrief | 14:11 | 6 |
| 6 | Usability: what you used on Days 1 and 2 | 14:17 | 7 |
| 7 | What is next for SACRED | 14:24 | 4 |
| 8 | Thank you: the action list | 14:28 | 2 |

During Eric's debrief, note three or four lessons in his words. They go straight into slide 5.

### What Dan says

**1. Title.**
- This session follows Eric's debrief on purpose: his lessons are the first test.
- Lee asked four things of the repository: is it accurate, is it under revision control, can we find the lessons, and is it usable?
- You've used it for two days. I want your verdict, on the action list.

**2. What SACRED holds today.**
- There are eight things in it, and you've seen all of them this week.
- The database is about 36 tables, loaded every hour, so a question is a query.
- There's one source: the rig posts once, and everything is built from that post. If a page is wrong, the post tells us why.

**3. How a document stays accurate and controlled.**
- **REV badge:** every tool shows its build. This week it's WCGRRT 174 and SSORT 169, frozen until Friday.
- **Rolling handoff:** no change ships without an entry. We're at 86, and that's the audit trail.
- **MOC:** a change to a controlled form or loop goes through MOC.
- **eDocs:** filing is built on our side and is waiting on ISIT.
- One renderer per document, so the PDF NOV get is the one the crew saw.

**4. Lessons learned: what SACRED can do now.**
- **In the plan:** Argo Navis matches Synergi lessons to tasks by job plan, location or work order. The West Vela sample plan has 161.
- **In the daily report:** the Daily Summary Report has a lessons section, and the dashboard has a Lessons learned tab.
- **The open question:** where does a lesson from a visit or a debrief live, so the next plan finds it?
- My proposal: Synergi stays the record and SACRED links to it.

**5. The first test: the West Tellus debrief.**
- Put three or four of Eric's lessons in the first column, in his words.
- For each, ask: does it go in Synergi, change a plan task, or change a technical standard? Tick what applies.
- One home, links from everywhere else. A lesson nobody can place goes on the action list.

**6. Usability: what you used on Days 1 and 2.**
- One line per tool, fast: what worked, what got in the way, and the one change you'd make.
- Name the problem, don't design the fix. Say which answers are faults rather than wishes.
- This is the usability evidence for the ORR and the handover, so be specific rather than polite.

**7. What is next for SACRED.**
- **Server move:** the scanner leaves my laptop. The laptop keeps running until the server has done one clean run.
- **Web app:** the other hosting route, with HTTPS built in. I started it with Adam on Wednesday.
- **Seadrill CORE:** Lee's build. Technical standards linked by rig, region and SFI.
- **eDocs:** waiting on ISIT. None of this changes how the rigs post.

**8. Thank you.**
- Three things go on the action list: where the West Tellus lessons live, the usability changes, and anything from this week that should be in SACRED.
- Anything wrong with a tool, or anything you want it to do, comes to me.

### Questions to ask the room

1. Did anyone find a document in SACRED this week that was wrong or out of date? Which one?
2. Before you post, do you check the REV badge? Should the tool refuse to post on a stale build?
3. Where should a lesson from a rig visit live: Synergi, the plan, the technical standard, or all three with one home?
4. Who owns a lesson once it is recorded, and who closes it?
5. What did you look for on Days 1 and 2 and fail to find?
6. From the standards workshop, API 53 and TOMs this week, what should live in SACRED and doesn't?
7. Is eDocs the controlled home for close-out packs, or is SharePoint enough?

### What goes on the action list

- Where each West Tellus lesson lives (slide 5), with an owner and a date. Add any the room couldn't place.
- The usability changes (slide 6), ranked. Faults go first and are owned by Dan.
- A decision on the lessons rule: one home in Synergi, linked from SACRED and the plan. Owner: Lee.
- Anything from this week that should be in SACRED and isn't.
- To ISIT: the eDocs connector, the server move and HTTPS. Owner: Dan.

---

## Assumptions to check before Thursday

- **"SSS" means the rig's Subsea Supervisor.** It's the role copied on the NOV email. The slide 11 table is a proposal for the room to correct; the sources record no CBM sign-off.
- **The heatmap on deck 1, slide 8 is an illustration.** Rigs are A to D and the grades are made up. The slide says so.
- **The "about 36 tables" figure is yours.** The transfer deck says 34. Change the slide if the Fabric count differs.
- **The "13 sent, 4 kept, 8 recovered" numbers** are West Capella, 29 September to 6 October, from the week plan, item 48.
