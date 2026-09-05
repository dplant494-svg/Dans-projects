# Handoff 1 of 2 — Precharge Request inbox: scanner routing and index

**To:** the dashboard / scanner session
**From:** the reporting-tools session
**Date:** 2026-09-05
**Updated:** 2026-09-05 by the precharge session — §2.1, §9, and answers in §8.
**Companion:** `PRECHARGE-INBOX-2-FOR-PRECHARGE-SESSION.md` — the calculator side.
**§3 (the id) and §4 (the index) are quoted identically in both. Do not diverge.**

> ### Status update from the precharge session
>
> **Both asks are done and shipped.**
>
> - **`meta.asset` now ships** in the request form output (form **Rev 2**). Your §2.1 stopgap becomes the *fallback*, not the primary — see the revised §2.1.
> - **The `?req=` loader is live in the calculator** (Rev 72), implemented exactly as the companion document specified, and tested against its §7 matrix. See **§9** for what you can now rely on.
> - **`loadState()` was checked against the companion's §4.1 question** and needs no wrapping: it calls `applyPreset()` first, so it does not assume a clean slate, and it ends with `compute()`, so the user lands on a filled form with the verdict already showing.

---

## 1. What we are building, in one line

A rig raises a BOP precharge request in SSORT; it posts as a `.json`; **Dan logs into
the SACRED server and finds it already loaded in the precharge calculator, waiting.**

Today he has to be emailed the file and open it by hand. Everything needed to
automate that already exists — the request file is written in the calculator's own
save-file schema, so **there is no transformation to do.** This is a routing job, not
a data job.

Your part is steps 2 and 3 below. The calculator's loader is done.

```
  rig (SSORT)        Power Automate → SharePoint        YOUR SCANNER              Dan
  ───────────        ───────────────────────────        ────────────              ───
  raise request  →   seadrill-request_*.json        →   copy to            →   inbox.html
                     lands in the library               /precharge/requests/    click a row
                                                        update index.json       calculator opens
                                                                                already filled
```

---

## 2. What arrives

Posted through the **existing** transport — nothing new, nothing changed.

**Filename**

```
seadrill-request_<rigKey>_<well>_<YYYYMMDD>_precharge.json
e.g.  seadrill-request_capella_DAL-795_20260905_precharge.json
```

`rigKey` is a lowercase short key, **not** the rig display name. The full set:

| rigKey | Rig | rigKey | Rig |
|---|---|---|---|
| `nov` | West Neptune | `polaris` | West Polaris |
| `auriga` | West Auriga | `libongos` | Sonangol Libongos |
| `vela` | West Vela | `quenguela` | Sonangol Quenguela |
| `saturn` | West Saturn | `gemini` | West Gemini |
| `jupiter` | West Jupiter | `capella` | West Capella |
| `tellus` | West Tellus | `cam` | Sevan Louisiana |
| `carina` | West Carina | | |

*West Phoenix is stacked and has no precharge configuration — correctly absent.*

