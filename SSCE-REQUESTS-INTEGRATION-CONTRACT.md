# Integration contract — WCE COC Dashboard ↔ SSCE Requests Dashboard

**Audience: anyone (human or Claude) editing any of the three files this
feature touches:** `requests-dashboard/coc-source/Seadrill_WCE_COC_Dashboard.html`
(the WCE COC Dashboard, tracked here as the write-back template),
`requests-dashboard/dashboard.html` (the SSCE Requests Dashboard), and
`scripts/Update-Dashboard.ps1` (the scanner). This is the contract between
them, in the same spirit as `INTEGRATION-CONTRACT.md` for the reporting
tools.

## Why this exists

The COC Dashboard's "SSCE Equipment" cross-reference lets a rig request a
Central Spares part. Submitting downloads `ssce-request_*.json`. Dan wants an
approver to review these with a comment, and — once approved — have the part
show as unavailable/assigned on the COC Dashboard. Neither dashboard has a
live backend (both are static, offline HTML), so this is built entirely on
the file-drop-and-scan pattern already used everywhere else in this repo.

## Data flow

```
COC Dashboard "Request" button        Requests Dashboard approve/deny
  → downloads ssce-request_*.json       → downloads ssce-decision_*.json
  → saved into the SSCE Requests folder → saved into its Decisions subfolder
                    \_______________________________/
                                  ↓
                    Update-Dashboard.ps1 (scheduled)
                      - merges request + decision by requestId
                      - writes requests-dashboard/ssce-requests-data.js
                      - writes ssce-notifications-pending.json (submitted/
                        decided events, for a future Power Automate flow -
                        inert today, no flow exists yet)
                      - if cocDashboardPath is set: patches a REVIEW COPY of
                        the COC Dashboard's embedded data for every approved
                        request, never the live file
```

## File patterns (scanner-side, `scripts/Update-Dashboard.ps1`)

- `ssce-request_*.json` (config key `ssceRequestPattern` to override) and
  `ssce-decision_*.json` (`ssceDecisionPattern`) are scanned separately from
  the daily report pattern (`config.filePattern`, normally `*.json`) and are
  explicitly excluded from that scan by name — they never reach
  `dashboard/reports-data.js` or the BOP Fleet Planning Dashboard. This is
  what actually guarantees the isolation Dan asked for, not just convention.
- Both patterns are matched under the same `reportFolders` already
  configured for daily/weekly reports — Dan's real folder is
  `...\TSC REPORTING\SSCE Requests` with a `Decisions` subfolder for the
  latter.
- Matching is by `requestId` (present in both file shapes) — a decision file
  for a `requestId` not yet seen is kept as an orphan and `Write-Warning`'d,
  not silently dropped; it applies automatically once that request's file is
  scanned in.

## `ssce-request_*.json` shape (downloaded by the COC Dashboard)

```json
{
  "requestId": "ssce-<epoch-ms>-<random6>",
  "submittedAt": "2026-08-09T07:14:34.225Z",
  "sourceItem": { "rig": "...", "bop": "...", "cat": "...", "asset": "...", "oem": "...", "serial": "...", "desc": "..." },
  "ssceItem": { "asset": "...", "oem": "...", "serial": "...", "desc": "...", "status": "..." },
  "applicant": {
    "requestOriginatorEmail": "...", "priorityLevel": "1-High | 2-Medium | 3-Low",
    "siteUnit": "...", "rigManagerContact": "...", "rigOnDowntime": "Yes | No",
    "planningOrExecuting": "Planning | Executing"
  },
  "requestedEquipment": { "dateRequired": "...", "description": "...", "partNumber": "...", "serialNumber": "..." },
  "returningEquipment": { "date": "...", "description": "...", "partNumber": "...", "serialNumber": "..." },
  "afePo": { "afeNumber": "...", "poNumber": "..." },
  "justification": "...",
  "termsAcknowledged": true
}
```

`ssceItem.status` is a **certificate validity** snapshot at request time
(`"VALID"`/`"EXPIRED"`/etc, same meaning as everywhere else in the COC
Dashboard) — it is NOT an availability flag. Availability is what this whole
feature adds (see below); don't conflate the two.

## `ssce-decision_*.json` shape (downloaded by the Requests Dashboard)

```json
{
  "requestId": "ssce-<epoch-ms>-<random6>",
  "decision": "approved" | "denied",
  "comment": "free text",
  "decidedBy": "free text (name or email, not validated against any directory)",
  "decidedAt": "2026-08-09T12:00:00.000Z"
}
```

