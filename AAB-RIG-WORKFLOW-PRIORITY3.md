# The rig's workflow for a Priority 3 Advisory — what DIR-37-0161 requires, and how the loop does it

**For:** Dan, for the AAB Notifications flow guide and the one-page rig bulletin · **Date:** 23 September 2026
**Source:** DIR-37-0161 Management of Technical Alerts, Advisories and Bulletins v6.07, §2.1, §2.2.3, §2.2.4; the loop in `AAB-LOOP-PLAN.md`

## 1. What the directive requires of the rig for a Priority 3

| Clause | Requirement today (Maximo) | The same requirement in the loop |
|---|---|---|
| §2.2.3 | A Priority 3 is Notification / Advisory: information only, "Not required by Corporate, for information only" in the scope; not mandatory; no cost or operational impact tick | The record carries `priority: 3`, `corporateMandatory: false`; the PDF and the email say so in the directive's words |
| §2.2.4 | "Both TSLs must review the AAB and acknowledge having done so by ticking the box by their respective names and adding a comment in the child AAB case" | Each crew's TSL opens the acknowledgement page, sees the advisory and the bulletin, enters name, crew (A or B), a comment, and presses Acknowledge. Two acknowledgements make the rig fully acknowledged; one makes it partly acknowledged until the other crew is on board |
| §2.2.4 | "Typically there is no follow up required on these AABs since they are informational only. However, the TSL has the option to add additional reviewers if deemed necessary" | The action-closed state exists only when the gatekeeper marked "action requested"; the TSL can name additional reviewers in the comment (the craft supervisor, §2.1) |
| §2.1 | Rig Manager: responsible for the directive being followed on the rig. OIM / TSL: ensure appropriate actions are implemented; TSL adds the responsible craft supervisor as a reviewer | Unchanged in substance. The Rig Manager and OIM are on the email; the TSL acknowledges; the craft supervisor is named in the comment where relevant |
| §2.2.4 | Required closure date inherited from the parent case | The due date the gatekeeper sets on the AAB |
| §2.2.4 | Technical Services periodically reviews AABs in WTSREV status | Technical Services reads the dashboard AAB tab: overdue first, then percent acknowledged |

Priority 1 and 2 are not in the loop: Rig Manager, ARM, both OIMs and both TSLs acknowledge those, in Maximo, with work orders where required.

## 2. The rig's steps, as the bulletin will say them

1. **An email arrives** with the subject `[Seadrill Bulletin Board] Priority 3 Advisory <number> Rev <n> — <title>`, the AAB PDF and the bulletin attached, and a link. It goes to the rig's Subsea Supervisor, TSL, OIM, ARM and Rig Manager as listed on the Rigs sheet.
2. **Read the AAB.** The PDF is the advisory; the bulletin is the OEM or Seadrill document behind it.
3. **The TSL on duty acknowledges**: open the link (or `sacred/aab/acknowledge.html?rig=<rig>` from any rig browser), find the advisory in the open list, enter name, crew A or B, a comment (what was checked, who was told), press Acknowledge. The gatekeeper and Technical Services get an email that says the rig has acknowledged.
4. **The other crew's TSL acknowledges** at the next crew change, the same way. The dashboard shows the rig as fully acknowledged when both are in.
5. **If the advisory asks the rig to do something** (the AAB says "action requested"), do it, then press Close action on the page with a comment and photographs of the evidence.
6. **If nothing happens by the due date**, the rig contacts get a chase email every day until the acknowledgement is in. The dashboard shows the rig as overdue.
7. **A revision arrives the same way** and, when marked so, every rig acknowledges again. The earlier acknowledgements stay on record.
8. **West Gemini**, until its route to the server is fixed: read the PDF from the email and acknowledge by replying to the gatekeeper; Technical Services enters it on the rig's behalf with the reply on file.

## 3. What the AAB Notifications flow must do to serve that workflow

| Branch | Trigger | Recipients | Attachments | Subject |
|---|---|---|---|---|
| Issued | `seadrill-aab_*` created | per applicable rig: SS, TSL, OIM, ARM, Rig Manager from the Rigs sheet; CC Office and the originator | the AAB PDF (`pdf` / `pdfName`) and the primary bulletin from `attachments[]` | `[Seadrill Bulletin Board] Priority 3 Advisory <number> Rev <n> — <title>` |
| No rig contact | a rig on `rigsApplicable` with no row or no addresses on the Rigs sheet | Office | none | `[NO RIG CONTACT] Priority 3 Advisory <number> for <rig>` |
| Acknowledged / closed | `seadrill-aab-ack_*` created | originator, CC Office | none | `<rig> acknowledged <number> Rev <n> (TSL crew <A/B>)` or `<rig> closed the action on <number>` |
| Chase | `aab-overdue-pending.json` written by the scanner, once per AAB per rig per day | the rig's contacts as above; CC originator and Office | the AAB PDF | `[OVERDUE] Priority 3 Advisory <number> Rev <n> — <rig> has not acknowledged` |
| Test mode | `Settings` `TestMode` = Yes | Office only, `[TEST MODE]` prefix, red line naming the real recipients | as the branch | as the branch |

All four read the `Settings` table first (test mode), the Rigs and Office tables from the notification workbook, and post nothing themselves. Same pattern as the CBM to OEM flow built on 22 September, with the acknowledgement branch new.

## 4. What the dashboard side computes for the compliance view

Per current AAB revision per applicable rig: `outstanding` (no TSL yet) · `partly acknowledged` (one crew) · `acknowledged` (both crews) · `action open` (acknowledged, `actionRequested` true, no close) · `closed` · `overdue` (past the due date and not acknowledged by both crews). The AAB tab shows the overdue count first, then percent of rigs fully acknowledged, then the list; the per-rig view shows that rig's open advisories and its history. The Compliance Checklist P1 item in WCGRRT points here once the change is live.
