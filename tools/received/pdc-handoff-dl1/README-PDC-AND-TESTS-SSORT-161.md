# SSORT pre-deployment checklist and surface tests — the data as it stands (SSORT REV 161)

**For:** the dashboard session and Lee Arnold's DL-1 profile (dashboard ask 2, 12 October 2026)
**From:** the reporting-tools session · **Tool:** SSORT REV 161, live (sha256 `a5da5eacfcc7878e45e7a509cae60708127bb701cd3f3da920ae31a694bc14f9`)
**How this was made:** not from memory and not from the source alone. SSORT 161 was opened, a pre-deployment checklist
tile was built on a **dual stack, seven cavities each** (the largest form), and every input was read off the page. Every
surface test was then rendered on **every rig in SSORT's rig list**, with every EDS sequence, ROV sheet and EHBS shear choice
selected in turn. A first pass read some forms before they had finished drawing; it was thrown away and redone with each form
allowed to settle. Nothing was posted.

Files beside this one:
- `SSORT-161-surface-test-keys.json` — every surface-test key set, the rigs that share it, every key with its label
- `SSORT-161-surface-test-keys.csv` — the same, one row per rig / test / key, for a spreadsheet

---

## 1. Where it is in the post

A pre-deployment checklist posts as report type **Pre-Deployment Checklist**, file
`seadrill-report_<rig>_<date>_pre-deployment-checklist.json`, with the checklist in **`tiles[].pdcData`**. That is a **flat object**:

- one key per input, every input, **including blanks** (`""`);
- checkboxes are `"1"` or `""`;
- the Yes/No buttons are hidden inputs holding `"Yes"`, `"No"` or `""`;
- each photo section is an array of **only the photographed slots**: `[{ src: <JPEG data URI>, caption }]`.

A dual seven-cavity checklist has **242 keys** plus 9 photo arrays.

## 2. Header and acknowledgement

| Key | Field |
|---|---|
| `pdc_rig` | Rig Name |
| `pdc_well` | Well Name |
| `pdc_stack` | BOP Stack |
| `pdc_date` | Date (`YYYY-MM-DD`) |
| `pdc_ack` | ☐ "All participants have reviewed the completed work and agree the BOP is suitable for deployment." `"1"` / `""` |

## 3. The 21 items

