# Two Argo Navis test reports for Saturday 17 Oct (West Vela BOP1, test plan WVE-BOP1-20261012)

Built by SACRED from Lee's REV 15 sample. Each report is a pair: the Daily Summary Report (`planning-report`) and its progress post (`plan-progress`), just as Post daily report sends them.

- **All four files are tests.** They carry `dryRun: true` and `meta.sample: true`: the email goes to Dan and Lee only, marked [TEST MODE], and the chat line goes to the Office-only test chat.
- **They have no saved schedule inside** (`scheduleBuilderState` removed), so they **don't replace** Dan's REV 16 saved state under "Load latest schedule".

| Drop | Files (both) | Report | What changed |
|---|---|---|---|
| 1 | `SAMPLE_20261017-1900_…` | 17 Oct 19:00, Day 6 | 19.84% / 34.10% BOP, LMRP Complete actual 17 Oct |
| 2 | `SAMPLE_20261018-0700_…` | 18 Oct 07:00, Day 7 | 23.41% / 41.05% BOP, break-in BRK-001 closed |

**How to use them:**

1. Drop the two files of **drop 1** into PostedReports.
2. Wait about 35 minutes for the `[TEST MODE] West Vela BOP1 BWM Reporting 2026/10/17 1900` email with the PDF, and the chat line "Progress 19.84% as of …". If the chat still reads "%%", the Pct fix in the Plan Notifications flow is not in yet.
3. Then drop **drop 2** the same way. Expect the 2026/10/18 0700 email, with one break-in open instead of two.
4. **Afterwards:** delete the four files from PostedReports. The `dsr-receipt_…` files in help-receipts can stay; they only stop a resend.
