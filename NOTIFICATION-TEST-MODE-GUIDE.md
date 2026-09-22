# Test mode for the notification flows — one cell, no address ever touched

**For:** Dan · **Date:** 16 September 2026, rewritten 22 September as built · **Week plan item 15**
**Problem:** testing a flow used to mean putting your own address into the Rigs or NOV
sheet and remembering to put the real one back. The Rigs sheet is shared by the live
precharge loop, so a forgotten swap sends a real precharge to nobody, and a forgotten
test sends test mail to a rig or to NOV.

**Answer:** a `Settings` table in the notification workbook with one switch. When
`TestMode` is `Yes`, the flow sends the email to the **Office** list only, puts
`[TEST MODE]` in front of the subject, and writes a red line at the top of the body
saying who the real run would have gone To and CC. Flip it to `No` and the same flow
goes live with the real sheets. No address is edited, ever, and one glance at one cell
says whether the estate is in test.

**State, 22 Sep 2026:** built into **CBM to OEM** and proven (a West Vela test post in
test mode mailed the office only, with the red line listing NOV, office, superintendents
and the five West Vela addresses). **Precharge Notifications** and **Rig Visit
Notifications** still need Part B applied.

## Part A — the Settings sheet (done 22 Sep)

Open `PostedReports/Notifications/WCE_Precharge_Notification.xlsx` in the browser.

1. Add a sheet, rename it `Settings`.
2. **A1** `Key`, **B1** `Value`, **A2** `TestMode`, **B2** `Yes`.
3. Select A1:B2, **Insert**, **Table**, *My table has headers*, OK. **Table Design**,
   Table Name: `Settings`.
4. Close the workbook.

`Yes` in any case is test mode (`yes`, `YES`). Anything else, a blank, or a missing
sheet is live, so a broken Settings sheet can never put a flow into test by accident.
There is no TestEmail cell: test mail goes to the Office table, which is the four people
who should see it anyway.

## Part B — two cards and three edits per flow (5 minutes per flow)

Cards go right after **Parse JSON**, so every later card can read them.

1. **SettingsRow**: `List rows present in a table`, same workbook, Table **Settings**,
   Advanced parameters: **Filter Query** fx `concat('Key eq ''TestMode''')`, **Top
   Count** `1`.
2. **TestMode** (Compose):

```
equals(toLower(trim(coalesce(first(body('SettingsRow')?['value'])?['Value'],'no'))),'yes')
```

Then in **every Send an email card** of that flow (the existing To and CC expressions
should already be in a Compose each; if not, make one first, as CBM to OEM has
`CcList`):

- **To**: `if(equals(outputs('TestMode'), true), outputs('OfficeList'), <the To compose>)`
- **CC**: `if(equals(outputs('TestMode'), true), outputs('OfficeList'), <the CC compose>)`
- **Subject**: at the very front, fx `if(equals(outputs('TestMode'), true), '[TEST MODE] ', '')`
- **Body**, code view, before the first `<p`:

```
@{if(equals(outputs('TestMode'), true), concat('<p style="color:#b00"><b>TEST MODE. Real run would go To: ', <the To compose>, '<br>CC: ', <the CC compose>, '</b></p>'), '')}
```

So the precharge REQUEST, ISSUED and NO RIG CONTACT emails, the rig visit email and its
NO RIG CONTACT, and the OEM email and its NO OEM RECIPIENTS all obey the one switch once
Part B is on all three.

## Part C — how testing goes from now on

1. `TestMode` = `Yes`, close the workbook. Post whatever you like, from any tool, for any
   rig. Every mail lands with the office only, `[TEST MODE]` in the subject and the red
   line naming the real recipients; the rig, the superintendents and NOV get nothing.
   The dashboard, the inbox index and the Sent-to-NOV chip behave exactly as live.
2. Happy: `TestMode` = `No`, close the workbook. The next post is live.
3. Any time you want to test again, one cell.

## Why not a test rig row or a swapped address

- A swapped address in the Rigs sheet changes the **live** precharge loop while you
  test the rig visit loop; one switch cannot leak into the other.
- A "Test Rig" row only works if the tools let you post under a made-up rig name, and
  it does nothing for NOV, whose recipients are keyed on the tool's `oem` value.
- The switch is visible. A swapped address is a thing you have to remember.

## One honest limit

The switch lives in the workbook the flows read, so it needs the workbook closed like
every other change there. And a flow that has not had Part B applied does not know
about the switch: apply it to all three, and to any future loop as part of its bring-up
checklist (`NOTIFICATION-LOOP-PATTERN.md` §6).
