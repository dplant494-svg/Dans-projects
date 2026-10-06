# Instagram Reel 1: "Beneath our feet"

30-second vertical reel (1080×1920, 30 fps) built from the client's storyboard: aerial Lambton Park → Lions Gate → colliery plan → strata → Five Quarter seam G → pitmen → colliery → coal → the Wear → flour, steak, stone oven, wine → "Now it's feeding something else" → end card (Coming Spring 2027).

The rendered MP4 is not in git (37 MB). Rebuild it with `python3 build.py` from this folder (needs `pip install imageio-ffmpeg pillow`; render the two layer PNGs from `layers.html` first if changed).

## How it's made
- `panels/p01–p14.png`: the storyboard frames, cropped from a phone screenshot of the storyboard (`storyboard-source.jpg`). Low resolution; grain, vignette and slow push-ins give it a deliberate vintage-film look.
- `layers/bg.png`: navy frame with the brand header, tagline and location (Marcellus + EB Garamond, site colours).
- `layers/end.png`: rebuilt end card (the screenshot's was covered by a button), with the Five Quarter seam motif from the site.
- Each frame 2.3 s, 0.4 s crossfades, end card 3.6 s. Silent audio track: add music in Instagram.

## Before it's posted
- **Client sign-off**: it's their account and their launch.
- **Full-resolution images**: download each original image from the ChatGPT storyboard chat, drop them into `panels/` with the same names, run `build.py` again. Same reel, sharp.
- **Archive frames**: the pitmen, colliery and ships on the Wear frames are AI-generated in a period style. For a Durham mining audience, real archive photographs (Beamish Museum, Durham Mining Museum, Sunderland archives; licensed) would land harder and avoid anyone feeling misled. Swap them in the same way.
- **Music**: pick a track in Instagram's own library when posting (licensed for use there); slow piano or strings, low volume.

## Suggested caption
Six hundred feet beneath Lambton Park runs the Five Quarter seam. For two centuries this land fed an industry. Now it's feeding something else.

The Fifth Quarter · restaurant, bar & delicatessen · Lions Gate, Lambton Park · opening spring 2027.

#TheFifthQuarter #LambtonPark #ChesterLeStreet #CountyDurham #DurhamFood #NewOpening #DurhamHeritage
