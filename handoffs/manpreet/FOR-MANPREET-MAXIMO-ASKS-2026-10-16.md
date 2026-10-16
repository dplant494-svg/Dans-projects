# Maximo data for Argo Navis and SACRED: the list for Manpreet

**From:** Dan Plant · **Date:** 16 Oct 2026 · **About:** the daily extract `\\SEADRILL23339\Well Control Data\WO.csv`.

Thank you for the **NC column**. It works: the last approved NC number shows on the WO's row, and Argo Navis reads it. We also confirmed that approving an NC pushes `TARGCOMPDATE` out, which is what we expected.

**Why the NC data matters so much.** An NC is normally raised when a BOP PM falls due while the BOP is deployed subsea: we don't pull a BOP to do a PM. So the maintenance window between wells is the opportunity to do that work, and **a BOP PM under NC should not be deferred past the window**. Argo Navis flags any the rig tries to leave out at the scope freeze, and it needs the dates in item 3 to show how far each has been deferred.

Below is everything we still need, in priority order.

## The asks

| # | Ask | Why we need it |
|---|---|---|
| 1 | **A question: does `WO.csv` include completed WOs on purpose?** On 16 Oct, 313 of the 314 WOs past `TARGCOMPDATE` with no NC were already completed: COMPWINFO 180, COMP 131, COMPWPO 2. Only 1 was still APPR. If they are there on purpose (for example, recent history), that's fine: we filter them out. If not, leaving them out would make the file smaller and cleaner. Either way, **please tell us which statuses the file carries and why**. | So the tools don't show completed jobs as overdue. |
| 2 | **Corrective WOs (CM, EM and so on) in the same `WO.csv`,** not only PMs. Today every row is `WORKTYPE = PM`. Please add them as extra rows in the same file, for the same sites and SFI locations, not as a second file. | The plan must hold every PM **and CM**, and the pre-deployment check "all CMs and known deficiencies repaired or deferred under an approved NC" needs them. |
| 3 | **Three date columns: Target Start, Initial Target Start and Initial Target Finish** (as on the WO's Dates section). `TARGCOMPDATE` (Target Finish) is already there. Target Start and Target Finish are when the PM is due; we pull work into the maintenance window from them, and an NC moves them to the NC deferred date. **The Initial Target dates are the first ones set, so the two pairs side by side show a deferral even where the NC column is blank.** We don't need actual start or finish: we close jobs out on our own list. | To place each WO in the maintenance window, and to see **how far an NC has deferred it**. A BOP PM under NC must be done in the window, and the scope freeze has to flag any that are not. |
| 4 | **AAB records per rig with their acknowledgement state:** outstanding, partly acknowledged, overdue or closed. This can be its own file. | So the AAB lines on the pre-deployment checklist fill themselves in instead of being answered by hand. |
| 5 | **`PMNUM`** on every WO, one new column. | The same PM keeps the same task when its WO is re-issued. |
| 6 | **Part number, serial number and install date per BOP position** (annulars, connectors, each ram cavity's forward and aft packer), as its own file `assets-by-position.csv`. It also needs **a location-to-position map**, for example `331.BOP1.365` → upper pipe ram. | The pre-deployment stack table, typed by the crew today. |
| 7 | *Lower priority:* **the MOC number on a WO,** if Maximo holds it. | To link a modification's WO to its MOC. |
| 8 | *Lower priority:* **meter readings or cycle counts per BOP function,** if they are kept in Maximo. If not, say so and we'll use PLATO. | Cycle counts on the pre-deployment checklist. |

## Please keep in mind for the extract

- **Keep the column names as they are.** The tools find columns by name, so a renamed column fails silently; it has happened once, when `DESCRIPTION_1` became `ASSET_DESCRIPTION`. Adding columns is always safe.
- **Keep the `WOPRIORITY` and `WORKTYPE` values as they are.** SACRED's AAB and precharge pre-fills use the same WO numbers.
- **Write the file complete, or not at all.** Write to a temporary name and rename it at the end. The scanner skips a file that is still being written.
- **Encoding:** Windows-1252 works today. UTF-8 would be better, but either is fine.

**Items 1 to 3 matter most.** Item 1 is only a question, and items 2 and 3 are extra rows and three extra columns in the file you already produce.
