# RAPID-S53 submission flow — Power Automate build spec

**Audience:** someone building this in the Power Automate designer, no
coding background assumed. **Companion, not a replacement, for the Python
relay** (`report-backend/app/rapid_s53/`) — build whichever one your
organization is better positioned to host and maintain; the two are
functionally equivalent by design (same field mapping table, same
contract). `mapping.py` in that folder is the single source of truth this
spec's Compose expressions must match.

**Do not start building step 6 (HMAC) until you've read it** — it's a real
blocker, not a formality.

---

## 1. Overview

```
[HTTP trigger: receive report]
        |
        v
[Condition: X-Api-Key matches stored secret?] --No--> [Terminate: 401]
        |Yes
        v
[Compose: build the Incident from the report — same field table as mapping.py]
        |
        v
[Check idempotency list for this report_id]
        |
        v
[Get/refresh RAPID auth token]  <-- separate concern, see §6-7
        |
        v
[HTTP: POST /incident or /update/incident]
        |
        v
[Branch on response: success / warnings / 405 / other error]
        |
        v
[Write report_id -> incident_number to idempotency list]  (before evaluating warnings — see §10)
        |
        v
[Respond to the caller]
```

A **separate, scheduled** child flow (§8) refreshes RAPID's six option
lists once a day — it does not run inside this synchronous flow.

---

## 2. Licensing note — read this before opening the designer

The **HTTP request trigger** ("When a HTTP request is received") and the
generic **HTTP action** (used to call RAPID's API) are both **Premium**
connectors in most Power Automate tenants. Confirm your organization's
license tier covers Premium connectors, or this entire flow can't be built
as described. This is the same constraint the SharePoint-relay side of
this project doesn't have (it's a small Python service instead) —
flagging it now, not discovered halfway through the build.

---

## 3. Trigger

- Trigger: **"When a HTTP request is received."**
- **Request body JSON schema**: generate it from a sample payload matching
  the flat `/rapid-s53` contract the Python relay defines — every `s53_*`
  field from `mapping.py`, plus `report_id`, `contract_version`, `assetid`,
  `asset`, `createdby`. Include `report_id` in the sample — it's easy to
  forget since it's not one of the RAPID-facing fields, but the whole flow
  depends on it.
- Immediately after the trigger, add a **Condition**: does the incoming
  `X-Api-Key` header equal the stored secret (§4)? If not, **Terminate**
  the flow with status "Failed" and respond `401`. Do this before touching
  the payload at all.

---

## 4. Secret storage

Store the shared API key (and RAPID's own credentials, once §6/§7 are
resolved) as **Power Platform environment variables of type Secret**, or
in **Azure Key Vault** via the Key Vault connector. **Never** paste a
secret as a literal string into a Compose or HTTP action — flow
definitions are readable by anyone with maker-portal access to the
environment, so a literal secret there is not meaningfully protected.

---

## 5. Build-the-Incident stage

One **Compose** action, `BuildIncident`, with one expression per RAPID
field. Keep this in lockstep with `mapping.py`'s tables — that file is the
authoritative list, this Compose action is a second, independently
maintained implementation of the same table, and the two **will** drift if
one changes without the other:

