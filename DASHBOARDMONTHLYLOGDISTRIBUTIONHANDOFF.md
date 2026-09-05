# Handoff — how the Daily Log and Monthly Log reach the dashboard

> **Dashboard-side status (2026-09-05):** all six asks implemented in
> scanner v2.35 — see `HANDOFF.md` / `INTEGRATION-CONTRACT.md`.
> **§7 fallback fix: APPROVED by Dan Plant (2026-09-05)** — fix the
> `sdWriteToReportFolder` argument order as its own revision, nothing
> else in it. Q6: no distinct monthly filename prefix needed (the
> dashboard never routes on filenames); leave posting unchanged.

**To:** the dashboard / scanner session
**From:** the reporting-tools session (SSORT **REV 139**)
**Date:** 2026-09-03
**Subject:** every route by which daily-log content is distributed, the duplication
you must expect, and one defect in the local-save fallback.

---

## 1. The short version

**The same day's log can arrive at the dashboard up to four times, by four different
routes, in three different shapes.** That is by design, not by accident — but it
means **deduplication is mandatory on your side.** If you ingest naively, a single
day's entry will appear repeatedly and the monthly view will double-count.

| # | Route | When it fires | Filename | `meta.reporttype` |
|---|---|---|---|---|
| 1 | **Per-entry auto-post** | Automatically, every time the user presses **Add to Log** | `seadrill-daily-log_<rig>_<date>_<shift>.json` | `Daily Log Entry` |
| 2 | **Lesson Learned** | User presses **Post Lesson Learned** | `seadrill-lesson-learned_<rig>_<date>.json` | `Lesson Learned` |
| 3 | **Re-post one day** | User presses post on a row in the Monthly Daily Log list | as route 1 or 2 | `Daily Log Entry` / `Lesson Learned` |
| 4 | **Monthly roll-up** | User presses **Generate & Post Month** | `seadrill-report_<rig>_<YYYY-MM>_daily-log.json` | `Daily Log` |

Separately, **Daily Checks and Weekly FLM are a different pipeline entirely** — see
§6. They are *not* included in the monthly log roll-up.

---

## 2. Route 1 — per-entry auto-post (the high-volume one)

`addToLog()` pushes the entry into the in-memory month array and **immediately posts
it**, with no confirmation dialog. This is the route that produces most of your
daily-log traffic.

```
filename: seadrill-daily-log_<Rig-Name>_<YYYY-MM-DD>_<Shift>.json
```

Payload is a **full SSORT report payload** (`buildReportPayload()`) with three fields
added to `meta`:

```json
{
  "meta": {
    "asset": "West Capella",
    "reporttype": "Daily Log Entry",
    "logDate": "2026-09-03",
    "hasLessonLearned": true,
    "dayLogEntry": {
      "date": "2026-09-03",
      "personnel": "J Smith",
      "shift": "Day 07:00",
      "equip": "Riser Connector",
      "failure": false,
      "lesson": false,
      "note": "<p>HTML from a rich-text box</p>",
      "photos": [ { "src": "data:image/jpeg;base64,...", "caption": "" } ]
    },
    "dayLog": [ ... ],
    "dayLogMonth": [ ... ]
  }
}
```

**`hasLessonLearned` is only present when true.** Treat its absence as false.

### The important part

`meta.dayLogEntry` is **the one entry just added**. But the same payload also carries
`meta.dayLog` and `meta.dayLogMonth`, which contain **every entry in the workspace and
the whole month**. So each post carries the entire month again.

**Read `meta.dayLogEntry` for route-1 files. Ignore `dayLogMonth` on these** — or you
will re-ingest the month on every single entry.

---

## 3. Route 4 — the monthly roll-up

`postMonthlyLog()` filters the month array to the selected `YYYY-MM`, confirms with
the user, generates the PDF, then posts.

```
filename: seadrill-report_<Rig-Name>_<YYYY-MM>_daily-log.json
```

```json
{
  "meta": {
    "asset": "West Capella",
    "reporttype": "Daily Log",
    "logMonth": "2026-09",
    "dayLogMonth": [ { entry }, { entry }, ... ]
  }
}
```

### ⚠ Filename trap — please read

**The monthly roll-up uses the `seadrill-report_` prefix**, which is the same prefix
as a rig-visit report. It is distinguished only by the `_daily-log` suffix and by
`meta.reporttype === 'Daily Log'`.

**Do not route on the `seadrill-report_` prefix alone** or a month of daily-log
entries will be filed as a rig-visit report. Route on `meta.reporttype` first.

We would rather have used a distinct prefix. It is not changed here because the
posting behaviour is under a standing do-not-change instruction — see §7.

---

## 4. Deduplication — what we suggest

| Content | Suggested newest-wins key |
|---|---|
| Daily log entry | `rig \| date \| shift \| equip` |
| Lesson learned | `rig \| date \| equip` (or the entry key above with `lesson = true`) |
| Monthly roll-up | `rig \| logMonth` |

Notes on the key choice:

- **`date` alone is not unique.** A rig can log several entries on one date, for
  different equipment and different shifts. Including `equip` prevents a second
  entry that day overwriting the first.
- **The monthly roll-up should not overwrite the individual entries** and vice versa.
  Treat them as two views of the same underlying set: entries are the record, the
  monthly file is a snapshot for reporting. If they disagree, **the individual
  entries are more recent**, because the roll-up is only as current as the last time
  someone pressed the button.
