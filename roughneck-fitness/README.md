# Roughneck Fitness (working name)

Online fitness coaching and training plans. Personal brand built on a documented transformation: 72 lb down, bodybuilder physique, 500+ days sober, filmed since July 2025. Oil-and-gas identity as homage. Owner is on a UK Level 3 personal-trainer course.

Separate brand from Plantworks Studio. Plantworks builds and hosts the site as a client (portfolio piece); nothing personal crosses over to the studio site.

## Rolling plan (last updated 5 Oct 2026)

**Done**: site in `site/` (noindex): story in Dan's words (message only, programme unnamed, Shaun credited with his OK), Coach Dan Plant, domain roughneck-fitness.com, 2024 before photo, dated story grid with day one 2 July 2025, NABBA prep paragraph, hero "Now" panel as a looping training clip, live sobriety counter, three plans (drafts) and one-to-one, apply form, Drinkline pointer, disclaimer. Placeholders in `site/NOTES.md`.

**Open, waiting on Dan** (in rough order; any can come at any time)
1. **Hero loop check**: open the preview in a real browser, confirm the "Now" panel plays, and pick cables (current) or the shoulder-press alternative.
2. **Stage-condition photo** from the end of the NABBA prep, with its date, and the show date. Goes in the story grid.
3. **Instagram handle**: claim it (try `roughneck.fitness` or `roughneckfitnessuk`), then it goes in the footer.
4. **Email for `coach@roughneck-fitness.com`**: a second mailbox on the Namecheap Private Email plan, or a forwarder to info@plantworksstudio.com for now.
5. **Shaun's programming shape**: split, days a week, rep ranges, progression, diet approach. The three plans get rewritten to follow his system instead of the generic drafts. A photo of one of Dan's real weekly programmes would do.
6. **Review the three plans** as the qualified person and mark them up.
7. **Netlify project**: create it from GitHub, base and publish directory `roughneck-fitness/site`, branch `claude/new-business-venture-7pxnxz`, form detection on before first deploy, then add the domain and the two Namecheap DNS records.
8. **More video**: upload the September DJI clips you rate to the GitHub release `videos-sept-2026` (Releases → edit → attach). They get cut into Instagram clips the same way.
9. **Prices**: confirm £39 / £89 / £199 or change them.
10. **Level 3 PT**: course provider and expected finish date, so the one-to-one tier can show an opening month.
12. **Film on the road (Houston, from Oct 2026; onshore and home-based for the foreseeable)**. Kit: DJI Osmo Pocket 3 and mics. The Hotel plan's advertising is Dan actually training in hotels.
    - Shot list per trip: the hotel or work-gym session (one exercise per clip, 20–40 s, phone-steady on the Pocket, landscape *and* vertical where possible); eating out right (what was ordered and why, one clip); a 30-second "session done" talking piece to camera with the mic; one clean 10–15 s loop with no talking for the site.
    - Posting rules: post after leaving a place, never live; never tag or show the hotel or room; nothing that says the family is home without him; "on the road in Texas" is the most location it gets.
    - Getting it here: upload the clips to a GitHub release on the repo (Releases → new release, tag e.g. `videos-houston-2026`, attach the files). The session cuts them for Instagram and the site.
    - Before posting "working from the US" on either brand: check with the accountant (residency/domicile record) and that the US visa allows work for his own company while there.
