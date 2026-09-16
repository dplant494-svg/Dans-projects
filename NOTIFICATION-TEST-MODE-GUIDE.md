# Test mode for the notification flows — one cell, no address ever touched

**For:** Dan · **Date:** 16 September 2026 · **Week plan item 15**
**Problem:** testing a flow today means putting your own address into the Rigs or NOV
sheet and remembering to put the real one back. The Rigs sheet is shared by the live
precharge loop, so a forgotten swap sends a real precharge to nobody, and a forgotten
test sends test mail to a rig or to NOV.

**Answer:** a `Settings` table in the notification workbook with one switch. When
`TestMode` is `TRUE`, every flow sends every email to `TestEmail` only, with `[TEST]`
in front of the subject, and nothing else changes. Flip it to `FALSE` and the same
flows go live with the real sheets. No address is edited, ever, and one glance at one
cell says whether the estate is in test.

## Part A — the Settings sheet (3 minutes)

Open `PostedReports/Notifications/WCE_Precharge_Notification.xlsx` in the browser.

1. Add a sheet, rename it `Settings`.
2. A1 `Setting`, B1 `Value`. Then:

| Setting | Value |
|---|---|
| TestMode | TRUE |
| TestEmail | your address (personal or Seadrill; the one you test from) |

3. Select A1:B3, **Insert**, **Table**, *My table has headers*, OK. **Table Design**,
   Table Name: `Settings`.
4. Close the workbook.

Type `TRUE` / `FALSE` as text; the flow compares lower-case text, so `true`, `True`
and `TRUE` all work. Anything else is live.

## Part B — three cards in every flow, once (5 minutes per flow)

Add these to the **Precharge Notifications**, **Rig Visit Notifications** and **CBM to
OEM** flows, right after the Office list is built (before any Send an email card).
Rename each card before the next expression refers to it.

1. **SettingsRows**: `List rows present in a table`, same workbook, Table **Settings**.
2. **TestMode** (Compose):

```
equals(toLower(coalesce(first(filter(body('SettingsRows')?['value'], item()?['Setting'], 'TestMode'))?['Value'], 'false')), 'true')
```

   If your designer does not offer `filter(...)`, use this instead, which reads row 1
   and row 2 by position (TestMode must stay in row 1 and TestEmail in row 2):

```
equals(toLower(coalesce(first(body('SettingsRows')?['value'])?['Value'], 'false')), 'true')
```

3. **TestEmail** (Compose): `coalesce(last(body('SettingsRows')?['value'])?['Email'], last(body('SettingsRows')?['value'])?['Value'], '')`
4. **TestTag** (Compose): `if(outputs('TestMode'), '[TEST] ', '')`

Then in **every Send an email card** of that flow:

- **To**: wrap what is there: `if(outputs('TestMode'), outputs('TestEmail'), <the existing expression>)`
- **CC**: `if(outputs('TestMode'), '', <the existing expression>)`
- **Subject**: put `@{outputs('TestTag')}` at the very front.

So the precharge REQUEST, ISSUED and NO RIG CONTACT emails, the rig visit email and its
NO RIG CONTACT, and the OEM email and its NO OEM RECIPIENTS all obey the one switch.

## Part C — how testing goes from now on

1. `TestMode` = `TRUE`. Post whatever you like, from any tool, for any rig. Every mail
   lands in your inbox with `[TEST]` in the subject; the rig, the office and NOV get
   nothing. The dashboard, the inbox index and the Sent-to-NOV chip behave exactly as
   live, so the whole loop is exercised end to end.
2. Happy: `TestMode` = `FALSE`, close the workbook. The next post is live.
3. Any time you want to test again, one cell.

## Why not a test rig row or a swapped address

- A swapped address in the Rigs sheet changes the **live** precharge loop while you
  test the rig visit loop; one switch cannot leak into the other.
- A "Test Rig" row only works if the tools let you post under a made-up rig name, and
  it does nothing for NOV, whose recipients are keyed on the tool's `oem` value.
- The switch is visible. A swapped address is a thing you have to remember.

## One honest limit

The switch lives in the workbook the flows read, so it needs the workbook closed and
synced like every other change there. And a flow that has not had Part B applied does
not know about the switch: apply it to all three, and to any future loop as part of
its bring-up checklist (`NOTIFICATION-LOOP-PATTERN.md` §6).
