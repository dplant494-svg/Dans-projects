# ORR return — Seadrill Precharge Pro

**Tool:** Seadrill Precharge Pro — BOP Accumulator Nitrogen Precharge Calculator, **Rev 87**
**Request form:** Seadrill BOP Precharge Request, **Rev 3**
**Owner:** Daniel Plant, Technical Services — Subsea · **MOC:** Synergi #1856051
**From:** the Precharge Pro session, via Dan · **Date:** 30 September 2026 · **Due:** 7 October 2026
**Against:** `ORR-HANDOFF-FOR-TOOLS.md`, items 1–5 for this tool

> **Read this first — what this tool does.** It sets the nitrogen precharge pressure that rig
> crews charge BOP accumulator bottles to, on the seabed. **A wrong number means a BOP pull**, and
> in the worst case a shear ram that does not complete its stroke. It is not a reporting tool.
> That governs everything below: the verification is per-rig rather than per-release, and the
> controls that matter are the ones that stop a wrong number reaching a rig.

---

## 1. Runbook — ORR 6, 7

### 1.1 What a revision is

The calculator is **one self-contained HTML file**. There is no server-side code, no database and
no runtime dependency except two CDN scripts (jsPDF + jspdf-autotable) used only to generate the
PDF. A revision is a rebuild of that file.

It is **built by concatenating six source files** — never hand-edited:

```bash
cat head_clean.html n2eos2.js he_eos.js engine_inline.js ui_clean.js tail_clean.html \
    > "Seadrill BOP Precharge Calculator.html"
```

Sources live in `Fleet Nitrogen Precharge Request Tool\build\`.

**Two deliverables are built from those same sources**, and they must stay two files:

| File | Gate? | Purpose |
|---|---|---|
| `Seadrill BOP Precharge Calculator.html` | no | offline use, email route, frozen approved baselines |
| `calculator.html` | yes | **the only one ever published** |

`build_served.py` produces the second by injecting the password gate and the requests-inbox
pane, and **self-checks that the engine section is byte-identical between the two** so they
cannot drift into being different calculators. The ungated build must never be published — on the
share, anyone with the URL would walk straight past the password.

### 1.2 Build and verify, step by step

1. **Rebuild** both deliverables from `build/` (above, then `build_served.py`).
2. **Run the full suite on both builds** — see §2.3. Everything must pass before delivery.
3. **Prove the scope.** Precharges are issued one rig at a time, so a change must be shown to
   have moved *only* the intended rig. `_rigdiff_iso.py` drives the real `compute()` on all 13
   rigs at their own presets and diffs **39 output containers**, printing `same` or `MOVED` per
   rig. A release that moves an unintended rig is stopped here.
4. **Record the hashes** (§1.3).
5. **Deliver to all three destinations** (§1.4).
6. **Confirm it landed** (§1.5).

### 1.3 The hashes we record every release

SHA-256, first 32 hex, recorded per release for the working copy, the deploy source and the
share. Current state, **Rev 87**:

| Artefact | Path | SHA-256 (first 32) |
|---|---|---|
| Working copy (ungated) | project folder | `13BCC05B46112D72D76E573E1D48152D` |
| Deploy source (gated) | `C:\TSC-Dashboard\precharge\calculator.html` | `D32368407165BD2F5A3DE5A1C190C552` |
| **Published (gated)** | `\\…\sacred\precharge\calculator.html` | `D32368407165BD2F5A3DE5A1C190C552` |
| Set-password page | both | `B430B3BD7F0CE0FB69819542D49D6AB1` |
| Gate config | both | `8E16054C03291115713EF437E4243727` |
| Request form | project + SSORT | `81596679291CF3E594D2A57841A9AFCD` |

**Deploy source and published must match.** They do, at Rev 87.

### 1.4 Publish — two files, by name, never a wildcard

```powershell
Copy-Item 'C:\TSC-Dashboard\precharge\calculator.html',
          'C:\TSC-Dashboard\precharge\set-password.html' `
          '\\sdrlazneuiis01d.corp.local\sacred\precharge\' -Force
```

