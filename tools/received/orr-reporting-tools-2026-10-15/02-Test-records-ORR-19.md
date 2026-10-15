# ORR 19 — Test records by revision

**Tools:** WCGRRT REV 160–169, SSORT REV 144–163 · **Owner:** Dan Plant
**Date compiled:** 6 October 2026

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

| 158 | 6 Oct 2026 | 6,897,196 | `6c06a4712ebf` | ✔ RECORD — two CBM inspections on one rig on one day overwrote each other (KE-15). Name now carries the equipment and serial; surface tests the test type. With the transport disabled: the reported collision separates; a corrected re-post replaces; two serials separate; Post to OEM then Post Report produces one file; checklist and plain rig-visit names verified unchanged. OEM `sourceFile`, always empty before, now carries the report name | pass |

| 159 | 9 Oct 2026 | 6,897,611 | `785c4ae8c415` | ✔ RECORD — the KE-15 residual, confirmed on the live 158 first: two different gate valves with the serial blank shared a name, and a serial typed only in Recipient Details was ignored. 159 takes the Model Data serial, else the Recipient serial, else the Recipient model. With the transport disabled: two valves separate; a corrected re-post replaces; serial names unchanged from 158; plain rig-visit name unchanged; reportFileName, sdSlug and the posting path byte-identical. Re-checked on the live file through IIS | pass |

| 160 | 9 Oct 2026 | 6,902,948 | `1e797e85e2af` | ✔ RECORD — Dan, 9 Oct: Recipient model and serial are per unit (a Riser Adapter serial had reached NOV on a gate valve). Never copied, remembered or duplicated; marked required by NOV; Post to OEM asks when blank. C&K Stabs gains Stab Identification, 12 new `ckstab_*` keys announced in handoff entry 55. With the transport disabled: old remembered details start Model and Serial blank; copy-to-all copies company and job only; Duplicate blanks unit identity; 12 keys collected on C&K only; table in the OEM HTML; the prompt fires on blank and not on filled. File name, posting path and sizes byte-identical. Re-checked on the live file through IIS | pass |

| 161 | 11 Oct 2026 | 6,936,884 | `a5da5eacfcc7` | ✔ RECORD — Technical Assistance Request (FRM-00-0169) in Requests, beside the precharge request (Dan, 11 Oct). Posts `seadrill-help_<rigkey>_<stamp>.json` through the unchanged sdPostReport; the filled-in FRM rides as the first attachment; 20 MB file cap; one send per request. Payload validated against the live flow schema; failure path, draft and requestId recovery, file whitelist and cap tested with posting stubbed. Precharge panel and its glue byte-identical. End-to-end practice send by Dan on SSCE Equipment landed: email, Teams chat, receipt, Help Centre card (handoff entry 60) | pass |

| 162–163 | 12 Oct 2026 | 7,345,170 | `825de795e869` | ✔ RECORD — 162 (built, not shipped alone): DL-1 plan picker + `meta.planid` on posts, 🔗 Link to plan on surface tests and the pre-deployment checklist with `seadrill-planlink_` records (handoff 64). 163: the assistance request's Equipment affected picks an SFI code from 28,916 Maximo codes for the 14 SSORT rigs, embedded gzipped (handoff 65/66). Tested against a plans-open.json in the dashboard's shape and posting stubbed: picker, rig guard, link record, refusals, SFI pick, payload, FRM row 5. Posting path byte-identical; one new GET (plan list). Re-checked live through IIS against the real v2.89 plan list | pass |

