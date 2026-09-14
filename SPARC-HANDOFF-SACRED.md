# SPARC — Project Handoff & Briefing
### Seadrill Parts And Recertification Catalogue
**Prepared for:** the Claude session analysing the Seadrill Well Control Equipment (WCE) toolset for **Project SACRED**
**Prepared by:** Claude Code, on behalf of Lee Arnold (WCE Manager, Seadrill)
**Date:** 14 September 2026
**Status:** Live / in production use (deployed to the SSORT file share)

---

## 0. How to use this document (note to the receiving Claude)

This is a self-contained briefing on **SPARC**, one of several WCE digital tools that Project SACRED is drawing together. It explains what SPARC is, every attribute it holds, how it links to **Maximo**, its build history/effort, and the planned roadmap. It is written so you can (a) place SPARC correctly in the SACRED landscape, and (b) build a project timeline that includes SPARC alongside the sibling tools you are also analysing:

- **SACRED Cloud dashboard** (the unifying WCE dashboard)
- **WCE Certification Tracker**
- **CoC Register** (Certificate of Conformity register)
- **SORT** (and the `SSORT` distribution share)
- **WCE Rig Report**

Wherever SPARC shares a **join key** with those tools (SFI location code, Seadrill ICN, Job Plan number, Master PM, Rig/Asset, equipment make/model), it is called out explicitly in §6 and §8 — those are the fields SACRED can use to stitch the tools together.

> **KEY FACTS (structured, for quick parsing)**
> - name: SPARC — Seadrill Parts And Recertification Catalogue
> - type: self-contained offline web application (single-file HTML build + multi-file installable PWA build)
> - purpose: unified searchable catalogue of subsea WCE parts + engineering diagrams + recertification/job-plan linkage, with order-list building
> - scope: ~2,868 catalogued parts across 6 equipment databases + a 255-row Job Plan Parts Matrix + 178 NOV job plans
> - diagrams: ~376 balloon-numbered engineering drawings
> - maximo_link: static (point-in-time) — carries Seadrill ICN, SFI location, unit cost, item status, job plans (0900-xxxx), Master PM (Cxxxx); no live API yet
> - deployment: `\\sdrlazneuiis01d.corp.local\SSORT\SPARC.html` (single self-contained file) + hosted PWA option
> - toolchain: pure PowerShell + C# (Add-Type); no Node.js / Python on the build machine
> - status: in use; actively extended (latest additions Aug–Sep 2026)

---

## 1. Executive summary

**SPARC is a single, offline digital catalogue that brings the fleet's subsea well control equipment — its parts, engineering diagrams and recertification data — into one searchable, orderable reference.** For any assembly (BOP rams and doors, MUX control pods, EHBS and Acoustic pods, motion-compensation valves, riser/WCE components) an engineer can search or browse to the item, see it called out by **balloon number on the actual engineering drawing**, read its NOV/OEM/OilGear part numbers, its **Seadrill ICN** and **unit cost**, and build a costed **order list** that exports to CSV or print — all with **zero installation**, working **offline on desktop, tablet or phone**.

Layered on top of the parts data is a **Job Plan Parts Matrix** that ties each **SFI equipment location** to its Maximo maintenance and recertification **job plans** across the full interval set (BWM / 1M / 12M / 24M / 36M / 60M / 120M), establishing the bridge from a maintenance task to the parts required to perform it.

SPARC's value to WCE operations: faster and more accurate parts identification and ordering, reduced downtime risk from wrong or late parts, and consistent recertification-parts planning across the fleet.

---

## 2. What SPARC is (core purpose & principles)

- **A parts + recertification catalogue**, not a transactional system. It is a fast, authoritative *reference and order-preparation* tool that sits alongside (not inside) Maximo.
- **Self-contained and offline-first.** The entire catalogue — data, ~376 diagrams, search, ordering, CSV/print — runs with no server and no connectivity once loaded. This is deliberate: WCE work happens on rigs and in workshops with poor connectivity.
- **Cross-platform, zero-install.** One file works on Windows desktop, iOS and Android. Also available as an installable PWA (home-screen app) when hosted over HTTPS.
- **Engineer-facing.** Organised the way the equipment is (by assembly, with balloon-numbered drawings), not the way a database is.

---

## 3. Scope & contents

SPARC is organised into **top-level databases** (the buttons across the top bar). Each database holds one or more **tabs** (equipment assemblies), and each tab is a **balloon-numbered Bill of Materials** matched to its engineering drawing(s).

