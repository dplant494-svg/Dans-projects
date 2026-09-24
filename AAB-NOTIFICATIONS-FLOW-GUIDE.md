# AAB Notifications — the flow, click by click

**For:** Dan · **Date:** 24 September 2026 · **Plan:** `AAB-LOOP-PLAN.md` §6 step 3
**Needs first:** `AAB-INSTALL-GUIDE.md` Parts A to C (scanner v2.65, the `aab` folder on
the share). **Pattern:** the same as Precharge Notifications and CBM to OEM: one trigger
on PostedReports, a filename condition, Parse JSON, the Settings/TestMode pair, the Office
and Rigs sheets. Test mode from the first minute.

Two flows. **AAB Notifications** fires on every AAB post and every acknowledgement.
**AAB Overdue Chase** runs once a day from the scanner's chase file.

| Event | Posted file | To | CC |
|---|---|---|---|
| AAB issued (or revised) | `seadrill-aab_<no>_<rev>_<stamp>.json` | each applicable rig: TSL, Subsea Supervisor, ARM, Rig Manager (Rigs sheet) | Office, Superintendents, the gatekeeper |
| Rig acknowledged / closed | `seadrill-aab-ack_<no>_<rev>_<rigKey>_<stamp>.json` | the gatekeeper | Office |
| Overdue chase (daily) | `aab-overdue-pending.json` in the Digests library | the rig's four | Office, the gatekeeper |

Rig people always on To, never CC (your rule, 23 Sep). The gatekeeper is Eric.

## Part A — the workbook (3 minutes)

`WCE_Precharge_Notification.xlsx`, in the browser.

1. **Settings** sheet: in A3 type `AabGatekeeper`, in B3 type Eric's email address. The
   Settings table grows to A1:B3 (click in the table, **Table Design**, **Resize Table** if it
   did not extend itself).
2. **Rigs** sheet: nothing to add. The flow uses `RigKey`, `Vessel`, `TslEmail`,
   `SubseaSupervisorEmail`, `ARMEmail`, `RigManagerEmail`, all already filled.
3. Close the workbook (or leave it open in the browser; never in Excel on the PC while a run
   fires).

## Part B — AAB Notifications (25 minutes)

1. `make.powerautomate.com`, **+ Create**, **Automated cloud flow**. Name:
   `AAB Notifications`. Trigger: search `when a file is created (properties only)`, pick the
   SharePoint one. **Create**.
2. Trigger card: **Site Address** WellControl, **Library Name** PostedReports.
3. **+ New step**, **Condition**. Left box **fx**, paste, **Add**:

```
startsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), 'seadrill-aab')
```

   **is equal to** `true`. Everything below goes in **True**.
4. **Get file content** (SharePoint): Site WellControl, **File Identifier** = the trigger's
   **Identifier**.
5. **Parse JSON**: Content = **File Content**. Schema, one line:

```
{"type":"object","properties":{"meta":{"type":"object","properties":{"kind":{"type":"string"},"asset":{"type":"string"},"rigkey":{"type":"string"}}},"aabNumber":{"type":"string"},"revision":{"type":["integer","string"]},"title":{"type":"string"},"issueDate":{"type":"string"},"dueDate":{"type":"string"},"actionRequested":{"type":["boolean","string"]},"rigsApplicable":{"type":"array"},"rigNames":{"type":"object"},"advisory":{"type":"object","properties":{"whatHappened":{"type":"string"},"whyItMatters":{"type":"string"},"requiredAction":{"type":"string"}}},"attachments":{"type":"array"},"pdf":{"type":"string"},"pdfName":{"type":"string"},"action":{"type":"string"},"by":{"type":"string"},"role":{"type":"string"},"crew":{"type":"string"},"at":{"type":"string"},"comment":{"type":"string"}}}
```

6. **SettingsRow** and **TestMode**, exactly as in the other two flows
   (`NOTIFICATION-TEST-MODE-GUIDE.md` Part B): List rows, table Settings, Filter
   `concat('Key eq ''TestMode''')`, Top 1; Compose
   `equals(toLower(trim(coalesce(first(body('SettingsRow')?['value'])?['Value'],'no'))),'yes')`.
7. **GateRow**: List rows present in a table, table **Settings**, Filter Query
   `concat('Key eq ''AabGatekeeper''')`, Top Count `1`. Then Compose **Gatekeeper**:
   `coalesce(first(body('GateRow')?['value'])?['Value'],'')`.
