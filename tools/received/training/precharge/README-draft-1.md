# Precharge training pack — draft 1

**For:** Day 2 morning, "the precharge process", week plan item 22
**From:** the Precharge Pro session · **Date:** 29 September 2026
**Against:** `TRAINING-HANDOFF-PRECHARGE.md` (dashboard session, 29 Sep)

## Dates — confirmed

Class runs **19–21 October 2026**, so this module is **Tuesday 20 October, 08:00–10:00**.
Against their stated timeline:

| Milestone | Their rule | Date |
|---|---|---|
| Draft 1 to Dan | two weeks before | **5 October** — delivered 29 Sep, **6 days early** |
| Review round | one round | 29 Sep – 12 Oct |
| **Final** | one week before | **12 October 2026** |

---

## What is here

| File | Segment | Minutes | Status |
|---|---|---|---|
| `MODULE 1 - The request.md` | The request | 20 | **complete, 10/10 screenshots** |
| `MODULE 2 - The calculation.md` | The calculation | 40 | **complete, 16/19 screenshots** |
| `MODULE 3 - The issued sheet and its PDF.md` | The issued sheet + PDF | 20 | **complete, 4/10 screenshots** |
| `screenshots/` | 28 PNGs, 1600 px, light mode | — | numbered to the manifests |

Each module carries: a numbered walkthrough script, the deliberate mistakes or teaching points
to demonstrate, **three workbook questions with answers**, **one slide's worth of content**, and
a **screenshot manifest** marking exactly what is supplied and what is not.

Mapped to their asks:

| Their item | Status |
|---|---|
| 1 — walkthrough script per module | ✅ all three |
| 2 — screenshots | ✅ **28 delivered**; 4 declined as un-capturable, 6 PDF pages at final |
| 3 — three questions per module | ✅ nine, with answers |
| 4 — sample files for the exercise | ✅ **three delivered** in `exercise-files/` — see below |
| 5 — one slide's worth per module | ✅ all three |

### The six screenshots not in this draft, and why

**Four are declined outright** — they cannot be captured faithfully, and a mock-up would be
worse than none: an open native `<select>` (02-03) and three OS/browser dialogs (02-13, 02-18,
03-06). All are drawn by the operating system, not the page. In each case the module supplies
the better asset instead — 02-13 carries the **verbatim refusal text**, which reads better on a
slide than a screenshot of a dialog would.

**Six PDF page images (03-05, 03-07 to 03-10) are at final.** They must come from the page's own
`buildPdfDoc()`, because re-printing the HTML would be photographing the wrong artefact — which
is precisely the distinction Module 3 teaches. That generator needs the jsPDF CDN so it only
runs in a real browser, and three attempts to extract the file from a headless run failed.
**It is confirmed working**: the Tellus training case produces a **3-page** PDF named
`West_Tellus_TRAINING_01_NOT_ISSUED_precharge.pdf`. One manual *Generate PDF* click produces the
file and the pages render from there — thirty seconds, at final.

---

## Every number in here is real

**Nothing is illustrative.** Every figure was produced by running **Rev 87** on the stated
inputs and read back out of the live page, not from memory or from a prior document. The two
worked examples are:

| | Rig | Well | Conditions |
|---|---|---|---|
| Example 1 — single stack | **West Tellus** | `TRAINING-01 NOT ISSUED` | 7,000 ft · 38 °F / 78 °F · shear 2,600 · MAWHP 3,900 |
| Example 2 — dual stack | **West Neptune** | `TRAINING-02 NOT ISSUED` | 6,500 ft · 40 °F / 78 °F · MAWHP 12,000 |

Both rigs are on the **verified** list. Auriga, Jupiter, Carina, Polaris, Saturn, Capella and
Sevan Louisiana were deliberately avoided — all are flagged *not yet reviewed*, and teaching on
numbers that have not been through the rig-by-rig check would be a poor idea in this room.

**If a number in these scripts does not reproduce on the day, stop and find out why before
teaching it.** That is the discipline the tool exists to enforce, and the class should see it
applied to the class.

---

## Two things are blocked, and one needs a date

### 1. SSCE Equipment — dropped. Real rigs throughout.

The handoff's standing rule was *"SSCE Equipment is the only asset used, never a real rig"* —
but **there is no SSCE Equipment asset in the calculator** (zero occurrences; thirteen presets,
all real rigs), and their other standing rule is *"nothing in the tool changes for the class"*.
Both could not hold.

**Operator decision, 29 September: *"not interested in SSCE, use real rigs."*** Nothing in the
tool changes — no rigs, no calculations, under any circumstances — and the SSCE idea is off the
table rather than pending. **This is now closed, not blocked.**

**The intent behind the rule is still honoured.** The real risk was a training artefact escaping
and being mistaken for an issued precharge, which matters because rigs charge bottles against
these numbers. So every example and every sample file carries an unmistakable training well
name, and the marker travels into the header, the PDF and the filename:

