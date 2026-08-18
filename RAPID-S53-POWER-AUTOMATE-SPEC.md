# RAPID-S53 submission flow — Power Automate build spec (v1.1.0)

**Status: UNBLOCKED — build this.** IADC (Mike Kucharski) answered all
open questions on 2026-08-17 and issued Swagger **v1.1.0**
(`RAPIDS53_Inbound_API_v1.1.0.yaml`, checked into this repo — the
authoritative schema for everything below). The chosen route for the
RAPID-S53 submission service is this Power Automate flow, NOT the
archived Python relay (decision recorded in
`RAPID-S53-RELAY-HANDOFF.md`; the relay stays archived as fallback).

**Audience:** someone building this in the Power Automate designer, no
coding background assumed — plus one small helper (§6) that needs IT to
deploy a few lines of provided code. The org already runs a Premium
HTTP-trigger flow in production (the PostedReports posting flow), so
licensing and the build pattern are proven.

---

## 1. Overview

SSORT Rev 104+ **builds the finished, RAPID-shaped `rapidIncident`
object inside the tool** — so unlike the original draft of this spec,
there is **no field-mapping stage**. The flow's whole job is: validate,
authenticate, submit, respond.

```
[HTTP trigger: receive submission from SSORT]
        |
        v
[Condition: X-Api-Key matches stored secret?] --No--> [Terminate: 401]
        |Yes
        v
[Validate rapidIncident: 52 required fields present,
 enums legal, vocab + reporter checked against cached lists (§8-9)]
        |--fail--> [Respond 400 naming the field(s); nothing sent to RAPID]
        v
[Idempotency lookup for report_id (§10)]
        |
        v
[Get RAPID token: cached, or re-auth via HMAC helper (§6-7)]
        |
        v
[HTTP: POST /incident  (or /update/incident if report_id known)]
        |
        v
[Write report_id -> incident_number FIRST, then branch on warnings (§11)]
        |
        v
[Respond to SSORT]
```

A **separate, scheduled** child flow (§8) refreshes RAPID's option lists
(including the authorised-reporters list) once a day.

## 2. Licensing — resolved

The HTTP request trigger and generic HTTP action are Premium connectors.
**This is no longer a risk**: the PostedReports posting flow already runs
on this tenant using the same trigger, in production, today. Build in the
same environment family (IT's SEADRILL-WC-DEV per their plan, or wherever
the PostedReports flow lives).

## 3. Trigger + contract with SSORT

- Trigger: **"When a HTTP request is received."**
- Body (confirm final shape with the reporting-tools session — see
  `RAPID-S53-TOOL-UPDATE-HANDOFF.md`; this is the recommended contract):

```json
{
  "report_id": "<client-generated UUID - REQUIRED, the only safe idempotency key>",
  "contract_version": 2,
  "asset": "<rig name>",
  "assetid": "<rig id in the tool>",
  "createdby": "<report creator>",
  "rapidIncident": { "...": "the complete Incident object in RAPID's own field names, built by SSORT" }
}
```

- Immediately after the trigger: **Condition** — incoming `X-Api-Key`
  header equals the stored secret (§4)? If not, Terminate + 401, before
  touching the payload.

## 4. Secret storage

Store the SSORT shared key, the RAPID credentials (username, password,
secret key, x-api-key — all four arrive from the RAPID administrator by
email during onboarding; the secret key comes in a **separate** email),
and the HMAC helper's own key as **Power Platform environment variables
of type Secret** or in **Azure Key Vault**. Never as literals in a
Compose/HTTP action — flow definitions are readable by anyone with
maker-portal access.

## 5. ~~Build-the-Incident~~ — deleted

SSORT builds the incident. The flow performs **no field mapping** and
**invents no values**. If something required is missing, that's a
validation failure back to the tool (§9), never a default filled in here.

## 6. RAPID authentication — the confirmed recipe

**Confirmed by IADC 2026-08-17: API-Key + HMAC-SHA256. The OAuth2 block
in the old inbound schema was their labeling error, removed in v1.1.0.**

Two steps:

**Step 1 — `GET https://api.rapid4s53.com/authentication`** with exactly
four headers:

| Header | Value |
|---|---|
| `X-Authorization-Username` | username from the onboarding email |
| `X-Authorization-Content-SHA256` | `base64( HMAC_SHA256( username + password + timestamp, secret_key ) )` — hash computed over the **plain concatenation** (no separators), digest taken as **raw binary** before base64 |
| `X-Authorization-Timestamp` | the same timestamp used in the hash — **GMT**, format `YYYY-MM-DD hh:mm:ss`; rejected if more than 2 hours old |
| `x-api-key` | the API key from the onboarding email |

Response: `{"success": true, "data": {"token": "<JWT>"}}`.

