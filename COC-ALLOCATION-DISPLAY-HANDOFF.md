# Handoff — "Allocated" display on the WCE COC Dashboard

**For:** the Claude Code session that will do the COC Dashboard UI work.
**From:** the dashboard/scanner session (`Dans-projects`, live `C:\TSC-Dashboard`,
scanner `Update-Dashboard.ps1` v2.31). Owner of the pipeline described below.
**Date:** 2026-08-17.
**Requested by:** Dan Plant — "the COC Dashboard should pick up the request
back and grey out the part in question, with a notification saying Allocated
and the rig."

---

## 1. What you are building (the ask)

When a Central Spares (SSCE) part has been **allocated to a rig** through the
approval loop below, the COC Dashboard must show that **everywhere the part
appears**:

1. **Grey the part out** — visibly de-emphasised wherever it renders (SSCE
   equipment lists / tiles / search results / the item's own detail view),
   not just in one modal.
2. **An "Allocated — `<rig>`" notification/badge** on the part, using the rig
   name provided in the data (see §3).

This is a **display-only change**. The data that drives it already arrives in
the file — your job is rendering it properly. Do not build any fetching,
posting, or scanning; all of that exists and works (confirmed end-to-end in
production on 2026-08-17).

## 2. How the whole loop works today (context — all shipped and live)

```
Rig team on COC Dashboard clicks "Submit Request"
  → POSTs ssce-request_*.json to the WCGRRT Power Automate flow
  → lands in SharePoint WellControl/PostedReports
        ↓ (scheduled scan, ~10 min, Update-Dashboard.ps1 on Dan's PC)
SSCE Requests Dashboard shows the request; approver clicks Approve/Deny
  → POSTs ssce-decision_*.json the same way
        ↓ (next scan)
Scanner matches decision → request by requestId. For APPROVED requests it
performs the WRITE-BACK: it opens the live COC Dashboard file, finds the
requested SSCE item inside the embedded APP_DATA, sets the allocation
fields on it (§3), and writes the result to
  Seadrill_WCE_COC_Dashboard_PENDING_REVIEW.html   (same folder)
— a REVIEW COPY, never the live file. Dan reviews and manually promotes it
to the live filename. That promoted file is where your greyed-out display
becomes visible to users.
```

Full pipeline contract: `SSCE-REQUESTS-INTEGRATION-CONTRACT.md`. Posting
transport: `POSTCONTRACTFORDASHBOARDBUTTONS.md`. Both in this repo.

## 3. The data contract you render from

The scanner sets, on the allocated SSCE item object inside `APP_DATA`
(folder `id: 'ssce'` → `bops[]` → `categories[]` → `items[]`):

| Field | Value | Meaning |
|---|---|---|
| `available` | `false` | part is allocated / not requestable |
| `assignedTo` | rig name string, e.g. `"West Tellus"` | who it's allocated to (the requesting rig's Site-Unit) |

**Absent fields mean available.** Most items will never have these keys —
that is the normal state, identical to the dashboard before this feature
existed. Never treat `undefined` as unavailable; test `available === false`
exactly (the existing render does — copy that idiom).

If you want to show an allocation **date** ("Allocated — West Tellus,
17 Aug 2026"): the scanner does not currently write one. Ask Dan to relay
that to the dashboard session and I'll add `assignedAt` (the decision's
ISO timestamp) to the write-back — a two-line change on my side. Don't
invent a date client-side.

## 4. What already renders (don't duplicate, extend)

In the current revision, the **item-detail modal's "SSCE Equipment" match
list** already swaps the "Request" button for a red
`Unavailable — <assignedTo>` badge when `available === false` (search the
file for `modal-ssce`). Dan's ask extends this treatment to **every** other
place an SSCE item renders, with the greyed-out styling and "Allocated"
wording. Reuse/replace consistently — one visual language for "allocated",
not two.

Optional idea Dan would likely appreciate (confirm with him): a small
banner/count on the SSCE section ("3 items currently allocated") so
allocations are visible without opening anything.

## 5. Hard constraints — breaking these breaks the production pipeline

1. **Start from the CURRENT revision.** Get the live file from Dan (deployed
   2026-08-17). It contains, and you must preserve:
   - the direct-POST submit flow (`SSCE_POST_URL`,
     `postJsonToPostedReports()`, async `submitSsceRequest()` with its
     download fallback and button-disable);
   - the radio/checkbox appearance fix
     (`input[type="radio"],input[type="checkbox"]{...appearance:auto}`) —
     without it the form's radios/checkboxes are invisible and submission
     silently blocks;
   - the `ret-serial` prefill (`value="${esc(source.it.serial||'')}"`).
2. **Do not disturb the APP_DATA anchors.** The scanner locates the embedded
   data with this exact regex:
   `(<script id="app-data">\s*const APP_DATA = )([\s\S]*?)(;\s*const SFI_GROUPS)`
   Keep the `<script id="app-data">` tag, the `const APP_DATA = ` spelling,
   and `const SFI_GROUPS` immediately following the APP_DATA literal. Rename
   or reorder any of these and the write-back dies with "could not find the
   embedded APP_DATA block".
3. **Do not rename item fields.** The write-back matches items by
   `asset` + `oem` + `serial` and writes `available`/`assignedTo`. Additive
   changes only; absent-means-available must stay true.
4. **Keep the delivered filename identical** (currently
   `Seadrill_WCE_COC_Dashboard_REV6 1.html` on the SSORT share) — user
   bookmarks and the scanner's `cocDashboardPath` config both point at it.
5. **Single self-contained HTML file** (~1.9 MB), no external dependencies,
   works opened from a file share. Keep it that way.

## 6. Definition of done / test before returning it

1. Hand-edit a couple of SSCE items in APP_DATA to `"available": false,
   "assignedTo": "West Tellus"` and confirm: greyed out + "Allocated — West
   Tellus" in every SSCE render path (list, tile, search, detail modal), and
   the Request button gone for those items only.
2. Confirm an item **without** the fields renders exactly as before.
3. Submit-request flow still works (the POST fires; test offline for the
   download fallback).
4. Regex check: run
   `[regex]::Match((Get-Content file -Raw), '(<script id="app-data">\s*const APP_DATA = )([\s\S]*?)(;\s*const SFI_GROUPS)').Success`
   in PowerShell against your finished file — must be `True`.
5. **Return the finished file to Dan**, who will pass it back to the
   dashboard session (me) — I re-verify the write-back against it, update
   the tracked template copy in `Dans-projects`
   (`requests-dashboard/coc-source/`), and only then should it go live on
   the SSORT share. Do not skip this loop: the scanner writes into this
   file's data block every scan cycle, so the template copy and the live
   file must stay in step.
