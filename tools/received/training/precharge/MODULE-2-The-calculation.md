# Module 2 — The calculation (40 minutes)

**Trainer:** Dan · **Tool:** Seadrill Precharge Pro, **Rev 87** · **Class:** Day 2, 08:20–09:00
**Assets:** West Tellus (single stack) and West Neptune (dual stack) · **Wells:** `TRAINING-01 NOT ISSUED`, `TRAINING-02 NOT ISSUED`

> **Every figure in this script was produced by running Rev 87 on the stated inputs.** None is
> illustrative. If a number here does not reproduce on the day, **stop and find out why before
> teaching it** — that is itself the lesson this tool exists to enforce.

> **Nothing is posted in this module.** Step 22 demonstrates the Post button being *refused*;
> the trainer does not post at any point. Trainees save locally.

---

## Segment plan

| Part | Steps | Minutes | What it teaches |
|---|---|---|---|
| A | 1–14 | 18 | A clean run end to end: inputs → precharge → the checks |
| B | 15–22 | 14 | A **genuine failure** and what the tool does about it |
| C | 23–30 | 8 | Dual stack, and one thing that is *not* what people assume |

---

# Part A — West Tellus, a clean run (steps 1–14)

### Setup before the room arrives

| Field | Value |
|---|---|
| Asset | West Tellus |
| Well | `TRAINING-01 NOT ISSUED` |
| Water depth | 7,000 ft |
| Subsea temp | 38 °F |
| Deck temp | 78 °F |
| Min shear pressure | 2,600 PSIG |
| MAWHP | 3,900 psi |

---

**1.** *Open the calculator.* `http://sdrlazneuiis01d.corp.local:8080/sacred/precharge/`
→ **Say:** "This is the tool that produces the number the rig charges the bottles to. One
password, no login. It runs in the browser — there is no server doing the maths." 📷 **02-01**

**2.** *Point at the revision in the header — `Rev 87`.*
→ **Say:** "Check this every time. If you are looking at a screenshot or a saved copy, the
revision tells you which version of the method produced it." 📷 **02-02**

**3.** *Open the Asset dropdown. Do not select yet.*
→ **Say:** "Thirteen assets, and they are not interchangeable. Each one carries that rig's own
bottle sizes, volumes, ratios and MOPs from its own OEM sizing document. Picking the wrong rig
does not give you a slightly wrong answer — it gives you another rig's answer." 📷 **02-03**

**4.** *Select **West Tellus**.*
→ **Say:** "Watch the locked fields repopulate. Anything greyed is rig hardware — you cannot
edit it, and you should not want to. Anything white is per-well, and that is your job."

**5.** *Point at the greyed hardware block.*
→ **Say:** "These came from `10656530-CAL Rev 05`. If one of them is wrong, that is a change
request and an MOC — not a thing you type over." 📷 **02-04**

**6.** *Type the well name: `TRAINING-01 NOT ISSUED`.*
→ **Say:** "On a real job this is the well. It goes in the header, on the PDF, and in the
filename — it is how the dashboard matches the issued sheet back to the request."

**7.** *Enter water depth 7,000 ft.*
→ **Say:** "Water depth drives the hydrostatic head the bottles work against."

**8.** *Enter subsea 38 °F and deck 78 °F.*
→ **Say:** "Two temperatures, and they do different jobs. Subsea sets the gas density at depth.
Deck is the temperature you will actually be charging at — the headline number is quoted at deck
temperature because that is what the gauge reads with the stack on the surface." 📷 **02-05**

**9.** *Enter minimum shear pressure 2,600 PSIG and MAWHP 3,900.*
→ **Say:** "Shear pressure comes off the rig's tubular estimator. MAWHP is the maximum
anticipated wellhead pressure. Module 1 covered how these two get misread."

**10.** *The results column has already updated — it recalculates as you type.*
→ **Say:** "There is no Calculate button. Every keystroke reruns the whole thing."

**11.** *Read the green verdict banner aloud.* 📷 **02-06**

