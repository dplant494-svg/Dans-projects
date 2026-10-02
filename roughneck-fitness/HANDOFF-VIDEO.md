# Handoff: Roughneck Fitness video pass

For a fresh Claude Code session on this repo (`dplant494-svg/Dans-projects`, branch `claude/new-business-venture-7pxnxz`). The main session built everything here; it cannot reach Google Drive with the right permission and cannot fetch Drive links through the network proxy. This session can, if Drive is connected with full access. Your job is to get the video material out of Drive, turn it into small files, and push them to the branch so the main session can use them.

## Context in one paragraph

Roughneck Fitness is Dan Plant's online coaching brand: former rig worker turned coach, 72 lb down, sober since 2 April 2025, coached by Shaun Joseph Tavenier (IFBB pro, former Mr Olympia competitor; named with his OK). The site is `roughneck-fitness/site/index.html`, a single static page, currently `noindex`. Plan and rules: `roughneck-fitness/README.md`. Placeholders and facts: `roughneck-fitness/site/NOTES.md`. Read both before touching anything.

## Scope: the `bodybuilding` folder only

Dan's Drive folder: https://drive.google.com/drive/folders/1bGT3S8vGAap5udW1YtQGcfeF27FZB_w0

Use **only** the folder named `bodybuilding` (the linked folder itself if that is its name, otherwise the subfolder with that name). Do not list, read or download anything else in his Drive. If the Drive connector cannot see the folder, say so immediately and stop: the fix is on his side (reconnect Drive on claude.ai with access to all files), not a workaround.

## What to produce

Work in your scratchpad, not the repo, for anything large. Raw videos never go into git.

1. **Inventory.** List every file in the folder: name, type, size, date, and for videos the duration and resolution. Write it to `roughneck-fitness/assets/from-video/INDEX.md` as a table. Dates matter: the transformation runs from 2 July 2025, and a clip's date is its caption.
2. **Look at the videos.** Install a video tool with `pip install imageio-ffmpeg` (the container has none; this gives you a static ffmpeg binary, path from `python3 -c "import imageio_ffmpeg as f; print(f.get_ffmpeg_exe())"`). For each video, make a contact sheet (one frame every two or three seconds, tiled, `-vf "fps=1/2,scale=320:-1,tile=6x5"`) and view it. Note what each clip shows: exercise, setting (gym, rig, hotel, home), framing, talking or not, usable or not.
3. **Hero loop candidates.** Pick the three best for a muted background loop behind the hero: steady camera, landscape or croppable to it, Dan training, no talking needed, 10 to 15 seconds. Cut each: H.264, 1280 wide, no audio, `-crf 28`, `-movflags +faststart`, target under 4 MB. Also a poster JPEG of the first frame. Save as `roughneck-fitness/site/img/hero-loop-1.mp4` (2, 3) with `hero-poster-1.jpg` etc.
4. **Stills.** Pull 10 to 15 of the best frames across all clips as JPEGs, 1400 px on the long side, quality 82, into `roughneck-fitness/assets/from-video/stills/`, named `YYYY-MM-DD-<what>.jpg` using the clip date. Prefer frames that show progress over time.
5. **Social clips, if there is time.** Three to five 15 to 30 second vertical clips (1080×1920, with audio if it's clean) into `roughneck-fitness/assets/from-video/social/`. These are for Instagram and TikTok, so keep the original quality high.
6. **Commit and push** everything above to the branch, with a plain commit message. Nothing larger than about 5 MB per file in `site/`, nothing larger than about 25 MB anywhere; if a social clip is bigger, re-encode or leave it out and note it in `INDEX.md`.
7. **Report back in chat** with the contact-sheet verdicts and your hero shortlist, so Dan can choose. Do not wire the video into the page: the main session will do that from your files.

## Rules that must hold

- The programme that got Dan sober is never named anywhere, including filenames, captions and commit messages. "The programme" or "a helpline" if it ever needs a word.
- Nothing from the AA share document goes anywhere. It is not in the repo and must not be added.
- No family detail, no daughters' names. His wife appears in one photo with her OK; that's it.
- Keep `noindex` on the site. Don't change `index.html` at all in this pass.
- No pull request. Push to the branch only.
- Don't touch `plantworks-studio/` or anything outside `roughneck-fitness/`.

## When you're done

Say what you pushed, and anything you couldn't get (a video that wouldn't download, a clip too big, a folder you couldn't see). The main session picks up from the branch.