⚠ **`Copy-Item '…\precharge\*'` must never be used.** On **11 September 2026** a wildcard copy
swept up `gate-config.js`, pushed a stale copy over the live one and **locked every user out of
the served tool** (register F-51). `Publish-PrechargeToShare.ps1` guards this: it compares the
two configs by SHA-256 and refuses to overwrite a differing one without `-IncludePassword`.
**That switch is the safety feature** — do not trade it for a shorter one-line wildcard.

Only those two files ever go to the share. **A delivery is not in front of anyone until that copy
happens**, and the local folder looks up to date either way (register F-44, open).

### 1.5 Smoke test through IIS, and what "nothing posted" means

1. Load `http://sdrlazneuiis01d.corp.local:8080/sacred/precharge/` in a private window.
2. The login card must appear. Enter the password.
3. **Read the revision in the page header.** `Rev <N>` matching the rev folder just delivered
   means the share is current; an older number means the copy did not happen. Check the served
   page, not the file — the local folder looks current either way.
4. Select a rig, enter a well and conditions, confirm a precharge renders and **Generate PDF**
   produces a 3-page document.
5. Force-reload with a cache-buster (`?cachebust=<rev>`) if the header shows the previous rev —
   browsers cache this page aggressively. This is how the Rev 86 defect was initially missed.

**"Nothing posted" during a test** means: **do not press *Post to Dashboard*.** Save, Export and
Generate PDF are all local to the machine and send nothing. *Post* writes an issued sheet to the
share against a request and **triggers the notification email to the rig**. A test post is
therefore a live communication to a rig, and is also hard to withdraw because the flow fires on
file creation. Use an obviously fictional well name (`TRAINING-nn NOT ISSUED`) for any test that
might be mistaken for real, and stop at Save.

### 1.6 Gate config on a fresh copy, and password reset

**There is no user database.** The gate is a single shared password, stored only as a salted
SHA-256 hash in `gate-config.js` beside the page. The plaintext password is stored nowhere.

**On a fresh copy**, the page needs `gate-config.js` in the same folder. Without it the gate
**fails closed** — the field is disabled and the page reports it is not set up. That is correct
for a served page. Generate the file with `set-password.html`; never hand-write it.

**Password reset**, in brief (full written procedure below):

1. Open `set-password.html`. It **self-tests its own SHA-256 against two published NIST vectors
   on load and disables itself if they fail** — if the page looks dead, stop; do not hand-write a
   config, or you will create a lockout.
2. Enter the new password twice. The hint is visible to anyone who clicks *Need the password?* —
   **do not make the hint the password.**
3. Download the generated `gate-config.js`.
4. **Copy it to BOTH the deploy source and the published folder**, by name.
5. **Hash-compare the two.** They must be identical. If they differ you are one deploy away from
   a repeat of F-51.
6. Test in a private window before telling anyone.

**Controlled procedure:** `PROCEDURE - Changing the precharge tool password and copying it
safely.pdf` (3 pages, issued 18 Sep 2026, in the project folder). Owner: Daniel Plant, sole
authority for this password.

**Honest limitation, for ORR:** the gate is **a curtain, not a lock.** The page content is fully
present in the file, so View Source or `curl` reaches it without the password, and it does
nothing about a direct URL to `requests/<id>.json` on the open share. Accepted for the sandbox;
server-side authentication or encrypted payloads are required before production. Register
**F-25 / F-25a**.

---

## 2. Test records — ORR 19

### 2.1 What "verified" means for this tool

**Verification is per rig, not per release.** Each rig's precharge is checked against **that
rig's own OEM accumulator sizing document** and, where one exists, the NOV well workbook NOV
issued for that well. A rig is *verified* when the engine reproduces the issued NOV figure to
within rounding **and that comparison is quoted in the MOC register**.

Standing instruction (operator, 15 Aug 2026): *"nothing is golden and nothing will be moved
across the fleet or multiple rigs unless I say."* There is **no fleet-wide basis** and no rig
inherits another rig's decision. A pattern holding on two rigs is not evidence for a third.

### 2.2 Verified-rig list, by rig

