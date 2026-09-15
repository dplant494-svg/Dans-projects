# CBM to OEM — a "Post to OEM" button, and what it posts

**To:** the reporting-tools session (SSORT, where CBM reports are done)
**From:** the dashboard / scanner session · **Date:** 15 September 2026
**Asked by:** Dan, on Dave Cargill's (NOV) request of 15 September
**Pattern:** loop three of `NOTIFICATION-LOOP-PATTERN.md`. The precharge loop is the
template; this is the same shape with a PDF attached, which Precharge Pro Rev 81
already does (`sheetPdf`).

## 1. What Dan wants, in his words

> When we complete the CBM it posts to the dashboard, but the main thing is it's
> condition based monitoring and the OEM, NOV, needs to review these as soon as they
> are posted. We cannot give them access to our internal dashboard, so we want this to
> automatically go to NOV distribution when posted. A **Post to Dashboard** and a
> **Post to OEM** button. Post to Dashboard posts as it does now, no change. Post to OEM
> automatically emails the same PDF format to the OEM distribution.

Recipients (Dave Cargill first, then six NOV engineers; Dan, Ronnie, Lee and Joao in
copy) live in the notification workbook, not in the tool and not in the flow. The tool
never sees an address.

## 2. The design, and why it is this shape

**Post to OEM posts a second, small file through the same HTTP trigger** you already
use, carrying the report's PDF. A Power Automate flow triggers on that file and emails
the PDF to the OEM list. Nothing in the transport changes; this is a new payload kind,
exactly as the precharge request was.

Why not put the PDF in the dashboard post: a CBM post is already 14–24 MB of
photographs, and the PDF holds the same photographs again, so every CBM post would
double. Why not have the tool email directly: a browser cannot send mail with an
attachment, and the addresses must not live in the tool. Why not build the PDF in the
flow: one renderer per artefact (Precharge Pro's principle 1). The PDF the OEM gets is
the PDF the engineer saw, bytes for bytes.

## 3. The payload contract

Posted as `seadrill-oem_<Rig>_<yyyy-MM-dd>_<equipment-slug>_<yyyyMMdd-HHmmss>_cbm.json`
(the timestamp makes every click unique, the lesson from the precharge Rev 80 filename
collision: the flow trigger never fires on an overwrite). Filenames are still not
load-bearing; the scanner recognises the payload by `meta.kind`.

```json
{
  "meta": {
    "kind": "oem-copy",
    "tool": "SSORT",
    "asset": "West Capella",
    "date": "2026-09-14",
    "reporttype": "CBM Inspection",
    "equipment": "Riser Adapter",
    "wce": "Bradley Waldron",
    "sourceFile": "seadrill-report_West-Capella_2026-09-14_cbm-inspection.json",
    "saved": "2026-09-15T08:00:00Z"
  },
  "oem": "NOV",
  "subject": "CBM Report - West Capella - Riser Adapter - 2026-09-14",
  "pdfName": "Seadrill_CBM_West-Capella_Riser-Adapter_2026-09-14.pdf",
  "pdf": "<base64 of the PDF bytes, no data: prefix>"
}
```

| Field | Rule |
|---|---|
| `meta.kind` | literally `oem-copy`. This is what the scanner keys on. |
| `meta.asset` | the rig, exactly as on the report post (the identity contract, unchanged) |
| `meta.date`, `meta.reporttype`, `meta.equipment`, `meta.wce` | as on the report |
| `meta.sourceFile` | the file name of the dashboard post for the same report, **if it has been posted**; blank otherwise. The dashboard matches on it first, then on rig + date. |
| `meta.saved` | ISO UTC, when the button was pressed |
| `oem` | `NOV` for now; the flow reads the recipient sheet named by this value, so a second OEM later is a second sheet, not a code change |
| `subject` | the email subject, built by the tool so the flow does not invent one |
| `pdfName` | the attachment name, the same name the Download button gives |
| `pdf` | bare base64 of the PDF bytes, the same object the Download button saves (Precharge Pro's `buildPdfDoc()` split is the model: one function builds the document, download and post both call it) |

**The scanner records the post and hides it.** It never appears as a report, never in
the Errors list, is never copied to the server or digested. The dashboard shows a green
**"Sent to NOV · date time"** chip on the matching CBM report row. Built and verified in
scanner v2.49 / dashboard 15 Sep against this contract.

## 4. Size, and the one decision in here

The email carries the PDF. Exchange limits are the constraint, not ours: 25 MB is the
common inbound ceiling and NOV's is unknown. A 48-photo CBM at 1600 px is about 11 MB as
JSON photographs; the same photographs in a jsPDF document are similar, so the PDF is
roughly the size of the post. A 100-photo report could be 20 MB+.

Please:

- **Warn at 20 MB and refuse at 30 MB** on Post to OEM, with a message that names the
  size and says the report can be split into two OEM posts (two equipment sections)
  without touching what was posted to the dashboard. Numbers to be confirmed by the first
  bounce, honestly.
- Do **not** lower the photo quality for the OEM PDF. Dan's rule on CBM evidence stands
  for the OEM copy too.

## 5. The two buttons

- **Post to Dashboard**: unchanged, byte for byte.
- **Post to OEM**: enabled only on a CBM report with a rig set (the `sdRequireRig`
  guard, same as every other post). Confirm dialog before sending: *"This emails the
  PDF of this CBM report to NOV's distribution list and copies the office. Continue?"*.
  On success, the same "posted" feedback as the dashboard post, with the words *sent to
  OEM* so nobody presses it twice. Pressing it twice is harmless (two emails), never
  destructive.
- Both buttons independent: a report can go to the dashboard only, to the OEM only, or
  both, in either order. The scanner matches the copy to the report either way.

## 6. What stays unchanged

Transport byte-identical · filenames not load-bearing · `meta.asset` the identity
contract · the dashboard post and its schema untouched · nothing added to the report
payload.

## 7. Verified on our side

Scanner v2.49 with a synthetic `oem-copy` post beside a real CBM post: the copy is
recorded (`oemCopies[]` in the payload), absent from `reports[]`, `problems[]`, the
digests and the server copies; the CBM row shows the chip with the OEM name and time.
