# BOP Equipment Failure / Downtime Notification — build spec

**Status: QUEUED, LAST.** Dan's instruction, 25 Sep: *"this is for last."* Nothing here is
built. This document exists so the requirement survives until we get to it.

**Source documents**
- `BOP Equipment Failure Notification - Petrobras (1).pdf` — the official form, printed
  22/09/2026, document dated **16/06/2026**
- `Re_ FRM - 00-0169 - BOP EQUIPMENT FAILURE.eml` — the thread that asked for it

---

## 1. Where this came from

**João Fábio Gomes de Almeida** (Technical Superintendent, WCE, Latin America South),
22 Sep: the form is already **an official SMS document**, and asked whether it can be
added to SACRED. He also said the **Petrobras name can come off it and it can be used
worldwide**.

**Lee Arnold** (Well Control Equipment Manager, Corporate Technical Service), same day:
*"I would like to discuss further and see how we adapt for more specific information
also"* — and tagged BOP Controls.

**Dan**, 23 Sep, replied committing to: update the form in SACRED, remove the Petrobras
reference so it is for worldwide use, and *"drill it down as we go"*.

**Read that last point before building.** Lee has explicitly asked to expand the field
set, and it has not been discussed yet. The field list in §3 is what the official form
holds **today**; it is a starting point, not a settled specification. Ask before treating
it as final.

---

## 2. What Dan asked for

Three pieces, in his words (25 Sep):

1. *"some form of failure reporting from the rig to submit a request similar to the
   precharge request"* — a rig-raised submission, same shape as the existing BOP
   Precharge Request.
2. *"maybe change that section to request/notify"* — the **Requests** tab becomes
   **Request / Notify**, because it will now carry things that are notifications rather
   than asks.
3. *"a downtime notification section that will automatically email the relevant parties
   when posted"* — posting the form sends the email, rather than a crew remembering to.

Plus: *"we will transpose the form in the attached."*

---

## 3. The form as it stands today

Title: **BOP EQUIPMENT FAILURE**. One page. Form reference **FRM-00-0169**.

A two-way selector at the head, currently two checkboxes:

- ☐ **Rig Down (DT)**
- ☐ **Equipment Failure (non-DT)**

Then the fields, in the order the form gives them:

| # | Field | Note |
|---|---|---|
| 1 | Rig name | comes from `meta.asset` — do not add a second rig field |
| 2 | Date / time of occurrence | |
| 3 | Current hrs. NPT | |
| 4 | Expected duration | |
| 5 | Equipment affected (Manufacturer / Model) | |
| 6 | Description of event (Operation at time of event) | |
| 7 | Immediate action(s) to correct downtime event(s) | |
| 8 | Cause(s) identified | |
| 9 | Solution identified, or troubleshooting continuing | |
| 10 | OEM tracking ticket # | |
| 11 | Remote diagnostics available? | |
| 12 | Parts identified — onboard or require sourcing? | |
| 13 | Tools identified — onboard or require sourcing | |
| 14 | Additional resource requirements | |
| 15 | Conference call required — YES ☐ / NO ☐ | the form adds: *"If a conference call is required, set up a Teams meeting with relevant personnel."* |

**Footer instruction on the form, verbatim:**

> Email this notification to: technicalservices@seadrill.com, bopcontrols@seadrill.com,
> ronnie.peeples@seadrill.com, lee.arnold@seadrill.com
>
> Subject line of email to include "RIG DOWN" or "BOP EQUIPMENT FAILURE", "RIG NAME",
> "SUBJECT"

That footer is the whole of the automation requirement, written down by the form itself.

---

## 4. What to think about before building

### 4.1 The distribution list is hard-coded on a form, and will rot

Four addresses, two of them **named individuals** (Ronnie Peeples, Lee Arnold). People
change roles. If those are baked into the tool, the tool is wrong the day someone moves,
and a rig-down notification goes to a mailbox nobody reads.

This is the same problem the precharge recipient list has, and SSORT already solves it
once — `loadCbmRecipient()` and `recipientDetailsHTML()`. Reuse that pattern: the
addresses are **data a superintendent can edit**, with the form's four as the default,
not constants in the source. Worth putting to Lee at the same discussion as §1.

### 4.2 The auto-email is the dashboard side's, and what we owe is the handoff

**Dan, 25 Sep: the email flow is done by the dashboard tool.** So this is not ours to
build or prove, and the Post-to-OEM sequencing problem (entries 31 and 33) does not
apply here.

What we owe instead is a **handoff good enough to build a flow against without coming
back to ask**, written into `DASHBOARD-ROLLING-HANDOFF.md` before it ships, as an entry
in its own right. At minimum it has to carry:

- the `reporttype` value that identifies a failure notification, and how **Rig Down (DT)**
  is distinguished from **Equipment Failure (non-DT)** in the payload — they are the same
  form but not the same urgency, and the flow will want to treat them differently
- every field key, lower case, with its type and whether it can be absent
- the **subject line convention**, which the form itself specifies: `"RIG DOWN"` or
  `"BOP EQUIPMENT FAILURE"`, then rig name, then subject
- the four default recipients, and — see §4.1 — the fact that the list is **editable data
  in the payload, not a constant**, so the flow must read it rather than hold its own copy
- the conference-call flag, since it changes what the recipient has to do next
- worked example payloads: one DT, one non-DT

Sequence: agree the field set with Lee and João **first** (§4.5), because every one of
those field keys is in the handoff and each change after the flow is built costs the
dashboard side a rebuild.

### 4.3 "Rig Down" is the highest-urgency thing either tool will ever send

Everything else in SSORT is a record made after the fact. This one is a live alarm: a rig
is down, now, and four people need to know. That changes what "posted" has to mean.

- A silent failure is not acceptable. If the post does not reach the endpoint, the crew
  must be told **on screen**, in terms that make clear the notification has NOT gone, and
  given the fallback (send the email themselves — so the form must be copyable as text
  without the flow).
- `res.ok` is already checked on the posting path. Whatever this does must not weaken
  that, and must not introduce `mode:'no-cors'`, which would make a failed send look
  identical to a successful one.

### 4.4 De-branding

Both João and Dan have said the Petrobras reference comes off and the form goes
worldwide. Nothing Petrobras-specific should be carried across. The form's own content is
already generic — the branding is in the file name and the header, not in the fields.

### 4.5 Open questions to settle before any code

1. What are Lee's *"more specific information"* fields? Not yet discussed.
2. Is this one form with a Rig Down / non-DT toggle, or two entries under Request /
   Notify? The form uses one toggle, so one form is the faithful transpose — but the
   distribution and urgency differ between them, and that may warrant splitting.
3. Does the notification post through the existing endpoint (so the dashboard indexes it
   like everything else), or is it email-only? If it posts, it needs a `reporttype` and
   an announcement in `DASHBOARD-ROLLING-HANDOFF.md` **before** it ships, like every
   other new key.
4. Renaming the **Requests** tab to **Request / Notify** — is the tab label load-bearing
   anywhere on the dashboard side, or in the guides and PowerPoints already issued to the
   rigs (`GUIDE - Raising a BOP Precharge Request (for rigs).pdf`, the SSORT user guide
   decks)? Check before renaming, and reissue what needs reissuing.

---

## 5. What is NOT in scope from this

Dan's standing instruction, unchanged: **the precharge request itself is not to be
touched.** Adding a sibling entry beside it under a renamed tab is not the same as
changing it, but the precharge form, its keys and its flow stay exactly as they are.
