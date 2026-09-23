# Handoff — the password gate pattern, for rebuilding in another app

**From:** the Seadrill Precharge Pro session · **Date:** 23 September 2026
**Purpose:** you are building a new app with a **landing page that takes a password, then leads
to a separate dashboard.** This is how our gate works, why each decision was made, what it does
*not* protect, and the traps that cost us real outages — so you can rebuild it without
repeating them.

**Read §1 and §3 before you write any code.** §3 is the one that changes your architecture.

---

## 1. What this pattern actually is — be honest about it up front

Our gate is **a curtain, not a lock.**

It is a full-screen overlay rendered on top of a page whose content is *already fully present in
the file*. Entering the password hides the overlay. It does not decrypt anything, it does not
fetch anything, and it does not ask a server whether you are allowed in.

Concretely, anyone who does `curl` on the page, or opens View Source, or hits Ctrl-U, has all of
the content without ever seeing the password box. On our share, the gate also does nothing about
a direct URL to the JSON data files sitting next to the page.

**So the pattern is appropriate when:**
- the content is internal-but-not-sensitive, and you mainly want to stop casual/accidental use,
  wrong-audience access, or someone stumbling in from a SharePoint link;
- you cannot get server-side authentication in a reasonable timeframe;
- the real control is that the URL is not published outside the org.

**It is NOT appropriate when:**
- the content is commercially or personally sensitive;
- "unauthorised access" would be a reportable event;
- you need to know *who* logged in (this pattern has no identity at all — one shared password,
  no usernames, no audit trail).

If your new app is in the second category, stop and ask IT for **IIS Windows Authentication** on
the virtual directory. That is a configuration change, not a development project, and it gives
you real identity for free. Everything below is the fallback for when you cannot get it.

I am putting this first because it is the single most important thing to carry across. We wrote
it down in our own gate's header comment and it has kept expectations honest for months.

---

## 2. How ours works — the mechanism

Four moving parts:

| Part | Role |
|---|---|
| **The overlay** | A `position:fixed; inset:0; z-index:100000` div covering the whole viewport, containing a form with one password field. |
| **The config file** | A tiny separate JS file, loaded *before* the gate, that sets one global: `window.PCGATE = { hash, hint }`. **The password is not in it** — only a SHA-256 hash of it. |
| **The hash check** | On submit, compute `sha256(SALT + entered)` and string-compare against `cfg.hash`. Match → hide the overlay and fire an event. No match → error message, reselect the field. |
| **The unlock token** | On success, write a `localStorage` key so the user is not re-prompted on every page load. |

### The flow

```
page loads
  └─ <script src="gate-config.js">   sets window.PCGATE = {hash, hint}
  └─ gate script runs
       ├─ no cfg.hash?          → fail closed: disable the field, show "not set up yet"
       ├─ valid unlock token?   → hide the overlay immediately, fire 'pcgate-unlocked'
       └─ otherwise             → show the overlay and wait
                                    └─ submit → sha256(SALT + pw) === cfg.hash ?
                                         ├─ yes → write token, hide overlay, fire event
                                         └─ no  → "Incorrect password."
```

### The salt

A fixed string prepended to the password before hashing:

```js
var SALT = 'seadrill-precharge-gate|';
```

It is not secret — it is visible in the page source. Its job is to stop a generic rainbow table
for common passwords resolving your hash directly. **Use a different salt string for your new
app**, containing the app's name. That way the same password in both apps produces different
hashes, which keeps the two independent (see §3 on why that matters for localStorage).

### The unlock token — this bit is more carefully designed than it looks

```js
var KEY = 'pcgate-unlocked:' + String(cfg.hash || '').slice(0, 12);

function unlocked() {
  try {
    var v = localStorage.getItem(KEY); if (!v) return false;
    var exp = Number(v); return exp === 0 || exp > Date.now();
  } catch (e) { return false; }
}
// on success:
localStorage.setItem(KEY, rem.checked ? '0' : String(Date.now() + 12 * 3600 * 1000));
```

