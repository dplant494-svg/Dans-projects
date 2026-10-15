# Addendum to Handoff 2 for Lee: the report time is the rig's, twice a day

**Date:** 15 Oct 2026, night. **Changes:** A1 and A5 of Handoff 2. Everything else stands.

**Dan:** "0600 and 1800 aren't actually cut-offs. Some rigs work 0700-1900, and the SSS will probably do it after handover or
shift, so we say 12 hours but it's twice a day really."

- **A1, replaced.**
  - The rig posts the `planning-report` **twice a day, after its shift handover**, at whatever time that is.
  - **Report time:** the time of the post, or a time the SSS enters; it defaults to now.
  - **Keys:** put it in `meta.cycle` and `planningData.cycle` as `"HHMM"` (e.g. `"0700"`, `"1930"`), in `meta.dataDateTime` as ISO with the rig's offset, and on the end of `meta.reportName`.
  - **Reminder:** if more than about 14 hours pass since the last report, remind the rig. Not at a fixed clock time.
- **A5, adjusted.** `prev` for `planCycleLists` is the task state at the **previous report's time**, whatever it was.
- **Wording.** Say "twice daily" rather than "12-hourly" anywhere the rig reads it.

SACRED's scanner (v3.05) already accepts any report time, so no SACRED change is waiting on this.
