# SACRED status board: dials and pies on the database (6 October 2026)

**What it is:** one page that shows, for the whole of SACRED, what has been done and what is open: reports posted by type,
daily check rounds by rig and shift, precharge requests issued, AAB acknowledgements and closures, Help Centre requests
answered, SSCE requests decided, CBM reports sent to NOV, CBM components at grade 4 or 5. A dial per loop with its percentage,
pies of done against open, a rig table and a daily checks chart. It refreshes every hour with the database.

**Built from:** `database/ddl-v5-status-views.sql` (four views; run it once in SACRED DATA). Every number is a count of what was
posted or recorded; nothing is judged by the board.

## Step 1. The views (one minute)

SACRED DATA, **New Query**, paste the whole of `ddl-v5-status-views.sql`, **Run**. The last result is the board in words: one row
per loop with total, done, open and `percent_done`.

## Step 2. Is Power BI open to you? (two minutes)

1. In SACRED DATA, top right, the drop-down that says **SQL database**: switch it to **SQL analytics endpoint**.
2. Look for a **Reporting** tab, or **New semantic model** on the ribbon. If it is there, Power BI is open to you; carry on.
3. If it is missing or greyed, Power BI needs an admin too: stop, and tell the dashboard session. The fallback is the same
   dials as a Status tab on the SACRED dashboard itself, built by the scanner from the same numbers, visible to everyone with no
   sign-in.

## Step 3. The model (two minutes)

**New semantic model**. Name `SACRED status`. Tick the four views: `v_status_loops`, `v_status_rigs`, `v_status_reports`,
`v_status_daily_checks`. **Confirm**.

## Step 4. The report (twenty minutes, then it looks after itself)

From the semantic model, **Create new report** (or **Explore this data**, then **Create report**). Build these, top to bottom:

1. **A dial per loop.** Visual: **Gauge**. Value: `percent_done` (Average). Minimum 0, maximum 100 (Format, Gauge axis). Filter
   pane: `loop_name` is *Precharge requests issued*. Title: the loop name. Copy and paste the gauge and change the filter for:
   AAB rig acknowledgements; AABs closed by Technical Services; TSC Help Centre requests answered; SSCE requests decided.
   Five dials across the top.
2. **Done against open, as pies.** Visual: **Donut chart**. Values: `done` and `open_items` (Sum). Filter `loop_name` as above.
   One per loop under its dial, if you want both; the dial alone is usually enough.
3. **The loops in words.** Visual: **Table** from `v_status_loops`: loop_name, total, done, open_items, percent_done,
   last_activity. Sort by sort_order.
4. **The rigs.** Visual: **Table** from `v_status_rigs`, every column. Conditional formatting (column drop-down, Conditional
   formatting, Background colour) on `aab_outstanding`, `precharge_open`, `help_open` and `cbm_latest_grade_4_or_5`: white at 0,
   amber above 0.
5. **What is being posted.** Visual: **Matrix**. Rows `rig`, Columns `reporttype`, Values `posts_last_30_days` (Sum), from
   `v_status_reports`.
6. **Daily checks, both shifts.** Visual: **Clustered column chart** from `v_status_daily_checks`. X-axis `check_date`, Y-axis
   `day_rounds` and `night_rounds` (Sum), Small multiples or a slicer on `rig`.

**Save** as `SACRED status`. **Share** with Lee (read). The report refreshes from the database by itself.

## What the dials will say on day one, so nobody is surprised

- The precharge dial reads 100%: all seven requests on record were issued.
- The AAB dials read low: four of six rig states are outstanding, because the advisories issued on 1 October to Sevan
  Louisiana are waiting for the rig. That is the loop working, not failing.
- The Help Centre dial reads 0%: one request, still open. It moves when the office acknowledges it.
- The training posts on `SSCE Equipment` count on the board until Dan deletes them after the class; `v_status_rigs` lists
  SSCE Equipment as its own row so it never hides in a rig's numbers.
