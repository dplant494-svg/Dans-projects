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

- **Reel 1 "Beneath our feet"** (6 Oct 2026): 30 s Instagram reel built from the client's storyboard, source in `social/reel-1/`. Waiting on client sign-off, full-resolution images, and a decision on real archive photos for the three historic frames. See `social/reel-1/README.md`.
- [x] "Site by Plantworks Studio" footer credit added (6 Oct 2026).

## Go-live (prepared 6 Oct 2026)

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

## Head chef: David Henry

David is writing his own bio (6 Oct 2026); his version wins. Facts so far, and conflicts to settle with him:
- Started cooking at 16 (from a draft template; confirm).
- Worked in Berkshire, "where I found the love for the old classics" (David).
- MasterChef: The Professionals semi-finalist: **2009** per web sources, **2010** per the draft template. Confirm the year.
- Order: **David says MasterChef came before Rockliffe Hall** (under Kenny Atkinson); Dan's message says Rockliffe came first. David's own word stands until he says otherwise.
- Head chef, The Crathorne Arms near Yarm, from 2014. Voted best restaurant in Teesside **2020 and 2026**. Tom Parker Bowles named its Sunday lunch among the country's best.
- Ethos: best ingredients from trusted local suppliers; herbs and vegetables grown in the garden. Kitchen garden at Lambton Park: unknown.
- Instagram @chefdavidhenry.