| # | Response key | Remarks key | Question | Prompt on the form | Response values |
|---|---|---|---|---|---|
| 1 | `pdc_1_resp` | `pdc_1_rem` | Has the BTW maintenance been completed within the projected timeline? | If no, please state why. | `Yes` / `No` / `""` |
| 2 | `pdc_2_resp` | `pdc_2_rem` | Was any break-in work required during the maintenance period? | If yes, please specify what and outline impact on timeline. | `Yes` / `No` / `""` |
| 3 | `pdc_3_resp` | `pdc_3_rem` | Have all CM's and known deficiencies been repaired with corresponding work orders closed out? | If no, please state details. | `Yes` / `No` / `""` |
| 4 | `pdc_4_resp` | `pdc_4_rem` | Have there been any modifications or upgrades made during the maintenance period? | If yes, please state Synergi NC or MOC number. | `Yes` / `No` / `""` |
| 5 | `pdc_5_resp` | `pdc_5_rem` | Is there an approved riser analysis and WSOG available? | — | `Yes` / `No` / `""` |
| 6 | `pdc_6_resp` | `pdc_6_rem` | Have all subsea accumulators been pre-charged to the pressures as per TSC recommendation? Can rig team confirm that all charging valves are in situ? | — | `Yes` / `No` / `""` |
| 7 | `pdc_7_resp` | `pdc_7_rem` | Is a BOP hop planned during the deployment? | If yes, does the rig have an approved riser analysis and pre-charge plan for this/these depths. | `Yes` / `No` / `""` |
| 8 | `pdc_8_resp` | `pdc_8_rem` | What is the inclination and the diameter of the High Press Wellhead Housing (HPWH)? | — | free text |
| 9 | `pdc_9_resp` | `pdc_9_rem` | Has the BOP control cycle count been re-set? If a dual stack and stacks have been swapped, have we accounted for simulator functions? | If no, please state details. | `Yes` / `No` / `""` |
| 10 | `pdc_10_resp` | `pdc_10_rem` | Have any of the main wellbore elastomers been changed out? | If yes, please state which components, how many closures they had, and elastomer information on the sheet below. | `Yes` / `No` / `""` |
| 11 | `pdc_11_resp` | `pdc_11_rem` | Is the subsea team aware of testing requirements during the BOP deployment and post BOP land out? | — | `Yes` / `No` / `""` |
| 12 | `pdc_12_resp` | `pdc_12_rem` | Is the BOP control system clear of all alarms and faults? | If no, please state details. | `Yes` / `No` / `""` |
| 13 | `pdc_13_resp` | `pdc_13_rem` | Are the Electrical and Marine departments aware of the requirements and procedure when re-calibrating the stack ERA's? | If no, please state details. | `Yes` / `No` / `""` |
| 14 | `pdc_14_resp` | `pdc_14_rem` | Are the rig team aware of the importance to monitor Mux cables at all times when machinery moves in the moon pool? How is this managed? Has the Mux Cable management video been watched by all to be involved in the task? | If no, please state details. | `Yes` / `No` / `""` |
| 15 | `pdc_15_resp` | `pdc_15_rem` | Are the Subsea team following requirements as per TB-WCE-73 (AAB C10078078) when reporting BOP/Pod Control Change outs? | If no, please state details. | `Yes` / `No` / `""` |
| 16 | `pdc_16_resp` | `pdc_16_rem` | During the maintenance period was there a need to urgently transfer/ship parts? (including taking parts from the offline stack if dual stack rig) | If yes, please state details. | `Yes` / `No` / `""` |
| 17 | `pdc_17_resp` | `pdc_17_rem` | Are there any overdue AAB's relevant to Well Control? | If yes, please state details. | `Yes` / `No` / `""` |
| 18 | `pdc_18_resp` | `pdc_18_rem` | Is there sufficient riser torque tools available with sufficient spares? | — | `Yes` / `No` / `""` |
| 19 | `pdc_19_resp` | `pdc_19_rem` | Has the BOP handling equipment been function tested and is there any known deficiencies? | — | `Yes` / `No` / `""` |
| 20 | `pdc_20_resp` | `pdc_20_rem` | Was someone from TSC well control equipment group onboard to assist during the BTW period? | — | `Yes` / `No` / `""` |
| M1 | `pdc_M1_resp` | `pdc_M1_rem` | Are any milling operations planned in the upcoming drilling program? | Raised at the West Neptune MPR investigation closeout. Milling debris is a known threat to ram packers and door sealing faces, and the BOP crew need to know before the stack goes in the water. If Yes, record what is planned and when in Remarks. | `Yes` / `No` / `""` |

Item 10 says "elastomer information on the sheet below": that is now the BOP stack table in §4. (The old elastomer table,
`pdc_el_r<n>_comp / _install / _serial / _closures`, still has code in SSORT but **no form renders it**; it can only appear
in a post from an older revision.)

## 4. BOP configuration (one block per stack)

| Key | Field | Values |
|---|---|---|
| `pdcbop_desig` | BOP Designation | `Single` (stack `s1`) / `Dual` (stacks `s1`, `s2`) |
| `pdcbop_s<s>_mfr` | Manufacturer | `NOV (Shaffer)` / `Cameron` |
| `pdcbop_s<s>_cav` | Cavities | `5` / `6` / `7` |
| `pdcbop_s<s>_status` | Status | `In Operation` / `Offline Maintenance` / `Between-Well Maintenance Ongoing` / `Quarantine` |
| `pdcbop_s<s>_packers_ok` | "All ram packers are installed correctly and their orientation has been confirmed correct" | `Yes` / `No` / `""` |
| `pdcbop_s<s>_packers_rem` | its remarks | free text |

**The stack table**, rows `r0` … `r<cav+3>`, top to bottom. Annulars and connectors come first, then the cavities in the
template's order, then the wellhead connector:

