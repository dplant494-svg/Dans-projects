# Handoff — build the Seadrill Bulletin Board

**For:** Eric Rachall, gatekeeper for Technical Alerts, Advisories and Bulletins (AABs)
**From:** Dan Plant, Subsea Superintendent — Technical Services
**Date:** 15 September 2026
**What this is:** everything you need to have Claude build the AAB creation tool,
plus what to send back when it is done.

---

## 0. Read this bit first, Eric

You are building the **second instance of a pattern we have already proved**, not
something from scratch. The BOP precharge tool does exactly this shape today and it
works: a rig raises a request, it lands on the dashboard, someone acts on it, the
answer posts back, and the rig gets told. Yours is the same loop with different
content — you issue an advisory, every applicable rig gets told, they acknowledge,
and the acknowledgement comes back to you.

Three things that will make this go well:

**Paste section 2 into Claude as your opening message.** It is written to be pasted.
Everything after it is reference material for the questions Claude will ask you.

**Let Claude ask you questions before it writes code.** The precharge tool took
eighty-odd revisions, and most of the expensive mistakes were things nobody asked
about at the start. If Claude starts building without asking anything, stop it and
tell it to ask.

**Say "I don't know" when you don't.** It is a much better answer than a guess.
Anything you do not know, Dan or I can settle — the list of open questions is in
section 7 and none of them blocks you starting.

---

## 1. What has already been decided

These are Dan's decisions, made 15 September. They are settled — build to them.

| Decision | Answer |
|---|---|
| **Levels in your tool** | **Level 3 only.** Levels 1 and 2 stay out of this tool; Dan is reviewing those and will amend the directive |
| **Who acknowledges** | **One acknowledgement per rig, by a named role** — plus a **separate "action closed"** state. Two distinct things: *we have read it* and *we have done it* |
| **Rigs** | The **13 units** in section 4. Structure the list as data so units can be added later |
| **Due date** | **You set a due date on each AAB** when you raise it |
| **The bulletin PDF** | **Travels inside the posted record**, so the dashboard shows it and the email attaches it. No separate upload, nothing to go missing |
| **Revisions** | A revision **supersedes and requires re-acknowledgement.** Previous acknowledgements are kept as history, but every rig goes back to outstanding |
| **KPI on the dashboard** | **Overdue count first, then % acknowledged.** One old unacknowledged AAB must be visible, not averaged away |
| **Ownership** | **You own your tool and the record it posts.** The dashboard team own routing, the dashboard AAB section, the acknowledgement write-back and the KPI |

That last one matters more than it looks. On the precharge work two people were
editing the same pages for a fortnight and it became unworkable. The rule that fixed
it: **if it renders in your tool it is yours; if it moves or names a file it is
theirs.**

---

## 2. The prompt — paste this into Claude

