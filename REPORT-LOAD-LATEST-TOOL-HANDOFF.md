# Handoff — "Load latest posted": the reporting tool picks up a report from another device

**To:** the reporting-tools session (WCGRRT REV 162 in build, SSORT REV 147)
**From:** the dashboard / scanner session (scanner v2.60)
**Date:** 19 September 2026
**Why:** Dan's ask. A report is started on the rig office PC; someone walks out with an iPad
and wants to carry on with it; at the end of the day the PC picks it up again. Today the only
route is the local Save/Load file, which does not cross devices. The answer is the mirror of
Post: a Power Automate flow that reads the newest posted report for a rig back to the tool.
Dan builds the flow from `REPORT-LOAD-LATEST-FLOW-GUIDE.md`; this page is the tool's side.

Nothing about Post changes. The posting flow, the payload, the filename: all untouched.

---

## 1. The contract

**Request** — `POST` to the Get Latest Report flow URL, `Content-Type: application/json`,
exactly as Post does it (same fetch shape, CORS is fine, never `no-cors`):

```json
{ "secret": "<the shared secret Dan gives you>", "asset": "West Capella", "file": "" }
```

- `asset`: the rig name as the tool holds it in `meta.asset`. The flow turns spaces into
  hyphens to match the posted filename prefix `seadrill-report_West-Capella_`.
- `file`: optional. Empty means "the newest posted file for this rig, any report type". An
  exact filename means that file. Use it when the person wants a specific earlier report
  rather than the newest.
- `secret`: a shared string held in the tool file, checked by the flow. It is not a user
  password and no one types it. It exists because a read flow, unlike Post, hands data out.

**Response**

| Status | Body | Meaning |
|---|---|---|
| 200 | the posted report JSON, unchanged, `Content-Type: application/json` | load it |
| 403 | `{"error":"not authorised"}` | wrong or missing secret; show "not authorised to load" |
| 404 | `{"error":"no posted report for this rig"}` | nothing posted for that rig, or the named file is not there |
| anything else, or a network error | | the flow failed or the report is over the flow's response size; show the message and offer the dashboard route (section 4) |

The 200 body is byte for byte the file in PostedReports. It parses with the same code as
Load from file, because it is the same shape.

## 2. The button, and the four rules around it

**"Load latest posted"**, beside Load. Rules, in order of importance:

1. **Refuse over unposted changes.** If the form has changes that have not been posted (the
   REV 162 unposted-changes mark), the button does not load. It says: *"You have changes
   that are not posted. Post them first, or discard them, then load."* Loading over unposted
   work is the one way this feature can lose something.
2. **Show a receipt before replacing the form.** From the response: filename, `meta.asset`,
   `meta.reportdate`, the report type, entries, photographs, bytes, and the SharePoint modified
   time if you can get it (it is not in the JSON; the filename and `exportedAt` are). *"Newest
   posted for West Capella: seadrill-report_West-Capella_2026-09-19_daily-report.json, daily
   report dated 2026-09-19, exported 19 Sep 07:08, 1 entry, 12 photographs, 2.2 MB. Load
   it?"* Then Load or Cancel. The newest posted file may be a CBM inspection, not the daily
   the person expects; the receipt is how they see that.
3. **Load it exactly as Load from file does**, including `attachments[]`. After loading, the
   form is "posted, no changes" until they edit, so the unposted mark starts clear.
4. **The next Post replaces the file it came from.** Same `reportdate`, same filename, so the
   post receipt's replaces line applies. That is the intended handover: PC posts, iPad loads,
   iPad posts, PC loads. Last post wins, and the scanner keeps every replaced version on the
   server under `reports\_replaced\`.

Two smaller things: put the flow URL and the secret in the same place in the file as the
Post URL, with the same "never in a screenshot" comment; and if the person is offline the
button should say so in one line, not spin.

## 3. iPad: the tool must be opened from an address

Safari on an iPad does not run a local HTML file with its script. Dan drops the tool file
into `C:\TSC-Dashboard\tools\served\` and `Deploy-Dashboard.ps1` publishes it as-is to
`http://sdrlazneuiis01d.corp.local:8080/sacred/tools/<file>`, which rig Wi-Fi reaches. Post
and Load latest go to Power Automate from there exactly as from a local file. Nothing in the
tool needs to know it is served, but if there is any code path that assumes `file://` (a
relative `<script src>`, a local fragment fetch), it will show up here first.

One consequence to design for: a served page has no local Save unless the browser downloads
the file. The auto-save in browser storage covers a dropped connection; the local Save
button on an iPad produces a download into Files, which is fine as a backup and no more.

## 4. The fallback nobody has to build

Every posted report is already on the server as `dashboard/reports/<file>.js`, and the
dashboard's report list is `reports-data.js` beside it. If the flow is ever unavailable, a
person on the network can still get the JSON from there; it lags the post by one scan. Not a
tool feature, just the reason a flow outage is never a lost day.

## 5. What Dan needs from you

- The build: the button, the receipt, the four rules, in REV 162 or 163 as you see fit.
- The two failure texts (403, 404) worded for a crew member, not a developer.
- Confirmation that the served copy of the tool behaves as the local one, once Dan gives you
  the address.

The flow URL and the secret come to you from Dan directly, by handoff, not through this file.
