# AAB loop — installing the dashboard side (click by click)

**For:** Dan · **Date:** 24 September 2026 · **Plan:** `AAB-LOOP-PLAN.md` §6 step 2, done this
side; step 3 (the flow) is `AAB-NOTIFICATIONS-FLOW-GUIDE.md`.
**What this installs:** scanner v2.65 (reads AAB posts and acknowledgements, writes
`aab-data.js` and the overdue chase file), one **Seadrill Bulletin Board** on the share at
`sacred\aab\` (Dan, 24 Sep: one board, not three views): the open rig page (`index.html`:
choose your rig, see what applies, acknowledge, close with evidence), the Technical Services
fleet compliance page (`register.html`, password) with the **Create or revise an AAB** button
into Eric's gated Rev 8 create page, and his set-password page. The main dashboard carries
no AAB tab, only a line on the Compliance tab with the overdue count and the links.

Nothing here posts anything. The first real post is yours, in test mode, in Part D.

## Part A — save the files (5 minutes)

Four files go over the old ones, as always:

1. `Update-Dashboard.ps1` into `C:\TSC-Dashboard\scripts\`
2. `Deploy-Dashboard.ps1` into `C:\TSC-Dashboard\scripts\`
3. `Archive-ProblemFiles.ps1` into `C:\TSC-Dashboard\scripts\`
4. `dashboard.html` into `C:\TSC-Dashboard\dashboard\`

Then a new folder:

5. Open File Explorer. Go to `C:\TSC-Dashboard`.
6. Right-click an empty space, **New**, **Folder**. Name it `aab`. Press Enter.
7. Save these seven files into `C:\TSC-Dashboard\aab\`:
   - `index.html` (the open rig page)
   - `register.html` (fleet compliance, password)
   - `aab-register.js` (the register the fleet page draws; Eric embeds it in Rev 9)
   - `seadrill-bulletin-board.html` (Eric's gated build, Rev 8: the create page)
   - `acknowledge.html` (a redirect to index.html, for older links)
   - `set-password.html` (Eric's)
   - `aab-logo-600.jpg`

## Part B — the password and the endpoint (5 minutes)

The create page and the fleet compliance page share one password and one small file,
`gate-config.js`, that never leaves your PC and the share. The rig page reads the same file
for the endpoint only and shows no password box.

1. In File Explorer, open `C:\TSC-Dashboard\aab`.
2. Double-click `set-password.html`. It opens in the browser.
3. Type the password for the board in the password box. Type a hint if you want one.
4. Click **Generate gate-config.js**.
5. Click **Download gate-config.js**.
6. In the download bar, click **Save as** (or open your Downloads folder afterwards) and
   save the file into `C:\TSC-Dashboard\aab\`. The name must be exactly `gate-config.js`.
7. Right-click `gate-config.js` in `C:\TSC-Dashboard\aab`, **Open with**, **Notepad**.
8. Find the line that starts with `hint:`. Click at the very end of that line. Press Enter.
9. On the new line paste this, then replace the words in capitals with the intake URL:

```
  postUrl: "PASTE THE INTAKE URL HERE",
```

   The intake URL is the one the SSCE requests page and the precharge calculator already
   post to (the HTTP trigger that files a post into PostedReports). It is in
   `C:\TSC-Dashboard\requests-dashboard\requests-dashboard.html` on the line that starts
   `var SSCE_POST_URL =`, between the quote marks. Copy it from there.
10. **File**, **Save**. Close Notepad.

The finished file looks like this (your values differ):

```
window.PCGATE = {
  hash: "…",
  hint: "…",
  postUrl: "https://….powerplatform.com/…",
};
```

## Part C — scan and deploy (5 minutes)

1. Open PowerShell. Run the scan:

```
C:\TSC-Dashboard\scripts\Update-Dashboard.ps1
```

   Look for `TSC Dashboard scanner v2.65` at the top and, near the end,
   `Wrote 0 AAB record(s), 0 acknowledgement(s), 0 rig state(s) to C:\TSC-Dashboard\aab\aab-data.js`
   and `Deployed aab-data.js to \\sdrlazneuiis01d.corp.local\sacred\aab`. Zero is right:
   nothing has been posted yet.

2. Run the deploy:

```
C:\TSC-Dashboard\scripts\Deploy-Dashboard.ps1
```

   Look for nine lines starting `Published aab\`.

3. In the browser open `http://sdrlazneuiis01d.corp.local:8080/sacred/aab/` (or
   `…/sacred/aab/index.html`). No password box. It says "Choose your rig" and, at the top
   right of the grey bar, **Posting: configured**. Choose a rig: "No advisory applies" until
   the first post. At the top right of the blue header is the link **Technical Services:
   fleet compliance and create AAB**.
