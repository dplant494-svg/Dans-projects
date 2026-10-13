# DL-1 Plan Notifications: the flow, click by click (plan item 53)

**For Dan. Written 12 October 2026 ahead of DL-1 REV 11, so it can be built the day the first plan posts.** Same shape as
`TSC-HELP-NOTIFICATIONS-FLOW-GUIDE.md`: one automated flow on PostedReports, the workbook as the audience, the Guard for
test posts, a Teams chat per plan that lives for the whole project, and a receipt in Digests so later posts find the chat.

What it covers today: **created**, **updated**, **frozen**, **12-hour progress** and **close-out** (events 1, 2, 4, 5
and 7 in item 53). **Reviewed by all** (3) waits for the Plan Review tab, which is pinned; **testing 90%** (6) comes with
the scanner change that detects it. Both drop into the same Switch later as one more case each.

## Part A — the workbook (done except one row of columns)

Workbook `WCE_Precharge_Notification.xlsx`, as the other flows use it.

1. **Planning** table: done 12 Oct (22 rows, `Role`, `Name`, `Email`, `Send` = To or Cc).
2. **Rigs** table: fill `ESVEmail` and `DSLEmail`, add `MSLEmail` after `MPDEmail` and fill it. Blanks are allowed; the
   flow drops them. (If the position mailboxes follow the `sss.` / `oim.` pattern, a formula per column does all rigs.)
3. **Settings** `TestMode` stays as it is (No since 11 Oct). Test posts are caught by the Guard, not by TestMode.

## Part B — the flow (about an hour)

1. Power Automate, **+ Create**, **Automated cloud flow**, name `DL-1 Plan Notifications`, trigger **When a file is
   created (properties only)** (SharePoint). Site **WellControl**, Library **PostedReports**. Create.
2. **Condition**, rename **IsPlan**. Left box fx:
```
and(contains(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), '_dl1_'), endsWith(toLower(triggerOutputs()?['body/{FilenameWithExtension}']), '.json'))
```
   is equal to `true`. Everything below goes in **True**. (DL-1 names every post
   `YYYYMMDD-HHmm_<Rig>_DL1_<kind>_<BOPn>_v<n>.json`; the plan-link records SSORT posts start `seadrill-planlink_` and do
   not match, so they never notify.)
3. **Get file content** (SharePoint): Site WellControl, File Identifier = the trigger's **Identifier**.
4. **Parse JSON**: Content = fx `body('Get_file_content')` (the token, never the typed words). Schema:
```
{"type":"object","properties":{"meta":{"type":"object","properties":{"kind":{"type":"string"},"asset":{"type":"string"},"rigkey":{"type":"string"},"rev":{"type":"string"},"by":{"type":"string"},"saved":{"type":"string"},"sample":{}}},"dryRun":{},"planId":{"type":"string"},"scopeVersion":{},"plan":{"type":"object","properties":{"planId":{"type":"string"},"status":{"type":"string"},"scopeVersion":{},"bopNo":{"type":"string"},"window":{"type":"object","properties":{"from":{"type":"string"},"to":{"type":"string"}}},"changeReason":{"type":"string"},"createdBy":{"type":"string"},"frozenBy":{"type":"string"}}},"progress":{"type":"object","properties":{"planId":{"type":"string"},"pctComplete":{},"asOf":{"type":"string"}}},"closeout":{"type":"object","properties":{"planId":{"type":"string"}}}}}
```
   Every key is optional, so a progress post (no `plan` block) parses as well as a plan post.
5. The Guard, three Composes as in the help flow:
   **TestAsset** `equals(toLower(coalesce(body('Parse_JSON')?['meta']?['asset'],'')), 'ssce equipment')`;
   **DryRun** `or(equals(toLower(string(coalesce(body('Parse_JSON')?['dryRun'], false))), 'true'), equals(toLower(string(coalesce(body('Parse_JSON')?['meta']?['sample'], false))), 'true'))`;
   **Guard** `or(equals(outputs('TestAsset'), true), equals(outputs('DryRun'), true))`.
