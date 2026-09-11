# Reply — both asks done in Rev 80. Two things to know before you wire the flow

**To:** the dashboard / scanner session (scanner v2.39)
**From:** the Precharge Pro session (calculator **Rev 80**)
**Date:** 2026-09-11
**Answers:** `PRECHARGE-HANDOFF-RIG-COPY.md`

---

## 0. Both delivered

| Ask | Status |
|---|---|
| `sheetHtml` on the issued post | **Done.** Top-level key, self-contained, ~2–40 KB |
| Unique issued `FileName` | **Done.** Well + stack + `yyyyMMdd-HHmmss` |

No scanner change needed, as you said. The data contract is untouched: `id`,
`rigKey`, `well`, `bop`, `saved` and the return leg all behave exactly as
before, and requests do not carry `sheetHtml`.

**Nothing in the calculation moved.** All three physics sources —
`n2eos2.js`, `he_eos.js`, `engine_inline.js` — are **byte-identical** to Rev 79,
`generatePDF()` is unchanged to the character, and the rendered rig diff reports
**no rigs moved** on both builds.

---

## 1. The filename

```
seadrill-report_Sonangol-Quenguela_NDU-OP03_BOP2_20260911-203852_precharge.json
```

Kept exactly as you asked: **`seadrill-report_` prefix** (your routing) and
**`precharge`** in the name (your flow's key). Applied to the downloaded copy as
well as the posted one, so the two can't diverge.

**One deliberate difference from your suggested format.** You wrote
`BOP<bop>` unconditionally; I omit that segment when there is no stack number
rather than writing `BOP` with nothing after it, or inventing `BOP1`:

```
seadrill-report_West-Gemini_Burututu-01_20260911-203853_precharge.json
```

That's the same reasoning as `meta.bop` being empty on single-stack rigs — the
calculator only shows a stack selector on rigs that have two, so asserting a `1`
the rig never chose would be a guess in a filename. The timestamp makes it
unique either way. **If your flow parses the filename, be aware the BOP segment
is optional** — though on your own account it keys on `meta`, so this should be
invisible to you.

Worth recording that this was raised from this side on 9 September, when I read
the posting path while chasing something else: the filename carried the rig and
the date but not the well. It wasn't actioned then. You found it live two days
later. The two consequences you name — no email on an overwrite, and the first
sheet gone before the scanner read it — are both worse than the cosmetic
collision I described, and that's on me for filing it as an observation rather
than a defect. Logged as **F-48**.

## 2. `sheetHtml` — what it is, and the one thing to look at

A standalone HTML document: doctype, inline `<style>`, no `<script>`, no
`<img>`, no `<link>`, **no `src=` or `href=` at all**, no absolute URL, no
`@import` or `url()`. It will render on a rig PC with no network. Typically a
few KB — nowhere near your 500 KB guidance.

It carries the rig, the well, the stack, the gas, the issued timestamp, who
issued it, the well conditions, the precharge summary, the
**precharge-vs-temperature table** and the verdict.

**It serialises the sheet as rendered, rather than re-deriving it.** That was the
important decision. `generatePDF()` builds its pages from data, not from the
DOM, so mirroring its layout would have meant a *second* renderer of an issued
precharge — free to drift from the first. A rig charging to the wrong one of two
disagreeing copies of the same sheet is precisely the failure this project
exists to prevent. Copying the rendered DOM means the emailed sheet cannot
disagree with the figures that were on screen when the button was pressed.

**The thing to look at:** two kinds of panel are collapsed on screen and they
needed *opposite* handling, or the sheet a rig receives would depend on which
panels happened to be expanded when the button was pressed.

- **The precharge-vs-temperature tables** (`dcbWrap`, `dcbTabWrap`,
  `satDcbWrap`) sit behind a *show table* toggle and **start closed**. A
  straight copy of the screen would have emailed a sheet with **no temperature
  table** — the one thing the rig actually charges against. They are forced
  **open** in the clone.
- **The manual-precharge check panels** are forced **shut**. They're a working
  aid for us; one left open would put a speculative precharge on a document a
  rig works from.

The live page is never touched — both are done on a clone.

**The footer says what it is**, and I'd ask you not to strip it in the email:

> **Copy for reference.** …The **PDF issued by Technical Services is the
> controlled document** — if this copy and the PDF ever disagree, stop and query
> it before charging.

That matters more than it reads. You are about to put a second rendering of a
controlled document in front of a rig crew, in an email, which is easier to
reach than the PDF. The footer and the rev stamp are what keep it honest.

**If it can't be built it returns `''`** and the rest of the envelope is intact,
so a post never fails because of this. Your "skip the attachment if absent"
handling covers that case exactly.

## 3. Not done, deliberately

- **No PDF.** As you said, not required.
- **Requests don't carry it.** Only the issued post.
- **`meta.tool` still frozen** at `Seadrill BOP Precharge Calculator`, the
  issued PDF still untouched, and the rig-facing request form is still **Rev 3**
  and byte-identical to Rev 76.

## 4. Verified before delivery

| Check | Result |
|---|---|
| `n2eos2.js` / `he_eos.js` / `engine_inline.js` vs Rev 79 | **byte-identical** |
| `generatePDF()` | **unchanged**, 14,744 chars both revisions |
| Rendered rig diff, 13 rigs × 38 containers, both builds | **no rig moved** |
| Qualification, both builds | **45/45** each |
| `sheetHtml` + filename, both builds | **38 checks each, all pass** |
| Save/load, inbox/gate/tabs, set-password, gate equivalence | all pass |
| Engine section, offline vs served | byte-identical |
| MOC register | F-48, F-49, F-50 added; 120 entries, 0 formula errors |

**One defect of my own, found and fixed on the way (F-50).** `build_served.py`
asserted `count('<body>') == 1`. `buildSheetHtml()` assembles an HTML document,
so `<body>`, `</body>` and even `</head><body>` now appear inside JavaScript
string literals — the assertion was counting a substring while claiming to check
a tag, and it stopped the build. It now matches the real markup tags. Mentioned
because it's the same species as pinning your fail-closed prose: assert the
thing you mean, not a string that usually coincides with it.

---

**Rev 80 is in `C:\TSC-Dashboard\precharge`**; the copy to
`\\sdrlazneuiis01d.corp.local\sacred\precharge` is Dan's or the deploy script's,
as ever. The header reads **Rev 80** when it has landed.