| Top-level database | What it covers | Tabs | Parts (rows) |
|---|---|---:|---:|
| **MUX POD** (OilGear/NOV control pod) | 5th-Gen MUX control pod — frame, grippers, manifolds, SPM manifolds, accumulators, compensator chambers, gauges, etc. | 31 | 886 |
| **WCE Parts DB** | Well control equipment components — Failsafe Assist, C&K spool, Hotline & Conduit Valve manifolds, acoustic/EHBS spares, SBOP, stabs, connectors, riser adapter, rams, etc. | 29 | 748 |
| **BOP Door** | BOP stack door/ram hardware — 14" & 22" NXT ram assemblies, door hinge parts, lock-drive, ram-shaft seals, LFS shear-ram, triple body, etc. | 25 | 892 |
| **Motion Comp Equip (MCE)** | Motion-compensation valves — ARV / MCV OilGear valve models (spare-parts assy drawings + graphic-symbol schematics) | 10 | 250 |
| **EHBS** | Emergency Hydraulic Backup System pod (Saturn-specific), 5th-Gen MUX — pod assembly BOM + full drawing package | 1 | 44 |
| **Acoustic Pod** | Acoustic control pod (Saturn-specific), 5th-Gen — pod assembly BOM + full drawing package | 1 | 48 |
| **Job Plan Parts Matrix** *(was "Recert Matrix")* | Per-SFI-location matrix of maintenance/recert **job plans** by interval, cross-referenced to make/model | — | 255 SFI locations |
| **All** | Cross-database search view | — | — |

**Totals:** ~**2,868 catalogued parts**, **~376 balloon-numbered diagrams**, **178** NOV maintenance job plans in scope, **255** SFI equipment locations in the matrix.

> EHBS and Acoustic are currently **Saturn-specific** (one rig tab each) by design — they were built to start compiling fleet differences and are the first candidates for fleet-wide rollout (see §10).

---

## 4. Features / attributes

- **Search** across all parts, part numbers and ICNs (global and per-database).
- **Balloon-numbered diagrams** — the real engineering drawings, with a **Balloon Quick-Add palette**: click a balloon number to jump to / add that part.
- **Rich parts table** per assembly: Balloon · Seadrill ICN · SFI Group · Part No(s) · Qty · Unit cost · Description · order stepper.
- **Order-list builder** — add parts (with quantities) across assemblies into named "assets/orders"; running **cost totals**; **Export to CSV** and **Print**, both made iOS-robust (share sheet + hidden-iframe print).
- **Job Plan Parts Matrix** — equipment/SFI location → job plans at every interval (BWM/1M/12M/24M/36M/60M/120M) → Master PM, with make/model and vendor.
- **Offline & installable** — PWA (service worker precache + runtime image cache) and a fully **standalone single HTML file** (~139 MB, all data + base64 images inlined).
- **Seadrill-branded** — Seadrill Blue `#002C77` / Yellow `#EDB71E`, Arial, logo; RAG colours preserved where used.

---

## 5. Data model (per-part attributes)

Every part row carries (field names as stored in the data):

| Field | Meaning |
|---|---|
| `bn` | Balloon number (maps to the callout on the drawing) |
| `nov_pn1` / `nov_pn_short` | Primary NOV / OEM part number |
| `nov_pn2` / `oracle_pn` / `og_pn` | Secondary PN — Oracle ERP PN, or OilGear PN, or Teamcenter PN |
| `description` | Part description |
| `qty` / `bom_qty` | Quantity per assembly |
| `seadrill_icn` / `icn` / `maximo_icn` | **Seadrill ICN** (Maximo item number) |
| `icn_sfi` / `maximo_sfi` | **SFI Group ID** (equipment location taxonomy) |
| `unit_cost` | **Unit cost (USD)** — "Last Price" from the item export |
| `icn_status` / `maximo_status` | Item status (e.g. ACTIVE) |
| `icn_mfr` / `maximo_mfr` | Manufacturer |
| `icn_src` | Source of the match (e.g. `SFI332`) |
| `vendor_cat` | Vendor category (NOV / OilGear-Olmsted / Supplier / not confirmed) |
| `has_bubbles` | Whether the tab is balloon-aligned (shows the quick-add palette) |

**Job Plan Parts Matrix** row schema adds: `group`, `equipment`, `location_sfi`, `make_model`, `oem`/`cem`, `vendor`, `cert_type` (e.g. COC), `job_plan_60m`, `job_plan_120m`, `master_pm_60`, `master_pm_120`, `maximo_desc_60/120`, `qp_5yr`, `qp_10yr`, and the interval columns `jp_bwm`, `jp_1m`, `jp_12m`, `jp_24m`, `jp_36m` (+ `jp_60m_nov`, `jp_120m_nov`).

