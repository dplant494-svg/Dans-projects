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

**The handoff answers it plainly: SPARC does not reach Maximo. There is no live route.**
(§6, "Current state": a static, point-in-time extract; "no live API yet"; live
integration is roadmap item 3.) What SPARC holds came from **files exported by hand**:

| Export | What it is | Used for |
|---|---|---|
| `SDITEM_SFI 331/332/334/335/336` | five Maximo item-master exports by SFI group, ~34k items | ICN, unit cost ("Last Price"), item status, manufacturer |
| `WCE Job Plans.xlsx` | 707 job plans, make/model in column H, SFI group in column I | job plan numbers `0900-xxxx`, Master PM `Cxxxx`, descriptions per interval |

So there is no service account, no API, no ODBC connection and no IT-built integration
sitting behind SPARC. The COC tracker (WCE Certification Tracker) is "on Maximo data"
the same way until someone shows otherwise: an export.

### What this does to the timeline

The §9 rewrite in the collaboration doc ("Maximo is not an unknown, it is a reuse
question", two weeks off the front) rested on a premise the handoff removes. Honest
correction:

| Bar | Was (§9) | Should be |
|---|---|---|
| `Maximo — reuse the route SPARC and the COC tracker already use`, 15 Sep → 9 Oct | reuse | **`Maximo — field mapping done (from SPARC); route is an IT ask`**, 15 Sep → 9 Oct. The *mapping* half of the old discovery bar is finished for free: ICN, SFI group, job plan, Master PM, last price, status, manufacturer are all named and reconciled in SPARC §6. The *route* half (who can give the estate a scheduled export or a read-only view) goes on the same ISIT ticket as the service identity. |
| `Maximo read-only feed into the platform`, 9 Oct → 27 Nov | pulled forward two weeks | **Back to 23 Oct → 11 Dec**, and honestly dependent on IT. Not a "first IT resource in January" item, but not ours to finish either. |

Net: the field mapping is a real gain and stays. The two weeks were not real and come
back. The Schedule Builder keeps consuming hand-refreshed exports until the route exists,
exactly as it does today, and so does SPARC.

**Cheapest possible route, worth asking IT first:** whoever produces the `SDITEM_SFI`
exports today does it from a Maximo screen. A **scheduled export of the same five
queries plus the job-plan list to a SharePoint library** is a Maximo report schedule,
not an integration project, and it would feed SPARC, the COC tracker, the Schedule
Builder and the database from one place. Ask for that before asking for an API.

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
- **Milestone:** M1c, *SPARC handoff received; Maximo route answered (static exports,
  no live link); field mapping banked*, 14 Sep 2026, done.

## 5. Questions back to Lee's session (three, all short)

1. Who runs the `SDITEM_SFI` and job-plan exports, from which Maximo screen, and how
   often? (This is the person and the report IT would schedule.)
2. Is the COC tracker fed from the same export, a different one, or something live?
3. Can we have `SPARC_Master_Data.xlsx` for the database load (step 3.1)?

Everything else in the handoff is complete enough to work from. It is a good document.
