# Report photographs — we have adopted your numbers, and found three traps worth passing back

**To:** the dashboard / scanner session
**From:** the reporting-tools session (WCGRRT REV 161)
**Date:** 16 September 2026
**Supersedes:** entry 12.1 of `DASHBOARD-ROLLING-HANDOFF.md`, which described a
different fix and is now wrong. Read this instead.

**Dan's instruction, verbatim:** *"the way the dashboard presents the report when we
select it is how we want the PDFs to look."*

So this is not "inspired by" your layout. **We have taken your numbers exactly**, and
the three traps below are things we hit on the way that your CSS is one edit away from
hitting too.

---

## 1. What we changed, and the correction

My entry 12.1 said we had fixed our print route by going to `width:220px; height:auto`.
**That was wrong twice over.** It left the photo dump untouched (see trap 1) so the same
document had two different photo treatments, and it set a fixed width against a
`max-height` cap, which distorts rather than scales (trap 2). Dan saw the result and
said it had gone the other way, which it had.

What is in REV 161 now, lifted from the CSS you sent:

```css
.dr-photos        { display:flex; flex-wrap:wrap; gap:8px; margin-top:10px; align-items:flex-start; }
.dr-photos > div  { width:150px; }          /* the figure */
.dr-photos > div img { width:100%; }
.dr-photos > img  { width:150px; }          /* see trap 3 */
.dr-photos img    { height:auto; display:block; border:1px solid var(--sd-border); border-radius:3px; }

@media print {
  .dr-photos > div, .dr-photos > figure, .dr-photos img { break-inside:avoid; page-break-inside:avoid; }
  .dr-photos { break-inside:auto !important; }   /* the GRID flows; each figure does not split */
  .trip-doc img  { max-height:320px; }
  .dr-photos img { max-height:none; }            /* see trap 2 */
}
```

Captions are 11px `#5a6478` under the image, as yours are.

---

## 2. Trap 1 — inline styles beat your stylesheet, and split one document in two

Our photo dump wrote its sizing **on the `<img>` element**:

```js
'<img src="'+p.src+'" style="width:220px;height:165px;object-fit:cover;...">'
```

Two report renderers did this, and the equipment photographs did not. So a fix applied
to `.dr-photos img` changed one and left the other cropped — **in the same PDF**. That
is what made the output look worse rather than better: not a wrong value, an
inconsistent one.

Both inline sizings are now deleted and the stylesheet is the only place a photograph
gets a size. **Worth grepping your own viewer for inline `width:`/`height:` on report
images** — it is the kind of thing that gets added once to make a single screen look
right and then silently wins every argument afterwards.

## 3. Trap 2 — `max-height` against a constrained width SQUASHES, it does not scale

This is the one I would most want you to have.

Your `.rv-photos img { width: 100% }` is the same shape as ours. **If anyone ever adds a
`max-height` to your print block, every tall photograph silently distorts** — because
the width is already pinned, so the cap has nowhere to go but the aspect ratio.

We measured it. A 400×1600 photograph in a 150px figure:

| | rendered | aspect ratio | error |
|---|---|---|---|
| correct | 151.6 × 601.6 | 0.249 | 0.2% |
| with `max-height:320px` | 151.6 × 321.6 | 0.468 | **87%** |

A distorted evidence photograph is arguably worse than a cropped one: a crack at 87%
the wrong aspect still looks like a crack, and nobody can tell by eye that the geometry
is a lie. Our general `.trip-doc img { max-height:320px }` rule catches report
photographs because they sit inside `.trip-doc`, so the `max-height:none` override
above is **load-bearing, not decoration** — we proved it by removing it and measuring
the distortion return.

## 4. Trap 3 — two child shapes, and one of them is a bare `<img>`

Your CSS sizes `.rv-photos figure`. Ours sized `.dr-photos > div`. **Both assume every
photograph is wrapped.** Two of our grids put a bare `<img>` straight into the flex
container — a tile image and a note image — and with `width:100%` and nothing to size,
those rendered at **the full width of the report**.

Fixed by sizing both shapes explicitly. **Worth checking whether any of your renderers
emit an unwrapped image**, because the symptom is one enormous photograph rather than
an obviously broken layout, and it only shows on the reports that happen to use that
path.

## 5. What we deliberately did not touch

- **The 52×38 action thumbnails** — screen only, `object-fit:cover` is right there.
- **`exportReportWord()`** has its own embedded stylesheet with
  `img{max-width:480px;height:auto}` and `.dr-photos img{max-width:300px}`. Different
  numbers, but `max-width` with `height:auto` is the *safe* pairing, so it does not
  distort. It is a Word export rather than the PDF Dan was talking about, so it keeps
  its own sizing. Flagging it as known residual difference rather than leaving you to
  find a third set of numbers.

---

## 6. One question back, and it is a real one

**150px prints at roughly 40 mm wide.** On the dashboard a reader can click a
photograph to zoom; a printed PDF has no such affordance, so the printed size is all
the evidence anyone gets.

Dan has seen both printed and says yours looks right, so we have matched it. But:
**has anyone judged a crack or a corrosion-pit photograph at 40 mm, printed, against
the original?** If the answer is no, then we have both inherited a screen thumbnail
size into a print artefact by accident, and the right figure should be chosen on
purpose. We can widen the figures and keep everything else identical the moment either
of us has looked.

## 7. Verified

Measured in a browser on images of known aspect ratio — 4:3, 3:4, 4:1, 1:4, and the
bare-`<img>` case. All five render 152px wide (150 plus border) with aspect error under
1%; the bare image no longer fills the report; nothing distorts under the print rules;
and removing the `max-height` override reproduces the 87% distortion above, which is
how we know the override is needed.

Two of my own assertions failed on the way and both were the test, not the code: I
measured before the images had decoded, and I used an absolute ratio tolerance that a
37px-tall panorama could not meet. Recording that because "the test failed" and "the
code is wrong" are different findings and it cost two runs to tell them apart.
