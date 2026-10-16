# Reply to Argo Navis REV 16, from SACRED

**Date:** 16 Oct 2026. **To:** Lee Arnold and the Argo Navis session, via Dan. **Re:** `00_ARGO-NAVIS-HANDOVER-TO-DAN-2026-10-16.md` and `1_ARGO-NAVIS-REV16-REPLY-TO-DAN.md`.

**Thank you: REV 16 does everything Handoff 3 and the pm update asked for.** That covers:

- the landing page;
- Save at any stage;
- one Post report at the top and the bottom;
- the server-save chip that is never silent;
- dates and numbered stars on the chronology.

**Enclosed:** the three files you said you did not receive. Your questions in section 7 were mostly answered in the first of them, so the answers below point back to it:

- `ARGO-NAVIS-REV15-REPLY-FROM-SACRED-2026-10-16.md`
- `ARGO-NAVIS-REV16-PLAN-REVIEW-FROM-SACRED.md`
- `ARGO-NAVIS-HANDOFF-4-PREVIEW-AND-MILESTONE-DATES.md`

## What SACRED checked

- **The package is clean.**
  - Zip `d7383205…41a3` and HTML `299eed6e…e945` match your note.
  - A scan of the whole pack and the unzipped tool finds no intake address.
- **Your session save fits scanner v3.08 as it is.** `West-Vela_DL1_session_WVE-BOP1-20261014.json` carries `meta.kind = "plan-session"`, `meta.planid`, a top-level `scheduleBuilderState` and `dryRun: true`. The scanner:
  - files it as a test session;
  - copies it to `plans-state/WVE-BOP1-20261014.test.json`;
  - lists it in `plans-state/index.json` with `kind: "session"`, `stage`, `by`, `saved` and the `path` to fetch.

  The newest save per plan wins, whether it is a session save or a daily report. **No scanner change is needed for REV 16.**

## Your section 7, answered

1. **Deploy REV 16.** Dan deploys it today and tells you when it is live. Then please make the first dryRun **Save** and **Post daily report** from the server page, and tell Dan when. Within about 10 minutes SACRED should show:
   - the session in `/sacred/dl1/plans-state/`;
   - the report printed to PDF;
   - the `[TEST MODE]` email, to Dan and Lee only.
2. **BOP ready date = the finish of the BOP set** (SFI 331 + 332 + the BOP sequence): **yes, confirmed.**
   - It matches Dan's definition: BOP work only, from BOP on beams to testing complete, drifted, the pre-deployment call and BOP ready to deploy.
   - `curFinish` stays the whole plan's finish.
   - Keep the banner that says when non-BOP work runs past the BOP ready date.
3. **The 31 SFI 302 / 315 Branch Map rows: accepted, as proposed.** That means Offline Ancillary, one parallel group per SFI, rank 500, no predecessors, and durations as given.
   - The only change is the group names, which follow answer 4: "302 HEAVE COMPENSATION & CROWN BLOCK" and "315 HP COMPRESSED NITROGEN".
   - Dan pastes the rows into the map on the share.
4. **`sfiGroup` names.** SSORT 163 uses **Maximo's own names**, so SSORT, the CoC tracker and Maximo all match. Please use the same:
   - 331 BLOWOUT PREVENTER STACK
   - 332 BLOWOUT PREVENTER CONTROL SYSTEM
   - 334 DIVERTER WITH CONTROL SYSTEM
   - 335 RISER SYSTEM INCL. CHOKE, KILL LINES
   - 336 CHOKE AND KILL SYSTEM INCL. MUD/GAS SEPARATOR
   - 337 MISCELLANEOUS WELL CONTROL RELATED EQUIPMENT
   - 339 MANAGED PRESSURE DRILLING
   - No Maximo name yet, so SSORT's derived names stand:
     - 302 HEAVE COMPENSATION & CROWN BLOCK
     - 314 RISER & GUIDELINE TENSIONING
     - 315 HP COMPRESSED NITROGEN

   Your Hub names ("302 Heave / motion compensation", "315 Subsea support utilities") should change to these, so every tool uses the same words.
5. **Which copy Continue refused.** It was **your own REV 15 sample**, byte for byte: `West-Vela_DL1_planning-report_BOP1_v2.json`, sha256 `6a6562f1…`, filed on Dan's side with a `SAMPLE_` prefix. Dan opened it with Continue on REV 15 as served from `/sacred/dl1/`. You open the same bytes without trouble, so the difference may be the server page rather than the file.
   - **Dan re-tests on REV 16** (Continue from a file on this PC, then the landing page) and reports back with the exact message.
   - If REV 16 refuses it, the message now names the keys it saw, which will tell us why.
6. **The event PM exports: yes, through the scanner.** Put `BWM_Event_PMs_Maximo_*.csv` and `CBM_Event_PMs_Maximo_*.csv` in the share's `Job Plans` folder and tell Dan.
   - If that folder's line in Dan's `dl1DataSources` only takes `*.xlsx`, Dan adds a second line for `*.csv`.
   - They then arrive in `/sacred/dl1/data/` with the other inputs.
   - SACRED does not need the "no WO yet" list as a separate post for now.
7. **Still open from before:**
   - **`review.comments` in `plans-open.json`: done since scanner v2.99.** It is in both `plans-open.json` and `plans-status/<planId>.json`, as an array of `{ by, position, decision, text, at }`, empty when nobody has written anything.
   - **Freeze keeps the verified scope version: confirmed (v2.99).** The review state is keyed by plan and scope version, so a frozen post at the same `scopeVersion` stays "verified". A tie on time is settled by status: frozen over proposed, closed over both. Please write `meta.saved` as the post time on every post; the scanner reads it before `exportedAt`.
   - **The sign-off order and the B-16 / B-M1 directives:** still Dan's, after the workshop (19 to 22 Oct).
   - **The eDocs prefix:** waiting on ISIT. Dan has created the eDOCS folder **Argo Navis Schedule Builder** (number 11296372) and asked ISIT for the connector. Until then, close-out packs are built by the scanner (v3.11) into the plan's `08 AAR and Close-out` folder, ready to file.
   - **Manpreet's data request:** Dan sends your reviewed version (`4_Argo-Navis_Maximo-Data-Request.md`) to Manpreet. Items 3 (NC records) and 4 (AAB states) come first.

## Next

1. Dan deploys REV 16 and tells you.
2. You make the first dryRun Save and Post daily report from the server page.
3. SACRED and Dan confirm the session, the PDF and the test email arrived.
4. Then the Superintendents see REV 16 at the workshop on Tuesday 20 Oct (13:00 to 14:30), with the hold point on daily reporting.
