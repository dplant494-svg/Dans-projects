# Handoff to the dashboard session — TSC Help Center and the assistance request

**From:** the reporting-tools session (WCGRRT / SSORT)
**Date:** 29 September 2026
**Supersedes:** the recipient and destination parts of `DASHBOARD-FAILURE-NOTIFICATION-HANDOFF.md` (26 Sep)

**You are now on the critical path.** The tool cannot post to something that does not exist,
so the Help Center gates stages 2 and 3 of our build. Stage 1 — the form itself, with no
Post button — proceeds in parallel and needs nothing from you.

**It goes in both tools** (Dan, 29 Sep): SSORT and WCGRRT.

---

## 1. What changed since the 26 September handoff

Dan, 29 September. Three things, and they simplify this considerably:

| Was assumed | Actually |
|---|---|
| A downtime notification with hours-banded escalation tiers | **A request for help that starts a trail.** Not a downtime report, not the Synergi first notification, and not a replacement for either |
| Posts to the dashboard as a new `reporttype` | **Posts to the TSC Help Center** — a separate, passworded area. Not `reports[]`, not the rig list, not the heatmap |
| Escalates to leadership as hours grow | **One fixed audience. No tiers, no escalation, no leadership** |
| The Synergi case number joins the records | **Optional.** The request can be raised 30 minutes after a failure; Synergi typically does not exist until the six-hour mark |

**The 30-minute case is the reason this exists.** A rig that needs help early has nowhere to
go today. Anything that pushes the form back toward six hours — a mandatory Synergi number,
a heavy approval, a slow destination — destroys the point of it.

## 2. The audience, and the mapping is yours

| | |
|---|---|
| **Fixed** | the office · the superintendents · `Ian.Jack@seadrill.com` · `BOPcontrols@seadrill.com` |
| **Per rig** | the **SSS**, **TSL**, **ARM** and **RM** for that specific rig |

**Dan, 29 Sep: the dashboard maps the addresses in the Power Automate flow.** Agreed, and it
is the right side for it — a crew change becomes an edit where you already keep the Rigs,
Office and NOV sheets, and no address is ever typed on a rig where a typo would silently
lose the notification.

Route on **`meta.asset` plus the role**, as everywhere else.

**One thing to settle:** *"the superintendents"* — a distribution list, or the named SSS for
that rig? They are different sets.

### 2.1 A defect this question uncovered, which you should know about

We were about to tell you the tools already send you those four names to cross-check your
roster against. **That is true of WCGRRT and false of SSORT**, and we found it checking
rather than asserting.

| key | WCGRRT 166 | SSORT 150 |
|---|---|---|
| `meta.sss` | field present | **field present** |
| `meta.tech` | field present | **field present** |
| `meta.tsl` | field present | **read by the payload builder, no field on screen** |
| `meta.rigmgr` | field present | **same** |
| `meta.arigmgr` | field present | **same** |
| `meta.oim` | field present | **same** |
| `meta.wce` | field present | **same** |
| `meta.elec` | field present | **same** |
| `meta.dsl` | field present | **same** |

SSORT's payload builder calls `getElementById('meta-tsl')` and six others on elements that
do not exist in SSORT. `null?.value` is `undefined`, so **those seven keys have posted empty
from SSORT for as long as they have existed**, with no error anywhere and nothing on your
side to notice — an absent key is indistinguishable from a field a crew left blank.

`meta.wce` is among them, so **every SSORT CBM-to-OEM copy has carried an empty `wce`** too.

**Nothing for you to do**, and no data is wrong — it is absent, not incorrect. It is here
because it changes what you can rely on: from SSORT, only `sss` and `tech` are real today.
We will add the missing fields to SSORT in the revision that carries this form, since the
form needs them anyway, and announce it then.

## 3. The Help Center — what we need it to be

It does not exist yet (Dan, 29 Sep: "will be built"), so this is the moment to say what the
tool assumes:

1. **A destination that accepts a post.** Same transport as everything else. We change the
   filename prefix and a `reporttype`; you route on it.
2. **The email is the mechanism; the Help Center is the record.** A help request that lands
   somewhere four people must remember to open is slower than an email. If that is the wrong
   way round, tell us now, because it decides what the tool says after a successful post.