| Cavities | Rows, in order |
|---|---|
| 5 | UA, RC, LA, UBSR, CSR, UPR, MPR, LPR, WHC |
| 6 | UA, RC, LA, UBSR, CSR, LBSR, UPR, MPR, LPR, WHC |
| 7 | UA, RC, LA, UBSR, CSR, LBSR, UPR, MPR, LPR, TPR, WHC |

The crew can change a row's position, from `UA/RC/LA/WHC/UBSR/CSR/LBSR/EPR/UPR/MPR/LPR/TPR`:

| Code | Position |
|---|---|
| `UA` | Upper Annular |
| `LA` | Lower Annular |
| `RC` | Riser Connector |
| `WHC` | Wellhead Connector |
| `UBSR` | Upper Blind Shear Ram |
| `CSR` | Casing Shear Ram |
| `LBSR` | Lower Blind Shear Ram |
| `EPR` | Extra Pipe Ram |
| `UPR` | Upper Pipe Ram |
| `MPR` | Middle Pipe Ram |
| `LPR` | Lower Pipe Ram |
| `TPR` | Test Pipe Ram |

Every row:

- `pdcbop_s<s>_r<i>_pos` — the position code;
- `_spec` — specification, with options by position and manufacturer:
  - annulars: NOV 18-3/4" 10M, Cameron DL, Shaffer 10K, N/A;
  - riser connector: Vetco H4 ExF / HAR, GE / HMH SHD-H4, Drillquip DX-10, Cameron HC, Cameron EVO, N/A;
  - wellhead connector: Vetco SHD-H4 15K, Cameron EVO 27" 15K (VX), Drillquip 18-3/4" 15M, GE / HMH SHD-H4, N/A;
  - pipe rams: ram sizes (3-1/2" Fixed, 5" Fixed, 5-1/2" Fixed, 5-7/8" Fixed …);
  - shear rams: NOV LFS-3, LFS-5, LFCS, CVX, CVX-W, Unsealed LFS-5 / Cameron CDVS II, DSI, EVO Tandem Bonnet w/CDVS II;
- `_install` — install date;
- `_cycles` — cycle count.

Part and serial numbers depend on the row:

| Row is | Keys |
|---|---|
| an annular or a connector (UA, RC, LA, WHC) | `_pn` part no., `_serial` serial no. |
| a ram (UBSR, CSR, LBSR, EPR, UPR, MPR, LPR, TPR) | `_pnf` / `_snf` **forward** packer part / serial, `_pna` / `_sna` **aft** packer part / serial |

## 5. The three photograph sections (the evidence the post gate counts)

Per stack: **`pdcbop_s<s>_ph_rams`** (ram packers), **`pdcbop_s<s>_ph_cavities`** (cavity sealing faces) and
**`pdcbop_s<s>_ph_doors`** (door sealing faces).

- Each section has **cavities × 2 slots**, one FWD and one AFT per ram cavity, in stack order. For seven cavities that is
  UBSR — FWD, UBSR — AFT, CSR — FWD, CSR — AFT, LBSR — FWD, LBSR — AFT, UPR — FWD, UPR — AFT, MPR — FWD, MPR — AFT, LPR — FWD, LPR — AFT, TPR — FWD, TPR — AFT.
- So a seven-cavity stack needs 42 photographs, and a dual seven-cavity rig needs 84.
- **The slot's label is pre-filled as the photograph's `caption`**, for example `UBSR — FWD`, and travels in the post.
  Because the array holds only photographed slots, **the caption, not the array index, says which slot a photograph is.**
- The caption is editable. A crew can overwrite it, so a ticking rule that trusts it should allow for that.

**Older posts:** `pdcbop_ph_rams`, `pdcbop_ph_cavities` and `pdcbop_ph_doors` (no stack number) come from the form before
photographs were per stack. SSORT shows them as "Photographs from an earlier revision" and does not count them.

## 6. Electrical

