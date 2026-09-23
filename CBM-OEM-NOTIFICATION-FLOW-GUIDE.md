# CBM to OEM — the flow that emails the PDF to NOV (loop three)

**For:** Dan · **Date:** 15 September 2026 · **Week plan item 14**
**Needs first:** SSORT's **Post to OEM** button (`CBM-OEM-HANDOFF.md`, reporting-tools
session). The flow can be built now and sits idle until the first OEM post arrives.
**Status, 22 September 2026:** built by Dan and tested end to end with a synthetic
`seadrill-oem_SSCE-Equipment_*` post (one-page TEST PDF): OEM email sent to the NOV
sheet's addresses, office in CC, PDF attached and opening. Live, waiting for the button.
**Status, 24 September 2026:** SSORT 148's button posts **HTML, not PDF** (rolling handoff
entry 31). **Part D below must be built and proven before the button ships**; without it a
real press would email NOV a one-byte file named `.pdf`.
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
4. **Office** sheet: Dan, Lee, Joao, Ronnie only. It is the To of the precharge and
   rig-visit mails and of every fallback mail, so nobody goes on it who should not get
   all of those.
4a. **Superintendents** sheet (22 Sep): `Name`, `Email`, the eight subsea
   superintendents (Brad Waldron, Paul Calhoun, Jacob James, Eric Rachall, Stephen
   Sagerian, Steve Rice, Siti Yusree, Brent Sherman), made into a table named
   `Superintendents`. Read by this flow only, for the CC. A future flow that should
   reach them reads the same table.
4b. **Rigs** sheet (22 Sep): headers after `TslEmail` are `OIMEmail`, `RigEngineerEmail`,
   `ARMEmail`, `RigManagerEmail`, `ESVEmail`, `DSLEmail`, `MPDEmail`. This flow copies the
   Subsea Supervisor, TSL, ARM, Rig Manager and Rig Engineer of the report's rig; blank
   cells are skipped (the Rig Engineer exists on the Brazil rigs only). ESV, DSL and MPD
   are for the rig-visit flow later.
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
9a. **SupRows** / **SupEmails** / **SupList**: the same three cards again, table
    **Superintendents**, From `body('SupRows')?['value']`, Map `item()?['Email']`,
    Compose `join(body('SupEmails'),';')`.
9b. **RigRow**: `List rows present in a table`, table **Rigs**, Advanced parameters:
    **Filter Query** fx `concat('Vessel eq ''', trim(outputs('RigName')), '''')`,
    **Top Count** `1`.
9c. **RigCc**: Compose. Joins the five rig addresses, each prefixed with `;`, skipping
    blanks, so a rig with no row or no Rig Engineer is not an error:

```
concat(if(empty(coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],'')),'',concat(';',first(body('RigRow')?['value'])?['SubseaSupervisorEmail'])),if(empty(coalesce(first(body('RigRow')?['value'])?['TslEmail'],'')),'',concat(';',first(body('RigRow')?['value'])?['TslEmail'])),if(empty(coalesce(first(body('RigRow')?['value'])?['ARMEmail'],'')),'',concat(';',first(body('RigRow')?['value'])?['ARMEmail'])),if(empty(coalesce(first(body('RigRow')?['value'])?['RigManagerEmail'],'')),'',concat(';',first(body('RigRow')?['value'])?['RigManagerEmail'])),if(empty(coalesce(first(body('RigRow')?['value'])?['RigEngineerEmail'],'')),'',concat(';',first(body('RigRow')?['value'])?['RigEngineerEmail'])))
```

10. **Condition** named **HasRecipients**: left box fx `length(outputs('OemList'))`,
    operator **is greater than**, right box `0`. (The first build used *is not equal to*
    an empty box and went False with seven addresses in the list; the length test is
    what passed on 22 Sep.)