- **Re-posting is expected and normal.** A user can re-post a single day from the
  month list at any time, and can re-post a whole month repeatedly. Later wins.

---

## 5. Payload size — a real risk on the monthly roll-up

Entries carry **photographs inline as base64** in `photos[].src`. A single daily-log
entry with photos has been measured at a few hundred KB.

**The monthly roll-up contains every entry for that month, with all photographs.** A
busy month on a rig that photographs everything could be tens of megabytes in one
POST.

This matters because large bodies have previously failed against this endpoint with
`TypeError: Failed to fetch`. If you see months that never arrive while individual
entries do, **suspect size before suspecting anything else.**

Two things we would ask:

1. If a monthly file arrives truncated or fails to parse, **do not discard it
   silently** — surface it, so the rig can be told to re-post.
2. When the platform moves to a database, photographs should go to object storage and
   the roll-up should carry references, not base64. This is already recommended in
   the SACRED LINK brief §9.

---

## 6. Daily Checks and FLM — a separate pipeline

**These do not go through the daily-log routes and are not in the monthly roll-up.**

`checksPost()` posts a **much smaller, purpose-built payload** — not a full report
payload:

```json
{
  "meta": {
    "asset": "West Capella",
    "reporttype": "Daily Checks",        // or "Weekly FLM"
    "logDate": "2026-09-03",
    "shift": "Day 07:00",                // empty string for FLM
    "checks": { /* the full collected round */ }
  }
}
```

```
filename: seadrill-daily-checks_<Rig>_<YYYY-MM-DD>_<Day|Night>.json
          seadrill-flm_<Rig>_<YYYY-MM-DD>.json          (no shift suffix)
```

Rounds are also archived locally in browser storage under `sd_checks_archive`, keyed
by month, purely to render the on-screen monthly list. **That archive is never
posted.** If you want a month of checks, it must be assembled from the individual
round files you already receive.

---

## 7. Defect in the local-save fallback — needs a decision

While tracing this I found a genuine bug. **It does not affect posting to the
dashboard**, but it does affect what happens when posting fails.

`dlPostPayload()` — used by routes 1, 2, 3 and 4 — calls:

```js
wrote = await sdWriteToReportFolder(json, filename);   // arguments reversed
```

but in SSORT the signature is:

```js
async function sdWriteToReportFolder(filename, jsonStr)
```

**Consequence:** when a daily-log, lesson-learned or monthly post fails and the user
has a report folder configured, the fallback write is called with the arguments the
wrong way round and does not produce a usable file. `postMonthlyLog()` then still
reports *"generated (saved locally)"*, which is not verified and may not be true.

This breaches our own rule — never report a success you have not verified.

**It is a one-line fix.** It is not applied in REV 139 because posting behaviour is
under a standing do-not-change instruction from Dan, and the correct move is to ask
rather than quietly alter a posting path. **Dan: say the word and I will fix it as
its own revision, with nothing else in it.**

### Related trap for anyone moving code between the tools

The two tools take these arguments in **opposite orders**:

| Tool | Signature |
|---|---|
| **SSORT** | `sdPostReport(filename, jsonStr)` · `sdWriteToReportFolder(filename, jsonStr)` |
| **WCGRRT** | `sdPostReport(json, filename)` · `sdWriteToReportFolder(json, filename)` |

Both are internally consistent and both work. But copying a call from one tool to the
other will silently base64 the filename and name the file after the JSON. Worth
knowing before anyone refactors.

---

## 8. Entry shape reference

Every daily-log entry, wherever it appears, has this shape:

| Field | Type | Notes |
|---|---|---|
| `date` | `YYYY-MM-DD` | Defaults to today if the user leaves it blank |
| `personnel` | string | Free text |
| `shift` | string | e.g. `Day 07:00` / `Night 19:00`. May be empty |
| `equip` | string | From a fixed equipment list, grouped by system. `Miscellaneous` group added in REV 139 for entries that belong to no specific system |
| `failure` | boolean | Flagged as an equipment failure |
| `lesson` | boolean | Flagged as a lesson learned |
| `note` | HTML string | Rich text — contains markup, not plain text |
| `photos` | array | `{ src: "data:image/...;base64,...", caption: "" }`, up to 8 |

**`note` is HTML.** If you strip tags for a list view, do it deliberately; don't
assume plain text.

---

## 9. Summary of what we're asking

| # | Ask | Why |
|---|---|---|
| 1 | Route on `meta.reporttype`, never on the filename prefix alone | The monthly roll-up shares the `seadrill-report_` prefix with rig-visit reports |
| 2 | Dedupe on `rig \| date \| shift \| equip`, newest wins | The same day arrives by up to four routes |
| 3 | On route-1 files read `meta.dayLogEntry` only; ignore `dayLogMonth` | Every entry post carries the whole month as well |
| 4 | Never silently discard an oversized or unparseable monthly file | Base64 photographs make monthly roll-ups large; failures must be visible so the rig can re-post |
| 5 | Treat individual entries as more current than the monthly roll-up | The roll-up is a manual snapshot |
| 6 | Tell us if you'd prefer a distinct filename prefix for the monthly log | We would change it, but only with Dan's explicit approval |

---

## 10. Unchanged

Transport is exactly as documented in `POST-CONTRACT-FOR-DASHBOARD-BUTTONS.md`:
`POST`, `Content-Type: application/json` only, `{FileName, ContentType,
FileContent(base64)}`, UTF-8-safe base64, check `res.ok`, never `mode:'no-cors'`.

Nothing in the posting path has been modified in REV 139.
