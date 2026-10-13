# Argo Navis on the SACRED server: what is in place and what Lee builds (13 October 2026)

**From:** Dan Plant and the SACRED dashboard session · **To:** Lee Arnold and the Argo Navis session · **Supersedes nothing;
adds to** `ARGO-NAVIS-REV13-REVIEW-2026-10-13.md` (section 2) and the rolling handoff. The posting build is **REV 14**.

## 1. Where Argo Navis lives for the rigs

| What | Where | Who puts it there |
|---|---|---|
| The tool and its files | `\\sdrlazneuiis01d.corp.local\sacred\dl1\`, served at **`http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/`** | Dan: drops Lee's REV folder into `C:\TSC-Dashboard\tools\argo-navis\` and runs Deploy; published as-is, subfolders included |
| `plans-open.json` (every open plan with sections, for SSORT's picker and now with `review`) | `/sacred/dl1/plans-open.json` | the scanner, every ten minutes |
| **The inputs** (new, 13 Oct) | `/sacred/dl1/data/` with `index.json` | the scanner (v2.91): copies each source when newer, skips the Branch Map while its Excel lock exists |
| The BOP page's Argo Navis button | opens `dl1/` beside the page | already live; reads "coming with REV 11" until the folder answers, then "Open the schedule builder" |

The feed share is **`\\SEADRILL23339\Well Control Data`** (Manpreet's WO.csv, his 24-hour task starting 13 or 14 Oct;
`synergi_lessons.json` and `wce_references.json` refreshed daily). Those three are published now. **Lee: where do the
rules files live?** `Job Plans and Durations.xlsm`, `Job Plan Branch  Sequence Map.xlsx`, the `Job plan detailed *.xlsx`
workbooks and the three `* Job Plan List.xlsx` exports. A path the scanner on Dan's PC can read (a share, or a
SharePoint folder synced to his PC) goes into the same list and they publish the same way.

`index.json` shape:
```
{ "generatedAt": "2026-10-13T22:37:05Z", "scanner": "2.91", "count": 3,
  "files": [ { "name": "WO.csv", "bytes": 596123, "modified": "2026-09-25T14:12:18Z", "sourceModified": "2026-09-25T14:12:18Z", "source": "\\\\SEADRILL23339\\Well Control Data" }, ... ] }
```
`modified` is the copy's time; `sourceModified` the share's. The feed-age banner can use either.

## 2. What Lee builds (REV 14 or a REV 14.1): the same-origin read

When the page is served from `/sacred/dl1/` (`location.pathname` starts with `/sacred/dl1/`, or simply when
`fetch('data/index.json')` answers 200), Step 1 reads the inputs by URL instead of the folder pickers, exactly the
`autoConnectCocTracker` pattern:

1. `fetch('data/index.json')` → the list.
2. For each known name, `fetch('data/<name>')` → `arrayBuffer()` into the existing parsers (`readXlsx` takes a buffer
   already; WO.csv is text). Same for `synergi_lessons.json`, `wce_references.json`, the job plan workbooks and the lists.
3. Step 1 shows "Connected automatically (SACRED server)" with the file dates from the index; Reload Everything
   re-fetches. The folder pickers stay for a PC with the shares.
4. The checklist file `Argo-Navis-Job-Plan-Checklists.html` is beside the tool in the same folder, so `JPC_URL`'s
   relative default already works there.
5. Nothing changes in posting: the HTTP post to the intake from anywhere; the planning report sync too.

## 3. What the rig sees once both halves are in

Open `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/`, three green ticks with no clicks, build the scope, Post for
review. From there SACRED's loop runs: the plan email and chat (built and proven 13 Oct), the Plans tab on the Help
Centre where the region's reviewers verify (built 13 Oct, reviewers by region from Dan's Reviewers table), the
"verified by all, freeze the scope" notice back to the planner, the frozen post, execution, the 90 % testing notice.

## 4. Asks to Lee, in one list

1. The rules files' location (section 1).
2. The same-origin read (section 2): REV 14 if it fits, else a point release after.
3. Confirm `plansOpen`/`review` is of use to the tool: each plan in `plans-open.json` now carries
   `review: { state, verified, required, outstanding[] }` (`state` awaiting | changes | verified | frozen | closed |
   no-reviewers). Argo Navis could show "2 of 3 verified" on the plan itself.
4. The two unsent drafts (entry 2 reply, the Maximo data request for Manpreet).
5. The REV 14 folder to Dan when ready, so Deploy puts it on the server.
