# The project folder: flow `Plan Files`, click by click, all in one place (plan item 55)

**What it does.** Every 15 minutes it reads `plan-files.json` (scanner v2.97 writes it beside the receipts: every plan
SACRED knows, the eight subfolders, and every post tied to the plan by reference with the subfolder it belongs in).
For a plan it has not seen it creates the folder tree under the **Between Wells Maintenance** library; for every file
not yet in its subfolder it copies the file from PostedReports. Copies, never moves: PostedReports stays the record.
A test plan files under `<planId> TEST`, so the proof never mixes with a real project. About 20 cards, 40 minutes.

**Before you start, once.** On the WellControl site: Site contents, **+ New**, **Document library**, name
`Between Wells Maintenance`, Create. Nothing else; the flow makes every folder under it.

1. Power Automate, **+ Create**, **Scheduled cloud flow**. Name `Plan Files`. Repeat every **15 Minute**. **Create**.
2. **+ New step**, **Get file content using path** (SharePoint). Site Address **WellControl**. File Path
   `/Digests/help-receipts/plan-files.json`. Rename the card **FilesList**.
3. **+ New step**, **Condition**, rename **HasFile**. Left: fx `empty(body('FilesList'))`. **is equal to**. Right:
   `false`. Everything below goes inside **True**.
4. **Parse JSON**, rename **Plans**. Content: fx `body('FilesList')`. Schema, paste:
```
{"type":"object","properties":{"plans":{"type":"array","items":{"type":"object","properties":{"planid":{"type":"string"},"folder":{"type":"string"},"istest":{"type":"boolean"},"rig":{"type":"string"},"subfolders":{"type":"array","items":{"type":"string"}},"files":{"type":"array","items":{"type":"object","properties":{"file":{"type":"string"},"kind":{"type":"string"},"reporttype":{"type":"string"},"subfolder":{"type":"string"},"path":{"type":"string"}}}}}}}}}
```
5. **Apply to each**, rename **EachPlan**. Select an output: fx `body('Plans')?['plans']`. Steps 6 to 16 go inside.
6. **Compose**, rename **FolderName**. Inputs: fx `items('EachPlan')?['folder']`.
7. **Get files (properties only)** (SharePoint), rename **FolderReceipt**. Site WellControl, Library **Digests**,
   Limit Entries to Folder `help-receipts`, Filter Query: fx
   `concat('FileLeafRef eq ''plan-folder-receipt_', replace(outputs('FolderName'), ' ', '_'), '.json''')`, Top Count `1`.
8. **Condition**, rename **IsNewFolder**. Left: fx `length(body('FolderReceipt')?['value'])`. **is equal to**. Right:
   `0`. Inside **True**, three cards (9 to 11). False stays empty.
9. **Create new folder** (SharePoint). Site WellControl. List or Library **Between Wells Maintenance**. Folder Path:
   fx `outputs('FolderName')`.
10. **Apply to each**, rename **EachSubfolder**. Select an output: fx `items('EachPlan')?['subfolders']`. Inside it one
    card: **Create new folder**, Site WellControl, Library **Between Wells Maintenance**, Folder Path: fx
    `concat(outputs('FolderName'), '/', items('EachSubfolder'))`.
11. After EachSubfolder, still inside IsNewFolder = True: **Create file** (SharePoint). Site WellControl. Folder Path
    `/Digests/help-receipts`. File Name: fx `concat('plan-folder-receipt_', replace(outputs('FolderName'), ' ', '_'), '.json')`.
    File Content: fx `concat('{"planid":"', items('EachPlan')?['planid'], '","folder":"', outputs('FolderName'), '","at":"', utcNow(), '"}')`.
12. Back at the EachPlan level, after the IsNewFolder condition: **Apply to each**, rename **EachFile**. Select an
    output: fx `items('EachPlan')?['files']`. Steps 13 to 16 go inside.
13. **Condition**, rename **HasPath**. Left: fx `empty(items('EachFile')?['path'])`. **is equal to**. Right: `false`.
    Inside **True** (a file in PostedReports; the others are reports from the laptop folders and are skipped for now):
14. **Get files (properties only)**, rename **Existing**. Site WellControl, Library **Between Wells Maintenance**,
    Limit Entries to Folder: fx `concat(outputs('FolderName'), '/', items('EachFile')?['subfolder'])`, Filter Query: fx
    `concat('FileLeafRef eq ''', items('EachFile')?['file'], '''')`, Top Count `1`.
15. **Condition**, rename **NotYetCopied**. Left: fx `length(body('Existing')?['value'])`. **is equal to**. Right: `0`.
16. Inside NotYetCopied = True: **Copy file** (SharePoint). Current Site Address **WellControl**. File to Copy: fx
    `items('EachFile')?['path']`. Destination Site Address **WellControl**. Destination Folder: fx
    `concat('/Between Wells Maintenance/', outputs('FolderName'), '/', items('EachFile')?['subfolder'])`.
    If another file is already there: **Replace**.
17. **Save**. Flow checker clean. The usual three if not: a token where an fx should be, a card not renamed, a connection.
18. **Prove it.** The West Vela sample plan is on the Plans tab as a test plan, so `plan-files.json` already lists it
    under `WVE-BOP1-20261005 TEST` with its plan post, the reviews you and Lee posted today and the planlink record.
    **Test**, **Manually**, **Run flow**. Then open the Between Wells Maintenance library: a folder
    `WVE-BOP1-20261005 TEST` with eight subfolders, the plan post and the reviews under 01 Plan and Scope. Run it
    again: nothing copies twice. Leave the test folder; it is the worked example for the class.

**What is not in this first version, on purpose.** A post with no plan reference is not filed (no window guessing).
Reports that reached the scanner from the laptop's Technical Services folders rather than PostedReports carry no
SharePoint path and are skipped until the scanner moves. The PDF of a signed checklist into 08 is the headless Edge step
after the server move (70.3.2).
