# Handoff — SSORT `rapidIncident` updates for RAPID-S53 v1.1.0

**For:** the reporting-tools session (WCGRRT/SSORT), which builds the
`rapidIncident` object in-tool (Rev 104+).
**From:** the dashboard session (`Dans-projects`).
**Date:** 2026-08-18.
**Why now:** IADC answered our four blocking questions and issued Swagger
**v1.1.0** (`RAPIDS53_Inbound_API_v1.1.0.yaml`, in the `Dans-projects`
repo — the authoritative schema). The submission path is being built as a
Power Automate flow per `RAPID-S53-POWER-AUTOMATE-SPEC.md`. The flow does
**zero field mapping** — it validates and submits exactly what the tool
builds, so these schema changes land in the tool.

## 1. Field changes to the `rapidIncident` builder

| Change | Field | Detail |
|---|---|---|
| **REMOVE** | `when_did_the_event_occur` | Deprecated by IADC; no longer exists in v1.1.0. |
| **ADD (required)** | `what_was_the_system_status` | Enum: `"In Operation"` \| `"Not in Operation"`. Needs a UI control. The YAML carries IADC's full API-53-based definition of when the WCS counts as In Operation (latched + initial subsea testing complete; well-hop rules included) — surface that text as help for the user, don't paraphrase it. |
| **ADD (required)** | `pressure_rating_unit` | Enum: `"Operating Circuit"` \| `"Wellbore"`. **Open question for you**: is the tool's existing `s53_bore` (Affected Circuit) semantically this value? If yes, map it; if not, add a dropdown. You own that call — the definition is in the YAML. |
| **ADD (recommended, optional in schema)** | `drilling_fluids_into_environment` | `"yes"` \| `"no"`. Optional in v1.1.0, but a `"yes"` auto-sets Root Cause to "RCFA Required" on RAPID's side — capture it rather than omit it. |
| **Consider (optional)** | `impacted_element` (`"Inline"`/`"Offline"`), `work_phase` (23-value enum), `desc_support_for_root_cause_selection`, `desc_lessons_learned_summary`, `what_maintenance_was_deferred`, `assessment_pending_root_cause_reason` | All optional; add as the template evolves. Enums verbatim from the YAML. |

Everything else in the builder stands — v1.1.0 has **52 required fields,
all defined** (the required-but-undefined inconsistency is fixed). Do a
one-pass diff of your builder's output against the YAML's
`definitions.Incident.required` + enum values; several enums are
punctuation-sensitive (`"15 - Test B.O.P."`, `'13/16"'`, etc.).

## 2. Reporter names — behaviour change

IADC's answer: free text is accepted but **silently dropped** unless
first/last name matches an authorised reporter for that rig from
`GET /rigs`; they recommend treating the mismatch warning as an error.
Dan's decision: the submission flow **rejects** unmatched reporters
before submitting, with a message telling the user to use a name from
the rig's authorised list.

Tool-side implication: keep populating `reporter_first_name`/`last_name`
(the naive creator-name split is fine as a default), but expect
rejections until rig reporter names align with RAPID's records. If you
want pick-from-list UX later, the flow's daily cache of `/rigs` (rig →
authorised reporters) can be exposed to the tool — ask and we'll spec it.

## 3. Submission contract (confirm or push back)

The flow expects this POST body — if Rev 104's export shape differs,
tell the dashboard session and the flow trigger will be adjusted to
match yours instead; do NOT reshape silently:

```json
{
  "report_id": "<UUID, generated once per report and PERSISTED in the saved report - an edit-and-resubmit must reuse it (it's the only duplicate-prevention key)>",
  "contract_version": 2,
  "asset": "<rig name>",
  "assetid": "<rig id>",
  "createdby": "<report creator>",
  "rapidIncident": { "...": "complete v1.1.0 Incident object" }
}
```

Transport once the flow exists: same posting pattern as
`POSTCONTRACTFORDASHBOARDBUTTONS.md` (plain fetch, application/json,
res.ok, UTF-8-safe base64 not needed here — this body is JSON, not a
file wrapper), URL supplied when the flow is built.

## 4. What you do NOT need to handle

Authentication (HMAC + tokens), option-list vocabulary validation,
reporter matching, idempotent create-vs-update, retries — all live in
the flow. The tool just builds a correct v1.1.0 incident and POSTs it.