| Rig | Status | Basis | What was reproduced |
|---|---|---|---|
| **West Gemini** | **Verified** | Katambi-2 workbook; OEM "Sizing Bottles for Dedicated Shear — 110 USG Piston Acc" | Manual precharge 3,500 PSIG @ 86 °F → Cond 1 4,975.3 / Cond 2 BSR close 3,456.3 vs workbook 4,975 / 3,456; at 2,800 → 3,241.2 vs 3,241 |
| **West Vela** BOP 1 & 2 | **Verified** | OEM 20094525D Rev R | `Pressure(90 °F, 17.369) − 14.7 = 4,122.1` — Rev R's SELECTED figure to the psi |
| **West Neptune** | **Verified** | own workbook; fixed density 16.974 | split 4+4 sequence; KC736-2 Castile (4,105 psig required) inside envelope |
| **West Tellus** | **Verified** (Revs 84–87, Sep 2026) | `10656530-CAL Rev 05` + the proven manual method | ρ₁ 29.1878, ρ₀ 20.2058, charged 8,085.59 PSIA — agree to 4 dp; bank comparison pod pilot 4,907.0 vs 4,906.95, FSV 5,313.8 vs 5,313.54, acoustic 4,269.5 vs 4,269.47 |
| Sonangol **Libongos** + **Quenguela** | **In progress** (always done together) | `11008576-CAL Rev 07` | `dcbRho` reproduces the doc's Condition 0 exactly: 16.5307 → 3,866.4 / 3,881.1 |
| Auriga, Jupiter, Carina, Polaris, Saturn, Capella, Sevan Louisiana | **Not reviewed** | — | **Assume each is wrong until checked** against its own sizing doc. Register **F-07**, **F-15**. |

⚠ **Seven of thirteen rigs are not yet verified.** They still carry legacy shared defaults (pod
pilot 2700, LMRP 1260, FSV 900, EHBS pilot 1600). This is a **known and deliberate** state — the
rollout is per rig as requests arrive — but ISIT should see it plainly rather than infer that
"Rev 87 passed its tests" means the whole fleet is verified. It does not.

### 2.3 Automated test suite — run on BOTH builds before every delivery

| Harness | Proves | Count |
|---|---|---|
| `qualify_node.js` | physics / behaviour envelope (needs `scenarios.json` present) | **47** |
| `_rigdiff_iso.py` + `_rigdiff_one.js` | all 13 rigs × 39 containers — scope proof | 13 rigs |
| `test_contractual.js` | Petrobras contractual model vs Rev 05's four cases | 16 |
| `test_pdf_contractual.js` | the panel reaches the **printed PDF** (real `buildPdfDoc`, jsdom, recording jsPDF) | 21 |
| `test_hopguard.js` | blank/zero water-depth guard | 26 |
| `test_sheethtml.js` | posted HTML copy self-contained, carries the temperature table | 38 |
| `test_inbox.js` | served build, gate SHA-256 vs `node:crypto`, fail-closed, two-tab shell | 59 |
| `test_setpw.js` | `set-password.html`, incl. **round trip** into the real gate | 30 |
| `test_reqform.js` | both request-form builds against their own markup | 29 |
| `test_saveload.js` | save/load round trip | — |
| `check_encoding.py` | UTF-8 / cp1252 / CRLF / BOM on all six sources and five deliverables | — |
| **`_verify_samples.js`** | **acceptance test** — every sample file loads back through the real `loadState()` and reproduces its sheet | 3 files |

### 2.4 Test record by revision

| Rev | Date | What was checked | Result |
|---|---|---|---|
| 83 | 14 Sep 2026 | full suite, both builds | 47/47 both; pass |
| 84a | 18 Sep 07:09 | + `test_hopguard` (blank water-depth freeze guard) | 26/26; 47/47; zero rigs moved |
| 84b | 18 Sep 12:35 | well-hop header corrected | 47/47; zero rigs moved |
| 84 | 18 Sep 15:56 | the eight Tellus changes | 47/47 both; **MOVED: tellus only**, 12 rigs `same` |
| 85 | 18 Sep 16:57 | + `test_contractual` (acoustic two-shear, MOPFLPS seals, design-factor fix) | 16/16; 47/47; Tellus only |
| 86 | 18 Sep 20:36 | + `test_pdf_contractual` | 21/21; 47/47 — **but see §2.5** |
| **87** | **19 Sep 09:55** | full suite + new `check_encoding.py` | **47/47 both; 21/21; 16/16; 26/26; encoding clean; zero rigs moved; request form byte-identical to Rev 83** |
| — | 29 Sep 2026 | `_verify_samples.js` on the three training files | all load and reproduce |

