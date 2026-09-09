# Handoff — The Fifth Quarter site & Costa del Sol web studio

Prepared for Claude Code. Two workstreams: (1) an in-flight client site, (2) a new web design business this site is the founding portfolio piece for.

---

## 1. The Fifth Quarter — restaurant website (in flight)

**Client**: Restaurant, bar & delicatessen opening Spring 2027 at Lions Gate, Lambton Park, Chester-le-Street, County Durham (DH3 4DT). Fortnum & Mason-style deli plus restaurant. Named after the Five Quarter coal seam of the Great Northern Coalfield (seam G in the Durham lettering) — the Lambton Estate was a major Durham coal dynasty, so the site sits above the coalfield it's named for. This heritage story is a core part of the brand.

**File**: `the-fifth-quarter.html` — single self-contained HTML file, no build step, no dependencies beyond Google Fonts (Marcellus + EB Garamond).

### Design system
- Colours (CSS vars): `--navy:#131F38`, `--navy-deep:#0C1526`, `--brass:#B8955A`, `--gold:#D8BC85`, `--parchment:#F6F1E4`, `--parchment-dim:#EFE7D2`, `--ink:#22293A`. Derived from the client's navy/gold sign logo.
- Type: Marcellus for display (matches the tall spaced caps of the physical sign), EB Garamond for body.
- Distinctive elements: SVG coal-strata diagram in the "Our Name" section (Five Quarter seam highlighted in gold); brass line-drawn jar-shelf SVG in the deli section; Deli and Steaks menu tabs styled as chalkboards (mirroring real chalkboards that will hang in the restaurant).

### Architecture decisions (keep these)
- **Menu tabs are pure CSS** — hidden radio inputs + labels + `:checked ~` sibling selectors. Deliberately no JavaScript: the client previews the file in sandboxed viewers that block scripts. Radios must stay *before* panels in source order for sibling selectors to work.
- Only JS on the page: the suggestion-box submit handler, which builds a `mailto:` link.
- Seven menu tabs: Breakfast / Lunch / Deli / Sunday / Dinner (default) / Steaks / Pizza.

### Contact & links
- All general links: `info@the5thquarter.co.uk` (suggestion box + Work With Us CV button).
- Booking (stopgap): `mailto:bookings@the5thquarter.co.uk` — hero button + nav "Book" link.
- Other addresses that exist: mark@, dave@, orders@.

### Open items
- [ ] **January 2027**: replace the two booking mailtos with the real booking-system URL (hero button + nav link).
- [ ] **Verify steak pricing**: notes said "from £23 per 100g" (= £230/kg — wagyu territory). Entered as written; likely needs checking with client.
- [ ] Prices missing from lunch, deli, dinner, Sunday mains, steak extras — layout already supports `.dish-price` spans.
- [ ] Deli sandwich descriptions: only Katz, Club and Veggie caprese are written; Cheesesteak, Chicken Parm, Fish Finger are name-only.
- [ ] Possible rename: Veggie caprese → "panuozzo" (client deciding; panuozzo = sandwich baked in pizza dough, they have the oven).
- [ ] Real photography when available (site is currently photo-free by design; degrades gracefully).
- [ ] Suggestion box: currently mailto-based (needs the visitor to have a mail app). Consider swapping to Formspree free tier for direct-to-inbox submissions.
- [ ] SEO pass: meta/OG tags, LocalBusiness + Restaurant structured data (schema.org) with menus/hours/geo, sitemap, favicon.
- [ ] Menus are labelled "example menus" — keep that label until client signs off final versions.

### Deployment plan (not yet done)
Rename to `index.html` → Netlify drag-and-drop (or Cloudflare Pages) → connect domain `the5thquarter.co.uk` at registrar (nameservers or A + CNAME) → HTTPS auto-issues. Zero hosting cost.

### Working style with this client
Feedback arrives as photos of handwritten notepad pages and WhatsApp screenshots — transcribe carefully, fix obvious typos silently (e.g. "Bernaise"→Béarnaise, "Elton mess"→Eton mess), and flag judgement calls back rather than guessing. Keep everything on one page; client explicitly dislikes making people juggle multiple menus (cross-references were removed in favour of full descriptions).

---

## 2. The business — bilingual web studio, Costa del Sol

**Concept**: Websites for small businesses, built AI-assisted, sold as a personal service. Base: Marbella (relocating from UK). Work is remote-capable and global, but the beachhead niche is local:

**Niche**: English/Spanish bilingual sites for expat-owned businesses on the Costa del Sol — restaurants, property services, health/wellness, trades. Large expat business community; most local web shops do bilingual badly. Proper hreflang implementation is both the product and the SEO edge.

**Offer / pricing (draft)**
- One-page site: €500–800
- Multi-page bilingual site: €1,200–2,000
- Care plan (hosting, updates, tweaks): €30–50/month — the recurring-revenue engine; 20 care-plan clients = steady baseline income.
- Optional add-on: local SEO service (Google Business Profile, reviews, citations) as a monthly retainer.

**What's in every build**: on-page SEO (meta, structured data, speed), mobile-first, static hosting (Netlify/Cloudflare = ~zero cost), bilingual with hreflang where sold. Native-speaker proofread on paid translated copy.

**Roadmap**
1. Portfolio of 3: The Fifth Quarter (done-ish) + fictional bilingual Marbella restaurant + one trades/property site.
2. Own studio site — bilingual, fast, the sales pitch itself.
3. Legal: register autónomo in Spain once resident (gestor to set up; note monthly social security, reduced flat rate first year).
4. First clients: walk-ins to expat businesses with weak sites, Costa del Sol expat Facebook groups, launch pricing.
5. Every job → Google review + referral ask.

**Build approach for future client sites**: same philosophy as The Fifth Quarter — single-file or minimal static sites, no frameworks unless needed, distinctive brand-driven design over templates, CSS-first interactivity, progressive enhancement.

---

## 3. Studio name — DECIDED: **Plantworks Studio**

Founder surname is Plant; 18+ years in oil & gas. The name carries a triple meaning: the surname, "plant" as industrial machinery/works (engineering heritage), and plants grow (what client businesses do). "Works" doubles as a quality claim.

**Brand positioning line** (use on studio site): *"I spent two decades maintaining offshore systems that couldn't be allowed to fail. Now I build websites the same way."* — reliability/engineering trust story that no local competitor can tell.

Verify before committing publicly: domain availability (plantworks.studio / plantworksstudio.com / .es), Spanish trademark search, and existing businesses with similar names.

Alternates considered (fallbacks if domains blocked): Plant Digital, Plant & Sol, Planted, Faro Studio (*faro* = lighthouse), Vela Studio, Costa Built, Brasa Digital.