```
I need to build a tool called the Seadrill Bulletin Board. It is a single
self-contained HTML file, no server, no build step, no dependencies beyond
what can be loaded from a CDN in the page head. I will open it from a folder
or a web share and it must also work opened from disk with no network.

WHAT IT DOES

I am the gatekeeper for Seadrill's Technical Alerts, Advisories and Bulletins
(AABs). This tool is how I raise a LEVEL 3 ADVISORY AAB and send it to the
rigs it applies to.

I fill in the AAB, choose which rigs it applies to, attach the bulletin PDF,
set a due date, and press "Post AAB". That posts one JSON record to our
dashboard system. The dashboard then shows the advisory in its AAB section,
each rig acknowledges it there, and the acknowledgements come back to me so I
can see who has acknowledged and who still has an open action.

WHAT I NEED THE TOOL TO CAPTURE

Per AAB:
  - AAB number and revision
  - Title
  - Level (fixed at 3 for this tool, but store it explicitly)
  - Category or equipment area
  - Issue date, and a DUE DATE that I set
  - Originator (me) and my email
  - The advisory text: what has happened, why it matters, what the rig must do
  - Any reference documents or OEM bulletin numbers
  - The bulletin PDF itself, embedded in the record as base64
  - WHICH RIGS it applies to - multi-select from a fixed list, with
    "all rigs" and "clear" shortcuts
  - Whether this revision requires re-acknowledgement (default YES)

Per rig, the record must leave room for the dashboard to fill in later:
  - acknowledged: who, when
  - action closed: who, when, with a comment
  These are NOT filled in by my tool. My tool only issues.

HOW IT MUST BEHAVE

  - Seadrill branding: navy #002C77, gold #EDB71E, Segoe UI, a header bar in
    navy with a gold underline. Match the look of our existing tools.
  - Validation is the point of the form, not decoration. Refuse to post if a
    mandatory field is blank or no rig is selected, and say exactly what is
    missing. Warn but do not block on things that are merely unusual.
  - A "Create AAB file" button that saves the JSON locally, so there is always
    a route that works with no network. The post is the convenience; the file
    is the fallback.
  - A preview of the AAB as the rigs will see it, before I post.
  - It must never lose my work: if a post fails, tell me the HTTP status and
    what the server said, and point me at the local file.

BEFORE YOU WRITE ANY CODE

Ask me questions. This is my first project of this kind and I would rather
answer twenty questions now than rebuild it. In particular ask me about
anything in the list above that is ambiguous, about what should happen in
cases I have not described, and about what "done" looks like.

Then, once you have built it, produce three documents for me:

  1. A HANDOFF FOR THE DASHBOARD TEAM describing the exact record my tool
     posts: every key, its type, what it means, what is optional, and what
     the dashboard must fill in for acknowledgements. They ignore keys they
     do not know, so extra keys are safe, but they need the ones they route
     and display on to be exact and stable.

  2. AN ADVISORY ON WHAT NEEDS UPDATING IN THE AAB DIRECTIVE, given that
     Level 3 advisories will now be issued and tracked through this tool and
     the dashboard rather than through Maximo. Name the sections, the roles
     and the timescales that no longer describe what actually happens.

  3. A DRAFT MANAGEMENT OF CHANGE (MOC) entry for the change of process.

Do not invent Seadrill facts. If you need a rig name, a role title, a
response period or a document number and I have not given it to you, ask.
```

---

## 3. Branding and format

Match the existing tools so the fleet sees one family of pages.

| | |
|---|---|
| Navy | `#002C77` |
| Gold | `#EDB71E` |
| Orange (attention) | `#E25303` |
| Ink | `#0a1530` |
| Muted text | `#5a6880` |
| Borders | `#d0d8e8` |
| Font | `"Segoe UI", Arial, Helvetica, sans-serif` |

Header: navy bar, **3 px gold bottom border**, the tool name in white with a small
gold uppercase eyebrow above it, and a revision tag. Cards: white, 1 px `#d0d8e8`
border, 3 px navy top border, 8 px radius. Keep a **`.noprint`** class on anything
that should not appear on paper.

**Put a revision number in the header** — `Rev 1`, `Rev 2` and so on, bumped on
every delivered version. It sounds trivial. It is the single most useful thing we
did: it is how anyone can tell at a glance whether the copy in front of them is
current.

---

## 4. The rigs

These are the 13 units and the exact spellings. **Use the display name character
for character** — the dashboard attributes records to rigs by that string, and a
mismatch puts an AAB in an "Unattributed" bucket where nobody sees it. That happened
to us and cost a rebuild.

| Display name | Short key |
|---|---|
| West Neptune | `nov` |
| West Auriga | `auriga` |
| West Saturn | `saturn` |
| West Jupiter | `jupiter` |
| West Tellus | `tellus` |
| West Carina | `carina` |
| West Polaris | `polaris` |
| West Vela | `vela` |
| West Gemini | `gemini` |
| West Capella | `capella` |
| Sonangol Libongos | `libongos` |
| Sonangol Quenguela | `quenguela` |
| Sevan Louisiana | `cam` |

Notes: the short keys are historical and a couple are odd — `nov` is West Neptune and
`cam` is Sevan Louisiana. **Carry both** the display name and the key in the record;
the display name is what people read, the key is what systems match on. Hold the list
as a data structure at the top of the file so adding a unit is a one-line edit.

**West Vela has two BOP stacks.** For AABs that is probably irrelevant, but if an
advisory can apply to one stack and not the other, ask Dan before designing for it.

---

## 5. How the posting works

Your tool posts **one JSON record** over HTTPS to a Power Automate endpoint, which
files it where the dashboard scanner picks it up. The body shape is fixed across the
whole estate:

