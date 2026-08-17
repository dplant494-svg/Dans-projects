# Handoff — Marine Integrity on the TSC Reports Dashboard

**For:** the reporting-tools session (WCGRRT), to write the **end-to-end
Marine Integrity instructional** for users.
**From:** the dashboard/scanner session (`Dans-projects`, live
`C:\TSC-Dashboard`, scanner `Update-Dashboard.ps1` v2.31).
**Date:** 2026-08-17.
**Replies to:** your `DASHBOARDMARINEINTEGRITYHANDOFF.md` (WCGRRT REV 145).

---

## 1. Status: shipped and live

Everything your handoff asked for is built, deployed, and confirmed working
in production by Dan. Your three sample exports are what's currently
displayed. This doc gives you the dashboard-side facts you need so the
instructional you write matches what users actually see.

> **IMPORTANT for the instructional — current data is DEMO ONLY.**
> The three reports now visible on the dashboard (West Jupiter 2026-03-12,
> West Jupiter 2026-08-14, West Gemini 2026-07-29) are the sample files you
> generated for integration testing. They are not real assessments. The
> instructional must say so wherever screenshots of the current state are
> used. To clear the demo data when real reporting starts: delete those
> three `seadrill-report_marineintegrity_*.json` files from SharePoint
> **WellControl / PostedReports**; on the next scan they disappear from the
> dashboard automatically (nothing else to clean up — no separate database).

## 2. The end-to-end journey (what the instructional should walk through)

1. **Fill in** the Marine Integrity Report in WCGRRT (your side — you know
   this part better than we do).
2. **Post it** the normal way: Power Automate → SharePoint
   **WellControl / PostedReports**, as `seadrill-report_<rig>_<date>*.json`.
   Nothing marine-specific here — same path as every other report.
3. **Wait for the scan.** A scheduled task on Dan's workstation runs the
   scanner roughly **every 10 minutes** (it can also be run on demand).
   The scanner reads the file, extracts the marine payload, and publishes
   updated dashboard data to the server automatically.
4. **View it** on the TSC Reports Dashboard
   (`\\sdrlazneuiis01d.corp.local\sacred\dashboard\dashboard.html`) →
   **Marine Integrity** tab. First view after an update may need a hard
   refresh (**Ctrl+F5**) — browsers cache the page.

## 3. What users see on the dashboard (describe this accurately)

**Routing:** Marine Integrity Reports do **not** appear in the Well
Control rig-visit Report List, its counts, charts, or filters — exactly as
your handoff asked. They live entirely under the **Marine Integrity** tab.
(Tell users this explicitly — otherwise the first thing they'll say is "my
report isn't in the list.")

**Marine Integrity tab — fleet view:**
- One card per rig, showing the **latest** report only, ranked **lowest
  overall average first** so outliers lead the view.
- Overall average shown large, **red below the 3.0 target, green at/above**
  (your RAG rule, mirrored exactly).
- The three section averages (Policies & Procedures / Regulatory /
  Equipment & Systems), each RAG'd the same way. A section with nothing
  scored shows **"not scored"** — never 0.
- Report date and items-scored count.
- Red ⚠ attention lines whenever these are non-empty: `mi_certexp`
  (certs due ≤ 3 months), `mi_asidef` (ASI deficiencies), `mi_classcc`
  (conditions of Class).

**Card click — per-rig detail:**
- **Score trends**: four charts (Overall + the three sections), one data
  point per report, fixed 1–4 scale, orange **target line at 3.0**. This
  is the headline view your handoff said the Marine department wants —
  each new report adds a point automatically.
- **Report picker** (defaults to latest) driving a per-report drill-down:
  - **Action list** — every item scored **1 or 2**, with its comment.
  - **Executive summary** — all nine fields, with **Non-Conformities
    highlighted in red and labeled "(to Synergi)"** as the action prompt.
  - The same ⚠ attention flags.
  - **Open full report** button.
- **Full report viewer**: complete score summary, installation
  information, executive summary, and every scored item with its
  comment, per section. Print / Save as PDF works here like any other
  report (though your tool's own branded PDF remains the formal output).

## 4. Data-handling rules worth stating in the instructional

- **One report per rig per date.** If the same rig posts twice with the
  same report date, the newest file wins — the earlier same-date file is
  superseded. Different dates are all kept (that's what builds trends).
- **Unscored items are excluded from averages** (we display your
  pre-computed `avg_*` values as-is; we verified a recomputation matches).
- **New checklist items appear automatically** — the dashboard iterates
  the keys, nothing is hard-coded to the current 73 items. Template
  revisions on your side need no dashboard change as long as the
  `mi_<section>__<slug>` / `_cmt` key convention holds.
- **A comment on any item is preserved and shown** even if the item was
  left unscored.

## 5. Separate outstanding item on your side (not marine)

While you're in WCGRRT: the **Daily Checks page still exports with no rig
identity** — real submissions are arriving with `meta.asset` and
`meta.checks.rig` both blank (latest: `seadrill-daily-checks_rig_2026-08-16_Day.json`)
and the scanner has to skip them with a warning. Crews are losing their
work. The FLM page populates `checks.rig` correctly — Daily Checks needs
the same. Please prioritise; happy to re-test with a fixed export.

## 6. If something doesn't show up (troubleshooting for the instructional)

1. Wait one scan cycle (~10 min), or Dan can run the scanner manually.
2. Hard-refresh the dashboard (**Ctrl+F5**).
3. Check the file actually landed in **PostedReports** and follows the
   `seadrill-report_*.json` naming.
4. If the scanner prints a `Skipping <file>` warning, the warning text
   says exactly why — send it to Dan.
