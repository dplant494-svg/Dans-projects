# Argo Navis: handoff from Dan and SACRED, 14 October 2026

**To:** Lee Arnold and the Argo Navis session · **From:** Dan Plant, with the SACRED dashboard session
**Replaces:** `ARGO-NAVIS-HOSTING-HANDOFF-FOR-LEE-2026-10-13.md` (yesterday's), which you have already acted on: the same-origin
read is in REV 13. Thank you. This one closes the loop and adds two things.

## 1. The one thing we need from you first, in plain words

Argo Navis reads five kinds of file to build a plan. Three of them already sit on the feed share, and SACRED now copies them
to the server every ten minutes, where your REV 13 reads them by URL:

| File | On the share today? |
|---|---|
| `WO.csv` (Manpreet's work orders) | yes, `\\SEADRILL23339\Well Control Data\WO.csv` |
| `synergi_lessons.json` | yes, same folder |
| `wce_references.json` | yes, same folder |
| **`Job Plans and Durations.xlsm`** | **no** |
| **`Job Plan Branch  Sequence Map.xlsx`** (Dan's map, two spaces in the name) | **no** |
| **the `Job plan detailed *.xlsx` workbooks** (the 12 job plan exports) | **no** |
| **the three `* Job Plan List.xlsx` Maximo exports** (WCE, MPD, Electrical) | **no** |

The last four live somewhere on your side (your project folder, your OneDrive). **Please copy them into a folder called
`Job Plans` on the feed share: `\\SEADRILL23339\Well Control Data\Job Plans\`.** Your CLAUDE.md names that as the agreed
home; the share was unreachable when it was written, so it has not happened yet. Once they are there, Dan adds one line to
the scanner's config and they publish to the server like the other three. When you change the Branch Map, copy it there
again (or edit it there); the scanner skips it while Excel has it open.

If the share is hard to reach from where you are, send Dan the files instead and he puts them there.

## 2. Where everything lives on the server, for the rigs

| What | Where |
|---|---|
| Argo Navis | `http://sdrlazneuiis01d.corp.local:8080/sacred/dl1/` (the BOP page's button opens it) |
| its inputs | `/sacred/dl1/data/` with `index.json`, refreshed every ten minutes by the scanner |
| `plans-open.json` | `/sacred/dl1/plans-open.json` |
| the job plan checklists file | beside the tool, same folder |

**To deploy:** send Dan the package your `Build-DeployPackage.ps1` makes. He drops its contents into
`C:\TSC-Dashboard\tools\argo-navis\` and runs Deploy; it lands as-is in `/sacred/dl1/`. The BOP page's button switches from
"coming" to "Open the schedule builder" by itself.

## 3. What SACRED built this week that touches you

1. **Plan review loop, live.** When a rig presses Post for review in REV 14, SACRED emails the plan audience, opens the plan's
   Teams chat, and lists the plan on the Help Centre's **Plans** tab. The region's required reviewers (Dan's roster:
   Ronnie for GOM, Angola, Namibia and Malaysia; Joao for Brazil; BOP Controls and Brent for all) press Verified or Changes
   needed there. When every required reviewer has verified, the planner gets "verified by all, freeze the scope" in the chat
   and by email, and presses Freeze in Argo Navis. A Changes needed sends it back; the next scope version starts again.
   `plans-open.json` now carries `review: { state, verified, required, outstanding[] }` per plan, if you want to show
   "2 of 3 verified" inside the tool.
2. **Testing at 90 %.** SACRED computes the Testing branch's percent from your `plan-progress` posts and sends the
   pre-deployment-call notice to the chat at 90 %. If REV 14 posts its own testing percent, say the key and SACRED reads it
   instead.
3. **FRM-00-0168 Rev 9, five new checklist lines** (SSORT 165 has them live since 14 Oct). The tools session's handoff
   `HANDOFF-LEE-PDC-REV9-ADDITIONS.md` has the lines, the SSORT keys and three suggestions; in matrix terms C-05 (ROV panel
   valve orientation and line-up, captioned photographs) and R-01 to R-04 (riser running and pulling checklist, drops
   inspection, seals verified, maintenance by 3rd party / CBM / Seadrill). Please add them to `PDC_LINES`.
4. **Optional sign-offs** (Ops Director, WCE Manager, Head of WCE, Regional Superintendent) must not hold "ready to sign"
   open: leave them out of the count or close them as N/A.

## 4. Asks, in one list

1. The four rules files onto the share (section 1).
2. The REV 14 deploy package to Dan when ready.
3. The Rev 9 lines into the checklist (section 3.3) and the optional sign-off rule (3.4).
4. The two drafts your CLAUDE.md says are written and not sent: the entry 2 reply and the Maximo data request for Manpreet.
5. Your view on showing the review state in the tool (3.1), no rush.
