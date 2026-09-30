# Screenshots — status, 30 September 2026, evening

**Capture worked.** Your question in the pack v2 reply, answered: it started working late on
30 September and **19 of the 24 shots were taken on the deployed builds** — WCGRRT REV 166 and
SSORT REV 153, light mode, asset `SSCE Equipment` throughout, and nothing posted.

This file replaces `07-SCREENSHOTS-NOT-YET-CAPTURED.txt`, which said capture was failing and is no
longer true.

## Captured (19)

| Tool | Shots |
|---|---|
| WCGRRT REV 166 | **1** badge · **2** Visit Information populated (also serves **7**, Report Date) · **4** Daily Report Entry selected · **5** equipment entry · **6** captioned photographs · **9** restore bar · **10** BOP function test · **11** EDS Sequence 2 on West Polaris · **12** acoustic no-system on West Vela · **13** EHBS, sequenced class |
| SSORT REV 153 | **17** badge · **18** Riser Adapter 1.1 · **19** grade 3 with the finding written · **20** the five-level scale · **21** attachments empty · **22** two files with task numbers and the running total · **23** packer attestation and the 42-slot requirement · **24** the Post to OEM button in context |

## Why no PNGs are in this zip

The build session's capture tool returns images into the conversation, not files on disk, so there
is nothing here to zip. The 19 images are in Dan's transcript for 30 September, each labelled with
its filename from `05-Screenshot-List.md`; they can be saved from there in a few minutes.

**If that is awkward, take them with the snipping tool instead** — `05-Screenshot-List.md` says
exactly what must be on screen for each one, and every setup step needed to reach it is in
`02-Walkthrough-Scripts.md`. Two of them need a moment's setup that is not obvious:

- **Shot 11 (EDS)** needs a real rig, not `SSCE Equipment` — West Polaris was used. Pick the
  sequence as well, or the steps table does not render.
- **Shot 23 (packer evidence)** needs the pre-deployment checklist's **own** BOP designation set to
  Single **and** its cavity count set, or the cavity photograph slots do not exist at all. Worth
  knowing for the class: a trainee who skips those two fields sees no cavity slots and could
  reasonably conclude the checklist does not want them.

## Five that cannot be captured, unchanged from the list

**3**, **8** and the dialog in **24** are native browser dialogs, which the automation dismisses
before a capture can happen; their text is quoted verbatim in the script, which is what the
workbook needs. **15** (the post receipt) and **16** (the dashboard row) both require a successful
post, and nothing is posted from a build session — take those two live, in module 2 or the
exercise.

## One change to the spec

**The 1600 px width is dropped.** Emulating it only scales the page down to the pane and the text
became unreadable. The 19 shots are at native width and sharp. For a workbook, legibility beats the
nominal size.
