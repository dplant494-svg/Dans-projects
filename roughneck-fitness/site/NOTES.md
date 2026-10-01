# Roughneck Fitness site — working notes

Deploy folder. Own Netlify project, base directory `roughneck-fitness/site`. `netlify.toml` included (publish `.`, headers).

## Status: DRAFT, noindex

Remove `<meta name="robots" content="noindex">` at launch, add `sitemap.xml` and `robots.txt` (copy the pattern from `plantworks-studio/site/`).

## Placeholders

| What | Where | Replace with |
|---|---|---|
| Coach name | done: "Coach Dan Plant" (full name approved 30 Sept) | |
| Domain | done: `roughneck-fitness.com` (Namecheap, 30 Sept 2026) | |
| `coach@roughneck-fitness.com` | footer, JSON-LD | the real mailbox |
| Instagram `#` | footer | the handle |
| Before photo | done: pool-bar photo, 2024, confirmed | |
| Prices £39 / £89 / £199 | plans and coaching | confirmed prices |
| Story text | done 1 Oct: the message only, no drinking history, no family detail. The fellowship is "the programme and the people in it", never named. Credits his coach Shaun Joseph Tavenier (IFBB pro, former Mr Olympia competitor): **confirm spelling, that he's happy to be named, and the credentials, before launch.** |

## Facts the page states (check each)
- 72 lb lost.
- Sober since 2 April 2025 (counter is computed live from this date in the visitor's local time).
- Programme started 2 July 2025 (day-one photo on the site). "15 months, documented" in the stats strip is right until November 2026; then update or make it live.
- Level 3 PT qualification in progress; one-to-one coaching opens only after it's done and insured. The plans are sold as programmes with general diet guidance, and say so.

## Images
`img/` holds web-sized copies (max 1400 px, JPEG 82) made from `../assets/`. Originals stay in `assets/`. The pool photo with the coach's wife is in with her OK (28 Sept 2026).

## Form
Netlify form `apply` → `/thanks/`. Enable form detection before the first deploy, then set the notification email.

## Responsible-content notes
- The apply section carries a Drinkline pointer (0300 123 1110) and a line that this is fitness, not treatment. Keep it.
- Footer disclaimer: not medical advice, one person's results. Keep it.
- Nothing on the page says where the coach lives.
