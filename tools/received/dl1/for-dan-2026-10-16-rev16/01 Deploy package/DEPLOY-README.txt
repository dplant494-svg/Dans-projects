Argo Navis deploy package
=========================
Build      : Argo Navis · REV 16 · 2026-10-16 · draft branding
Packaged   : 2026-10-16 11:10 by Build-DeployPackage.ps1 (leearnol)
Source     : REV 16\Seadrill BOP Schedule Builder.html
SHA-256    : 299eed6eed769216bdfb5d9b432c020b11a90daef78d18d39ef60d828a52e945  (index.html and Seadrill BOP Schedule Builder.html are identical)

Drop this folder's contents into C:\TSC-Dashboard\tools\argo-navis\ and run Deploy.
Served at  : http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/

The server must also provide, beside index.html (not in this package):
  Argo-Navis-Job-Plan-Checklists.html   Dan's job plan checklist file (JPC). Argo Navis opens it by its relative name.
  data\index.json + data\<inputs>        written by the scanner: WO.csv, Job Plans and Durations.xlsm,
                                        Job Plan Branch  Sequence Map.xlsx, Job plan detailed *.xlsx, the three
                                        * Job Plan List.xlsx, wce_references.json, synergi_lessons.json.
When data\index.json answers, Step 1 loads everything from data\ with no folder pickers. The CoC Tracker is on the same
server, so it connects directly.

Posting (REV 14 on): Argo Navis posts plans, progress, close-out, the BOP designation and the pre-deployment checklist
to SACRED's intake. The intake address is NOT in this build. It is read at run time from a file beside index.html:
  argo-config.json    { "intakeUrl": "<the intake address>", "dryRun": true }
Dan owns that file and keeps it on the server only. Without it the post buttons save the post file instead.
"dryRun": true forces every post to be a test post (filed under dl1.tests). Without it, "Test post" is ticked by default
and a planner can untick it; add "defaultLive": true to start unticked (live) once the loop is proven.
Read back from the same folder: plans-open.json and plans-status\<planId>.json (written by the scanner).
REV 15: the job plan checklists are BUILT IN (Dan's JPC, embedded by Scripts\Embed-Jpc.ps1 with the intake address removed;
the checklist takes it from argo-config.json at run time). Argo-Navis-Job-Plan-Checklists.html beside index.html is no longer
needed and may be removed. The Daily Summary Report is posted twice daily by the rig (Post daily report), with
WCGRRT 172's rules (planning-rules.js, embedded unchanged). Optional rules inputs read from data\: BWM_Event_PMs_Maximo_*.csv and
CBM_Event_PMs_Maximo_*.csv (Maximo event PMs: PM numbers and PMs with no work order yet).