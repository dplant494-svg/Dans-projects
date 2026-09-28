# Reply to IT — the WCE Reports Assistant (Copilot Studio agent), your ten questions answered

**From:** Dan Plant, Technical Superintendent, Well Control Engineering · **Cc:** Lee Arnold
**Date:** 28 September 2026 · **Follows:** my request of 16 September to publish the agent in Teams
**Replace the bracketed bits before sending.**

---

Hello [name],

Thank you for the questions; they are the right ones, and most of them have short answers because
of how this was built. Two things up front, then each question in turn.

**It was built inside Seadrill's own Copilot Studio.** The agent, its knowledge source and its
Teams channel all live in the Seadrill Microsoft 365 tenant under the company's Copilot Studio
licence, created with my Seadrill account. There is no personal subscription, no trial tenant, no
external service and no code of its own: it is a standard Copilot Studio agent pointed at one
SharePoint library on the WellControl site, with web search and general knowledge switched off.

**The one piece that is not yet where it belongs is the scanner, and that move is already
arranged.** Today the scanner runs as a scheduled task on my PC. When I am in Houston in October
I am sitting down with Adam Snyder to transfer it from my computer to the sacred server
(`sdrlazneuiis01d`), under a service account, as a scheduled task ISIT own. That was agreed in the
production plan on 27 August; October is when it happens. Everything below says what is true
today and what changes at that point.

## 1. What is the "dashboard scanner", what runs it, where, and who supports it?

The scanner is one PowerShell script, `Update-Dashboard.ps1`, about 3,000 lines, no modules and
nothing installed. Every ten minutes it reads the Well Control report files the rigs post into
three SharePoint libraries (through the OneDrive sync folders on the machine it runs on), summarises
them into the data files behind the WCE dashboards on the sacred web share, and writes one small
HTML text copy of each report, a "digest", into the **Digests** library on the WellControl site.
The agent reads those digests and nothing else.

- **Today:** a Windows scheduled task on my PC, every ten minutes, under my own account. It has
  run that way since 9 September.
- **From October:** the same script in `D:\TSC-Dashboard` on the sacred server, a scheduled task
  every ten minutes under a service account, set up with Adam Snyder in Houston. ISIT then own
  the task; I own the script.
- **Support:** I support the script and the dashboards (Technical Services, Well Control
  Engineering). Every version is in a Git repository with its change history, an install guide
  and a handoff document written for the next person, and the reporting tools it reads from are
  documented against it in a written integration contract. Lee Arnold (WCE Manager) is the
  co-owner; see question 4.

## 2. What account does the scanner use to write to SharePoint? Permissions? Expiring secrets?

Today, my own Seadrill account, and only through the OneDrive sync client. The scanner never calls
SharePoint, Graph or any API: it reads and writes ordinary files in synced folders, and OneDrive
carries them up. It has no app registration, no client secret, no certificate, no stored password
and no token, so there is nothing that expires and nothing to rotate. Its rights are exactly my
rights on the WellControl site. Writes to the sacred web share use the same domain account over
the file share.

From October the same is true of the service account: read on the three report libraries, write
on **Digests**, write on the two IIS folders on sacred. Still no secret, because the mechanism does
not change. That is the whole permission list, and it is in the production plan for ISIT.

The only signed URL anywhere in the estate is the Power Automate HTTP trigger the rigs post
reports to, which is the DLP exception ISIT granted in August. It belongs to the flow, not to the
scanner or the agent, and it is not in any file that travels.

## 3. Do the Digests library's permissions match the original reports? How are restricted reports kept out?

Yes, by construction. The Digests library sits on the same WellControl site as the three report
libraries and inherits the site's permissions, so the audience that can open a digest is the
audience that can open the report it came from. Two further safeguards:

- **Restricted material is never digested.** The scanner does not write a digest for TOPSET
  investigation files or for precharge request payloads, the same rule it applies to the report
  copies on the web share. A digest is text only: no photographs, no attachments.
