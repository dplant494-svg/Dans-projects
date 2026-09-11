# Precharge notifications only — one small flow, click by click

**For:** Dan
**Date:** 2026-09-09
**Scope:** every posted file whose name contains `precharge`. Two kinds:

| Posted file | Who posts it | Goes TO | CC |
|---|---|---|---|
| **Request** `seadrill-request_<rig>_<well>_<date>_precharge.json` | the rig, from the SSORT request form | Office table: Dan, Lee, Joao | — |
| **Issued precharge** `seadrill-report_<rig>_<date>_precharge.json` | you, from the calculator's Post to Dashboard | that rig's Subsea Supervisor **and Technical Section Leader** (Rigs table, `SubseaSupervisorEmail` + `TSLEmail`) | Office table |

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
13b. **Compose**, rename **RigTo** — the rig-side To line (supervisor plus
    TSL, either may be blank). Expression:
    ```
    join(union(split(concat(coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['TSLEmail'],'')),';'),json('[]')),';')
    ```
    Then in step 14 use `outputs('RigTo')` for the ISSUED email's To, and
    test `outputs('RigTo')` (not SupervisorEmail) for the NO RIG CONTACT
    condition.

## Part F — send (5 minutes)

14. **Condition**: `outputs('Kind')` **is equal to** `REQUEST`.

    **If yes** → **Send an email (V2)**:
    - To: `@{outputs('OfficeList')}`
    - Subject: `[Precharge REQUEST] @{outputs('RigName')} — @{outputs('Well')} — BOP @{body('Parse_JSON')?['meta']?['bop']}`
    - Body (HTML):
      ```html
      <p>A precharge request has been posted from <b>@{outputs('RigName')}</b>.</p>
      <p>Well: @{outputs('Well')} · BOP: @{body('Parse_JSON')?['meta']?['bop']} · Raised by: @{body('Parse_JSON')?['meta']?['raisedBy']}</p>
      <p>Shear required: @{body('Parse_JSON')?['fields']?['shReqTop']?['v']} psig · MAWHP: @{body('Parse_JSON')?['fields']?['mawhpTop']?['v']} psi · Water depth: @{body('Parse_JSON')?['fields']?['wd']?['v']}</p>
      <p><a href="http://sdrlazneuiis01d.corp.local:8080/sacred/precharge/calculator.html">Open Precharge Pro</a> — it is on the Requests tab within 10 minutes of posting.</p>
      ```

    **If no** (an issued precharge) → **Condition**: `outputs('SupervisorEmail')`
    **is not equal to** empty.
    - If yes → **Send an email (V2)**: To `@{outputs('SupervisorEmail')}`,
      CC `@{outputs('OfficeList')}`, Subject
      `[Precharge ISSUED] @{outputs('RigName')} — @{outputs('Well')} — BOP @{body('Parse_JSON')?['meta']?['bop']}`, Body:
      ```html
      <p>The precharge sheet for <b>@{outputs('RigName')}</b>, well @{outputs('Well')}, BOP @{body('Parse_JSON')?['meta']?['bop']} has been issued.</p>
      <p><a href="http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html?report=@{triggerOutputs()?['body/{FilenameWithExtension}']}">Open the issued sheet on the dashboard</a></p>
      ```
    - If no → **Send an email (V2)**: To `@{outputs('OfficeList')}`, Subject
      `[NO RIG CONTACT] Precharge issued — @{outputs('RigName')} — @{outputs('Well')}`,
      body "No Subsea Supervisor email is on the Rigs sheet for this rig."

15. **Save**. Turn it on if it is not already.

## Part G — test (10 minutes)

1. On the Rigs sheet put **your own** address as the Subsea Supervisor for
   one rig, save, close.
2. Post a request from SSORT for that rig → one email, `[Precharge REQUEST]`,
   to Dan, Lee and Joao.
3. Issue it from the calculator and Post to Dashboard → one email,
   `[Precharge ISSUED]`, to you as "supervisor", CC the three; the link opens
   the sheet.
4. Put the real supervisor address back.

## If it misfires

- **Nothing arrives:** open the flow's run history. A red step names the
  problem. Most often the workbook is open, or the file name does not
  contain `precharge`.
- **Issued mail says NO RIG CONTACT:** the Vessel on the Rigs sheet does not
  match `meta.asset` in the file, or the yellow cell is empty.
- **Request has no rig name** (older form): the RigKey column catches it as
  long as the short code (e.g. `libongos`) is on the sheet. All thirteen are.
