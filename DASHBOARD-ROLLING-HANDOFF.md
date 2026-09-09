# Rolling handoff to the dashboard session

**From:** the reporting-tools session (WCGRRT / SSORT)
**Maintained by:** Dan Plant
**Purpose:** one document, added to as changes ship, so the dashboard is updated
**once** rather than chased per change.

**How to use this:** read the change log below. Anything marked **NEEDS ACTION** wants
something from the dashboard side. Anything marked **FYI** is a payload or behaviour
change you should know about but which needs no work. Newest entries at the top.

**Standing rules, unchanged throughout:** transport must not be modified · filenames
are never load-bearing · `meta.asset` is the rig identity contract.

---

## Open items summary — read this first

| # | Change | Rev | Status |
|---|---|---|---|
| 4 | Compliance report gains **action photos** and a **photo dump** | WCGRRT REV 158 | **NEEDS ACTION** — two new payload fields |
| 3 | **A real daily report showed personnel but no technical content** | WCGRRT REV 157 | **NEEDS ACTION — highest priority.** One check needed from you, plus a rendering question |
| 2 | Compliance Checklist now carries **Actions Raised During Visit** | WCGRRT REV 156 | **NEEDS ACTION** — new `actions[]` array in the payload |
| 1 | **Marine Integrity retired** from Well Control reporting | WCGRRT REV 155 | **NEEDS DECISION** — what happens to your Marine view |

---

# Entry 4 — Compliance report: photos on actions, and a photo dump
**WCGRRT REV 158 · 9 September 2026 · NEEDS ACTION**

## What changed and why

Requested by the **West Neptune** subsea team, following on from Entry 2. An action is
much easier to act on when you can see it — *"the visual indicator requires
replacement"* plus the photograph of it.

1. **Every action row now has a 📷 Add button.** One photo per action. It appears
   under its action in the report, and travels with the action in the payload.
2. **The Compliance Checklist report now ends with a photo dump**, before sign-off.
   It has its own grid inside the compliance block — **separate from the daily-report
   photo dump**, so the two reports never share photographs. Up to 24.

**Both paths run through the REV 157 compressor** (1600 px long edge, JPEG 0.82), so
these additions do not undo the size fix in Entry 3. A phone photo lands at roughly
300 KB, not 6 MB.

## New in the payload

**`reportType: "compliance-checklist"`** gains a top-level **`photos`** array, and each
entry in **`actions`** gains a **`photo`** string:

```json
{
  "reportType": "compliance-checklist",
  "actions": [
    {
      "desc": "Cracked sight glass on the HPU tank",
      "system": "Equipment",
      "resp": "Subsea Supervisor",
      "target": "2026-09-21",
      "deadline": "2026-10-11",
      "leftWithRig": false,
      "photo": "data:image/jpeg;base64,..."
    }
  ],
  "photos": [
    { "src": "data:image/jpeg;base64,...", "caption": "Moonpool rig-up" }
  ]
}
```

### Notes on the shape

- **`actions[].photo` is `""` when there is no photo** — always present, never missing.
- **`photos` is always present**, `[]` when empty.
- Both are **base64 data URLs**, `image/jpeg`, typically 200–400 KB each.
- `photos[].caption` may be empty.

## Also new on the rig-visit report

The same photo travels on the **daily report** payload: `actionRows[]` (top level)
gains a `photo` field, on the same terms. The actions table is now **9 columns** —
`# · Action Description · System · Responsible Party · Target Date · Deadline ·
Left w/ Rig · Photo · (remove)`. Anything of yours that reads that table positionally
needs the extra column.

## What we would ask

1. **Show the action photo next to the action** in the open-actions view from Entry 2.
   A thumbnail that opens full size is enough — it is the single thing that makes a
   remote action intelligible.
2. **Keep photos out of list and aggregate views.** Counts in the lists, blobs only on
   the individual record — the existing rule from the data rules, and it matters more
   now there are more photos.
3. **Watch the size.** A compliance report with a full 24-photo dump plus action photos
   could reach 8–10 MB. If you have a practical ceiling, tell us the number and we will
   enforce it at source. Related to the ask in Entry 3.

---

# Entry 3 — West Capella daily report: content present in the file, missing on the dashboard
**WCGRRT REV 157 · 9 September 2026 · NEEDS ACTION**

## What happened

Bradley Waldron submitted the first daily report through the SACRED reporting system
(**West Capella, 7 September 2026**), printed the PDF, and posted it. **The dashboard
shows the personnel names but none of the technical content.**

We have his actual posted file and have examined it. **The content is in the file, and
it is complete:**

