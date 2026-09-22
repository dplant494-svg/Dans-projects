# Rig visit report email with a dashboard link — build guide (loop two)

**For:** Dan · **Date:** 13 September 2026 · **Week plan item 6**
**Pattern:** `NOTIFICATION-LOOP-PATTERN.md`. Same shape as the Precharge Notifications
flow you built on 11 September, with the lessons from it applied.
**Result:** every rig visit report posted from WCGRRT sends one email to the rig's
contacts, CC the office, with the rig, visit type, dates, who visited, how many actions
and critical items were raised, and a link that opens that report on the dashboard.
**No attachment.** The dashboard is the report.

Time: about 40 minutes, in six parts. Parts A and B are once; the rest is the flow.

---

## Part A — two columns on the Rigs sheet (5 minutes)

The recipients live in the workbook you already have,
`PostedReports/Notifications/WCE_Precharge_Notification.xlsx`. Open it from the
SharePoint site in the browser, not from the synced folder.

1. **Rigs** sheet. **Done 22 Sep while building the CBM to OEM flow:** the headers after
   `TslEmail` are `OIMEmail`, `RigEngineerEmail`, `ARMEmail`, `RigManagerEmail`,
   `ESVEmail`, `DSLEmail`, `MPDEmail`. OIM, Rig Engineer, ARM and Rig Manager are filled.
   ESV (Electrical Supervisor), DSL (Drilling Section Leader) and MPD (MPD Supervisor)
   are empty and are for this flow: fill them in Part A, and the RigTo expression in
   Part D step 11 gains those three columns plus `RigManagerEmail`, the same
   `coalesce(first(body('RigRow')?['value'])?['<column>'],'')` piece per column. The blue table extends itself to
   include them; if it does not, click any cell in the table, **Table Design**,
   **Resize Table**, and drag the range to column H.
2. Fill in the OIM, Rig Engineer and ARM addresses for each vessel you want to receive
   visit reports. Leave a cell blank where there is nobody; the flow skips blanks.
3. Close the workbook. It must be closed whenever the flow runs.

The **Office** sheet is shared with the precharge flow: everyone on it gets every
loop. If someone should get visit reports but not precharge, tell me and we add a
column instead.

## Part B — decide who the "no rig contact" mail goes to

When a report's rig has no row on the Rigs sheet, or the row has no addresses, the
flow emails the office with **NO RIG CONTACT** in the subject, exactly as the
precharge flow does. Nothing is ever dropped silently. No setup needed; just know it
will happen for any rig you have not filled in.

## Part C — the flow, trigger to parse (10 minutes)

1. `https://make.powerautomate.com`, **+ Create**, **Automated cloud flow**.
2. Name: `Rig Visit Notifications`. In the trigger search box type
   `when a file is created (properties only)` and pick the **SharePoint** one. **Create**.
3. Trigger card: **Site Address** = the WellControl site. **Library Name** =
   PostedReports. Leave Folder blank.
4. **+ New step**, search `Condition`, add it. This is the cheap filter so the flow
   exits in milliseconds for every file that is not a rig visit report. Click the
   left box, **fx**, paste, **Add**:

```
and(startsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), 'seadrill-report_'), endsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), '.json'), not(contains(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), 'precharge')))
```

   Operator **is equal to**, right box **true**. Everything else goes in the **True**
   branch. Leave **False** empty.
5. In **True**: **+ Add an action**, search `Get file content`, pick the **SharePoint**
   one. **Site Address** = WellControl. **File Identifier**: click the box, lightning
   bolt, pick **Identifier** from the trigger.
6. **+ Add an action**, `Parse JSON`. **Content**: lightning bolt, **File Content**
   from Get file content. **Schema**: paste this on one line:

```
{"type":"object","properties":{"meta":{"type":"object","properties":{"asset":{"type":"string"},"type":{"type":"string"},"reporttype":{"type":"string"},"discipline":{"type":"string"},"date":{"type":"string"},"dateend":{"type":"string"},"wce":{"type":"string"},"location":{"type":"string"},"planningOnly":{"type":"boolean"}}},"actionRows":{"type":"array"},"criticalRows":{"type":"array"}}}
```

## Part D — is it a rig visit, and who gets it (10 minutes)

Name every card **before** writing an expression that refers to it. Each **Compose**
card below: **+ Add an action**, `Compose`, click the card title, **Rename**, type the
name, then click **fx** in the Inputs box, paste, **Add**.

1. **IsVisit** — a WCGRRT rig visit carries a visit classification in `meta.type`,
   no `meta.reporttype` (SSORT exports set that), a rig, and is not Marine or a
   planning report:

```
and(not(empty(coalesce(body('Parse_JSON')?['meta']?['type'],''))), empty(coalesce(body('Parse_JSON')?['meta']?['reporttype'],'')), not(empty(coalesce(body('Parse_JSON')?['meta']?['asset'],''))), not(equals(coalesce(body('Parse_JSON')?['meta']?['discipline'],''),'Marine')), not(equals(coalesce(body('Parse_JSON')?['meta']?['planningOnly'],false),true)))
```

2. **Condition** (add after IsVisit): left box **fx** `outputs('IsVisit')`, **is equal
   to**, right box **true**. Everything below goes in this **True** branch.
3. **RigName** — `coalesce(body('Parse_JSON')?['meta']?['asset'],'')`
4. **Visit** — the subject line pieces:

