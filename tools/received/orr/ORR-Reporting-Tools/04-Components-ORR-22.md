# ORR 22 — Components and dependencies

**Owner:** Dan Plant, Technical Services — Subsea · **Date:** 30 September 2026
Figures verified against the live files on 1 October 2026.

---

## 1. Deployed components

Two files. That is the whole of what is deployed.

| Component | Share path | Served URL | Bytes | SHA-256 (12) |
|---|---|---|---|---|
| **SSORT** — Subsea Onboard Reporting Tool, REV 154 | `\\sdrlazneuiis01d.corp.local\SSORT\index.html` | `http://sdrlazneuiis01d.corp.local:8080/SSORT/index.html` | 6,804,809 | `f70d21f678b0` |
| **WCGRRT** — rig visit reporting (in-app title "TSC Rig Reporting Tool"), REV 167 | `\\sdrlazneuiis01d.corp.local\sacred\WCE Rig Vist Reporting Tool V0.html` | `http://sdrlazneuiis01d.corp.local:8080/sacred/WCE Rig Vist Reporting Tool V0.html` | 3,342,479 | `c916a062d457` |

Each is a **single self-contained HTML file**: markup, CSS, JavaScript, the Seadrill logos, NOV's
inspection schedules and every rig-specific test sheet, all inside the one file. No external
scripts, stylesheets, fonts or images are fetched at runtime; the tools work from `file://` on a
laptop with no network, which is how a rig uses them when the link is down.

**Also present on the share, not a supported component:**
`\\sdrlazneuiis01d.corp.local\sacred\index.html` — a stale second copy of SSORT (REV 149 content
badged REV 148). See Known error **KE-08**; it is awaiting deletion by IT.

## 2. Source of truth

| | |
|---|---|
| Revision folders | `C:\Users\danplant\Claude\Projects\Subsea Superintendent Reporting Template\SSORT REV <n>\` and `…\WCGRRT REV <n>\` |
| Interface contract with the dashboard | `DASHBOARD-ROLLING-HANDOFF.md` — every payload key change is announced there before it ships |
| Downstream consumer | the dashboard session's scanner and viewer (separate repo and owner) |

There is no source control on the tool files; each revision is a folder, and no shipped folder is
ever edited again. That is the rollback mechanism and it is stated plainly for the review.

## 3. Dependency 1 — the intake URL

Both tools POST to one Power Automate HTTP trigger, held as the constant **`REPORT_POST_URL`** in
each file.

| | |
|---|---|
| Where it lives | a literal in each tool file |
| Shape of the request | `POST`, `Content-Type: application/json`, body `{ FileName, ContentType, FileContent }` with `FileContent` the base64 of the report JSON |
| Success test | `res.ok` only |
| Override | `sd_post_url` in `localStorage` — **honoured in WCGRRT, ignored by SSORT's post** (Known error KE-05) |
| If it is unreachable | neither tool loses the report: it falls back to the TSC REPORTS folder, then Save As, then download. WCGRRT warns; SSORT does not (KE-01) |

**The URL carries its own signature and is readable by anyone who can open the tool** — raised as
KE-10 for ISIT rather than answered here. The token is deliberately not reproduced in this pack.

**Gate config:** the tools have no separate gate config file. The intake URL is the only endpoint
either tool knows.

## 4. Dependency 2 — the CBM-to-OEM notification flow

Used only by SSORT's **Post to OEM + Dashboard** button on a CBM inspection.

| | |
|---|---|
| Transport | the same intake URL and the same request shape |
| Filename | `seadrill-oem_<rig>_<date>_<equipment>_<timestamp>_cbm.json` — the timestamp means every press makes a new file and no two collide |
| Payload | `meta.kind = "oem-copy"`, `oem`, `subject`, `sourceFormat: "html"`, `pdfName`, `htmlName`, `html` (base64 of a standalone HTML report), and from REV 154 **`files[]`** — the crew's attached test records as `{name, type, data}` |
| What the flow does | attaches the HTML report **as it is** and, from Part D3, the `files[]` entries as real attachments, and emails NOV's distribution list copied to the office. **It does not convert the HTML to PDF** — the tenant's converter refused it |
| Size limits | 20 MB warns, 30 MB refuses, measured on the HTML plus the attachments |
| Owner of the flow | the dashboard side (Dan builds the flow cards); `CBM-OEM-NOTIFICATION-FLOW-GUIDE.md` |

**Notification workbook:** none is read by the tools. Recipient lists live in the Power Automate
flow, not in the tool files, and are changed on that side without a tool revision.

## 5. What the tools do NOT depend on

Stated because it shortens a support call: no database, no API beyond the single intake, no login,
no session, no server-side code, no scheduled job, no installed runtime, no browser extension, no
CDN, no external fonts. A browser and the file are the whole runtime. Chrome and Edge are what the
rigs use; the tools are also used on iPads, where Save As falls back to the share sheet.

## 6. Environment

| | |
|---|---|
| Host | `sdrlazneuiis01d.corp.local`, IIS, port 8080 |
| Shares | `\\sdrlazneuiis01d.corp.local\SSORT\` and `\\sdrlazneuiis01d.corp.local\sacred\` |
| Who can write | Dan Plant. Deletion on `sacred` needs IT — see KE-08 |
| Rigs served | thirteen |