6. The facts, Composes:
   **Kind** `toLower(coalesce(body('Parse_JSON')?['meta']?['kind'], ''))`
   **PlanId** `coalesce(body('Parse_JSON')?['plan']?['planId'], body('Parse_JSON')?['progress']?['planId'], body('Parse_JSON')?['closeout']?['planId'], body('Parse_JSON')?['planId'], 'UNKNOWN')`
   **RigName** `coalesce(body('Parse_JSON')?['meta']?['asset'], 'Unknown rig')`
   **RigKey** `toLower(coalesce(body('Parse_JSON')?['meta']?['rigkey'], ''))`
   **Bop** `coalesce(body('Parse_JSON')?['plan']?['bopNo'], '')`
   **Status** `toLower(coalesce(body('Parse_JSON')?['plan']?['status'], ''))`
   **Ver** `string(coalesce(body('Parse_JSON')?['plan']?['scopeVersion'], body('Parse_JSON')?['scopeVersion'], '1'))`
   **Pct** `string(coalesce(body('Parse_JSON')?['progress']?['pctComplete'], ''))`
   **From** `coalesce(body('Parse_JSON')?['plan']?['window']?['from'], '')`
   **Reason** `coalesce(body('Parse_JSON')?['plan']?['changeReason'], '')`
   **PageLink** `http://sdrlazneuiis01d.corp.local:8080/sacred/BOP Fleet Planning Dashboard.html?rig=` then the **RigName** token on the end (one line in the box).
7. **Event**, one Compose that names the case:
```
if(equals(outputs('Kind'), 'plan-closeout'), 'closed', if(equals(outputs('Kind'), 'plan-progress'), 'progress', if(equals(outputs('Status'), 'frozen'), 'frozen', if(equals(outputs('Ver'), '1'), 'created', 'updated'))))
```
8. The audience. **RigRow**: List rows present in a table, table **Rigs**, Filter Query fx
   `concat('RigKey eq ''', outputs('RigKey'), '''')`, Top Count 1. Compose **RigTen**:
