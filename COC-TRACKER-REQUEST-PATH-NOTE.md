# CoC tracker: the SSCE Request path is back (note for Manpreet, 11 October 2026)

**File:** `Seadrill_WCE_COC_Dashboard_REV6 1.html` on `\\sdrlazneuiis01d.corp.local\SSORT`, replaced by Dan on 11 Oct with
the same file plus the SACRED request path. Your data block and everything in the page are unchanged; the additions
are all inside the `<script>` after it, marked with a comment above the `coc-data` block.

**What was added (additive, per `COC-TRACKER-SACRED-HANDOFF.md` option 1):**

- In the component drawer, the "Shared capital with the same OEM part" table has an **SSCE** column: a **Request**
  button, or **Allocated — <site>** when the row's `avail` is NO.
- A shared-capital item opened directly shows **Request this item from SSCE**.
- The SSCE Application Form opens as a modal in the page's own style (`.modal`, `.field`, `.btn`), posts the record as
  `ssce-request_<site>_<stamp>.json` to the SACRED intake, and downloads the file instead if the post fails. A copy is
  kept in the browser's localStorage, like the annotations.
- `saveCopy()` already stripped `.modal`, so a saved copy never carries an open form.

**What SACRED does with your data block:** the scanner reads `coc-data`, finds the shared-capital rows (vessel not
fleet) by asset + OEM part + serial for each approved request, and writes `avail` = `NO`, `assignedTo` = `<site>` on a
**review copy** (`Seadrill_WCE_COC_Dashboard_PENDING_REVIEW.html` beside the file), never on the live file. Your page
already renders those two fields. One row per certificate means the same asset can be on more than one row; every
matching row is marked.

**The one ask, unchanged:** carry `avail` and `assignedTo` through your refresh and rebuild scripts (your importer
already maps `available` / `assignedto` headers), so a Maximo refresh does not wipe the allocations. And a line to Dan
before any change to `cFields` or to the `coc-data` tag, so the scanner is updated first.
