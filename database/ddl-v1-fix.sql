-- Fix after the first DDL run on SACRED DATA, 1 Oct 2026: the two child tables that refused a long text column in their key. Run once.

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
