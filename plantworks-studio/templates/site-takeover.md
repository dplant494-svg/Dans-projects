# Taking over an existing website

For any client who already has a site: "No job too small" fixes, rescues from a developer who has gone quiet, and rebuilds. Read it once end to end before the first one; after that the checklist at the bottom is enough.

## The one idea that matters

A website is three separate things, often with three different companies, and the client usually doesn't know which is which:

| Thing | What it is | Typical providers | What breaks if you get it wrong |
|---|---|---|---|
| **Domain** | the name, `example.com` | Namecheap, GoDaddy, IONOS, 123-reg, Arsys, Dinahosting, or bundled inside Wix/Squarespace | everything: site and email both hang off it |
| **Hosting** | where the site's files live | the same list, plus WordPress hosts, Wix, Squarespace, Shopify | the site goes down |
| **Email** | the `@example.com` mailboxes | Google Workspace, Microsoft 365, or the old host's own mail | **the client stops receiving email**, often without anyone noticing for days |

The domain is the one that matters. Whoever controls the domain controls the business's web address and its email. **The client must own their domain, in their own name, in their own account.** Plantworks never registers a client's domain in its own account.

## Step 1: find out what they have, before asking them for anything

Do this from the browser, on your own, in ten minutes. It tells you more than the client can.

1. **Who holds the domain**: lookup.icann.org, type the domain. The "Registrar" line is the company. The registrant name may be hidden for privacy; that's normal.
2. **Where it's hosted and who does the email**: mxtoolbox.com → "DNS Lookup" for the domain, then "MX Lookup".
   - Nameservers (NS) tell you who runs the DNS.
   - The A record's IP, pasted into ipinfo.io, tells you the hosting company.
   - The MX records tell you who handles email: `google.com` = Google Workspace, `outlook.com` = Microsoft 365, anything else is usually the old host's own mail.
3. **What it's built on**: builtwith.com, or the Wappalyzer browser extension. WordPress, Wix, Squarespace, Shopify or hand-built changes the whole plan (see Step 3).
4. **What Google knows**: search `site:example.com` to see which pages are indexed. Note the important page addresses; they need redirects later.

Write all of it into a new `clients/<name>/NOTES.md` before the call.

## Step 2: ask the client the right questions

Send this, or ask it on the first call:

**English**
```
To take over your website I need to know where its three parts live. Don't worry if you don't know some of these; I can find most of it.

1. Who built the site, and are they still in touch?
2. Who do you pay for the website, the domain and email? A bank or card statement is the quickest way to find out: look for annual charges from companies like GoDaddy, IONOS, 123-reg, Wix, Squarespace, Arsys or a web designer.
3. Do you have any logins for these? Even an old password helps.
4. Which email addresses do you use on the domain, and do you read them on a phone, in Outlook, or in a browser?
5. Is anything else connected: online bookings, a shop, Google Business Profile, a newsletter?

Nothing gets switched over until the new site is approved and your email is safe.
```

**Español**
```
Para hacerme cargo de tu web necesito saber dónde está cada una de sus tres partes. No pasa nada si no sabes alguna; la mayoría la puedo averiguar yo.

1. ¿Quién hizo la web y sigues en contacto con esa persona o empresa?
2. ¿A quién pagas por la web, el dominio y el correo? Lo más rápido es mirar el extracto del banco o de la tarjeta: busca cargos anuales de empresas como GoDaddy, IONOS, Arsys, Dinahosting, Wix, Squarespace o un diseñador web.
3. ¿Tienes algún acceso o contraseña? Aunque sea antigua, ayuda.
4. ¿Qué direcciones de correo usas con ese dominio, y dónde las lees: en el móvil, en Outlook o en el navegador?
5. ¿Hay algo más conectado: reservas online, una tienda, la ficha de Google, un boletín?

No se cambia nada hasta que hayas aprobado la web nueva y tu correo esté a salvo.
```

## Step 3: which situation is it?

| Situation | What to do |
|---|---|
| **A. Client has the logins** | Easy. Log in with them on a call, write down where everything is, carry on to Step 4. |
| **B. A developer or agency has it in their account, and still answers** | Ask politely for: the domain moved into the client's own account (or an authorisation code to transfer it), a copy of the site files and database if it's WordPress, and the email setup. Message below. Most do this within a week. |
| **C. The developer has disappeared** | Check who the registrant is (Step 1). If it's the client or their business, the registrar's support will hand control back on proof of identity: a photo ID and a bill in the business name. If the developer registered it in their own name, it's a dispute with the registrar (for `.es`, the registry is Red.es; for `.co.uk`, Nominet). The site itself doesn't matter: we're rebuilding, and the text and photos can be taken from the live pages. |
| **D. It's on Wix or Squarespace** | The site can't be moved off those platforms, only rebuilt. The domain can be moved, and often it was bought through the platform: transfer it out to the client's own Namecheap account. Don't cancel the plan until the new site is live. |

