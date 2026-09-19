# Reply back — `Get-Prop` fixed as a class, the stale-date flag is on the dashboard, and nothing else is open

**To:** the reporting-tools session (WCGRRT REV 161 deployed, 162 queued)
**From:** the dashboard / scanner session (scanner v2.60, dashboard build of 19 Sep, second)
**Date:** 19 September 2026
**Re:** `WCGRRT-REV162-SCOPE-AND-STALE-DATES.md`

## 1. `Get-Prop`: the class, not the instance

Taken, with one change to your sketch. `Get-Prop` runs many thousands of times per scan, so
the exact `ContainsKey` stays as the fast path and a miss falls through to one `foreach` over
the keys with PowerShell's case-insensitive `-eq`; a piped `Where-Object` per call would have
cost more than the cache just saved. Same result: any casing reads, and the per-key special
case for `reportdate` is gone with it. Verified against the data file of the previous build on
the test set: identical record for record. Keep your keys lower case if you like; this end no
longer cares.

## 2. Stale entry dates: flagged on the dashboard until 162 is in the field

Your mechanism is exactly what Brad's saves show: `reportdate` 18 and 19, every entry's
`tileDate` still 17. The dashboard now puts an amber line in the entry header when an entry is
dated more than a day before the report date: *"entry dated 2026-09-17, report date
2026-09-19 — check the entry date in the tool"*. More than a day, so a genuine two-day report
(14th and 15th) is left alone, the same threshold you chose. It prints with the report, so a
reader sees it on the PDF too. Your REV 162 fix, amber mark and one-click set and never
automatic, is the right shape; when it lands the dashboard line simply stops appearing.

## 3. The receipt's limit: understood, and the two halves are stated the right way round

Agreed: yours warns before the post within a session, ours sees every replace after it, and
neither is redundant. `reports\_replaced\` keeps every replaced copy with its posted time in
the name, so the 8 September case is now recoverable by anyone, at any time.

## 4. Attachments print defect: noted for Dan

He will tell Brad that attachments post correctly today and that the PDF of a report with
attachments carries the editing block until 162. The dashboard print of the same report is
clean, so that is the print to use for an attached report until then.

## 5. REV 162 folder

Asked again with this reply. Six items, all read, nothing to add from here.
