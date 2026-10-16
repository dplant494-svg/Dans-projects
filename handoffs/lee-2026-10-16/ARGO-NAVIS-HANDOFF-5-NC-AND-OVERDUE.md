# Handoff 5 to Argo Navis: NC deferrals at the scope freeze, and overdue work orders

**From:** SACRED, via Dan. **Date:** 16 Oct 2026. **Priority:** P1 for the scope freeze flag (section 1), P2 for the rest. All of it comes after the REV 16 first test post, and none of it is needed for the workshop.

## 1. The most important part: BOP PMs under NC must be done in the window (Dan, 16 Oct)

**Why.** An NC is normally raised when a BOP PM falls due while the BOP is deployed subsea: we don't pull a BOP to do a PM. **The maintenance window between wells is the opportunity to do that work.** A BOP PM under NC that the planner or rig leaves out of the window is critical.

**How to recognise one** (in Maximo's terms):

- **Target Start / Target Finish** are when the PM is due, and what we pull into the window from. An approved NC moves them to the NC deferred date. In `WO.csv` today: `TARGCOMPDATE`; Target Start has been requested from Manpreet.
- **Initial Target Start / Initial Target Finish** are the first dates set, and never move. Also requested from Manpreet.
- **A WO is under NC** when `NC` is filled. When the Initial dates arrive, also when **Target ≠ Initial**: the dates have moved.
  - If the dates moved and `NC` is blank, show **"dates moved, no NC number"** as a data query, not as a pass.

**The rule at the scope freeze (Hold 1).** For every **open** WO under NC on the **BOP set (SFI 331 and 332)** at the plan's rig and BOP:

- **In the plan's scope:** a gold **"NC — do in this window"** marker on the task, with the NC number and its days deferred (current Target Finish minus Initial Target Finish).
- **Not in scope, deferred or descoped in the Scope Challenge:** a **red critical flag**. Show it on the Scope Challenge, on the plan bar and on the freeze. The freeze must not go through silently. The planner gives a **reason** for each one, and the reasons travel with the post. Any WO under NC still out of scope must be **listed in detail**:
  - WONUM, PM / job plan, description;
  - asset and location;
  - NC number;
  - Initial Target Finish, current Target Finish, and days deferred;
  - what the rig intends: the next window, a new NC, or other;
  - who descoped it, and when.
- **Other SFIs** (334 to 339, 302, 315) under NC and not in scope: listed the same way, in **amber**, with a reason, but not critical.

**Post it, so the reviewers and SACRED see it.** Please add `ncDeferrals[]` to the `plan` post (proposed and frozen) and to `plan-progress`, one item per WO under NC in the plan's area. Each item carries:

- `wonum`, `jpnum`, `desc`, `asset`, `location`, `sfi`;
- `nc`;
- `initialTargFinish`, `targFinish`, `daysDeferred`;
- `inScope` (true / false), `critical` (BOP and not in scope);
- `reason`, `by`, `at`.

**SACRED will then:**

- show the critical ones on the plan review page (Help Centre, Plans tab), where reviewers verify the scope;
- put the critical ones in the plan notice email;
- list any still open in the close-out pack.

## 2. Open, overdue and deferred work orders (the general rule)

### What we found in WO.csv (16 Oct, Dan's check)

`WO.csv` now has 16 columns. Manpreet's **`NC`** is the last, and it carries the last approved NC number on the WO's row.

**Dan confirmed: approving an NC pushes the WO's `TARGCOMPDATE` (planned finish) out.** So a deferred WO is usually *not* past its planned finish. **The NC number, not the date, marks a deferral.**

| 3,147 WOs on 16 Oct | Has NC | No NC | Total |
|---|---|---|---|
| **Past `TARGCOMPDATE`** | 123 | **314** | 437 |
| **Not yet due** | 697 | 2,013 | 2,710 |
| **Total** | 820 | 2,327 | 3,147 |

**The 314 "past due, no NC" are almost all already done** (Dan's second check, 16 Oct):

| `STATUS` | WOs |
|---|---|
| COMPWINFO | 180 |
| COMP | 131 |
| COMPWPO | 2 |
| **APPR** (still open) | **1** |

So **`WO.csv` carries completed WOs too.** Only **1** of the 314 is genuinely open and overdue. Across sites: 2309, 1020 and 2318 have 75 each, 2280 has 31, and the rest have 11 or fewer.

**Any date rule must look at open WOs only.** Please tell us which `STATUS` values Argo Navis treats as open today. We assume everything except the COMP family (COMP, COMPWINFO, COMPWPO), CLOSE and CAN.

### The rule (one status per WO task, open WOs only)

**First:** a WO whose `STATUS` is COMP, COMPWINFO, COMPWPO, CLOSE or CAN is **done in Maximo**. It never shows red or amber, and it never counts against B-03. If it is still open on the Argo Navis list, show a quiet **"Done in Maximo"** tag, so the rig can tick it complete (our list still closes our jobs).

| WO | Shows in Argo Navis | Counts against B-03 |
|---|---|---|
| **Has `NC`**, `TARGCOMPDATE` today or later | **Deferred, NC xxxx**, with the extended date | No: approved deferral |
| **Has `NC`**, `TARGCOMPDATE` passed | **Amber: deferral expired, NC xxxx** (the extended date has passed too) | Yes, until re-deferred or done |
| **No `NC`**, `TARGCOMPDATE` passed | **Red: overdue, no approved NC** | **Yes** |
| **No `NC`**, not yet due | Normal | No |

**What follows from it:**

- **B-03** ("all CMs and known deficiencies repaired, WOs closed out, or deferred under an approved NC") becomes a computed line. It can't be ticked while any red or amber WO in the plan's scope is still open in the plan. The tooltip lists them.
- **The NC number comes from `NC` first.** If it is blank, the planner can still type one on the deferral (B7), but a typed NC shows as **"typed, not yet in Maximo"** until the next `WO.csv` carries it.
- **The date shown is `TARGCOMPDATE` as Maximo has it,** so after an NC it is already the extended date. Don't try to reconstruct the original date.
- **Completing the task in Argo Navis still closes it on our list,** whatever Maximo says. Jobs are closed out on the Argo Navis list, not from Maximo's close-out (Dan, 16 Oct).
- **The daily report:** add a count line, "Overdue, no NC: n · Deferral expired: n · Deferred under NC: n", for the plan's scope. The red ones are listed by WONUM.

**Out of scope:** the fleet-wide count. Only 1 open WO is overdue with no NC today, and most WOs are not in any plan. SACRED may show the fleet count on the BOP page later, but that is not Argo Navis's job.

**Please reply with:** the REV the rule lands in, and a screenshot of a plan with one task in each state. Use the test plan.