| Key | Field |
|---|---|
| `pdc_elec_checks_resp` / `_rem` | "Has all electrical checks been completed per Guidelines for Pre-Deployment – Checklist?" `Yes`/`No`/`""` + remarks |
| `pdc_elec_rars_relay` | ☐ Riser Anti Recoil Relay is installed (RARS) — Circuit ref RL-1-EDS. `"1"`/`""` |
| `pdc_elec_rars_spades` | ☐ RARS terminal spades are installed in the Drill Floor LIR Wireline Riser Tensioner Cabinet. `"1"`/`""` |
| `pdc_elec_ph_ews` | photographs: BOP EWS Alarm & Fault Pages (6 slots, free captions) |
| `pdc_elec_ph_ir` | photographs: Insulation Impedance Screen (4 slots) |
| `pdc_elec_ph_fibre` | photographs: Fibre Signal Strengths (4 slots) |

## 7. Non-compliance, exemption, sign-off

| Key | Field |
|---|---|
| `pdc_nc_r<i>_desc` / `_reason` / `_ref` | Non-Compliance / Non-Completion of PMs: description, reason, Synergi MOC/NC or MAXIMO NC No. Three rows by default (`r0`–`r2`); the crew can add more (`r3` …) |
| `pdc_exempt` | Comments in Case of Exemption from Above |
| `pdc_so0_name` / `pdc_so0_date` | TSL |
| `pdc_so1_name` / `pdc_so1_date` | SS Supervisor |
| `pdc_so2_name` / `pdc_so2_date` | Rig Manager |
| `pdc_so3_name` / `pdc_so3_date` | Operations Director |
| `pdc_so4_name` / `pdc_so4_date` | Well Control Equipment Manager |

## 8. What "complete" means on the tile — exactly, from the code

SSORT **refuses to post** a pre-deployment checklist until all of these hold. It will still **save** an incomplete one, with a
warning:

1. `pdcbop_desig` is set, and at least one stack is built;
2. for each stack: `_cav` is selected;
3. for each stack: `_packers_ok` is **`Yes`**;
4. for each stack: each of the three photograph sections has **at least cavities × 2** photographs. The refusal names the
   empty slots.

**Not part of "complete":**

- the 21 items;
- the acknowledgement tick (`pdc_ack`);
- the five sign-offs;
- the electrical section;
- the stack table's part / serial / cycle fields.

A posted checklist can therefore have blank items and no signatures. That is a ticking rule for DL-1 to decide, not
something SSORT enforces today. Say if you want SSORT to enforce more, after the class.

---

## 9. The surface tests SSORT records

One report type, **Surface BOP Testing**, one test per tile, file
`seadrill-report_<rig>_<date>_surface-bop-testing_<Test-type>.json` (from SSORT 158). In the post, under `tiles[]`:

```
sbopData = { testType, date, soak: { key: value, ... } }
```

- Only **non-empty** values are posted.
- **SSORT posts no labels for these keys.** The labels in a SSORT payload belong to the rig-visit equipment entries, not
  this tile. So the appendix is the only label source on our side.
- **No completeness rule:** any surface test posts whatever has been filled in.

### 9.1 Key families

