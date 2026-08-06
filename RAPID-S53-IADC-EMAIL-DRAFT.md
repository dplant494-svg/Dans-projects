To: iadc_dev@softway.com; mike.kucharski@iadc.org
Subject: RAPID-S53 auth scheme — which spec is right? (+ 3 quick ones)

Hi Mike, hi Softway team,

I'm the Technical Superintendent overseeing this on our side, not a
software engineer - I've been building this integration with AI-assisted
development support, so if any answer below has real implementation
nuance, a plain-language note alongside the technical detail would help a
lot.

We're connecting our internal well-control incident reporting tool
directly to the RAPID-S53 Inbound API, so incident reports post straight
into RAPID-S53 instead of being re-keyed by hand. As of our latest build,
the tool itself now assembles the finished incident record in RAPID's own
format before it ever reaches our relay - so the remaining open items are
really about how we're allowed to authenticate and submit, not about field
mapping.

Four questions, most important first:

1. Which authentication actually applies to /incident: OAuth2 (as the
   inbound schema states), or the API-Key + username/password +
   HMAC-SHA256 scheme (as the outbound documentation for the same portal
   states)? The two disagree, and we don't want to build against the
   wrong one.

2. when_did_the_event_occur is listed as required, but the schema doesn't
   define a property for it at all. What value and type does this field
   actually expect?

3. Must reporter_first_name / reporter_last_name match an authorised
   reporter you return from GET /rigs for that rig, or is free text
   accepted?

4. Is there a sandbox or test environment available so we can validate
   submissions before we point this at production, and if so, what are
   its rate limits?

Happy to jump on a call if that's easier than email, especially for
question 1 - I'd rather talk it through than misread a spec. Thanks for
your patience while we get this right.

Best,
Dan Plant
Technical Superintendent, Well Control Engineering
Seadrill