| | |
|---|---|
| Equipment entries | **4** — riser pull to surface, HPU Fluid Recovery decommissioning (Synergi MOC 1843049), 14″ Ultralock IIB door overhaul, MRT #9 wire rope replacement |
| Technical narrative | **3,194 characters**, with procedure and part/serial references |
| Photos | **16, all captioned** |
| Compliance checklist | 43 statuses + 10 notes, all populated |

So this is **not** a user error and **not** a capture bug. It is one of two things,
and one number tells us which.

## The number that settles it — please check

**Brad's file is exactly `22,012,925` bytes. It is 21.0 MB, of which 100% is
photographs** — the technical content is 20 KB. Base64-encoded, that is roughly a
**28 MB POST body**, against a transport where the largest previously successful post
was a few hundred KB.

**Please report the byte size of the file that actually landed in SharePoint:**

| Landed size | Conclusion |
|---|---|
| **Smaller than 22,012,925** | Truncated in transit. A transport/size limit problem |
| **Exactly 22,012,925** | The file arrived intact and the dashboard is not rendering `tiles[].equipEntries` |

If it is the second case, the fix is yours: **render `tiles[].equipEntries`** for daily
reports — `type` / `manualName`, `notes` (HTML), `photos[]` with `captions[]`, and the
`flagEot` / `flagCrit` / `flagLesson` flags.

## Fixed at source in REV 157 — photos are now downscaled

Root cause on our side: WCGRRT stored photos at **full camera resolution**. There was
no downscaling on attach at all. SSORT has had `compressDataUrl` for months — which is
why its daily-checks rounds are ~233 KB — and WCGRRT simply never got it.

REV 157 ports the same field-proven function: **1600 px long edge, JPEG 0.82**, never
inflates a file, and falls back to the original on any error so a photo is never lost.

**Measured on Brad's actual 16 photographs, re-encoded:**

| | Before | After |
|---|---|---|
| Photographs | 20.97 MB | **3.99 MB** |
| Whole report | 21.0 MB | **4.0 MB** |
| POST body | ~28 MB | **~5.3 MB** |
| | | **81% smaller** |

Three of his photos were 4032×3024 and one was 5712×4284 — straight off a phone. Those
four alone accounted for 18.7 MB. Small images are left alone; nothing is upscaled.

## What we would ask

1. **Report the landed byte size** (above). That is the whole diagnosis.
2. **If files are being truncated, fail loudly.** A partially-received report that
   renders its `meta` block and silently drops the content is the worst outcome — it
   looks like a working report. Please reject or flag it with the file named, the same
   way the Unattributed bucket works.
3. **Consider a size ceiling with a named reason.** If there is a practical limit,
   tell us the number and we will enforce it at source before the user presses Post.
4. **Confirm you render `equipEntries`** for daily reports.

## What Brad should be told

**His report is fine and nothing is lost.** The PDF he printed is the complete record,
and the file he holds contains everything. Once the landed size is known we will know
whether it needs re-posting from REV 157 — where the same report would be 4 MB.

---

# Entry 2 — Compliance Checklist: Actions Raised During Visit
**WCGRRT REV 156 · 9 September 2026 · NEEDS ACTION**

## What changed and why

Requested by the **West Neptune** subsea team. The *Actions Raised During Visit*
table already lives inside the compliance checklist on screen (`#ckl-actions`), but it
was missing from the generated Compliance Checklist report. It is now included — in
the PDF and in the posted JSON.

It sits directly after the Compliance Summary, before the Maximo AAB totals, because
the actions are the part someone has to *do* something about.

## New in the payload

`reportType: "compliance-checklist"` gains a top-level **`actions`** array:

```json
{
  "reportType": "compliance-checklist",
  "complianceOnly": true,
  "meta": { "asset": "West Neptune", "date": "2026-09-09", "...": "..." },
  "checklist": { "...": "..." },
  "actions": [
    {
      "desc": "Established end-of-well documentation pack",
      "system": "e-Docs",
      "resp": "Subsea Supervisor / S",
      "target": "2026-10-09",
      "deadline": "2026-11-10",
      "leftWithRig": true
    }
  ],
  "appxConfig": "ckl-appa",
  "complianceSummary": [ "..." ]
}
```

### Notes on the shape

- **`actions` is always present.** An empty array means no actions were raised — not
  that the field is missing.
- **`leftWithRig` is a real boolean.** Everything else is a string.
- **`desc` may contain newlines** (it is a free-text box). No HTML.
- `target` and `deadline` are `YYYY-MM-DD` from date pickers, but **may be empty** —
  the form does not force them.
- Field names match what the daily and end-of-trip reports already read from the same
  table, so the source of truth has not moved.

## What we would ask for

1. **An open-actions view across the fleet.** Every action from every compliance
   report, with rig, deadline and responsible party. This is the single most useful
   thing in the payload — actions raised on a rig visit are exactly what gets lost.
