# Handoff — Compliance Checklist is now its own report + a data-loss fix you must know about

**To:** the dashboard / scanner session
**From:** the reporting-tools session (WCGRRT **REV 151**)
**Date:** 2026-08-19
**Transport:** unchanged. Same endpoint, same contract, verified byte-identical.

---

## 1. READ THIS FIRST — historic compliance checklists are incomplete

A selector bug in every revision up to and including **REV 149** meant
`collectChecklistState()` queried `#tab-checklist`, **an element id that does not
exist in the document.** The checklist actually lives in `#compliance-block`.

Consequence, in every save and every post before REV 150:

| Part of the checklist | Was it in the JSON? |
|---|---|
| **43 compliance statuses** (compliant / N-A / action) | **NO — silently empty** |
| **10 notes boxes** | **NO — silently empty** |
| Appendix A and B registers | Yes |
| Maximo AAB totals | Yes |
| VRR ticks | Yes |
| Sign-off fields | Yes |

**So any `checklist.statuses` or `checklist.notes` you already hold will be empty
arrays.** That is not a rig failing to complete the checklist — it is our bug. If
you have surfaced "0 compliant / 0 assessed" anywhere, it is wrong and should be
treated as *no data*, not as a finding. **Fixed in REV 150 onwards.**

Please don't report on historic compliance statuses. If it helps, gate any
compliance view on `version` plus the presence of a non-empty `statuses` array.

---

## 2. New in REV 151 — a standalone Compliance Checklist report

The checklist previously reached a PDF only via the End-of-Trip report. It is its
own deliverable, so it now has its own **Generate Compliance PDF** and **Post
Compliance Checklist** buttons on the checklist itself.

### How to identify one

1. **`reportType === 'compliance-checklist'`** — definitive.
2. **`complianceOnly === true`**.
3. **Filename prefix `seadrill-compliance-checklist_`** — e.g.
   `seadrill-compliance-checklist_West-Capella_2026-08-19.json`
4. `meta.reporttype === 'Compliance Checklist'`.

**Note the filename is deliberately NOT `seadrill-report_*`** so it can't be
mistaken for a rig-visit report.

### Payload shape

```json
{
  "version": 3,
  "exportedAt": "2026-08-19T09:00:00.000Z",
  "reportType": "compliance-checklist",
  "complianceOnly": true,
  "meta": {
    "asset": "West Capella",
    "date": "2026-08-19",
    "dateEnd": "2026-08-20",
    "discipline": "Well Control (WCEG)",
    "type": "BWM Compliance",
    "wce": "D Plant",
    "location": "Offshore",
    "bopNo": "BOP1",
    "synCase": "1845411", "synTitle": "...", "synCategory": "...",
    "synRespunit": "...", "synIdunit": "...", "synParty": "...", "synUrl": "...",
    "reporttype": "Compliance Checklist"
  },
  "tiles": [],
  "checklist": {
    "statuses": ["compliant", "action", "na", "", "..."],
    "notes": ["...", "..."],
    "appendix": { "ckl-appa": [ { "added": false, "ele": "", "desc": "",
                                  "asset": "", "cert": "", "expiry": "" } ],
                  "ckl-appb": [ ] },
    "aab": { "reviewed": "12", "approved": "9", "returned": "2", "deferred": "1" },
    "vrr": [true, false, true],
    "signoff": ["name", "position", "date", "reference"]
  },
  "complianceSummary": [
    { "id": "ckl-p1", "label": "P1 — Maximo AAB Review",
      "compliant": 5, "na": 1, "action": 2, "blank": 0, "total": 8 }
  ],
  "vrr": [true, false, true]
}
```

### Notes on the shape

- **`tiles` is always `[]`.** This is a checklist, not a rig visit. Don't treat an
  empty `tiles` array as a broken report.
- **`complianceSummary` is precomputed by us**, one row per priority P1–P8, with
  `compliant / na / action / blank / total`. Use it or recompute from `statuses` —
  but see the next point.
- **`statuses` is POSITIONAL**, in document order, one entry per checklist row.
  There is no item key. `""` means **not assessed**.
- **`blank` / `""` is NOT compliant.** Please show it as *Not assessed* and never
  fold it into a pass. The report itself prints a warning when any exist.
- `vrr` appears twice (top level and inside `checklist`) — same array, kept for
  convenience. Use either.
- No photos, no attachments, no base64. Payload is a few KB.

### Dedup

Suggested newest-wins key: **`rig | date`** (`meta.asset` + `meta.date`), i.e. one
compliance checklist per rig per visit date. `exportedAt` breaks ties if a checklist
is re-posted the same day — later wins.

---

## 3. Known limitation worth recording

`statuses` is matched to rows **by position**, both on save and on load. It is
correct today, but if we ever add, remove or reorder a checklist item, older files
would map their statuses to the wrong rows. There is no key to protect against it
yet.

**Practical implication for you:** don't compare `statuses` across different tool
revisions item-by-item. Compare the `complianceSummary` tallies instead, which are
computed at export time against the form the user actually saw.

If we change the checklist content we'll move to keyed items first and tell you.

---

## 4. What would be useful on the dashboard

Suggestions only.

1. **Per-rig compliance status** — latest checklist per rig, with the P1–P8 tallies
   and the action count. The obvious headline.
2. **Outstanding actions** — every priority where `action > 0`, with the rig and
   date. This is the actionable list.
3. **Not-assessed count** — surfaced separately from actions. An incomplete
   checklist is a different problem from a failed item, and conflating them hides
   both.
4. **Certification expiry watch** — from `checklist.appendix.*`, rows whose
   `expiry` is approaching or past. That data has been arriving correctly all along
   and is probably the most immediately useful thing in the payload.
5. **AAB trend** — `reviewed / approved / returned / deferred` over time per rig.

Please avoid a fleet compliance league table — same ethos point as everywhere else.

---

## 5. Unchanged

- **Transport:** `POST`, `Content-Type: application/json` only, `{FileName,
  ContentType, FileContent(base64)}`, UTF-8-safe base64, check `res.ok`, never
  `mode:'no-cors'`. Verified byte-identical to REV 145.
- `postReport()`, `generateDailyReport()`, `generateTripReport()` all untouched — the
  End-of-Trip report still carries the compliance summary as before, so nothing you
  already consume changes.
- Standing instruction from Dan: **do not change how anything is posted.**

---

## 6. Questions back to us

1. Is `rig | date` right for dedup, or would you prefer we emit a checklist id?
2. Do you want `complianceSummary` at all, or would you rather derive everything
   from `statuses`? Happy to drop it if it's redundant.
3. How do you want historic (pre-REV-150) compliance records handled — hidden
   entirely, or shown with an "incomplete data" marker?