**Message to an old developer (B)**, sent by the client or by you with the client copied:
```
Hi [name], [business] is moving its website to a new provider. Could you please:
1. Move the domain [example.com] into an account in [business]'s name, or send the transfer authorisation code and unlock it;
2. Send a copy of the website files [and the database export, if WordPress];
3. Let us know how the @[example.com] email is set up and where.
Nothing will change on the live site or email until the new one is ready. Thanks for looking after it.
```

## Step 4: protect the email before touching anything

This is where takeovers go wrong.

1. **Copy every DNS record** before changing anything: screenshot the whole DNS page at the current provider, or export it. Every MX, TXT (SPF, DKIM, Google/Microsoft verification), CNAME (booking systems often live on `book.` or `reservas.`) and A record.
2. If email is **Google Workspace or Microsoft 365**: it's safe as long as the MX and TXT records are recreated exactly wherever the DNS ends up.
3. If email is **the old host's own mail** (cPanel/Webmail, often with cheap hosting): it dies the day that hosting is cancelled. Move the mailboxes first: to Namecheap Private Email for one or two addresses (same setup as info@plantworksstudio.com), or Google Workspace if they want Gmail. Copy the old mail across with the new provider's import tool. Only then touch anything else.

## Step 5: build, then switch

1. Build the new site and put it on a Netlify preview address. The client approves it there. The old site stays live the whole time.
2. **Don't transfer the domain yet.** A transfer takes five to seven days and is the slow, risky part. You only need access to the domain's DNS, which you have once the client owns their registrar account. Transfer it to Namecheap later if they want everything in one place; `.com` domains can't be transferred within 60 days of registration or a previous transfer. For `.co.uk`, a transfer is done by the old registrar changing the domain's "IPS tag" to the new registrar's tag, not with a code; check the tag on Namecheap's transfer page.
3. **Switch day**: in the domain's DNS, point `@` at Netlify (`A` record `75.2.60.5`) and `www` at the project's `.netlify.app` address (`CNAME`). Leave every MX and TXT record exactly as it was. Add the domain in Netlify; HTTPS issues itself within the hour.
4. **Redirects**: every old page address that Google knew (Step 1, point 4) gets a redirect in the site's `netlify.toml` to its new home, so search rankings carry over. WordPress addresses like `/contact-us/` or `/menu/` are the usual ones.
5. **Check**: the site loads on `example.com` and `www.example.com` with the padlock, the form arrives, and send a test email **to** and **from** the client's address.
6. **Search Console**: if it already exists for the domain it carries on; submit the new sitemap. If not, verify it now.
7. **Keep the old hosting for 30 days** after the switch, then cancel it. Cancelling early is the commonest way to lose something nobody knew was there.

## Step 6: hand over properly

- Every login goes in Bitwarden: a shared collection per client, so the client has them too.
- `clients/<name>/NOTES.md` records where the domain, DNS, hosting and email are, who owns each account, renewal dates, and what was changed on switch day.
- Renewal dates go in the calendar. A lapsed domain renewal takes the site and email down together.

## Pricing

- **Takeover only** (get control back, document it, move email to safety, no new site): a small job, €45 an hour, two-hour minimum, quoted after the Step 1 look.
- **Rescue from a vanished developer** (situation C): quote after the free look; usually two to four hours plus however long the registrar takes.
- **Takeover plus new site**: included in the package price. The takeover is part of the build.

## Checklist (once you've done one)

- [ ] Step 1 lookup done: registrar, DNS host, web host, email host, platform, indexed pages
- [ ] Client questions answered, situation A/B/C/D identified
- [ ] Client owns the domain in their own account; Plantworks has access, not ownership
- [ ] All DNS records copied before any change
- [ ] Email safe (Workspace/365 records noted, or old-host mail migrated)
- [ ] New site approved on the Netlify preview
- [ ] Switch: `@` and `www` repointed, MX/TXT untouched, HTTPS on
- [ ] Redirects for old URLs; sitemap submitted
- [ ] Test email in and out; form tested
- [ ] Old hosting kept 30 days, then cancelled
- [ ] Logins in Bitwarden; NOTES.md complete; renewals in the calendar
