# Plan — the reporting tools offline on iPads and Android tablets

**Owner:** Dan Plant · **Built by:** the reporting-tools session · **Opened:** 13 October 2026
**Status:** WAITING ON ISIT (HTTPS). The tools build starts after the 19–20 October class, because the freeze runs from
15 October. Rolling handoff entry 75.

## What Dan wants

> *"we can store a local copy and just sync to the network when we have a connection"*

Crews install each tool on the tablet once, fill reports in with no connection, and the reports send themselves when the
connection returns.

## What is true today (checked 13 Oct on SSORT 164 / WCGRRT 169)

- **Each tool is one self-contained file.** It loads nothing from other sites, so it can run with no connection once open.
- **Posting needs only the internet.** Reports go to the Power Automate intake on Power Platform
  (`*.environment.api.powerplatform.com`), not to our server, so any connection works, rig Wi-Fi included.
- **Opening the tool needs our intranet server**, over plain HTTP on port 8080. Nothing answers on HTTPS (443, 8443, or HTTPS
  on 8080).
- **Without HTTPS, the home-screen icon is only a bookmark.** iPads and Android tablets keep an offline copy of a web app only
  when it is served over HTTPS.
- **Saving the file on the device:**

  | Device | Works? |
  |---|---|
  | Laptop | Yes |
  | Android tablet | Maybe; to test on a real device |
  | iPad | No: it previews the file without running it |

## Stages

| # | Stage | Who | When | Status |
|---|---|---|---|---|
| 1 | HTTPS for the site, a certificate the tablets trust (internal CA root via Intune), MIME types, no-cache on `sw.js`, HTTP 8080 kept or redirected. Request: `ISIT-REQUEST-HTTPS-FOR-REPORTING-TOOLS.md` | ISIT (Dan sends) | asked 13 Oct; wanted by end of October | **waiting** |
| 2 | Test the local-file route on an Android tablet: open the saved `.html` in Chrome, then Firefox; fill a section; close the tablet; reopen; post | Dan or a rig | any time | open |
| 3 | **Installable tools:** a manifest and an offline script (`sw.js`) beside SSORT and WCGRRT. The installed copy opens with no signal; a new revision is picked up at the next connection, and the badge shows which | tools session | after 20 Oct, once stage 1 is in | not started |
| 4 | **The outbox** (it touches the posting path, so it needs Dan's go): a post made offline is queued on the tablet (IndexedDB, photos included) and sent automatically when the connection returns, with a visible "n waiting / sent" count. Same files and keys as today: nothing changes for the dashboard. This also closes ORR KE-01 (SSORT's silent post failure) | tools session | with stage 3 | not started |
| 5 | **Rollout:** Intune pushes the tools to the managed tablets as home-screen apps (iPad web clip, Android managed Chrome). Otherwise crews install by hand, once per tablet, in the office or on VPN, before it goes offshore | ISIT, Dan | after stage 3 | not started |
| 6 | **The same treatment for the Argo Navis job plan checklists**, which are already one offline file with sync | tools session | after stage 3 | not started |

## Limits to say out loud

- **The first install on each tablet needs a connection to our server**, once.
- **Queued photographs sit on the tablet until they are sent.** That is fine for a shift or two offline, but not for weeks.
- **The installed app and the browser keep separate drafts.** Use one or the other on a given tablet.
- **The intake URL stays inside the tool files** (ORR KE-10). HTTPS does not change that.