### 2.5 Two disclosures ISIT should have

**A. Rev 86 shipped a defect to the live share for about 13 hours.** A rev-bump done with
PowerShell read a BOM-less UTF-8 source as cp1252 and re-encoded it, corrupting every em-dash in
the markup. The page title on the live server read `Seadrill Precharge Pro â€" BOP Precharge
Calculator`. **No calculated figure was affected and no issued precharge changed.** It was found
by the operator looking at his browser tab, **not by the suite** — every harness compared numbers
and behaviour, none looked at how text was encoded. Fixed in Rev 87 by restoring the source
byte-exactly; `check_encoding.py` now runs in the proof set (17 hits on Rev 86, 0 on Rev 87).
Register **F-67**.

**B. One harness cannot currently run.** `_gatecheck.js` — which proves the gate inlined in our
build and the gate published on the share compute identical hashes — contains two hard-coded
paths to a sandbox mount that no longer exists. **It has not been executed in its current form.**
The fix is to resolve the published folder at run time; it is not yet applied. This is the one
gap in the test record and it sits on the control that would catch a gate/salt divergence, which
is the failure mode that produces a lockout with no route back in but editing a file on the
server. **Recommend it is closed before the next password change.**

### 2.6 Acceptance test

`build/_verify_samples.js` is the acceptance test, as your handoff proposes. It loads each
saved report through the **real** `loadState()` and asserts the same rig, the same well and a
reproduced sheet. Current result:

```
ok   Seadrill_Precharge_gemini_TRAINING-03-NOT-ISSUED_TRAINING.json
ok   Seadrill_Precharge_nov_TRAINING-02-NOT-ISSUED_TRAINING.json
ok   Seadrill_Precharge_tellus_TRAINING-01-NOT-ISSUED_TRAINING.json
=== all sample files load and reproduce ===
```

---

## 3. Known error log — ORR 11

**Shape:** issue · effect · workaround · fix planned. These are the entries a **support
engineer** needs, because a user can hit them.

| # | Issue | Effect | Workaround | Fix planned |
|---|---|---|---|---|
| **F-44** | `C:\TSC-Dashboard\precharge` is the deploy **source**, not the served folder | A build can be delivered locally and **not reach any user**, while the local folder looks up to date | **Read the revision on the served page**, not the file. `Rev <N>` must match the rev folder. Force-reload with `?cachebust=<rev>` — this page caches hard | Documented; publish step is manual by design (the share cannot be mounted safely). Open |
| **F-68** | After the auto-optimum raises a failed precharge, the verdict banner keeps a stale sentence that contradicts itself (e.g. *"closes at 4,045 > required shear 4,105"*) | **Display only — no calculated value is affected.** A reader anchoring on the last sentence could conclude a passing sheet failed | Read the **OPTIMUM** line above it; that figure is correct | Rebuild the trailing sentence from the optimum result. Next rev |
| **F-69** | The same issued PDF has one filename when downloaded (`West_Tellus_…precharge.pdf`) and another inside the posted payload (`Seadrill_West-Tellus-…precharge.pdf`) | No precharge effect. **Document-control confusion** — the PDF is the controlled document, so two names invite the conclusion there are two documents | Treat them as one document; match on rig + well, not filename | Direction agreed: the **payload form wins** (it is what the notification attaches and the inbox files); make the download match it. Next rev |
| **T-20** | West Tellus, hardest tubular (4,105 psig required): the Petrobras second cut cannot be met on the shipped acoustic precharge — closes 4,141 against 4,163 adjusted minimum | **The tool refuses to post the sheet.** A request will sit open with no issued sheet | **This is intended behaviour, not a fault.** An open request with no sheet means engineering review in progress. Save/Export/Print still work for review | Awaiting operator / NOV decision on raising the acoustic bank. Open |
| **F-35** | The password gate is inlined in our build but also published on the share; rebuild discipline between the two sessions not yet formalised | No precharge figure involved. Risk is a **gate/salt divergence causing a lockout** | Before rebuilding, check the share copy's `SALT` and `sha256()` body are unchanged | Discipline to be agreed. Open — and note `_gatecheck.js` (§2.5 B) is the control for this and cannot currently run |
| **T-15** | HTML default values for `dcbVol` / `dcbGv` disagree with the presets | **None today** — `applyPreset` overwrites them on load | None needed | Tidy in a future rev. Open |
| **F-64** | Rev 84's three engine corrections (mechanical stop, drawdown basis, hop) are keyed to **West Tellus only** | Unknown per rig until measured. Other DCB rigs behave as before | Expected. Do not assume a Tellus fix applies elsewhere | Extend per rig as each is reviewed. Open |
| **F-65** | Well hop on the piston rigs (Saturn, Capella, Sevan) still designs at the **median** depth and only flags a failing depth | Unknown | For a hop on those rigs, check each depth explicitly | Extend the Tellus hop model. Open |
| **F-25 / F-25a** | The gate is a curtain, not a lock: page content readable without the password, and `requests/<id>.json` reachable by direct URL on the open share | **Unauthenticated read** of request data is possible by anyone who can reach the share | Do not treat the gate as access control. Keep the URL unpublished outside the org | Server-side (IIS Windows) authentication or encrypted payloads **before production**. Open |
| **F-70** | Request payloads on the share carry `meta.raisedBy` and `meta.email` — an **employee name and work email** — and that folder is unauthenticated (see §5.4) | 5 of 7 live requests contain a named individual. Low sensitivity (business contact details), but it is unauthenticated personal data | None at the tool level; the fields are deliberate and operationally useful. Treat the share URL as internal-only | **Closed by fixing F-25** (server-side auth), which is the right fix rather than stripping the fields. Open — raised by this ORR review |

