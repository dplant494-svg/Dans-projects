# TSC Help Notifications — the flow, click by click

**For:** Dan · **Date:** 29 September 2026 · **Plan:** week plan item 31 (the assistance request), the
Help Centre side of `DASHBOARD-TSC-HELP-CENTRE-HANDOFF.md` · **Needs:** scanner v2.71 and the Help Centre
installed (`TSC-HELP-CENTRE-INSTALL-GUIDE.md`); the notification workbook with two new sheets (Part A).

**What it does:** when a rig posts a request for help from WCGRRT or SSORT (`seadrill-help_*`), the
flow emails the office, the superintendents, Ian Jack, BOP Controls and the rig's four with the
request in the body and the attachments attached; creates a Teams group chat named
`<Rig> – <date> – <subject>` with the same people and posts the request as its first message; and
writes a **delivery receipt** into the Digests library so the Help Centre shows **Sent to 9 at
14:02** beside the request. If the email cannot be sent, a NOT SENT email goes to the office with
the whole request as text, and the receipt says so.

**And back again (Part F):** when someone acknowledges, updates or closes the request from the Help
Centre page, a second flow emails the same people under the same subject, so it lands in the same
Outlook conversation, and posts the same words into the Teams chat the request opened. One request,
one email conversation, one chat, and the trail on the page.

The three guards, any one of which sends to the office only with the red line: `SSCE Equipment`
as the asset, `dryRun` true in the payload, or Settings B2 `Yes`.

Built the way the AAB Notifications flow was, card names in bold, expressions in code boxes.
Everything in **SEADRILL-WC-DEV**.

## Part A — the workbook (10 minutes)

In `WCE_Precharge_Notification.xlsx`, two new sheets, each with a table of the same name:

1. **HelpFixed**: columns `Name`, `Email`. Rows: Ian Jack, `Ian.Jack@seadrill.com`; BOP Controls,
   `BOPcontrols@seadrill.com`. Select A1:B3, Insert, Table, "My table has headers", name it `HelpFixed`.
2. **Downtime** (for Part E, the six-hour chat): columns `Role`, `Name`, `Email`. Rows: Ops Director;
   Director of Technical Services; Downtime Event SME. Table name `Downtime`.

The Rigs sheet already carries `TslEmail`, `SubseaSupervisorEmail`, `ARMEmail`, `RigManagerEmail` per
rig; nothing changes there. Close Excel (edit in the browser, or close before testing).

## Part B — the flow (45 minutes)

1. Power Automate, **+ Create**, **Automated cloud flow**, name `TSC Help Notifications`, trigger
   **When a file is created (properties only)** (SharePoint). Site **WellControl**, Library
   **PostedReports**.
2. **Condition** (rename **IsHelp**): left box fx
```
and(startsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), 'seadrill-help_'), endsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), '.json'))
```
   is equal to `true`. Everything else goes in **True**. (The Help Centre's own records start
   `seadrill-help-ack_`, which does not match `seadrill-help_` with the underscore, so they never
   trigger an email.)
3. **Get file content** (SharePoint): Site WellControl, File Identifier = the trigger's **Identifier**.
4. **Parse JSON**: Content = **File Content**; Schema:
```
{"type":"object","properties":{"meta":{"type":"object","properties":{"kind":{"type":"string"},"asset":{"type":"string"},"rigkey":{"type":"string"},"sss":{"type":"string"},"tsl":{"type":"string"},"saved":{"type":"string"},"rev":{"type":"string"}}},"requestId":{"type":"string"},"notifyKind":{"type":"string"},"rigDown":{"type":["boolean","string"]},"hoursDown":{"type":["number","string"]},"occurredAt":{"type":"string"},"synergiCase":{"type":"string"},"subject":{"type":"string"},"description":{"type":"string"},"dryRun":{"type":["boolean","string"]},"attachments":{"type":"array"},"photos":{"type":"array"}}}
```
5. **SettingsRow**, **TestMode**: as in the AAB flow (List rows present in a table, table Settings,
   filter `Key eq 'TestMode'`; Compose `TestMode` = `equals(toLower(coalesce(first(body('SettingsRow')?['value'])?['Value'],'no')), 'yes')`).
