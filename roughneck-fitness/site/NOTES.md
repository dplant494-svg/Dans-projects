# Roughneck Fitness site — working notes

Deploy folder. Own Netlify project, base directory `roughneck-fitness/site`. `netlify.toml` included (publish `.`, headers).

## Status: DRAFT, noindex

Remove `<meta name="robots" content="noindex">` at launch, add `sitemap.xml` and `robots.txt` (copy the pattern from `plantworks-studio/site/`).

## Placeholders

| What | Where | Replace with |
|---|---|---|
| `[Coach name]` | story sign-off | the coach's name as it should appear publicly |
| `roughneckfitness.com` | canonical, OG, JSON-LD | the domain once bought |
| `coach@roughneckfitness.com` | footer, JSON-LD | the real mailbox |
| Instagram `#` | footer | the handle |
| "Before · 2024" caption | hero | the real date of the beach photo |
| Prices £39 / £79 / £199 | programmes | confirmed prices |
| Story text | story section | the coach's own words from the recorded transcript; current text is a draft written from the brief |

## Facts the page states (check each)
- 72 lb lost.
- Sober since 2 April 2025 (counter is computed live from this date in the visitor's local time).
- Training filmed since June 2025 ("15 months, documented" in the stats strip: update the number or make it live).
- 2 weeks on / 2 weeks off rotation.
- Level 3 PT qualification in progress; Crew and One-to-one open only after it's done and insured.

## Images
`img/` holds web-sized copies (max 1400 px, JPEG 82) made from `../assets/`. Originals stay in `assets/`. The pool photo with the coach's wife is not in the repo pending her OK.

## Form
Netlify form `apply` → `/thanks/`. Enable form detection before the first deploy, then set the notification email.

## Responsible-content notes
- The apply section carries a Drinkline pointer (0300 123 1110) and a line that this is fitness, not treatment. Keep it.
- Footer disclaimer: not medical advice, one person's results. Keep it.
- Nothing on the page says where the coach lives.