### 3.1 Open engineering items — deliberately NOT in the log above

The MOC register holds **19 open entries**. The nine below are open *engineering* questions —
awaiting an OEM answer, a rig input or a per-rig review. **A support engineer can take no action
on them and no user can hit them**, so putting them in a Known Error Log would dilute it. Listed
here so the count reconciles and nothing looks filtered:

| Ref | Rig(s) | Open question |
|---|---|---|
| F-07 | Unreviewed rigs | Legacy shared defaults on all non-shear banks |
| F-15 | Auriga, Jupiter, Carina, Polaris, Saturn | G39 fallback is an anchor Neptune's own workbook declined to use — potentially significant |
| F-09 / F-09a | Fleet (bladder banks) | Bladder compressibility floor (MAWP/3.5) not applied — would be +181 to +235 psi if it were |
| N-11 | West Neptune | Maximum shear pressure the selected charge can deliver (envelope statement) |
| C-04 | West Capella | On nitrogen the installed bank **cannot** deliver 3,600 psig at 9,199 ft at any lawful precharge |
| L-10 | Libongos / Quenguela | Timing bottle volume |
| L-11 | Libongos / Quenguela | 10% design factor on FVR |
| L-16 | Libongos / Quenguela | MAWHP for the blind-seal check |
| L-26 | Sonangol Quenguela | Acoustic MOP and bottle size differ from the issued sheet |

**Register totals, 30 September 2026:** **159 entries** — 122 closed, 16 confirmed no-change, 2
noted, **19 open** (10 support-relevant above + 9 engineering below). Status totals reconcile;
`total_errors: 0`.

---

## 4. Components — ORR 22