**Payload** (abridged — this is the calculator's save schema, do not reshape it)

```json
{
  "meta": {
    "tool": "Seadrill BOP Precharge Calculator",
    "asset": "West Capella",
    "schema": 1,
    "saved": "2026-09-05T09:14:22.104Z",
    "source": "BOP Precharge Request form Rev 2",
    "raisedBy": "J Smith",
    "email": "j.smith@seadrill.com",
    "workOrder": "WO-12345",
    "bop": "2",
    "gas": "Nitrogen",
    "tubular": "5-7/8 HWDP",
    "shearSource": "NOV Shear Capability Estimator",
    "changes": "acoustic bank now 2 x 150 gal",
    "airTempLow": "10", "airTempHigh": "32"
  },
  "config": "capella",
  "units": { "wd": "m", "temp": "C", "vol": "gal" },
  "fields": { "well": {"v":"DAL-795"}, "wd": {"v":"1247"}, "subT": {"v":"5"},
              "shReqTop": {"v":"3019"}, "mawhpTop": {"v":"2639"}, "...": "..." },
  "hops": []
}
```

### ✅ 2.1 `meta.asset` — RESOLVED at source, form Rev 2

**The request form now emits `meta.asset` with the full rig display name.** Verified on three rigs:

| `config` | `meta.asset` |
|---|---|
| `quenguela` | `Sonangol Quenguela` |
| `gemini` | `West Gemini` |
| `libongos` | `Sonangol Libongos` |

So precharge requests now obey the same rig-identity contract as every other post in the estate, and will **not** land in "Unattributed".

**Please still implement the `config` → rig-name mapping, but as a fallback:**

1. **Prefer `meta.asset`** when present and non-empty.
2. **Fall back to the `config` mapping** in the table above. Any request raised before form Rev 2 has no `meta.asset`, and those files may still be in flight.
3. Only then treat it as Unattributed.

Keep the fallback permanently — it costs nothing and covers a rig running a cached copy of an older form, which is exactly the sort of thing that happens offshore.

**Identification rule** — route on these, in order:

1. Filename matches `seadrill-request_*_precharge.json`
2. `meta.tool === 'Seadrill BOP Precharge Calculator'` **and** `meta.source` starts with `BOP Precharge Request form`
3. `meta.schema === 1` and `config` is one of the keys above

**This is a REQUEST, not a report.** It must not appear in report counts, the rig report list, or the fleet report chart. It belongs only in the requests inbox.

---

## 3. The request id — QUOTED IDENTICALLY IN BOTH DOCUMENTS

```
id = "<rigKey>_<well>_<YYYYMMDD>_BOP<bop>"

  rigKey  from  payload.config
  well    from  payload.fields.well.v, sanitised: [^A-Za-z0-9._-] → "-"
  YYYYMMDD from meta.saved (date part, UTC). If meta.saved is missing or
           unparseable, fall back to the date in the FILENAME.
  bop     from  meta.bop  ("1" or "2"; if absent use "1")

example:  capella_DAL-795_20260905_BOP2
```

**Treat the id as opaque. Never parse it back apart** — every field you need is in the index (§4). It exists so that both sides construct the same string for the same request, nothing more.

**Dedup:** same id = same logical request, **newest `meta.saved` wins.** Rigs do re-post — a corrected shear pressure is the common case, and the newer file is the one Dan must see.

**One hard rule:** if a request already has `status: "issued"`, a re-post **must not** reset it to `new`. Update the payload, keep the status, and set `resubmitted: true` so it is visibly a revision rather than a fresh job.

---

## 4. Where files go, and the index — QUOTED IDENTICALLY IN BOTH DOCUMENTS

```
/precharge/requests/<id>.json     the request payload, copied verbatim
/precharge/requests/index.json    the list Dan's inbox page reads
```

**`index.json`**

```json
{
  "generated": "2026-09-05T10:20:00Z",
  "requests": [
    {
      "id": "capella_DAL-795_20260905_BOP2",
      "rig": "West Capella",
      "rigKey": "capella",
      "well": "DAL-795",
      "bop": "2",
      "raisedBy": "J Smith",
      "email": "j.smith@seadrill.com",
      "workOrder": "WO-12345",
      "saved": "2026-09-05T09:14:22.104Z",
      "received": "2026-09-05T09:23:11Z",
      "shearReq": "3019",
      "mawhp": "2639",
      "waterDepth": "1247",
      "hops": 0,
      "status": "new",
      "resubmitted": false,
      "file": "requests/capella_DAL-795_20260905_BOP2.json"
    }
  ]
}
```

- `status` ∈ `new` · `opened` · `issued`
- Newest `saved` first is the useful sort order.
- `shearReq`, `mawhp`, `waterDepth` are lifted into the index **only** so the inbox can show them without opening every file. The payload remains authoritative.
- `hops` is a count, not the array.

**Copy the payload verbatim.** Do not normalise, reformat or "tidy" it — it is fed straight into `loadState()` at the other end and has been tested end to end.

---

## 5. Status — or the inbox never empties

| Transition | Who | When |
|---|---|---|
| → `new` | scanner | A request id not seen before |
| → `opened` | inbox page | Dan clicks through to the calculator |
| → `issued` | manual, or the issued-sheet post if built | The precharge sheet has been sent |

Anything still `new` after, say, 48 hours is worth showing in amber on the inbox — that is the failure mode this whole thing exists to prevent.

---

## 6. Rules that must not be broken

1. **One writer.** The scanner writes `/precharge/requests/`. The calculator only ever **reads** it. If a status change needs recording, write it to a separate file — do not have two things writing the same store. (Same reasoning as SACRED LINK never writing to COC allocation data.)
2. **Behind the login.** These carry well data — MASP, water depth, shear requirements. The requests folder must **not** be in an open web share.
3. **The email route stays.** The inbox is a convenience. A rig with no connection still emails the file and that path must keep working — do not build anything that assumes the inbox is the only source.
4. **Transport unchanged.** Nothing in this asks for a change to how anything is posted.

---

## 7. The inbox page (yours to build, if you want it)

A single page behind the login reading `index.json`:

- Table: rig · well · BOP · raised by · received · shear pressure · status
- Newest first, `new` at the top and visually distinct
- Row click → `calculator.html?req=<id>`
- Amber flag on anything `new` for more than 48 hours

Nothing more than that. If you would rather show it as a panel on the existing dashboard than a new page, that is fine — it is the same `index.json` either way.

---

## 9. What the calculator side now guarantees — added by the precharge session

So you can build against something settled rather than an intention.

**The loader is live in Rev 72**, implemented as the companion document specified — same path, same id pattern check, same `cache: 'no-store'`, same failure message pointing at the manual Load button.

**The §7 test matrix, all passing:**

| Test | Result |
|---|---|
| No `?req=` | Identical to today — no fetch attempted at all |
| Valid id | Form filled, correct rig config, checks re-run |
| **Valid id, different rig** | **Correct panel shown, that rig's figures — no bleed from the previous request** |
| Request with `hops` | Hops load correctly |
| Id that does not exist | Clear message, manual Load still works |
| Junk characters in the URL | Ignored, opens normally, no fetch attempted |
| Re-post of a corrected request | `cache: 'no-store'` confirmed on the request |

The cross-rig case was tested deliberately, loading one rig's request over another's session in both directions. The visible output panel switches and shows that rig's figures.

**One defect found and fixed in test, worth knowing about.** The loader as first written referenced `location` at load time, which threw in any environment lacking it and killed the entire script — the calculator would not load at all. It is now guarded on `location`, `URLSearchParams` **and** `fetch` before doing anything. If you ever embed or proxy the calculator somewhere unusual, that guard is what keeps it working.

**What has NOT changed:** no equation, no existing function, no field mapping, no output format. The offline path — open the file locally, load a `.json` by hand — is untouched and was re-tested. Full qualification suite 47/47, save/load regression passing, and a rendered diff across all 13 rigs shows **no rig moved**.

**On §6 rule 1 (one writer):** agreed and respected. The calculator only ever **reads** `/precharge/requests/`. It writes nothing there and never will.

---

## 8. Questions back

1. Are you content generating `index.json`, or would you rather the inbox page scan the folder itself? The index makes the page trivial and keeps one definition of status, which is why it is proposed.
2. Where should the requests folder physically live on the SACRED server, and is it inside the authenticated area already?
3. Do you want the scanner to also handle the **return leg** — Dan posts the issued precharge sheet, and it flips the request to `issued` and notifies the rig? That closes the loop properly. Not required for the first cut.

### Answers from the precharge session

1. **Index, please** — for the reason given. One definition of status, and the inbox page stays trivial.
2. Not ours to answer, but the requests carry MASP, water depth and shear requirements, so §6 rule 2 matters. Behind the login.
3. **Worth doing, but not first.** The issued sheet already posts through the same transport — the calculator's own "Post to Dashboard", live since Rev 63 — with a filename `seadrill-report_<rig>_<date>_precharge.json`. Note **`-report_`**, not `-request_`: that is how you tell the two legs apart. If you want the return leg later, matching an issued sheet back to its request on rig + well + BOP would do it, and no change is needed at our end.
