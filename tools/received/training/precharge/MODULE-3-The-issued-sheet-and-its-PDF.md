# Module 3 — The issued sheet and its PDF (20 minutes)

**Trainer:** Dan · **Tool:** Seadrill Precharge Pro, **Rev 87** · **Class:** Day 2, 09:00–09:20
**Our part:** the sheet and the PDF. **Dashboard session's part:** the inbox and the request index.

> Hand over cleanly at step 16. Everything from the inbox onward is their segment.

---

## What this module has to land

The PDF is **the controlled document**. Not the screen, not the email, not the saved file. If
there is ever a disagreement about what was issued, the PDF is the answer — and this module is
about being able to read one and know it is the right one.

---

# Part A — Reading the issued sheet (steps 1–8)

*Start from the completed West Tellus sheet from Module 2 Part A — the clean run, set precharge
3,725 PSIG, well `TRAINING-01 NOT ISSUED`.*

**1.** *Point at the sheet header.* 📷 **03-01**

> **West Tellus — TRAINING-01 NOT ISSUED**

→ **Say:** "Rig, and well. On a dual-stack rig it also carries `BOP 1` or `BOP 2`. This line is
your first check that you are looking at the right sheet."

**2.** *Point at the revision tag in the page header — `Rev 87`.*
→ **Say:** "Which version of the tool produced this. If two sheets for the same well disagree,
the revision is where you start."

**3.** *Point at the conditions block: well, water depth, temperatures, shear pressure, MAWHP.*
→ **Say:** "Everything the rig told us, echoed back. **Check this against your request.** If the
conditions are wrong the precharge is answering a different question." 📷 **03-02**

**4.** *Point at the green verdict banner — the precharge.*
→ **Say:** "**This is the number you charge to. 3,725 PSIG, at 78 °F.** Gauge pressure."

**5.** *Point at the temperature table below it.* 📷 **03-03**
→ **Say:** "The precharge is only correct at the temperature it is quoted at. This table gives
you the same charge at other deck temperatures. If it is 60 °F on deck, not 78, **you use the
table** — you do not charge to 3,725 and hope."

→ **Say:** "This table is the single most-used part of the sheet offshore, and it is behind a
*show table* toggle on screen. On the PDF it is always open — we force it, precisely because a
sheet issued without it is a sheet missing the thing the rig actually works from."

**6.** *Point at the per-accumulator summary.*
→ **Say:** "On rigs with more than one bank you get a row per accumulator with its own method
and its own precharge. Charge each to its own figure."

**7.** *Point at the checks section.*
→ **Say:** "The pass criteria, with the margins. You should be able to see *why* it passed, not
just that it did."

**8.** *Scroll to the methodology notes at the foot.*
→ **Say:** "The methods, named. This is what makes the sheet defensible six months later." 📷 **03-04**

---

# Part B — The PDF (steps 9–16)

**9.** *Click **Generate PDF**.* 📷 **03-05**
→ **Say:** "Note what did *not* happen — nothing was sent anywhere. This builds a document, on
this machine."

**10.** *Point at the filename.*

```
West_Tellus_TRAINING_01_NOT_ISSUED_precharge.pdf
```

→ **Say:** "Rig, well, and BOP where there is one. The well travels into the filename — which is
why a blank well is refused at the point of issue." 📷 **03-06**

> **Trainer note — three names, one document.** Verified on Rev 87, the same sheet produces:
>
> | Where | Name |
> |---|---|
> | the PDF you download | `West_Tellus_TRAINING_01_NOT_ISSUED_precharge.pdf` |
> | the PDF inside the posted payload | `Seadrill_West-Tellus_TRAINING-01-NOT-ISSUED_precharge.pdf` |
> | the posted JSON | `seadrill-report_West-Tellus_TRAINING-01-NOT-ISSUED_20260929-190505_precharge.json` |
>
> Underscores in one, hyphens and a `Seadrill_` prefix in another. **Do not let anyone conclude
> from the filename that these are different documents** — they are the same PDF. Raised as a
> finding; not changed, because nothing in the tool changes for the class.

**11.** *Open the PDF. Page 1.* 📷 **03-07**
→ **Say:** "Same content as the screen, laid out for print. The PDF is **built from the data,
not photographed from the screen** — so it cannot drift from what the calculation produced."

**12.** *Point at the sections.*
→ **Say:** "Precharge Summary. Dedicated Shear — DCB Precharge and Method C Check. On Tellus,
the NOV Contractual Petrobras Checks. Then the temperature window on page 2."

**13.** *Turn to page 2 — the precharge-vs-temperature table.* 📷 **03-08**
→ **Say:** "Always present, always open. This is the page that goes to the person with the
nitrogen cart."

**14.** *Point at the controlled-document statement.* 📷 **03-09**

> *The **PDF issued by Technical Services is the controlled document**.*

→ **Say:** "Say this out loud on every job. Screenshots get forwarded, emails get replied to
with edits, spreadsheets get resaved. **The PDF is what was issued.** If someone is working from
anything else, stop them."

**15.** *Point out there is no logo and no product name on the sheet.*
→ **Say:** "Deliberate, and it stays that way. Renaming the issued sheet would make new sheets
differ from every sheet already out with a rig — that is a document-control decision, not
styling."

