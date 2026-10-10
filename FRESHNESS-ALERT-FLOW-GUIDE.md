# Scanner freshness alert: the flow, click by click (plan item 33, promised to IT, due 9 October 2026)

**What it does:** every hour, looks at when the scanner last finished a complete run, and emails Dan and Lee if that was more
than two hours ago. Nothing is sent while the scanner is healthy.

**What it watches (changed from the plan's first sketch, 6 Oct):** not the newest digest. Digests are only rewritten when a
report changes, so a quiet night with no posts would look like a stopped scanner. It watches
`Digests / DatabaseExport / export_manifest.json`, which the scanner rewrites with the database export, quiet or not.
**Since v2.80 that is once an hour** (the first complete scan an hour or more after the last export), so a healthy manifest is
at most about 70 minutes old. Two hours or more means at least an hour of scans did not finish.

**Where:** Power Automate, environment **SEADRILL-WC-DEV**, same as the other flows. Lee as co-owner afterwards.

## Build (about ten minutes)

1. **+ Create**, **Scheduled cloud flow**. Name `SACRED scanner freshness`. Repeat every **1 Hour**. **Create**.
2. **+ New step**, search `Get file metadata using path` (SharePoint), **not** Get file properties (that one wants the
   file's ID number). Site Address: the WellControl site. File Path: the folder icon, then `Digests` > `DatabaseExport` >
   `export_manifest.json`. Rename the card **Manifest**.
3. **+ New step**, **Compose**, rename **AgeHours**. Expression (fx):

```
div(sub(ticks(utcNow()), ticks(body('Manifest')?['LastModified'])), 36000000000)
```

4. **+ New step**, **Condition**. Left: fx

```
or(equals(int(outputs('AgeHours')), 2), and(greater(int(outputs('AgeHours')), 2), equals(mod(sub(int(outputs('AgeHours')), 2), 8), 0)))
```

   **is equal to** fx `true`. One email at two hours stale, then one every eight hours (10, 18, 26...) while it stays
   stale. (The first build emailed every hour: Dan's laptop off overnight on 10 Oct gave sixteen emails. Change the
   `8` to `24` for one a day after the first.)
5. In **If yes**: **Send an email (V2)** (Office 365 Outlook).
   - To: Dan's and Lee's addresses.
   - Subject, fx:

```
concat('SACRED scanner has stopped: no complete scan for ', string(outputs('AgeHours')), ' hours')
```

   - Body (type it, with the dynamic content where shown):
     `The last complete scan finished at ` + LastModified (from Manifest) + ` UTC. The dashboard, the digests and the database stop updating until it runs. Check the scheduled task on the scanner machine (Dan's PC; the server from the transfer week): run C:\TSC-Dashboard\scripts\Update-Dashboard.ps1 -Force and read its last lines. Dashboard: http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html`
   - Importance: High.
6. **If no**: leave empty.
7. **Save**. Then **Test**, **Manually**, **Run flow**: it should finish green with the Condition going to **If no**.

## Prove it (the "done when")

1. Disable the scheduled task on the scanner machine (Task Scheduler, the TSC Dashboard task, **Disable**).
2. Wait a little over two hours. The email arrives at the next hourly check.
3. **Enable** the task again and let one scan finish. The next hourly check sends nothing.
4. Tell the dashboard session; plan item 33 closes and the ORR monitoring row (13) moves to met for this part.

## Afterwards

- Add Lee as co-owner (Share, Lee Arnold, Owner), like the other flows.
- At handover the flow moves to the service account with the others (plan item 40): one Change connection on the SharePoint
  card and one on the Outlook card.
- After the server transfer nothing changes: the server writes the same manifest to the same library.