> **SET PRECHARGE (DCB TABLE): 3,725 PSIG** (gauge — charge to this) / 3,740 PSIA @ 78 °F —
> **CHECKS PASS ✓**

→ **Say:** "**3,725 PSIG is the answer.** Gauge pressure, at 78 °F. Everything else on this page
exists to justify that number or to prove it is safe."

**12.** *Point at the PSIG / PSIA pair, and the highlighted PSIG column.*
→ **Say:** "The gauge reads PSIG; the physics is in PSIA; they differ by atmospheric, 14.7. The
yellow column is always the one you charge to. Getting these the wrong way round is a 15 psi
error, which sounds small until you are near a limit." 📷 **02-07**

**13.** *Point at the parenthetical: "table value 3,704, rounded up to the nearest 25 psi".*
→ **Say:** "The OEM table gives 3,704. We round **up** to 3,725 because you cannot set a gauge to
3,704, and rounding down would put you under the table. Always up, never down."

**14.** *Open the Method C drawdown block.* 📷 **02-08**

| | |
|---|---|
| Condition 0 — surface precharge (table) | **3,725 PSIG** @ 78 °F |
| Subsea precharge P1 (NOV AX080263 field procedure) | **3,333 psia** at 38 °F |
| Condition 1 — charged subsea | **4,945 PSIG** |
| Condition 2 — shear ram close, after FVR | **4,045 PSIG** |
| Required shear | 2,600 PSIG → **passes by 1,445** |
| FVR | 46.00 gal × 1.1 design factor = **50.60 gal** |

→ **Say:** "Four conditions. You charge at 0, the stack goes to depth and gets charged from the
HPU at 1, then the ram fires and the pressure falls to 2. Condition 2 is the one that matters —
that is what is actually left at the ram when it closes. 4,045 against 2,600 required."

→ **Say, pointing at P1:** "That 3,333 psia is the subsea field-procedure figure. **Pair it only
with the subsea temperature** — a P1 read against deck temperature is a different pressure
entirely."

---

# Part B — The same rig, a tubular it cannot shear (steps 15–22)

> This is the most valuable fourteen minutes in the module. It is a **real open item** on the
> fleet (register T-20), not a contrivance.

**15.** *Change minimum shear pressure from 2,600 to **4,105**. Change nothing else.*
→ **Say:** "4,105 psig is the hardest tubular we currently have. One field. Watch." 📷 **02-09**

**16.** *The banner turns red.* 📷 **02-10**

> ⚠ **FAILS PER PRECHARGE TABLE** — at 3,725 PSIG: shear pressure not delivered — closing
> **4,045** PSIG vs required **4,105** PSIG; usable **46.4** gal vs FVR need **50.6** gal

→ **Say:** "Two separate failures. Not enough *pressure* — 60 psi short. And not enough
*volume* — 4.2 gallons short. Either one on its own means the ram does not complete its stroke."

**17.** *Scroll to the green OPTIMUM banner immediately below.* 📷 **02-11**

> ✓ **OPTIMUM PRECHARGE (raised to pass, +50 & rounded up to nearest 100): 3,900 PSIG** /
> 3,915 PSIA @ 78 °F — usable **70.3** gal (need 50.6); CSR closing **4,114** PSIG vs shear 4,105

→ **Say:** "The tool does not just fail you. It searches for the lowest precharge that passes,
adds 50 psi of margin, rounds up to the nearest 100, and rebuilds the temperature table at the
raised figure. 3,900 instead of 3,725."

> ⚠ **Trainer note — known wording quirk in Rev 87.** The sentence at the *end* of that banner
> still reads *"the shear ram closes at 4,045 > required shear 4,105"*. That is stale text left
> over from the pre-optimum pass and it contradicts itself. **The correct figure is the 4,114 in
> the optimum line above it.** Do not let a trainee anchor on the stale sentence. This has been
> raised; it is cosmetic and does not affect any calculated value.