**Step 2 —** every other endpoint gets two headers: `Authorization:
<that JWT>` and `x-api-key`. The token **expires 2 hours after issue**;
re-authenticate to get a new one.

### 6.1 The one piece Power Automate can't do itself

Power Automate has **no HMAC-SHA256 expression**, so the signature in
step 1 is computed by a tiny helper IT deploys once. Two equivalent
options — deploy EITHER, both verified to produce identical signatures:

**Option A — Azure Function (Node.js):**

```js
const crypto = require("crypto");
module.exports = async function (context, req) {
  const { username, password, timestamp } = req.body || {};
  const secret = process.env.RAPID_SECRET_KEY;   // Function app setting, not in the flow
  if (!username || !password || !timestamp || !secret) {
    context.res = { status: 400, body: { error: "missing input" } }; return;
  }
  const signature = crypto.createHmac("sha256", secret)
    .update(username + password + timestamp, "utf8").digest("base64");
  context.res = { status: 200, body: { signature } };
};
```

**Option B — Azure Automation PowerShell runbook (webhook-triggered):**

```powershell
param([object]$WebhookData)
$in = $WebhookData.RequestBody | ConvertFrom-Json
$secret = Get-AutomationVariable -Name 'RAPID_SECRET_KEY'   # encrypted automation variable
$h = New-Object System.Security.Cryptography.HMACSHA256
$h.Key = [Text.Encoding]::UTF8.GetBytes($secret)
$sig = [Convert]::ToBase64String($h.ComputeHash(
    [Text.Encoding]::UTF8.GetBytes($in.username + $in.password + $in.timestamp)))
@{ signature = $sig } | ConvertTo-Json
```

Notes for IT: the RAPID **secret key lives in the helper's own
configuration** (Function app setting / encrypted Automation variable),
never in the flow and never in the request body — the flow sends only
username, password and timestamp. Keep the helper's URL non-guessable
(function key / webhook token) since anyone who can call it can obtain
signatures.

### 6.2 Verification test vector — run this BEFORE credentials arrive

With inputs `username=testuser`, `password=TestPassword123`,
`timestamp=2026-08-18 12:00:00`, `secret=test-secret-key`, the helper
MUST return exactly:

```
yP3QFwesU4mPBXVX+BuT5KE6HD6E69s9kgHjZuW6F6Q=
```

(Verified 2026-08-18 against three independent implementations — Python
`hmac`, .NET `HMACSHA256`, Node `crypto` — all identical.) If the
deployed helper returns anything else for these inputs, it is wrong —
usual suspects: hex output instead of raw-binary→base64, separators
added between the three concatenated values, or a non-UTF-8 encoding.

### 6.3 Flow expressions for step 1

- Timestamp: `formatDateTime(utcNow(), 'yyyy-MM-dd HH:mm:ss')` — capital
  `HH` (24-hour). Compute it ONCE into a Compose and reuse the same
  output for both the helper call and the header — a re-evaluated
  `utcNow()` can differ between actions and invalidate the signature.
- HTTP action → helper URL with `{username, password, timestamp}` →
  returns `{signature}`.
- HTTP action → `GET https://api.rapid4s53.com/authentication` with the
  four headers → parse `body('...')?['data']?['token']`.

## 7. Token caching

Cache the token **with an expiry timestamp** (issue time + ~110 minutes,
inside the 2-hour window) in a SharePoint list or Dataverse table — not a
flow variable (no state across runs). Before calling RAPID: read cache →
if missing/expired, run §6 and update the cache. If any RAPID call
returns 401/`"The incoming token has expired"`, invalidate the cache,
re-authenticate once, retry the call once.

## 8. Option-list caching — separate scheduled daily flow

Fetch and store (SharePoint list / Dataverse):

- `/rigs` — rig names **and each rig's `reporters[]` (first_name,
  last_name)**. This is now the authoritative source for reporter
  validation (§9), per IADC's answer 3.
- `/control-fluids`, `/component-manufacturer`, `/subunit-hierarchy`,
  `/observed-failures`, `/models`.

On fetch failure, keep the previous cached list (log, don't overwrite
good data with nothing). These calls use the same token + x-api-key
headers as everything else.

## 9. Validation — before anything is sent to RAPID

All checks run against `triggerBody()?['rapidIncident']`; any failure →
Terminate/respond **400 naming the exact field(s)**, nothing sent.

1. **Required fields**: all **52** entries of v1.1.0's
   `definitions.Incident.required` present and non-empty. Take the list
   verbatim from `RAPIDS53_Inbound_API_v1.1.0.yaml` — do not retype it
   from memory. Notables vs the old spec: `what_was_the_system_status`
   is required (enum `In Operation` / `Not in Operation`) —
   `when_did_the_event_occur` no longer exists;
   `pressure_rating_unit` is required (enum `Operating Circuit` /
   `Wellbore`). `drilling_fluids_into_environment` is **optional** —
   pass through when present, never block on it.
