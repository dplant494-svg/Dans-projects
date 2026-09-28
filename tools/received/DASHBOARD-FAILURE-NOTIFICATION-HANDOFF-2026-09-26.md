# Handoff to the dashboard session — BOP Equipment Failure / Downtime Notification

**From:** the reporting-tools session (WCGRRT / SSORT)
**Raised:** 26 September 2026
**Status:** **PRE-PLANNING.** Nothing is built. This is the brief so you can think about your
half before we design ours, because **the email is yours, not ours**.

---

## 1. What is coming

Seadrill is putting the **BOP Equipment Failure** form — already an official SMS document,
**FRM-00-0169** — into the reporting tool so a rig can raise it directly rather than filling
a Word form and emailing it by hand.

Two things come with it:

1. The **Requests** tab becomes **Request / Notify**, because it will now carry things that
   are notifications rather than asks.
2. Posting a notification **sends an email automatically**. Dan has confirmed that flow is
   yours.

The form is one page and carries a **Rig Down (DT) / Equipment Failure (non-DT)** toggle and
fifteen fields. The Petrobras branding comes off — João Almeida and Dan have both confirmed
it goes worldwide.

---

## 2. What the form itself already specifies

The footer of FRM-00-0169 is the automation requirement, written down by the form:

> Email this notification to: technicalservices@seadrill.com, bopcontrols@seadrill.com,
> ronnie.peeples@seadrill.com, lee.arnold@seadrill.com
>
> Subject line of email to include "RIG DOWN" or "BOP EQUIPMENT FAILURE", "RIG NAME",
> "SUBJECT"

Two observations on that, before it gets hard-coded anywhere:

**The distribution list will rot.** Two of the four are named individuals. Baked into a
flow, it is wrong the day someone changes role — and a rig-down notice goes to a mailbox
nobody reads. We intend to carry the recipients **as data in the payload**, defaulting to
those four, editable by a superintendent. **Please read them from the payload rather than
holding your own copy.**

**The subject convention is load-bearing.** People filter on it. It should be built from the
payload, not retyped.

---

## 3. Why this one is different from everything else we send you

Every other thing the tools post is a **record made after the fact** — a report of work
done. This one is a **live alarm**: a rig is down, now, and four people need to know within
minutes.

That changes what "posted" has to mean, on both sides:

- **A silent failure is not acceptable.** If the post does not reach the endpoint, the crew
  must be told on screen, in terms that make clear the notification has **not** gone, with a
  fallback (the form must be copyable as text so they can send it themselves).
- On your side, the same: if the flow cannot send, that needs to surface somewhere a human
  will look. A notification that fails quietly is worse than one that was never built,
  because the rig believes it has been raised.
- **`res.ok` is already checked on our posting path and will stay checked.** We will not
  introduce `mode:'no-cors'`, which would make a failed send indistinguishable from a
  successful one.

---

## 4. Answered by Dan, 26 September

| # | Question | Answer |
|---|---|---|
| 1 | Recipient list from the payload? | **Yes, and it is not one list.** It is driven by a **downtime notification directive** that escalates on **how long the rig has been down**. Dan is getting the current list from the downtime reporting group. **It includes senior people.** |
| 2 | How should a send failure surface? | **Still open.** See §4.2 — this is the one we still need. |
| 3 | New `reporttype` or separate endpoint? | **Same post link, new form.** Same endpoint you already receive, a new `reporttype`. |
| 4 | Rig Down separated at transport level? | **No.** One form, with a **Rig Down button** and an **hours-down** value. Those two drive who gets notified. |
| 5 | Attachment path? | **Yes — same as everything else.** Photographs, trends, the usual. |

### 4.1 The escalation directive is now the critical input

Answer 1 changes the shape of this. The four addresses on the form are not the
distribution — they are **one rung of it**. The real rule is a directive that escalates as
downtime grows, and the payload has to carry enough for your flow to apply it: at minimum
the **rig-down flag**, the **hours down**, and the **time of occurrence**.

Nothing can be designed properly until that directive is in hand. Neither side should guess
at the tiers.

### 4.2 The one thing still open — and it matters more now, not less

**How does a failed send surface?** When we asked, this was already the most important
question, because a rig-down notification that fails quietly is worse than one that was
never built — the rig believes it has been raised and stops chasing.

Answer 1 makes it sharper. If the distribution escalates to senior people as downtime
grows, then a silent failure at the wrong tier means the people who most needed to know
never heard, and nobody finds out until someone asks why nothing happened.

### 4.3 ⚠ TESTING — read this before the flow is switched on

**The distribution includes senior people.** That turns a routine test into an outgoing
email to the leadership of the company.

The standing rule on the tools side has always been *nothing is posted from a test* — Dan
posts, on a real rig name, when he says so. That rule was about data integrity. **It is now
about not emailing executives by accident.**

So the trigger cannot simply be *"a post of this type arrived"*. Something has to stand
between a post and an email. Options, for the planning session:

- **The flow ignores `meta.asset === "SSCE Equipment"`.** That value was added to SSORT in
  REV 148 precisely as the test asset (rolling handoff entry 38.1). It is the cheapest
  guard and it costs nothing to honour.
- **A dry-run field in the payload** that routes the email to a single test mailbox
  regardless of tier.
- **Both**, which is what we would recommend. A guard that depends on one field being right
  is a guard that fails the first time that field is wrong.

Whatever is chosen, **it should be built and proven before the first live send**, not
retrofitted. The Post to OEM button is the cautionary tale here: it shipped ahead of its
flow and has been held ever since.

## 5. What we will send you, once the fields are agreed

We will announce the full key list as a numbered entry in
`DASHBOARD-ROLLING-HANDOFF.md` **before it ships**, as with every other key — lower case,
additive, with worked example payloads for both the DT and non-DT cases.

**We are not sending that list yet, deliberately.** Lee Arnold has asked to expand the
field set beyond what FRM-00-0169 currently holds, and that conversation has not happened.
Every one of those field keys ends up in your flow, and each change after the flow is built
costs you a rebuild. Better you get one list, late, than three lists, early.

---

## 6. What is NOT changing

The **BOP Precharge Request** is untouched. It keeps its form, its keys and its flow. A
sibling entry appearing beside it under a renamed tab is not a change to it.

---

## 7. Source documents

- `BOP Equipment Failure Notification - Petrobras (1).pdf` — the form, dated 16/06/2026
- `Re_ FRM - 00-0169 - BOP EQUIPMENT FAILURE.eml` — the thread (João Almeida, Lee Arnold, Dan Plant, 22–23 Sep)
- `FAILURE-NOTIFICATION-BUILD-SPEC.md` — our side's working spec, including the full field list as it stands today and the open questions
