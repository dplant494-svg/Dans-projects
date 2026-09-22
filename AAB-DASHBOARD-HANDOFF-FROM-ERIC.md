# AAB Record Handoff — Seadrill Bulletin Board → Dashboard

**From:** Eric Rachall (AAB gatekeeper, Technical Services — WCE)
**Purpose:** Describes the exact JSON record produced by the Seadrill Bulletin Board tool when a Level 3 Advisory AAB is issued. This is the contract the dashboard's ingestion should read against.

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

**Unknown/extra keys should be ignored** by the dashboard, so this schema can
grow over time without breaking ingestion. The keys below are the ones the
dashboard needs to route and display correctly.

## Top-level record (decoded `FileContent`)

| Key | Type | Required | Meaning |
|---|---|---|---|
| `schemaVersion` | string | yes | Version of this record format. Currently `"1.0"`. Bump this if the shape changes. |
| `recordType` | string | yes | Always `"AAB"` currently. Present so this JSON can share a folder/pipeline with other record types later. |
| `recordId` | string | yes | A generated unique ID (UUID) for this specific file/post. Stable primary key if you need one independent of `aabNumber`+`revision`. |
| `aabNumber` | string | yes | The AAB number, e.g. `"C10250746"`. Typically one letter (usually `C`) followed by 8 digits, but the tool does not enforce this strictly — treat as free text. **Use this to group revisions of the same advisory.** |
| `revision` | integer | yes | Revision number, starting at `0`. Higher = more recent for a given `aabNumber`. |
| `title` | string | yes | Short descriptive title. |
| `level` | integer | yes | Always `3` for records from this tool. Present explicitly so the dashboard doesn't have to infer it, and so the same pipeline could handle other levels later if they're ever added. |
| `category` | string | yes | Free-text category/equipment area (e.g. "BOP — Ram Packers"). Not from a controlled vocabulary — display as-is. |
| `issueDate` | string (ISO date, `YYYY-MM-DD`) | yes | Date the advisory was issued. |
| `dueDate` | string (ISO date, `YYYY-MM-DD`) | yes | Date by which rigs must close their action. Guaranteed `>= issueDate`. |
| `requiresReacknowledgement` | boolean | yes | If `true`, rigs that already acknowledged a prior revision must re-acknowledge this one. Defaults to `true` when issued. |
| `originator` | object | yes | See below. |
| `advisory` | object | yes | See below. |
| `referenceDocuments` | array of strings | yes (may be empty `[]`) | Free-text reference documents / OEM bulletin numbers, one per line as entered. No structure beyond that. |
| `bulletin` | object or `null` | yes (key always present) | The attached PDF, or `null` if the originator explicitly marked the AAB as having no attachment. See below. |
| `rigsApplicable` | array of strings | yes (at least 1 entry) | Rig codes this AAB applies to. See **Rig codes** below. |
| `rigStatus` | object | yes | Keyed by rig code (same codes as `rigsApplicable`). See below — **this is where the dashboard writes back.** |
| `expectedAcknowledgerRole` | string | yes | Which role is expected to acknowledge for each rig (e.g. OIM, Subsea Supervisor, TSL). **Not yet decided on the Seadrill side** — currently always a placeholder string (`"TBD — pending decision..."`). Don't hardcode display logic against this value until it's finalized; treat it as display text only for now. |
| `status` | string | yes | Reserved for future use. **Currently always `"active"`.** Whether an AAB can be withdrawn, and what that does to existing acknowledgements, hasn't been decided — this field exists so a future `"withdrawn"` (or similar) state can be added without a breaking schema change. No withdrawal logic exists in the tool today; don't build handling for it yet. |
| `postedAt` | string (ISO 8601 datetime, UTC) | yes | When the record was generated/posted by the tool. |
| `postedBy` | string | yes | Email of the originator at post time (matches `originator.email`). |
| `toolVersion` | string | yes | Version of the Bulletin Board tool that generated this record. |

### `originator` object

