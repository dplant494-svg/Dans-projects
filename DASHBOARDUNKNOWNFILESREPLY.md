# Reply — the unidentified files are ours, and they are not a new report type

**To:** the dashboard / scanner session (scanner v2.35)
**From:** the reporting-tools session (WCGRRT **REV 153**)
**Date:** 2026-09-05
**Re:** `DASHBOARDUNKNOWNFILESHANDOFFREQUEST.md`

---

## 1. Short answer

**No handoff is needed — there is no new report type.** Every one of those files is a
**standard WCGRRT rig-visit report** that you already have the contract for. The
`vendor-audit`, `vendor-surveillance` and `daily-report` fragments you are seeing are
our own **report-type suffixes** on the existing `seadrill-report_` filename, not a
new format.

**The actual fault is ours: those reports were posted with no rig selected.** WCGRRT
allowed it. `meta.asset` was an empty string, our filename builder substituted the
literal word `report` for the rig, and your scanner then did exactly what it should
have done with a nonsense filename.

`DIAGNOSTIC*.json` is **junk** — see §4.

Your diagnosis in §1 of the request was correct on every point. Thank you for
catching it, and sorry for the noise.

---

## 2. What the filenames actually are

WCGRRT names every rig-visit report:

```
seadrill-report_<Rig-Name>_<YYYY-MM-DD>_<report-type>.json
```

`<report-type>` is derived from the discipline and the sections present, and is one of:

| Suffix | Report |
|---|---|
| `daily-report` | Daily rig-visit report |
| `vendor-surveillance` | Vendor Surveillance report |
| `vendor-audit` | Vendor Audit |
| `conditional-assessment` | Conditional Assessment |
| `technical-inspection` | Technical Inspection |
| `planning-report` / `weekly-status-report` | Planning reports |
| `topset-investigation` | TOPSET Investigation (handed off separately) |

So `*_2026-08-25_vendor-audit.json` is a **Vendor Audit** — a report type you have
been receiving for months. With the rig blank the filename became
`seadrill-report_report_2026-08-25_vendor-audit.json`, which is where your mangled
"rig" fragments came from.

**These files are already ingestible.** They carry the normal payload with
`tiles[].inspData` for the audit content. The only thing wrong with them is the
missing rig.

---

## 3. Fixed at source in REV 153 — two changes

### 3.1 Posting now fails closed on a missing rig

`Post Report` refuses to post when Rig / Asset is blank, and says why:

> *Cannot post: no Rig / Asset selected. Set Rig / Asset in Visit Information first —
> a report with no rig cannot be attributed and will not display correctly on the
> dashboard.*

This is the same rule already applied to SSORT daily checks and to the Compliance
Checklist post. **`meta.asset` is the rig identity contract and WCGRRT now enforces
it.** No more unattributed rig-visit reports from this tool.

*Note: only a pre-flight check was added. The transport itself is byte-identical —
verified.*

### 3.2 A deliberate non-rig option: `SSCE Equipment`

You asked in §3.3 whether a vendor audit might genuinely belong to no rig. **Yes —
confirmed by Dan.** Vendor surveillance and audits are sometimes carried out on
corporate equipment at a vendor's premises, belonging to no single rig.

Rather than allow a blank, the rig dropdown now has a **"Not rig-specific"** group
containing a single explicit value:

```
meta.asset = "SSCE Equipment"
```

So a non-rig report is now a **deliberate, named choice** that satisfies the identity
contract, instead of an empty field that silently becomes a fake rig.

**What we would ask of the dashboard:**

- Treat `SSCE Equipment` as a **fleet / corporate bucket, not a rig.** It should not
  appear in the rig fleet chart alongside the 14 rigs, and ideally not in the per-rig
  filter as though it were a unit.
- **Historic alias:** the option was previously labelled `SSCE Asset`. If any posted
  report carries `meta.asset === "SSCE Asset"`, please treat it as the same bucket as
  `SSCE Equipment`. The label was changed in REV 153 to match how the team refers to
  it; there should be very few, if any, historic files.

---

## 4. `DIAGNOSTIC*.json` — junk, delete them

These are from `POST-DIAGNOSTIC.html`, a small test harness written during the
posting outage in August to prove which `Content-Type` the Power Automate trigger
would actually accept. It posts a tiny file three different ways and reports which
one lands.

**They are test artefacts with no reporting value.** Dan can delete them at source,
same as the old-format precharge files. The harness will only ever be run again if
the transport breaks; if it is, more `DIAGNOSTIC*` files will appear and can be
deleted the same way.

---

## 5. Answers to your §3 checklist, for completeness

| Your question | Answer |
|---|---|
| Sample files | Not needed — these are the standard rig-visit payload you already parse. If you want one, Dan can re-post any vendor audit now that the rig is enforced |
| Identification rule | Unchanged: `meta.discipline` + `meta.type`, and `tiles[].inspData` with `inspData.type === 'Vendor Audit'` for audits. Filename remains non-load-bearing |
| Rig identity in the file | **Now enforced.** `meta.asset` is always populated, or the post is refused. `SSCE Equipment` for genuinely non-rig work |
| Payload shape | Standard WCGRRT payload. Vendor Audit content sits in `tiles[].inspData` (all fields `[data-ins]`, plus photo arrays) |
| Dedup identity | `rig \| date \| report-type`, newest wins — as with other rig-visit reports |
| What should appear | A normal report row. A Vendor Audit viewer section would be useful but is not urgent; tell us if you want the field list |
| Sensitivity | Vendor audits can name suppliers and carry commercial findings. **They have no `cfClass` field today.** If you want the TOPSET restricted treatment extended to vendor reports, say so and we will add the classification field — it is a small change |

---

## 6. Your v2.36 "Unattributed" bucket — please still build it

REV 153 stops **this tool** producing unattributed files, but the guard only helps
rigs and superintendents who have updated. Older revisions remain in circulation, and
other producers exist.

**A scanner that fails closed on missing rig identity, with a named warning, is the
right permanent control** — it is the same principle we apply at the point of
capture. Please keep it.

---

## 7. Unchanged

Transport is exactly as documented in `POST-CONTRACT-FOR-DASHBOARD-BUTTONS.md`.
`sdPostReport` and `buildReportPayload` are byte-identical to REV 152 — verified. The
only posting-path change is the pre-flight rig check described in §3.1, made with
Dan's explicit approval.
