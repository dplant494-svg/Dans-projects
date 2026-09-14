# West Jupiter Unplanned BOP Pull – Tubing Failure Extract

**Source:** IR-WCE-332-XXX REV 0, "WJU Unplanned BOP Pull" (Incident Report, August 2026)
**Created by:** Paul Calhoun – Technical Superintendent – Well Control
**Approved by:** Ronnie Peeples – Subsea & Well Control Equipment Manager
**Classification of source:** Internal (DIR-37-0179 distribution restrictions apply)
**Extract prepared:** 14 Sep 2026

This extract pulls out only what is linked to the MPR ILF supply tubing failure on the Yellow Pod: the event, what was found, what was done to correct it, the additional checks performed, and the actions still open. Related tubing and fitting findings from the same end-of-well scope are included because they feed the same fleet action. Non-tubing corrective maintenance is listed only in summary.

---

## 1. The event

| Item | Detail |
|---|---|
| Rig / BOP | West Jupiter |
| Date of failure | 26 Aug 2026, during routine function test (Yellow Pod) |
| Function being tested | High Pressure Blind Shear Close, Yellow Pod |
| Symptom | Subsea flowmeter kept counting while the function was executed. Functions placed in block, flow did not stop. |
| Isolation | Pod swapped, flow stopped on the Yellow Pod. Well made safe. |
| ROV | Fluid seen coming from the inboard side of the Yellow Pod. Exact location could not be identified subsea. |
| Dye trace | Mix tank prepared to spot dye into the control system. Stopped by Petrobras and Seadrill because of the volume of fluid already displaced to sea. |
| Downtime record | Synergi Case 1862810 (registered 26 Aug 2026, 22:30) |
| BOP pull | Wellhead connector unlocked 28 Aug 10:45. BOP on transporter 29 Aug 23:00. On maintenance stand 30 Aug 04:00. |
| BOP ready for deployment | 14 Sep 2026 |

## 2. How the leak was found on surface

1. On the transporter, leaks were seen on the Blue Pod pilot system (fluid from CCSV vent ports). Both pilots were dumped during troubleshooting and the system could not be pressurised.
2. A temporary supply was rigged to the pilot lines, plus a second temporary supply to the hotline manifold fed from the hotline panel at 1000 psi reduced pressure.
3. When the Yellow Pod was brought online, fluid was seen coming from the **tubing supplying MPR ILF function #30** (SPM #30). See Figure 1 of the report for the location.

## 3. Findings on the failed tubing

| Check | Result |
|---|---|
| Failure mode | ½" tube pulled out of the Swagelok fitting (elbow) at the SPM. Tube and elbow removed with the fitting nut (Figures 2, 3). |
| RVG (Swagelok gap) inspection | Performed on the removed connection. Confirmed **not** over-tightened beyond RVG gauge limits (Figure 4). Initial make-up gauge also good (Figure 5). |
| Tube OD | Confirmed ½" (caliper 0.510", Figure 6). |
| Wall thickness | Confirmed 0.065" (caliper 0.066", Figure 7). Rated 5,100 psi. |
| Circuit pressure | MPR ILF supply is a 3,000 psi circuit. |
| Nut and tube end | Photographed (Figures 8, 9). No separate defect noted in the text. |
| Support | Insufficient support clamps on the tubing run. |

**Required wall thickness per TB-WCE-006 Rev 5** (onboard-fabricated tubing), introduced because of earlier failures of thinner-wall tubing that was nominally within circuit rating:

| Size | Wall thickness | Working pressure |
|---|---|---|
| ¼" | 0.049" | 7,500 psi |
| ⅜" | 0.065" | 6,500 psi |
| **½"** | **0.083"** | **6,700 psi** |
| ¾" | 0.109" | 5,800 psi |
| 1" | 0.120" | 4,700 psi |

