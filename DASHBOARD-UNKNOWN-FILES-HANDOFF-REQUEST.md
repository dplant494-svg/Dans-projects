# Handoff request — unidentified report files polluting the dashboard

**From:** the dashboard / scanner session (scanner v2.35)
**To:** whichever session/tool produces these files (via Dan)
**Date:** 2026-09-05
**Status:** REQUEST — the dashboard needs information before it can ingest
these properly. Until then they display wrongly (see §2).

---

## 1. What we are seeing

Files are arriving in the report folder that the scanner does not
recognise as any documented report type. They carry a `meta` block (so
they are ingested) but **no rig identity the scanner can read**
(`meta.asset` is blank or absent), so the scanner falls back to the
filename — and mangled filename fragments are now displayed as "rigs" on
the live dashboard's *Reports by rig* chart:

| Displayed as "rig" | Evidently from a filename like |
|---|---|
| `DIAGNOSTIC` | `DIAGNOSTIC*.json` |
| `026-08-25_vendor-audit` | `*2026-08-25_vendor-audit.json` |
| `-27_vendor-surveillance` | `*2026-08-27_vendor-surveillance.json` |
| `-28_vendor-surveillance` | `*2026-08-28_vendor-surveillance.json` |
| `-03_vendor-surveillance` | `*2026-09-03_vendor-surveillance.json` |
| `2026-08-29_daily-report` | `*2026-08-29_daily-report.json` |

At least six files across late August–early September. "vendor-audit" /
"vendor-surveillance" suggests a deliberate new report type we have never
received a handoff for; "DIAGNOSTIC" suggests a test file.

## 2. Why it matters

- Each file becomes a report row attributed to a **nonsense rig**, and
  the fake rigs appear in the fleet chart and the rig filter dropdown.
- Whatever these reports contain is **not being displayed meaningfully**
  — no viewer section exists for their payload, so the content is
  effectively invisible even though the file is "on the dashboard".
- If they belong to a real rig, that rig's report count is understated.

## 3. What the dashboard needs (pick whichever applies)

### If these are a real, new report type

Send the standard handoff, same as Marine / TOPSET / Compliance:

1. **One or two sample files** (real ones, exactly as posted). This alone
   answers most questions.
2. **Identification rule** — how to recognise one definitively from the
   payload (a `reportType` field, a tile data block, a `meta.reporttype`
   value). Filename prefixes are recorded but never load-bearing.
3. **Rig identity IN the file** — `meta.asset` with the standard rig
   name. This is the non-negotiable one; it is the same rule every other
   report type follows, and its absence is exactly why these files are
   polluting the chart. (If a vendor audit is genuinely fleet-level and
   belongs to no rig, say so explicitly and we will route it to a
   fleet-level view instead.)
4. **Payload shape** — fields, types, which are booleans, which free-text
   fields carry HTML, whether photos/base64 are included, expected size.
5. **Dedup identity** — what makes two files the same logical report
   (rig+date? an audit reference?), and whether re-posts happen.
6. **What should appear on the dashboard** — a row in the report list
   with a viewer section? A dedicated view? Who is the audience?
7. **Sensitivity** — vendor audits can name suppliers and commercial
   findings. Say whether anything needs the restricted treatment (the
   TOPSET `cfClass` mechanism exists and can be reused).

### If they are junk / test files

Tell Dan and he deletes them at source, like the old-format precharge
files — nothing else needed.

## 4. What the dashboard side will do regardless

Scanner v2.36 will add a guard so this class of problem can never pollute
the fleet views again: a file whose rig identity comes only from the
filename fallback (no `meta.asset`, no `meta.checks.rig`) will be listed
under a single explicit **"Unattributed"** bucket with a scan warning
naming the file, instead of inventing a per-file fake rig. That protects
the chart, but it does not make the content useful — only §3 does.

---

*Standing rules unchanged: transport must not be modified; filenames are
never load-bearing; `meta.asset` is the rig identity contract
(`INTEGRATION-CONTRACT.md`).*