**18.** *Scroll to the NOV Contractual Petrobras Checks panel.* 📷 **02-12**
→ **Say:** "This panel is West Tellus only. Petrobras contractually require two shears from the
acoustic system, calculated by Method B. So we check four cases."

**19.** *Walk the four rows.*

| Case | FVR +10% | P required | P remaining | Usable | Result |
|---|---|---|---|---|---|
| CSR alone | 50.60 gal | 4,164 | **4,516** (+352) | 100.46 gal (+49.86) | **PASS** |
| CSR + USR | 101.20 gal | 4,164 | **4,159** (−5) | 100.46 gal (−0.74) | **FAIL** |
| CSR + LSR | 101.20 gal | 4,164 | **4,159** (−5) | 100.46 gal (−0.74) | **FAIL** |
| Completion | 114.53 gal | 3,000 | **4,075** (+1,075) | 151.16 gal (+36.63) | **PASS** |

→ **Say, slowly:** "Look at the margin. **Minus five psi. Minus zero point seven four of a
gallon.** One cut is fine. The second cut fails — and it fails by an amount no one would spot by
eye, on a sheet that otherwise looks healthy."

→ **Say:** "This is the entire argument for the tool. Not that it is faster. That it finds the
five-psi failure at two in the morning when you have been at it for nine hours."

**20.** *Point at the panel header: "DCB 3,900 PSIG · acoustic piston 4,250 PSIG · hydraulic charged 4,945 PSIG".*
→ **Say:** "Note it is already using the raised 3,900 — the contractual check runs against the
precharge we would actually issue, not the one that already failed."

**21.** *Point out that the sheet still prints.*
→ **Say:** "Save, Export and Generate PDF all still work. You are meant to be able to take a
failing sheet into a review — that is a legitimate engineering document. What you cannot do is
send it to the rig."

**22.** ⚠ *Click **Post to Dashboard**. It is refused.* 📷 **02-13**

```
⚠ THIS SHEET FAILS THE NOV CONTRACTUAL PETROBRAS CHECK.

It cannot be posted to the dashboard:

  • CSR + USR: pressure 4159 vs 4164 PSIG required (-5), volume 100.46 vs 101.20 gal needed (-0.74)
  • CSR + LSR: pressure 4159 vs 4164 PSIG required (-5), volume 100.46 vs 101.20 gal needed (-0.74)

Saving, exporting and printing are still allowed - take it into review.
Raise the precharge, or confirm the acoustic bank precharge, and post again.
```

→ **Say:** "Nothing left the browser. No file, no email, no dashboard entry. The rig is not
told anything, because there is nothing safe to tell them yet."

→ **Say:** "And when this happens for real — which it will, this tubular is a live open item —
the answer is not to lower the requirement until it passes. It goes back to the operator and to
NOV. The tool has done its job by stopping here."

> **Trainer: dismiss the dialog. Do not post.** The refusal is the demonstration.

---

# Part C — West Neptune, dual stack (steps 23–30)

**23.** *Switch Asset to **West Neptune**. Enter well `TRAINING-02 NOT ISSUED`, water depth 6,500 ft, subsea 40 °F, deck 78 °F, MAWHP 12,000.*
→ **Say:** "Different rig, so the whole hardware block has changed underneath us." 📷 **02-14**

**24.** *Point at the new **BOP** selector, which was not there for Tellus.*
→ **Say:** "Neptune has two complete BOP stacks. Only the rigs that actually have two get this
selector — Neptune, Vela, Libongos, Quenguela and Saturn." 📷 **02-15**

**25.** *Point at the shear pressure field — Neptune's is prefilled at 3,826.*
→ **Say:** "Careful: the field that carries shear pressure is not the same field on every rig
family. Read the label, not the position."

**26.** *Show the Precharge Summary — the per-accumulator table.* 📷 **02-16**

