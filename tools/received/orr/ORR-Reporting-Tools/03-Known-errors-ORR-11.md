# ORR 11 — Known error log: WCGRRT REV 168 and SSORT REV 158

**Owner:** Dan Plant, Technical Services — Subsea · **Date:** 6 October 2026
Shape as the workbook's Known error log: issue · effect · workaround · fix planned.

---

### KE-01 · SSORT does not tell a crew that a post failed

**Tool:** SSORT 153 · **Severity:** high · **Status:** open

**Issue.** `sdPostReport` returns `false` silently — no toast, no receipt, nothing. `postReport`
then falls through to the reports folder, then Save As, then download, and the message the crew
sees is *"Report posted to the shared folder"* or *"✓ Report saved."* WCGRRT does the opposite: it
warns with the HTTP code.

**Effect.** A crew reads the word "posted", or a tick, and believes the report reached the
dashboard when it did not. Nobody in the office is expecting it, so nothing chases it.

**Workaround.** The dashboard is the only proof. If a SSORT report is not visible under the rig
within ten minutes it did not land, whatever the tool said. The file is never lost — it is in the
TSC REPORTS folder or wherever Save As put it — so send that `.json` to the office.

**Fix planned.** Give SSORT the WCGRRT receipt and failure toast. Not done days before the October
class, deliberately: it is on the posting path, which is the one place a rushed change is expensive.

---

### KE-02 · Four SSORT payload roles are always empty

**Tool:** SSORT 153 · **Severity:** low (data quality) · **Status:** open

**Issue.** The payload writes seven role keys — `tsl`, `rigmgr`, `arigmgr`, `oim`, `wce`, `elec`,
`dsl` — by reading elements that **do not exist in SSORT**. Verified 30 September: zero occurrences
of `id="meta-tsl"` and the other six. Every one posts as an empty string on every SSORT report.
WCGRRT has all the fields and populates them.

**Effect.** Any dashboard view or report that expects a Subsea Superintendent, TSL or Rig Manager
from a SSORT report gets nothing, and it looks like the crew left it blank rather than the form
never having asked.

**Workaround.** Take those roles from the WCGRRT report for the same rig and period, or from
`sss`, which SSORT does have and does populate.

**Fix planned.** Either add the fields to SSORT's Vessel Information or stop posting the seven keys.
Additive-only rules mean removing keys needs the dashboard side's agreement first.

---

### KE-03 · One SSORT workspace posts as one report type

**Tool:** SSORT 153 · **Severity:** medium · **Status:** open, by design but unguarded

**Issue.** The posted filename's type comes from `reportTypeAuto()`, which returns the **first**
matching tile in a fixed order — CBM Inspection, then Conditional Assessment, then Surface BOP
Testing, then Pre-Deployment Checklist — and the workspace holds every tile at once. There is no
`meta-reporttype` element in SSORT at all, so that fallback is always what runs.

**Effect.** A crew that builds a CBM inspection and a pre-deployment checklist in one workspace and
presses Post gets **one** file named `…_cbm-inspection.json` containing both. The checklist never
appears as its own row on the dashboard. **Nothing warns them.**

**Workaround.** One report at a time: build it, post it, **⊘ New Trip**, start the next. This is on
the Day 1 exercise sheet as rule 1.

**Fix planned.** Warn at Post when the workspace holds more than one report-type tile. Not yet
built.

---

### KE-04 · WCGRRT REV 163 shipped stamped REV 162

**Tool:** WCGRRT 163 (historical; 166 is current) · **Severity:** low · **Status:** closed forward, historical data affected

**Issue.** REV 163 carries `TOOL_REV = 'REV 162'` — the revision constant was not bumped.

**Effect.** `meta.rev` on any report posted from REV 163 reads `REV 162`, so posts from the two
revisions cannot be told apart. Provenance for that window is unreliable.

**Workaround.** None for reports already posted. Use the posted date rather than `meta.rev` to place
a report in that window.

**Fix planned.** Prevention, not repair: the runbook makes bumping the revision constant the **first**
edit in a new folder, and the same class of defect is what put a second, stale SSORT copy on the
`sacred` share (KE-08).

---

### KE-05 · `setPostUrl` in SSORT changes nothing

