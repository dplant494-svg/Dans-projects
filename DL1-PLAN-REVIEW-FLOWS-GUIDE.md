# Plan review: the two small flows, click by click (plan item 53)

**For Dan. Written 13 October 2026 with scanner v2.90 and the Help Centre's Plans tab.** The tab itself needs no flow:
the scanner writes its data and the page posts reviews through the intake. The two flows here carry the roster in and
the notices out. Both are short; the cards are the ones you have built before.

What the pieces do:

| Piece | Does | Where |
|---|---|---|
| **Reviewers** table in the workbook | who must verify a plan, by region (Ronnie for GOM, Angola, Namibia, Malaysia; Joao for Brazil; BOP Controls and Brent for all) | `WCE_Precharge_Notification.xlsx`, sheet Reviewers (copied in from `Reviewers-sheet-FINAL-2026-10-13.xlsx`) |
| Flow **Plan Reviewers** (hourly) | exports that table to Digests as `plan-reviewers.json` | this guide, Part A |
| Scanner v2.90 | reads the roster, the plan posts and the reviews; computes "n of m verified" per plan; writes `help\plan-review-data.js` for the tab and `plan-notices.json` to Digests when a plan is verified by all or its testing reaches 90 % | installed with the scanner |
| Help Centre, **Plans** tab | lists every plan with its scope by section; a reviewer presses Verified or Changes needed; that posts a `seadrill-planreview_*` record through the intake | deployed with the Help Centre |
| Flow **Plan Notices** (every 15 minutes) | reads `plan-notices.json`, posts each new notice to the plan's Teams chat (and the verified-by-all email to the planner side), writes a receipt so it never repeats | this guide, Part B |

## Part A — flow `Plan Reviewers` (hourly export, 6 cards, 15 minutes)

1. Power Automate, **+ Create**, **Scheduled cloud flow**, name `Plan Reviewers`, repeat every **1 Hour**. Create.
2. **List rows present in a table**, rename **ReviewerRows**: the workbook (Location, Document Library, File as on every
   flow), Table **Reviewers**. No filter.
3. **Compose**, rename **RosterJson**. Inputs fx:
```
concat('{"generatedAt":"', utcNow(), '","reviewers":', string(body('ReviewerRows')?['value']), '}')
```
4. **Create file** (SharePoint): Site **WellControl**, Folder Path: pick **Digests**, then **help-receipts**. File Name
   `plan-reviewers.json`. File Content fx `outputs('RosterJson')`. The SharePoint Create file card overwrites a file of
   the same name, so the roster is simply replaced every hour.
5. **Save**, then **Test**, **Manually**, **Run flow**. Open Digests, help-receipts: `plan-reviewers.json` is there and
   opens as JSON with your four rows.
6. The scanner picks it up on its next run and the Plans tab shows "Reviewers by region: Ronnie Peeples (GOM, Angola,
   Namibia, Malaysia); BOP Controls (All); Brent Sherman (All); Joao Fabio Gomes de Almeida (Brazil)".

A change to the table (a new reviewer, a region moved) reaches the tab within an hour and ten minutes with no other
step.

## Part B — flow `Plan Notices` (every 15 minutes, about 25 cards, 45 minutes)

The scanner writes `plan-notices.json` beside the receipts: `{ generatedAt, count, notices:[ { id, kind, planid, rig,
rigkey, bop, scopeversion, text } ] }`. `kind` is `verified` (every required reviewer verified this scope version) or
`testing90` (the Testing section reached 90 %). The `id` is stable (`WVE-BOP1-20261005|v2|verified`), so a receipt per
id makes each notice fire once.

1. **+ Create**, **Scheduled cloud flow**, name `Plan Notices`, repeat every **15 Minute**. Create.
2. **Get file content using path** (SharePoint): Site WellControl, File Path `/Digests/help-receipts/plan-notices.json`.
   Click the three dots, **Settings**, and set **Configure run after** on the next card to continue on failure so an
   empty folder (no file yet) ends the run quietly: simpler, add a **Condition** after it named **HasFile** with fx
   `empty(body('Get_file_content_using_path'))` is equal to `false`, and put everything below in **True**.
3. **Parse JSON**, rename **Notices**: Content fx `body('Get_file_content_using_path')`. Schema:
```
{"type":"object","properties":{"notices":{"type":"array","items":{"type":"object","properties":{"id":{"type":"string"},"kind":{"type":"string"},"planid":{"type":"string"},"rig":{"type":"string"},"rigkey":{"type":"string"},"bop":{"type":"string"},"scopeversion":{},"text":{"type":"string"}}}}}}
```
4. The lists you need once per run (same cards as `DL1-PLAN-NOTIFICATIONS-FLOW-GUIDE.md` Part B step 8): **OfficeRows /
   OfficeEmails / OfficeList** and **PlanToRows / PlanToEmails / PlanToList** (Planning table, `Send eq 'To'`).