11. **True**: **Send an email (V2)**. To: custom value, fx `outputs('OemList')`. CC: fx
    `concat(outputs('OfficeList'), ';', outputs('SupList'), outputs('RigCc'))` (office,
    superintendents, the rig's five). Subject: `[Seadrill CBM Report for OEM review] @{outputs('Subject')}`.
    Body (code view):

```
<p>Seadrill Well Control Engineering has completed a Condition Based Monitoring inspection report and it is attached for OEM review.</p>
<p><b>@{outputs('Subject')}</b><br>Rig: @{outputs('RigName')}<br>Completed by: @{body('Parse_JSON')?['meta']?['wce']}</p>
<p>Please review and respond to the Seadrill Technical Services contacts in copy. This is an automated distribution; replies go to the people in copy, not to this mailbox.</p>
<p>Seadrill readers: <a href="@{outputs('Link')}">open this report on the Rig Visit Dashboard</a> (internal network only).</p>
<p>Technical Services - Subsea<br>Lee Arnold - lee.arnold@seadrill.com<br>Joao Almeida - Joao.Almeida@seadrill.com<br>Ronnie Peeples - ronnie.peeples@seadrill.com</p>
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

Since 22 Sep the flow has test mode (`NOTIFICATION-TEST-MODE-GUIDE.md`): cards
**SettingsRow** and **TestMode** after Parse JSON, **CcList** after RigCc, and the OEM
Email's To, CC, Subject and Body wrapped on `outputs('TestMode')`. So:

1. Workbook, **Settings** sheet, **B2** = `Yes`. Close the workbook. No address on any
   sheet is touched.
2. Until the button exists, upload a synthetic post: the dashboard session makes a
   `seadrill-oem_<Rig>_<date>_flow-test_<stamp>_cbm.json` with a one-page TEST PDF
   inside. Use a real rig name to prove that rig's CC row; `SSCE Equipment` proves the
   rest without a rig. **Upload** it into PostedReports in the browser. Once the button
   exists, press **Post to OEM** on any CBM report from SSORT instead.
3. The run goes green; the four on the Office sheet get the email, `[TEST MODE]` in the
   subject, the PDF attached, and a red line at the top listing who the real run would
   have gone To (the NOV sheet) and CC (office, superintendents, the rig's five).
4. Settings **B2** = `No`. Close the workbook. Delete the test file from PostedReports
   and the test emails.
5. To rerun without uploading again: open the run in the flow's run history, top right
   **Resubmit**.

Before test mode existed (22 Sep morning) the test was done by putting your own address
in the NOV sheet's **Email** column; that is no longer needed and should not be done.

## Part D — SSORT 148 posts HTML, not PDF: the convert step (15 minutes, before the button ships)

**Why (rolling handoff entry 31, 24 Sep):** SSORT has no PDF renderer. Its Post to OEM sends
`sourceFormat: "html"`, `htmlName`, `html` (base64 of a standalone HTML report) and `pdfName`,
and **no `pdf`**. The Part B flow reads `pdf` only, so a real press of the button today would
email NOV a one-byte file called `.pdf`. Part D makes the flow build the PDF itself with the
OneDrive **Convert file** action, so one renderer (the tool's own report page) feeds both the
engineer's screen and NOV's attachment. Precharge posts still carry `pdf` and are unchanged.

**D1. A variable at the top.** Open the flow. Click the **+** directly under the trigger
card (above the first Condition). Search `Initialize variable`. Name `PdfFile`, Type
**Object**, Value empty. (Initialize variable only works at the top level, which is why it
sits here and not inside a branch.)

**D2. One more compose after HasPdf** (step 6): **HasHtml**:
`not(empty(coalesce(body('Parse_JSON')?['html'],'')))` and **HtmlName**:
`coalesce(body('Parse_JSON')?['htmlName'], replace(outputs('PdfName'), '.pdf', '.html'))`.

**D3. Condition `NeedsConvert`**, placed straight after HtmlName: left box fx
`and(equals(outputs('HasPdf'), false), equals(outputs('HasHtml'), true))`, **is equal to**
`true`.

**True** (an SSORT HTML post), four cards in this order:

1. **Create file** (OneDrive for Business): Folder Path `/OemConvert` (make the folder once
   in your OneDrive), File Name fx `outputs('HtmlName')`, File Content fx
   `base64ToBinary(body('Parse_JSON')?['html'])`. Rename **HtmlFile**.
2. **Convert file** (OneDrive for Business): File fx `outputs('HtmlFile')?['body/Id']`,
   Target type **PDF**. Rename **ConvertedPdf**.
3. **Set variable**: Name `PdfFile`, Value fx `body('ConvertedPdf')`.
4. **Delete file** (OneDrive for Business): File fx `outputs('HtmlFile')?['body/Id']`.

**False** (a post that carries `pdf`, the precharge shape): one card, **Set variable**:
Name `PdfFile`, Value fx
`base64ToBinary(if(equals(outputs('HasPdf'), true), body('Parse_JSON')?['pdf'], 'Cg=='))`.

**D4. The attachment.** Open **OEM Email**, Attachments, Content: replace the expression
with fx `variables('PdfFile')`. Name stays `outputs('PdfName')`. **Save.**

**D5. Test in test mode.** Settings B2 `Yes`. Have the tools session, or SSORT 148 on your
own PC against `SSCE Equipment`, press Post to OEM once. The office four get
`[TEST MODE] [Seadrill CBM Report for OEM review] …` with a real multi-page PDF attached and
the photographs in it. Open the PDF and check the photographs and the grade colours survived
the converter; if they did not, say so and Part D switches to attaching the HTML (`HtmlName`
+ `base64ToBinary(body('Parse_JSON')?['html'])`), which is one card change. B2 `No`.

**What happens if the converter refuses a file** (very large photo sets): the run fails at
ConvertedPdf, nothing is sent to NOV, Power Automate emails you the failure, and the tool's
button still says sent, which is why the tools session is changing that wording to
"Sent for OEM delivery". Until Part D is proven, the button does not ship.

## If it misfires

- **No run:** the file name does not start with `seadrill-oem_`, or the trigger has
  not polled yet (up to fifteen minutes).
- **Attachment will not open:** the Content expression is missing the
  `base64ToBinary(...)` wrap.
- **Bounced by NOV:** the PDF is over their inbound limit. Note the size from the
  bounce; that is the number the tool's warning gets set to.
- **Mail arrived with [TEST MODE] on it and only the office got it:** Settings B2 says
  Yes. Set it to No and close the workbook.
- **Went to NO OEM RECIPIENTS:** the sheet is not named exactly `NOV`, or the table
  inside it is not named `NOV`, or the workbook was open, or the addresses are in the
  Name column instead of Email. To find which: open the run, click **OemRows** (Inputs
  show the table name it used, raw Outputs show the rows), then **OemEmails** (raw
  Outputs show the address list), then **HasRecipients** (expressionResult).
- **"A table cannot overlap another table" in Excel:** the list is already a table.
  Click OK; nothing to do.