**Tool:** SSORT 153 · **Severity:** low · **Status:** open

**Issue.** The menu option writes `sd_post_url` to `localStorage` and `sdGetPostUrl()` reads it, but
`sdPostReport` posts to the hardcoded `REPORT_POST_URL` and ignores both. WCGRRT's `sdGetPostUrl()`
falls back to the same constant whenever the stored value is not `https://`, so it cannot silently
disable posting there either.

**Effect.** Anyone who sets a post URL in SSORT believes posts are being redirected. They are not —
they still go to the live dashboard intake. Behaviour is safe; the message is misleading.

**Workaround.** Do not use "Dashboard Post URL" in SSORT. It is not needed in normal operation.

**Fix planned.** Either honour the override or remove the menu option. Unchanged so far because it
sits on the posting path and the current behaviour always reaches the right place.

---

### KE-06 · Four WCGRRT test records hold nothing for `SSCE Equipment`

**Tool:** WCGRRT 166 · **Severity:** low (expected behaviour, poor discoverability) · **Status:** open

**Issue.** The ROV, acoustic, EDS and EHBS records are keyed to the rig. On `SSCE Equipment` each
renders a single line instead of a form: *"No EDS verification sheet on file for SSCE Equipment"*,
and so on. Only the BOP Function Test, Soak Test and Surface Drawdown Test work on that asset.

**Effect.** Anyone demonstrating or testing on `SSCE Equipment` — including a training class — finds
four of the seven records unusable and may read it as a fault.

**Workaround.** Use a real rig to exercise those four, and switch the asset back to `SSCE Equipment`
before anything is posted. Two different messages exist and mean different things: *no sheet on
file for this asset* means nobody has loaded it yet, so tell the office; *no system fitted* (West
Vela, West Neptune, Sevan Louisiana for acoustic) means the rig genuinely has none.

**Fix planned.** None needed for the tool. Documented in the Day 1 walkthrough script, module 2.

---

### KE-07 · Pre-deployment cavity photograph slots are invisible until two fields are set

**Tool:** SSORT 153 · **Severity:** medium · **Status:** open

**Issue.** `pdcBopEvidenceHTML` returns nothing without a cavity count, so the ram packer
attestation and all the cavity/door photograph slots only exist once the checklist's **own** BOP
designation (Single or Dual) **and** its cavity count are set.

**Effect.** A crew that has not set both sees no cavity photograph slots at all, and can reasonably
conclude the checklist does not want them — on the one record where those photographs are mandatory
evidence that the stack was fit to run.

**Workaround.** Set the designation and the cavity count first. A 7-cavity stack then asks for 42
named slots, 14 in each of three sections, every box labelled for its position.

**Fix planned.** Show the section with a "set the BOP designation and cavity count to load the
evidence boxes" placeholder rather than nothing. Not yet built.

---

### KE-08 · A second, stale SSORT is served from the `sacred` share

**Tool:** deployment · **Severity:** medium · **Status:** open, awaiting deletion

**Issue.** `\\sdrlazneuiis01d.corp.local\sacred\index.html` is a second copy of SSORT: **REV 149
content whose badge reads `REV 148`** (one character differs from REV 149; the rest is byte-identical).
Refreshed 26 September, so it is in use, not abandoned. SSORT is not supposed to live on `sacred`.

**Effect.** Anyone reaching SSORT by that URL runs a build four revisions behind — without the
Riser Adapter grades or photographs, without CBM test-record attachments — and anything posted from
it stamps `meta.rev = "REV 148"` while actually being 149.

**Workaround.** Use `\\sdrlazneuiis01d.corp.local\SSORT\index.html` (served at
`http://sdrlazneuiis01d.corp.local:8080/SSORT/index.html`). That is the only supported SSORT.

**Fix planned.** Delete the file. Dan has no delete rights on that share, so it needs IT. Tracked.

---

### KE-09 · The OEM copy's 30 MB refusal now counts the attachments

**Tool:** SSORT 153 · **Severity:** low · **Status:** open, working as designed

**Issue.** From REV 153 the crew's test records travel to NOV, so their bytes count towards the OEM
copy's 20 MB warning and 30 MB refusal. The arithmetic was written in 152 and dormant while the
feature was off.

