# AAB Record Handoff — Seadrill Bulletin Board → Dashboard

**From:** Eric Rachall (AAB gatekeeper, Technical Services — WCE)
**Purpose:** Describes the exact JSON record produced by the Seadrill Bulletin Board tool when a Level 3 Advisory AAB is issued. This is the contract the dashboard's ingestion should read against.
**schemaVersion 2.0** — see **Changes from 1.0** at the end. Rev 4's `schemaVersion "1.0"` records (with a single `bulletin` field and no `meta`/`sfi`/`photos`) may still exist; the scanner should keep accepting them rather than treating them as stranded.

## How records arrive

Each AAB (and each revision of an AAB) is sent as a single HTTPS POST from the
Bulletin Board tool to the estate's Power Automate intake endpoint, which
files it for the dashboard scanner. This is the estate's standard envelope
(fixed shape, not specific to this tool):

```json
{
  "FileName":    "seadrill-aab_<aabNumber>_<revision>_<yyyyMMdd-HHmmss>.json",
  "ContentType": "application/json",
  "FileContent": "<base64 of the AAB JSON record below, UTF-8 safe>"
}
```

`FileContent`, once base64-decoded, is exactly the AAB record described under
**Top-level record** below. Example `FileName`:
`seadrill-aab_C10250746_0_20260920-143000.json`.

Each revision is posted as a **new, independent file** — the tool never
overwrites or edits a prior post. The dashboard is responsible for grouping
revisions of the same AAB using the `aabNumber` field inside the decoded
record (see below) and treating the highest `revision` as current.

**The acknowledgement is a separate posted file, not a write-back into this
one.** Nothing on the estate edits a posted AAB file after the fact. When a
rig acknowledges or closes an action, that's posted as its own file through
the same trigger — filename `seadrill-aab-ack_<aabNumber>_<revision>_<rigKey>_<yyyyMMdd-HHmmss>.json`
— and the dashboard scanner computes each rig's status by joining the two
on `aabNumber` + `revision` + rig code. That acknowledgement record is built
on the dashboard side, not by this tool, so its exact shape is the dashboard
team's own contract — it's shown here only so both ends agree on the join:

```json
{
  "meta": { "kind": "aab-ack", "tool": "AAB Acknowledgement", "rev": 1,
            "asset": "West Vela", "rigkey": "vela", "saved": "2026-09-24T08:12:00Z" },
  "aabNumber": "C10250746",
  "revision": 0,
  "action": "acknowledge",
  "by": "A. Small",
  "role": "Subsea Supervisor",
  "crew": "A",
  "at": "2026-09-24",
  "comment": "",
  "photos": []
}
```
`action` is `"acknowledge"` or `"close"`; `close` carries `comment` and up to six evidence `photos`. `crew` is `"A"` or `"B"` — DIR-37-0161 §2.2.4 (per AAB-RIG-WORKFLOW-PRIORITY3.md, 23 Sep) wants both crews' TSLs to acknowledge a Priority 3, so a rig should be treated as fully acknowledged only once both crews have a matching acknowledgement for the current `aabNumber`+`revision`+`rigKey`, not after just one. **Caveat:** this crew/TSL requirement is implemented here from a secondhand summary of directive v6.07 — the copy of DIR-37-0161 on file is v6.06 — so please confirm against the actual v6.07 text before this compliance logic goes live. Note `meta.asset` **is** present here — unlike the AAB record's `meta` below, an acknowledgement belongs to one rig.

**Unknown/extra keys should be ignored** by the dashboard, so this schema can
grow over time without breaking ingestion. The keys below are the ones the
dashboard needs to route and display correctly.

## Top-level record (decoded `FileContent`)

