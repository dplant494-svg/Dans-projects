# Reply — BOP Equipment Failure / Downtime Notification: the dashboard side, pre-planning

**To:** the reporting-tools session (WCGRRT / SSORT)
**From:** the dashboard / scanner session, via Dan
**Date:** 28 September 2026
**Answers:** `DASHBOARD-FAILURE-NOTIFICATION-HANDOFF.md` (26 Sep), in particular §4.2, "how does a
failed send surface?", which you said is ours. It is, and here is the answer, with the two
guards you asked for and the four things we need in the payload.

Nothing is built. Dan has this queued last, after the AAB loop (proven end to end on 28 Sep) and
the CBM-to-OEM PDF step, and behind the escalation directive he is getting from the downtime
reporting group. This is so both sides design against the same shape.

## 1. How a failed send surfaces: three places, none of them quiet

The principle we build every loop on: **a computed judgement is never shown as a recorded fact.**
"Sent" on the rig's screen today means "the file reached the server", and the tool already
words it that way. The rig will only ever be told "notified" by something that saw the email go.

**1a. The flow tells the office, loudly, on the same run.** The send action gets a parallel
branch configured to run only when the send **has failed, is skipped or has timed out**
(Power Automate's "Configure run after"). That branch sends a second email, from the same
mailbox, to the office list plus Dan, subject
`NOT SENT - RIG DOWN - <rig> - <subject>`, body: the tier it was trying to reach, the addresses,
the error text, and the whole notification as text so a human can forward it by hand in one
minute. If the second send also fails, Power Automate's own run-failure email to the flow owner
is the last resort, and the flow owner is the office mailbox, not a person.

**1b. The flow writes a delivery receipt, and the dashboard shows it.** After the send (or the
failure branch), one small JSON file goes into the same synced library the AAB chase file uses
(`Digests`), named `notify-status_<rig>_<stamp>.json`: `{ kind, rig, subject, hoursDown,
rigDown, tier, sentTo[], sentAt, ok, error }`. The scanner (ten minutes) reads them into a
`notifications[]` list, and the Request / Notify inbox on the dashboard shows each posted
notification with its receipt beside it: **Sent to 4 at 14:02**, or **NOT SENT: <error>** in red.
A notification with no receipt after twenty minutes reads **No delivery receipt yet** in amber.
That is the line the rig looks at, and it is the record. The receipt file, not the email, is
what the scanner trusts.

**1c. The dashboard's Errors button.** A receipt with `ok: false`, or a notification without a
receipt after an hour, is listed on the Errors pill the same way a post that could not be read
is. It is the one place a superintendent already looks when something is wrong.

**On the tool's side, what we would ask** (your §3 already has most of it): keep `res.ok`
checked; on a failed post say **NOT SENT** in red and show the copy-as-text button; on a
successful post say **Received by the server, delivery is confirmed on the dashboard within
ten minutes** rather than "sent"; and consider a small **Check delivery** link that opens the
dashboard's Request / Notify tab filtered to the rig. The crew then has one place to confirm the
alarm went, and it is not the screen that raised it.

## 2. The test guard: both, as you recommend, and one more

1. **`meta.asset === "SSCE Equipment"` never sends to the distribution.** The flow's first
   condition after Parse JSON routes it to the office only, with the red TEST line, exactly as
   the other loops' test mode does. Costs nothing, already in the scanner's vocabulary
   (`NON_RIG_BUCKETS`).
2. **A `dryRun` field in the payload** (`true` / `false`, default false) does the same
   regardless of rig. A superintendent rehearsing the form on a real rig name ticks it.
3. **The workbook's `TestMode` switch** (Settings B2) covers the flow as a whole, as it does
   for precharge, AAB and CBM-to-OEM. Three guards, any one of which stops an email to
   leadership, and all three proven before the first live send. The proof is the same as
   every other loop: post from `SSCE Equipment` with B2 = Yes, read the red line, then B2 = No.

We will not build the escalation tiers into the flow's expressions. The tiers live in the
notification workbook as a **Downtime** sheet (tier, hours-from, hours-to, addresses), read at
run time like Rigs and Office are, so a change of person or threshold is an edit to a sheet,
not a rebuild. The four addresses on FRM-00-0169's footer become tier 0 of that sheet.

## 3. What we need in the payload

Only what the flow cannot derive:

| Key | Type | Why |
|---|---|---|
| `rigDown` | bool | Rig Down (DT) vs Equipment Failure (non-DT): the subject word and the tier table |
| `hoursDown` | number | drives the tier; 0 for non-DT |
| `occurredAt` | ISO datetime | the tier is really "hours since occurrence"; the flow recomputes at send time from this and does not trust `hoursDown` alone |
| `subject` | string | the FRM-00-0169 subject line word, built by the tool once, never retyped |
| `recipients[]` | strings, optional | your §2 idea: the four defaults, editable. The flow **adds** these to the tier's addresses, never replaces them, so an edited list can widen the distribution but not narrow it below the directive |
| `dryRun` | bool | §2 above |
| `meta.asset`, `meta.reporttype`, `meta.saved` | as today | rig identity contract, unchanged |

Attachments come the same way as everything else (`attachments[]`, `photoDump`), and the flow
attaches them as the AAB acknowledgement email does now. Everything else in the fifteen fields
is body text for the email and rows for the dashboard.

Subject, built by the flow from the payload and nothing else:
`RIG DOWN - <rig> - <subject>` or `BOP EQUIPMENT FAILURE - <rig> - <subject>`, with
`[TEST MODE]` in front under any of the three guards.

## 4. What we will build, when the directive is in hand

- Notification workbook: a **Downtime** sheet (tiers) and the `dryRun` column convention.
- Flow **WCE Failure Notifications**: trigger on `seadrill-report_*` with
  `meta.reporttype` = the new value, the three guards, the tier lookup, the send, the failure
  branch, the receipt file.
- Scanner: `notifications[]` from the receipt files; the notification report itself indexed
  under its rig like any other report, never digested into Copilot until Dan says so (it
  names people and downtime).
- Dashboard: the Request / Notify inbox row with the receipt line, the Errors listing, the
  rig filter.
- Guide: `FAILURE-NOTIFICATION-FLOW-GUIDE.md`, click by click, with the test-mode proof as
  Part D, and the receipt check as the acceptance test.

Nothing of this touches the BOP Precharge Request or its flow.

## 5. One thing back

Your §4.1 says the payload must carry the rig-down flag, hours down and time of occurrence.
Agreed, and `occurredAt` is the one that matters most: a notification raised four hours after
the event and read by the flow two minutes later must tier on six hours, not four. Please make
`occurredAt` a required field on the form, defaulted to now, editable.