The installed ½" tube (0.065" wall) is below the 0.083" wall the TB requires, even though its 5,100 psi rating exceeds the 3,000 psi circuit.

**Report conclusion on root cause:** the tubing failure is a result of insufficient support clamps and inferior wall thickness of the tubing installed, although the tubing was within the working pressure range.

## 4. What was done to correct it

| Action | Pod | Detail |
|---|---|---|
| New MPR ILF supply tubing fabricated | Yellow | Fabricated to TB-WCE-006 Rev 5 wall thickness. Test fitted, fittings swaged with the swaging tool and Swagelok procedure. |
| Pressure test of new tubing | Yellow | Tested to 7,500 psi (1.5 × BOP maximum) although the circuit is 3,000 psi (Figure 11, 30 Aug 2026). |
| MPR ILF tubing removed and replaced | Blue | Same function on the Blue Pod removed from service as a precaution. Thicker-wall tubing fabricated and pressure tested. |
| Support brackets / tubing clamps | Both | Brackets fabricated and clamps installed on the MPR ILF tubing on both pods (Figures 14, 15). |
| RVG inspection of tubing | Both | Listed in corrective maintenance as a consequence of the Yellow Pod leak. |

## 5. Additional checks performed

**Pressure-induced-load test (UBSR / LBSR closure theory)**

Review of the circuit raised the theory that UBSR closure was inducing pressure on the MPR ILF supply circuit. After the new tubing was installed on SPM #30, a recorder was connected at the point of failure and the subsea function sequence was replicated (31 Aug 2026).

| Test | Panel mode | Peak pressure at MPR ILF SPM supply | Against old tube rating (5,100 psi) |
|---|---|---|---|
| UBSR close (Figure 12) | Drilling | 3,949 psi | Within rating |
| LBSR close (Figure 13) | Drilling | 3,984 psi | Within rating |

Both peaks are well above the nominal 3,000 psi of the circuit but inside the old tubing's rating. This supports the conclusion that the failure was support and wall-thickness driven rather than a simple over-pressure.

**Blue Pod inspection.** Blue Pod MPR ILF tubing was inspected and found to need additional support, which drove the precautionary replacement above.

**Other tubing / fitting checks in the same scope**

| Item | Finding | Action taken |
|---|---|---|
| Upper Annular surge tubing | Failed RVG inspection | Replaced |
| Pilot hose to SPM, function 64 | Hose putting stress on the tubing | Support installed. Long-term re-route of tubing required, to be included in the tubing company inspection scope. |
| Lower Annular Close shuttle #75 | JIC/JIC swivel with no Loctite, leaking (Synergi 1846570, 5 Jun 2026) | Temporary fix: shuttle end cap removed, NPT elbow installed, hose torqued with Loctite 243, end cap refitted with new o-ring. |
| UBSR ILF and LBSR ILF shuttles | Additional JIC/JIC swivels found on BOP inspection | Swivels removed, NPT/JIC elbows installed, hoses connected per TB with Loctite 243. |
| Blue Pod CCSV (Synergi 1833566, 2 Apr 2026) | Broken plunger, manifold pressure stuck at ~2,900 psi | Spare CCSV cartridge rebuilt with repair kit and installed. Included for history, not a tubing fault. |

## 6. Outstanding actions

### 6.1 Fleet action: third-party tubing assessment (report Action 1)

**The fleet will perform an assessment of all BOP tubing using a certified third-party company. That company will be Swagelok.**

From the report:

- Action 1, owner **TSC – AAB**: "Perform inspection of BOP with third party to identify and fix any issues with tubing support and tubing wall thickness. Issued on AAB."
- Conclusion: "A review of all BOP tubing and support is required utilizing a third party tubing company. Information for tubing inspection and replacement of thin wall tubing will be issued in AAB from previous event on West Vela."
- The West Jupiter function 64 tubing re-route is to be carried in the tubing company inspection scope.

