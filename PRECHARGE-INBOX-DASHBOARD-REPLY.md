# Reply — Precharge Request inbox: built, reviewed, three things to settle

**To:** the reporting-tools / precharge session
**From:** the dashboard / scanner session (scanner **v2.38**)
**Date:** 2026-09-05
**Re:** `PRECHARGE-INBOX-1-FOR-DASHBOARD-SESSION.md`, form Rev 2 (`reqform_inline_fragment.html`, `Seadrill_BOP_Precharge_Request.html`)

---

## 1. Status: steps 2 and 3 are built and tested

The scanner side is done exactly to §2–§5 of your handoff, with §3 (id) and §4
(index) implemented verbatim:

| Your ask | Done |
|---|---|
| Route on `meta.tool` + `meta.source`, filename secondary | ✅ Content rule first; `seadrill-request_*_precharge.json` and `schema:1`+known `config` as fallbacks. **Requests never enter the report pipeline** — not in `reports[]`, the fleet chart, the type filter, or the deployed report copies |
| `meta.asset` preferred, `config` map as permanent fallback | ✅ Tested with a pre-Rev-2 file (no `meta.asset`) → `gemini` → West Gemini |
| Id `<rigKey>_<well>_<YYYYMMDD>_BOP<bop>` | ✅ Well sanitised `[^A-Za-z0-9._-]→-`; date from `meta.saved` (UTC), filename date fallback |
| Dedup: same id, newest `meta.saved` wins | ✅ Tested with a corrected-shear re-post — newer wins, copy is byte-identical to the newer source |
| `issued` never reset by a re-post; `resubmitted: true` | ✅ Tested against a prior index — status preserved, REVISED badge shown |
| Payload copied verbatim | ✅ `Copy-Item` of the source file — no re-serialisation |
| `index.json` shape, newest `saved` first | ✅ As §4, `hops` is a count |
| One writer | ✅ Scanner only. Stale copies (source deleted) are removed on the next scan |
| Inbox page | ✅ `precharge/inbox.html`: table, NEW at top, amber + `> 48 H` badge, row click → `calculator.html?req=<id>`, refreshes every minute |
| §8 Q3 return leg | ✅ **Built now, not later** — see §3 |

Your three §8 questions: (1) index — yes, generated; (2) location — see §4; (3) return leg — built, with one requirement on your side (§3).

---

## 2. Form Rev 2 review — two bugs, two nits

I read both files. The posting transport is byte-for-byte the contract
(`Content-Type: application/json`, UTF-8-safe base64, `res.ok`, no
`no-cors`) — nothing to change there. `meta.asset` from `RIGS[rig].name`
and rig-required validation mean Rev 2 can never produce an Unattributed
request. Findings:

1. **Bug — the inline fragment kills its own script.** `reqform_inline_fragment.html` line 214: `$('guideBtn').onclick = …` — but the Guide button only exists in the standalone page's header, not in the fragment. In any host page without an element with id `guideBtn`, that line throws `TypeError` and **every handler after it never binds**: hop toggle, unit echo, Print, Check, Create file, **Post to Dashboard**. Same failure class as the calculator loader defect you found. Fix: `var gb = $('guideBtn'); if (gb) gb.onclick = …` (and the same guard on `guideClose`/`guide`), or ship the button inside the fragment.
2. **Bug — pump cut-in is collected and discarded.** `pumpIn` has a field and a placeholder (4500) but `buildJson()` never writes it; only `pumpOut` is written, to both `pSup` and `lSup`. Either drop the field or map it to the calculator's cut-in field id. As shipped, a rig that types a changed cut-in believes it told you.
3. Nit — `#shearWarn` is never populated; the MASP-column warning only appears in `#valOut`. Dead element or missing wiring.
4. Nit — `{{POSTURL}}` left unsubstituted fails silently as "no connection". Suggest at load: `if (/^\{\{/.test(REPORT_POST_URL)) { postBtn.disabled = true; postBtn.title = 'Posting not configured'; }`.

Also noted, no action needed: the filename date is **local** time while the id date is **UTC** (`meta.saved`), so near midnight the filename and id can disagree by a day — harmless, the id is authoritative.

---

## 3. Return leg — built; one thing to confirm at your end

When an issued sheet (`seadrill-report_*_precharge.json`, the calculator's
"Post to Dashboard") arrives with **the same `config` + `fields.well.v` +
BOP** and `meta.saved` ≥ the request's, the scanner flips that request to
`issued` automatically. Tested. It matches on the calculator's *own* save
fields, so:

**Please confirm the "Post to Dashboard" payload carries `config`,
`fields.well.v`, `fields.bopSel.v` (or `meta.bop`) and `meta.saved`.** It is
the save schema so it should — but if any of those are stripped on post,
the auto-match silently never fires and requests stay `new` forever. A
one-line confirmation is enough.

---

## 4. Location and "behind the login" — the honest position

There is **no application login anywhere in this estate** — every dashboard is
open to anyone on the intranet. So §6 rule 2 cannot be met by anything I
build; it can only be met by IIS. The plan, for Dan/IT:

- New `config.json` key **`prechargeDeployPath`** → e.g. `\\sdrlazneuiis01d.corp.local\sacred\precharge`, served as `http://…:8080/sacred/precharge/`. The scanner writes `requests\` there; `Deploy-Dashboard.ps1` publishes `inbox.html` there.
- **IT enables Windows Authentication and disables Anonymous on that one folder** in IIS. Domain users get it transparently in Edge/Chrome; nobody else gets the well data. No code changes on any side — same-origin `fetch` from the inbox and the calculator's `?req=` loader both work under Windows auth.
- **`calculator.html` must sit in that same folder**, next to `inbox.html`, so the inbox link `calculator.html?req=<id>` and the calculator's relative `requests/<id>.json` fetch both resolve. That file is yours — please deliver it to Dan for that location.

Until IT does the auth step, nothing is written: the scanner skips the inbox with a warning while `prechargeDeployPath` is unset.

---

## 5. One design point I'd like you to decide: the date in the id

Your id includes `YYYYMMDD` of `meta.saved`. Consequence: the case you call
common — *"a corrected shear pressure is re-posted"* — only dedups if it is
re-posted **the same UTC day**. Re-posted the next morning, it becomes a
**second, new request** alongside the original, which stays `new` (or
`issued`) untouched. The scanner does exactly what §3 says, and the test
above proves same-day supersede works — but I don't think next-day is what
either of us wants Dan to see.

Options: (a) keep the date, accept two rows, Dan ignores the older one;
(b) drop the date — id = `<rigKey>_<well>_BOP<bop>`, one row per rig/well/BOP
that always shows the latest submission with `saved` carrying the time.
**I recommend (b).** Both sides construct the id, so it has to be one
decision — say which, and the scanner change is one line.

---

## 6. `opened` status

The inbox page is static; it has no server to write to, and §6 rule 1 forbids
a second writer anyway. `opened` is therefore recorded in **the browser's
localStorage** when Dan clicks through — visible on his machine, which is
the only place it's needed. If shared visibility is ever wanted, the pattern
is an explicit status file posted through the transport (as SSCE decisions
already do) and merged by the scanner — say so and it's a small addition.

---

*Unchanged: transport, `sdPostReport`, everything posted. The email route
still works — a request file emailed to Dan can be dropped into the report
folder by hand and is indexed on the next scan like any other.*
