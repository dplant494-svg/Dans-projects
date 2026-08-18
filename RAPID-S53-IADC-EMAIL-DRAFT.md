# Email draft — reply to Mike Kucharski (IADC), RAPID-S53 next steps

> The original four-questions email this file used to hold was answered
> in full by Mike on 2026-08-17 (v1.1.0 issued alongside). This is the
> reply draft. Copy the body below into Outlook.

**To:** mike.kucharski@iadc.org
**Cc:** iadc_dev@softway.com
**Subject:** RE: RAPID-S53 Inbound API — thanks; sandbox access + Teams session

---

Hi Mike,

Thank you — that answers everything we had open, and the v1.1.0 Swagger
resolves the schema inconsistencies we'd flagged. We're proceeding on
exactly the basis you described: API-Key + HMAC-SHA256 authentication,
`what_was_the_system_status` in place of the deprecated field, and
reporter names sourced from the authorised list per rig — we've taken
your recommendation and will treat a non-matching reporter as an error on
our side before anything is submitted.

Two things to move us forward:

1. **Sandbox access** — could the system administrator set us up with
   credentials for https://api-demo.rapid4s53.com (username, password,
   secret key and API key)? We'll validate our full submission sequence
   there — including create, edit-and-resubmit, and rejection handling —
   before anything touches production. If the sandbox has rate limits we
   should respect, a note on those would be appreciated.

2. **Teams session** — yes please, on the portal-only parts of the
   reporting process. Once we have sandbox access and have run our test
   submissions, a session where we walk through how they appear on the
   portal side would be ideal — I'll bring our test incident numbers.
   Please suggest a few times that suit you.

One small confirmation while we're at it: we'd like our test rigs and
authorised reporter names to be present in the sandbox's GET /rigs data
so we can exercise the reporter validation — is that something the
administrator sets up as part of sandbox onboarding?

Thanks again — this was exactly the clarity we needed.

Best,
Dan Plant
Technical Superintendent, Well Control Engineering — Seadrill