8. **OfficeRows** / **OfficeEmails** / **OfficeList** and **SupRows** / **SupEmails** /
   **SupList**: the same six cards as the CBM to OEM flow (tables Office and
   Superintendents, map `item()?['Email']`, join with `;`).
9. Compose cards:
   - **Kind**: `toLower(coalesce(body('Parse_JSON')?['meta']?['kind'],''))`
   - **AabNo**: `coalesce(body('Parse_JSON')?['aabNumber'],'')`
   - **Rev**: `string(coalesce(body('Parse_JSON')?['revision'],0))`
   - **Title**: `coalesce(body('Parse_JSON')?['title'],'')`
   - **DashLink**: `http://sdrlazneuiis01d.corp.local:8080/sacred/aab/register.html` (type the
     text into the Inputs box; no fx needed: the fleet compliance page, password)
   - **OfficeCc**: `concat(outputs('OfficeList'), ';', outputs('SupList'), if(empty(outputs('Gatekeeper')), '', concat(';', outputs('Gatekeeper'))))`
10. **Condition** named **IsAck**: `outputs('Kind')` **is equal to** `aab-ack`.

### IsAck → True: the acknowledgement email

11. Compose **AckRig**: `coalesce(body('Parse_JSON')?['meta']?['asset'],body('Parse_JSON')?['meta']?['rigkey'],'')`
    and **AckWhat**: `if(equals(toLower(coalesce(body('Parse_JSON')?['action'],'')), 'close'), 'action closed', 'acknowledged')`.
12. **Send an email (V2)**, rename **Ack Email**:
    - To: fx `if(equals(outputs('TestMode'), true), outputs('OfficeList'), if(empty(outputs('Gatekeeper')), outputs('OfficeList'), outputs('Gatekeeper')))`
    - CC: fx `outputs('OfficeList')`
    - Subject: fx `concat(if(equals(outputs('TestMode'), true), '[TEST MODE] ', ''), '[AAB ', outputs('AckWhat'), '] ', outputs('AabNo'), ' rev ', outputs('Rev'), ' - ', outputs('AckRig'), ' crew ', coalesce(body('Parse_JSON')?['crew'],'?'))`
    - Body (code view):

```
@{if(equals(outputs('TestMode'), true), concat('<p style="color:#b00"><b>TEST MODE. Real run would go To: ', outputs('Gatekeeper'), '<br>CC: ', outputs('OfficeList'), '</b></p>'), '')}
<p><b>@{outputs('AckRig')}</b> has @{outputs('AckWhat')} AAB <b>@{outputs('AabNo')}</b> rev @{outputs('Rev')}.</p>
<p>By: @{body('Parse_JSON')?['by']} (@{body('Parse_JSON')?['role']}, crew @{body('Parse_JSON')?['crew']}) on @{body('Parse_JSON')?['at']}<br>Comment: @{body('Parse_JSON')?['comment']}</p>
<p><a href="@{outputs('DashLink')}">Open the fleet compliance page</a> (the state updates within ten minutes; evidence photographs are on the record there).</p>
<p>Technical Services - Well Control Engineering</p>
```

### IsAck → False: the issued email, one per applicable rig

13. **Filter array**, rename **PrimaryAtt**: From fx `coalesce(body('Parse_JSON')?['attachments'], json('[]'))`,
    condition: left box fx `string(item()?['primary'])`, **is equal to** `true`.
14. Compose **HasAtt**: `greater(length(body('PrimaryAtt')), 0)`.
15. Compose **HasPdf**: `not(empty(coalesce(body('Parse_JSON')?['pdf'],'')))`.
16. **Apply to each**, rename **EachRig**. Select an output: fx
    `coalesce(body('Parse_JSON')?['rigsApplicable'], json('[]'))`. Inside it:
    - **RigRow**: List rows present in a table, table **Rigs**, Filter Query fx
      `concat('RigKey eq ''', trim(string(items('EachRig'))), '''')`, Top Count `1`.
    - Compose **RigName**: `coalesce(first(body('RigRow')?['value'])?['Vessel'], body('Parse_JSON')?['rigNames']?[string(items('EachRig'))], string(items('EachRig')))`
    - Compose **RigTo**:

