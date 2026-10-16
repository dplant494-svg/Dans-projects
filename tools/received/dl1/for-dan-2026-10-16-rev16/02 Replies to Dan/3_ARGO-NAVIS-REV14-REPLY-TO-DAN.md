# Argo Navis REV 14: posting, the review holds and the BOP ready date. Reply to your evening note of 14 October

**From:** Lee Arnold and the Argo Navis session · **To:** Dan Plant and the SACRED dashboard session ·
**Re:** `ARGO-NAVIS-REPLY-FOR-LEE-2026-10-14-EVENING.md` · **Package:** `Argo-Navis_REV14_2026-10-14.zip`

Thank you for deploying REV 13 so quickly, and for the 36 Branch Map decisions. REV 14 is built and tested: everything
your note asked for, plus posting itself. It replaces REV 13 at `/sacred/dl1/` once you're ready.

## 1. The one thing we need from you: `argo-config.json`

The intake address is **not** in the REV 14 file. Lee did not want it in his OneDrive, the project or the deploy
package, so Argo Navis reads it at run time from a small file **beside `index.html` on your server**:

```json
{ "intakeUrl": "<the intake address, exactly as in the post contract>", "dryRun": true }
```

- The file is yours, and it stays on the server only. Argo Navis keeps the address in memory: never in browser
  storage, the saved plan or the page, and never on screen.
- **`"dryRun": true`** makes every post a test post, filed under `dl1.tests`. Please keep it until the loop is
  proven. After that:
  - **Remove it:** "Test post" stays ticked by default, and a planner can untick it.
  - **Add `"defaultLive": true`:** posts start live.
- **Without the file**, every post button saves the exact file it would have posted, so nothing is lost.
- **A relative path also works** for `intakeUrl` (e.g. `/sacred/intake`), if you would rather put a same-origin relay
  in front of the flow.

## 2. Your four asks, all in REV 14

**1. Designation `meta`.** Added exactly as asked, with the top-level keys unchanged:

```
meta: { reporttype:"BOP Designation", planid, asset, bopNo, rigkey }
```

- **When it posts:** with the first plan post once the stack's cavities (C-01) are set, otherwise with the next plan
  or progress post.
- **Pre-deployment checklist export:** its `meta` gains `asset`, `rigkey` and `bopNo`, additive.

**2. Status strip.** When `data/index.json` answers, Steps 1 to 3 show one strip instead of the three connect rows:

| Colour | Shows |
|---|---|
| Green: **Maximo data loaded** | WO.csv date, rules index date, CoC register date, one Reload |
| Amber | The stale-feed rule: "feed is n days old, check with Dan before you freeze a scope on this feed" |
| Red: **Maximo data not loaded** | Names what is missing |

- "Connect folders manually" shows the old rows again.
- On `file://` nothing changes.
- Tested over http on a staged `/sacred/dl1/`. With the 25 Sep feed the strip is amber, as it should be.

**3. Review stages.** The plan bar, under the step tabs on every page, holds five buttons in your order:

1. **Post for review.**
   - Posts `plan` (`status:"proposed"`, scope version n+1).
   - Enabled once the Scope Challenge is answered and the schedule is built, and only when the scope is new or changed.
   - An edit shows "changed since v n" and re-enables it.
2. **Freeze scope. Hold 1:** disabled until `plans-open.json` shows this plan **and this scope version** as
   `verified`.
   - **Override:** "Freeze without full verification…" asks for a name and a reason and posts
     `frozenOverride:{by, reason, at}`. The bar shows it in red.
   - **After freezing, the scope is locked.** Execute, defer, durations, groups, SSCE and Add Task are all refused, with
     "add it as a break-in". Break-ins and actuals stay open.
3. **Post progress. Hold 2:** disabled until frozen.
   - One press posts `plan-progress`, a full snapshot (`progress{planId, scopeVersion, asOf, shift, snapshot:true,
     pctComplete, bopReadyDate, needDate, tasks[], pdcItemsTicked[], breakins[]}`), plus the `planning-report`.
   - That is two files, as the contract says.
4. **Post close-out.**
   - Enabled once every executed task is complete and every deferred WO has a reason.
   - Posts `plan-closeout` with `closeout{…, edocsRef, finalPct, finalVariance, deferredCarriedForward[]}` and
     `planningData.projectComplete:true`.
5. **Export** keeps the downloads as they were: copy, Scope Freeze Document, SSORT keys, designation.

