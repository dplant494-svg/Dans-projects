# SACRED → DL-1 rolling handoff replies

**From:** Dan Plant and the SACRED dashboard session · **To:** Lee Arnold and the DL-1 (BOP Schedule Builder) session
**Pattern:** one entry per reply, numbered against `DL1-ROLLING-HANDOFF.md`. Nothing the scanner reads changes without an entry.

---

## Entry 1 reply (dashboard side, 12 Oct 2026): the five answers, the samples we still need, and what the scanner will build

Thank you: this is the most complete first reply any tool has sent us, and the three faults in 1.3 are the kind of thing
only the builder finds. Answers to 1.6 first, then the rest of `DL1-REPLY-TO-SACRED.md` in its order, then what we build.

### 1.6 answered

1. **`scheduleBuilderState`: the scanner has never read it.** Not one line of `Update-Dashboard.ps1` or the dashboard
   mentions it; the planning panel reads `tiles[0].planningData` and `meta` only. So **move it to the `plan` post**, as the
   restore point for two-way review, and drop it from `planning-report`. That is within the additive rule: the rule
   protects fields the scanner reads, and this one it never did. One ask: on the `plan` post put it **last** in the object
   and keep it under the key `scheduleBuilderState`, so the scanner can skip it cheaply and the Fabric export never
   carries it.
2. **The `rigkey` list, as the scanner holds it today** (`$AabRigCodes`, the same table the Help Centre, the AABs and the
   notification workbook use):

   | rigkey | meta.asset | your SITEID |
   |---|---|---|
   | `nov` | West Neptune | 2317 |
   | `auriga` | West Auriga | 2302 |
   | `saturn` | West Saturn | 2321 |
   | `jupiter` | West Jupiter | 2318 |
   | `tellus` | West Tellus | 2309 |
   | `carina` | West Carina | 2326 |
   | `polaris` | West Polaris | 2270 |
   | `vela` | West Vela | 2303 |
   | `gemini` | West Gemini | 2290 |
   | `capella` | West Capella | 2280 |
   | `libongos` | Sonangol Libongos | 1010 |
   | `quenguela` | Sonangol Quenguela | 1020 |
   | `cam` | Sevan Louisiana | 2330 |
   | `ssce` | SSCE Equipment | (none: the test asset) |

   `meta.asset` is the identity everywhere; `rigkey` is the short form the flows look up. Send both, spelled exactly as
   above. **West Elara (2090), West Phoenix (2070), West Aquarius, West Eclipse are not on the list.** Adding a rig is one
   row in this table, one row on the notification workbook's Rigs sheet, and the BOP dashboard roster: **Dan's decision**,
   and the same decision SSORT 161 raised for West Phoenix on the assistance request this week. Until then a post with an
   unknown `rigkey` is filed under its `meta.asset` name and reaches the office but not a rig's four. Use your three-letter
   codes inside `planId` as you propose (`WVE-BOP1-20261005`); the scanner keys on `meta.rigkey`, not on the planId prefix.
3. **Test mode: yes for the scanner, and the flows will be built the same way.** `SSCE Equipment` is a non-rig bucket on
   every dashboard (never on a fleet grid, never counted). `dryRun: true` is read today on help requests only; **for the
   five DL-1 kinds the scanner will treat `dryRun` and `SSCE Equipment` as test**: shown under SSCE Equipment on the
   dashboard, never overwriting a rig's panel, never exported to the Fabric plan tables. The planning notification flow,
   when built, carries the same Guard as the three help flows: office only, `[TEST MODE]` subject. Your samples with
   `dryRun: true` and `meta.sample: true` are therefore safe to post once the scanner reads the kinds; not before.
4. **`next[]` rule: agreed, in progress plus the next 24 h.** Send `target` as the planned start in ISO 8601 with offset;
   the panel today prints `target` as text, so the scanner will format it (`06 Oct 08:00`) for display and keep the ISO
   value for Fabric. `taskId` beside `id` on both `done[]` and `next[]`: yes please.
5. **`PMNUM`: not from us yet.** SACRED has no Maximo work-order extract today. Item 45 (`maximo-reference.json`) is
   planned against an **asset and location** extract (Manpreet's `v3.xlsx` behind the CoC tracker: 18 sites, 3,968 WCE
   components, SFI locations, serials, models; no WOs, no PMs) and is not built. So `WO.csv` is the work-order source for
   the fleet and we will read **your** feed rather than invent a second one. **The ask goes to Manpreet, from Dan:** add
   `PMNUM` to `WO.csv`. Your asset tree, `TS - Well Control Assets and Locations.xlsx`, is almost certainly the same tree
   Manpreet's tracker extract comes from; Dan will ask him to confirm, and if so item 45 reads that file and the two tools
   agree by construction.

### The rest, in your order

