# The AAB loop — Seadrill Bulletin Board to the rigs and back (loop five)

**For:** Dan, Eric Rachall, the reporting-tools session, the dashboard session
**Date:** 22 September 2026 · **Week plan item 27**
**What arrived:** Eric's `seadrill-bulletin-board.html` Rev 4, his `AAB-Dashboard-Handoff.md`,
and the brief Dan sent him on 15 September (`HANDOFF_FOR_ERIC - Seadrill Bulletin Board AAB
tool.md`). The brief was right and Eric built to it. This document is the next step: what the
tool still needs, how the return leg works, where it lives, and who builds which part.

---

## 0. The decision: a passworded Bulletin Board on sacred, like the precharge pages, not a WCGRRT tile

**Shape settled 24 September (Dan): one Seadrill Bulletin Board, not three views.** Its open
front page (`aab/bulletin-board.html`) is the rig's: choose your rig, see only what applies, acknowledge,
close with evidence. Behind the password sit the Technical Services pages: the fleet compliance
with evidence (`aab/register.html`, drawn by `aab-register.js`) and, from its **Create or revise
an AAB** button, Eric's create page; one unlock covers both. The main dashboard's AABs
tab is kept for the **corporate master AABs** (Priority 1 and 2, source to be agreed with
Corporate; Dan, 24 Sep) and carries the Priority 3 line with the counts and the two links. Eric's Rev 9
embeds `aab-register.js` in his page, after which `register.html` is a doorway only.

