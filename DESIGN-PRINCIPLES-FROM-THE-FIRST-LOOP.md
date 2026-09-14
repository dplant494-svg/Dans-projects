# Design principles from the first loop

**From:** the Precharge Pro session
**Date:** 13 September 2026
**Sits alongside:** `NOTIFICATION-LOOP-PATTERN.md` (dashboard / scanner session)
**For:** page 6 of the Feb 2027 pack, and whoever builds loops two to five

---

## What this is, and what it is not

This is **not** a description of the notification flow. That flow belongs to the
dashboard/scanner session, they built it, and their pattern document is the one to
copy from. I have never seen it.

This is the other half: **five principles the precharge work actually established**,
each with the case that produced it. They are written from this workstream only. None
is a general software maxim — every one of them cost something to learn here, and the
cost is the reason to believe it.

They are ordered by how expensive they were.

---

## 1. One renderer per artefact

**If two pieces of code can render the same controlled document, they will
eventually disagree, and someone will act on the wrong one.**

The precharge sheet is a controlled document: a rig charges nitrogen bottles to the
number on it. When the dashboard session asked for a printable copy in the
notification email, the obvious move was to write an HTML renderer that laid the
sheet out the way the PDF does. That would have been a **second renderer**. Two
renderers drift — not immediately, but on the fourth change, when someone updates one
and not the other. A rig holding two copies of the same sheet that disagree, with no
way to tell which is current, is the exact failure this tool exists to prevent.

So `sheetHtml` **serialises what is already rendered on screen** rather than
re-deriving it. And when the standard later became *"the attachment must look exactly
like the generated PDF"*, the answer was not to make the HTML better — it was to send
the PDF itself. `generatePDF()` was **split, not rewritten**: the drawing code moved
into `buildPdfDoc()` **byte-identical, 14,462 characters**, and `generatePDF()`
became two lines that call it and save. The download and the email attachment now
come from the same object.

**The test:** if you can name two functions that could each produce the thing the
user acts on, you have already lost. Collapse them before they diverge.

**Where it bit anyway:** the dashboard session found the same defect inside their own
code — their full-report viewer had its own copy of the companion-suffix rule,
separate from the scanner's, and both needed the same fix. Two parsers, one document.
It is not a rare shape.

## 2. Assert the outcome, never the prose

**A test that pins someone else's wording fails when they reword, and passes when
they break something.**

Our harnesses asserted the exact text of the password gate's fail-closed message — a
file owned by the other session. They reworded it, for good reasons, and **two
harnesses went red on a cosmetic change** while testing nothing about behaviour. The
tests now assert that the gate *sets an explanation and disables the field*, which is
what actually matters.

The same mistake, differently dressed, stopped a build: an assertion counted
`'<body>'` as a substring to check for one HTML tag. The moment a function generated
an HTML document, `<body>` appeared inside a JavaScript string literal and the count
became two. The assertion was **testing a substring while claiming to check a tag**.

And the sharpest version: an injection step *required* the other session's
path-bearing text to be present so it could rewrite it. When they fixed the problem
at source — doing exactly what we asked — **our build broke because the thing it was
there to fix no longer existed.** A check that fails on success is worse than no
check. It now replaces the text only if present, and asserts the outcome: no server
path reaches the login screen, however it got there.

**The test:** write down what must be true of the *result*. If your assertion would
pass on a broken system that happened to use the right words, rewrite it.

## 3. Fail soft on the optional, fail closed on the essential — and know which is which

**Most of the design is in that classification. Get it wrong in either direction and
you get a silent lie or an unusable tool.**

- `sheetHtml` and `sheetPdf` are **optional**. If jsPDF has not loaded, or the
  document cannot be built, they come back empty and **the post still succeeds**.
  A rig's precharge must never fail to reach the dashboard because an attachment
  could not be generated.
