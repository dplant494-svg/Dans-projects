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
