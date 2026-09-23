# Precharge notifications only — one small flow, click by click

**For:** Dan
**Date:** 2026-09-09 · **as built 23 Sep 2026** (test mode on, ARM and Rig Manager on the ISSUED To; proven with a West Tellus resubmit in test mode)
**Scope:** every posted file whose name contains `precharge`. Two kinds:

| Posted file | Who posts it | Goes TO | CC |
|---|---|---|---|
| **Request** `seadrill-request_<rig>_<well>_<date>_precharge.json` | the rig, from the SSORT request form | Office table: Dan, Lee, Joao, Ronnie | — |
| **Issued precharge** `seadrill-report_<rig>_<date>_precharge.json` | you, from the calculator's Post to Dashboard | that rig's Subsea Supervisor, Technical Section Leader, Assistant Rig Manager and Rig Manager (Rigs table, `SubseaSupervisorEmail` + `TslEmail` + `ARMEmail` + `RigManagerEmail`, blanks skipped) | Office table |

**Test mode (23 Sep):** while `Settings!TestMode` is `Yes` every one of the three emails goes
to the Office table only, with `[TEST MODE] ` in front of the subject; the ISSUED email also
carries a red line naming the rig addresses the real run would have used. `No` is live. See
`NOTIFICATION-TEST-MODE-GUIDE.md`; cards `SettingsRow` and `TestMode` sit after Parse JSON.

**File you need:** `WCE_Precharge_Notification.xlsx` (sent with this). Two
tables: **Office** (the three addresses, already filled) and **Rigs** (one
row per rig, fill the Subsea Supervisor name and email in the yellow cells).
Vessel names are already the exact names the files carry; the RigKey column
covers requests from the older form that carry no rig name.

This is a **new, separate flow**. Report Post Test and the posting flow are
not touched.

---

## Part A — the workbook (5 minutes)

1. Fill the yellow cells on the **Rigs** sheet. Leave blank where there is no
   contact yet. Save, close.
2. Upload to the **WellControl** SharePoint site → Documents → a folder
   called **`Notifications`**. Keep it closed while the flow runs.

## Part B — create the flow (3 minutes)

1. `make.powerautomate.com` → **+ Create** → **Automated cloud flow**.
   Name: **Precharge Notifications**. Trigger: search **SharePoint**, pick
   **When a file is created in a folder**. Create.
2. Site Address: WellControl. Folder Id: browse to **PostedReports**.
   (Same trigger as Report Post Test; two flows on one folder is fine.)

## Part C — only carry on for precharge files (2 minutes)

3. **+ New step** → **Condition**. Left box: click **Expression**, paste
   ```
   contains(toLower(triggerOutputs()?['body/{FilenameWithExtension}']),'precharge')
   ```
   Operator **is equal to**, right box: Expression `true`.
   Everything below goes in the **If yes** branch. Leave **If no** empty.

## Part D — read the file (5 minutes)

4. **SharePoint → Get file content**. Site: WellControl. File Identifier:
   **Identifier** from the trigger.
5. **Parse JSON**. Content: **File Content**. Schema:
   ```json
   {
     "type": "object",
     "properties": {
       "meta": { "type": "object", "properties": {
         "asset": { "type": ["string","null"] }, "source": { "type": ["string","null"] },
         "saved": { "type": ["string","null"] }, "raisedBy": { "type": ["string","null"] },
         "email": { "type": ["string","null"] }, "bop": { "type": ["string","null"] },
         "date": { "type": ["string","null"] }, "well": { "type": ["string","null"] },
         "rigKey": { "type": ["string","null"] }
       } },
       "config": { "type": ["string","null"] },
       "fields": { "type": ["object","null"], "properties": {
         "well": { "type": ["object","null"], "properties": { "v": { "type": ["string","null"] } } },
         "wd": { "type": ["object","null"], "properties": { "v": { "type": ["string","null"] } } },
         "shReqTop": { "type": ["object","null"], "properties": { "v": { "type": ["string","null"] } } },
         "mawhpTop": { "type": ["object","null"], "properties": { "v": { "type": ["string","null"] } } }
       } }
     }
   }
   ```
   Rename the step **Parse JSON**.

6. **Compose**, rename **Kind**. Expression:
   ```
   if(startsWith(coalesce(body('Parse_JSON')?['meta']?['source'],''),'BOP Precharge Request form'),'REQUEST','ISSUED')
   ```
7. **Compose**, rename **RigKey**. Expression:
   ```
   coalesce(body('Parse_JSON')?['meta']?['rigKey'],body('Parse_JSON')?['config'],'')
   ```
8. **Compose**, rename **Well**. Expression:
   ```
   coalesce(body('Parse_JSON')?['meta']?['well'],body('Parse_JSON')?['fields']?['well']?['v'],'')
   ```

## Part E — look up the people (5 minutes)

9. **Excel Online (Business) → List rows present in a table**. Site
   WellControl, Documents, file `Notifications/WCE_Precharge_Notification.xlsx`,
   table **Office**. Rename **OfficeRows**.
10. Same action again, table **Rigs**, Show advanced options → Filter Query:
    ```
    Vessel eq '@{coalesce(body('Parse_JSON')?['meta']?['asset'],'')}' or RigKey eq '@{outputs('RigKey')}'
    ```
    (Type the text; for each `@{...}` click Expression and enter what is
    inside the braces.) Rename **RigRow**.
