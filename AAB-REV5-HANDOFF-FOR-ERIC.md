# Seadrill Bulletin Board Rev 5 — what to build next, for Eric's Claude session

**From:** the dashboard session, via Dan · **Date:** 22 September 2026
**Read with:** `AAB-LOOP-PLAN.md` (the whole loop, the decisions, who builds what)
**Rev 4 status:** read in full against Dan's 15 September brief. It meets the brief. Rev 5 is
the estate integration plus four things Dan asked for on 22 September: SFI codes, photographs,
several attachments, and load/save of the record.

## 0. Paste this into the session that built Rev 4

```
Rev 4 of the Seadrill Bulletin Board has been reviewed by the dashboard team. It meets the
brief. Build Rev 5 from it with the changes below, in this order, and stop after each for me
to check. Do not change the envelope (FileName / ContentType / FileContent), the filename
shape seadrill-aab_<number>_<rev>_<yyyyMMdd-HHmmss>.json, the sanitising, the UTF-8-safe
base64, or the validation rules. Keep every existing key; only add, and remove the two named
below. Bump the header tag to Rev 5 and toolVersion to "2.0".

1. META BLOCK. Add a top-level "meta" object to the record:
     meta: { kind: "aab", tool: "Seadrill Bulletin Board", rev: 5,
             saved: <ISO 8601 UTC, same instant as postedAt>, rigkeys: [ ...rig codes ] }
   The dashboard scanner recognises every posted file by meta.kind. There is deliberately
   NO meta.asset: an AAB is a fleet record, not one rig's report. All meta keys lower case.

2. RIG STATUS OUT. Remove the rigStatus object. Nothing on the estate writes into a posted
   file; the rig's acknowledgement is a second posted file and the dashboard computes
   status from the two. Replace it with rigNames: { <code>: <display name> } so a reader
   has the names without a lookup. rigsApplicable stays exactly as it is.

3. SFI CODES. Add a data list at the top of the script, SFI_CODES = [ { group, code, name } ],
   holding the Well Control SFI groups 331 to 336 (Dan supplies the code list with names;
   until then hold the six groups with name "to confirm"). In the Identification card add a
   multi-select "SFI code(s)" (checkbox list or a searchable picker, with "Clear"). Store as
     sfi: [ { group: "331", code: "331.02", name: "..." } ]
   Not mandatory; warn if empty. "Category / Equipment Area" stays as free text.

4. ATTACHMENTS, PLURAL. Replace the single bulletin object with
     attachments: [ { name, type, bytes, data, primary } ]
   where data is bare base64 (no data: prefix, as now), type is the file's MIME type, and
   primary is true on exactly one when any PDF is present (the bulletin itself). Accept PDF,
   DOCX, XLSX, images. Keep the "no separate attachment" checkbox; when ticked attachments
   is []. Set schemaVersion to "2.0".

5. PHOTOGRAPHS. Add a Photographs card: choose several images, each shown as a thumbnail
   with a caption box and a remove button. Compress every image in the browser to JPEG
   quality 0.82 with the long edge at most 1600 px (canvas), never crop. Store as
     photos: [ { name, caption, data } ]
   where data is a data:image/jpeg;base64,... URL. Not mandatory.

6. SIZE GUARD. Compute the size of the JSON the tool is about to post. Warn at 20 MB,
   refuse at 30 MB with a message naming the size and the largest attachments. Remove the
   old 5 MB warning.

7. LOAD JSON. Add "Load AAB file" next to "Create AAB file": a file input that reads a
   saved or posted record (schemaVersion 1.0 or 2.0) and fills the whole form, including
   rigs, SFI, attachments and photos. After a load, show a bar: "Loaded <number> Rev <n>.
   Issue as Rev <n+1>?" with one button that bumps the revision and ticks "requires
   re-acknowledgement". Nothing is posted by loading.

8. ENDPOINT. Read the intake endpoint from a gate-config.js file if one sits beside the
   page (window.PCGATE.postUrl, the way the precharge request form does; Dan supplies that
   file and it is never emailed or committed). Keep the current "Set endpoint" IndexedDB
   entry as the fallback for a copy opened from disk. Never write the URL into the page.

9. ESCAPE THE PREVIEW. The preview inserts the advisory text into innerHTML unescaped. Add
   an esc() helper and use it for every user-entered string in the preview.

10. PRINT. Make the page print as the AAB cover: header, identification, SFI, the three
    sections, references, applicable rigs, photographs as a contact sheet, attachments as
    a list of names. The PDF is the bulletin; do not redraw it.

After each step: node --check on the script block, open the file from disk, create one
AAB on the rig "West Vela" only with a small PDF and one photograph, press "Create AAB
file", and show me the saved record's meta, sfi, attachments (name/type/bytes only) and
photos (name/caption only). Do NOT press Post on any test; posting is Dan's, on his say-so.

When Rev 5 is done, update AAB-Dashboard-Handoff.md to schemaVersion 2.0: the meta block,
rigNames, sfi, attachments[], photos[], the removal of rigStatus and bulletin, and a
sentence that the acknowledgement is a separate posted file computed by the dashboard.
```