**Effect.** A CBM report that emailed to NOV yesterday at 24 MB of HTML plus 8 MB of charts is
refused today. Correct, but it is a behaviour change dated 30 September and the first crew to meet
it will not know that.

**Workaround.** Post to the dashboard as normal — that is unaffected, its ceiling is 40 MB — and
send the OEM copy as two posts split by equipment section. **Do not reduce photograph quality to
get under a limit.**

**Fix planned.** None. NOV's own mail gateway limit is still unknown to us; a bounce past our
refusal returns to the office through the flow's NOT SENT branch, not to the rig.

---

### KE-10 · The dashboard intake URL is embedded in a file any reader can open

**Tool:** both · **Severity:** for ISIT to rate · **Status:** open, stated for the review

**Issue.** `REPORT_POST_URL` is a Power Automate HTTP-trigger URL carrying its own signature, and it
is a literal in a client-side HTML file served from an intranet share. Anyone who can open the tool
can read it.

**Effect.** Anyone on the network who opens the file can post an arbitrary report into the intake.
There is no authentication on the trigger beyond the signature in the URL.

**Workaround.** None at the tool. The exposure is bounded by network access to the share, and the
dashboard side can see what arrives.

**Fix planned.** None proposed from this side — this is raised for ISIT rather than answered,
because the trigger, its rotation and any gateway in front of it are theirs. The token is
deliberately not reproduced in this pack.

---

### KE-11 · EHBS timer delay never computed while the form was being filled in

**Tool:** both, fixed in WCGRRT 167 / SSORT 154 · **Severity:** medium · **Status:** CLOSED 1 Oct 2026

**Issue.** The sequence timing delay is derived (B − A) rather than typed, but it was only computed
when the form was drawn from saved data. Nothing recomputed it as the crew typed, so the cell showed
"—" and `ehbs_tim_delay` posted empty.

**Effect.** Reported from a rig on 30 September. Every EHBS test posted from either tool carries an
empty timer delay unless the crew happened to save, reload and restore with both times already
entered. The delay is the measured gap between CSR closure stopping and UBSR closure starting.

**Workaround (historical).** It is recoverable from the posted data: the delay is simply
`ehbs_tim_shearStarts` − `ehbs_tim_csrStops`, both of which did post.

**Fix.** Recomputes on input, on a delegated listener so it survives the form being re-rendered.
Deployed 1 October.

---

### KE-12 · Restoring a SSORT surface test destroyed the record

**Tool:** SSORT, fixed in 154 · **Severity:** HIGH, data loss · **Status:** CLOSED 1 Oct 2026

**Issue.** Five of the seven surface-test forms are rig-keyed and return a "Select the vessel"
placeholder without `#meta-asset`. `loadState()` created the tiles before restoring the rig, so on a
restore the form rendered the placeholder and the saved readings were dropped. `collectSbop` reads
the DOM, so the next autosave collected an empty form and **overwrote the saved record with
nothing**. A second fault compounded it: the restore path's type mapping covered only four of the
seven forms, missing Acoustic, EHBS and Surface Drawdown entirely.

**Effect.** A crew that saved a surface test, closed the tool and restored it lost the whole test
record silently. Same class as the Ram Cavity defect closed in REV 148. WCGRRT was never affected.

**Workaround (historical).** Do not restore a report containing a surface test; rebuild it. Crews
who kept their own `.json` saves can recover from those.

**Fix.** One shared renderer for both the first render and the rebuild so the mappings cannot drift
apart again; the tile keeps its own saved soak data; both restore paths rebuild the forms after the
rig is back, replacing a placeholder only. Deployed 1 October.

**Open question with the dashboard side** (rolling handoff 45.3): how many already-posted reports
lost their `soak` block. Not visible from the tool side.

---

### KE-13 · A deployed revision can keep being served from browser cache

**Tool:** both · **Severity:** low, operational · **Status:** open

**Issue.** After a correct, hash-verified copy to the share, the browser continued serving the
previous revision until the URL was cache-busted.

**Effect.** A rig may keep running the old build after a fix has shipped, including a fix they are
waiting on.

