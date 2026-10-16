# Maximo data for Argo Navis and SACRED: the list for Manpreet

**From:** Dan Plant · **Date:** 16 Oct 2026 · **About:** the daily extract `\\SEADRILL23339\Well Control Data\WO.csv` and a few one-off exports.

Thank you for the **NC column**. It works: the last approved NC number shows on the WO's row, and Argo Navis reads it. We also confirmed that approving an NC pushes `TARGCOMPDATE` out, which is what we expected.

Below is everything we still need, in priority order. The Maximo field names are our best guess, so please use whatever Seadrill's Maximo actually calls them.

## The asks

| # | Ask | Why we need it | Likely Maximo source |
|---|---|---|---|
| 1 | **A question: does `WO.csv` include completed WOs on purpose?** On 16 Oct, 313 of the 314 WOs past `TARGCOMPDATE` with no NC were already completed: COMPWINFO 180, COMP 131, COMPWPO 2. Only 1 was still APPR. If they are there on purpose (for example, recent history), that's fine: we filter them out. If not, leaving them out would make the file smaller and cleaner. Either way, **please tell us which statuses the file carries and why**. | So the tools don't show completed jobs as overdue. | `WORKORDER.STATUS` |
| 2 | **Corrective WOs (CM, EM and so on) in the same `WO.csv`,** not only PMs. Today every row is `WORKTYPE = PM`. Please add them as extra rows in the same file, for the same sites and SFI locations, not as a second file. | The plan must hold every PM **and CM**, and the pre-deployment check "all CMs and known deficiencies repaired or deferred under an approved NC" needs them. | `WORKORDER` with `WORKTYPE` in (CM, EM…) |
| 3 | **Planned start date,** one new column. `TARGCOMPDATE` already gives the planned finish. **We don't need actual start or finish:** we close jobs out on our own list, not from Maximo. Please say which pair Seadrill plans with: target dates or scheduled dates. | To place each WO in the schedule against its planned window. | `TARGSTARTDATE` (with `TARGCOMPDATE`), or `SCHEDSTART` / `SCHEDFINISH` |
| 4 | **AAB records per rig with their acknowledgement state:** outstanding, partly acknowledged, overdue or closed. This can be its own file. | So the AAB lines on the pre-deployment checklist fill themselves in instead of being answered by hand. | Wherever Maximo holds the AAB actions per site or asset |
| 5 | **`PMNUM`** on every WO, one new column. | The same PM keeps the same task when its WO is re-issued. | `WORKORDER.PMNUM` |
| 6 | **Two missing job plan detail exports, 0900-UR0007 and 0900-UR90021,** plus **the full list of electrical job plans** used on WCE and MPD equipment. The current electrical list has only 23 plans; 0900-EE90061, for example, has 13 APPR WOs on 6 rigs and is missing from it. | Argo Navis needs the steps and durations for every job plan in a plan. | Job plan export, as before |
| 7 | **Part number, serial number and install date per BOP position** (annulars, connectors, each ram cavity's forward and aft packer), as its own file `assets-by-position.csv`. It also needs **a location-to-position map**, for example `331.BOP1.365` → upper pipe ram. | The pre-deployment stack table, typed by the crew today. | `ASSET` (`ITEMNUM`, `SERIALNUM`, `INSTALLDATE`) under the stack's `LOCATION` |
| 8 | **Job plan revision and per-site variants,** as its own file `jobplans.csv`. | To link a checklist to the revision it was done under. | `JOBPLAN.PLUSCREVNUM`, `JOBPLAN.SITEID` |
| 9 | *Lower priority:* **the MOC number on a WO,** if Maximo holds it. | To link a modification's WO to its MOC. | A WO attribute or worklog, or the WO number on the Synergi case |
| 10 | *Lower priority:* **meter readings or cycle counts per BOP function,** if they are kept in Maximo. If not, say so and we'll use PLATO. | Cycle counts on the pre-deployment checklist. | Maximo meters |

## Please keep in mind for the extract

- **Keep the column names as they are.** The tools find columns by name, so a renamed column fails silently; it has happened once, when `DESCRIPTION_1` became `ASSET_DESCRIPTION`. Adding columns is always safe.
- **Keep the `WOPRIORITY` and `WORKTYPE` values as they are.** SACRED's AAB and precharge pre-fills use the same WO numbers.
- **Write the file complete, or not at all.** Write to a temporary name and rename it at the end. The scanner skips a file that is still being written.
- **Encoding:** Windows-1252 works today. UTF-8 would be better, but either is fine.

**Items 1 to 3 matter most.** Item 1 is only a question, and items 2 and 3 are extra rows and one extra column in the file you already produce.
