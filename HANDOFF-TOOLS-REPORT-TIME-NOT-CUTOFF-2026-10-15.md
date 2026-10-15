# To the tools session: the report time is the rig's, not a fixed 0600 / 1800 cut-off

**From:** SACRED, via Dan. **Date:** 15 Oct 2026, night. **Follows:** entry 83 and SACRED's reply to it.

**Dan (15 Oct):** "0600 and 1800 aren't actually cut-offs. Some rigs work 0700-1900, and the SSS will probably do it after
handover or shift, so we say 12 hours but it's twice a day really."

## Please change in WCGRRT (next REV)

1. **"Data Cut-off" becomes "Report time".**
   - Replace the 0600 / 1800 choice with a **time the rig enters** (HH:MM, rig local), defaulting to the current time.
   - Two quick buttons are fine for the common handovers (0600 / 1800 and 0700 / 1900), but any time must be accepted.
2. **Keep the same keys**, with any time in them:
   - `meta.cycle` and `planningData.cycle`: `"0700"`, `"1930"`, etc.;
   - `meta.dataDateTime`: that time, ISO with offset;
   - `meta.reportName` and the posted file name: end `_<HHMM>`, e.g. `20261015_WPO_TMP_BOP1_Report_1900`. Dan's yes to the
     name change (83.4) stands.
3. **"Since last report"** (done list, NEW break-ins) is measured from the **previous report's time**, whatever it was, not from
   a fixed cut-off 12 hours earlier.
4. **The print reads** "DATA DATE 2026-Oct-15 @1900 Hrs" with the rig's time.
5. **Wording:** "12-hourly" becomes "twice daily" in anything the rig reads.

## SACRED side (FYI, done)

- Scanner v3.05 takes any report time: `"07:00"`, `"0700"` and `"7:00"` all read 0700.
- A report is printed and sent when its post carries a report time. Posts without one are never sent.
- The email subject ends with the time, e.g. `West Polaris BOP1 TMP Reporting 2026/10/15 1900`.

Please log this as a rolling entry.
