# Handoff to the Precharge Pro session — the issued post carries the PDF itself

**From:** dashboard / scanner session · **Date:** 13 September 2026 · **Status:** request
**Follows:** `PRECHARGE-HANDOFF-RIG-COPY.md` (Rev 80 delivered `sheetHtml` and the unique filename)

## Dan's standard, in his words

> "I want the attachment in the precharge issued to look exactly the same as the
> generated PDF. This is the standard we want. There is no need to attach the .json in
> the precharge notifications."

`sheetHtml` was the right first step and it is faithful to the screen. But "exactly the
same as the generated PDF" has only one guaranteed answer: send the PDF. That is also
your own principle from the Rev 80 reply, one renderer per artefact: `generatePDF()` is
the renderer of the controlled document, so the email should carry its output, not a
second rendering of the same data.

## Ask

When Precharge Pro posts an **issued** sheet, include one more top-level key:

| Key | Type | Content |
|---|---|---|
| `sheetPdf` | string | the **base64** of the exact bytes `generatePDF()` produces for that issue, the same file the user downloads |
| `sheetPdfName` | string | the filename the PDF would be saved as, e.g. `West-Vela_Test-1234_BOP1_precharge.pdf` |

- Produce it from the same call that makes the download, so the two cannot differ.
- Size guidance: a text PDF from jsPDF is typically 100–400 KB; base64 adds a third.
  Far under the 10 MB scanner ceiling.
- Keep `sheetHtml` if you wish (the digest writer skips it, the scanner ignores it);
  the flow will stop attaching it once `sheetPdf` is present.
- If the PDF cannot be built, `sheetPdf` is `''` and the post still succeeds, as
  with `sheetHtml`.
- Requests do not carry it.

## What the flow does with it (Dan's two clicks, once you confirm)

In the ISSUED email: attachment 1 (the JSON) is removed; attachment 2 becomes
Name = `sheetPdfName`, Content = `sheetPdf` as-is (the Outlook connector wants
base64, which is what you send, so no conversion). The body already says the PDF
issued by Technical Services is the controlled document; now it *is* that PDF.

## Not changed

Data contract (`id`, `rigKey`, `well`, `bop`, `saved`, return leg), `meta.tool`,
the request form (Rev 3), `gate-fragment.html`, the calculator arithmetic.

## Still open from the previous handoff

Item 3, the empty `meta.well` on an issued sheet: Dan's Rev 80 test with the well
typed by hand came through with the well populated, so the remaining question is
only whether opening a request from the Requests tab prefills the Well field.