| Test | Keys | Prefixes | Varies by rig? | Example (West Capella) |
|---|---|---|---|---|
| BOP Function Test | 428 | `ft_` | no, the same on every rig | `ft_date` = Date; `ft_well` = Well; `ft_operator` = Operator |
| Soak Test | 390 · Sevan Louisiana 456 | `soak_`, `sksoak_` | Sevan Louisiana has its own form (`sksoak_`) | `soak_wc_well` = Well; `soak_wc_date` = Date; `soak_wc_r0_b_start` = Surface Accumulators — Blue POD — Time (min) · Start |
| Surface Drawdown Test | 54 | `dd_` | no | `dd_hdr_client` = Client; `dd_hdr_well` = Well; `dd_hdr_date` = Date |
| EHBS Testing | 28 / 33 / 55 | `ehbs_` | by EHBS class: single (28), sequenced (33), DMAS / Sevan (55) | `ehbs_hdr_date` = Date; `ehbs_hdr_well` = Well; `ehbs_hdr_operator` = Operator |
| EDS Testing | 442 – 1,561 | `eds_` | **rig-keyed**: `eds_<Rig>_SEQ_<n>_r<i>_...`. `eds_seq` picks the sequence; each sequence has its own rows | `eds_West_Capella_SEQ_1_r0_v` = 1 · Riser Recoil Disconnect · Permissive · 0 · - · To Remain ON for 10 Seconds — Verified; `eds_West_Capella_SEQ_1_r0_t` = 1 · Riser Recoil Disconnect · Permissive · 0 · - · To Remain ON for 10 Seconds — Actual Time; `eds_West_Capella_SEQ_1_r0_rk` = 1 · Riser Recoil Disconnect · Permissive · 0 · - · To Remain ON for 10 Seconds — Remarks |
| ROV Function Testing | 70 – 193 | `rov_` | rig-keyed sheet; `rov_sheet` picks it where a rig has more than one | `rov_West_Capella_r0_v` = 1 · 1 · FSA ACCUM DUMP — Verified; `rov_West_Capella_r0_t` = 1 · 1 · FSA ACCUM DUMP — Actual Time; `rov_West_Capella_r0_rk` = 1 · 1 · FSA ACCUM DUMP — Remarks |
| Acoustic Function Testing | 64 – 80 | `acst_` | **rig-keyed**: `acst_<Rig>_...` | `acst_stack` = Stack; `acst_hdr_date` = Date; `acst_hdr_well` = Well |

**Values worth knowing:**

- A **Verified** cell (`…_v`, `…_pf`) is set by three buttons, so it holds `Pass`, `Fail` or `N/A`.
- `ft_r<i>_na` is a BOP Function Test row's **N/A toggle**: `"1"` when the function is not applicable on this stack. It is
  absent from the post when it is off.
- `eds_seq`, `rov_sheet` and `ehbs_shear` record which sequence, sheet or shear arrangement the crew chose. Read the rows
  under the chosen one.
- Units are in the labels where the form shows them: "Pressure (PSIG)", "Time (min)", "Vol".

### 9.2 Every rig, every test (number of keys)

| Rig | BOP Function Test | Soak Test | Surface Drawdown Test | EHBS Testing | EDS Testing | ROV Function Testing | Acoustic Function Testing |
|---|---|---|---|---|---|---|---|
| West Auriga | 428 | 390 | 54 | 28 | 802 | 85 | 80 |
| West Vela | 428 | 390 | 54 | 33 | 667 | 193 | none — no acoustic system |
| Sevan Louisiana | 428 | 456 | 54 | 55 | none — no sheet held | none — no sheet held | none — no acoustic system |
| Sonangol Libongos | 428 | 390 | 54 | 33 | 817 | 76 | 80 |
| Sonangol Quenguela | 428 | 390 | 54 | 33 | 490 | 85 | 80 |
| West Gemini | 428 | 390 | 54 | 28 | 442 | 85 | 64 |
| West Polaris | 428 | 390 | 54 | 28 | 886 | 91 | 80 |
| West Carina | 428 | 390 | 54 | 28 | 1561 | 121 | 80 |
| West Jupiter | 428 | 390 | 54 | 28 | 811 | 94 | 80 |
| West Saturn | 428 | 390 | 54 | 33 | 505 | 151 | 72 |
| West Phoenix | 428 | 390 | 54 | none — no sheet held | none — no sheet held | none — no sheet held | none — no sheet held |
| West Capella | 428 | 390 | 54 | 28 | 460 | 70 | 64 |
| West Neptune | 428 | 390 | 54 | 33 | 478 | 160 | none — no acoustic system |
| West Tellus | 428 | 390 | 54 | 28 | 1468 | 88 | 80 |
| SSCE Equipment | 428 | 390 | 54 | none — no sheet held | none — no sheet held | none — no sheet held | none — no sheet held |

"No acoustic system" is a fact about the rig (West Vela, West Neptune, Sevan Louisiana), not a gap. "No sheet held" means no
sheet has been loaded into SSORT for that rig.

---

*Generated from SSORT REV 161 on 2026-10-11. If a later SSORT revision changes any key, this document is
regenerated from the tool, not edited by hand.*