3. **A failed send must surface.** Your three answers from the 28 September reply still
   apply — the failure-branch email, the receipt file, the Errors pill — and they matter
   more here, not less: the whole point is that somebody is waiting for help.
4. **Passworded, and somebody watches it.** Worth deciding who, and what happens out of
   hours.

## 4. Dan's question — can the flow create the Teams chat?

> *"Ask the dashboard if we can automatically create a Teams chat from the email request
> with the participants in the email trail. We have an AI agent in Teams, this may be able
> to assist us."*

This is worth real thought, because **DIR-00-0116 §3.5.1.1 already mandates one** for any
downtime event over six hours:

> The OIM or his designated SHALL create a Teams chat with the following:
> naming convention **Rig Name – Date – Event Name**; add Rig Manager / ARM, Ops Director,
> Director of Technical Services, Downtime Event SME. Retained 12 months.

So the chat is not a nice-to-have someone might want — it is a directive obligation created
by hand today, at the worst possible moment, by the person with the most to do.

**What we would ask you to look at:**

- Can the flow create a Teams chat with a given membership and name it
  `⟨rig⟩ – ⟨date⟩ – ⟨event⟩`, from the payload? Graph has `POST /chats`; whether your flow's
  connection can use it in your tenant is the real question.
- **Two different memberships.** The assistance request reaches the office, BOP Controls, Ian
  Jack and the rig's four. The directive's six-hour chat is Rig Manager / ARM, Ops Director,
  Director of Technical Services and the Downtime SME. Overlapping, not the same — so it is
  probably two behaviours, not one: a chat for the help request, and the directive's chat
  when `hoursDown` crosses six.
- **The trail.** If the chat is created from the request, the request is its first message
  and the whole thing is retained together. That is exactly the "start the trail" Dan
  described, and it is better than an email thread nobody can find in a month.
- **The retention requirement is 12 months** — worth confirming a flow-created chat meets it.
- **The AI agent in Teams.** If it can summarise the request into the chat's opening post,
  that saves the OIM writing it out at hour six. Worth a look; not a dependency.

If the answer is no, the tool can still put the naming convention and the four positions on
screen as a prompt — that is in our stage 1 either way. If the answer is yes, a directive
obligation stops depending on somebody remembering.

## 5. What the tool will send

Not final — Lee Arnold's field expansion is still outstanding — but the shape is stable:

```
meta            asset, date, saved, rev, reporttype, sss, tsl, rigmgr, arigmgr, oim, wce
notifyKind      "assistance" | "mandatory"      derived, recorded, never recomputed
rigDown         bool
hoursDown       number
occurredAt      ISO datetime, required, defaults to now, editable
synergiCase     string, OPTIONAL and often empty
subject         the issue, as the crew wrote it
dryRun          bool
attachments     photographs, PDFs and trends, the existing path and ceilings
<the FRM-00-0169 fields>
```

**The subject line** is built from the payload, never retyped: the issue, the rig, and the
mode. `[TEST MODE]` in front under any of the three guards.

**`occurredAt` is the field to trust**, not `hoursDown`. Hours-down is stale the moment it is
typed; every deadline in DIR-00-0116 is measured from the start of the event.

Full keys will be announced in `DASHBOARD-ROLLING-HANDOFF.md` before anything ships, with
worked examples for both modes, as always.

## 6. The guards, unchanged

Three, any one of which stops an email: `meta.asset === "SSCE Equipment"` routes to the
office only, a `dryRun` field does the same on a real rig name, and the workbook's TestMode
switch covers the flow. All three proven before the first live send.

Less critical than it was — this no longer reaches leadership — but the Post to OEM lesson
stands: **that button shipped ahead of its flow and has been held ever since.** It is live
on every rig today and would email NOV a one-byte file. This one ships after the guard is
proven, not before.

## 7. Sequencing

| | Who | When |
|---|---|---|
| The form, no Post button, **both tools** | us | **now** — needs nothing from you |
| The seven missing SSORT role fields | us | same revision |
| Lee's field expansion | Dan / Lee | the long pole |
| **TSC Help Center** | **you** | **gates our stages 2 and 3** |
| Address mapping in the flow | you | with the Help Center |
| Teams chat creation — feasible? | you | §4, answer either way |
| The payload and the keys | us | after Lee's fields |
| The Post button | us | after your guard is proven |

Nothing here touches the BOP Precharge Request, its keys or its flow.
