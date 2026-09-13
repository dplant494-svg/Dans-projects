# Handoff to the reporting-tools session — shrink photographs at source

**From:** dashboard / scanner session · **Date:** 13 September 2026 · **Status:** request, Dan's decision
**Context:** rolling handoff entry 6 (six CBM reports legitimately over 10 MB), production-timeline §6

## Dan's decision

> "I'm happy with your solution, please do it, as long as they are good quality and
> legible."

Photographs are shrunk **in WCGRRT and SSORT before they are embedded**. Nothing else
changes: same posts, same JSON, same photo count, same places in the report. The
scanner and dashboard need no change and the 10 MB / 30 MB ceilings stay as the check
that this is working.

## The numbers

Today, from the live scan of 13 September: five rig-visit and CBM reports between
10 and 20 MB from one rig in one week, two vendor reports at 30 and 75 MB, and the
six CBM records at 12–24 MB carrying 48–100 photos each. A phone photo embedded as
taken is 2–5 MB; a hundred of them is the whole problem. Text is never the problem.

| Setting | Value | Why |
|---|---|---|
| Long edge | **1600 px** | A corroded flange, a gauge face, a serial plate all read clearly at 1600; it prints at A4 width at 190 dpi |
| Format | JPEG | Photographs; PNG only if the source is a screenshot or drawing (detect by transparency or palette) |
| Quality | **0.80** | Visibly identical to 0.92 for site photography, about 40% smaller |
| Target per photo | **≈120–200 KB** | 100 photos ≈ 15 MB worst case, typically 6–10 MB for a CBM record |
| Orientation | apply EXIF rotation before resize, then strip EXIF | Photos currently arrive sideways in some viewers; EXIF is also where GPS lives |
| Never upscale | a photo smaller than 1600 px is left as it is | |

Implementation is the canvas: draw the image into an offscreen canvas at the new
size and read it back as JPEG at the quality above. It runs in the browser the tool
already runs in, needs no library, and takes well under a second per photo.

## Legibility, which Dan made a condition

- Show the user the shrunk photo, not the original, in the report before posting, so
  what they approve is what is posted.
- Keep a **"keep full size"** tick per photo for the rare case where a defect needs
  every pixel (a crack, a thread). That one photo stays as taken; the report warns if
  the total then passes the ceiling, as it does today.
- Do not reduce the photo count, crop, or watermark. Quality is Dan's line, and 1600
  px at 0.80 is comfortably above it; if a superintendent disagrees on a real photo,
  the long edge goes to 2000 px before the quality moves.

## Scope

- WCGRRT: rig visit tiles, CBM records, actions with photos, compliance photo dump,
  vendor audit / surveillance (the 30 and 75 MB files).
- SSORT: daily report photos, CBM, daily log entries.
- Precharge Pro: not affected, no photos.

## Not asked

No change to the posting flow, the JSON shape, the scanner, or already-posted files.
The historic large files stay as they are; the scanner's cache (v2.45, this week)
stops them costing a re-parse every ten minutes.
