# Day 2 hold point: the Daily Summary Report on P6 projects (WCGRRT)

*Half a page for the Argo Navis session (13:00–14:30). Argo Navis is the BWM route; this is the P6 route, so the
Superintendents see both. The two print the same report: the same rules, cut from the same code.*

**What it is.** WCGRRT's **Planning Report** is now the **Daily Summary Report** (form PPDSR030918's content). It replaces the
planner's hand-made Word report and the three-a-week email.

**Who posts it, and when**

- **The rig** posts it, as the planner on the ground. Anyone can choose Discipline = Planning in WCGRRT, so nothing is
  planner-only.
- **Twice daily, after each handover.** The **Report Time** is the rig's own: any time, defaulting to now, with quick buttons
  for 0600 / 0700 / 1800 / 1900.
- **"Since last report" counts from the previous report's time**, which the tool keeps for you.
- **The P6 numbers come from the ERT,** the P6 export: "📥 Import ERT" fills the done and next lists, the milestones, the
  critical path, the % complete, BOP %, the variance in hours and the current finish time.

**What it prints**

- **Header:** rig and project people; data date and time; original and current finish (with time); maintenance day;
  variance (hrs, red / green); BOP need date and time; total float (hrs).
- **Critical path / SIMOPS / "89.18% Complete / 96.6% BOP Complete".**
- **Milestones**, with status dots.
- **Schedule changes:** every open break-in or delay (type "Waiting / NPT"), NEW since the last report marked.
- **Quality / rig reliability.**
- **Lessons learned since last report.**
- **Previous report cycle to present.**
- **Projected for next report cycle.**
- **After-action review.**
- **General comments.**

**BOP %** is BOP work only: from on beams to testing complete, drifted, the pre-deployment call and ready to deploy. It is
calculated the way P6 calculates its own %.

**What happens to it**

- **The post** is named `yyyymmdd_<rig>_<type>_<BOP>_Report_<HHMM>.json`, so two reports a day never overwrite each other.
- **SACRED** prints the PDF and files it in the project folder.
- **The "Daily Summary Report" flow** emails it:
  - **To:** the rig's RM, ARM, SSS, TSL, DSL, ESV and MPD, plus the planning list.
  - **Cc:** all WCE managers, superintendents and planners.
  - **Subject:** `<Rig> <BOP> <type> Reporting yyyy/MM/dd HHMM`.
- **The BOP Fleet Planning Dashboard tiles** update from the same post.
- **No Gantt** in the email; the whole schedule is on the dashboard.

**To agree at the hold point**

1. **Who on each rig posts it.**
2. **The two report times per rig.** These are the handovers.
3. **How the rig gets a fresh ERT for each report** from the office planner. Make one tab per report, named with its date, e.g.
   "Oct15 0700".
4. **The planner's role** once the rig posts.
5. **Form control.** Does it keep PPDSR030918, at a new revision?
