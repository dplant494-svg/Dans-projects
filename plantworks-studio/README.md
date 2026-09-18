# Plantworks Studio

Bilingual (EN/ES) web studio for small businesses on the Costa del Sol. Base: UK limited company (planned), working in the UK and on the Costa del Sol. This folder is the whole business: the studio's own site, every client site, and the plan.

The original brief that started this is `HANDOFF.md`. This file is the live version of it: update this one.

## Folder layout

```
plantworks-studio/
├── README.md                 ← this file: plan, pricing, roadmap, checklists
├── HANDOFF.md                ← original brief (kept for reference, don't edit)
├── site/                     ← the studio's own site. Deploy this folder as-is.
│   ├── index.html            ← English (default, x-default)
│   ├── es/index.html         ← Spanish
│   ├── sitemap.xml           ← all six URLs with hreflang alternates
│   ├── robots.txt
│   └── work/                 ← fictional demo sites, deployed with the studio at /work/<name>/
│       ├── README.md         ← what's invented, how to reuse for a real client
│       ├── brasa-y-sal/      ← beach restaurant, Marbella. ES at /, EN at /en/
│       └── pinar-property/   ← property management, Estepona. EN at /, ES at /es/
└── clients/
    └── the-fifth-quarter/    ← client site. Deploy this folder as-is.
        ├── index.html
        ├── sitemap.xml
        ├── robots.txt
        └── NOTES.md          ← open items and what's deliberately left out
```

Every site is a deploy folder: drag it onto Netlify or Cloudflare Pages, connect the domain, HTTPS issues itself. No build step, no dependencies beyond Google Fonts.

## Positioning

> "We spent eighteen years building and maintaining digital systems that weren't allowed to fail. We build websites the same way."

**Voice**: company, never a person. Engineers based in the UK and on the Costa del Sol; over eighteen years in digital and IT systems; now applying AI to web and small-business automation. No founder name, no personal history, no home life on the site or in structured data (decided Sept 2026).

**Niche**: English/Spanish bilingual sites for expat-owned businesses on the Costa del Sol. Restaurants, property services, health/wellness, trades. Most local web shops do bilingual badly. Proper hreflang is both the product and the SEO edge.

**Build philosophy**: single-file or minimal static sites, no frameworks unless needed, brand-driven design over templates, CSS-first interactivity, progressive enhancement. AI-assisted in the workshop, sold and supported as a personal service.

## Offer and pricing (ex-IVA, decided Sept 2026)

| Package | Price | What it is |
|---|---|---|
| One-page site, English | €600 | Long single page, contact/WhatsApp/map, on-page SEO, GBP setup, domain+hosting connected |
| One-page site, bilingual | €800 | Same page with Spanish alongside, hreflang done |
| Multi-page bilingual site | €1,500 | Up to 8 pages in both languages, hreflang + structured data + sitemap, booking/enquiry flow, native-speaker proofread of ES copy. Beyond 8 pages: quoted |
| Care | €40/month | Hosting, domain, HTTPS managed; content changes within 2 working days; monthly speed/links/search check; small tweaks; cancel any month |
| Care Plus | €75/month | Care plus Google Business Profile managed (posts, photos, hours, review replies) and a review request after every job |
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
- Mark: hexagon (bolt head) with a sprouting stem. Used as the favicon too.
- The only JavaScript is the contact form's mailto builder. Everything else is CSS.
- EN at `/`, ES at `/es/`. Each page carries `hreflang` for en, es and x-default. Sitemap repeats them.

Placeholders that must be swapped before launch are listed in the checklist below.

## Roadmap

1. **Portfolio of three**
   - [x] The Fifth Quarter (in flight; open items in `clients/the-fifth-quarter/NOTES.md`)
   - [x] Fictional bilingual Marbella restaurant: Brasa y Sal (`site/work/brasa-y-sal/`)
   - [x] Fictional property-services site: Pinar Property Care (`site/work/pinar-property/`)
2. **Own studio site**
   - [x] Built, bilingual, hreflang correct
   - [x] Domain bought and swapped in (plantworksstudio.com)
   - [ ] Remaining placeholders swapped (see checklist)
   - [ ] Deployed (see Deploying below)
3. **Legal** (Sept 2026: the business will be a **UK limited company**. It is UK-resident by incorporation and gets UK-Spain treaty protection regardless of anyone's personal position, which is the point.)
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
- [ ] **Email**. `hello@plantworksstudio.com` is used in the contact form, the mailto link and the structured data on both pages. It doesn't exist yet: set up mail on the domain (Namecheap Private Email, or free email forwarding in the Namecheap domain panel to an existing inbox) and confirm the address.
- [x] **Founder name**. Removed from the site and the structured data; the site speaks as a company.
- [ ] **Contact form**. Currently mailto-based (needs the visitor to have a mail app). Swap to Formspree free tier: set the form `action`, remove the inline script.
- [x] **WhatsApp**. `wa.me/447464435081` (UK mobile) is on both pages and in the structured data as `telephone`. Swap to the Spanish number when it exists: search-and-replace `447464435081` and `+44 7464 435081` in `site/index.html` and `site/es/index.html`.
- [ ] **Spanish**. Nobody on the team speaks it. Written Spanish (WhatsApp, email) is handled with translation tools; the site says calls are in English. A bilingual freelancer is needed for the proofread below and for any Spanish-language client call, budgeted per job.
- [ ] **Spanish proofread**. The ES copy was written directly, not machine-translated, but per the studio's own promise it should go past a native speaker before launch. Uses tú, not usted.
- [ ] **Case-study link**. The Fifth Quarter card links to `https://the5thquarter.co.uk/`, which is not live yet. Fine to leave; it'll resolve when the client site deploys. The two demo cards link relatively into `work/`, so they work as soon as `site/` is deployed.
- [ ] **Legal footer**. Add NIF, address and a privacy note once registered as autónomo.
- [ ] **Google Business Profile** for the studio. Without a Spanish business address this is a service-area listing at best; decide whether it is worth it, and only use an address where work genuinely happens.

## Deploying the studio site

Netlify drag-and-drop, DNS stays at Namecheap. About fifteen minutes.

1. Log in to Netlify, go to Sites, drag the whole `site/` folder onto the page. Netlify gives it a `something.netlify.app` address. Check the site, both languages and both demos work there.
2. In that site's settings, Domain management, add custom domain `plantworksstudio.com`. Netlify will show which records it wants.
3. In Namecheap, Domain List, Manage, Advanced DNS. Delete the parking records Namecheap put there. Add:
   - `A` record, host `@`, value `75.2.60.5` (Netlify's load balancer; use whatever address Netlify showed in step 2 if different).
   - `CNAME` record, host `www`, value `<your-site>.netlify.app`.
4. Back in Netlify, once DNS has propagated (minutes to an hour), it issues the HTTPS certificate itself. Set `plantworksstudio.com` as the primary domain so `www` redirects to it.
5. Google Search Console: add the property, verify by DNS TXT record at Namecheap, submit `https://plantworksstudio.com/sitemap.xml`.

To update the site later, drag the folder again. Netlify keeps the domain and certificate. Cloudflare Pages works the same way if preferred, but it wants the nameservers moved to Cloudflare, which is a bigger change.

## Working conventions

- One folder per client under `clients/`, each a deploy folder with its own `NOTES.md`.
- Keep the original client brief; keep the open-items list current.
- Client feedback often arrives as photos of handwritten notes. Transcribe carefully, fix obvious typos silently, flag judgement calls back.
