# Argo Navis REV 14: reply from SACRED, 14 October, late evening

**From:** Dan Plant and the SACRED dashboard session · **To:** Lee Arnold and the Argo Navis session ·
**Re:** `ARGO-NAVIS-REV14-REPLY-TO-DAN_DRAFT.md`, `Argo-Navis_REV14_2026-10-14.zip` · **Status:** REV 14 accepted; the
scanner side is built (v2.99); Dan deploys with `argo-config.json` in dry run; first test post from Lee when he is ready.

## Your seven posts through the scanner tonight

All seven filed first time (scanner v2.99, scratch run on the pack's samples, with the reviewer roster loaded):

| # | File | Filed as |
|---|---|---|
| 1 | plan v1 proposed | plan WVE-BOP1-20261005 v1, `proposed`, 121 tasks, ready date and need date read |
| 2 | designation (with `meta`) | designation for the plan, served as `plans-status/designation_WVE-BOP1-20261005.json` and inside the plan's status file |
| 3 | plan v1 frozen | the same plan, now `frozen`; the review state for v1 carries across unchanged |
| 4 | plan-progress | progress 13.1 %, `testingPct` 0 taken from the tool, ready date from the progress post |
| 5 | planning-report | the planning report on the BOP panel, test post |
| 6 | pre-deployment | Pre-Deployment Checklist for West Vela BOP1 under the plan, SSORT keys, Rev 9 groups |
| 7 | plan-closeout | closed out; `edocsRef` EDOCS-SAMPLE-0001 and `projectComplete` recorded |

All under the test plan (`dryRun:true`), kept apart from any real plan, as the contract says.

## Your three asks

1. **`argo-config.json`.** Dan places it beside `index.html` on the server with `"dryRun": true`. It is published by
   Deploy from his `tools\argo-navis\` folder and is excluded from the SACRED repository, so the address stays on the
   server only. Removing `dryRun` and adding `defaultLive` is Dan's call once the loop has run on a real plan.
2. **`review.comments`.** Added in scanner v2.99, in both files: `plans-open.json` (`review.comments`) and
   `plans-status/<planId>.json` (`review.comments`), an array of `{ by, position, decision, text, at }` for every review
   that carries words, verified or changes. Empty array when nobody has written anything.
3. **Freeze keeps the verified version: confirmed.** The scanner keys the review state by plan and scope version, so a
   frozen post with the same `scopeVersion` keeps "verified". One thing found on your samples: the proposed and the
   frozen post carry the same `exportedAt`, and the scanner's newest-wins rule used to keep the first. From v2.99 a tie
   on time is settled by status (frozen over proposed, closed over both). For real posts, please also write
   `meta.saved` as the post time on every post; the scanner reads it before `exportedAt`.

## Your other choices

- **Review field names:** keep reading both; nothing changes on this side.
- **`testingPct`:** read from the tool from v2.99 (`testingPctSource: "tool"` on the panel record); the scanner's own
  computation stays as the fallback for posts without it.
- **`edocsRef`** in `closeout`: recorded with the close-out; it is what the project-complete step will pass to eDocs.
- **Deferral reasons, the checklist post, the failed-post log:** as described, nothing to add.
- **BOP ready date and need date:** the BOP panel now shows "BOP ready … · need date … · float n d", green, amber within
  two days, red past the need date with the downtime days; a frozen-without-full-verification override shows in red
  with the name and reason.

## Dan's next steps (his side)

1. `argo-config.json` beside `index.html` in `C:\TSC-Dashboard\tools\argo-navis\`, `dryRun: true`.
2. Unzip REV 14 over REV 13 in that folder; Deploy.
3. Scanner v2.99 and the updated BOP page installed.
4. Lee posts West Vela BOP1 for review from the server copy; we check the Plans tab, the plan chat and the email, then
   the freeze, progress and close-out in turn. The project folder (built tonight, `Between Wells Maintenance`) files
   each post as it lands and the photographs as image files.

## Still open

- The sign-off order, B-16 and B-M1 directives, the eDocs prefix (Dan, document control, ISIT next week).
- The WO feed (still 25 Sep) and the CoC extract: with Manpreet.
- The navigation links and site owner rights: with Lee (item 52).
