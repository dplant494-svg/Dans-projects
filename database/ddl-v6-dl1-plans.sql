-- SACRED DATA, schema v2 additions for DL-1 (scanner v2.88, 12 Oct 2026): the BOP Schedule Builder's plan records.
-- Run once on SACRED DATA after ddl-v2-add. Every column NVARCHAR as the other tables (the dataflow types the few numbers it needs); test posts are never exported.

IF OBJECT_ID('dbo.plans','U') IS NULL
CREATE TABLE dbo.[plans] (
    [planId] NVARCHAR(200) NOT NULL,
    [scopeVersion] NVARCHAR(200) NOT NULL,
    [status] NVARCHAR(400) NULL,
    [rig] NVARCHAR(400) NULL,
    [rigKey] NVARCHAR(400) NULL,
    [bopNo] NVARCHAR(400) NULL,
    [windowFrom] NVARCHAR(400) NULL,
    [windowTo] NVARCHAR(400) NULL,
    [createdBy] NVARCHAR(400) NULL,
    [frozenAt] NVARCHAR(400) NULL,
    [frozenBy] NVARCHAR(400) NULL,
    [changeReason] NVARCHAR(MAX) NULL,
    [totalTasks] NVARCHAR(400) NULL,
    [totalMaintenance] NVARCHAR(400) NULL,
    [totalHours] NVARCHAR(400) NULL,
    [criticalTasks] NVARCHAR(400) NULL,
    [scopeCoveragePct] NVARCHAR(400) NULL,
    [deferredCount] NVARCHAR(400) NULL,
    [taskCount] NVARCHAR(400) NULL,
    [milestoneCount] NVARCHAR(400) NULL,
    [synergiCount] NVARCHAR(400) NULL,
    [rev] NVARCHAR(400) NULL,
    [posted] NVARCHAR(400) NULL,
    [file] NVARCHAR(400) NULL,
    [dryRun] NVARCHAR(400) NULL,
    [isTest] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_plans_plan] ON dbo.[plans] ([planId], [scopeVersion]);
GO

IF OBJECT_ID('dbo.plan_versions','U') IS NULL
CREATE TABLE dbo.[plan_versions] (
    [planId] NVARCHAR(200) NOT NULL,
    [scopeVersion] NVARCHAR(200) NOT NULL,
    [status] NVARCHAR(400) NULL,
    [rig] NVARCHAR(400) NULL,
    [rigKey] NVARCHAR(400) NULL,
    [bopNo] NVARCHAR(400) NULL,
    [posted] NVARCHAR(400) NULL,
    [file] NVARCHAR(400) NULL,
    [isTest] NVARCHAR(400) NULL,
    [changeReason] NVARCHAR(MAX) NULL,
    [frozenAt] NVARCHAR(400) NULL,
    [taskCount] NVARCHAR(400) NULL,
    [deferredCount] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_plan_versions_plan] ON dbo.[plan_versions] ([planId], [scopeVersion]);
GO

IF OBJECT_ID('dbo.plan_tasks','U') IS NULL
CREATE TABLE dbo.[plan_tasks] (
    [planId] NVARCHAR(200) NOT NULL,
    [scopeVersion] NVARCHAR(200) NOT NULL,
    [taskId] NVARCHAR(200) NOT NULL,
    [seq] NVARCHAR(400) NULL,
    [type] NVARCHAR(400) NULL,
    [branch] NVARCHAR(400) NULL,
    [group] NVARCHAR(400) NULL,
    [sfi] NVARCHAR(400) NULL,
    [location] NVARCHAR(400) NULL,
    [jobPlan] NVARCHAR(400) NULL,
    [woNum] NVARCHAR(400) NULL,
    [pm] NVARCHAR(400) NULL,
    [description] NVARCHAR(MAX) NULL,
    [plannedStart] NVARCHAR(400) NULL,
    [plannedEnd] NVARCHAR(400) NULL,
    [durationHrs] NVARCHAR(400) NULL,
    [techs] NVARCHAR(400) NULL,
    [predecessors] NVARCHAR(MAX) NULL,
    [critical] NVARCHAR(400) NULL,
    [floatHrs] NVARCHAR(400) NULL,
    [dueDate] NVARCHAR(400) NULL,
    [woStatus] NVARCHAR(400) NULL,
    [crew] NVARCHAR(400) NULL,
    [status] NVARCHAR(400) NULL,
    [hubCode] NVARCHAR(400) NULL,
    [hubOpEvent] NVARCHAR(400) NULL,
    [hubAlert] NVARCHAR(400) NULL,
    [hubHse] NVARCHAR(400) NULL,
    [hubMoc] NVARCHAR(400) NULL,
    [hubTb] NVARCHAR(400) NULL,
    [hubTr] NVARCHAR(400) NULL,
    [hubTp] NVARCHAR(400) NULL,
    [hubIr] NVARCHAR(400) NULL,
    [hubAab] NVARCHAR(400) NULL,
    [hubNptHrs] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_plan_tasks_plan] ON dbo.[plan_tasks] ([planId], [scopeVersion]);
