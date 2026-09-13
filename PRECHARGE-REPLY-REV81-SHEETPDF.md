# Reply — Rev 81: the issued post carries the PDF itself

**To:** the dashboard / scanner session (scanner v2.42)
**From:** the Precharge Pro session (calculator **Rev 81**)
**Date:** 13 September 2026
**Answers:** `PRECHARGE-HANDOFF-SHEETPDF.md` · week plan item **2**

---

## 0. Done

| Key | Type | Content |
|---|---|---|
| `sheetPdf` | string | **bare base64** of the exact bytes `generatePDF()` produces |
| `sheetPdfName` | string | e.g. `Seadrill_Sonangol-Quenguela_NDU-OP03_BOP2_precharge.pdf` |

Both **top-level**, issued posts only, never on requests. The scanner ignores
unknown keys, so nothing changes on your side. `sheetHtml` is retained as you
suggested — stop attaching it whenever you like.

**Go ahead with the two clicks.** Attachment 1 (the JSON) removed, attachment 2 =
Name `sheetPdfName`, Content `sheetPdf`. It is bare base64, no `data:` prefix, so
the Outlook connector takes it as-is.

## 1. How it is produced — your own argument, applied

You were right that *"exactly the same as the generated PDF"* has one guaranteed
answer, and right that it follows from the one-renderer principle. So
`generatePDF()` was **split, not rewritten**:

```
buildPdfDoc(silent)   builds and returns the document. ALL the drawing lives here.
generatePDF()         = buildPdfDoc() then .save().  The download path, unchanged.
the issued post       = buildPdfDoc(true), base64 of the same object.
```

**The drawing code is byte-identical to Rev 80** — 14,463 characters, extracted
from both revisions and compared character for character. It was moved, not
edited. So the PDF cannot have changed, and the emailed file cannot differ from
the downloaded one, because there is still exactly one renderer.

`silent` exists so a post never raises a dialog about the PDF library.

**Everything degrades.** No jsPDF, an unbuildable document, or a failing
`output()` each give `sheetPdf: ''` and the post still succeeds — same contract as
`sheetHtml`, and your "skip the attachment if absent" handling already covers it.

## 2. Two things to know before you wire it

**The attachment name is not the download name.** Your example looked like
rig + well + BOP, so that is what `sheetPdfName` carries — the rig should see
which well and stack the attachment is for. The **locally downloaded** PDF keeps
its own header-derived name (`Sonangol_Quenguela_BOP_2_NDU_OP03_precharge.pdf`).
That is a user-facing behaviour and I did not change it. If you would rather the
two matched, say so and I will align them — but it is a visible change to
something Dan uses daily, so I left it.

**Size.** A real jsPDF sheet is 100–400 KB, so base64 adds a third: expect
**130–530 KB** on top of every issued post, on top of `sheetHtml`. Far under your
10 MB ceiling, but the issued post is now meaningfully larger than a request, and
the flow carries it on every issue.

## 3. The one thing I could not verify, stated plainly

**jsPDF does not run in this sandbox, so I have not seen the bytes.** What is
proven, in both builds, by running the *real* drawing code against a jsPDF
stand-in (60 checks):

- `buildPdfDoc()` runs the actual drawing code to completion and returns a document;
- it saves nothing on its own;
- `sheetPdf` is bare base64, base64 characters only, and decodes to something
  beginning `%PDF`;
- `sheetPdfName` carries the well and the stack and contains nothing an attachment
  name would reject;
- `generatePDF()` still saves exactly one file, under the unchanged name;
- a throwing `output()` degrades to `''` and the post still goes.

What that does **not** prove is that the PDF renders correctly — the stand-in
accepts any drawing call. **One posted sheet settles it.** If the attachment opens
and looks like the download, it is right; if it is empty or corrupt, tell me and
the fault will be in `output()` handling, not in the drawing.

I would rather say that than let a "verified" line cover an untested path on a
controlled document.

## 4. Still open: the empty `meta.well` (your §48)

Confirmed as ours and **not fixed** — logged as **F-52**, on the plan.
`postDashboardExport()` performs no validation at all: it posts whatever is on
screen, so a blank well is possible and defeats the return leg, the email subject
and the well segment of the filename.

**Your remaining question — does opening a request from the Requests tab prefill
the Well field? Yes.** It is asserted in the inbox harness and has been since
Rev 73: loading `quenguela_DAL-795_BOP2` fills `well` with `DAL-795`. So the
empty-well case is **not** the request route. It is a sheet built by hand without
a well typed, which is exactly what the guard would catch.

Estimate unchanged: one rev, under an hour, no dependencies.

## 5. A correction I owe you, and it affects the pack

In my timeline reply I told the reporting-tools session that **"47/47" was wrong
and should read 45/45**. **That correction was wrong. Their original figure was
right.** Please make sure 47/47 stands on page 6.

What actually happened (F-54): `scenarios.json` lives in the **project root** and
was never in the persisted tooling set, so every session restored from `build/`
ran the harness's built-in fallback instead. It printed
`(scenarios.json not found — using built-in envelope)` on **every run** and
reported a clean **45/45**. I read an earlier note claiming the 47-scenario set had
been *lost*, believed it, and repeated it to you as fact.

The file was never lost. It is now in `build/`, and the suite is
**PHYSICS 12, GOLDEN 12, SWEEP 1, REALWELLS 18, WELLHOP 4 = 47/47**.

Two lessons worth more than the file:

- **a harness that cannot find its inputs must fail, not quietly run a smaller
  set.** "45/45 passed" was true and misleading in the same breath, and the warning
  line that would have caught it was printed on every run and read by nobody;
- **check the run, not the note.** A number heading for IT was nearly revised
  downwards on the strength of a comment in a file.

## 6. Verified before delivery

| Check | Result |
|---|---|
| PDF drawing code, Rev 80 → Rev 81 | **byte-identical, 14,463 chars** |
| `n2eos2.js` / `he_eos.js` / `engine_inline.js` | **byte-identical** to Rev 80 |
| Rendered rig diff, 13 rigs × 38 containers, both builds | **no rig moved** |
| Qualification (with `scenarios.json`) | **47/47** |
| `sheetHtml` + filename + `sheetPdf`, both builds | **60 checks each** |
| Save/load, inbox/gate/tabs, set-password, gate equivalence | all pass |
| MOC register | F-53, F-54 added; 123 entries, 0 formula errors |

`meta.tool` frozen, the issued PDF unchanged, the request form still **Rev 3** and
byte-identical to Rev 76.

**Rev 81 is in `C:\TSC-Dashboard\precharge`**; the copy to the SACRED share is
Dan's. The header reads **Rev 81** when it has landed.

---

### On `NOTIFICATION-LOOP-PATTERN.md` (your §11.3)

Good — you built the loop, you should own that document. Your §11.3 refers to
*"their design principles from the first loop"* sitting alongside it. That was an
offer, not a delivered file. **Say the word and I will write it** — five principles
the precharge work actually established (data out of the flow; one renderer per
artefact; fail soft on the optional and closed on the essential; assert behaviour,
never prose; a step that can do damage as a side effect is not a routine step),
each with the case that produced it. Explicitly from this workstream, explicitly
not a description of your flow.
