# Building the notification emails yourself in Power Automate — click by click

**For:** Dan
**Date:** 2026-09-09
**What you end up with:** every posted report emails the right people for that
report type and vessel, straight from the distribution matrix, with a link
that opens the report on the dashboard. Version 1 does routine (L1) routing.
Adding the L2/L3 escalation is a second, smaller job once v1 is sending.
**Files you need:** `WCE_Notification_Flow_Tables.xlsx` (sent with this),
and your existing flow **"Report Post Test"**.

The posting flow and the transport are never touched. This is all inside
your own notification flow.

---

## Part A — put the tables where the flow can read them (10 minutes)

1. Open `WCE_Notification_Flow_Tables.xlsx`. Go to the **Roster** sheet.
   Paste your names and emails from the Vessel Roster tab of your matrix
   workbook into the yellow cells. Vessel names must match the rig names in
   the reports exactly (`West Saturn`, `Sonangol Libongos`, and so on).
   Leave blank any position a vessel does not carry. Save and close.
2. Do **not** touch the MatrixFlat sheet. It is the matrix, one row per
   TO/CC cell, made for the flow.
3. Upload the file to the **WellControl** SharePoint site, Documents library,
   in a folder called **`Notifications`**. Close it. The flow cannot read a
   workbook someone has open.

## Part B — open the flow (2 minutes)

1. Go to `make.powerautomate.com`, **My flows**, click **Report Post Test**,
   then **Edit**.
2. You will see the trigger at the top (when a file is created in
   PostedReports) and at the bottom the email to you and Lee. Everything new
   goes **between** them. Leave the trigger alone.
3. If the flow does not already have a **Get file content** step under the
   trigger: click **+ New step**, search **SharePoint**, choose **Get file
   content**. Site Address: the WellControl site. File Identifier: click in
   the box, pick **Identifier** from the trigger's dynamic content.

## Part C — read the report (5 minutes)

4. **+ New step** → search **Parse JSON** (Data Operation).
   Content: pick **File Content** from Get file content.
   Schema: paste exactly this.
   ```json
   {
     "type": "object",
     "properties": {
       "meta": { "type": "object", "properties": {
         "asset": { "type": ["string", "null"] },
         "reporttype": { "type": ["string", "null"] },
         "discipline": { "type": ["string", "null"] },
         "date": { "type": ["string", "null"] },
         "checks": { "type": ["object", "null"], "properties": { "rig": { "type": ["string", "null"] } } }
       } },
       "applicant": { "type": ["object", "null"], "properties": { "siteUnit": { "type": ["string", "null"] } } },
       "reportType": { "type": ["string", "null"] }
     }
   }
   ```
   Rename the step **Parse JSON** (click the three dots → Rename) so the
   expressions below match.

5. **+ New step** → **Compose**. Rename it **ReportType**. In Inputs, click
   **Expression** and paste this in one go:
   ```
   if(startsWith(triggerOutputs()?['body/{FilenameWithExtension}'],'ssce-request_'),'SSCE / COC Request Submitted',if(startsWith(triggerOutputs()?['body/{FilenameWithExtension}'],'ssce-decision_'),'SSCE / COC Request Decision',if(equals(body('Parse_JSON')?['reportType'],'compliance-checklist'),'Rig Visit Report',if(equals(body('Parse_JSON')?['meta']?['discipline'],'Marine'),'Marine Integrity Report',if(equals(body('Parse_JSON')?['meta']?['reporttype'],'Precharge'),'Precharge Report',if(equals(body('Parse_JSON')?['meta']?['reporttype'],'Daily Log'),'Daily Log / Lessons Learned',if(equals(body('Parse_JSON')?['meta']?['reporttype'],'FLM'),'FLM (First Line Maintenance)',if(startsWith(triggerOutputs()?['body/{FilenameWithExtension}'],'seadrill-daily-checks_'),'Daily Checks (Rig Monitoring)',if(equals(body('Parse_JSON')?['meta']?['reporttype'],'CBM Inspection'),'CBM Inspection Report',if(equals(body('Parse_JSON')?['meta']?['reporttype'],'Planning Report'),'BOP Planning Report',if(equals(body('Parse_JSON')?['meta']?['reporttype'],'Rapid 53 (S53 Event Report)'),'S53 Failure Report (SSORT)','Rig Visit Report')))))))))))
   ```
   That produces the exact row names used in MatrixFlat. Anything it does
   not recognise becomes a Rig Visit Report, which is the safe default.

6. **+ New step** → **Compose**. Rename it **Vessel**. Expression:
   ```
   coalesce(body('Parse_JSON')?['meta']?['asset'],body('Parse_JSON')?['meta']?['checks']?['rig'],body('Parse_JSON')?['applicant']?['siteUnit'],'')
   ```

