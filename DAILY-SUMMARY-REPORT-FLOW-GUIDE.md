# Daily Summary Report flow: click by click

**For:** Dan. **Needs:** scanner v3.04 or later. **Time:** about 40 minutes for Part B, 2 minutes for Part A.

**What it does:**
- Every 15 minutes it looks for new 12-hour Daily Summary Reports.
- It emails each one, with its PDF attached, to the rig, the office, and all superintendents and planners.
- It drops a line in the plan's Teams chat when the report belongs to an Argo Navis plan that has a chat.
- Each report is sent **once**.
- A **test** report (SSCE Equipment, or a dry run) goes to **you only**, with [TEST MODE] in the subject.

**Where the scanner puts things:**
- `Digests\daily-reports\<Rig>\<report name>.pdf`: the PDF, printed with WCGRRT's own template.
- `Digests\help-receipts\daily-report-notices.json`: the list for this flow. Each item carries the subject, the email body (ready made), the chat line, and the path of the PDF.
- Only reports from the **last 48 hours** are listed, so an old report can never be sent.

**Tip that saves most of the typing:** in the new designer, open your **Plan Notices** flow in another tab. You can copy a card there (the three dots on the card, **Copy action**) and paste it here (the **+** between cards, **Paste an action**). Steps 4 and 6 say which cards to copy.

**Remember from Plan Notices:** every box marked **fx** must be typed **inside the fx box** (click in the box, then **fx**, paste, **Add**). If it is typed straight into the box, it saves as plain text. Check with **Code view** before the first run.

---

## Part A: stop the stray "PLAN CREATED" emails (2 minutes)

Today the **DL-1 Plan Notifications** flow treats any post with `_DL1_` in its name as a plan. So Lee's designation, planning report and pre-deployment posts would each send a second "PLAN CREATED" email.

1. Open **DL-1 Plan Notifications**, then **Edit**.
2. Click the **Event** card. Click in its **Inputs** box, delete what is there, click **fx**, paste this and click **Add**:
```
if(equals(outputs('Kind'), 'plan-closeout'), 'closed', if(equals(outputs('Kind'), 'plan-progress'), 'progress', if(not(equals(outputs('Kind'), 'plan')), 'other', if(equals(outputs('Status'), 'frozen'), 'frozen', if(equals(outputs('Ver'), '1'), 'created', 'updated')))))
```
3. **Save.**
   - The Switch has no case called "other", so those posts now do nothing.
   - The Daily Summary Report email comes from the new flow below instead.
4. While you're in there, rename the flow **Argo Navis Plan Notifications**: click the name at the top left, type the new name, **Save**. Nothing else depends on the name.

---

## Part B: the new flow (about 40 minutes)

**1. Create it.** Power Automate, **+ Create**, **Scheduled cloud flow**.
- Name `Daily Summary Report`.
- Repeat every **15** **Minute**.
- **Create.**

**2. Read the list.** **+**, **Add an action**, search **Get file content using path** (SharePoint).
- Site Address **WellControl**.
- File Path: type `/Digests/help-receipts/daily-report-notices.json`.

**3. Make sense of it.** **+**, **Parse JSON**. Rename it **Reports**: the three dots on the card, **Rename**.
- **Content:** click in the box, **fx**, type `body('Get_file_content_using_path')`, **Add**.
- **Schema:** paste this:
```
{"type":"object","properties":{"notices":{"type":"array","items":{"type":"object","properties":{"id":{"type":"string"},"rig":{"type":"string"},"rigkey":{"type":"string"},"bop":{"type":"string"},"planid":{"type":"string"},"cycle":{"type":"string"},"reportdate":{"type":"string"},"test":{"type":"boolean"},"subject":{"type":"string"},"bodyhtml":{"type":"string"},"chat":{"type":"string"},"link":{"type":"string"},"pdfname":{"type":"string"},"pdfpath":{"type":"string"},"source":{"type":"string"}}}}}}
```

**4. The office lists, once per run.** Copy these six cards from **Plan Notices** and paste them here, in this order:
- **PlanToRows**, **PlanToEmails**, **PlanToList**: the Planning table's **To** rows. These are James Stewart Young, Arnaud Gabaut, Lee and Ronnie.
- **PlanCcRows**, **PlanCcEmails**, **PlanCcList**: the **Cc** row, All TSC WCE Managers, Superintendents and Planners.

If Plan Notices has only the To cards, copy them, then make the Cc three the same way with Filter Query `Send eq 'Cc'`. Name them **PlanCcRows**, **PlanCcEmails** and **PlanCcList**.

**5. One pass per report.** **+**, **Apply to each**. Rename it **EachReport**.
- **Select an output from previous steps:** **fx**, `body('Reports')?['notices']`, **Add**.

Everything from here goes **inside** EachReport.

**6. Has it been sent already?**
1. **+** inside the loop, **Compose**, rename **ReportId**. Inputs **fx**:
   `replace(replace(items('EachReport')?['id'], ' ', '_'), '|', '_')`
2. **+**, **Get files (properties only)** (SharePoint), rename **SentReceipt**.
   - Site **WellControl**, Library **Digests**.
   - **Show all** (advanced), Limit Entries to Folder: pick `help-receipts`.
   - Filter Query **fx**: `concat('FileLeafRef eq ''dsr-receipt_', outputs('ReportId'), '.json''')`
   - Top Count `1`.
3. **+**, **Condition**, rename **IsNew**.
   - Left box **fx**: `length(body('SentReceipt')?['value'])`
   - Middle: **is equal to**.
   - Right: `0`.

   Everything below goes in **True**. **False** stays empty.

