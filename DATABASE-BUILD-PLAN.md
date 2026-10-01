# The database, built without IT — the order of work from 1 October 2026

**Owner:** Dan · **Engine:** the Fabric SQL database `SACRED DATA` in Dan's workspace (an Azure SQL database, created
1 October on the Fabric trial; the 13 September one was a test) · **Design on record:** timeline reply §1.1, §4, §12 and the tools session's
§7 (relational core, raw payload kept, long-and-narrow readings, the scanner's reading-key convention, one
definition of `needs_attention`, Azure SQL for the no-install scanner) · **Plan items:** 39 (this), 22 of the
programme chart (M3, M6, M9, M10).

## What "no IT" is true of, and what it is not

| Needs nobody outside Technical Services | Still needs one ask, later |
|---|---|
| The normalised export from the scanner (built: v2.75) | A paid Fabric capacity before the trial ends about 12 November: a licence line on Lee's cost centre, not provisioning |
| The tables and views (DDL below, pasted into the query editor) | An Entra app registration for the scanner to write directly to the database (phase 2); not needed while Fabric pulls the files |
| Loading: Fabric reads the export files from SharePoint on a schedule, no secret, no install | Serving the dashboard pages from the database (phase 3) needs an authenticated API or Power BI; a decision, not a provisioning ask |
| Proof: row counts against the dashboard's own data | The security review covers the database when it exists (ORR 16) |

## Phase 1, this week: files in, tables loaded, counts proven

### 1. The export (done, scanner v2.75)

Every full scan writes one UTF-8 CSV per table into a folder named by `databaseExportPath` in config.json, plus
`export_manifest.json` with the schema version and the row count per table. The rows are the dashboard's own
(`reports-data.js`) flattened: nested lists of objects become child tables named `parent__property` carrying the
parent's key columns; nested objects become `property_field` columns; lists of values are joined with `; `.
Seventeen tables today:

`reports`, `reports__criticalItems`, `reports__actionItems`, `daily_log_entries`, `r53_events`, `cbm_grades`,
`rig_checks` (the readings, one row per reading, key split on the first `__` as the scanner has always done),
`marine_scores`, `topset_investigations`, `compliance_checklists`, `oem_copies`, `aab_records`, `aab_acks`,
`aab_status`, `aab_status__ackList`, `help_requests`, `problems`.

