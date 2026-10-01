# Riser Tally Tool on SACRED: how we update and load, the branding, and the rig list

**From:** Dan Plant (owner of SACRED, the Well Control Equipment reporting pages) · **To:** Rohit and his build session
**Date:** 1 October 2026 · **About:** `Riser Tally Tool.html`, Rohit's standalone tool, hosted on the sacred share

This is the house style, not a request to change how the tool works. The tool is Rohit's. SACRED only hosts the file
and, later, links to it. Three things matter to us: the file keeps its name, it is self-contained, and it looks like
the rest of SACRED. Everything else is Rohit's call.

---

## 1. Where it lives and the one rule about the name

| | |
|---|---|
| File on the share | `\\sdrlazneuiis01d.corp.local\sacred\Riser Tally Tool.html` |
| Link people use | `http://sdrlazneuiis01d.corp.local:8080/sacred/Riser%20Tally%20Tool.html` |
| Who serves it | IIS on the sacred server; the folder is a plain file share, no build, no deploy pipeline |
| Neighbours | `dashboard\`, `precharge\`, `aab\`, `help\` (ours), `WCE Rig Visit Reporting Tool` and `SSORT` (the two reporting tools) |

**The name never changes.** Every link that will ever point at this tool (the SharePoint tile, bookmarks on rig
laptops, a future dashboard button) is the URL above. If the file is renamed, every one of them breaks the same minute.
Revisions go *inside* the file (section 2), never in the file name. `Riser Tally Tool v2.html` is the one thing not to do.

The `%20` in the link is the space in the file name. It works everywhere; it is just worth knowing the space is there
when the link is typed by hand.

**Honest note about the server.** The sacred server (`sdrlazneuiis01d`, the `d` is for development) is ISIT's
sandbox. ISIT are deciding in October whether it becomes the production server or a production server is built.
If the host name ever changes, the link changes once and Dan will tell you. Nothing else about this page changes.

---

## 2. How we update: save over the old file

1. Build and test the new revision locally. Open it from disk in Edge (the rigs' browser) and check it still works
   with no internet, because the file must be self-contained (section 3).
2. Put the revision number and date in the file's own header, where a user can see it (we use `REV 12 · 1 Oct 2026`
   in the banner's right-hand corner). Keep a one-line change log at the foot of the file or in a separate notes file;
   you will be asked "which revision is on the rig" more often than you expect.
3. Copy the new file **over** the old one on the share, same name. That is the whole deployment. IIS serves the new
   file on the next request.
4. Tell users to press **Ctrl+F5** once. Edge caches the page; a plain refresh can show the old revision for a while.
   This is the single most common "it has not updated" report we get, and it is always the cache.
5. Keep a copy of every revision you have shipped, locally, named with its revision number (`Riser Tally Tool REV 12.html`).
   The share holds only the live file, so your local copies are the history and the rollback.

**Rollback** is step 3 with the previous file. Nothing else to undo.

**Write access to the share.** Dan has write on `\sacred`. If Rohit does not, send Dan the file and he places it; or
ask ISIT (Adam Snyder) for write on the share, which is the long-term answer for a tool with its own maintainer.

---

## 3. Rules of the house for a SACRED page

These are the things every tool on the share follows. They exist because the rigs' laptops, their network and their
browser are not the office.

- **One self-contained HTML file.** CSS and JavaScript inline, images as `data:` URIs, fonts from the system
  (`"Segoe UI", Arial, sans-serif`). No `<link>` or `<script src>` to a CDN or to another file: rig networks block or
  slow outside hosts, and a second file on the share is a second thing to keep in step. Your current file already does
  this; keep it that way.
- **Nothing secret in the file.** No passwords, no API keys, no URLs with signatures or tokens. The file is readable by
  anyone who can reach the share, and it will be opened in a text editor by someone eventually.
- **No personal data the tool does not need.** Names of the people running the tally are fine. Keep it to that.
- **Browser storage is per machine, per browser.** `localStorage` auto-save (which your tool uses) is the right thing for
  a working tally. Say so on the page, as you already do, so a user does not expect the tally to follow them to another
  laptop. If a tally ever needs to be kept as a record, it leaves the browser by Print / Save as PDF or by export, not
  by relying on the browser.
- **Edge is the browser.** Test in Edge. Avoid features newer than about 2023.
- **Size.** Our tools are 1 to 3 MB; keep the file under 5 MB. A large logo image is the usual cause of bloat;
  the one in section 4 is 87 KB.
- **Print works.** Users print to PDF constantly. Keep a `@media print` block that hides the toolbar and fits A4.
- **No install, no PowerShell, no build step.** A file that opens by double-click is the standard.

---

## 4. Branding: the SACRED banner

Every SACRED page has the same banner: Seadrill blue, a thin gold rule under it, the white logo on the left, a
one-line eyebrow in gold capitals, the page title in white, and the revision stamp on the right. Your current header
uses a lighter blue gradient; swapping it for this makes the tool read as part of the same family.

**Tokens**

| Token | Value | Use |
|---|---|---|
| Seadrill blue | `#002C77` | banner background, primary buttons, headings |
| Seadrill gold | `#EDB71E` | the 3 px rule under the banner, eyebrow text, highlights |
| White | `#ffffff` | banner text, page cards |
| Page background | `#f4f6fa` | behind the cards |
| Ink | `#1b2733` | body text |
| Font | `"Segoe UI", Arial, Helvetica, sans-serif` | everything |