Three deliberate decisions in there:

1. **The key is derived from the password hash.** So when you change the password, every
   existing unlock token is instantly orphaned and everyone is re-prompted. You get revocation
   for free, with no extra mechanism. This is the nicest property of the whole design — do
   reproduce it.
2. **The value is an expiry timestamp, not a boolean.** `0` means "never expires" (the *remember
   on this computer* tick); anything else is a millisecond deadline, default 12 hours.
3. **Every access is wrapped in try/catch.** `localStorage` throws in a private window, with
   site data blocked, and in some kiosk configurations. A gate that throws on a storage read is
   a gate nobody can get through. Failing to "not unlocked" is the correct direction.

### Fail closed

```js
if (!cfg.hash) {
  err.textContent  = 'This page has not been set up yet.';
  hint.textContent = 'Contact Technical Services — Subsea to have the password set.';
  pw.disabled = true; form.querySelector('button').disabled = true;
  return;
}
```

If the config file is missing or malformed, the page **locks** rather than opens. This is the
right default for a served page, and you must get it right: the natural lazy implementation
(`if (cfg.hash && sha256(...) !== cfg.hash) return;`) fails *open* when the config is absent,
which means a deploy that forgets one file silently publishes your app to everyone.

⚠ **This has a consequence you must plan for** — see §6 on the two-builds rule.

---

## 3. ⚠ Your architecture: landing page → separate dashboard

**This is the part that needs the most care, and the obvious implementation is wrong.**

The tempting design is: landing page checks the password, and on success does
`location.href = 'dashboard.html'`.

**That protects nothing.** Anyone who types, bookmarks, or is sent the dashboard URL goes
straight in. The password becomes a speed bump on one page that nobody has to visit. We have
seen exactly this pattern shipped elsewhere and described as "password protected".

### Do this instead

**Put the same gate on every page, and let the token carry the session.**

```
landing.html    ─ gate + gate-config.js ─┐
dashboard.html  ─ gate + gate-config.js ─┤─ same origin → same localStorage
reports.html    ─ gate + gate-config.js ─┘   → unlock once, all pages open
```

Because `localStorage` is scoped to the **origin** (scheme + host + port), not to the folder or
the file, the token written by the landing page is readable by the dashboard page. So the user
is prompted once and every subsequent page opens without a prompt — which *feels* exactly like
"log in, then go to the dashboard", but each page is independently protected.

The landing page then becomes what it should be: a front door and a nice first impression, not
the security boundary.

**Rules that follow from this:**

- **Every page that should be protected carries the gate.** If you add a page later and forget,
  that page is public. Make it a build-time assertion, not a memory item (§6).
- **All pages must share one origin.** `http://server:8080/app/…` for all of them. Mixing a
  `file://` copy with a served copy gives you two separate localStorage stores and the token
  will not carry.
- **Use the same `gate-config.js` content for all pages in the app** — same hash, therefore same
  `KEY`, therefore one unlock. Each folder can hold its own copy of the file (the `src` is
  relative); they just need identical contents.
- **Use a different salt from any other app**, so that the same password in two apps yields
  different hashes and different keys. Otherwise unlocking app A silently unlocks app B, which
  is a surprise nobody wants and a leak nobody notices.

### If the dashboard loads data separately

If your dashboard fetches JSON/CSV from the server rather than embedding it, remember the gate
does not protect those endpoints — a direct URL returns the data. Either accept that (and say
so), or use the `pcgate-unlocked` event to gate the *fetch*, understanding that this is still
only a curtain because the URL remains reachable.

We expose that moment as an event precisely so downstream code can hang off it:

```js
function open() { gate.hidden = true; document.dispatchEvent(new Event('pcgate-unlocked')); }
// consumer:
document.addEventListener('pcgate-unlocked', function () { loadTheDashboard(); });
```

That is how our requests inbox re-reads its index the moment the gate opens — worth copying,
because it avoids doing expensive work behind a locked overlay.

