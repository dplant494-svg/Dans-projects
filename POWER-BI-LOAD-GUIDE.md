# SACRED data in Power BI Pro: load steps (week plan item 54)

**For:** Dan · **Written:** 17 Oct 2026 · **Time:** about 1 hour the first time · **Cost:** none. Your Power BI Pro comes with your Microsoft 365 E5 licence.

## Why this changed

Fabric is not an approved Seadrill platform (Janzen Small, ISIT, 17 Oct). So the data goes to Power BI Pro instead.

- **The source doesn't change.** The scanner keeps writing its export every hour: one CSV per table, plus `export_manifest.json`, in WellControl > **Digests** > **DatabaseExport**.
- **Power BI reads those files from SharePoint** and refreshes on a schedule.
- **Build nothing new on Fabric.** The Fabric trial, and the SACRED DATA database in it, lapse around 11 Nov, and nothing is lost.

---

## Part A: the workspace (2 min)

1. Go to **app.powerbi.com**, then **Workspaces**, then **+ New workspace**.
2. Fill it in:
   - **Name:** `SACRED – Well Control`
   - **Description:** `SACRED data and reports for Technical Services – Well Control`
   - **Workspace type:** **Power BI Pro**. Never pick PPU, which costs extra.
3. Click **Apply**.
4. Open **Manage access** and add:
   - Lee as **Admin**;
   - the Well Control Group 1 and 2 role accounts as **Member**, once Janzen has them;
   - readers as **Viewer**. Anyone who views needs Pro, which E5 includes.

## Part B: Power BI Desktop (10 min, once)

1. Install **Power BI Desktop** (free) from the **Microsoft Store**, or from **Company Portal** if the Store is blocked.
2. Open it and sign in with your Seadrill account (top right).

## Part C: connect to the export (15 min)

You make two helper queries once. Then each table is one line.

**C1. The file list**

1. **Home**, then **Get data**, then **Blank query**. The Power Query window opens.
2. **Home**, then **Advanced editor**. Delete everything in it and paste this, then click **Done**:

   ```
   let
       Source = SharePoint.Files("https://sdrl.sharepoint.com/sites/wellcontrol", [ApiVersion = 15]),
       Csvs = Table.SelectRows(Source, each Text.Contains([Folder Path], "DatabaseExport") and Text.EndsWith([Name], ".csv"))
   in
       Csvs
   ```

3. If it asks how to connect, choose **Organizational account**, then **Sign in**, then **Connect**.
4. On the right, under **Properties**, set **Name** to `ExportFiles`.
5. You should see a list of files named `export_….csv`.

**C2. The loader**

1. **Home**, then **New source**, then **Blank query**, then **Advanced editor**. Paste this and click **Done**:

   ```
   (name as text) as table =>
   let
       Match = Table.SelectRows(ExportFiles, each [Name] = "export_" & name & ".csv"),
       Raw = if Table.IsEmpty(Match) then #table({}, {}) else Csv.Document(Match{0}[Content], [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
       Out = if Table.RowCount(Raw) = 0 then #table({"file"}, {}) else Table.PromoteHeaders(Raw, [PromoteAllScalars = true])
   in
       Out
   ```

2. Name it `LoadExport`.
3. It copes with a file that's missing or empty: you get an empty table, not an error.

**C3. Stop the two helpers loading as tables**

Right-click `ExportFiles` in the left list and untick **Enable load**. Do the same for `LoadExport`.

## Part D: one query per table (about 1 min each)

For each table name below:

1. **New source**, then **Blank query**.
2. In the formula bar, type the line below, swapping in the table name, and press Enter:

   ```
   = LoadExport("cbm_grades")
   ```

3. Name the query exactly the table name, e.g. `cbm_grades`.

**Start with these six,** which answer most fleet questions:

`reports`, `cbm_grades`, `cbm_usage`, `rig_checks`, `oem_copies`, `aab_status`

**Then the rest, any time:**

`daily_log_entries`, `r53_events`, `pdc_rev9`, `compliance_checklists`, `topset_investigations`, `marine_scores`, `problems`, `aab_records`, `aab_acks`, `help_requests`, `help_acks`, `ssce_requests`, `precharge_requests`, `precharge_issued`, `bwm_snapshots`, `plans`, `plan_versions`, `plan_tasks`, `plan_milestones`, `plan_progress`, `plan_deferrals`, `plan_evidence`, `plan_links`, `plan_reviews`, `plan_synergi`

**Plus the child tables,** whose file names contain a double underscore, for example `reports__criticalItems`, `reports__actionItems` and `aab_status__ackList`. The full, current list of tables is in `export_manifest.json` in the same folder; that's what makes the 36.

**Then:** **Home**, then **Close & Apply**. Power BI loads every table.

> **Columns load as text.** That's deliberate: it avoids the empty-date problem we had on 6 Oct. Change a column's type only when a chart needs it. In Power Query, click the column header icon, then **Whole number** or **Date**, for things like `photos`, the counts, or `date`.

## Part E: link the tables (10 min)

**Model view** (the third icon on the left). Drag **`reports[file]`** onto **`file`** in each child table: `cbm_grades`, `cbm_usage`, `rig_checks`, `oem_copies`, `pdc_rev9`, `reports__criticalItems`, `reports__actionItems` and so on. Choose one-to-many, with `reports` on the one side.

For the plans, drag **`plans[planid]`** onto `planid` in each `plan_…` table.

## Part F: publish and schedule (10 min)

1. **File**, then **Save as** `SACRED Data.pbix`, saved in your OneDrive.
2. **Home**, then **Publish**, then **SACRED – Well Control**.
3. In app.powerbi.com, open the workspace and find the **SACRED Data** semantic model. Click **…** then **Settings**:
   - **Data source credentials**, then **Edit credentials**: **OAuth2**, privacy level **Organizational**, then **Sign in**.
   - **Refresh**: turn on **Scheduled refresh**, time zone **Central Time (US & Canada)**. Add up to **8 times**, e.g. 06:15, 08:15, 10:15, 12:15, 14:15, 16:15, 18:15 and 20:15. That's after the scanner's hourly export.
   - **Failure notifications:** tick **email the semantic model owner**.
4. Click **Apply**.

## Part G: prove it (5 min)

1. Open `export_manifest.json` in the DatabaseExport folder in SharePoint. It lists the row count per table.
2. In Power BI, add a **Card** visual for each of the six main tables, using **Count of** `file`.
3. The numbers must match the manifest. Once they match, the load is proven.

## Later (SACRED writes these when you're ready)

- **The measures that replace the old SQL views:** BOP % per plan (was `v_plan_pct`), the latest CBM grade per item (was `v_cbm_latest_grade`), and AAB acknowledgement rate. Ready-made DAX to paste.
- **A first report page:** CBM heatmap by rig and class, AAB status, and plan progress.
- **When the Well Control Group role accounts exist:** move the semantic model's owner and credentials to one of them (**Settings**, then **Take over**), so the refresh doesn't depend on your login.

## If something goes wrong

- **"We couldn't authenticate":** go back to Part F step 3 and re-enter the credentials as OAuth2, Organizational.
- **A table is empty:** the scanner hasn't written that file yet. That's normal for new tables, and it fills on the next export.
- **Refresh fails at night:** the scanner may have been mid-write. The next scheduled refresh fixes it. If it fails twice, send this SACRED session the error text.