```
join(union(split(replace(concat(coalesce(first(body('RigRow')?['value'])?['OIMEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['TslEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['RigEngineerEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['ESVEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['DSLEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['MSLEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['RigManagerEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['ARMEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['OpsDirectorEmail'],'')), ';;', ';'), ';'), json('[]')), ';')
```
   **PlanToRows**: List rows present in a table, table **Planning**, Filter Query `Send eq 'To'`; **PlanToEmails**
   (Select, map `item()?['Email']`); **PlanToList** `join(body('PlanToEmails'), ';')`. The same three for Cc:
   **PlanCcRows** (`Send eq 'Cc'`), **PlanCcEmails**, **PlanCcList**.
   **OfficeRows/OfficeEmails/OfficeList** as in every flow (the test audience).
   **Regional audience (13 Oct, Dan: viewers as well as reviewers).** The Reviewers table carries everyone by region; Required = Yes
   must verify, Required = No is told but nothing waits on them. The Rigs table gains a `Region` column (GOM, Brazil, Angola,
   Namibia, Malaysia). Five cards after RigTen: **ReviewerRows** (List rows, table Reviewers, no filter); **Region** (Compose,
   `toLower(coalesce(first(body('RigRow')?['value'])?['Region'], ''))`); **RegionalRows** (Filter array, From `body('ReviewerRows')?['value']`,
   advanced `@or(contains(toLower(coalesce(item()?['Region'], '')), 'all'), and(not(empty(outputs('Region'))), contains(toLower(coalesce(item()?['Region'], '')), outputs('Region'))))`);
   **RegionalEmails** (Select, From `body('RegionalRows')`, Map `item()?['Email']`); **RegionalList** (Compose, `join(body('RegionalEmails'), ';')`).
   **Two audiences (13 Oct, Dan: the rig's ten are for reporting during execution, not for plan generation or scope freeze).**
   **RigPlan** (Compose): the rig's plan people, Subsea Supervisor, TSL, Rig Manager, ARM, Rig Engineer, Electrical Supervisor, MPD Supervisor (Dan, 13 Oct):
   `join(union(split(replace(concat(coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['TslEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['RigManagerEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['ARMEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['RigEngineerEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['ESVEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['MPDEmail'],'')), ';;', ';'), ';'), json('[]')), ';')`
   **ChatTo** (Compose): the plan chat's members, the rig's plan people and the regional reviewers, superintendents by email only:
   `join(union(split(replace(concat(outputs('RigPlan'), ';', outputs('RegionalList')), ';;', ';'), ';'), json('[]')), ';')`
   **SupRows / SupEmails / SupList**: the Superintendents table, the same three cards as the help flow.
   **AllTo** (plan events: created, updated, frozen; Dan 13 Oct: SSS, TSL, RM, ARM, Rig Engineer, the superintendents and the regional reviewers, no Planning To rows, no duplicates)
   `join(union(split(replace(concat(outputs('RigPlan'), ';', outputs('SupList'), ';', outputs('RegionalList')), ';;', ';'), ';'), json('[]')), ';')`
   **ExecTo** (execution events: progress, closed) `join(union(split(replace(concat(outputs('RigTen'), ';', outputs('PlanToList')), ';;', ';'), ';'), json('[]')), ';')`
   **To** `if(equals(outputs('Guard'), true), outputs('OfficeList'), if(or(equals(outputs('Event'), 'progress'), equals(outputs('Event'), 'closed')), outputs('ExecTo'), outputs('AllTo')))` (To sits below Event)
   **Cc** `if(equals(outputs('Guard'), true), '', outputs('PlanCcList'))`
   **Banner** `if(equals(outputs('Guard'), true), '[TEST MODE] ', '')`
9. The chat. The plan's Teams chat is created on the first post and reused for every later one, found through a receipt.
   **ReceiptRows**: SharePoint **Get files (properties only)**, Site WellControl, Library **Digests**, Folder
   `help-receipts`, Filter Query fx `concat('FileLeafRef eq ''plan-receipt_', outputs('PlanId'), '.json''')`, Top Count 1.
   **Condition HasChat**: `length(body('ReceiptRows')?['value'])` is greater than `0`.
   - **HasChat = No:** first two cards that de-duplicate the members (Teams adds the connection owner itself, so an
     address that is also on a list makes "Duplicate chat members"): Compose **MembersArr**
     `union(split(toLower(if(equals(outputs('Guard'), true), outputs('OfficeList'), outputs('ChatTo'))), ';'), json('[]'))`;
     **Filter array** renamed **MembersOk**, From `outputs('MembersArr')`, advanced mode
     `@and(not(empty(item())), not(equals(item(), 'daniel.plant@seadrill.com')))` (the connection owner's address).
     Then Teams **Create a chat**: Members fx `join(body('MembersOk'), ',')`, Title fx `outputs('PlanId')`. Then
     SharePoint **Create file**: Site WellControl, Folder `/Digests/help-receipts`, File Name
     `concat('plan-receipt_', outputs('PlanId'), '.json')`, File Content
     `concat('{"planid":"', outputs('PlanId'), '","chatid":"', outputs('Create_a_chat')?['body/id'], '","created":"', utcNow(), '"}')`.
     Compose **ChatId** = `outputs('Create_a_chat')?['body/id']`.
   - **HasChat = Yes:** **Get file content using path** (Digests, path
     `concat('/Digests/help-receipts/plan-receipt_', outputs('PlanId'), '.json')`), then Compose **ChatId** =
     `json(body('Get_file_content_using_path'))?['chatid']`.
   After the condition, Compose **Chat** = `coalesce(outputs('ChatId'), outputs('ChatId_2'))` (Power Automate numbers the
   second one; use the names it shows).
10. **Switch** on **Event**, five cases. Each case is one **Send an email (V2)** and one Teams **Post message in a chat
    or channel** (Post as Flow bot, Post in Group chat, Group chat = **Chat**, Message = the same text as the email's
    first line). Subjects, with the plan id first so the thread sorts with Brent's own files:

| Case | Subject | Body (first line) |
|---|---|---|
| created | `Banner` + `PlanId - PLAN CREATED - RigName Bop - for review` | "A new BOP maintenance plan has been posted for review. Open it: PageLink. Created by `createdBy`, window from `From`. Review it on the Help Centre Plans tab: http://sdrlazneuiis01d.corp.local:8080/sacred/help/help-centre.html#plans" |
| updated | `Banner` + `PlanId - PLAN UPDATED v` + `Ver` + ` - RigName Bop` | "The plan has been updated to scope version `Ver`. Reason: `Reason`. Earlier reviews are void; please look again: PageLink." |
| frozen | `Banner` + `PlanId - SCOPE FROZEN - RigName Bop - execute from From` | "Scope is frozen by `frozenBy`. The plan is ready for execution from `From`. Any break-in work or edit will be posted in this chat." |
| progress | no email; chat only | Message fx `concat(outputs('Banner'), 'Progress', if(empty(outputs('Pct')), ' update', concat(' ', outputs('Pct'), '%')), ' as of ', coalesce(body('Parse_JSON')?['progress']?['asOf'], ''))`: reads "Progress update" until REV 11 posts `pctComplete`. (One daily digest email to the Planning table is Part E, later.) |
| closed | `Banner` + `PlanId - PLAN CLOSED OUT - RigName Bop` | "The plan is closed out. AAR and close-out: PageLink. The project folder is ready for the Project complete step (eDocs)." |

    To = **To**, Cc = **Cc** on every email. The default case does nothing.
11. **Save.** Flow checker clean, then Part C.

## Part C — proving it (test mode, nothing real is sent)

**13 Oct: built by Dan as `Plan Notifications` and proven on the plan sample: Office email, the WVE-BOP1-20261005 chat, the receipt; on the progress sample: a line in the same chat, no email; and on a frozen v2 of the plan sample: the SCOPE FROZEN email and chat line. Snag on the frozen email: a wrong token in the Cc box (the chat id); Cc must be `outputs('Cc')`.** The three snags on the way are folded into Part B above (Parse JSON content token, duplicate chat members, the chat title).

1. Drop one of Lee's samples from `tools/received/dl1/sample-files/` (they carry `meta.sample: true`, so the Guard holds
   and the Office gets it with `[TEST MODE]`) into PostedReports: the `plan` sample first.
2. Expect within a minute: an email to the Office with `[TEST MODE] WVE-BOP1-20261005 - PLAN CREATED - West Vela BOP1 -
   for review`, a Teams group chat named `WVE-BOP1-20261005` with the Office as members and the first line posted, and
   `plan-receipt_WVE-BOP1-20261005.json` in Digests/help-receipts.
3. Drop the `plan-progress` sample: no email, one line in the same chat.
4. Drop the `plan` sample again with `status` edited to `frozen` and `scopeVersion` 2: the frozen email and the chat line.
5. Delete the three test files from PostedReports and the receipt from help-receipts when done (the scanner ignores
   sample posts anyway; the receipt must go so the real plan creates its own chat).

## Part D — what the dashboard does with it

Nothing new for the flow. The scanner already files the plan, progress and close-out posts (v2.88) and the BOP panel
shows them. The receipt file is for the flow; the scanner leaves `plan-receipt_*` alone. When the Plan Review tab is
built (item 53, pinned) a `plan-review` kind joins the Switch as case **reviewed** (chat line per review, and the
"VERIFIED BY TSC - freeze the scope" email when the scanner's count reaches all). When the scanner writes the
testing-90% notice (matrix H-07) it lands as a small `plan-notice` file; case **testing90** posts the agreed text to the
chat.

## Part E — later

- Daily progress digest email to the Planning table (one scheduled flow reading `plans-open.json` and the day's
  progress posts).
- Reviewer-void handling on **updated**: today everyone on the audience is told; once reviews exist the email names
  the reviewers whose review is void.
