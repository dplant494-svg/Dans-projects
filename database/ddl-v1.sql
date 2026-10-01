-- SACRED database, schema v1: one table per export CSV written by Update-Dashboard.ps1 v2.75 (export_manifest.json).
-- Target: Fabric SQL database (Azure SQL). Paste into the query editor and run once. Re-runnable: each CREATE is guarded.
-- Columns are NVARCHAR by default; counts are INT; dates stay ISO text in v1 (cast in views). Keys follow the scanner's own identity rules.
-- v1.1 (1 Oct, after the first run on SACRED DATA): key columns are NVARCHAR(200) so no key passes 900 bytes; child tables and the daily log carry an index, not a primary key.

IF OBJECT_ID('dbo.aab_acks','U') IS NULL
CREATE TABLE dbo.[aab_acks] (
    [file] NVARCHAR(200) NOT NULL,
    [modified] NVARCHAR(400) NULL,
    [aabNumber] NVARCHAR(400) NULL,
    [revision] INT NULL,
    [rigKey] NVARCHAR(400) NULL,
    [rig] NVARCHAR(400) NULL,
    [action] NVARCHAR(400) NULL,
    [by] NVARCHAR(400) NULL,
    [role] NVARCHAR(400) NULL,
    [crew] NVARCHAR(400) NULL,
    [at] NVARCHAR(400) NULL,
    [comment] NVARCHAR(MAX) NULL,
    [photoCount] INT NULL,
    [attachmentCount] INT NULL,
    [attachmentNames] NVARCHAR(MAX) NULL,
    [saved] NVARCHAR(400) NULL,
    [rev] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_aab_acks] PRIMARY KEY ([file])
);
GO

IF OBJECT_ID('dbo.aab_records','U') IS NULL
CREATE TABLE dbo.[aab_records] (
    [file] NVARCHAR(400) NULL,
    [modified] NVARCHAR(400) NULL,
    [aabNumber] NVARCHAR(200) NOT NULL,
    [revision] INT NOT NULL,
    [recordId] NVARCHAR(400) NULL,
    [schemaVersion] NVARCHAR(400) NULL,
    [toolVersion] NVARCHAR(400) NULL,
    [rev] NVARCHAR(400) NULL,
    [title] NVARCHAR(MAX) NULL,
    [priority] NVARCHAR(400) NULL,
    [corporateMandatory] NVARCHAR(400) NULL,
    [edocsRef] NVARCHAR(400) NULL,
    [maximoParent] NVARCHAR(400) NULL,
    [actionRequested] NVARCHAR(MAX) NULL,
    [category] NVARCHAR(400) NULL,
    [sfi_group] NVARCHAR(400) NULL,
    [sfi_code] NVARCHAR(400) NULL,
    [sfi_name] NVARCHAR(400) NULL,
    [issueDate] NVARCHAR(400) NULL,
    [dueDate] NVARCHAR(400) NULL,
    [requiresReacknowledgement] NVARCHAR(400) NULL,
    [originatorName] NVARCHAR(400) NULL,
    [originatorEmail] NVARCHAR(400) NULL,
    [whatHappened] NVARCHAR(MAX) NULL,
    [whyItMatters] NVARCHAR(400) NULL,
    [requiredAction] NVARCHAR(400) NULL,
    [referenceDocuments] NVARCHAR(400) NULL,
    [attachments_name] NVARCHAR(400) NULL,
    [attachments_type] NVARCHAR(400) NULL,
    [attachments_bytes] NVARCHAR(400) NULL,
    [attachments_primary] NVARCHAR(400) NULL,
    [photoCount] INT NULL,
    [photoCaptions] NVARCHAR(400) NULL,
    [rigsApplicable] NVARCHAR(400) NULL,
    [rigNames_vela] NVARCHAR(400) NULL,
    [rigNames_capella] NVARCHAR(400) NULL,
    [expectedAcknowledgerRole] NVARCHAR(400) NULL,
    [status] NVARCHAR(400) NULL,
    [postedAt] NVARCHAR(400) NULL,
    [postedBy] NVARCHAR(400) NULL,
    [pdfName] NVARCHAR(400) NULL,
    [hasPdf] NVARCHAR(400) NULL,
    [current] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_aab_records] PRIMARY KEY ([aabNumber], [revision])
);
GO