```
join(union(split(concat(coalesce(first(body('RigRow')?['value'])?['TslEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['ARMEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['RigManagerEmail'],'')),';'),json('[]')),';')
```

    - Compose **AckLink**: `concat('http://sdrlazneuiis01d.corp.local:8080/sacred/aab/index.html?rig=', string(items('EachRig')))`
    - **Condition** **HasRigContact**: fx `length(replace(outputs('RigTo'), ';', ''))` **is greater than** `0`.
    - True → **Send an email (V2)**, rename **AAB Issued Email**:
      - To: fx `if(equals(outputs('TestMode'), true), outputs('OfficeList'), outputs('RigTo'))`
      - CC: fx `if(equals(outputs('TestMode'), true), outputs('OfficeList'), outputs('OfficeCc'))`
      - Subject: fx `concat(if(equals(outputs('TestMode'), true), '[TEST MODE] ', ''), '[AAB ', outputs('AabNo'), ' rev ', outputs('Rev'), '] ', outputs('Title'), ' - ', outputs('RigName'))`
      - Body (code view):

```
@{if(equals(outputs('TestMode'), true), concat('<p style="color:#b00"><b>TEST MODE. Real run would go To: ', outputs('RigTo'), '<br>CC: ', outputs('OfficeCc'), '</b></p>'), '')}
<p>Seadrill Well Control Engineering has issued a <b>Priority 3 Advisory AAB</b> that applies to <b>@{outputs('RigName')}</b>. Priority 3 is not required by Corporate and is for information; it is acknowledged by the Technical Section Leader of each crew.</p>
<p><b>AAB @{outputs('AabNo')} rev @{outputs('Rev')} - @{outputs('Title')}</b><br>Issued: @{body('Parse_JSON')?['issueDate']} &middot; Due: @{body('Parse_JSON')?['dueDate']} &middot; Action requested: @{if(equals(string(body('Parse_JSON')?['actionRequested']), 'True'), 'yes', 'no')}</p>
<p><b>What happened</b><br>@{replace(coalesce(body('Parse_JSON')?['advisory']?['whatHappened'],''), decodeUriComponent('%0A'), '<br>')}</p>
<p><b>Why it matters</b><br>@{replace(coalesce(body('Parse_JSON')?['advisory']?['whyItMatters'],''), decodeUriComponent('%0A'), '<br>')}</p>
<p><b>Required action</b><br>@{replace(coalesce(body('Parse_JSON')?['advisory']?['requiredAction'],''), decodeUriComponent('%0A'), '<br>')}</p>
<p><a href="@{outputs('AckLink')}">Acknowledge this AAB for @{outputs('RigName')}</a> (each crew's TSL; the page also holds the bulletin and the photographs). Technical Services: <a href="@{outputs('DashLink')}">the fleet compliance page</a>.</p>
<p>Technical Services - Well Control Engineering</p>
```

      - **Attachments** (Show all, + Add new item). Name: fx
        `if(equals(outputs('HasAtt'), true), first(body('PrimaryAtt'))?['name'], 'no-bulletin.txt')`.
        Content: fx
        `if(equals(outputs('HasAtt'), true), base64ToBinary(first(body('PrimaryAtt'))?['data']), base64ToBinary('Tm8gYnVsbGV0aW4gd2FzIGF0dGFjaGVkIHRvIHRoaXMgQUFCLg=='))`
        (the fallback is a one-line text file saying no bulletin was attached, so the card
        never fails on an AAB without one). A second attachment item for the AAB's own PDF,
        once Eric's tool produces one: Name `coalesce(body('Parse_JSON')?['pdfName'],'AAB.pdf')`,
        Content `base64ToBinary(if(equals(outputs('HasPdf'), true), body('Parse_JSON')?['pdf'], 'Cg=='))`.
        Leave that second item out until `pdf` arrives.
    - False → **Send an email (V2)**, rename **No Rig Contact**: To `outputs('OfficeList')`,
      Subject fx `concat(if(equals(outputs('TestMode'), true), '[TEST MODE] ', ''), '[NO RIG CONTACT] AAB ', outputs('AabNo'), ' - ', outputs('RigName'))`,
      Body: `The Rigs sheet has no TSL, Subsea Supervisor, ARM or Rig Manager address for @{outputs('RigName')} (key @{items('EachRig')}). The AAB is on the dashboard; the rig has not been told.`
17. **Save**. Turn on.

## Part C — test (10 minutes, Part D of the install guide)

Settings B2 `Yes`. Post a TEST AAB for one rig from the board. One `[TEST MODE] [AAB …]`
email per applicable rig arrives at the office only, with the bulletin attached and the red
line naming the rig's four. Acknowledge from the page: one `[TEST MODE] [AAB acknowledged]`
to the office. Close the action: `[TEST MODE] [AAB action closed]`. Settings B2 `No`.

