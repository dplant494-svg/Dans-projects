# Second review of "SSORT and WCERRT Integration.md" (21 Sep, evening copy)

**To:** Dan, and the reporting-tools session
**From:** the dashboard / scanner session (scanner v2.60)

The corrections from the morning are all in and right: §1.2 (SSORT's route, delete the stray),
§4.2 (the cap), §5.2 (the lookup fix, lower case kept), §7.9 (the acoustic duplicate, with the
verification method), §8.2 (which blobs are live), §10.1 to 10.3 (the counted state of the grade
strings). As a handoff to Code it is correct. Five additions before it goes, in order of weight:

1. **§9.1 is missing the items the tools session itself queued on 19 and 21 September.** The
   queue lists acoustic, EHBS, Drawdown, Ram Cavity, `soakLabels`, Load latest posted and the
   CBM grade photos. Not listed, and all promised in the 19 Sep reply and the 21 Sep scope
   reply: the **post receipt with the replaces line**, the **unposted-changes mark**, the
   **three print rules** (uniform bottom-anchored photo boxes, conditional keep-together,
   headings never ending a page), **`#attachments-block` hidden in report mode** (a live print
   defect: a report with attachments prints the editing block), **stale entry dates** (amber
   mark and one-click set), the **`counts` block**, and **SSORT writing `meta.rev`** (rolling
   handoff entry 14). A Code session working from §9.1 alone would not know these exist.
   Add them as rows with the same "tool / notes" shape.

2. **§7.9: the Sevan Louisiana has no acoustic system either** (Dan, 21 Sep), alongside West
   Neptune and West Vela. Three rigs get the "no acoustic system fitted" statement, and the
   acoustic tables are rig-specific for the rest, so the fix is per rig, not one form.

3. **§5.2: mark each key shipped or queued.** `attachments[]` and `meta.reportdate` are in the
   field (REV 161). `counts` reads as shipped in the table but is on the queue in §1 of this
   note. A Code session should not have to guess which keys a posted file actually carries.
   One word per row.

4. **§10.3, the reference photographs: state the display rule and the size rule.** Dan, 21 Sep:
   the rig needs to *see* the example photograph beside the grade, and nothing else; it is
   never printed, never posted, never generated into a report. So `CBM_REFPHOTOS` entries stay
   out of `cbmReportHTML()` and out of the payload, and the evidence rules in §6.1 (0.82 JPEG at
   1600 px, never crop) do **not** apply to them: they are reference thumbnails, not evidence,
   and thirteen rigs download every byte. A small fixed size (about 480 px on the long edge)
   keeps a set of examples from doubling the file. Worth saying in the document, because the
   evidence rule is stated strongly enough that someone will apply it to the wrong pictures.

5. **§4.2, the request-limit test: Dan's decision is no deliberate test.** The first post that
   fails will be reported by the crew, and Post already reports a failed response as a failure.
   If it ever happens, the answer stays what §4.2 says: split the payload (plan item 25 on the
   dashboard side is that change), never lower quality. Record the decision so the paragraph
   stops asking for a test.

Two things for §10.2 step 3, already answered on the dashboard side (rolling handoff reply,
entry 15): the posted Gate Valve template has no tasks 1.6 to 1.8, so nothing was graded against
the shifted scale; the only SBOP grade ever recorded is a 1 on task 2.1.1, three times, 27 July.
The tools session maps its "1.3, 4.3, 5.3" to the posted key shape and says whether 2.1.1 is one
of them. Record the answer in §10.2 when it is known.

## Brad's reports, for the photo task

Yes, drop them in, and drop two kinds, into the folders the document already names:

- **Brad's CBM PDFs** into `CBM PDF Reports\`. They are the human-readable review copy and the
  source of the captions.
- **The posted CBM JSON files** for the same inspections, into the same folder or beside it.
  Get them from WellControl, PostedReports, or from the server copies under
  `sacred\dashboard\reports\` (the `.js` files are the same content). These are the better
  source for the photo task: every photograph in them is already keyed to its task
  (`cbm_<equip>_g<section>_<task>_ph`) and sits beside the grade Brad recorded, which is exactly
  the association §10.3 says the NOV figures lack. The PDF has the picture; the JSON has the
  picture and the task and the grade.

And the caution from this morning still applies to both: a photograph is filed as an example of
a grade only after it is re-read against the **corrected** NOV criteria text, not against the
number Brad pressed on a partly shown or inverted scale.