IF OBJECT_ID('dbo.aab_status','U') IS NULL
CREATE TABLE dbo.[aab_status] (
    [aabNumber] NVARCHAR(200) NOT NULL,
    [revision] INT NOT NULL,
    [title] NVARCHAR(MAX) NULL,
    [rigKey] NVARCHAR(200) NOT NULL,
    [rig] NVARCHAR(400) NULL,
    [issueDate] NVARCHAR(400) NULL,
    [dueDate] NVARCHAR(400) NULL,
    [actionRequested] NVARCHAR(MAX) NULL,
    [state] NVARCHAR(400) NULL,
    [overdue] NVARCHAR(400) NULL,
    [status] NVARCHAR(400) NULL,
    [daysOverdue] INT NULL,
    [ackCrews] NVARCHAR(400) NULL,
    [acknowledgedAt] NVARCHAR(400) NULL,
    [acknowledgedBy] NVARCHAR(400) NULL,
    [evidenceCount] INT NULL,
    [evidenceMissing] NVARCHAR(400) NULL,
    [closedAt] NVARCHAR(400) NULL,
    [closedBy] NVARCHAR(400) NULL,
    [historyCount] INT NULL,
    [ackList_action] NVARCHAR(400) NULL,
    [ackList_crew] NVARCHAR(400) NULL,
    [ackList_at] NVARCHAR(400) NULL,
    [ackList_by] NVARCHAR(400) NULL,
    [ackList_role] NVARCHAR(400) NULL,
    [ackList_photos] NVARCHAR(400) NULL,
    [ackList_documents] NVARCHAR(400) NULL,
    [ackList_comment] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_aab_status] PRIMARY KEY ([aabNumber], [revision], [rigKey])
);
GO

IF OBJECT_ID('dbo.aab_status__ackList','U') IS NULL
CREATE TABLE dbo.[aab_status__ackList] (
    [aabNumber] NVARCHAR(400) NULL,
    [revision] INT NULL,
    [rigKey] NVARCHAR(400) NULL,
    [action] NVARCHAR(400) NULL,
    [crew] NVARCHAR(400) NULL,
    [at] NVARCHAR(400) NULL,
    [by] NVARCHAR(400) NULL,
    [role] NVARCHAR(400) NULL,
    [photos] INT NULL,
    [documents] NVARCHAR(400) NULL,
    [comment] NVARCHAR(MAX) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_aab_status__ackList_aabNumber] ON dbo.[aab_status__ackList] ([aabNumber]);
GO
IF OBJECT_ID('dbo.cbm_grades','U') IS NULL
CREATE TABLE dbo.[cbm_grades] (
    [rig] NVARCHAR(400) NULL,
    [class] NVARCHAR(400) NULL,
    [equip] NVARCHAR(400) NULL,
    [itemKey] NVARCHAR(200) NOT NULL,
    [itemLabel] NVARCHAR(400) NULL,
    [itemShape] NVARCHAR(400) NULL,
    [sortKey] NVARCHAR(400) NULL,
    [task] NVARCHAR(MAX) NULL,
    [grade] NVARCHAR(400) NULL,
    [comment] NVARCHAR(MAX) NULL,
    [photos] INT NULL,
    [date] NVARCHAR(400) NULL,
    [file] NVARCHAR(200) NOT NULL,
    [rev] NVARCHAR(400) NULL,
    [era] NVARCHAR(400) NULL,
    [postedKey] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_cbm_grades] PRIMARY KEY ([file], [itemKey])
);
GO

IF OBJECT_ID('dbo.compliance_checklists','U') IS NULL
CREATE TABLE dbo.[compliance_checklists] (
    [rig] NVARCHAR(400) NULL,
    [date] NVARCHAR(400) NULL,
    [file] NVARCHAR(200) NOT NULL,
    [section] NVARCHAR(400) NULL,
    [item] NVARCHAR(400) NULL,
    [status] NVARCHAR(400) NULL,
    [comment] NVARCHAR(MAX) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_compliance_checklists] PRIMARY KEY ([file])
);
GO

IF OBJECT_ID('dbo.daily_log_entries','U') IS NULL
CREATE TABLE dbo.[daily_log_entries] (
    [rig] NVARCHAR(400) NULL,
    [month] NVARCHAR(400) NULL,
    [date] NVARCHAR(400) NULL,
    [shift] NVARCHAR(400) NULL,
    [personnel] NVARCHAR(400) NULL,
    [equip] NVARCHAR(400) NULL,
    [failure] NVARCHAR(400) NULL,
    [lesson] NVARCHAR(400) NULL,
    [note] NVARCHAR(400) NULL,
    [photos] INT NULL,
    [file] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_daily_log_entries_rig] ON dbo.[daily_log_entries] ([rig]);
