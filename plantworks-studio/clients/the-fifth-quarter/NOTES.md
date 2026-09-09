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

- [ ] **January 2027**: replace the two booking mailtos with the real booking-system URL (hero button, nav "Book" link, and the `ReserveAction` target in the JSON-LD).
- [ ] **Verify steak pricing**: "from £23 per 100g" is £230/kg. Entered as written; check with client.
- [ ] Prices missing from lunch, deli, dinner, Sunday mains, steak extras. Layout supports `.dish-price` spans.
- [ ] Deli sandwich descriptions: Cheesesteak, Chicken Parm, Fish Finger are name-only.
- [ ] Possible rename: Veggie caprese → "panuozzo" (client deciding).
- [ ] Real photography when available.
- [ ] Suggestion box: mailto-based. Swap to Formspree free tier for direct-to-inbox (needs an account; the form already has `name`, `email`, `message` fields so only the `action` and the script change).
- [ ] Menus are labelled "example menus" until the client signs off.

## Working style

Feedback arrives as photos of handwritten notes and WhatsApp screenshots. Transcribe carefully, fix obvious typos silently, flag judgement calls back rather than guessing. Everything stays on one page. Menu tabs stay pure CSS (radios before panels in source order).