| Key | Type | Required | Meaning |
|---|---|---|---|
| `schemaVersion` | string | yes | `"2.0"` currently. `"1.0"` (Rev 4) records may still exist — see **Changes from 1.0**. |
| `recordType` | string | yes | Always `"AAB"`. |
| `recordId` | string | yes | A generated unique ID (UUID) for this specific file/post. |
| `meta` | object | yes | `{ kind: "aab", tool: "Seadrill Bulletin Board", rev: 5, saved: <ISO 8601 UTC>, rigkeys: [...] }`. The scanner should recognise every AAB post by `meta.kind === "aab"` (same pattern as other posted record types on the estate). **`meta.asset` is deliberately absent** — an AAB is a fleet record, not one rig's, and must not be filed under a single rig. `meta.rigkeys` duplicates `rigsApplicable` for convenience. |
| `aabNumber` | string | yes | The AAB number, e.g. `"C10250746"`. Typically one letter (usually `C`) followed by 8 digits, but the tool does not enforce this strictly. **Use this to group revisions of the same advisory.** |
| `revision` | integer | yes | Revision number, starting at `0`. Higher = more recent for a given `aabNumber`. |
| `title` | string | yes | Short descriptive title. |
| `level` | integer | yes | Always `3` for records from this tool. |
| `priority` | integer | yes | Always `3`. New — matches DIR-37-0161's actual terminology (Priorities, not Levels). Same value as `level`; both are kept rather than one being dropped, since existing consumers may already key on `level`. |
| `corporateMandatory` | boolean | yes | Always `false` for a Priority 3, per the directive's own wording: "Not required by Corporate, for information only." |
| `edocsRef` | string | yes (may be empty `""`) | Optional eDocs filing reference the originator can enter (every AAB is filed in eDocs under the `0000` prefix per the directive). Free text, not validated. |
| `actionRequested` | boolean | yes | Whether this advisory asks the rig to do something. When `true`, the dashboard should show an action-closed state for each rig in addition to acknowledgement; when `false`, acknowledgement alone is the whole lifecycle for that rig. |
| `category` | string | yes | Free-text category/equipment area. Not from a controlled vocabulary. |
| `sfi` | array of objects | yes (may be empty `[]`) | `[{ group: "331", code: "331", name: "..." }]`. Well Control SFI groups 331–336. **Names are currently placeholder `"to confirm"` strings** — Dan is supplying the real 33x code list; until then, treat `name` as provisional. Not mandatory on the originator's side. |
| `issueDate` | string (ISO date, `YYYY-MM-DD`) | yes | Date the advisory was issued. |
| `dueDate` | string (ISO date, `YYYY-MM-DD`) | yes | Date by which rigs must close their action. Guaranteed `>= issueDate`. |
| `requiresReacknowledgement` | boolean | yes | If `true`, every applicable rig resets to outstanding for this revision even if it acknowledged an earlier one; earlier acknowledgements are kept as history, not discarded. |
| `originator` | object | yes | `{ name, email }`. |
| `advisory` | object | yes | `{ whatHappened, whyItMatters, requiredAction }` — three free-text sections, display in this order. |
| `referenceDocuments` | array of strings | yes (may be empty `[]`) | Free-text reference documents / OEM bulletin numbers, one per line as entered. |
| `attachments` | array of objects | yes (may be empty `[]`) | Documents attached to the AAB — PDFs, DOCX, XLSX, images. See below. Replaces the old singular `bulletin` field. |
| `photos` | array of objects | yes (may be empty `[]`) | Evidence photographs. See below. |
| `rigsApplicable` | array of strings | yes (at least 1 entry) | Rig codes this AAB applies to. See **Rig codes** below. |
| `rigNames` | object | yes | `{ <code>: <display name> }` for every code in `rigsApplicable`, so a reader has names without a lookup. **Replaces `rigStatus`** — see **Changes from 1.0**. |
| `expectedAcknowledgerRole` | string | yes | Currently `"Technical Section Leader (each crew)"` — per DIR-37-0161 §2.2.4 (both TSLs acknowledge a Priority 3), as summarized in AAB-RIG-WORKFLOW-PRIORITY3.md. Same v6.07-vs-v6.06 caveat as above applies. Treat as display text, not a hardcoded enum, in case it's revised. |
| `status` | string | yes | `"active"` today. Reserved: a withdrawn AAB is expected to be posted as a **new revision** with `status: "withdrawn"` once Dan confirms withdrawal — a withdrawn revision should close every applicable rig's outstanding state, with acknowledgement history kept. No withdrawal is built on the tool side yet. |
| `postedAt` | string (ISO 8601 datetime, UTC) | yes | When the record was generated/posted by the tool. Same instant as `meta.saved`. |
| `postedBy` | string | yes | Email of the originator at post time (matches `originator.email`). |
| `toolVersion` | string | yes | `"2.0"`. |

### `attachments[]` item

| Key | Type | Notes |
|---|---|---|
| `name` | string | Original filename. |
| `type` | string | MIME type as read from the file (PDF, DOCX, XLSX, or an image type). |
| `bytes` | integer | Size of the decoded file, in bytes. |
| `data` | string | **Bare base64** — no `data:` URI prefix. Decode directly. |
| `primary` | boolean | `true` on exactly one attachment when any PDF is present — that one is *the* bulletin. At most one `true` per record. |

No hard cap is enforced per-attachment; the tool guards the **total posted payload**: it warns the originator at 20 MB and refuses to post above 30 MB. Don't assume small payloads, but 30 MB is the practical ceiling from this tool.

### `photos[]` item

