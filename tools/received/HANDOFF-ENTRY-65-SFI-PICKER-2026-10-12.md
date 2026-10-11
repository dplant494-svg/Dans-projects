## Entry 65 — SSORT 163: the Technical Assistance Request picks the equipment by SFI code. Four new keys, announced before they ship

**Rev: SSORT 163, built and tested 12 October; NOT deployed.** sha256
`c15d88bfbaf5881ceca1bf08bf15bd6c5c39972562cb1f9319e17d2ff5ed41d1`, 7,345,278 bytes. **163 is built on 162** (the plan
picker and Link to plan, entry 64), so **deploying 163 ships 162 too.** Status: **NEEDS ACTION**: the four keys below, plus
64.4 still open.

**Dan, 12 October:** *"on the equipment manufacturer in the help requests tool in SSORT we need all of the SFI codes, see
attached a new list of SFIs, so the team can pick from a dropdown."* The list is `TS - Well Control Assets and
Locations.xlsx`, a Maximo export: ten SFI groups and 34,167 rows.

### 65.1 — What the crew sees

The help request's Equipment affected gets an **SFI** row above it:

- **An SFI group dropdown** with the ten groups and a count for the rig.
- **A search box** listing that rig's codes in the group (or in all groups) as `331.BOP1.200 — NOV SHAFFER 18 3/4" 10K BIG BOY
  ANNULAR`, with the manufacturer and model shown beside each suggestion. The crew types part of the code, the description or
  the manufacturer.
- **Picking a code** fills Equipment affected (manufacturer / model), unless the crew has typed there, and shows the Maximo
  asset number.
- Text that is not a code on the list is flagged and **not** sent as an SFI. The free-text box still works, so nothing is
  ever blocked.
- **The list follows the rig.** Another rig's pick is never sent.

### 65.2 — The data

- **Scope:** every location code below group level, levels 2 to 4 (for example `331.BOP1`, `331.BOP1.200`,
  `331.BOP1.300.010`), for the **14 rigs in SSORT's rig list**: **28,916 codes**. Each code carries its description,
  manufacturer, make/model, Maximo asset number, and any status other than OPERATING.
- **Not included:** West Elara and West Aquarius, which are not in SSORT's rig list (stacked: Dan, 11 Oct). They are added
  with the rig.
- **Packing:** the list is gzipped inside the file (2.9 MB of JSON becomes 387 KB) and unpacked in the browser only when the
  request form opens; that takes about 0.2 s. SSORT stays one file and works offline.
- **Fallback:** a browser that cannot unpack it gets the free-text box only. Edge and Chrome can.
- **Group names.** The workbook names no groups, so these are taken from the systems in each group. **Dan, please correct any
  of them:** 302 Heave compensation & crown block · 314 Riser & guideline tensioning · 315 HP compressed nitrogen · 331 BOP
  stack & LMRP · 332 BOP control system · 334 Diverter system · 335 Marine riser · 336 Choke & kill / mud gas separation ·
  337 Well control test & support equipment · 339 Managed pressure drilling (MPD).

### 65.3 — The keys, new on the help request

Top-level strings, `""` when no code is picked. They are camelCase, like the rest of the help record your contract
defines (`requestId`, `occurredAt`):

| Key | Example | `fieldLabels` |
|---|---|---|
| `sfiCode` | `331.BOP1.200` | SFI code |
| `sfiDescription` | `NOV SHAFFER 18 3/4" 10K BIG BOY ANNULAR` | SFI description |
| `sfiGroup` | `331` | SFI group |
| `maximoAssetNo` | `C1004805` | Maximo asset number |

They also appear in two other places:

- **in `description`**, so they reach the email and the chat: `SFI: 331.BOP1.200 — …` and `Maximo asset number: C1004805`,
  first among the FRM lines;
- **on the FRM-00-0169 copy**, in row 5 (Equipment affected).

**For Fabric:** `maximoAssetNo` is the same Maximo asset number the CoC tracker keys on, so a request can be joined to the
asset and its certificates.

### 65.4 — Verified on 163 (posting stubbed, nothing posted, test data cleared)

- **The picker:**
  - the list unpacks in about 0.2 s;
  - West Capella has 570 codes, 74 of them in 331;
  - picking `331.BOP1.200` fills the manufacturer/model box and gives `C1004805`;
  - free text is refused as an SFI;
  - after a rig change, the list follows the rig and the old pick is dropped;
  - the draft keeps the pick, and resolves it again once the rig is set;
  - New request clears it.
- **The post:** the payload carries all four keys and their labels; the description and FRM row 5 carry the SFI and the
  asset number.
- **Build checks:**
  - byte-identical: the precharge panel, `sdPostReport`, `postReport`, `REPORT_POST_URL`, `reportFileName`, `dlPostPayload`,
    `tarqSend`, `sdLinkToPlan` and `sdSizeOk`;
  - post and fetch call counts unchanged;
  - no `no-cors`; the 0.82 count unchanged.

---

