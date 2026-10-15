# Argo Navis: event-based BWM and CBM PMs, the CBM tick box, and grouping by component (handoff for Lee, 15 Oct)

**From:** Dan Plant and the SACRED dashboard session · **To:** Lee Arnold and the Argo Navis session · **Status:**
NEEDS ACTION, a design conversation first. **To the Argo Navis session:** before building any of this, ask Lee the
questions in section 5 and agree the approach with him. Dan's rules below are fixed; how the tool applies them is
Lee's call.

**Files** (Dan's Maximo exports of 15 Oct, filed as received and as clean CSV):
- `63895118` — the **BWM event PMs**: 2,095 PMs, every rig, all "BWM …", 179 job plans, almost all 12-monthly.
- `65449095` — the **CBM programme event PMs**: 422 PMs; West Tellus 136, West Jupiter 134, West Capella 125, and three
  riser CBM PMs on each of the other rigs. Prefixes BWM, 12M, 24M, 48M, 60M; 37 job plans.

## 1. What is missing today, in Dan's words

When the tool was first built, the plan included the **event-based PMs required at every end of well**. These are the
BWM PMs. At an end of well the TSL onboard **releases** them in Maximo, which generates the work orders; they are
standard and required at every BWM. Rigs on the **CBM** programme have their own event-based CBM PMs, released the same
way. Today the plan is built from WO.csv, which only holds work orders that already exist, so a plan built before the
TSL has released the event PMs is missing the whole BWM set.

## 2. The rules (Dan, fixed)

1. **Every plan gets the BWM event PMs** for that rig, in the SFIs the tool considers (331, 332, 334, 335, 339). The
   other SFIs in the export (651, 703, 408, rig central, blank location) are not plan work.
2. **CBM rigs also get the CBM event PMs** (BWM, 12M, 24M, 48M, 60M "CBM PROGRAM" lines), same SFI rule.
3. **A CBM or not tick box in the pre-information**, next to the milling question, **defaulted per rig**:
   - in CBM today: **West Carina, West Capella, West Jupiter, West Tellus**;
   - all other rigs: standard (not CBM);
   - **CBM is not permitted in the GOM / GOA under BSEE federal regulations**, so a rig operating there cannot be ticked
     CBM (or must be warned hard, Lee to decide which).
4. **Group tasks by component and run them concurrently.** Example: a Poslock door with a BWM, a 3M, a 6M and a 12M
   (or a BWM CBM, a 12M and a 60M) are one piece of work on one door: grouped together in the plan and scheduled in
   parallel, not one after another.

## 3. What the data shows (for the design)

- **The two lists overlap.** 189 PMs appear in both: the "BWM … (CBM PROGRAM)" lines (Jupiter 62, Tellus 60,
  Capella 55). Deduplicate on the PM number.
- **CBM rigs still carry standard BWM PMs.** Outside the CBM programme lines, the BWM list has 108 standard BWM PMs on
  Capella, 108 on Tellus, 84 on Jupiter and 135 on Carina. Whether a CBM rig runs both sets, or the CBM version replaces
  its standard counterpart, is question 5.2.
- **West Carina has no CBM programme PMs in Maximo.** Only the three fleet-wide riser CBM PMs. Dan names Carina as CBM.
  Either the Carina CBM PMs are not built in Maximo yet, or the export missed them. Dan to confirm with Manpreet.
- **The riser CBM PMs are on every rig** (0900-UR0209 BWM riser CBM inspection, UR0210 12M basic NDE, UR0211 12M
  detailed NDE), not only the four CBM rigs.
- **Component grouping has a natural key.** PMs on one component share the asset location, e.g. Tellus
  `331.BOP1.312` carries the BWM Poslock door inspection (0900-UB90124) and the 12M (0900-UB90125); Tellus `331.BOP1.310`
  carries the BWM, 12M and 60M NXT body inspections (UB90121, UB90122, UB90123). 56 locations on Tellus alone carry
  three or more event PMs.
- **Most are 12-monthly in Maximo.** The "BWM" in the description is what marks them as end-of-well work; the frequency
  is a backstop.

## 4. What it means for the plan and for SACRED

- A planned event PM has **no work order number yet** at Post for review. It needs its own task id (for example
  `pm:<PMNUM>`) until the TSL releases it and the WO exists, then the WO joins it (`wo:<WONUM>`), so the review, the
  links and the progress keep one task identity throughout.
- SACRED needs nothing new to receive these: they are tasks in `plan.tasks[]` with a `type` and a `group`. If a group
  key is added to each task (`group: "<asset location or Lee's key>"`), the Plans tab and the project folder will show
  the grouping as built.
- The pre-information answers (milling, CBM) belong in the plan post so the reviewers see them: one additive key each,
  for example `scopeChallenge: { milling: true|false, cbm: true|false, cbmDefault: true|false, region: "GOM" }`.

## 5. Questions for Lee (the Argo Navis session asks these before building)

1. **Source of the event PMs.** Read these two exports as a standing file on the share (`Job Plans\` beside the rules
   files, refreshed by Manpreet's task), or ask Manpreet for a PM extract with the same columns every day like WO.csv?
2. **CBM rig, both sets or one?** On a CBM rig, does the CBM-programme PM replace the standard BWM PM for the same
   component (Poslock door BWM vs Poslock door BWM CBM), or run as well? Is there a mapping job plan to job plan?
3. **The 12M, 24M, 48M and 60M CBM PMs.** Included only when they fall due in or near the window (by Estimated Next Due
   Date), or always at a BWM on a CBM rig?
4. **Released or not.** When the WO already exists in WO.csv for a released PM, the plan must show one task, not two.
   Match on PM number (WO.csv needs `PMNUM`, already on the Maximo data request) or on job plan plus location?
5. **The GOM / GOA rule.** Block the CBM tick for a rig whose region is GOM or GOA, or allow it with a red warning that
   the reviewers see? Which field gives the region (the BWM tracker location, Dan's Rigs table, or a list in the tool)?
6. **Grouping.** Group key = asset location, asset number, or the component (door, body, cavity) across locations? Does
   a group run at the duration of its longest member, or the sum, or a set figure per group? Do grouped tasks keep their
   own % and evidence, with the group showing the slowest?
7. **The Branch Map.** Do the event PMs need Branch Map rows (most of the 179 BWM job plans are probably mapped already;
   the gap report will say), and do the CBM job plans (UB9012x, UC9002x, RG90021 …) already sit in the right branch?
8. **Carina.** Treat as CBM per Dan's list even with no CBM PMs in Maximo, or standard until Maximo has them?

## 6. Dan's asks of others (not Lee)

- **Manpreet:** are the West Carina CBM programme PMs built in Maximo? And can a PM extract (these columns) be added to
  the 24-hour task?
- **Dan:** confirm the CBM rig list is current, and the regions of the four CBM rigs.