| Key | Type | Notes |
|---|---|---|
| `name` | string | Editable in the tool; defaults to Eric Rachall but is not hardcoded, in case someone else ever issues an AAB from this tool. |
| `email` | string | Not strictly validated as a well-formed email by the tool (it warns, doesn't block) — treat defensively. |

### `advisory` object

| Key | Type | Notes |
|---|---|---|
| `whatHappened` | string | Free text, multi-line. What triggered the advisory. |
| `whyItMatters` | string | Free text, multi-line. Risk/consequence. |
| `requiredAction` | string | Free text, multi-line. What the rig must do. |

Display these as three labeled sections, in this order, exactly as they are the rig-facing content of the advisory.

### `bulletin` object (or `null`)

| Key | Type | Notes |
|---|---|---|
| `filename` | string | Original filename of the attached PDF. |
| `mimeType` | string | Should always be `application/pdf`, but read from the file rather than assumed. |
| `sizeBytes` | integer | Size of the decoded file, in bytes. |
| `base64` | string | The PDF file, base64-encoded, **no data-URI prefix** (i.e. not `data:application/pdf;base64,...` — just the raw base64 payload). Decode directly. |

There is no hard size cap enforced by the tool (it only warns the originator above 5 MB), so the dashboard should not assume a small payload.

### `rigStatus` object

Keyed by rig code. **The Bulletin Board tool only ever writes rigs into this object with the structure below and all values `null` inside** — it never fills in acknowledgement or closure data. This is intentionally the dashboard's space to write into as rigs respond.

```json
"rigStatus": {
  "saturn": {
    "rigName": "West Saturn",
    "acknowledged": { "by": null, "at": null },
    "actionClosed": { "by": null, "at": null, "comment": null }
  }
}
```

| Key | Type | Filled by | Notes |
|---|---|---|---|
| `rigName` | string | tool | Human-readable rig name, for display convenience without a lookup. |
| `acknowledged.by` | string or `null` | **dashboard** | Who acknowledged, once acknowledged. |
| `acknowledged.at` | string (ISO 8601 datetime) or `null` | **dashboard** | When acknowledged. |
| `actionClosed.by` | string or `null` | **dashboard** | Who closed the action. |
| `actionClosed.at` | string (ISO 8601 datetime) or `null` | **dashboard** | When closed. |
| `actionClosed.comment` | string or `null` | **dashboard** | Closure comment/notes. |

The dashboard should treat every `rigStatus` entry present in a posted file as "open" (unacknowledged, action not closed) at ingestion time, since the tool never populates these.

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

## Open questions — flagged, not guessed at

These are being settled by Dan/Eric. Listed here so the dashboard is designed to accommodate whichever way they land, rather than built around an assumed answer:

1. **Level 3 response period.** No default is set in the directive yet. The tool currently pre-fills Due Date as Issue Date + 14 days (a constant at the top of the tool's source, easy to change) — this is a placeholder, not a confirmed policy.
2. **Which role acknowledges** (OIM, Subsea Supervisor, TSL, or the rig's choice) is undecided. `expectedAcknowledgerRole` carries a placeholder string until this is settled — build the acknowledgement page's wording to read that field rather than hardcoding a role name.
3. **Notification matrix** (who's emailed when an AAB posts, who's chased when one goes overdue) is being kept as a workbook outside both this tool and the Power Automate flow, specifically so a crew change is a cell edit rather than a rebuild. Neither the tool nor this record carries a distribution list — please don't build the dashboard to expect one here.
4. **Withdrawal.** Whether an AAB can be withdrawn, and what that does to existing acknowledgements, isn't decided. The reserved `status` field (see above) exists for this; no withdrawal logic exists yet on either side.
5. **Whether the AAB section needs its own acknowledgement page or reuses an existing dashboard page** is entirely the dashboard team's call — nothing here depends on that choice.

Separately, still worth confirming:

- **Revision handling**: please confirm the dashboard groups posted files by `aabNumber` (inside the decoded record) and shows the highest `revision` as current, and confirm what should happen in the UI to a rig that had already acknowledged a lower revision when a new revision with `requiresReacknowledgement: true` arrives.
- **Malformed/duplicate files**: not yet defined — worth agreeing on how ingestion should behave if `FileContent` fails to decode/parse, or if a `recordId` is somehow duplicated.
- **CORS on the intake endpoint**: since the tool posts directly from a browser, please confirm the Power Automate flow's HTTP trigger accepts cross-origin browser calls (handles the CORS preflight and returns appropriate `Access-Control-Allow-*` headers) — otherwise the post will fail client-side even though the flow itself would have worked.