GO

IF OBJECT_ID('dbo.plan_milestones','U') IS NULL
CREATE TABLE dbo.[plan_milestones] (
    [planId] NVARCHAR(200) NOT NULL,
    [scopeVersion] NVARCHAR(200) NOT NULL,
    [taskId] NVARCHAR(200) NOT NULL,
    [name] NVARCHAR(400) NULL,
    [baseline] NVARCHAR(400) NULL,
    [est] NVARCHAR(400) NULL,
    [actual] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_plan_milestones_plan] ON dbo.[plan_milestones] ([planId], [scopeVersion]);
GO

IF OBJECT_ID('dbo.plan_deferrals','U') IS NULL
CREATE TABLE dbo.[plan_deferrals] (
    [planId] NVARCHAR(200) NOT NULL,
    [scopeVersion] NVARCHAR(200) NOT NULL,
    [taskId] NVARCHAR(200) NOT NULL,
    [sfi] NVARCHAR(400) NULL,
    [location] NVARCHAR(400) NULL,
    [jobPlan] NVARCHAR(400) NULL,
    [woNum] NVARCHAR(400) NULL,
    [pm] NVARCHAR(400) NULL,
    [description] NVARCHAR(MAX) NULL,
    [dueDate] NVARCHAR(400) NULL,
    [reason] NVARCHAR(MAX) NULL,
    [deferredBy] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_plan_deferrals_plan] ON dbo.[plan_deferrals] ([planId], [scopeVersion]);
GO

IF OBJECT_ID('dbo.plan_synergi','U') IS NULL
CREATE TABLE dbo.[plan_synergi] (
    [planId] NVARCHAR(200) NOT NULL,
    [scopeVersion] NVARCHAR(200) NOT NULL,
    [ref] NVARCHAR(200) NOT NULL,
    [source] NVARCHAR(400) NULL,
    [title] NVARCHAR(MAX) NULL,
    [kind] NVARCHAR(400) NULL,
    [matchedOn] NVARCHAR(400) NULL,
    [linkedTaskIds] NVARCHAR(MAX) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_plan_synergi_plan] ON dbo.[plan_synergi] ([planId], [scopeVersion]);
GO

IF OBJECT_ID('dbo.plan_progress','U') IS NULL
CREATE TABLE dbo.[plan_progress] (
    [planId] NVARCHAR(200) NOT NULL,
    [scopeVersion] NVARCHAR(200) NOT NULL,
    [asOf] NVARCHAR(200) NOT NULL,
    [taskId] NVARCHAR(200) NOT NULL,
    [pct] NVARCHAR(400) NULL,
    [status] NVARCHAR(400) NULL,
    [note] NVARCHAR(MAX) NULL,
    [actualStart] NVARCHAR(400) NULL,
    [actualEnd] NVARCHAR(400) NULL,
    [actualHrs] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_plan_progress_plan] ON dbo.[plan_progress] ([planId], [scopeVersion]);
GO

IF OBJECT_ID('dbo.plan_evidence','U') IS NULL
CREATE TABLE dbo.[plan_evidence] (
    [planId] NVARCHAR(200) NOT NULL,
    [scopeVersion] NVARCHAR(400) NULL,
    [taskId] NVARCHAR(400) NULL,
    [asOf] NVARCHAR(400) NULL,
    [fileCount] NVARCHAR(400) NULL,
    [fileNames] NVARCHAR(MAX) NULL,
    [bytes] NVARCHAR(400) NULL,
    [posted] NVARCHAR(400) NULL,
    [file] NVARCHAR(200) NOT NULL,
    [isTest] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_plan_evidence_plan] ON dbo.[plan_evidence] ([planId], [scopeVersion]);
GO

