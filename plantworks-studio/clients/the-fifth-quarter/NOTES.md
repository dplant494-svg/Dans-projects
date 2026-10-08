# The Fifth Quarter — working notes

Client: restaurant, bar & delicatessen opening Spring 2027 at Lions Gate, Lambton Park, Chester-le-Street, County Durham (DH3 4DT).
Full brief, design system and architecture decisions: see `../../HANDOFF.md` section 1.

This folder is the deploy folder. Drag it as-is onto Netlify (or Cloudflare Pages), then point `the5thquarter.co.uk` at it.

## Files

| File | Purpose |
|---|---|
| `index.html` | The whole site. Single file, no build step. |
| `sitemap.xml` | Single-URL sitemap for Google. |
| `robots.txt` | Allows everything, points at the sitemap. |

## Done in this pass (Sept 2026)

- Renamed `the-fifth-quarter.html` to `index.html` for deployment.
- SEO head: canonical URL, Open Graph and Twitter tags, `theme-color`.
- Favicon: inline SVG data URI, navy square with a gold "5" in Marcellus. No extra file to host.
- Structured data: schema.org `Restaurant` with address, cuisine, menu anchor, map link, parking/bar/deli amenities, reservation action pointing at the bookings mailbox.
- `sitemap.xml` and `robots.txt`.

## Deliberately left out of the structured data

These need a fact from the client before they go in. Wrong data here is worse than none.

- **Geo coordinates**: add `"geo": {"@type":"GeoCoordinates","latitude":…,"longitude":…}` once the pin is confirmed on Google Maps.
- **Opening hours**: the site says "open seven days from 9am" but has no closing time. Add `openingHoursSpecification` when hours are fixed.
- **Telephone**: none on the site yet.
- **Image**: add `"image"` and `og:image` once there is photography. A 1200×630 crop of the sign would do.

## Open items (carried from the handoff)

- [ ] **Bookings: Toast Tables** (decided 7 Oct 2026). In the UK Toast doesn't offer its embedded widget, so the site links out. When Toast is set up, get the link from Toast Web → Settings → Reservations → Online access → "Copy online reservation link", and swap it in for the three `mailto:bookings@` links (hero button, nav "Book", and the `ReserveAction` target in the JSON-LD). Same link on Instagram's "Reserve" action button and as a QR code on printed menus. Until then, the mailto stays, so `bookings@` must receive email at launch.
- [ ] **Verify steak pricing**: "from £23 per 100g" is £230/kg. Entered as written; check with client.
- [ ] Prices missing from lunch, deli, dinner, Sunday mains, steak extras. Layout supports `.dish-price` spans.
- [ ] Deli sandwich descriptions: Cheesesteak, Chicken Parm, Fish Finger are name-only.
- [ ] Possible rename: Veggie caprese → "panuozzo" (client deciding).
- [ ] Real photography when available.
- [x] Suggestion box: now a Netlify form (`suggestions`) landing on `/thanks/`; no mail client needed (6 Oct 2026).
- [ ] Menus are labelled "example menus" until the client signs off.

## Working style

Feedback arrives as photos of handwritten notes and WhatsApp screenshots. Transcribe carefully, fix obvious typos silently, flag judgement calls back rather than guessing. Everything stays on one page. Menu tabs stay pure CSS (radios before panels in source order).

## Social

- **Launch grid** (7 Oct 2026): nine 1080×1350 posts, profile picture, captions and a from-scratch setup guide for Mark in `social/launch-grid/`. Mark creates and owns the accounts on info@; Plantworks gets access through Meta Business Suite and as a Google Business Profile manager.

- **Reel 1 "Beneath our feet"** (6 Oct 2026): 30 s Instagram reel built from the client's storyboard, source in `social/reel-1/`. Waiting on client sign-off, full-resolution images, and a decision on real archive photos for the three historic frames. See `social/reel-1/README.md`.
- [x] "Site by Plantworks Studio" footer credit added (6 Oct 2026).

## Go-live (prepared 6 Oct 2026)

**LIVE 8 Oct 2026.** DNS switched at GoDaddy, Netlify project deployed, HTTPS on, Netlify visitor-access protection switched off (it was on by default and showed "This site is private"). Dan confirmed the public site loads. Still to do: confirm info@ and bookings@ exist in Mark's Microsoft 365 (step 2), test the suggestion form and a test email (step 7), Search Console (step 8), Reel 1 (step 9). Check Netlify's team setting so new projects aren't private by default.

Domain `the5thquarter.co.uk` is in the owner's (Mark's) GoDaddy account. Account details are never written into this repo; access goes through GoDaddy's **Delegate Access** (Account Settings → Delegate Access → invite Dan's email, "Products & Domains" level), not a shared password or PIN.