- **Direct fields** (`mapping.DIRECT_FIELD_MAP`): `triggerBody()?['s53_bopfluid']` → straight into `component_manufacturer_name` etc. No expression logic.
- **Dates** (`mapping.DATE_FIELD_MAP`): `formatDateTime(triggerBody()?['s53_installdate'], 'MMM dd, yyyy')`. Our stored value is already ISO `yyyy-MM-dd`, so no separate parse step is needed.
- **Integers** (`mapping.INTEGER_FIELD_MAP`): `int(triggerBody()?['s53_npt'])`. If the source value isn't numeric, this expression throws — let it; don't wrap it in a fallback that silently sends `0`.
- **Numbers** (`mapping.NUMBER_FIELD_MAP`): `float(triggerBody()?['s53_usagehours'])`.
- **Booleans** (`mapping.BOOLEAN_FIELD_MAP`): `if(equals(triggerBody()?['s53_unplanned'], true), 'yes', 'no')`. RAPID wants the lower-case string, not a JSON boolean.
- **Enum reconciliation** (`mapping.ENUM_RECONCILE_FIELD_MAP` / `ENUM_VALUE_MAPS`): a `switch()` expression per flagged field. Today only `detection_method` has a confirmed mismatch (`"Functional Testing Surface"` → `"Function Testing"`); default the `switch()` to the original value for everything else, so an unmapped value passes through rather than being silently dropped.
- **`rig_name`**: `triggerBody()?['asset']` — not one of the `s53_*` fields, comes from the report's own rig identity.
- **Reporter name split**: `first(split(triggerBody()?['createdby'], ' '))` for `reporter_first_name`; the corresponding "everything after the first space" expression for `reporter_last_name` — Power Automate has no direct "split once" function, so build it as `if(contains(...), substring(...), '')` around the first space's index (`indexOf`). This is the same naive fallback the Python relay uses; it's a stopgap, not a fix — see §9 for the real gap.
- **The three genuine gaps** (`when_did_the_event_occur`, `pressure_rating_unit`, `drilling_fluids_into_environment`): do **not** invent a value. If the trigger payload doesn't carry one of these under its own RAPID field name, this flow should fail the same way the Python relay does — see §9.

---

## 6. HMAC — the real blocker, named plainly

**Power Automate has no built-in keyed HMAC-SHA256 expression.** The
`ApiKeyHmacAuth` scheme in the Python relay (`base64(HMAC_SHA256(username +
password + UTC timestamp, secret))`) cannot be computed inside a Compose
action or any stock connector action. Two honest options, pick one before
going further:

**(a) A minimal Azure Function**, doing only this one computation — input:
username/password/timestamp/secret; output: the base64 signature. Called
from this flow via an HTTP action. This is a few lines of code, but it is
code, hosted somewhere, with its own secret (the HMAC secret) to protect —
functionally a tiny sibling of the Python relay this spec is meant to be
an alternative to.

**(b) If IADC confirms the bearer/OAuth path is the real one** (see the
open question list this relay sent them — §7 below explains why the
inbound YAML's stated "implicit flow" can't actually work unattended),
this entire section disappears and the flow gets substantially simpler:
no HMAC, just a token-acquisition HTTP call and a cached bearer token.

Do not build §6 assuming (a) or (b) without confirming which is real —
that confirmation is one of the six open questions in
`RAPID-S53-RELAY-HANDOFF.md`, sent to IADC/Softway. The Python relay's
`auth.py` hedges this exact ambiguity behind one interchangeable
`RapidAuth` interface for the same reason.

---

## 7. RAPID authentication call

Whichever of §6(a)/(b) is confirmed:

- Call RAPID's `/authentication` endpoint (or whatever token endpoint the
  confirmed scheme uses) in its own action, before the submit call.
- **Cache the resulting token with its expiry in a Dataverse table or
  SharePoint list**, not in a flow variable — Power Automate does not keep
  in-memory state across separate runs, so every run without a persisted
  cache would re-authenticate needlessly (and, if RAPID rate-limits
  `/authentication`, could start failing under normal traffic).
- Before calling RAPID, check the cached expiry; only re-authenticate if
  expired or missing.

---

## 8. Option-list caching — separate scheduled flow

Build the six RAPID option-list lookups (`/rigs`, `/control-fluids`,
`/component-manufacturer`, `/subunit-hierarchy`, `/observed-failures`,
`/models`) as their **own flow**, triggered on a **daily recurrence**, that
writes the results into a Dataverse table or SharePoint list. The
submission flow (this document) only **reads** that list — it does not
call RAPID's option endpoints inline. Two reasons: it keeps the
synchronous submission flow well under Power Automate's ~120-second
timeout, and it means a slow/failing RAPID option endpoint never blocks an
actual incident submission.