11. **Compose**, rename **OfficeList**. Expression:
    ```
    join(map(body('OfficeRows')?['value'], item()?['Email']),';')
    ```
    If your designer rejects `map`, use instead a **Select** action on
    OfficeRows value with Map = `item()?['Email']`, then `join(body('Select'),';')`.
12. **Compose**, rename **RigName**. Expression:
    ```
    coalesce(first(body('RigRow')?['value'])?['Vessel'],body('Parse_JSON')?['meta']?['asset'],outputs('RigKey'))
    ```
13. **Compose**, rename **SupervisorEmail**. Expression:
    ```
    coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],'')
    ```
13b. **Compose**, rename **RigTo** — the rig-side To line (supervisor, TSL,
    ARM and Rig Manager; any may be blank). Expression as built 23 Sep:
    ```
    join(union(split(concat(coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['TslEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['ARMEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['RigManagerEmail'],'')),';'),json('[]')),';')
    ```
    Then in step 14 use `outputs('RigTo')` for the ISSUED email's To, and
    test `outputs('RigTo')` (not SupervisorEmail) for the NO RIG CONTACT
    condition.

## Part F — send (5 minutes)

14. **Condition**: `outputs('Kind')` **is equal to** `REQUEST`.

    **If yes** → **Send an email (V2)**:
    - To: `@{outputs('OfficeList')}`
    - Subject: `@{if(equals(outputs('TestMode'), true), '[TEST MODE] ', '')}[Precharge REQUEST] @{outputs('RigName')} — @{outputs('Well')} — BOP @{body('Parse_JSON')?['meta']?['bop']}`
    - Body (HTML):
      ```html
      <p>A precharge request has been posted from <b>@{outputs('RigName')}</b>.</p>
      <p>Well: @{outputs('Well')} · BOP: @{body('Parse_JSON')?['meta']?['bop']} · Raised by: @{body('Parse_JSON')?['meta']?['raisedBy']}</p>
      <p>Shear required: @{body('Parse_JSON')?['fields']?['shReqTop']?['v']} psig · MAWHP: @{body('Parse_JSON')?['fields']?['mawhpTop']?['v']} psi · Water depth: @{body('Parse_JSON')?['fields']?['wd']?['v']}</p>
      <p><a href="http://sdrlazneuiis01d.corp.local:8080/sacred/precharge/calculator.html">Open Precharge Pro</a> — it is on the Requests tab within 10 minutes of posting.</p>
      ```

    **If no** (an issued precharge) → **Condition** `HasRigContact`: `outputs('RigTo')`
    **is not equal to** empty.
    - If yes → **PreCHARGE iSSUED** (Send an email V2): To
      `@{if(equals(outputs('TestMode'), true), outputs('OfficeList'), outputs('RigTo'))}`,
      CC `@{outputs('OfficeList')}`, Subject
      `@{if(equals(outputs('TestMode'), true), '[TEST MODE] ', '')}[Precharge ISSUED] @{outputs('RigName')} — @{outputs('Well')} — BOP @{body('Parse_JSON')?['meta']?['bop']}`, Body, first line:
      ```
      @{if(equals(outputs('TestMode'), true), concat('<p style="color:#b00"><b>TEST MODE. Real run would go To: ', outputs('RigTo'), '<br>CC: ', outputs('OfficeList'), '</b></p>'), '')}
      ```
      then:
      ```html
      <p>The precharge sheet for <b>@{outputs('RigName')}</b>, well @{outputs('Well')}, BOP @{body('Parse_JSON')?['meta']?['bop']} has been issued.</p>
      <p><a href="http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html?report=@{triggerOutputs()?['body/{FilenameWithExtension}']}">Open the issued sheet on the dashboard</a></p>
      ```
    - If no → **Send an email (V2) 2**: To `@{outputs('OfficeList')}`, Subject
      `@{if(equals(outputs('TestMode'), true), '[TEST MODE] ', '')}[NO RIG CONTACT] Precharge issued — @{outputs('RigName')} — @{outputs('Well')}`,
      body "No Subsea Supervisor email is on the Rigs sheet for this rig."

15. **Save**. Turn it on if it is not already.

## Part G — test (5 minutes, no address swapped)

1. Settings sheet, in the browser: **B2** `Yes`, wait for Saved. Never leave
   the workbook open in Excel on the PC while a run fires: the flow reads the
   file on SharePoint, not the copy on your screen, and Excel holds the edit
   until it saves (this is exactly what happened 23 Sep: first resubmit went
   live to West Tellus, second one after closing Excel came back in test mode).
2. Run history: pick a run whose **Kind** output is `ISSUED` (the long ones;
   0 s runs stopped at the first Condition because the file was not a
   precharge) and **Resubmit**. One email, `[TEST MODE] [Precharge ISSUED]`,
   to the office four only, red line naming the rig's four addresses.
3. Settings **B2** `No`, wait for Saved. Live again.

## If it misfires

- **Nothing arrives:** open the flow's run history. A red step names the
  problem. Most often the workbook is open, or the file name does not
  contain `precharge` (grey minus signs under True, run 0 s: not a precharge
  file, nothing to fix, pick another run).
- **Test mode did not take:** the workbook was open in Excel on the PC when
  the run fired. Save, close, check B2 in the browser, resubmit.
- **Issued mail says NO RIG CONTACT:** the Vessel on the Rigs sheet does not
  match `meta.asset` in the file, or all four contact cells are empty.
- **Request has no rig name** (older form): the RigKey column catches it as
  long as the short code (e.g. `libongos`) is on the sheet. All thirteen are.
