# Wednesday 21 October, 09:00–12:00: working session with Adam Snyder

**Dan Plant** (Technical Services – Subsea, SACRED owner) with **Adam Snyder** (ISIT) · WCE SME Workshop, Seadrill Houston ·
two topics: **the web app** and **the start of the SACRED handover** · 1 copy for Dan, 1 for Adam.

## 1. Purpose and outcome

**Purpose.** Agree how SACRED moves off Dan's PC and into ISIT's care: on the sacred server as planned, or as a Microsoft web app.
Then walk the move through step by step, and set the web app and Lovable questions against it, so nothing is built twice.

**Outcome by 12:00.** A host chosen (or the one question that decides it, with an owner and a date). A transfer day booked. The
identities and HTTPS asks owned by named people with dates. The decisions table in section 5 filled in and read back to Adam.

## 2. Agenda

| Time | Topic | What we want from it |
|---|---|---|
| 09:00–09:05 | **Where SACRED is today** (deck slides 2–5) | Same picture. 16 rigs post through Power Automate into SharePoint PostedReports. The **scanner** (one PowerShell script, v3.11, every 10 minutes) runs on Dan's PC and publishes to the `sacred` share on `sdrlazneuiis01d`. IIS serves the pages. The flows send the emails and Teams posts. The laptop is the only weak point, and no data is at risk: every post is in SharePoint first. |
| 09:05–09:45 | **The handover: what moves, in what order, who owns what after** (slides 6, 11, 12) | Agree the ownership table below and the order: identity first, then host, then the scanner, then the flows' identity, then HTTPS and the tablets. |
| 09:45–10:15 | **The server move steps, walked through together** (`SACRED-SERVER-MOVE-STEPS.md`, steps 1–8 and the 21 Sep addendum) | Say which steps still hold if the host is the web app. Agree **the transfer day** and who is in the room (deck: a three-hour window). |
| 10:15–10:30 | **Break** | |
| 10:30–11:15 | **The web app** (slides 7–10; the Lovable plan) | Settle which "web app" we mean (the two are in the box below). Then hosting, sign-in and data questions 9 to 16. |
| 11:15–11:45 | **HTTPS for tablets, the eDocs connector, the Fabric database** | Owners and dates for each (questions 17 to 23). |
| 11:45–12:00 | **Decisions and actions** | Fill section 5 and read it back. |

**Two "web apps" are on the table. Keep them apart.**

- **A. The Microsoft web app (Azure App Service).** Adam raised it on the 14 October call. It hosts the pages as they are, because
  they are static files. The scanner runs as a scheduled WebJob, reads SharePoint through Graph with an app registration, and
  HTTPS comes with it. **It is a different host for the same SACRED.**
- **B. Lovable.** This is Plan 2, draft 1, of 2 October: a rebuild of the pages and the scanner's job on Lovable with its own
  database, Supabase. Viren owns the platform. The purchase order is cut, but the go-ahead was not official on 2 October
  (current status to confirm). The plan's cutover is the first full week of January 2027 at five days a week, or February 2027
  at two. **It is a replacement, later.** The rigs keep using today's SACRED until it proves parity.

Either way the transfer still has to happen now, because the Lovable plan keeps the live SACRED running throughout.

### Who owns what after the handover (proposal, to agree)