1. **Free build (confirmed 7 Oct 2026)**: no invoice. In return, in writing (a WhatsApp or email from Mark is enough): permission to show the site and reel in the Plantworks portfolio and socials; the "Site by Plantworks Studio" footer credit stays; a named testimonial at launch. Also agreed in the same message: hosting sits free on the Plantworks Netlify account; the domain and any mailboxes stay in Mark's name and he pays their renewals; changes after launch are either the €40/month Care plan or quoted small jobs.
2. **Email first**: in GoDaddy DNS, screenshot every record. Find out whether `info@` and `bookings@the5thquarter.co.uk` exist (MX records). The site links to both. If no mailbox exists, set one up before launch: forwarding to Mark's own inbox (free, e.g. ImprovMX) or proper mailboxes (Microsoft 365 / Google Workspace, ~£5 per user per month).
3. **Netlify**: new project from GitHub, base and publish directory `plantworks-studio/clients/the-fifth-quarter`, branch `claude/new-business-venture-7pxnxz`, no build command. **Forms → enable form detection before the first deploy**; notifications for `suggestions` to info@ (or Mark's own email until info@ exists).
4. Netlify → Domain management → add `the5thquarter.co.uk` and `www.the5thquarter.co.uk`.
5. **GoDaddy DNS**: `A` record `@` → `75.2.60.5` (replacing GoDaddy's parked/forwarding record; turn off any domain forwarding), `CNAME` `www` → the project's `.netlify.app` address. **MX and TXT records untouched.**
6. HTTPS issues itself once DNS resolves (usually within the hour).
7. Test: `the5thquarter.co.uk` and `www.` with the padlock; the suggestion form arrives; a test email to info@ and bookings@.
8. Search Console: Domain property for `the5thquarter.co.uk` (TXT record at GoDaddy), submit `https://the5thquarter.co.uk/sitemap.xml`.
9. Then post Reel 1 on the restaurant's Instagram.

### DNS before the switch (GoDaddy, screenshot 8 Oct 2026)

Nameservers `ns27/ns28.domaincontrol.com` (GoDaddy DNS). **Email is Microsoft 365 bought through GoDaddy** (tenant `NETORGFT21104179.onmicrosoft.com`), already live.

| Type | Name | Value | Switch day |
|---|---|---|---|
| A | @ | Parked | **change to `75.2.60.5`** |
| CNAME | www | `the5thquarter.co.uk.` | **change to the project's `.netlify.app` address** |
| MX | @ | `the5thquarter-co-uk.mail.protection.outlook.com` (0) | leave |
| TXT | @ | `NETORGFT21104179.onmicrosoft.com` | leave |
| TXT | @ | `v=spf1 include:secureserver.net -all` | leave (see note) |
| TXT | _dmarc | `v=DMARC1; p=quarantine; …` | leave |
| CNAME | autodiscover, email, lyncdiscover, msoid, sip, selector1._domainkey, selector2._domainkey, _domainconnect | Microsoft 365 / GoDaddy | leave |
| SRV | _sip._tls, _sipfederationtls._tcp | Microsoft 365 | leave |
| NS, SOA | @ | GoDaddy | leave |

Only the two bold rows change. SPF note: the record covers GoDaddy's relay (`secureserver.net`) but not `spf.protection.outlook.com`. That's how GoDaddy sets up its own 365 product and isn't part of the site launch; if Mark's outgoing mail starts landing in spam, that's the first thing to look at, with GoDaddy support.

## Head chef: David Henry

**His own bio arrived 8 Oct 2026** and is now the source. The site's "The Head Chef" section (`#chef`) and launch post 7 (three-slide carousel) are written from it, in the third person, with his line "The North East always brings you home" as the pull quote. His career, in his order: college in Middlesbrough; a five-hotel group on the south-west coast of Scotland ("what moulded me"); Storrs Hall, Windermere; back to the Scottish group; Hide café bar and grill, then Newcastle; Sharrow Bay; Scotland again, on pastry; opened the Bay Horse, Hurworth; the Pot Kiln, Berkshire (Mike Robinson, crayfish from the Kennet, "rustic food"); Jeffers by the Marina, Bangor, where he entered MasterChef: The Professionals (semi-finalist, final 8); a pub near Kirkby Stephen; back to the North East, where he met Mark; Rockliffe Hall under Kenny Atkinson; the Crathorne Arms (Eugene McCoy), 12 years.

**Mark is not to be named anywhere public** (his wish, 8 Oct 2026): not in the bio, captions or posts. Left out of the public version on purpose: his first child; the name of the place where he and Mark met, and that it "didn't go to plan"; why Sharrow Bay was sold; Hide and Newcastle (kept the story moving). Spellings corrected from his draft: Storrs Hall, Kirkby Stephen, the Kennet. He ends with "Roll on April 2027": the site still says spring 2027 until Mark confirms April publicly.

Earlier facts and conflicts:
- Started cooking at 16 (from a draft template; confirm).
- Worked in Berkshire, "where I found the love for the old classics" (David).
- MasterChef: The Professionals semi-finalist: **2009** per web sources, **2010** per the draft template. Confirm the year.
- Order: settled by his bio. MasterChef (while at Jeffers, Bangor) came before Rockliffe Hall.
- Head chef, The Crathorne Arms near Yarm, from 2014. Voted best restaurant in Teesside **2020 and 2026**. Tom Parker Bowles named its Sunday lunch among the country's best.
- Ethos: best ingredients from trusted local suppliers; herbs and vegetables grown in the garden. Kitchen garden at Lambton Park: unknown.
- Instagram @chefdavidhenry.
