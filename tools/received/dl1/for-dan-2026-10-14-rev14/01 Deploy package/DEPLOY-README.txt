Argo Navis deploy package
=========================
Build      : Argo Navis · REV 14 · 2026-10-14 · draft branding
Packaged   : 2026-10-14 16:24 by Build-DeployPackage.ps1 (leearnol)
Source     : REV 14\Seadrill BOP Schedule Builder.html
SHA-256    : 1f0d6a2c8a625d50810d3afcc65c016a41405a940fad6071df539ab27e525792  (index.html and Seadrill BOP Schedule Builder.html are identical)

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