There is also a companion **`SPARC_Master_Data.xlsx`** — the same data expressed as **8 native Excel Tables** (`tbl_MuxPod`, `tbl_WCE`, `tbl_BOP`, `tbl_MCE`, `tbl_EHBS`, `tbl_Acoustic`, `tbl_JobPlanMatrix`, `tbl_JobPlans`) with a dynamic "Candidate Job Plans" formula column — intended as the analyst-friendly / integration-friendly view of the dataset.

---

## 6. Maximo linkage  ⭐ (key section for SACRED)

**Current state:** SPARC holds a **static, point-in-time extract** of Maximo-derived data. It does **not** live-connect to Maximo (that is a planned evolution — §10). The value is that it has already *reconciled* NOV/OEM engineering part numbers against the Maximo item master and the WCE job-plan set.

**Fields sourced from Maximo / Seadrill systems, and how they map:**

| SPARC field | Source system | Maximo / Seadrill field | Notes |
|---|---|---|---|
| Seadrill ICN | Maximo item master | Item (ICN) | The primary join key to Maximo |
| Unit cost | Maximo / procurement | Last Price | Placeholder `$500.00` rows treated as "no confirmed price" |
| Item status | Maximo | Status (ACTIVE/…) | |
| Manufacturer / mfr PN | Maximo | Manufacturer / (Default) Manufacturer Part No | Used to match NOV PNs → ICN |
| SFI Group / location | Seadrill SFI taxonomy | SFI Group ID (e.g. `335.RIS1.410`) | Shared across Maximo & the whole WCE toolset |
| Job plan number | Maximo | Job Plan (`0900-xxxx`) | From the WCE Job Plans export |
| Master PM | Maximo | Master PM (`Cxxxx`) | 60M & 120M currently populated |
| Job-plan / PM description | Maximo | Description (60M/120M) | |
| Cert type, QP 5yr/10yr | Recert regime | COC / quality-plan flags | |

**Reconciliation method (how the links were built):**
1. **Item/cost/ICN** — NOV & manufacturer part numbers are normalised and matched against **five SFI item exports** (`SDITEM_SFI 331/332/334/335/336`, ~34k items) drawn from the Maximo item master by SFI group. Match rate ≈ 50% (unmatched are OEM assembly `-001` numbers and common fittings not held in these SFI groups — they still show balloon/PN/description/qty, just without ICN/cost).
2. **Job plans / PM** — the **Job Plan Parts Matrix** maps each SFI location to its Maximo job plans. Source = `WCE Job Plans.xlsx` (707 job plans; **column H = Make/Model**, column I = SFI Group, frequency in the description prefix, duration per plan). Filtered to **NOV make/model only** (178 plans), then each matrix row's existing 60M/120M job plan is used to resolve its Make/Model and pull the sibling plans at every interval (101 of 255 rows resolved to a NOV make so far).

**Why this matters to SACRED:** SPARC already carries the **ICN ↔ part ↔ SFI location ↔ job plan ↔ cost** relationships. The **SFI location code**, **ICN**, **Job Plan number** and **Master PM** are the natural join keys between SPARC and the Certification Tracker, CoC Register and Rig Report — SACRED can use them to answer, per SFI location: *what is due (job plan/PM), what certifies it (CoC/cert), and what parts + cost it needs (SPARC).*

---

## 7. Technical architecture (for a maintainer)

- **Two builds from one source of truth:**
  1. **Multi-file PWA** (`sparc/`) — open/host **`SPARC.html`** (not `index.html`). Data is delivered as classic `<script>` files (`src/data/*.js` → `window.OG/WCE/BOP/MCE/EHBS/ACOUSTIC/RECERT/…`) so it runs from `file://` (browsers block `fetch()` on `file://`). Canonical JSON kept in `sparc/data/*.json`; the `.js` globals are generated from it. Tailwind vendored locally; installable via `manifest.webmanifest` + `sw.js` service worker.
  2. **Standalone single file** — **`SPARC_standalone.html`** (~139 MB) with all data + ~376 diagrams inlined as base64. This is the file distributed on the share.
