# Meeting with Adam Snyder, 14 October 2026: itinerary and talking list

**For Dan.** Everything SACRED needs from ISIT, in the order to raise it, with the decision wanted on each. Bring: the ORR
workbook v2, the programme chart (draft 5), `ISIT-REQUEST-HTTPS-FOR-REPORTING-TOOLS.md`, `SACRED-WHAT-IT-IS-MADE-OF.md`.

## Itinerary (60 minutes)

| Min | Topic | Decision wanted today |
|---|---|---|
| 0 to 10 | **The scanner transfer, week of 19 Oct** | the day, the account, how the server reads SharePoint |
| 10 to 20 | **Production home and UAT** (M2a) | is this server production, or is one built; UAT estimate and date |
| 20 to 30 | **Two accounts:** the service account and the WCEMPD sending identity | who creates them, by when, with what licences |
| 30 to 40 | **HTTPS on the server** (tablets offline) | yes and when; cert via internal CA and Intune |
| 40 to 50 | **eDocs, Fabric, the two known errors, rig access** | owners and dates |
| 50 to 60 | **What comes next:** Argo Navis joining SACRED, Lovable, early support funding | awareness, no decision |

## 1. The scanner transfer (week of 19 Oct)

Say: "The scanner is one PowerShell script, one config file and one scheduled task, running on my laptop every ten minutes.
We move it onto sdrlazneuiis01d one day that week while I am in Houston, and run both for three weeks."

Ask Adam:
1. **Which day** that week, and who has admin on the server to register the task.
2. **The service account** the task runs as. It needs: read on three SharePoint libraries (WellControl PostedReports, the
   two Technical Services DMS report folders), write on WellControl Digests, write on the `sacred` share, read on
   `\\SEADRILL23339\Well Control Data`.
3. **How the server reads SharePoint.** On my laptop the libraries are OneDrive-synced folders. A server cannot run OneDrive
   under a service account. Does ISIT prefer the OneDrive sync client under the account, or a scheduled pull? This is the
   one technical question that decides the transfer day's work.
4. **Windows PowerShell 5.1 and .NET** on the server: the script runs on 5.1 today; no Excel, no Python, no Node needed.
5. **The dual run** to 13 November, then my laptop's task is disabled on 6 November (M7); ISIT own the task from then.

## 2. Production home and UAT (M2a)

Say: "Moving the scanner onto the server makes the task yours, but the server is still the sandbox. The server name is in
every link the flows send, in the rigs' bookmarks, in the SSORT write-back and the scanner config."

Ask:
1. **Does sdrlazneuiis01d become production, or is a production server built?** If built, the cutover is planned like the
   transfer, with the rigs' bookmarks and the flow links changing once.
2. **UAT:** Adam's estimate and requirements (the 1 October action). Testers: the WCE SME class on 20 October gives the UAT
   sign-off. Heavy windows: 7 to 10 day BOP maintenance periods.
3. **Does the server name stay** through any move? (Also the HTTPS question below.)

## 3. Two accounts

**a. The service account** (section 1.2): for the scanner task, and later the Fabric dataflow.

**b. The WCEMPD sending identity**, for every notification email and Teams post. Say: "I want every email and chat line the
flows send to come from one group identity the rigs learn once, not from my mailbox."

Ask:
1. **An Exchange mailbox** named for WCEMPD (the Well Control Equipment and MPD group).
2. **A Power Automate licence and a Teams licence** on it: the flows create chats and post into them, not only email.
3. **Can it be the same account as the scanner's**, or must they differ? Either works for us.
4. **Who in ISIT is the Power Platform admin** who reassigns flow ownership in SEADRILL-WC-DEV once the account exists. The
   flows are never exported or moved, so no URL changes.
5. **Date:** the week of 19 October, with the server account.

## 4. HTTPS on the server (rig tablets offline)

Hand over the request. Say: "The rig tools are single files that post over the internet, so they can run offline on an iPad
or Android tablet. The only thing stopping it is that tablets keep an offline web app only over HTTPS, and the server
answers on HTTP 8080 only."

Ask:
1. **An HTTPS binding** on the IIS site, port 443, for `sdrlazneuiis01d.corp.local` (or a friendlier name).
2. **A certificate the tablets trust:** internal CA, with the CA root pushed to managed iPads and Android tablets by Intune.
3. **Two MIME types** (`.webmanifest`, `.js`) and `Cache-Control: no-cache` on `sw.js`, or let me do it in a web.config.
4. **Keep 8080** working, or redirect it.
5. **Can rig tablets reach the server at all**, on the rig network or VPN, for the one-time install.
6. Optional: **Intune push** of the two tools as home-screen apps. Wanted by end of October.

## 5. eDocs, Fabric, known errors, rig access

**eDocs (InfoCenter).** Say: "The planning tool's project folder on SharePoint will be copied into eDocs at project
complete, by a flow. The OpenText eDOCS connector is in our Power Automate environment."
Ask: (1) is InfoCenter OpenText eDOCS, and which version; (2) is its REST API enabled and reachable from Power Automate;
(3) licence for the OneFox eDOCS connector in SEADRILL-WC-DEV (it is premium); (4) an integration account with rights in the
WCE evidence library; (5) which eDocs library and workspace WCE project evidence belongs in.

**Fabric.** The capacity decision is on the open actions for 31 October. Ask who decides and whether the SACRED DATA
warehouse and the hourly dataflow stay as they are.

**Two known errors ISIT own.**
- **KE-08:** a stale second SSORT copy on the `sacred` share that I cannot delete. Ask for it to be deleted.
- **KE-10:** the intake URL sits in the tool files, so anyone who opens a tool can post. Ask ISIT to rate it: the trigger,
  its rotation, and whether anything should sit in front of it.

**Rig access.** ISIT's notes call it "selective test provisioning": West Gemini cannot reach the server (its edge router drops
the route). Ask for the fix date; every other rig reaches it.

## 6. What comes next (awareness)

- **Argo Navis** (Lee's schedule builder) is coming into SACRED: hosted on the same server already, same share, same flows.
  No new infrastructure; one more folder on the server.
- **Two future APIs** we will ask about later, not today: PLATO (live BOP control-system data, every rig but Sevan
  Louisiana) and Maximo REST for work-order close-out.
- **Lovable:** Viren's feasibility is outstanding. Our position: it could replace the IIS hosting, not the posting contract,
  the flows or Fabric; judge it on a half-day render test.
- **Early support funding:** Luis was asking Arnold and Torsten; any news.

## Before you leave the room, read back the list

Day of the transfer · the SharePoint read method · service account owner and date · WCEMPD mailbox owner and date ·
HTTPS yes/no and date · eDocs five answers or who answers them · KE-08 deleted · West Gemini date · UAT estimate date.