## Part D — AAB Overdue Chase (15 minutes)

The scanner writes `aab-overdue-pending.json`: one row per AAB per rig that is past due and
still open, once per day per row. A flow cannot read the server share, so the scanner also
copies it into the **Digests** library, which is SharePoint.

1. `config.json` on your PC, in Notepad: add one line inside the braces (after any existing
   line, with a comma on the line before it):

```
  "aabChaseFile": "C:\\Users\\danplant\\Seadrill\\WellControl - Digests\\aab-overdue-pending.json"
```

   The next scan prints `AAB chase file updated: …` whenever the rows change.
2. `make.powerautomate.com`, **+ Create**, **Scheduled cloud flow**. Name
   `AAB Overdue Chase`. Repeat every **1 Day**, starting 07:00. **Create**.
3. **Get file content using path** (SharePoint): Site WellControl, File Path: browse to the
   **Digests** library, pick `aab-overdue-pending.json` (it exists after the first scan
   with the config line; if the browse shows nothing yet, run a scan first).
4. **Parse JSON**: Content = File Content. Schema:

```
{"type":"array","items":{"type":"object","properties":{"aabNumber":{"type":"string"},"revision":{"type":["integer","string"]},"title":{"type":"string"},"rigKey":{"type":"string"},"rig":{"type":"string"},"dueDate":{"type":"string"},"daysOverdue":{"type":["integer","string"]},"state":{"type":"string"},"day":{"type":"string"}}}}
```

5. **SettingsRow**, **TestMode**, **GateRow**, **Gatekeeper**, the Office and
   Superintendents six, **OfficeCc**: as in Part B steps 6 to 9.
6. **Apply to each** over `body('Parse_JSON')`. Inside: **RigRow** by
   `concat('RigKey eq ''', trim(string(items('Apply_to_each')?['rigKey'])), '''')`, **RigTo** as in
   Part B, **AckLink** `concat('http://sdrlazneuiis01d.corp.local:8080/sacred/aab/index.html?rig=', string(items('Apply_to_each')?['rigKey']))`,
   then **Send an email (V2)**, rename **Chase Email**:
   - To: fx `if(equals(outputs('TestMode'), true), outputs('OfficeList'), outputs('RigTo'))`
   - CC: fx `if(equals(outputs('TestMode'), true), outputs('OfficeList'), outputs('OfficeCc'))`
   - Subject: fx `concat(if(equals(outputs('TestMode'), true), '[TEST MODE] ', ''), '[AAB OVERDUE] ', items('Apply_to_each')?['aabNumber'], ' - ', items('Apply_to_each')?['rig'], ' - ', string(items('Apply_to_each')?['daysOverdue']), ' days past due')`
   - Body:

```
@{if(equals(outputs('TestMode'), true), concat('<p style="color:#b00"><b>TEST MODE. Real run would go To: ', outputs('RigTo'), '<br>CC: ', outputs('OfficeCc'), '</b></p>'), '')}
<p>AAB <b>@{items('Apply_to_each')?['aabNumber']}</b> rev @{items('Apply_to_each')?['revision']} - @{items('Apply_to_each')?['title']} was due on @{items('Apply_to_each')?['dueDate']} and is <b>@{items('Apply_to_each')?['state']}</b> for <b>@{items('Apply_to_each')?['rig']}</b> (@{items('Apply_to_each')?['daysOverdue']} days).</p>
<p><a href="@{outputs('AckLink')}">Acknowledge or close it here</a>. This reminder repeats daily until the rig does.</p>
<p>Technical Services - Well Control Engineering</p>
```

7. **Save**. Turn on. Test it: with B2 `Yes`, click **Test**, **Manually**, **Run flow**.
   If the chase file has rows, the office gets one `[TEST MODE] [AAB OVERDUE]` per row.

## If it misfires

- **Nothing arrives after a post:** run history. A 0 s run stopped at the filename
  condition (not an AAB file). A red **Parse JSON**: the post is not schema 2.0; open it.
- **Issued email goes to nobody / NO RIG CONTACT:** the rig's `RigKey` on the Rigs sheet
  does not match the code the board used (`nov`, `cam` are the odd ones), or the four
  address cells are empty.
- **The attachment is `no-bulletin.txt`:** the AAB was posted without a PDF. The board
  allows it; the dashboard shows the record; Eric decides whether to revise.
- **Chase mails the same row twice in a day:** two scans on one day cannot, the state file
  stops it; two flow runs in one day can. Keep the recurrence at one a day.
