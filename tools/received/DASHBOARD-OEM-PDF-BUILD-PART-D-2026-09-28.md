# Post to OEM — make NOV get a PDF. Build Part D.

**From:** the reporting-tools session (SSORT)
**Raised:** 28 September 2026
**Effort:** about 15 minutes in Power Automate. **No change to SSORT.**
**Dan's instruction, 28 Sep:** *"I want NOV to get a PDF not a HTML from the CBM."*

---

## 1. The short version

SSORT's **Post to OEM** already sends everything the flow needs to produce a PDF. It has
since REV 148. What it does **not** send is a rendered PDF, because SSORT has no PDF
renderer and should not gain one.

The conversion belongs in the flow, and it was designed and written up on 24 September as
**Part D** of `CBM-OEM-NOTIFICATION-FLOW-GUIDE.md`. It has not been built. This note is
Part D on its own so it can be actioned without reading the whole guide.

---

## 2. Current state — worth being straight about

**The button shipped before Part D was built.** The flow guide said *"Until Part D is
proven, the button does not ship."* It shipped anyway, in SSORT REV 148 on 26 September, on
Dan's explicit instruction, and it is live in REV 149 now.

So today a crew can press **Post to OEM** and:

- the post reaches the server and returns `res.ok`
- the tool says **"✓ Sent for OEM delivery"** — deliberately worded, because all the tool
  can see is that the file arrived
- the flow reads `pdf`, finds nothing, and emails NOV **a one-byte file called `.pdf`**

Nothing is lost — the CBM report on the dashboard is unaffected — but NOV gets an empty
attachment and nobody downstream is told.

**Building Part D closes this.** It is the only thing standing between the current state
and a working button.

---

## 3. What SSORT already sends

From `postCbmToOem`, unchanged since REV 148:

```
meta: { kind:'oem-copy', tool:'SSORT', asset, date, reporttype:'CBM Inspection',
        equipment, wce, saved, rev }
oem: 'NOV'
subject:      'CBM Report - <rig> - <equipment> - <date>'
sourceFormat: 'html'          <- says which of the two it sent
html:         <base64 of a standalone HTML report>
htmlName:     'Seadrill_CBM_<rig>_<equip>_<date>.html'
pdfName:      'Seadrill_CBM_<rig>_<equip>_<date>.pdf'    <- the name to attach under
```

Filename: `seadrill-oem_<rig>_<date>_<equip>_<stamp>_cbm.json`

`sourceFormat` exists precisely so that if SSORT ever does gain a real PDF renderer, the
flow takes either without a rewrite. Precharge posts still carry `pdf` and are unchanged —
the condition in D3 keeps both shapes working.

---

## 4. Part D, the five steps

**D1 — a variable at the top.** Under the trigger card, above the first Condition:
`Initialize variable`, Name `PdfFile`, Type **Object**, Value empty. (Initialize variable
only works at top level, which is why it sits here and not in a branch.)

**D2 — two composes after HasPdf** (step 6):
- **HasHtml**: `not(empty(coalesce(body('Parse_JSON')?['html'],'')))`
- **HtmlName**: `coalesce(body('Parse_JSON')?['htmlName'], replace(outputs('PdfName'), '.pdf', '.html'))`

**D3 — Condition `NeedsConvert`**, straight after HtmlName.
Left box fx: `and(equals(outputs('HasPdf'), false), equals(outputs('HasHtml'), true))`
**is equal to** `true`.

**True branch** (an SSORT HTML post) — four cards, in order:

1. **Create file** (OneDrive for Business) — Folder Path `/OemConvert` (create the folder
   once), File Name fx `outputs('HtmlName')`, File Content fx
   `base64ToBinary(body('Parse_JSON')?['html'])`. Rename **HtmlFile**.
2. **Convert file** (OneDrive for Business) — File fx `outputs('HtmlFile')?['body/Id']`,
   Target type **PDF**. Rename **ConvertedPdf**.
3. **Set variable** — Name `PdfFile`, Value fx `body('ConvertedPdf')`.
4. **Delete file** (OneDrive for Business) — File fx `outputs('HtmlFile')?['body/Id']`.

**False branch** (a post carrying `pdf`, the precharge shape) — one card, **Set variable**:
Name `PdfFile`, Value fx
`base64ToBinary(if(equals(outputs('HasPdf'), true), body('Parse_JSON')?['pdf'], 'Cg=='))`

**D4 — the attachment.** Open **OEM Email** → Attachments → Content: replace the expression
with fx `variables('PdfFile')`. Name stays `outputs('PdfName')`. **Save.**

---

## 5. Proving it

Settings **B2 = Yes** (test mode). Press **Post to OEM** once from SSORT REV 149 against
the asset **`SSCE Equipment`**.

The office four should receive
`[TEST MODE] [Seadrill CBM Report for OEM review] …` with a real multi-page PDF attached.

**Open the PDF and check two things specifically:**
- the **photographs** survived the converter
- the **grade colours** survived

If either did not, say so and Part D switches to attaching the HTML instead (`HtmlName` +
`base64ToBinary(body('Parse_JSON')?['html'])`) — one card changed. Then **B2 = No**.

`SSCE Equipment` is SSORT's test asset, added in REV 148 (rolling handoff entry 38.1). It
is not a rig and should be excluded from fleet rollups.

---

## 6. The one failure mode to expect

**Very large photo sets may be refused by the converter.** The run fails at ConvertedPdf,
nothing goes to NOV, and Power Automate emails you the failure — but the crew's screen
still says "Sent for OEM delivery", because the tool only ever knew the file arrived.

SSORT already refuses above 30 MB and warns above 20 MB, with the warning naming both the
OEM mailbox and our own server. If the converter turns out to have a lower practical limit
than that, tell us the figure and the tool's thresholds move to match.

---

## 7. Why this is not being done in the tool

Asked and answered, so it does not get relitigated:

- **One renderer, not two.** The tool's own report page feeds both the engineer's screen and
  NOV's attachment. A separate PDF renderer means two things to keep in step, and they will
  drift.
- **The library is the wrong one to reintroduce.** SSORT would need jsPDF, roughly 350 KB.
  It was in SSORT until REV 148 inside the drawdown iframe blob and is the library visible
  in the one field fault reported this month.
- **It performs badly where it matters.** Client-side HTML-to-PDF on a photo-heavy CBM
  report is slow, breaks tables and page breaks, and can hang a rig laptop — on the exact
  reports that matter most.
