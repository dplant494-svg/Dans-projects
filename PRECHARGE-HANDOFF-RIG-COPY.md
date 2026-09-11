# Handoff to the Precharge Pro session — a rig-readable copy in the issued post

**From:** dashboard/scanner session · **Date:** 2026-09-11 · **Status:** request

## Why

A Power Automate flow ("Precharge Notifications") now emails the rig's Subsea
Supervisor and Technical Section Leader when an issued precharge sheet is
posted to the dashboard. Dan wants that email to carry a copy of the sheet the
rig can open and print. Today the only thing the flow can attach is the posted
JSON itself, which is not readable without Precharge Pro, and rigs may be slow
to reach the dashboard link offshore.

## Ask

When Precharge Pro posts an **issued** sheet, include one extra top-level key:

| Key | Type | Content |
|---|---|---|
| `sheetHtml` | string | a self-contained HTML rendering of the issued sheet, as it prints: rig, well, BOP, issued date, the calculated precharge table, verified-by. Inline CSS only, no external scripts, images or fonts. |

- Size guidance: well under 500 KB. The scanner's 10 MB cap is not a concern.
- The scanner ignores unknown keys, so this needs **no scanner change** and no
  change to the data contract already in force (id, rigKey, saved, the return
  leg). It is not written into `requests\` and it is not indexed.
- Requests (from the request form) do not need it.
- Not required: PDF. HTML opens on any rig PC in a browser and prints to PDF
  from there.

## What the flow will do with it

In the ISSUED email the flow attaches
`@{body('Parse_JSON')?['sheetHtml']}` as `<posted file name>.html`, alongside
the JSON. If `sheetHtml` is absent the attachment is skipped, so older posts
still send.

## Nothing else changes

Routing, folder, `prechargeDeployPath`, gate, `gate-fragment.html`, the Rev 3
request form and the calculator arithmetic are all untouched by this.

## Second ask — a unique filename for every issued post

Observed live today: an issued post is named
`seadrill-report_West-Vela_2026-09-11_precharge.json`, rig and date only.
Re-issuing the same rig on the same day (a second BOP, or a correction)
posts the same name and SharePoint **overwrites** the earlier file.

Two consequences:

1. The notification flow triggers on file *creation*. An overwrite is a
   modification, so the rig gets no email for the second sheet.
2. If the scanner has not run in the 10-minute window between the two posts,
   the first file is gone from `PostedReports` before it was ever read.

Please make the issued `FileName` unique per sheet, for example:

```
seadrill-report_West-Vela_<well sanitised>_BOP<bop>_<yyyyMMdd-HHmmss>_precharge.json
```

Keep `precharge` in the name (the flow keys on it) and keep the rest of the
POST call exactly as it is. Filenames are not load-bearing for the scanner;
it keys on `meta`, so nothing on the dashboard side changes. The request form
already does this (`seadrill-request_vela_Test-1234_20260911_precharge.json`).

## Third item — issued sheet posted with an empty well (observed 2026-09-11)

`seadrill-report_West-Vela_2026-09-11_precharge.json` (exportedAt
2026-09-11T19:18:28Z) has `meta.well: ""`, an empty Well cell in the notes
table and `prechargeData.conditions.well: ""`. The request it was issued
against was well `Test 1234` (`seadrill-request_vela_Test-1234_20260911_precharge.json`).

Please check whether opening a request from the Requests tab populates the
calculator's Well field, and whether Issue / Post refuses or warns when the
well is empty. Without the well:

- the dashboard return leg (rigKey + well) cannot flip the request to
  *issued*, and
- the rig notification email goes out with "well ," in the subject and body.