```json
{
  "FileName":    "seadrill-aab_<number>_<rev>_<yyyyMMdd-HHmmss>.json",
  "ContentType": "application/json",
  "FileContent": "<base64 of your AAB JSON>"
}
```

`POST`, one header — `Content-Type: application/json` — and nothing else. The base64
must be UTF-8 safe: `btoa(unescape(encodeURIComponent(json)))`.

**The endpoint URL is not in this document on purpose.** It is signed, and anyone
holding it can post into the estate, so it does not travel in an emailed file. Dan
will give it to you directly. Better still, have your tool read it from an existing
tool at build time rather than typing it in, which is what our request form does —
then the two can never drift apart.

**Three filename rules, learned the hard way:**

- **Make every post unique.** Ours was rig plus date, so re-issuing the same rig on
  the same day **overwrote the first file** — and because the notification triggers on
  file *creation*, an overwrite emailed nobody. Put the AAB number, the revision and a
  timestamp in the name.
- **Keep the prefix stable.** Routing keys on it.
- **Sanitise every component** to `A-Z a-z 0-9 . _ -`. It becomes a SharePoint
  filename, and a stray space or `#` is rejected with an unhelpful error.

---

## 6. The five things that cost us most

Not general advice — five specific mistakes from the precharge tool. Each one is
cheaper to avoid than to find.

**1. One renderer per document.** If two bits of code can produce the bulletin the
rig acts on, they will eventually disagree. Embed the *actual PDF* you issue; do not
also build something that redraws it.

**2. Fail soft on the optional, fail closed on the essential.** A missing attachment
must not stop the AAB posting. A missing rig selection or due date must stop it dead.
Decide which each field is, deliberately.

**3. Report what actually went wrong.** Our first version said only "post failed".
It had the HTTP status and the server's own message in hand and threw them away, and
it cost a day. Show the status, the server text and the filename.

**4. If a check can't do its job, it must say so — not pass.** We had a test that
reported "nothing changed" when it was actually reading the wrong thing, and a suite
that quietly ran a smaller set of checks than it claimed while printing a warning
nobody read. **Check the run, not the note.**

**5. A step that can do damage as a side effect is not a routine step.** A one-line
publish command that also copied a password file reverted the live password and locked
every user out. If a step can change something it is not named after, it needs a
guard.

---

## 7. Open questions — none of these block you starting

Dan or I will settle these. Flag them to Claude so it designs around them rather than
guessing.

1. **The Level 3 response period in the directive.** You set a due date per AAB, but
   there should be a sensible default. Dan is reviewing the directive — until then,
   make the default a configurable constant at the top of the file, not a number
   buried in the code.
2. **Which role acknowledges for a rig** — OIM, Subsea Supervisor, Technical Section
   Leader, or the rig's choice. It affects the wording on the acknowledgement page,
   which is the dashboard team's to build, but your record should name the expected
   role.
3. **The notification matrix** — who gets emailed when an AAB is posted, and who gets
   chased when one goes overdue. Held as a workbook outside the flow so a crew change
   is a cell edit, not a rebuild.
4. **Whether an AAB can be withdrawn** and what that does to acknowledgements.
5. **Whether the dashboard AAB section needs its own acknowledgement page** or sits
   inside an existing one. Dashboard team's call.

---

## 8. What to send back

Three documents, as in the prompt:

1. **The dashboard handoff** — the record shape, exactly. This is the important one:
   it is the contract between your tool and everything downstream, and it should be
   written once and amended, not renegotiated in every email.
2. **The directive advisory** — what in the current AAB directive no longer matches
   reality once Level 3 runs through this tool and the dashboard instead of Maximo.
3. **The draft MOC** for the process change.

Send them to Dan. He will route the dashboard one to the dashboard team and the other
two into the directive review.

---

## 9. One honest caveat about this document

I could not open the AAB directive PDF while writing this — the sandbox lost access to
the file system, which is a known issue with a Windows update from 8 September. So
**everything here about the AAB process comes from Dan's description, not from the
directive itself.** The levels, the roles and the response periods in the directive
may differ from my assumptions, and section 7 item 1 is the place that shows.

Ask Dan to confirm anything in here that reads as though it came from the directive.
Nothing about the tool's construction depends on it.