11. **Online booking for intro calls**: a second call type on the same Cal.com account as Plantworks (one login, one calendar, so a Plantworks call and a Roughneck call can't clash). "Intro call · 20 minutes", Google Meet, booking questions: where you train, goal, current training days. Same rotation rule: block trips with date overrides. Turn it on only when one-to-one opens after qualification; until then the apply form stays the way in. Send the link and it becomes a "Book an intro call" button beside the apply form.

**How video gets here**: Drive can list files but can't deliver video into a session. Upload clips as assets on a GitHub release in this repo; the session downloads them via the API, cuts them with ffmpeg (`pip install imageio-ffmpeg`), and only small web cuts go into git. Inventory in `assets/from-video/INDEX.md`.

**Decide first**
1. Name and domain: **Roughneck Fitness, roughneck-fitness.com** (bought 30 Sept 2026). Done.
2. How much of the story goes public (decided 30 Sept–1 Oct): the message, not the history. Counter stays. Programme never named. Done.
3. Positioning (decided 29 Sept): general market, not rig workers only (owner's call: too small a market). The rig identity stays in the name, the story and the tone. The product structure is by training environment: Full Gym, Rig & Site, Hotel. Diet guide included in every plan. Products: single plan £39, all three £89, one-to-one coaching £199/month once qualified.

**Before selling anything**
4. Finish the Level 3 PT qualification. Public liability and professional indemnity insurance (Insure4Sport or Protectivity, roughly £60–£100 a year) needs it. Selling coaching before that is a risk not worth taking.
5. Trade under the UK Ltd once it exists (Plantworks Ltd t/a Roughneck Fitness), or its own Ltd later if it grows. One set of accounts to start.
6. "By my team": don't claim a team that isn't there yet. Launch as one named coach; add coaches when there is demand.

**Build**
7. Coaching app: TrueCoach, Trainerize or Everfit. All do programmes, check-ins, video form review, and take the monthly payment. About £20–£50 a month. Pick one and learn it during the course.
8. Site: single page, same engineering as the studio sites. Hero with the transformation, the story, who it's for, programmes, how it works, results, and an **apply** form (not a buy button). Applications come to the inbox; you pick who you take.
9. Payments: Stripe Payment Links for the self-serve programme, subscription via the coaching app for 1:1.

**Offer (on the site)**
| Tier | What | Price |
|---|---|---|
| One plan | Full Gym, Rig & Site, or Hotel: 4-week programme, video demos, diet guide, tracking sheet | £39 one-off |
| All three | The three plans, switch as the week changes, future updates | £89 one-off |
| One to one | Programme and diet written for the client, app, weekly check-in and call | £199/month, 12-week minimum, opens on qualification |

**Plans**: drafted in `plans/` as Word documents (`build-plans.js` regenerates them). They are marked DRAFT FOR COACH REVIEW: the owner, as the qualified person, reads and signs off every exercise, rep range and diet line before anything is sold. Video demos for each exercise are the owner's to film.

**Launch**
10. Content is already shot. Cut the footage into: one 60-second transformation reel, a "day 1 vs day 500" still, and ten short clips. Instagram, TikTok and YouTube Shorts. Here short video is the channel; for Plantworks it wasn't.
11. First five clients at half price for testimonials and permission to show results. Same pattern as the studio launch offer.
12. One post a day for the first month, from the archive. Then three a week.

## Bio (written 30 Sept from the coach's own share; source document kept off the repo)

**Short (site, proposals, press):** Coach Dan Plant, former rig worker turned coach. Nearly twenty years in oil and gas as a subsea engineer, twenty-eight days on and twenty-eight off. Trained for twenty-five years without ever having the consistency. Sober since 2 April 2025 with the help of a programme he doesn't name, and coached into shape by Shaun Joseph Tavenier (IFBB pro, former Mr Olympia competitor; named on the site with his OK, 1 Oct 2026), whose ethos he coaches: do what you're told, follow the process. 72 lb down since, every step filmed. Training as a personal trainer. Roughneck Fitness: plans for the gym, the rig and the hotel room, diet included, from someone who did the turnaround himself.

**Instagram (150 chars):** `72 lb down · sober since 2.4.25 · former rig worker turned coach · plans for gym, rig & hotel · diet included · roughneck-fitness.com`

**Rules for the story anywhere public (his call, 30 Sept):** the message, not the history. Full name is fine. Never name the fellowship (its own tradition asks members not to identify themselves as members in print, film or online: say "a helpline", "the programme"). No drinking anecdotes, no family detail, nothing about Norway. He did not do it alone and the site must never say he did: the programme (unnamed) and his coach Shaun get the credit.

## Assets so far
- `assets/before/`: three "before" stills (bedroom, mirror, beach with a beer). The beach one is the sobriety "before"; the mirror one is the physique "before".
- Pool photo with wife: in, with her OK (28 Sept 2026).
- Sobriety date: **2 April 2025**. A counter on the site computes days from that date (544 on 28 Sept 2026).
- NABBA show prep, spring 2026: 18 weeks, reached stage condition, missed the show because he was offshore on rotation. On the site as one paragraph. Prep photos/videos in Drive `BODYBUILDING/NABBA PREP 2026` (weeks 18 down to 10).
- Transformation start: **2 July 2025**, with coach Shaun Joseph Tavenier. Day-one photo: `assets/before/before-home-front.jpg`.

## Still needed to build the site
- Name and domain.
- Six to ten stills: day one, milestones, now. A 30–60 second clip for the hero (muted, looping).
- The story in your words. Record it on the phone, paste the transcript.
- Qualification body and expected completion date (Active IQ, YMCA Awards, etc.).
- Which of the three tiers to launch with. One is fine.
- Instagram handle once claimed.

## Not now
- Merchandise, supplements, an app of your own, a podcast. All after the first ten paying clients.