**Workaround.** Hard-refresh (Ctrl-F5) or close and reopen the tool. Check the revision badge
against what was announced.

**Fix planned.** None at the tool. Worth raising with ISIT as a cache-header question on the IIS
site.

---

### KE-14 · A rig-specific panel built before the rig is known stays wrong for the session

**Tool:** SSORT, fixed in 157 · **Severity:** medium · **Status:** CLOSED 5 Oct 2026

**Issue.** The Daily Checks panel was built the first time the tab was opened, behind a
`dataset.built` latch, using whatever rig was set at that moment, and was never rebuilt. The rig
selector is on a different tab, so opening Daily Checks first — the normal order — produced the
default Capella sheet for the whole session, whatever rig was picked afterwards.

**Effect.** Reported by West Auriga on 5 October as their template having "disappeared". It had
not: the sheet was intact and the selector correct, the panel was stale. Only West Auriga, West
Saturn and Sevan Louisiana could ever see it, because the other ten rigs legitimately use the
Capella sheet and a stale panel looked right. Rounds posted in that state carry the wrong sheet's
keys.

**Workaround (historical).** Select the rig first, then open Daily Checks; or reload after
selecting the rig.

**Fix.** The panel rebuilds on rig change, carrying readings across and telling the crew how many
transferred. Deployed 5 October.

**Pattern worth naming for ISIT:** this is the third defect of one shape — a rig-keyed block
rendered before the rig is known and never rebuilt. The others were the Ram Cavity record (REV 148)
and the surface-test restore (KE-12, REV 154). Any new rig-dependent panel needs a rebuild hook on
`onAssetChange` as a matter of course.

---

### KE-15 · Two CBM inspections on one rig on one day overwrote each other

**Tool:** SSORT, fixed in 158 · **Severity:** HIGH, data loss · **Status:** CLOSED 6 Oct 2026

**Issue.** A CBM post was named for the rig and the date only. Two different inspections on one day —
the C&K stabs and the riser adapter, say — shared a file name, SharePoint kept the second, and the flow
does not fire on an overwrite, so the first vanished from every downstream view. Surface BOP tests had
the same shape.

**Effect.** Found by the dashboard from scan counts on 6 October: six CBM reports reached NOV between
two scans while PostedReports kept at most four.

**Workaround (historical).** One CBM inspection per rig per day, or all of them as tiles in one report.

**Fix.** The name carries the equipment, plus the serial number where entered; surface tests carry the
test type. Deliberately not a timestamp, which would have made every corrected re-post a second row.
Lost versions are recoverable from PostedReports' own version history; the dashboard side is restoring
them. Residual: the same class on both stacks of a dual-stack rig on one day with the serial blank.

---

### KE-16 · Save to File in WCGRRT silently posted to the dashboard

**Tool:** WCGRRT, fixed in 168 · **Severity:** HIGH · **Status:** CLOSED 6 Oct 2026

**Issue.** The Save to File button posted the report before opening the Save As dialog, with no rig
guard, no date guard, no "only post a finished report" confirm and no size check. Present since at least
REV 155. The tool's own New Trip prompt recommends Save to File at the end of every trip.

**Effect.** Unattributed posts (how a Vendor Surveillance report reached the dashboard as
`seadrill-report_report_…`); unfinished reports posted without the crew choosing to; and a draft saved
after the finished report was posted replacing it under the same name, which loses work.

**Workaround (historical).** None a crew would have known to apply.

**Fix.** The post is removed; Save to File saves a file. **Consequence to watch:** a rig that reached
the dashboard only through Save to File will go quiet until a crew presses Post Report.

---

## Closed since REV 149, for context

| Was | Closed by |
|---|---|
| Riser Adapter had no grading and no photographs on any path — five weeks of CBM reports with no condition recorded | SSORT 150 (photographs), 151 (grades) |
| A crash-restored Ram Cavity record came back empty and the next autosave overwrote the good one | SSORT 148 |
| `acousticTestHTML` declared twice; the later declaration silently won and the wrong acoustic form rendered | WCGRRT 165 |
| Daily reports overwriting each other — two different days under one filename | WCGRRT 161 |
| West Vela's EDS stamped Rev H while carrying Rev G content | rebuilt from NOV 20093383D Rev H |
