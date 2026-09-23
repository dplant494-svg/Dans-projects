# Seadrill Bulletin Board Rev 5 — what to build next, for Eric's Claude session

**From:** the dashboard session, via Dan · **Date:** 22 September 2026
**Read with:** `AAB-LOOP-PLAN.md` (the whole loop, the decisions, who builds what) · **Supplied with it:** `aab-logo-600.jpg` (the logo), `sample-reports\aab\` (four test records and a README). The password gate handoff is held for Rev 6 (§4)
**Posting:** the same HTTP intake URL every tool on the estate uses (Dan gives it directly, never in a file); the post lands in SharePoint WellControl / PostedReports, where the scanner and the flow read it. Nothing about the envelope changes.
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

11. GENERATE PDF. One function, buildAabPdf(), renders the AAB itself as a PDF with jsPDF
    embedded in the file (not loaded from a CDN, so it works from disk with no network;
    Precharge Pro Rev 81 embeds it the same way for its sheetPdf): the AAB logo top left
    (see LOGO below), Seadrill navy header bar, "LEVEL 3 ADVISORY" tag, number, revision,
    title, issue and due dates, originator, SFI codes and category, the three sections in
    order, reference documents, applicable rigs, photographs at a fixed height with their
    captions, and a list of the attachment names. It never redraws the bulletin PDF; that
    stays as its own attachment. Two buttons call the same function: "Download PDF" saves
    it locally; "Post AAB" calls it and puts the result in the record as
      pdf:     <bare base64 of the PDF bytes, no data: prefix>
      pdfName: "Seadrill_AAB_<number>_Rev<n>.pdf"
    exactly as the CBM to OEM record carries pdf / pdfName. The notification flow attaches
    it to every rig email beside the bulletin, and the dashboard shows it. Include it in the
    size guard of step 6.

12. LOGO. Embed the Seadrill Bulletin Board logo (aab-logo-600.jpg, supplied with this
    handoff, ~110 KB) as a base64 constant AAB_LOGO_B64 at the top of the script. Use it in
    the page header beside the title, on the printed cover, and in the PDF. It is the one
    image in the file; do not embed the 600 px PNG (600 KB).

13. TEST RECORDS. Four synthetic files come with this handoff (sample-reports\aab\ in the
    dashboard repository, README beside them): an AAB at revision 0, its revision 1, an
    acknowledgement and an action closure from West Vela. Load AAB file (step 7) must open
    the two AAB files and fill the form completely; Create AAB file on the loaded revision 0
    must produce a record with the same keys. The acknowledgement files are the dashboard
    side's shape, shown so both ends agree; the tool never reads them. Do not upload any of
    the four to PostedReports.

14. THE DIRECTIVE'S WORDS (DIR-37-0161 v6.07, read 23 Sep). The directive has Priorities,
    not Levels: 1 Safety Alert, 2 Bulletin / Product Obsolescence, 3 Notification / Advisory
    (information only). Rename every "Level 3" on screen, in the preview, the print, the PDF
    and the header tag to "Priority 3 — Advisory". Keep level: 3 in the record and add
      priority: 3
      corporateMandatory: false      (a Priority 3 is "Not required by Corporate, for
                                      information only"; carry that sentence on the PDF)
      edocsRef: "<eDocs number>"     (text field on the Identification card, optional;
                                      every AAB is filed in eDocs under the 0000 prefix)
      actionRequested: false         (checkbox "This advisory asks the rig to do something";
                                      when true the dashboard shows the action-closed state)
    expectedAcknowledgerRole becomes the fixed string "Technical Section Leader (each crew)":
    the directive says both TSLs acknowledge a Priority 3.

15. SFI CODE LIST. Dan does not have the 331 to 336 list to hand. Source it yourself from the
    Seadrill SFI group structure available to you (SYS-00-0034 RAMP Equipment Structure and
    Coding, or the Maximo item master by SFI group) and put it back to the dashboard side in
    your handoff as a table: group, code, name, one row per code, marked verified or
    unverified against the source you used. The tool's SFI_CODES list and the dashboard's
    test records both wait on it.

After each step: node --check on the script block, open the file from disk, create one
AAB on the rig "West Vela" only with a small PDF and one photograph, press "Create AAB
file", and show me the saved record's meta, sfi, attachments (name/type/bytes only) and
photos (name/caption only). Do NOT press Post on any test; posting is Dan's, on his say-so.

When Rev 5 is done, update AAB-Dashboard-Handoff.md to schemaVersion 2.0: the meta block,
rigNames, sfi, attachments[], photos[], pdf / pdfName, the removal of rigStatus and bulletin,
and a sentence that the acknowledgement is a separate posted file computed by the dashboard.
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
  "priority": 3,
  "corporateMandatory": false,
  "edocsRef": "",
  "maximoParent": "",
  "actionRequested": false,
  "expectedAcknowledgerRole": "Technical Section Leader (each crew)",
  "status": "active",
  "pdfName": "Seadrill_AAB_C10250746_Rev0.pdf",
  "pdf": "<bare base64 of the AAB PDF built by buildAabPdf()>",
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
  "role": "Technical Section Leader",
  "crew": "A",
  "at": "2026-09-24",
  "comment": "",
  "photos": []
}
```

