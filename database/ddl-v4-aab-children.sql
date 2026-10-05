-- ddl-v4-aab-children.sql  (5 October 2026, scanner v2.78)
-- Two child tables the export now writes, because a list is kept as a list on every PowerShell version:
--   aab_records__attachments  one row per document attached to an AAB revision (was flattened onto aab_records)
--   aab_records__sfi          one row per SFI group ticked on an AAB revision (was flattened onto aab_records)
-- marine_scores__items is also written now; Marine Integrity is retired, so it has no table and no query.
-- Guarded and re-runnable. Paste the whole script into a New Query in SACRED DATA, Run.

IF OBJECT_ID('dbo.aab_records__attachments','U') IS NULL
CREATE TABLE dbo.[aab_records__attachments] (
    [aabNumber] NVARCHAR(200) NULL,
    [revision]  INT NULL,
    [name]      NVARCHAR(MAX) NULL,
    [type]      NVARCHAR(400) NULL,
    [bytes]     BIGINT NULL,
    [primary]   NVARCHAR(20) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_aab_records__attachments_aab')
CREATE INDEX [IX_aab_records__attachments_aab] ON dbo.[aab_records__attachments] ([aabNumber], [revision]);
GO

IF OBJECT_ID('dbo.aab_records__sfi','U') IS NULL
CREATE TABLE dbo.[aab_records__sfi] (
    [aabNumber] NVARCHAR(200) NULL,
    [revision]  INT NULL,
    [group]     NVARCHAR(20) NULL,
    [code]      NVARCHAR(40) NULL,
    [name]      NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_aab_records__sfi_aab')
CREATE INDEX [IX_aab_records__sfi_aab] ON dbo.[aab_records__sfi] ([aabNumber], [revision]);
GO
