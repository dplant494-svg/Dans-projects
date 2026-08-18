# RAPID-S53 Relay — Handoff

**Status: HOLD LIFTED 2026-08-17 — superseded as the delivery route.**
IADC (Mike Kucharski) answered all four open questions and issued Swagger
**v1.1.0** (`RAPIDS53_Inbound_API_v1.1.0.yaml`, in this repo). Answers,
in short:

1. **Auth = API-Key + HMAC-SHA256** (the scheme this relay implements as
   `RAPID_AUTH_MODE=hmac`; the inbound schema's OAuth2 block was their
   labeling error, removed in v1.1.0). Two-step: HMAC-signed
   `GET /authentication` → JWT (2h expiry) → `Authorization` + `x-api-key`
   on every other endpoint.
2. **`when_did_the_event_occur` is deprecated** — replaced by
   `what_was_the_system_status` (required, `In Operation`/`Not in
   Operation`).
3. **Reporter names**: free text accepted but silently dropped unless
   matching an authorised reporter from `GET /rigs`; IADC recommends
   treating the mismatch warning as an error (adopted).
4. **Sandbox exists**: `https://api-demo.rapid4s53.com`, same endpoints;
   credentials from the RAPID administrator. Some process steps are
   portal-only — a Teams session with Mike covers those.

**Route decision (Dan, 2026-08-18): the submission service is being
built as a Power Automate flow** — see `RAPID-S53-POWER-AUTOMATE-SPEC.md`
(rewritten to v1.1.0) and `RAPID-S53-TOOL-UPDATE-HANDOFF.md` for the
tool-side field changes. This Python relay stays archived as the
documented fallback: if the flow route ever stalls, the relay's `hmac`
auth mode is exactly the confirmed scheme — resume per "How to resume"
below, updating validation to v1.1.0's field list first.

Everything below this line is the original hold-era document, kept
verbatim for the record.

---

**Where the code is:** NOT in this repo. A standalone Python (FastAPI)
relay service was built and fully tested (122 passing tests, zero live
credentials required) to submit Rapid-S53 well-control incident reports
to `api.rapid4s53.com`. It's deliberately kept separate from this
dashboard codebase — it's a different service with different hosting and
its own secrets. The code, its test suite, and this same paperwork were
packaged as `RAPID-S53-ON-HOLD-ARCHIVE.zip` and saved to Dan's external
hard drive. **This file, `RAPID-S53-POWER-AUTOMATE-SPEC.md`,
`RAPID-S53-IADC-EMAIL-DRAFT.md`, and `RAPID-S53-Status.pdf` sitting
alongside it in this repo are the paperwork trail** — durable and
findable even if the external drive isn't at hand; the runnable code only
lives in that archive.

The same service also has a `POST /report` route (unrelated to RAPID,
uploads reports to SharePoint via Microsoft Graph) — it's in the same
archive but isn't part of this hold; nothing about it is blocked.

---

## What this is for

WCGRRT/SSORT (the offline, single-file HTML reporting tool) needs to
submit Rapid-S53 incident reports into RAPID-S53's database via its
Inbound API. The tool can't call `api.rapid4s53.com` directly — it can't
hold real credentials in a file anyone can open, and calling a
server-to-server API from `file://` hits a hard CORS wall. The relay
exists so the tool keeps POSTing its own JSON to a service we control; the
relay holds RAPID's real secrets and talks to RAPID on the tool's behalf.

As of SSORT Rev 104, the tool itself builds the finished, RAPID-shaped
`rapidIncident` object before it ever reaches the relay — so the relay's
job is now just: authenticate, validate six controlled-vocabulary fields
against RAPID's own cached option lists, check idempotency, and submit.
See `RAPID-S53-POWER-AUTOMATE-SPEC.md` for the equivalent no-code build
(same contract, not built).

---

## The contract (`POST /rapid-s53`)

```
Headers:
  Content-Type: application/json
  X-Api-Key: <shared secret>
Body: a flat, purpose-built shape - NOT the dashboard's nested
  tiles[].r53Data shape. Every s53_* field the tool captures, plus:
    report_id        (string, required) - client-generated UUID, persist
                      this in the tool's saved report so an edit-and-
                      resubmit reuses it. There is no other safe
                      idempotency key.
    contract_version  (int, required)
    assetid, asset, createdby  (required - asset is the rig name)
```

