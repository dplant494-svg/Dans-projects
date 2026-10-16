# Handoff 5 to Argo Navis: deferred and overdue work orders, from the NC column

**From:** SACRED, via Dan. **Date:** 16 Oct 2026. **Priority:** P2. This is after the REV 16 first test post, and is not needed for the workshop.

## What we found in WO.csv (16 Oct, Dan's check)

`WO.csv` now has 16 columns. Manpreet's **`NC`** is the last, and it carries the last approved NC number on the WO's row.

**Dan confirmed: approving an NC pushes the WO's `TARGCOMPDATE` (planned finish) out.** So a deferred WO is usually *not* past its planned finish. **The NC number, not the date, marks a deferral.**

| 3,147 WOs on 16 Oct | Has NC | No NC | Total |
|---|---|---|---|
| **Past `TARGCOMPDATE`** | 123 | **314** | 437 |
| **Not yet due** | 697 | 2,013 | 2,710 |
| **Total** | 820 | 2,327 | 3,147 |

## The rule (one status per WO task)

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

**Out of scope:** the fleet-wide 314. Most are not in any plan. SACRED may show the fleet count on the BOP page later, but that is not Argo Navis's job.

**Please reply with:** the REV the rule lands in, and a screenshot of a plan with one task in each state. Use the test plan.