- **Read-back:** the bar reads `plans-open.json` and `plans-status/<planId>.json` and shows:
  - the state (awaiting, changes requested, verified, frozen, closed);
  - "n of m verified";
  - who is outstanding;
  - what SACRED holds (linked reports, checklists, the call).
- **When it re-reads:** on opening, on Reload, 15 s after each post, and on **Refresh review**.

**4. BOP ready date.**

- **Where it shows:**
  - a large banner at the top of the schedule (Step 4), Execute and Pre-deployment;
  - a compact chip in the plan bar, so it is on every page.
- **What it shows:** the ready date, the **need date** (editable in place) and the float.
- **Colours:** green when inside the need date, amber within 2 days, red when past, with "n days of rig downtime".
- **Updates:** it recalculates on every Generate Schedule and Calculate Project, and shows "moved ±n days since v n was
  posted".
- **Simulate:**
  - A planner can defer tasks, slide durations and mark work done, before or after the freeze, and watch the date move.
  - A striped "SIMULATION, nothing is posted" ribbon shows throughout. Every post, sync and download is refused.
  - **Reset to the real plan** puts the plan back exactly as it was; the test checks that byte for byte.
- **In the posts:** `planningData.bopReadyDate` (ISO with offset) and `planningData.needDate`, on every planning report,
  plan, progress and close-out post. `plan.bopReadyDate` and `plan.needDate` are there too.

## 3. Choices we made where the notes left room. Please say if any is wrong.

1. **Freeze keeps the verified version number.**
   - The contract says scope version +1 on every `plan` post, but Hold 1 is "this plan and scope version verified".
   - So the frozen post carries the **same** `scopeVersion` as the version the reviewers verified, with
     `status:"frozen"`.
   - A scope change after the freeze is not possible in the tool; it goes as a break-in.
2. **Review field names: both are read.**
   - `plans-open.json` uses `verified`/`required` and `plans-status` uses `verifiedCount`/`requiredCount`. Argo Navis
     reads either.
   - `verified` may be a number or a list of names.
3. **"Changes requested" comments.**
   - Argo Navis shows `review.comments` (a string, or `[{by, text}]`) beside Post for review.
   - **Could the scanner add that field to `review`?** Today `plans-open` carries the state but not the reviewer's
     words.
4. **`testingPct` is live:** `planningData.testingPct`, 0 to 100, the same figure as the tool's own 90 % banner. Please
   read it in place of your own computation.
5. **`edocsRef`** sits in `closeout.edocsRef`: free text, the eDOCS document number. It can be blank if not yet filed.
6. **Deferral reasons.**
   - Unticking a WO asks for a reason from the contract's list. Plans on your Excluded sheet get "Excluded on Branch
     Map" automatically.
   - `deferred[]` carries `reason`, `reasonText`, `nc` and `ncRef`.
7. **The checklist posts.** Pre-deployment has a **Post checklist** button through the same intake, as SSORT 165 does,
   with `complete` true or false. Photos stay inline, as you said.
8. **A failed post.** The HTTP status and the first 2 KB of the reply are shown and kept in the post log, and the file is
   saved locally. Those are the two things you asked for if the first live post fails.

## 4. What is in the pack

| Where | What |
|---|---|
| `For Dan\01 Deploy package\Argo-Navis_REV14_2026-10-14.zip` | `index.html`, the tool, `DEPLOY-README.txt` (the argo-config note is in it). HTML SHA-256 `1f0d6a2c…25792`. |
| `For Dan\04 JSON samples\REV 14 posts (test posts, West Vela BOP1)\` | The seven files REV 14 posts, in order: plan v1 proposed, designation, plan v1 frozen, plan-progress, planning-report, pre-deployment, plan-closeout. All `dryRun:true`, made from the golden test data with a dummy intake. |
| `For Dan\06 Screenshots\ArgoNavis_REV14_*.png` | Status strip, plan bar with read-back, BOP ready banner, simulate, deferral reason. |

**Tests:**

- The full suite passes on REV 14. The engine is unchanged against REV 13 and REV 9. The payload adds only
  `bopReadyDate`, `needDate` and `testingPct`.
- The http server test sends a real `fetch` POST to a local stand-in intake: 202, the contract's wrapper, the plan
  decoded.

**Suggested first live step:** deploy REV 14 with `argo-config.json` (`dryRun:true`). Lee posts West Vela BOP1 for review,
and we check it reaches the Plans tab before a rig uses it.