| 164 | 13 Oct 2026 | 7,345,616 | `18b4d6346c39` | ✔ RECORD — Daily Log tab (KE-18). The Daily Log document (Generate / Refresh, Print, and the PDF Generate & Post Month prints) listed entries from the entry form, which Add to Log clears, so it never carried the month's entries; it now lists the selected month's entries from the month's log. Removed below the Monthly box: the end-of-trip archive line and three buttons, among them a Post Report that posted a blank, untyped report from this tab. Badge date current. With posting stubbed: two October entries and one September; October preview 2 and September 1; Generate & Post Month posts `…_2026-10_daily-log.json` with 2 entries and prints them; Rig Reporting Post Report unchanged. Posting functions (sdPostReport, postReport, dlPostPayload, addToLog, postMonthlyLog, checksPost, postLessonLearned, tarqSend, sdLinkToPlan), buildReportPayload and the precharge panel byte-identical. Re-checked live through IIS | pass |

| 165 | 14 Oct 2026 | 7,350,417 | `f4c982426a05` | ✔ RECORD — Pre-deployment checklist: FRM-00-0168 Rev 9 additions (Dan, 14 Oct; form going to Rev 9). ROV panel valve orientation and line-up (tick + captioned photographs, 12 slots + 6 more), riser running and pulling (checklist, drops inspection, seals: ticks), riser maintenance by 3rd party (named) / CBM / Seadrill. 10 new `pdc_r9_*` keys announced in handoff entry 76. One new post stop: 3rd party ticked with no company. With posting stubbed: section renders; two photographs through the real upload path; the stop fires and clears; + 6 slots; every value and caption restores from the saved file; the PDF prints the section; file name and every Rev 8 value unchanged. Posting functions, buildReportPayload, collectPdc, sdPdcComplete, PDC_ITEMS and the precharge panel byte-identical. Re-checked live through IIS, with 164's Daily Log fix | pass |

| 166 | 14 Oct 2026 | 7,350,749 | `5dd8da79af74` | ✔ RECORD — "Nothing to post" guard (dashboard handoff 14 Oct, ask 2; Dan: "do this now"). Post Report refuses when the Rig Reporting workspace has no report sections, the scanner's blank-post shape (empty reporttype, no tiles), instead of posting a blank report. Built so that postReport equals 165 plus the one guard line and the rest of the file equals 165 apart from the revision. With posting stubbed: empty workspace, with and without a rig, gives "Nothing to post", no confirm and no post; a surface test posts as before (same confirm, same file name); Daily Log Add to Log unaffected. Re-checked live through IIS, with 165's Rev 9 section | pass |

| 167 | 14 Oct 2026 | 7,361,060 | `3a9ca0457c29` | ✔ RECORD — the after-class queue, done now (Dan, 14 Oct). **Outbox**: a failed post is kept on the device (IndexedDB) and sent automatically on reconnect, at start-up and every 2 min; a pill and list show what waits; the assistance request is excluded (its own path). `sdPostReport` byte-identical, wrapped once. **KE-01** closed: Post Report says NOT posted / Posted, with a receipt line. **Entry 73**: Daily Notes and Lesson Learned names carry shift and equipment; re-post uses the same name. **KE-03** warning on two report types; **KE-07** placeholder; **KE-05** Post URL option removed; CBM equipment / variant switch keeps entries. Install files (manifest, `sw.js`, icons) ship beside the tool, registered only over HTTPS. With posting stubbed: queued on failure, sent on reconnect **byte-identical**; not queued for seadrill-help_; names; warnings; switch-back restores; offline copy reopens the tool with the network cut and leaves other files alone. Re-checked live through IIS | pass |
| 168 | 14 Oct 2026 | 7,361,069 | `51869c433157` | ✔ RECORD — the "waiting to send" words only when the post really was kept: if the device refuses storage the crew is told to send the saved file to the office (found checking 167 live). Tested with storage blocked; re-checked live through IIS | pass |
| 169 | 15 Oct 2026 | 7,365,124 | `94f4afed950f` | ✔ RECORD — NOV's "Usage Data at date of removal from service" table (section 8.1 of the SBOP, Gate Valve, Poslock Door and U2B Door ID documents) on the Upper SBOP, Lower SBOP, Gate Valves, Poslock Door and U2B Door CBMs: Part No., Serial No., Date in / out of Service, Wet Cycle Count, Pressure Cycles (Dan, 15 Oct). Six new `cbm_<equip>_usage_*` keys, rolling handoff entry 80. In the CBM PDF and OEM copy with dates DD/MMM/YYYY, omitted when blank; Duplicate clears it. Report table headers made readable in every report (KE-19). With posting stubbed on SSCE Equipment: shown on the five classes only; collected; survives an equipment switch; restored from file; printed; cleared on Duplicate; zero posts. Posting functions byte-identical. Re-checked live through IIS | pass |

