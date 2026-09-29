# TSC Help Centre — installing the dashboard side (click by click)

**For:** Dan · **Date:** 29 September 2026 · **Answers:** `DASHBOARD-TSC-HELP-CENTRE-HANDOFF.md`
(the tools session, 29 Sep): the Help Centre gates their stages 2 and 3, so it goes up now.
**What this installs:** scanner v2.71 (reads the rigs' assistance requests and the Help Centre's
own records, reads the flow's delivery receipts, writes `help-data.js`, lists a request without a
receipt on the Errors button) and one passworded page, the **TSC Help Centre**, on the share at
`sacred\help\`. The main dashboard's AABs tab gets a one-line count with the link.

Nothing here emails anyone. The flow is `TSC-HELP-NOTIFICATIONS-FLOW-GUIDE.md`, built after this.

## Part A — save the files (5 minutes)

Two files over the old ones, as always:

1. `Update-Dashboard.ps1` into `C:\TSC-Dashboard\scripts\`
2. `Deploy-Dashboard.ps1` into `C:\TSC-Dashboard\scripts\`
3. `dashboard.html` into `C:\TSC-Dashboard\dashboard\`

Then a new folder:

4. File Explorer, `C:\TSC-Dashboard`, right-click, **New**, **Folder**, name it `help`.
5. Save these three into `C:\TSC-Dashboard\help\`: `help-centre.html`, `help-centre.js`,
   `set-password.html`.

## Part B — the password and the endpoint (5 minutes)

Its own password, its own `gate-config.js` (the AAB one is a different salt and stays as it is).

1. `C:\TSC-Dashboard\help`, double-click `set-password.html`. Type the Help Centre password and a
   hint, **Generate**, **Download**.
2. Move the downloaded `gate-config.js` from Downloads into `C:\TSC-Dashboard\help\`.
3. PowerShell, the same four lines as for the AAB but on the help folder, which copy the intake
   URL out of the SSCE requests page:

```
$u = (Select-String -Path 'C:\TSC-Dashboard\requests-dashboard\requests-dashboard.html' -Pattern "SSCE_POST_URL\s*=\s*'([^']+)'").Matches[0].Groups[1].Value
$f = 'C:\TSC-Dashboard\help\gate-config.js'
(Get-Content $f -Raw) -replace 'postUrl:\s*"[^"]*"', ('postUrl: "' + $u.Replace('$','$$') + '"') | Set-Content $f -Encoding UTF8
Get-Content $f
```

   It prints the file: a `hash:` line and a filled `postUrl:` line.

## Part C — the receipts folder (2 minutes)

The flow writes its delivery receipts into the **Digests** library, in a folder the scanner reads.

1. In the browser, WellControl site, **Digests** library, **+ New**, **Folder**, name `help-receipts`.
2. It syncs to `C:\Users\danplant\Seadrill\WellControl - Digests\help-receipts` by itself. Nothing
   to add to `config.json`: the scanner finds it beside the AAB chase file. (If you ever move it, add
   `"helpReceiptPath": "C:\\...\\help-receipts"` to `config.json`.)

## Part D — scan and deploy (5 minutes)

1. PowerShell:

```
C:\TSC-Dashboard\scripts\Update-Dashboard.ps1 -Force
```

   Look for `scanner v2.71` and, near the end, `Wrote 0 assistance request(s), 0 Help Centre
   record(s) to C:\TSC-Dashboard\help\help-data.js` and `Deployed help-data.js to
   \\sdrlazneuiis01d.corp.local\sacred\help`. Zero is right.

2. Deploy:

```
C:\TSC-Dashboard\scripts\Deploy-Dashboard.ps1
```

   Look for five lines starting `Published help\`.

3. Browser: `http://sdrlazneuiis01d.corp.local:8080/sacred/help/help-centre.html`. Password box;
   type the Help Centre password. The page says "No assistance request has been posted yet".

## Part E — the first request, in test mode (after the flow is built)

1. Settings B2 `Yes`.
2. Drop the synthetic request file (sent with this guide, `seadrill-help_SSCE-Equipment_….json`)
   into PostedReports in the browser, or post one from SSORT stage 2 against SSCE Equipment.
3. The office gets `[TEST MODE] RIG DOWN - SSCE Equipment - …`; a `[TEST]` Teams chat appears.
4. Within ten minutes the Help Centre shows the card with **Sent to N at hh:mm**, and the dashboard's
   AABs tab line says `TSC Help Centre: 1 open request(s), 1 with the rig down`.
5. On the card: **Acknowledge**, your name, a note, **Post**. After the next scan the state is
   **acknowledged**. Then **Close the request** with a closing note. After the next scan, **closed**.
6. Settings B2 `No`. Delete the test files from PostedReports and the test receipt from
   `Digests/help-receipts` when you want them gone.

## What the scan prints from now on

- `TSC Help Centre: N request(s): a open, b acknowledged, c closed; k record(s) from the page; r receipt(s) read`
- `Wrote … to C:\TSC-Dashboard\help\help-data.js` and `Deployed help-data.js to …\sacred\help` every scan.
- On the Errors button: **Assistance requests without a delivery receipt** when a request has had no
  receipt for an hour or the flow reported NOT SENT.

## If it misfires

- **Password refused:** Caps Lock, or the `gate-config.js` in `help\` is the AAB one (different
  salt). Generate it with `help\set-password.html`, not the AAB page.
- **"help-data.js is not beside this page yet":** the scan has not run since Part A, or
  `helpDeployPath` points elsewhere; the scan output says where it deployed.
- **A card says "No delivery receipt yet" for a real request:** the flow did not run or did not write
  the receipt; open the flow's run history. The email may still have gone: check the office inbox.
- **A post from the page downloaded a file instead:** the intake URL in `help\gate-config.js` is
  wrong; compare with the SSCE page's. Send the downloaded file to Dan and it is filed by hand.
