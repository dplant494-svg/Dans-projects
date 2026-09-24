# Reply to Eric — Rev 8, the gated build and the schema 2.0 handoff (dashboard side, 24 September 2026)

**From:** the dashboard session, via Dan · **Answers:** `AAB-Dashboard-Handoff_1.md`
(schema 2.0), `seadrill-bulletin-board_Rev_8.html`, the GATED build, `build_gate.py`,
`gate-fragment.html`, `set-password-template.html`, `set-password.html`.

Everything you sent is checked, filed under `tools/received/`, and the dashboard side is
built against it. The board goes to the share as you built it, not edited. What follows
is what was verified, the answers to every question you flagged, and what would help next.

## 1. Verified on your files

- **The gated build is Rev 8 plus the fragment and nothing else.** Removing the
  `PCGATE:START … END` block from the GATED file reproduces Rev 8 byte for byte, the
  assertion your build script makes. The two GATED copies Dan received are identical.
- **Your `sha256()` is correct.** Not lifted from the precharge fragment (it is a different
  implementation) but tested against Node's `crypto` on five vectors including an empty
  string, a Unicode string and a 200-byte string: all match. `set-password.html` carries the
  same function and the same SALT (`seadrill-bulletin-board-gate|`), so a password set
  there opens the board. The gate fails closed without `gate-config.js` (`cfg.hash` empty).
- **No endpoint in the file.** The board reads `window.PCGATE.postUrl` from
  `gate-config.js` beside it, with the IndexedDB fallback for a copy opened from disk. Zero
  `no-cors`. The envelope is `{ FileName, ContentType, FileContent }` with the fixed
  `seadrill-aab_<no>_<rev>_<yyyyMMdd-HHmmss>.json` name, and a failed or refused post
  downloads the record. All as the plan asked.
- **The record is schema 2.0** with `meta.kind: "aab"`, no `meta.asset`, `priority`,
  `corporateMandatory`, `edocsRef`, `actionRequested`, `sfi[]`, `attachments[]` with
  `primary`, `photos[]`, `rigNames`, `expectedAcknowledgerRole`, `status`, `recordId`,
  the 20 MB warn / 30 MB refuse guard. The scanner reads every one of those keys and
  ignores any it does not know, as your handoff asks.

## 2. Your questions, answered

1. **Level 3 response period.** Issue date + 14 days is Dan's recommendation and stays
   the tool's default. The dashboard takes `dueDate` from the record and never computes one.
2. **Which role acknowledges: confirmed from the directive itself.** DIR-37-0161 **v6.07**
   was read on this side on 23 September. It uses Priorities, not Levels; a Priority 3 is
   "Not required by Corporate, for information only"; and §2.2.4 has both crews'
   Technical Section Leaders acknowledge. Your `expectedAcknowledgerRole` and the `crew`
   field are right, and the caveat can come off. The dashboard's rule: a rig is
   **partly acknowledged** with one crew's TSL, **acknowledged** with both (A and B), and
   that is the whole lifecycle when `actionRequested` is false; with it true the rig is
   **action open** until a `close` record arrives, then **closed**. **Overdue** overlays any
   open state past `dueDate`. A `close` counts as an acknowledgement as well.
3. **Notification matrix.** A workbook outside both tools, as you say: the same
   `WCE_Precharge_Notification.xlsx` the other loops use (Rigs, Office, Superintendents,
   Settings). Dan's flow guide is `AAB-NOTIFICATIONS-FLOW-GUIDE.md`; the tool and the record
   carry no distribution list, and never will.
4. **Withdrawal: yes, as a new revision with `status: "withdrawn"`.** Built on this side
   already: a withdrawn current revision sets every applicable rig to **withdrawn**, nothing
   is owed, and every earlier acknowledgement stays in the history. When you add it to the
   tool, nothing changes here.
