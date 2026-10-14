# Handoff to the tools session: the daily blank posts are SSORT 163 on three rigs (entry 74.2 closed)

**From:** Dan Plant and the SACRED dashboard session · **To:** the reporting-tools session (SSORT) · **Date:** 14 October
2026, evening · **Status:** NEEDS ACTION, small: get three rigs onto SSORT 165 and add one guard.

## What we found

Blank posts named `seadrill-report_<rig>_<date>.json` arrive every day from **West Saturn** (23 Aug to 13 Oct, most days),
and arrived from **West Capella** (25 Aug to 3 Sep) and **West Tellus** (12 Oct). Dan opened the Saturn post of 13 Oct:

- `meta.rev` = **`SSORT REV 163`**, `exportedAt` 2026-10-13T13:03:49Z;
- `meta.reporttype` `""`, `tiles` `[]`, `criticalRows` `[]`, `actionRows` `[]`, every header field blank;
- the file still carries the whole workspace: the pre-deployment checklist's two equipment appendices (43 and 48 rows
  of fixed equipment text), the AAB block, the VRR flags and the sign-off slots, all empty.

That is the Daily Log tab's end-of-trip **Post Report** you removed in 164 (entry 74): the crew finishes the Daily Log,
presses the button that looks like the day's post, and the empty Rig Reporting workspace goes to the intake. The crew is
not posting on purpose. The rig is on 163 because the tool is a file on their PC and nobody has replaced it.

## What SACRED did (scanner v2.92, installed 14 Oct)

Any `seadrill-report_*` post with an empty `meta.reporttype` and no tiles is listed once under Problems as `blank-post`
and kept off the Reports list and the rig's panel. The 34 skipped files on Dan's dashboard tonight are these. Nothing
is deleted; the files stay in PostedReports.

## Asks

1. **Get West Saturn, West Capella and West Tellus onto SSORT 165** ahead of the class on 20 October, the same way the
   class build goes out, and confirm back which rigs are on which build if you keep that list. The blank posts stop
   the day the rig opens 165.
2. **A guard in SSORT's post path, for the next build after the freeze:** never post when `meta.reporttype` is empty and
   `tiles` is empty; show "Nothing to post" instead. It costs nothing on 165 and protects against any future button that
   posts the workspace.
3. **One line in the rolling handoff** closing 74.2 with the cause (163 on the rig), so the next person reading it does
   not reopen the hunt.

## For the ORR / Status page (our side, no action for you)

Scanner v2.96 will show the posting build per rig on the Status page (newest post's `meta.rev` per rig), so a rig left
on an old build is visible without opening a file. The intake flow stays as it is: it accepts what the tool sends, the
scanner decides what is shown.