Note: the report names a "third party tubing company" but does not name Swagelok. Naming Swagelok is the fleet decision communicated with this request, not a statement in REV 0.

Scope the assessment should cover, based on the findings:

1. Wall thickness of all onboard-fabricated tubing against the TB-WCE-006 Rev 5 table. Replace any thin-wall tubing.
2. Tubing support and clamping on every run, with attention to runs feeding SPMs that see induced pressure from ram functions.
3. RVG gap inspection of Swagelok connections.
4. Hose routing that loads tubing (as on function 64).
5. Identification of tubing runs that need re-routing for maintenance access (annular shuttles, accumulator readback).

### 6.2 Rig actions from the report (Actions table, page 10)

| # | Owner | Action | Tubing-linked? |
|---|---|---|---|
| 1 | TSC – AAB | Third-party inspection of BOP for tubing support and wall thickness. Issued on AAB. | Yes |
| 2 | SSS | Re-route Annular tubing to shuttles into an accessible position for maintenance (Open and Close shuttles to be relocated at next end of well, routed to top of LMRP base). | Yes |
| 3 | SSS | Run new tubing for accumulator readback from SPM to bulkhead fittings so the line is fully supported for hose connections, both pods. | Yes |
| 4 | TSC | Issue AAB for inspection of all BOP control systems and removal of any JIC/JIC swivel connections (prone to rotate and leak from water hammer and hose torque). | Yes (fittings) |
| 5 | SSS | Review location of control components for maintenance access and relocate as required. | Partly |
| 6 | SSS | Establish onboard spare list for regulators, CCSVs and SPMs. | No |
| 7 | SSS | Review fluid analysis and report last 12 months to TSC. | No |
| 8 | SSS | Review BWM ERT plan and update hours per task; provide times to Planner for future EOW periods. | No |

### 6.3 Other open items stated in the report body

- New mandate in well control directives restricting any use of JIC/JIC swivels. All rigs to review systems and remove them.
- AAB from the West Vela event to be issued covering tubing inspection and thin-wall tubing replacement.
- Long-term re-route of tubing on function 64 (currently only a hose support is installed).
- Lower Annular Close shuttle fix is temporary. Permanent relocation of both Open and Close shuttles at next end of well.
- PMs to be updated to reflect the OEM's changed riser connector maintenance schedule.
- Timeline still shows **TBD** for the initial installation date and last maintenance date of the MPR ILF SPM supply tubing. The history of the failed tube is not yet established.

## 7. Points to check before the report goes further

These look like REV 0 drafting issues, not findings. Worth correcting before wider distribution.

1. Page 1 says "The pod was swapped to Yellow and the flow stopped on the Yellow Pod." The timeline says "Soft swap to Blue Pod and pressure stabilized." The failure was on Yellow, so the swap was to Blue.
2. Page 1 gives the function test as 7:30–8:00 **p.m.** The timeline gives 07:30–08:00. One of these is wrong.
3. Timeline uses "MRP ILF" where the body uses "MPR ILF".
4. Action 4 reads "likely to leak to leak".
5. Two figures are numbered 24.
6. Report number is still IR-WCE-332-**XXX**; eDOCS and Maximo numbers are blank in the revision table.

## 8. Non-tubing corrective maintenance in the same scope (summary only)

Ram rubbers replaced; seal cartridges removed (mud); skid plates removed for NOV part identification and shear cavity inspection; Upper Annular hose replaced (blisters, partial collapse); LMRP split for riser connector maintenance; multiple CCSV, SPM and regulator rebuilds on both pods after leaks or failure to function during testing; pod snubbers re-orientated; WH pressure gauge and acoustic pod disarm gauge replaced; nitrogen valve and test unit drain valve replaced; test cap seals replaced; LMRP connector gasket retainer hoses replaced.

The report notes the mix system was dumped and pressure-washed to remove the dye added earlier, and asks for a fluid analysis review to confirm fluid cleanliness over the life of the components.