**v2 (scanner v2.76, 1 Oct, Dan: "what about precharges? all of our acknowledges and requests?"):** the outputs
with their own data files are in too: `precharge_requests` (the inbox index: every request, its status new or
issued, resubmitted or not), `precharge_issued` (every issued sheet by rig, well and stack, with its time; the
sheets themselves are rows in `reports`), `help_acks` (the Help Centre's acknowledge, update and close records),
`ssce_requests` (and their decisions), `bwm_snapshots` (the BOP planning snapshots, with child tables for their
rows). The export now runs at the end of the scan so every output is in it. DDL for the new tables:
`database/ddl-v2-add.sql`, run once after `ddl-v1.sql`. Schema 2 in the manifest.

**Install on Dan's PC (one line in config.json, then one scan):**

1. Make a folder `DatabaseExport` inside the Digests library on the WellControl site, beside `Reports`, so it
   syncs like the digests do.
2. In `C:\TSC-Dashboard\config.json` add, inside the braces, after the `"digestPath"` line:
   `"databaseExportPath": "C:\\Users\\danplant\\Seadrill\\WellControl - Digests\\DatabaseExport",`
3. Run the scanner once. Expect a cyan line `Database export: 17 table(s), N row(s), schema 1 to …`.
4. Open the folder: seventeen `export_*.csv` files and `export_manifest.json`. They refresh on every full scan.

### 2. The tables (fifteen minutes)

1. Fabric: open the WCE workspace, open the SQL database, click **Query** (the T-SQL query editor).
2. Paste the whole of `database/ddl-v1.sql`, run it. It creates seventeen tables (guarded, re-runnable) and five
   views: `v_rig_checks_attention` (the one definition of needs_attention: `pass = 'false' OR comment <> ''`),
   `v_cbm_latest_grade`, `v_reports_by_rig`, `v_aab_open`, `v_help_open`.
3. Refresh the object explorer: the tables appear under `dbo`.

### 3. Loading, by Fabric, on a schedule (an hour, once)

Fabric's **Dataflow Gen2** reads a SharePoint folder and writes a SQL table; no code, no secret, it runs under
Dan's own sign-in and can be scheduled. One dataflow, one query per CSV:

1. Workspace, **+ New item**, **Dataflow Gen2**. Name it `SACRED export load`.
2. **Get data**, choose **SharePoint folder**. Site URL: the WellControl site URL (the part before `/Shared
   Documents` or the library name). Sign in with your account when asked.
3. In the navigator, **Combine** is not what we want; choose **Transform data** so the file list appears.
   Filter the `Folder Path` column to the `DatabaseExport` folder.
4. For each `export_<table>.csv`: filter `Name` to that file, click the **Binary** in `Content`, and Fabric parses
   the CSV (first row as headers, UTF-8). Rename the query to the table name. Repeat per file (seventeen; the
   first one takes five minutes, the rest a minute each; a query can be duplicated and the file name changed).
5. For each query, **Add data destination**, choose **SQL database** (the Fabric SQL database), pick the matching
   table, mapping **Replace** (the export is a full snapshot every scan, so replace is the correct load; nothing
   is lost because the files are the system of record), and **Automatic settings** off so the column mapping is
   explicit. Match the columns by name.
6. **Publish**. Then on the dataflow, **Settings**, **Refresh**, schedule **hourly**. The scanner writes every
   ten minutes; an hourly load is enough for the proof and can be tightened later.

If the "SharePoint folder" connector will not list the library (it needs the library to be a document library,
which Digests is), the fallback is the **OneLake** route: a Lakehouse in the workspace with a shortcut to the
same folder, and the dataflow reads from the Lakehouse. Same result, one more item.

### 4. Proof (ten minutes, then daily until the dual run)

In the query editor:

```sql
SELECT 'reports' AS t, COUNT(*) AS n FROM dbo.reports
UNION ALL SELECT 'rig_checks', COUNT(*) FROM dbo.rig_checks
UNION ALL SELECT 'cbm_grades', COUNT(*) FROM dbo.cbm_grades
UNION ALL SELECT 'aab_status', COUNT(*) FROM dbo.aab_status
UNION ALL SELECT 'help_requests', COUNT(*) FROM dbo.help_requests;
```

The numbers must equal the `rows` in `export_manifest.json` and the counts the scan prints. Then the first real
question the dashboard cannot answer today:

```sql
SELECT rig, class, itemKey, task, grade, [date] FROM dbo.v_cbm_latest_grade WHERE grade IN ('4','5') ORDER BY rig, class, itemKey;
```

Milestone M3 (reading keys agreed) is met by the export itself: the keys are the scanner's, there is no second
parser. Milestone M6 (loader dry runs over the full history) is met the day step 4's counts match on the
production export.

## Phase 2, October to November: the database as a source

- **Ask SACRED AI on the database.** Point a Fabric Data agent, or Copilot Studio through the SQL connector, at
  the tables; the digests keep carrying the agent until that answers as well as they do.
- **Power BI** on the views for the fleet questions: grade history per component, open critical items by rig,
  reports per week. These are the trend views the static dashboards do not attempt.
- **Scanner dual-write** (M9, brought forward from January): the scanner writes rows directly with
  `System.Data.SqlClient` (built into Windows, no install) using an Entra token. That needs an app registration:
  the one small ask, raised when phase 1 is proven, not before. Until then the file load is the dual run.

## Phase 3, early 2027: the pages fed from the database (M10)

The dashboards are static pages on an intranet web server. For a page to read the database it needs an
authenticated path: the Fabric GraphQL API with Entra sign-in in the browser, or Power BI reports embedded in
the SharePoint site. That is a decision for after the parity window, with the file pipeline kept as the
fallback, exactly as the chart says. It is not a provisioning ask.

## The honest limits

- The trial ends about 12 November. Nothing on it is production until a capacity is attached (Lee, cost centre).
- Replace-load every hour is right for a snapshot of this size (hundreds of rows per table, thousands at most
  for readings). When `rig_checks` passes a few hundred thousand rows, the load becomes incremental by `file`.
- The raw payload (every report's JSON verbatim) is not in the v1 export; the files in PostedReports are that
  record, and the `file` column on every table points at them.