## 1. The record after Rev 5, for reference

```json
{
  "schemaVersion": "2.0",
  "recordType": "AAB",
  "recordId": "<uuid>",
  "meta": { "kind": "aab", "tool": "Seadrill Bulletin Board", "rev": 5,
            "saved": "2026-09-22T15:04:00Z", "rigkeys": ["vela", "capella"] },
  "aabNumber": "C10250746",
  "revision": 0,
  "title": "…",
  "level": 3,
  "category": "BOP — Ram Packers",
  "sfi": [ { "group": "331", "code": "331.02", "name": "…" } ],
  "issueDate": "2026-09-22",
  "dueDate": "2026-10-06",
  "requiresReacknowledgement": true,
  "originator": { "name": "Eric Rachall", "email": "eric.rachall@seadrill.com" },
  "advisory": { "whatHappened": "…", "whyItMatters": "…", "requiredAction": "…" },
  "referenceDocuments": ["NOV SB-2024-118"],
  "attachments": [ { "name": "C10250746.pdf", "type": "application/pdf", "bytes": 412331,
                     "data": "<base64>", "primary": true } ],
  "photos": [ { "name": "packer.jpg", "caption": "Extrusion at 3 o'clock", "data": "data:image/jpeg;base64,…" } ],
  "rigsApplicable": ["vela", "capella"],
  "rigNames": { "vela": "West Vela", "capella": "West Capella" },
  "expectedAcknowledgerRole": "Subsea Supervisor",
  "status": "active",
  "postedAt": "2026-09-22T15:04:00Z",
  "postedBy": "eric.rachall@seadrill.com",
  "toolVersion": "2.0"
}
```

## 2. The acknowledgement record (built by the dashboard side, shown so both ends agree)

Posted by `sacred/aab/acknowledge.html` through the same trigger, filename
`seadrill-aab-ack_<number>_<rev>_<rigKey>_<yyyyMMdd-HHmmss>.json`:

```json
{
  "meta": { "kind": "aab-ack", "tool": "AAB Acknowledgement", "rev": 1,
            "asset": "West Vela", "rigkey": "vela", "saved": "2026-09-24T08:12:00Z" },
  "aabNumber": "C10250746",
  "revision": 0,
  "action": "acknowledge",
  "by": "A. Small",
  "role": "Subsea Supervisor",
  "at": "2026-09-24",
  "comment": "",
  "photos": []
}
```

`action` is `acknowledge` or `close`; `close` carries the comment and up to six evidence
photographs. Here `meta.asset` **is** present, because an acknowledgement belongs to one rig.

## 3. Answers to the open points in Eric's handoff

- **Revision grouping:** yes, by `aabNumber`, highest `revision` current. A new revision with
  `requiresReacknowledgement: true` puts every applicable rig back to outstanding; earlier
  acknowledgements stay as history on the dashboard. With it `false`, an existing
  acknowledgement of the lower revision carries forward.
- **Malformed or duplicate files:** a file that fails to parse is listed on the dashboard's
  Errors button like any other bad post, never silently dropped. A duplicate `recordId` is
  treated as the same post (newest file wins); nothing is merged.
- **CORS:** the reporting tools and the precharge form already post to this trigger from a
  browser, so the answer is proven: the flow handles the preflight. Never use `mode:
  'no-cors'`; a `no-cors` request cannot carry a JSON body and the flow receives nothing
  while the browser reports success.
- **Which role acknowledges, response period, withdrawal, notification matrix:** Dan's
  decisions, listed with recommendations in `AAB-LOOP-PLAN.md` §5. None of them changes the
  record's shape.
