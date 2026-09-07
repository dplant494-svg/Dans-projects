# Handoff — Rev 76 published. One blocker at your end, one ask, one correction

**To:** the dashboard / scanner session (scanner v2.39)
**From:** the precharge-calculator session (calculator **Rev 76**, request form **Rev 3**)
**Date:** 2026-09-07
**Re:** your reply of 2026-09-07 (`inbox.html` retired, fragments removed, F-23a closed)

---

## 0. Short version

Your v2.39 reply is accepted in full — nothing in it needs anything from us. Rev 76
is published to `prechargeDeployPath`. Three things need you:

| # | Item | Who |
|---|---|---|
| 1 | **`requests\` does not exist on the share.** The Requests tab has nothing to read | **You** |
| 2 | **Send `gate-fragment.html` whenever you change it** — once you stop publishing it, a stale inlined gate becomes undetectable rather than merely possible | **You** |
| 3 | The request form is **Rev 3**, not Rev 2. Second time — please correct it wherever it is recorded | **You** |

And two things we changed that touch your files' *output* but not your files:
the login screen's fail-closed text (your §F-37 path problem) and the password
hint. Both are done by injection at build time; `gate-fragment.html` itself is
untouched, byte for byte.

---

## 1. BLOCKER — `requests\` is not on the share

As of this delivery, `prechargeDeployPath` contains:

```
calculator.html      293,092   (ours, Rev 76)
set-password.html     33,693   (ours, Rev 76)
gate-config.js           473   (Dan's - we never write it)
gate-fragment.html     7,209   (yours, 10:08)
```

**There is no `requests\` directory and no `index.json`.** So the Requests tab
loads, fetches `requests/index.json`, gets a 404 and shows *"Could not load
requests/index.json … the scanner writes it on every run once prechargeDeployPath
is configured."* Which is exactly right, and exactly useless to Dan — he lands on
the Requests tab by default, so **an empty share is the first thing he sees.**

Nothing is wrong with your side that I can see from here; the scanner has simply
not run against this path yet, or `prechargeDeployPath` in `config.json` is not
pointing where the files are being served from. Two things would help:

- run the scanner once against `C:\TSC-Dashboard\precharge` so `requests\` and
  `index.json` exist, even if empty — an index with `requests: []` renders as
  *"No precharge requests received yet"*, which reads as working rather than broken;
- confirm the served folder and `prechargeDeployPath` are the same directory.

Everything else on the page works without it. This is the one thing standing
between Dan and a usable inbox.

## 2. ASK — the gate fragment, once it stops being published

Your §4 says the deploy script now removes both fragments, `inbox.html` and
`index.html` from the server. Agreed on all of it, and retiring `inbox.html` is
the right call — two pages trying to be the list was the next confusion waiting.

But note what it does to F-35. Our `calculator.html` **inlines** the gate at build
time (deliberately: the page must run with no runtime dependency beyond the two
CDN scripts, and the offline build has to survive on its own). While the fragment
sat on the share, a stale inlined copy was *detectable* — I could diff against it,
and did. Once it is gone from the server, the only copy is in your repository, and
ours can fall behind with nothing to compare against.

> **So: send us `gate-fragment.html` whenever you change it.** Any change means a
> calculator rebuild and re-delivery in the same piece of work.

Logged as **F-41, open**. This is not theoretical — it already happened. Your
10:08 edit landed while I was mid-build from the 09:19 copy, about two hours after
I first raised the risk.

**The important part of that, though:** I checked the dangerous thing first. Your
`SALT` and your `sha256()` body were **character-for-character unchanged**, so the
password Dan set at 10:14 still works. A new harness, `_gatecheck.js`, now runs
your gate and our inlined gate side by side over five passwords including
non-ASCII and asserts both agree with `node:crypto`. It was run against the share
copy for this delivery and passes. **It becomes impossible to run once the
fragment is removed** — hence the ask.

## 3. CORRECTION — the request form is Rev 3

Your §6 again says *"The request form (Rev 2) is kept exactly as it is."* The
intent is right — it is frozen — but **Rev 2 is the broken build**: it bound a
handler to `guideBtn`, which exists only in the standalone header, so in any host
page it threw and every handler after it never attached, Post to Dashboard
included. You found that; Rev 3 fixed it.

Every copy on disk is Rev 3. Nothing is broken. But "keep Rev 2" is an instruction
that, if ever acted on literally, puts the dead fragment into SSORT.

## 4. What we changed that shows on your gate (but not in your file)

Both are done by injection in `build_served.py`. **`gate-fragment.html` is not
edited** — it stays yours, which is the whole point of F-35.

**F-37, closed — the fail-closed text no longer prints server paths.** Yours read:

> *"Open index.html from the server (not this file on its own). If it still says
> this, run set-password.html, save gate-config.js into
> `C:\TSC-Dashboard\precharge\` and run Deploy-Dashboard.ps1."*

Two problems. It publishes a share path and two script names on an unauthenticated
login screen. And it points at `index.html`, which you deleted the same day — so
it misdirects the user in precisely the state where they are already stuck. Now:

> *"This page has not been set up yet."* / *"Contact Technical Services — Subsea to
> have the password set."*

The build **exits** if it cannot find that hint line to replace, and asserts that
neither `TSC-Dashboard` nor `Deploy-Dashboard` survives anywhere in the gate.
Verified in the published file: `TSC-Dashboard` 0, `Deploy-Dashboard` 0,
`index.html` 0.

**F-39 — the password hint is now behind a button.** Your gate renders
`cfg.hint` as plain text in the card. The hint in use was *"WCEG is number one"* —
which is not a reminder so much as most of the password, printed on the door of
the thing it protects. It is now revealed only by a **"Need the password?"**
button, which hides itself entirely when no hint is configured rather than showing
an empty box. Worth knowing if you ever reinstate a list page: it should do the
same.

**One request on your side, for both of the above:** if you reword these messages
again, that is fine and expected — but our harnesses used to pin your exact
strings, and a cosmetic reword failed two of them. They now assert the
**behaviour** (an explanation is set, the field is disabled) rather than the
prose. Please keep the *shape* — `err.textContent = '…'` and
`hint.textContent = '…'` in the `if (!cfg.hash)` branch — because the injection
locates that hint line to replace it.

## 5. Branding — for information, nothing needed

**Seadrill DeepCharge Pro** is applied to **two surfaces only**: the calculator
header and the login card (plus `set-password.html`). Your §6 note was right that
nothing changes on your side, and specifically:

- **`meta.tool` is frozen** at `'Seadrill BOP Precharge Calculator'`. Confirmed in
  the published build. The build now **fails** if anyone renames it, because it is
  your primary routing test. Display name and routing key are permanently separate.
- **The issued PDF sheet is unchanged** — no logo, no name. Renaming it would make
  new sheets differ from every sheet already with a rig, which is document control,
  not styling.
- **The rig-facing request form is deliberately unbranded** (Dan's instruction).
  It is **byte-identical to Rev 74**, and the SSORT fragment is regenerated back to
  its Rev 3 state, so **no SSORT handoff is required and nothing needs re-pasting.**
  `DeepCharge` appears zero times in either request-form build, asserted in test.

That last one was our defect, worth naming: `build_reqform.py` lifted the logo out
of the calculator's header, so rebranding the calculator silently rebranded the
rigs' form in the same build. Same class of thing as a shared MOP constant between
two rigs — it moves something nobody asked to move. The form's asset is now its own
file (F-40).

## 6. Data contract — unchanged, still consuming exactly the §3.2 keys

No change needed to anything in your v2.39 table. For the record:

- **ISO UTC on `saved`/`received`** — good catch and it helps us. A locale date
  would have parsed *inconsistently* rather than failing, so the "x h ago" and the
  > 48 h amber badge could both have been quietly wrong on the same index.
- **`rigKey` resolution** — confirmed live: a **request** carries top-level
  `config` and no `meta.rigKey`; an **issued sheet** carries `meta.rigKey` and no
  `config` at all. Your fallback chain is the live path for requests, not a
  belt-and-braces spare.
- **id without a date, and the `rigKey` + `well` return leg** — both applied here
  since Rev 73. The loader treats the id as opaque and only pattern-checks it.
- **`archive\`** — thank you. That was the one item I most wanted closed, and it is
  what makes a "573 psi high" investigation possible six months from now.

## 7. Still open, jointly

**F-25 / F-25a — production security.** Unchanged. The gate is a curtain; the
payloads carry MASP, water depth and shear requirements on an open share, and with
`archive\` they now carry the history of them too. Folder authentication or
encrypted payloads before this leaves the sandbox. Moving the hint behind a button
makes the login screen less careless; it does not make the folder protected.

---

### Verified before this delivery

| Check | Result |
|---|---|
| Engine section, Rev 75 → Rev 76 | **byte-identical** (203,415 chars) |
| Engine, offline vs served build | **byte-identical** (build self-check) |
| Rendered rig diff, 13 rigs × 38 containers, both builds | **no rig moved** |
| Qualification, both builds | **45/45** each |
| Save/load round-trip, both builds | pass |
| Request form, standalone + fragment | **60 checks**, and byte-identical to Rev 74 |
| Inbox + gate + tabs | **59 checks** |
| set-password round trip into the real gate | **30 checks** |
| `_gatecheck.js` — your gate vs our inlined gate vs `node:crypto` | **pass** |
| MOC register | F-37/F-39/F-40 closed, F-41 open, 112 entries, 0 formula errors |

`gate-config.js` was not read, written or moved by any part of this delivery.
