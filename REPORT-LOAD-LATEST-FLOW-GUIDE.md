# Get Latest Report — the flow that hands a posted report back to the tool (loop four)

**For:** Dan · **Date:** 19 September 2026 · **Week plan item 21**
**What it does:** the reporting tool asks "what is the newest posted report for West Capella?"
and this flow reads it from WellControl > PostedReports and sends the JSON straight back. That
is how someone on an iPad picks up a report started on the PC: post on the PC, "Load latest
posted" on the iPad, carry on, post again.
**Pattern:** the mirror of the Post flow. The Post flow is **never touched**; this is a new flow.
**Needs first:** nothing on our side. The tool's button comes from the reporting-tools session
(`REPORT-LOAD-LATEST-TOOL-HANDOFF.md`); the flow can be built and tested today with the test
in Part D, before the button exists.

Time: about 25 minutes.

## Part A — choose a secret (2 minutes)

The Post flow only writes, so its address in the tool gives nothing away. This flow **reads**,
so anyone with the tool file could ask it for any rig's report. A shared secret makes that
harder: the tool sends it, the flow checks it, and anything without it gets a 403 and nothing
else.

1. Open Notepad and type a long random phrase, letters and digits, no spaces, at least 24
   characters. Example shape: `WCEG-2026-h7Qp3vLx9sTb2Nk4Rw`. Make your own; do not use
   that one.
2. Keep Notepad open. You paste it into the flow in Part B step 5 and you give it to the
   reporting-tools session in the handoff. Nowhere else. It is not a password anyone types.

## Part B — the flow (15 minutes)

1. `https://make.powerautomate.com`, left menu **+ Create**, **Instant cloud flow**. Flow
   name: `Get Latest Report`. Under "Choose how to trigger this flow" pick **When an HTTP
   request is received**. **Create**.

2. On the trigger card, **Request Body JSON Schema**, paste this one line:

```
{"type":"object","properties":{"secret":{"type":"string"},"asset":{"type":"string"},"file":{"type":"string"}}}
```

   Then click **Show all** (or the three dots, Settings) on the trigger and make sure
   **Who can trigger the flow** is **Anyone**. Same as the Post flow. The HTTP POST URL
   appears only after the first Save (step 9); come back for it then.

3. **+**, search `Condition`, add it. Rename it **Secret OK**. Left box **fx**:

```
equals(coalesce(triggerBody()?['secret'],''), 'PASTE-YOUR-SECRET-HERE')
```

   Replace `PASTE-YOUR-SECRET-HERE` with the phrase from Part A, keeping the quotes. Middle
   **is equal to**, right box `true`.

4. In the **False** branch: **+**, search `Response` (the one with the purple lightning icon,
   "Response" under Request). **Status Code** `403`. **Body**:

```
{"error":"not authorised"}
```

   Rename it **Refused**.

5. Everything from here goes in the **True** branch. **+**, `Compose`, rename **Prefix**. fx:

```
concat('seadrill-report_', replace(coalesce(triggerBody()?['asset'],''), ' ', '-'), '_')
```

   This turns "West Capella" into `seadrill-report_West-Capella_`, which is how every posted
   filename for that rig starts. An empty rig name gives `seadrill-report__`, which matches
   nothing, which is what we want.

6. **+**, search `Get files (properties only)` (SharePoint). **Site Address** WellControl,
   **Library Name** PostedReports. Click **Show all**: **Order By** = `Modified desc`,
   **Top Count** = `500`. Rename **Recent files**.

7. **+**, search `Filter array`. **From**: fx `body('Recent_files')?['value']`. In the
   condition row click **Edit in advanced mode** and paste:

```
@or(equals(item()?['{FilenameWithExtension}'], coalesce(triggerBody()?['file'],'')), and(startsWith(item()?['{FilenameWithExtension}'], outputs('Prefix')), endsWith(item()?['{FilenameWithExtension}'], '.json'), not(startsWith(item()?['{FilenameWithExtension}'], 'seadrill-oem_'))))
```

   Rename **Matching**. Read it as: the exact file the tool asked for, or else any `.json`
   for that rig that is not an OEM copy. The list is already newest first, so the first
   match is the newest.

8. **+**, `Condition`, rename **Found one**. Left box fx `length(body('Matching'))`, middle
   **is greater than**, right `0`.

   **False** branch: **Response**, Status Code `404`, Body:

```
{"error":"no posted report for this rig"}
```

   Rename **Nothing posted**.

   **True** branch, two cards:

   - **Get file content** (SharePoint). Site WellControl. **File Identifier**: fx
     `first(body('Matching'))?['{Identifier}']`. Rename **Report file**.
   - **Response**. Status Code `200`. Click **Show all**. **Headers**: two rows, key
     `Content-Type` value `application/json`, and key `Access-Control-Allow-Origin` value `*`
     (this is what lets the tool, open in a browser, read the answer). **Body**: fx
     `body('Report_file')`. Rename **Report back**.

9. **Save**. Open the trigger card again and copy the **HTTP POST URL**. That address and the
   secret are the two things the reporting-tools session needs. Send them by the handoff, not
   by chat, and never put either on the dashboard.

## Part C — what "latest" means, so nobody is surprised

The flow returns the newest file **by SharePoint's modified time** whose name starts with
the rig's prefix. That is any report type: daily report, CBM, precharge issued sheet, whatever
was posted last. The tool's receipt (see the handoff) shows the filename and posted time
before anything is loaded, so the person can see "that is the CBM from this morning, not my
daily" and choose the daily from the tool's list instead by passing its exact `file`.

Posted means posted: a report saved locally on the PC but not posted is not on SharePoint and
this flow cannot see it.

## Part D — test it now, without the tool (5 minutes)

In PowerShell on your PC, with the URL and secret pasted in:

```
$u = 'PASTE-THE-HTTP-POST-URL'
$r = Invoke-RestMethod -Method Post -Uri $u -ContentType 'application/json' -Body '{"secret":"PASTE-YOUR-SECRET","asset":"West Capella"}'
$r.meta.asset; $r.meta.reportdate; $r.tiles.Count
```

Expected: `West Capella`, the date of Brad's newest post, and a tile count. Then the two
failure cases:

```
Invoke-RestMethod -Method Post -Uri $u -ContentType 'application/json' -Body '{"secret":"wrong","asset":"West Capella"}'
```

should fail with **403**, and `"asset":"No Such Rig"` should fail with **404**. In the flow's
run history the three runs show as one green and two green-with-a-response (a 403 or 404 is
the flow working, not failing).

## If it misfires

- **Nothing in run history:** the tool or your test is using the Post flow's URL, or the
  trigger's "Who can trigger" is not Anyone.
- **403 on a correct secret:** a space or quote crept into the Condition when pasting. Open
  it and retype the expression.
- **404 for a rig that has posts:** the rig name in the request does not match the filename
  prefix. The prefix replaces spaces with hyphens, so `West Capella` becomes `West-Capella`;
  a rig posted with a different spelling needs that spelling in the request.
- **Run failed at Report file:** the file is over the flow's response limit (very large
  photo-heavy reports). The report is still on the dashboard; the tool shows the error and
  the person can load it from the dashboard copy instead.
- **The tool says it cannot read the answer:** the two headers on the Report back Response
  are missing or mistyped.
