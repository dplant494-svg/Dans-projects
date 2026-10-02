# SACRED: what it is made of, in one page

**For:** Viren (Lovable feasibility), Adam Snyder (UAT), Saroj / Infosys (supportability) · **From:** Dan Plant ·
**Date:** 2 October 2026. One page so that the migration and support questions are judged against the real parts.

SACRED is five parts. They are joined by files, not by code calling code, which is why each can be judged on its own.

| # | Part | What it is | Where it runs | Who owns it | Could it move to a hosted app platform? |
|---|---|---|---|---|---|
| 1 | **The rig-side tools** (WCE Rig Reporting Tool, SSORT, Precharge Pro, the AAB and Help pages) | Single self-contained HTML files. A crew opens one on a rig laptop, often with no or poor connectivity, fills it in over hours or days, and presses Post. Post sends one JSON file (0.5 to 40 MB) to an HTTP endpoint. | On the rig laptop, from a file. Served from the sacred share only as the place to download the current revision. | Dan Plant (owner); built with their build sessions | **No.** They must work offline and post one file. A hosted web app needs a live connection for every keystroke, and rigs do not have that. They stay as they are whatever happens to the rest. |
| 2 | **The intake and the notification flows** | Power Automate: an HTTP trigger that writes each posted file into a SharePoint library; five flows that send the precharge, CBM to NOV, AAB, Help Centre and rig-visit emails and Teams posts from a distribution workbook, with test mode and receipts. | SEADRILL-WC-DEV environment; SharePoint site WellControl | Dan, Lee Arnold co-owner | **Already hosted** in the Microsoft tenancy. Nothing to migrate. If the pages moved, the links the flows send would change, which is a field edit per flow. |
| 3 | **The scanner and the pages** | A PowerShell script (no modules) runs every ten minutes, reads the three SharePoint libraries through OneDrive sync, and writes static HTML pages plus a JSON data file and per-report digests. The dashboard, the Bulletin Board, the Help Centre and the precharge pages are those static files served by IIS from the sacred share. | Dan's PC today; the sacred server (sandbox) from the week of 19 October; UAT / production when ISIT provide them | Dan (script and pages); ISIT (server and task from the transfer) | **This is the part a platform could replace.** The pages are read-only views of files; a hosted app could render the same views from the same data. It would need an ingestion step to take the posted files from SharePoint (or the scanner's normalised export) into its own store, and an authenticated path for rig users. |
| 4 | **The database** | Microsoft Fabric SQL database `SACRED DATA` (22 tables, 6 views), loaded from the scanner's normalised export on every run. No server, no secret. | Dan's Fabric workspace; capacity on Lee's cost centre from mid-November | Dan / Lee | **Already hosted** in the tenancy. A platform with its own database would be a second copy of the same data outside the tenancy, with its own security review. |
| 5 | **Ask SACRED AI** | A Copilot Studio agent that answers questions from the per-report digests in SharePoint. | Seadrill Apps PROD; Teams app approval pending since 16 September | Dan, Lee | **Already hosted.** Reads SharePoint; unaffected by where the pages live. |

## What a migration of part 3 would and would not do

**Would remove:** the IIS server, the share, the scheduled task and the service account for it, the server backup and
the DNS and hosting rows on ISIT's gap list. That is the hosting burden, and it is real.

**Would not remove:** the posting contract (part 1 posts a file; something has to receive and index it), the
notification flows (part 2 stays and needs the new page links), the data model (the scanner's export is the schema;
it would feed the platform's store instead of, or as well as, Fabric), the authenticated path for rig users (needed
either way; the sandbox has none), the heavy-window load (7 to 10 day periods where a rig posts many large files),
the rig connectivity problem (a rig that cannot reach the sacred server will not reach a hosted app unless the
platform is reachable from the rig network, which has to be checked first), the security review (a hosted platform
holding rig reports with names and photographs is a larger review than static files on an internal server, not a
smaller one), or the training and the people side.

**Would add:** a build of the dashboard views on the platform (the current dashboard is about 5,000 lines of
rendering logic for reports, CBM grades, compliance, AAB, precharge and Help, written against the data file's
shape), a second data store, a dependency on a vendor platform that is new to Seadrill, and a licence line.

## The honest position

SACRED's hosting footprint is already small: one static web folder and one ten-minute script. The parts ISIT find
hard to support are the ones with no platform answer: the offline rig tools, the posting contract, the flows and
the people process. A migration is worth doing if ISIT would rather support a hosted app than a Windows server and
a scheduled task, and if the platform is reachable from the rigs and passes the same security review. It is not a
shortcut past the integration work, because the integration work is in parts 1, 2 and 4, which stay where they are.

The useful first step for Viren is a half-day with the data file and the normalised export, to see whether the
platform can render the Reports and Rig Monitoring views from them. If it can, the migration question is real and
can be planned for after February. If it cannot, it is answered.

Questions: Dan Plant, Technical Superintendent, Well Control Engineering.