| Part | Today | After (proposed) | Source |
|---|---|---|---|
| Scanner script and config | Dan's PC, Dan's login | **ISIT own the task and the host. Dan owns the script** and sends versions. Dan gets drop access to `scripts` and `precharge`. | Migration handoff §7, chart M7 |
| Scheduled task / WebJob | Dan's PC, every 10 min | ISIT. It runs as a service account or app registration, **not a person** | Deck slide 6 |
| Deploy (pages to the web folder) | Dan runs `Deploy-Dashboard.ps1` | Run on the host. Dan triggers it after a page update (the method is to confirm) | Move steps, step 8 |
| The `sacred` share / web root | ISIT server, Dan writes | ISIT. Dan has write access and drops every update himself, including Lee's Argo Navis builds, so no ticket per update | Deck slide 6 |
| Power Automate flows (SEADRILL-WC-DEV) | Dan's connection, Dan and Lee owners | A Well Control Group role account as co-owner and connection. ISIT's Power Platform admin reassigns the primary owner. **Flows are never exported or moved** (that would change the trigger URLs) | Plan item 40 |
| SharePoint libraries (PostedReports, Digests, report folders) | M365, Dan and Lee | Unchanged. They stay the system of record | Deck slide 3 |
| Inputs (Maximo extract, Lee's job plans) | `\\SEADRILL23339` | Server: unchanged. Web app: moved to a SharePoint library | Deck slides 8–9 |
| Fabric database SACRED DATA | Dan's workspace | Dan and Lee. Capacity goes on Lee's cost centre when the trial ends, about 12 November | Chart M1b |
| Secrets (intake key, flow URL, eDocs credentials) | In the rig tools and the flows | **They do not move.** Anything new goes by a secure route only (section 6) | Deck slide 11 |

## 3. What Dan brings and opens

- [ ] **`SACRED-TRANSFER-DECK-2026-10.pptx`**: open it on slide 2. Slide 13 lists the decisions.
- [ ] **`SACRED-SERVER-MOVE-STEPS.md`** (9 Sep, with the 21 Sep addendum) and **`SCANNER-SERVER-MIGRATION-IT-HANDOFF.pdf`** (the design: §2 the SharePoint read, §3 the steps, §5 acceptance)
- [ ] **`ADAM-MEETING-BRIEF-2026-10-14.md`**: the full ask list from the 14 October call, including the read-back list at the end
- [ ] **`SACRED-to-Production-Programme-Chart-2026-10-01.pdf`** (draft 5) and the ORR workbook **`Operation_Readiness_Review_ORR_Checklist_SACRED_v2.xlsx`**
- [ ] **`SACRED-to-Lovable-Transition-Plan-2026-10-02.pdf`** and **`-Chart-2026-10-02.pdf`**, **`SACRED-What-It-Is-Made-Of.pdf`**
- [ ] **`tools/received/offline-tablets/ISIT-REQUEST-HTTPS-FOR-REPORTING-TOOLS.md`** (to hand over, if it has not been sent yet)
- [ ] **`EDOCS-CONNECTOR-ISIT-REQUEST-2026-10-16.md`**
- [ ] **`NOTIFICATION-DISTRIBUTION-IT-HANDOFF.pdf`**: background on the flows, only if Adam asks
- [ ] On screen, live: the dashboard and the **Status page** on `sdrlazneuiis01d` (the internal address you already use). Also Task Scheduler on your PC, showing **Refresh Reports Dashboard**.
- [ ] **Not to bring on screen:** `config.json`, `gate-config.js`, or any flow's trigger panel. These hold addresses and keys.

## 4. Questions to settle with Adam

| # | Question | Answer |
|---|---|---|
| **Host and handover** | | |
| 1 | Server (option A) or Microsoft web app (option B)? If ISIT will not give SACRED a server (14 Oct call), say so today. | |
| 2 | Is `sdrlazneuiis01d` still the sandbox? Has ISIT named the production home (M2a, due 10 Oct)? If a production server is built, when is that second cutover? | |
| 3 | **Which day is the transfer?** The chart has the week of 19 Oct, but the builds are frozen to Fri 23 Oct and Dan is in the class. Is it a day after 23 Oct, with Dan on Teams? | |
| 4 | Who has admin on the host to register the task or WebJob, and who is in the room on the day? | |
| 5 | **The identity**: one of Janzen's Well Control Group role accounts, a separate service account, or an app registration? Who creates it, and by when? It needs read on the three report libraries (PostedReports and the two Technical Services DMS folders), write on Digests and the web folder, and, on the server, read on `\\SEADRILL23339`. | |
| 6 | **How the host reads SharePoint**: a scheduled pull with PnP or Graph (recommended in the handoff), or OneDrive under the account? It must mirror deletions, and Digests must sync back. | |
| 7 | **The role accounts.** On 17 Oct Janzen Small (ISIT Business Partner Support, Technical Services' app IT contact) asked Digital Desk for two role-based accounts, **Well Control Group 1** and **Well Control Group 2**, for rotation continuity and shared tablets. She will arrange full account access. Do these replace WCEMPD? Which one runs the scanner and owns the flows? Their Exchange, Power Automate and Teams licences? Who is the Power Platform admin who reassigns flow owners? | |
| 8 | Windows PowerShell 5.1 on the host (server), or a PowerShell WebJob (web app)? Is the 60-minute task limit acceptable? | |
| **The web app** | | |
| 9 | Internet-facing with a Seadrill sign-in, or a private network only? The rigs open SACRED today with no login. | |
| 10 | If there is a sign-in, will the rig PCs and tablets get through it? We need a rig test before cutover. Can West Gemini reach it (it cannot reach the server today)? | |
| 11 | The new address: is it permanent, and does it survive a later production move? The flows' links (13 email cards) and the rigs' bookmarks change once. | |
| 12 | Where do the SSORT write-back share and the CoC Tracker file the rigs open go? | |
| 13 | Where do Manpreet's Maximo extract and Lee's job plans land if `\\SEADRILL23339` is out of reach? Who sets up the SharePoint library? | |
| 14 | Can `web.config` carry the MIME types and `no-cache` on `sw.js` for the offline tools? | |
| 15 | Lovable: does ISIT see the Microsoft web app as the step before Lovable, or instead of it? Who decides hosting for Lovable (Lovable-hosted, or exported and self-hosted by ISIT)? | |
| 16 | The Entra app registration for SSO and Graph: can one registration serve both the web app and Lovable? What is the lead time? (Lovable plan: no SSO, no production on any platform.) | |
| **HTTPS, eDocs, Fabric** | | |
| 17 | HTTPS for the tablets: a binding and an internal-CA certificate pushed by Intune (server), or built in (web app)? By when? The request asks for the end of October. | |
| 18 | Do we keep port 8080 working, or redirect it? | |
| 19 | The Intune push of SSORT and WCGRRT as home-screen apps: yes or no, and who does it? | |
| 20 | eDocs: does Seadrill hold the OneFox / PPC subscription? Who owns the API key and the settings name? | |
| 21 | eDocs: the API key and settings name (asked of Digital Desk 17 Oct) and the premium licence. The connection uses Dan's account until a role account is ready; the document controller sets the fields. | |
| 22 | Fabric: who makes the capacity decision (open action, 31 Oct)? Do SACRED DATA and the hourly dataflow stay as they are? | |
| 23 | ORR, week of 19 Oct: who confirms backup, the RACI, early-life support and the DR handover? Also KE-08 (the stale SSORT copy on the share) and KE-10 (the intake address in the tool files, which needs a rating). | |

## 5. Decisions to record

| Decision | Agreed | Owner | Date |
|---|---|---|---|
| Host: server (A) or Microsoft web app (B) | | | |
| If B: internet with sign-in, or private | | | |
| Production home (is the sandbox production, or a second cutover) | | | |
| Transfer day and window, who is present | | | |
| Identity: service account or app registration, and who creates it | | | |
| SharePoint read method (pull / Graph / OneDrive) | | | |
| The Well Control Group role accounts' licences (Exchange, Power Automate, Teams) and owner | | | |
| Flow ownership: who reassigns, and when | | | |
| Dan's write access to the deploy folders (scripts, Argo Navis, precharge, pages): no ticket per update; Lee sends his builds to Dan | | | |
| Inputs location (`\\SEADRILL23339` or a SharePoint library) | | | |
| HTTPS: method and date | | | |
| Dual run length, and the date Dan's PC task is disabled (chart: 13 Nov; 14 Oct brief: 6 Nov; to confirm) | | | |
| eDocs connector: API key and settings owner (Digital Desk asked 17 Oct); Dan's account until the role accounts land | | | |
| Fabric capacity: decision owner | | | |
| How the web app relates to Lovable | | | |

## 6. Risks and things not to do

- **Never paste the intake address, the flow URLs, keys or passwords into chat, email, Teams or this sheet.** That covers the rig
  tools' intake key, the trigger URLs, the precharge gate and the eDocs API key and password. New credentials go **straight into the
  Power Automate connection or the host's secret store**, or reach Dan by a secure route ISIT name. They are never written into
  SACRED's files.
- **The scanner must not run on two machines with the outputs pointed at different places.** The move steps allow a short dual run
  on the same outputs (the scan lock and `_replaced` cover it). For anything else, **pause Dan's task before the first run on the
  new host**, as deck slide 12 does. Agree which of the two rules applies on the day.
- **Do not disable or delete anything on Dan's PC until the new host passes acceptance.** That means a matching report count, a
  test post appearing within 10 minutes, a deletion mirrored, and the Status page agreeing. Then **disable, never delete**: the
  laptop task is the rollback.
- **Freeze to Friday 23 October.** The builds are frozen at WCGRRT 174, SSORT 169 and Argo Navis REV 16, and the dashboard and pages
  are frozen as signed off in UAT. Nothing is deployed, and no address the class uses changes, before then. The transfer day is
  agreed on Wednesday, not done on Wednesday.
- **Do not move the flows by export and import.** That makes new trigger URLs and means a new revision of every rig tool.
  Swapping connections and owners inside SEADRILL-WC-DEV changes no URL.
- **Do not install the tools on tablets before the move.** An installed app belongs to its address, so every tablet would have to
  install twice. Carry `sw.js`, `manifest.json` and the icons across with the tools.
- **No second system of record.** Do not load data into a Lovable or Supabase store alongside Fabric until the Lovable plan's
  phase 0 has decided which one holds the record.
- **Do not take on new build work in the room.** Section 7 gets the asks into the plan.

## 7. After the session

Before the end of Wednesday, send this SACRED session one message. Paste the text, never a credential. It should contain:

1. **Section 5 as filled in**: each decision, its owner and its date, plus anything left open and who answers it.
2. **The transfer day**: the date, the window, who is present, and the host (A or B).
3. **The identity**: what ISIT will create, and when. The same for the Well Control Group role accounts.
4. **The answers to questions 1–23** that changed anything, in a line each.
5. **Anything Adam asked of Dan**, with dates.

With that, this session will:

- update `WEEK-PLAN-2026-09-14.md` (items 36, 40, 54, 62, 67 and 69);
- rebuild the programme chart (M2, M2a, M5, M7, M8a);
- rewrite `SACRED-SERVER-MOVE-STEPS.md` for the chosen host;
- prepare `config.server.json` for the new paths;
- update the ORR workbook's open actions;
- draft any follow-up email to Adam, for you to send.
