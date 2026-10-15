# ORR 27 — Local data and retention

**Owner:** Dan Plant, Technical Services — Subsea · **Date:** 30 September 2026
Storage keys enumerated from the deployed files, 30 September 2026.

---

## The short answer to the question ISIT is really asking

**Yes. Between the moment a crew starts a report and the moment it posts, the only copy is on that
rig's machine, in that browser.** Nothing is held server-side until a post succeeds. There is no
autosave to the network, no draft on a server, no sync.

The window is usually hours and can be days — a between-well maintenance report is built up across a
port call. If the machine is lost, re-imaged, or the browser profile is cleared in that window, the
report is gone and the work is done again. This has been survived once by the crew's own saved `.json`
files after a filename collision, which is why **💾 Save to File** is taught as a habit and not an
option.

---

## 1. Browser storage — `localStorage`, per browser, per machine, per origin

Written continuously as the crew types. **Origin-scoped**, so the same report opened from the share
path and from the IIS URL are two different stores.

| Key | Both / tool | What it holds |
|---|---|---|
| `sd_maint_tiles` | both | every report section, including all photographs as base64 — the bulk of it, typically megabytes |
| `sd_maint_meta` | both | rig, dates, personnel, BOP configuration |
| `sd_maint_checklist` | both | compliance checklist state and its appendices |
| `sd_maint_critical`, `sd_maint_actions`, `sd_maint_notes` | both | critical items, actions raised, notes |
| `sd_maint_eot`, `sd_maint_manualeot` | both | end-of-trip content |
| `sd_maint_photodump`, `sd_maint_photodump_eot` | both | the photo dump and its flag |
| `sd_maint_savedAt` | both | timestamp shown on the restore bar |
| `sd_post_url` | both | optional intake override (ignored by SSORT's post — KE-05) |
| `sd_maint_attachmeta` | WCGRRT | attachment metadata |
| `sdPlanLastReport::…` | WCGRRT | last planning report, per convention name |
| `sd_vessel_config` | SSORT | saved vessel/BOP configuration, reused between reports |
| `sd_cbm_recipient` | SSORT | CBM recipient details, reused between reports |
| `sd_cbm_refmeta_edits` | SSORT | edited captions on NOV reference photographs |
| `sd_checks_archive` | SSORT | archived daily checks |

**Retention: indefinite.** Nothing expires and nothing is purged on a schedule. It persists until
the crew presses **⊘ New Trip**, clears browser data, or the profile is removed. A restore bar
offers the last session back on load.

**Contains personal data:** names and roles of rig personnel (Subsea Supervisor, OIM, Rig Manager
and so on) and photographs taken on the rig.

## 2. IndexedDB — `sd-report-tool`

Both tools open a database named `sd-report-tool` to hold the **directory handle** for the TSC
REPORTS folder, so the crew is not asked to pick it again. It is a handle, not report content, and
it persists until browser data is cleared.

## 3. The TSC REPORTS folder

Set once by the crew with **📂 Choose folder**. When a post fails, the tool writes the report `.json`
there automatically and says so. On a normal successful post nothing is written.

| | |
|---|---|
| Where | wherever the crew chose — typically a local or mapped drive on the rig |
| What | the same `.json` the dashboard would have received, photographs included |
| Retention | **indefinite, and nobody manages it.** No rotation, no cleanup, no size cap |
| Is it ever the only copy? | **Yes** — that is its entire purpose. After a failed post it is the only copy until someone sends it to the office |

## 4. Files the crew saves or downloads

**💾 Save to File** and the Save As fallback write `seadrill-report_<rig>_<date>_<type>.json`
wherever the crew chooses; on iPad it goes through the share sheet. **⎙ Print / PDF** produces a PDF
through the browser's own print. A CBM report can also be exported as a standalone HTML document.

Retention is the crew's own file management. Several rigs keep a dated folder per trip; that
practice is what recovered a week of West Capella reports after a filename collision, and it is
taught in Day 1.

## 5. Photographs

Every photograph is re-encoded on the way in — canvas, 1600 px, quality **0.82** — so a 6 MB phone
image is stored at roughly 300 KB. They live inside `sd_maint_tiles` as base64 data URIs and travel
inside the report JSON.

**Attachments are the exception.** From SSORT REV 152 a CBM inspection accepts PDF, image, CSV, text
and Office files as test records. Non-images **cannot be compressed** and carry their full size, plus
about a third for base64. Guards at the point of attaching: warn over 8 MB per file, refuse over
20 MB per file, warn when the running total passes 15 MB.

## 6. Once a report is posted

The posted `.json` is the record, held by the dashboard side in `PostedReports` and rendered on the
dashboard. A same-name post replaces the earlier one and the previous copy is kept server-side under
`reports\_replaced\`. Nothing on the rig's machine is deleted when a post succeeds — the local copy
simply stops being the only one.

## 7. Deletion

There is no remote wipe and no admin control over what a rig's browser holds. The crew clears it
with **⊘ New Trip** or by clearing site data. For the October training class, posts made on the
`SSCE Equipment` asset are deleted from `PostedReports` afterwards and clear from the dashboard on
the next scan; the trainees' `localStorage` on the training machines is cleared with **⊘ New Trip**.

## 8. Gap, stated

**Local data is unmanaged and unbounded.** No retention period is set or enforced for browser
storage, the TSC REPORTS folder, or saved files; personal data and rig photographs persist
indefinitely on rig machines; and nothing in the tools can enforce a policy, because there is no
server-side component to enforce it from. If a retention period is required, it has to come from
machine management rather than from the tools.
