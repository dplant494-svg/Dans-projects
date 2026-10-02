# Screenshots — status, 2 October 2026

**The dashboard session captured these itself.** Nothing is owed from the reporting-tools side and
this item is closed here.

Two things to check before the pack goes final, both caused by the builds moving after the shots
were taken rather than by anything wrong with the shots.

## 1. Check the revision badges in shots 1 and 17

Those two are the only shots where the build number is the subject. The live builds are now:

| Tool | Revision | Deployed |
|---|---|---|
| **SSORT** | **REV 156** | 2 October |
| **WCGRRT** | **REV 167** | 1 October |

If the shots were taken before 2 October the SSORT badge will read 153, 154 or 155. Any of those is
wrong for the class and shot 17 needs retaking. Everything else in the set is unaffected — nothing
visible in the other shots changed between those builds.

## 2. Shots 18 and 19 may show fewer grade rows than the class will see

**SSORT REV 156 changed what the CBM screen looks like**, and those two shots are of it:

- Riser Adapter now has **22 grade rows, not 11** — its Testing and Intrusive sections are graded
  as well as General Inspections.
- A grade row on a Testing or Intrusive task shows **1, 5 and N/A only**, with a yellow caveat line
  reading *"NOV publishes only grades 1 and 5 for this item."*
- There is a **23rd equipment class**, Riser Spider Assembly and Gimbal.

If shots 18 and 19 were taken on REV 154 or earlier they show the old screen. They are still
readable and the teaching point of each is unchanged, so this is a judgement call rather than a
must-fix — but a trainee comparing the workbook to the screen will notice.

**Module 3's script covers the new behaviour** at steps 53a and 53b, so the trainer will not meet it
cold whichever way the shots go.

## 3. The thing actually worth deciding: when does the build freeze

SSORT has gone **152 → 153 → 154 → 155 → 156 in four days**, each for a good reason — a rig's bug
report, a data-loss defect found underneath it, then two new NOV documents. Every one of those
invalidates a badge screenshot and a "frozen build" line in this pack.

The class is **19 October**. **A date after which nothing ships unless a rig is broken** would stop
this pack chasing the tools. Suggested: **12 October**, the same day the pack goes final. Anything
found after that is held unless it is losing someone's work.

That is Dan's call, and it is the only thing from this side still open on the screenshots.

## The five that could never be captured, unchanged

**3**, **8** and the dialog in **24** are native browser dialogs, which the automation dismisses
before a capture can happen; their text is quoted verbatim in the script, which is what the workbook
needs. **15** (the post receipt) and **16** (the dashboard row) both require a successful post — take
those live, in module 2 or the exercise.