---

## 4. The hashing — and the one decision you should make differently

Ours hand-rolls SHA-256 in plain JavaScript. **That was forced on us and you may not need it.**

The reason: our app is served over plain `http://` on the intranet, and
`window.crypto.subtle` is **only available in secure contexts** (https, or localhost). On
`http://server:8080/…` it is simply `undefined`. So we could not use the platform's own
crypto and had to ship an implementation.

**Decide this first for your new app:**

| Your situation | Do this |
|---|---|
| App will be served over **https** (or you can get a cert) | Use `crypto.subtle`. Skip the hand-rolled hash entirely. Better still, use **PBKDF2** with 100k+ iterations rather than a single SHA-256 round. |
| App will be plain **http** intranet, like ours | You must hand-roll. Then §5 applies in full. |

### Why PBKDF2 matters if you can have it

Your hash is published. It sits in a JS file that anyone who can reach the page can download.
A single round of salted SHA-256 over a human-chosen password is brute-forceable offline in
**seconds to minutes** on a laptop. With PBKDF2 at 100k iterations that becomes days to years.

If you are stuck on single-round SHA-256 (as we are), the mitigation is entirely in the password
itself: **make it long and not guessable** — a passphrase of several unrelated words, not
`Seadrill2026!`. Say this out loud to whoever sets it, because the design gives them no other
protection.

---

## 5. The traps — every one of these cost us something real

These are the expensive lessons. They are what this handoff is actually for.

### 5.1 Never let the hash function or the salt exist in two places

We have two pages that must hash identically: the gate itself, and the page that *sets* the
password. Early on those were two copies of the same code.

**Two independent copies of a hash function and a salt are a lockout waiting to happen.** One
character of drift and the correct password is rejected, with no way back in but editing a file
on the server.

Our fix: the password-setting page is **generated at build time**, and the builder **lifts the
`sha256()` body and the `SALT` literal verbatim out of the gate source**. Neither is ever
retyped:

```python
i = gate.find('  function sha256(str) {')
if i < 0: sys.exit('FAIL: sha256() not found in gate-fragment.html - has it changed?')
…
m = re.search(r"var SALT = '([^']*)';", gate)
if not m: sys.exit('FAIL: SALT not found in gate-fragment.html')
```

If you cannot generate, then put the hash function and salt in **one shared `.js` file** that
both pages load. Just never have two.

### 5.2 Self-test the hash implementation and refuse to run if it fails

Our password-setting page checks its own SHA-256 against the two published NIST vectors on load,
and **disables itself** if they do not match:

```js
var VECTORS = [
  ['',    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'],
  ['abc', 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad']
];
var broken = VECTORS.filter(function (v) { return sha256(v[0]) !== v[1]; });
if (broken.length) { /* disable every field, explain why */ }
```

The reasoning: a page that cannot hash correctly must refuse to write a config, rather than hand
out a lockout. Two lines of code, and it converts a silent catastrophic failure into a visible
refusal. **Copy this.**

### 5.3 The password file is not a build artefact — and a wildcard copy will eat it

This one caused a real outage. **On 11 September a single wildcard copy pushed a stale
`gate-config.js` over the live one and locked every user out of the tool.**

```powershell
Copy-Item 'C:\…\app\*' '\\server\share\app\' -Force     # ← this reverted the password
```

The config had only ever existed in a Downloads folder and on the share; the local deploy folder
held an older one. The publish swept it up as if it were a build output.

**Rules that came out of it, all of which transfer:**

- **Publish named files, never a wildcard.** List the two or three files the build produces.
- **The config file must be identical in the deploy source and the published folder at all
  times.** If they ever differ, the next deploy — for any unrelated reason — silently reverts
  the password, with no error. Nobody finds out until the calls start.
- **When the password changes, write it to both locations in the same action**, then hash-compare
  them. Putting it in both is what makes the *next* publish safe, rather than merely recovering
  this one.