| Accumulator | Method | Surface PC | Subsea precharge | BAR |
|---|---|---|---|---|
| Blue POD Pilot | **B** | 1,500 | **5,156** PSIG | 355.5 |
| Subsea Manifold Reg. Pilot | **A** | 850 | **3,743** PSIG | 258.0 |
| Subsea LMRP Connector Reg. Pilot | **A** | 400 | **3,293** PSIG | 227.0 |
| Subsea Stack Connector Reg. Pilot | **A** | 400 | **3,293** PSIG | 227.0 |
| Subsea Upper Annular Reg. Pilot | **A** | 400 | **3,293** PSIG | 227.0 |

→ **Say:** "This is the output on a rig like this — not one number, a number **per accumulator**,
each by its own method. Method A for the subsea regulator legs, Method B for pilots. The BAR
column is for whoever is charging with a metric gauge."

**27.** *Point at the Method column.*
→ **Say:** "Method A is a straight hydrostatic addition and it matches NOV to the psi. Method B
is the real-gas isothermal optimum. They are not interchangeable — the method is a property of
what the bottle does, not a preference."

**28.** *Switch the BOP selector from 1 to 2. Let the room watch the numbers.* 📷 **02-17**
→ **Ask the room:** "What changed?"

**29.** *Answer: only the header.*
→ **Say:** "**Nothing in the arithmetic moved.** Every number is identical. On Neptune both
stacks are the same hardware and the tool uses one fixed gas density for the rig, so the
precharge is genuinely the same for BOP 1 and BOP 2."

→ **Say:** "The selector's job is to *label* the sheet — the header, the PDF and the filename —
so the dashboard files it against the right stack. It is not a calculation input."

→ **Say:** "This catches people out in both directions. Do not assume switching it changes the
answer. And do not assume, because it does not, that the two stacks are interchangeable — if
their hardware ever diverges, that is a change request, not a field you can set."

**30.** *Save the sheet — `Save .json`. Do not post.*
→ **Say:** "Saved locally. In the class exercise you will each produce one of these and we will
compare against a known-good file." 📷 **02-18**

---

## Three questions for the workbook

**Q1.** A sheet shows a set precharge of 3,725 PSIG and a Condition 2 shear-ram closing pressure
of 4,045 PSIG, against a required shear pressure of 4,105 PSIG. Usable volume is 46.4 gal against
an FVR requirement of 50.6 gal. **What are the two independent reasons this sheet fails, and what
does the tool do next?**

> **A.** It fails on **pressure** — 4,045 delivered against 4,105 required, 60 psi short — and
> separately on **volume**, 46.4 gal against 50.6 gal, 4.2 gal short. Either alone means the ram
> does not complete its stroke. The tool then computes an **optimum precharge**: it raises the
> precharge until both checks pass, adds 50 psi, rounds up to the nearest 100 — giving 3,900 PSIG
> — and rebuilds the temperature table at that raised figure.

**Q2.** The Petrobras contractual panel shows *CSR alone* passing with +352 psi and +49.86 gal,
but *CSR + USR* failing by −5 psi and −0.74 gal. **Can this sheet be posted to the dashboard, and
what may still be done with it?**

> **A.** **No — the post is refused**, with a dialog naming both failing cases and their margins.
> Nothing leaves the browser: no file, no email, no dashboard entry. **Save, Export and Generate
> PDF all remain available**, deliberately, so the sheet can be taken into an engineering review.
> The correct next action is to raise the precharge or confirm the acoustic bank precharge — not
> to reduce the requirement until it passes.

**Q3.** On West Neptune you switch the BOP selector from 1 to 2 and every calculated value stays
the same. **Is this a fault? What does the selector actually do?**

> **A.** **Not a fault.** Both Neptune stacks carry identical hardware and the rig uses a single
> fixed gas density, so the precharge is genuinely the same for either stack. The selector
> **labels** the sheet — header, PDF and filename — so the dashboard matches the issued sheet to
> the correct stack. It is not a calculation input. It does not follow that the stacks are
> interchangeable: if their hardware ever differs, that is a change request and an MOC.

---

## Slide content — Module 2