| Component | Deployed to | Served as | Built by | Owner |
|---|---|---|---|---|
| **`calculator.html`** — gated calculator + requests pane | `\\sdrlazneuiis01d.corp.local\sacred\precharge\` | `http://sdrlazneuiis01d.corp.local:8080/sacred/precharge/` | `build_served.py` | Precharge (Dan) |
| **`set-password.html`** — generates the gate config | same folder | `…/sacred/precharge/set-password.html` | `build_setpw.py` | Precharge (Dan) |
| **`gate-config.js`** — password hash + hint | same folder **and** deploy source | loaded by the page | **`set-password.html` only** — never hand-written, never in source control | **Dan, sole authority** |
| `gate-fragment.html` — login card markup, carries `SALT` and `sha256()` | same folder | inlined into our build at build time | dashboard session | **Dashboard session** |
| **`Seadrill BOP Precharge Request.html`** — rig-facing request form | `\\…\sacred\` | `…/sacred/` | `build_reqform.py` | Precharge (Dan) |
| **`reqform_inline_fragment.html`** — SSORT drop-in | reporting-template folder → SSORT | inside SSORT | `build_reqform.py` (same run) | Precharge (Dan) |
| `Seadrill BOP Precharge Calculator.html` — **ungated** | **never published** | — | `cat` of six sources | Precharge (Dan) |
| `requests/` + `index.json` | `\\…\sacred\precharge\requests\` | reachable by URL | dashboard scanner | **Dashboard session** |

### 4.1 The two things it depends on

1. **The intake / post URL.** `REPORT_POST_URL` is baked into the calculator at build time and
   the same value is substituted into the request form by `build_reqform.py`, **so the two cannot
   drift apart**. A change to the endpoint requires a rebuild of both.
2. **The notification workbook / flow** is the dashboard side's. Our only obligation to it is the
   **frozen contract**: `meta.tool` must remain exactly `'Seadrill BOP Precharge Calculator'` —
   it is the scanner's primary routing test, and renaming it would stop posted sheets being
   recognised at all. The build fails if it changes. Verified byte-identical from Rev 83 to
   Rev 87, along with `buildDashboardExport`, `issuedFileName`, `buildSheetHtml`,
   `loadRequestById`, `saveState` and `loadState`.

### 4.2 Runtime dependencies

**Two CDN scripts** — jsPDF and jspdf-autotable, from `cdnjs.cloudflare.com`, loaded in the page
head and used **only** to generate the PDF. If the CDN is unreachable the calculator still
computes and displays correctly and *Generate PDF* reports that the library is still loading.
Everything else is self-contained: no server-side code, no database, no API.

**The SharePoint entry point must be a LINK, not an embed** (register F-32). SharePoint is
`https://` and the share is plain `http://`; browsers block mixed active content, so an iframe or
embed web part renders **empty with no error** — it looks as though the tool is broken.

---

## 5. Local data and retention — ORR 27

### 5.1 The controlled record

**The PDF issued by Technical Services is the controlled document.** Not the screen, not an
email body, not a screenshot. It is generated **from the calculation data, not photographed from
the screen**, so it cannot drift from what was computed, and it carries two signature lines —
**Calculated** and **Verified** — plus a generation timestamp that is the tool's own record and
replaces neither name.

### 5.2 Where the issued record lives