4. Click that link. The password box appears. Type the password. The fleet compliance page
   opens (empty until the first post) with **Create or revise an AAB** at the top right.
5. Click **Create or revise an AAB**. Eric's create page opens with no second password box
   (one unlock covers both for twelve hours) and says **Endpoint: configured (gate-config.js)**.
6. Open the dashboard, **Compliance** tab. Once an AAB exists, a line at the top gives the
   counts and the two links; until then nothing shows.

## Part D — the first post, in test mode (after the flow in `AAB-NOTIFICATIONS-FLOW-GUIDE.md` is built)

1. Settings sheet, B2 `Yes` (in the browser, then wait for Saved).
2. On the Bulletin Board, create a TEST advisory: title starting `TEST`, one rig only
   (a rig where your own address is on the Rigs sheet is best), a one-page PDF attached,
   Action requested ticked, due date a few days out. Click **Post to Dashboard**. The board
   says `Posted — seadrill-aab_… sent to the intake endpoint (HTTP 200)`.
3. The AAB Notifications flow fires: the office gets `[TEST MODE] [AAB C…]` with the red
   line naming the rig addresses. Nothing reaches the rig.
4. Within ten minutes the fleet compliance page shows the advisory with the rig chip
   **outstanding**, and the dashboard's Compliance tab shows the line.
5. Open `…/sacred/aab/index.html?rig=<the rig's key>` (keys: `nov`, `auriga`, `saturn`,
   `jupiter`, `tellus`, `carina`, `polaris`, `vela`, `gemini`, `capella`, `libongos`,
   `quenguela`, `cam`). Acknowledge as crew A. Then as crew B. Then close the action with a
   comment and a photograph.
6. Each post lands in PostedReports as `seadrill-aab-ack_…json` and the flow mails the
   gatekeeper and the office (test mode: office only). The next scan moves the rig chip
   through **partly acknowledged**, **action open**, **closed**.
7. To see the chase: post one more TEST advisory with the due date set to yesterday. The
   next scan prints `AAB overdue chase: 1 new row(s)` and the chase flow (Part D of the
   flow guide) mails once a day until the rig closes it.
8. Settings B2 `No`.

The TEST records stay on the dashboard as history. When you want them gone, tell me and
they come out of PostedReports by hand, the way the OEM test copies did. The archive
script never moves an AAB file.

## What the scan prints from now on

- `AABs: N advisory(ies) in M revision(s), K acknowledgement(s); rig states: …` when any exist.
- `Wrote … to C:\TSC-Dashboard\aab\aab-data.js` and `Deployed aab-data.js to …\sacred\aab` every scan.
- `AAB overdue chase: N new row(s)` on the first scan of a day that finds an open row past due.

## If it misfires

- **The board says "No intake endpoint configured yet":** `gate-config.js` has no `postUrl`
  line, or the file is not beside the board on the share. Part B, then Deploy again.
- **The password box refuses the password:** the hash in `gate-config.js` is not the one
  set-password.html generated (a stale download). Generate and download again, keep the
  `postUrl` line, Deploy.
- **The rig page says "aab-data.js is not beside this page":** the scan has not
  run since Part A, or the deploy folder for AAB is not `sacred\aab`. Run the scan; the
  scan output says where it deployed the file.
- **A post from the board says HTTP 4xx/5xx:** the intake URL is wrong or expired. The board
  downloads the record instead; nothing is lost. Compare the URL with the SSCE page's.
- **An AAB shows on the Errors button as "aab-invalid":** the post has no AAB number. The
  file is left where it is (never archived); open it and tell Eric.