| Key | Type | Notes |
|---|---|---|
| `name` | string | Original filename. |
| `caption` | string | Free text, may be empty. |
| `data` | string | **Full data URI** — `data:image/jpeg;base64,...` (unlike `attachments[].data`, this one keeps the prefix, since it's meant to be dropped straight into an `<img src>`). Always JPEG, quality 0.82, long edge capped at 1600px by the tool. |

## Rig codes

Fixed set currently in use. Codes are stable identifiers; names are for display.

| Code | Rig name |
|---|---|
| `nov` | West Neptune |
| `auriga` | West Auriga |
| `saturn` | West Saturn |
| `jupiter` | West Jupiter |
| `tellus` | West Tellus |
| `carina` | West Carina |
| `polaris` | West Polaris |
| `vela` | West Vela |
| `gemini` | West Gemini |
| `capella` | West Capella |
| `libongos` | Sonangol Libongos |
| `quenguela` | Sonangol Quenguela |
| `cam` | Sevan Louisiana |

Note the code for West Neptune (`nov`) and Sevan Louisiana (`cam`) don't obviously match the rig name — these were supplied as the existing codes in use and should be treated as opaque identifiers, not abbreviations to re-derive.

## Not yet implemented: `pdf` / `pdfName`

The Rev 5 plan calls for the tool to also render the AAB itself as a PDF (Seadrill-branded cover page) and post it as `pdf` (bare base64) / `pdfName`, alongside the existing `attachments[]`. **This isn't in the tool yet.** It depends on embedding the jsPDF library directly in the file (no CDN, works from disk), and every attempt to fetch a complete copy of that library has come back truncated — not a design choice, a tooling limitation on my end. Rather than ship a corrupted, silently-broken PDF generator, I've left it out. Records posted by the current version won't have `pdf`/`pdfName`; treat their absence as "not yet built," not as a signal to write fallback logic around.

## Changes from schemaVersion 1.0

| 1.0 | 2.0 | Notes |
|---|---|---|
| `bulletin` (object or `null`, one PDF) | `attachments[]` (array, any count, PDF/DOCX/XLSX/image) | A 1.0 `bulletin` maps onto a one-element `attachments[]` with `primary: true` — worth handling in the scanner so old files aren't stranded. |
| `rigStatus` (object, tool wrote nulls, dashboard was meant to write back into it) | *(removed)* — replaced by `rigNames` + the separate acknowledgement file described above | **Correction, not just a rename:** nothing on the estate should ever write into a posted AAB file. Status per rig is computed by joining the AAB record to acknowledgement records, the same way other posted-record joins work on this estate. |
| — | `meta` | New. Scanner routing key. |
| — | `sfi` | New. Optional. |
| — | `photos` | New. Optional. |
| `"1.0"` | `"2.0"` | `schemaVersion` bump reflecting the above. |
| `toolVersion "1.1"` | `toolVersion "2.0"` | |

## Open questions — flagged, not guessed at

These are being settled by Dan/Eric. Listed here so the dashboard is designed to accommodate whichever way they land, rather than built around an assumed answer:

1. **Level 3 response period.** No default is set in the directive yet. The tool pre-fills Due Date as Issue Date + 14 days (a named constant in the tool's source) — Dan's team's recommendation, not yet a confirmed policy.
2. **Which role acknowledges.** Per DIR-37-0161 §2.2.4 (as summarized 23 Sep): both crews' Technical Section Leaders acknowledge a Priority 3 — `expectedAcknowledgerRole` now carries `"Technical Section Leader (each crew)"`. A rig should show as fully acknowledged only once both crews' TSLs have acknowledged (see `crew` in the acknowledgement record above). This is implemented from a secondhand summary of v6.07; the directive copy on file is v6.06 — please confirm the actual wording before this drives compliance status.
3. **Notification matrix** (who's emailed when an AAB posts, who's chased when one goes overdue) is kept as a workbook outside both this tool and the Power Automate flow, so a crew change is a cell edit rather than a rebuild. Neither the tool nor this record carries a distribution list.
4. **Withdrawal.** Recommendation: yes, as a new revision with `status: "withdrawn"`, acknowledgements kept as history. Not yet built on the tool side.
5. **Whether the AAB section needs its own acknowledgement page or reuses an existing dashboard page** is entirely the dashboard team's call.
6. **SFI code list.** Dan is supplying the 331–336 codes with names; until then `sfi[].name` is a placeholder `"to confirm"` string for every entry.

Separately, still worth confirming:

- **Revision handling**: please confirm the dashboard groups posted files by `aabNumber` and shows the highest `revision` as current; a new revision with `requiresReacknowledgement: true` resets every applicable rig to outstanding while earlier acknowledgements remain visible as history.
- **Malformed/duplicate files**: a file that fails to parse should be surfaced (e.g. an errors list on the dashboard), never silently dropped. A duplicate `recordId` should be treated as the same post (newest file wins), not merged.
- **CORS on the intake endpoint**: since the tool posts directly from a browser, the flow's HTTP trigger needs to handle the preflight and return the right `Access-Control-Allow-*` headers, and must not be called with `mode: 'no-cors'` anywhere (that mode can't carry a JSON body — the flow would receive nothing while the browser reports success).
