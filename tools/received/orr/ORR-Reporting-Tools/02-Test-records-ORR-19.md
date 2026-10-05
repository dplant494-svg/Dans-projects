# ORR 19 — Test records by revision

**Tools:** WCGRRT REV 160–167, SSORT REV 144–157 · **Owner:** Dan Plant
**Date compiled:** 5 October 2026

## Read this first — what is a record and what is a reconstruction

Two different things are in the table below and ISIT should be able to tell them apart.

- **Rows marked ✔ RECORD** were verified at the time, with the checks named, and the result is
  first-hand. That is REV 149 onwards in SSORT and REV 166 in WCGRRT.
- **Rows marked ~ RECONSTRUCTED** carry the file's real hash and byte count, recomputed from the
  revision folder on 30 September 2026, and what the change was per
  `DASHBOARD-ROLLING-HANDOFF.md`. **A contemporaneous test log was not kept for those revisions.**
  The hash and size are facts; "what was checked" is inferred from the handoff entry, not from a
  test record written on the day.

**This is a real gap and it is stated rather than papered over.** A per-revision test record became
a deliberate artefact from REV 149 (SSORT). Everything before that was verified in a browser before
it shipped, but the verification was not written down in a form an auditor can rely on. The runbook
(ORR 6, 7) now makes the record part of the deploy.

Every hash below is **SHA-256, first 12 hex characters**, recomputed on 30 September 2026 and
reproducible with `Get-FileHash -Algorithm SHA256`.

---

## SSORT

| REV | Date | Bytes | SHA-256 (12) | What was checked | Result |
|---|---|---|---|---|---|
| 144 | Sep 2026 | 8,906,306 | `2feebc7596ee` | ~ RECONSTRUCTED — daily-check readings added | shipped |
| 146 | Sep 2026 | 8,931,412 | `8ef9291f810e` | ~ RECONSTRUCTED — pre-deployment checklist, packer attestation, cavity photographs | shipped |
| 147 | Sep 2026 | 8,941,320 | `5171685675c9` | ~ RECONSTRUCTED — potable-water comment defect fixed | shipped |
| 148 | 24 Sep 2026 | 6,774,894 | `ff83c12cdff1` | ~ RECONSTRUCTED — three iframe test blobs removed and the forms rebuilt native; `meta.rev` written for the first time; `cbmlabels` added; two base64 blobs stripped. Size falls 2.17 MB, consistent with the blob removal | shipped |
| 149 | 26 Sep 2026 | 6,781,942 | `b73370a7d949` | ✔ RECORD — editable reference-photo captions. Script blocks parse; no duplicate declarations; posting path byte-identical; browser-tested on `SSCE Equipment` | pass |
| 150 | 28 Sep 2026 | 6,782,841 | `97b68be56e3f` | ✔ RECORD — `calcData` gains per-cavity `status`/`ramLabel`/`checks[]`; Riser Adapter 1.1 photograph slots (11 tasks). Task count, task order, every task description and the criteria count asserted unchanged outside the 11; hash-verified on deploy | pass |
| 151 | 29 Sep 2026 | 6,782,830 | `e1879f4ecdd7` | ✔ RECORD — Riser Adapter 1.1 grade buttons (11 tasks). Same assertions; browser-tested through IIS: 11 grade rows, 11 photo grids, a graded task reaching the payload as `"3"`, zero console errors; test state cleared | pass |
| 152 | 30 Sep 2026 | 6,799,847 | `05133b2283ae` | ✔ RECORD — CBM test-record attachments (`cbmatt`); Post to OEM also posts to the dashboard. 15 anchored edits each matching exactly once; both script blocks parse; extraction reconciles to 97.1%; zero duplicate declarations; posting path byte-identical; 0.82 unchanged; `CBM_SCHED` unchanged; precharge untouched. Browser: attach, `.exe` refused, 20 MB refused, notes, running total, removal, **crash recovery** (restored report returns both files with notes, bytes and data). Dual post proven with `fetch` disabled and the transport stubbed — dashboard first, then OEM, nothing sent | pass |
| 153 | 30 Sep 2026 | 6,800,443 | `44cb4db89d2c` | ✔ RECORD — `OEM_SEND_FILES` switched on so test records reach NOV as email attachments. Function list asserted identical to 152 (flag and wording only); 30 MB OEM refusal and the 20/8/15 MB attachment figures asserted intact; posting path byte-identical. Browser: `files[]` carries exactly `name`/`type`/`data`, dashboard post still first, `cbmatt` unchanged on the dashboard copy, zero console errors — all with the transport stubbed. Re-verified through IIS after deploy, cancelling at the confirm | pass |