**The logo.** `seadrill-logo-white.png` is in this folder (the white logo the dashboard banner uses, 478 by 175 px,
87 KB). Embed it as a `data:` URI so the file stays self-contained. One PowerShell line gives you the string:

```powershell
"data:image/png;base64," + [Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\path\seadrill-logo-white.png"))
```

**Banner CSS**

```css
:root { --sd-blue:#002C77; --sd-yellow:#EDB71E; --sd-white:#ffffff; --bg:#f4f6fa; --ink:#1b2733; }
body { font-family:"Segoe UI", Arial, Helvetica, sans-serif; background:var(--bg); color:var(--ink); margin:0; }
.page-banner { background:var(--sd-blue); padding:22px 32px 18px; display:flex; align-items:center; gap:18px;
               border-bottom:3px solid var(--sd-yellow); }
.page-banner .logo-img { height:34px; width:auto; display:block; }
.page-banner .banner-divider { width:1px; height:36px; background:rgba(255,255,255,0.25); flex-shrink:0; }
.page-banner .banner-title { color:var(--sd-white); flex:1; }
.page-banner .eyebrow { display:block; font-size:10px; font-weight:700; letter-spacing:0.12em;
                        text-transform:uppercase; color:var(--sd-yellow); margin-bottom:3px; }
.page-banner h1 { font-size:17px; font-weight:700; color:var(--sd-white); margin:0; }
.page-banner .banner-meta { flex-shrink:0; text-align:right; font-size:10px; font-weight:700; letter-spacing:0.14em;
                            text-transform:uppercase; color:rgba(255,255,255,0.45); line-height:1.4; }
@media print { .page-banner { -webkit-print-color-adjust:exact; print-color-adjust:exact; } }
```

**Banner HTML**

```html
<header class="page-banner">
  <img class="logo-img" alt="Seadrill" src="data:image/png;base64,PASTE-THE-STRING-HERE">
  <div class="banner-divider"></div>
  <div class="banner-title">
    <span class="eyebrow">Well Control Equipment · Technical Services</span>
    <h1>Riser Tally Tool <span id="hdrRig" style="color:var(--sd-yellow)"></span></h1>
  </div>
  <div class="banner-meta">REV 12<br>1 Oct 2026</div>
</header>
```

Buttons: primary is blue background, white text; secondary is white background, blue text and a 1 px blue border;
6 px corner radius. Status colours we use elsewhere, if you need them: green `#1e9e57`, amber `#f5b301`, red `#c0392b`.

---

## 5. The rig drop-down: the list, and how to wire it

Across SACRED a rig is identified by its name, spelled exactly as below. The two reporting tools, the dashboard, the
notification flows and the database all key on this string (`meta.asset` in the reporting contract). If the tally
tool uses the same spellings from day one, anything that joins it to SACRED later is a straight match.