GO
IF OBJECT_ID('dbo.help_requests','U') IS NULL
CREATE TABLE dbo.[help_requests] (
    [requestId] NVARCHAR(200) NOT NULL,
    [rigKey] NVARCHAR(400) NULL,
    [rig] NVARCHAR(400) NULL,
    [subject] NVARCHAR(MAX) NULL,
    [notifyKind] NVARCHAR(400) NULL,
    [rigDown] NVARCHAR(400) NULL,
    [hoursDown] INT NULL,
    [occurredAt] NVARCHAR(400) NULL,
    [hoursSince] NVARCHAR(400) NULL,
    [synergiCase] NVARCHAR(400) NULL,
    [state] NVARCHAR(400) NULL,
    [postedAt] NVARCHAR(400) NULL,
    [by] NVARCHAR(400) NULL,
    [rev] NVARCHAR(400) NULL,
    [dryRun] NVARCHAR(400) NULL,
    [ackCount] INT NULL,
    [lastAction] NVARCHAR(400) NULL,
    [lastBy] NVARCHAR(400) NULL,
    [lastAt] NVARCHAR(400) NULL,
    [receiptState] NVARCHAR(400) NULL,
    [receipt] NVARCHAR(MAX) NULL,
    [directiveChat] NVARCHAR(400) NULL,
    [attachmentCount] INT NULL,
    [file] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_help_requests] PRIMARY KEY ([requestId])
);
GO

IF OBJECT_ID('dbo.marine_scores','U') IS NULL
CREATE TABLE dbo.[marine_scores] (
    [rig] NVARCHAR(400) NULL,
    [date] NVARCHAR(400) NULL,
    [file] NVARCHAR(200) NOT NULL,
    [item] NVARCHAR(400) NULL,
    [score] NVARCHAR(400) NULL,
    [comment] NVARCHAR(MAX) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_marine_scores] PRIMARY KEY ([file])
);
GO

IF OBJECT_ID('dbo.oem_copies','U') IS NULL
CREATE TABLE dbo.[oem_copies] (
    [file] NVARCHAR(200) NOT NULL,
    [rig] NVARCHAR(400) NULL,
    [date] NVARCHAR(400) NULL,
    [reporttype] NVARCHAR(400) NULL,
    [equipment] NVARCHAR(400) NULL,
    [sourceFile] NVARCHAR(400) NULL,
    [oem] NVARCHAR(400) NULL,
    [pdfName] NVARCHAR(400) NULL,
    [pdfBytes] INT NULL,
    [sourceFormat] NVARCHAR(400) NULL,
    [htmlName] NVARCHAR(400) NULL,
    [htmlBytes] INT NULL,
    [fileCount] INT NULL,
    [fileNames] NVARCHAR(MAX) NULL,
    [sent] NVARCHAR(400) NULL,
    [modified] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_oem_copies] PRIMARY KEY ([file])
);
GO

IF OBJECT_ID('dbo.problems','U') IS NULL
CREATE TABLE dbo.[problems] (
    [file] NVARCHAR(200) NOT NULL,
    [bytes] INT NULL,
    [why] NVARCHAR(MAX) NULL,
    [modified] NVARCHAR(400) NULL,
    [kind] NVARCHAR(200) NOT NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_problems] PRIMARY KEY ([file], [kind])
);
GO

IF OBJECT_ID('dbo.r53_events','U') IS NULL
CREATE TABLE dbo.[r53_events] (
    [rig] NVARCHAR(400) NULL,
    [date] NVARCHAR(400) NULL,
    [equip] NVARCHAR(400) NULL,
    [item] NVARCHAR(200) NOT NULL,
    [mfr] NVARCHAR(400) NULL,
    [model] NVARCHAR(400) NULL,
    [obsfailure] NVARCHAR(400) NULL,
    [malfunction] NVARCHAR(MAX) NULL,
    [rootcause] NVARCHAR(MAX) NULL,
    [findings] NVARCHAR(MAX) NULL,
    [lessons] NVARCHAR(MAX) NULL,
    [source] NVARCHAR(400) NULL,
    [file] NVARCHAR(200) NOT NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_r53_events] PRIMARY KEY ([file], [item])
);
GO

IF OBJECT_ID('dbo.reports','U') IS NULL
CREATE TABLE dbo.[reports] (
    [file] NVARCHAR(200) NOT NULL,
    [rig] NVARCHAR(400) NULL,
    [reporttype] NVARCHAR(400) NULL,
    [type] NVARCHAR(400) NULL,
    [discipline] NVARCHAR(400) NULL,
    [wce] NVARCHAR(400) NULL,
    [location] NVARCHAR(400) NULL,
    [schedule] NVARCHAR(400) NULL,
    [date] NVARCHAR(400) NULL,
    [reportDate] NVARCHAR(400) NULL,
    [dateEnd] NVARCHAR(400) NULL,
    [exportedAt] NVARCHAR(400) NULL,
    [rev] NVARCHAR(400) NULL,
    [modified] NVARCHAR(400) NULL,
    [tileCount] INT NULL,
    [attachments] INT NULL,
    [cbmEquipment] NVARCHAR(400) NULL,
    [criticalTotal] INT NULL,
    [criticalOpen] INT NULL,
    [actionsTotal] INT NULL,
    [actionsLeftWithRig] INT NULL,
    [criticalItems] NVARCHAR(400) NULL,
    [actionItems] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_reports] PRIMARY KEY ([file])
);
GO

