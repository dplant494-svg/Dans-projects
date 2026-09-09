# Plantworks Studio

Bilingual (EN/ES) web studio for small businesses on the Costa del Sol. Base: Marbella. This folder is the whole business: the studio's own site, every client site, and the plan.

The original brief that started this is `HANDOFF.md`. This file is the live version of it: update this one.

## Folder layout

```
plantworks-studio/
├── README.md                 ← this file: plan, pricing, roadmap, checklists
├── HANDOFF.md                ← original brief (kept for reference, don't edit)
├── site/                     ← the studio's own site. Deploy this folder as-is.
│   ├── index.html            ← English (default, x-default)
│   ├── es/index.html         ← Spanish
│   ├── sitemap.xml           ← both URLs with hreflang alternates
│   └── robots.txt
└── clients/
    └── the-fifth-quarter/    ← client site. Deploy this folder as-is.
        ├── index.html
        ├── sitemap.xml
        ├── robots.txt
        └── NOTES.md          ← open items and what's deliberately left out
```

Every site is a deploy folder: drag it onto Netlify or Cloudflare Pages, connect the domain, HTTPS issues itself. No build step, no dependencies beyond Google Fonts.

## Positioning

> "I spent two decades maintaining offshore systems that couldn't be allowed to fail. Now I build websites the same way."

**Name**: Plantworks Studio. Plant is the surname; a plant is industrial machinery (the engineering heritage); plants grow (what client businesses do). "Works" doubles as a quality claim.

**Niche**: English/Spanish bilingual sites for expat-owned businesses on the Costa del Sol. Restaurants, property services, health/wellness, trades. Most local web shops do bilingual badly. Proper hreflang is both the product and the SEO edge.

**Build philosophy**: single-file or minimal static sites, no frameworks unless needed, brand-driven design over templates, CSS-first interactivity, progressive enhancement. AI-assisted in the workshop, sold and supported as a personal service.

## Offer and pricing (launch pricing, ex-IVA)

| Package | Price | What it is |
|---|---|---|
| One-page site | €500–800 | Long single page, EN with ES optional, contact/WhatsApp/map, on-page SEO, GBP setup, domain+hosting connected |
| Multi-page bilingual site | €1,200–2,000 | Up to 8 pages in both languages, hreflang + structured data + sitemap, booking/enquiry flow, native-speaker proofread of ES copy |
| Care plan | €30–50/month | Hosting, domain, HTTPS managed; content changes within 2 working days; monthly speed/links/search check; small tweaks; cancel any month |
| Add-on: local search | monthly retainer, TBD | Google Business Profile, review requests, citations |

The care plan is the recurring-revenue engine. Twenty care-plan clients is a steady baseline.

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
   - [ ] Fictional bilingual Marbella restaurant
   - [ ] One trades or property site
2. **Own studio site**
   - [x] Built, bilingual, hreflang correct
   - [ ] Placeholders swapped (see checklist)
   - [ ] Deployed
3. **Legal**: register as autónomo once resident (gestor to set up; monthly social security; reduced flat rate first year). Add NIF and registered address to the site footer once registered.
4. **First clients**: walk-ins to expat businesses with weak sites, Costa del Sol expat Facebook groups, launch pricing.
5. **Every job**: Google review and referral ask.

## Pre-launch checklist for the studio site

- [ ] **Domain**. `plantworks.studio` is used as a placeholder in canonical, hreflang, sitemap and structured data across both pages. Verify availability (the environment this was built in blocks WHOIS/RDAP lookups, so this is **unverified**). Fallbacks: `plantworksstudio.com`, `plantworks.es`. If the domain changes, search-and-replace `https://plantworks.studio/` in `site/index.html`, `site/es/index.html` and `site/sitemap.xml`.
- [ ] **Name clash**. A web search for "Plantworks Studio" and "Plantworks" web design found no existing web studio, but this is a weak signal. Do a Spanish trademark search (OEPM, oepm.es) and an EUIPO search before printing anything.
- [ ] **Email**. `hello@plantworks.studio` is a placeholder in the contact form, the mailto link and the structured data on both pages.
- [ ] **Founder name**. "Dan Plant" appears in the about section and structured data. Confirm spelling and whether to show it.
- [ ] **Contact form**. Currently mailto-based (needs the visitor to have a mail app). Swap to Formspree free tier: set the form `action`, remove the inline script.
- [ ] **WhatsApp**. Add a `wa.me` link next to the email once there is a Spanish number.
- [ ] **Spanish proofread**. The ES copy was written directly, not machine-translated, but per the studio's own promise it should go past a native speaker before launch. Uses tú, not usted.
- [ ] **Case-study link**. The Fifth Quarter card links to `https://the5thquarter.co.uk/`, which is not live yet. Fine to leave; it'll resolve when the client site deploys.
- [ ] **Legal footer**. Add NIF, address and a privacy note once registered as autónomo.
- [ ] **Google Business Profile** for the studio itself, in Marbella.

## Working conventions

- One folder per client under `clients/`, each a deploy folder with its own `NOTES.md`.
- Keep the original client brief; keep the open-items list current.
- Client feedback often arrives as photos of handwritten notes. Transcribe carefully, fix obvious typos silently, flag judgement calls back.
