# Handoff — new report type: TOPSET Investigation (Terms of Reference)

**To:** the dashboard / scanner session
**From:** the reporting-tools session (WCGRRT **REV 148**)
**Date:** 2026-08-19
**Transport:** unchanged. Same endpoint, same contract, same `seadrill-report_*` prefix.

---

## 1. What this is

A new report type in WCGRRT for commissioning an incident investigation under the
**Kelvin TOP-SET** methodology, used when a piece of well-control equipment has
failed or caused an incident.

**It is a Terms of Reference, not a findings report.** It defines scope, team,
authority and the plan for gathering evidence. It deliberately records **no
conclusions and no causes** — those come later, in the investigation report, which
is not built yet. Please don't present it as an outcome.

**Methodology context you'll need for labels.** TOP-SET is an acronym for the six
categories that facts get gathered against:

| Key | Letter | Leg |
|---|---|---|
| `tech` | T | Technology |
| `org` | O | Organisation |
| `ppl` | P | People |
| `sim` | S | Similar Events |
| `env` | E | Environment |
| `time` | T | Time |

Note **two legs begin with T** — Technology and Time. Use the `key`, never the
letter, to identify a leg.

---

## 2. How to identify one

Three signals, in order of reliability:

1. **`tiles[].topsetData` is a non-null object.** This is the definitive test.
2. **`tiles[].title === 'TOPSET Investigation'`**.
3. **Filename** contains `_topset-investigation` — e.g.
   `seadrill-report_West-Capella_2026-08-19_topset-investigation.json`.

`meta.type` (Visit Classification) will usually be `TOPSET Investigation`, but a
user can set it to plain `Investigation`, so **don't route on `meta.type` alone**.

Discipline stays `Well Control (WCEG)`. This is **not** a Marine or Mechanical
report, and nothing about it touches SSCE/COC.

---

## 3. Payload shape

```json
{
  "meta": { "asset": "West Capella", "discipline": "Well Control (WCEG)",
            "type": "TOPSET Investigation" },
  "tiles": [{
    "title": "TOPSET Investigation",
    "tileDate": "2026-08-19",
    "topsetData": {
      "torRef": "WCE-TOPSET-2026-004",
      "torRev": "Rev 1",
      "torStatus": "Approved",
      "raisedDate": "2026-08-19",
      "invLevel": "Level 2 — cross-discipline team",
      "severity": "High",
      "synCaseTs": "",
      "incidentNumber": "",
      "incDate": "2026-08-17", "incTime": "04:30",
      "incLocation": "Moonpool", "operation": "Running BOP",
      "statement": "free text, newlines preserved",
      "eqName": "Annular BOP", "eqMfr": "", "eqModel": "", "eqSerial": "",
      "eqTag": "", "eqLastMaint": "", "eqHours": "", "eqQuarantine": "Yes",
      "consequence": "free text",
      "scopeIn":     ["string", "..."],
      "scopeOut":    ["string", "..."],
      "objectives":  ["string", "..."],
      "limitations": "free text",
      "team":         [{ "name":"", "role":"", "org":"", "contact":"" }],
      "competence":   "free text",
      "commissionedBy":"", "sponsor":"", "reportsTo":"", "escalation":"",
      "authority":    "free text",
      "mStoryboard": true, "mLegs": true, "mCause": false, "mWhy": false,
      "mInterviews": false, "mSite": false, "mStrip": false, "mLab": false,
      "mData": false, "mDocs": false, "mSim": false, "mBarrier": false,
      "leg_tech_note": "free text", "leg_org_note": "", "leg_ppl_note": "",
      "leg_sim_note": "",  "leg_env_note": "", "leg_time_note": "",
      "legs": {
        "tech": [{ "enquiry":"", "evidence":"", "source":"", "owner":"",
                   "due":"YYYY-MM-DD", "status":"In progress" }],
        "org": [], "ppl": [], "sim": [], "env": [], "time": []
      },
      "evQuarantined": true, "evNotice": false, "evPhotos": true,
      "evData": false, "evParts": false, "evCustody": false,
      "evLocation":"", "evCustodian":"", "evDeadline":"",
      "evidence":     [{ "item":"", "action":"", "owner":"", "ref":"" }],
      "interviews":   [{ "name":"", "role":"", "date":"", "by":"", "status":"" }],
      "deliverables": [{ "item":"", "owner":"", "due":"", "status":"" }],
      "cfNoBlame": true, "cfSeparate": false, "cfLegal": false, "cfClient": false,
      "distribution": "free text", "cfClass": "Confidential",
      "regNotifiable": "No", "regWho": "", "regRef": "", "regRapid": "",
      "regNotes": "free text",
      "resTravel":"", "resOem":"", "resBudget":"", "resApproved":"",
      "signoff":      [{ "name":"", "position":"", "role":"", "date":"" }],
      "reportDate": "2026-08-19"
    }
  }]
}
```