6. Compose **TestAsset**: `equals(toLower(coalesce(body('Parse_JSON')?['meta']?['asset'],'')), 'ssce equipment')`.
   Compose **DryRun**: `equals(toLower(string(coalesce(body('Parse_JSON')?['dryRun'], false))), 'true')`.
   Compose **Guard**: `or(equals(outputs('TestMode'), true), equals(outputs('TestAsset'), true), equals(outputs('DryRun'), true))`.
7. Compose **RigName**: `coalesce(body('Parse_JSON')?['meta']?['asset'], 'Unknown rig')`.
   Compose **RigKey**: `toLower(coalesce(body('Parse_JSON')?['meta']?['rigkey'], ''))`.
   Compose **ReqId**: `coalesce(body('Parse_JSON')?['requestId'], replace(triggerOutputs()?['body/{FilenameWithExtension}'], '.json', ''))`.
   Compose **IsDown**: `equals(toLower(string(coalesce(body('Parse_JSON')?['rigDown'], false))), 'true')`.
   Compose **Mode**: `if(equals(outputs('IsDown'), true), 'RIG DOWN', 'BOP EQUIPMENT FAILURE')`.
   Compose **Subj**: `coalesce(body('Parse_JSON')?['subject'], 'Assistance request')`.
   Compose **HelpLink**: `http://sdrlazneuiis01d.corp.local:8080/sacred/help/help-centre.html`.
8. The lists, the same six cards as the AAB flow, plus two: **OfficeRows/OfficeEmails/OfficeList**,
   **SupRows/SupEmails/SupList**, and **FixedRows** (table `HelpFixed`) / **FixedEmails** (Select, map
   `item()?['Email']`) / **FixedList** (`join(body('FixedEmails'), ';')`).
9. **RigRow**: List rows present in a table, table **Rigs**, Filter Query fx
   `concat('RigKey eq ''', outputs('RigKey'), '''')`, Top Count 1.
   Compose **RigFour**:
```
join(union(split(concat(coalesce(first(body('RigRow')?['value'])?['TslEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['ARMEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['RigManagerEmail'],'')), ';'), json('[]')), ';')
```
10. Compose **AllTo** (the real audience, semicolon list, blanks removed):
```
join(union(split(replace(concat(outputs('OfficeList'), ';', outputs('SupList'), ';', outputs('FixedList'), ';', outputs('RigFour')), ';;', ';'), ';'), json('[]')), ';')
```
   Compose **SendTo**: `if(equals(outputs('Guard'), true), outputs('OfficeList'), outputs('AllTo'))`.
   Compose **Banner**:
```
if(equals(outputs('Guard'), true), concat('<p style="color:#b00"><b>TEST MODE. Real run would go To: ', outputs('AllTo'), '</b></p>'), '')
```
11. The attachments, as in the AAB flow: **Select** **ReqPhotos** (From
    `coalesce(body('Parse_JSON')?['photos'], json('[]'))`, Map `Name` → `coalesce(item()?['name'],'photo.jpg')`,
    `ContentBytes` → `base64ToBinary(last(split(item()?['data'], ',')))`) and **Select** **ReqDocs** (From
    `coalesce(body('Parse_JSON')?['attachments'], json('[]'))`, same map, `'document'` as the fallback name).
12. **Send an email (V2)**, rename **Help Email**:
    - To: fx `outputs('SendTo')`. CC: leave empty (everyone is on To).
    - Subject: fx
```
concat(if(equals(outputs('Guard'), true), '[TEST MODE] ', ''), outputs('Mode'), ' - ', outputs('RigName'), ' - ', outputs('Subj'))
```
    - Body, pasted into the normal view as plain text, no HTML (the banner card carries the HTML):
