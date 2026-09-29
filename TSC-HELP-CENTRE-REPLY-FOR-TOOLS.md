# Reply — the TSC Help Centre and the assistance request: what the dashboard side builds, and your four questions answered

**To:** the reporting-tools session (WCGRRT / SSORT) · **From:** the dashboard session, via Dan
**Date:** 29 September 2026 · **Answers:** `DASHBOARD-TSC-HELP-CENTRE-HANDOFF.md` (29 Sep), which
supersedes the recipient and destination parts of the 26 September failure-notification handoff.
Our 28 September reply stands for everything it did not supersede: the three ways a failed send
surfaces, the three test guards, `occurredAt` as the field to trust.

Understood, and accepted: a request for help that starts a trail, thirty minutes after a failure,
one fixed audience, no tiers, no leadership, Synergi optional. The Help Centre is on the critical
path and is being built now against the shape in your §5; the keys can move under it the way Eric's
did under the AAB pages, because the page reads what the scanner gives it and the scanner ignores
what it does not know.

## 1. What the Help Centre is (your §3, confirmed line by line)

1. **A destination that accepts a post: the same one.** The same intake endpoint every tool posts
   to, the same PostedReports library. Filename prefix **`seadrill-help_`**, `meta.kind: "help"`,
   `meta.reporttype: "TSC Assistance Request"`. The scanner routes on the prefix and the kind, never
   the filename alone. Nothing else in the transport changes.
2. **The email is the mechanism; the Help Centre is the record. Right way round.** The flow mails
   the audience within a minute of the post, with the request in the body and the attachments
   attached; nobody has to open anything to learn a rig needs help. The Help Centre is where the
   request, its delivery receipt, Technical Services' acknowledgement and the trail live, for the
   people who pick it up and for the record afterwards. So what the tool says after a successful
   post is: *"Received by the server. The Technical Services office, the superintendents and your
   rig's four are being emailed now; delivery is confirmed on the TSC Help Centre within ten
   minutes."* Not "sent": the receipt says sent.
3. **A failed send surfaces three ways**, as on 28 September and built the same way here: the
   flow's failure branch emails the office `NOT SENT - ASSISTANCE - <rig> - <subject>` with the
   whole request as text so a human forwards it in one minute; the flow writes a delivery receipt
   file the scanner shows beside the request (**Sent to 9 at 14:02** or **NOT SENT** in red, and
   **No delivery receipt yet** in amber after twenty minutes); and a request with no receipt after
   an hour is on the dashboard's Errors button.
4. **Passworded, and somebody watches it.** Behind the same gate pattern as the AAB compliance page
   and the precharge pages, its own password and its own `gate-config.js`, audience the office and
   the superintendents. Who watches: the Technical Services office in hours; out of hours the email
   is the mechanism and the Help Centre is where the next person in picks the trail up. That is
   Dan's decision to confirm, and the page does not depend on it.

## 2. The audience, and the mapping (your §2)

The flow holds the addresses, in the notification workbook, as everywhere else:

| Audience | Where it comes from |
|---|---|
| The office | the **Office** sheet, as today |
| The superintendents | the **Superintendents** sheet, as today: the distribution list, every superintendent, not the rig's SSS alone |
| Ian Jack, BOP Controls | a new **HelpFixed** sheet (name, email), so a change is a sheet edit and not a flow edit |
| The rig's SSS, TSL, ARM and RM | the **Rigs** sheet row for `meta.asset`, the same four columns the AAB flow reads |

So **"the superintendents" is the distribution list**, and the rig's own SSS is on To through the
Rigs row anyway; nobody is left off by the choice, and a superintendent who is not the rig's still
hears. If Dan wants the rig's SSS only, it is one card fewer. All of them on **To**, none on CC
(Dan's standing rule). Routed on `meta.asset` plus the role, from the payload's asset, never from
the payload's own role fields.

Your §2.1 is noted and changes nothing here: the flow never reads `meta.sss` and the rest for
addressing, only for display in the email body, where an empty value is shown as empty. When
SSORT's seven fields arrive they appear.

## 3. Can the flow create the Teams chat? Yes, and it is two behaviours (your §4)

**Feasible with the standard Microsoft Teams connector, no Graph call and no premium licence.**
Power Automate's Teams connector has **Create a chat** (members as a list of addresses, a topic,
returns the chat id) and **Post message in a chat or channel** (post as the flow bot or as a user
into that chat by id). Both are standard-tier actions, in the Business group of every DLP policy,
and both work in SEADRILL-WC-DEV under the same Teams connection the flows already hold. The chat
appears in every member's Teams as an ordinary group chat with the given name.

So, built into the same flow:

1. **The assistance chat, at the request.** Create a chat named
   `<Rig> – <yyyy-MM-dd> – <subject>` with the office, the superintendents, Ian Jack, BOP Controls
   and the rig's four; post the request as its first message (rig, occurred at, rig down or not,
   hours down, the issue as the crew wrote it, the Synergi case if any, a link to the Help Centre).
   The request is the trail's first entry, retained with the chat. The email still goes: the chat
   is for the people working it, the email is what wakes them.
2. **The directive's chat, at six hours** (DIR-00-0116 §3.5.1.1), only when `rigDown` is true. A
   different membership: Rig Manager and ARM from the Rigs row, the Ops Director, the Director of
   Technical Services and the Downtime Event SME from a new **Downtime** sheet. Not created at the
   request, because a thirty-minute request must not summon directors: an hourly scheduled flow
   reads the Help Centre's open requests, and when `occurredAt` plus six hours has passed and no
   directive chat exists for that request, creates it, posts the request and the assistance chat's
   link as the first message, and records the chat id back in a receipt so it is created once.
   The OIM's obligation is then met by the flow, with the OIM in the chat.

**Retention.** A flow-created chat is an ordinary Teams group chat and falls under the tenant's
Teams chat retention policy, which ISIT set; the flow cannot set retention itself. We add "confirm
Teams chat retention is at least twelve months, or exempt chats named `<Rig> – <date> – <event>`"
to the ISIT list. Until confirmed, the Help Centre's record and the flow's receipt carry the same
content for as long as SharePoint keeps them, which is the record either way.

**The AI agent.** The opening post needs no AI: the flow composes it from the payload, which is
better than a summary because it is the crew's own words. The WCE Reports Assistant can be added
to a group chat once it is published with group-chat scope (it is a Teams app setting, and the
Teams approval ISIT are working on covers it); it would then answer "what has this rig posted
about this equipment" inside the chat from the digests. Worth doing, not a dependency, after the
approval.

## 4. What the tool sends (your §5): read as stated, plus three small asks

Read as you listed it: `meta` (asset, date, saved, rev, reporttype, the role fields), `notifyKind`,
`rigDown`, `hoursDown`, `occurredAt`, `synergiCase`, `subject`, `dryRun`, `attachments`, the
FRM-00-0169 fields. Three asks, all small:

1. **A request id**, `requestId` (a GUID the tool makes at first save), so a re-post of the same
   request, or a later update carrying the Synergi number once it exists, joins the same record
   instead of making a second one. Same rule as the AAB's `recordId`: duplicate id, newest file wins.
2. **`meta.rigkey`** beside `meta.asset`, the same thirteen codes the AAB uses, so the Help Centre
   and the flow join on the code and the display name stays the display name.
3. **`subject` at most 120 characters**, because it goes into a chat name and a subject line.

Filename: `seadrill-help_<rigKey>_<yyyyMMdd-HHmmss>.json`. The Help Centre's own posts (Technical
Services acknowledging, updating, closing) are `seadrill-help-ack_<requestId>_<yyyyMMdd-HHmmss>.json`
with `meta.kind: "help-ack"`, posted from the Help Centre page through the same intake, never
touching your file. The flow's receipts are `help-receipt_<requestId>_<stamp>.json` in the Digests
library, not in PostedReports, so they never trigger anything.

## 5. What is being built here, in order

| | What | State |
|---|---|---|
| 1 | Scanner: read `seadrill-help_*` and `seadrill-help-ack_*` into `helpRequests[]` (state open, acknowledged, closed; rig, occurredAt, hoursDown live-computed for display and labelled as such, rigDown, subject, synergiCase, attachments, receipt); write `help\help-data.js` to the share; list on the Errors button anything unreadable or without a receipt after an hour | **now** |
| 2 | `help/help-centre.html`: passworded, the open requests first, each with its receipt, its trail and an acknowledge / update / close form posting `seadrill-help-ack_*`; the closed ones below; the dashboard gets a Request / Notify line with the count and the link, never the rows | **now** |
| 3 | `TSC-HELP-NOTIFICATIONS-FLOW-GUIDE.md`: click by click for Dan: trigger, the three guards, the audience from the four sheets, the email, the Teams chat, the receipt file, the failure branch; then the hourly flow for the six-hour chat | with 1 and 2 |
| 4 | Test on `SSCE Equipment` with `TestMode = Yes`: post, email to the office, chat created with the office only, receipt on the Help Centre, acknowledge and close from the page | before your Post button ships |

Nothing here touches the BOP Precharge Request, its keys or its flow.

## 6. Back to you

- The three asks in §4.
- Your stage 1 form can already show the four positions and the chat naming convention as a
  prompt, as you say; with §3 built the prompt becomes "a Teams chat has been created for this
  request", which the tool can state only after the receipt says so, so leave the wording to the
  post-success message in §1.2.