### Notes on the shape

- **`m*`, `ev*` (the six booleans), `cf*` are real booleans.** Everything else is a
  string or an array of objects. No numbers anywhere.
- **`legs` always has all six keys**, and an unused leg is `[]` — not missing, not
  null. An empty leg with a populated `leg_<key>_note` means *"considered and ruled
  out"*, which is a decision, not a gap. Please don't render it as incomplete.
- **`status` values** on legs and deliverables come from a fixed list:
  `Not started` · `In progress` · `Complete` · `Not applicable` (plus empty).
- **Free-text fields may contain newlines.** No HTML — these are plain textareas.
  If you render them, convert `\n` to `<br>` yourself.
- **No photos and no attachments** in this report type. Nothing base64.
- Typical payload is **a few KB**. It will not stress the transport.

---

## 4. Dedup and identity

Suggested newest-wins key: **`rig | torRef | tileDate`**.

`torRef` is the investigation's own reference (e.g. `WCE-TOPSET-2026-004`) and is
the natural identity — one investigation, revised over time. `torRev` tracks the
revision and `torStatus` moves `Draft → Issued for approval → Approved →
Superseded → Closed`.

**Please show the latest revision, and do not latch status** — same lesson as the
`projectComplete` issue in `DASHBOARD-PROJECT-COMPLETE-LATCH-HANDOFF.md`. A ToR
going from `Approved` back to `Draft` is legitimate and must be reflected.

If `torRef` is blank, fall back to `rig | tileDate` and flag it — an investigation
without a reference is a data-quality problem worth surfacing.

---

## 5. What would actually be useful on the dashboard

Suggestions, not requirements — you know the users' habits better.

1. **An open-investigations list.** Rig, equipment (`eqName`), `torRef`, severity,
   `torStatus`, date raised, team leader (the `team` row whose `role` is
   `Investigation Team Leader`). That question — *"what investigations are open
   right now?"* — currently needs someone to go and ask.
2. **Overdue evidence.** Across `legs.*`, any row where `due` is in the past and
   `status` is not `Complete` or `Not applicable`. This is the single most useful
   thing here: TOP-SET investigations stall because evidence gathering slips, and
   nobody sees it slipping.
3. **Deliverables tracker.** Same treatment for `deliverables`.
4. **Quarantine watch.** Where `evQuarantine`/`evQuarantined` is set and
   `evDeadline` is approaching — equipment released before evidence is captured is
   how investigations die.
5. **Leg coverage at a glance.** Six small indicators per investigation showing
   which legs have lines of enquiry. Useful as a completeness prompt for the team
   leader, **not** as a score, and definitely not compared between rigs.
6. **Link to related records.** `synCaseTs` (Synergi) and `incidentNumber`
   (RAPID-S53) are slots for joining up later.

### Please don't

- **Don't present this as findings or causes.** It contains neither, by design.
- **Don't rank or score rigs on investigation counts.** More investigations often
  means better reporting culture, not worse equipment.
- **Respect `cfClass`.** Values are `Seadrill Internal`, `Confidential`,
  `Restricted — named recipients only`. Anything other than `Seadrill Internal`
  should not be broadly visible on a shared dashboard — at minimum show the header
  row and withhold the body, or exclude it entirely until access control exists.
  Investigations touch people and can be legally sensitive. **If in doubt, exclude
  it and tell Dan** rather than publish it.

---

## 6. Other REV 148 changes

None affecting you. REV 148 adds this report type only. The REV 147 changes
(`meta.float` now manual free text, `planningData.comments` now a `<ul>`,
`meta.bopNo` populated more often) are covered in
`DASHBOARD-PROJECT-COMPLETE-LATCH-HANDOFF.md`.

Posting transport verified byte-identical to REV 145. Standing instruction from
Dan: **do not change how anything is posted.**

---

## 7. Questions back to us

1. Is `rig | torRef | tileDate` the right dedup key, or would you rather we emit an
   explicit stable `topsetId`? We can add one if it makes your life easier.
2. Do you want the overdue-evidence rollup computed our side and included in the
   payload, or will you derive it from `legs.*`? Deriving it is cleaner, but say if
   you'd rather have it precomputed.
3. How do you want to handle `cfClass` above `Seadrill Internal` — exclude, redact,
   or wait for access control?
