# The notification loop — design of the pattern, from the first one built

**From:** the dashboard / scanner session, which built the Precharge Notifications flow
with Dan on 11 September 2026 and hit its edges live
**For:** the reporting-tools session (page 6 of the production pack), the Precharge Pro
session (design principles alongside), IT reviewers, and whoever builds loops two to five
**Companion:** `NOTIFICATION-PRECHARGE-FLOW-GUIDE.md` is the click path. This is the
design: what the loop is, why each part is where it is, what it keys on, how it fails,
and what I would do differently now that one is in service.

---

## 1. What a loop is, in one paragraph

A tool posts a file. The file lands in one SharePoint library. A flow wakes on the new
file, reads it, decides what kind of event it is from the file's own `meta`, looks up
who should hear about it in a workbook, and sends one email per branch with a link back
to the dashboard and, where the file carries one, a copy the recipient can open. The
scanner is not in the loop and does not need to be: the flow reads the same posted file
the scanner reads, at the same moment, from the same place. **The file is the event.**

That is the whole pattern. Everything below is consequences.

## 2. The shape, as built

```
tool POSTs JSON ─► Power Automate HTTP trigger ─► SharePoint WellControl/PostedReports
                                                          │
                              (scanner reads it, 10-min task, unchanged)
                                                          │
                     flow: "When a file is created" in PostedReports
                            │  filename contains the loop's key word
                            ▼
                     Parse JSON (the posted file)
                            │
                     Kind ◄── meta.source / meta.tool        (what happened)
                     RigKey ◄── meta.rigKey, fallback config (where)
                     Well, Rig name ◄── meta                 (for the subject line)
                            │
                     Office list ◄── workbook table "Office"          (always)
                     Rig row    ◄── workbook table "Rigs" WHERE RigKey (per rig)
                            │
              ┌─────────────┼───────────────────┐
           REQUEST        ISSUED            ISSUED, no rig contact
           → Office     → rig contacts,     → Office, subject says
                          CC Office           NO RIG CONTACT
                          + JSON attached
                          + sheetHtml attached
```

Three branches, never zero: **a posted file always produces exactly one email**, and the
"no rig contact" branch exists so a lookup miss is a message to the office, not silence.

## 3. The decisions, and why

### 3.1 Recipients live in a workbook, not in the flow

Two tables in one `.xlsx` in `PostedReports/Notifications`: **Office** (name, email —
the people who always hear) and **Rigs** (vessel, rigKey, supervisor name, supervisor
email, TSL email — one row per rig). The flow reads them on every run.

Why:

- **Crew changes are a cell edit.** A new Subsea Supervisor on West Vela is one cell,
  by anyone with the workbook, in under a minute. Editing a flow is a designer session,
  a save, and a re-test, by one of two people who know how.
- **The list is auditable.** Who was on it, when, is the workbook's version history.
  Flow history shows what was sent, not what the list was.
- **The same workbook serves every loop.** Loop two adds a table, or a column, not a
  flow.
- **It survives handover.** ISIT can maintain a flow that reads a table. They should not
  have to maintain a flow with addresses inside it.

The cost: the workbook must be closed and synced when the flow runs (an open workbook
fails the read, a half-synced one is read stale), and the Excel connector's filter is
primitive (§5.2). Both are manageable; neither is worth giving up the table for.

### 3.2 Kind is read from `meta`, never from the filename

A request carries `meta.source` starting `BOP Precharge Request form`; an issued sheet
does not. That is the branch. The filename is used for exactly one thing, the trigger's
cheap pre-filter (`contains 'precharge'`), because the trigger fires on every file in
the library and the flow should exit in milliseconds on the 95% that are not its
business. **Filenames are not load-bearing** anywhere else, which is the same rule the
scanner keeps, and for the same reason: filenames are chosen by the tool and change
between revisions (they did, in Rev 80).

### 3.3 The rig is joined on `rigKey`, and `rigKey` is the tool's key

`meta.rigKey` (issued sheets) with fallback to top-level `config` (requests), exactly as
the scanner resolves it. The Rigs table carries the same short key (`vela`,
`libongos`). Joining on the display name would have worked until the first "West Vela"
vs "WEST VELA" and then silently sent nothing. `meta.asset` is still what is *printed*
in the email; it is the rig identity contract, but it is prose, and the join needs a
key.

### 3.4 Every email carries a link back, and the issued one carries a copy

The link is to the dashboard (`dashboard.html?report=<file>`) or the tool. The copy is
the posted JSON plus, since Rev 80, `sheetHtml`, a self-contained printable sheet the
tool renders **from the same DOM the user saw**, so the emailed sheet cannot disagree
with the screen. It has a footer naming the PDF as the controlled document and telling
the reader to stop and query if the two disagree. **The flow attaches it unchanged.** A
flow that edited a controlled artefact would be a third renderer.

### 3.5 Loop membership is decided by the tool, by posting; the flow decides only who hears

The flow has no notion of state. It does not know whether a request is open, issued,
or superseded; the scanner and the calculator own that. It knows only "a file of kind X
for rig Y just arrived". That keeps the flow small enough for a non-technical owner to
reason about, and it means the flow can never contradict the dashboard.

## 4. What the trigger actually keys on, because it matters

**"When a file is created" fires once, on creation, and never on modification.** If a
tool re-posts under the same filename, SharePoint overwrites the file and the flow does
not fire. This is not a bug in the flow; it is what "created" means. Consequences:

