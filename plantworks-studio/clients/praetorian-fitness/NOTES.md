# Praetorian Fitness — working notes

Client: friend's premium fitness-apparel brand. Positioning: simple, high quality, upmarket (Lululemon end of the market) for athletes and gym-goers. Pre-launch site: a "coming soon" collection page that builds a launch list.

This folder is the deploy folder. Drag it as-is onto Netlify as its own project (not inside the Plantworks project), then point the brand's domain at it.

## Files

| File | Purpose |
|---|---|
| `index.html` | The whole site. Single file, no build step. |
| `thanks/index.html` | Landing page after the launch-list form submits. `noindex`. |
| `img/` | 20 JPEG crops taken from the four phone images supplied. Low resolution; see below. |

## Status: DRAFT

`index.html` carries `<meta name="robots" content="noindex">`. Remove that line at launch. Add `sitemap.xml` and `robots.txt` at the same time (copy the pattern from `../the-fifth-quarter/`).

## Placeholders to replace before launch

| Placeholder | Where | Replace with |
|---|---|---|
| `https://praetorianfitness.com/` | canonical, OG tags, JSON-LD | the real domain once bought |
| `hello@praetorianfitness.com` | footer | the real mailbox |
| Instagram link `#` | footer | the real handle |
| Prices in GBP (£38 tee, £44 short, £62 quarter-zip, £68 hoodie, £26 cap, £16 shaker, £74 duffel) | collection cards | the client's prices, or remove prices until confirmed |
| "Notify me" buttons | collection cards | Stripe Payment Links or a shop (Shopify / Snipcart) when stock exists |

## Imagery

All photos are crops from four low-resolution phone screenshots (945×2048). They look fine at card size and on phones, but the hero and full-width images will soften on a large desktop screen. Ask the client for:

- Original photo files (the AI-generated lifestyle set and the product set) at full resolution.
- The logo as a vector (SVG, PDF or AI). The source images use **two different marks**: a minimal helmet-crest line mark on the tees, and a shield-with-helmet badge on the product set. The site uses the line mark (redrawn as inline SVG for the favicon and thank-you page). Confirm which is the brand mark.

## Form

Netlify Forms, form name `launch-list`, fields: name, email, size, piece of interest. Before the first deploy: Netlify project → Forms → enable form detection. After the first deploy: Forms → Notifications → email to the client's mailbox. Same procedure as the Plantworks site (see `../../README.md`, Deploying).

## Open items

- [ ] Domain: `praetorianfitness.com` availability unknown (proxy blocks WHOIS from here). Check on Namecheap; `.co.uk` as fallback.
- [ ] Confirm product names, prices and colourways (site shows five tee colours: black, charcoal, stone, navy, white).
- [ ] Sizing guide page once the size chart exists.
- [ ] Shop: decide Shopify (full shop, ~£25/month) vs Stripe Payment Links on this static site (cheapest for a small launch range).
- [ ] Privacy notice and terms before collecting emails at scale.
