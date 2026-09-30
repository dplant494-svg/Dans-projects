# Roughneck Fitness site — working notes

Deploy folder. Own Netlify project, base directory `roughneck-fitness/site`. `netlify.toml` included (publish `.`, headers).

## Status: DRAFT, noindex

Remove `<meta name="robots" content="noindex">` at launch, add `sitemap.xml` and `robots.txt` (copy the pattern from `plantworks-studio/site/`).

## Placeholders

| What | Where | Replace with |
|---|---|---|
| Coach name | done: "Dan", first name only, no surname anywhere on the site | |
| Domain | done: `roughneck-fitness.com` (Namecheap, 30 Sept 2026) | |
| `coach@roughneck-fitness.com` | footer, JSON-LD | the real mailbox |
| Instagram `#` | footer | the handle |
| "Before · 2024" caption | hero | the real date of the beach photo |
| Prices £39 / £89 / £199 | plans and coaching | confirmed prices |
| Story text | done 30 Sept from the coach's own written share; kept off the site by design: the fellowship's name (its own anonymity tradition), the Norway attempt, family history, daughters' names, surname. One line ("my family had gone") to be checked with his wife. |

## Facts the page states (check each)
- 72 lb lost.
- Sober since 2 April 2025 (counter is computed live from this date in the visitor's local time).
- Training filmed since June 2025 ("15 months, documented" in the stats strip: update the number or make it live).
- Level 3 PT qualification in progress; one-to-one coaching opens only after it's done and insured. The plans are sold as programmes with general diet guidance, and say so.

## Images
`img/` holds web-sized copies (max 1400 px, JPEG 82) made from `../assets/`. Originals stay in `assets/`. The pool photo with the coach's wife is in with her OK (28 Sept 2026).

## Form
Netlify form `apply` → `/thanks/`. Enable form detection before the first deploy, then set the notification email.

## Responsible-content notes
- The apply section carries a Drinkline pointer (0300 123 1110) and a line that this is fitness, not treatment. Keep it.
- Footer disclaimer: not medical advice, one person's results. Keep it.
- Nothing on the page says where the coach lives.
