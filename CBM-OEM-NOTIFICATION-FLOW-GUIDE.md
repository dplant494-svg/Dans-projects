# CBM to OEM — the flow that emails the PDF to NOV (loop three)

**For:** Dan · **Date:** 15 September 2026 · **Week plan item 14**
**Needs first:** SSORT's **Post to OEM** button (`CBM-OEM-HANDOFF.md`, reporting-tools
session). The flow can be built now and sits idle until the first OEM post arrives.
**Pattern:** the same as Precharge Notifications and the rig-visit flow, with a PDF
attached the way the precharge ISSUED email attaches one.

## Part A — the OEM sheet in the workbook (5 minutes)

Open `PostedReports/Notifications/WCE_Precharge_Notification.xlsx` in the browser.

1. Bottom left, click **+** to add a sheet. Rename it `NOV` (double-click the tab).
   The sheet name must match the `oem` value the tool posts, which is `NOV`.
2. In **A1** type `Name`, in **B1** type `Email`. Then the rows, Dave first:

| Name | Email |
|---|---|
| Cargill, David | david.cargill@nov.com |
| Cupertino, Thiago L | Thiago.Cupertino@nov.com |
| Carvalho, Gustavo P | Gustavo.Carvalho@nov.com |
| Argote, Nazario Ramirez | NazarioRamirez.Argote@nov.com |
| Oliveira, Muriel D | Muriel.Oliveira@nov.com |
| Bhuvela, Vaishali M | Vaishali.Bhuvela@nov.com |
| Figueira, Leone D | Leone.Figueira@nov.com |

3. Select A1 to B8, **Insert** tab, **Table**, tick *My table has headers*, OK. Click in
   the table, **Table Design**, and set the table name (top left) to `NOV`.
4. **Office** sheet: make sure Dan, Ronnie, Lee and Joao are on it. They are the CC on
   every OEM mail, the same list the precharge mails use.
5. Close the workbook.

## Part B — the flow (15 minutes)

1. `https://make.powerautomate.com`, **+ Create**, **Automated cloud flow**. Name:
   `CBM to OEM`. Trigger: search `when a file is created (properties only)`, pick the
   SharePoint one. **Create**.
2. Trigger card: **Site Address** = WellControl, **Library Name** = PostedReports.
3. **+ New step**, `Condition`. Left box **fx**, paste, **Add**:

```
and(startsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), 'seadrill-oem_'), endsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), '.json'))
```

   **is equal to** `true`. Everything below goes in **True**.
4. **Get file content** (SharePoint): Site WellControl, **File Identifier** = the
   trigger's **Identifier**.
5. **Parse JSON**: Content = **File Content**. Schema, one line:

```
{"type":"object","properties":{"meta":{"type":"object","properties":{"kind":{"type":"string"},"asset":{"type":"string"},"date":{"type":"string"},"reporttype":{"type":"string"},"equipment":{"type":"string"},"wce":{"type":"string"},"sourceFile":{"type":"string"}}},"oem":{"type":"string"},"subject":{"type":"string"},"pdfName":{"type":"string"},"pdf":{"type":"string"}}}
```

6. Compose cards, each renamed **before** the next expression refers to it:
   - **IsOemCopy**: `equals(coalesce(body('Parse_JSON')?['meta']?['kind'],''),'oem-copy')`
   - **Condition**: `outputs('IsOemCopy')` is equal to `true`. Everything below in **True**.
   - **RigName**: `coalesce(body('Parse_JSON')?['meta']?['asset'],'')`
   - **Subject**: `coalesce(body('Parse_JSON')?['subject'], concat('CBM Report - ', outputs('RigName'), ' - ', coalesce(body('Parse_JSON')?['meta']?['equipment'],''), ' - ', coalesce(body('Parse_JSON')?['meta']?['date'],'')))`
   - **PdfName**: `coalesce(body('Parse_JSON')?['pdfName'], replace(triggerOutputs()?['body/{FilenameWithExtension}'], '.json', '.pdf'))`
   - **HasPdf**: `not(empty(coalesce(body('Parse_JSON')?['pdf'],'')))`
   - **Link** (the dashboard, for the Seadrill readers in copy; NOV cannot open it):
     `concat('http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html?report=', encodeUriComponent(coalesce(body('Parse_JSON')?['meta']?['sourceFile'], '')))`