| Location | What | Retention |
|---|---|---|
| `\\…\sacred\precharge\requests\` | the rig's **request**, `<rigKey>_<well>_BOP<n>.json` — **dateless id**, so a corrected re-post supersedes rather than duplicating. Currently 7 live + `index.json` + `archive\` | Indefinite; archived by the dashboard scanner |
| `WellControl - PostedReports` (synced library) | the **issued sheet**, `seadrill-report_<rig>_<well>_BOP<n>_<yyyyMMdd-HHmmss>_precharge.json`, carrying `sheetHtml` and the base64 PDF. Currently 23 precharge files | Indefinite; synced, not local-only |
| Rev folders `Rev <N> - <date>\` in the project folder | every delivered build, permanent | Indefinite, on Dan's machine |

The posted payload is the **record of issue** and it is self-contained: it carries the rendered
sheet as HTML *and* the PDF, so the record does not depend on the calculator still existing in
that revision.

### 5.3 What is kept on the user's machine

| Item | Where | Notes |
|---|---|---|
| Saved working files (`Save .json`) | wherever the engineer chooses, usually Downloads | Working files, **not** records of issue |
| Generated PDFs | Downloads | A copy; the posted payload holds the controlled one |
| Gate unlock token | browser `localStorage`, key derived from the password hash | **12-hour expiry**, or none if *remember on this computer* is ticked. Changing the password **orphans every existing token**, so everyone is re-prompted — revocation comes free |
| `gate-config.js` | deploy source + share only | Not in source control. The one file in that folder that is not a build artefact — **must be excluded from any automated sync** |

**Nothing the tool writes to a user's machine is the only copy of an issued record.** A saved or
exported file before *Post* is a **draft**, and a draft is deliberately not a record — the
engineer is expected to be able to work up a failing sheet, print it and take it to review
without that ever looking like an issue. The record is created by *Post*, and lands on the share
and in the synced library, never only locally.

**One genuine single-copy window, stated plainly:** between an engineer computing a sheet and
pressing *Post*, the only copy is on their machine. That window is minutes, it contains a draft
rather than a record, and the request on the share remains open until a sheet is posted against
it — so a lost draft is visible as an unanswered request, not as a silent gap.

### 5.4 ⚠ Personal data — corrected finding, raised by this review

**An earlier draft of this return stated there was no personal data. That was wrong, and the
error was found by checking the files rather than the design.** The accurate position:

The rig-facing request form collects **"Raised by"** and **"Email"**, and emits them into the
request payload as `meta.raisedBy` and `meta.email`. Those payloads are written to
`\\…\sacred\precharge\requests\`, which **is reachable by direct URL without the password**
(F-25/F-25a).

Checked against the live share on 30 September 2026: **five of the seven current request files
carry a named individual and an email address.** Most emails are rig shared mailboxes
(`sss.w<rig>@seadrill.com`), but at least two are named individual addresses.

| | |
|---|---|
| **What** | Employee name + work email address, per request |
| **Where** | `requests/<id>.json` on the share, plus the same fields in the posted payload in the synced library |
| **Exposure** | Readable by **anyone who can reach the share URL**, with no authentication. Internal `http://` only, not internet-facing |
| **Sensitivity** | Low — business contact details of employees in a work context. **No credentials, no personal identifiers beyond name and work email, no rig-crew personal data** |
| **Why it is collected** | Deliberate and useful: it is who Technical Services comes back to with a question on the request. Removing it would cost a day per query |
| **Retention** | Indefinite at present. Archived by the dashboard scanner, not deleted |

**This is a real ORR item, not a theoretical one**, and it is the same root cause as F-25: the
gate is a curtain, not a lock. Fixing F-25 (server-side IIS authentication on the virtual
directory) closes this at the same time, which is the argument for doing it properly rather than
stripping the fields.

**Raised as register F-70**, open. No change made to the tool — nothing changes before the
20 October class.

**What is still true:** **no credentials are stored anywhere.** The shared password exists only
as a salted SHA-256 hash in `gate-config.js`; the plaintext is stored nowhere and cannot be
recovered from the file.

---

## 6. UAT note

Your handoff assigns UAT (ORR 9) to the reporting tools' four Day 1 exercises. For this tool the
equivalent is the **three precharge exercise files and their answer key** used in the Day 2
session on **20 October 2026**, verified by `build/_verify_samples.js` (§2.6) — one per rig
family (DCB single, DCB dual/split, piston), on verified rigs only, with training well names so
no exercise artefact can be mistaken for an issued precharge.

---

## 7. Summary for the ORR workbook

- **One self-contained HTML file.** No server code, no database, no API. Two CDN scripts, for
  the PDF only.
- **Verification is per rig, not per release.** **4 of 13 rigs verified** (Gemini, Vela,
  Neptune, Tellus), 2 in progress, **7 not reviewed and assumed wrong until checked.**
- **Rev 87 is current**, published, and deploy source matches the share.
- **19 open register items**, of which **10 are support-relevant** and in the Known Error Log.
- **Three things a reviewer should press on:**
  1. the gate is **a curtain, not a lock** (F-25) — needs server-side auth before production;
  2. **request payloads on the unauthenticated share carry an employee name and work email**
     (**F-70**, §5.4) — raised by this review, and closed by fixing F-25;
  3. **`_gatecheck.js` cannot currently run** (§2.5 B) — the control against a gate/salt
     divergence, which is the lockout failure mode.
- **No stored credentials.** The shared password exists only as a salted SHA-256 hash; the
  plaintext is stored nowhere. **There is limited personal data** — see F-70 above.

---

*Prepared against the delivered Rev 87 and the MOC register as at 30 September 2026. Every hash,
count and figure in this return was read from the artefacts, not from notes.*