Response (200): `{"source": "stub"|"rapid", "report_id", "incident_number",
"action": "created"|"updated", "warnings": [...], "incident": {...}}`.
Errors:
- `401` bad/missing key
- `422` missing `report_id`/`assetid`/`asset`/`createdby`
- `400` `{"error": "transform_failed", "fields": [...]}` — see "Known gaps"
  below. **Every real submission will hit this until those are resolved.**
- `502` `{"error": "rapid_malformed_request"|"rapid_request_failed", ...}`

---

## Known gaps — three fields RAPID requires that the tool doesn't send today

1. **`when_did_the_event_occur`** — required by RAPID, but its own schema
   defines no property for it (a genuine spec inconsistency). Blocked
   pending IADC/Softway confirmation.
2. **`pressure_rating_unit`** — unconfirmed whether the tool's `s53_bore`
   (Affected Circuit) is the right source, or a new field is needed.
3. **`drilling_fluids_into_environment`** — not captured by the tool at
   all today.

A fourth item, **reporter first/last name**, is already handled with a
naive split of the report's creator name so it doesn't block submissions —
what's still open is whether RAPID requires that name to match an
authorised reporter on file for the rig (`GET /rigs`), or accepts free
text.

If a future tool build starts sending any of the three blocking fields
directly under their RAPID field name, the relay's transform passes them
straight through — no relay code change needed, per the archived code's
own design (see `report-backend/app/rapid_s53/transform.py` in the zip).

---

## Open questions sent to IADC/Softway

The official list (also in `RAPID-S53-IADC-EMAIL-DRAFT.md`):

1. Which authentication actually applies to `/incident`: OAuth2 (as the
   inbound schema states), or the API-Key + username/password +
   HMAC-SHA256 scheme (as the outbound documentation for the same portal
   states)? The two disagree.
2. `when_did_the_event_occur` is listed as required, but the schema
   doesn't define a property for it at all — what value/type does it
   expect?
3. Must `reporter_first_name`/`last_name` match an authorised reporter
   returned by `GET /rigs` for that rig, or is free text accepted?
4. Is there a sandbox/test environment available for submission testing,
   and what are its rate limits?

---

## Environment variables (for whoever redeploys the archived code)

| Var | Required for live mode | Purpose |
|---|---|---|
| `API_KEY` / `API_KEY_RAPID_S53` | ✅ | Shared secret the tool sends as `X-Api-Key` |
| `CORS_ORIGINS` | ✅ in prod | Comma-separated allowed origins |
| `RAPID_AUTH_MODE` | — | `stub` (default) \| `hmac` \| `bearer` — two real candidates, unconfirmed (see open questions) |
| `RAPID_BASE_URL` | optional | Defaults to `https://api.rapid4s53.com` |
| `RAPID_API_KEY` / `RAPID_USERNAME` / `RAPID_PASSWORD` / `RAPID_SECRET` | if `RAPID_AUTH_MODE=hmac` | The outbound-spec's documented scheme |
| `RAPID_STATIC_BEARER_TOKEN` | if `RAPID_AUTH_MODE=bearer` | A human-obtained token — there's no unattended way to get this; see the archived `auth.py`'s docstring |
| `RAPID_OPTIONS_CACHE_TTL_HOURS` | optional | Defaults to `24` |
| `IDEMPOTENCY_DB_PATH` | optional | Defaults to `./data/rapid_s53_idempotency.db` — **must sit on a persistent volume in production**, or a redeploy loses the report_id→incident_number mapping and the next resubmission creates a duplicate RAPID incident |

---

## How to resume once IADC/Softway answers land

1. Unzip `RAPID-S53-ON-HOLD-ARCHIVE.zip` from the external drive.
2. Set `RAPID_AUTH_MODE` (`hmac` or `bearer`) and the matching credentials
   per their answer on question 1.
3. For each of the three gap fields IADC clarifies, confirm whether the
   fix is tool-side (new field to capture) or relay-side — the transform
   layer already passes any of them through once present, so most likely
   nothing here needs to change.
4. Run `pytest` inside the unzipped `report-backend/` — 122 tests should
   still pass with zero live credentials before touching anything live.
5. Test against RAPID's sandbox (if question 4 confirms one exists)
   before pointing the real tool at production.
6. Once confirmed working, wire WCGRRT/SSORT's Rapid-S53 submission to
   `POST https://<wherever this gets hosted>/rapid-s53` — this is new
   integration work in the tool, not a reuse of its existing report-export
   logic.
