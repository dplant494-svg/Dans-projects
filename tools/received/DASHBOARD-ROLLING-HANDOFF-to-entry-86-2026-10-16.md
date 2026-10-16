# Rolling handoff to the dashboard session

**From:** the reporting-tools session (WCGRRT / SSORT)
**Maintained by:** Dan Plant
**Purpose:** one document, added to as changes ship, so the dashboard is updated
**once** rather than chased per change.

**How to use this:** read the change log below. Anything marked **NEEDS ACTION** wants
something from the dashboard side. Anything marked **FYI** is a payload or behaviour
change you should know about but which needs no work. Newest entries at the top.

**Standing rules, unchanged throughout:** transport must not be modified · filenames
are never load-bearing · `meta.asset` is the rig identity contract.

---

## Open items summary — read this first

| # | Change | Rev | Status |
|---|---|---|---|
| 86 | **Workshop pack W1–W10 answered (16 Oct): builds FROZEN to Fri 23 Oct at WCGRRT 174 / SSORT 169; pack, shots, samples, deck updated; Day 2 hold-point half page. W10.1: SSORT does not route Post to OEM on SSCE Equipment — your OEM flow must, or report 3 drops Post to OEM** | WCGRRT 174 · SSORT 169 · frozen | **NEEDS ACTION** - 86.2 confirm the OEM flow and other post-keyed flows for SSCE Equipment before Monday |
| 85 | **WCGRRT 174 DEPLOYED 15 Oct: the report time is the rig's (any HH:MM, default now; quick 0600/0700/1800/1900), "twice daily". Same keys; new `prevDataDateTime`; "since last report" and NEW break-ins count from the previous report's time. Template + rules module re-cut** | WCGRRT 174 · **DEPLOYED 15 Oct** | **NEEDS ACTION** - 85.2 one new key; swap in the re-cut template |
| 84 | **SACRED accepted T1–T10 (template prints 2 pages Letter; scanner v3.04 + "Daily Summary Report" flow live). Dan's 83.4 decisions: cycle in the posted name YES, order date_rig_TYPE_BOP KEPT. WCGRRT 173 DEPLOYED 15 Oct: planning posts named `<reportName>.json`** | WCGRRT 173 · **DEPLOYED 15 Oct** | **FYI** - closes 83.4 |
| 83 | **WCGRRT 172 DEPLOYED 15 Oct: the Planning Report is the 12-hourly Daily Summary Report (your T1-T10). Template from the posted JSON, rules module for Argo Navis, sample post. New keys announced here. Two filename questions for Dan** | WCGRRT 172 | **NEEDS ACTION** - 83.3 keys; 83.4 Dan's filename decision before the rig posts twice a day |
| 82 | **Reply to your 15 Oct Daily Summary Report handoff: Brent's PPDSR030918 report is a Word document, not a WCGRRT print. WCGRRT's own Planning Report print view attached; every field rule from the code; what WCGRRT does not have** | WCGRRT 171 (read only) · no change | **NEEDS ACTION** - get Brent's Word template via Dan; the open questions for Brent/Lee in 82 |
| 81 | **PLAN (Dan, 15 Oct): the entry 80 usage table to be filled from PLATO via your PowerShell scan, from a CSV whose location Dan will give later — as you already do for other tools. Nothing built yet** | future SSORT · your scanner | **NEEDS ACTION** - 81.3: put it in the plan; propose the published shape; wait on Dan's CSV location |
| 80 | **SSORT 169 DEPLOYED 15 Oct: NOV's "Usage Data at date of removal from service" table on the Upper SBOP, Lower SBOP, Gate Valves, Poslock Door and U2B Door CBMs. 6 new `cbm_<equip>_usage_*` keys. Report table headers made readable in every SSORT report** | SSORT 169 · **DEPLOYED 15 Oct** | **NEEDS ACTION** - 80.2 the new keys, for the report row, the viewer and the export |
| 79 | **SSORT 168 + WCGRRT 171 DEPLOYED 14 Oct: outbox (failed posts wait on the device and send themselves), clear posted/not-posted messages (KE-01), Daily Notes / Lesson Learned names carry shift + equipment, KE-03/05/07 closed, CBM switch-back fix, tablet install files (dormant until HTTPS)** | SSORT 168 · WCGRRT 171 · **DEPLOYED 14 Oct** | **NEEDS ACTION** - 79.2 new daily-log name shape; 79.3 posts can arrive late |
| 78 | **SSORT 166 DEPLOYED 14 Oct: Post Report says "Nothing to post" when the Rig Reporting workspace has no sections (your blank-post shape). Class build** | SSORT 166 · **DEPLOYED 14 Oct** | **FYI** - closes ask 2 / 77.3 |
| 77 | **Blank posts closed (74.2): the rigs follow the server build (Saturn blank posts stamped 148, 149, 151, 153, 154, 160, 163 as each was live); last one 13 Oct 13:03Z, 7 min before 164; since then Saturn on 164/165, Tellus on 164. No rollout needed. Guard queued for after class** | - | **CLOSED** - 77.3 guard after 20 Oct (Dan go, posting path) |
| 76 | **SSORT 165 DEPLOYED 14 Oct: FRM-00-0168 Rev 9 additions on the pre-deployment checklist: ROV panel valve orientation/line-up (tick + captioned photos), riser running/pulling checklist, drops, seals, maintenance by 3rd party/CBM/Seadrill. 10 new pdc_r9_* keys** | SSORT 165 · **DEPLOYED 14 Oct** | **NEEDS ACTION** - 76.2: show the keys; same lines to Lee for Argo Navis |
| 75 | **For the SACRED plan: tools offline on iPads/Android tablets (install + outbox). Waiting on ISIT for HTTPS** | - | **NEEDS ACTION** - add as a plan item; is the 18 Oct server move this server? |
| 74 | **SSORT 164 DEPLOYED 13 Oct: the Daily Log month PDF now lists the month (it listed the cleared entry form); removed the old end-of-trip section whose Post Report posted blank untyped reports. No keys change** | SSORT 164 · **DEPLOYED 13 Oct** | **FYI** — 74.2: look for blank seadrill-report_<rig>_<date>.json posts (reporttype empty, no tiles) |
| 73 | **Daily Notes entries in the same date and shift share one file name, so the second replaces the first in PostedReports (the month post still carries both). Found writing the crew how-to; nothing changed (freeze)** | — | **FYI** — 73.2: do you see it in posted data? Fix after 20 Oct |
| 72 | **Day 1 training pack moved to the class builds, WCGRRT 169 / SSORT 163 (Dan, 13 Oct). New script steps, 9 screenshots, samples rebuilt; three errors the 159 pack had are fixed (wrong SSORT button name, pre-158 file names, deck drawing badly in PowerPoint)** | — | **NEEDS ACTION** — rebuild the trainee workbook from the 13 Oct zip; 72.3 badge-date wording logged for after the class |
| 71 | **The resolved pre-deployment matrix reviewed; one pack to Lee (job plans, matrix, SSORT link, branding)** | — | **FYI** — 71.3: Dan answered Q6 **yes** and Lee's title (Head of Well Control Equipment). 71.1: the resolved handoff miscounts (27 commented, 26 as proposed); optional sign-offs must not block "ready to sign". 71.2: slot labels agreed, after the class and Lee's designation format |
| 70 | **Job plan checklists for DL-1 (`Argo-Navis-Job-Plan-Checklists.html`, JPC REV 4: also the job plan pop-up inside Argo Navis, 70.5): your 12 Oct eDocs / PDF / sync / percent answers built. Sync on at 15 / 25 MB, eDocs title block and footer on the PDF, `meta` block for the scanner. Handoff to Lee final** | JPC REV 4 (not SSORT / WCGRRT) | **FYI** — 70.2: new record keys for your next scanner version. 70.3: the plan-folder rule is 62.5(3), not 67; entry 67 is in this file |
| 69 | **Dan: sign-off is typed names for now; the pre-deployment call per directive reviews the checklist, now seen beforehand by all. Matrix proposal (Excel) for review — dashboard first, then Lee** | — | **NEEDS ACTION** — fill in the Dashboard columns of PDC-MATRIX-PROPOSAL-for-Dan-and-Lee.xlsx |
| 68 | **Dan confirms 67.1; the matrix populates a pre-deployment checklist everyone signs before deployment, like a flight checklist. Design points for accountability: populated not typed, no open lines, snapshot + hash, re-sign on change, signed-in identity, one "go" record** | — | 68.2.6 identity route **deferred by Dan** (entry 69: typed names + the pre-deployment call per directive). Rest of 68.2 stands |
| 67 | **Reply to the pre-deployment alignment check: your reading 1–4 is right — the checklist's primary moves to DL-1, tests stay in SSORT; entry 62.1 overstated it (corrected). What DL-1 keeps identical; the matrix** | — | 67.1 **CONFIRMED by Dan, 12 Oct** (entry 68). DL-1: one stack per checklist, `slot` on photos? |
| 66 | **SSORT 163 DEPLOYED (ships 162): Maximo's own SFI group names used; the SFI workbook needs one home and a refresh rhythm** | SSORT 163 · **DEPLOYED 12 Oct** | **FYI** — 66.2 for Dan: where the workbook lives, how often |
| 65 | **SSORT 163: the assistance request picks the equipment by SFI code (28,916 codes, 14 rigs, from the Maximo list). Keys `sfiCode`, `sfiDescription`, `sfiGroup`, `maximoAssetNo`** | SSORT 163 (includes 162) · **DEPLOYED 12 Oct** | **NEEDS ACTION** — the four keys; Dan to confirm the group names |
| 64 | **SSORT 162 built: plan picker + `meta.planid` (stage 1), 🔗 Link to plan on tests and the checklist + `seadrill-planlink_*` records (stage 2). Keys announced** | SSORT 162 · **DEPLOYED 12 Oct (in 163)** | **NEEDS ACTION** — 64.4: confirm no flow mistakes a `seadrill-planlink_` file for a report |
| 63 | **Reply to the 61/62 answers: plan structure agreed (plans-open.json defined, one plan per stack, stable plan id); SSORT stage 1 ready to build on Dan's word** | — | **FYI** |
| 62 | **Dan's direction on DL-1: checklists stay in SSORT, the plan links to them. "Link to plan" button (tests, pre-deployment, daily logs) announced, held until the plan structure is agreed** | — | **FYI** to the dashboard and DL-1; three questions (62.5), no rush. The 61 appendix is reference / possible Fabric data dictionary |
| 61 | **Reply to the 12 Oct DL-1 asks: the pre-deployment checklist and every test, read off the live tool (PDC-HANDOFF-DL1.zip); the plan reference proposed — meta.planId yes, file name no (Dan to decide)** | — | **NEEDS ACTION** — 61.1 findings; 61.3 three questions on plans-open.json |
| 60 | **The Technical Assistance Request is built in SSORT 161 (Requests → Technical Assistance Request). Keys announced; eight questions before it goes live** | SSORT 161 · **DEPLOYED 11 Oct** | 60.4 **answered 11 Oct**; 20 MB total cap (60.6); **the filled-in FRM-00-0169 rides as the first attachment, no flow change** (60.7) — **all confirmed by the dashboard**. Dan runs 60.5, then deploy |
| 59 | **Reply to 11 Oct: the assistance request is NOT in either tool — stage 1 was never built. The ❓ Help / Feedback tab is NOT it** | — | **FYI** — Dan to decide before or after the class (59.4) |
| 58 | **WCGRRT 169: drag-and-drop onto photo boxes, as SSORT has** | WCGRRT 169 · **DEPLOYED 10 Oct** | **FYI** — no keys, no payload change |
| 57 | **54.3 answered: Brad's Upper SBOP copy is complete (9,314,138 bytes, 23 photos intact). The short file was cut in transfer, not by the tool** | — | **DONE 9 Oct** — restored to PostedReports on Dan's instruction; confirm on the dashboard after the next scan |
| 56 | **The freeze moves to 15 October; SSORT 160 is live; the training pack stays on 159 until Dan says** | SSORT 160 · **DEPLOYED 9 Oct** | **FYI** — update the ORR freeze row and frozen builds |
| 55 | **SSORT 160: model and serial are per unit and no longer carried over; C&K Stabs gains Stab Identification — 12 new `ckstab_*` keys** | SSORT 160 · **DEPLOYED 9 Oct** | **NEEDS ACTION** — 55.2: show the 12 keys on the row, in the viewer and in the export. No file-name change |
| 54 | **Reply to your 8 Oct note: SSORT 159 is live; some restored names differ under it; the truncated Upper SBOP is unlikely to be the save dialog; the C&K stab asset field waits for Dan** | SSORT 159 · **DEPLOYED 9 Oct** | **NEEDS ACTION** — 54.2: check the seven restored names against 159. 54.3: four facts about the Upper SBOP file. 54.4/54.5: Dan to decide |
| 53 | **Reply to 52: the gate-valve collision is real on the live 158, and 158 never read the serial you are recovering by. SSORT 159 names the unit by serial, else model** | SSORT 159 · **DEPLOYED 9 Oct** | **NEEDS ACTION** — 53.3: the 9 Oct recovery must name by the 159 rule if 159 is live, and never by `rcpt_serial` under 158. 53.5: four ORR workbook corrections |
| 51 | **Reply to 50: CBM overwrite fixed by naming what was inspected (not a timestamp — see why), and 50.2 was not the VSR path: WCGRRT’s Save to File silently posts** | SSORT 158 · WCGRRT 168 · **DEPLOYED 6 Oct** | **FYI** — 51.2: the OEM `sourceFile` was always empty. 51.5: watch for rigs going quiet after 168 |
| 49 | **West Auriga’s daily checks sheet was never missing — the panel was built before the rig was picked and never rebuilt** | SSORT 157 · **DEPLOYED 5 Oct** | **FYI** — no key changes. 49.4: Auriga rounds posted before today carry Capella’s keys |
| 48 | **Build freeze: 12 October — the tools stop moving until after the class** | — | **FYI** — no new keys between 12 and 20 Oct unless a rig is losing work. SSORT 156 and WCGRRT 167 are what you build against |
| 47 | **Every Testing and Intrusive task in the schedule is now graded pass/fail — 211 new `_gr` keys** | SSORT 156 | **NEEDS ACTION** — 47.3: most graded tasks are now a pass or a fail, not a condition. A fleet average across tasks no longer means anything |
| 46 | **Two new NOV documents — a new equipment class, the Diverter graded at last, and a grade row that can now offer fewer than five buttons** | SSORT 155 | **NEEDS ACTION** — 46.4: `cbmGrades` will carry tasks that can never hold a 2 or a 4. A distribution or average across tasks needs to expect that |
| 45 | **A rig reported the EHBS timer delay never filling in — and underneath it, restoring a SSORT surface test was DESTROYING the record** | WCGRRT 167 · SSORT 154 · **DEPLOYED 1 Oct** | **NEEDS ACTION** — 45.3: please find how many posted reports lost their `soak` block or carry an empty `ehbs_tim_delay`. We cannot see it from here |
| 44 | **`OEM_SEND_FILES` is on — the crew’s test records now reach NOV as real email attachments** | SSORT 153 · DEPLOYED 30 Sep | **FYI** — your Part D3 ask, done the same day. Superseded on the rigs by 154 (entry 45); the attachment behaviour is unchanged |
| 43 | **SSORT 152 built to your entry 42 answers — `cbmatt` ships exactly as announced, and Post to OEM now posts the dashboard copy first** | SSORT 152 · DEPLOYED 30 Sep | **CLOSED 30 Sep** — nothing owed; 43.2 accepted as built, do not move the threshold. Superseded on the rigs by 153 (entry 44) |
| 42 | **CBM gains file attachments for test records, and Post to OEM will also post to the dashboard** | SSORT 152 | **CLOSED 30 Sep** — all three answered: 40 MB holds and the input is controlled (8 warn / 20 refuse / 15 total), a same-day repost is an update, Part D3 can take `files[]`. Built in entry 43 |
| 41 | **Riser Adapter could not be photographed or graded at all — 22 new keys, and it closes the discrepancy entry 18.2 left open** | SSORT 150 · 151 | **FYI** — 22 additive keys in families you already read. 18.2’s `CBM_GRADED` explanation was wrong: the class was covered on no path at all |
| 40 | **`calcData` now carries the per-cavity verdict and the rows behind it — plus three corrections to the 27 Sep summary** | SSORT 150 | **FYI** — your entry 36 ask, built. Two items I wrongly listed as open were already decided |
| 39 | **Reference photo captions are now editable in the tool — still not posted, still no key** | SSORT 148 | **CLOSED 28 Sep** — rule recorded: a reference-photo grade is never a `cbmGrades[]` row |
| 38 | **SSORT 148 closed out — nine more keys stop posting, a new `meta.asset` value, and West Vela’s EDS was stamped with a revision it did not contain** | SSORT 148 | **CLOSED 28 Sep** — `SSCE Equipment` was already a non-rig; two rollups tightened. Nine keys: nothing to do |
| 37 | **WCGRRT narratives can now contain images — no new key, but the narrative HTML changes shape** | WCGRRT 166 | **CLOSED 28 Sep** — `<img>` was never stripped; the `×` is removed in renderer and digest (v2.70) |
| 36 | **The Ram Cavity checker was never a calculator — it is a dimensional inspection record, and nothing it produced has ever been posted** | SSORT 148 | **CLOSED 28 Sep** — `calcData` renders. Their ask for per-cavity `status`/`checks[]` is built in entry 40 |
| 35 | **Dan reviewed all 52 open tasks — criteria now on 93 of 104, and nine `_gr` keys stop being posted** | SSORT 148 | **CLOSED 28 Sep** — items discovered from `_gr`/`_cm`/`_ph`, so a cleaning task stays on the heatmap with no grade |
| 34 | **Every NOV document reference audited against its own title block — 13 of 16 exact, one fixed, and the Ram Block entry was an outlier** | SSORT 148 | **FYI** — no keys change. Display and print only |
| 33 | **A seventh ram block class (`Ram Block::Fixed`), a wrong NOV document number on every ram block report, and the OEM button is held** | SSORT 148 | **PART-CLOSED 28 Sep** — the seven ram block classes render (v2.64). **Post to OEM stays held** until flow Part D is built |
| 32 | **Criteria coverage 41 of 101 — and a method we proposed in the review sheet was wrong, withdrawn here** | SSORT 148 | **FYI** — no keys change. More NOV wording reaches you through `cbmlabels`; the rest keeps the universal scale |
| 31 | **Post to OEM is built — but SSORT sends `html` and your flow test read `pdf`. SSORT has no PDF renderer** | SSORT 148 | **CLOSED 24 Sep** — answered: the flow reads `pdf` only and falls back to a 1-byte file. Button held; wording changed per 31.5 |
| 30 | **Ram Block split into its six types — and the `n:` key map you asked for is EMPTY, by evidence: no id moved** | SSORT 148 | **CLOSED 24 Sep** — empty `n:` accepted, not needed. Scanner now counts generic `Ram Block` posts on every run |
| 29 | **SSORT goes native too — the last iframe in either tool is gone, and its acoustic / EHBS / drawdown keys hash IDENTICAL to WCGRRT’s** | SSORT 148 | **CLOSED 24 Sep** — SSORT posts reach the same three renderers unchanged |
| 28 | **`cbmlabels` — NOV’s task wording beside every posted CBM key. Your 24.2 ask, built** | SSORT 148 | **CLOSED 24 Sep** — `cbmlabels` built (v2.64), and it exposed two live defects on their side, both fixed |
| 27 | **Conditional triggers now surface on a grade of 4 or 5 — as a prompt, not a ruling** | SSORT 148 | **CLOSED 23 Sep** — they agree: a computed judgement is not displayed as a recorded fact either. Nothing built, nothing owed |
| 26 | **NOV’s grade criteria are now on the LIVE path — 9 of 65 migrated, with per-item document/page provenance** | SSORT 148 | **CLOSED 23 Sep** — acknowledged. Ram Block split needs an `n:` section in `cbm-key-map.json` **before** that build ships |
| 25 | **`CBM_GRADED` is dead code in the deployed build — and there are TWO CBM key namespaces, positional and id-based** | SSORT 147 · 148 | **CLOSED 23 Sep** — decision (a), with us. Replay check built (v2.63): a `SSORT`-stamped post with positional keys is listed as a replay |
| 24 | **SSORT finally posts `meta.rev` — and all 47 stripped CBM task descriptions are back, with no key changing meaning** | SSORT 148 | **CLOSED 23 Sep** — `meta.rev` read (v2.63). Their one ask, `cbmlabels`, is entry 28 |
| 23 | **EHBS and Drawdown are native too: the `ehbs_*` and `dd_*` key lists. WCGRRT now contains no iframe at all** | WCGRRT 166 | **CLOSED 23 Sep** — EHBS and drawdown renderers built; posted verdicts shown, never recomputed |
| 22 | **The `acst_*` key list and `soakLabels` — the announcement you have been waiting for. Build the acoustic renderer now** | WCGRRT 165 | **CLOSED 23 Sep** — acoustic renderer built; name settled as `soaklabels` |
| 21 | **`cbm-key-map.json` delivered — plus a correction to entry 19 and a disagreement about Grade 3** | SSORT 147 | **CLOSED 23 Sep** — decided with us: 1–2 acceptable, **3 monitor**, 4–5 fail. Legend and contract corrected |
| 20 | **Where we are and what is coming — the whole picture in one place.** Nothing has shipped yet; two revisions are being built, and only one of them changes the payload | WCGRRT 165 · SSORT 148 | **FYI** — one thing to wait for (the `acst_*` key list) and one thing to expect (more CBM text, no new keys) |
| 19 | **The positional-key failure you were warned about has already happened: 38 of 65 posted CBM grade keys no longer resolve to the task that was graded** | SSORT REV 80 → 147 | **CLOSED 22 Sep** — scanner v2.61 keeps pre-19-Jul positional rows apart; `cbm-key-map.json` re-points the known ones |
| 17 | **SSORT carries the same three iframe test blobs as WCGRRT — acoustic is not a WCGRRT-only story; and the duplicate sweep you asked for is done** | WCGRRT 164 · SSORT 147 | **CLOSED 22 Sep** — answered NIL: no posted report from either tool carried those keys |
| 18 | **The CBM grading criteria were never missing — NOV states one universal scale in every component document.** No grade buttons are being removed after all | SSORT 147 → 148 | **FYI** — nothing to build. Entry 18.3's warning about your `cbmGrades` table is **withdrawn** in 18.5 |
| 16 | **Your second review answered: six of your seven "missing" items are shipped, and nothing was graded against the corrupted criteria** | WCGRRT 164 · SSORT 147 | **FYI** — nothing to build. One item was genuinely owed, and the CBM question you asked is now closed from Brad's files |
| 15 | **Your two questions answered — and do NOT build the `acst_*` soak table yet** | WCGRRT REV 164 | **CLOSED 21 Sep** — answered across the reply; acoustic renderer held until the key list, which then arrived |
| 11 | **Daily reports have been OVERWRITING each other** — and you are rendering everything except the surface tests | WCGRRT REV 160 → 161 | **CLOSED 16 Sep** — all three asks built (scanner v2.50); the overwrite recovered from Brad’s own saves |
| 10 | **Pre-deployment checklist: mandatory packer attestation + 2× cavity photographs per BOP** — new keys, and a posted PDC is now guaranteed complete | SSORT REV 146 | **CLOSED 16 Sep** — `pdcData` rendered and given the 40 MB ceiling (v2.50) |
| 9 | **CBM ceiling mirrored in `sdSizeOk` — but at 40 MB, not your 30** | SSORT REV 146 | **CLOSED 15 Sep** — decided: CBM and PDC ceiling is **40 MB** (scanner v2.48), matching SSORT |
| 8 | **Defect in our REV 145 potable-water items: two comment inputs on one key** — a typed ✗ reason is discarded | SSORT REV 147 (pending) | **FYI** — nothing to build. Your rule is unaffected; answer to your `yn` question inside |
| 7 | **Two new readings on every daily-check round, on all three rig specs** — and a bare tick on them is meaningful | SSORT REV 145 | ✅ **CLOSED** — built your side 14 Sep, rule inverted as asked, `yn` literals confirmed in entry 8 |
| 6 | **The nine oversize files, diagnosed one by one** — two real defects fixed, and **CBM reports cannot meet 10 MB** | WCGRRT REV 160 · SSORT REV 144 | ✅ **CLOSED** — decided 9 Sep: CBM gets its own 30 MB ceiling, nothing degraded, photos untouched (scanner v2.41) |
| 5 | **Rig identity enforced at source, and a 10 MB warning** — the debt you flagged | SSORT REV 143 · WCGRRT REV 159 | **FYI** — nothing to build. The Unattributed bucket should now stop filling |
| 4 | Compliance report gains **action photos** and a **photo dump** | WCGRRT REV 158 | ✅ **CLOSED** — done your side, scanner v2.40 |
| 3 | **A real daily report showed personnel but no technical content** | WCGRRT REV 157 | ✅ **CLOSED** — landed at exactly 22,012,925 bytes, parses, `equipEntries` = 4. Not truncated. Content is behind **View full report** |
| 2 | Compliance Checklist now carries **Actions Raised During Visit** | WCGRRT REV 156 | ✅ **CLOSED** — fleet open-actions view built |
| 1 | **Marine Integrity retired** from Well Control reporting | WCGRRT REV 155 | ✅ **CLOSED** — read-only archive, nothing deleted |

*Entries 1–4 were answered in full by scanner v2.40 on 9 September 2026. Entry 5 is
our side of that exchange: the one piece of work the reply said was still owed by us.
Entry 6 answers the v2.40 addendum — the nine files the first scan found over 10 MB.
Entries 8 and 9 are ours: both were found by reading our own code to answer the single
assumption your 14 September reply asked us to confirm.*

---

## Entry 86 — Workshop pack, W1–W10 answered (16 Oct). Builds frozen to Friday 23 October. One flow question before Monday

**Rev:** none; nothing deployed. Replies to your *"the workshop pack, final for Monday 19 October"* (16 Oct).

**The full reply is `TRAINING-Day1-Pack/10-REPLY-WORKSHOP-PACK-2026-10-16.md`.** The pack, updated, is in `TRAINING-Day1-Pack/`
and `WCE-Training-Day1-Pack.zip`. The 13 Oct zip is kept as `…-ON-SSORT166-WCGRRT169-superseded.zip`.

Status: **NEEDS ACTION** — 86.2.

### 86.1 — What is done

- **W1:** **frozen at WCGRRT 174 and SSORT 169** (hashes in the reply). **Nothing deploys before Friday 23 October unless Dan
  asks.** 173 and 174 deployed after your list; both are Planning mode only.
- **W2:** every script step that moved, old → new, is in `09-WHATS-NEW-SSORT-169-WCGRRT-174.md`. The script, the exercise sheet
  and the Q&A are edited to match:
  - steps 38, 41, 42, **42a**, **49c**, 64, 70, 73, **78**;
  - the SSORT date box is **Log Date**, which the old sheet had wrong.
- **W3:** **report 3 doesn't need the usage table**, because Riser Adapter doesn't carry it. The trainer demonstrates it on
  Gate Valves, and there are training values for 00–10. The dates and serials were tested on the frozen builds, and all 40 names
  are distinct.
- **W4:** `screenshots-169/` has 1, 15, 17 retaken and 18c, 23d, 28a, 28b, 29, 30, 31, 32 new (outbox waiting and sent; usage
  table).
- **W5:** samples rebuilt; nothing changed but `meta.rev`.
- **W6:** the deck is still 21 slides. Slides 3, 16, 19 (+1 row) and 20 changed, rendered and checked in PowerPoint.
- **W7:** the KE list, with which a delegate can hit on Monday: KE-06, KE-08 and KE-13.
- **W8:** `11-DAY2-HOLD-POINT-DAILY-SUMMARY-REPORT.md`.
- **W9:** laptop list: nothing to install. Normal window, not InPrivate; the server links; badge check at 07:45; downloads and
  Print to PDF; photos and the test PDF copied at 07:45.

### 86.2 — What we need from you before Monday (W10)

1. **Post to OEM on SSCE Equipment.**
   - **The tool doesn't route it as a test.** It posts the normal `seadrill-oem_SSCE-Equipment_…_cbm.json`, and your OEM flow
     decides who receives it.
   - **Please confirm one of these:**
     - **(a)** the flow already sends SSCE Equipment to the office only; **or**
     - **(b)** you add that before Monday; **or**
     - **(c)** report 3 uses 📤 Post Report only, and the trainer shows Post to OEM once.

     Otherwise ten delegates send NOV ten test emails. **If nothing is confirmed by Saturday, we recommend (c)** and will make
     the one-line change.
2. **Confirm no other flow keyed on posted reports emails anyone for SSCE Equipment.** The Technical Assistance Request (tool:
   office only) and the Daily Summary Report (yours: Dan only) are already covered.
3. **The clean-up works if nothing is left waiting on a delegate laptop.**
   - **Why:** a queued post would send itself later.
   - **How:** new script step 78 has every laptop checked for the orange 📤 button before anyone leaves.
   - **What re-sends:** only failed posts are kept, and a re-send is byte-for-byte the same file, routed the same, just later.

---

## Entry 85 — WCGRRT 174 DEPLOYED (15 Oct, night): the report time is the rig's, not a fixed 0600 / 1800 cut-off

**Rev: WCGRRT 173 → 174, deployed 15 October, night.**

- **Before the copy:** the live file on `sacred` was hash-checked as 173.
- **After the copy:** re-hashed, then smoke-tested through IIS with posting blocked (badge REV 174; a 19:30 report posts as
  `…_Report_1930.json`; nothing posted).

| Build | sha256 | Bytes |
|---|---|---|
| WCGRRT 174 | `b3b7e87773d02ebfc1f9c2421dd1fdcaa570f09fcbf1d5620a01646fc59a9eaa` | 3,376,514 |

Replies to your "the report time is the rig's, not a fixed 0600 / 1800 cut-off" (15 Oct, night). Dan: *"0600 and 1800 aren't
actually cut-offs … twice a day really."*

The files are in `REPLY-REPORT-TIME-2026-10-15/` and its `.zip`:

- the **re-cut template and `planning-rules.js`**;
- the updated spec;
- a 174 sample post;
- screenshots.

Status: **NEEDS ACTION.** One new key (85.2), and **use the re-cut template** (85.3).

### 85.1 — Your five asks

| # | Ask | Status |
|---|---|---|
| 1 | "Data Cut-off" becomes "Report time" | **Done.** "Report Time (rig local)": any HH:MM, **default the device clock now**, quick buttons **0600 / 0700 / 1800 / 1900**; any typed time is accepted |
| 2 | Same keys, any time | **Done.** `meta.cycle` / `planningData.cycle` = `HHMM` (`"0700"`, `"1930"`). `meta.dataDateTime` is at that time. `meta.reportName` and the posted name end `_HHMM`, normalised (`7:00`, `07:00` and `0700` all give `0700`; never a colon in a file name) |
| 3 | "Since last report" from the previous report's time | **Done.** Details below the table |
| 4 | Print "DATA DATE 2026-Oct-15 @1900 Hrs" | **Done.** e.g. `2026-Oct-15 @1930 Hrs` |
| 5 | "12-hourly" → "twice daily" | **Done** in everything the rig reads. The form says "Reports go out twice daily, after each handover. Any time can be entered." No 12-hour wording is left on the form or the print |

**Ask 3, "since last report":**

- **New key `prevDataDateTime`** (85.2).
- **How it is set:** when the report moves on (a date and time **6 hours or more** after the report on screen), the report on screen
  becomes the previous report. Small corrections (07:00 → 07:15) don't move it, and the rig can set it by hand ("Previous Report").
- **NEW break-ins** are those added after the previous report's time and up to this report's time. With no previous report known,
  the 12 hours before are used.
- **The ERT import** treats the report still on screen as the last report when choosing which tab to compare. This was already
  per-report tabs; it no longer depends on who printed on that PC.
- **The print's legend** names the previous report, e.g. "NEW = added since the previous report (2026-Oct-15 @0715 Hrs)".

### 85.2 — The new key (additive)

| Where | Key | Value |
|---|---|---|
| `planningData` and `meta` | `prevDataDateTime` | ISO with offset, e.g. `"2026-10-15T07:15:00-03:00"`; `""` until a report has moved on |

**Changed values, not new keys:**

- `cycle` now holds any `HHMM`, not just `0600` / `1800`.
- `meta.reportName` and the posted name end with it.

**Unchanged:**

- **No other key changes.**
- **Byte-identical to 173:** `buildReportPayload` (so the 173 file-name rule is unchanged), `collectPlanningData`, the transport,
  the outbox, `postReport`, the ERT reader and `printPlanning`.

### 85.3 — The template and module are re-cut: please swap them in

- **What changed:** the PLAN-RULES block (report time, NEW from the previous report, the legend). So
  `planning-report-template.html` and `planning-rules.js` are re-cut from the 174 build.
- **The 172 template still renders 174 posts,** but it marks NEW on the old 12-hour window and doesn't name the previous report.
- **The fill is unchanged:** the token `/*RECORD_JSON*/null`, escape `</` as `<\/`, then wait for `body[data-ready="1"]`.
- **Tested:** the 174 template gives **byte-identical HTML** to WCGRRT's own print of the same record.
- **For Lee:** `planning-rules.js` for Argo Navis is re-cut too. It adds `planNormTime`; `planIsNewSince` now takes the previous
  report's time; `PLANNING-REPORT-RULES-SPEC.md` §2.2 and §2.2a cover this.

### 85.4 — Tested (SSCE Equipment, nothing posted)

- **The ERT import** is identical in 173 and 174 on two real ERTs.
- **The default time** is the clock now (17:02 at the test).
- **A run of reports:**
  - 07:00 posts as `…_Report_0700.json`;
  - corrected to 07:15, no roll;
  - typed 19:30 posts as `…_Report_1930.json`, with previous = 07:15;
  - next day 07:00 gives `20261016_…_Report_0700`, with previous = 19:30.
- **NEW:** a break-in added at 08:00 is NEW in the 19:30 report; one added the evening before is not.
- **The template HTML equals WCGRRT's print.**

---

## Entry 84 — Your reply to 83 logged; Dan's two file-name decisions; WCGRRT 173 DEPLOYED (15 Oct, night): planning posts carry the cycle

**Rev: WCGRRT 172 → 173, deployed 15 October, night.**

- **Before the copy:** the live file on `sacred` was hash-checked as 172.
- **After the copy:** re-hashed, then smoke-tested through IIS with posting blocked (badge REV 173; a 0600 planning post is named
  `…_Report_0600.json`; nothing posted).

| Build | sha256 | Bytes |
|---|---|---|
| WCGRRT 173 | `114d1497139437cfb2a582ae3a79340a5744203237bec91226652d202fd24644` | 3,372,612 |

Status: **FYI.** Closes 83.4.

### 84.1 — Your reply (15 Oct, night), logged as asked

- **T1 to T10 accepted.** The template prints on your headless path as our screenshot showed: **2 pages, Letter**. You add only
  the margin footer: page x of y, source file and SHA-256.
- **Scanner v3.04** prints every planning report that carries `meta.cycle` to `Digests\daily-reports\<Rig>\<reportName>.pdf`.
  Posts without a cycle (anything before 172) are never printed or sent.
- **The flow "Daily Summary Report"** emails the PDF:
  - **To:** the rig's RM, ARM, SSS, TSL, DSL, ESV and MPD, plus the Planning table's To rows.
  - **Cc:** the All TSC WCE Managers, Superintendents and Planners list.
  - **Test posts** (SSCE Equipment, dry run) go to Dan only.
- **WCGRRT keeps running as it is.** Nothing is retired.

### 84.2 — Dan's decisions on 83.4

1. **The cycle goes in the posted file name: YES.** This is Dan's say-so for this posting-name change only.
2. **The order stays WCGRRT's,** `date_rig_TYPE_BOP` (e.g. `20261015_WPO_TMP_BOP1`).

### 84.3 — What 173 changes: one expression

- **A Planning post is now named `meta.reportName + ".json"`**, so it ends with the cycle:

  | Cut-off | 172 posted as | 173 posts as |
  |---|---|---|
  | 0600 | `20261015_SSCE_TMP_BOP1_Report.json` | `20261015_SSCE_TMP_BOP1_Report_0600.json` |
  | 1800 | `20261015_SSCE_TMP_BOP1_Report.json` (overwrote the 0600) | `20261015_SSCE_TMP_BOP1_Report_1800.json` |
  | no cycle | `20261015_SSCE_TMP_BOP1_Report.json` | the same, unchanged |

- **The file name and `meta.reportName` now always match**, and so does your PDF name.
- **Nothing else changes.**
  - Every other report's name is unchanged; the daily report name was tested identical to 172.
  - The 173 file is 172 plus the revision number and this one expression, checked character for character.
  - The transport, the outbox, `postReport`, the PLAN-RULES block and `planning-report-template.html` are byte-identical.
  - **There are no new keys.**
- **A BWM week suffix still applies after it, as before.** If a workspace also holds a BWM Weekly Planning tile, `_Wk<n>` is
  appended (`…_Report_0600_Wk42.json`). That has always been so for planning posts.

**For you:**

- **Planning posts from 15 Oct night onward** have the cycle in the file name.
- **172 posts from earlier today** have it in `meta.reportName` but not in the file name. Your scanner keys on `meta.cycle` and
  names the PDF by `meta.reportName`, so nothing on your side should need to change.

---

## Entry 83 — WCGRRT 172: the Planning Report becomes the 12-hourly Daily Summary Report. Your T1–T10

**Rev: WCGRRT 171 → 172, DEPLOYED 15 Oct.**

- **Before the copy:** the live file on `sacred` was hash-checked as 171.
- **After the copy:** re-hashed, then smoke-tested through IIS with posting blocked (badge REV 172, new form fields present, nothing
  posted).
- **sha256** `b6f086423ccae2c753be26df9be5020db9e30fb9f7f093cde67deb153d800893`, 3,372,569 bytes (171: 3,353,244). The PWA files
  are unchanged.

Replies to your handoff "WCGRRT's Planning Report becomes the 12-hourly Daily Summary Report" (15 Oct, evening). The files are in
`REPLY-PLANNING-REPORT-12H-2026-10-15/` and its `.zip`:

- the template (T1);
- `planning-rules.js` and `PLANNING-REPORT-RULES-SPEC.md` (T6);
- the sample post;
- screenshots.

Status: **NEEDS ACTION.**

### 83.1 — T1 to T10

| # | Ask | Status |
|---|---|---|
| T1 | Template from the posted JSON | **Done, 172.** `planning-report-template.html` is self-contained (CSS, logo, renderer), about 224 KB. Details below the table |
| T2 | Full Daily Summary Report | **Done, 172.** Details below the table |
| T3 | Data date-time and cycle | **Done, 172.** "Data Cut-off" 0600 / 1800 on the Planning Report. Posts `meta.cycle` and `meta.dataDateTime` (ISO with the device's offset, so the PC must run rig time). Prints `2026-Oct-15 @0600 Hrs` |
| T4 | BOP % | **Done, 172.** `planningData.bopPctComplete`, filled by the ERT import, can be overwritten. Details below the table |
| T5 | Hours as numbers | **Done, 172.** `planningData.planVarianceHrs` (signed, + ahead) and `meta.floatHrs` (signed), alongside the text. Label now "PLAN VARIANCE (Hrs)". Float stays typed (planner's rule) and is parsed to hours |
| T6 | Rules once, for Argo Navis | **Done.** Details below the table |
| T7 | Report name | **Done, 172.** `meta.reportName` = `planConventionName("Report")` + `_<cycle>`, e.g. `20261015_WPO_TMP_BOP1_Report_0600`. **See 83.4: WCGRRT's order is type then BOP**, unlike your example |
| T8 | Rig people, location | **Done, 172.** All printed. Project location now shows in Planning mode (`meta.location`) |
| T9 | Who posts | **Nothing is planner-only.** Details below the table |
| T10 | Delays, NEW marking | **Done, 172.** "Waiting / NPT" kept. The print lists every open break-in and marks **NEW** those added in the 12 hours to the cut-off. Each break-in now records `added`. Break-ins made before 172 have no `added`, so they are never marked NEW |

**T1, the template:**

- **Fill it** by replacing the token `/*RECORD_JSON*/null` (it appears once) with the whole posted record. **Escape `</` as `<\/`
  first.**
- **Wait for** `body[data-ready="1"]`, then print to Letter.
- **It is the same function as WCGRRT's own "Generate Report"**, cut from the built tool, and gives **byte-identical HTML** for the
  same record (tested).
- **Page numbers ("Page 1 of 3")** come from your printToPDF footer template.

**T2, the full report:** it now prints:

- the rig people;
- maintenance day (underlined) and actual start;
- data date-time;
- current finish and need **times**;
- BOP %;
- variance and float in hours, red / green;
- need date in green;
- new **Quality / Rig Reliability** and **Lessons Learned Since Last Report** blocks;
- Schedule Changes (break-in or delays);
- General Comments.

Scope change stays out. Screenshot: `template-page.png`.

**T4, BOP %:**

- **Calculated exactly as P6 calculates its own %:** 1 − Σ remaining hours ÷ Σ original hours. On West Vela's ERT that reproduces
  P6's branch figure to the digit (85.07%).
- **Which work counts:** picked **by WBS branch** (spec §2.5):
  - BOP / LMRP / Lower Stack / Beam-to-Beam / annulars / rams / pods / accumulators / wellhead connector / pre-deploy / drift /
    stump test / quarantine are in;
  - MPD / riser (not the riser adapter) / telescopic joint / diverter / surface equipment are out.
- **`planningData.bopPctBasis`** says which branches were counted.
- **Project % now has 2 decimals** (89.18%, was 89%).

**T6, rules once:**

- **`planning-rules.js`:** WCGRRT's PLAN-RULES block, the ERT helpers and `RIG_CODES`, cut byte-for-byte from the built tool, for
  browser or Node.
- **`PLANNING-REPORT-RULES-SPEC.md`:** every rule in words.
- **WCGRRT itself now calls these functions.** The ERT import gives **identical** lists, milestones, critical path and variance in
  171 and 172 on two real ERTs (West Vela, West Neptune), and the maintenance day is identical.

**T9, who posts:**

- **Anyone can pick Discipline = Planning.** The rig can post from WCGRRT today.
- **What the rig needs:**
  1. **The ERT.** The P6 export is made in the office, so the rig needs a fresh `.xlsx` each cycle, with **one tab per cycle**
     (e.g. "Oct15 0600", "Oct15 1800").
  2. **The "since last report" memory is per PC.** It is set when the report is **printed** ("Generate Report"). A rig that posts
     without printing compares against an older tab.
  3. **83.4** below.

### 83.2 — The sample post (your ask)

- **What it is:** `sample-post_20261015_SSCE_TMP_BOP1_Report.json`, every field filled, asset **SSCE Equipment** (test asset; rig
  code `SSCE` added).
- **Where it came from:** WCGRRT's own `buildReportPayload`, saved, **not posted**. The file name is the one the tool would post
  with.
- **The data:** Brent's 15 Oct numbers, plus test quality, lesson and break-in rows.
- **Prove it before Argo Navis is ready:** print it with your template, and send the test email to Dan only.

### 83.3 — The new keys (additive; camelCase, matching the existing planning keys you named)

| Where | Key | Value |
|---|---|---|
| `meta` | `cycle` | `"0600"` / `"1800"` |
| `meta` | `dataDateTime` | `"2026-10-15T06:00:00-03:00"` |
| `meta` | `reportName` | `"20261015_WPO_TMP_BOP1_Report_0600"` |
| `meta` | `floatHrs` | number or `null` |
| `planningData` | `cycle`, `curFinishTime`, `needTime` | `"0600"`; `"21:48"`; `"01:00"` |
| `planningData` | `bopPctComplete`, `bopPctBasis` | `"96.6%"`; text |
| `planningData` | `planVarianceHrs` | number or `null` |
| `planningData` | `quality[]` | `{owner, date, desc}` |
| `planningData` | `lessons[]` | `{id, desc}` |
| `planningData.breakins[]` | `added` | ISO date-time; blank on older break-ins |

**Changed values:**

- `pctComplete` from an ERT import now has 2 decimals.
- `meta.location` is now filled on planning posts.

**Unchanged:**

- **No other key changes.**
- **The posting path is byte-identical:** `sdPostReport`, the outbox, `postReport`, the posted file name.
- **`buildReportPayload` gains one line.**

### 83.4 — Two file-name points. Dan's to decide; nothing changed

1. **The 0600 and 1800 reports post under the same file name**, e.g. `20261015_WPO_TMP_BOP1_Report.json`. The name has no cycle.
   - **The intake replaces a file of the same name**, so the 1800 post overwrites the 0600 one in PostedReports.
   - **Your scanner prints every post as it arrives,** so you may keep both PDFs. But the posted record of the 0600 report is
     replaced.
   - **The fix is one word:** add `_<cycle>` to the posted name. It changes the posting file name, which **Dan's standing rule
     forbids without his say-so**. Waiting on Dan.
2. **The order of type and BOP.** WCGRRT's convention is `date_rig_TYPE_BOP` (`20261015_WPO_TMP_BOP1`). Brent's files and your T7
   example use `date_rig_BOP_TYPE` (`20261015_WPO_BOP1_TMP`).
   - **WCGRRT's order drives the posted file name, so it stays** unless Dan says otherwise.
   - **`meta.reportName` follows WCGRRT's order**, so the PDF and the post match.
   - The ERTs themselves use both orders.

### 83.5 — Not done, and why

- **The PDF was not printed here.** This workstation's Edge won't print to PDF headless: CDP says "Printing is not available", and
  the command line writes nothing. The template renders correctly (screenshot), and **your scanner's headless Edge is the PDF
  test**.
- **WCGRRT's own "Generate Report" still shrinks the report to one page.** That was the planner's request, and `printPlanning` is
  unchanged. A full Daily Summary Report prints at about 60%. The SACRED template paginates naturally.

---

## Entry 82 — Reply to your Daily Summary Report handoff (15 Oct): the form is Brent's Word document; WCGRRT's planning rules, from the code

**Rev:** none. WCGRRT 171 was read, not changed. The full reply, with WCGRRT's print view as one self-contained HTML file and a
screenshot, is in `REPLY-DAILY-SUMMARY-FORMAT-2026-10-15/` and `REPLY-DAILY-SUMMARY-FORMAT-2026-10-15.zip`.

Status: **NEEDS ACTION.**

- **Brent's 15 Oct report (PPDSR030918 Rev 4) is a Word document printed to PDF.** Its metadata says
  `Microsoft Word - 20261015_WPO_BOP1_TMP_Report`. It is not WCGRRT output.
  - The layout you asked for (column widths, red/green, underlined maintenance day, page breaks, footer) lives in that Word
    template. **Dan is to get it from Brent.**
- **WCGRRT has its own one-page Planning Report**, a "core subset" of the form. Its print view is attached, but it is not the
  PPDSR layout.
- **What WCGRRT calculates:**
  - **Maintenance day:** date-only, with the start date as Day 1. "Of" comes from the P6 Original Duration.
  - **Plan variance:** taken from the ERT project row, **in hours**, against the baseline set in P6. Without an ERT it is days
    between the finish dates.
  - **% complete:** P6's project %.
  - **Float:** **typed, never calculated.** Brent's +3 h equals need minus current finish.
  - **The lists:**
    - "previous cycle" = anything with progress since the last report;
    - "projected" = everything in progress, with no time window.
- **What WCGRRT does not have:**
  - "BOP Complete" %;
  - any times (so no 0600 / 1800);
  - quality / reliability and general lessons-learned blocks;
  - project location in Planning mode;
  - any planning email.
- **Brent's email, as a template for yours:**
  - subject `<Rig> <BOP> <Type> Reporting yyyy/mm/dd`;
  - rig role mailboxes `SSS.<rig>@`, `TSL.<rig>@`, `DSL.<rig>@`, `ESV.<rig>@`, `MPD.<rig>@`;
  - CC the All TSC WCE Managers_Superintendents_and Planners group;
  - attachment names follow WCGRRT's `yyyymmdd_<code>_<type>_<BOP>_Report` convention.
- **Your revised handoff drops the Scope change request block,** sending unplanned work through Break-in Work instead. That
  matches WCGRRT, which never had the block, but leaves a gap (reply 4.1).
  - A break-in has no **"requested by"** and no **approval status**: WCGRRT's open → closed means "added to P6", not "approved".
  - Delays reach the report only as a **"Waiting / NPT"** break-in type.
  - **Ask Lee** whether Argo Navis's break-ins carry these; recommended fields are in 4.1.
- **Retirement and form control are Dan's to decide.** We recommend running both in parallel for one project.

---

## Entry 81 — PLAN: fill the NOV usage table (entry 80) from PLATO, through your PowerShell scan. Nothing built yet

**Rev:** none. This is a plan item for you to carry. Dan, 15 Oct:

> *"a future reiteration of this for the plan is to have this be loaded in from PLATO using the powershell scan, i will provide a
> location of this CSV file at a later date, we are doing this already for other tools, hand it off in your next run to the DB tool."*

Status: **NEEDS ACTION** — put it in the plan (81.3). The build waits on Dan's CSV location.

### 81.1 — What it is for

- **Today the crew types the usage data by hand** (SSORT 169, entry 80) on the Upper SBOP, Lower SBOP, Gate Valves, Poslock Door
  and U2B Door CBMs: Date in Service, Date out of Service, Wet Cycle Count and Pressure Cycles, with Part No. and Serial No.
- **NOV's own instruction says the numbers come from rig records.** PLATO is the system of record for closure counts and pressure
  cycles: your production timeline already lists it under source-of-truth integrations (workstream 2).
- **The aim:** the scan reads PLATO's CSV export and publishes it, and SSORT fills the table from it, so the crew checks the
  numbers rather than looks them up.

### 81.2 — How we see the split (a proposal; yours to change)

**Your side, the scan:**

- Reads the PLATO CSV from the location Dan will give.
- Publishes it the way you already do for the other tools, on the same server so SSORT can read it over HTTP. One record per
  unit: rig, part no., serial no., date in service, wet cycle count, pressure cycles, and the export date.

**Our side, SSORT, built once your published shape is fixed:**

- **When the crew enters a Serial No.** (or picks the unit) on one of the five CBMs, SSORT looks it up in your published file and
  fills the empty fields. It never overwrites what the crew typed.
- **The crew can correct any value,** and the report records where the numbers came from (for example "PLATO, export
  14/OCT/2026"). That needs one new key, announced here before it ships.
- **If the file can't be reached** (offline tablet, scan not run), nothing changes: the table stays manual, exactly as 169.
- **The six keys from entry 80 stay as they are.** Your report row, viewer and export need no change for this.

### 81.3 — What we need from you

1. **Put it in the plan:** as a PLATO item under workstream 2, dependent on Dan's CSV location.
2. **Tell us what you already publish for the other tools.** File name, location, format (`.js` like `reports-data.js`, or
   JSON), and refresh rate. We'll read it the same way rather than invent a second shape.
3. **When Dan gives the CSV location,** send the column headings and a sample row (one rig is enough). Above all, say which
   column carries the serial number we match on, and whether the cycle counts are cumulative or per service period.
4. **Say how a unit is identified in PLATO.** Serial alone may not be unique across the fleet. Entry 53's gate-valve collision
   shows how easily two units get confused. If you need rig + serial, or rig + position, we'll match on that.

---

## Entry 80 — SSORT 169 DEPLOYED (15 Oct): NOV's Usage Data table on the annular, gate valve and door CBMs. 6 new keys, announced here

**Rev: SSORT 168 → 169, deployed 15 October.** The live file was hash-checked as 168 before the copy, re-hashed after, and
smoke-tested through IIS with posting stubbed. Nothing was posted.

| Build | sha256 | Bytes |
|---|---|---|
| SSORT 169 | `94f4afed950fca4314f8e2273b71cf562552062e4235dc13597d118d63cc5c96` | 7,365,124 (168: 7,361,069) |

Dan, 15 Oct: *"in the CBM documents at the start of the equipment information for Annular, Failsafe's (GATE VALVES), and all
BOP doors we need a permatation of the above table fillable in our format to capture the information for NOV."*

Status: **NEEDS ACTION** — 80.2, the six new keys.

### 80.1 — What ships

- **The table is NOV's own section 8.1, "Usage Data at date of removal from service".** It is identical in the four NOV ID
  documents: 120456057 (SBOP), 132970183 (Gate Valve), 123170149 (NXT 22 in Poslock Door) and 120660738 (U2B Door Assemblies).
  - Its fields are Part No., Serial No., Date in Service, Date out of Service, Wet Cycle Count and Pressure Cycles.
  - NOV's instruction text is shown with it.
- **It appears on five CBM classes only:** Upper SBOP and Lower SBOP (the annulars), Gate Valves (the failsafes), Poslock Door
  and U2B Door. No other class shows it.
- **Where it sits.** On the form it is a collapsible section after 5 · Product Bulletins and before the equipment's inspection
  tasks.
- **In the CBM PDF and the OEM copy NOV receive** (same builder), it prints as a table after Product Bulletins.
  - Dates print as DD/MMM/YYYY, as NOV's form asks (e.g. `02/OCT/2026`).
  - The table is left out when the crew filled none of it.
- **Duplicate** starts the copy with the table blank, as it already does for the unit's model and serial (entry 55.1). The
  table describes one unit.
- **Switching a tile's equipment and back** keeps what was typed (the 168 per-equipment memory, entry 79.1 item 7).

### 80.2 — The new keys (in `cbmData`, lower-case suffixes, additive)

Each key is prefixed with the equipment, exactly as every other CBM key is. `collectCbm` keeps them with their unit and drops
another equipment's.

| Key suffix | Field | Value |
|---|---|---|
| `_usage_pn` | Part No. | free text |
| `_usage_sn` | Serial No. | free text |
| `_usage_in` | Date in Service | `yyyy-mm-dd` (the date picker's value), or blank |
| `_usage_out` | Date out of Service | `yyyy-mm-dd`, or blank |
| `_usage_wet` | Wet Cycle Count | text; numeric keypad on tablets, not enforced |
| `_usage_press` | Pressure Cycles | text; numeric keypad on tablets, not enforced |

The full keys are those six suffixes on these five prefixes, 30 keys in all:

```
cbm_Upper_SBOP_usage_*   cbm_Lower_SBOP_usage_*   cbm_Gate_Valves_usage_*   cbm_Poslock_Door_usage_*   cbm_U2B_Door_usage_*
```

e.g. `cbm_Gate_Valves_usage_out = "2026-10-02"`.

**For you:**

- **Absent, not empty, on posts before 169**, and on CBMs of the other classes.
- **The dates are stored ISO.** Only the PDF formats them as DD/MMM/YYYY, so format them yourself if you show them NOV's way.
- **`_usage_sn` is a third serial field on these CBMs**, beside `rcpt_serial` (Recipient Details) and the Model Data serial
  `cbm_<equip>_md_serial`. They should agree, but nothing makes them.
  - Post to OEM's "model and serial blank?" question (entry 55.1) still reads only the first two.
  - If you recover a unit by serial (entry 53), consider `_usage_sn` as a fallback.
- **No change** to the file name, `reportFileName`, `sdPostDiscriminator`, the posting path or any existing key. These were
  checked byte-identical to 168: `sdPostReport`, `buildReportPayload`, `collectCbm`, `CBM_SCHED`, `CBM_EQUIP` and the precharge
  panel.

### 80.3 — Found while testing: report table headers were white on pale in every SSORT report. Fixed in 169. FYI

- **Every `trip-table` header in every SSORT report printed white text on a pale grey-blue background.** That covers the BOP
  function and pressure test tables, CBM, inspections and C&K Stab Identification.
  - It was barely legible on screen, and blank on paper when the browser drops background colours.
  - The cause: `.trip-doc table th{background:#eef2f9}` overrides the header's navy background but not its white text. It has
    been there since at least REV 148.
- **169 adds one CSS rule:** headers inside a report are navy text on that same pale background. It reads on screen and on paper.
- **Presentation only.** No key, payload or posting change. Your dashboard renders from the JSON, so it is unaffected.
- **PDFs already in your archive keep the old look.**

---

## Entry 79 — SSORT 168 and WCGRRT 171 DEPLOYED (14 Oct, evening): the after-class queue, done now. The outbox; clear post messages; Daily Notes names; three known errors closed

**Rev: SSORT 167 → 168, WCGRRT 170 → 171, deployed 14 October about 20:40–20:47.**

- Dan: *"anything your waiting on until after the class dont waste time and let get its done now … we are migrating to the
  server and probably running on a web app from the 21st"*.
- Each live file was hash-verified before its copy, and smoke-tested through IIS with posting stubbed. Nothing was posted.

| Build | sha256 | Bytes |
|---|---|---|
| SSORT 168 | `51869c433157147ef1ccc9080fbfc37266ab318d5c749e97f700d4ca8c6e5735` | 7,361,069 |
| WCGRRT 171 | `3fe4d84a735307a89ffdebf1048f1a10c5635adc67b2aadd35e0554dec7d79ed` | 3,353,244 |

Status: **NEEDS ACTION**, small: 79.2 (a new file-name shape) and 79.3 (late posts).

### 79.1 — What ships

1. **The outbox** (entry 75, both tools).
   - **When a post fails** (no connection), the report is kept on the device in IndexedDB, under its own file name. A later post
     of the same name replaces it, as the intake does.
   - **It sends itself** when the connection returns, at start-up, and every 2 minutes.
   - **The crew sees** a "📤 n waiting to send" pill and a list with Send now, Save file and Remove.
   - **What arrives is byte-for-byte** the post that would have gone: the same `FileName`, the same body. Tested.
   - **The transports are byte-identical** (SSORT's `sdPostReport(filename, json)`, WCGRRT's `sdPostReport(json, filename)`);
     each is wrapped once.
   - **Not the assistance request** (`seadrill-help_`), which keeps its own NOT-received path and phone-the-office instruction.
   - **If a device cannot store the post** (storage blocked or full), the crew is told to send the saved file to the office,
     never "waiting to send" (168 / 171).
2. **SSORT says whether it posted** (closes ORR **KE-01**).
   - **Posted:** "✓ Posted to the dashboard", with a receipt line under the button (file name, size, time).
   - **Not posted:** "⚠ NOT posted to the dashboard (no connection?) … waiting to send", plus where the local copy went.
   - The Daily Log, Daily Checks and month messages say the same.
3. **Daily Notes and Lessons Learned file names carry the shift and the equipment** (entry 73). See 79.2.
4. **SSORT warns when a workspace holds two report types** (closes **KE-03**): it names both, and Cancel posts nothing.
5. **The pre-deployment evidence section says what to set** instead of showing nothing (closes **KE-07**).
6. **The "Dashboard Post URL" menu option is removed** (closes **KE-05**; it changed nothing). The hints that pointed at it are
   reworded.
7. **CBM:** switching a tile's equipment, or its ram variant, and back restores what was typed for that equipment. This was
   logged on 9 Oct (entry 55).
8. **Tablets** (entry 75): the install files are on the server beside each tool.
   - **SSORT:** `sw.js`, `manifest.json`, `icon-192.png` and `icon-512.png`.
   - **WCGRRT:** the same set as `wcgrrt-*`, scoped to WCGRRT's own file, because `sacred` also serves your dashboard. They
     never touch your pages.
   - **They do nothing over HTTP**, and switch on by themselves under HTTPS. IIS already serves them with the right types.

   Tested with the network cut: the tool reopens from the device's copy.

### 79.2 — One new file-name shape (Daily Notes, Lessons Learned)

The route-1 file name was `seadrill-daily-log_<rig>_<date>_<Shift>.json`. **It is now:**

```
seadrill-daily-log_<rig>_<date>_<Shift>_<Equipment>.json        e.g. seadrill-daily-log_West-Vela_2026-10-14_Day-Shift_DCB-1-BOP1.json
seadrill-lesson-learned_<rig>_<date>_<Shift>_<Equipment>.json   (was seadrill-lesson-learned_<rig>_<date>.json)
```

- The equipment part is the entry's Equipment pick, with every run of non-alphanumerics turned into `-`. It is left off when no
  equipment is picked.
- **The month list's 📤 Post** (re-post one day) now uses the same name. Before, it dropped the shift, so a re-post landed as a
  second file.

**Your side:**

- **The prefix, `meta.reporttype` and `meta.dayLogEntry` are unchanged**, so routing is unaffected.
- **Your dedup key (rig + date + shift + equip) now works as designed.** Two entries in one shift no longer overwrite each other
  at the intake.
- **Old files keep their old names.** Please confirm nothing parses the date or shift out of the *name*; we expect not, since
  routing is never filename-based.

### 79.3 — Posts can now arrive late

A report written with no connection arrives when the device reconnects. That can be hours later: its `exportedAt` or
`meta.saved` will be well before the time it lands.

- If anything on your side orders, alerts or "today"-filters by arrival time, prefer the report's own dates.
- **A queued re-send replaces the earlier copy under the same name**, as a normal re-post does.

### 79.4 — Still open, not ours to close

- **KE-02:** the empty SSORT role keys. These need your agreement to drop or to add fields.
- **KE-08:** the stale `sacred\index.html`. This needs IT to delete it.
- **KE-13:** cache headers. This sits with ISIT, alongside HTTPS (`ISIT-REQUEST-HTTPS-FOR-REPORTING-TOOLS.md`).
- **The §4.1 argument reversal in SSORT's `dlPostPayload` folder fallback is untouched**, as Dan's standing rule says.

---

## Entry 78 — SSORT 166 DEPLOYED (14 Oct, evening): the "Nothing to post" guard (77.3), done now, not after the class

**Rev: SSORT 166, deployed 14 October about 20:00 on Dan's go** (*"do this now"*).

- Live file hash-verified before the copy: it was 165.
- After the copy: sha256 `5dd8da79af746b29f1752e05f03bcc82624c648c45d4eb1b70b3e1c45fc6364e`, 7,350,749 bytes.
- **This is the class build:** the freeze starts 15 October.

Status: **FYI**. This closes your ask 2.

**What it does:**

- 📤 Post Report (Rig Reporting) refuses when the workspace has no report sections. That is your blank-post shape: on SSORT's
  path `meta.reporttype` is always `""`, so empty type plus no tiles means no `.data-tile`.
- The crew sees: *Nothing to post. The Rig Reporting workspace has no report sections, so there is nothing to send. Add one
  with + Add Section first. Daily Log entries post from the Daily Log tab: ➕ Add to Log for each entry, 📤 Generate & Post
  Month for the month.*
- There is no confirm, and nothing is posted.

**What it does not touch:**

- `postReport` is 165 plus that one guard line. The rest of the file is identical to 165 apart from the revision.
- The other posts never use `postReport`, so they are unaffected: the Daily Log entries and month, Daily Checks / FLM, Link
  to plan, the assistance request, and Post to OEM.

**Tested** with posting stubbed:

- an empty workspace, with and without a rig, gives the message and no post;
- a surface test posts as before, with the same confirm and the same file name;
- Add to Log is unaffected.

It was re-checked live through IIS, together with 165's Rev 9 section. Nothing was posted.

**Also moved to 166:** the training pack (the badge, samples, slides 3 and 16) and the ORR pack (test record 166; KE-18
notes the guard).

---

## Entry 77 — Reply to your 14 Oct blank-posts handoff: the rigs were not on a stale copy. They follow the server, and the blank posts stopped with 164. 74.2 closed

**Rev: none.** To the dashboard, via Dan. Status: **CLOSED** (74.2). The guard (ask 2) is queued for after the class.

### 77.1 — The cause, corrected: the server's own builds, not a file on the rig's PC

Your reading of the post is right: it was the Daily Log tab's end-of-trip **📤 Post Report**, which 164 removed (entry 74). One
part of the explanation does not hold, though: *"the rig is on 163 because the tool is a file on their PC"*.

**The evidence, from `WellControl - PostedReports`:** West Saturn's blank posts carry, day by day, the SSORT build that was live
on the server that day.

| Saturn blank post | `meta.rev` |
|---|---|
| 26 Sep | 148 |
| 27–28 Sep | 149 |
| 29 Sep | 151 |
| 30 Sep | 153 |
| 1 Oct | 154 |
| 9–10 Oct | 160 |
| 12–13 Oct | 163 |

A rig on a saved copy would keep posting one revision. Saturn's changed every time we deployed, so Saturn opens SSORT from the
server. Posts before 26 Sep carry no `meta.rev`, because SSORT wrote none before 148 (entry 24).

- **The 13 Oct post** (`exportedAt` 13:03:49Z) is the last one. 164 replaced 163 on the server at about 13:10Z that afternoon,
  seven minutes later.
- **Since then** (checked 14 Oct evening) there are no blank posts from any of the three rigs, and their next posts are already on
  the new builds:

  | Time (UTC) | Post | Build |
  |---|---|---|
  | 13 Oct 22:59 | West Saturn Daily Checks (Night) | **SSORT REV 164** |
  | 14 Oct 00:10 and 00:14 | West Tellus Daily Log entries | **SSORT REV 164** |
  | 14 Oct 15:27 | West Saturn Daily Checks (Day) | **SSORT REV 165** |

- **West Capella's** blank posts ended on 3 Sep. Its latest SSORT post (a Post to OEM, 12 Oct) is stamped 163, the live build at
  the time.

**So ask 1 needs no action.** All three rigs pick up 165 as they open the tool, and Saturn and Tellus already have. The cause of
the blank posts was the button in every build up to 163, on the server, pressed by crews finishing the Daily Log. It is gone from
164.

### 77.2 — Which rig is on which build

We keep no list, and from the evidence above none is needed while rigs open the server copy. Your v2.96 Status page (the newest
post's `meta.rev` per rig) is the right check. It will show at a glance any rig that *does* run a saved copy, which a laptop on
a rig with no intranet might.

### 77.3 — The guard (ask 2): agreed, after the class

**"Never post when `meta.reporttype` is empty and there are no tiles; say *Nothing to post*."** It goes into the first SSORT
build after 20 October, subject to Dan's go, because it is on the posting path.

**Update, 14 Oct evening: done.** Dan said *"do this now"*, and it shipped in **SSORT 166** (entry 78), the class build.

- **Where:** `postReport` only.
- **The other posts already set their own types**, so they never trip it: the Daily Log entries and month, Daily Checks and FLM,
  Link to plan, the assistance request, and Post to OEM.
- **The words, as shipped:** *Nothing to post. The Rig Reporting workspace has no report sections, so there is nothing to send.
  Add one with + Add Section first. Daily Log entries post from the Daily Log tab: ➕ Add to Log for each entry, 📤 Generate &
  Post Month for the month.*

Still queued for after the class: the offline outbox (entry 75) and the Daily Notes file name (entry 73).

### 77.4 — Your v2.92 handling

Listing these under Problems as `blank-post`, and keeping them off the Reports list and the rig panel, is right. Nothing needs
deleting.

---

## Entry 76 — SSORT 165 DEPLOYED (14 Oct): FRM-00-0168 Rev 9 additions on the pre-deployment checklist. 10 new `pdc_r9_*` keys, announced here

**Rev: SSORT 165, deployed 14 October on Dan's go** (*"build ssort today and handoff to lee"*).

- Live file hash-verified before the copy: it was 164.
- After the copy: sha256 `f4c982426a054d78a5bef9573dde60f227a70705d5a872a99d192b4d0bfa3426`, 7,350,417 bytes.
- Smoke-tested through IIS with posting stubbed: the Rev 9 section, and 164's Daily Log fix. Nothing was posted.

Status: **NEEDS ACTION**: 76.2, show the keys.

### 76.1 — What the crew sees

A new section headed **FRM-00-0168 Rev 9 Additions**, below Electrical Scope. Dan: *"Form is going to Rev 9"*. The Rev 8 items,
and the header, are unchanged until document control issues Rev 9.

- **ROV panel: valve orientation and line-up**
  - a tick: all ROV panel valves verified in the correct orientation and line-up for deployment, and photographed;
  - **free photographs, each captioned** with the panel and the valve: 12 slots, plus **+ 6 more** as needed.
- **Riser: running and pulling**, three ticks:
  - the pre-deployment checklist for running and pulling riser is completed;
  - a drops inspection is completed;
  - the riser is verified: all seals satisfactory and correctly oriented.
- **Riser maintenance conducted by:** tick all that apply.
  - 3rd party, with the company's name;
  - CBM;
  - Seadrill;
  - riser remarks.
- **One new stop before posting:** 3rd party ticked but no company named. The ticks themselves do not block a post, because the
  emergency copy must still post.
- **The checklist PDF** prints the section and the captioned ROV photographs.

### 76.2 — The keys, in `pdcData`, lower case and additive

| Key | Type | Meaning |
|---|---|---|
| `pdc_r9_rov_lineup` | `"1"` / `""` | ROV panel valves verified in orientation and line-up, and photographed |
| `pdc_r9_rov_ph` | `[{src, caption}]` | ROV panel valve photographs (JPEG data URI, the same compression as every SSORT photo) |
| `pdc_r9_riser_checklist` | `"1"` / `""` | running and pulling riser checklist completed |
| `pdc_r9_riser_drops` | `"1"` / `""` | drops inspection completed |
| `pdc_r9_riser_seals` | `"1"` / `""` | riser verified: seals satisfactory and correctly oriented |
| `pdc_r9_riser_by_3p` | `"1"` / `""` | riser maintenance by a 3rd party |
| `pdc_r9_riser_by_3p_company` | string | that company (required when the tick is on) |
| `pdc_r9_riser_by_cbm` | `"1"` / `""` | riser maintenance by CBM |
| `pdc_r9_riser_by_seadrill` | `"1"` / `""` | riser maintenance by Seadrill |
| `pdc_r9_riser_rem` | string | riser remarks |

**What to build:**

- show them in the checklist viewer and the export;
- `pdc_r9_rov_ph` belongs beside the other pre-deployment photo grids, and counts toward the same 40 MB ceiling.

**A checklist posted from 164 or earlier has none of these keys.** Absent means the line predates Rev 9; it never means No.

**Unchanged, byte-identical to 164:**

- posting: `sdPostReport`, `postReport`, `dlPostPayload`, `addToLog`, `postMonthlyLog`, `checksPost`, `tarqSend`,
  `sdLinkToPlan`, `sdSizeOk`;
- `buildReportPayload`, `collectPdc`, `sdPdcComplete`, `PDC_ITEMS` and the precharge panel.

The file name, the post / fetch / 0.82 counts and the 40 MB pre-deployment ceiling are also unchanged.

### 76.3 — Argo Navis

The same five lines go to Lee for Argo Navis's checklist, using these keys as the interchange: `HANDOFF-LEE-PDC-REV9-ADDITIONS.zip`
(Dan sends). In matrix terms:

- **C-05:** ROV panel orientation and line-up, photographs with captions;
- **R-01 … R-04:** riser running and pulling checklist, drops, seals, and maintenance by.

There are suggestions to populate R-02 and R-04 from the plan.

### 76.4 — The training pack moves to 165

The class exercise uses this checklist, so the script, the exercise sheet, the screenshots and the samples now show the section.
The badge reads REV 165 · 2026-10-14. **The freeze starts 15 October, so 165 is the class build.**

---

## Entry 75 — For the SACRED plan: the reporting tools offline on iPads and Android tablets. Waiting on ISIT for HTTPS

**Rev: none.** Status: **NEEDS ACTION**: add it to the plan as an item.

Dan, 13 October: *"we can store a local copy and just sync to the network when we have a connection"*. The plan is in
`PLAN-OFFLINE-TABLETS.md`. In short:

- **Each tool is one self-contained file**, and posts go to the Power Platform intake over the ordinary internet. So the tools can
  run offline once installed.
- **The blocker is HTTPS.** The server answers only on HTTP 8080, and tablets keep an offline copy of a web app only when it is
  served over HTTPS. The request to ISIT is drafted (`ISIT-REQUEST-HTTPS-FOR-REPORTING-TOOLS.md`) and asks:
  - for HTTPS and a certificate the tablets trust;
  - for MIME types for the offline files, and no-cache on `sw.js`;
  - whether HTTPS can be part of the server move;
  - for an optional Intune push of the tools to the tablets.
- **After the class, the tools session builds:**
  - an installable SSORT and WCGRRT;
  - **an outbox**: reports made offline queue on the tablet and send themselves when the connection returns.

  The files and keys are the same as today, so nothing changes for you.
- **The outbox touches the posting path**, so it needs Dan's go when we get there. It also closes ORR KE-01, SSORT's silent post
  failure.

**One question for you:** is the 18 October server move this server (`sdrlazneuiis01d`)? If it is, HTTPS belongs in its setup.

---

## Entry 74 — SSORT 164 DEPLOYED (13 Oct): the Daily Log's month PDF now carries the month, and a Post Report that posted blank reports is gone. No keys change

**Rev: SSORT 164, deployed 13 October on Dan's go** (*"A, build 164 and deploy it"*).

- Live file hash-verified before the copy: it was 163.
- After the copy: sha256 `18b4d6346c3902488c33af9af2a9c618e2c52a75fd84fe9c1d2cb9697082d445`, 7,345,616 bytes (163: 7,345,170).
- Smoke-tested through IIS with posting stubbed. Nothing was posted.

Status: **FYI**, with one check (74.2).

**The report came from the rig.** Eric Rachall sent Dan a screenshot of the section below the Monthly Daily Log box: *"so the
above actually does nothing"*.

### 74.1 — What 164 changes (the Daily Log tab only)

1. **The Daily Log document lists the month.**
   - **What was wrong:** ⟳ Generate / Refresh, ⎙ Print / PDF and the PDF that 📤 Generate & Post Month prints all built their
     entry list from the entry form. ➕ Add to Log clears that form, so **the crew's month PDF never carried the month's
     entries.**
   - **Now:** the document lists the selected month's entries from the month's log, by date then shift, each with its shift
     and who.
   - **Your data was never short:** the posted `…_<YYYY-MM>_daily-log.json` always carried `meta.dayLogMonth` in full.
2. **Removed from below the Monthly box:**
   - the end-of-trip archive line;
   - a duplicate Generate;
   - a duplicate Print;
   - a 📤 Post Report.

   The ⋮ menu stays (Save to File, Report Folder, Load from File, Clear Daily Log Archive).
3. **The intro line** now names Generate & Post Month (it said "Generate & Archive Month", a button that no longer exists).
4. **The badge date is current** (`2026-10-13`). That closes 72.3.

**For you: nothing to build.**

- No key, file name or payload changes.
- Byte-identical to 163:
  - posting: `sdPostReport`, `postReport`, `dlPostPayload`, `addToLog`, `postMonthlyLog`, `checksPost`, `postLessonLearned`,
    `tarqSend`, `sdLinkToPlan`, `sdSizeOk`;
  - payload and Daily Log: `buildReportPayload`, `collectDayLog`, `generateTripReport`;
  - `CBM_SCHED` and the precharge panel.
- The `sdPostReport(`, `fetch(` and 0.82 counts are unchanged.

### 74.2 — One check: blank reports from the removed Post Report

On the Daily Log tab, that Post Report posted the whole workspace. With nothing on the Rig Reporting tab, that is:

- `seadrill-report_<rig>_<date>.json`;
- with `meta.reporttype` `""`;
- with no `tiles`;
- with the month's notes riding in `meta.dayLogMonth`.

**Please look for posts of that shape.** If any exist:

- they are blank rows in the Reports list for that rig, and can be ignored or removed;
- their `dayLogMonth` should not have been ingested as a monthly roll-up. Your routing uses `meta.reporttype`, so it shouldn't
  have been.

No more can arrive from 164.

### 74.3 — The training pack, the ORR pack and the crews' how-to

- **Training pack:** moved to SSORT 164.
  - It changes only the Daily Log tab, which Day 1 does not teach.
  - Shot 17 (badge) and the samples are redone; the deck's slides 3 and 16 are updated.
  - Rebuilt `WCE-Training-Day1-Pack.zip`.
- **ORR pack:**
  - test record 164;
  - **KE-18** (closed);
  - components, runbook and UAT now name 164.
- **The crews' Daily Log how-to:**
  - footer updated to 164;
  - its month-end step ("prints it as a PDF") is now true of the PDF's contents.

---

## Entry 73 — Daily Notes: two entries in one shift post under one name, so the dashboard keeps only the last

**Rev: none.** Found on 13 October while writing the crews' Daily Log how-to for Dan
(`SSORT-Daily-Log-How-To.html`). **Nothing was changed: we are in the freeze, and it is on the posting path.** Status: **FYI**,
with one question.

### 73.1 — What happens

- **➕ Add to Log** posts each entry at once as `seadrill-daily-log_<rig>_<date>_<shift>.json`.
- **The name carries no equipment and no sequence**, and an entry holds one Equipment pick. So a crew logging two pieces of
  equipment in one shift posts two files with the same name, and **the second replaces the first** at the intake.
- Both entries stay in the browser's month list. **📤 Generate & Post Month**
  (`seadrill-report_<rig>_<YYYY-MM>_daily-log.json`, `meta.dayLogMonth`) carries every entry, so nothing is lost at month
  end, only in the meantime.
- **The same pattern applies to Lessons Learned:** `seadrill-lesson-learned_<rig>_<date>.json`, so two on one day overwrite.

**Your side is built for several entries in a shift; the file name is the weak point.** Your index (`INTEGRATION-CONTRACT.md`,
v2.35+) dedups Daily Log entries on **rig + date + shift + equip**, because "a rig can log several entries per day for
different equipment". The route-1 file name carries no equipment, though. So the intake overwrites the first entry's file with
the second before your index can keep them apart. Fixing the name (73.3) lets your existing key work as designed.

### 73.2 — Asked of you

- **Do posted `seadrill-daily-log_` files show it?** Look for a rig whose month post has more entries for a date and shift
  than the dashboard showed during the month.

**Meanwhile, the how-to tells crews:** one entry per shift, with the equipment listed in the text.

### 73.3 — After 20 October

Add the equipment, or a short sequence, to the name. That is additive and the scanner keys on the prefix. It is held for
after the class, with the fallback reversal (§4.1), which stays untouched.

---

## Entry 72 — The Day 1 training pack moves to the class builds, WCGRRT 169 and SSORT 163. Three errors it already had are fixed

**Rev: none in the tools.** Dan released the pack on 13 October (*"yes go for it"*). It had been held on SSORT 159 / WCGRRT 168
since 9 October (entry 56). **The freeze starts 15 October, so 169 / 163 are the builds on the 19th.** Both were re-hashed on
the servers today. Status: **NEEDS ACTION**: rebuild the trainee workbook from `WCE-Training-Day1-Pack.zip` (13 Oct).

### 72.1 — Start with `08-WHATS-NEW-SSORT-163-WCGRRT-169.md` in the pack

**New in the scripts** (Module 3 still ends at 14:30; CBM 40 → 35 min, test records 20 → 15):

- WCGRRT 169 drag-and-drop photos (M1 step 14);
- SSORT 160 model and serial "required by NOV", per unit (M3 49a–49b);
- SSORT 161 Technical Assistance Request: a new section 6, 10 min, steps 70a–70g;
- SSORT 163 SFI picker;
- SSORT 162 plan picker and Link to plan (M3 46a, 66a).

**Q&A:**

- 2.3 gains the two SSORT controls that do report a failure;
- two optional questions are added: 3.4 (model and serial) and 3.5 (the assistance request).

**Screenshots, in `screenshots-163/`:** taken at 1600 px with headless Edge, with every POST blocked before page scripts ran.
Nothing was posted.

- **Retaken:** 1 and 17, the badges.
- **New:** 17a, 18a, 18b, 23a, 25, 26 and 27. 27 is on West Capella, display only, because SSCE Equipment has no SFI codes.
- **Yours, optional:** 18, 19 and 23 may lack the new marks; 18a and 23a cover them.

**Samples:**

- **How rebuilt:** through the tools' own Load from File and `buildReportPayload`.
- **What changed:** a deep diff shows only `meta.rev` and `exportedAt`. The CBM sample also gains its model and serial.
- **Renamed:** two files take the names 163 gives.

### 72.2 — Three errors the 159 pack already had, now fixed

1. **The exercise sheet said "📤 Post to Dashboard" for SSORT.** The button is **📤 Post Report**. "Post to Dashboard" is the
   Daily Checks form.
2. **The class's file names were pre-158.** On 163 they are:
   - `…_surface-bop-testing_BOP-Function-Test.json`;
   - `…_cbm-inspection_Riser-Adapter-SNTRN-0n.json`. Each trainee now enters serial `TRN-0n` to match their date.

   The daily and pre-deployment names are unchanged. **For Dan's clean-up:** these are the 40 file names, plus one
   `seadrill-oem_` per trainee.
3. **The deck drew badly in PowerPoint.**
   - **10 of the 20 slides** (the title, the opening, the module dividers and the Title-and-Content slides) had text boxes of
     zero height, which PowerPoint stacks at the top-left.
   - **The checks table ran off the slide.** Its last two rows, the *post failed* lines, were never visible.
   - **Fixed**, and every slide re-rendered through PowerPoint and checked. The deck is now 21 slides (one new: *New this
     month*). **If the workbook took anything from the deck's look, re-export from this copy.**

### 72.3 — One wording item logged for after the class (not shipped: freeze)

**The badge date is not the build date.** Both badges show *2026-09-23*. `SSORT_REV_DATE` and its WCGRRT twin were last
changed at SSORT 156 / WCGRRT 166 and have not been bumped since. The pack tells the trainer to read the revision, not the date.
Fix after 20 October: bump it with each revision, or drop it.

---

## Entry 71 — The resolved matrix, reviewed, and in one pack to Lee with the job plans and the branding

**Rev: none.** Status: **FYI**, with two small corrections to your 12 Oct resolved handoff (71.1) and the tools session's
position on your ask to us (71.2).

`Argo-Navis-Handoff-to-Lee-2026-10-12.zip` (Dan sends) contains:

- `00-START-HERE.md`;
- 01: the job plan checklists (JPC REV 4, entry 70);
- 02: your resolved matrix and handoff;
- 03: the SSORT tests and Link to plan (entries 61–62, 64, 67, 68, `PLAN-SSORT-LINK-TO-PLAN.md`, the 161 test keys);
- 04: the Argo Navis branding pack.

The workbook went in **recalculated in Excel**, with no cell content changed. The example's COUNTIF cells had no stored values
(an openpyxl save), so some viewers showed them blank.

### 71.1 — Review of `PDC-MATRIX-RESOLVED-HANDOFF-2026-10-12.md` against the workbook

1. **Counts.** Your §1 says 40 lines approved without comment and 13 commented. The workbook has:
   - **27 lines with a comment**: 19 in Dan's column (B-13 … H-06), 8 in Lee's (A-01, B-03, B-04, B-06, B-07, B-09, B-10, H-07);
   - **26 approved as proposed**, and D-02 / D-03 "as D-01".

   Every decision is in the Decision column and matches your tables. The miscount is in the prose only. Lee was told to build
   from the Decision column.
2. **Decided but not yet a row.** These are in Lee's START-HERE as lines to add:
   - E-04b;
   - the two optional sign-offs under H-06;
   - B-14 as two checks;
   - the H-07 testing milestone;
   - plan-side items (B-M1 scope challenge, the B-19 task, the B-04 MOC task type).
3. **"Ready to sign?" in the example counts every line.** Now that H-05 and H-06 (and the two new lines) are optional, they must
   be left out of the count, or closed as N/A, or an unsigned optional sign-off holds the checklist open. Flagged to Lee; worth
   the same rule in your 90 % and "pre-deployment complete" logic.

### 71.2 — Your ask to the tools session: photograph slot labels in SSORT and WCGRRT (Q2)

**Agreed, not built yet.** It reads the designation's photograph set from the project folder, and that set's location and
format are not defined yet. Lee is asked for both in START-HERE. The tools are also in the freeze from 15 October until after
the 19–20 October class.

Precharge Pro's plan-id line (B-06) is Dan's own tool. This session does not touch the precharge tool.

### 71.3 — Two of Dan's open items answered (12 Oct)

- **Q6: yes.** "Pre-deployment complete" on the plan needs **every line closed and every required sign-off**, as you proposed.
  The optional sign-offs are the exception (71.1.3). SSORT's emergency sheet keeps its light gate.
- **Lee's optional sign-off line (H-06):** **Lee Arnold, Head of Well Control Equipment.**

Both are in Lee's START-HERE. Still with Dan:

- the sign-off order;
- the B-16 and B-M1 directives;
- the eDocs prefix;
- Precharge Pro's plan-id line.

---

## Entry 70 — Job plan checklists for DL-1: your 12 Oct answers, built. Sync is on, the PDF carries the eDocs title block, and the file is now Argo Navis

**Rev: none in SSORT or WCGRRT.** A standalone file for DL-1: **`Argo-Navis-Job-Plan-Checklists.html`, JPC REV 3**. It was
`WCE-Job-Plan-Checklists.html` when the 70 ask went to you; Dan renamed the planning tool **Argo Navis** on 12 October.
Status: **FYI**, with one correction (70.3) and the keys for your next scanner version (70.2).

### 70.1 — The ask and your reply, for the record

The ask went to you as a standalone note (`Job Plan Checklists/ASK-DASHBOARD-eDocs-and-sync.md`). It covered:

- the lifecycle Dan described: view-only during schedule building, a checklist during execution;
- third-party engineers without SSO, on a desktop, iPad or Android tablet;
- % complete with each step an equal share;
- the PDF to eDocs, and a Seadrill close-out in Maximo.

It asked five things: eDocs, the PDF, sync, the percent, and the future. Your reply (12 Oct, late) is taken as written:

- **eDocs (70.3.1).**
  - The planning tool's file structure is on **the WellControl site**: Between Wells Maintenance, one folder per `planId`,
    with subfolders 01–08. It is not in eDocs.
  - eDocs takes the **PDF only**. A Seadrill person uploads it by hand at close-out.
  - The eDocs number comes back as `edocsRef` on the plan close-out post.
  - The title block has a blank "eDocs no." line.
  - Dan is to confirm the prefix with document control.
- **The PDF (70.3.2).** A person printing on the device is acceptable for now. The headless-Edge PDF into 08 comes after the
  18 Oct server move, as your scanner work.
- **Sync (70.3.3).** **On.**
  - Same intake; a stable name, so each sync replaces the last.
  - Filed into 02, or 03 when the job plan is a test.
  - **25 MB** ceiling; warn at 15.
  - A third-party device without SSO is accepted as monitored; KE-10 widened to cover it.
  - Tests never count: `dryRun`, `meta.sample` or SSCE Equipment.
- **The percent (70.3.4).** `checklistPct`, `checklistCounts` and `checklistSigned` go on the task as evidence. DL-1 is the one
  writer of the task and plan %. A gap over 20 points is flagged.
- **Future (70.3.5).** No eDocs API is known; a Maximo close-out would need OSLC plus an ISIT decision. Nothing is built for
  either.

### 70.2 — What changed in the file to meet it (JPC REV 3). Tested with fetch stubbed; nothing posted

1. **Sync is on.** `JPC_POST_URL` is the intake every tool uses. The transport is unchanged:
   `{FileName, ContentType, FileContent}`, JSON as base64, and no `no-cors`. The name is unchanged:
   `seadrill-jpc_<rig>_<planid|noplan>_<jobplan>_<wo|nowo>_<cid8>.json`.
   - A stubbed test on SSCE Equipment produced
     `seadrill-jpc_SSCE-Equipment_WVE-BOP1-20261005_0900-CX80021_R-TEST-1_058c3d8e.json`, with `meta.sample: true` and
     22.2 % for 2 of 9 steps.
2. **Size, as you set it.** The file warns above **15 MB** and refuses above **25 MB**. On refusal it offers to sync **without
   the photographs**, which stay on the device.
   - Your "post the record, add photographs later" route: export the file to deliver them.
   - A 27 MB test checklist went through that path as designed.
3. **New keys on the record, for your scanner.** All are additive; the shape is otherwise as 70.2 of the ask. `version` stays 2.

   | Key | What it is |
   |---|---|
   | `tool` | `"Argo Navis Job Plan Checklists"` (was `"WCE Job Plan Checklists"` in the drafts nobody posted) |
   | `rev` | `"JPC REV 3"` |
   | `meta.kind` | `"jobplan-checklist"`: what you route on |
   | `meta.tool`, `meta.rev` | as above |
   | `meta.asset` | the rig, as everywhere else |
   | `meta.saved` | ISO time of the sync |
   | `meta.by`, `meta.company` | Performed-by name and company: the poster for your monitoring list |
   | `meta.planid` | the DL-1 plan, the same as `link.planid` |
   | `meta.sample` | `true` when the rig is SSCE Equipment |
   | `photosHeldBack` | `true` only on a record synced without its photographs |
   | `checklist.answers.<tid>.photoCount`, `checklist.photoCountGeneral` | only on such a record: how many photographs were held back |

4. **The PDF (your 70.3.2 list).** The print stylesheet now has:
   - **A title block:** "Seadrill · Argo Navis · Job plan checklist", the signed / in-progress state, job plan number and title,
     rig, job plan and revision, WO, `planId`, plan task, checklist id, % complete with the counts, Performed by and Verified by
     with names, companies and **local** times, the source, the printed time, and **a blank "eDocs no." line**.
   - **A footer on every page:** the job plan, the WO, the checklist id, the `sourceSha256` short form (`7ad625cfb801`) and
     JPC REV 3.
   - **"Page x of y"** where the browser supports it (Chrome, Edge).
   - **One line of help** on the screen: on an iPad or Android tablet, Print → the share sheet → Save as PDF.
5. **Branding.** Argo Navis app icon, name and Planning Tool logo, the pack's palette, and icons for the tab and the iPad home
   screen.
   - The pack is marked as draft assets pending Seadrill Communications, with no Seadrill wordmark on the lock-ups, so the
     Seadrill logo is **removed** from the file. "Seadrill" appears as text only.
   - The whole pack goes to Lee in the zip.

### 70.3 — One correction: "as in entry 67" in the ask was the wrong reference

The ask said the scanner would "file a copy in the plan folder (as in entry 67)". The plan-folder rule is in
**entry 62.5, item 3**, not entry 67:

- the plan folders hold copies, as Dan answered on 12 Oct;
- re-copy when the source file changes, so the plan never holds an older version than PostedReports.

**Your reply already meets it** ("newest content wins, the signed copy is the one kept"), so there is no further rule.

**Entry 67 is in this file** (the pre-deployment alignment reply, 12 Oct). If it is not on your received list, you may be
reading an older copy of this file. Dan, please send the current one.

### 70.4 — Gone to Lee (Dan sends)

`Argo-Navis-Job-Plan-Checklists.zip` contains:

- the file;
- `LEE-HANDOFF-JOB-PLAN-CHECKLISTS.md` (final): §5 has your percent position, §6 sync, §8 your eDocs section;
- `README-for-Lee.md`;
- the full `Argo_Navis_Branding_Pack/`, its 26 files byte-identical to Dan's.

Your two asks go to Lee through it:

- `edocsRef` on the plan close-out post (§8.1, question 6);
- whether a job plan with a checklist should expose its task weighting (§5, question 4).

### 70.5 — JPC REV 4, same day: the job plan pops up inside Argo Navis. Nothing changes for you except the `rev` string

Dan:

> *"when this is embedded in the schedule builder it will be literally click on the job plan number in the plan and the
> checklist opens … lee's tool won't be opening a separate tool though, just a job plan will pop up."*

The same file now has an **embed mode** (`embed=1`):

- Argo Navis opens the file inside its own pop-up.
- The file hides its library and shows a ✕ Close.
- It tells the plan page its progress by `postMessage`: % complete, and signed or synced, with no names or photographs.

On its own, the file stays the on-site tool for any job.

**For you:**

- **The record, the sync name and the transport are unchanged.** Only `rev` and `meta.rev` now read `"JPC REV 4"`.
- A checklist started on site **without a plan** syncs as `seadrill-jpc_<rig>_noplan_…`, as before. It cannot be routed to a
  plan task. List it as evidence for the rig; it is not a fault.

---

## Entry 69 — Dan's sign-off decision, and the matrix proposal for review (dashboard first, then Lee)

**Rev: none.** To the dashboard. Status: **NEEDS ACTION**: review the attached matrix and fill in your columns. Dan then sends it
to Lee.

### 69.1 — Sign-off, for now (Dan, 12 October)

> *"for now people just sign it off with their name, once this is complete there is always a pre deployment call per directive
> before the BOP is ran which the list will be reviewed, only now all relevant parties will have seen the checklist beforehand."*

**So entry 68.2 point 6 (signed-in identity) is deferred, not the route for now:**

- **Sign-off is each role's typed name and date**, as on FRM-00-0168 today.
- **Accountability comes from the pre-deployment call held per directive before the BOP is run**, where the checklist is
  reviewed. What changes is that every relevant party has **seen the checklist beforehand**, because the matrix populates it as
  the work goes.
- The rest of 68.2 is unaffected and offered as before:
  - populated, not typed;
  - no open lines at signing;
  - a snapshot of what was signed;
  - re-open on change;
  - one "go" record.

  The matrix sheet's "States" tab carries the no-open-lines rule.
- **ORR known error KE-17** (SSORT sign-off is a typed name) is updated to say this is the accepted position. The
  pre-deployment call is the control, and identity-based sign-off stays a possible later step.

### 69.2 — The matrix proposal: `PDC-MATRIX-PROPOSAL-for-Dan-and-Lee.xlsx`

Built from what SSORT's checklist holds today (read off SSORT 161, as in the entry 61 pack), plus the nine pre-deployment
tests (62.4). **Nothing in it is new content.** It is today's checklist laid out as matrix rows, so the three sides can agree
it before anyone builds. **Five sheets:**

| Sheet | What |
|---|---|
| **Read me** | Purpose, the decisions already made, and the legend |
| **Matrix** | **The one to review.** 53 lines in sections A–H. Each line has: what it records, one row per (checklist / stack / position / cavity), the evidence, when it is complete, whether N/A is allowed, who updates it, from when, and the SSORT keys today. Sections: header · 21 items · BOP configuration and the stack table · ram packers · the photographs per cavity · electrical · the nine surface tests · non-compliance and exemption · acknowledgement, the five sign-offs, and **H-07, the pre-deployment call per directive** (new: not in SSORT today) |
| **Example — one stack** | The matrix expanded for one 7-cavity stack (West Vela BOP1, illustrative states only): 66 lines, with a live summary of counts by state, % done, and "Ready to sign?" |
| **States** | Not started · In progress · Complete · Evidence linked · N/A (reason); the sign-off rule; the floor for "complete" (SSORT's post gate) |
| **Questions** | Seven open points with a proposed answer each: one stack per checklist, a photo `slot` field, who may mark N/A, H-07 as a line, sign-off order and delegation, items and sign-offs as part of "complete", visibility |

**How to review:**

- The pale yellow cells are the reviewers'. Each of the dashboard, Dan and Lee has an **"Agree?"** dropdown (Yes / No / Change)
  and a comment column per line, and an answer column in Questions. Row 3 shows one example entry, for the format.
- **Dashboard first:** please fill in the Dashboard columns, and add rows in your comment column if a line is missing. Then
  hand it back to Dan, who sends it to Lee.

---

## Entry 68 — Dan confirms 67.1, and sets the purpose: the matrix populates a pre-deployment checklist everyone signs before the BOP goes in the water, like a flight checklist

**Rev: none.** To the dashboard **and DL-1 (Lee)**. Status: **NEEDS ACTION**: design points for DL-1 and the dashboard
(68.2), and one decision for Dan (68.3).

### 68.1 — What Dan said, 12 October

> *"yes confirmed 1-4, but the matrix will populate a predeployment checklist that everyone can agree and sign off before the BOP
> is deployed like a flight checklist, this is very important for accountability"*

**So entry 67.1 points 1 to 4 stand, confirmed.**

- The surface tests stay in SSORT and link to the plan.
- The pre-deployment checklist's primary is DL-1.
- SSORT keeps its checklist as a copy.
- None of it is compulsory yet.

On top of that, **the matrix is not the end product.** It is the working view, filled progressively from the day the BOP
lands. **It populates the pre-deployment checklist**, and that checklist is agreed and **signed off by everyone before the BOP
is deployed**: a flight checklist, for accountability.

### 68.2 — What "like a flight checklist, for accountability" asks of the design

Suggestions from the tools side, for Lee and the dashboard to accept or change. Each says why.

1. **Populated, not typed.** Every checklist line comes from the matrix: its state, its evidence link, who updated it and
   when. Nobody types "Yes" on the signing day. **Why:** the signature is then over evidence, not over somebody's memory of it.
2. **No line left open at signing.** Sign-off is possible only when every line is **complete** or **N/A with a reason**.
   An open line blocks signing and is named, the way SSORT's post gate names the missing photographs (README §8). **Why:** a
   flight checklist is not signed with items skipped.
3. **The signature freezes what was signed.** At the first signature the checklist is **snapshotted**: its content, its
   evidence list and a hash of the two. Every signature records the snapshot it was given against. **Why:** "I signed this" must
   always point to exactly what was on the page.
4. **A change after signing re-opens it.** If anything changes after the first signature, a new revision is cut and all the
   signatures already given lapse and are asked for again. That covers a line, a re-posted test record or a replaced
   photograph. The old revision is kept, signed, as history. **Why:** otherwise a signature could stand over a page it never
   saw.
5. **Who signs, in what order.** The five roles on FRM-00-0168 today are TSL, SS Supervisor, Rig Manager, Operations Director
   and Well Control Equipment Manager. Whether the order matters (rig first, shore last?), and whether any role can delegate,
   is for the department review. The design should allow either.
6. **Identity, not a typed name. This is the point that matters most for accountability.**
   - Today a sign-off in SSORT is a **typed name and date** (`pdc_so<i>_name` / `_date`), posted through an intake that
     authenticates nobody. Anyone can type anyone's name.
   - For the deployment sign-off, each signature should come from a **signed-in identity**: the person's Seadrill (Entra)
     account, with the time from the server, not the device.
   - The tenant already has two ways to do that, both standard: **Power Automate Approvals** (an approval per role, answered in
     Teams or Outlook, recorded with the approver's account), or a sign-off page behind Seadrill sign-in.
   - **Lee and the dashboard to choose.** Neither of the two tools can provide this today, and SSORT should not pretend to.
7. **One "go" record.** When the last signature lands, the record (`kind: "pdc-signoff"` or whatever you name it) carries:
   the plan, the BOP, the revision, the hash, and the five signatures with identity and time. It is posted, filed with the
   plan, and **shown on the dashboard as the deployment go**. If any line is N/A with a reason, the go record lists those
   lines, so they are signed knowingly.
8. **The SSORT copy's place.** On a DL-1 rig, a SSORT checklist linked by the button is **evidence feeding the matrix**, never
   a substitute for the signed DL-1 checklist. On a rig not yet on DL-1, SSORT's checklist is what is signed today, typed
   names and all. That is a known gap until the rig moves to DL-1, and should be said so in the ORR.

### 68.3 — For Dan

- **Identity (68.2.6) is the decision that sets the build.** An Approvals flow is the quickest route: the tenant has it and the
  dashboard already builds flows. A sign-in page is the alternative. Either way, typed names stop counting for deployment
  sign-off on DL-1 rigs. Your call, with Lee.
- **The ORR known-error log gains one line now:** *"SSORT pre-deployment sign-off is a typed name; not an authenticated
  signature."* That is honest, and it is what the DL-1 sign-off closes.

### 68.4 — On the SSORT side

Nothing is built now:

- **SSORT's checklist keeps working** exactly as today.
- **The Link to plan wording** on a SSORT checklist ("the SSORT copy, as evidence") changes when DL-1's checklist tasks exist,
  because it depends on how DL-1 names them.
- **If DL-1 adopts a `slot` field on photographs (67.2), SSORT adds it too**, additively.

---

## Entry 67 — Reply to your 12 Oct alignment check: your reading 1–4 is right and entry 62.1 overstated it; what DL-1 should keep identical; the matrix

**Rev: none.** Status: **NEEDS ACTION by Dan**: confirm 1–4 (67.1). Nothing is built on it until he does.

### 67.1 — (a) Your reading matches; entry 62.1 overstated it. Correction

Dan's words to this session on 12 October, in order:

1. *"in the planning tool there will be surface testing, so a task will be EHBS, ACOUSTIC, EDS, PRESSURE TEST, FUNCTION TEST
   … we do not want them to redo the checklists in the planning tool. they can do them in SSORT, and SSORT has a button which
   posts to predeployment and can then be used as evidence, which links them."*
2. *"**the predeployment checklist will be in the planning tool under predeployment**, and we will certainly be adding 'surface
   testing complete'; this will depend on evidence and attachments."*

Entry 62.1 read "the checklists" in (1) as including the pre-deployment checklist, and wrote *"the tests and the
pre-deployment checklist are done in SSORT, once."* Sentence (2) says otherwise, and it agrees with what Dan told you: *"we need
to move the pre-deployment checklist to Lee's tool … check pre-deployment status as we go"* (12 Oct) and *"Lee builds the
checklist and we move it into the planning tool, we can keep a copy in SSORT"* (11 Oct). **"The checklists" in (1) were the
test records (EHBS, EDS, function test and so on), not FRM-00-0168.** That was my misreading, and this entry corrects 62.1.

**So your 1–4 is our reading too:**

1. **The surface tests stay in SSORT**, once, and link to the plan's test tasks. Entries 62 and 64 are unchanged for the tests.
2. **The pre-deployment checklist's primary moves to DL-1.** The rig fills it there as it goes. DL-1 posts it progressively,
   and the matrix shows each row's state from the day the BOP lands.
3. **SSORT keeps its checklist tile as the copy**, for a rig on another template or not yet on DL-1. Nothing is removed. A
   SSORT checklist can still be linked to the plan with the 163 button.
4. **Not compulsory yet.** Templates differ by rig, and the full requirement goes to department review.

**Dan: please confirm 1–4.** The one thing that changes on our side is the Link to plan pre-selection on a SSORT checklist,
which assumed the checklist is a plan task. On a DL-1 rig it becomes "the SSORT copy, for reference". That is a small
wording change, made only after Dan confirms.

### 67.2 — (b) What DL-1 should keep identical, so the two copies are interchangeable

Beyond the pack (`README-PDC-AND-TESTS-SSORT-161.md`), these are what matter:

- **Key names and values, exactly as §2–§7:**
  - `pdc_<n>_resp` / `_rem` for the 21 items, including `M1`: `Yes` / `No` / `""`; item 8 is free text;
  - `pdcbop_*` for the stack;
  - `pdc_elec_*`, `pdc_nc_r<i>_*`, `pdc_exempt`;
  - `pdc_so<i>_name` / `_date`, in the five roles' order;
  - `pdc_ack` as `"1"` / `""`.

  A DL-1 copy written in these keys can be read by anything that reads SSORT's.
- **Photographs: `[{src, caption}]`, with the slot in the caption** (`UBSR — FWD`), and only photographed slots in the array.
  If DL-1 can carry the slot as its own field (for example `slot: "UBSR — FWD"`) as well as the caption, better still: the
  caption is editable in SSORT, and a separate slot field would end that ambiguity. **That is the one improvement worth
  making in both tools.** Say so and SSORT adds `slot` too, additively.
- **One stack per checklist on DL-1, two in SSORT.** SSORT holds a dual-stack rig's two stacks in **one** checklist
  (`pdcbop_desig: "Dual"`, then `pdcbop_s1_*` and `pdcbop_s2_*`). DL-1 has **one plan per stack**. The simplest interchange is
  for **a DL-1 checklist to be one stack**, written as `pdcbop_desig: "Single"` with that stack in the `s1` slots and the plan's
  `bopNo` saying which BOP it is. Anything reading SSORT copies of dual rigs then splits `s1` and `s2` by stack. Please confirm
  that is how DL-1 wants it.
- **The post gate as a floor, not a ceiling.** SSORT refuses to post until four things hold: designation set, cavities
  chosen, packers confirmed **Yes**, and cavities × 2 photographs in each of the three sections (README §8). DL-1 posting
  progressively means it posts *before* those hold, which is right for a matrix. But **"complete" on DL-1 should never mean
  less than SSORT's gate.** The department review may make it more (items, sign-offs), and SSORT would then follow DL-1, not
  the other way round.
- **`complete`**, your handoff Q5, is new to `pdcData`, and is fine to add. SSORT's copy will carry it too: it is `true`
  exactly when SSORT's gate passes, so a SSORT copy and a DL-1 copy mean the same thing by it.
- **`meta.reporttype: "Pre-Deployment Checklist"` and `meta.planid`** on DL-1's posts, so the scanner files both copies the same
  way. The form reference stays **FRM-00-0168 Rev 8** until the review changes it. Both tools should then move together.
- **If both copies exist for one plan** (a rig filled SSORT and DL-1), the scanner needs one rule. Ours: **DL-1's copy is
  primary on a DL-1 plan**, and a linked SSORT copy is shown as a reference. Your call to set it.

### 67.3 — (c) The matrix: yes, with four refinements

The rows you list are right: the 21 items, the per-cavity rows, and the nine tests. The four refinements:

1. **The per-cavity row is one row per cavity per stack, with six photograph cells:** ram packer, cavity sealing face and door
   sealing face, each FWD and AFT. Its state comes from the cells: complete only at 6 of 6. That keeps the matrix the same
   shape as SSORT's three sections, read across instead of down.
2. **Add the rows that are not items but are evidence**, so "status as we go" has nothing hidden:
   - the stack table, one row per position (install date, part / serial numbers, cycles);
   - the packer confirmation;
   - electrical: the checks, the two RARS ticks, and the three photograph sets;
   - non-compliance / PMs;
   - exemption;
   - the five sign-offs;
   - the acknowledgement.
3. **States:** not started · in progress · complete · evidence linked, as you have them, plus **N/A**. N/A is for an item that
   does not apply, and for **Acoustic on West Vela, West Neptune and Sevan Louisiana**, where there is no system. An N/A needs a
   reason, the same rule SSORT's function test applies.
4. **Tests:** seven rows complete on a linked SSORT record; PRESSURE TEST and DRIFT complete on an attachment in the plan.
   **"Surface testing complete"** is all nine complete, or N/A with a reason.

Nothing is built on this side until Dan confirms 67.1. The department review may change the requirement, and if it does,
SSORT's copy follows DL-1.

---

## Entry 66 — SSORT 163 DEPLOYED (12 Oct), which ships 162 with it. Maximo's own group names used; where the SFI workbook lives

**Rev: SSORT 163, DEPLOYED 12 October 20:46 on Dan's go** (*"Build and deploy brother"*). sha256 `825de795e869fd9d9007d4b7e9689eeb5f0ca46e75f2e27db556076c38b857ed`,
7,345,170 bytes. Hash-verified on the share. Smoke-tested through IIS, nothing posted:

- the plan picker read **your live v2.89 `plans-open.json`** (scanner 2.89, no plans yet) and says "No open plan for West
  Capella. Posts go out as normal.";
- the SFI list unpacked (West Capella, 570 codes);
- the precharge request opens.

**Live: SSORT 163, WCGRRT 169.** Status: **FYI**, plus one question for Dan (66.2).

### 66.1 — What changed since entry 65's build

- **Group names: Maximo's own, from your note.** I used the CoC tracker's `sfiGroups` wherever Maximo has a name:
  331 BLOWOUT PREVENTER STACK · 332 BLOWOUT PREVENTER CONTROL SYSTEM · 334 DIVERTER WITH CONTROL SYSTEM · 335 RISER SYSTEM INCL.
  CHOKE, KILL LINES · 336 CHOKE AND KILL SYSTEM INCL. MUD/GAS SEPARATOR · 337 MISCELLANEOUS WELL CONTROL RELATED EQUIPMENT ·
  339 MANAGED PRESSURE DRILLING. So SSORT, the CoC tracker and Maximo name them identically.
- **302, 314 and 315 have no name in `sfiGroups`**, so they keep derived names in the same style: HEAVE COMPENSATION & CROWN
  BLOCK · RISER & GUIDELINE TENSIONING · HP COMPRESSED NITROGEN. If Maximo has names for these three, send them and they
  replace these.
- Rebuilt before deploy, because 163 had not shipped; 65's hash is superseded by the one above. The codes are unchanged:
  28,916.
- **64.4 is closed** by your entry: no flow reacts to `seadrill-planlink_`, and v2.89 was already installed and writing the
  plan list before 163 went out, as you asked.

### 66.2 — The workbook: where it lives and how often (your ask)

SSORT 163 embeds `TS - Well Control Assets and Locations.xlsx`, sha256 starting `48989c496379`, as Dan sent it on 12 October.
It is a **snapshot**: SSORT does not read the workbook live. It is offline, single-file, and runs on the rig.

**Today the workbook is a file Dan attached, held in his Downloads.** It is not yet in a shared, versioned place.

**Proposal:**

1. **One copy, in one place.** It should live where your scanner already reads, beside the source for item 45
   (`maximo-reference.json`). Dan to say where, and who exports it from Maximo.
2. **On each refresh**, the scanner regenerates `maximo-reference.json`, and the tools session regenerates SSORT's embedded
   list from the **same** file. That is one SSORT revision, announced here with the workbook's sha256, so the three tools agree
   on codes by construction.
3. **How often:** Dan's call. Maximo's tree changes slowly, so after each campaign or quarterly is probably enough, plus on
   demand when a rig reports a missing code.

---

## Entry 65 — SSORT 163: the Technical Assistance Request picks the equipment by SFI code. Four new keys, announced before they ship

**Rev: SSORT 163, built and tested 12 October; NOT deployed.** sha256
`c15d88bfbaf5881ceca1bf08bf15bd6c5c39972562cb1f9319e17d2ff5ed41d1`, 7,345,278 bytes. **163 is built on 162** (the plan
picker and Link to plan, entry 64), so **deploying 163 ships 162 too.** Status: **NEEDS ACTION**: the four keys below, plus
64.4 still open.

**Dan, 12 October:** *"on the equipment manufacturer in the help requests tool in SSORT we need all of the SFI codes, see
attached a new list of SFIs, so the team can pick from a dropdown."* The list is `TS - Well Control Assets and
Locations.xlsx`, a Maximo export: ten SFI groups and 34,167 rows.

### 65.1 — What the crew sees

The help request's Equipment affected gets an **SFI** row above it:

- **An SFI group dropdown** with the ten groups and a count for the rig.
- **A search box** listing that rig's codes in the group (or in all groups) as `331.BOP1.200 — NOV SHAFFER 18 3/4" 10K BIG BOY
  ANNULAR`, with the manufacturer and model shown beside each suggestion. The crew types part of the code, the description or
  the manufacturer.
- **Picking a code** fills Equipment affected (manufacturer / model), unless the crew has typed there, and shows the Maximo
  asset number.
- Text that is not a code on the list is flagged and **not** sent as an SFI. The free-text box still works, so nothing is
  ever blocked.
- **The list follows the rig.** Another rig's pick is never sent.

### 65.2 — The data

- **Scope:** every location code below group level, levels 2 to 4 (for example `331.BOP1`, `331.BOP1.200`,
  `331.BOP1.300.010`), for the **14 rigs in SSORT's rig list**: **28,916 codes**. Each code carries its description,
  manufacturer, make/model, Maximo asset number, and any status other than OPERATING.
- **Not included:** West Elara and West Aquarius, which are not in SSORT's rig list (stacked: Dan, 11 Oct). They are added
  with the rig.
- **Packing:** the list is gzipped inside the file (2.9 MB of JSON becomes 387 KB) and unpacked in the browser only when the
  request form opens; that takes about 0.2 s. SSORT stays one file and works offline.
- **Fallback:** a browser that cannot unpack it gets the free-text box only. Edge and Chrome can.
- **Group names.** The workbook names no groups, so these are taken from the systems in each group. **Dan, please correct any
  of them:** 302 Heave compensation & crown block · 314 Riser & guideline tensioning · 315 HP compressed nitrogen · 331 BOP
  stack & LMRP · 332 BOP control system · 334 Diverter system · 335 Marine riser · 336 Choke & kill / mud gas separation ·
  337 Well control test & support equipment · 339 Managed pressure drilling (MPD).

### 65.3 — The keys, new on the help request

Top-level strings, `""` when no code is picked. They are camelCase, like the rest of the help record your contract
defines (`requestId`, `occurredAt`):

| Key | Example | `fieldLabels` |
|---|---|---|
| `sfiCode` | `331.BOP1.200` | SFI code |
| `sfiDescription` | `NOV SHAFFER 18 3/4" 10K BIG BOY ANNULAR` | SFI description |
| `sfiGroup` | `331` | SFI group |
| `maximoAssetNo` | `C1004805` | Maximo asset number |

They also appear in two other places:

- **in `description`**, so they reach the email and the chat: `SFI: 331.BOP1.200 — …` and `Maximo asset number: C1004805`,
  first among the FRM lines;
- **on the FRM-00-0169 copy**, in row 5 (Equipment affected).

**For Fabric:** `maximoAssetNo` is the same Maximo asset number the CoC tracker keys on, so a request can be joined to the
asset and its certificates.

### 65.4 — Verified on 163 (posting stubbed, nothing posted, test data cleared)

- **The picker:**
  - the list unpacks in about 0.2 s;
  - West Capella has 570 codes, 74 of them in 331;
  - picking `331.BOP1.200` fills the manufacturer/model box and gives `C1004805`;
  - free text is refused as an SFI;
  - after a rig change, the list follows the rig and the old pick is dropped;
  - the draft keeps the pick, and resolves it again once the rig is set;
  - New request clears it.
- **The post:** the payload carries all four keys and their labels; the description and FRM row 5 carry the SFI and the
  asset number.
- **Build checks:**
  - byte-identical: the precharge panel, `sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportFileName`, `dlPostPayload`,
    `tarqSend`, `sdLinkToPlan` and `sdSizeOk`;
  - post and fetch call counts unchanged;
  - no `no-cors`; the 0.82 count unchanged.

---

## Entry 64 — SSORT 162 built: the plan picker and `meta.planid` (stage 1), Link to plan on tests and the checklist (stage 2). Keys announced before they ship

**Rev: SSORT 162, built and tested 12 October; NOT deployed.** sha256
`6e77b534c94b4ebdad4eaf974dd7eafcf9102e597a91c7f95aba90a47a8db2f2`, 6,952,159 bytes (161: 6,936,884). Dan: *"build stages 1
and 2 now"*. Status: **NEEDS ACTION**: 64.4 (one check before it ships).

### 64.1 — Stage 1: the plan picker, and `meta.planid`

- **Where:** Vessel Information, under Log Date, **"Maintenance plan (DL-1)"**.
- **What it lists:**
  - the rig's plans from `plans-open.json`, fetched on load from `/sacred/dl1/plans-open.json` on the same server
    (`http://sdrlazneuiis01d.corp.local:8080/...` when SSORT runs from a file);
  - each plan's `title · planId`, matched on `rigKey`, or on `rig` as a fallback;
  - `closed` plans greyed out and not selectable;
  - "Type a plan id…" for a rig that cannot reach the server.
- **What it picks:**
  - The rig's **only** open plan is picked automatically.
  - With two or more (a dual-stack rig), nothing is picked until the crew chooses.
  - The last plan a viewer picked for a rig is remembered in that browser.
- **Typed plan ids** must look like `WVE-BOP1-20261005`, or they are not sent.
- **Guards:**
  - a closed plan is never sent;
  - **another rig's plan is never sent**. SSORT changes the rig in places that fire no change event, so the picker
    re-checks every 1.5 s and `sdPlanId()` refuses a listed plan for a different rig.
- **`meta.planid`**, a new key: lower case, additive, a string.
  - It is on every post built by `buildReportPayload` while a plan is selected: Post Report, the dashboard copy behind Post
    to OEM, and the monthly Daily Log archive.
  - **It is absent when no plan is selected**, so those posts are exactly as before.
  - **It is not in the file name.**
  - Load Saved Report and Load from file bring it back.
  - The Daily Checks rounds post through `dlPostPayload`, which is untouched; they carry no plan id until stage 3.
- **With no `plans-open.json` yet**, the picker says "No open plan for <rig>. Posts go out as normal." Nothing else changes.

### 64.2 — Stage 2: 🔗 Link to plan

**Where:** on every **Surface BOP Testing** tile and the **Pre-Deployment Checklist** tile.

**What it does, in order:**

1. **Refuses** in each of these cases, saying why, and posts nothing:
   - no rig;
   - no plan picked;
   - the plan is not in the list (offline, or typed);
   - no test type on the tile;
   - **the workspace posts as a different report type** (RT KE-03: a workspace posts as one type, so a link from a test
     tile in a CBM workspace would point at the CBM).
2. **Shows the plan's tasks**, grouped by section, **pre-selecting** where it can:
   - for a test, the `type:"test"` task whose `testType` equals the tile's test;
   - for the checklist, the Pre-Deployment task with `type:"checklist"`, or a name containing "checklist".
3. **Posts the record first**, exactly as Post Report would: the same `buildReportPayload`, `sdPdcComplete('post')` gate,
   `sdSizeOk` and `reportFileName()`. So it **replaces** any earlier post of the same record.
4. **Then posts the link record.** If the record did not reach the server: "NOT linked", and no link is sent. If the link
   did not: "press again"; a second press re-posts the record under the same name, then links.
5. Shows a badge on the tile, e.g. "🔗 EHBS · WVE-BOP1-20261005".

**The link record**, new, announced here:

```
filename  seadrill-planlink_<rigkey>_<planid>_<yyyyMMdd-HHmmss>.json        (UTC)
{ meta:{ kind:"plan-link", tool:"SSORT", rev:"SSORT REV 162", asset, rigkey, saved, by },   by = Vessel Information SSS
  planid, taskid, taskname, section, action:"link",
  source:{ file, reporttype, testtype, date },                                file = the record's exact posted name
  linkid }                                                                    a GUID
```

`taskname` is the task's name as the plan gave it. It is added for whoever reads the file and is not needed for the join.
**Unlink** (`action:"unlink"` with the same `linkid`) is designed in entry 62.3 but **not built**. Say if you want it before
the first plans post.

### 64.3 — Verified

Tested on 162 with a test `plans-open.json` in your exact shape: West Vela BOP1 (nine Pre-Deployment tasks with their
`testType`s, and a maintenance WO), West Vela BOP2, a closed West Vela plan, and a West Capella plan. `sdPostReport` was
stubbed to record, so nothing was posted. Test data cleared.

**Stage 1:**

- no rig: "Pick the rig first";
- West Vela: two open plans, nothing auto-picked, the closed plan greyed;
- West Capella: its only plan auto-picked;
- a silent rig change from Capella to Vela never sends Capella's plan;
- a typed bad id is refused, a typed good id is sent;
- no plan: no `planid` key;
- the file name is unchanged (`seadrill-report_West-Vela_2026-10-12.json`);
- Load from file restores the plan.

**Stage 2:**

- EHBS tile: EHBS pre-selected; the record (`..._surface-bop-testing_EHBS-Testing.json`, carrying `meta.planid`) posted,
  then `seadrill-planlink_vela_WVE-BOP1-20261005_<stamp>.json` with `source.file` equal to the record's name;
- checklist: the incomplete one is stopped by the existing post gate; the complete one pre-selects PRE-DEPLOYMENT
  CHECKLIST and links;
- refusals checked: record post failed (no link sent), mixed workspace, plan not listed, no plan.

**Build checks:**

- byte-identical: the precharge panel, `sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportFileName`,
  `sdPostDiscriminator`, `dlPostPayload`, `reqSetType`, `sdSizeOk`, `sdPdcComplete` and `tarqSend`;
- exactly 2 new `sdPostReport(` calls (the record, then the link);
- exactly 1 new `fetch(`, a plain GET of the plan list, with no `no-cors`;
- the 0.82 count and `CBM_SCHED` are unchanged.

### 64.4 — One check before Dan deploys

**Will a `seadrill-planlink_*` file reaching PostedReports before scanner v2.89 is installed do any harm?**

- It cannot happen through the button, which needs a plan from `plans-open.json`, which only v2.89 writes.
- What does reach you early is `meta.planid` on ordinary posts, if a crew types a plan id. That is an additive key your
  scanner ignores until it knows it.

So 162 should be safe to deploy before v2.89. Please confirm that no flow treats an unknown `seadrill-planlink_` prefix as a
report, and we will deploy on Dan's go.

---

## Entry 63 — Reply to your 61/62 answers (12 Oct): the plan structure is agreed on your side; SSORT stage 1 is ready to build on Dan's word

**Rev: none.** Status: **FYI**, nothing owed by you.

Read and agreed in full:

- the link record and `meta.planid`, not in the file name;
- SACRED makes the copies, refreshed on re-post, keyed on `source.file`;
- **`plans-open.json`** as defined (scanner v2.89), served at `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/plans-open.json`;
- one plan per stack, and a post carries one `planid`;
- the plan id stays the same for a campaign (`scopeVersion` moves instead);
- the picker shows `title`, with `planId` underneath, and greys out `closed` plans;
- tasks come from DL-1 `plan.tasks[]`, pre-deployment tests as `type: "test"` with SSORT's `testType`.

**What it means for SSORT's stages (`PLAN-SSORT-LINK-TO-PLAN.md`):**

| Stage | What | Can it be built now? |
|---|---|---|
| 1 | Plan picker under Vessel Information, from `plans-open.json`; `meta.planid` on posts | **Yes.** Your shape is enough. It can only be **tested end to end** once DL-1 REV 11 posts a first plan and v2.89 writes the file. Until then the picker says "no open plan for this rig" and posts are unchanged |
| 2 | 🔗 Link to plan on surface tests and the pre-deployment checklist; the `seadrill-planlink_*` record | **Yes** for maintenance tasks. Test pre-selection needs DL-1's `type: "test"` tasks (REV 11) |
| 3 | Link to plan on the daily log | once DL-1 defines the daily section's tasks, or links to the section itself |

**Two notes for the build:**

- **SSORT on the server fetches the file over http, same origin as `/SSORT/`.** A rig running SSORT from a saved file
  cannot fetch it, so the picker keeps the type-in fallback: the crew types the plan id. It is validated against the
  `<rig>-<BOP>-<YYYYMMDD>` pattern only.
- Your file uses `planId` / `rigKey` (camelCase) because it is your file. SSORT's own new keys stay lower case (`meta.planid`,
  and the link record's `planid`, `taskid`), per Dan's rule.

Nothing is built until Dan says go. When he does, the keys are announced here before shipping.

---

## Entry 62 — Dan's direction on DL-1 (12 Oct): checklists stay in SSORT, the plan links to them. "Link to plan" is announced here, held until the plan structure is agreed

**Rev: none — intent only, nothing is built.** To the dashboard **and to the DL-1 / planning-tool side (Lee Arnold)**. Status:
**FYI + three questions (62.5)**, no deadline. This entry refines 61.2 and replaces what it proposed.

### 62.1 — What Dan decided

Dan, 12 October:

> *"in the planning tool there will be surface testing, so a task will be EHBS, ACOUSTIC, EDS, PRESSURE TEST, FUNCTION TEST,
> the person updating the plan will tick whether these are done and attach evidence which will automatically post to the
> correct folder structure. we do not want them to redo the checklists in the planning tool. they can do them in SSORT, and
> SSORT has a button which posts to predeployment and can then be used as evidence, which links them … we would also like this
> button that links daily logs etc too. so keep it in the plan to add later when we get the structure right but notify the
> planning tool and dashboard of the intent and how we would do it."*

So:

- **The tests and the pre-deployment checklist are done in SSORT, once.** The planning tool does **not** rebuild them. **⚠ Corrected by entry 67: the pre-deployment checklist's primary moves to DL-1; only the surface tests are done once in SSORT.**
- **The plan holds tasks**: EHBS, ACOUSTIC, EDS, PRESSURE TEST, FUNCTION TEST and the rest, plus a **Pre-Deployment**
  section. A task is ticked with evidence.
- **"Surface testing complete"** in the plan depends on that evidence.
- **SSORT gets a "link to plan" button.** It sends a record from SSORT (a test, the pre-deployment checklist, a daily log,
  and so on) to the plan as evidence for a task.
- **Held until the plan's structure is agreed.** This entry says how we would do it, so both sides can build towards the same
  thing.

### 62.2 — What the entry 61 appendix is for now

The key-by-key appendix (`PDC-HANDOFF-DL1.zip`) is **reference, not a ticking source.** The plan ticks a task when the evidence
record exists; it never needs to read the values inside a test.

The appendix has two uses:

1. **The only thing DL-1 needs from it** is §8 of the README: what SSORT already treats as a complete pre-deployment checklist.
2. **Dashboard: it may be useful for the Fabric database** as a data dictionary: every SSORT surface-test key with a
   human-readable label, per rig. SSORT posts no labels for those keys (61.1 finding 3). Take it if it helps; it costs us
   nothing either way.

### 62.3 — How we would do it: link, don't copy

**One principle:** the record stays where it is, a normal SSORT post in PostedReports, and **a small link record says
"this record is evidence for this task of this plan".** Nothing is posted twice, a corrected re-post of the record still
replaces it as today, and a wrong link can be withdrawn without touching the evidence.

**The button.** It is **🔗 Link to plan**, on:

- each surface-test tile;
- the pre-deployment checklist tile;
- the daily log;
- later, any report you want (CBM, rig visit).

It:

1. needs a plan open for the rig (from `plans-open.json`, entry 61.3);
2. shows that plan's tasks and lets the crew pick one, pre-selected where the record type matches (62.4);
3. **posts the record first** if it has not been posted, through the normal Post Report with its normal name, so the evidence
   is in PostedReports before anything points at it. This is the same order as Post to OEM (entry 42.5);
4. then posts the link record;
5. tells the crew which task it is now evidence for.

**The link record**, new and small, carrying no photographs and no data from the source:

```
filename   seadrill-planlink_<rigkey>_<planid>_<yyyyMMdd-HHmmss>.json      (UTC stamp)
meta       { kind: "plan-link", tool: "SSORT", rev, asset, rigkey, saved, by }
planid     the DL-1 plan id, e.g. "WVE-BOP1-20261005"
taskid     the DL-1 task id within that plan
section    "predeployment" | "surface-testing" | "daily" | ...   (as the plan defines them)
action     "link" | "unlink"
source     { file: <the source post's exact file name>, reporttype, testtype, date }
linkid     a GUID, so an "unlink" names the link it withdraws
```

The **join key is `source.file`**. That is the source report's file name, exactly as SSORT posted it. It is the same idea as
the OEM copy's `sourceFile` (entry 51.2), which the "Sent to NOV" chip already matches on.

**Folders.** The folder structure is yours. The scanner (or the planning tool) reads `seadrill-planlink_*`, finds the source
by `source.file`, and files or shows it under `<plan>/<section>/<task>`. Whether that means copying the file into a plan folder
or indexing it in place is your call.

**The plan id on the record itself (61.2), as well:** `meta.planid`, lower case per Dan's rule for new keys rather than the
`planId` you suggested. It is set on every SSORT post made while a plan is selected, so the scanner can file **unlinked**
records by plan as well. As 61.2 said, **not in the record's file name**, so re-posting still replaces.

### 62.4 — The pre-deployment tests, and where each one's evidence comes from (Dan, 12 Oct)

Dan: *"pressure test will be an attachment showing the test charts either digital or analogue, drawdown, soak, drift, function,
pressure, acoustic, rov, eds are all tests that will be done in predeployment"*

So the plan's **Pre-Deployment** section has nine tests:

| Plan task (Pre-Deployment) | Evidence | From SSORT |
|---|---|---|
| FUNCTION TEST | SSORT record, linked | Surface BOP Testing · BOP Function Test |
| SOAK | SSORT record, linked | Surface BOP Testing · Soak Test |
| DRAWDOWN | SSORT record, linked | Surface BOP Testing · Surface Drawdown Test |
| ACOUSTIC | SSORT record, linked | Surface BOP Testing · Acoustic Function Testing (no task on rigs without an acoustic system: West Vela, West Neptune, Sevan Louisiana) |
| ROV | SSORT record, linked | Surface BOP Testing · ROV Function Testing |
| EDS | SSORT record, linked | Surface BOP Testing · EDS Testing |
| EHBS | SSORT record, linked | Surface BOP Testing · EHBS Testing |
| **PRESSURE TEST** | **attachment: the test charts, digital or analogue** | **none.** The charts are attached against the task in the planning tool. SSORT has no pressure-test form and gets none |
| **DRIFT** | **attachment** (confirmed by Dan, 12 Oct) | **none.** SSORT has no drift test and gets none |
| *(section)* Pre-Deployment Checklist | SSORT record, linked | Pre-Deployment Checklist |
| *(daily section)* daily log | SSORT record, linked | daily log |

Seven of the nine tests are linked from SSORT. PRESSURE TEST and DRIFT are files attached in the plan. Nothing about those two
changes in SSORT.

### 62.5 — What we need, when the structure is ready (no rush)

1. **The plan's shape as SSORT will see it** in `plans-open.json`: plan id, sections, task ids and task names, and whether a
   dual-stack rig has one plan per stack (entry 61.3).
2. ~~62.4's gaps~~ **answered by Dan, 12 Oct** (62.4): nine pre-deployment tests. PRESSURE TEST is the charts as an attachment, and DRIFT is an attachment too (confirmed).
3. ~~Link or copy~~ **Answered by Dan, 12 Oct: the plan folders hold copies**, either hard copies or `.json`. The planning
   dashboard reads from them and can print. The format is **for Lee to decide**. The link record in 62.3 is unchanged: it tells
   whoever files the copy which record goes where. **One thing for whoever makes the copy:** when the crew re-posts a corrected
   record, it replaces the original in PostedReports under the same name. The plan's copy should be refreshed from it then, so
   the plan never holds an older version than the record. Re-copy when the source file changes; the `source.file` name is the
   key.

Until then nothing is built. When the structure is agreed, the work is about one SSORT revision: the picker, the button, the
link record and `meta.planid`. Keys are announced here first, as always.

---

## Entry 61 — Reply to your 12 Oct DL-1 asks: the pre-deployment checklist and every test, read off the live tool; the plan reference proposed, with one recommendation against

**Rev: none, nothing shipped.** Live builds: SSORT 161, WCGRRT 169. Status: **NEEDS ACTION**:

- 61.1: the pack is delivered, and four findings in it change your ticking rules;
- 61.3: three questions about `plans-open.json` before we build the plan reference.

### 61.1 — Ask 2: delivered, as `PDC-HANDOFF-DL1.zip`

| File | What |
|---|---|
| `README-PDC-AND-TESTS-SSORT-161.md` | the checklist key by key; the three photograph sections; what "complete" means, from the code; the seven surface tests with their key families; a matrix of rig × test |
| `SSORT-161-surface-test-keys.json` | every surface-test key, in 45 distinct sets, with the rigs sharing each set and a label for every key |
| `SSORT-161-surface-test-keys.csv` | the same, 25,008 rows, one per rig / test / key |

**How it was made.** It was read off the running SSORT 161, not written from memory:

- A pre-deployment checklist was built on the largest form, dual stack with seven cavities each, and every input was read
  (242 keys and 9 photograph arrays).
- Every surface test was rendered on all 15 assets in SSORT's rig list, with every EDS sequence, ROV sheet and EHBS
  shear choice selected in turn.

Saying it plainly because it matters for something Lee will build on: the first passes were wrong in two ways, and I
threw them away.

- Some forms were read before they finished drawing. West Vela and West Neptune showed no EDS keys, when they have 667
  and 478.
- Some labels were wrong. Header fields came out as the whole header row, and merged column headings were misread, so a
  30-minute soak reading was labelled "Start".

The final pass gives identical key counts to the two before it, every key has a label, and one known heading quirk is
corrected and stated in the files (540 pass/fail keys). Nothing was posted.

**Four findings that change what DL-1 can assume:**

1. **"Complete" on the tile is narrower than it looks.** SSORT refuses to post a checklist until four things hold: the
   designation is set; each stack has a cavity count; the ram packers are confirmed **Yes**; and each of the three
   photograph sections has cavities × 2 photographs. It does **not** require the 21 items, the acknowledgement tick or
   the five sign-offs. A posted checklist can have blank items and no signatures. That is DL-1's rule to set; say if you
   want SSORT to enforce more.
2. **A photograph's slot is in its caption, not its position.** Each section posts only the photographed slots, as
   `[{src, caption}]`. The caption is pre-filled with the slot (`UBSR — FWD`), but the crew can edit it.
3. **Surface tests post no labels.** `sbopData` is `{testType, date, soak}`, with filled values only. The appendix is the
   label source, and test keys are rig-specific for EDS, ROV and acoustic.
4. **The elastomer table is gone.** `pdc_el_r*` has code in SSORT but no form renders it; item 10's "sheet below" is now
   the BOP stack table. Old posts may also carry `pdcbop_ph_*` (photographs from before they were per stack).

### 61.2 — Ask 1, the plan reference: what we propose

- **`meta.planId`, additive, on every SSORT post** while a plan is open for the rig: daily log, CBM, surface tests,
  pre-deployment checklist. One value per post, in `meta` like `meta.asset`.
- **Where the crew picks it:** one "Maintenance plan" picker under Vessel Information, filled from `plans-open.json` for
  the rig. It defaults to the rig's single open plan when there is exactly one, can be set to none, and has a type-in
  fallback for a rig running SSORT from a file with no server.
- **Not in the file name. This is our recommendation against your ask, and it is Dan's call (file names are his rule):**
  - **A plan attached after a first post would change the name**, so the corrected re-post lands as a second row
    instead of replacing the first. That is exactly the 158 lesson (entries 51–53).
  - **You said names are not load-bearing.** The scanner reads `meta`, and `meta.planId` is in every post.
  - **The names are already long.** CBM names carry the equipment and the serial or model.

  If Dan wants it in the name anyway, the position would be `..._<report-type>_<planId>[_<equipment...>].json`.
- **Timing:** you asked for the first revision after the class. It can go sooner; Dan decides. It is only useful once
  DL-1 posts plans and the scanner writes `plans-open.json`, so nothing is lost by waiting for that.

### 61.3 — What we need from you for ask 1

1. **`plans-open.json`**: its path on the share, and its shape. We assume something like
   `[{ planId, rigKey, rig, stack, title, opened, closes }]`. Which fields should the picker show?
2. **One plan or several per rig?** A dual-stack rig may run one plan per stack. Should the picker offer both, and should
   a post ever carry two plan ids?
3. **Does the plan id change during a campaign** (a revision, a re-issue)? If so, should a post carry the id it was made
   under, or the latest?

---

## Entry 60 — The Technical Assistance Request is built (SSORT 161), against your live flow. The keys, and eight questions before it goes live

**Rev: SSORT 161. DEPLOYED 11 October 18:11 on Dan's go, after his practice send landed end to end** ("test sent, all landed, deploy it"). Hash-verified on the share; smoke-tested through IIS, nothing posted. sha256
`a5da5eacfcc7878e45e7a509cae60708127bb701cd3f3da920ae31a694bc14f9`, 6,936,884 bytes (rebuilt after your 60.4 answers, 60.6, and with the FRM copy, 60.7). Status: **NEEDS ACTION**
— answer 60.4 before Dan deploys; 60.5 is the end-to-end test Dan runs.

**Dan, 11 October:** *"build it before the 15th, ask the dashboard what you need, this goes into ssort as a drop down
in requests, technical assistance request next to precharge requests. forget about the 15th we are plowing"* — and
*"we have also built the flow since then so you will need more info surely before its fully built and deployed"*.

**SSORT only, by Dan's instruction.** WCGRRT has no Requests tab and gets nothing in this revision.

### 60.1 — Where the crew finds it (your question 1)

**SSORT → 📨 Requests tab → Request Type → *Technical Assistance Request*.** It sits in the same dropdown as the BOP
Precharge Request. The rig is the one picked at the top of the tab.

- **Reachable with no report open.** The Requests tab needs no tiles, no trip and no posted report. That covers
  the 30-minute case.
- The ❓ Help / Feedback tab is still the tool-feedback email (entry 59.1) and is not this.

### 60.2 — What the crew sees

- **Mode**: RIG DOWN (DT) or BOP EQUIPMENT FAILURE (non-DT).
- **Required**: subject, date and time of occurrence, description of the event, and who is raising it.
  - The subject is capped at 120 characters, with a counter.
  - The occurrence time is shown in UTC beside the local time it was entered in.
  - Who is raising it defaults to the Vessel Information SSS.
- **The FRM-00-0169 fields** as on the form: expected duration, equipment affected, immediate actions, causes,
  solution or troubleshooting, OEM ticket, remote diagnostics, parts, tools, additional resources, conference call.
  Also contact on board. Synergi case is optional.
- **Current hrs NPT** is worked out from the occurrence time and can be typed over. It is rig down only.
- **The DIR-00-0116 checklist**, live from the occurrence time, showing only what applies:
  - always: the Synergi case due 07:00 local the next day (shown as a clock time), and the OEM ticket;
  - over 2 hrs: ATT-00-0028-ENG;
  - 6 hrs or more: the Flash Alert due at occurrence + 12 hrs, and the note that the flow creates the directive
    chat;
  - over 24 hrs: the recovery plan.

  It says **MANDATORY NOTIFICATION** at 6 hrs or more, rig down.
- **Photographs and documents**, through SSORT's existing CBM attachment reader, unchanged:
  - the same whitelist (nothing executable) and the same 8 MB warning / 20 MB refusal per file;
  - photographs compressed to 1600 px, JPEG 0.82.
- **Practice send**: a box that sets `dryRun`, office only, for the class. `SSCE Equipment` is also flagged on
  the form as office-only.
- **Send**:
  1. Validates the required fields.
  2. Shows a confirm naming who will be emailed.
  3. Posts through the unchanged `sdPostReport`.
  4. On success it shows your §1.2 wording verbatim (*"Received by the server. … within ten minutes."*), never
     "sent", and **locks**.
  5. On failure it says plainly **NOT received — nobody has been emailed**, saves the request as a file, and
     tells the crew to email it to technicalservices@seadrill.com and phone the office. Send stays available
     for a retry.
- **The draft survives a crash or reload**, including the `requestId`, so a retry joins the same record.

### 60.3 — The payload: announced here before it ships

Filename `seadrill-help_<rigkey>_<yyyyMMdd-HHmmss>.json`, the stamp in UTC. It goes to the same intake as every
report, through `sdPostReport` unchanged.

```
meta          kind "help", reporttype "TSC Assistance Request", tool "SSORT", asset, rigkey, date, saved (ISO),
              rev "SSORT REV 161", sss (= Raised by), tsl "", rigmgr "", arigmgr "", form "FRM-00-0169"
requestId     crypto.randomUUID(), made once per request, kept in the draft
notifyKind    "mandatory" when rig down and >= 6 hrs since occurredAt at send, else "assistance"
rigDown       boolean
hoursDown     number: the crew's figure, or computed from occurredAt; 0 when not rig down
occurredAt    ISO UTC
synergiCase   string, often ""
subject       string, <= 120
description   the crew's description, then a blank line, "FRM-00-0169", and one "Label: value" line per
              answered field. YOUR EMAIL CARRIES ONLY description, so this is how the form reaches the inbox
dryRun        boolean (the Practice send box)
attachments[] {name, type, bytes, data}   data = BARE base64, so your blobUrl/atob and base64ToBinary both read it
photos[]      {name, type, caption "", data}   data = data URI (image/jpeg after compression)
expectedDuration, equipmentAffected, immediateActions, causesIdentified, solutionStatus, oemTicket,
remoteDiagnostics, partsRequired, toolsRequired, additionalResources, conferenceCall, raisedBy, contactOnBoard
              top-level strings, always present, "" when unanswered: your fields{} capture
fieldLabels   {key: "the FRM-00-0169 wording"} for the 13 keys above (an object, so not in fields{})
```

**Rig keys** come from the live `help-data.js` `rigCodes` (11 Oct): `nov` West Neptune, `cam` Sevan Louisiana, the
eleven by name, and `ssce` SSCE Equipment. **West Phoenix is not in your list** (see 60.4.4).

**Verified on 161** (`fetch` and `sdPostReport` stubbed, nothing posted, test data cleared):

- the payload validates against your flow's Parse JSON schema, every key and type;
- the PDF's bare base64 decodes to `%PDF`; the photo is a JPEG data URI;
- seven hours down gives `mandatory`, 45 minutes gives `assistance`;
- an `.exe` is refused;
- an empty send lists what is missing and posts nothing;
- the failure path saves the file and keeps the `requestId`;
- a reload restores the draft;
- the precharge request still opens.

Build checks: every script block parses and there are no duplicate declarations. Byte-identical: **the precharge
panel and its script** (25,559 characters), `reqSetType`, `reqSetRig`, `reqSyncRig`, `reqApplyRigToPanel`,
`sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportFileName`, `sdPostDiscriminator`, `sdReadAttachment` and
`sdSizeOk`. Exactly one new `sdPostReport(` call, no new `fetch(`, and the 0.82 count is unchanged.

### 60.4 — What we need from you before Dan deploys (Dan: "you will need more info")

Built from your 29 Sep reply, `INTEGRATION-CONTRACT.md` (Assistance request row), `TSC-HELP-NOTIFICATIONS-FLOW-GUIDE.md`
(Parse JSON schema, the email body) and the live `help-centre.js` / `help-data.js`. **You have built and changed the
flows since**, so:

1. **Is the schema above still what `TSC Help Notifications`, `TSC Help Acknowledgements` and `TSC Help Six-hour
   Chat` parse today?** Have any keys been added, renamed or made required since the guide we hold? If the email body
   now carries more than `description`, say which keys, and we will stop folding the form into `description` if you
   prefer.
2. **A second post with the same `requestId`.** Your trigger fires on every new `seadrill-help_` file. So a re-post
   would email everyone again and create a second assistance chat. **161 therefore sends once and locks**; further
   information goes in the chat or the email thread. If you want in-tool updates (the Synergi number later, say),
   tell us the shape. An `isUpdate: true` the flow skips is one option. Until then, one send per request.
3. **`fieldLabels`** — will the Help Centre use it to label the FRM fields, instead of the raw keys it shows today
   under "The request as posted"? And should blank fields be left out? We send all 13, `""` when unanswered.
4. **West Phoenix** has no rig code. 161 sends `west-phoenix` and warns the crew that the rig's own four may not be
   emailed. Is Phoenix to be added to the Rigs sheet and `rigCodes`, or is it out of scope?
5. **Size.** Photographs are compressed. A document can be up to 20 MB embedded, and `sdSizeOk` warns at 10 MB
   total. Does the email action hold that? Outlook's attachment ceiling is about 25–35 MB. Give us a total to refuse
   above if you want one.
6. **`notifyKind`** — `mandatory` = rig down and ≥ 6 hrs since `occurredAt` at the moment of sending. Confirm that
   matches what the six-hour flow and the Help Centre expect.
7. **The roles.** `meta.tsl`, `meta.rigmgr` and `meta.arigmgr` are sent empty: SSORT has no such fields (RT KE-02).
   Your 29 Sep §2 says the flow addresses from the Rigs row, never from these, so nothing breaks. Confirm it is still
   so.
8. **Anything else the flows built since 29 Sep expect from the tool**, such as a receipt read-back. Name it and we
   build it.

### 60.5 — The end-to-end test, Dan's to run (posting is his)

Once 60.4 is answered:

1. Dan opens `SSORT REV 161\index.html` from his PC. Requests → Technical Assistance Request, rig `SSCE Equipment`,
   Practice send ticked.
2. He sends one rig-down request with a photo and a PDF.
3. Expected on your side: office-only email marked TEST, an office-only chat, a receipt on the Help Centre, and the
   FRM lines visible.

Then deploy. WCGRRT is untouched. The training pack stays held (entry 56), so the class deck has no assistance-request
shot until Dan releases the pack.

### 60.6 — Your 60.4 answers (11 Oct), and the one change they made

All eight are answered. The schema holds. The tool keeps folding the form into `description`, keeps one send per
request, and sends blanks as `""` (you drop them; `fieldLabels` is used from scanner v2.87). `notifyKind` is a label,
not a trigger; the roles are never read for addressing; and nothing else is expected.

**One change, built:** at most **20 MB of files in total per request** (the tenant's 25 MB email send limit). The file
that would cross it is refused with the reason, and Send refuses as well if the total is ever over. The 8 MB warning
and 20 MB refusal per file, and `sdSizeOk`'s 10 MB warning, are unchanged. Tested: two 7.5 MB PDFs were attached and
the third was refused at 22.5 MB. 161 was never deployed, so it was rebuilt in place; the hash above is the new
build. Every byte-identical check still passes.

**West Phoenix, Elara, Aquarius, Eclipse** as Rigs-sheet rows: Dan's call (your 60.4.4). The tool needs no change
either way, because `rigkey` falls back to the rig name.

**Dan decided, 11 Oct:** *"we will add these rigs but theres no rush, these rigs are stacked and are currently not working."* So add the four
Rigs-sheet rows when convenient, at low priority. No tool change is needed then or now.

### 60.7 — A copy of the FRM on the email (Dan, 11 Oct). No flow change, by design: please confirm

Dan: *"we want to attach a copy of the FRM and any attachments to the email"*. The crew's files already go on the
email, because your flow attaches every `attachments[]` and `photos[]` item. So the tool now builds the filled-in
**FRM-00-0169** itself and puts it as the **first `attachments[]` item**:

```
{ name: "FRM-00-0169_<rigkey>_<yyyyMMdd-HHmm>.html", type: "text/html", bytes, data: <bare base64 of UTF-8 HTML>, frm: true }
```

- **The document** is laid out as the form is: the Rig Down / Equipment Failure selector ticked, then its fifteen
  numbered fields in its order, conference call YES/NO ticked. After those come what the tool adds: subject,
  Synergi case, raised by and contact, assistance or mandatory, the names of the files sent with it, the request id,
  and the SSORT revision.
- On a `dryRun` or `SSCE Equipment` send it carries a **TEST** banner.
- It is self-contained HTML with no images, about 4 KB, and all crew text is escaped. It opens in any browser and prints
  to PDF. That is the same route NOV already receive the CBM report by: the tenant converter refuses HTML (ORR known
  error 4), and the tool has no PDF library offline.
- `frm: true` is an extra key on that one item, so the Help Centre can tell it from the crew's files if you want to.
  The flow ignores it.
- It does not count toward the 20 MB file cap.
- The crew can see the exact document before sending: **🖨 View / print FRM**.

**So nothing changes in `TSC Help Notifications`**, because `ReqDocs` already maps every attachment. **Please confirm two
things, or say otherwise:**

- **(a)** Nothing in the flow or the scanner filters `attachments[]` by type, so a `text/html` item goes on the email
  like a PDF.
- **(b)** The Help Centre lists it as a downloadable attachment. Its `blobUrl` with `type: text/html` opens it.

Verified on 161, posting stubbed and nothing posted:

- the FRM is first, then the crew's PDF;
- the base64 decodes to the document;
- all fifteen rows are present, and the ticks are right;
- `<` and `&` in crew text are escaped;
- the TEST banner shows;
- the files are listed.

**This lands in Dan's practice send (60.5):** the office email should carry `FRM-00-0169_ssce_<stamp>.html` plus the
photo and the PDF.

**Confirmed by you, 11 Oct late:**

- **(a)** There is no type filter in `ReqDocs` or the scanner.
- **(b)** The Help Centre lists the FRM as a download.
- `frm: true` is used from scanner v2.87: the Help Centre prefixes the link **"FRM-00-0169 form copy:"**.

Nothing is open on either side. **161 waits only on Dan's practice send.**

---

## Entry 59 — Reply to your 11 Oct question: the assistance request is NOT in either tool. Stage 1 was never built

**Rev: none — nothing shipped.** Live builds: WCGRRT 169, SSORT 160. Status: **FYI**, plus one decision for Dan
(59.4).

**Straight answer first.** Searched both live builds for the form, the button, and every field you list
(`rigDown`, `hoursDown`, `occurredAt`, `notifyKind`, `assistance`): **zero matches in either file.** Our
29 September handoff (`DASHBOARD-TSC-HELP-CENTRE-HANDOFF.md` §7) put stage 1 — the form with no Post button,
both tools — at "now, needs nothing from you". **It was not started.** The CBM, EHBS, surface-test, naming and
Riser Adapter work took every revision since, and nothing on this side chased it. That is our miss, stated
plainly. Your side has been ready since you built the flows; nothing on your side is waiting on a mistake of
yours.

### 59.1 — The path: there is none yet

- **WCGRRT 169: no entry point. SSORT 160: no entry point.**
- **Do not confuse it with the ❓ Help / Feedback tab**, top right in both tools. That is a tool-feedback form
  ("Found a problem, need a change, or have an idea to improve the tool?"). It opens a pre-addressed email to
  the tool owner, posts nothing, and never reaches the Help Centre. For the class deck: **that tab is not the
  assistance request.** A trainer who points at it as one will be wrong.
- So no screenshot exists for the deck. The class (19–20 Oct) runs on frozen builds that do not have it,
  unless Dan decides otherwise in 59.4. Training reply §4.2 already said so: "Dan drops the sample file in."

### 59.2 — Stage: not stage 1 either

Neither the form nor the Post button exists. Your condition for the Post button (guard proven, your row 5 of
29 Sep) is met, so the Post button no longer waits on you. It waits on us building the form at all.

### 59.3 — The fields, as they stand

None of the request fields is populated, because there is no form. The `meta` roles you list, as they stand
**today** on ordinary reports:

| Key | WCGRRT 169 | SSORT 160 |
|---|---|---|
| `meta.sss` | populated (Visit Information) | populated |
| `meta.tsl`, `meta.rigmgr`, `meta.arigmgr` | populated (Visit Information) | **always empty.** RT KE-02: SSORT reads elements it does not have. The "seven-field SSORT fix" in our 29 Sep §7 was the same revision as stage 1 and was **not built either** |

**For the six-hour chat:** `occurredAt` comes only from the request form, so nothing can carry it until the
form exists.

### 59.4 — What happens next: Dan decides

1. **Before the freeze (15 October).** Build stage 1 and the Post button together in both tools in the next four
   days. Use FRM-00-0169's fifteen fields as they stand, plus your list in 59.3, and the SSORT role fields. The
   keys are announced here first. It would also need, from you, **the endpoint the request posts to** (your
   flows' trigger, or `REPORT_POST_URL` with a request type) and the exact payload shape your flows parse. Lee's
   field expansion is still not discussed; under this option it becomes a later additive revision.
2. **After the class (from 21 October)**, as you proposed. Nothing on your side waits.

---

## Entry 58 — WCGRRT 169: drag-and-drop onto photo boxes, as SSORT has. No keys, no payload change

**Rev: WCGRRT REV 169. DEPLOYED 10 October on Dan's go.** sha256 `9af1e76a986da12644293335f67512982794d7ee8374a141d8db766b75bc7b6b`, 3,345,420 bytes (168:
3,342,821). Hash-verified on the share; smoke-tested through IIS with the transport disabled. Status: **FYI** —
nothing to build.

**Dan, 10 October:** *"we can drag and drop photos into SSORT photo load fields but not WCGRRT? Can we add the
same capability please?"*

- **Why it never worked.** Each tile carries the tile-reorder drag handlers. Their `dragover` and `drop` cancelled
  every drop inside a tile, so the transparent file input over each photo box never received the file — even on
  boxes whose text says "or drop photo here".
- **169** adds SSORT's window-level handler, ported. A photo dropped on any photo box takes exactly the
  file-picker path: `compressDataUrl` (1600 px, JPEG 0.82, never inflates), then the slot, figure numbering,
  autosave. It covers tile photo boxes, photo-grid slots, the Help Centre screenshot boxes, and the **Actions
  Raised photo cell**, which is WCGRRT-only and goes through the same path as `onActionPhoto`.
  - A non-image file is refused with a message.
  - A file dropped anywhere else is swallowed, instead of the browser leaving the report to show the image.
  - Narrative boxes keep their own reference-image drop (`rteRefDrop`), unchanged.
  - As in SSORT, if several photos are dropped at once only the first is used.
- **For you:** nothing. Photos land in the same keys, at the same size and compression, as a picked photo. Byte-identical
  to 168: `sdPostReport`, `handlePhotoUpload`, `compressDataUrl`, `rteRefDrop`, `onActionPhoto`, the posting URL.
  The 0.82 count and the post call-site count are unchanged.
- **Training pack:** still held where it is, by Dan's instruction (entry 56). Live builds are now **WCGRRT 169 /
  SSORT 160**. The freeze is from 15 October.

---

## Entry 57 — 54.3 answered: Brad's Upper SBOP copy is complete. The short file was not the tool

**From Dan, 9 October:** Brad's own saved copy, `Upper SBOP - seadrill-report_West-Capella_2026-09-29_cbm-inspection 2.json`.
Status: **DONE — restored 9 October 13:16 on Dan's instruction.** Please confirm the row after your next scan. **Nothing to fix in SSORT.**

**The file, checked on the tools side:**

- **9,314,138 bytes, valid JSON**, ending cleanly on `}`. sha256 `1a30f3db6ba19eac7b65f81e0d00b1fa526e6e299151f15cbf44189ddfb25eb8`.
- `exportedAt` `2026-09-29T08:33:37.614Z`; `meta.rev` `SSORT REV 149`; `meta.asset` `West Capella`; date
  `2026-09-29`.
- **One CBM tile, Upper SBOP.** Model Data serial `20027927- 1145`, Maximo asset `C1004864`.
  `rcpt_model` `NOV PN: 20027927`, `rcpt_serial` `20027927- 1145`. One graded task; no attachments.
- **23 photographs, every one complete.** Each decodes from base64, and each JPEG runs from its start
  marker to its end marker.

**What it means for 54.3.** The copy you had stopped part-way through a photograph. Brad's saved file
does not; the same report is whole on his side. So the short copy was cut **after** it left his machine,
in the transfer (email, Teams, a OneDrive sync), or it was a different copy. This is consistent with the
tool's own check: Save to File reads back the byte count and re-downloads if it is short. No freeze
exception is needed.

**Restored, as with the other seven.** It was copied into `WellControl - PostedReports` (the OneDrive-synced
library on Dan's PC) at 13:16 on 9 October, byte-identical to Brad's file (same sha256), on Dan's instruction
*"you put it in there for me please"*. Before copying, the library was checked: the name was free, and no
Upper SBOP CBM for 29 September existed. The old-name `..._2026-09-29_cbm-inspection.json` is the **Riser
Adapter** (exported 30 Sep, REV 152), a different inspection, and is left alone. The only other Upper SBOP
in the library is 27 July. Under the current rule (SSORT 159 and 160) it is named:

`seadrill-report_West-Capella_2026-09-29_cbm-inspection_Upper-SBOP-SN20027927-1145.json`

The serial comes from the Model Data field (`20027927- 1145` → `SN20027927-1145`). 158 would name it the
same, so it matches your restores. It was placed in the library directly, not posted through the intake; like your restores, it carries no visit
type, so no flow should fire. Brad's
re-post from 160 with Post Report only would land under the same name and replace it, which is the
behaviour we want.

---

## Entry 56 — The freeze moves to 15 October. SSORT 160 is live; the training pack stays on 159 until Dan says

**Dan, 9 October:** *"lets move the freeze to the 15th"*, and *"dont move anything on the training pack yet"*.
Status: **FYI** — please update the ORR workbook's freeze row and frozen builds.

- **Freeze from 15 October 2026** (was 12 October), until after the class on 19 and 20 October. The rule
  is unchanged: only data loss, a failed or silent post, or anything stopping a rig recording or sending
  ships during it. The frozen builds are whatever is live on 15 October.
- **Live today: SSORT REV 160** (entry 55, deployed 9 October; sha256 `1e797e85e2afa174d8f38d04f4df47621da6672ad8056e598d7b1ebcfe506609`,
  6,902,948 bytes; hash-verified on the share; smoke-tested through IIS, nothing posted) and
  **WCGRRT REV 168**.
- **The Day 1 training pack, deck and samples still say SSORT 159, on purpose.** Dan will say when to
  move them. Until then, a trainer opening the live tool sees REV 160 on the badge, plus two things
  the pack does not show: the C&K Stabs **Stab Identification** table, and Model and Serial marked
  *required by NOV*, with the Post to OEM prompt when they are blank. Badge shot 17 is to be retaken
  only when the pack moves.
- The ORR return in `ORR-Reporting-Tools/` is moved to 160 and to the 15 October freeze (runbook §8,
  test records, components, known errors, UAT).

---

## Entry 55 — SSORT 160: model and serial are per unit and no longer carried over; C&K Stabs gains Stab Identification. 12 new keys, announced here before they ship

**Rev: SSORT 160. DEPLOYED 9 October on Dan's go**; hash-verified on the share, smoke-tested through IIS, nothing posted. sha256
`1e797e85e2afa174d8f38d04f4df47621da6672ad8056e598d7b1ebcfe506609`, 6,902,948 bytes (159: 6,897,611).
Inside the window before the freeze (moved to 15 October, entry 56). Status: **NEEDS ACTION** — 55.2: the 12 new keys, for
the report row, the viewer and the database export.

Dan's decision, 9 October, on 54.4 and 54.5: *"The guys need to put the correct serial and model number
in here, its required by NOV to review for the cbm so needs to be there. Yes add the C+K stab asset
field please."*

### 55.1 — Model and serial are per unit (54.4). No key changes

- **Copy-to-all no longer copies them.** "Save details & copy to all equipment" still copies and
  remembers the shared visit fields: company, PO, job, rig, configuration, witnesses and inspection
  date. It never copies or remembers `rcpt_model` or `rcpt_serial`.
- **Remembered details are cleaned when read.** If a rig's browser already holds a serial remembered by
  an earlier revision, a new CBM section still starts with Model and Serial blank.
- **Duplicate** starts the copy with no unit identity. Blank on the copy: `rcpt_model`, `rcpt_serial`,
  the Model Data serial and Maximo asset number, and the Stab Identification table. Findings are copied
  as before.
- **Both fields are marked "\* required by NOV".**
- **Post to OEM asks before sending a CBM with no model or no serial number.** It does not refuse:
  Cancel goes back to enter them, OK sends anyway. A crew with an unreadable plate can still send. A
  Model Data serial counts as a serial; for C&K Stabs, a part number or serial in Stab Identification
  counts. Post Report is unchanged.

**For you:**

- From 160 a blank `rcpt_serial` / `rcpt_model` on a new CBM is a crew omission, not a carry-over.
  Posts made before 160 can still carry another unit's serial: West Capella's Upper Kill FSV is one.
- **No change to the file name.** `reportFileName` and `sdPostDiscriminator` are byte-identical to
  159.

### 55.2 — C&K Stabs: Stab Identification (54.5). The new keys

A section on the C&K Stabs CBM only, under Recipient Details. One row per stab, read from the stab
itself. It is shown in the CBM PDF and in the OEM HTML NOV receive, as a table after Recipient Details.
It is left out of both when the crew has filled none of it.

`cbmData` gains, **only when the equipment is C&K Stabs**, these 12 keys. All are string values, lower
case and additive; a blank field is posted as `""`:

| Stab | Part number | Serial | Seadrill Maximo asset number |
|---|---|---|---|
| Choke — female | `ckstab_choke_f_pn` | `ckstab_choke_f_serial` | `ckstab_choke_f_maximo` |
| Kill — female | `ckstab_kill_f_pn` | `ckstab_kill_f_serial` | `ckstab_kill_f_maximo` |
| Choke — male | `ckstab_choke_m_pn` | `ckstab_choke_m_serial` | `ckstab_choke_m_maximo` |
| Kill — male | `ckstab_kill_m_pn` | `ckstab_kill_m_serial` | `ckstab_kill_m_maximo` |

- `_maximo` is the Seadrill Maximo asset number, as Dan confirmed on 9 October: the identity the CoC
  tracker and the Maximo extract key on. **Never `asset`**: `meta.asset` stays the rig.
- `collectCbm` drops any `ckstab_*` key from every other class, so they can never appear on a gate
  valve or a riser adapter.
- No `cbmlabels` entry. The keys name themselves, and `cbmlabels` covers task keys only.
- The other 19 classes keep the single Model Data *Seadrill Maximo Asset #* they already post,
  `cbm_<safe>_md_maximo`. BOP Mandrel, Diverter and Riser Spider still have no asset field; ask if you
  want them.

**Verified on 160**, asset `SSCE Equipment`, `fetch` and `sdPostReport` disabled, nothing posted:

- the table renders, and all 12 keys are collected;
- the stab table appears in the report HTML;
- a Gate Valves tile in the same report carries none of the keys;
- details remembered as an older revision stored them (company, serial and model) start a new section
  with the company filled and Model and Serial blank;
- copy-to-all copies company and job but not model or serial;
- Duplicate of a C&K tile and of a Gate Valves tile both start blank on unit identity;
- Post to OEM on a blank C&K tile asks: *"NOV need this unit's model and serial number to review the
  CBM, and they are blank."* On a filled tile it goes straight to the existing send confirm.

**Build checks:**

- every script block parses, and there are no duplicate declarations;
- byte-identical: `sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportTypeAuto`, `reportFileName`,
  `sdPostDiscriminator`, `sdSlug` and `sdSizeOk`;
- `sdPostReport(` call count unchanged; no `no-cors`; 0.82 count and `CBM_SCHED` unchanged.

**The name for C&K Stabs** still comes from the Recipient serial or model (entry 53.3). It does not come
from the stab table. With the stabs in the table, the crew no longer needs four serials in one box.

**Seen while testing, not new in 160:** if a crew changes a filled CBM tile to another equipment and
back, the first equipment's entries come back empty. That is true of every CBM field and every
revision; it is logged here for after the class.

---

## Entry 54 — Reply to your 8 October note: SSORT 159 is live, which changes some restored names; the truncated Upper SBOP is unlikely to be the save dialog; the C&K stab asset field waits for Dan

**Rev: SSORT 159, DEPLOYED 9 October** on Dan's go. sha256
`785c4ae8c4159fd4ed123c4c2c922040f322364252fc2fbca6396485d3aab9b6`, 6,897,611 bytes. Hash-verified on the
share. Smoke-tested through IIS with the transport disabled: badge REV 159, nothing posted, test state
cleared. Status: **NEEDS ACTION** — 54.2 (check the restored names) and 54.3 (four facts about the
Upper SBOP file).

### 54.1 — Your "52.2 is still untested" crossed with entry 53

Entry 53 (6 Oct) answered it. The collision was confirmed on the live 158 and is fixed in 159, now
deployed. 53.3 also holds the exact slug rule you asked for in 52.3. If 53 had not reached you when
you wrote, read it before anything below.

In one line, from 159, per CBM tile: equipment, then `-SN<serial>` from the **Model Data** serial, else
the **Recipient Details** serial; if both are blank, `-<model>` from Recipient Details; if all three are
blank, nothing. Re-checked on the live 159 on 9 Oct: the two gate valves now separate, and
`Gate-Valves-SN973654-0015-1` is named exactly as 158 named it.

### 54.2 — The seven restored files against 159: NEEDS ACTION, a check not a redo

Your restores are named as **158** would name them. **159 gives the same name whenever the Model Data
serial was filled in.** That covers both your 7 Oct examples. A restored file is named differently by
159 in two cases:

1. **The Model Data serial was blank** but the Recipient serial or the model was filled in. 158 gave
   plain `<Equipment>`; 159 adds `-SN<recipient serial>` or `-<model>`.
2. **The class has no Model Data section at all**: C&K Stabs, BOP Mandrel, Diverter, and Riser Spider
   Assembly and Gimbal. These four never had a Model Data serial, so 158 named them plain
   `<Equipment>`. 159 adds the Recipient serial or model. The other 19 classes all have the section.

**Why it matters:** if the rig re-posts a correction from 159, the corrected file lands under the 159
name. It then sits as a **second row** beside your restored file instead of replacing it. **Ask:**
compute the 159 name for each of the seven from its own `cbmData` (rule in 53.3). Where it differs,
either rename the restored file to the 159 name, or note that a later re-post will need the old row
removing. Your call; the tool side has no preference.

C&K Stabs is the likeliest to differ. Your 30 Sep West Capella example (`rcpt_serial` = the whole
four-stab sentence) names under 159 as
`..._cbm-inspection_C-K-Stabs-SNChoke-Fem-10696444-001-88-Kill-Fem-20084080-3086-Choke-male-060929-5-Kill-male-060929-9.json`.
That part is 99 characters, under the 140 cap.

### 54.3 — Upper SBOP: Brad's saved copy stops part-way through a photograph

**What SSORT's Save to File does, in every revision from at least 100 to 159:**

1. It writes the report through the browser's Save dialog.
2. It **reads the file back and compares the byte count** with what it meant to write.
3. If the count is short, it tries once more. If still short, it downloads a fresh, complete copy and
   tells the crew how short the first one came back. The code comment records why this exists:
   *photo-heavy CBM files were silently truncating, especially to OneDrive folders mid-sync.*

The TSC REPORTS folder write behind Post Report checks its byte count the same way.

**So a short `.json` from the Save dialog itself is unlikely.** There are two gaps where the tool cannot
check:

- **(a)** If the browser refuses the read-back, the tool assumes success. Edge and Chrome on Windows
  allow the read-back.
- **(b)** If the Save dialog is unavailable (iPad, or the dialog failing), the file goes out as a
  plain browser download or share. The browser writes that file, not the page. A failed download in
  Edge or Chrome usually leaves a `.crdownload`, not a `.json`.

Neither gap can be ruled out from here. Transfer and OneDrive are likelier:

- a file can pass the check when written and still be cut short later by a OneDrive sync or conflict
  copy;
- email and Teams have their own size handling.

**Four facts would settle it. Please ask Brad, or read them off the file:**

1. The file's **exact size in bytes**. A round figure points at a transfer limit.
2. **Where it was saved.** A OneDrive-synced folder?
3. **How it reached you:** email, Teams, or a OneDrive link?
4. Its **modified time**, against the time of the NOV copy.

If they point at the tool, it is a freeze exception (a crew's only backup unreadable without anyone
knowing) and we fix it. If not, nothing ships. Brad re-posting with Post Report only, as you asked, is
right.

### 54.4 — Upper Kill FSV carried the Riser Adapter's serial: the mechanism, and a proposal for Dan

This is the residual we named in 53.2, now seen in the field. **"Save details & copy to all equipment"**
stores the whole Recipient Details block in the browser. Every new CBM section then fills from it,
**`rcpt_serial` and `rcpt_model` included**. Brad's Riser Adapter serial went into the next section and
was not changed.

From 159 this matters more, because `rcpt_serial` now names the file when the Model Data serial is
blank. Two different units carrying the same copied serial would share a name again.

**Proposal, Dan to decide, nothing built:** keep auto-filling the shared fields (company, PO, job, rig,
witnesses) but **stop carrying `rcpt_serial` and `rcpt_model` into a new section**. They describe one
unit, not the visit.

- **No payload key changes.** The fields stay; they simply start empty.
- **The cost:** a crew re-types the serial for each unit, which NOV want per unit anyway.
- **Timing:** it prevents wrong serials and a route back to the overwrite, so Dan may count it as a
  freeze exception before 12 October. Otherwise it is first in the queue after the class.

### 54.5 — Item A, the C&K stab asset field: facts for Dan, then it waits

- **19 of the 23 CBM classes already have a Maximo asset field**: the Model Data section's *Seadrill
  Maximo Asset #*, key `cbm_<safe>_md_maximo`. It is posted in `cbmData` today and shown in the OEM HTML.
  It may already be the "asset" you want for those classes; please check it is on your rows.
- **C&K Stabs is one of the four classes with no Model Data section**, alongside BOP Mandrel, Diverter
  and Riser Spider. So it has no asset field and no Model Data serial. Its only identity fields are the
  free-text Recipient Model and Serial, which is why the four stabs end up in one sentence.
- **Your per-stab suggestion fits the equipment.** It would be a small table on the C&K Stabs form:
  four rows (choke female, kill female, choke male, kill male), each with part number, serial and
  Maximo asset number. The OEM HTML would carry the same table beside the serials.
- **Keys:** none ship until announced here, and never `asset`. Our proposal, all new, lower case and
  additive: `ckstab_<pos>_pn`, `ckstab_<pos>_serial` and `ckstab_<pos>_maximo`, with `<pos>` one of
  `choke_f`, `kill_f`, `choke_m`, `kill_m`. That is 12 keys. Tell us if an array suits the scanner
  better.
- **File name:** unchanged by this. The name keeps using the Recipient serial or model. Once the
  per-stab table exists, the crew no longer needs to put four serials in the Recipient serial box, so
  the name shortens naturally.
- **For Dan:**
  1. ~~"Asset" means the Maximo asset number. Yes?~~ **Answered 9 Oct: yes, the Maximo asset number of
     each stab** (your reply, item A.1).
  2. Per stab (12 keys), or one field?
  3. After the class, as both sides read it, or before 12 October?

---

## Entry 53 — Reply to 52: the gate-valve collision is real on the live 158, and 158 never read the serial you are recovering by. SSORT 159 built; the slug rule exactly

**Rev: SSORT 159. DEPLOYED 9 October on Dan's go** (it touches the filename logic, his rule); hash-verified
on the share and smoke-tested through IIS, nothing posted. Freeze exception: losing work, and it is before 12 October in any case. SSORT 159
sha256 `785c4ae8c4159fd4ed123c4c2c922040f322364252fc2fbca6396485d3aab9b6`, 6,897,611 bytes (158: 6,897,196).
Status: **NEEDS ACTION** — 53.3 changes how the 9 October recovery names its files. No new keys.

52.1, 52.5 and 52.6: read and agreed; nothing owed either way.

### 53.1 — 52.2: confirmed on the deployed 158

Tested against the live file (`/SSORT/index.html`, badge REV 158), asset `SSCE Equipment`, `fetch` and
`sdPostReport` disabled, nothing posted, test state removed afterwards. One Gate Valves tile, both
serial fields blank:

| Recipient Details "Model" | Name under 158 |
|---|---|
| `NOV - Upper Choke - Dual Failsafe` | `seadrill-report_SSCE-Equipment_2026-10-06_cbm-inspection_Gate-Valves.json` |
| `NOV - M991005890 - Kill Isolation Valve (Single)` | `seadrill-report_SSCE-Equipment_2026-10-06_cbm-inspection_Gate-Valves.json` |

**Same name. Your reading is right: any class with more than one unit on a rig collides under 158
whenever the serial is blank — not only dual-stack.** Our entry 51 stated the residual too narrowly.

**And a second finding your 52.3 depends on.** A CBM tile has **two** "Serial Number" fields:

- **Model Data** (section 4) — key `cbm_<safe>_md_serial`, e.g. `cbm_Gate_Valves_md_serial`;
- **Recipient Details** — key `rcpt_serial`.

**158 reads only the Model Data serial.** A serial typed only in Recipient Details was ignored —
tested on the live 158: `rcpt_serial` = `GV-111` and `GV-222` both gave `..._Gate-Valves.json`. Your
52.3 plans to name recovered files from `rcpt_serial`; under 158 that would not have matched what the
tool produces.

### 53.2 — SSORT 159: what changes

Per CBM tile, the instance is the **first non-blank** of:

| # | Field (key in `cbmData`) | Becomes |
|---|---|---|
| 1 | Model Data serial `cbm_<safe>_md_serial` | `-SN<serial>` |
| 2 | Recipient Details serial `rcpt_serial` | `-SN<serial>` |
| 3 | Recipient Details model `rcpt_model` | `-<model>` |
| — | all three blank | nothing — named exactly as 158 |

Verified on 159 (posting disabled, same asset):

| Case | Name |
|---|---|
| All blank | `..._cbm-inspection_Gate-Valves.json` |
| Model `NOV - Upper Choke - Dual Failsafe` | `..._cbm-inspection_Gate-Valves-NOV-Upper-Choke-Dual-Failsafe.json` |
| Model `NOV - M991005890 - Kill Isolation Valve (Single)` | `..._cbm-inspection_Gate-Valves-NOV-M991005890-Kill-Isolation-Valve-Single.json` |
| Same model again (a corrected re-post) | identical to the first: **replaces** |
| `rcpt_serial` `GV-222`, model still filled | `..._cbm-inspection_Gate-Valves-SNGV-222.json` (serial wins) |
| `md_serial` `GV-111` as well | `..._cbm-inspection_Gate-Valves-SNGV-111.json` (Model Data wins) |
| Two tiles: C&K Stabs (blank) + the Upper Choke valve | `..._cbm-inspection_C-K-Stabs--Gate-Valves-NOV-Upper-Choke-Dual-Failsafe.json` |
| Plain rig visit, no CBM tile | `seadrill-report_SSCE-Equipment_2026-10-06.json` (unchanged) |

Build checks as every revision: every script block parses; no duplicate top-level declarations;
`sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportTypeAuto`, `reportFileName`, `sdSlug` and
`sdSizeOk` byte-identical to 158; `sdPostReport(` call count unchanged; no `no-cors`; 0.82 count and
`CBM_SCHED` unchanged; the 154/157/158 fixes present. The only code change is the three lines inside
`sdPostDiscriminator` that pick the instance. The OEM `sourceFile` calls the same `reportFileName()`,
so OEM then Post Report is still one file.

**Two consequences, stated:**

- **Names change from 158 for a tile with a model or a Recipient serial and no Model Data serial.** A
  report first posted from 158, which has been live since 19:25 on 6 October, and corrected after 159 is
  deployed, would land as a second row rather than replace. It only affects that window.
- **Residual after 159.** Two units of one class, on one rig, on one day, both with **all three fields
  blank**, still share a name. So do two units given the **same** text, and that can happen without the
  crew typing it. "Save details & copy to all equipment" stores Recipient Details in the browser, and
  every new CBM section fills from them, `rcpt_model` and `rcpt_serial` included. A crew that
  inspects a second valve and does not change the model or serial gets the first valve's name, and
  the record carries the wrong model anyway. **Training point for Day 1:** on every CBM, check the
  Model and Serial in Recipient Details belong to *this* unit. We have not made the serial compulsory,
  which would mean a new refusal on the Post button during the freeze. Dan's call if he wants it after
  the class.

### 53.3 — 52.3: the rule, exactly. NEEDS ACTION for the recovery

```
seadrill-report_<rig>_<date>_<type>[_<disc>].json
```

- **`<rig>`** — `meta.asset` with **each** character outside `A–Z a–z 0–9` replaced by `-`, one for
  one: no collapsing, no trimming. `West Capella` → `West-Capella`. Unchanged since before 158.
- **`<date>`** — the report date `meta-date`, `YYYY-MM-DD`.
- **`<type>`** — the report type, lower-cased, runs of non-alphanumerics → one `-`, ends trimmed:
  `cbm-inspection`, `surface-bop-testing`.
- **`<disc>`** — CBM: one part per CBM tile that has an equipment selected, `slug(equip)` + instance as
  in 53.2. Surface BOP Testing: `slug(test type)` per tile. Every other type: none.
- **`slug(s)`** (`sdSlug`): trim; every run of one or more characters outside `A–Z a–z 0–9` becomes
  **one** `-`; leading and trailing `-` removed; an empty result becomes `unknown`. **Case is kept.**
  - `C&K Stabs` → `C-K-Stabs`
  - `Flexloops, Spools, Blocks` → `Flexloops-Spools-Blocks`
  - `(Kill Isolation Valve [Single])` → `Kill-Isolation-Valve-Single`
  - `  --x--  ` → `x`
  - `  &&  ` → `unknown`
- **Serial**: `-SN` + `slug(serial)`, no separator after `SN`: `GV-111` → `-SNGV-111`.
- **Model**: `-` + `slug(rcpt_model)`, the **whole field**, manufacturer segment included.
  `NOV - Upper Choke - Dual Failsafe` → `-NOV-Upper-Choke-Dual-Failsafe`. This is not the shortened
  label the dashboard displays.
- **Blank test**: each field is trimmed first; whitespace-only counts as blank.
- **`<safe>`** in `cbm_<safe>_md_serial`: `equip` with **each** non-alphanumeric character → `_`, one
  for one: `Gate Valves` → `Gate_Valves`, `C&K Stabs` → `C_K_Stabs`.
- **Several tiles**: parts de-duplicated, sorted by JavaScript's default sort (code-unit order, so
  capitals before lower case), joined with `--`.
- **Length cap**: the whole `<disc>` is cut at **140 characters**, a plain cut that may end mid-word or
  on a `-`. No cap on `<rig>`.
- Every input is in the posted file: `cbmData.equip`, `cbmData.cbm_<safe>_md_serial`,
  `cbmData.rcpt_serial`, `cbmData.rcpt_model`.

**For the 9 October recovery:**

- **If 159 is live by then**, name each restored version by the 159 rule above. A later corrected
  re-post from the rig then replaces it.
- **If Dan holds 159**, the 158 rule is `slug(equip)` + `-SN` + `slug(cbm_<safe>_md_serial)` only.
  **Not `rcpt_serial`.** Two units that would then share a name cannot both be restored under the
  158 name, as your 52.4 says.

### 53.4 — 52.7: Day 1 pack moved to 158

Every SSORT 156 reference in the README, the reply, the scripts and the Q&A now says 158, and the
screenshot list's two as well. The zip is rebuilt. Three places were wrong beyond the number and are
rewritten, not just renumbered:

- **Reply §4 (the revisions to freeze)** carried SSORT **152's** hash and "deployed today, 30 September"
  under the 156 label. It now gives 158's hash, bytes and deploy date.
- **Reply §5 4.1** still said *"Do not teach that NOV receives the attachment"* (`OEM_SEND_FILES` false).
  That has been untrue since 153 and the script already teaches the opposite. Corrected.
- **Reply §1.2**: the CBM and surface-test name patterns were the pre-158 ones. Updated, pointing to 53.3.

Also fixed: the README held the build-freeze section **three times over** (one copy kept). The
**deck's slide 3** ("Frozen for the class week") still said **WCGRRT REV 166 / SSORT REV 153**; it now
says 168 / 158 (validated). Historical lines ("SSORT went 152 to 156 in four days") and the samples
README, which records the build each sample was made on, are left as they are.

**If 159 deploys, the frozen build becomes SSORT 159 and the pack moves once more, at deploy.** Badge
shot 17 is then retaken on 159.

### 53.5 — The ORR workbook (v2, 6 October): four corrections from the tools side

Read in full. For your next pass, none urgent:

1. **Service components**: the row `WCGRRT REV 168 | \\sdrlazneuiis01d\sacred\index.html` has the wrong
   path. That file is the **stale SSORT copy** (RT KE-08). WCGRRT is
   `\\sdrlazneuiis01d.corp.local\sacred\WCE Rig Vist Reporting Tool V0.html`, as your second WCGRRT row
   says. Each tool currently has two rows; one per tool would do.
2. **Test summary**, row "26 to 30 Sep (SSORT 149 to 153)": "live file `f70d21f678b0` matches the REV
   157 folder". `f70d21f678b0` is **SSORT 154**; 157 was `ba2ddd573e99`. Row "26 Sep (WCGRRT 166)": "live
   file `c916a062d457`" is **WCGRRT 167**. SSORT 154–157 (1–5 Oct) and WCGRRT 167 (1 Oct) have no row of
   their own. They are in `02-Test-records-ORR-19.md`.
3. **Open actions**, the build-freeze row still says "today SSORT 156, WCGRRT 167". It is 158 / 168,
   or 159 / 168 if Dan deploys 159.
4. **Open actions**, the recovery row says "named as SSORT 158 would name them". Per 53.3 it depends on
   159, and it is never `rcpt_serial` under 158. The 52.2 check row can close once Dan decides on 159:
   confirmed, and fixed in 159.

---

## Entry 51 — Reply to 50: both confirmed at source, both fixed. And 50.2 was not the Vendor Surveillance path — it was Save to File

**Rev: SSORT 158 and WCGRRT 168. DEPLOYED 6 October on Dan's go** — both touched rules he holds
personally (the filename logic, the posting path) and he approved both. SSORT 158 sha256 `6c06a4712ebf81c0aaf57c84b080c42fe2bc0029c4fb75e10c5f1b9827a5ac8a`, 6,897,196 bytes; WCGRRT 168 sha256 `a723b6df13b6e605dcbf0d2d91e1e4aab39588a03de3b21e70bdd1b74e6a051a`, 3,342,821 bytes. Status: **FYI** — no new keys. Two things
for you in 51.3 and 51.5.

### 51.1 — 50.1, CBM overwrite: confirmed, fixed in SSORT 158

Confirmed from the code before touching anything: a CBM post was named
`seadrill-report_<rig>_<date>_cbm-inspection.json`, so two different inspections on one rig on one day
shared a name.

**The name now carries what was inspected, not when it was posted:**

```
seadrill-report_<rig>_<date>_cbm-inspection_<Equipment>[-SN<serial>].json
seadrill-report_SSCE-Equipment_2026-10-06_cbm-inspection_Riser-Adapter.json
seadrill-report_SSCE-Equipment_2026-10-06_cbm-inspection_Upper-SBOP-SNABC-123.json
```

**We did not add the timestamp you proposed. This is the one place we have departed from your ask,
so here is why.** A timestamp makes every post a new file, which breaks two behaviours you confirmed
and rely on:

- **a corrected re-post would add a second row instead of replacing the first** — the heatmap and
  grade history would then count that inspection twice;
- **Post to OEM + Dashboard followed by Post Report** — which entry 42.5 promised produces *one* file,
  and which your `_replaced` / `shrunk` logic is built around — would produce two.

Identity by equipment, plus the serial number where the crew has entered it, separates every pair of
different inspections and keeps both of those behaving. Same equipment, same serial, same rig, same
day is the same physical unit inspected twice, and replacing is right.

**The residual, stated:** on a dual-stack rig, the same equipment class inspected on both stacks on
one day *with the serial left blank* would still share a name. The serial field exists for exactly
that and NOV ask for it.

**Your 50.1.3 — other SSORT posts with the same shape.** Surface BOP Testing had it (two different
tests on one day collided), so it gets the test type the same way:
`..._surface-bop-testing_BOP-Function-Test.json`. Pre-Deployment Checklist, Conditional Assessment,
R53 and the plain rig visit are one-per-day by nature, and a same-day re-post replacing them is
wanted; **verified unchanged**:

```
seadrill-report_SSCE-Equipment_2026-10-06_pre-deployment-checklist.json    unchanged
seadrill-report_SSCE-Equipment_2026-10-06.json                             unchanged
```

Verified with the transport disabled: the reported collision separates; a corrected re-post of the
same inspection replaces; two serials on one class separate; OEM then Post Report produces **one**
dashboard file; two different surface tests separate.

### 51.2 — 50.1.2, the OEM `sourceFile`: it has always been empty

You asked for the OEM copy's `meta.sourceFile` to carry the new name. **Before you go looking in
SACRED DATA for OEM copies that share one `sourceFile` across equipment: every OEM copy ever sent has
`sourceFile: ""`.** It was written as an empty literal and never populated, so all of them share it
and that check cannot confirm the overwrite. Your scan-count evidence — six OEM copies, at most four
reports — stands on its own and is enough.

From SSORT 158 it carries the dashboard file name, verified equal to the report the same press
posted, so the "Sent to NOV" chip can land on the right row.

### 51.3 — 50.2: not the Vendor Surveillance path. **Save to File posts.**

The Vendor Surveillance post path is guarded — Post Report fails closed on a blank rig, and still
does. The unattributed file did not come through it.

**WCGRRT's 💾 Save to File calls the dashboard post unconditionally**, before it opens the Save As
dialog: no rig guard, no report-date guard, no "only post a finished report" confirm, no size check.
Present unchanged in every revision back to at least REV 155. SSORT's Save to File has never done it.

**Reproduced on the deployed WCGRRT 167:** a Vendor Surveillance report with no rig, saved to file,
posted `seadrill-report_report_2026-10-06_vendor-surveillance.json` — the same shape as the file you
found from the 3rd.

The tool's own wording treats Save to File as a local copy — *"Save to File is the reliable backup"* —
and the New Trip prompt says *"Save to File now (recommended), then it will clear."* So at the end of
every trip, the tool has recommended a button that silently posts the trip.

It costs three ways:

1. **unattributed posts**, which is what you saw;
2. **unfinished reports posted without the crew choosing to** — the Capella-week problem, silently;
3. **a draft saved after the finished report was posted carries the same file name and replaces it.**
   That one loses work. Your `shrunk` rule catches it only when the draft is smaller.

**WCGRRT 168 removes the post.** Save to File saves a file; Post Report posts, behind its guards.
Verified: Save to File with a blank rig saves locally and posts nothing; Post Report with a blank rig
still refuses; with *Not rig-specific → SSCE Equipment* it posts, attributed.

### 51.4 — the freeze

Both before 12 October, and both would qualify after it: 51.1 is losing work outright, and 51.3's
third path replaces a finished report with a draft. If Dan ships both, **the frozen builds become
SSORT 158 and WCGRRT 168**, and shots 1 and 17 are retaken.

### 51.5 — **one thing to watch after 168, please**

Any rig that has been reaching the dashboard **only** through Save to File — perhaps without knowing
it — **will stop appearing** once 168 is live, until a crew presses Post Report. We cannot see which
rigs those are; you can. **If a rig goes quiet in the days after 168, that is the first thing to
check**, and the answer is a phone call, not a fix. We will tell the crews in the release note.

### 51.6 Unchanged

SSORT 158: `sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportTypeAuto`, `sdSizeOk`
byte-identical; `CBM_SCHED` unchanged; no key added. WCGRRT 168: `sdPostReport`, `postReport`,
`postCompliance`, `REPORT_POST_URL`, `buildReportPayload` byte-identical; exactly one of four post call
sites removed, the one in Save to File. Both: zero `no-cors`, 0.82 intact, no duplicate declarations,
all script blocks parse, every earlier fix asserted present.

**The recovery you offered in 50.1** — restoring the overwritten CBM versions from PostedReports under
unique names — needs SSORT 158 live first, or the next CBM post on that rig and day overwrites the
restored copy. Restored files should follow the new pattern, taking the equipment from each version's
own `cbmData.equip`.

---

## Entry 49 — West Auriga's daily checks sheet was never missing. It was built once, before the rig was picked, and never rebuilt

**Rev: SSORT 157. DEPLOYED 5 October**, hash-verified and smoke-tested. Status: **FYI** — no payload
key changes. One thing to be aware of in 49.4 if you hold daily-checks posts.

### 49.1 What the rig reported

West Auriga, 5 October: their daily checks template had "disappeared and defaulted to the
Capella's".

**It had not disappeared.** `AURIGA_CHECKS` is intact in the file and `dcSpecForRig()` returns it
correctly — on the deployed REV 156, `dcFormatName()` returns `"West Auriga"` while the panel on
screen still reads `Format: Capella`. The selector was right; the panel was stale.

### 49.2 The cause

A one-shot latch in `dlSetMode`:

```js
if(hc && !hc.dataset.built){ hc.innerHTML=renderChecks('dc'); hc.dataset.built='1'; }
```

The checks panel is built **the first time the Daily Checks tab is opened**, with whatever rig is
set at that moment, and is never rebuilt. The rig selector lives on a different tab, so opening
Daily Checks first is the normal order — and after that, picking the rig changed nothing on screen.

Three sheets exist: `AURIGA_CHECKS` for West Auriga, `DAILY_CHECKS` for West Saturn and Sevan
Louisiana, and `CAPELLA_CHECKS` as the default for everyone else. **The default is why nobody
reported it before** — ten of the thirteen rigs legitimately get the Capella sheet, so a stale
panel looked correct. Only Auriga, Saturn and Sevan could ever see the fault, and only Auriga has
a sheet different enough to notice immediately.

**Long-standing, not a regression.** The latch is present unchanged in every revision back to at
least REV 146.

### 49.3 The fix

The panel is rebuilt when the rig changes, carrying the readings across, by reusing
`checksApply()` — which already re-renders and re-applies values, so no new restore logic was
written. Hooked into `onAssetChange`, which both rig selectors funnel through (`#meta-asset` and
the Daily Log's own `#daylog-rig`), and which the report-restore paths already call.

Three cases verified on the deployed build:

| | |
|---|---|
| Open checks with no rig, then pick West Auriga | switches Capella → **West Auriga** |
| Switch between two Capella-format rigs (Capella → Polaris) | **no rebuild, all readings intact** |
| Switch to a rig with a genuinely different sheet | non-matching readings dropped, and the crew is told |

That middle row was the one that mattered: a fix that wiped readings on every ordinary rig change
would have been worse than the fault.

### 49.4 Why nothing carries across between Capella and Auriga, and why that is right

The two sheets share **zero keys** — 178 on Capella, 158 on Auriga, no overlap. Keys are derived
from the system and item names (`dc_bop_control_manifold_pressures__manifold_pressure_tp`), not
from position, so a reading **cannot** land on the wrong item when the sheet changes. It is dropped
instead, and the crew is told how many carried and how many did not.

**What this means for you:** a posted daily-checks round carries `rig` and its `values` keyed this
way. If you hold any Auriga rounds posted before today, their keys will be **Capella's keys**,
because that is the sheet the crew was shown. They are not wrong readings — they are readings taken
against the wrong sheet. We cannot tell from here how many exist; if you can count Auriga posts
whose value keys do not match the Auriga spec, that is worth knowing and we will go back to the rig.

### 49.5 Unchanged

`sdPostReport`, `collectChecks`, `checksApply`, `dcSpecForRig` and `REPORT_POST_URL` byte-identical.
All three rig sheets asserted untouched — this build changes when the panel is drawn, never what is
on it. `CBM_SCHED` unchanged. Zero `no-cors`, 0.82 intact, no duplicate declarations, script blocks
parse.

REV 156 6,893,201 → **REV 157 6,895,584 bytes**, sha256 `ba2ddd573e99f1a5a3f562c5a838bafb3924ac8aaee09968057be9d71472f725`.

### 49.6 The freeze

The freeze starts **12 October** (entry 48) and this is before it. Had it been after, this would
still have shipped: a rig recording against another rig's sheet is the "losing work" case the
freeze carves out.

---

## Entry 48 — Build freeze: 12 October. The tools stop moving until after the class

**Rev: none — this is a process note, nothing shipped.** Status: **FYI**, but it changes what you
can rely on, so it is worth two minutes.

**Dan set a build freeze on 2 October. From 12 October 2026 neither tool changes before the class
on 19 and 20 October unless a rig is losing work.**

| | |
|---|---|
| Freeze from | **12 October 2026** — the same day the training pack goes final |
| Until | after the class, 20 October |
| Frozen builds | whatever is live on the 12th. Today **SSORT REV 156**, **WCGRRT REV 167** |
| Ships anyway | data loss, a failed or silent post, anything stopping a rig recording or sending a report |
| Held until after | new NOV documents, new equipment classes, features, wording, cosmetics |

### Why

SSORT went **152 → 153 → 154 → 155 → 156 in four days**: the OEM attachment flag, a rig's bug report
and the data-loss defect found underneath it, then two new NOV documents. Every one was worth
shipping. Every one also invalidated a screenshot, a sample file and a "frozen build" line in the
training pack, which has now been repointed four times.

### What it means for you

- **The payload contract stops moving on the 12th.** Scanner and viewer work against SSORT 156 and
  WCGRRT 167 will not be overtaken mid-build.
- **No new keys will be announced in this handoff between 12 and 20 October** unless something is
  losing a crew's work. If you see one, it is because a rig was broken.
- Anything we find during the freeze is **logged here with the date it was found** and shipped in
  order once the freeze lifts, so nothing is dropped — it just waits.
- **The two open asks from entries 45 and 47 are unaffected**, because they are yours to answer
  rather than ours to ship: how many posted reports lost their `soak` block (45.3), and whether you
  want the permitted grade levels sent per key (47.3).

Normal service resumes 21 October.

---

## Entry 47 — Every Testing and Intrusive task in the schedule is now graded pass/fail. 211 new `_gr` keys

**Rev: SSORT 156.** Status: **NEEDS ACTION** — this is the largest single addition of grade keys the
tool has made, and 47.3 is the part that changes what your grade views mean.

### 47.1 What Dan decided, and why

His words, 2 October: *"this can be applied to everything and define it in the notes, NOV define
grade x as a pass and grade y as a fail in their CT inspections, ie pressure testing and dimensional
inspections."*

Entry 46 applied NOV's two-point scale to the Diverter only. This applies it to **every Testing and
Intrusive Inspections section in the schedule**, across 21 classes.

The reasoning is NOV's own, not ours: they grade their condition-trigger inspections — pressure
testing and dimensional inspection — as **grade 1 passed, grade 5 failed**, with no middle grade.
A test result is an outcome, not a condition, and it is gradeable precisely because NOV grades it.

### 47.2 The numbers

| | Before | After |
|---|---|---|
| Testing tasks graded | 6 | **82** (all of them) |
| Intrusive tasks graded | 12 | **147** (all of them) |
| General Inspections graded | 130 | 130 — **untouched** |
| Graded across the schedule | 148 | **359** |

**211 new `_gr` keys**, across 21 classes, every one id-based in the existing namespace — for
example `cbm_Riser_Adapter_1_2_1_gr` through `cbm_Riser_Adapter_1_3_6_gr`. No key renamed, re-typed
or removed. `_cm` and `_ph` unchanged, and **no task gained a photograph slot**: this build adds
grades, nothing else.

**Eighteen tasks were deliberately left exactly as they were** because they already carry grades
set from their own NOV documents. The one most at risk was **Flexloops 23.3.2**, which carries NOV's
own five-level criteria in an Intrusive section; overwriting it with pass/fail would have thrown
away published NOV wording. The build asserts it is intact.

### 47.3 What this changes about your grade views

Before today, a graded task was a **condition judgement on a 1–5 scale**. From REV 156, most graded
tasks in the schedule are **a pass or a fail**, and there are now more of them than there are
condition grades: 211 pass/fail against 148 condition.

That matters for anything that aggregates:

- **A fleet or class average grade is now close to meaningless.** It mixes a condition scale with a
  two-point outcome, and the two-point items will dominate by count and sit at the extremes.
- **A grade distribution** will show a large spike at 1 and 5 that is not a change in equipment
  condition. It is the arrival of these keys.
- **A heatmap by task** is fine, and arguably better — a failed pressure test now shows red where
  before it showed nothing at all.
- **"No grade 2s or 3s recorded" on a Testing task is correct**, not missing data.

**Our recommendation, which is yours to take or leave:** separate the two populations in any rollup.
A task whose criteria are the two pass/fail lines is a test result; everything else is a condition
grade. You can tell them apart today from `cbmlabels` plus the criteria text, but if you would
rather have it explicitly we will add the permitted levels per key as one additive block — say the
word, we did not add it unasked.

### 47.4 The note a crew sees

Dan asked for the convention to be defined on screen rather than assumed, and it is, under every one
of these tasks:

> NOV grade their condition-trigger inspections — pressure testing and dimensional inspection — as
> a two-point scale: grade 1 is a PASS, grade 5 is a FAIL. There is no middle grade on these.
> Wording per NOV D9D1008360-PRO-001_01 p14.

With it, the grade row shows **1, 5 and N/A only**, and a caveat line: *"NOV publishes only grades
1 and 5 for this item."*

### 47.5 One consequence worth naming

Three tasks that now carry a pass/fail grade are **NXT Body 6.3.6, "Replacement of Seal Plate"** —
the task behind anomaly A02, where Seadrill told NOV that a 1–5 condition grade on a component
replacement is meaningless and the grade was removed.

A pass/fail outcome is not a condition judgement, so this answers A02 rather than reversing it: did
the replacement pass or fail. It is recorded as **A25** in the NOV anomalies register going to Dave
Cargill, asking NOV to confirm — and if they do, **A01 and A02 can be closed.**

Two other rows went into the same register from the new documents: **A23**, Riser Spider item 1.9
publishing no criteria at all while the other nine in its section do; and **A24**, the four
different grade scales those two documents use between them.

### 47.6 Unchanged

`sdPostReport`, `collectCbm`, `gradeButtons`, `REPORT_POST_URL` and the filename logic
byte-identical. Zero `no-cors`, 0.82 intact, no duplicate top-level declarations, all script blocks
parse. The schedule's structure is asserted identical — same classes, sections, task ids, order and
wording; only flags and criteria were added. General Inspections sections are asserted untouched.

REV 155 6,814,422 → **REV 156 6,893,201 bytes**.

---

## Entry 46 — Two new NOV documents: a new equipment class, the Diverter finally graded, and a grade row that can now offer fewer than five buttons

**Rev: SSORT 155.** Status: **NEEDS ACTION** — 46.4 changes an assumption your heatmap and grade
history are built on. Read that one before the rest.

### 46.1 What arrived

Two NOV CBM inspection documents, 2 October. One of them is **the Diverter document we have been
recording as non-existent** — it exists, first issued 30 June 2025. The other covers equipment the
tool had no class for.

| Document | Covers | In the tool before | Now |
|---|---|---|---|
| `D9D1008360-PRO-001_01` | Diverter Assembly | class existed, 27 tasks, **0 graded**, document number blank | 27 tasks, **all graded**, document number set |
| `D9D1008477-PRO-001_01` | Riser Spider Assembly and Gimbal | **no such class** | **new class**, 15 tasks, 11 graded |

### 46.2 The new class and its key family

**`Riser Spider Assembly and Gimbal`** — the 23rd equipment class. Sections `3.1` General
Inspections (10 tasks), `3.2` Testing (2), `3.3` Intrusive Inspections (3). The key prefix is long
but ordinary:

```
cbm_Riser_Spider_Assembly_and_Gimbal_3_1_1_gr / _cm / _ph
...through...
cbm_Riser_Spider_Assembly_and_Gimbal_3_3_3_gr / _cm / _ph
```

Id-based, as entry 25 requires, so `3_1_3` stays section 3.1 task 3 whatever else moves. Eleven of
the fifteen are graded; the four that are not are the cleaning, greasing and lifting-gear items,
which are actions rather than inspections.

### 46.3 The Diverter: 27 new `_gr` keys

Every one of the 27 tasks is now graded — `cbm_Diverter_10_1_1_gr` through `cbm_Diverter_10_6_4_gr`.
Sixteen carry the universal scale; **eleven carry NOV's two-point test scale** (see 46.4).
`_cm` and `_ph` are unchanged.

**This revises a rule we gave you in September.** Until today, Testing and Intrusive sections were
never graded anywhere in the schedule, on Dan's rule that a task without a visual inspection does
not need a grade. His position on 2 October, verbatim: *"if NOV are grading the pass/fail criteria
on pressure tests and dimensional checks rather than a pass or a fail, then so should we shouldn't
we?"* NOV grade their own tests 1 passed / 5 failed, so the tool records the same thing.

A test **result** is gradeable because NOV publishes a grade for it. That is not the same as grading
a measurement, and the September rule still holds for the measurement itself.

**Scope, so you can size it:** this applies to the Diverter only in REV 155. Every other class still
has ungraded Testing and Intrusive sections. Whether they follow is Dan's call and not yet made.

### 46.4 **The one that affects you — a graded task may now offer fewer than five grades**

These documents do not use one scale. Between them, four conventions:

| Levels NOV publishes | Where | Count |
|---|---|---|
| 1, 2, 3, 4, 5 | the universal scale, everything before today | 110 tasks |
| **1, 3, 5** | Riser Spider visual and pressure tests | 9 tasks |
| **3, 5** | Riser Spider dimensional checks | 2 tasks |
| **1, 5** | Diverter tests and intrusive work | 11 tasks |

Tasks now carry an optional `levels` list. Where it is present the grade row renders **only those
buttons plus N/A**, and says so on screen: *"NOV publishes only grades 1, 3 and 5 for this item."*
Where it is absent — which is every task that existed before today — nothing changes and all five
still show.

**What this means at your end.** From REV 155, `cbmGrades` will contain tasks that **can never hold
a 2 or a 4**, and two tasks that can never hold a 1. Anything that assumes a graded task can take
any value 1–5 needs to expect that:

- a heatmap colouring by grade is fine, since the values that do arrive are still 1–5;
- a **distribution or average** across tasks is not, because a 1/5 task is bimodal by construction
  and will drag an average toward the extremes;
- a grade history that shows "no 2s recorded" for a Diverter test is **correct**, not missing data.

**We are not sending you the level list in the payload.** `cbmlabels` already carries the task
wording; if you want the permitted levels per key as well, say so and it is one additive key. We did
not add it unasked.

### 46.5 Dan's answers, for the record

He filled the review sheet and the sheet failed to save it — our fault, we sent an interactive file
in a mode that renders a static snapshot. His answers were recovered from a paste and are filed as
`NEW-CBM-REVIEW-ANSWERS.md`:

- **D1** restrict the buttons to the levels NOV publishes, with a caveat on screen.
- **D2** grade the Diverter's General Inspections against the **universal** scale; NOV's three
  item criteria are **not** attached and stay on file for a future assembly-level task.
- **D3** yes, add the Riser Spider class.
- **D4** grade all fourteen NOV items including the dimensional pair — with four per-task
  exceptions he marked himself.

One conflict, resolved the conservative way and flagged to him: he marked Riser Spider **1.9
"stored condition"** as *grade with NOV criteria*, but NOV publishes **no criteria** for 1.9. It is
graded against the universal scale, like the other criteria-less graded tasks.

### 46.6 Unchanged

`sdPostReport`, `collectCbm`, `REPORT_POST_URL` and the filename logic byte-identical. No key
renamed, re-typed or removed. Zero `no-cors`, 0.82 intact, no duplicate top-level declarations, all
script blocks parse. The REV 154 fixes (EHBS timer delay, surface-test restore) are asserted still
present. Every class except the Diverter is asserted byte-identical in `CBM_SCHED`; the Diverter's
task ids, order and wording are asserted unchanged — only flags and criteria were added.

Graded tasks across the schedule: **110 → 148**. Classes: **22 → 23**.

---

## Entry 45 — A rig reported one bug and we found a second one underneath it that was destroying whole surface-test records

**Rev: WCGRRT 167 and SSORT 154. BOTH DEPLOYED 1 October**, hash-verified and smoke-tested through
IIS. Status: **NEEDS ACTION** — 45.3 asks you to look for the damage in posted reports, because we
cannot see it from here.

### 45.1 What Jacob reported

Jacob Eric James, from the rig, 30 September, with a screenshot of the EHBS sequence timing block:
*"It won't let me add the time delay."* CSR closure stops (A) 21, UBSR closure starts (B) 32, and
**Timer delay (B − A) showing an empty box.**

He was right. The delay is **derived**, not typed — that part is deliberate, because two sources for
one number is how a record ends up disagreeing with itself. The defect was that it was only ever
computed at the moment the form was **drawn from saved data**. Nothing recomputed it while a crew
was filling the form in. So the cell sat at "—" and **`ehbs_tim_delay` posted empty, on every EHBS
test, in both tools**, unless the crew happened to save, reload and restore with both numbers
already in.

Reproduced on the deployed REV 166 with his own figures before changing anything: cell "—", key
empty, expected 11.

**Fixed in both tools.** The derivation is unchanged; it now recomputes as the crew types, on a
delegated listener so it survives the form being re-rendered. Verified: A alone gives "—", A and B
give 11, correcting B to 30 gives 9, clearing B returns to "—" without leaving a stale number.
**No new key** — `ehbs_tim_delay` already existed and already posted; it now carries a value.

### 45.2 The one underneath it — SSORT only, and much worse

Confirming Jacob's report meant restoring a saved EHBS record, and that is where this came out.

**Restoring a SSORT Surface BOP Testing tile destroyed the record, and the next autosave wrote the
destruction to disk.**

Five of the seven test forms are rig-keyed: `ehbsTestHTML`, `acousticTestHTML`, `drawdownTestHTML`,
`rovTestHTML` and `edsTestHTML` all begin by reading `#meta-asset` and return a *"Select the vessel
in Visit Information first"* placeholder without it. **`loadState()` creates the tiles first and
restores the rig thirty lines later.** So on a restore the form rendered the placeholder, the saved
readings were dropped on the floor, and because `collectSbop` reads the DOM, the next autosave
collected an empty form and overwrote the saved record with nothing.

Reproduced on the deployed REV 153: `ehbs_tim_csrStops` = `"21"` in storage before the re-save,
**absent after it.**

A second, narrower fault sat on top: the restore path's type mapping only listed four of the seven
forms — Acoustic, EHBS and Surface Drawdown were missing entirely. Those are exactly the three that
stopped being iframes most recently. When they went native the live path was updated and the
restore path was not.

**This is the Ram Cavity defect of REV 148 in a different block**, and the comment left at that fix
says so almost word for word: *"Every other place that sets meta-asset programmatically follows it
with `onAssetChange()` … The ram cavity block does: it takes its rig from here."* The surface-test
forms take their rig from there too, and nothing rebuilt them.

**Fixed three ways**, so it cannot recur the same way: one shared renderer `sbopWrapHTML(tt, sd)`
used by both the first render and the rebuild, so the two mappings can never drift apart again; the
tile keeps its own saved soak data, as the CBM tile already keeps `_cbmByEquip`; and both
report-restore paths rebuild the forms immediately after `onAssetChange()`, replacing a placeholder
only — never anything a crew has typed since.

Verified end to end: a restored EHBS record returns all 33 fields with its readings, the delay reads
11, and **the re-save now preserves it**. Acoustic (80 fields) and Surface Drawdown (54) likewise.

**WCGRRT does not have this defect** — its equipment entry restores all seven types and always did.

### 45.3 What we need from you, because we cannot see it

**Please look for the damage in what has already been posted.** From here we can only prove the
mechanism, not its reach.

1. **How many posted SSORT reports carry a `sbopData` with a `testType` set but an empty or
   near-empty `soak` object?** That is the signature of a record that was restored and re-saved.
   Acoustic, EHBS and Surface Drawdown are the likeliest; ROV and EDS are possible.
2. **How many posted reports from either tool carry `ehbs_tim_delay` as an empty string while
   `ehbs_tim_csrStops` and `ehbs_tim_shearStarts` both have values?** Those are recoverable — the
   delay is just B − A and you can compute it for display without us re-posting anything.
3. If any report has lost its soak block entirely, say which rig and date and we will go back to the
   crew's own saved `.json` if they still have it.

The timer delay matters on its own: it is the measured gap between CSR closure stopping and UBSR
closure starting on an EHBS activation, and it has been posting empty.

### 45.4 One thing about deployment you should know

After the copy, the browser kept serving **REV 166 from cache** until the URL was cache-busted. The
share and the hash were correct the whole time. **A rig that does not hard-refresh may keep running
the old build**, which matters here because Jacob is waiting on this fix. Ctrl-F5, or close and
reopen. Worth knowing for every revision, not just this one.

### 45.5 Unchanged

`sdPostReport`, `collectSbop`, `REPORT_POST_URL` and `reportFileName` byte-identical in both tools.
No new payload key in either. Zero `no-cors`, 0.82 intact, no duplicate top-level declarations, all
script blocks parse. Nothing was posted at any point: every Post path exercised in testing ran with
`fetch` disabled, and test state was cleared from both origins afterwards.

| | Bytes | SHA-256 |
|---|---|---|
| WCGRRT REV 167 | 3,342,479 | `c916a062d45736efc607f183ec027d3e04de4bba19d43ab6b80a5becb41430a6` |
| SSORT REV 154 | 6,804,809 | `f70d21f678b0fcbeac08fa715a9d161d95a8715a2eab97c23626d5eef3c9ee94` |

**The frozen build for the October class moves to WCGRRT 167 and SSORT 154.** The training pack is
updated.

---

## Entry 44 — `OEM_SEND_FILES` is on. The crew's test records now reach NOV as real email attachments

**Rev: SSORT 153. DEPLOYED 30 September**, hash-verified and smoke-tested through IIS. Status:
**FYI** — your ask from the Part D3 note, done the same day. Nothing owed. One thing to check at
your end is in 44.4.

### 44.1 Done as asked

Your words: *"Please flip `OEM_SEND_FILES` to true in the next SSORT revision and say so in the
rolling handoff; from that revision the crew's confirm can read 'attached for NOV'."*

Both, in REV 153. `files[]` now rides on every `seadrill-oem_*` payload that has attachments, in
the shape 42.6 announced and your Part D3 consumes:

```
files: [ { name, type, data } ]        // data is the full data: URI
```

`note` and `bytes` stay behind, as agreed — the flow has no use for either, and `cbmatt` on the
dashboard copy still carries both.

**Verified on the built file before it shipped**, with `fetch` disabled and the transport stubbed
so nothing was sent: two attachments, one PDF and one CSV, arriving on `files[]` with exactly
`name`, `type` and `data` and no stray keys; the dashboard post still first; `cbmatt` unchanged on
the dashboard copy. Then repeated against the deployed file as IIS serves it, cancelling at the
confirm, so no email left the building.

### 44.2 What the crew now reads

Before (REV 152):

> 2 test records: posted to the dashboard, and LISTED for NOV but not attached — the OEM
> attachment channel is not switched on yet.

Now (REV 153):

> 2 test records: posted to the dashboard, and attached to the email NOV receives.

**Both branches are still in the code**, selected by the constant. A single constant deciding what
the tool tells a crew is the only safe arrangement here: if the flow ever has to be switched off,
one edit puts the honest wording back, and there is no possibility of the tool claiming an
attachment reached NOV when it did not.

### 44.3 Your 43.3 correction is now in the file

You corrected us: **the flow no longer converts the HTML to PDF** — the tenant's converter refused
it, so the HTML is attached as it is. Our comment in the OEM code still said the conversion
happened, and a wrong comment on the posting path is how the next person gets it wrong. It now
reads:

> The flow does NOT convert the HTML report to PDF. The tenant's converter refused it, so the
> HTML is attached as it is and NOV open it in a browser. `pdfName` is still sent for the flow's
> own use; do not read it as evidence that a PDF exists.

`sourceFormat` is still `'html'` and both `pdfName` and `htmlName` are still sent, unchanged, so
nothing at your end moves.

### 44.4 The one thing worth checking before the first live one

The OEM copy's **30 MB refusal now has the attachments inside it**. That was written in REV 152 and
was dormant while the flag was off; from REV 153 it is live:

```
attBytes = OEM_SEND_FILES ? sum of the data: URI lengths : 0
mb       = (doc.length + attBytes) / 1048576
```

So a CBM report that sent to NOV yesterday at 24 MB of HTML plus 8 MB of charts is **refused
today**, and correctly — that is the ceiling doing its job. But it is a behaviour change on the
day the flag flipped, not a new limit, and the first crew to hit it will not know that. Your
figure and your reasoning, kept exactly: 20 MB warns, 30 MB refuses, and the message tells them to
post to the dashboard as normal and split the OEM copy by equipment section.

**NOV's gateway limit is still unknown to all of us.** The 30 MB refusal is our hard stop; a bounce
past it comes back to the office through the flow's NOT SENT branch, not to the rig, so if the
first live reports bounce it is your branch that will see it before we do. Worth watching for the
first week.

### 44.5 Unchanged

`postReport`, `sdPostReport`, `REPORT_POST_URL`, `reportFileName` and `sdSizeOk` are all
byte-identical to REV 152. The function list is identical — this build flips one constant and
rewords two messages, nothing else. Zero `no-cors`, 0.82 intact, `CBM_SCHED` untouched, the
precharge request untouched. The 20 / 8 / 15 MB attachment figures are asserted intact by the
build.

REV 152 6,799,847 → **REV 153 6,800,443 bytes**, sha256
`44cb4db89d2c2910086ff6c6a1c23a80034b6f53b0b44b0b326e0c31d2b161a1`, deployed to
`\\sdrlazneuiis01d.corp.local\SSORT\index.html`.

### 44.6 For the class

**The frozen build for 19 and 20 October is now SSORT 153**, not 152. The only difference the room
will see is the one line in the confirm, but the Day 1 pack says 152 in three places and the
training reply froze it there, so both are corrected in the pack rather than left to be noticed on
the day. Module 3's script now tells the crew their test records **do** reach NOV, which is the
opposite of what it said this morning.

---

## Entry 43 — SSORT 152 built to the entry 42 answers. `cbmatt` ships exactly as announced; one measurement detail you should know about your own 20 MB figure

**Rev: SSORT 152. DEPLOYED 30 September**, hash-verified and smoke-tested through IIS (see 43.6). Status: **FYI** —
your v2.73 work should need no change. Read 43.2, which is the only place the build is not
literally what the words said.

### 43.1 Your three answers, built

| Your figure | In the tool |
|---|---|
| 40 MB ceiling holds, control the input | `sdSizeOk` untouched, byte-identical |
| Warn at 8 MB a file | built |
| **Refuse** a single file above 20 MB, at attach time | built — refused outright, nothing attached |
| Warn when attachments pass 15 MB in total | built — names the running total and the ceiling |
| Whitelist: PDF, images, CSV, text, Office. Nothing executable | built, by extension |
| Same-day repost is an update | relied on — the OEM button posts the dashboard copy first under the unchanged filename |
| Part D3 can take `files[]`, but not until proven in test mode | **`OEM_SEND_FILES = false`** — see 43.3 |

`cbmatt` is exactly the shape announced in 42.3 — `name`, `type`, `bytes`, `note`, `added`,
`data` — and is **omitted entirely when there are none**, so a CBM report with no
attachments is byte-for-byte what REV 151 produced.

### 43.2 Your 20 MB is measured on the EMBEDDED size, not the file on disk

This is the one thing in the build that is an interpretation rather than a transcription, so
it is stated rather than buried.

A 16 MB PDF becomes about 21 MB as base64 in the payload. **The thresholds fire on the
embedded figure**, because that is what weighs against the 40 MB ceiling — your own reason
for the limit was "one file that size plus a normal photograph set breaches the ceiling in a
single press", and the thing that breaches it is the encoded bytes. WCGRRT's existing 8 MB
warning has always worked this way too, so the two tools agree.

The consequence for a crew is that a file they see as 16 MB is refused by a limit called
20 MB. Rather than move the threshold, **both numbers are named in the message**:

> "survey_scan.pdf" is 16.0 MB, and 21.3 MB once embedded in the report.
> A single file above 20 MB embedded is refused here, because that file plus a normal
> photograph set puts the whole report over the dashboard ceiling in one press.

The row in the list shows the **file** size, which is what the crew recognises. `cbmatt.bytes`
is also the decoded file size — so **your budgeting figure is the file, not the base64**.
If you would rather the threshold moved to the file size instead, say so and it is one
constant; nothing else changes.

### 43.3 NOV does not get the attachments yet, and the crew is told so

`files[]` is written and sits behind `OEM_SEND_FILES`, false in what ships, per your
sequencing — Dan builds Part D3 after the Help flow and proves it in test mode first. The
send path and its size accounting are already written for the flag being true, so the day
D3 is proven it is one constant and no new code.

Until then the confirm the crew sees says it plainly, so nobody believes NOV received a
chart that stayed behind:

> 1 test record: posted to the dashboard, and LISTED for NOV but not attached — the OEM
> attachment channel is not switched on yet.

The OEM copy **lists** attachments in a metadata table (name, what it evidences, type, size,
added) and **never carries their bytes** — verified by search on the generated document. Two
reasons, both real: the OEM copy inlines the report HTML and then base64s the whole thing, so
embedding would carry every file twice and push an ordinary report past the OEM 30 MB refusal;
and a `data:` link does not survive the flow's HTML-to-PDF conversion, so it would be a dead
link in NOV's copy regardless.

### 43.4 Post to OEM → dashboard first, verified by stub, nothing posted

The order you were told to expect is the order built, and it was proven with the transport
stubbed and `fetch` made to throw, so no test post reached the server:

```
1. seadrill-report_SSCE-Equipment_2026-09-30_cbm-inspection.json     (dashboard, 182,020 bytes)
2. seadrill-oem_SSCE-Equipment_2026-09-30_Riser-Adapter_cbm.json     (OEM,       288,349 bytes)
```

The dashboard post carried `cbmatt` with the note intact; the OEM payload carried **no
`files` key**. The two outcomes are reported to the crew separately, because they can
differ — the OEM copy refuses at 30 MB while the dashboard accepts to 40.

`postReport`, `sdPostReport`, `REPORT_POST_URL`, `reportFileName`, `sdSizeOk` and
`buildReportPayload` are all **byte-identical to REV 151** — the existing path is called
from a second button, not modified.

### 43.5 Verified

Two script blocks parse, extraction reconciles to 97.1% of the file, zero duplicate
top-level declarations, zero `no-cors`, 0.82 unchanged at 8 occurrences, `CBM_SCHED`
unchanged, the precharge request untouched. Exercised in a browser on `SSCE Equipment` /
Riser Adapter: attach, whitelist refusal of an `.exe`, the 20 MB refusal, notes, running
total, removal, and **crash recovery** — a restored report brings both files back with
their notes, bytes and data, and the footer total is correct on first paint.

REV 151 6,782,830 → **REV 152 6,799,847 bytes**.

### 43.6 Deployed, 30 September

`\\sdrlazneuiis01d.corp.local\SSORT\index.html` — sha256
`05133b2283aec4cff5cf38c8a46e16733c737d8641a1ca0a64221335bc72c334`, 6,799,847 bytes,
byte-identical to the `SSORT REV 152` folder and to the file the tests above ran against.
The live file was confirmed to be exactly REV 151 immediately beforehand, so nothing else
had changed underneath it.

Smoke-tested on what IIS serves, at `http://sdrlazneuiis01d.corp.local:8080/SSORT/index.html`:
badge reads REV 152, the attachments block renders on Riser Adapter alongside its 11 grade
rows and 11 photograph grids, a PDF attaches and reaches `cbmatt` with its note and decoded
`bytes`, an `.exe` is refused, the running total reads correctly, and the rendered report
carries no attachment bytes. Zero console errors. **`fetch` was disabled for the duration,
so nothing was posted**, and the test state was cleared from that origin afterwards.

**So `cbmatt` can now arrive on a real rig post at any time.** Your v2.73 reader is already
built for it.

---

## Entry 42 — Two changes coming to the CBM path: file attachments on every equipment, and Post to OEM will also post to the dashboard

**Rev: SSORT 152. NOT BUILT YET — this is the announcement, ahead of the code.** Status:
**NEEDS ACTION** — two decisions are yours, and the first one gates the build.

### 42.1 Announced before the build this time, deliberately

Entry 41.6 conceded that eleven `_ph` keys shipped before you were told. This entry is the
correction of that habit rather than an apology for it: nothing below exists in a deployed
file, and nothing will be built until 42.5 comes back answered.

### 42.2 Attachments — what Dan asked for, and why NOV asks for it too

Dan, 30 September: *"when we do any CBM we need to be able to upload attachments as we need
to upload test records. this will be on every equipment entry."*

This is not a new requirement so much as an unmet one. NOV's own task wording already
instructs the crew to attach documents, in the tool's own text, today:

- *"Description of Test, test for low pressure: record time held and **attach test graph**"*
- *"Description of Test, test for high pressure: record time held and **attach test graph**"*
- *"9.1 Operator Testing, **upload test charts**"*

The tool has been telling crews to attach a test chart and giving them nowhere to put it.
In practice a pressure-test chart either never reaches you, or reaches you as a photograph
of a screen in a `_ph` array — which is why you may have seen chart recorder images sitting
in photo slots. They were never photographs. They were documents with no home.

### 42.3 The new key: `cbmatt`

One array per CBM report, top-level on `cbmData`, sibling to `cbmlabels`. Lower case,
additive, nothing renamed.

```
cbmData.cbmatt = [
  { name : "WCAP_RiserAdapter_mudseal_test_2026-09-30.pdf",
    type : "application/pdf",
    bytes: 1843200,                       // decoded size, for your budgeting
    note : "1.2.1 mud seal test to rated pressure",
    added: "2026-09-30T08:14:22.000Z",
    data : "data:application/pdf;base64,JVBERi0xLjQK…" }
]
```

`data` is a **full data URI**, the same shape as WCGRRT's existing `refDocFile`, so if you
already render that you can reuse the renderer unchanged — a download link for non-images,
an inline `<img>` for images. Absent or empty `cbmatt` means no attachments; it will not
appear on reports that have none.

**Why one array per equipment and not one per task.** Dan's words were "on every equipment
entry". Per-task would mean roughly 2,400 new keys across the 22 equipment classes, for a
thing crews will use a handful of times per report. `note` is free text and carries the task
reference instead — so `1.2.1` above ties the chart to its task without a key for every task
in the schedule that might one day have a document.

### 42.4 The part that actually affects you: uncompressed bytes enter the payload

Every file input in SSORT today is `accept="image/*"` — nine of them, no exceptions — and
every image goes through `compressDataUrl`, which re-encodes through a canvas at 1600 px and
0.82. That is why a 6 MB phone photograph reaches you at roughly 300 KB.

**A PDF cannot be canvas-compressed.** It carries its full size into the payload, plus about
33% for base64. This is the first content in a SSORT post that is not size-controlled on the
way in.

The arithmetic against the ceiling:

| | |
|---|---|
| Largest real CBM report seen (West Capella Riser Adapter, 48 photographs) | **14.27 MB** |
| Riser Adapter also gained 66 photograph slots in REV 150 | *more, not yet measured in the field* |
| One 3 MB test chart, encoded | **+4 MB** |
| Five of them | **+20 MB** |
| Current CBM ceiling, yours and ours | **40 MB** |

A Riser Adapter report with a full photograph set and five test charts is a plausible
breach of 40 MB, not a contrived one.

**We are not inventing a mechanism for this.** WCGRRT already solved it: `sdReadAttachment`
accepts PDFs and Office files, routes images to `compressDataUrl` and warns at 8 MB per file
in words that name the real reason — *"a PDF or Office file cannot be compressed the way a
photo can, so it carries its full size into every copy of this report."* SSORT does not have
that function at all (`grep` count: WCGRRT 6, SSORT 0). The build ports it across rather
than writing a second one.

**DECISION 1, yours: does the 40 MB CBM ceiling hold?**

Our recommendation is **hold it at 40 MB** and control the input instead — a per-file cap
and a per-report attachment budget with a warning, plus a type whitelist (PDF, images, CSV,
plain text, Office). Reasons: Dan's standing rule is that evidence is never degraded to fit
a limit, and a post your scanner refuses is worse than one it finds slow. But the scanner is
yours and the 40 MB figure was your decision on 15 September (entry 9), so the call is too.

Tell us the number and the build takes it. If you would rather attachments were capped hard
per report, say the figure and we will refuse above it in the tool, at the point the crew
attaches the file, rather than at the point they try to post a finished report.

### 42.5 Post to OEM will also post to the dashboard

Dan, 30 September: *"i would like the post to OEM button to also post to the dashboard."*

**Today** they are two independent buttons and the tooltip says so in as many words:
*"Separate from Post to Dashboard — either, both, in any order."* `postCbmToOem` builds its
own `kind:'oem-copy'` payload and posts `seadrill-oem_…_cbm.json`. It does not touch the
dashboard post at all.

**After the change**, one press does both, in this order:

1. **Dashboard post first**, unchanged — `buildReportPayload()`, `sdSizeOk`, the existing
   filename, the existing transport. That is the record of truth and it goes first.
2. **Then the OEM copy**, unchanged — its own payload, its own filename, its own 20 MB warn
   / 30 MB refuse.

The two outcomes are reported separately, because they can differ: the OEM copy can be
refused at 30 MB while the dashboard post at 40 MB succeeds, and the crew must not read one
failure as both.

**Three things this means at your end:**

- **`seadrill-report_<rig>_<date>_<type>.json` may now arrive triggered from a CBM tile**, at
  a moment when the crew was thinking about NOV rather than about you.
- **The dashboard post is the whole report, every tile — not just the CBM tile the button
  sits on.** That is existing `postReport` behaviour and we are not changing it, but it is
  worth you knowing why a report may now land earlier in its life than before.
- **The filename is unchanged, so a later post replaces an earlier one for the same rig,
  date and report type.** Pressing Post to OEM and then Post Report produces one file, not
  two, and the second is the same report or a superset of it.

**DECISION 2, yours: confirm a same-day repost is an update and not a duplicate row.** We are
asking rather than assuming, because entry 11 was precisely about daily reports overwriting
each other and we do not know which way scanner v2.50 resolved it.

### 42.6 Should NOV get the attachments too? A question for Part D

The OEM copy travels as HTML which your flow converts to PDF. **An attached PDF cannot be
embedded in that HTML** — at best it rides as a data URI that survives the conversion as a
dead link.

If NOV should receive the test records — and on a condition-based monitoring review they are
arguably the most useful thing in the report — the flow needs them as **separate
attachments**. That would be a new optional key on the `oem-copy` payload:

```
files: [ { name, type, data } ]      // same objects as cbmatt, minus note/bytes
```

**We are not building that until you say Part D can take it.** If the answer is no, the tool
will say so plainly at the point of sending, so nobody believes NOV received a chart that
stayed behind.

### 42.7 What is not changing

Posting path, transport, existing payload keys, filename logic, photo compression 0.82,
`sdSizeOk`'s structure, zero `no-cors`. `postReport` is called, not modified. The OEM
payload gains nothing unless 42.6 is answered yes.

### 42.8 What we need back

| | Ask | Blocks |
|---|---|---|
| **1** | Does the 40 MB CBM ceiling hold with uncompressed attachments in the payload? A per-file cap figure if you want one. | **the build** |
| **2** | Confirm a same-day repost of `seadrill-report_*` is an update, not a duplicate row. | the OEM/dashboard merge |
| **3** | Can flow Part D take `files[]` as real attachments for NOV? | 42.6 only — the rest proceeds either way |

---

## Entry 41 — Riser Adapter could not be photographed or graded at all. 22 new keys, and it closes the one discrepancy entry 18.2 left open

**Rev: SSORT 150 (photographs) and 151 (grades), both now deployed.** Status: **FYI** —
22 new keys in the families you already read. Nothing to build; read 41.4, which corrects
something entry 18.2 told you.

### 41.1 What was wrong

Brad Waldron, 29 September, from the rig: no way to attach a photograph to a Riser Adapter
inspection, and no grading on it either.

He was right on both counts, and it was the only class in the schedule like that. Of its
**22 tasks: 0 carried a photograph slot and 0 carried a grade button.** Every other
equipment class in `CBM_SCHED` carries both on its General Inspections section. So a Riser
Adapter CBM report has never been able to record a condition, and the evidence a crew took
had nowhere to go.

### 41.2 The 22 new keys, in full

All additive, lower case, in the families you already parse. Nothing is renamed, re-typed
or removed.

**Photographs — SSORT 150** (arrays of data URIs, same shape and 0.82 compression as every
other `_ph`):

```
cbm_Riser_Adapter_1_1_1_ph      cbm_Riser_Adapter_1_1_7_ph
cbm_Riser_Adapter_1_1_2_ph      cbm_Riser_Adapter_1_1_8_ph
cbm_Riser_Adapter_1_1_3_ph      cbm_Riser_Adapter_1_1_9_ph
cbm_Riser_Adapter_1_1_4_ph      cbm_Riser_Adapter_1_1_10_ph
cbm_Riser_Adapter_1_1_5_ph      cbm_Riser_Adapter_1_1_11_ph
cbm_Riser_Adapter_1_1_6_ph
```

**Grades — SSORT 151** (`"1"`–`"5"` or `"N/A"`, same as every other `_gr`):

```
cbm_Riser_Adapter_1_1_1_gr      cbm_Riser_Adapter_1_1_7_gr
cbm_Riser_Adapter_1_1_2_gr      cbm_Riser_Adapter_1_1_8_gr
cbm_Riser_Adapter_1_1_3_gr      cbm_Riser_Adapter_1_1_9_gr
cbm_Riser_Adapter_1_1_4_gr      cbm_Riser_Adapter_1_1_10_gr
cbm_Riser_Adapter_1_1_5_gr      cbm_Riser_Adapter_1_1_11_gr
cbm_Riser_Adapter_1_1_6_gr
```

The `_cm` comment keys on these eleven already existed and are unchanged. The ids are the
**id-based** namespace of entry 25, not the positional one — `1_1_7` is section 1.1 task 7,
and it stays that task whatever else moves in the schedule.

Six photograph slots per task, so a fully-evidenced Riser Adapter report gains up to 66
images. Entry 6's finding stands: this class already produced the largest CBM reports in
the fleet (the West Capella report in 41.7 was 14.27 MB at 48 photographs). It is inside
the 40 MB CBM ceiling, but it is the class most likely to approach it.

### 41.3 Why eleven tasks and not all 22

The class has three sections. Only **1.1 General Inspections (11 tasks)** is graded and
photographed. **1.2 Testing (5)** and **1.3 Intrusive Inspections (6)** get neither.

That is not our reading of the house pattern — it is what NOV's own schedule says. Sheet
`Riser Adapter` of `136151848 Rev 01 CBM Maintenance Schedule Compiled, 7 July 2026`,
column F `EVIDENCE REQUIRED`:

| Section | Column F |
|---|---|
| **1.1 General Inspections** | **`PHOTOS & GRADE CONDITION`** |
| 1.2 Testing | *(blank)* |
| 1.3 Intrusive Inspections | *(blank)* |

Every one of the eleven tasks in 1.1 begins "Visual inspection of…", and the build asserted
that before writing — if one of them had not, it stopped rather than apply the rule blindly.

It also matches Dan's two standing rules: a task without a visual inspection does not need a
grade, and a dimensional inspection cannot be graded until the measurements are verified.
Three independent lines agreeing is why this one did not need a review sheet first.

**One honest qualifier.** NOV marks the **section header row**, not each of the eleven
sub-tasks. Entry 18.2 argued against reading a section mark as cascading, on the evidence
that NOV marks sub-tasks individually elsewhere (C&K Stabs, BOP Mandrel, Gate Valves) and
leaves siblings blank within one section (Poslock Door). That argument is about whether a
mark **reaches** an unmarked sibling. Here there is nothing to reach past: no task in 1.1 is
marked, the section is, and 1.2 and 1.3 are blank. The section-level mark is the only
instruction NOV gives for this class.

### 41.4 This closes entry 18.2 — and corrects it

Entry 18.2 (22 September) listed Riser Adapter 1.1 as the one discrepancy running the other
way: NOV marks it, the tool did not grade it. It then said this was *"apparently covered on
the `CBM_GRADED` path instead, which we are confirming rather than assuming."*

**That was wrong, and entry 25 is why.** `CBM_GRADED` is dead code in the deployed build —
nothing reads it, and its keys are positional. Riser Adapter 1.1 was not covered on another
path. It was not covered anywhere, on any path, and had not been since the class was built.

So the correction is worth stating plainly: for five weeks the fleet's Riser Adapter CBM
reports recorded no condition grade and no photographic evidence, and our own handoff had an
explanation on file for why that was fine. It took Brad on a rig to find it. If you hold a
count of graded tasks per class, **Riser Adapter's historical zero is real, not a parsing
failure at your end** — do not go looking for the rows.

### 41.5 No criteria are attached yet

The eleven tasks fall back to NOV's universal GRADE LEVEL EVALUATION GUIDE on the ⓘ button,
like the other fourteen graded tasks that carry no item criteria. Nothing reaches
`cbmlabels` beyond the task descriptions above.

NOV document `129391676 Rev 01 CBM BOP RISER ADAPTER ID 1` **does** publish 16 items with
complete five-level criteria for this class. They are not in the tool yet because NOV's item
numbering does not line up with the tool's task ids, and matching by wording is exactly what
put threaded-hole criteria onto weld seams last week. That mapping is on a review sheet with
Dan. When it lands it changes **text only** — no key changes, same as entries 26, 32 and 35.

Graded tasks across the whole schedule: **99 → 110**. Tasks carrying NOV item criteria:
**85, unchanged.**

### 41.6 The photograph keys are being announced late, and that is on us

The rule is new keys are announced **before** they ship. The eleven `_ph` keys shipped in
SSORT 150 and were deployed on 28 September; this entry is the first you are hearing of
them. The `_gr` keys are announced on the day they deploy, which is also not before.

Nothing breaks from it — they are new keys in a family you already iterate, so a report
carrying them rendered correctly the moment it arrived, and no report has yet been posted
with either. But you were entitled to the list first and did not get it. The cause was
running a fix straight from a rig report to deployment in one sitting; the announcement is
part of the change, not a write-up afterwards.

### 41.7 Verified before deploying

Opened in a browser on asset `SSCE Equipment`, Riser Adapter selected: **11 grade rows, 11
photograph grids, 11 `_gr` keys present, zero console errors.** Graded a task through the
button as a crew would — `cbm_Riser_Adapter_1_1_1_gr` arrived in the payload as `"3"` and
the notes prompt appeared. Repeated against the deployed file as IIS serves it, same result,
and the test state cleared from that origin afterwards. Nothing was posted.

The build refused to write unless the task count, task order, every description, the photo
count and the criteria count were all unchanged outside the eleven — they were.

### 41.8 Nothing else moved

Posting path byte-identical. Zero `no-cors`. Photo compression 0.82, ceilings unchanged.
Both script blocks parse, extraction reconciles, no duplicate top-level declarations.
REV 151 is **6,782,830 bytes**, 11 fewer than REV 150 at 6,782,841 — the eleven tasks
carried `grade:false` explicitly and now carry `grade:true`, one byte shorter each. *(Entry
40.5 closed REV 150 at 6,782,852; that figure was written before the photograph work landed
in the same revision. The deployed and hash-verified figure is 6,782,841.)*

---

## Entry 40 — `calcData` now carries the per-cavity verdict and the rows behind it, as asked. And three corrections to the 27 September summary

**Rev: SSORT 150.** Status: **FYI** — your ask from the entry 36 reply, built. Nothing else owed.

### 40.1 The ask, built

Your words: *"the viewer can show '2 pass, 1 fail' from the summary and cannot say which
cavity failed or on which check."* Right, and that was a gap in what the tool published
rather than anything you were missing.

Each entry in `calcData.cavities[]` now carries three more fields:

```
status    : "pass" | "fail" | "est" | "nospec" | "na"      the cavity's overall verdict
ramLabel  : "Blind / Wireline Shear — CVX-W"                what it was judged as
checks[]  : [ { item, measured, nominal, status, note } ]   the rows behind the verdict
```

`checks[]` is exactly what `evalCavity` already returned — nothing is computed that was not
being computed before, it is just published now. A worked example from a test stack:

```
UBSR  status "pass"   ramLabel "Blind / Wireline Shear — CVX-W"
UPR   status "fail"
      check: item     "Vertical (skid plate–to–seal seat)"
             measured "7.249 in / 7.281 in / 7.260 in / 7.255 in"
             nominal  "7.250 in – 7.270 in"
             status   "fail"
             note     "Outside nominal limits — inspect/shim per TR-WCE-331-038"
```

`measured` and `nominal` are **already formatted in the unit the crew used**, so you do not
need the 25.4 conversion to display them; `unit` still governs the raw readings in
`vertical` / `horizontal` / `block`, which are unchanged.

**Cost:** about 3.2 KB for a seven-cavity stack. Immaterial against a report carrying
photographs, and it only appears on tiles that have a cavity stack.

Your rule holds on both sides: the tool judges, you display. Nothing here asks you to
recompute anything, and the `est` / `nospec` / `na` cautions in 36.3 apply to `status`
exactly as they do to the summary.

### 40.2 Correction — two items I listed as open were closed, and I should have known

The **27 September action summary** told you two decisions were still sitting with you:

- **Grade 3 in the fail bucket** (entry 21) — you decided this **23 September**, with us:
  1 and 2 blue, 3 orange "acceptable with findings, monitor", 4 and 5 red.
- **The 30 MB vs 40 MB ceiling** (entry 9) — you decided this **15 September**: 40 MB for
  CBM and PDC, scanner v2.48, matching SSORT.

Both were answered in your reply file and neither was open. I built that summary from the
**open-items table at the top of `DASHBOARD-ROLLING-HANDOFF.md`**, which is written when an
entry ships and never updated when you answer it. So the table has been drifting out of
date for weeks and I read it as current.

**Fixed two ways.** The table is now reconciled against your reply file — every entry you
have answered is marked closed with the date you answered it. And the rule from here: the
status column is updated when a reply lands, not only when an entry is written.

Sorry for the re-reading.

### 40.3 Correction — the `<img>` risk was overstated

I ranked "your renderer might strip `<img>` from narrative HTML" as the first thing to do
and called it the one that fails silently. You checked, and your sanitiser removes
`script`, `style`, `iframe`, `object`, `embed`, `link`, `meta`, `form`, `base`, `on*` and
`javascript:` — **and nothing else**. An `<img>` with a data URI was never at risk.

The entry itself was written as a conditional (*"if your renderer strips…"*), but the
summary turned it into a likely failure, and that is not the same thing. Checking your code
before ranking it was the right response and it was yours, not mine.

What was real in that entry was the `×` control, and you have handled it in both the
renderer and the digest.

### 40.4 Also noted from your reply

- **`SSCE Equipment` was already in `NON_RIG_BUCKETS`** since WCGRRT 153. Listing it as
  NEEDS ACTION was redundant, though the two rollups you tightened as a result — Compliance
  and Rig Monitoring — were worth finding.
- **Riser Tally** (Dan, 26 Sep: per rig, embedded in SSORT, after the failure reporting) is
  on your plan as item 32 and is not started on this side either.

### 40.5 Nothing else moved

Posting path byte-identical. Zero `no-cors`. Photo compression 0.82, ceilings unchanged.
Both script blocks clean, extraction reconciles, no duplicate top-level declarations.
**REV 149 is untouched** and remains what is deployed until 150 is uploaded.
File 6,781,942 → **6,782,852 bytes**.

---

## Entry 39 — Reference photo captions are now editable in the tool. Still not posted, still no key

**Rev: SSORT 148.** Status: **FYI** — nothing to build. Recorded because it changes what a crew sees, and because there is one thing worth knowing if a caption ever reaches you by another route.

### 39.1 What changed

Entry 38.4 introduced `CBM_REFMETA` — 51 reference photographs carrying the task they
illustrate, the grade they show and a note, assigned by Dan from field experience because
NOV publish no graded reference photographs at all.

Those were baked into the build. Anything learned afterwards — a better task match, a grade
worth revising, a photograph that can now be named — needed a round trip through the
development session. It no longer does. The Reference Photos section has **Edit captions**,
**Export edits** and **Reset to built-in**.

### 39.2 Where the edits live, and why not in the payload

**Reference photographs are identical on every rig and in every report.** They are the
document's figures, not the crew's evidence. If a caption edit rode in the payload it would
be duplicated into every posted file, would differ between rigs depending on who had edited
what, and you would have no way to tell which copy was authoritative.

So the edits are held in **`localStorage`, per browser**, layered over the built-in set when
the section renders. **Nothing is collected and nothing is posted — there is no new key and
no existing key changes.** Verified on a built payload: no trace of an edited caption
anywhere in it.

The authoritative copy stays in the build. **Export edits** produces the changed set as
text, in the same shape the review sheet produced, to be sent back and built in for the
fleet in the next revision.

### 39.3 The one thing worth your attention

If a caption ever reaches you — quoted in a comment, pasted into a narrative, or in a
future revision of this store — **treat it as Seadrill field experience, not as NOV
guidance.** It is labelled that way on screen for the same reason:

> *Where a figure carries a task and a grade, that is Seadrill field experience, not NOV:
> the NOV documents publish no graded reference photographs.*

That distinction matters if grading data is ever audited. A grade a crew assigned to a
component is a record. A grade on a reference photograph is one superintendent's opinion of
what that photograph shows, offered to make crews more consistent with each other. The two
should never be conflated in a rollup.

### 39.4 Nothing else moved

Posting path byte-identical. Zero `no-cors`. Both script blocks clean, extraction
reconciles, no duplicate declarations. The edit controls are `display:none` in print.
File **6,774,894 → 6,781,942 bytes**.

---

## Entry 38 — SSORT 148 closed out: nine more keys stop posting, a new `meta.asset` value, and West Vela's EDS was stamped with a revision it did not contain

**Rev: SSORT 148.** Status: **NEEDS ACTION** — a new rig name will start appearing, and nine keys stop. Both named in full.

### 38.1 A new value in `meta.asset` — **`SSCE Equipment`**

The vessel list gains one option at the end: **`SSCE Equipment`**. It is the test asset,
added so a test post is distinguishable from a real rig post rather than borrowing a real
rig's name.

**What you need to do:** treat `meta.asset === "SSCE Equipment"` as **not a rig**. Keep it
out of fleet counts, compliance percentages, per-rig histories and anything that rolls up
by vessel. It is the only value in that list that is not a drilling unit.

Nothing has been posted from it and nothing will be until Dan does it deliberately.

### 38.2 Nine keys stop being posted

**`6.3.6 Replacement of Seal Plate`** — a replacement task carrying a 1–5 grade. Dan,
26 Sep: *"no grade here require."* This is the general form of the cleaning-task decision in
entry 35 — his rule is *anything without a visual inspection on it does not need a grade* —
and an audit over all 104 graded tasks found this was the only task left that the rule
caught. After it, **zero** graded tasks lack an inspection verb.

```
cbm_Single_NXT_Body_6_3_6_gr
cbm_Upper_Triple_NXT_Body_6_3_6_gr
cbm_Lower_Triple_NXT_Body_6_3_6_gr
```

**`7.1.6B Visually inspect blades`** — removed from the two ram block types that have no
blades. Both inherit the NXT ram block document, which covers shearing types in the same
schedule. All three suffixes go, because the task itself is gone rather than degraded:

```
cbm_Ram_Block__PipeBlindFixed_7_1_6B_gr / _cm / _ph
cbm_Ram_Block__BiDirectional_7_1_6B_gr / _cm / _ph
```

As with entry 35: absence means *"there was nothing to inspect"*, not *"missing"*. Rows
already in your index stay and should stay visible.

### 38.3 `6.1.6` external welds — criteria withdrawn, no key change

`6.1.6 Visually inspect all external welds` had taken NOV's **threaded holes** criteria on
all three NXT body classes, matched by text overlap. Weld seams and fasteners are
unrelated, and Dan said so. The criteria and their provenance are stripped; the task keeps
its grade and falls back to the universal GRADE LEVEL EVALUATION GUIDE. **The key is
unchanged** — only what the crew reads before choosing a grade. Raised with NOV as row A21
of the anomalies register.

Coverage is now **99 gradeable tasks, 85 carrying NOV item criteria, 14 without**.

The count fell from 104 because eleven tasks left the graded pool across entries 35 and 38 — nine cleaning tasks (`7.1.1B`), three `6.3.6`, and two `7.1.6B`, the last two also leaving the schedule entirely. The without-criteria figure rose from 11 to 14 because `6.1.6` gave up its borrowed threaded-holes criteria on all three NXT body classes, as described just above.

### 38.4 Reference photographs now carry a caption — not posted, no key

`CBM_REFMETA`, a new store keyed `"<class>#<index>"` against `CBM_REFPHOTOS`. **It is
display only and is never collected or posted**, so there is nothing for you to build —
recorded because it changes what a crew sees when they grade.

Until now the Reference Photos section could say only *"Reference figure 7"*. Fifty-one
photographs now carry the task they illustrate, the grade they show where they show one,
and a note. **Nineteen carry both a task and a 1–5 grade** and are outlined so they stand
out from general reference.

Worth knowing why this had to be done by hand: **NOV publish no graded reference
photographs at all.** Across all 44 document files there are 3,751 references to grades, 6
references to figures, and **not one line tying a figure to a grade**. There was nothing to
read out of the documents. This is Seadrill field experience and is labelled as such on
screen. It is row A19 of the anomalies register, and the single biggest lever on grading
consistency across the fleet.

Eight figures are filed under **NXT Body**, where the hinges physically mount, but carry an
`also` list so they surface on **U2B Door** and **Poslock Door** as well — they are
door-to-body locking components, and a crew grading `9.1.1` needs to see them.

### 38.5 West Vela's EDS sequences were stamped Rev H and contained Rev G

Found while checking a fault Dan reported. The tool **and** the source verification workbook
both stamp **Rev H**, and both still carried the six **EHBS Preselect** steps that NOV
20093383D Rev H's own change note says were removed — *"SEQUENCE 1, SEQUENCE 2, SEQUENCE 3,
SEQUENCE 4. Removed EHBS Preselect function."* The revision label had been updated and the
content had not.

There were timing differences too, confirmed against the document text: SEQ1
`FSC Valve Accumulators Isolate` **10 s in Rev H, 14 s in the tool**; `Wetmate Connector
Retract` **10 s / hyd 22** against **14 s / hyd 23**; `Acoustic Stabs Retract` **10 s /
hyd 49** against **14 s / hyd 36**.

Rebuilt from the Rev H document. **No posted report anywhere carries an EDS key** — checked
across every posted file in the project — so no positional key resolves differently and no
history is affected. The other eleven rigs are untouched and were not changed.

**Worth your attention:** the same eleven workbooks came from the same place. All twelve
match their workbooks exactly, which proves only that they agree with each other. If you
hold NOV EDS documents for any other rig, they are worth the same comparison.

### 38.6 Nothing else moved

Posting path byte-identical to REV 147 — same line count, same bytes. Zero `no-cors`. Photo
compression still 0.82. Every existing `data-soak`, `data-cbm`, `data-vsr` and `data-cf`
key present. Both script blocks `node --check` clean, extraction reconciles, no duplicate
top-level declarations. Exercised end to end on `SSCE Equipment` with one tile of each of
the six major types and a payload built: **zero console errors**.

File **8,941,320 → 6,774,894 bytes**.

---

## Entry 37 — WCGRRT narratives can now contain images. No new key, but `notes` and the `vsrData` narrative fields change shape

**Rev: WCGRRT 166.** Status: **NEEDS ACTION** — one rendering change, and it fails silently if you miss it.

### 37.1 What changed

A report writer can now place an image **inside the narrative text**, where the sentence
needs it, rather than only in the photograph run at the end. Two per box, labelled REFA
and REFB. It is for the thing a reader must see immediately — the clause of the standard
being cited, the drawing detail being described, the control screen a reading came from.

Three ways in: paste a snip (`Win+Shift+S`, `Ctrl+V`), a **Reference** button on the
narrative toolbar, or drag an image file onto the box.

### 37.2 What it means for you — **no new key, but read this**

**No new payload key.** The image rides inside the narrative HTML you already receive:

- `tiles[].notes`
- `tiles[].equipEntries[].notes`
- `tiles[].vsrData.concerns` / `.actions` / `.forecast`
- `meta.next24`, `meta.summary24`

Each reference arrives as this fragment, inline in that HTML:

```html
<span class="rte-ref" contenteditable="false" data-ref="A">
  <span class="rte-ref-del" ...>×</span>
  <img src="data:image/jpeg;base64,...">
  <span class="rte-ref-lbl">REFA</span>
  <span class="rte-ref-cap">the writer's caption, may be empty</span>
</span>
```

**If your renderer strips or sanitises `<img>` out of that HTML, the reference disappears
and nothing tells anyone** — not the crew who added it, not the reader, not you. The
sentence still reads "…outside the limit at REFA" and there is no REFA. That is the one
thing worth checking before this lands.

Two smaller points:

- `<span class="rte-ref-del">×</span>` is a screen-only delete control. It is `display:none`
  in print. **Suppress it in your renderer too**, or every reference shows a stray ×. It is
  a span rather than a button precisely so it cannot render as a live control on your side.
- `data-ref` and the `REFA` label are generated in document order and renumber when one is
  deleted, so they are stable within a report but carry no meaning across reports.

### 37.3 Size

Images are compressed on the way in at **900 px long edge, quality 0.82** — a separate path
from report photographs, which are unchanged at 1600 px / 0.82. A full-screen snip lands
around 10–90 KB. Two per box, and the existing 10 MB ceiling and `sdSizeOk` check are
unchanged, so a report cannot get past the same limit it always had.

### 37.4 Also in REV 166 — printed page breaks

Not a payload change, listed so you know why printed output looks different: major
activities (BOP Surface Function Test, Acoustic, EHBS, Drawdown, EDS Verification, ROV,
Photo Dump, Equipment Issues) now start on a new page; headings can no longer be stranded
at the foot of a page; equipment entries, photo blocks and meta tables are kept whole; long
tables still break but never through a row, and **their header row repeats on each page**.

### 37.5 Nothing else moved

Posting path byte-identical to the **deployed REV 164** — same line count, same bytes. Zero
`no-cors`. Photo compression still 0.82 at 1600 px. No duplicate top-level declarations;
`acousticTestHTML` declared once (the §7.9 defect that started this is still fixed).
No base64 iframe remains on any live path. File 5,095,443 → **3,340,404 bytes**.

**One piece of dead weight found and left alone:** `COC_DASHBOARD_B64`, 908,884 chars —
the WCE/COC Vessel Dashboard carried as a base64 blob with **zero references anywhere in
the file**. It is 27% of the download and loads nothing. Not stripped in this revision,
because removing 900 KB on the eve of an upload is not a change to make in a hurry. Flagged
for the next one.

---

## Entry 36 — The Ram Cavity checker was never a calculator. It is a dimensional inspection record, and nothing it produced has ever been posted. One new key: `calcData`

**Rev: SSORT 148.** Status: **NEEDS ACTION** — one new tile-level key, shape given in full below.

### 36.1 What it is, and why it was invisible to you

The Calculators tile carries two entries. One really is a calculator (Conduit Flush — a
volume and a time, worked out on the spot and used). The other, labelled *Cavity
Dimensions*, is the **NOV BOP Ram Cavity Dimensions Checker**, and it is not a calculator
at all. It records:

- a rig, a test date, a **supervisor** and a **witness**
- for each of 5, 6 or 7 cavities: the ram type, the block style, four vertical readings
  (skid plate to seal seat, 90° apart), three horizontal readings (side pad to side pad),
  and where the block style requires it, six ram-block points and two widths
- a **PASS / FAIL** judgement on every one of those against **TR-WCE-331-038 Rev 3,
  Figure 7 — BOP Cavity Nominal Limits**

That is a record of whether a BOP ram cavity is within the manufacturer's limits. It sat
inside a `srcdoc` iframe, and the tile payload has slots for `vsrData`, `caData`,
`inspData`, `cbmData`, `r53Data`, `sbopData` and `pdcData` — **and none for the
calculators**. So nothing a crew typed into it has ever reached you, or survived a page
reload. Same defect class as the acoustic and EDS iframes in entries 17 and 29, on a
record that matters as much.

**You will not find it in your index, because it has never been there.** There is no
historical data to re-read and nothing to replay. From REV 148 it starts arriving.

### 36.2 The new key, in full

One new key on the tile object, alongside the seven that already exist. Absent (or
`null`) on any tile that is not a Calculators tile, and **`null` on a Calculators tile
where nothing has been entered** — an untouched tile adds nothing to the payload.

```
calcData : {
  unit      : "in" | "mm",          // the display unit the readings are IN
  hdr       : { cfg: "5"|"6"|"7", date: "YYYY-MM-DD", sup: "", wit: "" },
  summary   : { pass: n, fail: n, est: n, nospec: n, na: n },
  cavities  : [ {
      id             : 0,
      position       : "UBSR"|"CSR"|"LBSR"|"UPR"|"MPR"|"LPR"|"TPR",
      label          : "UBSR — Upper Blind Shear Ram",
      ramType        : "pipe"|"multiram"|"shear"|"casingshear"|"reversible"|"empty",
      blockStyle     : "CVX"|"CVX-W"|"LFS-5"|"LFS-3"          // shear
                     | "Standard"|"Unsealed LFS-5"|"LFCS"|"LFCS-5"   // casing shear
                     | "",
      plateMode      : "with" | "without",
      plateChoice    : "<NOV part no>" | "custom" | "",
      plateMin       : 0.560, plateMax : 0.562,               // when a plate is chosen
      customThickness: "",
      forceBlock     : false,
      expanded       : true,
      vertical       : { fwd:"", stbd:"", aft:"", port:"" },
      horizontal     : { fwd:"", mid:"", aft:"" },
      block          : { fwd:["","","",""], aft:["","","",""] }   // pts 1-3 then width
  } , ... ]
}
```

**Three things to hold on to when you read it.**

1. **`unit` governs every reading in the object.** The readings are stored as the crew
   typed them, in whichever unit was selected. The nominal limits are always inches.
   Convert with 25.4 before comparing anything to a published limit. A 7-cavity stack in
   mm reads around 184.2, not 7.252 — do not treat that as an outlier.
2. **`summary` is a convenience, not the record.** It is the count of cavities at each
   overall status at the moment of collection. The rows are the evidence.
3. **Empty strings mean not measured.** A cavity with partial readings is `na`
   (INCOMPLETE), not a fail. Please do not roll INCOMPLETE into a fail bucket — that is
   the same argument as entry 21 about Grade 3, and the same answer.

### 36.3 The status values, and what each one means

`evalCavity` returns a row per check; the cavity's overall status is the worst of them.
Five values, and the two in the middle are the ones worth building for:

| status | meaning |
|---|---|
| `pass` | every measured check within the TR-WCE-331-038 nominal |
| `fail` | at least one check outside it. **This is the one to surface** |
| `est` | measured as a bare casting, with a skid plate thickness added to estimate the assembled height. **Not a measured result** — it must be confirmed with plates installed before anyone signs it off. Do not present an `est` as a pass |
| `nospec` | the block style has **no published limit**. Unsealed LFS-5, LFCS and LFCS-5 are unsealed casing shear variants and NOV has not published cavity limits for them. The readings are recorded for reference; there is nothing to judge them against, and **we have not invented a limit** |
| `na` | not enough readings entered yet |

### 36.4 Two things we removed rather than carried across

**The Demo Data button is gone.** The standalone tool had one. `fillDemoData()` wrote
randomised readings into the same `vertical` / `horizontal` / `block` fields an inspector
types into — deliberately close to the nominal limits, alternating pass and fail down the
stack, so a printout could be demonstrated without going offshore. Inside the iframe that
was harmless, because nothing it produced was collected. Native and collected, one click
would have put fabricated cavity measurements into a posted well-control record, and
nothing in the payload would distinguish them from real ones. **It is not ported.** If
you ever see a cavity stack that looks too neatly half-passing, it did not come from
SSORT 148 or later.

**Its own Print path is gone.** The tool ran its own `window.print()` from inside the
iframe. It now renders through SSORT's report output like every other tile, behind a
Print / PDF button on the Calculators tile header.

### 36.5 A restore defect we found on the way, which would have destroyed records

`loadState()` and the file-import path both rebuild the tiles **before** they put
`meta-asset` back. The cavity block takes its rig from `meta-asset`, so on the first
build a crash-recovered stack came back as an empty form — and then the next autosave
**wrote that empty form over the good one**. A crew who reloaded would have lost the
measurements and had no way to know.

Fixed two ways: the rig gate now only applies to a *fresh* mount, since restored data
carries its own configuration; and both restore paths now call `onAssetChange()` after
restoring the meta fields, which is what every other programmatic setter of `meta-asset`
in the file already did (`dlSetRig` and the daily-log restore). **Nothing else in SSORT
read `meta-asset` at restore time, so nothing else was affected** — but it is worth your
knowing the shape of it, because the same ordering exists on your side wherever a
restored record depends on a field restored later.

### 36.6 The iframe is gone, and that is now true of both tools

`RAM_CAVITY_HTML_B64` — 237,036 chars of base64 carrying the whole standalone tool — is
stripped. It was the **last embedded tool in either app**. WCGRRT reached that state at
REV 166 (entry 23); SSORT reaches it now.

| | |
|---|---|
| SSORT 148 before | 6,943,369 bytes |
| SSORT 148 after | 6,766,746 bytes |
| saved | **176,623 bytes** |

The arithmetic was carried across unchanged and proved, not assumed: both versions were
run over **8,000 randomly generated cavities**, in both units, across every ram type,
block style and plate mode, and every row of every evaluation — item, measured, nominal,
status and note — plus the overall status matched **exactly**. The six reference tables
(`RAM_TYPES`, `SHEAR_BLOCK_SPECS`, `CASING_SHEAR_SPECS`, `STD_PLATES`, `SLOT_PLATES`,
`CAVITY_TEMPLATES`) are byte-identical to the source.

### 36.7 Nothing else moved

Posting path byte-identical to REV 147. Zero `no-cors`. Photo compression still 0.82.
Every existing `data-soak`, `data-cbm`, `data-vsr` and `data-cf` key present and
unchanged; no tile-payload key removed; exactly one added, and it is additive. Both
script blocks `node --check` clean, extraction reconciles, no duplicate top-level
declarations. The module is a single closure — the source's 45 top-level names are all
private, which is what disposes of the four that collided with SSORT (`POSITION_LABELS`,
`CAVITY_TEMPLATES`, `num` and `SEADRILL_LOGO_WHITE`); three of those four differed in
value, and §7.9 means the last declaration would have won silently and broken the BOP
Config stack builder with no error anywhere.

---

## Entry 35 — Dan reviewed all 52 open tasks. Criteria now on 93 of 104, and nine `_gr` keys stop being posted

**Rev: SSORT 148.** Status: **NEEDS ACTION** — nine keys stop arriving. Named in full below.

### 35.1 The key change, named

Dan's decision, 24 Sep: a cleaning task should not carry a 1–5 grade. *"If it says clean, you
clean and add a check box then take pictures. I'm assuming the inspection task comes after
the cleaning."* He has put it to NOV; this is the tool side of it.

Task `7.1.1B`, **"Clean ram blocks and seals with fresh water"**, on all nine ram block
classes, no longer shows grade buttons. **These nine keys stop being posted:**

```
cbm_Ram_Block_7_1_1B_gr
cbm_Ram_Block__MultiRam_7_1_1B_gr
cbm_Ram_Block__LFS_7_1_1B_gr
cbm_Ram_Block__Shear_7_1_1B_gr
cbm_Ram_Block__CasingShear_7_1_1B_gr
cbm_Ram_Block__LFSCSG_7_1_1B_gr
cbm_Ram_Block__Blind_7_1_1B_gr
cbm_Ram_Block__PipeBlindFixed_7_1_1B_gr
cbm_Ram_Block__BiDirectional_7_1_1B_gr
```

**Only the `_gr` goes.** `_cm` and `_ph` continue, and the task now explicitly asks for
photographs — NOV requires photographic evidence on every inspection item, and a cleaning
task keeps its evidence, it just stops carrying a judgement.

**This is not hypothetical, and the history proves the point.** Three posted West Capella
files already carry `cbm_Ram_Block__MultiRam_7_1_1B_gr = "1"` — a crew graded *"clean with
fresh water"* as a 1, three times. Those three rows stay in your index and should stay
visible; nothing is being rewritten. From SSORT 148 onwards the key simply will not arrive.
Absence means "not graded because there is nothing to grade", not "missing".

The Flexloops cleaning task `23.1.1` **keeps** its grade — Dan's call, and it is a different
task: it combines cleaning with a check for damage and corrosion.

### 35.2 Coverage

| | before | now |
|---|---|---|
| gradeable tasks | 113 | **104** (nine cleaning tasks left the pool) |
| carrying NOV criteria | 61 | **93** |
| without item criteria | 52 | **11** |

The remaining 11 are the ones Dan judged genuinely have no NOV counterpart: six C&K Stabs
items with no mapped document, three BOP Mandrel items (latch profile, ring groove area and
weld seams — there is no latch item in any of the 14 documents, and weld seams are, in his
words, "absolutely nothing to do with fasteners"), and two others. They keep the universal
GRADE LEVEL EVALUATION GUIDE on the `ⓘ scale` button.

### 35.3 One correction we made to his decision, same document, better line

Three rows — `7.1.5B` on Blind, PipeBlindFixed and BiDirectional — are *"Visually inspect
cross strap seal retaining groove"*. The matcher had paired them with NOV's **RRA** item at
0.10 overlap. Their own documents carry *"Visually inspect Ram Block **grooves** for damage,
pitting and corrosion"*, which is obviously the right line.

**Why the matcher missed it:** its tokeniser treats `groove` and `grooves` as different
words, so the correct candidate scored **zero** overlap while the wrong one scored 0.10. Dan
ticked "apply" meaning grade this task; it is now graded against the right line of the same
document. Worth recording as a weakness in the method, not just a fixed row.

### 35.4 Nothing else moved

All 418 posted keys byte-identical apart from the nine `_gr` above — asserted mechanically,
and the run writes nothing if a task id, a description or an existing criteria string moves.
Posting path byte-identical to REV 147, zero `no-cors`, extraction reconciles, both script
blocks clean, no duplicate declarations. File 6,959,523 bytes.

---

## Entry 34 — every NOV document reference audited against its own title block. The Ram Block entry was an outlier, not a pattern

**Rev: SSORT 148.** Status: **FYI** — no keys change, nothing to build. Recorded because
these strings are what a crew signs and an OEM auditor checks a document number against.

### 34.1 Why

Entry 33 found **three** errors in the single `CBM_REF["Ram Block"]` entry: the document
number two digits out, the revision a version behind, and a title matching neither the
document's title block nor its body. One entry being that wrong is a reason to look at the
other fifteen rather than assume they are fine.

### 34.2 Method

Ground truth is each PDF's own front matter, never a filename: the component name printed
under "CBM INSPECTION DOCUMENT", the "TEMPLATE DOCUMENT NUMBER" and the "REVISION" beside
it. **14 distinct documents** across the 44 files on disk. Every `CBM_REF` entry was then
compared on all three: template number, revision, title.

### 34.3 Result

| | |
|---|---|
| `CBM_REF` entries (distinct objects, aliases counted once) | 16 |
| **match the document exactly** | **13** |
| genuinely wrong | **1**, now fixed |
| intentional difference | 2 |

**The one real finding:** `Ram Block::LFS` carried *"NXT Low Force Shear Ram Blocks"*. The
document's title block reads *"Blind Shear Rams NXT Low Force Shear Ram Blocks"*. A
shortening rather than an error, but exact is cheaper to defend to an auditor than nearly.
Corrected.

**The two intentional ones** are `Ram Block::PipeBlindFixed` and `Ram Block::BiDirectional`.
Their document's title block names both types together, so neither sub-class can carry it
verbatim; they carry NOV's own wording for the **component**, taken from the body of the same
document. Flagged by the audit, correct as they stand.

So the Ram Block entry was an outlier. The rest of the references are sound, and that is
worth knowing as plainly as the errors were.

### 34.4 A false positive from our own tooling, said out loud

The audit first reported `Ram Block::CasingShear` as citing a document that does not exist.
It does exist and the reference is right. The PDF's text layer renders its number as
`D9D100 8038-PRO-001 | REV01` — a space inside the document number and none before the
revision — and our pattern did not tolerate either.

That is the **second** false negative our extraction has produced today; the first told us
"pipe" appeared nowhere in any document when in fact it is all through `D9D1008025`. Both
were caught by reading the document. The lesson we are taking: a regex result over this PDF
text layer is a lead, not a finding, and anything that says "none" gets read by eye before it
is repeated to anyone.

### 34.5 Unchanged

Display and print only — no payload carries a document reference, so no key, no value and no
historical record moves. Posting path byte-identical to REV 147, zero `no-cors`, extraction
reconciles, both script blocks clean. File 6,948,284 bytes.

---

## Entry 33 — a seventh ram block class, a wrong document number on every ram block report, and the OEM button is held

**Rev: SSORT 148.** Status: **NEEDS ACTION** — one new equipment class, so one new key family.

### 33.1 Post to OEM does NOT ship. Your answer settles it

Thank you for checking the flow rather than assuming. "The flow reads `pdf` only... the
attachment expression falls back to a one-byte placeholder when `pdf` is absent, so a real
press of the button today would email NOV a one-byte file called `.pdf`." That is worse than
the no-attachment case we guessed at, and it is exactly why the question was asked before a
rig ever pressed it.

Done on our side: **31.5, the wording is changed** to *"Sent for OEM delivery"*, on both the
button and the toast, with the reasoning recorded beside it — all the tool can see is that
the POST returned `res.ok`. Whether the flow could build the attachment, and whether NOV's
gateway accepted it, happen later and out of sight.

Not done, and not ours: Part D of the flow guide. **The button stays unshipped until Dan has
built and proven it in test mode.** Nothing else in SSORT 148 depends on it.

### 33.2 New class: `Ram Block::Fixed` — a new key family

Dan, 24 Sep: *"Ram blocks, there should be casing CSR, LFSCSG, BLIND, LFS, MULTI and FIXED
to name a few."* Fixed was missing from the six in entry 30. Added, on the same terms:

- posted class `Ram Block::Fixed`, keys `cbm_Ram_Block__Fixed_<id>` — **the only new key
  family in this entry**
- the same 13 task ids as every other ram block class, byte-identical; the build refuses to
  write if any copy's structure diverges from the generic
- its NOV document is `D9D1008025-PRO-001`, whose title is "NXT Ram Blocks — Pipe / Blind /
  Fixed"; 3 of its 6 gradeable tasks took criteria from it

"To name a few" means this list may still not be complete. **Pipe** is named in that
document's own title and has no class yet; we have not invented one, and it is on Dan's list.

### 33.3 A wrong NOV document number, on every ram block report ever printed

Found while checking which document covers Fixed. `CBM_REF["Ram Block"].docNo` read
**`D9D1998025-PRO-001`**. There is no such document. The real one is **`D9D1008025-PRO-001`**
— two digits, `99` where `00` should be — and it is what the PDF's own title block says.

That number is printed on the report a crew signs and an OEM auditor reads. Corrected to
`D9D1008025-PRO-001 (Rev 02)`. Worth a look on your side at whether any archived ram block
report shows the wrong number; nothing in the payload carries it, so this is a display and
print fix only, with no key or data effect.

### 33.4 Dan's domain corrections, and what each one turned out to allow

He went through the 32 held items from entry 32 and gave the engineering rather than the text
matching. Three outcomes, and only one of them was "apply":

**Side outlets carry BX ring grooves, so a side outlet inspection is a ring groove
inspection.** NOV agrees: items `8.2`, `9.2` and `10.2` of `D9D1008289` are all "Visually
inspect side outlet ring groove for any defects" and **all three state the same scale**.
Applied to `6.1.8` on all three NXT body classes. His reasoning and NOV's document reached
the same place independently.

**Side plates are not side outlets.** `6.1.3` stays without criteria. The text matcher had
paired them at 0.43 and was wrong.

**"Latch profile or ring groove will get any ring groove inspection or similar."** This one
we could not do, and the reason is worth recording. There are **12 ring-groove items across
the 14 documents and they use 4 different scales**: the SBOP's has no G4, the NXT body's
ends "Repair required", the Flexloops one is worded differently again. There is no single
ring-groove measuring stick to borrow. Separately, **no item in any of the 14 documents
mentions a latch at all**, and "mandrel" appears exactly twice, both in the U2B *door*
document meaning a door mandrel. So `BOP Mandrel 21.1.2` and `21.1.3` stay without criteria
until someone points us at the document that grades them.

**"Weld seams are absolutely nothing to do with fasteners."** Agreed, and that was already
held. `21.1.5` stays.

### 33.5 Dan's position on cleaning tasks, going to NOV — not built

*"A task clean with fresh water doesn't need any scale at all... we only need to scale where
there is an inspection. If it says clean, you clean and add a check box then take pictures.
I'm assuming the inspection task comes after the cleaning."*

**Nine gradeable tasks** currently start with clean/lubricate/flush: `Flexloops 23.1.1` and
`7.1.1B` on all eight ram block classes. Nothing has been changed. Recorded here because Dan
is putting it to NOV and the answer is theirs, and because if it goes ahead it **removes a
`_gr` key** from nine tasks, which is a posted-key change and would come through this file
first with a full list before it ships.

### 33.6 Coverage, and your two defects

| | entry 32 | now |
|---|---|---|
| gradeable tasks | 101 | **107** (Fixed adds six) |
| carrying NOV criteria | 41 | **58** |

On the two defects `cbmlabels` exposed on your side — id keys with a letter (`7_1_2B`) and
cavity keys (`6_1_2_c0`) matching nothing, and `Ram Block::Shear` building a prefix with the
colons intact: those are the better result of the day. Every ram block task in Brad's
MultiRam, Shear and CasingShear posts and every cavity item on an NXT body had been silently
absent from the heatmap since those shapes first arrived. Neither side would have found it
from its own code. Good catch, and thank you for saying it plainly.

### 33.7 Unchanged

Posting path byte-identical to REV 147 — 17 transport lines, zero differences. Zero
`no-cors`. Extraction reconciles, both script blocks clean, no duplicate declarations.
File 6,941,956 bytes.

One correction to our own method, for the record: the posting-path check briefly reported 18
lines against 147's 17. That was the checker, not the code — it was matching comment lines,
and a new comment in the OEM button mentions `res.ok`. The checker now excludes comments,
which cannot affect the transport. The seventeen real lines are identical.

### 33.8 Addendum, later the same day: the class is renamed, Bi-Directional added, and a correction to 33.2

Dan asked whether NOV references *pipe* anywhere. It does, heavily, and the first search we
ran said it did not — a false negative from a pattern written the wrong way round
(`ram.{0,12}pipe`, which cannot match "Pipe / Blind Ram"). Taken at face value it would have
told Dan the opposite of the truth. Redone properly:

`D9D1008025` Rev 02 calls the component **"NXT Pipe / Blind Ram Blocks Fixed Rams"** right
through its body — section headings, cleaning instructions, reference photos, the NDE
component name — while its *title block* reads "NXT Ram Blocks - Bi-Directional and Fixed".
Page 31 names **both** types side by side, which is why the document carries two identical
graded sections at p14 and p17. Only one had been wired.

So, with Dan's agreement:

| was | now | NOV's own wording |
|---|---|---|
| `Ram Block::Fixed` | **`Ram Block::PipeBlindFixed`** | NXT Pipe / Blind Ram Blocks Fixed Rams |
| — | **`Ram Block::BiDirectional`** (new) | NXT Bi-Directional Ram Blocks |

**The rename is safe and re-points no history.** `Ram Block::Fixed` was added earlier the same
day, has never shipped, and a scan of all 29 posted CBM files finds zero references to it. The
only new key families to read are these two.

Both take the same criteria, because NOV states p14 and p17 **identically** — checked, not
assumed. All nine ram block classes share the generic task ids, asserted mechanically.

**And a third error in the same `CBM_REF` entry.** 33.3 reported the document number and
revision were wrong. The *title* was wrong too: "NXT Ram Blocks — Pipe / Blind / Fixed" is
neither the title block nor the body wording. It now reads the document's own title block.
Three errors in one reference entry, all now matching the PDF.

**One correction to our own arithmetic, in this file and the review sheet.** We have said
"14 NOV documents" in entries 26, 32 and 33 and in the review sheet's KPI row. The real figure
is **14 distinct documents across 44 files** — eleven exist under both a 9-digit number and a
`D9D` number, plus three `D9D`-only. No conclusion moves: matching is keyed on template
numbers and the de-duplication collapsed the copies correctly. The count was simply wrong.

Current state: **22 equipment classes, 113 gradeable tasks, 61 carrying NOV criteria, 418
posted keys.** Posting path byte-identical to REV 147, zero `no-cors`, 467 top-level
functions, no duplicates, extraction reconciles. File 6,948,267 bytes.

---

## Entry 32 — criteria coverage: 41 of 101, and a correction to the method we proposed in the review sheet

**Rev: SSORT 148.** Status: **FYI** — no key changes, nothing to build. Recorded because it
changes how much wording the heatmap will see through `cbmlabels`, and because we got a
method wrong and want that on the record rather than quietly fixed.

### 32.1 The correction first

`CBM-SCHED-CRITERIA-REVIEW-SHEET.html` grouped 17 unresolved tasks as NEAR and proposed
treating them as a class: attach NOV's section-level scale to each, because the schedule is
more granular than NOV. **That proposal was wrong and is withdrawn.** Reading the 17
individually against the documents, they are not one class at all:

| live task | best NOV match | verdict |
|---|---|---|
| Flexloops `23.3.2` API ring groove | `1.1` *Examine ring groove areas for mechanical wear/damage* | the same item, worded longer |
| SBOP `2.1.1` **Bore** — dirt, corrosion, scratches, key seating | `6.2` *Visually inspect the **Sealing Element**…* | **wrong component** |
| NXT `6.1.3` **Side plates** | `1.4` *Inspect side **outlets**.* | **wrong** — plates are not outlets |
| NXT `6.1.8` side outlet connections | `8.2` side outlet **ring groove** | related, not the same |

Applying that group as a class would have attached the sealing element's scale to a bore
inspection. Worth saying plainly: the sheet's "After" column is evidence, and its
*grouping* was our inference, which is a weaker thing.

### 32.2 What replaced it, and its limit

A second pass asks a weaker, more answerable question. Not *"which NOV item is this?"* —
which a roll-up has no answer to — but *"do all the plausible candidates measure it the
same way?"* If every candidate states the same scale, the measuring stick is certain even
when the item is not, and that is honest to attach with provenance naming every item it was
confirmed against.

It found 22. **Ten of those were a set of one candidate, which agrees with itself and proves
nothing**, so the rule now requires two or more independent NOV items. That single change
removed SBOP `2.1.1` from the list — at the candidate floor the only item that surfaced was
`6.2`, the sealing element, while NOV's four actual bore items (`1.2`, `2.2`, `4.2`, `5.2`)
score below it and never appeared. One candidate is not evidence.

**Twelve survived. Six were applied.** The other six were held, each for its own reason:

- `Ram Block 7.1.3B`, `7.1.4B` — the **generic** ram block entry. The six types got their own
  NOV scales in entry 30; giving the generic one borrowed from a single type would rebuild
  the wrong measuring stick Dan just had us split away from.
- `6.3.6 Replacement of Seal Plate` (×3) — a replacement **action** matched to inspection
  items. Arguable, since you would grade the new plate, but a judgement rather than evidence.
- `BOP Mandrel 21.1.4` — sits on the Riser Adapter document, which is **our inference**. Held
  until Dan confirms the mandrel is inspected under that CBM.

### 32.3 Where coverage stands

| | entry 26 | entry 30 | now |
|---|---|---|---|
| gradeable tasks on the live path | 65 | 101 | **101** |
| carrying NOV criteria | 9 | 35 | **41** |

The rise from 65 to 101 gradeable is the ram block split: six classes where there was one.

The remaining 60 keep the universal GRADE LEVEL EVALUATION GUIDE, reachable from every one
of them via the `ⓘ scale` button. That is not a placeholder — NOV states it as the criteria
for any item with no wording of its own.

**The honest limit:** text similarity has reached the end of what it can settle. What is
left needs a person reading the document beside the task, which is what the review sheet is
for. We would rather stop here than keep inventing cleverer ways to guess.

### 32.4 Unchanged

All 392 posted keys byte-identical, task ids, descriptions and structure untouched — the run
writes nothing if any of that moves. Posting path byte-identical to REV 147, zero `no-cors`,
extraction reconciles, both script blocks clean, no duplicate declarations. Each new scale
carries a `gsrc` naming every NOV item it was confirmed against, so a roll-up is visibly a
roll-up. Nothing posted.

---

## Entry 31 — Post to OEM: the button is built, but it sends `html` and your flow test read `pdf`. One question before it ships

**Rev: SSORT 148.** Status: **NEEDS DECISION** — this is a blocking question, and it is
Dan's and yours rather than ours. Nothing has been sent to NOV from any test.

### 31.1 The mismatch, stated plainly

`CBM-OEM-HANDOFF.md` specifies, and your 22 September flow test confirms field by field:

> `meta.asset`, `meta.wce`, `meta.sourceFile`, `oem`, `subject`, `pdfName`, **`pdf` as bare
> base64, no `data:` prefix**

SSORT's `postCbmToOem` posts everything on that list **except `pdf`**. What it sends instead:

```
sourceFormat : "html"
pdfName      : "Seadrill_CBM_West-Capella_Ram-Block-Blind_2026-09-23.pdf"
htmlName     : "Seadrill_CBM_West-Capella_Ram-Block-Blind_2026-09-23.html"
html         : "<base64 of a standalone HTML document>"
```

**Why, and it is deliberate rather than an oversight.** SSORT has no PDF renderer. "Generate
CBM PDF" renders the report into the page and hands it to the browser's own print-to-PDF, so
there are no PDF bytes in JavaScript to attach. The handoff was written against the Precharge
Pro architecture, which has jsPDF; SSORT does not. The reasoning is recorded in the tool
above the function, and we are not going to fabricate a `pdf` field the tool cannot produce.

### 31.2 The question

**Does the flow convert `html` to PDF, or does it only read `pdf`?**

Your message says the test passed with "a one-page TEST PDF in `pdf`" and that "the flow
sends whatever is in `pdf`". That is evidence it reads `pdf`, and no evidence either way
about `html`. Dan built the flow, so he may answer this in seconds.

- **If the flow already converts `html`** — nothing to do on either side. Say so and the
  button ships as it stands.
- **If it only reads `pdf`** — then pressing the button today sends NOV an email with
  **no attachment**, or the flow fails, and the crew sees "✓ Sent to OEM" either way,
  because the tool can only see that the POST returned `res.ok`. That is the part worth
  fixing before a rig ever presses it, not after.

### 31.3 If the flow needs changing, three honest options

1. **Add an HTML-to-PDF step in the flow.** Power Automate has one (`Convert file`), and it
   keeps one renderer: `cbmReportHTML()` already produces both what the engineer reviews on
   screen and what is sent. Our preference, and it needs nothing from the tool.
2. **Attach the HTML instead of a PDF.** `htmlName` is already in the payload for exactly
   this. NOV receives a file that opens in any browser and prints identically. Worse for an
   OEM's document system, and Dan's call whether NOV will accept it.
3. **Put a PDF renderer in SSORT.** We would advise against it. jsPDF plus html2canvas is
   several hundred kilobytes added to a file thirteen rigs download, in a tool that must
   work from `file://`, and the output for a hundred-photograph report would be worse than
   the browser's own print — which is the thing Dan said to protect.

### 31.4 What is verified on our side

The tool's half was exercised on the rebuilt build without posting: a real CBM tile
collected, `cbmReportHTML` rendered, `sdStandaloneReportDoc` wrapped it, and the payload
assembled exactly as `postCbmToOem` assembles it.

| | |
|---|---|
| document built | 199,879 bytes, valid standalone HTML with the page's stylesheets inlined |
| `meta` fields | all ten present, including `sourceFile` and the new `rev` |
| `subject` | `CBM Report - West Capella - Ram Block::Blind - 2026-09-23` |
| `pdfName` | `Seadrill_CBM_West-Capella_Ram-Block-Blind_2026-09-23.pdf` |
| `pdf` present | **no** |
| `html` present | yes |

Two things that also check out: the Ram Block split from entry 30 flows through correctly
into `meta.equipment` and the filename slug; and `sdPostReport` does **not** apply
`sdSizeOk`, so the button's own 20 MB warn / 30 MB refuse is the only size guard, exactly as
you described it.

### 31.5 One thing we will change regardless of the answer

`postCbmToOem` reports success on `res.ok` alone, which is all the transport can tell it.
If the answer to 31.2 is anything other than "the flow converts html", the button should not
say "✓ Sent to OEM" until the flow has confirmed it could build the attachment. We are not
changing the posting path to chase that — but the **wording** of the success message can say
what is actually known ("Sent for OEM delivery") rather than what is not. Say the word and
it is one string.

---

## Entry 30 — Ram Block is split. Your three conditions, answered — and the `n:` map you asked for is **empty, by evidence**

**Rev: SSORT 148 (building).** Status: **NEEDS ACTION** — one check on your side, described in
30.3. Nothing to build.

### 30.1 Done, and it is a restoration rather than a new shape

Dan's decision from your 26.2 addendum is executed. The six block types are back in the CBM
equipment list, each mapped to its own NOV document:

| class | NOV template |
|---|---|
| `Ram Block::MultiRam` | `D9D1008041-PRO-001_01` |
| `Ram Block::LFS` | `D9D1008042-PRO-001_01` |
| `Ram Block::Shear` | `D9D1008026-PRO-001_01` |
| `Ram Block::CasingShear` | `D9D1008038-PRO-001_01` |
| `Ram Block::LFSCSG` | `D9D1008154-PRO-001_01` |
| `Ram Block::Blind` | `D9D1008155-PRO-001_01` |

The document numbers are not our invention: `CBM_REF` in the tool already recorded one per
block type, and has all along. The six options were collapsed into a single generic
`Ram Block` at some point and this puts them back.

### 30.2 Your three conditions

**Condition 1 — the `equip` class names stay exactly as they are.** They do, and we can
prove it from your own index rather than asserting it. Brad's posted West Capella files
already carry `cbmData.equip` of `Ram Block::Shear`, `Ram Block::MultiRam` and
`Ram Block::CasingShear`. These are the same strings, character for character.

**Condition 2 — an old-id to new-id map per block type, before the build ships.** There is
no id change to map, and here is the evidence rather than the claim. Brad's
`Ram Block::MultiRam` posts already contain **id keys under the split class name**:

```
cbm_Ram_Block__MultiRam_7_1_1B_gr
cbm_Ram_Block__MultiRam_7_1_2B_gr
```

So `CBM_SCHED` was already keyed by the split class before the collapse. The 13 task ids
(`7.1.1B` … `7.3.2B`) are **byte-identical** in all six copies — asserted mechanically, and
the build refuses to write if any copy's structure diverges from the generic. A post from
SSORT 148 under `Ram Block::Shear` produces `cbm_Ram_Block__Shear_7_1_2B_gr`, which is
exactly the shape already in your index.

**So the `n:` section of `cbm-key-map.json` is empty.** Not "not sent yet" — empty, because
nothing moved. If you would still rather have the file carry an explicit empty `n:` block so
the scanner can record that the question was asked and answered, say the shape and it is
yours in a minute.

**Condition 3 — the build's ship date is the boundary.** Agreed, and `meta.rev` makes it
sharper than a date: any post stamped `SSORT REV 148` or later that carries a bare
`Ram Block` class is pre-split data being re-posted, in the same spirit as your 25.2 replay
check.

### 30.3 The one thing to check on your side

We hold 29 of Brad's files; you hold 307. **Was any CBM report ever posted under the bare
generic `Ram Block` class** — that is, `cbmData.equip === 'Ram Block'` exactly, with id keys
`cbm_Ram_Block_7_1_*`? In our 29 there are none: every ram post uses a `::` class.

If your answer is also none, the split is seamless and no history is affected at all. If any
exist, those posts cannot be attributed to a block type by us or by you — the tool did not
record which block it was — so they should stay apart under `Ram Block` rather than be
guessed into a type. A labelled gap, on the same principle you used at the July boundary.

### 30.4 Why the split was worth doing, measured

Each block type is now graded against its own NOV document. The test of whether that matters
is whether the scales actually differ, and they do — same task id, six classes:

| task id | classes with criteria | **distinct scales** |
|---|---|---|
| `7.1.2B` visual inspection of the block | 6 | **4** |
| `7.1.3B` block grooves | 6 | **5** |
| `7.1.4B` RRA wear | 4 | **4** |
| `7.1.5B` cross strap seal groove | 4 | **3** |
| `7.1.6B` blades | 6 | 1 — NOV genuinely uses the same wording here |

For example `7.1.3B`: a Blind block reads *"Visual signs of very light wear beginning to
show, but still in good working condition"* from `D9D1008155` p11, while a Shear block reads
*"Surface indications found in non-sealing area"* from `D9D1008026` p11. One generic entry
really was the wrong measuring stick, as Dan said.

Criteria on the live path are now **35** (was 9 at entry 26), of 101 gradeable tasks across
20 equipment classes. Each carries its `gsrc` document and page.

### 30.5 A defect found and fixed in the same change

The equipment dropdown preselected `cbmEquipOptions(cbmFamilyOf(eqsel))`. With only the
generic option in the list that was the only thing that could work; with the sub-types
present it silently downgraded a saved `Ram Block::Shear` to `Ram Block` on reopen — which
would have posted a class disagreeing with its own keys, and handed you a
`cbm_Ram_Block__Shear_…` key under class `Ram Block` to strip a prefix from. Now the exact
sub-type is preselected. Verified on the rebuilt tool: `cbmEquipOptions('Ram Block::Shear')`
returns `Ram Block::Shear` selected.

The generic `Ram Block` option is **retained**, so reports saved against it still open and
still resolve. Whether it should now be retired so a crew cannot pick the generic scale
again is Dan's call, not ours, and it is on his list.

### 30.6 Unchanged

Posting path byte-identical to REV 147, zero `no-cors`, extraction reconciles, both script
blocks clean, no duplicate declarations, no cross-block collisions. No payload key is added
by this entry. File 6,928,154 bytes — still 22% smaller than REV 147 despite everything
added since.

---

## Entry 29 — SSORT goes native too. The last iframe in either tool is gone, and the keys are provably identical to WCGRRT's

**Rev: SSORT 148 (building).** Status: **FYI** — **no new keys and nothing to build.** The
renderers you built for WCGRRT in entries 22 and 23 will read SSORT's posts unchanged. That
is the whole point of this entry, and it is asserted below rather than hoped for.

### 29.1 What was wrong

Entry 17 reported that SSORT carried the same three iframe surface-test blobs as WCGRRT.
WCGRRT was fixed in 165 and 166; SSORT was not, and has been sitting on the same hole
since: acoustic, EHBS and Surface Drawdown rendered inside an iframe, `collectSoak` is a
`querySelectorAll` and cannot cross that boundary, so the contents printed and **were never
saved or posted**. Same defect that cost the fleet the 8–15 September EDS and function-test
records.

Two things made it worse than WCGRRT's version:

1. SSORT also held a **dead acoustic quartet** — `acousticTestHTML`, `onAcousticSheetChange`,
   `acousticSheetTableHTML`, `acousticTestReportHTML` — rendering the old `acoustic_sheet` /
   `ac_*` key shape that 15.2 recorded as a defect and you refused to build against. Three
   had no caller. The fourth **was** called from the report renderer, fed by a `soak` the
   iframe never filled, so it drew nothing, every time, silently.
2. The report renderer had **no EHBS or drawdown branch at all**. Even a correctly filled
   `soak` would have rendered nothing for those two.

### 29.2 What was done

WCGRRT 166's native region was ported **verbatim** — 932 lines, 35 new functions and data
tables — and the deprecated quartet deleted. Verbatim was the requirement, not a
convenience: you built one renderer for both tools, so a key that drifts here produces a
report you cannot read. Repointed in the same edit:

- the live surface-test change, all three tests
- `makeEquipEntry`, all three — **the restore path, which is the one a crew hits after a
  crash**, and the one missed last time this was done (§7.2)
- the report renderer: acoustic repointed to `acousticReportHTML`, **EHBS and drawdown
  branches added**

`surfEmbed` now has no caller in either tool. Kept, not deleted, with a comment saying why
it must never be called again.

### 29.3 The proof that matters to you

Both tools were loaded side by side, the same rig selected (**West Saturn**), each of the
three tests rendered, and the `data-soak` keys and `data-soak-label` pairs sorted and
hashed:

| test | keys | key set SHA-256 (first 16) | label set SHA-256 |
|---|---|---|---|
| acoustic | 72 | `e07111b6f2025a3d` | `31bcbdd3d1b6fca7` |
| EHBS | 33 | `bf55daf2608511b4` | `85a15c9769a3e70c` |
| drawdown | 54 | `1099386ea7502318` | `0d4a2824568eab82` |

**Identical for WCGRRT REV 166 and SSORT REV 148, all six hashes.** Not just the counts —
the key names and every printed label match exactly. So the acoustic, EHBS and drawdown
blocks you built and tested on synthetic WCGRRT posts will render SSORT posts with no
change whatsoever.

Also confirmed: `ACOUSTIC_NO_SYSTEM` carries **West Neptune, West Vela and Sevan Louisiana**
in SSORT as well; each shows "has no acoustic system fitted" and emits **zero** keys, so
absence stays absence and never arrives as an empty sheet.

### 29.4 `soaklabels` now ships from SSORT

Both SSORT payload builders emit `soaklabels` beside `soak`, lower case as settled in 22.4,
built by the same `collectSoakLabels` from the same tables that render the form. `ftPfButtons`
gained the optional third `label` argument and is byte-identical in output for its existing
two-argument callers, so no other test's markup moved.

### 29.5 Size, and the count that matters more

| | |
|---|---|
| SSORT REV 147 | 8,941,320 bytes |
| **SSORT REV 148** | **6,897,972 bytes** |
| | **−2,043,348 (−22.9%)** |

Five base64 blobs are now gone from SSORT: the three iframe tests stripped here
(598,123 + 607,155 + 600,871 bytes) and the two dead ones from entry 24.5. **Neither tool
contains an embedded iframe tool any more.**

The count that matters more than the bytes: three surface test types across thirteen rigs
that previously produced a printed page and an empty `soak` now produce 72, 33 and 54
recorded values with a printed label on every one.

### 29.6 Unchanged

Posting path byte-identical to REV 147 — 17 transport lines, no difference. Zero `no-cors`.
467 top-level functions, no duplicates, no cross-block collisions, extraction reconciles,
both script blocks clean under `node --check`. The only payload keys SSORT 148 adds remain
`meta.rev` (24.1), `cbmlabels` (28.1) and now `soaklabels`, which is not new to you — it is
the key WCGRRT already sends.

Nothing has been posted from any test.

---

## Entry 28 — `cbmlabels` is in 148. Your 24.2 ask, answered yes

**Rev: SSORT 148 (building).** Status: **NEEDS ACTION** — one new key, lower case, additive.
This is the announcement; it ships in the same revision.

### 28.1 The key

`cbmData.cbmlabels` — a flat object, one entry per posted CBM key that belongs to a task,
keyed **exactly as the data is keyed** so you need no join rule:

```
"cbmlabels": {
  "cbm_Gate_Valves_7_1_2_gr": "Visually inspect all external welds for pitting and corrosion",
  "cbm_Gate_Valves_7_1_2_cm": "Visually inspect all external welds for pitting and corrosion",
  "cbm_Upper_Triple_NXT_Body_6_1_2_c0_gr":
      "Visually inspect and record in CBMID Seal and skid plates — Upper Cavity"
}
```

Same shape and the same spirit as `soaklabels`: **built from the tables that render the
form, never a static map**, for the reason you gave in 12.2 — a static map is wrong the day
NOV reissues a sheet.

Three things worth knowing before you build against it:

1. **Sub-cavity keys carry the cavity name**, appended after an em dash, because the cavity
   is not in the task wording and `_c0` on its own tells a reader nothing.
2. **Both key shapes resolve.** Live id-based keys come from `CBM_SCHED`. Historical
   positional `_g<s>_<i>` keys still resolve against `CBM_GRADED`, so a pre-shadowing report
   re-opened and re-saved carries labels too. Given entry 25, a label is arguably more use
   on an old record than a new one.
3. **Section summary keys are deliberately unlabelled.** `cbm_<equip>_g<n>_summary` and
   `_maximo` are not tasks and get no entry, rather than a misleading one.

### 28.2 Size, since it rides on a report that already has a 40 MB ceiling

Measured on the real datasets: **2.9 KB** for a full Gate Valves set (40 labels) and
**8.0 KB** for an Upper Triple NXT Body (72 labels, three cavities). Only the equipment the
report actually covers is labelled. Against a CBM report that runs to tens of megabytes of
photographs this is not a consideration, and it does not move the ceiling.

### 28.3 What it changes for you, and what it does not

It answers 24.2 directly: your `itemLabel` stays derived from the key, so
`Section 3 . Item 2` and `7.1.2` keep working exactly as now and nothing existing has to
change. `cbmlabels` sits beside it, so the heatmap and the digest can print NOV's wording
next to the grade when it is present, and print nothing different when it is not. Absent
means a pre-148 post, never a fault — the same convention as `meta.rev`.

It also closes the loop on entry 24: the 47 task descriptions restored from SSORT REV 79 and
the NOV documents now reach **the reader of a report**, not only the crew grading it. That
was the part of the restoration that had no route to you.

### 28.4 Verification, and one thing not verified

Proven by running the shipped `cbmLabelsFor` — lifted from the built file, not a
reimplementation — over the real `CBM_SCHED` and `CBM_GRADED` datasets with a realistic
collected key set for two equipment types:

| | Gate Valves | Upper Triple NXT Body |
|---|---|---|
| collected `cbm_` keys | 43 | 75 |
| labelled | 40 | 72 |
| grade / comment keys with **no** label | **0** | **0** |

The three unlabelled in each case are the section summary keys, by design.

**Verified end to end as well**, by driving the built tool: a CBM section on Gate Valves, a
grade of 3 pressed through `cbmSetGrade` and a note typed, then `collectCbm` called on the
tile and its output read. The real `cbmData` carried `cbmlabels` with **29 labels, 2,229
bytes**; the recorded grade `cbm_Gate_Valves_7_1_2_gr` and its `_cm` note both carried
*"Visually inspect all external welds for pitting and corrosion"*; **zero** task keys were
unlabelled. Nothing was saved to a file and nothing was posted — the payload was read in
memory, which is a stronger check than a file and leaves no artefact anywhere.

One incidental finding while setting that test up, recorded because it is a real gap rather
than a test inconvenience: **SSORT has no `SSCE Equipment` asset.** WCGRRT carries it as a
production option under an `<optgroup label="Not rig-specific">`, for work that genuinely
belongs to no rig such as a vendor audit at an OEM's premises; SSORT's asset list is the 14
rigs and nothing else. So a not-rig-specific SSORT report has nowhere to go, and the two
tools disagree about what `meta.asset` can contain. Not changed — the asset list feeds the
rig identity contract and the filename, so it is Dan's call, and it is on his list.

Unchanged: posting path byte-identical to REV 147, zero `no-cors`, 432 top-level functions,
no duplicates, no cross-block collisions. The only payload keys 148 adds are `meta.rev`
(24.1) and this one.

### 28.5 On your other points

- **25.4 (a), 25.2 replay check, 21.4 Grade 3, 24.1 `meta.rev`** — all noted, nothing owed.
  The replay check is a good use of the one fact that makes it safe, and we would not have
  thought of it from this side.
- **26.2, the Ram Block split** — still Dan's. Understood that it needs an `n:` section in
  `cbm-key-map.json` **before** such a build ships, not after; that is now recorded on this
  side as a precondition rather than a follow-up.
- **27** — agreed, and thank you for applying the rule back at us. A computed judgement
  should not be posted as a recorded fact *or* displayed as one.

---

## Entry 27 — conditional triggers surface on a grade of 4 or 5. It suggests; it never decides

**Rev: SSORT 148 (building).** Status: **FYI** — display only, no key added, nothing collected,
nothing posted.

### 27.1 What it does

Grading a CBM item 4 or 5 now reveals, under that item, the conditional-trigger tasks in the
same equipment whose trigger names a failure of the same kind as the check just graded — with
each trigger's own wording shown.

### 27.2 What the data would and would not support

This is the part worth your attention, because it sets a hard ceiling on what the dashboard
can ever infer from a CT task:

| | |
|---|---|
| CT tasks on the live path | 172 |
| of those, stating a trigger | 148 |
| distinct trigger strings | 100 |
| triggers describing a failure condition | 79 |
| **triggers naming a grade** | **0** |

**Nothing anywhere states "grade 4 unlocks task X."** Not NOV, not the maintenance schedule.
So this feature cannot and does not assert that a CT task is due. What the triggers *do*
carry is the **kind** of failure — "Failed Visual Inspection", "Failed dimensional
inspection", "Failed Operator test" — so the graded item is classified by kind from its own
wording and evidence field, and the CT tasks naming that kind of failure are listed.

The panel says, in those words, that the listed tasks **are not automatically due** and that
the crew must read each trigger and decide. If we had made it authoritative we would have
been inventing a mapping NOV never wrote, which is the same error as inventing a missing
grade level.

Specificity is good enough to be useful rather than noise — a visual failure on Gate Valves
surfaces 5 of its 13 CT tasks, not 12. And where an equipment set has no matching trigger at
all, the panel says so outright instead of staying silent: C&K Stabs and Diverter have zero
failure-kind triggers, because theirs are about disturbed connections rather than failures.

### 27.3 Nothing for you to consume

No payload key is added. The panel contains zero `data-cbm` attributes and zero inputs, so
there is nothing to collect and nothing arrives. Posting path still byte-identical to REV
147; zero `no-cors`. 430 top-level functions, no duplicates, no cross-block collisions.

If you later want the dashboard to show "this report recorded a 4 or 5 on a visual check and
these CT tasks name that failure", that is derivable on your side from the grades you already
receive plus the schedule — it does not need a new key, and we would rather not post a
computed judgement as if it were a recorded fact.

---

## Entry 26 — the criteria migration has started: NOV's scales are now on the live path, for 9 of 65

**Rev: SSORT 148 (building).** Status: **FYI** — no key changes, nothing for you to build. Read
25.4 first; this is option (a) being executed.

### 26.1 What was done

Dan chose the migration route from entry 25.4. NOV's per-item criteria are now attached to
tasks in `CBM_SCHED`, which is the dataset crews actually reach.

Method, so you can judge the quality rather than take our word for it:

1. Every graded item was extracted from all 16 NOV component documents in `CBM DOCS\` —
   **859 raw, 266 distinct** after collapsing the documents that exist twice on disk.
2. Each of the 65 live gradeable tasks was scored against the items in **its own** NOV
   document, identified either from `CBM_EQUIP`'s template number or from a document title
   that names the component outright.
3. A match was applied only when the wording matched closely, the NOV item carried at least
   two grade levels, and there was no competing candidate stating *different* criteria.

**9 applied.** Four of those have a `CBM_GRADED` twin, and in all four the twin's criteria
are byte-identical to what was extracted independently from the PDF — two separate routes to
the same text, which is the strongest check available.

Each carries provenance: `gsrc` holds the NOV template number, item and page, e.g.
`D9D1008449-PRO-001_01 item 1.2, p12`. That is displayed under the criteria, so an OEM
auditor can see which clause a grade was pressed against.

### 26.2 Why only 9 of 65 — two structural reasons, not laziness

We expected most of the 65. Two facts in the source material stopped it, and both are worth
you knowing because they shape what the CBM Heatmap can ever show:

1. **The schedule is more granular than NOV.** For the ram bodies and doors, NOV states one
   scale per component section — *"Visual inspection of body condition"* — while the
   schedule asks eight separate questions underneath it (locking groove, external welds,
   side outlet connections, and so on). There is no NOV item to attach to those eight.
2. **NOV does not reuse its scales.** The Gate Valve document uses **17 distinct scales
   across 18 items**. So there is no document-level default that could be applied safely to
   an unmatched task. Attaching one would be inventing a measuring stick.

A third, narrower blocker is worth flagging because it is a *schedule* problem, not a NOV
one: `CBM_SCHED["Ram Block"]` is **one generic entry covering six block types** — Shear, Low
Force Shear, MultiRam, Casing Shear, LFSCSG and Blind — and NOV writes a separate document
with its own scale for each. Four ram-block tasks match several NOV items equally well and
those items state different criteria, so nothing can be attached without knowing which block
is in the cavity. Splitting Ram Block by type would change task ids, and on this path the id
**is** the posted key, so that is not a change to make casually. It is with Dan.

### 26.3 The remaining 56, and what covers them meanwhile

A review sheet — `CBM-SCHED-CRITERIA-REVIEW-SHEET.html` — groups all 56 by why they were
held back (4 ambiguous, 5 inferred-document, 17 near-misses, 24 no match, 6 no mapped
document), shows the closest NOV item and its actual criteria, and takes a decision per row.

Until those land, the universal GRADE LEVEL EVALUATION GUIDE remains the criteria for every
one of them, and it is reachable from all 95 gradeable items via the `ⓘ scale` button. That
button and the guide behind it have been exercised on the live path.

### 26.4 Nothing you consume has moved

Asserted mechanically, and the run writes nothing if any of these fail:

- **314 CBM_SCHED posted keys, byte-identical** before and after
- task `id`, `desc`, `ct`, `grade` and `subs`: unchanged on every task in all 14 equipment sets
- the only difference is a `grades` array and a `gsrc` string on 9 tasks — both display-only,
  neither collected, neither posted
- posting path still byte-identical to REV 147; zero `no-cors`

One defect was found and fixed while testing this, and it is worth recording because it had
been shipped in our own earlier 148 work: the grade-2–5 note prompt searched only the first
`.cbm-cap` ancestor, and on the live path the notes box sits *outside* that element, so the
prompt was reaching **zero tasks**. It now walks ancestors until it finds the box. Expect the
`_cm` note fields to start arriving populated, which is what 24.4 promised and what was not
actually happening.

---

## Entry 25 — `CBM_GRADED` is dead code in the deployed tool. There are two CBM key namespaces, not one

**Rev: SSORT 147 (deployed) and 148 (building).** Status: **NEEDS DECISION** — this changes
what entry 19 and `cbm-key-map.json` mean, and it is not a change we should make alone.

### 25.1 The finding

SSORT holds two separate CBM datasets, and only one of them can ever render.

```
makeCbmBody()    index.html:7962   if(CBM_SCHED[equipKey] || CBM_SCHED[cbmFamilyOf(equipKey)]) { ... return h; }
                 index.html:7963   if(CBM_GRADED[equipKey]) { ... }        <-- never reached
cbmReportHTML()  index.html:8110   if(CBM_SCHED[d.equip]  || CBM_SCHED[cbmFamilyOf(d.equip)])  { ... return h; }
                 index.html:8111   if(CBM_GRADED[d.equip]) { ... }         <-- never reached
```

`CBM_SCHED` returns early on both the form path and the report path. It covers **14
equipment keys**. `CBM_GRADED` has **11**, and every one of them is covered by `CBM_SCHED`
either directly or through `cbmFamilyOf` — the six `Ram Block::*` variants all collapse
onto `CBM_SCHED["Ram Block"]`.

| | |
|---|---|
| `CBM_GRADED` equipment keys | 11 |
| shadowed by `CBM_SCHED` | **11** |
| reachable by a crew | **0** |

So all 190 `CBM_GRADED` tasks — every description, every grade criterion — are unreachable
in the deployed build. This is **not** something REV 148 introduced: the early return is
byte-identical in 147, which is what the rigs are running.

### 25.2 Two key namespaces, and your index contains both

The two renderers build keys differently, and this is the part that matters to you.

| dataset | key built from | example |
|---|---|---|
| `CBM_GRADED` (`gradedTaskHTML`) | **array position** | `cbm_Gate_Valves_g0_11_gr` |
| `CBM_SCHED` (`cbmCapBlock`) | **the task's own id** | `cbm_Gate_Valves_7_1_2_gr` |

Brad's 29 posted West Capella files carry **both shapes**: 89 distinct positional keys and
39 distinct id-based keys. That is the transition captured mid-flight.

Consequences, stated plainly:

1. **`cbm-key-map.json` remains correct** for what it covers. It maps positional keys, and
   positional keys are exactly the historical ones. Nothing in it needs reissuing.
2. **No new positional key will ever be produced.** Any `_g<si>_<ti>_` key arriving after
   the shadowing took effect is impossible; if you see one, it is a replay of an old file,
   not a new inspection. That is a usable integrity check on your side.
3. **The id-based keys are self-describing and positionally safe.** `7_1_2` is NOV's own
   item number, so the §10.4 failure mode that produced entry 19 **cannot recur** on the
   live path. The class of bug is closed by the very change that created this mess.
4. Entry 19 stands as history, not as a live risk. We should both stop treating it as a
   pending hazard.

### 25.3 What a crew actually sees today

The live dataset, measured:

| | |
|---|---|
| `CBM_SCHED` tasks | 290 |
| showing 1–5 grade buttons | 65 (+30 sub-items) |
| carrying a NOV page reference (`pages`) | 131 |
| carrying an evidence note (`ev`) | 186 |
| **carrying any grade criteria** | **0** |

Not one of the 95 gradeable items on the live path states what a grade means. That is the
"65 tasks with grade buttons and no criteria" item from entry 18, and it is worse than the
count suggested, because the 174 criteria that *do* exist are in the dataset nobody can
reach.

This is why the universal scale matters more than the per-item repair. The `ⓘ scale`
button added in 148 hangs off `gradeButtons`, which is the one function both renderers
share — so it **does** reach all 95 live gradeable items. It has been exercised on the
live path and it opens NOV's five-level guide, with Grade 3 rendered amber, consistent with
your corrected fail bucket from entry 21.

### 25.4 The decision we are not taking alone

There are two honest ways forward and they have different costs:

- **(a) Migrate NOV's per-item criteria into `CBM_SCHED`.** Keeps the id-based keys, keeps
  the §10.4 fix, gives crews real criteria. Cost: the two datasets are structured
  differently and the mapping between 190 graded tasks and 290 scheduled tasks is not
  one-to-one. It is a body of work and it needs matching evidence per item, not guesswork.
- **(b) Un-shadow `CBM_GRADED` for the 11 equipment keys that have criteria.** Cheaper, but
  it reinstates positional keys and therefore reinstates the entry 19 failure mode. We do
  not recommend it.

Our recommendation is **(a)**, and the universal scale in 148 is the stopgap until it
lands. Nothing about this changes any posted key, so there is nothing for you to build
today — but do not size your CBM Heatmap work on the assumption that per-item criteria are
about to start arriving.

### 25.5 One correction to our own earlier entries

Entries 18 and 21 described the 65 blank-scale tasks and the 174 graded tasks as if they
were one population being progressively repaired. They are two populations in two datasets,
only one of which is live. Nothing we told you about the posted keys was wrong, and
`cbm-key-map.json` is unaffected, but the framing was. This entry supersedes that framing.

---

## Entry 24 — SSORT 148: `meta.rev` finally arrives, and every CBM task now has its description back

**Rev: SSORT 148 (built, not shipped).** Status: **NEEDS ACTION** — one new key, and the
thing you have been asking for since entry 8 is in it.

### 24.1 `meta.rev` — your §9.1 item 7 is closed

SSORT has never written its revision into the payload. `SSORT_REV` drove the badge in the
corner and nothing else, so when an SSORT post misbehaved you had no way to tell which
build produced it. From 148 the payload carries it.

```
meta.rev = "SSORT REV 148"
```

One new key, lower case, inside the existing `meta` object. Nothing else in `meta` moved.
Two other places that build their own literal payload — the Daily Checks / FLM route and
the OEM copy — now carry the same `rev` field with the same value, so all three routes
agree.

What this does **not** do: it cannot tell you anything about posts already in your index.
Everything from SSORT 147 and earlier has no `rev` at all. Treat absence as "147 or
earlier", not as an error. And note the WCGRRT trap from entry 20 does not apply here —
there is no SSORT revision carrying a stale constant, because there was never a constant
being posted to go stale.

### 24.2 Forty-seven CBM task descriptions are back. Zero keys changed meaning

Entry 19 reported that the REV 80 restructure had two symptoms, and that the second one —
38 task descriptions stripped to empty — was still outstanding. It is now fixed, and then
some.

| | count |
|---|---|
| descriptions restored from SSORT REV 79 | 38 |
| descriptions restored from the NOV component documents | 9 |
| **tasks with no description, before** | **47** |
| **tasks with no description, after** | **0** |

The nine are the ones that had never had text in **any** of the 85 SSORT revisions, so
there was nothing in our own history to restore them from. They were recovered from NOV's
documents directly — located by the page numbers that the pagination corruption had left
behind in the neighbouring task's description, which is the one useful thing that damage
did. In all nine cases the grades already sitting in the tool match NOV's grades on the
page we found the wording on, which is an independent confirmation that the wording landed
on the right task and not merely a plausible one.

**Nothing you index changes meaning.** §10.4 binds here: the posted key carries the array
index, so a restore that inserted, removed, reordered, split or merged a single task would
repeat the REV 80 failure. The repair edited `desc` text in place and nothing else. Proof,
asserted mechanically and not by eye:

- section count, task count, task `id`, `grades` array and `ct` flag: **byte-identical**
  before and after, every class, every section, every task
- `desc` fields changed: **47**, and every one of them was empty beforehand — the assertion
  fails the whole run and writes nothing if a restore would overwrite existing text
- `CBM_GRADED["Lower SBOP"] === CBM_GRADED["Upper SBOP"]` still true — still one object by
  reference, not a copy that could drift
- the 46 distinct CBM grade keys present in Brad's posted West Capella files resolve to the
  same task in 148 as in 147: 36 identical descriptions, 8 that went from empty to
  populated, 2 pre-existing absences confirmed identical in both builds

So for your CBM Heatmap: the per-item history does not splice, and 8 items that previously
rendered with a blank label will now render with NOV's wording. You do not need to change
anything. If you cache task labels anywhere, refresh them after 148 ships.

### 24.3 The N/A question from entry 18, answered: **none of them**

Dan's rule was that a task with genuinely no inspection criteria cannot be graded and
should be marked N/A — but only after checking whether text was supposed to be there.
We checked all 47 against the component documents. **Every single one is a real NOV
inspection item whose text was lost.** Not one is genuinely N/A.

That matters to your side because entry 18 left open the possibility that some grade
buttons would disappear or gate to N/A. They will not. The task count is unchanged and no
key retires. Entry 18.3's withdrawal stands and nothing further is withdrawn.

One of the nine is worth naming because it confirms the §10.5 corruption pattern outright.
`cbm_Ram_Block__LFS_g0_5` had an empty description and a G5 string reading
*"Visually inspect blades for damage and scoring."* — that is not a grade, that is the
task. The extractor had shifted the task wording into the G5 slot. NOV's page 12 carries
the clean five-line scale for that item, so the repair in 24.6 has a source for it.

### 24.4 What you will see more of: populated note fields

Display-only changes, no keys, but they change what arrives:

- NOV's universal five-level scale (§7 of every component document, identical in all of
  them) is now reachable from every one of the 174 graded tasks via an `ⓘ scale` button.
  Reference only — nothing about it is recorded or posted.
- Selecting grade 2, 3, 4 or 5 now sets an amber placeholder on that task's note box asking
  for **type, location, depth and severity**, which is what NOV asks for. It is a
  placeholder and a prompt, not a gate — it does not block save and it does not block post.

Expect the `_cm` note fields to arrive populated far more often than they used to, and with
more structure in them. Nothing to build, but if you have a "notes empty" indicator
anywhere it is about to get much quieter.

### 24.5 Two dead blobs stripped — byte accounting

Both were base64 copies of standalone tools embedded as iframes, and both were
unreferenced. Declarations removed entirely and replaced with a comment saying what was
there and why it went.

| | chars |
|---|---|
| `CONDUIT_FLUSH_HTML_B64` | 22,356 |
| `PRECHARGE_HTML_B64` | 303,140 |

File on disk: **8,941,320 → 8,628,248 bytes (−313,072)**. That is smaller than the 325,496
stripped because 148 also adds the grade guide, the note prompt, `meta.rev` and 47
descriptions — roughly 12,300 chars back in. Nothing on the posting path changed: the
transport lines are byte-identical to 147 and there are zero `no-cors` occurrences.

The three live blobs — `ACOUSTIC_TEST_B64`, `EHBS_TEST_B64`, `DRAWDOWN_TEST_B64` — are
**still in SSORT and still live**, read by the same two call sites entry 17 described.
WCGRRT is now free of all three (entry 23); SSORT is not. That work is not in 148.

### 24.6 Still open in 148, so do not treat it as finished

Three things remain, and two of them will produce another entry before 148 ships:

1. **The per-item grade strings.** Restoring the descriptions has made the damage more
   visible, not less: several tasks now read `G1: GRADE 5` with no other levels, and the
   LFS case in 24.3 still carries the task wording in its G5 slot. The review sheet is
   signed off and the repair is next. **No key changes** — same rule as 24.2, text in
   place only. Anything NOV does not state stays marked UNCERTAIN; we are not inventing a
   missing G2 or G4 to make a scale look complete.
2. **Conditional triggers on failure.** Grade 4 or 5 will reveal the matching
   conditional-trigger tasks. Display-only as currently designed — if that changes to
   something that posts, you get a key list first.
3. **`CBM_GRADED["Single NXT Body"]`**, which has grade buttons and no criteria at all.

### 24.7 Nothing to reply to unless you want to

The only thing in this entry you must act on is `meta.rev` in 24.1, and "act on" means
start reading it. Everything else is either invisible to you or makes an existing field
better populated. The Grade 3 disagreement from entry 21 is resolved on your side already
and needs nothing further here.

---

## Entry 23 — EHBS and Drawdown native: the `ehbs_*` and `dd_*` keys, and the last iframe is gone

**WCGRRT REV 166 · 23 September 2026 · NEEDS ACTION — two key families, announced before shipping**

`soaklabels` renamed lower case in REV 165 as you asked, and the reasoning went into the file
beside it so nobody "tidies" it back. **REV 165 is finished and unchanged** — it is still
exactly the build you tested against, and it can go to the rigs.

**REV 166 is separate on purpose.** You validated 165; folding EHBS and Drawdown into it would
have meant what ships is not what you tested. 166 has not been deployed.

### 23.1 What changed

EHBS and Surface Drawdown were the last two `<iframe>` surface tests. Both are now native
forms whose fields carry `data-soak`, so **§7.2's data loss is closed across the whole of
WCGRRT**: the tool now contains **no iframe at all**, and `surfEmbed` — the helper that mounted
them — is dead code, left in place with a comment saying why it must never be called again
rather than quietly deleted.

Both ports were taken from the embedded blobs, which were verified **sha256-identical** to
`EHBS Template\Seadrill EHBS Function Test.html` and `Accumulator Drawdown Template\Seadrill
Accumulator Drawdown Test.html` first, so there is no question of the embedded copies having
drifted from the templates.

Entry 17's NIL still holds: no posted file ever carried an EHBS or drawdown soak key, so
**there is no history to migrate** — nothing to map, nothing to keep apart.

### 23.2 EHBS keys — 71 distinct, and the shape depends on the rig CLASS

Unlike acoustic, these are **not rig-slugged**. The thirteen rigs fall into three classes and
the key set is the same for every rig in a class:

| Class | Rigs | Keys |
|---|---|---|
| `single` | Auriga, Capella, Carina, Gemini, Jupiter, Polaris, Tellus | **28** |
| `seq` | Libongos, Quenguela, Neptune, Saturn, Vela | **33** |
| `dmas` | **Sevan Louisiana only** | **55** |

| Key | Meaning |
|---|---|
| `ehbs_shear` | the selected shear ram, `UBSR` or `LBSR`. **Absent on DMAS**, which has no shear selection |
| `ehbs_hdr_<field>` | `date well operator stackTemp dcbPc` |
| `ehbs_ip_<field>` | `cpShear dcb podAcc podArm podDis`, plus `autoshear` and `stackAcc` **on DMAS only** |
| `ehbs_chk_<item>` | pre-test checklist (single and seq). `shearOpen`, `csrOpen` (seq only), `noPipe`, `simBtns`, `podArm`, `rov` |
| `ehbs_chk_shearAcc_charge` / `_isolate` | **one item, two keys.** The dedicated shear accumulators are recorded in BOTH states, so the record shows the valve was worked through its full travel rather than left where it was found |
| `ehbs_tim_<step>` | timing. single: `clock`, `close`. seq: `clock`, `csrStops`, `shearStarts`, `shearStops` |
| `ehbs_tim_delay` | **derived, see 23.4** |
| `ehbs_open_<ram>` | ram opening. `shear`, plus `csr` on seq; on DMAS `csr`, `ubsr`, `lbsr` |
| `ehbs_p1_*` / `ehbs_p2_*` | **DMAS only** — the two-part test. Each part carries its own `_chk_`, `_act_` and `_tim_` sets |
| `ehbs_sig_<client\|dsl\|subsea>` / `_date` | signer name and date |
| `ehbs_notes` | free text |

DMAS part detail, since it is the one shape you cannot infer: `_chk_` is `noJoint drilling
bottles vented armed opposite safe`, plus `isolated` on part 2 only; `_act_` is `s1 s2 s3 s4
rst`; `_tim_` is `t0 lbsrLock ubsrStart ubsrLock` on part 1 and `t0 csrClosed ubsrStart
ubsrLock` on part 2. `t0` is the fixed zero datum and always posts `"0"`.

### 23.3 Drawdown keys — 54 with the default four functions, and the row count is NOT fixed

| Key | Meaning |
|---|---|
| `dd_hdr_<client\|well\|date>` | test details |
| `dd_st_<blue\|yellow\|dcp\|tcp>` | control station, `USED` or `N/A` |
| `dd_ip_<field>` | `precharge ambient initAcc manifold upperAnn lowerAnn` |
| `dd_t_<rowid>_<c\|o>_<time\|gal\|psi>` | the table. `c` close, `o` open; seconds, gallons, remaining psi |
| **`dd_rows`** | **read this first** — `"r1:Pipe Ram\|r2:Annular\|r3:CSR\|r4:BSR"`. The crew can add, remove and relabel functions, so the row ids and their labels are only knowable from this key |
| `dd_acc_mop` | MOP in psi, typed by the crew |
| `dd_acc_rwpMin` / `_rwpSec` | recharge to system RWP |
| `dd_acc_zeroMin` / `_zeroSec` | recharge from zero |
| `dd_final_psi`, `dd_chk_precharge`, `dd_chk_mop`, `dd_chk_rwp` | **derived, see 23.4** |
| `dd_sig_<subsea\|dsl\|coman>` / `_date` | signer name and date |
| `dd_notes` | free text |

**Do not assume four rows and do not assume the labels.** Parse `dd_rows`; the ids are `r1`,
`r2`, … and are not reused after a removal, so a post can legitimately carry `r1|r3|r4|r5`.

### 23.4 The derived values, and why they are posted rather than left for you to compute

Five keys are computed by the tool and posted as data:

| Key | Rule |
|---|---|
| `ehbs_tim_delay` | `shearStarts − csrStops`, to 2 dp |
| `dd_final_psi` | the **last** remaining-psi recorded anywhere in the table, row order, close before open |
| `dd_chk_precharge` | `PASS` when `final_psi >= dd_ip_precharge + 200` — **API STD 53 4th ed** |
| `dd_chk_mop` | `PASS` when `final_psi > dd_acc_mop` — **STD 53 5th ed, Annex C** |
| `dd_chk_rwp` | `PASS` when `rwpMin*60 + rwpSec <= 900` |

Each is `PASS`, `FAIL`, or **absent when the inputs are not there** — absent means "cannot be
judged", never "fail".

You could recompute all of these, and you are welcome to as a cross-check. They are posted
because **one source of truth means the rig and the dashboard cannot disagree about whether a
BOP passed its drawdown** — the same reasoning as the `counts` block. If your recomputation
ever differs from the posted verdict, that is a defect and we want to hear about it.

Three boundaries worth knowing, because they are easy to get wrong and they are asserted in
the build: pre-charge is **`>=`** so exactly +200 passes; MOP is **`>`** so exactly MOP fails;
recharge is **`<=`** so exactly 15:00 passes.

Also derived but display-only, not posted: a close or open time over its limit is shown in red.
The limit is **60 seconds for an annular and 45 for everything else**, taken from the function
label on that row.

### 23.5 `soaklabels` covers both

Every one of these keys carries a label, harvested the same way as acoustic — emitted by the
row that draws the field, so a relabelled function or a reissued sheet relabels itself.
Examples: `dd_t_r2_c_time` → *"Annular — Close time (sec)"*, `ehbs_p1_chk_noJoint` → *"Part 1 —
Test joint is not installed in the BOP"*, `dd_chk_precharge` → *"STD 53 4th ed - remaining ≥
pre-charge + 200 psi"*. Verified: 28/28, 33/33, 55/55 and 54/54 keys labelled, none missing.

`"N/A"`, `"USED"` and `"visual"` are real values, not blanks; an unanswered field is absent.

### 23.6 Size, since it affects your scan

REV 164 was 5,095,443 bytes. REV 166 is **3,327,978** — **1,767,465 bytes smaller, 34.7% off
every rig's download**, from stripping the three base64 tools now that nothing reads them.

### 23.7 Verified

- Acceptance arithmetic ported verbatim, then asserted against hand-computed values:
  **17 of 17 pass**, including all three boundary cases above and "blank is null, not zero".
- All three EHBS classes rendered and counted; DMAS correctly shows no shear selector.
- Restore path checked for both forms: values return and the drawdown verdicts **recompute from
  the restored data**, which is the case that matters after a crash.
- Add and remove row exercised; `dd_rows` tracks correctly and orphaned cell keys are dropped.
- `node --check` clean, extraction reconciles, **411 bound functions, zero duplicate
  declarations**; every new name grep-checked against the file before insertion (§7.9).
- Posting path byte-identical to REV 164: `sdPostReport`, `sdWriteToReportFolder`,
  `REPORT_POST_URL`. Zero `no-cors`.
- **Nothing has been posted and REV 166 has not been deployed.**

---

## Entry 22 — acoustic: the final key list and `soakLabels`. You can build the renderer now

**WCGRRT REV 165 · 22 September 2026 · NEEDS ACTION — one naming question, then build**

Entry 15.2 told you to build nothing for acoustic until the real keys arrived in this file.
**This is that entry.** REV 165 is built and verified but **has not shipped and will not ship
until you have had this.**

### 22.1 What was wrong and what is fixed

The shadowing ROV clone is deleted, the REV 163 native form is now the one that is bound, and
the report renderer is repointed to `acousticReportHTML` in the same edit. Verified by
evaluating the built file and reading the bound function back: it reads `ACOUSTIC_SHEETS`,
honours `ACOUSTIC_NO_SYSTEM`, writes `acst_*`, and does **not** touch `RIG_ROV_MAP` or
`acoustic_sheet`. 378 bound top-level functions, **zero duplicate declarations** in the whole
file.

**`acoustic_sheet` and `ac_<sheet>_r<n>_v|_t|_rk` are retired.** They were only ever the
defect. Entry 17's answer confirmed no posted file carries them, so there is no history to
migrate — nothing to map, nothing to keep apart.

### 22.2 The keys

All lower-case-prefixed `acst_`, inside `equipEntries[].soak`, exactly as `ft_*` and `eds_*`
are today. Harvested by rendering every rig and stack, not from reading the source:
**512 distinct keys across 10 rigs.**

| Key | Meaning |
|---|---|
| `acst_stack` | the selected stack. Present on every post; the value is the stack name (`Stack 1`) or `''` on a single-stack rig |
| `acst_hdr_<field>` | the 17 header fields: `acReg` `acSupply` `aftTxArm` `battery` `date` `dcbPc` `disarmP` `fwdArmAcu` `fwdTxArm` `nonShrArmP` `nonShrPc` `operator` `pilotAcc` `scu1` `scu2` `shrArmP` `well` |
| `acst_<rigslug>_<stackslug>_f<n>_act` | the function's Pass / Fail / N/A |
| `…_f<n>_fwd` · `…_f<n>_time` · `…_f<n>_aft` | forward volume, time in seconds, aft volume |
| `acst_asr_<0-6>` | the seven ASR checklist rows, Pass / Fail / N/A |
| `acst_sig_<client\|dsl\|subsea>` | signer name |
| `acst_sig_<client\|dsl\|subsea>_date` | signer date |
| `acst_notes` | free text |

**The slug rule**, because you will need it to parse the function keys: `<rigslug>` and
`<stackslug>` are the rig name and stack name with every run of non-alphanumeric characters
replaced by a single `_`, and **a single-stack rig uses the literal `x`** as its stackslug.
So `acst_West_Saturn_Stack_1_f0_act` and `acst_West_Capella_x_f3_time`. West Saturn is the
only two-stack rig.

**Row counts differ by rig** — 8 functions on Capella and Gemini, 10 on Saturn, 12 on the
other seven. Do not assume a fixed row count.

**Two values are real, not blanks** (the REV 150 lesson): a cell that does not apply carries
the literal `"N/A"` and an ASR-verified cell carries the literal `"visual"`. Neither is an
empty string, so you can tell them from "nobody filled it in", which stays absent.

### 22.3 `soakLabels` — and it travels with the first post, as you asked

`equipEntries[].soakLabels`, a flat map beside `soak`, **same key set, one label per key**:

```
"soak":       { "acst_West_Saturn_Stack_1_f2_fwd": "12.5" },
"soakLabels": { "acst_West_Saturn_Stack_1_f2_fwd": "Upper blind shear rams close — Fwd vol" }
```

Real examples from the built file:

| Key | Label |
|---|---|
| `acst_West_Saturn_Stack_1_f0_act` | `Disarm — Actuated` |
| `acst_West_Saturn_Stack_1_f2_fwd` | `Upper blind shear rams close — Fwd vol` |
| `acst_hdr_well` | `Well` |
| `acst_asr_0` | `ASR — All lower stack functions in block/vent` |
| `acst_sig_subsea` | `Subsea supervisor — Name` |
| `acst_stack` | `Stack` |

**Built at collect time from the same tables that render the form** — the label is emitted as
`data-soak-label` beside `data-soak` by the row that draws it, and harvested by
`collectSoakLabels`. This is deliberate and it is the whole point: a static map sent to you
once would be correct the day it was sent and quietly wrong the day NOV reissue a sheet.
Reissue the sheet, the labels change themselves.

**A label is only emitted for a key that carries a value**, so the two maps never disagree
about which keys exist. Verified on a filled form: 19 soak keys, 19 labels, zero keys without
one.

`soakLabels` is generic, not acoustic-only. It is empty today for `ft_*` and `eds_*` because
those renderers do not yet emit the attribute; when they do, the same collector picks them up
with no change on either side. Treat an absent or empty `soakLabels` as "no labels available",
never as an error.

### 22.4 The one thing to settle before it ships

**`soakLabels` is camelCase and our standing rule is lower case.** It is the name you asked
for in entry 12.2 and the one your contract already carries, and it sits beside `tileDate`,
`equipEntries` and `flagEot`, which are camelCase too — the lower-case rule came from the
`meta.reportdate` incident specifically. Your `Get-Prop` has been case-insensitive since
v2.60, so either works.

**REV 165 has not shipped, so a rename is free right now and will never be free again.** Say
`soaklabels` and it is one line; say nothing and it ships as `soakLabels`.

### 22.5 Also in REV 165, affecting nothing of yours

- **Sevan Louisiana** added to `ACOUSTIC_NO_SYSTEM`. All three rigs with no acoustic system
  now say so instead of being offered a sheet.
- **The restore path is fixed.** `makeEquipEntry` was still mounting the iframe, so a draft
  restored after a crash came back blank and the next collect overwrote the real answers
  (§7.2). Proven side by side against REV 164 in one run: 164 restores 0 fields, 165 restores
  all of them including the stack.
- **`ACOUSTIC_TEST_B64` stripped** — 597,926 bytes, 11.74% off every rig's download, now that
  both its call sites are native. `EHBS_TEST_B64` and `DRAWDOWN_TEST_B64` are untouched and
  still live.

### 22.6 Verified

- Bound-function check on the built file: the native pair is bound, all three deleted names
  are `undefined`, zero duplicate declarations.
- `node --check` clean; extraction reconciles to the file length exactly.
- Opened in a browser: West Saturn renders its own table with the Stack 1/2 selector and
  drawing reference 10721470-SCH; West Neptune renders "no acoustic system fitted" and zero
  fields. Screenshots taken, per the rule that a diff is not evidence a form renders.
- Key inventory harvested by rendering all 10 rigs and both Saturn stacks.
- **Nothing has been posted.** REV 165 has not been deployed.

---

## Entry 21 — the key map, a correction to entry 19, and one thing we think you have got wrong

**SSORT REV 147 · 22 September 2026 · NEEDS DECISION — Grade 3**

Thank you for v2.61. Splitting at the boundary rather than merging was the right call, and
*"a split is a labelled gap; a merge was a wrong trend"* is the sentence that should survive
this whole exchange.

### 21.1 `cbm-key-map.json` — delivered, deliberately partial

In the repository root, in your schema. **Every class moved at the same moment**, so the
global `boundary` of `2026-07-19` holds and no per-class override is written: for all six
classes the earliest revision whose shape matches REV 147 is REV 80.

| | Keys |
|---|---|
| re-pointed to a current index | 16 |
| unchanged, mapped to themselves (removes their split) | 7 |
| removed → `null` | 5 |
| **deliberately left out** | **20** |

**The 20 are left out because mapping them would have been a guess**, and your rule that
anything absent stays kept apart makes silence the safe answer. Fourteen are ambiguous —
the task description is not unique, so it cannot identify a task. Riser Adapter's *"Visual
inspection of all fasteners for corrosion and back off"* appears **three times** in the old
template; Gate Valves' matched description appears twice in REV 147. Six more had a blank
description at post time, so there is nothing to match on at all.

**A confession about the first version of this file.** It mapped all of them, by nearest
description, and four Riser Adapter keys collapsed onto `o:1.5` and three onto `o:1.3` —
a silent merge of distinct historical grades, which is precisely the failure we are both
trying to undo. It was rebuilt to emit a mapping only where it is unambiguous in both
directions, and the rebuilt file is asserted to contain **zero colliding targets**. If a
future version of this map ever maps two sources to one target, it is wrong.

### 21.2 Correction to entry 19.1 — `o:2.2` is not orphaned

Entry 19 told you `cbm_Riser_Adapter_g2_2` *"does not exist"* in REV 147. **That was wrong,
and the map contradicts it.** The *index* was out of range, because section 2 shrank from
four tasks to two — but the task itself survived and relocated. *"…low pressure testing down
through the booster line"* is now at **`o:3.3`**, and `o:2.3` is at `o:3.4`. Both are mapped.

So entry 19's "2 orphaned" is wrong. The genuinely removed set is **5 different keys**:
Flexloops `o:0.0`, `o:0.3`, `o:0.5`, and Gate Valves `o:1.0`, `o:1.2`. Entry 19 stays as
written with this correction beside it, per the convention on your side that a corrected
wrong conclusion is the more useful record.

### 21.3 The map is a REV 147 snapshot and will need a v2

SSORT 148 restores **38 task descriptions** that REV 80 stripped (entry 19's other symptom).
Once they are back, several of the 20 left-out keys become matchable and at least one `null`
becomes an identity mapping — Flexloops `o:0.0` is `null` today only because its text is
missing from REV 147, not because the slot is gone. **Take this file now and expect a v2
after SSORT 148 ships.** Nothing in v1 will be contradicted by v2; it will only get less
partial.

### 21.4 Grade 3 — we think the new fail bucket is wrong

You wrote: *"3, 4 and 5 are the fail bucket … If SSORT 148 turns grades 4 and 5 into 'Not
acceptable' on screen, the dashboard now agrees with it."* **Those two sentences disagree
with each other, and three sources say Grade 3 is acceptable:**

| Source | Grade 3 |
|---|---|
| NOV's §7 GRADE LEVEL EVALUATION GUIDE, in every component document | *"Evidence of wear, damage or corrosion that requires monitoring (**Fair/Acceptable working condition**)"* |
| `CBM Grading — Reference and Acceptability.pdf` | Grades 1–2 ACCEPTABLE · **Grade 3 ACCEPTABLE WITH FINDINGS** · Grades 4–5 NOT ACCEPTABLE |
| SSORT's own report renderer, `grcol()` today | 1 and 2 green, **3 amber**, 4 and 5 red |

Only grades 4 and 5 are "Not acceptable" in NOV's own words. A Grade 3 is *in service,
monitor at the next interval* — and it is the grade Brad recorded five times on West Capella,
all of which are currently on the dashboard.

**Why it matters beyond colour.** SSORT 148's conditional-trigger feature fires at **4 or 5**,
because that is where §7 puts the line. If your fail bucket starts at 3, the same inspection
reads as *acceptable, monitor* on the rig and *failed* on the dashboard, and the first person
to notice will be a superintendent asking why the dashboard says his BOP failed.

**What we would ask:** make Grade 3 its own amber band — *acceptable with findings* — and keep
the fail bucket at 4 and 5. That matches NOV, the Seadrill reference, the tool's own colours
and the CT threshold, all at once. Your call, but please do not leave the two sides
disagreeing about what "acceptable" means.

### 21.5 Acknowledged, nothing needed

- **`itemLabel` is key-derived** — thank you, that is the better failure and it closes 19.3.
- **CBM to OEM live and tested.** Noted that the button can ship whenever ready, that
  `subject` and `pdfName` are used exactly as posted, and that the 20 MB warn / 30 MB refuse
  on the button is the only size guard. It is not in WCGRRT 165 or SSORT 148; it goes on the
  queue as its own item.
- **Your two `seadrill-oem_*` test files** — understood, and thank you for saying so
  unprompted. Nothing on this side treats them as tool posts.
- **20.1, the "last post from REV n" line:** worth having, and it is Dan's call. It needs
  SSORT item 7 first, which is in SSORT 148.
- **Grades `'1'`–`'5'`:** correct, five levels, and a posted `5` was always possible.

### 21.6 Verified

- The map is built by evaluating `CBM_GRADED` in the revision current on each post's own
  `cbmData.date` and matching the description forward into REV 147; `class` is `cbmData.equip`
  exactly as posted.
- Per-class boundary computed as the earliest revision whose section/task shape equals
  REV 147's: REV 80 for all six classes, hence one global boundary.
- Collision assertion run over the emitted file: 0.
- `o:2.2` → `o:3.3` confirmed by matching the REV 79 description forward, not by index.
- **Nothing was changed in either tool for this entry.** One file added to the repository root.

---

## Entry 20 — state of play: what is built, what is coming, and which of it touches your side

**WCGRRT 164 → 165 · SSORT 147 → 148 · 22 September 2026 · FYI — one thing to wait for**

Dan asked for a single picture of where this sits, because entries 17, 18 and 19 each landed a
finding and none of them said what happens next. **Nothing has shipped. No tool file has been
modified at all.** Everything so far is investigation plus three documents.

### 20.1 The live revisions, and how they were established

| Tool | Live | How |
|---|---|---|
| WCGRRT | **REV 164** | the served file on `sacred` is sha256-identical to the REV 164 folder (`bcb8495f0aeb…a60ed`), and Dan confirmed 164 from the on-screen badge |
| SSORT | **REV 147** | the badge on a rig machine. There is no file route — SSORT still writes no `meta.rev`, which is why §9.1 item 7 exists |

The newest post we can see stamps `WCGRRT REV 162`, so a build can sit deployed for days
before a rig opens it. **Server build is not last-posted build**, and for SSORT there is no
way to tell from a file at all until item 7 ships.

### 20.2 What is being built, and what it does to the payload

Two revisions, deliberately not one:

| # | Change | Rev | Payload effect |
|---|---|---|---|
| 1 | **Acoustic defect fixed** — the shadowed ROV clone deleted, the REV 163 native form actually reachable, the report renderer repointed, Sevan Louisiana added to `ACOUSTIC_NO_SYSTEM`, and `makeEquipEntry` converted so a restored draft keeps its data | WCGRRT 165 | **YES — keys change from `acoustic_sheet` / `ac_*` to `acst_*`, and `soakLabels` arrives with them.** Full list to you in this file BEFORE it ships |
| 2 | NOV's universal §7 grade guide added to the tool, once, reachable from every graded task | SSORT 148 | none — display only |
| 3 | A prompt for type / location / depth / severity when a grade of 2 or worse is pressed | SSORT 148 | none — placeholder text on the existing Notes box |
| 4 | `CBM_GRADED["Single NXT Body"]` supplied, which both Triple NXT aliases inherit | SSORT 148 | none — no new key; those classes simply start rendering a graded section that has been empty since the alias was written |
| 5 | **38 lost task descriptions restored** from REV 79 (entry 19's other symptom) | SSORT 148 | none — text in place, no index moves |
| 6 | Per-item grade criteria repaired from the component documents, signed off by Dan 22 Sep | SSORT 148 | none — the stored value is a bare `'1'`–`'5'`/`'N/A'`; the arrays are display text |
| 7 | NOV document, section and page cited against each task, so the OEM can see compliance | SSORT 148 | none — display only |
| 8 | **Conditional triggers surface on a failing grade** — a grade of 4 or 5 reveals the matching CT tasks with NOV's own trigger text | SSORT 148 | none — display only, no block on save or post |

**Only item 1 changes a key.** Everything in SSORT 148 is additive or display-only and none of
it touches a key, a value, a filename or the posting path.

### 20.3 Why two revisions and not one upload

Dan asked whether this should all go up at once. **No, and entry 19 is the reason.** REV 80 was
one large restructure; it re-pointed 38 posted keys and stripped 38 task descriptions, and
neither was noticed for two months because neither raises an error. A single big release is how
that happened.

So: the acoustic fix ships on its own, because it is a live defect on thirteen rigs and it is
small enough to verify by looking at the screen. The CBM work ships as one coherent SSORT
release, because it is all one subsystem, all off the posting path, and splitting it further
would cost thirteen rigs a download per change for no extra safety.

### 20.4 Item 8 is new — and it came from NOV's own wording

Dan asked whether a failing grade should open the conditional-trigger task. It does not today:
`cbmSetGrade` writes the value and nothing else, `toggleCbmSec` is a manual accordion, and `ct`
only adds a badge and a CSS class while `trig` renders as static text.

But NOV's triggers are mostly failure-based. Of 100 distinct `trig` strings across 148 `ct`
tasks, **63 reference a failure**, and the most common single trigger — six tasks — is
*"Failed Visual Inspection · Failed dimensional inspection"*. The threshold comes free from the
§7 guide: grades 1–3 are acceptable, **4 and 5 are "Not acceptable"**. So "grade 4 or 5 reveals
the CT tasks" is NOV's model, not an invention.

Nothing for you to build. Recorded because it will change what a CBM report *looks* like on the
rig, and because if it ever grows beyond display-only it becomes a payload change and you will
hear about it here first.

### 20.5 Revision numbering stays integer

Dan floated a new scheme (`1A`, `1B`, …). Recommended against, and he has the reasoning: the
folders are the only rollback point there is, `REV 1A` sorts before `REV 60` in a folder
listing, and `meta.rev` is your only route from a posted file back to a build — a scheme change
would leave your stored history with `WCGRRT REV 162` followed by something unorderable. So
**WCGRRT 165 and SSORT 148**, and the sequence continues.

### 20.6 What we need from you, and what we do not

- **Nothing to build.** Item 1's key list is the only thing you wait for, and it comes here
  before it reaches a rig.
- **Entry 19's question still stands:** does `cbmGrades[].itemLabel` derive from the key alone,
  or from anything that attaches a task description to it?
- **Nothing is posted from a test.** Local saves on the asset `SSCE Equipment` prove the build;
  Dan does the first real post, on a real rig, when he says. If you see a CBM or rig-visit post
  from `SSCE Equipment`, that is a mistake and we want to know.

### 20.7 Verified

- Live revisions as §20.1, by hash against the served file and by the badge.
- The eight items above are scoped against the current code, not planned in the abstract;
  items 4 and 5 come from evaluating 85 SSORT revisions, item 8 from reading `cbmSetGrade`,
  `toggleCbmSec` and all 148 `trig` values.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 19 — the positional-key failure has already happened: 38 of 65 posted CBM grade keys changed meaning

**SSORT REV 80 → 147 · 22 September 2026 · NEEDS ACTION — affects how your CBM history reads**

Entry 16.3 and entry 18.5 both describe `CBM_GRADED`'s positional keys as a hazard to avoid
in any future repair. **It is not a future hazard. It happened in July, and nothing reported
it, because there is no error to raise.**

### 19.1 What happened

`CBM_GRADED`'s posted key carries **array indices**, not task ids:
`cbm_Gate_Valves_g0_2_gr` is section 0, task 2. The Riser Adapter template was rebuilt at
**SSORT REV 80, 19 July 2026** — 5 sections with `[15, 2, 4, 1, 1]` tasks became 4 sections
with `[28, 16, 2, 12]`. Other classes moved too. Every index recorded before the rebuild now
points somewhere else.

Brad's 29 posted West Capella CBM files carry **172 non-empty grades**: 107 on the id-based
`CBM_SCHED` path and **65 on the positional `CBM_GRADED` path**. Comparing each positional
key's meaning in the revision current on its own report date against REV 147:

| | Keys |
|---|---|
| still resolve to the same task | 27 |
| **resolve to a DIFFERENT task** | **36** |
| no longer exist at all | 2 |
| **total no longer meaning what was recorded** | **38 of 65** |

Concrete, all live in posted files:

| Key | Recorded against | Now reads as |
|---|---|---|
| `cbm_Gate_Valves_g1_1` = 1 | Wellbore Pressure Test to **Maximum Working Pressure (MWP)** | Dimensional inspection of operator body |
| `cbm_Riser_Adapter_g1_0` = N/A | **Pressure test** the boost gate valve, open position | Visually inspect the entire Riser Adapter Body |
| `cbm_Riser_Adapter_g2_2` = 1 | low pressure testing down through the **booster line** | **index does not exist** |
| `cbm_Ram_Block__Shear_g0_0` = **3** | Visually inspect Ram Blocks for scoring, corrosion | task with no description |

A recorded MWP pressure test presents as a dimensional inspection.

### 19.2 One thing it is NOT — checked, because Dan challenged it

Dan asked whether a dimensional inspection appearing against a pressure test is simply a
**conditional trigger** firing. Fair question, and `ct` is real: `CBM_SCHED` carries it on
**172 of 290 tasks** with a `trig` field, rendered as *"Condition triggers: …"* and labelled
`[CT]` or `[BW]`.

**It does not explain this.** Of the three examples checked against the REV 147 task objects,
`cbm_Gate_Valves_g1_1` and `cbm_Riser_Adapter_g1_0` are **`ct: false`**, and the whole Gate
Valves section has no conditional task in it. Only the Ram Block example lands on a `ct: true`
task — which describes what the destination task is, not why a low-pressure-test grade appears
against it. And an index that no longer exists at all (`g2_2`) cannot be conditional.

### 19.3 What this means for you, and the one question

Your contract says `cbmGrades[]` is *"not deduped away across dates — every inspection date
for the same item is kept, since that's what the CBM Heatmap's history drill-down reads."*
That is exactly where this bites: **across the July boundary, the same `itemKey` is a
different task**, so a per-item history line can splice two unrelated inspections into one
trend.

**The question:** does `cbmGrades[].itemLabel` derive from the key alone, or from anything
that could attach a task description to it? If it is key-derived it is opaque rather than
wrong, which is the better failure — but the drill-down still groups across the boundary.

### 19.4 What is NOT wrong — please do not conclude the data is junk

- **Brad's grades are sound.** Dan, 22 September: NOV were on site for the West Capella
  inspection and briefed him on the criteria directly. He did not have the documents, but he
  had the grading standard from NOV in person. This is an interpretation problem with the
  stored keys, not a quality problem with the grading.
- **The 107 `CBM_SCHED` grades are unaffected** — id-based keys, as entry 18.5 says.
- **No safety consequence identified.** Nothing re-points a benign grade onto a defect or
  vice versa; the grades are what they are, it is the task label against them that moved.
- **The photograph candidates are unaffected.** The two Grade-3 records that matter
  (`cbm_Gate_Valves_g0_2`, choke and kill lines, six photographs between them) are both in
  the "same task" group.

### 19.5 It is recoverable, and we hold the mapping

There is no git history for these tools, but **the REV folders are the history**, and they go
back to REV 60. The full 38-row `then → now` mapping per key is computed on this side and is
available whenever you want it. One caveat stated honestly: the "then" revision is chosen from
each REV folder's file date as a proxy for what the rig was running. A rig on a cached older
copy would shift an individual attribution; it does not change the finding.

The lesson is the one entry 18.5 already drew, now with evidence behind it: **strings only,
structure untouched.** Any repair that inserts, removes, reorders, splits or merges a
`CBM_GRADED` task does this again, silently.

### 19.6 Verified

- `CBM_GRADED` and `CBM_SCHED` extracted by **evaluating** the real assignments in 85
  readable SSORT revisions (REV 60 to 147), not by parsing text, so aliasing by reference is
  observed rather than assumed.
- The Riser Adapter shape change was located by walking every revision: `[15,2,4,1,1]`
  through REV 79, `[28,16,2,12]` from REV 80.
- Each posted key compared against the revision current on its own `cbmData.date`, not one
  revision applied wholesale.
- `ct` checked on the actual REV 147 task objects, not inferred from wording.
- Also confirmed independently, both as entry 18.5 states: Upper SBOP really does carry two
  sections both `id 10.1 "Dimensional Inspection"` with one task each; and `CBM DOCS\` holds
  44 PDFs that are 16 distinct by content hash and about 14 distinct documents by title and
  page count.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 17 — acoustic is not WCGRRT-only: SSORT has the same three embedded tools, live

**WCGRRT REV 164 · SSORT REV 147 · 22 September 2026 · NEEDS ACTION — one question from your data**

Your entry 15.2 asked us not to build the `acst_*` renderer yet, and we told you the keys
you would actually see come from WCGRRT's shadowed ROV clone. **That was right as far as it
went, and its scope was wrong.** A blob inventory of both tools found the same three
embedded test tools in SSORT, live, at the same two call sites.

### 17.1 What is actually in the two files

`ACOUSTIC_TEST_B64`, `EHBS_TEST_B64` and `DRAWDOWN_TEST_B64` are present **in both tools**,
and in both they are read from two places:

| Tool | `onSurfaceTestChange` | `makeEquipEntry` |
|---|---|---|
| WCGRRT REV 164 | declared 3699, calls at 3705 / 3709 / 3710 | declared 5961, call at 6005 |
| SSORT REV 147 | declared 3986, calls at 3992 / 3993 / 3994 | declared 5731, call at 5762 |

The ternary chain at SSORT 5762 is character-identical to WCGRRT 6005. Our §8.2 attributed
these three to WCGRRT alone; that table was built from WCGRRT and never re-run against
SSORT.

**So §7.2's iframe data-loss defect exists in SSORT too**, for acoustic, EHBS and drawdown
— not only for Ram Cavity as §7.2 says. Anything a crew types into those three forms in
SSORT is printed into the PDF and collected nowhere, with no error, exactly as in WCGRRT.

### 17.2 What this changes for you

Entry 15.2 told you a stray acoustic soak block would be an artefact of a WCGRRT defect.
**Widen that:** `acoustic_sheet` and `ac_<sheet>_r<n>_v` / `_t` / `_rk` can in principle
arrive from **either** tool, and from any rig, and in both cases they are a ROV sheet
rendered under an acoustic heading rather than a record of an acoustic test.

Our recommendation is unchanged and now firmer: **build nothing for acoustic yet.** The
final key list comes to you in this file before it reaches a rig.

### 17.3 The duplicate sweep you asked for — done, and the news is good

Entry 15.2 said a sweep of both tools for other duplicate function declarations was worth
doing and that `acousticTestHTML` was "unlikely to be the only one". **It is the only one.**

Established the same way as the original finding — script block extracted, evaluated with a
probe as statement one so hoisting was complete, the bound function read back and matched
to its declaration site:

| | Top-level functions | Hoisted vars | Duplicate declarations |
|---|---|---|---|
| WCGRRT REV 164 | 380 | 7 | **1** — `acousticTestHTML`, lines 3552 / 3968, 3968 bound |
| SSORT block 0 | 7 | 2 | 0 |
| SSORT block 1 | 422 | 6 | 0 |

Also checked and clean: no duplicate `var` declarations, no name declared as both a
function and a var, no hoisted function clobbered by a later assignment, and — because
SSORT's two `<script>` blocks share one global scope — no cross-block collision of any
kind, lexical included. That last test was poisoned with a deliberate duplicate first, to
prove it could detect one.

One correction to how our §7.9 reads: only `acousticTestHTML` is shadowed.
`acousticReportHTML` (3652) has **zero call sites** — it is dead because nothing calls it,
not because something outranks it. The renderer at 4210 calls `acousticTestReportHTML`
instead, so that call must be repointed in the same edit or the report renderer throws.

### 17.4 The question for you

You hold every posted file and an index over them. We cannot answer this from our side, and
it decides whether the defect has produced records in the field or only the possibility of
them:

**Does any posted report carry `equipEntries[].soak` keys `acoustic_sheet` or `ac_*` — and
if so, from which rig, which date, and does the file look like it came from SSORT or
WCGRRT?**

Three ways to tell the tools apart in a posted file: `meta.rev` is present only on WCGRRT
posts; `meta.reporttype` values differ; and SSORT posts carry `meta.checks`, `cbmData` or
`pdcData` where a WCGRRT rig-visit post carries `tiles[]` with `equipEntries[]`.

A nil return is a useful answer and we would like that stated rather than assumed — it
would mean no crew has yet selected any of the three tests on either tool, and the loss is
latent.

### 17.5 Not asking you to change anything

No payload key is added, renamed or re-typed by anything in this entry. Transport,
filenames and `meta.asset` untouched. Nothing to build; one question to answer.

### 17.6 Verified

- Blob references counted across the whole of both files and **every hit opened**, not just
  counted: WCGRRT `ACOUSTIC_TEST_B64` / `EHBS_TEST_B64` / `DRAWDOWN_TEST_B64` 3 refs each;
  SSORT the same three, 3 refs each.
- Enclosing functions established by walking back to the nearest top-level declaration, not
  by eye.
- Literal sizes measured: 598,308 / 607,340 / 601,056 chars, identical in both tools.
- Duplicate sweep as described in 17.3, with the negative control.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 18 — the 65 blank-scale tasks: NOV only asks for 29 of them

**SSORT REV 147 · 22 September 2026 · FYI — nothing to build, but it affects `cbmGrades`**

Entry 16.3 told you 65 `CBM_SCHED` tasks carry grade buttons with no criteria on screen,
and said the next step was to get the criteria out of the NOV Maintenance Schedule.
**That step does not exist.** Recorded here because the conclusion changes what your
`cbmGrades` table may receive in future.

### 18.1 The schedule holds no criteria, and it is not missing

The document is **NOV `136151848` Rev. 01, "CBM Maintenance Schedule Compiled",
7 July 2026**. It was in the repository all along as an `.xlsx` outside `CBM DOCS\`, which
is why it read as absent; a copy is now in `CBM DOCS\` under its document number. An older
25 June compile also exists in `SSORT\` and **should not be used** — its section and page
references differ from the July one for the same tasks.

Seven columns: `ITEM ID · SERVICE LEVEL · TASK · FREQUENCY · CONDITION TRIGGERS ·
EVIDENCE REQUIRED · CBM ID SECTION & PAGES`. **Every cell of all 14 sheets, 616 data rows,
scanned for grade text — zero matches.** It is a schedule, not a criteria document: it says
what to inspect, how often, what evidence to keep, and which section of the component
inspection PDF holds the detail.

### 18.2 What it does say, and the discrepancy that follows

Column F marks a task as needing a condition grade: `"PHOTOS & GRADE CONDITION"`, on
**29 tasks. The tool grades 65.**

Six equipment families match NOV exactly (BOP Mandrel, C&K Stabs, Flexloops, Gate Valves,
Upper and Lower SBOP). The rest do not: the three NXT bodies grade **+7** tasks each,
Poslock Door **+5**, U2B Door **+5**, Ram Block **+6** — **36 grade buttons NOV never asked
for.** And one runs the other way: Riser Adapter 1.1 is marked by NOV and carries no grade
on this path, apparently covered on the `CBM_GRADED` path instead, which we are confirming
rather than assuming.

The obvious defence is that NOV marks the section and means it to cascade. The data argues
against it: on C&K Stabs, BOP Mandrel and Gate Valves NOV marks **each** sub-task
individually, and on Poslock Door it marks 7.1.1 and leaves 7.1.2, 7.1.3, 7.1.5, 7.1.6 and
7.1.8 blank **within the same section**. Stated as the stronger reading, not as settled —
NOV's intent is Brad's and Dan's to establish, with NOV if needed.

### 18.3 What this means for you

Dan's decision, taken with Brad, is one of two: drop the 36 grade buttons, or keep them and
source criteria from each section's component inspection document. **If he drops them, your
`cbmGrades` table stops receiving those keys** — no rename, no re-type, nothing breaking,
just fewer graded tasks per CBM report on the NXT bodies, both doors and the ram blocks.
Worth knowing before a trend line goes flat and someone reads it as equipment improving.

Two facts that make the decision cheap, for context: removing a grade button on this path
is structurally safe, because `CBM_SCHED` keys are **id-based**, so dropping one re-points
no history (unlike `CBM_GRADED`, entry 16.3); and of NOV's own 29, only **12** carry a
section-and-page reference at all, so even the legitimate ones need the component document
opened and matched on task wording.

Nothing to build, nothing to change. You will get the key list if and when buttons are
removed.

### 18.5 WITHDRAWN, same day — no buttons are being removed, and the criteria were never missing

**18.3 is retracted.** Dan settled it in one sentence and he was right: *"the grading comes
from the component document end of, so if there's no grading on the spreadsheet and there
is in the document we need to add it."*

Looking where he said to look found what I should have found first. **Every CBM component
inspection document carries, at its section 7, a "GRADE LEVEL EVALUATION GUIDE" — one
universal five-level scale, word-for-word identical across every document checked** (Gate
Valve, Riser Adapter, Shear Ram Blocks, NXT Ram Blocks, Ram BOP Body; the only variation
anywhere was a stray space in "Fair / Acceptable").

So the criteria are **two-layered**, and the tool had a damaged copy of the second layer
and no copy at all of the first:

| Layer | Where | Scope |
|---|---|---|
| The universal guide | §7 of every component document | every inspection item, always |
| Per-item wording | beside each inspection item | that one item |

That dissolves the question in 18.2 and 18.3. The absence of criteria in the *schedule* was
never evidence that a task shouldn't be graded, because the schedule was never the source.
The 65 blank-scale tasks are not missing their criteria — **the universal guide is their
criteria**, and it goes into the tool once. SSORT 148 will add it, plus a prompt for the
four things NOV asks for in the notes on any grade of 2 or worse (type, location, depth,
severity).

**What this means for you: nothing changes.** No key is removed, no key is added, no grade
button disappears, and `cbmGrades` keeps receiving exactly what it receives today. Ignore
18.3. The 29-versus-65 count in 18.2 stands as a fact about which tasks NOV flags for
photographic evidence, but it is not a reason to take a grade away from anyone — and N/A
was always the correct answer for an item the scale does not suit, which NOV states itself.

One correction to entry 16.3 while I am here, for the same reason. I called 81 of 109
partial `grades` arrays a defect. **That overstates it.** A first pass over the component
documents found 521 per-item grade blocks, and while most carry five lines, a genuine
minority carry **two by design** — pressure tests are pass or fail (*"GRADE 1: held …
GRADE 5: failed pressure test"*), so a two-line scale on a test item is correct. My count
also showed three- and four-line blocks which are probably page-break artefacts of a crude
text split, not NOV's design. Nobody should treat a short array as evidence of corruption
or of intent without checking that item against the document.

### 18.4 Verified

- Both `.xlsx` copies opened and compared; the Riser Adapter 1.1 reference reads
  "SECTION 8 - PG 13-32" in the June copy and "SECTION 9 - PG 13-32" in the July one.
- Criteria scan: every cell of every sheet against `G1`–`G5`, `GRADE 1`–`GRADE 5`,
  "Excellent", "Critical:" — **0 hits**.
- The 29-versus-65 comparison is a join on sheet name plus item id between the workbook's
  column F and `CBM_SCHED`'s `grade: true` flags, reported per equipment.
- The §7 guide compared across five component documents by extracting the section and
  diffing the level descriptions: identical apart from one space.
- The two-line-by-design finding comes from the pressure-test items' own blocks, read in
  the Shear Ram Blocks and Gate Valve documents.
- `CBM DOCS\` holds each document twice: the numbered files and the `D9D…-PRO-001` files
  are the same documents (Gate Valve `132970183` carries the PDF title
  `D9D1008449-PRO-001`, with identical per-item block counts). 45 PDFs is about 13
  documents.
- **Nothing was changed in either tool for this entry.** One file was copied into
  `CBM DOCS\`; no tool, payload or routing change.

---

## Entry 16 — your second review, answered; and the CBM question is closed

**WCGRRT REV 164 · SSORT REV 147 · 21 September 2026 (evening) · FYI — nothing to build**

All five additions from your second review are in `SSORT and WCERRT Integration.md`. Four
were straightforwardly right. One needs a correction back, and your CBM question has a
definitive answer from Brad's own files.

### 16.1 The seven "missing" queue items — six of them shipped between 162 and 164

Your point 1 is fair and the omission was mine: §9.1 was never updated as things shipped,
so you planned around promises instead of state. **But six of the seven are in the field.**
Verified in `WCGRRT REV 164\WCE Rig Vist Reporting Tool V0.html` by name and line, and now
recorded as §9.1a:

| Item | State | Evidence |
|---|---|---|
| Post receipt with the replaces line | **shipped** | `sdPostReceipt`, called inside `sdPostReport` so no caller can skip it |
| Unposted-changes mark | **shipped** | `SD_DIRTY` / `SD_POSTED` |
| `counts` block | **shipped** | `sdReportCounts()`, in the payload at line 10514 |
| The three print rules | **shipped** | `.dr-photos` bottom-anchored boxes, `.dr-equip.dr-keep`, `.dr-dump` at its own size |
| `#attachments-block` hidden in report mode | **shipped** | both hide lists, lines 533 and 1409 |
| Stale entry dates, amber + one-click | **shipped** | `sdSyncDateWarnings`, `sdSetEntryDatesToReportDate` |
| **SSORT writing `meta.rev`** | **genuinely owed** | SSORT 147 has `SSORT_REV` for the badge only. Now §9.1 item 7, SSORT 148 |

So `counts` reading as shipped in §5.2 was correct, not an error — and your point 3 is a
good fix anyway: **§5.2 now carries a state column**, shipped or queued, with the revision.
`soakLabels` is marked queued (zero occurrences in 164) and so is `acst_*`, for entry 15's
reason. You should not have to grep our file to know what a post contains.

The rule I have written into the handoff so this does not recur: **an item ships and the
queue is edited in the same change.**

### 16.2 Your CBM question — answered from Brad's 29 posted files. Nothing was graded against corrupted criteria

Dan has put Brad's posted CBM JSON in the repository:
`CBM PDF Reports\CBM .JSN Reports\`, 29 files, West Capella, 13–27 July. Every non-empty
`cbm_*_gr` key in all 29 was extracted and matched against the corrupted tasks.

| Question | Answer |
|---|---|
| Graded against the three inverted Upper/Lower SBOP tasks? | **No.** Those are `cbm_Upper_SBOP_g0_2_gr`, `_g0_9_gr`, `_g0_12_gr`. Absent from every file |
| Graded against the three shifted Gate Valve tasks? | **No.** Those are `cbm_Gate_Valves_g1_5/6/7_gr`. Recorded Gate Valve grades are `g0_0`–`g0_4` and `g1_0`–`g1_2` only. **Your independent finding confirmed** |
| So what is the "1 on task 2.1.1, three times, 27 July"? | `cbm_Upper_SBOP_2_1_1_gr` and `cbm_Lower_SBOP_2_1_1_gr`. **Task 2.1.1 is not in `CBM_GRADED` at all** — it is a `CBM_SCHED` task, a different renderer with a different key shape |

**The safety question is therefore closed**, which is the good news, and it means the
criteria can be repaired carefully rather than urgently.

### 16.3 But the same exercise found something worse than the inverted six

Two things you will want, because one of them changes how you should read our CBM posts.

**There are two CBM key shapes, not one.**

| | `CBM_GRADED` (inspection documents) | `CBM_SCHED` (NOV maintenance schedule) |
|---|---|---|
| Posted key | `cbm_<equip>_g<sectionINDEX>_<taskINDEX>_gr` | `cbm_<equip>_<task-ID>_gr`, plus `_c<n>` per sub-cavity |
| Tasks | 190, of which 109 graded | 290, of which **65 graded** |
| Criteria shown to the crew | partial — only 28 of 109 arrays are complete | **none. Not one of the 65** |

**65 tasks ask for a 1-to-5 condition grade with no scale on the screen at all.**
`cbmCapBlock` renders "Grade Assigned" and the buttons, and `CBM_SCHED` carries no
`grades` arrays whatsoever (zero of 290). That is not corruption — it was built that way —
and it is worse than a partial scale, which at least anchors the ends. Brad's SBOP 1 was
recorded against a blank scale. The reading is not that the grade is wrong; it is that
nobody can say what it means, and neither could the next person to grade it. It is now
the top of the CBM repair list, ahead of the inverted six.

**And `CBM_GRADED`'s keys are positional**, which constrains any repair either side makes.
The key carries array indices, so inserting, removing or reordering a task silently
re-points every historical grade after it to a different task, in every file already
posted, with no error. Upper SBOP has two identical "Dimensional Inspection" sections, and
Gate Valves has four tasks sharing the id `1.3` — they look like extraction duplicates and
**they are staying exactly where they are.** Task ids are not unique within a section
either, so if you ever need to identify a CBM task, use the full key, never the id.

### 16.4 The photograph task, bounded — and your caution was the right one

From the same extraction: **145 grades recorded across the whole West Capella inspection —
1 → 110, 2 → 22, 3 → 5, N/A → 35, and not a single 4 or 5.**

Dan's rule is an exact grade match, so the entire Grade-3 candidate set is five records,
one with no photographs. Of the remaining four, **only one task has a clean complete scale**
— `cbm_Gate_Valves_g0_2`, "Visual inspection of Tail Rod Bonnet", graded 3 independently on
the choke and kill lines, six photographs between them, and Brad's note matches the task's
G3 line almost word for word. The other three were graded against corrupted or absent
criteria and cannot be used as references until the text is repaired.

Which is exactly your caution — a photograph is filed as an example of a grade only after
it is re-read against the **corrected** criteria, not against the number pressed on a
partly shown scale. It is now a hard condition in the task handoff, and it is the concrete
reason the criteria repair goes first rather than a principled one.

### 16.5 Your other three points, accepted as written

- **Sevan Louisiana has no acoustic system either.** In §7.9 — three rigs, and
  `ACOUSTIC_NO_SYSTEM` in 164 still lists only two, so that is a second change in the same
  edit. Recorded that the remaining ten are rig-specific and Saturn has two stacks, so the
  fix is per rig.
- **Reference photographs: display and size rule stated.** New §10.3.1, as a table against
  the evidence rule so the two cannot be confused. Never printed, never posted, out of
  `cbmReportHTML()` and every collect function, **≈480 px long edge** — and explicitly
  *not* the 1600 px / 0.82 evidence standard. You were right that §6.1 is stated strongly
  enough that someone would apply it to the wrong pictures; that is now the first thing
  §10.3.1 says.
- **No deliberate size test.** Dan's decision recorded in §4.2 and in §11, with his
  reasoning: Post already reports a failed response, so the first real failure will be
  reported by the crew that made it. The paragraph no longer asks for a test, and the
  answer if it ever happens stays split the payload — your plan item 25 — never lower
  quality.

### 16.6 Verified

- All grade extractions are from the 29 files in `CBM PDF Reports\CBM .JSN Reports\`, by
  regex over `"cbm_..._gr"` values: 145 non-empty grades, 83 distinct keys.
- The four Grade-3 photo counts were read from the matching `_ph` arrays: Choke Isolation
  Valve 3, Kill Isolation Valve 3, Ram Blocks Blind Shear 6, Spools and Blocks `g0_0` 6,
  Spools and Blocks `g0_2` **0**.
- The six shipped items were confirmed by name and line in REV 164, not from memory.
- `CBM_SCHED` counts by parsing the literal: 290 tasks, 65 with `grade: true`, **0** with a
  `grades` array.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 15 — your two questions, answered; and answering the second one found a live defect

**WCGRRT REV 164 · 21 September 2026 · NEEDS ACTION — one thing to stop, nothing to build**

This answers the two questions in §2 of your `TOOLS-INTEGRATION-REVIEW-NOTES.md`, and
gives the view on §10 your §4 asked for. Thank you for the review — three of your
corrections are now in `SSORT and WCERRT Integration.md` and the document is better for
them.

### 15.1 The 30 MB cap: you are right, I was wrong, and the real number is unknown

My §4.2 said a 20 MB report was "a ~36 MB request against an IIS default cap near 30 MB".
**Both halves were wrong.** The post goes to a Power Automate HTTP trigger, not to IIS —
IIS serves the tools and your dashboard and has nothing to do with the posting path, so an
IIS request limit was never a constraint on a post. And Brad's 21 MB report of 8 September
is a ~38 MB request that arrived intact, which settles it empirically. §4.2 is rewritten.

**What is actually unknown, and why it is not academic.** The 40 MB CBM ceiling implies a
request of about **72 MB** — roughly twice anything proven. Neither of us should assume in
either direction. I would ask for **one deliberate test**: Dan posts a real oversized CBM
report from a real rig name, you confirm it arrived and parses, and we write the number
down. Better a planned test than a rig finding the limit after a hundred photographs of a
crack.

If the limit does turn out to sit below a full CBM, please note in advance that the answer
is **not** lowering the photo quality or the ceiling. That was settled in entry 9 and the
reasoning has not changed. The answer would be splitting the payload, which is a design
change and Dan's to authorise.

### 15.2 Acoustic `acst_*` — **please do not build that renderer yet.** I gave you the wrong keys

You said acoustic was new to your soak renderer and offered to build its third table when
the first file arrives. Checking what that file would actually contain found a defect in a
build that is on thirteen rigs right now.

**WCGRRT is a single `<script>` block and everything is a global.** `acousticTestHTML` is
declared **twice** — my REV 163 native form at line 3552, and a pre-existing clone of the
ROV form at line 3968. Function declarations are hoisted and **the last one wins**, so the
one that runs is the old one. Verified rather than assumed: I extracted the script block,
evaluated it with a probe above every statement so hoisting was complete, and read back
which function was bound. It is the old one. The report renderer calls its partner too, so
both halves of the REV 163 work are orphaned.

**So the keys I told you to expect do not exist in any posted file.** What acoustic
actually writes into `equipEntries[].soak` on REV 164:

| Key | Value |
|---|---|
| `acoustic_sheet` | the selected sheet name, from `RIG_ROV_MAP` — i.e. **a ROV sheet** |
| `ac_<sheet-slug>_r<n>_v` | Pass / Fail |
| `ac_<sheet-slug>_r<n>_t` | actual time, `hh:mm:ss` |
| `ac_<sheet-slug>_r<n>_rk` | remarks |

Note the shape is the `rov_*` shape with a different prefix, because the form is a clone.
**If you build a renderer for these you will be rendering a defect faithfully**, and then
have to rebuild it when REV 165 fixes it. My recommendation: build nothing for acoustic
yet. It is item 0 in our queue, ahead of EHBS and Drawdown. When it ships I will send you
the final key list, lower case, in this file, before it reaches a rig — and `soakLabels`
with it, so the table carries "Close Upper Annular" rather than "Step 3" from its first
post, which is the thing you asked for and it is a good ask.

**One knock-on you may care about.** West Neptune and West Vela have no acoustic system
fitted (Dan, 19 Sep). The REV 163 form says so explicitly; the form that actually runs
offers them a ROV sheet instead. So if an acoustic soak block ever arrives from either
rig before REV 165, it is an artefact of this defect and not a record of a test. Worth a
note on your side rather than a puzzled email later.

**And the lesson, because it is yours as much as mine.** `node --check` cannot see this —
a duplicate function declaration is valid JavaScript, with no error and no warning at
runtime. I reported acoustic as native in REV 163 on the strength of having written the
code, which is the same mistake as entry 13: asserting behaviour from a code trace instead
of opening the thing and looking. Grep for the name before adding a function; open the
form before calling it done.

### 15.3 `Get-Prop` in v2.60 — noted, and we are keeping lower case anyway

Recorded in §5.2 of the integration document, along with *why* we are keeping the
convention: the underlying difference has not gone away. `JavaScriptSerializer` on
Windows PowerShell 5.1 gives you a case-sensitive dictionary and `ConvertFrom-Json` on
PowerShell 7 gives you case-insensitive PSObjects, which is exactly why a sandbox test
passed while production failed. Lower case costs nothing and removes the question. Every
new key we add stays lower case and gets announced here before it ships.

### 15.4 `sacred\index.html` — agreed, delete it

Your recommendation is better than mine and §1.2 now says delete, not refresh, with your
reasoning: a second copy of SSORT at a second address on one host is exactly the trap the
document warns about. §1.2 also now records that SSORT's real route is the SSORT share,
`\\sdrlazneuiis01d.corp.local\SSORT\`, and that `tools\served\` in `Deploy-Dashboard.ps1`
exists but is not the route in use — one route per tool, and neither of us starts using
the other without agreeing it first.

### 15.5 My view on the CBM grade strings, before anyone repairs them

Your §4 asked for this. Full detail is in §10.1 to §10.3 of the integration document;
here is the short version, counted rather than estimated from
`SSORT REV 147\index.html`.

**§10 understated it.** 190 tasks, 109 with grade arrays. **Only 28 of those 109 arrays
are complete.** 46 have three lines, 24 have two, seven have one. G2 has text on 32 tasks
and G4 on 33 — but the buttons always offer 1, 2, 3, 4, 5 and N/A. So on three quarters of
graded tasks a crew can press 4 with no description of 4 anywhere on the screen. That
matters more than the noise: the grades already in your `cbmGrades` table were chosen
against a scale the tool only partly showed.

**Six inverted G1s, not three.** Three on Upper SBOP — and Lower SBOP is assigned by
reference, so they appear on six equipment selections — plus three on Gate Valves where
G1 reads "Fair: minor wear… plan replacement soon". The Gate Valve three look like the
whole scale **shifted up one letter** when the "as-new" line was lost in extraction. A
hypothesis to test against the source PDF, not a finding.

**The repair is off the posting path, which is the reassuring part.** The value the crew
records is a bare `'1'`–`'5'`/`'N/A'` in `cbm_<equip>_g<section>_<task>_gr`; the `grades`
array is display text above the buttons and nothing else. So repairing the strings changes
no key, no value, no payload shape, and nothing your scanner reads.

**But the consequence for your history needs saying.** Because the stored value is a
number and the meaning lived only in the on-screen text, **posted reports cannot be
re-interpreted.** A crew that read *"G1: wear or damage found that requires parts to be
replaced"* and honestly pressed **1** produced a record your dashboard shows as good
condition, for equipment needing parts. Nothing in the file distinguishes it from a
genuinely as-new grade.

So the one thing I would ask of you: **can you tell from `cbmGrades[]` whether any posted
CBM report graded Upper or Lower SBOP tasks 1.3, 4.3, 5.3, or Gate Valves 1.6 to 1.8?**
If Brad's West Capella inspection touched any of them, those grades want re-reading
against his photographs and notes, which he has. That is the only place where this
corruption may already have produced a wrong answer in a live record, and it is answerable
from files that exist. Six lines, and it is the only part of this with a possible safety
reading rather than a quality one — it should not wait behind the other 149 strings.

**Where I disagree with the obvious approach:** do not let anyone write the missing G2 and
G4 lines by interpolating between the G1, G3 and G5 that are present, however plausible it
reads. A grading scale is a calibration standard; inventing its middle is worse than
leaving a gap, because a gap is visible and an invention is not. Anything not in the source
document goes on an uncertain list for Brad.

### 15.6 Verified

- The winning `acousticTestHTML` established by evaluating the real script block
  (lines 2723–10904 of `WCGRRT REV 164\WCE Rig Vist Reporting Tool V0.html`) with a probe
  above every statement, then reading the bound function back. Result: the `RIG_ROV_MAP`
  version, writing `acoustic_sheet`.
- Duplicate first appears in REV 163 (`grep -c "function acousticTestHTML"`: REV 160, 161,
  162 → 1; REV 163, 164 → 2). The defect is mine and it arrived with the REV 163 change.
- `makeEquipEntry` still calls `surfEmbed(ACOUSTIC_TEST_B64, …)` in REV 162, 163 and 164 —
  so the restore path was never converted, for acoustic, EHBS or Drawdown.
- `CBM_GRADED` counts produced by parsing the ten assignments out of
  `SSORT REV 147\index.html` and counting: 190 tasks, 109 grade arrays, array-length
  histogram {1:7, 2:24, 3:46, 4:4, 5:28}, 68 placeholder strings, 19 fragments, 26 task
  descriptions carrying pagination, lines per letter G1 109 / G2 32 / G3 79 / G4 33 /
  G5 96.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 14 — the cause, found: the test forms were behind a gate nobody could open

**WCGRRT REV 161 · 16 September 2026 · NEEDS ACTION — one new payload field**

Dan established how Brad produced the EDS record: **he merged it into the printed PDF
with a PDF tool**, outside both systems. So entry 13.1 stands — the data was never in
the payload and never could have been. But the reason he did it turns out to be ours.

### 14.1 One line explains the whole thing

```js
const showSurface = (eqType === 'Surface BOP Testing') && !manual;
```

Every structured test form in the tool — BOP Function Test, ROV, Acoustic, EHBS,
Drawdown, Soak, **and EDS Testing** — sits behind that single condition. So the dropdown
appeared **only when the equipment type was literally "Surface BOP Testing"**.

EDS is a *subsea* emergency disconnect test. To record one you first had to choose an
equipment type called *Surface*. Brad had four equipment entries on West Capella and
none of them was that, **so the form was never on his screen** — while
`EDS_SHEETS["West Capella"]`, doc **20072896D Rev E**, sat in the file with every
sequence step ready to fill in. He did the work twice: once properly in another tool,
once again merging PDFs, and the estate got nothing either time.

A dropdown nobody can find is the same as a feature that does not exist. Fixed: the
Test Record selector is now on **every** equipment entry, and relabelled — *"Surface BOP
Test Type"* was misleading as well as hidden, since most of the list is not a surface
test.

**What this means for you:** expect `soak` to start arriving populated, on reports from
any rig, without warning. Your entry 11.2 renderer stops being idle. The `ft_*` and
`eds_*` key shapes are exactly as described there.

### 14.2 New payload field: `attachments[]`

Dan's second ask. Until now the only way to get a document into a report was the Vendor
Surveillance tile, so anything produced outside the tool had nowhere to go — hence the
hand-merged PDF that reached no system of record.

A report-level **Evidence & Attachments** section now takes any file:

```json
"attachments": [
  { "name": "EDS-record-merged.pdf", "type": "application/pdf",
    "note": "Merged EDS test record, Blue pod, 14 Sep",
    "bytes": 812345, "data": "data:application/pdf;base64,…" }
]
```

| Field | Rule |
|---|---|
| `name` | the original filename, as chosen |
| `type` | the browser's MIME type, `""` if it gave none |
| `note` | free text the crew typed to say what it is. Often the only description you will get |
| `bytes` | decoded size, computed from the data URL, not reported by the browser |
| `data` | a data URL. **Images are compressed** through the same path as photographs; anything else keeps its full size and warns the crew once above 8 MB |

Top level, beside `photoDump`. Absent on older reports — treat missing as `[]`.

**Two things worth knowing.** Images print inline at the end of the report; a PDF cannot,
so the report prints a table of name / description / size and **the file itself travels
in the payload for you to serve**. A "download attachment" affordance on the report row
would close the loop, and only you can build that. And **`attachments` is deliberately
absent from the browser auto-save**: an attached PDF can be 20 MB against a few MB of
localStorage for the whole origin, so storing it would blow the quota and take the
2-minute crash-recovery net down with it. Only the names are kept there, and a restore
says plainly which files were not recovered rather than coming back quietly without
them.

### 14.3 Verified

Round trip set → collect preserves order, names, notes and both data URLs byte-exact; a
row with no data is dropped rather than posted as an empty attachment; quotes and
`<b>`/`<hr>` in a filename survive intact and do **not** inject into the page; byte
accounting matches `atob` to within 3 bytes, which matters because your ceiling judges
the whole payload; the report section prints images inline and counts non-images; an
empty list renders nothing; and the browser-backup metadata contains no file data at
all. One defect caught by the run and fixed: the non-image line read *"1 non-image
attachment **travel** with this report"*.

---

## Entry 13 — you were right and I was wrong, and it found something worse

**WCGRRT REV 160/161 · 16 September 2026 · NEEDS DECISION (Dan)**

### 13.1 The correction, plainly

My entry 11.2 said the EDS and function test data *"is in every file Brad has posted"*.
**You checked his files. It is not.** `soak` is `{}` on every entry and `surfaceTest` is
empty, so your renderer is correct and idle, and Brad's tests exist only in his PDFs.

Where I went wrong is worth naming, because it is not a typo. **I traced the mechanism
and then asserted a fact about a specific report without opening it.** The trace itself
holds — `ft_*` and `eds_*` inputs really do carry `data-soak`, and `collectSoak` really
does walk them — so "the data is collected" was true of the code path and false of
Brad's reports, because *he never used that path*. `surfaceTest: ""` says so on every
entry. A mechanism that works is not evidence that it ran.

You had the files and read them. I had the files available and reasoned from the source
instead. That is the wrong way round, and it is the second time this fortnight that
checking beat inferring — the first was the phantom readings, which went the other way.

### 13.2 What your check surfaced, which neither of us was looking for

Chasing why `soak` was empty, I found this. Of the seven surface tests, three are not
forms at all:

```js
else if (sel.value === 'Acoustic Function Testing') { wrap.innerHTML = surfEmbed(ACOUSTIC_TEST_B64,'surf-acoustic'); }
else if (sel.value === 'EHBS Testing')              { wrap.innerHTML = surfEmbed(EHBS_TEST_B64,'surf-ehbs'); }
else if (sel.value === 'Surface Drawdown Test')     { wrap.innerHTML = surfEmbed(DRAWDOWN_TEST_B64,'surf-drawdown'); }
```

and `surfEmbed` mounts **an entire separate tool inside an `<iframe>`**:

```js
function _fr(sa){ return '<iframe class="surf-embed '+cls+'" '+sa+' ...></iframe>'; }
... return _fr('srcdoc="'+esc+'"');
```

`collectSoak(entry)` is `entry.querySelectorAll('[data-soak]')`. **A querySelectorAll
cannot cross an iframe boundary.** So for Acoustic Function Testing, EHBS Testing and
Surface Drawdown Test, **everything the crew types is saved nowhere, posted nowhere, and
printed into the PDF** — because iframes do print, at the fixed 1600 px height the code
sets. Evidence in the document, nothing in the data, no error anywhere.

That is the same species as the vendor audit at REV 149 and the compliance checklist at
REV 150, but wider: three whole test types rather than one section, and it has been that
way since the embeds were added.

**It is fixable, and I checked how far.** The primary path is `srcdoc`, which inherits
the parent's origin, so `iframe.contentDocument` is reachable and the fields can be
harvested generically into `soak`. The fallback path, taken only if building the srcdoc
throws, is `src="data:text/html;base64,…"` — an **opaque origin**, where
`contentDocument` is not reachable and the data cannot be recovered at all. So a fix
covers the normal case and must fail loudly, not silently, on the fallback.

**Dan's decision, not mine to take:** it changes what is collected, on a tool thirteen
rigs post from, and it is a bigger change than anything in REV 161 so far.

### 13.3 For Brad, via Dan

His EDS and pod function test records for 8–15 September exist **only in the PDFs he
printed**. They should be kept, not re-typed. And the open question only he can answer:
**how did he produce that EDS record?** He never selected "EDS Testing" on an equipment
entry — that path does collect properly — so he used something else, most likely
attaching or photographing the record. Knowing which tells us whether anything else is
escaping.

### 13.4 Your `soakLabels` recommendation

Agreed and noted: yes, and in the same revision that makes `soak` carry the tests at
all, because one without the other is no use. That is now the same decision as 13.2.

---

## Entry 12 — your 16 September reply: print route diagnosed, and one thing back

**WCGRRT REV 161 · 16 September 2026 · one decision for Dan**

> **SUPERSEDED, 16 September, later.** §12.1 below describes a fix that was wrong: it
> left the photo dump's inline styles in place, so the same PDF had two different photo
> treatments, and it paired a fixed width with a `max-height` cap, which distorts a
> photograph instead of scaling it. Dan saw the output and said it had gone the other
> way. **Read `REPORT-PHOTO-RENDERING-HANDOFF.md` instead** — we have since adopted your
> numbers exactly, and it carries three traps your own CSS is one edit away from hitting.
> §12.2 and §12.3 below still stand.

### 12.1 Thank you for the honest answer on the print CSS

> *"There are **no page-break rules** in the dashboard at all. What Brad is seeing is
> the layout."*

That was more useful than the CSS would have been, because it sent me looking at ours
instead of copying yours — and ours had **two** faults, one of which is not cosmetic.

**Fault one, the page breaks.** `.dr-photos` was in a `page-break-inside: avoid` list
*as the whole grid*. A sixteen-photo block that may not be split throws a fresh page and
leaves most of the previous one blank — Brad's "messy formatting" exactly. The grid is
now `break-inside: auto` and each figure is `avoid`, which is the pairing your layout
achieves by accident. Ours also centred the grid, so a short last row floated in the
middle of the page; it is left-aligned now.

**Fault two, and this one matters.** Our report CSS was:

```css
.dr-photos img { width: 220px; height: 165px; object-fit: cover; }
```

**`object-fit: cover` crops every photograph to 4:3 — on a report whose entire purpose
is evidence.** A pit or a crack near the edge of a frame was being cut out of the PDF,
and nobody could tell, because a cropped photograph still looks like a photograph. Now
`width: 220px; height: auto`. The grid is slightly ragged and the evidence is whole.

Worth checking whether your own viewer crops anywhere — `object-fit: cover` on a
thumbnail is a completely reasonable thing to write, and a thumbnail is where it stops
being reasonable without anyone noticing.

### 12.2 The `ft_*` and EDS labels — you are right, and a static map is the wrong fix

> *"the viewer says 'Blue Panel' and 'Step 3' where the PDF says the real words"*

Agreed that it matters. An EDS verification row reading **"Step 3 — Pass"** is a much
poorer record than **"Close Upper Annular — Pass"**, and this is emergency disconnect
evidence.

You offered two routes. **A label map shipped once is the one I would refuse**, because
`EDS_SHEETS` is per rig, per sequence, per row, and it changes when NOV reissues a
verification sheet. A static copy on your side would be correct on the day it was sent
and quietly wrong afterwards — and wrong labels on the right data is worse than slugs,
because slugs are obviously slugs.

**The right fix is `soakLabels` beside `soak` in the payload**, built at collect time
from the same tables that render the form, so a reissued sheet carries its own new
labels automatically. Text only, negligible beside the photographs.

**It is a payload addition, so it is Dan's call and it is not in REV 161.** Flagged to
him. Until then your slugs are the honest rendering and I would keep them.

### 12.3 Two things you asked for

- **A real REV 161 daily report JSON** and **a real REV 146 pre-deployment JSON** —
  agreed, and Dan has them as soon as either exists. You are right not to trust
  synthetic shapes for the photo object and the row order.
- **`pdcData` at 40 MB, and the viewer rendering it at all** — noted, and the detail
  that a PDC report previously showed *"No content recorded for this entry"* is worth
  recording: that was a whole report type invisible on the dashboard, and neither side
  spotted it until the report type got big enough to argue about.

---

## Entry 11 — Daily reports have been overwriting each other, and three asks

**WCGRRT REV 160, fix pending in 161 · 16 September 2026 · NEEDS ACTION**

Raised by **Brad on West Capella** this morning, reviewing his own posts. Four
observations; three turned out to be the same defect and it is ours.

### 11.1 The defect, and what it means for your history

Our posted filename is built from the field labelled **"Visit Start Date"**:

```js
const date = document.getElementById('meta-date')?.value ...   // Visit Start Date
filename = `seadrill-report_${rig}_${date}_daily-report.json`;
```

So across a two-week visit, **every daily report posts to the same filename and
overwrites the previous one.** An overwrite is not a file creation, which is why it has
been silent — the same reason your precharge flow trigger never fired on a re-issued
sheet at Rev 80.

**The warning about your data:** for any multi-day visit where the crew left the visit
start date alone, **you have only ever held the last daily report of that visit**, filed
under the visit start date. Not a scanner fault and nothing you could have detected —
one filename, one file. Brad's earlier reports survived only because he happened to
change that date field, which he had been apologising for.

**After REV 161 ships, expect the volume of daily reports to rise sharply** — one per
rig per day rather than one per visit. That is the defect ending, not a new problem.

**Fix, decided by Dan:** the filename takes the **report's own date**, so one file per
rig per day, and a corrected re-post of the same day deliberately replaces it — the same
rig + date replacement model you already use for compliance checklists. WCGRRT also
gains a proper **Report Date** field, so "Visit Start Date" keeps its real meaning.

### 11.2 Ask one: please render `equipEntries[].soak`

Brad's EDS and BOP function test sections appear in the PDF and are missing from the
dashboard. **The data is in every file he has posted** — I traced it end to end.
`functionTestHTML` and `edsSeqTableHTML` put every input behind `data-soak`, including
the Pass / Fail / N/A buttons:

```js
function ftPfButtons(key, val) {
  return '<input type="hidden" data-soak="'+key+'" value="'+escAttr(val)+'">' + ...
}
```

and the payload collects them per entry, in **both** the save and post builders:

```js
soak: collectSoak(e)     // every [data-soak] input in the entry
```

Your 9 September reply listed what you render from `equipEntries` — *"`type` /
`manualName`, `notes` (HTML), `photos[]` with `captions[]`, and the `flagCrit` /
`flagEot` tags"*. **`soak` is not on that list**, which fits the symptom exactly: the
report renders, and the tests at the end of it do not.

Key shapes: function test keys are `ft_*` (`ft_date`, `ft_well`, `ft_blue_panel`…); EDS
keys are `eds_seq` plus `eds_<rig>_<seq>_r<n>_v` / `_t` / `_rk` for verified, actual time
and remarks. **`collectSoak` omits empty values**, so an absent key means "not answered"
— the same convention as REV 150's empty statuses, not a zero.

### 11.3 Ask two: show the report date, not the visit start date

You read `meta.date`, which is the visit start. The PDF header uses something better,
and **it is already in the payload**:

```js
// WCGRRT line 3641 — what the PDF header prints
const reportDate = tiles[0].querySelector('.tile-date-input')?.value || today;
```

posted as `tiles[].tileDate` (line 9384, both builders). So **use `tiles[0].tileDate`
as a daily report's date**, falling back to `meta.date`.

Brad suggested the posting date. It answers a real question — *did today's report
arrive?* — but as the record date it drifts: a report written on the 15th and posted on
the 16th after a comms outage would be filed under the wrong day. **Both is the right
answer**: the report date as the record date, the posted timestamp beside it. You
already know the second.

Once 161 ships the filename will carry the report date too, so your rig + date matching
should key on `tileDate` rather than `meta.date` or it will still group a whole visit
together.

### 11.4 Ask three: send us your print stylesheet

Brad found that **your** PDF/print button formats photographs and page breaks better
than our own "Generate Daily Report" route, and he has switched to it. That is a free
improvement sitting in your file rather than a defect in ours. Please send whatever you
do around photo blocks and page breaks — `break-inside: avoid` on the photo figures, at
a guess — and we will port it into the tool's print path so both routes match. He should
keep using yours in the meantime.

---

## Entry 10 — Pre-deployment: the packer attestation is mandatory, and the photographs are counted

**SSORT REV 146 · 15 September 2026 · NEEDS ACTION**

A VP-level requirement via Dan: the pre-deployment checklist must carry a **confirmation
that every ram packer is installed correctly with its orientation checked**, and
**pictorial evidence to back it up** — and neither is optional.

### 10.1 The count is derived from the stack, not typed

A ram sits in a cavity with a door either side. So its packer, the cavity sealing face
and the door sealing face **each exist twice — forward and aft**. A 7-cavity BOP
therefore has 14 doors, 14 sealing faces and 7 packer pairs, and the required photo
count is **2 × cavities in each of three sections**:

| Cavities | Photos per section | Total for that BOP |
|---|---|---|
| 7 | 14 | 42 |
| 6 | 12 | 36 |
| 5 | 10 | 30 |

It is computed from `pdcbop_s{n}_cav`, never written down, so it cannot drift from the
stack the form has built. **You can derive the expected count the same way.**

### 10.2 New keys

Photographs are now **per BOP**, because a Dual stack needs its own evidence:

| Key | Contents |
|---|---|
| `pdcbop_s{n}_ph_rams` | ram packer photographs |
| `pdcbop_s{n}_ph_cavities` | cavity sealing face photographs |
| `pdcbop_s{n}_ph_doors` | door sealing face photographs |
| `pdcbop_s{n}_packers_ok` | `"Yes"` / `"No"` / `""` — the attestation |
| `pdcbop_s{n}_packers_rem` | who confirmed it, free text |

`{n}` is `1`, or `1` and `2` on a Dual BOP. **Every photo caption is pre-filled with the
position it belongs to** — `UBSR — FWD`, `CSR — AFT` — so a caption identifies its
subject without you needing to know the slot order. A crew can overwrite a caption, and
if they do, the photograph is preserved and shown but no longer machine-identifiable.

**The three old shared arrays `pdcbop_ph_rams` / `_ph_cavities` / `_ph_doors` still
exist** and still render, so a checklist begun on the previous form keeps its evidence.
Treat them as legacy — new records will not use them.

### 10.3 Ram serial numbers have moved — this one will bite if you read `_serial`

A ram packer is a pair, and the part number is sometimes one assembly number for both
sides and sometimes one per side. So on a **ram** row:

| Was | Now |
|---|---|
| `pdcbop_s{n}_r{i}_serial` | `_pnf` · `_pna` · `_snf` · `_sna` (Part/Serial, FWD/AFT) |

On a **non-ram** row (UA, RC, LA, WHC) `_serial` is unchanged and `_pn` is added.
Whether a row is a ram is decided by its **selected position**, not its index —
`UBSR CSR LBSR EPR UPR MPR LPR TPR` are rams.

**Migration:** when an older record loads, a ram row's legacy `_serial` seeds
`_snf`, so nothing already recorded is orphaned. If you read `_serial` on ram rows
today, fall back through `_snf` then `_serial`.

### 10.4 What "mandatory" means, and what you can now rely on

- **Posting is blocked** unless, for every BOP: a cavity count is chosen, the packer
  question is answered **Yes**, and all three sections hold their full count. The
  message names the missing positions — *"door sealing face photographs: 13 of 14.
  Missing: MPR — FWD."*
- **Saving is not blocked.** It warns and proceeds. A crew interrupted mid-call with the
  BOP on deck must be able to park their work, and losing an afternoon of photographs to
  a validation rule would be a worse outcome than an incomplete local file.
- **So: any pre-deployment checklist that reaches you is complete.** You do not need a
  "missing evidence" state for posted records. If you ever see one short, that is a
  defect on our side and we want to know.

### 10.5 One thing we need from you

**`pdcData` needs the same 40 MB ceiling as `cbmData`.** A 7-cavity pre-deployment now
carries 42 mandatory photographs by design, plus the EWS, insulation and fibre grids —
roughly **20–22 MB** at quality 0.82. Our `sdSizeOk` already exempts it; without the
same on your side, every single pre-deployment checklist lands in the oversize list.
The regex we use is `/"(cbmData|pdcData)"\s*:\s*\{/` — note the `\{`, so
`"pdcData":null` is correctly *not* exempt.

### 10.6 Verified

Tested by running the new functions in a browser against a synthetic form, twelve
groups, all passing: the 14/12/10 counts derive correctly; labels exclude UA/RC/LA/WHC
and **follow a ram moved to a different position**; a part-filled grid reloads each
photograph into its **own** box rather than shifting them all up (index-based placement
would have silently mislabelled evidence — the bug this design exists to avoid); an
unmatched caption is kept rather than dropped; the legacy serial migrates; an empty
7-cavity yields exactly four blockers; a complete one yields none; one photo short is
caught and named; a Dual BOP names which stack; and **a report with no PDC tile is never
blocked**.

---

## Entry 9 — CBM ceiling mirrored, and we have deliberately used 40 MB not 30

**SSORT REV 146 · 14 September 2026 · NEEDS DECISION — one number to agree**

Mirrored as you asked, keyed on the `cbmData` marker in the payload and never on the
filename. **But the number is 40 MB, and we want you to either match it or tell us we
are wrong.**

### Why not your 30

Your reasoning for 30 was explicit and good: *"the largest real CBM seen so far is
24.3 MB (a ~100-photo report at REV-157-equivalent settings). 30 MB leaves headroom for
a full 100-photo record without ever tripping."*

**That 24.3 MB was measured at photo quality 0.70. SSORT is now 0.82** — the change you
proposed and Dan confirmed, shipped in this same revision. Above 0.8 the JPEG
size/quality curve steepens sharply, so the same hundred photographs are materially
bigger: our estimate is 25–40%, which puts that identical report somewhere around
**30–38 MB**. The ceiling that was designed never to trip on a legitimate CBM report
would start tripping on precisely the report it was built to protect.

**This is our estimate, not a measurement, and it is the weak link in the argument.**
Nobody has yet weighed a 100-photo CBM at 0.82. We would rather be generous and correct
the number downwards from evidence than have the first real one argue with a crew.

### The timing is not academic

Brad is on West Capella now doing thorough reporting — **his CBM will be done in SSORT
from the rig**, and it is the first 0.82 CBM anyone will have seen. **When it lands,
please send us its byte size.** That single number settles whether 40 is right, and we
will move to whatever it says.

### The message changed too, and that mattered more than the number

The old dialog told the user *"Photos are almost always the cause — removing or
retaking the largest ones would help."* In front of someone who has just photographed
every crack on a BOP, that advice is actively wrong. On a CBM report it now reads:

> *"This is a CBM report, so the limit is already generous. DO NOT delete or retake
> photographs to get under it — the evidence is worth more than the warning. Post it and
> tell the office."*

Your *"do not soften a crack photograph to save a warning"* line is the reason that text
exists. It seemed worth putting in front of the person actually holding the iPad, rather
than only in a handoff document.

### Verified

The workspace that normally runs `node --check` is still down, so this was tested by
running the changed function in a browser against five synthetic payloads: 4 MB plain
(silent), 11 MB plain (warns at 10, carries the retake advice), **24 MB CBM (silent —
the whole point)**, 41 MB CBM (warns at 40, carries the DO-NOT-delete text and *not* the
retake advice), and `"cbmData":null` at 11 MB (correctly treated as **not** a CBM
report, so a non-CBM report cannot inherit the generous ceiling). All five passed.
`sdSizeOk` also remains fail-open — any exception returns `true` — so the guard can
never block a post.

---

## Entry 8 — your `yn` assumption is correct, and answering it found a defect in ours

**SSORT REV 145, fix pending in REV 147 · 14 September 2026 · FYI — nothing to build**

### 8.1 The answer to your question: yes, and here is the code

> *"a `yn` item stores `"pass"` / `"fail"` in `values`, the same literals as every
> other pass/fail item."*

**Confirmed, from the shipped file rather than memory.** `dcSetCC` is the only writer:

```js
var nv = hid.value===val ? '' : val; hid.value=nv;     // val is 'pass' or 'fail'
```

and `collectChecks` reads the element value straight through with no mapping:

```js
var v=(el.type==='checkbox')?(el.checked?'1':''):(el.value||''); ... o.values[k]=v;
```

So the domain is exactly **`"pass"`, `"fail"`, or `""`** — empty when a crew taps the
same button twice to clear it. Your rule holds as written, and your ✓/✗ rendering is
safe. Note the third case is a real one on an iPad: `""` means *not answered*, which
your *"a blank value is 'not done', neither"* already handles.

### 8.2 The defect: two inputs, one key, last one wins

Reading that turned up something in **our** REV 145 work. The `yn` branch of
`_checkItemHTMLBase` always emits a comment row that is hidden until ✗ is ticked:

```js
var trig=(type==='ynp')?'pass':'fail';
'<tr class="dc-cmt-row" data-for="'+key+'" data-trigger="'+trig+'" style="display:none;">
   <input ... data-dc="'+key+'_cmt" placeholder="Comment — why marked ✗">'
```

and the string-placeholder feature added for the flush items appends a **second,
always-visible** box — on the same key:

```js
_h+='<tr><td colspan="2"><input ... data-dc="'+key+'_cmt" placeholder="'+_ph+'">'
```

`collectChecks` walks `querySelectorAll('[data-dc]')` in document order and assigns
`o.values[k]=v` each time, so **the last input wins — the always-visible one.**

**What it costs:** tick **✗**, type the reason into the box the form pops up, and it is
**silently overwritten by the empty box below it.** A failed potable-water flush with an
explanation is the single most valuable comment these two items can produce, and it can
be dropped without a trace. The ✓ path is unaffected, so the VP's requirement still
works — it is the failure path that loses data.

**Blast radius, stated precisely so nobody has to take it on trust:** only an item that
passes a *string* 4th spec element gets the second box, only `yn` and `ynp` emit the
conditional row, and a search of the file finds the string form on exactly six items —
the two flush items across the three rig specs. Jon's pump-starts items pass `1`, not a
string, and are type `hrs`, which emits no conditional row: one box, correct. **Nothing
before REV 145 is affected, and you have confirmed no rig has yet submitted a REV 145
round.** It is fixable before it costs a real reading.

### 8.3 The fix, decided by Dan on 14 September

**One box, always visible, taking both.** The same field carries the observation on a ✓
and the reason on a ✗, under the *"what did you see?"* prompt. The conditional row is
suppressed for any item supplying a string placeholder.

**Deliberately chosen so that nothing changes on your side.** One key, one value, and
your rule reads exactly as you built it — `pass <> false AND value <> '' AND
comment = ''` is still a bare tick, a fail with a blank comment is still ordinary
attention. The alternative considered and rejected was a separate `_obs` key, which
would have been more faithful to the data but would have needed a contract change and a
dashboard change before it meant anything, to fix a defect we introduced.

Shipping as **REV 147** on Dan's instruction, so REV 146 stays a single-value change.

### 8.4 One thing back to you

Your digest column and the amber **○ n** badge are keyed on `comment = ''`. Until
REV 147 ships, a round where the crew ticked ✗ and *did* write a reason into the wrong
box will reach you as a fail with an empty comment. That is not a bare tick and your
rule will not label it one — but if you are eyeballing early REV 145 rounds and see a
fail with no reason, this is the likeliest explanation, not a crew who declined to
explain themselves.

---

# Entry 7 — potable-water flush: two new readings on every round
**SSORT REV 145 · 11 September 2026 · NEEDS ACTION**

**I owe you this one.** REV 145 added two items to the daily-check round and I did not
tell you at the time, which was an oversight — you ingest daily checks into Rig
Monitoring with a readings matrix and trends, so two new keys appear on every round
from every rig and you found out from page 6 of the pack rather than from a handoff.

## What was added, and why

Requested by the VP. The concern was specific and worth understanding, because it
shapes how the data should be read:

> *"I want to see if they verify they flush and provide a visual observation to
> clarity, or just tick the box."*

So the point of these two items is not the tick. It is **whether an observation was
recorded at all.**

Two items, identically worded, on **all three daily-check specs** — every rig is
covered:

| Spec | Rigs | Section |
|---|---|---|
| `CAPELLA_CHECKS` | most of the fleet | Diverter Panel / HPU, after Water Flow Meter |
| `AURIGA_CHECKS` | West Auriga | Mixing Skid, after Potable Water Total Flow |
| `DAILY_CHECKS` | West Saturn, Sevan Louisiana | HPU, after Potable Water Reading |

## The new keys

Type `yn` with a comment companion, so the convention is unchanged and no parser
change is needed:

```
<prefix>_<section>__flush_potable_water_supply_line_before_filtration
<prefix>_<section>__flush_potable_water_supply_line_after_filtration
     + the matching _cmt companions
```

Worked example, West Capella:

```
dc_diverter_panel_hpu__flush_potable_water_supply_line_before_filtration
dc_diverter_panel_hpu__flush_potable_water_supply_line_before_filtration_cmt
```

The section slug differs per rig because the item sits in a different section on each
spec — `diverter_panel_hpu`, `mixing_skid`, `hpu`. **Match on the item half, not the
whole key**, if you want them side by side across rigs.

## The one thing that needs a decision your side

The comment prompt is bespoke — *"What did you see? — clarity, colour, any
particulate, how long flushed"* — because a generic "(optional)" invites a blank box.
On the report it prints:

| What the operator did | Prints as |
|---|---|
| Flushed and observed | `✓ — Ran 2 min, clear, no particulate` |
| Flushed, recorded nothing | `✓` |
| Found a problem | `✗ — Cloudy after filter, filter changed` |

**A bare `✓` is the signal the VP asked for.** It means *flushed, nothing observed* —
and on your side that case is currently invisible, because the dashboard styles
attention off **`comment <> ''` alone** (your §4.2). A pass with an empty comment
therefore looks identical to an item nobody was worried about.

**What I would ask:** when the database view adopts our rule
(`status = 'fail' OR comment <> ''`), these two items want the *opposite* treatment —
**a pass with no comment is the thing to surface**, not to hide. It is the only place
in the estate where an empty comment is itself the finding. A small exception, but the
VP will ask for exactly that count: *how many rounds ticked it without looking.*

## Honest limits

- **The comment is not mandatory.** Nothing in the daily-check engine can block a
  round from being submitted, so a bare tick is possible by design — which is the
  point, since it makes "ticked without looking" visible rather than impossible.
- If Dan later wants it *impossible* rather than *visible*, that needs a clarity
  dropdown instead of a tick, plus a small fix so dropdown comments print in the PDF
  (they currently do not). Offered, not built.

## Unchanged

Transport untouched · filenames not load-bearing · `meta.asset` still the rig
identity contract · the key convention and the companion rule are exactly as you
implement them today, so nothing about ingestion changes.

---

# Entry 6 — the nine oversize files, diagnosed individually
**WCGRRT REV 160 · SSORT REV 144 · 9 September 2026 · NEEDS DECISION**

Your addendum asked us to *"apply the REV 157 compressor to whichever tool produces
the vendor files."* Before changing anything we audited **every** file-intake path in
both tools and took apart a real oversize report. The nine files turn out to have
**three different causes**, only two of which are defects. The third needs a decision
from you, because it cannot be fixed by compressing harder.

## Audit result: every photo path was already compressed

All nine `readAsDataURL` sites across both tools were checked. Every **photo** path —
nine photo-slot inputs and the action-photo button in WCGRRT, nine in SSORT — already
runs through `compressDataUrl`. So there was no missing compressor to apply. What the
audit did find was two paths nobody had thought of.

## Cause 1 — document attachments were never compressed (fixed, WCGRRT REV 160)

**This is almost certainly your 74.8 MB vendor audit.**

Two WCGRRT buttons embed a *file*, not a photo, and they wrote it verbatim as a base64
data URL:

- **"Attach Document"** on every Vendor Surveillance row (`refDocFile`) — scanned
  certificates, OEM procedures, test reports
- **"Attach PDF / Image"** on the Planning schedule (`meta-schedule-file`)

Base64 adds a further third on top. One scanned certificate can therefore outweigh an
entire photo dump, and a vendor audit may attach several. Both now route through a
shared `sdReadAttachment(f, cb)`:

- **an attached image is compressed like any photo** — a photographed certificate or
  a screenshot goes from ~6 MB to ~300 KB
- **a PDF or Office file cannot be**, so its embedded size is named at attach time and
  the user decides: warn over 8 MB, never block. Same rule as the post guard.

## Cause 2 — the photo editor silently undid the compressor (fixed, SSORT REV 144)

SSORT's annotation editor re-encoded the edited photo at **JPEG 0.90 with no size
cap**, against an intake setting of 1600 px / 0.70. Every annotated photo therefore
got *heavier* than it arrived.

Measured on the real **West Capella Riser Adapter CBM report** (48 photos, one of the
six you flagged):

| | Whole report, posted |
|---|---|
| As it posts today | **14.2 MB** |
| If every photo were annotated, at the old q0.90 | **17.7 MB** — **+24%** |
| Same, after REV 144 (1600 px / q0.70, matching intake) | **13.5 MB** — −5% |

So annotating a photo no longer changes what it weighs. **The intake settings are
untouched at 1600 px / q0.70**, exactly as you asked.

*Also fixed in passing:* SSORT's compressor drew onto an unpainted canvas, so JPEG —
which has no alpha channel — rendered every transparent pixel **black**. A screenshot
or a PNG with a clear background came back with black patches. WCGRRT has carried the
white-flatten since REV 157; SSORT now does too. Correctness only, no size change.

## Cause 3 — CBM reports are legitimately over 10 MB. This is the decision.

We took the 14.27 MB Riser Adapter CBM report apart:

| | |
|---|---|
| Embedded images | **48**, every one JPEG |
| Already at the 1600 px cap | 34 of 48 (the rest are smaller by nature) |
| Mean size per photo | **228 KB** |
| Share of the whole file that is photographs | **100%** *(14.25 of 14.27 MB)* |

**There is no defect here and nothing to fix.** These photos are already compressed to
REV-157-equivalent settings. A CBM equipment report carries 48 to roughly 100
photographs *by design* — it is a condition record, and the photographs are the
evidence. 48 × 228 KB is 10.9 MB of base64 before a single word of text.

**Which means the 10 MB ceiling is unreachable for CBM without a real trade-off:**

| Option | The 48-photo report becomes | Cost |
|---|---|---|
| Leave it | **14.2 MB** | Every legitimate CBM report trips your warning and ours. Warnings that always fire get ignored — and then the one that matters is ignored too |
| 1600 px / **q0.55** | 11.7 MB (−18%) | *Still over 10 MB.* Buys nothing |
| **1200 px** / q0.70 | **8.8 MB** (−38%) | Under the ceiling. Loses detail — 1200 px is marginal for reading a corroded serial number or a hairline crack |
| 1200 px / q0.60 | 7.3 MB (−49%) | Comfortably under. Visibly softer |
| Split the report | 2 × ~7 MB | No quality loss at all, but the CBM record for one piece of equipment stops being one document |

**Our view, for what it is worth:** don't degrade the photographs. A CBM photo exists
so that somebody two years later can see whether a crack has grown, and 1200 px is
where that starts to get difficult. We would rather you **exempt CBM reports from the
10 MB warning** — they are a known, bounded, deliberate case — than have every rig
trained to click past a warning.

**We have deliberately not changed the CBM photo settings.** That is Dan's call on
engineering-evidence quality, not ours to make quietly in a compressor.

## The nine files, accounted for

| Files | Cause | Status |
|---|---|---|
| `seadrill-report_report_2026-08-25_vendor-audit.json` — 74.8 MB | Uncompressed **document attachments** (cause 1). Also predates the REV 153 rig guard and the REV 157 compressor, hence `report` where the rig should be | **Fixed at source, REV 160** |
| `..._2026-09-03_vendor-surveillance.json` — 29.9 MB | Same | **Fixed at source, REV 160** |
| Six West Capella CBM reports, July, 12.5–24.3 MB | **Not a defect** (cause 3) — 48–100 already-compressed photographs | **Needs your decision** |
| Brad's West Capella daily, 21 MB | Pre-REV-157 photos | **Fixed** — the same report now posts at 4.0 MB |

All nine predate the fixes. Nothing new should join them, other than CBM.

## What we would ask

1. **Exempt CBM from the 10 MB warning**, or tell us the number you can live with and
   we will apply it — but please read the trade-off table first.
2. **The 74.8 MB file is the one worth clearing manually** if it is still costing you
   ten seconds every ten minutes. It is a pre-fix artefact and nothing will replace it.

## Unchanged, verified

- **Transport byte-identical** in both tools — `sdPostReport` and
  `sdWriteToReportFolder` diffed against REV 159 / REV 143, character for character.
- No payload field added, removed or renamed. Nothing for you to parse.
- Photo intake settings unchanged: **1600 px long edge, q0.70 in SSORT, q0.82 in
  WCGRRT** — as you asked.
- Every `<script>` block in both files parses clean; both revisions shipped, byte size
  and tail verified.

---

# Entry 5 — Rig identity enforced at source, and a 10 MB warning before Post
**SSORT REV 143 · WCGRRT REV 159 · 9 September 2026 · FYI — nothing to build**

Both of these come straight out of your v2.40 reply. Neither needs anything from the
dashboard; this entry exists so you know the source behaviour has changed and can
stop compensating for it.

## 1. The Unattributed bucket — fixed at source

> *"the Unattributed bucket still catches the daily checks / daily log / vendor files
> that arrive without it (that fix is still owed on the tool side; nine such files
> were in the last scan)."*

That debt is paid. **SSORT now fails closed on rig identity at every post entry
point.** WCGRRT already did, from REV 153.

A single helper, `sdRequireRig(what)`, is called at the top of all six SSORT paths:

| Post path | What it posts |
|---|---|
| `checksPost` | Daily Checks (12 h round) and weekly FLM |
| `addToLog` | a Daily Log entry |
| `postLessonLearned` | a Lesson Learned |
| `postMonthlyLog` | the whole month's Daily Log |
| `postMonthEntry` | a re-post of one day from the month list |
| `postReport` | the main SSORT report |

If `meta.asset` is empty the post is **refused with the reason named**, the Rig /
Vessel field is focused and scrolled to, and nothing is sent. Nothing is silently
dropped — on the Daily Log path the entry stays in the form, so the user sets the rig
and clicks again.

**Why this was the right shape.** The old failure was quiet: `addToLog` built its
filename as `seadrill-daily-log_report_<date>_<shift>.json` when no rig was set —
the literal string `report` where the rig should be. That file posted successfully,
looked fine to the rig, and then landed in your Unattributed bucket where nobody
looks. A refused post the user can see and fix beats a successful post nobody can
attribute.

**Expect the nine to stop.** Anything already in Unattributed is historic and still
needs whatever manual attribution you were going to do — we have not, and cannot,
retro-fit a rig onto a file that never carried one.

## 2. The 10 MB ceiling — enforced at source as a warning

> *"Over 10 MB the scan warns and the dashboard shows an amber banner, but the report
> is still ingested — it is a warning, not a rejection… please enforce 10 MB at source
> before Post."*

Implemented as **a warning, not a block** — mirroring your own behaviour deliberately,
so the two sides can never disagree about whether a report is acceptable.

`sdSizeOk(json, what)` runs after the rig guard and after the "post this?" confirm,
and before anything is sent. Under 10 MB it is completely silent. Over 10 MB the user
sees the **real number**, the reason (the 10-minute scan cost and the viewer download),
the fact that photos are almost always the cause, and a plain *Post anyway?* — which
they may accept.

Live at:

| Tool | Where |
|---|---|
| WCGRRT REV 159 | `postReport` (rig-visit, planning, TOPSET, vendor) · `postCompliance` |
| SSORT REV 143 | `postReport` · `checksPost` · `dlPostPayload` (covers Daily Log entry, Lesson Learned, monthly log and single-day re-post) |

Measured against real files:

| Report | Size | Behaviour |
|---|---|---|
| Brad's West Capella daily, before REV 157 | 21.0 MB | *"This report is 21.0 MB… Post anyway?"* |
| The same report after REV 157 | 4.0 MB | silent |
| A 24-photo compliance dump plus action photos | ~8 MB | silent |
| 9.99 MB | — | silent |
| 10.04 MB | — | warns, and displays **10.1 MB** (rounded up, so the figure is never below the threshold that triggered it) |

So in practice, with the REV 157 compressor in place, nobody should ever see this
prompt. It is there for the case the compressor cannot save — thirty photos, or a
future report type we have not thought about — rather than as a routine gate. **The
per-photo compressor settings stay exactly where they are**, as you asked.

## Unchanged, verified

- **Transport byte-identical.** `sdPostReport` and `sdWriteToReportFolder` were
  diffed against REV 142 / REV 158 in both tools: identical, character for
  character. Both guards sit *above* the transport and only decide whether to call it.
- No payload field added, removed or renamed by this entry. Nothing for you to parse.
- Filenames unchanged — and still not load-bearing.
- Every `<script>` block in both files parses clean; both revisions shipped and
  verified byte size and tail.

## Nothing needed from you

Unless you would rather we blocked over 10 MB outright — say so and it is a one-word
change in one function per tool. Dan's decision was to warn and allow, on the grounds
that a report is worth having even when it is fat.

---

# Entry 4 — Compliance report: photos on actions, and a photo dump
**WCGRRT REV 158 · 9 September 2026 · NEEDS ACTION**

## What changed and why

Requested by the **West Neptune** subsea team, following on from Entry 2. An action is
much easier to act on when you can see it — *"the visual indicator requires
replacement"* plus the photograph of it.

1. **Every action row now has a 📷 Add button.** One photo per action. It appears
   under its action in the report, and travels with the action in the payload.
2. **The Compliance Checklist report now ends with a photo dump**, before sign-off.
   It has its own grid inside the compliance block — **separate from the daily-report
   photo dump**, so the two reports never share photographs. Up to 24.

**Both paths run through the REV 157 compressor** (1600 px long edge, JPEG 0.82), so
these additions do not undo the size fix in Entry 3. A phone photo lands at roughly
300 KB, not 6 MB.

## New in the payload

**`reportType: "compliance-checklist"`** gains a top-level **`photos`** array, and each
entry in **`actions`** gains a **`photo`** string:

```json
{
  "reportType": "compliance-checklist",
  "actions": [
    {
      "desc": "Cracked sight glass on the HPU tank",
      "system": "Equipment",
      "resp": "Subsea Supervisor",
      "target": "2026-09-21",
      "deadline": "2026-10-11",
      "leftWithRig": false,
      "photo": "data:image/jpeg;base64,..."
    }
  ],
  "photos": [
    { "src": "data:image/jpeg;base64,...", "caption": "Moonpool rig-up" }
  ]
}
```

### Notes on the shape

- **`actions[].photo` is `""` when there is no photo** — always present, never missing.
- **`photos` is always present**, `[]` when empty.
- Both are **base64 data URLs**, `image/jpeg`, typically 200–400 KB each.
- `photos[].caption` may be empty.

## Also new on the rig-visit report

The same photo travels on the **daily report** payload: `actionRows[]` (top level)
gains a `photo` field, on the same terms. The actions table is now **9 columns** —
`# · Action Description · System · Responsible Party · Target Date · Deadline ·
Left w/ Rig · Photo · (remove)`. Anything of yours that reads that table positionally
needs the extra column.

## What we would ask

1. **Show the action photo next to the action** in the open-actions view from Entry 2.
   A thumbnail that opens full size is enough — it is the single thing that makes a
   remote action intelligible.
2. **Keep photos out of list and aggregate views.** Counts in the lists, blobs only on
   the individual record — the existing rule from the data rules, and it matters more
   now there are more photos.
3. **Watch the size.** A compliance report with a full 24-photo dump plus action photos
   could reach 8–10 MB. If you have a practical ceiling, tell us the number and we will
   enforce it at source. Related to the ask in Entry 3.

---

# Entry 3 — West Capella daily report: content present in the file, missing on the dashboard
**WCGRRT REV 157 · 9 September 2026 · NEEDS ACTION**

## What happened

Bradley Waldron submitted the first daily report through the SACRED reporting system
(**West Capella, 7 September 2026**), printed the PDF, and posted it. **The dashboard
shows the personnel names but none of the technical content.**

We have his actual posted file and have examined it. **The content is in the file, and
it is complete:**

| | |
|---|---|
| Equipment entries | **4** — riser pull to surface, HPU Fluid Recovery decommissioning (Synergi MOC 1843049), 14″ Ultralock IIB door overhaul, MRT #9 wire rope replacement |
| Technical narrative | **3,194 characters**, with procedure and part/serial references |
| Photos | **16, all captioned** |
| Compliance checklist | 43 statuses + 10 notes, all populated |

So this is **not** a user error and **not** a capture bug. It is one of two things,
and one number tells us which.

## The number that settles it — please check

**Brad's file is exactly `22,012,925` bytes. It is 21.0 MB, of which 100% is
photographs** — the technical content is 20 KB. Base64-encoded, that is roughly a
**28 MB POST body**, against a transport where the largest previously successful post
was a few hundred KB.

**Please report the byte size of the file that actually landed in SharePoint:**

| Landed size | Conclusion |
|---|---|
| **Smaller than 22,012,925** | Truncated in transit. A transport/size limit problem |
| **Exactly 22,012,925** | The file arrived intact and the dashboard is not rendering `tiles[].equipEntries` |

If it is the second case, the fix is yours: **render `tiles[].equipEntries`** for daily
reports — `type` / `manualName`, `notes` (HTML), `photos[]` with `captions[]`, and the
`flagEot` / `flagCrit` / `flagLesson` flags.

## Fixed at source in REV 157 — photos are now downscaled

Root cause on our side: WCGRRT stored photos at **full camera resolution**. There was
no downscaling on attach at all. SSORT has had `compressDataUrl` for months — which is
why its daily-checks rounds are ~233 KB — and WCGRRT simply never got it.

REV 157 ports the same field-proven function: **1600 px long edge, JPEG 0.82**, never
inflates a file, and falls back to the original on any error so a photo is never lost.

**Measured on Brad's actual 16 photographs, re-encoded:**

| | Before | After |
|---|---|---|
| Photographs | 20.97 MB | **3.99 MB** |
| Whole report | 21.0 MB | **4.0 MB** |
| POST body | ~28 MB | **~5.3 MB** |
| | | **81% smaller** |

Three of his photos were 4032×3024 and one was 5712×4284 — straight off a phone. Those
four alone accounted for 18.7 MB. Small images are left alone; nothing is upscaled.

## What we would ask

1. **Report the landed byte size** (above). That is the whole diagnosis.
2. **If files are being truncated, fail loudly.** A partially-received report that
   renders its `meta` block and silently drops the content is the worst outcome — it
   looks like a working report. Please reject or flag it with the file named, the same
   way the Unattributed bucket works.
3. **Consider a size ceiling with a named reason.** If there is a practical limit,
   tell us the number and we will enforce it at source before the user presses Post.
4. **Confirm you render `equipEntries`** for daily reports.

## What Brad should be told

**His report is fine and nothing is lost.** The PDF he printed is the complete record,
and the file he holds contains everything. Once the landed size is known we will know
whether it needs re-posting from REV 157 — where the same report would be 4 MB.

---

# Entry 2 — Compliance Checklist: Actions Raised During Visit
**WCGRRT REV 156 · 9 September 2026 · NEEDS ACTION**

## What changed and why

Requested by the **West Neptune** subsea team. The *Actions Raised During Visit*
table already lives inside the compliance checklist on screen (`#ckl-actions`), but it
was missing from the generated Compliance Checklist report. It is now included — in
the PDF and in the posted JSON.

It sits directly after the Compliance Summary, before the Maximo AAB totals, because
the actions are the part someone has to *do* something about.

## New in the payload

`reportType: "compliance-checklist"` gains a top-level **`actions`** array:

```json
{
  "reportType": "compliance-checklist",
  "complianceOnly": true,
  "meta": { "asset": "West Neptune", "date": "2026-09-09", "...": "..." },
  "checklist": { "...": "..." },
  "actions": [
    {
      "desc": "Established end-of-well documentation pack",
      "system": "e-Docs",
      "resp": "Subsea Supervisor / S",
      "target": "2026-10-09",
      "deadline": "2026-11-10",
      "leftWithRig": true
    }
  ],
  "appxConfig": "ckl-appa",
  "complianceSummary": [ "..." ]
}
```

### Notes on the shape

- **`actions` is always present.** An empty array means no actions were raised — not
  that the field is missing.
- **`leftWithRig` is a real boolean.** Everything else is a string.
- **`desc` may contain newlines** (it is a free-text box). No HTML.
- `target` and `deadline` are `YYYY-MM-DD` from date pickers, but **may be empty** —
  the form does not force them.
- Field names match what the daily and end-of-trip reports already read from the same
  table, so the source of truth has not moved.

## What we would ask for

1. **An open-actions view across the fleet.** Every action from every compliance
   report, with rig, deadline and responsible party. This is the single most useful
   thing in the payload — actions raised on a rig visit are exactly what gets lost.
2. **Flag actions past their deadline** where the report is the latest for that rig.
   Derive it your side, as with the precharge overdue rollup — don't ask us to
   precompute a date comparison that goes stale.
3. **Surface `leftWithRig: false` separately.** The report now warns when an action is
   not marked as left with the rig, because that means the handover was not confirmed.
   Worth mirroring rather than treating all actions alike.
4. **Dedup:** actions have no id of their own. Treat them as **part of their parent
   compliance report** and replace them wholesale when a newer report for the same
   `rig | date` arrives. Do not try to merge action lists across reports.

## Also worth knowing

Two earlier compliance changes are already live and may not be on your side yet:

- **REV 152** — the equipment register is now **one arrangement only**, chosen per rig:
  `appxConfig` is `ckl-appa` (5th Gen / Mosvold) or `ckl-appb` (6th Gen / Modular),
  with `appxLabel` carrying the readable name. Only the selected register appears in
  the report.
- **REV 150** — the fix for the selector bug that meant **compliance statuses and
  notes were never written to file**. Anything you hold from REV 149 or earlier has
  empty `statuses` and `notes`; that is our old bug, not a rig failing to complete the
  checklist. Please don't report on historic compliance statuses.
  Full detail in `DASHBOARD-COMPLIANCE-CHECKLIST-HANDOFF.md`.

---

# Entry 1 — Marine Integrity retired from Well Control reporting
**WCGRRT REV 155 · 9 September 2026 · NEEDS DECISION**

*(Supersedes `DASHBOARD-MARINE-INTEGRITY-HANDOFF.md`, the original build spec.)*

## What changed

**Marine Integrity has been removed from WCGRRT.** Dan's decision.

- **Marine** is gone from the Discipline dropdown.
- **Marine Integrity Report** is gone from the Add Section dropdown.

**No new Marine Integrity report can be raised.** Your Marine view will simply stop
receiving new records.

## What was deliberately NOT done

The scoring engine — 73 items across Policy / Regulatory / Equipment, the 3.0 target,
the report builder — **is still in the file, dormant.** A conscious choice:

- Any Marine Integrity report **already saved or posted still opens, renders and
  prints exactly as before.** Nothing archived is lost.
- If Marine ask for it back, or take it over themselves, it is two dropdown entries to
  restore rather than a rebuild.

Opening an archived marine report re-inserts the discipline option at runtime,
labelled **"Marine (archived — retired)"**, so the report displays correctly without
offering Marine for new work. Never added when opening a non-marine report — verified.

## What we need you to decide

Historic Marine Integrity records are real assessment data, completed by people,
scored against a 3.0 target. **We are not asking you to delete anything.**

| Option | What it means |
|---|---|
| **Read-only archive** *(our suggestion)* | Keep the tab, label it archived/retired with a date, stop expecting new data. Historic trends stay readable |
| **Hide the tab** | Records stay in the store but come off the navigation. Recoverable |
| **Export and remove** | Final extract for the Marine department, then remove the view |

**Whichever you choose, please do not silently drop the records.** If the tab
disappears with no explanation, someone will assume the data was lost.

## Scanner behaviour we would ask for

1. **Stop treating an absence of marine reports as a fault.** Any "no marine report
   received for rig X" check will now fire forever — retire it.
2. **Keep ingesting if a file does arrive.** Older WCGRRT revisions remain in
   circulation and someone may post from a cached copy for a while.
3. **Don't repurpose the marine identifiers.** `marineData`, `meta.marineData` and the
   marine filename suffix stay reserved, so the same markers still mean the same thing
   if Marine restart.

## Related rule that still stands

**Marine data must never appear in well-control views.** Retiring the reporting does
not change that — if historic marine records stay visible anywhere, they stay in
their own view.

## Question back

**How many Marine Integrity records do you hold, and across how many rigs?** If it is
a handful, an export is trivial. A substantial history argues for the read-only
archive — and Dan should know the number before Marine are told.

---

## Verified for every entry above

| Check | Result |
|---|---|
| `sdPostReport` / `REPORT_POST_URL` | Byte-identical throughout |
| `generateDailyReport` / `generateTripReport` | Byte-identical — nothing you already consume changed |
| `printPlanning` | Byte-identical in REV 155 and 156 |
| Script syntax | `node --check` clean on every revision |
| Actions rendering | Tested with none, and with three actions including one not left with the rig |
| Marine legacy guard | Tested: appears for an archived marine report, never otherwise, no duplicates |

---

*Add new entries at the top, above Entry 2, with the same NEEDS ACTION / NEEDS
DECISION / FYI marker and the revision number.*
