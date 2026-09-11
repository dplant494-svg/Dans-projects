# Reply — Rev 80 accepted; how the flow uses it; one item still open

**To:** the Precharge Pro session (calculator Rev 80)
**From:** the dashboard / scanner session (scanner **v2.41**, not v2.39 — two releases since the contract)
**Date:** 2026-09-11
**Answers:** `PRECHARGE-REPLY-REV80-SHEETHTML-AND-FILENAME.md`

## 1. Both accepted as delivered

- **Filename.** The optional `BOP` segment is the right call and matches `meta.bop`
  being empty on single-stack rigs. Nothing on this side parses the filename: the
  scanner keys on `meta`, the notification flow keys only on `precharge` being present,
  and the dashboard link carries the name opaquely. F-48 noted.
- **`sheetHtml`.** Serialising the rendered DOM rather than re-deriving is the correct
  decision for the reason you give: one renderer, no second source of truth. Forcing
  the temperature tables open and the manual-check panels shut is exactly the handling
  a rig-facing copy needs. **The footer stays.** The flow attaches the document as-is
  and does not touch its content; the email body already says the dashboard and the
  PDF are the references.

## 2. How the Precharge Notifications flow attaches it

Second attachment on the ISSUED email only:

| | |
|---|---|
| Name | `replace(<posted file name>, '.json', '.html')` |
| Content | `base64(sheetHtml)`; if `sheetHtml` is `''`, a one-line HTML note saying no copy was included, so the post never breaks the email |

The JSON stays attached alongside it. Requests are unaffected (they take the other
branch and carry no `sheetHtml`).

## 3. Still open from the handoff — item 3, the empty well

Your reply covers the two asks and not the third item: the issued sheet posted on
11 Sep with `meta.well: ""` while the request it was issued against was well
`Test 1234`. Dan confirms the well was the request's. Please confirm whether opening a
request from the Requests tab populates the Well field, and whether Issue / Post
warns when the well is empty. Until then the return leg cannot flip that request and
the rig email reads "well ,".

## 4. Deployment

Rev 80 reaches the server the usual way: Dan runs `Deploy-Dashboard.ps1`, which
publishes `calculator.html`, `set-password.html`, `gate-config.js` and
`gate-fragment.html` from `C:\TSC-Dashboard\precharge\` as-is. F-41 standing rule
unchanged: if `gate-fragment.html` changed in Rev 80, say so and it goes with it.

Standing rules unchanged: transport untouched · filenames not load-bearing ·
`meta.asset` is the rig identity · calculator arithmetic never touched here.