- **The `file://` UNC gotcha:** opening the multi-file build from a `\\server` share (UNC file share) blocks the separate scripts → app won't boot. Fix = the standalone single file (what's deployed) or serving over real HTTP (IIS).
- **Diagram pipeline:** engineering PDFs are rendered to PNG via the Windows `Windows.Data.Pdf` WinRT API from PowerShell (`DestinationWidth≈2400` for legible balloons); balloon BOMs are read from the drawing package; NOV PNs cross-referenced to the SFI exports for ICN + cost.
- **Toolchain:** built **entirely with PowerShell + C# (`Add-Type`)** — **no Node.js or Python** on the machine. Office COM (Excel/PowerPoint/Word) available and used for the Excel Tables workbook and the executive deck.
- **Deployment:** rebuild `SPARC_standalone.html`, copy to **`\\sdrlazneuiis01d.corp.local\SSORT\SPARC.html`**. Service-worker cache version is bumped each release so clients refresh.
- **Repeatable "add equipment" workflow** exists (read PDF → render diagram → cross-ref SFI → brace-safe JSON edit → regenerate JS → rebuild standalone → redeploy).

---

## 8. Development history, timeline & effort

**Origin:** SPARC grew out of a ~100 MB single-file HTML parts reference (`OilGear_WCE_Parts_Reference`, ~v7) — an inlined prototype that proved the concept but was unmaintainable.

**Phased development (Claude Code, AI-assisted):**

| Phase | ~Date (2026) | Work | Relative scope |
|---|---|---|---|
| 1. De-inline & platform | early–mid Jul | Split the 100 MB single file into a maintainable multi-file project; JSON data; hosted + `file://` support | Large |
| 2. Cross-platform + offline | Jul | iOS/Android support; installable **PWA** (manifest + service worker); **standalone single-file** build; iOS-robust CSV/print | Medium |
| 3. WCE content build-out | Jul–Aug | Failsafe Assist, Hotline & Conduit Valve manifolds; SPM PN corrections; **Motion Comp** valves with diagrams + balloons; NOV↔OilGear cost review | Large |
| 4. EHBS & Acoustic pods | Aug (8–10) | Two new top-level databases; page-specific balloon BOMs (EHBS drawing pkg pp.103–127; Acoustic pp.190–194 & 197–209); full diagram sets; SFI cross-ref | Large |
| 5. Job Plan Parts Matrix | Aug 11 | Renamed "Recert Matrix" → **Job Plan Parts Matrix**; cross-referenced Maximo WCE job plans (NOV col H) across all intervals | Medium |
| 6. Data & comms artefacts | Sep 14 | **Master Data Excel Tables** workbook (dynamic lookups); **Executive overview deck** (4 slides + animations + live screen-capture walkthrough) | Medium |

**Elapsed calendar time:** ~**10 weeks** of intermittent development (early July → mid September 2026), alongside other WCE duties.

**Man-hours:** _______________  *(to be populated by the timeline owner)*

> **Effort note for the timeline:** SPARC was built **AI-assisted with Claude Code**, which compressed the effort dramatically. A conventional build of the same scope — a cross-platform offline app, ingestion and reconciliation of ~2,900 parts and ~376 engineering drawings against the Maximo item master and WCE job-plan set, plus the recert matrix and packaging — would traditionally represent a **multi-month effort for a small team** (a developer plus a data/WCE analyst). Treat the AI-assisted actuals as materially lower than that traditional baseline; insert the confirmed figure above.

---

## 9. SPARC's place in Project SACRED

SPARC is the **parts & recertification-parts layer** of the WCE toolset. It answers: *for this equipment / SFI location / job plan — what parts are required, at what cost, from which vendor, and where are they on the drawing.*

**How it relates to the sibling tools you are analysing:**

| Tool | Owns | SPARC's relationship |
|---|---|---|
| **WCE Certification Tracker** | Certificate validity & due dates by equipment/SFI | SPARC supplies the **parts** needed to perform the recert the tracker is counting down to |
| **CoC Register** | Certificates of Conformity | Same SFI/ICN keys; SPARC = the parts side of the same equipment records |
| **WCE Rig Report** | Per-rig WCE status roll-up | SPARC can feed **parts readiness / order status** per rig into the report |
| **SORT / `SSORT` share** | Distribution & (per user) the WCE reporting/records system | SPARC is **published on the `SSORT` share** (`\\…\SSORT\SPARC.html`); shares the distribution channel |
| **SACRED Cloud dashboard** | Unifying WCE dashboard | SPARC is one feeder; its order lists / parts-readiness are a candidate widget |

**Shared join keys across SACRED:** `SFI location code`, `Seadrill ICN`, `Job Plan number (0900-…)`, `Master PM (Cxxxx)`, `Rig/Asset`, `equipment make/model`, `CoC number`. These are the columns SACRED can use to join SPARC to the other tools.