IF OBJECT_ID('dbo.reports__actionItems','U') IS NULL
CREATE TABLE dbo.[reports__actionItems] (
    [file] NVARCHAR(400) NULL,
    [desc] NVARCHAR(MAX) NULL,
    [sys] NVARCHAR(400) NULL,
    [resp] NVARCHAR(400) NULL,
    [target] NVARCHAR(400) NULL,
    [deadline] NVARCHAR(400) NULL,
    [leftWithRig] NVARCHAR(400) NULL,
    [hasPhoto] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_reports__actionItems_file] ON dbo.[reports__actionItems] ([file]);
GO
IF OBJECT_ID('dbo.reports__criticalItems','U') IS NULL
CREATE TABLE dbo.[reports__criticalItems] (
    [file] NVARCHAR(400) NULL,
    [done] NVARCHAR(400) NULL,
    [equip] NVARCHAR(400) NULL,
    [sfi] NVARCHAR(400) NULL,
    [date] NVARCHAR(400) NULL,
    [issue] NVARCHAR(MAX) NULL,
    [mit] NVARCHAR(MAX) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_reports__criticalItems_file] ON dbo.[reports__criticalItems] ([file]);
GO
IF OBJECT_ID('dbo.rig_checks','U') IS NULL
CREATE TABLE dbo.[rig_checks] (
    [rig] NVARCHAR(400) NULL,
    [kind] NVARCHAR(400) NULL,
    [date] NVARCHAR(400) NULL,
    [shift] NVARCHAR(400) NULL,
    [by] NVARCHAR(400) NULL,
    [supervisor] NVARCHAR(400) NULL,
    [system] NVARCHAR(400) NULL,
    [item] NVARCHAR(400) NULL,
    [itemKey] NVARCHAR(200) NOT NULL,
    [value] NVARCHAR(400) NULL,
    [unit] NVARCHAR(400) NULL,
    [pass] NVARCHAR(400) NULL,
    [comment] NVARCHAR(MAX) NULL,
    [psi] NVARCHAR(400) NULL,
    [tp] NVARCHAR(400) NULL,
    [dp] NVARCHAR(400) NULL,
    [photos] INT NULL,
    [file] NVARCHAR(200) NOT NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_rig_checks] PRIMARY KEY ([file], [itemKey])
);
GO

IF OBJECT_ID('dbo.topset_investigations','U') IS NULL
CREATE TABLE dbo.[topset_investigations] (
    [rig] NVARCHAR(400) NULL,
    [date] NVARCHAR(400) NULL,
    [file] NVARCHAR(200) NOT NULL,
    [title] NVARCHAR(MAX) NULL,
    [status] NVARCHAR(400) NULL,
    [equipment] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_topset_investigations] PRIMARY KEY ([file])
);
GO

-- Views: the operational rules live here, once (timeline reply §4.2).
CREATE OR ALTER VIEW dbo.v_rig_checks_attention AS
SELECT *, CASE WHEN [pass] = 'false' OR ISNULL([comment],'') <> '' THEN 1 ELSE 0 END AS needs_attention
FROM dbo.rig_checks;
GO
CREATE OR ALTER VIEW dbo.v_cbm_latest_grade AS
SELECT g.* FROM dbo.cbm_grades g
JOIN (SELECT rig, class, equip, itemKey, MAX([date]) AS latest FROM dbo.cbm_grades GROUP BY rig, class, equip, itemKey) l
  ON l.rig = g.rig AND l.class = g.class AND l.equip = g.equip AND l.itemKey = g.itemKey AND l.latest = g.[date];
GO
CREATE OR ALTER VIEW dbo.v_reports_by_rig AS
SELECT rig, reporttype, COUNT(*) AS reports, MAX(reportDate) AS latest_report, SUM(criticalOpen) AS critical_open, SUM(actionsLeftWithRig) AS actions_left_with_rig
FROM dbo.reports GROUP BY rig, reporttype;
GO
CREATE OR ALTER VIEW dbo.v_aab_open AS
SELECT * FROM dbo.aab_status WHERE state NOT IN ('closed','withdrawn');
GO
CREATE OR ALTER VIEW dbo.v_help_open AS
SELECT * FROM dbo.help_requests WHERE state <> 'closed';
GO
