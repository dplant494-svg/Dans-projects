-- ddl-v5-status-views.sql  (6 October 2026)
-- The SACRED status board: four views that say, at a glance, what has been done and what is open across every loop.
-- Read by the Power BI report (STATUS-BOARD-GUIDE.md), by a query in SACRED DATA, and later by the Lovable pages.
-- Nothing is computed that is not written in a report: counts, dates and the states the loops already record.
-- Re-runnable. Paste the whole script into a New Query in SACRED DATA, Run.

-- 1. Every loop on one page: how many, how many done, how many open, the percentage done (for a dial), when it last moved.
CREATE OR ALTER VIEW dbo.v_status_loops AS
SELECT u.sort_order, u.loop_name, u.total, u.done, u.open_items, u.last_activity,
       CAST(CASE WHEN u.total = 0 THEN NULL ELSE 100.0 * u.done / u.total END AS DECIMAL(5,1)) AS percent_done   -- the dial
FROM (
SELECT 1 AS sort_order, N'Reports posted, all types' AS loop_name,
       COUNT(*) AS total, COUNT(*) AS done, 0 AS open_items,
       CAST(MAX([modified]) AS NVARCHAR(40)) AS last_activity
FROM dbo.reports
UNION ALL
SELECT 2, N'Daily check rounds (Day and Night)',
       COUNT(DISTINCT [file]), COUNT(DISTINCT [file]), 0, CAST(MAX([date]) AS NVARCHAR(40))
FROM dbo.rig_checks
UNION ALL
SELECT 3, N'Precharge requests issued',
       COUNT(*), SUM(CASE WHEN [status] = 'issued' THEN 1 ELSE 0 END),
       SUM(CASE WHEN ISNULL([status],'') <> 'issued' THEN 1 ELSE 0 END), CAST(MAX([saved]) AS NVARCHAR(40))
FROM dbo.precharge_requests
UNION ALL
SELECT 4, N'AAB rig acknowledgements',
       COUNT(*), SUM(CASE WHEN [state] IN ('acknowledged','closed') THEN 1 ELSE 0 END),
       SUM(CASE WHEN [state] NOT IN ('acknowledged','closed') THEN 1 ELSE 0 END), CAST(MAX([issueDate]) AS NVARCHAR(40))
FROM dbo.aab_status
UNION ALL
SELECT 5, N'AABs closed by Technical Services',
       COUNT(*), SUM(CASE WHEN [state] = 'closed' THEN 1 ELSE 0 END),
       SUM(CASE WHEN [state] <> 'closed' THEN 1 ELSE 0 END), CAST(MAX([closedAt]) AS NVARCHAR(40))
FROM dbo.aab_status
UNION ALL
SELECT 6, N'TSC Help Centre requests answered',
       COUNT(*), SUM(CASE WHEN [state] <> 'open' THEN 1 ELSE 0 END),
       SUM(CASE WHEN [state] = 'open' THEN 1 ELSE 0 END), CAST(MAX([postedAt]) AS NVARCHAR(40))
FROM dbo.help_requests
UNION ALL
SELECT 7, N'SSCE requests decided',
       COUNT(*), SUM(CASE WHEN ISNULL([decision],'') <> '' THEN 1 ELSE 0 END),
       SUM(CASE WHEN ISNULL([decision],'') = '' THEN 1 ELSE 0 END), CAST(MAX([submittedAt]) AS NVARCHAR(40))
FROM dbo.ssce_requests
UNION ALL
SELECT 8, N'CBM reports sent to NOV',
       COUNT(*), COUNT(*), 0, CAST(MAX([sent]) AS NVARCHAR(40))
FROM dbo.oem_copies
UNION ALL
SELECT 9, N'CBM components whose latest grade is 4 or 5',
       COUNT(*), 0, COUNT(*), CAST(MAX([date]) AS NVARCHAR(40))
FROM dbo.v_cbm_latest_grade WHERE [grade] IN ('4','5')
) u;
GO

