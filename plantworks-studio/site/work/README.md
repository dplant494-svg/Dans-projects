# Demo sites (fictional businesses)

Portfolio pieces for the studio site. Both businesses are invented; each footer says so and links back to the studio. They live inside `site/` so a single deploy of the studio carries them, at `/work/<name>/`.

| Folder | Business | Default language | Other language | Why it exists |
|---|---|---|---|---|
| `brasa-y-sal/` | Beachfront espeto grill, Playa de la Bajadilla, Marbella | Spanish at `/` | English at `/en/` | The bilingual restaurant piece. CSS-only menu tabs, Restaurant structured data with hours and geo, booking form. |
| `pinar-property/` | Property management for owners abroad, Estepona | English at `/` | Spanish at `/es/` | The property-services piece. Sample visit report in the hero, seven-point inspection drawn on a villa, pricing, `details`-based FAQ, LocalBusiness data. |

Both carry `<meta name="robots" content="noindex">` and are left out of the studio sitemap, so they work as portfolio pages linked from Work but never appear in search as if they were real businesses. The two show both folder layouts a client might want: Spanish-root and English-root. Each page carries `hreflang` for both languages plus `x-default`, and the studio `sitemap.xml` lists all six URLs.

## Facts that are made up

Addresses, phone numbers (all `00 00 00`), emails, prices, hours, the "Villa Los Almendros" report, and the coordinates for Brasa y Sal (a point on Playa de la Bajadilla). None should be presented as real. The regulatory claims in Pinar's FAQ (Andalucía VUT registration, 2024 community-of-owners rules, LAU contracts, deposits with the Junta) are real-world context written from general knowledge; check them before reusing that copy on a real client site.

## Reusing for a real client

Copy the folder to `clients/<name>/`, swap the fictional facts, remove the demo footer line, change the canonical/hreflang/og URLs to the client's domain, and give it its own `sitemap.xml` and `robots.txt` (the demos rely on the studio's).