**The fleet list, in the order the reporting tools show it (SSORT REV 153, WCGRRT REV 166, 1 October 2026):**

```javascript
var RIGS = [
  "West Auriga", "West Vela", "Sevan Louisiana", "Sonangol Libongos", "Sonangol Quenguela",
  "West Gemini", "West Polaris", "West Carina", "West Jupiter", "West Saturn", "West Phoenix",
  "West Capella", "West Neptune", "West Tellus"
];
// "SSCE Equipment" is the reporting tools' not-rig-specific / test option. Leave it out of a tally tool.
```

**Capability now, behaviour unchanged.** The simplest way to add the capability without changing anything for the
West Vela crew today: the drop-down defaults to West Vela and the per-rig defaults table has one entry, West Vela's,
which is the `INPUT_DEFAULTS` you already have. Every other rig falls back to blank inputs until someone fills in its
constants. Nobody has to use the drop-down until they want to.

```html
<label>Rig
  <select id="rig" onchange="onRigChange(this.value)"></select>
</label>
```

```javascript
// Per-rig defaults, keyed on the exact rig name. Start with the one you have; add rigs as their constants arrive.
var RIG_DEFAULTS = {
  "West Vela": { WATER_DEPTH: 0, WH_STICKUP: 0, TREE: 0, BOP: 0, MPD: 0, SHUTTLE: 0, TARGET_SPACEOUT: 0 /* your INPUT_DEFAULTS */ }
};
var RIG_KEY = "riserTally.rig";

function fillRigSelect() {
  var sel = document.getElementById("rig");
  sel.innerHTML = '<option value="">— Select Rig —</option>' +
    RIGS.map(function (r) { return '<option>' + r + '</option>'; }).join("");
  var saved = localStorage.getItem(RIG_KEY) || "West Vela";
  sel.value = saved;
  onRigChange(saved, true);
}

function onRigChange(rig, silent) {
  localStorage.setItem(RIG_KEY, rig);
  document.getElementById("hdrRig").textContent = rig ? "· " + rig : "";
  var d = RIG_DEFAULTS[rig];
  if (!silent && d) {
    // Load that rig's constants into the inputs. If the user has a tally in progress, ask first.
    if (confirm("Load " + rig + " defaults? This replaces the current inputs.")) applyDefaults(d);
  }
  // Keep each rig's auto-save separate so switching rigs does not overwrite another rig's tally:
  // use KEY = "riserTally." + rig for localStorage, instead of one key for the whole tool.
}
```

Two design points that matter later, cheap now:

- **One auto-save key per rig** (`riserTally.<rig name>`), so a West Vela tally and a West Capella tally can both exist
  on the same laptop (a technical superintendent's, for instance).
- **Rig name on every export.** Put the rig name in the CSV header and in the printed title, so a tally that leaves the
  tool carries its identity with it.

---

## 6. Later, if and when it joins SACRED properly (nothing to do now)

- **A button on the dashboard** or a tile anywhere is just the link in section 1. Dan adds a dashboard header button
  in a scanner release when asked; nothing in the tool changes.
- **The SharePoint tile** is the same link. It will open the tool in the browser from SharePoint; the tool itself stays
  on the sacred share, not in SharePoint, because IIS serves HTML and SharePoint downloads it.
- **Posting a tally into SACRED as a record** (so the dashboard shows it per rig and the database keeps it) is a
  separate conversation with its own contract: a JSON file named by convention, posted through an HTTP trigger, the
  rig name in `meta.asset`, a size ceiling. Dan shares the contract the day it is wanted. Using the rig names above
  and keeping the rig name on exports is all the preparation it needs.

---

## 7. What SACRED would like from Rohit, once

1. Confirm the tool's display name (we have used "Riser Tally Tool") and the revision stamp you will use.
2. Confirm the file is self-contained (no external links) and its size.
3. Whether you want write access on the share from ISIT, or will send Dan each revision to place.

Questions through Dan. There is no change-control form for a standalone tool; the revision stamp in the banner and
your own change log are the record.