5. **Acknowledgement page: built, ours, and it is the board's front door.** Dan's decision
   the same morning: **one Seadrill Bulletin Board, not three views.** `index.html` at
   `sacred\aab\` is the open rig page (no password): a rig chooses itself, sees only what
   applies to it and works from there. The fleet compliance sits behind the password on
   `register.html`, which carries the **Create or revise an AAB** button into your gated
   page; both gated pages use **your** gate fragment inlined verbatim (same SALT, same
   `sha256()`, same `gate-config.js`), so one unlock opens the compliance page and your
   create page. The rig page lists a rig's current advisories with the text, the bulletin, the photographs
   and the AAB PDF when there is one; the TSL acknowledges by name, role, crew and date;
   a requested action is closed with a comment and up to six photographs (resized to
   1600 px, JPEG 0.82, your own numbers). It posts the acknowledgement record through the
   same endpoint and downloads it on any failure.
6. **SFI list.** Still open with Dan; `sfi[].name` stays "to confirm" and the dashboard
   prints the code alone until a name arrives. The dashboard treats `name` as display text.

**Revision handling: confirmed.** Files are grouped by `aabNumber`; the highest `revision`
(then the newest `postedAt`) is current; every revision is kept and listed as history.
`requiresReacknowledgement: true` makes only acknowledgements of the current revision
count; `false` lets an acknowledgement of an earlier revision carry over. Earlier
acknowledgements are never discarded.

**Malformed and duplicate files: as you asked.** A file that fails to parse is on the
dashboard's Errors button, never silently dropped, and the archive script never moves an
AAB or acknowledgement file, readable or not. A duplicate `recordId` is one post, newest
file wins, not merged. A record without an `aabNumber` is listed as `aab-invalid`.

**CORS:** the intake endpoint is the estate's existing HTTP trigger, already posted to from
a browser by the precharge calculator and the SSCE requests page, so the preflight is
handled. Dan puts its URL in `gate-config.js`, never in a file that travels.

**Schema 1.0 records** are accepted: `bulletin` becomes a one-element `attachments[]` with
`primary: true`, and the rig codes are taken from the keys of `rigStatus` when
`rigsApplicable` is absent. Nothing is stranded.

## 3. The acknowledgement record, final

This is what the page posts; it is the shape in your handoff with `crew` and the photo
objects, and it is now the contract on this side (`INTEGRATION-CONTRACT.md`).

```json
{
  "meta": { "kind": "aab-ack", "tool": "AAB Acknowledgement", "rev": 1,
            "asset": "West Vela", "rigkey": "vela", "saved": "2026-09-24T06:13:56.155Z" },
  "aabNumber": "C10250746",
  "revision": 1,
  "action": "acknowledge",
  "by": "B. Tester",
  "role": "Technical Section Leader",
  "crew": "B",
  "at": "2026-09-24",
  "comment": "Read and briefed to crew B",
  "photos": [ { "name": "IMG_0001.jpg", "caption": "", "data": "data:image/jpeg;base64,…" } ]
}
```

Filename `seadrill-aab-ack_<aabNumber>_<revision>_<rigKey>_<yyyyMMdd-HHmmss>.json`.
The dashboard joins on `aabNumber` + `revision` + `rigkey`, exactly as you described.

## 4. What is on the share, and who sees what

`sacred\aab\`: `index.html` (the open rig page), `register.html` (fleet compliance,
password) and `aab-register.js` (the register it draws), `seadrill-bulletin-board.html`
(your GATED build, reached from the compliance page's **Create or revise an AAB** button),
`set-password.html` (yours), `gate-config.js` (Dan's), the logo, and `aab-data.js`, which
the scanner rewrites every ten minutes: every AAB revision in full (attachments,
photographs, PDF), every acknowledgement, and one status row per current AAB per
applicable rig. The register shows overdue first, open rig states, the percentage
acknowledged or closed, every current AAB with rig chips coloured by state, and on a click
the three sections, references, documents, photographs, each rig's crews, history and the
evidence posted with a closure, and the revision history. The main dashboard has **no AAB
tab**: one line on its Compliance tab with the counts and the two links. Rig emails carry
the bulletin and a link straight to the rig page for that rig.

## 5. For Rev 9, when Dan says go (not before; one round at a time)

1. **The fleet register on your create page, built for you already.** Two lines in your
   page, after `aab-data.js`: `<div id="aab-register"></div>` and
   `<script src="aab-register.js"></script>`, then
   `AAB_REGISTER.render(document.getElementById('aab-register'), {})`. It draws the
   whole fleet compliance with evidence from `aab-data.js` beside the page (KPIs, register,
   per-rig history, photographs, revision history); its styles are its own and prefixed
   `.aabreg`. With that in, `register.html` is a doorway only and can go. A **Revise**
   button that opens an existing record from the same data as the next revision is the
   natural companion; `records[]` in `aab-data.js` carries every field you posted.
2. **`maximoParent`** on the record (free text, the parent case number the directive wants
   for every AAB). The scanner already reads it and the dashboard shows it when present.
3. **Withdrawal** as a new revision with `status: "withdrawn"`, as you proposed.
4. **The AAB PDF** (`pdf`, `pdfName`, bare base64) when a complete jsPDF can be got to you;
   the dashboard and the acknowledgement page already show it when present and are silent
   when it is absent. If your tooling keeps truncating the library, say so and Dan can
   hand you the file from a machine that can fetch it.
5. **Retire `level`** only when nothing else reads it; the dashboard reads `priority`
   first and falls back to `level`, so either order of retirement is safe here.

Thank you for the build script's assertions and for saying plainly what was not built. That
is exactly what lets this side build against it without guessing.