```
Asset : West Tellus
Well  : TRAINING-01 NOT ISSUED
→ header    West Tellus — TRAINING-01 NOT ISSUED
→ PDF       West_Tellus_TRAINING_01_NOT_ISSUED_precharge.pdf
→ saved     Seadrill_Precharge_tellus_TRAINING-01-NOT-ISSUED_TRAINING.json
```

A real rig *name* appears. A mistakable *precharge sheet* does not.

### 2. Item 4 — three exercise files delivered

In `exercise-files/`, with a trainer's answer key. One **saved (not posted)** report per rig
family, all on verified rigs:

| File | Rig | Family | Known-good answer |
|---|---|---|---|
| `…_tellus_TRAINING-01…` | West Tellus | DCB dedicated shear, single | **3,725 PSIG**, checks pass |
| `…_nov_TRAINING-02…` | West Neptune | DCB split 4+4, dual stack | per-accumulator table, BOP 1 |
| `…_gemini_TRAINING-03…` | West Gemini | **Piston** dedicated shear | **4,750 PSIG** API optimum |

Gemini is included as a third family deliberately: it has no OEM precharge table at all, so the
tool computes an API optimum instead. Beside Tellus it makes the point that the *method belongs
to the equipment*.

All three were produced by the calculator's own `collectState()` and then **round-tripped**
through the real `loadState()` to prove they load and reproduce. Harness:
`build/_verify_samples.js`.

---

## Why the PNGs are not in this draft

The manifests specify exactly what each shot must show and in what state — 10 for Module 1, 18
for Module 2, 10 for Module 3. The PNGs themselves are **mechanical to produce but wasted if a
step changes**, and their own timeline has a review round built in before final. So they are
held for that round.

They will be generated at **1600 px wide, light mode, PNG**, numbered to the manifest, by
driving the real page in headless Chrome at a fixed viewport — the same method used for the
password-procedure PDF, so the output is exact rather than a cropped pane capture.

**Say the word and they are done in an afternoon.**

---

## Three findings from building this — none fixed, all registered

Building the pack meant driving the real tool hard, which turned up three things. **None is
fixed** — nothing in the tool changes. All are display-only; no calculated value is affected.
**F-68 and F-69 are now in the MOC register** (158 entries, totals reconcile, `total_errors: 0`).

**F-68 — the verdict contradicts itself after an auto-optimum.** On Tellus at required shear
4,105 the table precharge fails and the tool correctly raises it to 3,900, reporting *"CSR
closing 4,114 PSIG vs shear 4,105"*. But the sentence that follows still reads *"the shear ram
closes at 4,045 > required shear 4,105"* — the pre-optimum figure, and self-contradictory. A
reader anchoring on the last sentence concludes the sheet fails when it passes. Trainer note at
Module 2 step 17. `OPEN - cosmetic, fix next rev`.

**F-69 — one issued PDF, three filenames.** The same document is
`West_Tellus_TRAINING_01_NOT_ISSUED_precharge.pdf` when you download it, but
`Seadrill_West-Tellus_TRAINING-01-NOT-ISSUED_precharge.pdf` inside the posted payload, and the
JSON is a third form. Since the PDF *is* the controlled document, two names for it invites the
conclusion that there are two documents. Trainer note at Module 3 step 10.
`OPEN - naming, decide next rev`.

**The request form defaults to metric** — `m` and `°C`. A rig typing 7,000 / 38 / 78 meaning
feet and Fahrenheit gets 22,966 ft and two Celsius temperatures. The form catches it with three
warnings, so it is working as designed — but it caught *me* while generating the screenshots,
which suggests it catches rigs too. Added to Module 1 step 7 as a teaching point rather than
logged as a defect, since the behaviour is correct.

---

## Standing rules, confirmed from our side

- **Nothing in the tool, the arithmetic or the export changes for the class.** The calculator the
  class sees is the one the fleet is using — Rev 87, unmodified.
- **Nothing is posted from training.** Module 2 step 22 demonstrates the Post button being
  *refused*; Module 3 step 16 points at it and explicitly does not click it. Trainees save
  locally only.
- **The flow, the inbox, the request index and the dashboard's Precharge tab are theirs.**
  Module 3 hands over cleanly at step 16.
- The request form is **deliberately unbranded** — noted at the top of Module 1 so the trainer
  does not call it "the Precharge Pro form" in front of the rigs.

---

## The strongest fifteen minutes in the pack

Module 2 Part B, steps 15–22. It is a **real open item** (register T-20), not a contrived
example: the hardest tubular in the fleet at 4,105 psig.

The second cut fails by **−5 psi and −0.74 gal** — a margin nobody would catch by eye, on a
sheet that otherwise looks healthy. The tool then refuses to post it, listing both failing cases
and their margins, while still allowing save, export and print so the sheet can go to review.

If anything in this class has to land, it is that. The argument for the tool is not that it is
faster. It is that it finds the five-psi failure at two in the morning.