- **Exclude the config from any automated sync** between machines. It is the one file in the
  folder that is not generated.
- If you script the publish, **guard it**: compare the two configs by SHA-256 and refuse to
  overwrite a differing one without an explicit `-IncludePassword` switch. We had that guard,
  and then talked ourselves into a shorter one-line wildcard because it was less ceremony. The
  switch *was* the safety feature.

We have a full written procedure for this if it is useful as a template:
`Fleet Nitrogen Precharge Request Tool\PROCEDURE - Changing the precharge tool password and copying it safely.pdf`.

### 5.4 The hint is usually most of the password

Our login card originally printed the password hint on screen for anyone who loaded the page.
The hint in use was *"WCEG is number one"* — which was not a reminder so much as the password.

Now it sits behind a **"Need the password?"** button, and the button **hides itself when no hint
is configured** rather than revealing an empty box. (Ours currently ships with `hint: ""`, so no
button appears at all.)

If you offer a hint field, treat whatever goes in it as public.

### 5.5 A login screen must not publish your infrastructure

Our fail-closed message used to name the server share path and a setup script. A login screen is
the most-reachable page you have — it should not tell an unauthenticated visitor your UNC paths,
script names, or folder layout.

The build now **exits** if `TSC-Dashboard`, `Deploy-Dashboard` or `index.html` appears anywhere
in the gate markup. Assert the *outcome* ("no server path reaches the login screen"), not that a
particular string was found and rewritten — we got that backwards once, and the build started
failing the moment the other team fixed the text themselves.

### 5.6 Mixed content will make your app look broken, with no error

Our SharePoint entry point has to be a **link**, not an embed. SharePoint is `https://` and our
share is plain `http://`; browsers block mixed active content, so an iframe or embed web part
renders **empty with no error message**. It looks exactly like the tool is broken.

If your landing page will be reached from SharePoint or Teams, make it a link, or get https.

### 5.7 Assert behaviour, never prose

We pinned the exact fail-closed wording in two test harnesses. A cosmetic reword broke both
tests while the gate was working perfectly. The tests now assert that it *sets an explanation*
and *disables the field* — not what the sentence says.

---

## 6. Build discipline: the two-builds rule

Fail-closed (§2) has a consequence. The gate is correct for a served page and **fatal for a
local one** — if someone opens the file from disk with no config beside it, they get a blue
login screen and nothing else, forever.

We needed an offline copy to keep working (open the HTML from disk, load a saved file by hand),
so we produce **two builds from one set of sources**:

| Build | Gate? | Where it lives |
|---|---|---|
| ungated | no | offline use, email, frozen approved baselines |
| gated | yes | the share — the only one ever published |

The builder **injects** the gate into the second one rather than the gate being hand-pasted into
a maintained file, and it **self-checks that the shared body of the two builds is byte-identical**
so they cannot quietly become two different applications.

If you need an offline mode in the new app, do the same. If you do not, skip it — but then
assert at build time that **every** page carries the gate, so a page added later cannot ship
unprotected. That assertion is the cheapest insurance in this whole document.

Two more build-time checks worth stealing:

- **The gate must be the first thing in `<body>`.** Ours asserts `index('id="pcgate"') <
  index('<header')`. If any content renders above the overlay in the DOM order, there is a
  visible flash of the real page before the overlay paints.
- **Match markup as markup.** We asserted `count('<body>') == 1` and it broke the day the app
  gained a feature that put `<body>` inside a JavaScript string literal. Anchor on something
  unambiguous like `'</head><body>\n<header'`.

---

## 7. Setting and changing the password

There is no server, so "setting the password" means **generating the config file**.

We ship a small standalone page that:

1. self-tests its SHA-256 against the NIST vectors and disables itself on failure (§5.2);
2. takes the new password twice, plus an optional hint;
3. computes `sha256(SALT + password)`;
4. offers the resulting `gate-config.js` as a download.

Output:

```js
/* Created <timestamp> by set-password.html.
   SHA-256 of the password with a fixed salt. The password itself is NOT here
   and cannot be recovered from this file. Never commit it. */
window.PCGATE = {
  hash: "…64 hex chars…",
  hint: ""
};
```

The operator then copies that one file to **both** the deploy source and the published folder,
and hash-compares them (§5.3).

**Do not skip building this page and hand-write the config instead.** The whole point is that
the hash is produced by the same code that will verify it.

---

## 8. How to verify your gate actually works

Three checks, in increasing strength. All of them run in Node with no browser.

**1. Equivalence.** Extract the gate's script from the built page, run it against a stubbed
`document`/`localStorage`, and assert its `sha256` agrees with `node:crypto` on a range of
inputs — including non-ASCII, which is where hand-rolled UTF-8 handling usually breaks:

```js
const probes = ['hunter2', 'x', 'a very long passphrase with spaces', '°C — 5° Précharge'];
for (const p of probes) {
  const ours = GATE.sha(SALT + p);
  const node = crypto.createHash('sha256').update(SALT + p, 'utf8').digest('hex');
  assert(ours === node);
}
```

**2. Round trip.** Drive the *real* password-setting page, take the `gate-config.js` it
produces, feed it to the *real* gate, and prove the gate accepts the password that made it.
This is the check that would have caught every lockout we nearly had.

**3. Behaviour.** Assert: wrong password is rejected; missing config disables the field; a valid
token opens without prompting; an expired token does not; `localStorage` throwing does not break
the page.

> **Note for whoever picks this up in our repo:** our own equivalence harness,
> `build/_gatecheck.js`, currently has two hard-coded paths to a sandbox mount that no longer
> exists, so it cannot run as-is. The fix is to resolve the published folder at run time (try the
> share, then the deploy source) instead of the literal path. I have not applied it — say the
> word and I will.

---

## 9. Minimum spec, if you just want the checklist

- [ ] Overlay is `position:fixed; inset:0`, high `z-index`, **first element in `<body>`**
- [ ] Config is a **separate file** setting one global; contains a hash, never a password
- [ ] Salt is **app-specific** and prepended before hashing
- [ ] Missing/invalid config → **fail closed**, field disabled, no infrastructure named
- [ ] Unlock token key **derived from the hash**, so a password change revokes everything
- [ ] Token value is an **expiry**, with an explicit never-expires option
- [ ] Every `localStorage` access in **try/catch**, failing to "locked"
- [ ] **Every protected page carries the gate** — never redirect-after-login
- [ ] All pages on **one origin** so the token carries
- [ ] Hash function + salt exist in **exactly one place**
- [ ] Password-setting page **self-tests against NIST vectors** and disables on failure
- [ ] Publish **named files, never a wildcard**; config excluded from sync
- [ ] Config **identical** in deploy source and published folder, hash-verified
- [ ] Build asserts: gate present on every page, gate first in body, no paths leaked
- [ ] Tests assert **behaviour**, not wording
- [ ] Written down somewhere that this is **a curtain, not a lock**

---

## 10. Source files, if you want to read the real thing

All under `C:\Users\danplant\Claude\Projects\Fleet Nitrogen Precharge Tool\Fleet Nitrogen Precharge Request Tool\build\`:

| File | What |
|---|---|
| `gate-fragment.html` | the gate itself — markup, CSS, SHA-256, the whole mechanism (~7 KB, most of it the hash function) |
| `set-password.html` | the generated config-writer |
| `build_setpw.py` | generates the above; shows the verbatim-lift technique (§5.1) |
| `build_served.py` | injects the gate; all the build-time assertions (§6) |
| `_gatecheck.js` | the equivalence harness (see the note in §8) |
| `test_setpw.js` | 30 checks including the round trip |

Live example to look at: `http://sdrlazneuiis01d.corp.local:8080/sacred/precharge/`

---

*Written for a from-scratch rebuild, not a copy-paste. If you diverge from anything here,
diverge deliberately — most of these came out of something breaking.*
