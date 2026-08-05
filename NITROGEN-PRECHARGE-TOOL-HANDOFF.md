# Handoff — BOP Accumulator Nitrogen Precharge Calculator's JSON export

**Audience: whoever maintains the Seadrill BOP Precharge Calculator tool.**

The dashboard pipeline (`dplant494-svg/Dans-projects` repo) ingests this
tool's `.json` export and shows a summary on the BOP Fleet Planning
Dashboard. Right now that summary is thin — a handful of input numbers and
whichever "manual precharge" value was typed in — because **the `.json`
export only contains the raw inputs, not the tool's own calculated
output.** Everything genuinely useful (the per-accumulator precharge
table, the shear/volume check, the temperature curve) is computed live in
the browser and only ever reaches the printed PDF, never the save file.

This document specifies what to add to the export so the dashboard can
show the same thing the PDF does. **Everything below is additive** — don't
rename or remove anything already in `fields`/`config`/`units`/`touched`;
just add a new top-level `results` object alongside them.

## What the PDF has that the `.json` doesn't

Comparing a real export (`Seadrill_Precharge_gemini_Burututu01_20260803_1.json`)
against its own PDF (`West_Gemini_Burututu_01_precharge_1.pdf`) side by
side, three things are missing entirely:

1. **The per-accumulator precharge table** — ~30 rows across four
   sections (Blue POD, Yellow POD, LMRP, Lower Stack), each with type,
   size, quantity, MWP, surface precharge, calc method, and the final
   "precharge for location" figure.
2. **The EHBS Shear Volume / Pressure Check** — the API-optimum-precharge
   derivation: the FVR (fluid volume required) calculation, the Method C
   drawdown conditions (0/1/2), and the PASS/FAIL checks against MWP and
   required shear.
3. **The Precharge vs Temperature operating-window curve** — precharge
   set point plus a full °F/°C/PSIG/BAR table across the tool's ±15°F
   window.

## Proposed schema addition: `results`

```json
{
  "meta": { "...": "unchanged" },
  "config": "gemini",
  "units": { "...": "unchanged" },
  "touched": { "...": "unchanged" },
  "fields": { "...": "unchanged - keep every existing input field" },
  "hops": [],

  "results": {
    "config": "gemini",
    "method": "C",
    "apiOptimumPrechargePsig": 3400,
    "apiOptimumTempC": 20.0,
    "requiredShearPsig": 2800,
    "generatedAt": "2026-08-03T14:25:53-05:00",

    "accumulators": [
      {
        "section": "Blue POD",
        "name": "Pilot",
        "type": "Bladder",
        "sizeGal": 2.5,
        "qty": 3,
        "mwpPsig": 7500,
        "surfacePrechargePsig": 1500,
        "method": "B",
        "prechargeForLocationPsig": 1681
      },
      {
        "section": "Blue POD",
        "name": "Surface Manifold Reg.",
        "type": "Pilot Piston",
        "sizeGal": 0.5,
        "qty": 1,
        "mwpPsig": 7500,
        "surfacePrechargePsig": 850,
        "method": null,
        "prechargeForLocationPsig": null,
        "note": "surface function"
      }
      // ... one entry per row of the PDF's Precharge Summary table,
      // in the same section order shown there (Blue POD, Yellow POD,
      // LMRP, Lower Stack)
    ],

    "shearCheck": {
      "headline": "API OPTIMUM PRECHARGE: 3,400 PSIG @ 20.0°C",
      "narrative": "API 16D Method C optimum (rho0 = rho2 - balances pressure- & volume-limited efficiency). After drawing FVR 41.03 gal the BSR closes at 4,132 > required 2,800 PSIG; deliverable above shear 136.67 gal >= FVR.",
      "fvr": [
        { "label": "BSR - shear & seal (UBSR +lock, +10%)", "gal": 37, "df": 1.1, "totalGal": 41.03 },
        { "label": "Total FVR required", "totalGal": 41.03 }
      ],
      "drawdown": [
        { "condition": "Condition 0 - precharge (surface)", "pressurePsig": 3400, "tempC": 20.0, "note": "API optimum rho0=rho2" },
        { "condition": "Condition 1 - charged subsea", "pressurePsig": 5015, "tempC": 5.0, "note": "supply + control-fluid head" },
        { "condition": "Condition 2 - BSR close (after FVR)", "pressurePsig": 4132, "tempC": -7.9, "note": "adiabatic end" }
      ],
      "checks": [
        { "check": "API optimum precharge (rho0=rho2)", "value": "3,400 PSIG", "criterion": "<= MWP rating 7,500", "result": "PASS" },
        { "check": "BSR closing (Condition 2)", "value": "4,132 PSIG", "criterion": "> required shear 2,800", "result": "PASS" },
        { "check": "Deliverable fluid above required shear", "value": "136.67 gal", "criterion": ">= FVR 41.03 gal", "result": "PASS" },
        { "check": "Total stored fluid (to ambient)", "value": "283.54 gal", "criterion": "info only", "result": "-" }
      ]
    },

    "temperatureCurve": {
      "title": "Precharge vs Temperature - +/-15F Operating Window",
      "setPoint": { "tempF": 68, "prechargePsig": 3400 },
      "rows": [
        { "tempF": 53, "tempC": 12, "prechargePsig": 3259, "bar": 224.7 },
        { "tempF": 55, "tempC": 13, "prechargePsig": 3277, "bar": 226.0 }
        // ... one row per line of the PDF's F/C/Precharge/BAR table
      ]
    }
  }
}
```

