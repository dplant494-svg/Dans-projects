# Update for Lee: REV 15 posting works on the server; one change for REV 16

**From:** SACRED, via Dan (over Teams). **Date:** 16 Oct 2026, afternoon. **Read with:** `ARGO-NAVIS-REV16-PLAN-REVIEW-FROM-SACRED.md` (four points), which still stands.

## Results today

1. **Why REV 15 only downloaded files this morning.** The cause was on SACRED's side, not in Argo Navis: `argo-config.json` on the server still held the placeholder text from the instructions, not a real intake address. Dan has put the real address in and redeployed (`dryRun: true`).
2. **Post report now works:** a test post went through from the server page, with no download.
3. **Sync to Dashboard still downloads a .json.** It is the old folder route, and no folder was ever picked.
4. **The daily report route is proven end to end** with your REV 15 sample: scanner printed it, the flow emailed [TEST MODE] to Dan and Lee with the PDF, and the latest state went to `plans-state`.

## The change Dan wants in REV 16

**One way out, and it posts.** Make **Sync to Dashboard** a **Post** button (Dan: "so we have one at the top and bottom"). Both buttons post through the intake, as Post report does now. Keep a plain **Download a copy** link for emailing, and remove the folder-picking route.

## Still to come in REV 16 (from the plan review)

- The landing page, Save at any stage, and loading by rig (handoff 3).
- Fetch `index.json`'s `path` as it is: it already starts `plans-state/`.
- A **Server save ON / OFF** chip with the reason, and never a silent fallback.
- Test plans shown by default while `dryRun` is on.
- Milestone dates on the timeline stars (handoff 4).

**Then:** Dan deploys REV 16, and you make the first dryRun save and daily post on the server page when ready.