```
@{outputs('Banner')}
@{outputs('RigName')} has asked Technical Services for help: @{outputs('Subj')}
Mode: @{outputs('Mode')}. Event occurred: @{coalesce(body('Parse_JSON')?['occurredAt'],'not given')}. Hours down as posted: @{coalesce(body('Parse_JSON')?['hoursDown'],'0')}. Synergi case: @{coalesce(body('Parse_JSON')?['synergiCase'],'not yet raised')}.
Raised by: @{coalesce(body('Parse_JSON')?['meta']?['sss'],'')} (Subsea Supervisor). Tool: @{coalesce(body('Parse_JSON')?['meta']?['rev'],'')}.
@{coalesce(body('Parse_JSON')?['description'],'')}
The request, its delivery receipt and the trail are on the TSC Help Centre (password): @{outputs('HelpLink')}
A Teams chat named "@{outputs('RigName')} - @{formatDateTime(utcNow(),'yyyy-MM-dd')} - @{outputs('Subj')}" has been created with everyone on this email.
Technical Services - Well Control Engineering
```
    - Attachments (Advanced parameters, Switch to input entire array): fx `union(body('ReqPhotos'), body('ReqDocs'))`.
    - Importance: **High** when rig down: fx `if(equals(outputs('IsDown'), true), 'High', 'Normal')`.
12a. **Filter array** (Data Operation), rename **ToClean**: From fx `split(outputs('SendTo'), ';')`, condition
    `item()` **is not equal to** (leave the right box empty). Drops the blank entries a missing rig row or an empty table
    row leaves behind (10 Oct: the trailing `;` made Create a chat return BadRequest). Help Email To becomes
    `join(body('ToClean'), ';')`.