2. **Enums**: v1.1.0 defines 24 enum fields — validate at least the
   high-risk ones (`what_was_the_system_status`, `pressure_rating_unit`,
   `event_date_is`, `component_status`, `detection_method`,
   `iadc_code_description`, yes/no fields) against the YAML's exact
   values; case and punctuation must match exactly.
3. **Controlled vocabulary** (values RAPID silently drops if unmatched):
   `rig_name`, `subunit_name`, `item_name`, `component_name`,
   `component_manufacturer_name`, `model`, `observed_failure_name`,
   `bop_control_fluid` — check against the §8 cache. Catching these here
   is the only way to get a clear failure instead of a false success.
4. **Reporter pre-flight (Dan's decision, per IADC recommendation)**:
   if `reporter_first_name`/`reporter_last_name` are present, they must
   match (case-insensitive) an entry in the cached `reporters[]` for
   `rig_name`. No match → 400: *"reporter '<first last>' is not an
   authorised reporter for <rig> — pick a name from the rig's authorised
   list or contact the RAPID administrator to have them added."* This
   runs BEFORE submission because RAPID's own behavior is to create the
   incident **without** a reporter and only warn.

## 10. Idempotency

SharePoint list / Dataverse table keyed `report_id` → `incident_number`.

1. Look up the incoming `report_id`.
2. Found → `POST /update/incident` including the stored
   `incident_number` in the body.
3. Not found → `POST /incident`.

**Non-negotiable ordering**: RAPID returns a real `incident_number` even
when the response carries `warnings[]`. Write the mapping **immediately
after** either call succeeds — **before** evaluating warnings. Reversed,
a user who retries after a warning creates a duplicate incident.

## 11. Submit + response handling

- **2xx, empty `warnings[]`** → respond 200 with `incident_number`.
- **2xx with the reporter warning** (*"The provided reporter was not
  found…"*) → the §9 pre-flight makes this rare (stale cache window).
  Mapping is already written (§10); respond as a **failure** telling the
  submitter the incident was created without a reporter and to fix the
  name and resubmit — the resubmit updates the same incident via §10.
- **2xx, other warnings** → "submitted with warnings", not a failure;
  respond 200 and surface the warnings list verbatim.
- **400** → RAPID rejected the body (`SubmissionError` may carry
  field-level detail in `data`) — non-retryable; pass the detail through.
- **403** → unauthorized/unknown user/account disabled — non-retryable;
  check credentials and that onboarding is complete.
- **5xx / 503** → potentially transient (§12).

## 12. Retry policy

Built-in retry on the RAPID HTTP actions for **429 and 5xx only**.
Explicitly exclude 400/401/403 — retrying a malformed request or bad
credential repeats the failure and burns rate limit.

## 13. Sandbox first — test sequence

**Sandbox: `https://api-demo.rapid4s53.com`** — same endpoints as
production; authenticate against the demo host and use the returned
token against the demo host. Credentials (username, password, secret
key, x-api-key) must be requested from the RAPID **system administrator**
— they are separate from production credentials. Keep the base URL as an
environment variable so demo → production is a config change, not an
edit.

In order, all against the sandbox:

1. Helper returns the §6.2 test vector exactly (no credentials needed).
2. `GET /authentication` returns `success: true` and a token.
3. `GET /rigs` with the token → confirm Seadrill's rigs and their
   authorised reporters appear; run the §8 daily flow once.
4. Submit a complete test incident → 200 + `incident_number`.
5. Re-submit the same `report_id` → flow takes the `/update/incident`
   path; NO second incident appears in the demo portal.
6. Submit with a junk `component_manufacturer_name` → the flow's own 400
   (never reaches RAPID).
7. Submit with a junk reporter name → the flow's own 400 from the §9
   pre-flight.
8. Have Mike/administrator confirm in the demo portal that the test
   incidents display correctly (this is also a natural Teams-call
   agenda item — some steps of the RAPID process are portal-only, per
   Mike).

Only after all eight: switch the base URL + credentials to production.

## 14. Risks appendix

- **Run-history retention**: default retention may be too short for
  incident forensics — log outcomes (report_id, incident_number,
  warnings, timestamp) to your own SharePoint list/Dataverse table.
- **Connector throttling**: Premium HTTP calls count against tenant API
  limits; a fleet-wide drill day could throttle. The §8 daily flow and
  token cache keep steady-state volume minimal.
- **Payload size**: the trigger payload is the flat contract + one
  incident object, no attachments — well under Compose/Parse JSON
  ceilings.
- **Clock skew**: the timestamp window is 2 hours, so ordinary clock
  drift is a non-issue; if `/authentication` returns 401 "hash expired"
  with a fresh timestamp, check the helper's inputs, not the clock.
