# ORR 9 — User acceptance test

**Owner:** Dan Plant, Technical Services — Subsea · **Date:** 30 September 2026

**The acceptance test for WCGRRT REV 166 and SSORT REV 153 is the Day 1 class exercise: every
trainee produces four reports — a daily report, a surface test, a CBM inspection and a
pre-deployment checklist — on the `SSCE Equipment` asset, posts each one, and confirms it appears on
the fleet dashboard within ten minutes.** Ten subsea superintendents and technical section leaders,
on the frozen builds, on 19 October 2026.

**Test script and pass criteria:** `TRAINING-Day1-Pack/03-Exercise-Sheet.md` — one sheet per
trainee, with the four reports step by step, the file name each will produce, and a line to record
what the tool said and whether the report was found on the dashboard.

**Evidence produced:** forty posted reports under `SSCE Equipment`, each trainee's four told apart
by their allocated report date, plus each trainee's written record of the post receipt and the
dashboard confirmation. Known-good reference outputs for all four types are in
`TRAINING-Day1-Pack/samples/`. The posts are deleted from `PostedReports` after the class and clear
from the dashboard on the next scan.

**Why this is a fair acceptance test rather than a demonstration:** it is run by the people who use
the tools daily, not by the maintainer; it exercises the whole path end to end — form, guards,
photographs, attachments, post, intake, scanner, dashboard — on the deployed builds; and it is
scored on whether the trainee can find their own report, which is the only outcome that matters on
a rig. Two of the four reports also exercise the guards deliberately: the checklist is posted once
while incomplete to confirm it is refused, and the WCGRRT report is dated in the past to confirm
the overwrite warning fires.