**Slide title: The calculation — what the tool is actually doing**

- **One number is the answer.** The green banner, in **PSIG at deck temperature** — that is what
  you charge to. Everything else justifies it.
- **PSIG vs PSIA — 14.7 psi apart.** The highlighted column is always the charge target.
- **Rounding is always UP**, to the nearest 25 psi. Never down, never "near enough".
- **Four conditions.** Charge (0) → charged subsea (1) → **ram closes (2)**. Condition 2 is what
  is left at the ram, and it is the one that has to beat the shear requirement.
- **Two independent checks**: enough *pressure*, and enough *volume* (FVR). Both must pass.
- **Failure is not the end** — the tool computes the lowest precharge that passes, +50, rounded
  up to the nearest 100.
- **A failing sheet cannot be posted.** It can be saved, exported and printed for review. The rig
  is never told a number that has not passed.
- **The method belongs to the equipment**, not to the engineer. A for subsea regulator legs, B
  for pilots, C for the dedicated-shear drawdown.

---

## Screenshot manifest — Module 2

Light mode, 1600 px wide, PNG, numbered to the steps above.

All shots are 1600 px wide, light mode, PNG, in `screenshots/`. Each is a true crop of a real
render of Rev 87 at the stated inputs — nothing composited or redrawn.

| # | Step | Shows | Status |
|---|---|---|---|
| 02-01 | 1 | Full page, freshly loaded | ✅ `02-01.png` |
| 02-02 | 2 | Header band, `Rev 87` visible | ✅ `02-02.png` |
| 02-03 | 3 | Asset dropdown open, all 13 | ❌ **not capturable** — see below |
| 02-04 | 5 | Locked hardware block, greyed | ✅ `02-04.png` |
| 02-05 | 8 | Well conditions, both temps | ✅ `02-05.png` |
| 02-06 | 11 | **Green verdict banner, 3,725 PSIG** | ✅ `02-06.png` |
| 02-07 | 12 | PSIG/PSIA pair, yellow column | ✅ within `02-06.png` |
| 02-08 | 14 | Method C drawdown, four conditions | ✅ `02-08.png` |
| 02-09 | 15 | Shear field mid-edit, 4,105 | ✅ within `02-05.png` |
| 02-10 | 16 | **Red FAILS banner** | ✅ `02-10.png` |
| 02-11 | 17 | Green OPTIMUM banner, 3,900 | ✅ `02-11.png` ⚠ contains the stale sentence |
| 02-12 | 18–19 | **Contractual panel FAILING**, all four cases + sequence | ✅ `02-12.png` |
| 02-12b | — | The same panel **PASSING**, for the before/after | ✅ `02-12b.png` |
| 02-13 | 22 | **Post refusal dialog** | ❌ native dialog — **verbatim text is in step 22** |
| 02-14 | 23 | Neptune selected, hardware changed | ✅ `02-14.png` |
| 02-15 | 24 | BOP selector | ✅ `02-15.png` |
| 02-16 | 26 | Precharge Summary table, **BOP 1** | ✅ `02-16.png` |
| 02-17 | 28 | Same table, **BOP 2** — side-by-side with 02-16 | ✅ `02-17.png` |
| 02-18 | 30 | Save dialog / saved filename | ❌ OS dialog, not part of the tool |

**Three shots are deliberately not supplied**, because a faithful capture is not possible and a
mocked-up one would be worse than none:

- **02-03** — an open native `<select>` is drawn by the operating system and does not appear in
  a page capture. The thirteen assets are listed on the Module 2 slide instead.
- **02-13** — `alert()` is a browser dialog, outside the page. **The exact text is reproduced
  verbatim at step 22** and is the better asset anyway: it can be read aloud and put on a slide.
- **02-18** — the OS save dialog, which looks different on every machine.

**02-12b is an extra** beyond the original manifest: the same contractual panel *passing*. Put
it beside 02-12 and the −5 psi / −0.74 gal failure reads at a glance.
