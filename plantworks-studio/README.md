# Plantworks Studio

Web studio for small businesses in the UK and on the Costa del Sol, remote everywhere, with bilingual EN/ES as the specialism. Base: UK limited company (decided Sept 2026, for tax reasons); the team works from the Costa del Sol and abroad, meeting clients in person on the coast or in the UK. This folder is the whole business: the studio's own site, every client site, and the plan.

The original brief that started this is `HANDOFF.md`. This file is the live version of it: update this one.

## Rolling plan (kept current; last updated 26 Sept 2026)

**Live**: plantworksstudio.com on Netlify, HTTPS, both languages, demos hidden from search. Mailbox info@ on Namecheap Private Email, working on the Samsung phone over IMAP. Contact form posts to Netlify Forms and emails info@. Search Console verified, sitemap accepted with two pages. Templates for invoices (EN, ES) and proposals in `templates/`.

**Next, in order**
0. Praetorian Fitness (friend's apparel brand): draft site built in `clients/praetorian-fitness/`. Send the preview, then ask for: logo as a vector, full-resolution photos, confirmed prices, domain, mailbox, Instagram handle. Deploy as a separate Netlify project (form detection on first, then notifications). Remove `noindex` at launch. Shop later: Stripe Payment Links on the static site, or Shopify if the range grows.
1. Talk to business owners. Launch offer: first five multi-page sites at €1,200 for a review and portfolio permission. Record the conversation, paste the transcript here, get the proposal back.
2. UK limited company via an online accountant (registered office, ID verification, corporation tax registration included). Then: business bank account (Tide or Wise), Stripe, company number and address into the site footer and the invoice templates.
3. Spanish native read of the ES page. Wife has the file.
4. Logo: done, title block + P mark, in `site/brand/`. Use `mark-512.png` as the avatar everywhere and `lockup.png` on documents.
5. Phone, two numbers on the Galaxy S23 Ultra (unlocked, Vodafone UK in the physical slot):
   - Now: install WhatsApp Business on the UK number (the one on the site), move personal chats into it, set greeting, hours, site link, quick replies for "prices" and "how it works".
   - Done: Spanish SIM in, WhatsApp Business on **+34 722 676 631** with the P mark as photo. Profile, greeting, away and quick-reply texts (EN/ES) in `templates/whatsapp.md`.
   - Now: Samsung Keyboard Chat assist (chat translation, Spanish pack) so Spanish chats can be answered in English.
   - Site shows both numbers (WhatsApp button → Spanish number; calls UK and Spain listed). JSON-LD carries both.
   - Password manager (Bitwarden, free) before the first client hands over a login.
6. Social: claim the handles, set up the LinkedIn page and WhatsApp Business profile, join the Costa del Sol expat groups (see Social below). One post per finished site.
7. Google Business Profile once there is a verifiable address.

**Parked**: Care Plus and local-search work until the first Care client; AI assistant add-on until a client asks; a 952 landline number.

## Folder layout

```
plantworks-studio/
├── README.md                 ← this file: plan, pricing, roadmap, checklists
├── HANDOFF.md                ← original brief (kept for reference, don't edit)
├── site/                     ← the studio's own site. Deploy this folder as-is.
│   ├── index.html            ← English (default, x-default)
│   ├── es/index.html         ← Spanish
│   ├── sitemap.xml           ← the two studio URLs with hreflang alternates (demos are noindex)
│   ├── robots.txt
│   └── work/                 ← fictional demo sites, deployed with the studio at /work/<name>/
│       ├── README.md         ← what's invented, how to reuse for a real client
│       ├── brasa-y-sal/      ← beach restaurant, Marbella. ES at /, EN at /en/
│       └── pinar-property/   ← property management, Estepona. EN at /, ES at /es/
├── templates/                ← invoice (EN, ES) and proposal Word templates, WhatsApp texts (EN/ES), and the script that builds the docx files
└── clients/
    ├── the-fifth-quarter/    ← client site. Deploy this folder as-is.
    │   ├── index.html
    │   ├── sitemap.xml
    │   ├── robots.txt
    │   └── NOTES.md          ← open items and what's deliberately left out
    └── praetorian-fitness/   ← client site (pre-launch, noindex). Deploy this folder as its own Netlify project.
        ├── index.html
        ├── thanks/index.html ← launch-list form landing page
        ├── img/              ← crops from the supplied phone images; replace with originals
        └── NOTES.md
```

Every site is a deploy folder: drag it onto Netlify or Cloudflare Pages, connect the domain, HTTPS issues itself. No build step, no dependencies beyond Google Fonts.

## Positioning

> "We spent eighteen years building and maintaining digital systems that weren't allowed to fail. We build websites the same way."

**Voice**: company, never a person. Engineers based in the UK and on the Costa del Sol; over eighteen years in digital and IT systems; now applying AI to web and small-business automation. No founder name, no personal history, no home life on the site or in structured data (decided Sept 2026).

**Frame** (widened Sept 2026): two home markets, the UK and the Costa del Sol, and remote work anywhere. Same four sectors in both: restaurants, property services, health/wellness, trades. The bilingual EN/ES work stays the specialism and the search edge on the coast, not the whole offer. UK clients invoiced in GBP.

**Build philosophy**: single-file or minimal static sites, no frameworks unless needed, brand-driven design over templates, CSS-first interactivity, progressive enhancement. AI-assisted in the workshop, sold and supported as a personal service.

## Offer and pricing (ex-IVA, decided Sept 2026)

| Package | Price | What it is |
|---|---|---|
| One-page site, English | €600 | Long single page, contact/WhatsApp/map, on-page SEO, GBP setup, domain+hosting connected |
| One-page site, bilingual | €800 | Same page with Spanish alongside, hreflang done |
| Multi-page bilingual site | €1,500 | Up to 8 pages in both languages, hreflang + structured data + sitemap, booking/enquiry flow, native-speaker proofread of ES copy. Beyond 8 pages: quoted |
| Care | €40/month | Hosting, domain, HTTPS managed; content changes within 2 working days; monthly speed/links/search check; small tweaks; cancel any month |
| Care Plus | €75/month | Care plus Google Business Profile managed (posts, photos, hours, review replies) and a review request after every job |
| Take payments online | €150 setup | Stripe Payment Link or Buy Button on the client's own Stripe account for deposits, vouchers, single products; booking deposits via their booking system. Full shop quoted separately. Client money never passes through the studio |
| Extra work | €45/hour | Anything outside a package, quoted before it starts |

**Launch offer**: first five multi-page sites at €1,200 in return for a Google review and portfolio permission. Ends when the fifth signs. Stated as such on the site.

**Terms**: half on brief, half on launch. Care billed monthly, cancel any month. Photography, copywriting, extra languages and paid third-party services passed on at cost.

The care plan is the recurring-revenue engine. Twenty Care clients is about €800/month before building anything; Care Plus nearly doubles that per client for roughly an hour a month on their Google listing, so offer it at every hand-over.

**In every build**: on-page SEO (meta, structured data, speed), mobile-first, static hosting (~zero cost), bilingual with hreflang where sold, native-speaker proofread on paid translated copy.

## The studio site (`site/`)

Built September 2026. Sections: hero with a "data sheet" of what every build includes; who it's for (four sectors); a plain-language explanation of hreflang with the actual markup shown; packages; the process drawn as a P&ID-style flowline (valve → pump → strainer → tank → gauge = brief → draft → revise → launch → care); work (The Fifth Quarter case study); about; contact.

Design system:

- Colours: `--steel:#1B2A38`, `--steel-deep:#111C27`, `--sol:#E0762E` (Andalusian sun / safety orange), `--sand:#F5EFE6`, `--ink:#1E2730`.
- Type: Fraunces (display), IBM Plex Sans (body), IBM Plex Mono (labels, the "datasheet" voice).
- Identity (decided 25 Sept 2026): the drawing-sheet **title block**. Lockup = name in a bordered block over a three-cell strip (WEB · AI | UK · COSTA DEL SOL | REV 01). Mark = a bordered square with a bold P and an orange strip, used as favicon and social avatar. Files in `site/brand/` (SVG masters, PNG exports); share image `site/og-image.png` built from the dark lockup. Bump REV when the site is redesigned.
- No JavaScript at all. The contact form is a Netlify Form (`data-netlify="true"`, honeypot field, hidden `form-name`); submissions land in the Netlify dashboard and are emailed to info@ via a form notification. Thank-you pages at `/thanks/` and `/es/gracias/`, both noindex.
- EN at `/`, ES at `/es/`. Each page carries `hreflang` for en, es and x-default. Sitemap repeats them.

Placeholders that must be swapped before launch are listed in the checklist below.

## Roadmap

1. **Portfolio of three**
   - [x] The Fifth Quarter (in flight; open items in `clients/the-fifth-quarter/NOTES.md`)
   - [x] Praetorian Fitness, premium gym apparel (draft built; placeholders and asks in `clients/praetorian-fitness/NOTES.md`)
   - [x] Fictional bilingual Marbella restaurant: Brasa y Sal (`site/work/brasa-y-sal/`)
   - [x] Fictional property-services site: Pinar Property Care (`site/work/pinar-property/`)
2. **Own studio site**
   - [x] Built, bilingual, hreflang correct
   - [x] Domain bought and swapped in (plantworksstudio.com)
   - [x] Live at https://plantworksstudio.com (Sept 2026). Netlify project `benevolent-gumption-18b8fd`, manual zip deploys, DNS at Namecheap (A @ 75.2.60.5, CNAME www), HTTPS issued, form detection on, form notifications to info@, Search Console verified by TXT record.
   - [ ] Remaining placeholders swapped (see checklist)
3. **Legal** (decided Sept 2026: a **UK limited company**, for tax reasons. It is UK-resident by incorporation and gets UK-Spain treaty protection regardless of where the team happens to be working.)
   - [ ] Incorporate a UK Ltd (Plantworks Studio Ltd or similar), registered office at a UK address (an accountant's registered-office service is fine).
   - [ ] Appoint a small-business accountant to run it: annual accounts, corporation tax return, confirmation statement. Budget roughly one care-plan client a month.
   - [ ] Business bank account in the company's name. Invoice all clients from the company, in EUR where the client is Spanish.
   - [ ] No fixed place of business in Spain: meet clients at their premises or a café. Keep a note that company decisions are taken from the UK. Both protect the company's UK residence and avoid a Spanish permanent establishment.
   - [ ] Ask the accountant, once, whether the studio changes anything about the directors' personal tax positions. Get the answer in writing.
   - [ ] Footer: company name, registered number and a privacy line once incorporated.
   - Not needed: UK VAT below the threshold; Spanish autónomo; anything on the personal self-assessment return for this business.
4. **First clients**: walk-ins to expat businesses with weak sites, Costa del Sol expat Facebook groups, launch pricing.
5. **Every job**: Google review and referral ask.

## Pre-launch checklist for the studio site

- [x] **Domain**. `plantworksstudio.com`, registered at Namecheap (Sept 2026). Every canonical, hreflang, Open Graph URL, structured-data URL and the sitemap use it. `www` should redirect to the bare domain (Netlify and Cloudflare Pages both do this once the bare domain is set as primary).
- [ ] **Name clash**. A web search for "Plantworks Studio" and "Plantworks" web design found no existing web studio, but this is a weak signal. Do a Spanish trademark search (OEPM, oepm.es) and an EUIPO search before printing anything.
- [x] **Email**. `info@plantworksstudio.com`, Namecheap Private Email (Sept 2026). Used in the contact form, the mailto link and the structured data on both pages.
- [x] **Founder name**. Removed from the site and the structured data; the site speaks as a company.
- [x] **Contact form**. Netlify Forms, no mail app needed. Requires a form notification set up once in Netlify (Project configuration, Forms, Form notifications, email to info@). Free tier is 100 submissions a month.
- [x] **WhatsApp**. `wa.me/447464435081` (UK mobile) is on both pages and in the structured data as `telephone`. Swap to the Spanish number when it exists: search-and-replace `447464435081` and `+44 7464 435081` in `site/index.html` and `site/es/index.html`.
- [ ] **Spanish**. Nobody on the team speaks it. Written Spanish (WhatsApp, email) is handled with translation tools; the site says calls are in English. A bilingual freelancer is needed for the proofread below and for any Spanish-language client call, budgeted per job.
- [ ] **Spanish proofread**. The ES copy was written directly, not machine-translated, but per the studio's own promise it should go past a native speaker before launch. Uses tú, not usted.
- [ ] **Case-study link**. The Fifth Quarter card links to `https://the5thquarter.co.uk/`, which is not live yet. Fine to leave; it'll resolve when the client site deploys. The two demo cards link relatively into `work/`, so they work as soon as `site/` is deployed.
- [ ] **Legal footer**. Add NIF, address and a privacy note once registered as autónomo.
- [ ] **Google Business Profile** for the studio. Without a Spanish business address this is a service-area listing at best; decide whether it is worth it, and only use an address where work genuinely happens.

## Deploying the studio site

Done Sept 2026. Kept for the next site. Netlify drag-and-drop, DNS stays at Namecheap. About fifteen minutes.

1. Log in to Netlify, go to Sites, drag the whole `site/` folder onto the page. Netlify gives it a `something.netlify.app` address. Check the site, both languages and both demos work there.
2. In that site's settings, Domain management, add custom domain `plantworksstudio.com`. Netlify will show which records it wants.
3. In Namecheap, Domain List, Manage, Advanced DNS. Delete the parking records Namecheap put there. Add:
   - `A` record, host `@`, value `75.2.60.5` (Netlify's load balancer; use whatever address Netlify showed in step 2 if different).
   - `CNAME` record, host `www`, value `<your-site>.netlify.app`.
4. Back in Netlify, once DNS has propagated (minutes to an hour), it issues the HTTPS certificate itself. Set `plantworksstudio.com` as the primary domain so `www` redirects to it.
5. Google Search Console: add the property, verify by DNS TXT record at Namecheap, submit `https://plantworksstudio.com/sitemap.xml`.

To update the site: zip the contents of `site/` (index.html at the top of the archive, not inside a folder), open the Netlify project, Deploys, drag the zip onto the drop box. Domain, certificate and form settings persist. Netlify keeps the domain and certificate. Cloudflare Pages works the same way if preferred, but it wants the nameservers moved to Cloudflare, which is a bigger change.


## Social media

Minimum viable, about an hour a week. The leads are in Facebook groups and referrals, not in a content calendar.

- **Claim the handles now** so nobody else does: `plantworksstudio` on Instagram, Facebook, LinkedIn (company page), X. Same avatar (the hex mark on navy), same one-line bio: "Websites for small businesses, engineered not to fail. UK & Costa del Sol. English & Spanish."
- **LinkedIn company page**: the credibility check UK clients and property firms do. Page, logo, the positioning line, link to the site. Post each finished site.
- **Instagram**: where Costa del Sol restaurants and wellness businesses live. Post each finished site (phone screenshot, three lines, in both languages), and occasional before/after of a client's old site versus new. No stock quotes, no daily posting.
- **Facebook groups**: the actual channel on the coast. Join the Marbella, Estepona and San Pedro expat and business groups. Read the rules. Answer people's questions about websites, Google listings and bookings before ever mentioning the studio. One helpful reply a week beats any advert.
- **WhatsApp Business** on the studio number: business name, hours, the site link, a greeting message, quick replies for "prices" and "how it works".
- **Share image**: `site/og-image.png` (1200×630) is set as `og:image` on both pages, so the link shows a proper card on WhatsApp, Facebook, LinkedIn and iMessage. Regenerate from `templates/og-card.html` (screenshot at 1200×630) if the strapline changes.
- **Not worth it now**: TikTok, X beyond claiming the handle, paid ads until there are reviews to point them at.

## Working conventions

- One folder per client under `clients/`, each a deploy folder with its own `NOTES.md`.
- Keep the original client brief; keep the open-items list current.
- Client feedback often arrives as photos of handwritten notes. Transcribe carefully, fix obvious typos silently, flag judgement calls back.
