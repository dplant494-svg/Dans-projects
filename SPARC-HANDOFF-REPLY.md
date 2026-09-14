# SPARC handoff — received, read, and what it changes

**From:** the dashboard / scanner session · **Date:** 14 September 2026
**To:** Dan, Lee, and the reporting-tools session (owner of the Feb 2027 timeline pack)
**Source:** `SPARC-HANDOFF-SACRED.md` (Lee's session, 14 Sep 2026), filed in this repo unchanged.
**Week plan item 8:** closed.

---

## 1. The one question we were waiting on, answered

The timeline pack (collaboration doc §8.1 and §9) called *"how does SPARC reach
Maximo?"* the single highest-value unknown, on the assumption that SPARC reads live
Maximo data and its route could be reused by the whole estate.

**The handoff answers it: SPARC has no live connection to Maximo** (§6, "Current state":
a static, point-in-time extract; "no live API yet"; live integration is roadmap item 3).
**Dan then answered the rest (14 Sep): the export comes from Maximo direct and refreshes
at 06:00 Houston time every day.** So the route is not an API and not a person at a
screen: it is **a scheduled daily Maximo export that already runs.** SPARC and the COC
tracker both read it. What it produces:

| Export | What it is | Used for |
|---|---|---|
| `SDITEM_SFI 331/332/334/335/336` | five Maximo item-master exports by SFI group, ~34k items | ICN, unit cost ("Last Price"), item status, manufacturer |
| `WCE Job Plans.xlsx` | 707 job plans, make/model in column H, SFI group in column I | job plan numbers `0900-xxxx`, Master PM `Cxxxx`, descriptions per interval |

So there is no service account, no API, no ODBC connection and no IT-built integration
sitting behind SPARC, and none is needed. **The COC tracker (WCE Certification
Tracker) uses the same export** (Dan, 14 Sep). One scheduled export, refreshed daily at
06:00 Houston (12:00 UK in summer, 11:00 in winter), is the estate's Maximo supply, and
it is already automated. **The estate's Maximo route exists today. What is missing is
only that our tools do not read it yet.**

### What this does to the timeline

The §9 rewrite in the collaboration doc ("Maximo is not an unknown, it is a reuse
question", two weeks off the front) rested on a premise the handoff removes. Honest
correction:

The §9 rewrite in the collaboration doc ("Maximo is not an unknown, it is a reuse
question", two weeks off the front) turns out to be **right, for a different reason
than it assumed.** Not a live route to reuse, but a scheduled export to read:

| Bar | Was (§9) | Should be |
|---|---|---|
| `Maximo — reuse the route SPARC and the COC tracker already use`, 15 Sep → 9 Oct | reuse a live route | **`Maximo — read the daily 06:00 Houston export SPARC and the COC tracker already use`**, 15 Sep → 9 Oct. Two things to establish, both small: **where the export lands** (a share, a SharePoint library, a mailbox?) and **its exact file set** (the five `SDITEM_SFI` files and the job-plan list, or more). The field mapping half is finished for free: ICN, SFI group, job plan, Master PM, last price, status and manufacturer are all named and reconciled in SPARC §6. |
| `Maximo read-only feed into the platform`, 9 Oct → 27 Nov | pulled forward two weeks | **Stays pulled forward.** If the export lands somewhere a sync client can reach, the scanner reads it the way it already reads the planners' BWM workbook dropped in a folder (raw file carried through, parsed downstream), and the database loader reads the same files. No IT build; at most an ISIT ask to add one read-only path. |

Net: the two weeks §9 took off are real after all, the discovery bar is now a
one-week "find the landing folder and list the files" task, and the Schedule Builder's
hand-refreshed exports (`Job Plans and Durations.xlsm`, `PMs with due dates.xlsx`)
should be checked against the same daily export: if they are the same data, the hand
refresh stops.

**The one thing still to ask:** not IT, Lee. *Where does the 06:00 export land, and what
files are in it?* Everything else follows from the answer.

## 2. What SPARC is, in SACRED terms

A **feeder, not a consumer**. It is a finished, offline, single-file catalogue
(~2,868 parts, ~376 drawings, 255 SFI locations, 178 NOV job plans) that already
carries the relationships the rest of the estate wants:

```
Seadrill ICN  <->  part (NOV / OilGear PN)  <->  SFI location  <->  job plan / Master PM  <->  unit cost
```

Join keys it shares with our data, named in the handoff §9: **SFI location code,
Seadrill ICN, Job Plan number, Master PM, Rig/Asset, make/model, CoC number.**

Where those keys already exist on our side:

| Our record | Carries | Joins SPARC on |
|---|---|---|
| COC Dashboard `APP_DATA` items (`asset`, `oem`, `serial`) and SSCE requests | equipment identity per rig | Rig/Asset, make/model; ICN where the COC item has one |
| Compliance checklist `expiries[]` (`register`, `ele`, `asset`, `cert`, `expiry`) | certification due dates | Rig/Asset + certificate |
| Precharge sheets (`meta.asset`, `meta.bop`) | rig + stack | Rig/Asset + BOP |
| Planning reports / BWM snapshots | BOP work by rig and week | Rig/Asset + interval (BWM) |

Nothing on our side carries an SFI location code today. That is the one column to add
at source if SACRED is to answer "what is due, what certifies it, what parts does it
need" per location. It is a reporting-tools question (a field on the compliance
checklist and the planning report), not a scanner one, and not urgent.

## 3. Concrete next steps, in order

1. **Load `SPARC_Master_Data.xlsx` into the Fabric database as reference tables.** The
   handoff says the workbook exists precisely as "the analyst-friendly / integration-
   friendly view": eight native Excel tables (`tbl_MuxPod`, `tbl_WCE`, `tbl_BOP`,
   `tbl_MCE`, `tbl_EHBS`, `tbl_Acoustic`, `tbl_JobPlanMatrix`, `tbl_JobPlans`). Eight
   tables in, one-off, re-loaded whenever Lee rebuilds. This is the first real content
   in the database Dan created on 13 September (M1b) and it costs nobody a build: the
   reporting-tools session's loader plan (timeline reply §10) gets its first reference
   data, and Copilot Studio can be pointed at the same tables later. **Ask Lee for the
   workbook.**
2. **Serve SPARC from IIS instead of the share.** `\\sdrlazneuiis01d.corp.local\SSORT\`
   and the sacred server are **the same machine**. The 139 MB standalone file exists
   only because the multi-file build will not boot from a UNC path (handoff §7). Served
   as `http://sdrlazneuiis01d.corp.local:8080/sparc/`, the light multi-file build works,
   the PWA installs (on HTTPS), and the 139 MB file goes away. One folder on the same
   ISIT ticket as the sacred pages. Lee's call; our recommendation.
3. **A SPARC link on the Rig Visit Dashboard.** One line once step 2 gives it a URL.
   Not before: a link to a 139 MB file on a share is not a link anyone clicks twice.
4. **Order lists as a posted artefact (later, loop three of the pattern).** Today an
   order list lives in the browser that built it. "Parts readiness per rig" on the
   dashboard (handoff §9, §10.4) needs SPARC to post its order list through the same
   HTTP trigger every other tool uses, as `seadrill-order_<rig>_<date>.json`, and the
   scanner to route it. That is a handoff to Lee's session when Dan wants the widget;
   the pattern document (`NOTIFICATION-LOOP-PATTERN.md`) is the template. **Not started;
   not on this week's list.**

## 4. For the timeline pack

- **Page 1:** replace the hatched SPARC band with two bars as §8.1 proposed, now with
  content: `SPARC — reference tables loaded into the database` (Oct, one week, needs
  the workbook) and `SPARC — served from IIS, linked from the dashboard` (Oct, with the
  sacred ticket). The Oct→Jan "integrate the parts catalogue with SSORT" bar stays as
  the order-list loop, owned by Lee's session.
- **Page 4 (effort):** the handoff leaves man-hours blank for the timeline owner to
  fill; it gives ten weeks elapsed, six phases, and a note that the AI-assisted actuals
  are far below a traditional multi-month small-team estimate. Lee owns that figure.
- **Milestone:** M1c, *SPARC handoff received; Maximo route answered: a scheduled
  daily export (06:00 Houston) already feeds SPARC and the COC tracker; field mapping
  banked*, 14 Sep 2026, done.

## 5. Questions back to Lee's session (three, all short)

1. ~~Who runs the exports and how often?~~ **Answered by Dan, 14 Sep: Maximo direct,
   scheduled, refreshes 06:00 Houston daily.** Remaining half: **where does it land
   (exact path or library) and which files are in it?** That path is what the scanner
   and the database loader read.
2. ~~Is the COC tracker fed from the same export?~~ **Answered by Dan, 14 Sep: yes, the
   same export.**
3. Can we have `SPARC_Master_Data.xlsx` for the database load (step 3.1)?

Everything else in the handoff is complete enough to work from. It is a good document.