- The password gate is **essential**. With no config it **fails closed** and says so.
- A blank well name is **essential**, and this took two passes to get right. It was
  first left as a warning. It is now a refusal on the post — because a blank well
  breaks the return leg, the email subject and the filename *at once and silently* —
  but deliberately **only on the post**. Saving, exporting and printing a half-worked
  sheet are all legitimate. It is publishing it to a rig that is not.

**The test:** for each failure, ask "if this silently does nothing, who finds out, and
when?" If the answer is "nobody, until a rig charges to the wrong number", it is
essential.

## 4. A harness that cannot do its job must say so, not return a result

**The most expensive failures here were tools reporting success while measuring less
than they claimed.**

Three separate instances, all the same species:

- A scope-proving harness read output containers that did not exist, so it compared
  empty against empty and reported **"no rigs moved" regardless of what changed**. It
  was blind to five rigs for several revisions.
- The same harness extracted the engine by position with a greedy match. On a build
  with more than one inline script it swallowed page markup as JavaScript, failed, and
  reported **all thirteen rigs moved** with every value blank. Fixed in the files where
  it was noticed, and left live in one that had not been checked — which therefore
  could not run against the served build at all.
- The qualification suite could not find its scenario file, **fell back to a smaller
  built-in set, and reported a clean "45/45 passed"**. It printed
  `(scenarios.json not found — using built-in envelope)` on every single run, and
  nobody read it. Every delivery for weeks was verified against a reduced set. Worse:
  a note in the project file claimed the missing scenarios had been *lost*, that claim
  was passed to another session as a correction to a pack going to IT, and **a number
  heading for IT was nearly revised downwards because a harness lied quietly.**

**The rules that came out of it:** a harness that cannot parse its input **throws**.
A harness that cannot find its inputs **fails**, it does not quietly measure less. And
**check the run, not the note** — a comment in a file is not evidence.

**The liveness test is cheap and worth it:** point the harness at a revision you know
*did* change something, and confirm it says so. A green suite that cannot go red is
decoration.

## 5. A step that can do damage as a side effect is not a routine step

**Convenience and blast radius are different axes. Optimising the first without
looking at the second is how you lock people out.**

Publishing to the server was a script with a guard: it compared the password file on
both sides by hash and **refused to overwrite a differing one** without an explicit
switch. That guard was then talked away — by me — in favour of a shorter one-line
wildcard copy, on the reasoning that one pasteable line beats a script whose switches
you have to remember.

The wildcard swept up the password file. The local folder held an older copy than the
server, because the current one had only ever been in a Downloads folder. **The live
password reverted and every user was locked out of the tool.**

The switch *was* the safety feature. The ceremony was the point.

**The test:** list what a step can change. If that list includes anything the step is
not named after — a password, a schedule, someone else's file — it needs a guard, and
the guard does not get removed to save typing. If the operator wants one line, give
them a one-line version that *cannot* reach the dangerous thing, not a shorter one
that can.

---

## What these have in common

Four of the five are failures of **honesty in tooling** rather than failures of logic:
a renderer that might disagree with itself, a test that reports on the wrong thing, a
silent degradation, a harness that measures less than it says, a publish step that
does more than it says. None was an arithmetic error. The calculation has been
byte-identical across every revision in which any of this happened.

That is the thing worth carrying into loops two to five. **The engineering was rarely
the hard part. Knowing whether the machinery around it was telling the truth was.**

---

### For the record — what this workstream holds itself to

Every delivered revision proves, before it ships:

- the three physics sources **byte-identical** to the previous revision, unless a
  precharge figure was deliberately changed and is recorded in the MOC register;
- `compute()` **byte-identical**, by brace-matched extraction, not by eye;
- a rendered diff across **all 13 rigs × 38 output containers**, reporting per rig;
- the full qualification suite on **both** builds;
- the MOC register updated **in the same piece of work** — a revision delivered
  without it is an incomplete deliverable.

Sixteen revisions in seventeen days, including six in one day, have gone out under
that rule. It is the reason a change can be made quickly on a tool that sets
pressures for equipment on the seabed.