- **The agent answers with the reader's own permissions.** Copilot Studio's SharePoint knowledge
  is queried as the signed-in person, so someone who cannot open the Digests library gets no
  answer from the agent at all, and nobody can read a digest of a report they could not open.

If ISIT would rather the Digests library carried its own, narrower audience, that is a
permissions change on one library and nothing in the agent moves.

## 4. Who takes over if Dan leaves? Co-owner and documentation?

**Lee Arnold**, WCE Manager, is the co-owner. I am adding him as a co-owner on the agent in
Copilot Studio (Manage → Security) and on each Power Automate flow this week, so nothing depends
on my account alone; the service account in October removes the last dependency on my PC.

Documentation: everything is written down in one repository, with the history of every change:
the scanner's handoff document, the install guides, the flow build guides (click by click, as
built), the integration contract between the reporting tools and the dashboard, the Copilot
agent setup guide (`COPILOT-REPORTS-ASSISTANT-GUIDE.md`, which includes the agent's instructions
verbatim), and the production timeline agreed with ISIT. A competent colleague can rebuild the
agent from that guide in half an hour. I can give ISIT read access to the repository.

## 5. How does the dashboard's "Ask SACRED AI" button connect to the agent? Do users sign in?

The button is a plain link. It opens the agent's Teams channel link (the address Copilot Studio
issues when the agent is published to Microsoft Teams) in a new tab. Nothing is embedded in the
dashboard, no token is passed, and the dashboard holds no credentials. Teams opens with the
person's existing Microsoft 365 sign-in, so they are who Entra ID says they are, and the agent
answers within that person's SharePoint permissions (question 3). No separate sign-in, no shared
account, no anonymous access: the demo website channel is not enabled.

## 6. Which Power Platform environment, which DLP policies, can sharing be set for that environment only?

The agent lives in the **Seadrill Apps PROD** environment, the Power Platform environment the
company's production apps sit in, which is where Copilot Studio placed it when it was created
under the Seadrill licence. The WCE Power Automate flows (the report intake, the precharge, AAB
and CBM-to-OEM notifications) are in **SEADRILL-WC-DEV** (id
`76e054f3-a40c-e46e-8457-4bd43fc3ad06`), the environment created for Well Control. The two do
not talk to each other: the agent reads a SharePoint library, the flows write files, and neither
calls the other.

The DLP policies that apply to each are whichever ISIT have assigned to those environments plus
the tenant-wide ones. The only exception ever requested is the HTTP trigger exception of August,
on SEADRILL-WC-DEV, which is granted and in use. The agent itself uses two connectors, SharePoint
(knowledge) and Teams (channel), both in the Business group of every standard policy, so it needs
no exception. If ISIT would rather the agent sat in SEADRILL-WC-DEV beside the flows, it can be
exported and imported there as a solution; say so and I will do it before it is published.

Yes, sharing can be set for the environment alone. Copilot Studio's "share agents with
everyone/security groups" and the Teams app availability are governed per environment and per
app, not tenant-wide, so ISIT can allow this agent for a named group in this environment and
change nothing for the rest of the company.

## 7. Which group gets access, who manages it, does each update need approval again?

The group is the membership of the **WellControl SharePoint site**: Technical Services, the
Subsea Superintendents, and the rig subsea teams (Technical Section Leaders and Subsea
Supervisors), about [N] people. Lee Arnold and I own that site and manage its members today. If
ISIT prefer a security group for the Teams app policy, "WCE Reports Assistant users" with me and
Lee as owners is fine; site membership still decides what anyone can read.

Approval is once. The Teams app approval covers the app. Changes to the agent's instructions or
knowledge are published from Copilot Studio and take effect without a new approval; only a
change to the Teams app package itself (name, icon, permissions) would come back to the admin
centre, and none is planned.

## 8. Who pays, how much use, billing model, cost centre, are the users licensed for Microsoft 365 Copilot?