- **A loop needs the tool to post unique filenames per event.** Precharge Pro did not
  (rig + date only) until Rev 80 (rig + well + stack + timestamp). Loop builders: check
  this before anything else, because every other test will pass and the second post of
  the day will vanish.
- The trigger is a **poll**, not a push. It checks the library on an interval, in
  practice one to fifteen minutes. Do not test with a stopwatch.
- The trigger in service is the **deprecated** SharePoint "When a file is created"
  (content included). It has no filename token in the designer; the name is read from
  `triggerOutputs()?['headers']?['x-ms-file-name']`. The replacement, "When a file is
  created (properties only)" plus a "Get file content" step, is the right build for
  loops two onward and the planned swap for loop one.

## 5. Failure modes, in the order they were met

### 5.1 The Excel filter accepts one clause

`RigKey eq 'vela' or Vessel eq 'West Vela'` fails with *"Only single 'eq', 'ne',
'contains', 'startswith' or 'endswith' is currently supported"*. One clause, one column.
Design the table so one column is the key.

### 5.2 A stray character in the filter matches nothing, silently

`RigKey eq 'vela '` (trailing space, left by the designer's token editor) returns an
empty set, not an error. The flow then correctly went to NO RIG CONTACT. Diagnosis took
four runs. **Build the filter as one expression** so there is nothing to hand-type:

```
concat('RigKey eq ''', trim(outputs('RigKey')), '''')
```

### 5.3 The workbook was still syncing

The edit was made in the OneDrive-synced copy; the flow read the SharePoint copy before
the upload finished. The Explorer status icon tells you. Edit the workbook in the browser
from the SharePoint site when testing, and always close it.

### 5.4 Renaming an action breaks every expression that names it

`outputs('RigKey')` stops working if the card is renamed. Name the cards **before**
writing the expressions that reference them, and then never rename. Email cards can be
renamed freely because nothing references them.

### 5.5 An external or personal address

Delivery to two personal addresses worked first time. It is Exchange policy, not the
flow, that decides that, and it can be withdrawn by policy at any time without the flow
seeing an error. **The flow cannot tell a bad address from a good one.** A typo in the
Rigs table sends the mail into the void with a green tick. The only defence is the
office CC on every rig-bound mail: someone who always receives it will notice the rig
did not.

### 5.6 Sender identity

Every mail is sent from the connection of the person who built the flow, from their
mailbox. IT's 27 August plan (step 5) requires a standard identity. That is a connection
swap in the email actions once IT provide a service mailbox; nothing else changes. Until
then the builder's mailbox is a single point of failure for every loop.

### 5.7 Attachments

The Outlook connector wants base64 for content. The posted JSON attaches straight from
the trigger's file content. A text field such as `sheetHtml` needs
`base64(...)`, and an **empty attachment fails the send**, so the flow substitutes a
one-line HTML note when the field is absent rather than attaching nothing.

### 5.8 Run history is 28 days

The flow's run history is the only record of what was sent, and it expires. For a loop
whose sends are evidence (a precharge was issued to a rig on a date), that is not
enough. See §7, item 5.

## 6. Bringing up loop two: the checklist

For SSCE release, daily-log, CoC expiry and R53, in order of what to settle first:

1. **Does the tool post a unique filename per event?** If not, stop and get that fixed.
2. **What in `meta` says what kind of event it is?** Name the field and the value. If
   the answer is "the filename", go back to the tool.
3. **What is the key that joins to a recipient row?** `rigKey` for anything rig-bound.
   For office-only loops there is no join; the Office table is the whole list.
4. **What is the "nobody to tell" branch?** There must be one, and it goes to the
   office with a subject line that says so.
5. **What does the recipient open?** A dashboard link at minimum. A copy only if the
   tool renders one itself; the flow never renders.
6. **Add a table or a column to the existing workbook; do not create a second
   workbook.**
7. **Build with the properties-only trigger** from the start.
8. **Test with a personal address in the table, then put the real one back.** Both
   steps.

## 7. What I would do differently, now that one is in service

1. **Properties-only trigger from the first minute.** The deprecated trigger cost an
   evening of "why is the filename token missing".
2. **Name every action first, then write expressions.** See 5.4.
3. **One expression per filter, no hand-typed quotes.** See 5.2.
4. **Turn on the flow's own failure notification** (Power Automate emails the owner on a
   failed run) the day it is built, so a red run is not discovered from a missing email.
5. **Write a sent-log.** One row per send into a SharePoint list or a third workbook
   table: file, kind, rig, recipients, timestamp. It is one extra action, it outlives
   the 28-day history, and "was the rig told, and when" becomes a lookup rather than an
   archaeology. This is the notifications outbox the LOVABLE handoff asked for, and the
   flow is the right place to write it because the flow is the thing that sent.
6. **Put the sentinel in the table.** A rig with no supervisor should have the word
   `NONE` in the cell, not a blank, so "not filled in yet" and "deliberately nobody" are
   different things on the sheet.
7. **Keep the flow this small.** Eleven actions, three emails. Every time the logic
   wanted to grow, the right answer was a column in the workbook or a field in `meta`.

## 8. Standing rules this pattern inherits

Transport is not modified: the loop reads what the HTTP trigger already writes.
Filenames are not load-bearing beyond the trigger's pre-filter. `meta.asset` is the rig
identity in prose; `meta.rigKey` is the join. The flow renders nothing and edits
nothing it attaches. The scanner and the tools do not know the flow exists, and do not
need to.
