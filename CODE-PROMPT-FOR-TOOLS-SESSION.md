# Opening Claude Code on the reporting tools — Dan's prompt, with the dashboard side included

**Date:** 21 September 2026. Replaces Prompt A in `DASHBOARD-HANDOFF-TO-CODE-REQUEST.md`.
**Folder Claude Code is opened on:** `C:\Users\danplant\Claude\Projects\Subsea Superintendent Reporting Template`

## Before pasting the prompt: four files to copy into that folder

The tools session's own handoff (`SSORT and WCERRT Integration.md`) is already there. These
four are from the dashboard repository and are what stops the tools side changing something
the dashboard depends on. Copy them from `C:\TSC-Dashboard\` (or the repository) into the
folder above:

1. `DASHBOARD-SCANNER-INTEGRATION.md` — our handoff to Code, sent 21 September.
2. `INTEGRATION-CONTRACT.md` — every field the scanner and dashboard read, by report type.
3. `CBM-OEM-HANDOFF.md` — the Post to OEM payload contract (`seadrill-oem_*`, `meta.kind`).
4. `REPORT-LOAD-LATEST-TOOL-HANDOFF.md` — the Load latest posted button contract.

If any of the four is not in `C:\TSC-Dashboard\`, they are in the repository at
`github.com/dplant494-svg/Dans-projects`, branch `claude/dashboard-automation-planning-aa0sqi`.

## The prompt

Paste all of it as the first message.

```
This folder holds the WCGRRT and SSORT reporting tools and their handoffs. Thirteen rigs post
from these tools every day. Before you touch anything, read these in this order:

  1. "SSORT and WCERRT Integration.md"  — the tools' own handoff. The four rules in §0 are law.
  2. DASHBOARD-SCANNER-INTEGRATION.md   — the dashboard and scanner side, which consumes every
                                          post. Its §0 rules are law too, and §3 is how our
                                          fields are actually read.
  3. INTEGRATION-CONTRACT.md            — field by field, what the dashboard reads per report type.
  4. CBM-OEM-HANDOFF.md and REPORT-LOAD-LATEST-TOOL-HANDOFF.md — two features on the tools'
                                          list whose payloads the dashboard already expects.

Then confirm back to me, in your own words, before doing anything else:

  a) The four rules in the tools handoff §0 and the four in the dashboard handoff §0.
  b) Which revision of each tool is current, which is deployed, and how you established that
     (meta.rev in a fresh post and the deployed REV folder; say if they disagree).
  c) Why the posting contract in the tools handoff §4 must not be varied, including the
     argument-order trap in §4.1.
  d) The case-sensitivity trap in the dashboard handoff §4, and the rule that follows for us:
     every key we add is lower case and is announced in the rolling handoff before it ships.
  e) Which fields the dashboard reads from our posts (contract §3): meta.asset, meta.reporttype,
     meta.reportdate, tileDate, meta.date, meta.dateend, meta.type, meta.discipline, meta.wce,
     meta.checks, criticalRows, actionRows, photoDump, attachments, equipEntries[].soak and the
     tile data blocks (cbmData, pdcData, topsetData, planningData, bwmData, marineData,
     r53Data, caData, inspData, sbopData). Renaming, re-nesting or changing the type of any of
     these breaks the dashboard for every rig at the next scan.

Then do these, in this order, and STOP after each for me to check:

  1. Run node --check on every <script> block in the current revision of both tools and report
     anything it finds. Change nothing.
  2. Tell me exactly how many bytes the unreferenced base64 blobs are costing
     (PRECHARGE_HTML_B64, CONDUIT_FLUSH_HTML_B64, ACOUSTIC_TEST_B64) and propose how to strip
     them without touching anything else. Change nothing.
  3. Show me the corrupted CBM grade strings listed in the tools handoff §10 as a before/after
     table. Change nothing.
  4. List the items the tools session queued after REV 161 (their 19 Sep reply called the
     next revision 162; by 21 Sep the folder was at 164 and acoustic soak was native in 163,
     so use the folder and meta.rev, not the number in any handoff). The items: iframe harvest into soak with
     soakLabels, the post receipt with the replaces line and the unposted-changes mark, the
     three print rules, #attachments-block hidden in report mode, stale entry dates with the
     amber mark and one-click set, the counts block, the Load latest posted button) and for
     each say which files and functions it touches and whether it changes the posted payload.
     Anything that adds a key to the payload gets its key name written here, lower case, so I
     can send it to the dashboard session before it ships.

Rules for every step after that, none negotiable:

  - Work only in the current REV folder I name (164 as of 21 September). Never edit a deployed REV folder.
  - Never change the posting path, the Post payload's existing keys, the filename logic, the
    photo compression (0.82) or the size ceilings (10 MB, 40 MB for CBM and PDC). New keys
    only, lower case, additive, announced.
  - Never use mode:'no-cors' on any fetch. The Post contract explains why.
  - node --check passes on every <script> block before anything is called done. Then open
    the built file in a browser, create one report of each type with the asset "SSCE
    Equipment" (the tools handoff §8: the asset list is fixed, there is no training rig and
    none is to be added), save it locally, and show me the saved JSON's meta block and the
    counts for each. Rig-keyed forms (acoustic, EDS, cavity) need a real rig selected and
    the result saved locally. Do not post anything from a test; posting is mine to do, on a
    real rig name, when I say.
  - Any base64 blob you strip: show me the byte count before and after and prove by search
    that nothing references it.
  - If a template or source document contradicts the current tool, ask me first. The
    templates were deliberately modified and are not like-for-like.
  - Deliverables are files with their production names, saved into the REV folder. Tell me
    what to copy where in one numbered list. I install by saving over the old file.
  - When something you find changes what the dashboard side needs to know, write it as a
    numbered entry in DASHBOARD-ROLLING-HANDOFF.md, not in chat. That file is the channel.

Start with the reading and the confirmations. Do not start step 1 until I say go.
```

## What changed against the original Prompt A, and why

- **The dashboard side is read first, not discovered later.** Two of the three defects that
  cost this month (the case-sensitive key, the report date fallback) were contract
  misunderstandings between the two sides. The new session sees both contracts before it
  writes a line.
- **A confirmation on the fields the dashboard reads**, so a rename or a re-nesting cannot
  slip through as a "tidy-up".
- **Step 4, the map of the queued items**, so every payload change is known and named before it ships,
  and the rolling handoff gets it.
- **A test rule that never posts.** Local saves on "SSCE Equipment" prove a build (the asset
  list is fixed; a training rig would appear on thirteen rigs' dropdowns); posting from a
  test would put a test report on the fleet dashboard.
- **The channel rule.** Findings for the dashboard go in the rolling handoff file, which is
  what both sides already read; chat is where things got lost.

## For the session on the dashboard side, when that moves to Code

Prompt at the end of `DASHBOARD-SCANNER-INTEGRATION.md`'s delivery message, 21 September: read
that file, confirm the four rules, the live versions and the case trap, then run the three
scans on the test set and show the comparison. Same shape, same stop points.
