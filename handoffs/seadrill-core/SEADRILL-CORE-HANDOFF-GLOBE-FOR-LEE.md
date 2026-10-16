# Handoff to Lee: Seadrill CORE, the spinning globe and the rig views (priority), for Lovable

**From:** SACRED (Dan Plant's dashboard session). **Date:** 16 Oct 2026. **For:** Lee Arnold and his Claude / Lovable build of **Seadrill CORE: Central Operations & Resource Environment**. CORE is the company-wide app for Seadrill's technical standards, for Technical Services.

**What Dan wants:**
- the same spinning globe as SACRED's BOP Fleet Planning page, with real rig locations;
- a **Tile view** and a **Map view** beside it;
- **click a rig, and the globe turns and zooms to it.** Then the **core of the earth opens** and the rig's requirements come out as a **linked knowledge graph**, like Obsidian's graph view (a "second brain"). Every field can be clicked: region, vessel, discipline, SFI, maintenance and operating requirements, regulatory and company requirements.

**The globe is the priority.**

## Files with this handoff (`handoffs/seadrill-core/`)

| File | What it is |
|---|---|
| `seadrill-core-logo-sheet.png` (and `.webp`) | **The CORE logo** (Dan, 16 Oct): horizontal and stacked, light and dark, app icon 512 down to 16 px, favicon and palette. Draft until Seadrill Communications approves. Cut the SVGs from it, or regenerate them with `SEADRILL-CORE-LOGO-PROMPT.md` |
| `sacred-globe-source.js` | SACRED's globe, verbatim: projection, draw loop, pins, labels, hit testing, timings |
| `sacred-map-source.js` | SACRED's map view, verbatim |
| `sacred-region-anchors.js` | Region anchors, the map projection and the label layout |
| `world-paths.json` | The land outlines the globe uses today: Natural Earth 110m, pre-projected into a 1820 × 880 box, **cropped to longitude −105 to 135 and latitude −50 to 55** (see section 1.2) |
| `reference-obsidian-graph.png` | The look Dan wants for the opened core: a graph of nodes and links |

---

## 1. The globe: build it identical to SACRED's

The SACRED globe uses **no library**. It is an orthographic projection drawn by hand on a 2D `<canvas>` inside a fixed **1820 × 880** stage, which CSS scales to fit (`scale = min(w/1820, h/880)`). Port it as a React component: the canvas in a `useEffect` with `requestAnimationFrame`, and the state in a `useRef`. The code is in `sacred-globe-source.js`; these values make it identical.

### 1.1 Look

**Stage**
- Background `radial-gradient(ellipse at 62% 50%, #0b3f8f 0%, #002C77 48%, #001a4d 100%)`, radius 10 px.
- Globe radius **R = 392**, centre **(1090, 440)**, so it sits right of centre. The fleet list goes on the left.
- Start view: longitude facing −25°, tilt **φ = −14°**.

**Draw order**
1. **Halo:** radial `rgba(0,145,218,0.45)` to `0` from 0.98R to 1.12R.
2. **Ocean disc:** radial centred at (cx−0.35R, cy−0.35R): `#0a4aa8` at 0, `#073a8a` at 0.7, `#02225e` at 1.
3. **Graticule:** every 30°, `rgba(255,255,255,0.10)`, 1 px, front side only.
4. **Land:** fill `rgba(255,255,255,0.13)`, even-odd. Stroke `rgba(255,255,255,0.85)`, 1.1 px, front edges only.
5. **Limb shade:** radial from (cx−0.3R, cy−0.2R), 0.6R to 1.02R, `rgba(0,0,0,0)` to `rgba(0,10,40,0.55)`.
6. **Rig pins:**
   - Circle r = 9 in the status colour, with a 2.5 px white ring.
   - A pin fades in near the edge: alpha `min(1, z × 2.2)`, shown when z > 0.02.
   - Rigs in maintenance get an orange pulse ring: radius `10 + 22·ph`, where `ph = (t mod 1.6)/1.6`, stroke `rgba(226,83,3, 0.7·(1−ph))`, 3 px.
7. **Label cards:**
   - White, radius 6, height 44, shadow `0 3px 10px rgba(0,0,0,.35)`, and a leader line `rgba(255,255,255,0.55)` 1.5 px back to the pin.
   - Line 1: the rig name, 700 15 px, `#002C77`. Line 2: the status in capitals, 700 11 px, `#5a6880`.
   - The card sits 18 px right of the pin, or flips left near the edge. Overlapping cards are pushed down.

**Fleet list (left side)**
- 330 px wide, title "FLEET · N RIGS" in yellow.
- Rows are translucent white. The rig nearest the viewer gets a **yellow border** (`.facing`).

**Status colours** (one pin per rig; the "worst" BOP wins: maintenance, then ready, then preservation, then deployed)

| Status | Colour |
|---|---|
| Deployed | `#002C77` |
| Ready to Deploy | `#0082C0` |
| Performing Maint. | `#E25303` |
| Preservation | `#64748b` |
| Unknown | `#94a3b8` |

**Font:** `"Meta Pro", Arial, sans-serif`, weight 700. Palette from the logo: `#002C77`, `#EDB71E` (the star and highlights only), `#0082C0`, `#F4F7FA`, `#1F2D3D`.

### 1.2 Land: use the full world

SACRED's outlines stop at latitude 55° N and longitude 135° E. **Norway and the North Sea are missing,** and CORE will have rigs there (West Elara, West Phoenix).
- For CORE, use **Natural Earth 110m countries for the whole world** (`world-atlas` `countries-110m.json`, TopoJSON, converted with `topojson-client`).
- Draw it with **the same fill and stroke values** as above. The look stays identical, and the coverage is complete.
- `world-paths.json` is included only for comparison.

### 1.3 Motion today (keep)

- Linear spin at **3° per second** (one turn every 2 minutes), with the longitude facing the viewer moving west.
- **Hovering pauses it.** It resumes **10 s** after the mouse leaves. A touch pauses it for 10 s.
- Hovering a row in the fleet list turns the globe to that rig.
- The loop runs only while the globe is on screen and the browser tab is visible.
- **Slow-device fallback:** more than 90 slow frames (over 80 ms each) switches to the Map view.

### 1.4 New for CORE: click a rig, the globe flies to it, then the core opens

SACRED opens a panel on click. **CORE animates instead.**

1. **Turn** (900 ms, ease-in-out-cubic): tween the facing longitude (λ) to the rig's longitude and the tilt (φ) to the rig's latitude, so the rig comes to the centre. Pause the spin and fade out the other labels. **Take the short way round** (wrap λ to ±180°).
2. **Zoom** (800 ms, ease-out-cubic): tween R from 392 to about 1400 and the centre to (910, 440). The region fills the stage and the graticule and coastline stay crisp. Neighbouring rigs in the same region stay visible as small pins.
3. **The core opens** (700 ms):
   - The globe surface fades to 0.15 opacity and a **glowing core** grows from the rig's position.
   - The core is a radial gradient `#EDB71E` to `#E25303` to transparent, with a slow 1.5 s breathing glow.
   - The background darkens to Charcoal `#1F2D3D`, Obsidian-style.
4. **The graph comes out** (600 ms, staggered 20 ms per node): nodes burst from the core into a **force-directed graph** (`react-force-graph-2d` or `d3-force`). The rig node sits in the centre, pinned. See section 2 for the nodes.
5. **Back:** a "Back to globe" button, or Esc, plays it in reverse and the spin resumes after 10 s.

**Other rules:**
- **Deep links:** `?rig=<rig-key>` opens straight into that rig's core.
- **Reduced motion:** honour `prefers-reduced-motion`. Skip the tweens and cut straight to the graph.

### 1.5 Map view and Tile view (as SACRED, plus the CORE click)

Three tabs in the header: **Globe · Map View · Tile View**. They are yellow pills when active, and the same legend is shown in all three.

**Map view** (`sacred-map-source.js`)
- An equirectangular SVG on Seadrill Blue `#002C77`.
- Countries are drawn `rgba(255,255,255,0.08)` fill with a `rgba(255,255,255,0.85)` 1 px stroke.
- Pins are r = 8 with a 2 px white ring.
- Labels sit in a column per region, with the region name in yellow capitals above, and a leader line from each pin to its label.
- **Use the full world here too.**

**Tile view**
- A grid of 5 columns with a 16 px gap. Each tile is white with a 5 px left bar in the status colour.
- Each tile shows the rig name (18 px, 700, `#002C77`), the region code, and one line per BOP with a status pill.
- Tiles in maintenance get a slow yellow "spotlight" ring that moves to the next one every 20 s.

**Clicking a pin, label or tile** in either view opens the same rig core as the globe (step 4 above). On the Map view, zoom the map to the region first.

## 2. Inside the core: the requirements graph

A **knowledge graph** in Obsidian style (`reference-obsidian-graph.png`): dark Charcoal background, small round nodes, thin links, hub labels in grey and leaf labels in white.

**Behaviour:**
- **Hovering a node** highlights it and its neighbours and dims the rest.
- **Clicking a node** opens the requirement panel on the right: its text, its source document, its revision, and a link to eDocs.
- **Double-clicking a hub** makes it the new centre.
- A **search box** finds a node.
- **Filter chips** switch each hub type on or off.

| Hub (node type) | Example leaves | Colour |
|---|---|---|
| **Rig** (centre) | West Vela: type (drillship / semi / jack-up), BOP stack(s), class, flag | `#EDB71E` star |
| **Region** | Gulf of Mexico, Brazil, Angola, Namibia, Malaysia, North Sea | `#0082C0` |
| **Regulatory** | per region, e.g. GOM: BSEE (30 CFR 250 Subpart G), API Std 53; Brazil: ANP; Norway: PSA / NORSOK D-010; Angola: ANPG | `#E25303` |
| **Company** | Seadrill technical standards and directives (DIR-…), MoCs, technical alerts, AABs | `#002C77` with a white ring |
| **Vessel** | the rig's equipment, BOP 1 and BOP 2, stack type | `#64748b` |
| **Discipline** | Subsea / WCE, Drilling, Mechanical, Electrical, Marine, MPD | `#1F8A70` |
| **SFI** | Maximo groups, e.g. 331 BLOWOUT PREVENTER STACK, 332 BLOWOUT PREVENTER CONTROL SYSTEM, 302, 315 … (the same names SSORT and Argo Navis use) | `#5a6880` |
| **Maintenance requirements** | intervals per SFI: BWM, 3M, 6M, 12M, 5Y, CBM | `#0a7` |
| **Operating requirements** | testing, drills, pre-deployment, function and pressure tests | `#16a37a` |

**Links carry the meaning:**
- rig to region; region to regulator; regulator to requirement;
- requirement to SFI; requirement to discipline;
- company standard to requirement;
- requirement to its **maintenance** or **operating** rule.

**One real example of why the graph matters:** CBM is **not permitted in the Gulf of Mexico or the Gulf of America under BSEE**. So on a GOM rig the "CBM" maintenance node is linked to the BSEE node and shown **red, "not permitted here"**. On Carina, Capella, Jupiter and Tellus it is allowed.

**Data:** keep the graph in tables, not in code: `nodes(id, type, label, region?, rig?, source, rev, url)` and `links(source, target, relation)`. Dan's team can then maintain it.

## 3. Rig locations (option 2: proposed positions, editable in the app)

SACRED has **no real rig coordinates**; it spreads pins around a region anchor. For CORE, Dan chose **proposed positions now, corrected later**.
- Store a **Location per rig** (lat, lon, region, field or block, updated by, updated at), editable by an admin when a rig moves.
- **Seed it with the table below.** Every position is **approximate**: an open-water point in the rig's operating area, not its real position.

| Rig | Key | Region (as SACRED shows today) | Lat | Lon | Note |
|---|---|---|---|---|---|
| West Vela | vela | Gulf of Mexico | 27.20 | −90.40 | |
| West Neptune | nov | Gulf of Mexico | 27.30 | −91.20 | |
| Sevan Louisiana | cam | Gulf of Mexico | 27.90 | −89.90 | |
| West Auriga | auriga | Gulf of Mexico | 26.80 | −89.40 | SACRED's older data said Brazil; confirm |
| West Saturn | saturn | Brazil | −22.60 | −40.10 | Campos Basin area |
| West Jupiter | jupiter | Brazil | −24.80 | −42.60 | Santos Basin area |
| West Tellus | tellus | Brazil | −25.30 | −43.40 | Santos Basin area |
| West Polaris | polaris | Brazil | −23.90 | −41.20 | |
| Sonangol Libongos | libongos | Angola | −7.60 | 11.40 | |
| Sonangol Quenguela | quenguela | Angola | −6.90 | 11.20 | |
| West Gemini | gemini | Angola | −8.40 | 12.10 | |
| West Carina | carina | Namibia | −26.20 | 14.20 | Orange Basin area (Dan, 12 Oct: Carina is offshore Namibia) |
| West Capella | capella | Malaysia | 5.90 | 113.60 | |
| West Elara | elara | North Sea (to confirm) | 58.90 | 2.40 | Region not in SACRED yet |
| West Phoenix | phoenix | North Sea (to confirm) | 61.00 | 2.00 | Region not in SACRED yet |
| West Aquarius | aquarius | **to confirm** | | | Not shown until a location is set |
| West Eclipse | eclipse | **to confirm** | | | Not shown until a location is set |

- **Two rigs in one place:** if two rigs share almost the same point, spread them with SACRED's golden-angle spiral: angle `i × 2.399963`, radius `0.6°·√i`.
- **Status:** status colours can come later from SACRED's `plans-status` / BOP planning data. Until then, show the pins in Seadrill Blue.

## 4. Order of build

1. **The globe, identical** to SACRED's look and motion (section 1.1 to 1.3), on the full Natural Earth land, with the seeded rig positions.
2. **Fly-to and zoom** on click (1.4, steps 1 to 2).
3. **The core opening and the graph** (1.4, steps 3 to 5, and section 2), first with sample nodes for one GOM rig and one Brazil rig.
4. **Map view and Tile view**, with the same click.
5. **The logo** in the header (light lock-up on a white header, or dark on a Seadrill Blue header), the app icon and the favicon.

## Please reply with

- Screenshots or a short screen recording of the globe and the click-to-core animation.
- The Lovable project link, so Dan can review it.
- Any data you need from SACRED: rig status, plan progress, or the SFI group list.
