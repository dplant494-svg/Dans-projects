# Email draft — reply to Mike Kucharski (IADC), RAPID-S53 next steps

> Refreshed 9 Oct 2026 (plan item 50, step 1). Mike answered all four open questions on 17 Aug and issued v1.1.0;
> the August reply drafted here was never sent, so this version acknowledges the gap. The Teams session is
> left until our test submissions run (Dan, 9 Oct: see it working first). Paste-ready copy for Outlook:
> `Email-IADC-RAPID-S53-Sandbox.html`.

**To:** mike.kucharski@iadc.org
**Cc:** iadc_dev@softway.com
**Subject:** RE: RAPID-S53 Inbound API — sandbox access

---

Hi Mike,

Apologies for the slow reply. Your answers on 17 August and the v1.1.0 Swagger settled everything we had open, and I
should have come back to you sooner. We are now ready to move, on exactly the basis you described:

- API key and HMAC-SHA256 sign-in, with the token from `GET /authentication`;
- `what_was_the_system_status` in place of the deprecated event date;
- reporter names taken from the authorised list for each rig. We will treat a name that does not match as an error on
  our side, before anything is sent.

Our submission will run as a Power Automate flow. Our rig reporting tool already builds the incident in RAPID's own field
names, so the flow only checks it and submits it.

Two things to get us started:

1. **Sandbox access.** Could the system administrator set us up for https://api-demo.rapid4s53.com: username, password,
   secret key and API key? We will run our whole test sequence there first: create, edit and resubmit the same incident,
   and our own rejection checks. If the sandbox has rate limits, please let me know.
2. **Our rigs and reporters in the sandbox.** Could Seadrill's rigs and their authorised reporters appear in the sandbox's
   `GET /rigs`, so we can test the reporter check properly? If there is a form or list you need from us for that, send it
   over and I will fill it in.

Once our test submissions are running, I would welcome a Teams session on the portal-only steps; I will be in touch
then.

And one quick check: is v1.1.0 still the current version of the Inbound API, or has anything changed since August?

Thanks again for your help.

Best regards,
Dan Plant
Technical Superintendent, Well Control Engineering — Seadrill