On a fetch failure, the daily flow should leave the existing cached list
untouched (log the failure, don't overwrite good data with nothing) — same
stale-on-failure-fallback behavior as the Python relay's `options.py`.

---

## 9. Vocabulary validation

For each of the six controlled-vocabulary fields
(`rig_name`, `subunit_name`/`item_name`/`component_name`,
`component_manufacturer_name`, `model`, `observed_failure_name`,
`bop_control_fluid`), add a **Condition** (or a `contains()` check against
the cached list from §8) after `BuildIncident`. If a value isn't in the
cached list, **Terminate** the flow with status "Failed" and a structured
message naming the field — mirroring the Python relay's `400
transform_failed` response, so both integrations fail the same way for the
same reason. Do this **before** calling RAPID: RAPID's own `warnings[]`
response silently drops unmatched vocab rather than rejecting it, so
catching it here is the only way to get a clear, immediate failure instead
of a false "success."

The same Condition-based approach handles the three named gaps from §5:
if `when_did_the_event_occur` / `pressure_rating_unit` /
`drilling_fluids_into_environment` aren't present in the trigger payload,
Terminate naming the missing field, rather than sending RAPID an
incomplete `Incident`.

---

## 10. Idempotency

Keep a Dataverse table (or SharePoint list) keyed by `report_id`, one
column `incident_number`. Before calling RAPID:

1. Look up `report_id` in this table.
2. If found → call `/update/incident` with the stored `incident_number`.
3. If not found → call `/incident` (create).

**Non-negotiable ordering**: RAPID returns a real `incident_number` even
on a response that also carries `warnings[]`. Write the `report_id` →
`incident_number` mapping to the table **immediately after** either call
succeeds — **before** the next step evaluates `warnings[]`. If this order
is reversed, a caller who sees "submitted with warnings" and naively
retries from scratch will create a **duplicate incident** in RAPID for
something that already exists.

---

## 11. Submit + response handling

After the `/incident` or `/update/incident` call, branch explicitly:

- **2xx, empty `warnings[]`** → success. Respond 200 to the caller with the `incident_number`.
- **2xx, non-empty `warnings[]`** → "submitted with warnings," **not** a failure. Still write the idempotency mapping (§10). Respond 200 but surface the warnings list so the tool/user knows a value was silently ignored by RAPID.
- **405** → RAPID's documented response for a malformed request body. Treat as non-retryable — this means something in `BuildIncident` is wrong, not a transient RAPID problem. Respond with a distinct message ("request rejected as malformed — check field mapping"), don't retry.
- **Other 4xx** (e.g. 401) → non-retryable, respond with the RAPID error body passed through.
- **5xx** → potentially transient, eligible for retry (§12).

---

## 12. Retry policy

On the HTTP action that calls RAPID, set the built-in retry policy to
trigger only on **429 and 5xx**. Explicitly **exclude 405 and 401** from
retry — retrying a malformed request or a bad credential just repeats the
same failure and burns RAPID's rate limit for no benefit.

---

## 13. Risks appendix

- **Run-history retention**: Power Automate's default run-history window may not be long enough for after-the-fact incident investigation — consider exporting run history or logging outcomes to a SharePoint list/Dataverse table separately from the platform's own history.
- **Connector throttling**: Premium HTTP connector calls count against tenant-level API request limits: high-volume submission days (e.g. a fleet-wide well-control drill) could hit throttling Power Automate surfaces as a generic error, easy to mistake for a RAPID-side problem.
- **JSON action size limits**: Compose/Parse JSON actions have payload size ceilings well below what a large multi-attachment report could reach — this flow's trigger payload is the flat `/rapid-s53` contract only (no attachments), so this is a lower risk here than elsewhere in this project, but worth confirming against your tenant's actual limits before assuming it's a non-issue.

---

## Open questions this spec depends on

Same six questions the Python relay sent to IADC/Softway — §6 and §7 above
cannot be finalized until at least question 1 (and ideally 2) is answered.
See `RAPID-S53-RELAY-HANDOFF.md` / the Python relay's `HANDOFF.md` for the
full list; summarized:

1. Is machine-to-machine auth actually client-credentials or API-Key+HMAC — the inbound YAML's stated "implicit flow" can't run unattended.
2. For the HMAC scheme: is there a header carrying the raw timestamp, and what clock-skew tolerance does RAPID accept?
3. What does `when_did_the_event_occur` actually expect, given the YAML defines no property for it?
4. Must `reporter_first_name`/`last_name` match an authorised reporter from `/rigs`, or is free text accepted?
5. Does `pressure_rating_unit` map from `s53_bore`, or is a new tool field needed?
6. Is there a sandbox environment, and what are its rate limits?