7. **+ New step** → **Initialize variable**. Name `TO`, Type **Array**, Value
   leave empty. Repeat for a second variable named `CC`.

## Part D — look up who gets it (10 minutes)

8. **+ New step** → search **Excel Online (Business)** → **List rows present
   in a table**. Location: SharePoint site WellControl. Document Library:
   Documents. File: browse to `Notifications/WCE_Notification_Flow_Tables.xlsx`.
   Table: **MatrixFlat**. Click **Show advanced options**, Filter Query:
   ```
   ReportType eq '@{outputs('ReportType')}' and Level eq 'L1'
   ```
   (Type the text, then for the `@{...}` part click Expression and enter
   `outputs('ReportType')` — the designer inserts it as a token.)
   Rename the step **MatrixRows**.

9. **+ New step** → **Apply to each**. Select an output: **value** from
   MatrixRows. Inside it add these three steps:

   9a. **Excel Online (Business) → List rows present in a table** again,
   same file, table **Roster**, Filter Query:
   ```
   Vessel eq '@{outputs('Vessel')}' and Position eq '@{items('Apply_to_each')?['Position']}'
   ```
   Rename it **VesselRow**.

   9b. Same again, rename **FleetRow**, Filter Query:
   ```
   Vessel eq 'ALL (Fleet)' and Position eq '@{items('Apply_to_each')?['Position']}'
   ```

   9c. **Compose**, rename **Email**, Expression:
   ```
   coalesce(first(body('VesselRow')?['value'])?['Email'],first(body('FleetRow')?['value'])?['Email'],'')
   ```

   9d. **Condition**: `outputs('Email')` **is not equal to** `` (empty).
   In the **If yes** branch add another **Condition**:
   `items('Apply_to_each')?['Role']` **is equal to** `TO`.
   - If yes: **Append to array variable** → `TO`, Value `outputs('Email')`.
   - If no: **Append to array variable** → `CC`, Value `outputs('Email')`.
   Leave the outer If no branch empty. That is the "blank email = skip" rule.

## Part E — send it (5 minutes)

10. After the Apply to each, **+ New step** → **Condition**:
    `length(variables('TO'))` **is greater than** `0`.

11. **If yes** → **Send an email (V2)** (Office 365 Outlook):
    - To, Expression: `join(union(variables('TO'),json('[]')),';')`
    - CC, Expression (pilot period, keeps you and Lee on everything):
      `join(union(variables('CC'),createArray('dplant@seadrill.com','LEE-ADDRESS')),';')`
      Replace `LEE-ADDRESS` with Lee's address.
    - Subject: `[WCE L1] @{outputs('ReportType')} — @{outputs('Vessel')} — @{body('Parse_JSON')?['meta']?['date']}`
    - Body (switch to HTML with the `</>` button):
      ```html
      <p><b>@{outputs('Vessel')}</b> — @{outputs('ReportType')}, routine (L1).</p>
      <p>Open the report: <a href="http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html?report=@{triggerOutputs()?['body/{FilenameWithExtension}']}">on the dashboard</a></p>
      <p>Sent automatically from the WCE distribution matrix.</p>
      ```

12. **If no** → **Send an email (V2)** to you and Lee only, Subject
    `[WCE UNROUTED] @{outputs('ReportType')} — @{outputs('Vessel')}`, body
    "No recipients found in the matrix or roster for this vessel and report
    type." Nothing ever disappears silently.

13. **Delete or disable your old Dan + Lee email step** at the bottom, or
    you will get two emails. Click **Save**.

## Part F — test before anyone else gets a mail (10 minutes)

For the first run, temporarily put your own address in every roster email
cell for **one** vessel, then post a report from a tool for that vessel.
Check:

1. The flow run shows green all the way down (My flows → Report Post Test →
   28-day run history).
2. One email arrives, subject `[WCE L1] ...`, the dashboard link opens the
   right report.
3. Post a file for a vessel with no roster rows → you get `[WCE UNROUTED]`.
4. Put the real addresses back. Tell Lee it is live.

## When something is wrong

- **Flow fails at MatrixRows or VesselRow:** the workbook is open somewhere,
  or the table names changed. Close the file, check the names.
- **Everything goes UNROUTED:** the vessel name in the roster does not match
  the rig name in the report. Copy the exact name from the dashboard.
- **Wrong people for a type:** check the MatrixFlat row for that ReportType.
  The names are fixed by the matrix; the expression in step 5 maps report
  files onto them.

## Adding escalation later (L2/L3)

Same flow, one more Compose called **Level** before step 8 that inspects
the report (the signals are listed in the IT handoff §3c), then change
`Level eq 'L1'` in step 8 to `Level eq '@{outputs('Level')}'`. The IT
handoff PDF has the full signal table. Do v1 first.
