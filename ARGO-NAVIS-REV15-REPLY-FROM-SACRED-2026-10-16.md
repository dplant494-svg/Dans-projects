# Reply to Argo Navis REV 15, from SACRED

**Date:** 16 Oct 2026. **To:** Lee Arnold and the Argo Navis session, via Dan. **Re:** the REV 15 reply to Handoff 2 and its addendum, and the `For Dan` pack of 15 Oct evening.

**Thank you.** Every part of Handoff 2 is answered, with tests. What SACRED checked on its side:

- **The package is clean.** The zip and HTML hashes match your note: zip `17a2be5c…6576`, HTML `b35f2b1b…2b46`. A scan of the whole pack finds no intake address anywhere.
- **Your daily report sample prints and sends.**
  - `SAMPLE_West-Vela_DL1_planning-report_BOP1_v2.json` went through scanner v3.06. WCGRRT 172's template printed it to a 2-page PDF with every block filled: rig people, times on current finish and need date, variance and float in hours, 11.52% / 17.28% BOP, ten milestones, and BRK-001 with its MOC ref.
  - It was offered to the Daily Summary Report flow as a **test**, because of `dryRun`. Subject: `[TEST MODE] West Vela BOP1 BWM Reporting 2026/10/15 0700`.
  - The flow is built and proven on Dan's side: email to Dan only, PDF attached, sent once.
- **"BWM — Between Well Maintenance" in the subject.** v3.06 now takes the code before the dash, so the subject reads "BWM". No change needed from you.

## Your four questions (Dan's answers)

1. **BOP ready date = the finish of the BOP set** (SFI 331 + 332 + the BOP sequence): **yes.** It matches Dan's definition of BOP %: only BOP work counts toward the deployment timeline. `curFinish` stays the whole plan's finish. Keep the banner that says when non-BOP work runs past the BOP ready date.
2. **`sfiGroup` names.** SSORT 163 uses **Maximo's own names** (rolling entry 66.1), so SSORT, the CoC tracker and Maximo all match. Please use them:
   - 331 BLOWOUT PREVENTER STACK
   - 332 BLOWOUT PREVENTER CONTROL SYSTEM
   - 334 DIVERTER WITH CONTROL SYSTEM
   - 335 RISER SYSTEM INCL. CHOKE, KILL LINES
   - 336 CHOKE AND KILL SYSTEM INCL. MUD/GAS SEPARATOR
   - 337 MISCELLANEOUS WELL CONTROL RELATED EQUIPMENT
   - 339 MANAGED PRESSURE DRILLING
   - **No Maximo name yet,** so SSORT's derived names stand: 302 HEAVE COMPENSATION & CROWN BLOCK, 314 RISER & GUIDELINE TENSIONING, 315 HP COMPRESSED NITROGEN.

   Your Hub names ("302 Heave / motion compensation", "315 Subsea support utilities") should change to these, so every tool shows the same words.
3. **The 31 SFI 302 / 315 Branch Map rows: accepted**, as proposed: Offline Ancillary, one parallel group per SFI, rank 500, durations as given. The only change is the group names, which follow answer 2: "302 HEAVE COMPENSATION & CROWN BLOCK" and "315 HP COMPRESSED NITROGEN".
4. **The event PM exports: yes, through the scanner.** Put `BWM_Event_PMs_Maximo_*.csv` and `CBM_Event_PMs_Maximo_*.csv` on the share, then tell Dan where. He adds that folder to the scanner's `dl1DataSources`, and they arrive in `/sacred/dl1/data/` with the other inputs. **SACRED does not need the "no WO yet" list as a separate post for now.** Showing it in Argo Navis is enough.

## Noted from REV 15 (no action)

- **Break-ins move the schedule** (A6). "Waiting / NPT" is a break-in placed before the task it holds up, and the NPT log is a tally only. The report reads correctly either way.
- **The checklists are built in** (B5), and the address comes from `argo-config.json`. **Dan removes `Argo-Navis-Job-Plan-Checklists.html` from the server** when he deploys REV 15. That takes one copy of the intake address off the share (ORR KE-10).
- **The value changes:** `pctComplete` follows the spec, `float` is in hours, `maintDay` uses `planMaintDayText`. The scanner reads them as they come.
- **NC numbers** come from Manpreet's new `NC` column, or are typed on the deferral (B7). Thank you; that also answers the question to Manpreet.

## Still open from earlier

`review.comments`, the freeze version, the sign-off order, B-16 / B-M1, and the eDocs prefix. These are unchanged and waiting on Dan.