- **Licence:** the agent runs on Seadrill's Copilot Studio tenant licence. Users do **not** need
  a Microsoft 365 Copilot licence to use an agent published to Teams; the agent's use is
  metered in Copilot Studio messages against the tenant's capacity (message packs or
  pay-as-you-go), not per user.
- **Expected use:** an estimate of 1,500 questions a month across Technical Services, the
  Subsea Superintendents and the rig subsea teams, roughly 4,500 Copilot Studio messages. At the published pay-as-you-go rate
  of one cent a message that is about **$50 a month**; if ISIT prefer a fixed line, one Copilot
  Studio message pack (25,000 messages, about $200 a month) covers it several times over. Copilot Studio's own analytics report the actual number, and I
  will send ISIT the first month's figure.
- **Cost centre and billing:** Technical Services, Well Control Engineering. Lee Arnold, WCE
  Manager, will confirm the cost centre code and whether it is billed as a message pack or
  pay-as-you-go against the Copilot Studio capacity; he is copied on this email. The scanner,
  the dashboards and the flows cost nothing beyond the licences Seadrill already holds
  (SharePoint, Power Automate standard connectors, IIS on sacred).

## 9. Will it be used offshore? Tested on a rig? Firewalls?

Yes, offshore is the point: the questions come from the rigs as much as from the office. It runs
inside Teams, over the same Microsoft 365 endpoints the rigs use every day for Teams, SharePoint
and Outlook, and the rigs already post their reports to SharePoint through the same path. No new
address needs opening: if Teams works on the rig, the agent works on the rig.

It has not yet been tested on a rig, because until the Teams app is approved nobody but me can
open it. The first rig test is West Capella, where Brad Waldron is already piloting the daily
reports; I will run it the day the app is allowed and send ISIT the result.

## 10. Who supports it, how will we know if it breaks, chat logs?

- **Support:** me, with Lee Arnold as co-owner; ISIT own the server task from October. Users
  report through Technical Services, not the service desk, unless ISIT want it the other way.
- **If the digests stop:** it is visible in three places already. The dashboard header says
  "Data updated N minutes ago" and every page carries an amber banner when its data is more than
  a few hours old; the scanner prints a scan log every run; and Power Automate emails the flow
  owner on any failed run. I will add the one thing missing: a scheduled flow that checks the
  Digests library once an hour and emails Lee and me if nothing has been written for two hours,
  so a stopped scanner is known within the hour. Once on the server, ISIT's own task monitoring
  covers the same.
- **If the agent breaks:** Copilot Studio's analytics show sessions, unanswered questions and
  errors; Microsoft service health covers the platform.
- **Chat logs:** conversation transcripts are kept by Copilot Studio in the environment's
  Dataverse, the standard retention being 30 days, adjustable by ISIT per environment. The agent
  stores nothing of its own, keeps nothing outside the tenant, and sends nothing outside it: no
  web search, no general knowledge, no external connectors.

If it helps, I can show all of it in fifteen minutes on a call, and when I am in Houston in
October Adam and I can take ISIT through the server transfer at the same time. I would like this
to be the reference case for the next agent someone in Seadrill builds.

Kind regards,

Dan Plant
Technical Superintendent, Well Control Engineering
[phone]

---

## Notes for Dan (not part of the email)

- Question 6: the agent is in Seadrill Apps PROD (Copilot Studio's picker), the flows in SEADRILL-WC-DEV;
  both stated. If IT prefer the agent moved beside the flows, that is a solution export/import, not a rebuild.
- Question 4: add Lee as co-owner on the agent (Copilot Studio → the agent → **Manage** → **Security**
  → **Co-owners**) and on each flow (flow → **Share**) before the email goes, so the sentence is true.
- Question 8: head count and monthly estimate are the session's numbers (about 1,500 questions a month, about $50 a month pay-as-you-go or a $200 message pack); Lee confirms the cost centre code and the billing model, so copy him.
- Question 10: the hourly "digests still fresh" flow is a ten-minute build; say the word and I write it
  click by click.