```
concat(coalesce(body('Parse_JSON')?['meta']?['type'],'Rig Visit'), ' - ', coalesce(body('Parse_JSON')?['meta']?['date'],''), if(empty(coalesce(body('Parse_JSON')?['meta']?['dateend'],'')), '', concat(' to ', body('Parse_JSON')?['meta']?['dateend'])), ' - ', coalesce(body('Parse_JSON')?['meta']?['wce'],''))
```

5. **Counts** — `concat(string(length(coalesce(body('Parse_JSON')?['actionRows'],json('[]')))), ' action(s) raised, ', string(length(coalesce(body('Parse_JSON')?['criticalRows'],json('[]')))), ' critical item(s)')`
6. **Link** — `concat('http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html?report=', encodeUriComponent(triggerOutputs()?['body/{FilenameWithExtension}']))`
7. **OfficeRows** — **+ Add an action**, `List rows present in a table` (Excel Online
   (Business)). Location: SharePoint Site - WellControl. Document Library:
   PostedReports. File: `/Notifications/WCE_Precharge_Notification.xlsx`. Table:
   **Office**. Rename the card **OfficeRows**.
8. **OfficeEmails** — **+ Add an action**, `Select` (Data Operation). **From**: fx
   `body('OfficeRows')?['value']`. Click the small **switch to text mode** icon at
   the right of the Map box, then fx `item()?['Email']`. Rename **OfficeEmails**.
9. **OfficeList** — Compose: `join(body('OfficeEmails'),';')`
10. **RigRow** — another `List rows present in a table`, same workbook, Table
    **Rigs**. Open **Advanced parameters**, tick **Filter Query** and **Top Count**.
    Filter Query: clear the box completely, then **fx**, paste, **Add**:

```
concat('Vessel eq ''', trim(outputs('RigName')), '''')
```

    Top Count: `1`. Rename **RigRow**. (This is the filter that bit us last time:
    one expression, no hand-typed quotes.)
11. **RigTo** — Compose. Joins the five rig addresses, skipping blanks:

```
join(union(split(concat(coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['TslEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['OIMEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['RigEngineerEmail'],''),';',coalesce(first(body('RigRow')?['value'])?['ARMEmail'],'')),';'),json('[]')),';')
```

    Because `split` leaves empty strings for blank cells, add one more Compose
    **RigToClean** right after it:

```
join(union(split(replace(replace(concat(';',outputs('RigTo'),';'),';;',';'),';;',';'),';'),json('[]')),';')
```

## Part E — the two emails (10 minutes)

1. **Condition** named **HasRigContact**: left box fx `outputs('RigToClean')`,
   **is not equal to**, right box **left completely empty**.
2. **True** branch, **Send an email (V2)**. In **To**, click the gear at the right,
   **custom value**, fx `outputs('RigToClean')`. **CC**: same, fx `outputs('OfficeList')`.
   Subject:

```
[Rig Visit Report] @{outputs('RigName')} - @{outputs('Visit')}
```

   Body (switch the body to code view with the `</>` button and paste):

```
<p>A Well Control Engineering rig visit report has been posted for <b>@{outputs('RigName')}</b>.</p>
<p><b>@{outputs('Visit')}</b><br>@{outputs('Counts')}</p>
<p><a href="@{outputs('Link')}">Open this report on the Rig Visit Dashboard</a></p>
<p>The dashboard is the report: photographs, actions, critical items and the full text are there, and it is always the current version. Nothing is attached to this email.</p>
<p>Technical Services - Subsea<br>Daniel Plant - daniel.plant@seadrill.com<br>Lee Arnold - lee.arnold@seadrill.com<br>Joao Almeida - Joao.Almeida@seadrill.com</p>
```

   Rename the card **Rig Visit Email**.
3. **False** branch, **Send an email (V2)**. **To**: custom value, fx
   `outputs('OfficeList')`. Subject:

```
[NO RIG CONTACT] Rig visit report posted - @{outputs('RigName')} - @{outputs('Visit')}
```

   Body: `No rig addresses are on the Rigs sheet for this vessel. Report: @{outputs('Link')}`.
   Rename **No Rig Contact Email**.
4. **Save**. Fix anything red before moving on.

## Part F — test with yourself as the rig (5 minutes)

1. On the Rigs sheet put your personal address in the West Vela **OIMEmail** cell.
   Close the workbook.
2. Post a rig visit report for West Vela from WCGRRT. The flow fires on its own
   within a few minutes (the trigger polls). No resubmit games this time: every
   WCGRRT post has a unique name.
3. Open the run. Every card green; the email in your personal inbox with the link;
   click the link and the dashboard opens on that report.
4. Put the real address back.

## If it misfires

- **Flow did not run:** the file name does not start with `seadrill-report_`, or the
  trigger has not polled yet. Give it fifteen minutes.
- **Went to NO RIG CONTACT:** the Vessel cell must match `meta.asset` exactly
  (`West Vela`, not `WEST VELA`). Click **RigRow** in the run and read the Body:
  `"value": []` means no match.
- **Red on Parse JSON:** the file was not a report export. The IsVisit check would
  have skipped it anyway; ignore.
- **Ran, green, no email:** check the address in the Rigs sheet for a typo; the
  flow cannot tell a wrong address from a right one. The office CC is there so
  someone always sees the mail went out.

## Later, on the same ticket as the precharge flow

When IT provide the service identity (their step 5), both flows' email actions get
their connection switched to it. When the properties-only trigger proves reliable
here, the precharge flow gets the same trigger.