| 154 | 1 Oct 2026 | 6,804,809 | `f70d21f678b0` | ✔ RECORD — two defects: the EHBS timer delay never recomputed as a crew typed (reported from a rig), and **restoring a Surface BOP test destroyed the record** — five of seven forms are rig-keyed and `loadState` built the tiles before restoring the rig, so the next autosave overwrote the saved readings with nothing. Both reproduced on the deployed build first. Fix verified end to end: a restored EHBS record returns all 33 fields with its readings and survives the re-save; Acoustic (80 fields) and Surface Drawdown (54) likewise. Shared renderer asserted to cover all seven live types; `collectSbop` and the posting path byte-identical | pass |

| 155 | 2 Oct 2026 | 6,814,422 | `77a8562f935f` | ✔ RECORD — two new NOV documents: the Diverter document that had been recorded as non-existent, and a new Riser Spider Assembly and Gimbal class. Grade rows can now show only the levels NOV publishes for an item. Structure asserted unchanged outside the Diverter and the new class; every other class byte-identical | pass |
| 156 | 2 Oct 2026 | 6,893,201 | `94c0c448fd58` | ✔ RECORD — NOV’s pass/fail scale applied to all 211 previously ungraded Testing and Intrusive tasks across 21 classes. Schedule structure asserted identical; General Inspections asserted untouched; the 18 tasks already carrying NOV criteria asserted byte-identical, including Flexloops 23.3.2 and its five-level criteria | pass |
| 157 | 5 Oct 2026 | 6,895,584 | `ba2ddd573e99` | ✔ RECORD — West Auriga’s daily checks sheet reported missing; it was the panel being built before the rig was picked and never rebuilt (KE-14). Three cases verified on the deployed build: stale panel corrects on rig change; switching between two same-format rigs does **not** rebuild and keeps every reading; a genuinely different sheet drops non-matching readings and says so. All three rig sheets asserted untouched | pass |

**SSORT REV 157 is what is deployed.** Live file verified 5 October: 6,895,584 bytes,
`ba2ddd573e99`, identical to the `SSORT REV 157` folder.

## WCGRRT

| REV | Date | Bytes | SHA-256 (12) | What was checked | Result |
|---|---|---|---|---|---|
| 160 | Sep 2026 | 5,040,569 | `d5737825c56e` | ~ RECONSTRUCTED — oversize-report diagnosis; CBM ceiling separated | shipped |
| 161 | 16 Sep 2026 | 5,061,859 | `975f6c4ddf92` | ~ RECONSTRUCTED — **the overwrite fix**: a daily report is named for the day it covers, so two days can no longer collide under one filename | shipped |
| 162 | Sep 2026 | 5,069,292 | `2b0ddcd1fe68` | ~ RECONSTRUCTED | shipped |
| 163 | Sep 2026 | 5,094,789 | `af8ef205469d` | ~ RECONSTRUCTED — **shipped with a stale `TOOL_REV = 'REV 162'`.** See the Known error log; a post from 163 is indistinguishable from a post from 162 | shipped, defect |
| 164 | 21 Sep 2026 | 5,095,443 | `bcb8495f0aeb` | ~ RECONSTRUCTED | shipped |
| 165 | 23 Sep 2026 | 4,497,595 | `b83914df1caf` | ~ RECONSTRUCTED — acoustic form rebuilt native, the duplicate-declaration defect removed, `Sevan Louisiana` added to the no-system list. Size falls 598 KB with the blob | shipped |
| 166 | 26 Sep 2026 | 3,340,404 | `83929b1a6749` | ✔ RECORD — EHBS and drawdown native (last iframe gone), inline narrative references, printed page breaks. Script blocks parse; no duplicate declarations; browser-tested on two rigs; acoustic and EHBS exercised on a restore path as well as a fresh form. Size falls a further 1.16 MB | pass |

| 167 | 1 Oct 2026 | 3,342,479 | `c916a062d457` | ✔ RECORD — the EHBS timer delay now recomputes as the crew types. Verified: A alone “—”, A and B 11, B corrected to 30 gives 9, B cleared returns to “—” with no stale value. Posting path byte-identical; no new key | pass |

**WCGRRT REV 167 is what is deployed.** Live file verified 1 October: 3,342,479 bytes,
`c916a062d457`, identical to the `WCGRRT REV 167` folder.

---

## Standing verification, applied to every revision from 149 / 166 onwards

1. Every `<script>` block parses.
2. Script extraction reconciles to the file length (a stray `</script>` in a string would otherwise
   hide a truncated check).
3. No duplicate top-level declarations.
4. `sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportFileName`, `sdSizeOk` and
   `buildReportPayload` byte-identical unless the change is deliberately there.
5. Zero `mode:'no-cors'`.
6. Photo compression `0.82` and the ceilings (10 / 40 / 30 MB) unchanged.
7. `CBM_SCHED` unchanged unless that is the change.
8. Browser test on asset `SSCE Equipment`, zero console errors, **nothing posted**.
9. Hash and byte count of the deployed file recorded, before and after the copy.
10. Test state cleared from the served origin afterwards.

## Acceptance test

The four Day 1 exercise reports are the acceptance test for both tools — see
`06-UAT-ORR-9.md`.
