# Exercise sample files — the trainer's answer key

**Three saved (not posted) reports**, one per rig family, for the Day 2 exercise on
**20 October 2026**. Each loads straight back into the calculator through **Load .json**.

> **SSCE Equipment was dropped on 29 September** (operator: *"not interested in SSCE, use real
> rigs"*). These are **real rig presets with real hardware and real physics**, carrying an
> unmistakable training well name. The marker travels into the sheet header, the PDF and the
> filename, so no artefact here can be mistaken for an issued precharge.

**Only verified rigs are used.** Auriga, Jupiter, Carina, Polaris, Saturn, Capella and Sevan
Louisiana are flagged *not yet reviewed* — a trainee must not be handed a "known-good answer"
built on numbers that have not been through the rig-by-rig check.

---

## How to use them

1. Trainee works the case from the request sheet and produces their own result.
2. Trainer loads the matching file here via **Load .json**.
3. Compare. The figures below are what the file must reproduce.

**Nothing is posted.** These are *saved* files, produced by the calculator's own
`collectState()` — the same object the **Save .json** button writes.

---

## File 1 — West Tellus · DCB dedicated shear, single stack

`Seadrill_Precharge_tellus_TRAINING-01-NOT-ISSUED_TRAINING.json`

| Input | |
|---|---|
| Water depth | 7,000 ft |
| Subsea / deck temp | 38 °F / 78 °F |
| Min shear pressure | 2,600 PSIG |
| MAWHP | 3,900 psi |

**Known-good answer**

> **SET PRECHARGE (DCB TABLE): 3,725 PSIG** (gauge) / 3,740 PSIA @ 78 °F — **CHECKS PASS ✓**
> Table value 3,704, rounded up to the nearest 25.

| | |
|---|---|
| Condition 0 — surface precharge | 3,725 PSIG @ 78 °F |
| Subsea P1 (field procedure) | 3,333 psia at 38 °F |
| Condition 1 — charged subsea | 4,945 PSIG |
| Condition 2 — shear ram close | **4,045 PSIG** vs 2,600 required |
| FVR | 46.00 × 1.1 = **50.60 gal** |
| Petrobras contractual panel | **PASS**, all four cases |

**The extension, if the group is quick.** Change the shear requirement to **4,105** — the
hardest tubular in the fleet, a real open item (register T-20). The sheet fails, the tool raises
the precharge to **3,900**, and the contractual second cut still fails by **−5 psi and
−0.74 gal**. The post is then refused. That is Module 2 Part B.

---

## File 2 — West Neptune · DCB dedicated shear, split 4+4, dual stack

`Seadrill_Precharge_nov_TRAINING-02-NOT-ISSUED_TRAINING.json`

| Input | |
|---|---|
| BOP | **1** |
| Water depth | 6,500 ft |
| Subsea / deck temp | 40 °F / 78 °F |
| MAWHP | 12,000 psi |
| Shear (preset) | 3,826 |

**Known-good answer** — header reads `West Neptune BOP 1 — TRAINING-02 NOT ISSUED`, and the
output is a **per-accumulator** table, not a single figure:

| Accumulator | Method | Surface PC | Subsea precharge | BAR |
|---|---|---|---|---|
| Blue POD Pilot | B | 1,500 | **5,156** PSIG | 355.5 |
| Subsea Manifold Reg. Pilot | A | 850 | **3,743** PSIG | 258.0 |
| Subsea LMRP Connector Reg. Pilot | A | 400 | **3,293** PSIG | 227.0 |
| Subsea Stack Connector Reg. Pilot | A | 400 | **3,293** PSIG | 227.0 |
| Subsea Upper Annular Reg. Pilot | A | 400 | **3,293** PSIG | 227.0 |

**The teaching point.** Switch the BOP selector to **2**. *Every calculated value stays the
same* — only the header changes. Both stacks are identical hardware and the rig uses one fixed
gas density, so the precharge genuinely is the same. The selector **labels** the sheet so the
dashboard files it against the right stack; it is not a calculation input.

---

## File 3 — West Gemini · PISTON dedicated shear

`Seadrill_Precharge_gemini_TRAINING-03-NOT-ISSUED_TRAINING.json`

| Input | |
|---|---|
| Water depth | 5,000 ft |
| Subsea / deck temp | 42 °F / 78 °F |
| MAWHP | 10,000 psi |
| Shear (preset) | 2,050 PSIG |

**Known-good answer**

> **API OPTIMUM PRECHARGE: 4,750 PSIG @ 78 °F**
> API 16D Method C optimum (ρ₀ = ρ₂). After drawing FVR 41.03 gal the BSR closes at
> **3,679 > 2,050** required; deliverable above shear **118.51 gal** ≥ FVR.

| Condition | | |
|---|---|---|
| 0 — precharge (surface) | 4,750 PSIG | 78 °F |
| 1 — charged subsea | 4,971 PSIG | 42 °F |
| 2 — BSR close (after FVR) | **3,679 PSIG** | 18 °F |

**Why this one is included.** Gemini's dedicated shear is **conventional 110 USG piston
accumulators, not DCBs** — gas pressure equals hydraulic pressure 1:1, with no ×1.184
intensifier and no depth compensation. So there is **no OEM precharge table** to read from; the
tool computes an API optimum instead. Put beside Tellus, it shows that the *method belongs to
the equipment*, which is the point Module 2 step 27 makes.

---

## Verification

Every file was produced by loading the delivered build, running the real `applyPreset()` and
`compute()`, and serialising the real `collectState()` — not hand-written and not trimmed down
from a posted export.

Each was then **round-tripped**: loaded back through the real `loadState()` and checked to
reproduce the same rig, the same training well and the same sheet. Harness:
`build/_verify_samples.js`.

```
ok   Seadrill_Precharge_gemini_TRAINING-03-NOT-ISSUED_TRAINING.json
ok   Seadrill_Precharge_nov_TRAINING-02-NOT-ISSUED_TRAINING.json
ok   Seadrill_Precharge_tellus_TRAINING-01-NOT-ISSUED_TRAINING.json
=== all sample files load and reproduce ===
```

**Nothing in the tool was changed to produce these** — generated against
`Seadrill BOP Precharge Calculator.html` at `13BCC05B46112D72…`, unchanged before and after.