### Formatting notes

- **Store plain numbers, not comma-formatted strings.** The PDF displays
  `1,681` and `3,400` for readability; the JSON should store `1681` and
  `3400` (numbers, or numeric strings without thousands separators) so the
  dashboard can format them however it needs to.
- `method` is one of `"A"`, `"B"`, `"C"`, or `null` where the PDF shows a
  dash (rows marked "surface function" in the PDF aren't part of the
  subsea calculation — carry that through as `note` on those rows,
  `prechargeForLocationPsig: null`).
- `result` in `checks[]` is `"PASS"`, `"FAIL"`, or `"-"` for info-only
  rows (matches the PDF's own wording, so don't need a separate enum).
- Field names above are suggestions, not requirements — if the tool's own
  internal variable names differ, use whatever's natural on your end. The
  scanner reads these by name, so just document whatever you actually ship
  and the dashboard side will be built to match it.

## Why this shape, specifically

- **One `results` object, not scattered top-level keys** — keeps the
  input/output distinction clean: `fields` is what the user typed,
  `results` is what the tool calculated from it. Easy to tell apart when
  debugging a mismatch later.
- **Arrays of plain objects**, not the same `{v: "..."}` wrapper used in
  `fields` — that wrapper exists because `fields` mirrors live form-control
  state (value + checked); computed results aren't form controls, so a
  plain value is clearer and there's nothing to "touch."
- **No change to `fields`/`config`/`units`/`touched`/`hops`** — those still
  work exactly as they do today; this is a pure addition.

## What happens on the dashboard side once this lands

The BOP Fleet Planning Dashboard's per-rig "Nitrogen Precharge" panel
currently shows only water depth/temps/shear-required/manual precharge
value, with those numbers pulled straight from `fields`. Once `results`
exists, the "View full precharge details" button (already built) will be
extended to render the same three things the PDF shows: the
per-accumulator table, the shear/volume check, and the temperature curve —
so the dashboard becomes a genuine substitute for opening the PDF, not
just a pointer to it.

## How to verify (once implemented)

1. Export a test precharge report from the tool.
2. Confirm the `.json` now has a `results` object matching the shape
   above (or your own equivalent — just tell Dan/the dashboard team what
   you actually used).
3. Drop it in the shared reports folder and run
   `scripts\Update-Dashboard.ps1` — no scanner changes needed for this to
   be picked up safely (new keys are always safely ignored until the
   dashboard side is built to read them).
4. Send a sample export back so the dashboard side of this can be built
   against real data rather than this spec alone.