5. **Apply to each**, rename **EachNotice**: Select an output fx `body('Notices')?['notices']`. Inside it:
   1. Compose **NoticeId** fx `replace(replace(items('EachNotice')?['id'], '|', '_'), ':', '-')`.
   2. **Get files (properties only)**, rename **NoticeReceipt**: Site WellControl, Library **Digests**, Limit Entries to
      Folder `help-receipts`, Filter Query fx `concat('FileLeafRef eq ''plan-notice-receipt_', outputs('NoticeId'), '.json''')`,
      Top Count 1.
   3. **Condition**, rename **IsNew**: fx `length(body('NoticeReceipt')?['value'])` is equal to `0`. Everything below in
      **True**; False stays empty.
   4. **Get files (properties only)**, rename **PlanReceipt**: Digests, `help-receipts`, Filter Query fx
      `concat('FileLeafRef eq ''plan-receipt_', items('EachNotice')?['planid'], '.json''')`, Top Count 1.
   5. **Condition HasChat**: fx `length(body('PlanReceipt')?['value'])` is greater than `0`.
      - **True:** **Get file content using path**, rename **PlanReceiptFile**, path fx
        `concat('/Digests/help-receipts/plan-receipt_', items('EachNotice')?['planid'], '.json')`; Compose **ChatId** fx
        `json(string(body('PlanReceiptFile')))?['chatid']`; Teams **Post message in a chat or channel**: Flow bot, Group
        chat, Group chat fx `outputs('ChatId')`, Message fx `items('EachNotice')?['text']`.
      - **False:** nothing (the plan chat does not exist yet; the notice waits for the next run, no receipt is written
        because step 7 is in the True branch of HasChat). Put step 6 and 7 inside **HasChat = True** after the post.
   6. The email, only for `verified`: **Condition IsVerified**: fx `items('EachNotice')?['kind']` is equal to `verified`.
      True: **RigRow** (table Rigs, Filter Query fx `concat('RigKey eq ''', items('EachNotice')?['rigkey'], '''')`, Top
      Count 1), Compose **Planner** fx
```
join(union(split(replace(concat(coalesce(first(body('RigRow')?['value'])?['TslEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['SubseaSupervisorEmail'],''), ';', coalesce(first(body('RigRow')?['value'])?['OIMEmail'],''), ';', outputs('PlanToList')), ';;', ';'), ';'), json('[]')), ';')
```
      then **Send an email (V2)**: To fx `outputs('Planner')`, Subject fx
      `concat(items('EachNotice')?['planid'], ' - VERIFIED BY ALL - freeze the scope - ', items('EachNotice')?['rig'], ' ', items('EachNotice')?['bop'])`,
      Body fx `concat(items('EachNotice')?['text'], '<br><br>Open Argo Navis, press Freeze scope; the frozen post is the ready-for-execution notice.')`.
   7. **Create file**: Digests, Folder `/Digests/help-receipts`, File Name fx
      `concat('plan-notice-receipt_', outputs('NoticeId'), '.json')`, File Content fx
      `concat('{"id":"', items('EachNotice')?['id'], '","at":"', utcNow(), '"}')`.
6. **Save.** Flow checker clean.

**Proving it (test mode).** Test plans never produce a notice (the scanner skips them), so the proof uses the scanner's
own output: ask this session for a one-off `plan-notices.json` with a sample notice whose planid matches a plan chat
that exists (the `WVE-BOP1-20261005` test chat from 13 Oct will do if its receipt is restored), drop it into
help-receipts, run the flow by hand: a line in the chat, the email to the planner side, and
`plan-notice-receipt_WVE-BOP1-20261005_v2_verified.json` written. Run it again: nothing repeats. Delete the sample
notices file and the receipt afterwards.

## What happens on a real plan, end to end

1. The rig presses Post for review in Argo Navis. `Plan Notifications` emails the audience and opens the plan chat.
2. The scanner lists the plan on the Plans tab with its three required reviewers for the region.
3. Each reviewer opens the Help Centre, Plans, finds the plan, reads their section, presses **Verified** (or **Changes
   needed** with a comment). The BOP page shows "2 of 3 verified".
4. When the third verifies, the scanner writes the notice; within 15 minutes `Plan Notices` posts "VERIFIED BY ALL,
   freeze the scope" to the chat and emails the planner side.
5. The planner presses Freeze scope in Argo Navis; `Plan Notifications` sends SCOPE FROZEN; execution starts.
6. A Changes needed sends the plan back; the planner posts the next scope version; the reviews start again on it.
7. When the Testing section reaches 90 %, the scanner writes the testing notice and the chat gets the pre-deployment
   call line.