**16.** *Point at **Post to Dashboard** — and do not click it.* 📷 **03-10**
→ **Say:** "This is where it leaves us. Post puts the issued sheet on the dashboard against the
original request, and the notification goes out from there."

→ **Say:** "**Nothing is posted from this class.** And the tool will refuse the post anyway if
the sheet has not passed its checks — you saw that in Module 2."

→ **Hand over:** "What happens after the post — the inbox, the request index, who gets the
email — is the next segment."

---

## Three questions for the workbook

**Q1.** A rig has a screenshot of a precharge sheet on a phone, an email with the figure in the
body, and a PDF attachment. **The three disagree. Which is correct, and why is the answer not
"whichever is most recent"?**

> **A.** **The PDF.** It is stated on the sheet itself that the PDF issued by Technical Services
> is the controlled document. Recency is not the test: a screenshot can be cropped, an email body
> can be edited in a reply, and either can be more recent than the PDF while being wrong. The PDF
> is generated from the calculation data rather than copied from the screen, so it cannot drift
> from what was actually computed. If the rig is working from anything else, stop and reissue.

**Q2.** A sheet quotes a set precharge of 3,725 PSIG at a deck temperature of 78 °F. On the day,
the deck is 60 °F. **What do you charge to, and where do you find it?**

> **A.** **Not 3,725.** A precharge is only correct at the temperature it is quoted at. Use the
> **precharge-vs-temperature table** on page 2 of the PDF and read the value for 60 °F. The table
> is forced open on every issued PDF for exactly this reason. Charging to the headline figure at
> a different deck temperature puts the wrong mass of nitrogen in the bottle.

**Q3.** **What three things on an issued sheet would you check first to confirm you are holding
the right document for the job in front of you?**

> **A.** (1) The **header** — rig, well, and BOP number on a dual-stack rig. (2) The **conditions
> block** — water depth, both temperatures, shear pressure and MAWHP, checked against what was
> requested; if the conditions are wrong the sheet is answering a different question. (3) The
> **revision tag**, which identifies the version of the tool that produced it and is where you
> start if two sheets disagree.

---

## Slide content — Module 3

**Slide title: The issued sheet — the PDF is the controlled document**

- **The PDF is the controlled document.** Not the screen, not the email, not a screenshot.
- **Built from the data, not from the screen** — so it cannot disagree with the calculation.
- **Check three things first:** header (rig · well · BOP) · conditions block · revision.
- **The conditions block is your cross-check** against the request. Wrong conditions = right
  answer to the wrong question.
- **The temperature table is not optional reading.** Charge to the value for *today's* deck
  temperature, not the headline.
- **Filename carries rig, well and BOP** — which is why a blank well is refused at issue.
- **No logo, no product name on the sheet** — and it stays that way, for document control.
- **Post is the hand-off point.** A sheet that fails its checks cannot be posted at all.

---

## Screenshot manifest — Module 3

Light mode, 1600 px wide, PNG. All from the clean Tellus run (set precharge 3,725 PSIG).

| # | Step | Shows | Status |
|---|---|---|---|
| 03-01 | 1 | Sheet header — `West Tellus — TRAINING-01 NOT ISSUED` | ✅ `screenshots/03-01.png` |
| 03-02 | 3 | Conditions as entered (left input column) | ✅ `screenshots/03-02.png` |
| 03-03 | 5 | Temperature table, expanded | ✅ `screenshots/03-03.png` |
| 03-04 | 8 | Drawdown / methodology card at the foot | ✅ `screenshots/03-04.png` |
| 03-05 | 9 | Generate PDF button | ⏳ at final |
| 03-06 | 10 | Save dialog showing the filename | ❌ **OS dialog — cannot be captured** |
| 03-07 | 11 | **PDF page 1** | ⏳ at final (see below) |
| 03-08 | 13 | **PDF page 2** — temperature window | ⏳ at final (see below) |
| 03-09 | 14 | Controlled-document statement, crop | ⏳ at final (from page 1) |
| 03-10 | 16 | Post to Dashboard button — **not clicked** | ⏳ at final |

**The PDF page images are the one gap in this draft.** The PDF has to come from the page's own
`buildPdfDoc()` — re-printing the HTML would be photographing the wrong artefact, which is the
exact distinction this module teaches. That generator needs the jsPDF CDN, so it only runs in a
real browser, and getting the resulting file out of a headless run defeated three approaches
(the download keeps headless Chrome alive; a local receiver would not answer).

**It is confirmed working, just not yet extracted.** Driving the real generator on the Tellus
training case returns a **3-page** document named `West_Tellus_TRAINING_01_NOT_ISSUED_precharge.pdf`.
The simplest route to the PNGs is one manual step: open the sheet, click **Generate PDF**, save
the file, and the pages render to 1600 px from there. Thirty seconds of Dan's time, or done at
final.

**03-06 will not be supplied at all** — it is the operating system's save dialog, which is not
part of the tool and looks different on every machine. Recommend the slide just names the
filename pattern instead.

---

## Not covered here — handed to the dashboard session

The inbox, `requests/<id>.json`, the request index, the dashboard's Precharge tab, the
notification email and the superseded-payload behaviour. Their segment, their material.
