## Entry 60 — The Technical Assistance Request is built (SSORT 161), against your live flow. The keys, and eight questions before it goes live

**Rev: SSORT 161, built and tested 11 October; NOT deployed.** sha256
`69477019fbe5375ad86a94dfbf361b844b51c7dc8964234743349902a669ad7f`, 6,929,498 bytes. Status: **NEEDS ACTION**
— answer 60.4 before Dan deploys; 60.5 is the end-to-end test Dan runs.

**Dan, 11 October:** *"build it before the 15th, ask the dashboard what you need, this goes into ssort as a drop down
in requests, technical assistance request next to precharge requests. forget about the 15th we are plowing"* — and
*"we have also built the flow since then so you will need more info surely before its fully built and deployed"*.

**SSORT only, by Dan's instruction.** WCGRRT has no Requests tab and gets nothing in this revision.

### 60.1 — Where the crew finds it (your question 1)

**SSORT → 📨 Requests tab → Request Type → *Technical Assistance Request*.** It sits in the same dropdown as the BOP
Precharge Request. The rig is the one picked at the top of the tab.

- **Reachable with no report open.** The Requests tab needs no tiles, no trip and no posted report. That covers
  the 30-minute case.
- The ❓ Help / Feedback tab is still the tool-feedback email (entry 59.1) and is not this.

### 60.2 — What the crew sees

- **Mode**: RIG DOWN (DT) or BOP EQUIPMENT FAILURE (non-DT).
- **Required**: subject, date and time of occurrence, description of the event, and who is raising it.
  - The subject is capped at 120 characters, with a counter.
  - The occurrence time is shown in UTC beside the local time it was entered in.
  - Who is raising it defaults to the Vessel Information SSS.
- **The FRM-00-0169 fields** as on the form: expected duration, equipment affected, immediate actions, causes,
  solution or troubleshooting, OEM ticket, remote diagnostics, parts, tools, additional resources, conference call.
  Also contact on board. Synergi case is optional.
- **Current hrs NPT** is worked out from the occurrence time and can be typed over. It is rig down only.
- **The DIR-00-0116 checklist**, live from the occurrence time, showing only what applies:
  - always: the Synergi case due 07:00 local the next day (shown as a clock time), and the OEM ticket;
  - over 2 hrs: ATT-00-0028-ENG;
  - 6 hrs or more: the Flash Alert due at occurrence + 12 hrs, and the note that the flow creates the directive
    chat;
  - over 24 hrs: the recovery plan.

  It says **MANDATORY NOTIFICATION** at 6 hrs or more, rig down.
- **Photographs and documents**, through SSORT's existing CBM attachment reader, unchanged:
  - the same whitelist (nothing executable) and the same 8 MB warning / 20 MB refusal per file;
  - photographs compressed to 1600 px, JPEG 0.82.
- **Practice send**: a box that sets `dryRun`, office only, for the class. `SSCE Equipment` is also flagged on
  the form as office-only.
- **Send**:
  1. Validates the required fields.
  2. Shows a confirm naming who will be emailed.
  3. Posts through the unchanged `sdPostReport`.
  4. On success it shows your §1.2 wording verbatim (*"Received by the server. … within ten minutes."*), never
     "sent", and **locks**.
  5. On failure it says plainly **NOT received — nobody has been emailed**, saves the request as a file, and
     tells the crew to email it to technicalservices@seadrill.com and phone the office. Send stays available
     for a retry.
- **The draft survives a crash or reload**, including the `requestId`, so a retry joins the same record.

### 60.3 — The payload: announced here before it ships

Filename `seadrill-help_<rigkey>_<yyyyMMdd-HHmmss>.json`, the stamp in UTC. It goes to the same intake as every
report, through `sdPostReport` unchanged.

```
meta          kind "help", reporttype "TSC Assistance Request", tool "SSORT", asset, rigkey, date, saved (ISO),
              rev "SSORT REV 161", sss (= Raised by), tsl "", rigmgr "", arigmgr "", form "FRM-00-0169"
requestId     crypto.randomUUID(), made once per request, kept in the draft
notifyKind    "mandatory" when rig down and >= 6 hrs since occurredAt at send, else "assistance"
rigDown       boolean
hoursDown     number: the crew's figure, or computed from occurredAt; 0 when not rig down
occurredAt    ISO UTC
synergiCase   string, often ""
subject       string, <= 120
description   the crew's description, then a blank line, "FRM-00-0169", and one "Label: value" line per
              answered field. YOUR EMAIL CARRIES ONLY description, so this is how the form reaches the inbox
dryRun        boolean (the Practice send box)
attachments[] {name, type, bytes, data}   data = BARE base64, so your blobUrl/atob and base64ToBinary both read it
photos[]      {name, type, caption "", data}   data = data URI (image/jpeg after compression)
expectedDuration, equipmentAffected, immediateActions, causesIdentified, solutionStatus, oemTicket,
remoteDiagnostics, partsRequired, toolsRequired, additionalResources, conferenceCall, raisedBy, contactOnBoard
              top-level strings, always present, "" when unanswered: your fields{} capture
fieldLabels   {key: "the FRM-00-0169 wording"} for the 13 keys above (an object, so not in fields{})
```