---

## 10. Planned future evolutions (roadmap)

1. **Parts → Job-Plan linkage (next phase).** Complete the Job Plan Parts Matrix by attaching the **exact parts** required for each NOV job plan / SFI location (not every part — the reviewed subset). A manual-alignment workbook has already been produced to capture the engineer's part selections per job plan, to be loaded back and uploaded. This turns SPARC from "parts by assembly" into "parts by maintenance task."
2. **Fleet-wide rollout.** Extend EHBS, Acoustic (and other databases) from **Saturn-only** to **per-rig tabs across the whole fleet**, compiling and surfacing equipment differences rig-by-rig.
3. **Live Maximo integration.** Move from static SFI / WCE-Job-Plan **exports** to a **live feed** of ICN, Master PM, job plans, item status and cost from Maximo — so ICNs/costs/PM data stay current automatically.
4. **SACRED integration.** Surface SPARC **parts-readiness and order lists** into the **SACRED WCE dashboard**, joined to the CoC Register, Certification Tracker and Rig Report on the shared keys in §9.

---

## 11. Assets & locations

- **Deployed app:** `\\sdrlazneuiis01d.corp.local\SSORT\SPARC.html` (standalone single file)
- **Project root:** `…\Documents\Claude\Projects\SPARC\`
  - `sparc/` — multi-file PWA build (`SPARC.html`, `src/`, `data/`, `assets/diagrams/`, `sw.js`, `manifest.webmanifest`, `build/`)
  - `SPARC_standalone.html` — the distributable single file
  - `SPARC_Master_Data.xlsx` — the 8-table dynamic master data workbook
  - `SPARC_Executive_Overview.pptx` — 4-slide executive briefing (incl. live screen-capture GIF)
  - `SPARC_Nav_22in_Door.gif` / `SPARC_22in_Door_OrderList.gif` — demo animations
  - `SPARC_Handoff_SACRED.md` — **this document**
- **Source data feeds:** `sparc/SFI information/` (5× `SDITEM_SFI` item exports), `sparc/WCE PM Job Plans/WCE Job Plans.xlsx`, and the OEM drawing packages (EHBS / Acoustic / OilGear / NXT manuals).

---

## 12. Known limitations / caveats

- **Static data.** ICNs, costs, job plans and PM are a point-in-time extract; they drift from Maximo until phase-3 live integration lands.
- **~50% ICN/cost match rate.** OEM assembly `-001` numbers and common fittings aren't in the five SFI groups exported, so those rows lack ICN/cost (PN/qty/description still present).
- **EHBS/Acoustic = Saturn only** so far.
- **Standalone file is large (~139 MB).** Ideal on the share/desktop; heavy for e-mail. The PWA build is lighter but needs HTTP hosting.
- **Job-plan interval coverage** currently resolves 101 of 255 SFI rows to a NOV make/model (the NOV-only scope agreed for phase 1).

---

## 13. Glossary

- **SPARC** — Seadrill Parts And Recertification Catalogue (this tool)
- **SACRED** — the umbrella WCE dashboard/programme this feeds
- **ICN** — Item Control Number (Seadrill/Maximo item number)
- **SFI** — the equipment-location taxonomy/coding (e.g. `335.RIS1.410`); "SFI group" = the leading system number
- **CoC** — Certificate of Conformity
- **PM / Master PM** — Preventive Maintenance / its Maximo master record (`Cxxxx`)
- **Job Plan** — Maximo maintenance job plan (`0900-xxxx`)
- **BWM** — Between-Well Maintenance; other intervals = 1M/3M/6M/12M/18M/24M/36M/60M/120M (months)
- **WCE** — Well Control Equipment
- **BOP / LMRP** — Blowout Preventer / Lower Marine Riser Package
- **MUX POD** — multiplex control pod; **EHBS** — Emergency Hydraulic Backup System; **Acoustic Pod** — acoustic control pod
- **SPM** — Sub-Plate-Mounted (valve); **NXT** — NOV Shaffer NXT ram BOP; **ARV/MCV** — motion-comp valve models
- **QP 5yr / 10yr** — quality-plan / recert milestones
- **NOV** — National Oilwell Varco (primary OEM); **OilGear/Olmsted** — control-pod valve OEM

---

*End of handoff. For anything needing confirmation (man-hours, exact SACRED join design, live-Maximo scope), those are flagged inline and owned by the WCE Manager / SACRED timeline owner.*