2. **Flag actions past their deadline** where the report is the latest for that rig.
   Derive it your side, as with the precharge overdue rollup — don't ask us to
   precompute a date comparison that goes stale.
3. **Surface `leftWithRig: false` separately.** The report now warns when an action is
   not marked as left with the rig, because that means the handover was not confirmed.
   Worth mirroring rather than treating all actions alike.
4. **Dedup:** actions have no id of their own. Treat them as **part of their parent
   compliance report** and replace them wholesale when a newer report for the same
   `rig | date` arrives. Do not try to merge action lists across reports.

## Also worth knowing

Two earlier compliance changes are already live and may not be on your side yet:

- **REV 152** — the equipment register is now **one arrangement only**, chosen per rig:
  `appxConfig` is `ckl-appa` (5th Gen / Mosvold) or `ckl-appb` (6th Gen / Modular),
  with `appxLabel` carrying the readable name. Only the selected register appears in
  the report.
- **REV 150** — the fix for the selector bug that meant **compliance statuses and
  notes were never written to file**. Anything you hold from REV 149 or earlier has
  empty `statuses` and `notes`; that is our old bug, not a rig failing to complete the
  checklist. Please don't report on historic compliance statuses.
  Full detail in `DASHBOARD-COMPLIANCE-CHECKLIST-HANDOFF.md`.

---

# Entry 1 — Marine Integrity retired from Well Control reporting
**WCGRRT REV 155 · 9 September 2026 · NEEDS DECISION**

*(Supersedes `DASHBOARD-MARINE-INTEGRITY-HANDOFF.md`, the original build spec.)*

## What changed

**Marine Integrity has been removed from WCGRRT.** Dan's decision.

- **Marine** is gone from the Discipline dropdown.
- **Marine Integrity Report** is gone from the Add Section dropdown.

**No new Marine Integrity report can be raised.** Your Marine view will simply stop
receiving new records.

## What was deliberately NOT done

The scoring engine — 73 items across Policy / Regulatory / Equipment, the 3.0 target,
the report builder — **is still in the file, dormant.** A conscious choice:

- Any Marine Integrity report **already saved or posted still opens, renders and
  prints exactly as before.** Nothing archived is lost.
- If Marine ask for it back, or take it over themselves, it is two dropdown entries to
  restore rather than a rebuild.

Opening an archived marine report re-inserts the discipline option at runtime,
labelled **"Marine (archived — retired)"**, so the report displays correctly without
offering Marine for new work. Never added when opening a non-marine report — verified.

## What we need you to decide

Historic Marine Integrity records are real assessment data, completed by people,
scored against a 3.0 target. **We are not asking you to delete anything.**

| Option | What it means |
|---|---|
| **Read-only archive** *(our suggestion)* | Keep the tab, label it archived/retired with a date, stop expecting new data. Historic trends stay readable |
| **Hide the tab** | Records stay in the store but come off the navigation. Recoverable |
| **Export and remove** | Final extract for the Marine department, then remove the view |

**Whichever you choose, please do not silently drop the records.** If the tab
disappears with no explanation, someone will assume the data was lost.

## Scanner behaviour we would ask for

1. **Stop treating an absence of marine reports as a fault.** Any "no marine report
   received for rig X" check will now fire forever — retire it.
2. **Keep ingesting if a file does arrive.** Older WCGRRT revisions remain in
   circulation and someone may post from a cached copy for a while.
3. **Don't repurpose the marine identifiers.** `marineData`, `meta.marineData` and the
   marine filename suffix stay reserved, so the same markers still mean the same thing
   if Marine restart.

## Related rule that still stands

**Marine data must never appear in well-control views.** Retiring the reporting does
not change that — if historic marine records stay visible anywhere, they stay in
their own view.

## Question back

**How many Marine Integrity records do you hold, and across how many rigs?** If it is
a handful, an export is trivial. A substantial history argues for the read-only
archive — and Dan should know the number before Marine are told.

---

## Verified for every entry above

| Check | Result |
|---|---|
| `sdPostReport` / `REPORT_POST_URL` | Byte-identical throughout |
| `generateDailyReport` / `generateTripReport` | Byte-identical — nothing you already consume changed |
| `printPlanning` | Byte-identical in REV 155 and 156 |
| Script syntax | `node --check` clean on every revision |
| Actions rendering | Tested with none, and with three actions including one not left with the rig |
| Marine legacy guard | Tested: appears for an archived marine report, never otherwise, no duplicates |

---

*Add new entries at the top, above Entry 2, with the same NEEDS ACTION / NEEDS
DECISION / FYI marker and the revision number.*