**Rig keys** come from the live `help-data.js` `rigCodes` (11 Oct): `nov` West Neptune, `cam` Sevan Louisiana, the
eleven by name, and `ssce` SSCE Equipment. **West Phoenix is not in your list** (see 60.4.4).

**Verified on 161** (`fetch` and `sdPostReport` stubbed, nothing posted, test data cleared):

- the payload validates against your flow's Parse JSON schema, every key and type;
- the PDF's bare base64 decodes to `%PDF`; the photo is a JPEG data URI;
- seven hours down gives `mandatory`, 45 minutes gives `assistance`;
- an `.exe` is refused;
- an empty send lists what is missing and posts nothing;
- the failure path saves the file and keeps the `requestId`;
- a reload restores the draft;
- the precharge request still opens.

Build checks: every script block parses and there are no duplicate declarations. Byte-identical: **the precharge
panel and its script** (25,559 characters), `reqSetType`, `reqSetRig`, `reqSyncRig`, `reqApplyRigToPanel`,
`sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportFileName`, `sdPostDiscriminator`, `sdReadAttachment` and
`sdSizeOk`. Exactly one new `sdPostReport(` call, no new `fetch(`, and the 0.82 count is unchanged.

### 60.4 — What we need from you before Dan deploys (Dan: "you will need more info")

Built from your 29 Sep reply, `INTEGRATION-CONTRACT.md` (Assistance request row), `TSC-HELP-NOTIFICATIONS-FLOW-GUIDE.md`
(Parse JSON schema, the email body) and the live `help-centre.js` / `help-data.js`. **You have built and changed the
flows since**, so:

1. **Is the schema above still what `TSC Help Notifications`, `TSC Help Acknowledgements` and `TSC Help Six-hour
   Chat` parse today?** Have any keys been added, renamed or made required since the guide we hold? If the email body
   now carries more than `description`, say which keys, and we will stop folding the form into `description` if you
   prefer.
2. **A second post with the same `requestId`.** Your trigger fires on every new `seadrill-help_` file. So a re-post
   would email everyone again and create a second assistance chat. **161 therefore sends once and locks**; further
   information goes in the chat or the email thread. If you want in-tool updates (the Synergi number later, say),
   tell us the shape. An `isUpdate: true` the flow skips is one option. Until then, one send per request.
3. **`fieldLabels`** — will the Help Centre use it to label the FRM fields, instead of the raw keys it shows today
   under "The request as posted"? And should blank fields be left out? We send all 13, `""` when unanswered.
4. **West Phoenix** has no rig code. 161 sends `west-phoenix` and warns the crew that the rig's own four may not be
   emailed. Is Phoenix to be added to the Rigs sheet and `rigCodes`, or is it out of scope?
5. **Size.** Photographs are compressed. A document can be up to 20 MB embedded, and `sdSizeOk` warns at 10 MB
   total. Does the email action hold that? Outlook's attachment ceiling is about 25–35 MB. Give us a total to refuse
   above if you want one.
6. **`notifyKind`** — `mandatory` = rig down and ≥ 6 hrs since `occurredAt` at the moment of sending. Confirm that
   matches what the six-hour flow and the Help Centre expect.
7. **The roles.** `meta.tsl`, `meta.rigmgr` and `meta.arigmgr` are sent empty: SSORT has no such fields (RT KE-02).
   Your 29 Sep §2 says the flow addresses from the Rigs row, never from these, so nothing breaks. Confirm it is still
   so.
8. **Anything else the flows built since 29 Sep expect from the tool**, such as a receipt read-back. Name it and we
   build it.

### 60.5 — The end-to-end test, Dan's to run (posting is his)

Once 60.4 is answered:

1. Dan opens `SSORT REV 161\index.html` from his PC. Requests → Technical Assistance Request, rig `SSCE Equipment`,
   Practice send ticked.
2. He sends one rig-down request with a photo and a PDF.
3. Expected on your side: office-only email marked TEST, an office-only chat, a receipt on the Help Centre, and the
   FRM lines visible.

Then deploy. WCGRRT is untouched. The training pack stays held (entry 56), so the class deck has no assistance-request
shot until Dan releases the pack.

---

