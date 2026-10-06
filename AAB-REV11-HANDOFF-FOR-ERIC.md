# Seadrill Bulletin Board — handoff to Eric for HTML edits (from Rev 11)

**From:** Dan Plant (owner, SACRED) and the dashboard session · **To:** Eric Rachall and his Claude session
**Date:** 6 October 2026 · **Base:** `seadrill-bulletin-board.html` **Rev 11** (ungated source), the file on the share today

Eric, the create page is yours. It was edited on the dashboard side for Rev 9 and Rev 11 while you were busy, always on your
source and always rebuilt with your own `build_gate.py`. This pack hands it back to you whole so you can make your edits.
**Start from the Rev 11 source in this pack, not from an older copy of your own,** or Rev 9 to 11 are lost.

## 0. Paste this into your Claude session first

> You are editing the Seadrill Bulletin Board create page (`seadrill-bulletin-board.html`, Rev 11, ungated source), a single
> HTML file used by Technical Services to issue Priority 3 Advisory AABs to the rigs. Read section 2 of the handoff (what is
> in the file) and section 3 (what must not change) before touching anything. Make only the edits asked for. Keep the
> payload, the file name and the posting code exactly as they are unless the edit is explicitly about them. Edit the
> ungated source only; build the gated copy with `build/build_gate.py`; never hand-edit the gated copy. Bump the rev tag to
> Rev 12. When done, list every change in a short note: what, why, and whether any payload key was added (never removed or
> renamed). Do not post anything to the intake endpoint while testing; use Download.

## 1. What is in this pack

| File | What it is |
|---|---|
| `seadrill-bulletin-board.html` | **Rev 11 ungated source.** The one file you edit. No endpoint URL in it. |
| `build/build_gate.py` | Your build script, unchanged. Writes `seadrill-bulletin-board-GATED.html` and `set-password.html` beside the source, with its four assertions. |
| `build/gate-fragment.html` | Your gate fragment, unchanged (SALT `seadrill-bulletin-board-gate|`). Changing it changes the password; do not. |
| `build/set-password-template.html` | Your template for `set-password.html`, unchanged. |
| `AAB-REV11-HANDOFF-FOR-ERIC.md` | This note. |

**Deliberately not in the pack:** `gate-config.js` (it holds the password hash and the intake endpoint URL; it stays on the
share and is never emailed or committed), `aab-data.js` (live rig data), and the gated copy (you build it).

## 2. What is in Rev 11, and what changed since your Rev 8

The page: header with **Rigs page** and **Fleet compliance** links; the AAB form (number, revision, title, eDocs, Maximo
parent case, category, SFI groups, issue and due dates, re-acknowledgement, withdrawal, evidence asked, originator, the
three advisory sections, reference documents); attachments with a primary flag; photographs (resized to 1600 px, JPEG 0.82);
rig selection; the size guard (warn at 20 MB, refuse at 30 MB); Preview, Print, Save Draft, Load AAB file, Download, Post.

**Changed on the dashboard side since your Rev 8** (all additive; no key renamed or removed):

| Rev | Date | Change |
|---|---|---|
| 9 | 26 Sep | `maximoParent` (optional text beside eDocs) through `buildRecord`, `applyLoaded`, preview and print. **Withdrawal** checkbox sets `status: "withdrawn"`; `validate()` refuses it on revision 0. Header links to the Rigs page and Fleet compliance (the `create.html` frame is gone). `toolVersion` 2.1. |
| 10 | 27 Sep | Wording only: the checkbox reads "This advisory asks the rig to attach evidence photographs with its acknowledgement"; preview and print say "Evidence asked of the rig: Yes — photographs with the acknowledgement / No — acknowledge only". The loop is advisory only; Technical Services close. |
| 11 | 3 Oct | **+ New AAB** in the Actions panel and **Start a new AAB** in the green message after a good post (`startNewAAB()`, `markPosted()`): clears the form to its opening state, keeps the originator name and email, asks before clearing unposted work, no question straight after a good post. **SFI names** from Dan: 302, 314, 315, 331, 332, 334, 335, 336, 337, 339 with their names; 333 gone; a loaded record carrying any code not in the list keeps it on re-post (`loadedExtraSfi`). |

Still yours from before, if wanted: the **AAB PDF** (`pdf`, `pdfName`, bare base64; the dashboard and rig page already show it
when present).

## 3. What must not change (the dashboard, the rig page, the flows and the database read these)