## `window.SSCE_REQUESTS_DATA` shape (scanner output, `ssce-requests-data.js`)

```json
{
  "generatedAt": "2026-08-09T08:05:40+00:00",
  "requests": [
    {
      "requestId": "...", "submittedAt": "...", "file": "ssce-request_....json",
      "sourceItem": {...}, "ssceItem": {...}, "applicant": {...},
      "requestedEquipment": {...}, "returningEquipment": {...}, "afePo": {...},
      "justification": "...", "termsAcknowledged": true,
      "decision": null | "approved" | "denied",
      "comment": "", "decidedBy": "", "decidedAt": "",
      "decisionFile": null | "ssce-decision_....json"
    }
  ]
}
```

Newest-first by `submittedAt`. `decision`/`comment`/`decidedBy`/`decidedAt`/
`decisionFile` stay at their empty defaults until a matching decision file
has been scanned in — the dashboard treats that as "Pending".

## `ssce-notifications-pending.json` shape (scanner output)

Same "small pending-events file for an external flow to read" pattern as
the existing `break-ins-pending.json` — not a live webhook call, since
nothing in this project calls out to a live endpoint. One entry per
newly-seen event (deduped across runs via `ssce-notified-state.json`, same
idiom as `notified-state.json`):

```json
[
  { "event": "submitted", "requestId": "...", "rig": "...", "priority": "...", "part": "...", "submittedAt": "..." },
  { "event": "decided", "requestId": "...", "decision": "approved", "comment": "...", "decidedBy": "...", "decidedAt": "..." }
]
```

Whenever IT's Power Platform environment ("SEADRILL-WC-DEV" per Dan's IT
thread) exists, a flow just needs pointing at wherever this file gets
deployed — no scanner code change required then.

## COC Dashboard write-back — new fields on `APP_DATA` SSCE items

Gated entirely on `cocDashboardPath` being set in `config.json` (a path to
the **live/master** COC Dashboard HTML file). If unset, this step is skipped
every run with one visible `Write-Warning` — never silent.

For every request with `decision === "approved"`, the scanner finds the
matching item under `APP_DATA.folders[id="ssce"]` by **all three** of
`asset` + `oem` + `serial` (not OEM alone — multiple physical units share an
OEM part number) and sets two fields that don't otherwise exist on any item
in this dashboard:

| Field | Type | Meaning |
|---|---|---|
| `available` | `false` (absent/`true` = available, the default for every item before this feature) | Central Spares no longer has this specific unit free |
| `assignedTo` | free text | The `applicant.siteUnit` (full rig name) from the approved request — deliberately not a 3-letter code; no rig-name-to-code table exists anywhere in this project today |

The result is written to `<same folder as cocDashboardPath>\Seadrill_WCE_COC_Dashboard_PENDING_REVIEW.html` — **a review copy, never the live file** — every run, computed fresh from the live file each time (not from a previous review copy), so it's naturally idempotent and self-healing if the live file changes for unrelated reasons (new stock added, etc). Dan reviews and manually replaces the live file when ready, the same manual-redistribution step the dashboard's own "Download updated dashboard" button already requires.

The COC Dashboard's own rendering (`requests-dashboard/coc-source/Seadrill_WCE_COC_Dashboard.html`, the "SSCE Equipment" match-list inside the item detail modal) reads these two fields: `available === false` replaces the "Request" button with a red "Unavailable — `<assignedTo>`" badge. **If the live COC Dashboard file in production is a different revision than the copy tracked here, that revision needs the same small patch** (search for `modal-ssce` in this repo's copy) or the write-back's new fields will be silently invisible to users even though they're correctly written into the data.

## Known limitations (stated plainly, not silently glossed over)

- **No authentication anywhere in this feature.** Anyone with the Requests
  Dashboard page open can approve/deny. Same trust level as every other
  dashboard in this project (no schema validation, no auth) — acceptable for
  v1 per that existing precedent, but worth knowing explicitly.
- **No live notifications yet.** `ssce-notifications-pending.json` is
  produced correctly but nothing currently reads it — it activates the
  moment a real flow is pointed at it, with zero code changes needed here.
- **Two-step approve/deny, not one click.** The approver downloads a file
  and has to save it into the right folder for the decision to take effect
  on the next scan (up to the scan interval's delay, not instant). This was
  a deliberate choice to avoid standing up a live backend (which would need
  new IT-hosted infrastructure) — see the "Approve/deny UX" discussion in
  this feature's build history if that tradeoff needs revisiting.
- **Rig name, not a short code, for `assignedTo`.** Easy to swap for a code
  table later if Dan wants one — none exists anywhere in this project today.