**Dan, 23 Sep (evening), replacing the 22 Sep wording:** the Seadrill Bulletin Board is **a separate,
passworded requests dashboard on the sacred server, the way the precharge pages are** (`sacred\aab\`
beside `sacred\precharge\`). AABs are **created there** by Eric as gatekeeper; **all the subsea
superintendents and the offices have access** to it and see the register; the rigs acknowledge on
its acknowledgement page. It is not a mailbox and not a WCGRRT tile. The main WCE Dashboard keeps a
read-only **AAB tab** for the fleet compliance view. Both read the same `aab-data.js` the scanner
writes. Three reasons the shape holds:

1. **Different user, different side.** WCGRRT is a rig-side reporting tool that thirteen rigs
   download; an AAB is issued from the office by one gatekeeper. The Bulletin Board is an office
   app served from the estate, with the same password gate the precharge pages carry (the Precharge
   Pro session's gate handoff, step 15 of Eric's handoff); Eric's tool file is its source.
2. **The acknowledgement is a dashboard act, exactly as the precharge request is.** The rig does
   not need a tool install; `sacred\aab\acknowledge.html` shares the gate and the origin with the
   Bulletin Board, so one unlock opens both. (West Gemini cannot reach `sacred` today, item 24; the
   email carries the PDF and Gemini acknowledges by reply until the route is fixed.)
3. **WCGRRT gets a read-only "open AABs for this rig" view later**, a fetch of `aab-data.js`, no
   posting, no keys; a REV item for the tools session after the loop is live.

So: **Bulletin Board Rev 5** (Eric's source; served gated under `sacred\aab\`: create, register,
per-rig status) · **acknowledgement page** (ours, same folder, same gate) · **scanner + `aab-data.js`
+ the read-only AAB tab on the main dashboard** (ours) · **AAB Notifications flow** (Dan builds from
our guide; one email per applicable rig and one to the office, from the existing notification
workbook's Rigs, Office and Superintendents sheets, the same pattern as the precharge and CBM to
OEM flows). Same four parts as the precharge loop.

## 1. The loop, as it will run

```
 OFFICE (Eric)                         ESTATE                              RIG
 ─────────────                         ──────                              ───
 Seadrill Bulletin Board Rev 5
   fill AAB, SFI codes, rigs,
   PDFs, photos, due date
   [Save JSON]  ── local file, always works
   [Post AAB] ──────────► HTTP trigger ──► WellControl/PostedReports
                                             seadrill-aab_<no>_<rev>_<stamp>.json
                                                    │
                        ┌───────────────────────────┼──────────────────────────┐
                        ▼                           ▼                          │
               AAB Notifications flow        scanner (10-min task)             │
               "AAB issued" branch:          aabRecords[] grouped by number,   │
               one email per applicable      highest revision current;         │
               rig: SS, TSL, OIM, ARM,       aab-data.js written for the       │
               Rig Manager (Rigs sheet),     acknowledgement page;             │
               CC Office + Eric,             dashboard AAB tab: overdue count  │
               PDFs attached, link to        first, then % acknowledged        │
               the AAB on the dashboard                                        │
                        │                                                      │
                        └─────────────── email ──────────────────────────────► │
                                                                               ▼
                                                              opens sacred/aab/acknowledge.html?rig=<key>
                                                              sees open AABs for the rig, the PDF, the text
                                                              [Acknowledge]  name, role, date
                                                              [Close action] name, date, comment, photos
                                                                               │
                        ┌───────────────────── HTTP trigger ◄──────────────────┘
                        ▼                    seadrill-aab-ack_<no>_<rev>_<rigKey>_<stamp>.json
               AAB Notifications flow
               "acknowledged" / "closed" branch:
               email Eric + Office: "<rig> acknowledged <no> Rev <n>"
                        │
                        ▼
               scanner: aabAcks[] joined to aabRecords[] on number + revision + rigKey
               → per-rig status on the dashboard; a new revision with
                 requiresReacknowledgement resets every rig to outstanding,
                 the earlier acknowledgements stay as history
                        │
                        ▼
               overdue: scanner writes aab-overdue-pending.json (like ssce-notifications-pending.json)
               → flow chases the rig contacts and Eric, one email per overdue AAB per rig, once a day
```

Standing rules, inherited whole: transport byte-identical; filenames not load-bearing beyond
the trigger's prefix filter; posted files are **never modified** by anything downstream; the
flow renders nothing; the scanner computes, the tools post.

## 2. One correction to Eric's contract before anything is built on it

Eric's handoff says `rigStatus` in the posted record is "where the dashboard writes back".
**Nothing on this estate writes into a posted file.** The scanner caches by size and
modification time, SharePoint keeps version history, the notification flow triggers on file
*creation*, and the whole audit trail rests on a post being what the tool posted. The rig's
acknowledgement is therefore **a second posted file** (`seadrill-aab-ack_*`), and the status
per rig is **computed by the scanner** from the two files, exactly as the precharge loop
computes "issued" from the request and the issued sheet.

So in Rev 5 `rigStatus` goes: `rigsApplicable[]` (codes) plus `rigNames{}` (code → display
name) is all the record needs. Nothing is lost: the tool never filled those nulls anyway.

## 3. What Rev 4 does well, and what it needs (the review)

Read line by line against the brief and the estate rules. Kept as is: the branding, the
validation (blocks on the essentials, warns on the unusual, names what is missing), the local
file fallback on every failure path, the HTTP status and server text on a failed post, the
unique filename with number, revision and timestamp, the sanitised components, the UTF-8-safe
base64, the rig list held as data with the thirteen names character for character, the
`.noprint` class, the revision tag in the header, the open decisions written at the top of the
script as constants rather than buried. That is the brief, delivered.

What Rev 5 adds or changes, in the order it matters:

| # | Item | Why | Payload effect |
|---|---|---|---|
| 1 | **A `meta` block**: `{ kind: 'aab', tool: 'Seadrill Bulletin Board', rev: 5, saved: <ISO UTC>, rigkeys: [...] }` | The scanner recognises every post by `meta.kind` (`oem-copy`, precharge, SSCE all work this way); `recordType: 'AAB'` stays as well. `meta.asset` is deliberately absent: an AAB is a fleet record, not one rig's, and the scanner must not file it under a rig | new keys, additive |
| 2 | **SFI codes**, multi-select from a data list at the top of the file (`SFI_CODES`), stored as `sfi: [{ group: '331', code: '331.02', name: '...' }]` | Dan: category by SFI, the Well Control groups 331 to 336, which is how Maximo and the item exports already key equipment (`MAXIMO-ITEM-EXPORT-PROFILE.md`). `category` stays as free text for the words. **Dan supplies the 33x code list**; until then the list holds the six groups with names to confirm | new key `sfi` |
| 3 | **Several attachments, not one**: `attachments: [{ name, type, bytes, data }]`, PDFs and other documents; `bulletin` (singular) removed; a "primary" flag on the one that is *the* bulletin | Dan: more PDFs. Same shape as WCGRRT REV 161's `attachments[]`, which the dashboard already renders, so the viewer code is shared | `bulletin` → `attachments[]`, `schemaVersion` `2.0` |
| 4 | **Photographs**: `photos: [{ name, caption, data }]`, JPEG at quality 0.82 and 1600 px on the long edge, the tools' evidence rule, `data` a `data:image/jpeg;base64,` URL | Dan: attaching pictures. Same compression as the reporting tools so a picture is a picture across the estate | new key `photos` |
| 5 | **Load JSON**: a file input that restores the whole form from a saved or posted record; when loaded, offer `revision + 1`, tick *requires re-acknowledgement*, keep the originator | Dan: load and save. Revisions are the normal case for an AAB and today Eric would retype one. Later, *Load latest posted* through the Get Latest Report flow (item 21) with the `seadrill-aab_` prefix | none |
| 6 | **Size guard**: warn at 20 MB, refuse at 30 MB of total post | The transport's practical limit, the same numbers as Post to OEM. Rev 4 warns at 5 MB and never refuses | none |
| 7 | **Endpoint from `gate-config.js`**, the way the precharge request form reads it, with the IndexedDB entry kept as the fallback for a copy opened from disk | The brief's own advice: read it from an existing tool at build time so the two cannot drift. `gate-config.js` is gitignored and never travels in a file | none |
| 8 | **Escape user text in the preview** | `pv-body.innerHTML` inserts the advisory text raw; an `<` in "what happened" breaks the preview, and a pasted tag runs. One `esc()` helper | none |
| 9 | **A printable AAB page** using the existing `.noprint` rules: header, identification, the three sections, references, SFI, rigs, photos as a contact sheet, attachments as a list | The rig prints the advisory from the dashboard or the email; the PDF is the bulletin, the page is the cover. One renderer per artefact: the page does **not** redraw the PDF | none |
| 10 | **`expectedAcknowledgerRole` becomes a real value** once Dan decides (§5) | Today a placeholder string is posted in every record | value only |
| 11 | **`status`**: `active` today; `withdrawn` posted as a new revision with `status: 'withdrawn'` once Dan decides withdrawal exists | The reserved field already exists; the scanner will treat a withdrawn revision as closing every rig's outstanding state, history kept | value only |
| 12 | **Rig list**: add `stack` later only if Dan says an AAB can apply to one West Vela stack and not the other | Brief §4 | none today |

Nothing in the list changes the envelope, the filename shape or the posting path. Rev 4's
record with `schemaVersion 1.0` will still be read by the scanner (`bulletin` accepted as a
one-element `attachments[]`), so Eric can post before Rev 5 ships without leaving a stranded
file.

## 4. The dashboard side (ours)

**Scanner, v2.62 or so, `aabRecords[]` / `aabAcks[]` / `aabStatus[]`:**

- `seadrill-aab_*` or `meta.kind: 'aab'` or `recordType: 'AAB'` → `aabRecords[]`, never in
  `reports[]`, `problems[]`, the digests or the server report copies (the `oem-copy` pattern).
  Grouped by `aabNumber`; highest `revision` is current; every revision kept.
- `seadrill-aab-ack_*` or `meta.kind: 'aab-ack'` → `aabAcks[]`: `{ aabNumber, revision,
  rigKey, rig, action: 'acknowledge' | 'close', by, role, at, comment, photos, file }`.
- `aabStatus[]`: one row per current AAB per applicable rig: `outstanding | acknowledged |
  closed | overdue`, from the current revision's due date and the newest ack for that
  number + revision + rigKey. A new revision with `requiresReacknowledgement: true` resets
  the rig to outstanding; earlier acks remain in `aabAcks[]` as history. A withdrawn
  revision closes everything.
- `aab-data.js` written beside `reports-data.js` and deployed to `sacred\aab\` for the
  acknowledgement page: the current AABs, their text, attachments and photos, per-rig
  status. Attachments and photos are in it (the rig needs the PDF); size is bounded by
  the 30 MB post guard per AAB and by AABs being few.
- Three rules from the HAZID (`AAB-HAZID-DRAFT.md` §4): `Archive-ProblemFiles.ps1` never
  moves an AAB or an acknowledgement file; "acknowledged, action open" is its own state and
  colour, distinct from closed; the dashboard shows a stale-data banner when the scanner has
  not run for two hours.
- `aab-overdue-pending.json` into the repo root, like `ssce-notifications-pending.json`,
  one row per AAB per rig that is past due and not acknowledged, written once per day per
  row, for the chase branch of the flow.

**The AAB is a PDF too (Dan, 23 Sep):** Rev 5 renders the advisory itself with jsPDF, one
function for the Download PDF button and for the record (`pdf`, `pdfName`, the CBM to OEM shape),
so the rig email carries the AAB cover beside the bulletin and the dashboard shows it. The
Seadrill Bulletin Board logo (`tools/received/aab-logo-600.jpg`) goes on the tool header, the
PDF, the rig email and the dashboard tab.

**Dashboard, AAB tab (Dan, 23 Sep: yes, beside Rig Monitoring and the others):** the KPI is **overdue count first, then % acknowledged** (Dan, 15
Sep: one old unacknowledged AAB must be visible, not averaged away). Then the list: number,
revision, title, SFI, issued, due, applicable rigs as chips coloured by status, open the
record (three sections, references, photos, attachments with download links, the same
Attachments renderer as reports), revision history, acknowledgement history per rig.
Fleet view and per-rig view, the way the rest of the dashboard works.

**Acknowledgement page, `aab\acknowledge.html` on `sacred`, sharing the Bulletin Board's password gate and origin (one unlock opens both):** rig from `?rig=<key>` or a
dropdown; lists that rig's open AABs from `aab-data.js` with the text, the photos and the
PDF; **Acknowledge** (name, role, crew A or B, date; DIR-37-0161 §2.2.4 wants both crews' TSLs on a Priority 3) and **Close action** (name,
date, comment, up to six photos as evidence); posts `seadrill-aab-ack_<no>_<rev>_<rigKey>_
<stamp>.json` through the HTTP trigger read from `gate-config.js`, and downloads the file
instead on any failure. Rev tag in the header. Behind the same gate as the Bulletin Board (Dan, 23 Sep: the board is
passworded like the precharge pages); acknowledging is signed by name, role and crew, and the
record is the audit trail.

## 5. Decisions Dan owns (updated 23 Sep after DIR-37-0161 v6.07 and DIR-37-0015 v1.08 were read)

| # | Decision | State |
|---|---|---|
| 1 | Response period | 14 days stays as the default; DIR-37-0161 sets none for a Priority 3 (the discipline manager sets a closure date per AAB, §2.2.3) |
| 2 | Who acknowledges | **Settled by the directive:** for a Priority 3, "both TSLs must review the AAB and acknowledge" (§2.2.4). The acknowledgement page records the TSL's name and crew; a rig is fully acknowledged when both crews' TSLs have acknowledged, partially until then. The Rig Manager, ARM and OIMs acknowledge Priority 1 and 2 only, which stay in Maximo. Action closure is optional on a Priority 3 (§2.2.4: typically no follow-up) and is used when the gatekeeper marks "action requested" |
| 3 | Notification matrix | the existing workbook: Rigs sheet columns (SS, TSL, OIM, ARM, Rig Manager, and the Rig Engineer where there is one), `Office` for the CC, Eric from the record |
| 4 | Withdrawal | a new revision with `status: 'withdrawn'`; acknowledgements kept as history |
| 5 | Acknowledgement page | its own page under `aab\`, §4 |
| 6 | SFI list | Dan sends the 331 to 336 code list with names |
| 7 | Chase cadence | daily at 07:00 |
| 8 | **Terminology** | the directive's word is **Priority** (1 Safety Alert, 2 Bulletin / Product Obsolescence, 3 Notification / Advisory). Tool, record, documents and dashboard say Priority 3 Advisory; the record keeps `level: 3` and adds `priority: 3` |
| 9 | **Scope** | **Settled, Dan 23 Sep:** every Priority 3 advisory that WCE Technical Services issues is created on the Bulletin Board by the gatekeeper, including ones he derives from OEM notifications. The board is not a mailbox: the common mailbox, the Document Controller's eDocs filing and the Maximo parent case stay exactly as DIR-37-0161 says; the board replaces the Maximo child cases and the tick-box acknowledgement for this priority |
| 10 | **Maximo parent case** | **Settled, Dan 23 Sep: yes.** The parent AAB case is kept for the corporate evaluation trail (DIR-37-0161 §2.2.2), marked "distributed via the Seadrill Bulletin Board"; the child cases and the acknowledgement are on the board and the dashboard. eDocs filing continues; the record carries the eDocs reference and the Maximo parent number |
| 11 | **Route to go-live** | **Settled, Dan 23 Sep: always a pilot under a documented DIR-00-0011 deviation, with the MOC and the HAZID as its basis**, while the DIR-37-0161 revision (owner Arnaud Gabaut, approver VP Technical Services & ISIT) goes through. The deviation case is connected to the MOC case; its end date is the directive revision date |
| 12 | **Synergi case type** | **open:** the Seadrill-change (system change) type name in Synergi; the CAR26 example is the Physical Changes type, which is not ours |

## 5a. Rev 6 queue for the Bulletin Board (held until Eric's Rev 5 handoff is back; Dan, 23 Sep: do not overload him)

| # | Item | Written up in |
|---|---|---|
| A | The password gate on the served copy: two builds, app-specific salt, fail closed, set-password page, config never a build artefact | `AAB-REV5-HANDOFF-FOR-ERIC.md` §4 step A, with `tools/received/PASSWORD-GATE-PATTERN-HANDOFF-2026-09-23.md` |
| B | The board as a served, passworded requests dashboard under `sacred\aab\`: the register view reading `aab-data.js`, New AAB, Revise, per-rig state chips, `maximoParent` on the record | `AAB-REV5-HANDOFF-FOR-ERIC.md` §4 step B; the `aab-data.js` shape comes from the dashboard side with the acknowledgement page |

Rev 5 stays at steps 1 to 15 (the estate integration, SFI, attachments, photographs, load and save,
size guard, endpoint, escaped preview, print, Generate PDF, logo, test records, the directive's
wording, and sourcing the SFI list).

## 6. Who builds what, in order

| Step | Owner | Needs first | Deliverable |
|---|---|---|---|
| 1 ✅ Rev 8 + schema 2.0 handoff received 24 Sep | Eric's Claude session | `AAB-REV5-HANDOFF-FOR-ERIC.md` (this pack), the logo, `sample-reports/aab/` | Bulletin Board **Rev 5**, an updated dashboard handoff with the `meta` block, `sfi`, `attachments[]`, `photos[]`, `pdf`/`pdfName`, Load AAB file proven on the two test records, one saved test record on `West Vela` only, **not posted** |
| 2 ✅ built 24 Sep (scanner v2.65, AABs tab, `aab/acknowledge.html`, `AAB-INSTALL-GUIDE.md`) | dashboard session | `sample-reports/aab/` (four records, expected state in its README) | scanner `aabRecords[]` / `aabAcks[]` / `aabStatus[]`, `aab-data.js`, the AAB tab, the acknowledgement page; tested on the test set with a synthetic ack |
| 3 guide written 24 Sep: `AAB-NOTIFICATIONS-FLOW-GUIDE.md` | Dan, guide from us | steps 1 and 2 | **AAB Notifications** flow: issued branch, acknowledged/closed branch, overdue chase; test mode from the first minute; `Settings` obeyed |
| 4 | Dan + Eric | step 3 in test mode | end to end: Eric posts a real AAB on one rig with Dan's address on that rig's row; acknowledge from the page; the chase fires on a due date set to yesterday |
| 5 | Eric | live | the directive advisory and the draft MOC his brief already asks for, now written against how the loop actually runs |
| 6 | reporting-tools session, later | `aab-data.js` on `sacred` | WCGRRT tile "Open AABs for this rig", read-only |

**State on 24 September 2026.** Steps 1 and 2 are done. Eric's Rev 8 is the gated build from
his own build script (verified byte-identical to the ungated source plus the fragment; his
`sha256()` checked against Node's; endpoint from `gate-config.js` only). The dashboard side is
built and tested on the synthetic set: four sample records plus synthetic acknowledgements give
outstanding, partly acknowledged, closed and overdue states, the chase file fires once per day,
the acknowledgement page posts the ack record and downloads it when the endpoint is down. Not
yet built by Eric, by his own account: the AAB PDF (jsPDF could not be fetched whole), the
register view on the board (Rev 6 queue B), `maximoParent`, withdrawal. Reply and the Rev 9
list: `AAB-REV8-REPLY-FOR-ERIC.md` (the Rev 5 prompt pack `AAB-REV5-HANDOFF-FOR-ERIC.md` is answered by it). Next: Dan
installs (`AAB-INSTALL-GUIDE.md`), builds the two flows (`AAB-NOTIFICATIONS-FLOW-GUIDE.md`),
and the first TEST advisory goes round the loop in test mode (step 4).

## 7. What is deliberately not in this plan

- No Maximo write-back. The directive moves Level 3 off Maximo; the AAB record and the
  acknowledgement record are the system of record for Level 3.
- No Levels 1 and 2. Dan is reviewing the directive; the `level` field carries a 3 and
  the pipeline would accept another number, but nothing is built for it.
- No per-stack AABs on West Vela until Dan says one is needed.
- No editing of a posted file, anywhere, ever.
