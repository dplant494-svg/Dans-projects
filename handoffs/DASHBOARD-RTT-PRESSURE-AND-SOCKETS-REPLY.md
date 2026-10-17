# Reply: RTT pressure logging, socket business case, PDC additions (West Capella RTT gauge event)

**From:** the dashboard / scanner session (SACRED) · **To:** the report session, via Dan · **Date:** 17 Oct 2026 (rev 2: business case and bolts per joint added)
**Re:** *Handoff — RTT pressure logging, socket business case, PDC additions*

This answers what SACRED knows from its own records. Where SACRED has no record, the answer says who holds it.
**Part 2 goes to the reporting-tools session.** SSORT is frozen at REV 169 until **Fri 23 Oct** (workshop), so it ships after that date.

---

## Part 1: answers

| # | Question | Answer from SACRED | Still [TBC]: who answers |
|---|---|---|---|
| 1 | **Socket business case** | **Found (Dan, 17 Oct): *Power Tork to TorqLite Business Case 1.1*** (Technical Services – WCEMPDG). **Yes, it is the TorqLite RT-24-S change.** The headline figures are below the table. **Events behind it:** West Tellus (21 Sep 2025, socket fracture; flash alert Synergi **1790819**), West Neptune (2 Oct 2025, new sockets failed on first use), West Polaris (28 Sep 2026, 10 sockets broken, one RTT left working); IR-WCE-335-009 Rev 3, eDOCS 11237290. AAB **C10247907**. | Dan: whether the deck's caveats below go in the report as written. |
| 2 | **PLATO riser running tally** | **SACRED has no PLATO riser data.** PLATO, as SACRED knows it, is the live **BOP control system** feed (cycle counts, Grafana dashboards at `plato.corp.local:3000`). It is **not connected to SACRED yet** (plan item 63). The **riser tally** SACRED knows is a separate tool: **Rohit's Riser Tally Tool**, standalone on the SACRED share (`/sacred/Riser%20Tally%20Tool.html`). It saves in the browser and posts nothing. A per-rig tally inside SSORT (one posted record per run, with serial, weight and comments per joint) is plan item 32, **not started**. **SACRED's recommendation:** don't put the per-bolt record inside PLATO. Give it its own area: an "RTT Pressure Log" record keyed to the riser tally by **rig + run + joint serial** (see Part 3). | **Nick** (PLATO owner): whether PLATO holds a riser running tally at all, and in what fields. **Rohit**: whether his tally captures joint no., serial, position and torque. |
| 3 | **What SACRED publishes from PLATO today** | **Nothing yet.** It waits on Nick: a CSV export or a service account (plan item 63; rolling entry 81 for the CBM usage table). **The shape we would use**, the same as every other feed: a CSV dropped on `\\SEADRILL23339\Well Control Data\` (or a SharePoint library), listed in the scanner's `dl1DataSources` (or a new source list), copied every run when changed, and published on `/sacred/…/data/` with an `index.json`. The RTT log follows that shape exactly. | Nick, for the PLATO side. |
| 4 | **Identifiers** | **West Capella rig code: `capella`** (SACRED / Argo Navis key); asset name `West Capella`. **TS / TR format:** SACRED holds **TR-WCE-331-038**, so the pattern is `TR-WCE-<SFI>-<seq>`. An RTT report would sit under **SFI 335** (riser system), like the socket report IR-WCE-335-009; e.g. `TR-WCE-335-nnn`, with the number from the TR register. **Related numbers from the business case:** Synergi 1790819 (West Tellus), eDOCS 11237290 (IR-WCE-335-009), eDOCS 11242619 (plate measurement guide). | **Dan / Ronnie**: the Synergi and eDOCS numbers for the **West Capella** event itself. **Document control**: the next TR number. |
| 5 | **SSS-007 revision** | SACRED's references cite **SSS-007 by title only** (BOP handling equipment function test, with DIR-37-0165), with **no revision**. The WCE Reference Hub (`wce_references.json`, refreshed daily on the share) is the place to check. | **Dan**: check the Reference Hub or eDOCS for the current revision (Rev 8 vs Rev 9). |
| 6 | **Downtime cost** | Not in SACRED. The **43.75 h** is from the event. | **Dan / Ronnie**: the Code 8 hours and the West Capella spread rate. |
| 7 | **Bolts per flange; joints per run** | **8 riser bolts per joint** (Dan, 17 Oct). The riser is the **Shaffer FT-H**: the upload is the West Vela FT-H riser system manual 10799079-MAN Rev 01, page 1 only, which is NOV drawing 10631690-ASM Rev 04 (shim assembly, Lankhorst). It holds no bolt torque values. **Sizing:** a run of about 80 joints × 8 bolts = **640 make-ups**, about 320 per tool with FWD and AFT. At 1 s logging a logger holds **8.9 h**, less than a full run, so either **log at 2 s** (about 17.8 h, still enough to catch each make-up peak) or **download at every crew change**. | **Rig**: typical joints per run per rig; confirm FWD / AFT each take 4 of the 8 bolts. |
| 8 | **Fleet count of RTTs** | **The business case covers 11 vessels**, with 3 RT-24-S tools each (33 tools), replacing Power Tork / Clover tools on Shaffer FT-H risers. | **Dan**: whether West Capella's **HR-40/33C** tools are in those 11, or are a separate population to count. |

**The business case in figures** (from the deck, with its own caveats):

| Item | Figure |
|---|---|
| Proposal | Standardise on **TorqLite RT-24-S** (modified for Shaffer FT-H: hydraulic motor, 2½ in square drive, 95 mm / 3¾ in 6-point socket Z-40M60-RT, IDCC dual console) |
| Roll-out | **11 vessels × 3 tools = 33 tools**, plus 11 ancillary sets and 11 spares packages |
| Cost | **$247,034 per vessel; $2,717,374 for all 11** (tools $1,473,582; ancillary $832,128; spares $411,664). RT-24-S $44,654 each, Maximo ICN 4085835. Quote S39960-GOA-R2, 25 Aug 2026 |
| Spend comparison (two years, two rigs each) | Power Tork / Clover **$531,125.42** (West Neptune + West Tellus) vs TorqLite **$86,499** (West Auriga + Sevan Louisiana): **83.7% lower PO spend** |
| Deck's own caveats | Purchasing history covers stock, repairs and urgent orders, not failures only, and has no common denominator per run: **don't present it as guaranteed savings or payback**. The downtime claim (2.5 h vs 2.0 h) is **unverified**; don't use it. Readiness still needs rig dimensional checks, training, procedures and PMS / Maximo entries. |
| AAB C10247907 rules relevant to the PDC | **5.875 in OD sockets SHALL NOT be used on the inner bolt circle**: use 5.375 in. Thick sockets on the outer circle only. NDE sockets before **every** riser run or pull. Measure drive / body plates (eDOCS 11242619; nominal 3.693 / 4.440 in, ±0.010 in) and replace above 0.010 in permanent deformation. |

---

## Part 2: PDC additions (for the reporting-tools session; SACRED's comments)

**SACRED agrees with the eight items and the permanent ids.** A few points before it's built:

1. **Key prefix.** `pdc_rt_*` is free: no existing SSORT key uses it, and it doesn't clash with the Rev 9 keys (`pdc_r9_*`). Keep it.
2. **Item answers.** These follow the existing convention: `pdc_RT1_resp` / `pdc_RT1_rem` … `pdc_RT8_resp` / `_rem`. Please list the exact spelling in the interchange announcement, including case.
3. **Rows.** Gauge rows `pdc_rt_g_r<i>_id / _cert / _due` and socket rows `pdc_rt_s_r<i>_sn / _nde / _res`. Please state the **maximum number of rows** and the **date format** (`_due`). SACRED will print dates as DD/MMM/YYYY, as for the usage table.
4. **RT3 "No" warns on post, never blocks.** Agreed. The emergency copy must always post.
**Two further lines proposed from AAB C10247907** (permanent ids RT9 and RT10; Dan to accept):

| id | Type | Question | Hint | Extra fields |
|---|---|---|---|---|
| RT9 | yn | Are only 5.375 in OD sockets used on the inner bolt circle (5.875 in on the outer circle only)? | AAB C10247907: thick sockets on the inner circle caused every reviewed failure. | `pdc_rt_sock_inner_od` |
| RT10 | yn | Have drive and body plates been measured per eDOCS 11242619 and found within ±0.010 in? | Nominal drive plate 3.693 in, body 4.440 in; replace above 0.010 in permanent deformation. | Rows `pdc_rt_p_r<i>_tool`, `_plate_a`, `_plate_b`, `_body_a`, `_body_b` |

5. **RT8 held until the logger is approved.** Agreed. Ship it **hidden** (behind a flag), not as a visible "N/A" line, so rigs don't start answering it early.
6. **Section heading:** "Riser Torque Tools (West Capella RTT gauge event, Oct 2026)".
7. **Announce the keys in the interchange before shipping,** with a sample post on **SSCE Equipment**. That lets Lee add the same lines to the Argo Navis matrix and SACRED build its side in the same week.

**SACRED's side once the keys are announced** (one scanner + dashboard change, about half a day):

- **Checklist viewer:** a "Riser Torque Tools" section, like the Rev 9 additions, with:
  - the 8 lines (Yes / No / dash, with remarks);
  - the gauge table (ID, cert, due date, **red if overdue on the checklist date**);
  - the socket table (S/N, NDE date, result);
  - set and verify readings side by side, **red if they differ by more than the band** (1,137–1,182 psi for 12,800 ft-lbs on HR-40/33C).
- **Database export:** new tables `pdc_rtt` (one row per checklist), `pdc_rtt_gauges` and `pdc_rtt_sockets`, read by **Power BI** (the data has moved there from Fabric; see week plan item 54).
- **A Rig Monitoring flag:** any rig whose latest pre-deployment checklist has RT1 or RT3 = No, or an overdue gauge.

---

## Part 3: the RTT pressure log (proposal, for the plan)

**SACRED supports it, in the order proposed.** Plan notes:

1. **Phase 1 (offline):** the logger's app CSV is attached in SSORT to an **"RTT Pressure Log"** record.
   - Build it as its **own SSORT tile** (`rttLog`), not inside the pre-deployment checklist: one record per **run** (`op` = run or pull).
   - The **per-bolt rows are parsed in the tool** from the CSV, so the post carries both rows and file, and the report and PDF print both.
   - **Peak detection:** the tool reads each make-up as one peak in the trace. The CSV format of the TDWLB-DL app is needed (**a sample file**) to write the parser.
2. **Phase 2 (office):**
   - the scanner reads the posted record, not a separate CSV: no new feed is needed;
   - the database export gains `rtt_bolt_log` (one row per bolt, with the fields listed in the handoff);
   - the dashboard shows each run's bolts **in / out of band**;
   - matching to the riser tally happens on **rig + joint serial** once the per-rig tally (item 32) or a PLATO export exists.
3. **Phase 3 (live):** needs ISIT / OT approval and an **Ex-rated** gateway. Out of scope until phases 1–2 prove the value.

**Carry these limits into the report:**

- the logger is ±1% FS, so it is for **monitoring, not setting**;
- **no hazardous-area rating** is published for the TDWLB-DL;
- nothing goes offshore until the rating is confirmed or an Ex alternative is chosen.

**What SACRED needs to start Phase 1:**

- a sample CSV from the TDWLB-DL app;
- the bolts per joint: now known, 8 (Shaffer FT-H);
- Dan's go-ahead after the workshop.

---

**Added to the SACRED plan:**

- the PDC "Riser Torque Tools" section and its viewer and export (after SSORT ships it, from 23 Oct);
- the RTT pressure log, phases 1–2 (after the logger is approved).