**7. The rig's people** (in **True**).
1. **+**, **List rows present in a table** (Excel Online (Business)), rename **RigRow**.
   - Location **WellControl**, Document Library **Documents**, File `Notifications/WCE_Precharge_Notification.xlsx`, Table **Rigs**.
   - **Show all**, Filter Query **fx**: `concat('RigKey eq ''', items('EachReport')?['rigkey'], '''')`
   - Top Count `1`.
2. **+**, **Compose**, rename **RigPeople**. Inputs **fx**, in one line. These are the rig manager, assistant rig manager, subsea supervisor, TSL, DSL, electrical supervisor and MPD supervisor, as on Brent's email:
```
join(union(split(replace(concat(coalesce(first(body('RigRow')?['value'])?['RigManagerEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['ARMEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['TslEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['DSLEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['ESVEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['MPDEmail'],''), ';', outputs('PlanToList')), ';;', ';'), ';'), json('[]')), ';')
```
3. **+**, **Compose**, rename **SendTo**. Inputs **fx**. This is the test gate: a test report goes to you only.
```
if(equals(items('EachReport')?['test'], true), 'daniel.plant@seadrill.com', outputs('RigPeople'))
```
4. **+**, **Compose**, rename **SendCc**. Inputs **fx**:
```
if(equals(items('EachReport')?['test'], true), '', outputs('PlanCcList'))
```

**8. The PDF.** **+**, **Get file content using path** (SharePoint), rename **ReportPdf**.
- Site **WellControl**.
- File Path **fx**: `items('EachReport')?['pdfpath']`

**9. The email.** **+**, **Send an email (V2)** (Office 365 Outlook).
- **To:** **fx** `outputs('SendTo')`
- **Subject:** **fx** `items('EachReport')?['subject']`. The scanner already writes "[TEST MODE]" into a test report's subject.
- **Body:** click the **</>** (code view) button on the Body box, then **fx** `items('EachReport')?['bodyhtml']`. The scanner writes the whole body: the header table, the milestones, and the dashboard link.
- **Show all** (advanced):
  - **CC:** **fx** `outputs('SendCc')`
  - **Attachments Name - 1:** **fx** `items('EachReport')?['pdfname']`
  - **Attachments Content - 1:** **fx** `body('ReportPdf')`
  - **Importance:** Normal.

**10. The Teams line**, only for an Argo Navis plan with a chat. These are the same three cards as Plan Notices step 5.4 and 5.5; copy them in and change the names as below.
1. **+**, **Get files (properties only)**, rename **PlanReceipt**.
   - Digests, `help-receipts`.
   - Filter Query **fx**: `concat('FileLeafRef eq ''plan-receipt_', items('EachReport')?['planid'], '.json''')`
   - Top Count `1`.
2. **+**, **Condition**, rename **HasChat**.
   - Left **fx**: `and(not(empty(items('EachReport')?['planid'])), greater(length(body('PlanReceipt')?['value']), 0), equals(items('EachReport')?['test'], false))`
   - **is equal to**; right **fx** `true`.
3. In **True**:
   - **Get file content using path**, rename **PlanReceiptFile**, path **fx**: `concat('/Digests/help-receipts/plan-receipt_', items('EachReport')?['planid'], '.json')`
   - **Compose** **ChatId**, **fx**: `json(string(body('PlanReceiptFile')))?['chatid']`
   - **Post message in a chat or channel**: Post as **Flow bot**, Post in **Group chat**, Group chat **fx** `outputs('ChatId')`, Message **fx** `items('EachReport')?['chat']`

   **False** stays empty. A WCGRRT report on a P6 project has no plan chat; the email carries the link.

**11. The receipt**, so the report is never sent twice. Add it **after HasChat** (below it, still inside IsNew True).
- **+**, **Create file** (SharePoint), Site **WellControl**, Folder Path `/Digests/help-receipts`.
- File Name **fx**: `concat('dsr-receipt_', outputs('ReportId'), '.json')`
- File Content **fx**: `concat('{"id":"', items('EachReport')?['id'], '","at":"', utcNow(), '"}')`

**12. Save.** Then click **Flow checker** (top right). It should be clean. Open **Code view** on SendTo and on the email's To box: each must start with `@`. If one shows plain words, redo it through **fx**.

---

## Part C: prove it, to you only (10 minutes)

The test report is the tools session's sample (SSCE Equipment, a test asset). It can only ever reach you.

1. Copy `sample-post_20261015_SSCE_TMP_BOP1_Report.json` from SACRED's repo (`tools/received/argo-navis/planning-report-12h-reply-2026-10-15/`) into the **PostedReports** folder the scanner reads.
2. Run a scan. Look for:
   `Daily Summary Report: 1 report PDF(s) in daily-reports, 1 offered to the flow in daily-report-notices.json`
3. Wait a minute for OneDrive to sync, then open the flow and click **Test**, **Manually**, **Run flow**.
4. **Check:**
   - An email **to you only**, subject `[TEST MODE] SSCE Equipment BOP1 TMP Reporting 2026/10/15 1800`.
   - The header table and milestones are in the body, with the red variance and the green float.
   - The PDF is attached.
   - `dsr-receipt_20261015_SSCE_TMP_BOP1_Report_1800_TEST.json` is now in help-receipts.
5. **Run it again:** no second email.
6. **Tidy up:**
   - Delete the sample from PostedReports.
   - Delete `Digests\daily-reports\SSCE Equipment`.
   - Delete the `dsr-receipt_…TEST.json` receipt.
7. **Turn it on:** it is on once saved. From then on, every WCGRRT 172 Planning Report posted with a cut-off, and every Argo Navis report once Lee adds the cycle, goes out within about 25 minutes of the post.

**If a run shows red on ReportPdf:** OneDrive had not finished uploading the PDF when the flow ran. The next run sends it, because no receipt was written. Nothing to do.