13. **Create a chat** (Microsoft Teams), rename **HelpChat**: Members fx `join(body('ToClean'), ';')`
    (semicolons, not commas: 10 Oct, the comma list was one invalid member, BadRequest), Title fx (a chat topic
    may not contain a colon, so the subject's colons become ' -'; 10 Oct, BadRequest on 'TEST: ...')
```
concat(if(equals(outputs('Guard'), true), '[TEST] ', ''), outputs('RigName'), ' - ', formatDateTime(utcNow(),'yyyy-MM-dd'), ' - ', replace(outputs('Subj'), ':', ' -'))
```
14. **Post message in a chat or channel** (Teams), rename **ChatOpen**: Post as **Flow bot**, Post in
    **Group chat**, Group chat fx `outputs('HelpChat')?['body/id']`, Message: the same text as the email
    body without the banner and the last two lines, plus `Help Centre: @{outputs('HelpLink')}`.
15. **Create file** (SharePoint), rename **Receipt**: Site WellControl, Folder Path `/Digests/help-receipts`
    (make the folder once in the Digests library), File Name fx
    `concat('help-receipt_', outputs('ReqId'), '_', formatDateTime(utcNow(),'yyyyMMdd-HHmmss'), '.json')`,
    File Content fx
```
json(concat('{"requestId":"', outputs('ReqId'), '","kind":"assistance","ok":true,"sentTo":', string(body('ToClean')), ',"sentAt":"', utcNow(), '","error":"","chatCreated":true,"chatId":"', coalesce(outputs('HelpChat')?['body/id'],''), '","mode":"', outputs('Mode'), '"}'))
```
16. **The failure branch.** Click the **+** under **Help Email**, **Add a parallel branch**, **Send an email
    (V2)**, rename **NotSent**: To `outputs('OfficeList')`, Subject fx
    `concat('NOT SENT - ', outputs('Mode'), ' - ', outputs('RigName'), ' - ', outputs('Subj'))`, Body: the same
    text as the email plus a first line `THE FLOW COULD NOT SEND THIS TO THE RIG'S FOUR AND THE FIXED ADDRESSES. Forward it by hand now to: @{outputs('AllTo')}`.
    Then on the NotSent card, **⋯**, **Settings** (or **Configure run after**): untick **is successful**, tick
    **has failed**, **is skipped**, **has timed out**. Below NotSent, a second **Create file** into the same
    folder with `"ok":false,"sentTo":[],"error":"the flow could not send the email"` in the content, same
    file name pattern, and the same run-after settings.
    (The receipt's `mode` and `chatId` are what Part F uses to put the acknowledgement into the same
    email conversation and the same Teams chat.)
17. **Save.**

## Part C — proving it (test mode)

Settings B2 `Yes`. Post one assistance request from SSORT (stage 2 of the tools' build) against
**SSCE Equipment**, or drop a synthetic `seadrill-help_*.json` into PostedReports. Expect: the office
gets `[TEST MODE] RIG DOWN - SSCE Equipment - …` with the attachments and the red line; a Teams chat
`[TEST] SSCE Equipment - <date> - …` appears with the office in it and the request as its first
message; the Help Centre shows the request within ten minutes with **Sent to N at hh:mm**. Acknowledge
and close it from the Help Centre. B2 `No`.

## Part D — what the Help Centre does with it

The scanner reads the receipts from the Digests library (`helpReceiptPath` in config.json, default
the `help-receipts` folder beside the AAB chase file) and shows one of four things beside each
request: **Sent to N at hh:mm**, **NOT SENT: <reason>** in red, **No delivery receipt yet** in amber
after twenty minutes, or **pending** in the first twenty. A request still without a receipt after an
hour, or one marked NOT SENT, is on the dashboard's Errors button as an assistance request without
a delivery receipt.

## Part E — the six-hour chat (DIR-00-0116 §3.5.1.1), a second, scheduled flow (30 minutes)

Not built with Part B; built once Part B is proven. **Recurrence** every hour. **Get file content**
of `help-data.js`? No: a flow cannot read the server share. Instead the scanner writes
`help-open.json` beside the receipts (the open rig-down requests with `requestId`, `rigKey`, `rig`,
`subject`, `occurredAt`; scanner v2.72, on request). The flow: **Get file content** on that file,
**Parse JSON**, **Apply to each** row: Condition `less(addHours(item()?['occurredAt'], 6), utcNow())`
is `true` → **Get files (properties only)** on `/Digests/help-receipts` filtered to
`help-receipt_<requestId>_directive_*` (Filter Query `startswith(FileLeafRef,'…')`); if none:
**RigRow** for the rig, **DowntimeRows** (table `Downtime`), **Create a chat** with Rig Manager, ARM,
the three Downtime rows and the office, Title `<Rig> – <occurred date> – <subject>`, **Post message**
with the request and the assistance chat's link, and a receipt file named
`help-receipt_<requestId>_directive_<stamp>.json` with `"kind":"directive","chatCreated":true`.
The Help Centre then shows **Six-hour Teams chat created** on the card.

## Part F — the acknowledgement back into the same conversation (30 minutes, after Part C)

**What it does:** the Help Centre page's Acknowledge, Update and Close post a `seadrill-help-ack_*`
record through the same intake. This second flow, **TSC Help Acknowledgements**, picks that record up,
finds the request's delivery receipt (who the request went to, which chat it opened, its mode), and
sends the acknowledgement **to the same people, under the same subject with `RE:` in front**, so
Outlook files it in the same conversation as the request, and **posts the same words into the Teams
chat** the request created. Nothing new is created: no second chat, no new audience. If the request has
no receipt (the flow never ran for it), the acknowledgement goes to the office only, marked as such.

Everything in **SEADRILL-WC-DEV**, the same workbook, the same connections.

1. **+ Create**, **Automated cloud flow**, name `TSC Help Acknowledgements`, trigger **When a file is
   created (properties only)** (SharePoint), Site **WellControl**, Library **PostedReports**.
2. **Condition**, rename **IsAck**: left box fx
```
and(startsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), 'seadrill-help-ack_'), endsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), '.json'))
```
   is equal to `true`. Everything else goes in **True**.
3. **Get file content** (SharePoint): Site WellControl, File Identifier = the trigger's **Identifier**.
4. **Parse JSON**: Content = **File Content**; Schema:
```
{"type":"object","properties":{"meta":{"type":"object","properties":{"kind":{"type":"string"},"tool":{"type":"string"},"asset":{"type":"string"},"rigkey":{"type":"string"},"saved":{"type":"string"}}},"requestId":{"type":"string"},"action":{"type":"string"},"by":{"type":"string"},"role":{"type":"string"},"at":{"type":"string"},"comment":{"type":"string"},"subject":{"type":"string"},"attachments":{"type":"array"}}}
```
5. **SettingsRow**, **TestMode**, **OfficeRows** / **OfficeEmails** / **OfficeList**: the same cards as
   Part B steps 5 and 8 (only the office list is needed here).
   Compose **TestAsset**: `equals(toLower(coalesce(body('Parse_JSON')?['meta']?['asset'],'')), 'ssce equipment')`.
   Compose **Guard**: `or(equals(outputs('TestMode'), true), equals(outputs('TestAsset'), true))`.
6. Composes:
   **ReqId**: `coalesce(body('Parse_JSON')?['requestId'], '')`.
   **RigName**: `coalesce(body('Parse_JSON')?['meta']?['asset'], 'Unknown rig')`.
   **Subj**: `coalesce(body('Parse_JSON')?['subject'], 'Assistance request')`.
   **Action**: `toLower(coalesce(body('Parse_JSON')?['action'], 'acknowledge'))`.
   **ActionText**:
```
if(equals(outputs('Action'), 'close'), 'CLOSED', if(equals(outputs('Action'), 'update'), 'UPDATE', 'ACKNOWLEDGED - Technical Services are on it'))
```
   **Who**: `concat(coalesce(body('Parse_JSON')?['by'], 'Technical Services'), if(empty(coalesce(body('Parse_JSON')?['role'], '')), '', concat(' (', body('Parse_JSON')?['role'], ')')))`.
   **Comment**: `coalesce(body('Parse_JSON')?['comment'], '')`.
   **HelpLink**: `http://sdrlazneuiis01d.corp.local:8080/sacred/help/help-centre.html`.
7. **Get files (properties only)** (SharePoint), rename **ReceiptFiles**: Site WellControl, Library
   **Digests**, Folder `/help-receipts` (pick it with the folder icon), Filter Query fx
```
startswith(FileLeafRef, concat('help-receipt_', outputs('ReqId'), '_'))
```
8. **Filter array**, rename **AssistanceReceipts**: From `body('ReceiptFiles')?['value']`, condition
   (Edit in advanced mode) fx
```
@not(contains(item()?['{FilenameWithExtension}'], '_directive_'))
```
   (the six-hour chat's receipt shares the prefix and is not the one wanted).
9. **Condition**, rename **HasReceipt**: fx `greater(length(body('AssistanceReceipts')), 0)` is equal to `true`.
10. In **HasReceipt / True**:
    - **Get file content** (SharePoint), rename **ReceiptContent**: Site WellControl, File Identifier fx
      `last(body('AssistanceReceipts'))?['{Identifier}']` (the newest receipt when there are several).
    - **Parse JSON**, rename **Receipt**: Content = **File Content** of ReceiptContent; Schema:
```
{"type":"object","properties":{"requestId":{"type":"string"},"kind":{"type":"string"},"ok":{"type":"boolean"},"sentTo":{"type":"array","items":{"type":"string"}},"sentAt":{"type":"string"},"error":{"type":"string"},"chatCreated":{"type":"boolean"},"chatId":{"type":"string"},"mode":{"type":"string"}}}
```
    - Compose **SendTo**: `if(equals(outputs('Guard'), true), outputs('OfficeList'), join(body('Receipt')?['sentTo'], ';'))`
      (the receipt already holds exactly who the request went to; under the guard, the office only).
    - Compose **Subject**:
```
concat('RE: ', if(equals(outputs('Guard'), true), '[TEST MODE] ', ''), coalesce(body('Receipt')?['mode'], 'ASSISTANCE REQUEST'), ' - ', outputs('RigName'), ' - ', outputs('Subj'))
```
      This is the request's subject with `RE:` in front; Outlook groups it into the same conversation.
    - Compose **Text** (plain text, one card so the email and the chat say the same):
```
@{outputs('ActionText')}
@{outputs('RigName')} - @{outputs('Subj')}
By: @{outputs('Who')} on @{coalesce(body('Parse_JSON')?['at'], formatDateTime(utcNow(),'yyyy-MM-dd'))}
@{outputs('Comment')}
The trail is on the TSC Help Centre (password): @{outputs('HelpLink')}
Technical Services - Well Control Engineering
```
    - **Send an email (V2)**, rename **AckEmail**: To fx `outputs('SendTo')`, Subject fx `outputs('Subject')`,
      Body pasted as plain text: `@{outputs('Text')}`. Importance Normal.
    - **Condition**, rename **HasChat**: fx `not(empty(coalesce(body('Receipt')?['chatId'], '')))` is equal to `true`.
      **True:** **Post message in a chat or channel** (Teams), rename **ChatAck**: Post as **Flow bot**,
      Post in **Group chat**, Group chat fx `body('Receipt')?['chatId']`, Message fx `outputs('Text')`.
      **False:** nothing.
11. In **HasReceipt / False**: **Send an email (V2)**, rename **AckNoReceipt**: To `outputs('OfficeList')`,
    Subject fx `concat('RE: ', outputs('RigName'), ' - ', outputs('Subj'), ' (no delivery receipt for the request)')`,
    Body: `@{outputs('Text')}` with a first line `This request has no delivery receipt, so the acknowledgement went to the office only. Forward it to the rig by hand if the request email never went.`
12. **Save.**

**No receipt is written for an acknowledgement.** The trail on the Help Centre page is the record of
who acknowledged what and when; the scanner already shows it. (A receipt of kind `ack` would be read as
the request's own receipt by scanner v2.71 and must not be written.)

**Proof, in test mode (after Part C):** on the Help Centre, acknowledge the SSCE Equipment test request
with a name, a role and a note. Expect within fifteen minutes: the office gets `RE: [TEST MODE] RIG DOWN -
SSCE Equipment - …`, sitting under the request in Outlook's conversation view, with the note in it; the
same words appear as a new message in the `[TEST] SSCE Equipment - <date> - …` chat; the Help Centre
card shows the acknowledgement in its trail after the next scan. Then close it from the page and expect
the same again with `CLOSED`.

**Limits, said plainly:** the acknowledgement is a new message with the same subject, not a reply to
the original message id, so a mailbox with conversation view off shows it as its own email under the
same title. The Teams post is genuinely in the same chat. A person replying to the email by hand stays in
the conversation as normal, but that reply is not on the Help Centre; only what is posted from the page is.

## If it misfires

- **No run:** the file name does not start `seadrill-help_`, or the trigger has not polled (up to
  fifteen minutes).
- **Went to the office only, no red line expected:** B2 is `Yes`, or the payload has `dryRun` true,
  or the asset is SSCE Equipment. All three are by design.
- **Create a chat fails with "member not found":** an address in SendTo is not a Seadrill account
  (a distribution list, or a typo on a sheet). Chats take people, not lists; put the list's members
  on the sheet, or leave the list to the email only by building the chat members from
  `outputs('RigFour')`, `outputs('FixedList')` and the office alone.
- **Receipt missing on the Help Centre:** the `help-receipts` folder is not under the Digests
  library, or `helpReceiptPath` in config.json points elsewhere. The scan output names the folder
  it read.
- **Part F: the acknowledgement went to the office with "(no delivery receipt for the request)":** the
  request's receipt file is not in `/Digests/help-receipts`, or its name does not start
  `help-receipt_<requestId>_`. Open the folder and check.
- **Part F: no message in the chat:** the receipt's `chatId` is empty because Create a chat failed on the
  request (see the member-not-found line above); the email still went.
- **The receipt says sent but nobody got it:** the email went to the addresses in `sentTo`; open
  the receipt file and compare with the sheets.
