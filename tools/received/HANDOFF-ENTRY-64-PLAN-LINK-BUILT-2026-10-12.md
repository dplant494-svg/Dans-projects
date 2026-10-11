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

