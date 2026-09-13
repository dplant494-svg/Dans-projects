# Ask Copilot about the reports — setup guide

**For:** Dan · **Date:** 13 September 2026 · **Needs:** scanner v2.43, Copilot Studio (you have it)

## Why this is built the way it is

On 13 September an agent pointed straight at the PostedReports library found the
notification workbook and nothing else. Copilot's SharePoint index reads Office, HTML
and text files and ignores the raw `.json` posts. So the scanner now writes one
readable HTML **digest** per report into a separate library, and the agent reads
those. The dashboard stays static and gets one button. Nothing changes in how
reports are posted or scanned.

The digests must live in their **own** library, not in PostedReports, for two
reasons: the Precharge Notifications flow triggers on every file created in
PostedReports and would email a digest whose name contains `precharge`, and the
scanner must never read its own output as a report.

---

## Part A — one new SharePoint library, synced to your PC (5 minutes)

1. Open the **WellControl** SharePoint site in your browser.
2. Click the gear (top right) → **Site contents** → **+ New** → **Document library**.
3. Name: `Digests`. Description: `Searchable text copies of posted WCE reports, written by the dashboard scanner for Copilot. Do not edit.` Click **Create**.
4. Open the new library and click **Sync** in its toolbar. Accept the OneDrive prompt.
5. In File Explorer, confirm a folder now exists at
   `C:\Users\danplant\Seadrill\WellControl - Digests`.

## Part B — three lines in config.json (2 minutes)

1. Open `C:\TSC-Dashboard\config.json` in Notepad.
2. After the `"prechargeDeployPath": ...` line, add these three lines (keep the
   commas as shown, the last existing line before the closing `}` must have a comma
   after it too):

```
  "digestPath": "C:\\Users\\danplant\\Seadrill\\WellControl - Digests",
  "dashboardUrl": "http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html",
  "copilotUrl": "",
```

3. Save. `copilotUrl` stays empty until Part D gives you the link.

## Part C — install v2.43 and run it (5 minutes)

1. Save `Update-Dashboard.ps1` (v2.43) over `C:\TSC-Dashboard\scripts\Update-Dashboard.ps1`.
2. Save `dashboard.html` over `C:\TSC-Dashboard\dashboard\dashboard.html`.
3. In PowerShell:

```
Unblock-File C:\TSC-Dashboard\scripts\*.ps1
C:\TSC-Dashboard\scripts\Update-Dashboard.ps1
```

4. Look for the line `Digests for Copilot: N new/updated, N total`. N should be
   roughly the number of reports on the dashboard.
5. In File Explorer, the `WellControl - Digests` folder fills with `.html` files.
   Wait for the sync icons to turn to green ticks. Open one in a browser to see what
   Copilot will read.

## Part D — point the agent at the digests (5 minutes)

1. Go to `https://copilotstudio.microsoft.com`, open **Agents**, open **WCE Reports
   Assistant**.
2. **Knowledge** tab. On the PostedReports source, click the **…** and **Delete**.
3. **+ Add knowledge** → **SharePoint** → paste the URL of the new library, which is
   the WellControl site address followed by `/Digests`. **Add**. Wait for **Ready**.
4. Still on Knowledge, find the setting **Allow the AI to use its own general
   knowledge** (or **Web search**) and turn it **off**. This stops it quoting news
   sites about the rigs.
5. **Overview** tab, **Instructions**. Replace with:

```
You answer questions about Seadrill Well Control Engineering reports using only the report digests in your knowledge. Each digest is one report and states the rig, report type, date and source file at the top. Always name the rig, the date and the source file your answer came from, and include the dashboard link from the digest when there is one. Quote pressures, dates, grades and serial numbers exactly as written. If the digests do not contain the answer, say so. Never use outside knowledge about the rigs.
```

6. **Save**. Test in the pane with:
   - `What was the most recent report from West Vela and what did it say?`
   - `List the actions raised on West Capella in September with their deadlines.`
   - `What precharge was issued for West Vela on 11 September and what was the verdict?`
7. When the answers cite digests, click **Publish** (top right), then **Channels**
   → **Microsoft Teams** or the **Demo website**, and copy the agent's link.

## Part E — the button on the dashboard (2 minutes)

1. Paste the link into `config.json` as the value of `"copilotUrl"`. Save.
2. Run the scan once, then:

```
C:\TSC-Dashboard\scripts\Deploy-Dashboard.ps1
```

3. Open the dashboard, Ctrl+F5. Under "Data updated" there is now a button, **Ask
   Copilot about these reports**. It opens the agent in a new tab.

## Part F — one line in the precharge flow, belt and braces (2 minutes)

The digests are in their own library, so the flow will not see them. Tighten the
flow anyway, so a future stray file cannot trigger it:

1. Edit **Precharge Notifications**, click the first **Condition** card.
2. Its expression is `contains(toLower(coalesce(triggerOutputs()?['headers']?['x-ms-file-name'],'')),'precharge')`.
   Replace it with:

```
and(contains(toLower(coalesce(triggerOutputs()?['headers']?['x-ms-file-name'],'')),'precharge'), endsWith(toLower(coalesce(triggerOutputs()?['headers']?['x-ms-file-name'],'')),'.json'))
```

3. **Save**.

---

## What happens from now on

Every scan rewrites only the digests whose report changed and removes digests for
reports that are gone, so the library mirrors the dashboard within ten minutes of a
post. Restricted TOPSET files and precharge request payloads are never digested, the
same rule as the report copies on the server. Photos are never in a digest; the
dashboard has them.

**After the server move:** the scanner will write digests from the server, so the
Digests library needs to be one the service account can write to. Add that to the
ISIT list: the three report libraries read-only, plus Digests read/write.

**Who can ask what:** the agent answers with what the signed-in person can open in
SharePoint. Anyone who cannot open the Digests library gets nothing from the agent.