**SSORT REV 169 is what is deployed.** Live file verified 15 October: 7,365,124 bytes,
`94f4afed950f`, identical to the `SSORT REV 169` folder. With it on the share: `sw.js`, `manifest.json`, `icon-192.png`, `icon-512.png` (served as `application/javascript`, `application/json`, `image/png`).

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

| 168 | 6 Oct 2026 | 3,342,821 | `a723b6df13b6` | ✔ RECORD — Save to File silently posted, with no rig, date or size guard and no confirm (KE-16). Reproduced on the live 167 before the fix. Verified on 168: Save to File with a blank rig saves and posts nothing; Post Report still refuses a blank rig; with Not rig-specific it posts, attributed. Exactly one of four post call sites removed | pass |

| 169 | 10 Oct 2026 | 3,345,420 | `9af1e76a986d` | ✔ RECORD — Dan, 10 Oct: photos could be dragged into SSORT's photo boxes but not WCGRRT's (the tile-reorder handlers cancelled every drop inside a tile). SSORT's window-level drop handler ported. Reproduced on 168 first (nothing placed). On 169: tile photo box, photo-grid slot (numbered Figure 1), Help Centre box and Actions Raised photo cell all take a dropped photo through the file-picker path; a PDF is refused; a narrative box still takes its own reference image. Posting path, upload and compression functions byte-identical. Re-checked on the live file through IIS | pass |

| 170 | 14 Oct 2026 | 3,353,082 | `79d926fc47f3` | ✔ RECORD — the same outbox as SSORT 167 around WCGRRT's `sdPostReport(json, filename)` (byte-identical, wrapped once); fallback messages say NOT posted and waiting; badge date current; install files `wcgrrt-*` scoped to the tool's own file (the share also serves the dashboard). With posting stubbed: a real Post Report failed, queued, sent on reconnect byte-identical; offline copy reopens the tool and does not touch other pages. Re-checked live through IIS | pass |
| 171 | 14 Oct 2026 | 3,353,244 | `3fe4d84a7353` | ✔ RECORD — as SSORT 168: "waiting to send" only when the post was kept. Re-checked live through IIS | pass |
| 172 | 15 Oct 2026 | 3,372,569 | `b6f086423cca` | ✔ RECORD — the Planning Report becomes the 12-hourly Daily Summary Report (SACRED T1–T10, Dan 15 Oct): the rules move into one page-free block (PLAN-RULES) that WCGRRT, SACRED's print template and Argo Navis's planning-rules.js share; full report print (rig people, data date-time 0600/1800, BOP %, variance and float in hours, quality / reliability, lessons learned, NEW break-ins); new additive keys (rolling handoff entry 83). With posting stubbed on SSCE Equipment: ERT import identical to 171 on two real ERTs (lists, milestones, critical path, variance), maintenance day identical, BOP % = P6's own branch % (85.07% West Vela), save / restore, template HTML byte-identical to WCGRRT's print for the same record; posting path byte-identical; zero posts. PDF not printable on this workstation (headless print unavailable). Re-checked live through IIS | pass |

**WCGRRT REV 172 is what is deployed.** Live file verified 15 October: 3,372,569 bytes,
`b6f086423cca`, identical to the `WCGRRT REV 172` folder. With it on the share: `wcgrrt-sw.js`, `wcgrrt-manifest.json`, `wcgrrt-icon-192.png`, `wcgrrt-icon-512.png`.

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