1. **The record, schema 2.0.** Every key `buildRecord()` writes today keeps its name and meaning: `schemaVersion`,
   `recordType`, `recordId`, `meta` {`kind: "aab"`, `tool`, `rev`, `saved`, `rigkeys`}, `aabNumber`, `revision`, `title`,
   `level`, `priority` (3), `corporateMandatory` (false), `edocsRef`, `maximoParent`, `actionRequested`, `category`, `sfi[]`
   {`group`, `code`, `name`}, `issueDate`, `dueDate`, `requiresReacknowledgement`, `originator` {`name`, `email`}, `advisory`
   {`whatHappened`, `whyItMatters`, `requiredAction`}, `referenceDocuments[]`, `attachments[]` {`name`, `type`, `bytes`,
   `data`, `primary`}, `photos[]` {`name`, `caption`, `data`}, `rigsApplicable[]`, `rigNames`, `expectedAcknowledgerRole`,
   `status`, `postedAt`, `postedBy`, `toolVersion`. **Adding a key is fine** (the scanner ignores keys it does not know);
   say so in your note so the dashboard can show it. Renaming or removing one breaks the dashboard, the rig page and the
   database export. If an edit needs that, stop and ask Dan.
2. **The rig codes** (`RIGS`): `nov` West Neptune, `auriga`, `saturn`, `jupiter`, `tellus`, `carina`, `polaris`, `vela`,
   `gemini`, `capella`, `libongos`, `quenguela`, `cam` Sevan Louisiana. The codes are the join key for acknowledgements and
   the notification workbook. A new rig is added, never renamed.
3. **The file name** `seadrill-aab_<number>_<revision>_<yyyyMMdd-HHmmss>.json` (`estateFileName()`). The timestamp keeps every
   post a new file; a repeated name would overwrite the earlier post in SharePoint and the notification flow would not fire.
4. **The posting code.** The endpoint comes only from `window.PCGATE.postUrl` in `gate-config.js` beside the page (IndexedDB
   fallback for a copy opened from disk). No URL is ever typed into the HTML. The envelope stays
   `{ FileName, ContentType, FileContent }`; a failed or refused post downloads the record; no `no-cors`.
5. **Priority 3 only.** No priority selector (Dan, 26 Sep): Priority 1 and 2 stay in the corporate process.
6. **The size guard** (20 MB warn, 30 MB refuse) and the **withdrawal rule** (never on revision 0).
7. **The gate.** Edit the ungated source only; build with `build_gate.py`; all four assertions must pass. The `<body>` then
   blank line then `<header>` layout is the script's anchor; if you move it, update the anchor deliberately. The fragment
   and SALT stay as they are, so the password Dan set keeps working.
8. **The HAZID.** The AAB HAZID (Dan, change owner; Eric, gatekeeper) relies on controls that live in this page: the preview
   and primary-attachment flag (H5), the local save and size guard on a failed post (H6), the revision and re-acknowledgement
   reset (H4), the fixed acknowledger role shown (H10). An edit that weakens any of these goes back to Dan first; the HAZID is
   the reference, not the code.

## 4. How to test without posting

- Open the ungated source straight from disk. With no `gate-config.js` beside it there is no endpoint, so **Post** cannot
  reach the intake; use **Download** to see the record your edit produces.
- Use `SSCE Equipment`-style training content only and a number such as `TRAINING-01`; tick one rig. Nothing goes to a rig
  unless it is posted, and nothing is posted from a test.
- Check: the downloaded JSON has every key in section 3; **Load AAB file** on it brings the form back unchanged; Preview and
  Print show the new content; **+ New AAB** still clears the form and keeps the originator.

## 5. How to hand it back

1. Rev tag **Rev 12** in the header (`<span class="rev-tag">`). Same file name; a revision goes inside the file, never in
   the name.
2. Run `build/build_gate.py`; keep its printed output (the four assertions and the two SHA-256 lines).
3. Send Dan three things: `seadrill-bulletin-board.html` (ungated), `seadrill-bulletin-board-GATED.html`, and a short note
   (what changed; any new payload key; the build output).
4. The dashboard session checks it the same way as Rev 8 (gated copy is the source plus the fragment, byte for byte; no URL in
   the file; every key still written), files it under `tools/received/`, and Dan saves the gated copy over
   `seadrill-bulletin-board.html` in `sacred\aab`. Ctrl+F5.

**Timing:** the tools are frozen from **12 to 20 October** for the class (Day 2, module 7 shows this page). An edit lands
before 12 October or after 20 October; nothing ships in between unless a rig is losing work.

Questions through Dan. Thank you, Eric.
