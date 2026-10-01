-- SACRED DATA, schema v2 additions (scanner v2.76, 1 Oct 2026): precharge requests and issued sheets, Help Centre records, SSCE requests, BWM planning snapshots. Run once after ddl-v1.

IF OBJECT_ID('dbo.bwm_snapshots','U') IS NULL
CREATE TABLE dbo.[bwm_snapshots] (
    [week] NVARCHAR(400) NULL,
    [bwm_week] NVARCHAR(400) NULL,
    [bwm_compiledBy] NVARCHAR(400) NULL,
    [bwm_reportDate] NVARCHAR(400) NULL,
    [bwm_rows] NVARCHAR(MAX) NULL,
    [reportDate] NVARCHAR(400) NULL,
    [file] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_bwm_snapshots_file] ON dbo.[bwm_snapshots] ([file]);
GO

IF OBJECT_ID('dbo.help_acks','U') IS NULL
CREATE TABLE dbo.[help_acks] (
    [file] NVARCHAR(200) NOT NULL,
    [modified] NVARCHAR(400) NULL,
    [requestId] NVARCHAR(400) NULL,
    [action] NVARCHAR(400) NULL,
    [by] NVARCHAR(400) NULL,
    [role] NVARCHAR(400) NULL,
    [at] NVARCHAR(400) NULL,
    [comment] NVARCHAR(MAX) NULL,
    [saved] NVARCHAR(400) NULL,
    [attachments] NVARCHAR(MAX) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_help_acks] PRIMARY KEY ([file])
);
GO

IF OBJECT_ID('dbo.precharge_issued','U') IS NULL
CREATE TABLE dbo.[precharge_issued] (
    [matchKey] NVARCHAR(200) NOT NULL,
    [bop] NVARCHAR(400) NULL,
    [saved] NVARCHAR(200) NOT NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_precharge_issued] PRIMARY KEY ([matchKey], [saved])
);
GO

IF OBJECT_ID('dbo.precharge_requests','U') IS NULL
CREATE TABLE dbo.[precharge_requests] (
    [id] NVARCHAR(200) NOT NULL,
    [rig] NVARCHAR(400) NULL,
    [rigKey] NVARCHAR(400) NULL,
    [well] NVARCHAR(400) NULL,
    [bop] NVARCHAR(400) NULL,
    [raisedBy] NVARCHAR(400) NULL,
    [email] NVARCHAR(400) NULL,
    [workOrder] NVARCHAR(400) NULL,
    [saved] NVARCHAR(400) NULL,
    [received] NVARCHAR(400) NULL,
    [shearReq] NVARCHAR(400) NULL,
    [mawhp] NVARCHAR(400) NULL,
    [waterDepth] NVARCHAR(400) NULL,
    [hops] NVARCHAR(400) NULL,
    [status] NVARCHAR(400) NULL,
    [resubmitted] NVARCHAR(400) NULL,
    [file] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [PK_precharge_requests] PRIMARY KEY ([id])
);
GO

IF OBJECT_ID('dbo.ssce_requests','U') IS NULL
CREATE TABLE dbo.[ssce_requests] (
    [requestId] NVARCHAR(400) NULL,
    [submittedAt] NVARCHAR(400) NULL,
    [file] NVARCHAR(400) NULL,
    [sourceItem_rig] NVARCHAR(400) NULL,
    [sourceItem_bop] NVARCHAR(400) NULL,
    [sourceItem_cat] NVARCHAR(400) NULL,
    [sourceItem_asset] NVARCHAR(400) NULL,
    [sourceItem_oem] NVARCHAR(400) NULL,
    [sourceItem_serial] NVARCHAR(400) NULL,
    [sourceItem_desc] NVARCHAR(400) NULL,
    [ssceItem_asset] NVARCHAR(400) NULL,
    [ssceItem_oem] NVARCHAR(400) NULL,
    [ssceItem_serial] NVARCHAR(400) NULL,
    [ssceItem_desc] NVARCHAR(400) NULL,
    [ssceItem_status] NVARCHAR(400) NULL,
    [applicant_requestOriginatorEmail] NVARCHAR(400) NULL,
    [applicant_priorityLevel] NVARCHAR(400) NULL,
    [applicant_siteUnit] NVARCHAR(400) NULL,
    [applicant_rigManagerContact] NVARCHAR(400) NULL,
    [applicant_rigOnDowntime] NVARCHAR(400) NULL,
    [applicant_planningOrExecuting] NVARCHAR(400) NULL,
    [requestedEquipment_dateRequired] NVARCHAR(400) NULL,
    [requestedEquipment_description] NVARCHAR(400) NULL,
    [requestedEquipment_partNumber] NVARCHAR(400) NULL,
    [requestedEquipment_serialNumber] NVARCHAR(400) NULL,
    [returningEquipment_date] NVARCHAR(400) NULL,
    [returningEquipment_description] NVARCHAR(400) NULL,
    [returningEquipment_partNumber] NVARCHAR(400) NULL,
    [returningEquipment_serialNumber] NVARCHAR(400) NULL,
    [afePo_afeNumber] NVARCHAR(400) NULL,
    [afePo_poNumber] NVARCHAR(400) NULL,
    [justification] NVARCHAR(MAX) NULL,
    [termsAcknowledged] NVARCHAR(400) NULL,
    [decision] NVARCHAR(400) NULL,
    [comment] NVARCHAR(MAX) NULL,
    [decidedBy] NVARCHAR(400) NULL,
    [decidedAt] NVARCHAR(400) NULL,
    [decisionFile] NVARCHAR(400) NULL,
    [loaded_at] DATETIME2 NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX [IX_ssce_requests_requestId] ON dbo.[ssce_requests] ([requestId]);
GO

CREATE OR ALTER VIEW dbo.v_precharge_open AS
SELECT * FROM dbo.precharge_requests WHERE status <> 'issued';
GO