- **Q1, home for the tool:** yes to the IIS server beside the rig tools, served over http. `Deploy-Dashboard.ps1`
  publishes folders; a `dl1\` folder is a one-line addition once Lee sends a release. The server move (18 Oct) does not
  change the path the rigs use.
- **Q3, the three faults:** noted and welcome. The panel's Variance and Reporting Day stats will light up the first time
  REV 11 posts `planningData.planVariance` and `planningData.reportingDay`; no scanner change, those keys were always
  read. `projectComplete` explicit on every post is the WCGRRT 147 rule and the scanner already keys it by rig|BOP.
- **Q4 and Q5, PDC:** agreed: one checklist item per `pdcData` key, ticked by job plans, posted progressively with
  `complete`. New keys announced here before they ship. SSORT keeps its copy; the dashboard's PDC panel reads whichever
  posted last per rig|BOP and shows which tool it came from (`meta.tool`).
- **Q6, the kinds and the size:** agreed on all five including `plan-evidence`, and on the additive task fields and
  `plan.totals`. Thank you for the 578 KB finding: 118 KB is right, counts plus direct lessons. Our ceiling for one post
  is about 2 MB on the intake, but the scanner reads every file every ten minutes, so small is better.
- **Q7 and Q8, identity:** `planId` and `scopeVersion` as proposed; `taskId = wo:<WONUM>` for maintenance, skeleton keys
  for fixed tasks, `ms:<slug>` for milestones. These are the Fabric keys; nothing else is needed.
- **Q9, the 12-hour post:** full snapshot, agreed; the "and generate the planning report" option on Post progress is
  the right shape, two files from one press.
- **Q10, AAR:** the computed set is what the office wants; Lee confirms the typed fields. The scanner will read
  `closeout.aar` whole and the Fabric `plan_aar` table carries the typed fields plus the computed ones as columns.
- **Q11, Synergi:** agreed: `synergi_lessons.json` straight into Fabric as its own table from your share, and
  `plan_synergi` holds only `planId`, `ref`, `taskId`. One writer. Dan: that needs the `\\SEADRILL23339\Well Control
  Data` share reachable from the scanner machine, or a synced copy; say which.
- **Q12, deferrals:** the fixed list is exactly what the office asked for. `dueDate` and `deferredBy` on each: yes.
- **Q13, posting:** matches the contract line by line. Prove over Starlink on `SSCE Equipment` with `dryRun: true`.
- **Q14, two-way review:** cheap for you and cheap for us: the scanner's share copy of every posted file already exists
  (`\\sdrlazneuiis01d.corp.local\sacred\dashboard\reports`); a `status: reviewed` post would simply be the next
  `scopeVersion`. Phase 2, not now; the `plan` post carrying `scheduleBuilderState` makes it possible later.
- **Q15, cadence:** your recommendation stands as the proposal to Dan and Lee: immediate email for scope for review,
  frozen, PDC complete and close-out; one daily digest per rig under maintenance for the 12-hour posts; the Teams chat
  carries every post. Audience: the Office and Rigs sheets plus a new **Planning** table in the notification workbook.
- **Q19:** Lee's call. Note that every posted file is kept whole in PostedReports (internal, Seadrill sign-in) and the
  Fabric tables can leave `thirdParty` costs and `nptLog` free text out if Lee says so.
- **Q20:** the table above; take ours. Your SITEID-to-rig table goes into the repo as the one mapping (item 45 needs it).
- **Q21, evidence:** JPEG 0.82, 1,600 px, PDFs, in `plan-evidence` only: the same rules as every tool.
- **Q22, AABs and `aab-data.js`:** correct that DL-1 posts no AAB records. **Yes, the Reference Hub may read
  `aab-data.js`** from the server (`/sacred/aab/aab-data.js`); it is plain JSON, rewritten every scan, internal network
  only, and it carries acknowledgers' names and comments, so it stays inside Seadrill. Read it, never write it, and read
  `aabStatus[]` for state (outstanding, partly acknowledged, acknowledged, closed, withdrawn, overdue).
- **Q23, time zones:** ISO 8601 with offset everywhere, **rig local time**, agreed. The scanner stores the ISO string and
  the offset and computes UTC when it needs it.
- **Q24.5, rig plus BOP:** the planning panel today keeps one planning report per rig (newest wins) and keys only
  `projectComplete` by rig|BOP. **For DL-1 the scanner keys every one of the five kinds by `planId`**, so BOP1 and BOP2
  plans run side by side, and the panel will show the newest report per rig|BOP (a scanner change, with the kinds).
- **Q24.6, `maximo-reference.json`:** does not exist yet (5 above). Your `WO.csv` columns and the asset tree are the
  input to it, not the other way round.
- **1.8, the posting URL:** it lives in `POSTCONTRACTFORDASHBOARDBUTTONS.md` in the SACRED repository and in every
  shipped tool, by design; rotating it means a new URL in every rig tool, so **no rotation**. Keep it exactly as you say:
  embedded at build time, never in a project file, a share or a chat.

### The samples

The `sample-files/` folder did not reach us: only the two `.md` files arrived. **Dan: please upload the three
`SAMPLE_20261011-1130_West-Vela_DL1_*.json` files** (pretty-printed is fine). The scanner is built against them.

### What SACRED builds, in order, once the samples are here

1. Scanner: read the five kinds by `meta.kind`, key by `planId` + `scopeVersion` (+ `asOf` for progress), test rules as in
   3 above, `scheduleBuilderState` skipped, `target` formatted, the newest `planning-report` per rig|BOP on the panel.
2. Fabric: `plans`, `plan_tasks`, `plan_deferrals`, `plan_progress`, `plan_evidence`, `plan_synergi`, `pdc_items`,
   `plan_aar`, plus `synergi_lessons` from your share.
3. The planning notification flow on the TSC Help pattern, with the Planning table and the cadence in Q15.
4. End-to-end on `SSCE Equipment`, `dryRun: true`, from REV 11; then the one-rig pilot with WCGRRT's report in parallel.

Nothing in this reply changes a shape you have proposed; the only decisions outstanding are Dan's (the four extra rigs,
the cadence, the Synergi share path, Manpreet's `PMNUM`) and Lee's (AAR typed fields, Q19).
