# Class module: the WCE Certificate of Conformance tracker (Day 2, 13:00 slot, about 30 minutes)

**Taught from:** Manpreet Singh's handoff of 30 September 2026 (`tools/received/coc/WCE_CoC_Tracker_Handoff_2026-09-30.html`).
**Presenter:** Dan. **File in the room:** the rebuilt tracker as Manpreet issued it, opened from a local copy, not the share.
**Not in this module:** the API Std 53 gap analysis (Wednesday morning of the workshop, Ronnie's session).

## Walkthrough, in order

1. **What it is (2 min).** One HTML file, data and code inside, opens from a share or an attachment. The Maximo extract
   is the master record; the tracker is a snapshot of it. Say the figures as built on 30 September: 3,364 fleet
   components, 289 expired, 485 due within 18 months, 621 valid, 1,969 with no date on file.
2. **The fleet dashboard (3 min).** KPI tiles, the status split, the by-vessel table with BOP 1 / BOP 2 / Surface /
   Not defined / C&K / Riser columns. SAY: "Action required is everything between Expired and Valid."
3. **The status tiers (3 min).** Calculated against today every time the file opens, never imported: expired; due
   within 6 months; within 1 year; within 18 months; valid; no date on file. TRAP: "no date on file" is not "valid".
   It is 59% of the fleet and it is a Maximo data-entry problem, not a tracker problem.
4. **One row per asset (3 min).** The extract has one row per certificate; the tracker keeps the newest and lists
   the rest under Previous certificates with a +n badge. SAY: "29 assets were showing expired under an old
   certificate when they had been recertified. Headline expired fell from 392 to 289 the day this rule went in."
5. **A vessel page (4 min).** Pick one rig; WCE / Choke & Kill / Riser tabs; the WCE sub-tabs by section. Open a row:
   the detail panel, Maximo ID, certificate history, the same OEM part held in shared capital.
6. **Search and shareable addresses (2 min).** Ctrl+K; then paste an address such as
   `…Tracker.html#/components?tier=expired&v=2317` and show that it lands on that view. SAY: "Send the link, not a
   screenshot."
7. **Annotations (3 min).** Compliance tick, remark, Synergi number on a row. TRAP: they live in your own browser.
   They do not travel with the file, they are not shared, and clearing site data loses them. Anything that must be
   shared goes in Maximo or Synergi.
8. **Refreshing the data (4 min).** Update from Excel, pick the extract, read the counts, Save copy, distribute the
   copy. Nobody edits the HTML. Mention the auto-refresh link and why it often does nothing on SharePoint.
9. **Exports (2 min).** CSV per view, Excel per vessel, print to PDF; both exports carry the superseded-certificate count.
10. **Shared Capital and the SSCE request (4 min).** The 0960 register; stock tiles; then the Request path. SAY
    whichever is true on the day: either "the Request button is on the rebuilt tracker" or "for now requests are
    raised from the older COC Dashboard on the SSORT share; the rebuilt tracker is for status". The decision is due
    10 October (`COC-TRACKER-SACRED-HANDOFF.md`).

## Questions the room will ask, with the answers

- "Why does my rig show so many with no date?" Because the issued and expiry dates are blank in Maximo for those
  rows. The fix is in Maximo, by the rig and the CoC owner; the tracker will show it the next refresh.
- "Can I change a wrong date here?" No. The tracker never edits the record. Fix it in Maximo.
- "Who owns the tracker?" Manpreet Singh. Questions on the data go to him; questions on SACRED's use of it go to Dan.
- "Is this in SACRED?" Linked from it today; the SSCE request loop runs through it; the rebuilt file's place in
  SACRED is being settled this month.

## Trainer's notes

- Do not open the tracker from the SSORT share in the room; the share copy is the live SSCE front door and the
  scanner writes a review copy beside it. Use a local copy.
- The handoff's known gaps (§9) are the honest list if someone pushes: the two unmapped C&K SFIs, the carried-over
  shared capital, the per-browser annotations.
