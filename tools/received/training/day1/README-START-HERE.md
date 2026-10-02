# WCE reporting tools — Day 1 pack

**From:** the reporting-tools session · **Date:** 30 September 2026
**For:** the dashboard session, to build the trainee workbook and trainer's pack
**Class:** Monday 19 October 2026, Houston · **Draft due 5 October, final 12 October**

Everything in this folder is Day 1 (the reporting tools). Day 2 is yours and nothing here
touches it.

---

## Read in this order

| # | File | What it is |
|---|---|---|
| 1 | `01-REPLY-to-handoff-2.md` | **Read this first.** Answers §2 (file names), §3 a/b/c and all four §4 asks from your 30 September handoff. Three findings in it change the exercise. |
| 2 | `02-Walkthrough-Scripts.md` | Four module scripts, 77 numbered steps. What the trainer clicks and says, with `SAY:` lines and `TRAP:` warnings. Screenshot markers `[SHOT 1]`–`[SHOT 24]`. |
| 3 | `03-Exercise-Sheet.md` | One per trainee. Their allocated date, the four reports, the file names their work will produce, and spaces to record what the tool told them. |
| 4 | `04-Questions-and-Answers.md` | Twelve questions, three per module, with answers for the trainer's copy. |
| 5 | `05-Screenshot-List.md` | All 24 shots specified exactly, and which five cannot be captured. |
| 6 | `06-Day-1-Deck.pptx` | The 19-slide deck with slides 3, 16, 17 and 18 edited. |
| 7 | `07-SCREENSHOTS-STATUS.md` | **The dashboard captured these itself** — closed here. Two checks before final, and the build-freeze question. |
| 8 | `samples/` | Four sample reports built from the frozen builds, plus a README explaining each. |

## The frozen builds

**WCGRRT REV 167** and **SSORT REV 156**. SSORT 156 was deployed on 30 September;
sha256 `44cb4db89d2c2910086ff6c6a1c23a80034b6f53b0b44b0b326e0c31d2b161a1`, 6,800,443 bytes.
Everything in this pack is written against those two and nothing else.

**SSORT moved from 152 to 153 during the day.** The only difference the class will see is one
line in the Post to OEM confirm: the crew's attached test records now reach NOV as real email
attachments, where on 152 they were listed for NOV but not attached. That went live on
30 September once the dashboard side proved Part D3 of the OEM flow. Module 3's script, the
exercise sheet and question 3.3 all say so; if you find anything in this pack still claiming
NOV does not receive them, it is stale and wrong.

## One more finding, v4 (30 September, late)

Chasing your TRAP line about shot 11 turned up something worth having before the class rather than
during it. **Four of the seven WCGRRT test records are keyed to the rig, and `SSCE Equipment` holds
none of them.** Verified on the frozen build: the ROV, acoustic, EDS and EHBS forms each render one
line on that asset instead of a form ("No EDS verification sheet on file for SSCE Equipment", and so
on). Only the BOP Function Test, the Soak Test and the Surface Drawdown Test work on it.

So **module 2 is taught on a real rig** and the script now says so at the top of that module, names
which rig for which form, and adds a step to switch the asset back to `SSCE Equipment` before
anybody posts. The exercise is unaffected — its surface test is SSORT's tile, not WCGRRT's.

The script also now distinguishes the two messages a crew can meet, which are easy to conflate:
*no sheet on file for this asset* means nobody has loaded it yet, so tell the office; *no system
fitted* means the rig genuinely does not have one. And shot 23's cavity trap is in module 3 as a
TRAP line, as you asked.

While checking, one thing I nearly reported as a defect was not one: selecting ROV Function Testing
appeared to show the EHBS message, but that was stale DOM from the previous selection in my own test
loop. On a clean selection it says the right thing.

## Lee's two edits, done

The class sits inside Lee Arnold's WCE SME workshop (19 to 22 October), so **Lee opens Day 1 at
08:00** with the safety minute, roles and responsibilities and expectations. Both asks from your
reply are in this pack:

- A new **Opening** slide before Module 1 — now slide 4, `Lee Arnold · safety minute, roles and
  responsibilities, expectations for the week · 08:00–08:30`. The deck is 20 slides.
- **Module 1 is 08:30–10:00** on the divider (now slide 5) and in the script header, which also
  tells the trainer to be set up and past the badge check before Lee finishes.

## Three findings that change what was planned

1. **The exercise would have lost three reports in four.** SSORT names the posted file after the
   *first* tile type in the workspace, so four report types built in one workspace post as one
   file. The sheet now says one report at a time, with **⊘ New Trip** between. Detail in §1.1 of
   the reply.
2. **Slide 18 was wrong and is corrected.** It said SSORT reports a failed post much as WCGRRT
   does. It does not — SSORT falls through silently and can say "posted" on a failure. Corrected
   on the slide, in the script, in the exercise sheet and in two questions. Detail in §2 of the reply.
3. **"Load latest posted" is not in REV 166.** It comes out of the 10:15–12:00 agenda line. It is
   correctly listed on Day 2 under "What is coming". Detail in §5 of the reply.

## What is missing, and why

**The screenshots.** Screenshot capture is failing in the build session — every attempt returns a
blank frame, on both tools and against the live server. `05-Screenshot-List.md` specifies all 24
exactly, so the zip can be filled in one pass by whoever gets there first; the four dialog shots
(3, 8, 20 and 24) are the ones the workbook actually needs, so take those first if time is short.
This will be resolved or reported by **3 October**, not left to surprise anyone on the 5th.

Nothing else from the 29 September or 30 September handoffs is outstanding on this side.

## Not included, deliberately

Your own three documents — `WCE-Training-Class-Agenda.pdf`, `TRAINING-HANDOFF-REPORTING-TOOLS-2.md`
and the Day 2 deck — are unchanged and already yours. The only thing this pack asks you to change
in the agenda is the "Load latest posted" line in the Day 1 10:15 module.

No `seadrill-oem_*` sample is included: that file is generated at the moment of sending and carries
a timestamp, so producing one without sending would mean fabricating a file the tool never made.
Its shape is in rolling handoff entries 31 and 43.

## One judgement call

The deck had the CBM exercise on **Single NXT Body**; it is now **Riser Adapter**, because that is
where REV 152's new grades and test-record attachments are, and it is the class Brad raised from the
rig. Trivial to change back if Dan prefers.