-- 2. One row per rig: when it last reported, how its checks are running, what it has open.
CREATE OR ALTER VIEW dbo.v_status_rigs AS
WITH rigs AS (SELECT DISTINCT [rig] FROM dbo.reports WHERE ISNULL([rig],'') NOT IN ('', 'Unattributed'))
SELECT r.[rig],
  (SELECT MAX(TRY_CONVERT(date, COALESCE(NULLIF(x.[reportDate],''), x.[date]))) FROM dbo.reports x
     WHERE x.[rig] = r.[rig] AND x.[reporttype] = 'Rig Visit') AS last_rig_visit_report,
  (SELECT MAX(TRY_CONVERT(date, c.[date])) FROM dbo.rig_checks c WHERE c.[rig] = r.[rig]) AS last_daily_checks,
  (SELECT COUNT(DISTINCT c.[file]) FROM dbo.rig_checks c
     WHERE c.[rig] = r.[rig] AND TRY_CONVERT(date, c.[date]) >= DATEADD(day, -7, CAST(GETUTCDATE() AS date))) AS check_rounds_last_7_days,
  (SELECT COUNT(*) FROM dbo.reports x WHERE x.[rig] = r.[rig] AND x.[reporttype] = 'CBM Inspection'
     AND TRY_CONVERT(date, COALESCE(NULLIF(x.[reportDate],''), x.[date])) >= DATEADD(day, -30, CAST(GETUTCDATE() AS date))) AS cbm_inspections_last_30_days,
  (SELECT COUNT(*) FROM dbo.v_cbm_latest_grade g WHERE g.[rig] = r.[rig] AND g.[grade] IN ('4','5')) AS cbm_latest_grade_4_or_5,
  (SELECT COUNT(*) FROM dbo.aab_status a WHERE a.[rig] = r.[rig] AND a.[state] NOT IN ('acknowledged','closed')) AS aab_outstanding,
  (SELECT COUNT(*) FROM dbo.precharge_requests p WHERE p.[rig] = r.[rig] AND ISNULL(p.[status],'') <> 'issued') AS precharge_open,
  (SELECT COUNT(*) FROM dbo.help_requests h WHERE h.[rig] = r.[rig] AND h.[state] = 'open') AS help_open
FROM rigs r;
GO

-- 3. Rig by report type: how often each kind of report is being posted.
CREATE OR ALTER VIEW dbo.v_status_reports AS
SELECT [rig], [reporttype],
  COUNT(*) AS posts_total,
  SUM(CASE WHEN TRY_CONVERT(date, COALESCE(NULLIF([reportDate],''), [date])) >= DATEADD(day, -7,  CAST(GETUTCDATE() AS date)) THEN 1 ELSE 0 END) AS posts_last_7_days,
  SUM(CASE WHEN TRY_CONVERT(date, COALESCE(NULLIF([reportDate],''), [date])) >= DATEADD(day, -30, CAST(GETUTCDATE() AS date)) THEN 1 ELSE 0 END) AS posts_last_30_days,
  MAX(TRY_CONVERT(date, COALESCE(NULLIF([reportDate],''), [date]))) AS last_report_date
FROM dbo.reports
GROUP BY [rig], [reporttype];
GO

-- 4. Daily checks by rig and day for the last fourteen days: were both shifts done, and how many readings need a look.
CREATE OR ALTER VIEW dbo.v_status_daily_checks AS
SELECT [rig], TRY_CONVERT(date, [date]) AS check_date,
  COUNT(DISTINCT CASE WHEN [shift] = 'Day'   THEN [file] END) AS day_rounds,
  COUNT(DISTINCT CASE WHEN [shift] = 'Night' THEN [file] END) AS night_rounds,
  COUNT(DISTINCT CASE WHEN [kind] = 'FLM'    THEN [file] END) AS flm_rounds,
  SUM(CASE WHEN [pass] = 'false' OR ISNULL([comment],'') <> '' THEN 1 ELSE 0 END) AS readings_needing_attention
FROM dbo.rig_checks
WHERE TRY_CONVERT(date, [date]) >= DATEADD(day, -14, CAST(GETUTCDATE() AS date))
GROUP BY [rig], TRY_CONVERT(date, [date]);
GO

-- Check: the one-page answer.
SELECT loop_name, total, done, open_items, percent_done, last_activity FROM dbo.v_status_loops ORDER BY sort_order;
