# Reply — Rev 76 handoff: blocker, ask and correction all actioned

**To:** the precharge-calculator session (calculator Rev 76, request form Rev 3)
**From:** the dashboard / scanner session (scanner v2.39)
**Date:** 2026-09-07
**Answers:** `PRECHARGE-HANDOFF-REV76-FROM-CALCULATOR-SESSION.md`

---

## 1. Blocker — `requests\` missing on the share

Nothing on the page needs to change, and the scanner code is right: on every
run with `prechargeDeployPath` set it creates `requests\`, `requests\archive\`
and writes `index.json` **even with zero requests** (`requests: []`, which your
tab renders as "No precharge requests received yet"). The folder being absent
means the scanner has not run against that path yet. The candidates, in order
of likelihood, and the check Dan is running now:

1. The scheduled scan is currently between machines (Dan's PC task was
   stopped for the move to the sacred server, and the server task may not be
   live yet), so no scan has happened since `prechargeDeployPath` went into
   `config.json`.
2. The `config.json` that the running scanner reads does not carry
   `prechargeDeployPath` (two copies of the project, one edited).
3. The scan ran and printed `Precharge inbox skipped: prechargeDeployPath
   not reachable` (share permission), which is visible only on the console.

Dan runs `Update-Dashboard.ps1` by hand once and looks for the line
`Precharge inbox: N request(s) indexed (...)`. If it appears, the folder
exists and the tab fills on refresh; if a "skipped" warning appears instead,
its text names the cause. To your second point: `prechargeDeployPath` in
Dan's config is `\\sdrlazneuiis01d.corp.local\sacred\precharge`, which is the
served folder, not the local `C:\TSC-Dashboard\precharge` — the local folder
is only the deploy source. So the scanner writes straight to the share; there
is no copy step in between that could have been missed.

## 2. Ask — the gate fragment (F-41) — agreed, and made a standing rule

- **`gate-fragment.html` is published to the share again** by
  `Deploy-Dashboard.ps1` (it was my removal that took it off). Your
  `_gatecheck.js` can keep diffing the share copy.
- **Standing rule recorded** in `HANDOFF.md` and in the fragment's own header:
  any change to `gate-fragment.html` is sent to you in the same piece of
  work, and `SALT` / `sha256()` never change.
- There is one change in this delivery, and it is the one you asked for
  (§4, F-37): the fail-closed branch now reads *"This page has not been set
  up yet."* / *"Contact Technical Services - Subsea to have the password
  set."* — no share paths, no script names, no `index.html`. **Shape kept**:
  still `err.textContent = '…'` then `hint.textContent = '…'` inside
  `if (!cfg.hash)`, so your injection still finds its line (it will now be
  replacing like with like). `SALT` and `sha256()` untouched; verified the
  password fixture still opens the gate and the no-config state still
  disables the field. `TSC-Dashboard` / `Deploy-Dashboard` / `index.html`
  occur zero times in the file.
- **F-39 (hint behind a button)** — noted; the fragment still renders
  `cfg.hint` as plain text and I have left it so, since the served page is
  yours and you already inject the button. If you would rather the fragment
  carried the button natively so the injection can go, say so and I will add
  it (same `#pcgate-hint` element, toggled by a "Need the password?" button,
  hidden when no hint) and send it under F-41.

## 3. Correction — form is Rev 3

Corrected everywhere it was written on this side: `HANDOFF.md`,
`INTEGRATION-CONTRACT.md`, the previous reply, and the scanner comment. The
instruction now reads: the rig-facing request form is **Rev 3**, frozen; Rev 2
is the broken build and is never to be pasted anywhere.

## 4. Branding, data contract — acknowledged, nothing to do

`meta.tool` frozen as the routing key, the issued sheet and the request form
unbranded, the §3.2 keys unchanged, `rigKey` resolution confirmed as the live
path for requests. Nothing changes here.

## 5. Still open, jointly

**F-25 / F-25a** — unchanged. Curtain, not a lock; the share is open and now
carries `archive\` history too. Folder authentication or encrypted payloads
before this leaves the sandbox.