-- The latest scope version per plan, the newest progress snapshot, and the plan with its percent complete.
CREATE OR ALTER VIEW dbo.v_plan_latest AS
SELECT p.* FROM dbo.plans p
JOIN (SELECT planId, MAX(CAST(scopeVersion AS INT)) AS v FROM dbo.plans GROUP BY planId) m ON m.planId = p.planId AND CAST(p.scopeVersion AS INT) = m.v;
GO
CREATE OR ALTER VIEW dbo.v_plan_progress_latest AS
SELECT g.* FROM dbo.plan_progress g
JOIN (SELECT planId, MAX(asOf) AS asOf FROM dbo.plan_progress GROUP BY planId) m ON m.planId = g.planId AND g.asOf = m.asOf;
GO
CREATE OR ALTER VIEW dbo.v_plan_pct AS
SELECT l.planId, l.rig, l.bopNo, l.status, l.scopeVersion, pr.asOf,
       COUNT(*) AS tasks,
       SUM(CASE WHEN TRY_CAST(pr.pct AS FLOAT) >= 100 THEN 1 ELSE 0 END) AS complete,
       ROUND(100.0 * SUM(COALESCE(TRY_CAST(t.durationHrs AS FLOAT), 1) * COALESCE(TRY_CAST(pr.pct AS FLOAT), 0) / 100.0)
             / NULLIF(SUM(COALESCE(TRY_CAST(t.durationHrs AS FLOAT), 1)), 0), 1) AS pctComplete
FROM dbo.v_plan_latest l
JOIN dbo.v_plan_progress_latest pr ON pr.planId = l.planId
LEFT JOIN dbo.plan_tasks t ON t.planId = pr.planId AND t.scopeVersion = l.scopeVersion AND t.taskId = pr.taskId
GROUP BY l.planId, l.rig, l.bopNo, l.status, l.scopeVersion, pr.asOf;
GO

-- v2.89 (12 Oct 2026): the live plan-link records (link, don't copy): which SSORT post joins which plan task.
-- Exported as export_plan_links.csv, key linkId; an unlinked record is dropped from the export, so a load with Replace removes it.
IF OBJECT_ID('dbo.plan_links','U') IS NULL
CREATE TABLE dbo.[plan_links] (
    [linkId] NVARCHAR(200) NOT NULL,
    [planId] NVARCHAR(200) NULL,
    [taskId] NVARCHAR(400) NULL,
    [taskName] NVARCHAR(MAX) NULL,
    [section] NVARCHAR(400) NULL,
    [action] NVARCHAR(400) NULL,
    [sourceFile] NVARCHAR(400) NULL,
    [sourceType] NVARCHAR(400) NULL,
    [testType] NVARCHAR(400) NULL,
    [sourceDate] NVARCHAR(400) NULL,
    [rig] NVARCHAR(400) NULL,
    [rigKey] NVARCHAR(400) NULL,
    [by] NVARCHAR(400) NULL,
    [rev] NVARCHAR(400) NULL,
    [saved] NVARCHAR(400) NULL,
    [file] NVARCHAR(400) NULL,
    CONSTRAINT PK_plan_links PRIMARY KEY ([linkId])
);
GO
CREATE INDEX [IX_plan_links_plan] ON dbo.[plan_links] ([planId], [taskId]);
GO

-- v2.90 (13 Oct 2026): the reviewers' verdicts from the Help Centre's Plans tab, one row per reviewer per scope version
-- (the newest wins in the export). Exported as export_plan_reviews.csv; test reviews are never exported.
IF OBJECT_ID('dbo.plan_reviews','U') IS NULL
CREATE TABLE dbo.[plan_reviews] (
    [planId] NVARCHAR(200) NOT NULL,
    [scopeVersion] NVARCHAR(200) NOT NULL,
    [email] NVARCHAR(400) NOT NULL,
    [reviewer] NVARCHAR(400) NULL,
    [position] NVARCHAR(400) NULL,
    [section] NVARCHAR(400) NULL,
    [decision] NVARCHAR(400) NULL,
    [comment] NVARCHAR(MAX) NULL,
    [at] NVARCHAR(400) NULL,
    [saved] NVARCHAR(400) NULL,
    [rig] NVARCHAR(400) NULL,
    [rigKey] NVARCHAR(400) NULL,
    [rev] NVARCHAR(400) NULL,
    [file] NVARCHAR(400) NULL,
    [isTest] NVARCHAR(400) NULL,
    CONSTRAINT PK_plan_reviews PRIMARY KEY ([planId], [scopeVersion], [email])
);
GO