`action` is `acknowledge` or `close`; `close` carries the comment and up to six evidence
photographs. `crew` is `A` or `B`: DIR-37-0161 §2.2.4 wants both crews' TSLs to acknowledge a
Priority 3, so a rig is fully acknowledged after two acknowledgements. Here `meta.asset` **is** present, because an acknowledgement belongs to one rig.

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
- **Which role acknowledges:** settled by DIR-37-0161 §2.2.4, both crews' TSLs (step 14).
  Response period, withdrawal, notification matrix: Dan's decisions in `AAB-LOOP-PLAN.md` §5.

## 4. Held for Rev 6, not in the Rev 5 prompt (Dan, 23 Sep: one round at a time)

Two further steps are ready and wait for Eric's Rev 5 handoff to come back. They are recorded here
so the next prompt is a paste, and in `AAB-LOOP-PLAN.md` item 27's Rev 6 queue.

```
A. PASSWORD GATE. The Bulletin Board issues advisories to thirteen rigs, so the served copy
    carries the estate's password gate. The pattern, its traps and its checklist are in the
    handoff supplied with this pack, "HANDOFF - Password gate pattern, portable for a new
    app" (Precharge Pro session, 23 Sep 2026). Read its §1 and §3 first. Build it the way it
    says, not a shortcut: gate overlay first in <body>; gate-config.js beside the page
    setting window.PCGATE = { hash, hint } with a SHA-256 of salt + password and never the
    password; an app-specific salt 'seadrill-bulletin-board-gate|'; fail closed when the
    config is missing (field disabled, no server path or script name on the login screen);
    unlock token in localStorage keyed on the first 12 characters of the hash, value an
    expiry (0 = never, default 12 h), every localStorage access in try/catch; a set-password
    page that self-tests SHA-256 against the two NIST vectors and refuses to run if they
    fail; hash function and salt in exactly one place (generate the set-password page from
    the gate source, as the handoff shows). Produce TWO builds from one source: the ungated
    file for offline use and email, and the gated file that alone goes to the share; assert
    at build time that the two share bodies are byte-identical and that the gate is first in
    <body>. The endpoint (step 8) reads from the same gate-config.js as window.PCGATE.postUrl.
    Write in the file header that the gate is a curtain, not a lock, in the handoff's words.

B. THE BOARD IS A SERVED, PASSWORDED DASHBOARD (Dan, 23 Sep). The gated build from step 15
    is published on the sacred server under aab\ beside the precharge pages and is the
    Seadrill Bulletin Board itself: Eric creates AABs there; every subsea superintendent and
    the offices open it to read. So the page gains a REGISTER view above the create form:
    it fetches aab-data.js from the same folder (written by the dashboard scanner every ten
    minutes; the dashboard side supplies the file's shape with the acknowledgement page)
    and lists every AAB: number, current revision, title, priority, issue and due dates,
    applicable rigs as chips coloured by state (outstanding / partly acknowledged / fully
    acknowledged / action open / closed / overdue), with the PDF and the bulletin to open.
    "New AAB" opens the create form; "Revise" loads that AAB into the form as revision n+1
    (step 7). The register is read-only; nothing on it edits a posted file. When
    aab-data.js is absent (a copy opened from disk) the register says so and the create
    form still works. Keep the file self-contained apart from gate-config.js and
    aab-data.js, both loaded relatively from the same folder.
    Record: add maximoParent: "<Maximo parent AAB case number>" (text, optional): Dan keeps
    the Maximo parent case for the corporate evaluation trail; the board replaces the child
    cases and the tick-box acknowledgement for Priority 3.

```

The password gate pattern handoff (`PASSWORD-GATE-PATTERN-HANDOFF-2026-09-23.md`) goes with step A
when it is sent. Until then the Rev 5 record's `maximoParent` field is the only trace of step B in
the prompt; it is harmless if Eric adds it early.