7. **OemRows**: `List rows present in a table` (Excel Online (Business)). Location
   SharePoint Site - WellControl, Document Library PostedReports, File
   `/Notifications/WCE_Precharge_Notification.xlsx`, Table: click the box, choose
   **Enter custom value**, **fx** `coalesce(body('Parse_JSON')?['oem'],'NOV')`. Rename
   **OemRows**.
8. **OemEmails**: `Select`. From: fx `body('OemRows')?['value']`. Map (text mode): fx
   `item()?['Email']`. Rename **OemEmails**. Then Compose **OemList**:
   `join(body('OemEmails'),';')`.
9. **OfficeRows** / **OfficeEmails** / **OfficeList**: exactly as in the precharge flow
   (table **Office**, map `item()?['Email']`, join with `;`).
10. **Condition** named **HasRecipients**: fx `outputs('OemList')` **is not equal to**
    an empty right box.
11. **True**: **Send an email (V2)**. To: custom value, fx `outputs('OemList')`. CC: fx
    `outputs('OfficeList')`. Subject: `[Seadrill CBM Report for OEM review] @{outputs('Subject')}`.
    Body (code view):

```
<p>Seadrill Well Control Engineering has completed a Condition Based Monitoring inspection report and it is attached for OEM review.</p>
<p><b>@{outputs('Subject')}</b><br>Rig: @{outputs('RigName')}<br>Completed by: @{body('Parse_JSON')?['meta']?['wce']}</p>
<p>Please review and respond to the Seadrill Technical Services contacts in copy. This is an automated distribution; replies go to the people in copy, not to this mailbox.</p>
<p>Seadrill readers: <a href="@{outputs('Link')}">open this report on the Rig Visit Dashboard</a> (internal network only).</p>
<p>Technical Services - Subsea<br>Daniel Plant - daniel.plant@seadrill.com<br>Lee Arnold - lee.arnold@seadrill.com<br>Joao Almeida - Joao.Almeida@seadrill.com</p>
```

    **Attachments**: click **Show all**, then **+ Add new item**. Name: fx
    `outputs('PdfName')`. Content: fx

```
base64ToBinary(if(equals(outputs('HasPdf'), true), body('Parse_JSON')?['pdf'], 'Cg=='))
```

    (the same wrap that fixed the precharge attachment: the connector wants bytes, a bare
    base64 string gets encoded twice). Rename the card **OEM Email**.
12. **False**: **Send an email (V2)** to `outputs('OfficeList')`, subject
    `[NO OEM RECIPIENTS] CBM report posted for @{outputs('RigName')} - @{outputs('Subject')}`,
    body `The @{body('Parse_JSON')?['oem']} sheet in the notification workbook is empty or missing. File: @{triggerOutputs()?['body/{FilenameWithExtension}']}`.
    Rename **No OEM Recipients**.
13. **Save**.

## Part C — test before NOV sees anything

1. On the NOV sheet, temporarily replace every address with your own (personal and
   Seadrill). Close the workbook.
2. Ask the reporting-tools session for a test post, or, once the button exists, press
   **Post to OEM** on any CBM report from SSORT.
3. The run goes green; your inbox gets the email with the PDF attached; the PDF opens
   and matches the Download. The dashboard row shows **Sent to NOV**.
4. Put the real addresses back. Close the workbook.

## If it misfires

- **No run:** the file name does not start with `seadrill-oem_`, or the trigger has
  not polled yet (up to fifteen minutes).
- **Attachment will not open:** the Content expression is missing the
  `base64ToBinary(...)` wrap.
- **Bounced by NOV:** the PDF is over their inbound limit. Note the size from the
  bounce; that is the number the tool's warning gets set to.
- **Went to NO OEM RECIPIENTS:** the sheet is not named exactly `NOV`, or the table
  inside it is not named `NOV`, or the workbook was open.
