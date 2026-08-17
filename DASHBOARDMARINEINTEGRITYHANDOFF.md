# Handoff — Marine Integrity Report → TSC Marine Integrity Dashboard

**For:** the dashboard/scanner session (`Dans-projects`, live `C:\TSC-Dashboard`).
**From:** the reporting-tools session (WCGRRT **REV 145**).
**Date:** 2026-08-17.
**Related:** `DASHBOARD-SHAREPOINT-INGESTION-HANDOFF.md` (how files arrive),
`PLANNING-DASHBOARD-ROUTING-HANDOFF.md` (routing pattern to copy).

---

## 1. What's new

WCGRRT can now produce a **Marine Integrity Report** — a scored marine
compliance assessment (the Marine department's equivalent of a rig-visit report).
It posts through the **same** mechanism as everything else (Power Automate →
SharePoint **WellControl / PostedReports**), so ingestion is unchanged. This doc
covers **routing** it away from the Well Control views and the **data shape** for
a future TSC Marine Integrity dashboard with score trending.

## 2. How to identify one

| Marker | Value |
|---|---|
| `meta.discipline` | `"Marine"` |
| `meta.type` (visit classification) | `"Marine Integrity Report"` |
| tile | `tiles[].marineData` is a non-null object |
| tile title | `"Marine Integrity Report"` |

**Routing ask:** treat `meta.discipline === "Marine"` like Planning — send it to
the **Marine** view, and **exclude it from the Well Control / rig-visit Reports
list**. (Same one-line exclusion approach as the planning-routing handoff.)

## 3. Data shape — `tiles[].marineData`

One flat object. Keys are stable and generated from the item text, so they're safe
to trend on.

### 3.1 Pre-computed metrics (use these for the dashboard)

| Key | Type | Meaning |
|---|---|---|
| `avg_pol` | number \| null | Average score — Marine Policies & Procedures (8.1.1) |
| `avg_reg` | number \| null | Average score — Regulatory (8.1.2) |
| `avg_eqp` | number \| null | Average score — Equipment & Systems (8.1.3) |
| `avg_overall` | number \| null | Overall average across all scored items |
| `target` | number | Minimum target score — currently **3.0** |
| `scoredCount` | number | How many items were scored (denominator; unscored items are excluded) |

`null` means nothing scored in that section yet. **RAG rule used in the tool:**
below `target` = red, at/above = green. Please mirror that.

### 3.2 Installation information

`mi_unit`, `mi_imo`, `mi_callsign`, `mi_design`, `mi_built`, `mi_flagclass`,
`mi_cor`, `mi_radio`, `mi_asiflag`, `mi_asidef`, `mi_iopp`, `mi_ispp`, `mi_iapp`,
`mi_issc`, `mi_ism`, `mi_loadline`, `mi_modu`, `mi_class`, `mi_classcc`,
`mi_tplifeboat`, `mi_tpfire`, `mi_certexp`, `mi_client`, `mi_field`,
`mi_location` — all strings (free text, e.g. "Due on 12 Mar 2027").

`mi_certexp` (certificates expiring within 3 months) and `mi_asidef` (open ASI
deficiencies) are the two worth surfacing as attention flags.

### 3.3 Executive summary

`mi_ex_<area>_<type>` where `<area>` = `pol` | `reg` | `eqp` and `<type>` =
`bp` (Best Practices) | `nc` (Non-Conformity) | `ip` (Improvement Proposal).
Nine free-text fields, e.g. `mi_ex_reg_nc`.

> Non-conformities are required to be entered into **Synergi** — worth showing
> `*_nc` prominently as the action-tracking prompt.

### 3.4 Scored items

```
mi_<section>__<item_slug>        → "" | "1" | "2" | "3" | "4"   (score)
mi_<section>__<item_slug>_cmt    → comment string
```

`<section>` = `pol` | `reg` | `eqp`. `<item_slug>` is the item text lowercased
with non-alphanumerics collapsed to `_`.

Examples:

```
mi_pol__quality_of_induction              = "3"
mi_pol__quality_of_induction_cmt          = "OIM participated, muster tour done"
mi_pol__ballasting_de_ballasting          = "2"
mi_reg__all_dp_operators_certified        = "4"
mi_eqp__all_lifeboats_in_good_working_order = "3"
```

**Counts:** 24 items in `pol`, 21 in `reg`, 28 in `eqp` (**73 total**). An empty
string means not scored — exclude from averages (the tool already does).

Scores mean: **4** good · **3** acceptable · **2** poor · **1** very poor. The
full guideline text is printed on the report.

## 4. What the dashboard should show (suggested)

- **Per-rig card:** overall average vs the 3.0 target (RAG), the three section
  averages, `scoredCount`, and report date.
- **Trend:** `avg_overall` and the three section averages **over time per rig** —
  this is the headline the Marine department wants. Each report is one data point
  (key on `meta.asset` + report/tile date).
- **Fleet view:** rigs ranked by `avg_overall`, so outliers are obvious.
- **Drill-down:** items scored **1 or 2** listed with their `_cmt` — that's the
  actionable list. Plus the nine executive-summary fields.
- **Attention flags:** `mi_certexp` non-empty, `mi_asidef` non-empty, `mi_classcc`
  non-empty.

## 5. Notes

- Item sets may grow as the template is revised. **Don't hard-code the 73 items** —
  iterate keys matching `^mi_(pol|reg|eqp)__` and ignore `_cmt` suffixes when
  reading scores. New items then appear automatically.
- `avg_*` are already computed in the tool, so the dashboard doesn't need to
  recalculate — but recomputing from the raw scores is a valid cross-check.
- Nothing about posting/ingestion changed. These land in **PostedReports** as
  `seadrill-report_<rig>_<date>*.json` like other WCGRRT reports.
- The tool renders its own branded PDF; the dashboard only needs the data.
