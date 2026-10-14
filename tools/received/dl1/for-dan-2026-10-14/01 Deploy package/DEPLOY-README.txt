Argo Navis deploy package
=========================
Build      : Argo Navis · REV 13 · 2026-10-12 · draft branding
Packaged   : 2026-10-14 08:09 by Build-DeployPackage.ps1 (leearnol)
Source     : REV 13\Seadrill BOP Schedule Builder.html
SHA-256    : 31e76a1514a9c5387032cce9fe770b5d1f28f2baad99884c7fbe699328638627  (index.html and Seadrill BOP Schedule Builder.html are identical)

Drop this folder's contents into C:\TSC-Dashboard\tools\argo-navis\ and run Deploy.
Served at  : http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/

The server must also provide, beside index.html (not in this package):
  Argo-Navis-Job-Plan-Checklists.html   Dan's job plan checklist file (JPC). Argo Navis opens it by its relative name.
  data\index.json + data\<inputs>        written by the scanner: WO.csv, Job Plans and Durations.xlsm,
                                        Job Plan Branch  Sequence Map.xlsx, Job plan detailed *.xlsx, the three
                                        * Job Plan List.xlsx, wce_references.json, synergi_lessons.json.
When data\index.json answers, Step 1 loads everything from data\ with no folder pickers. The CoC Tracker is on the same
server, so it connects directly. Nothing in this build posts anywhere (posting is REV 14).