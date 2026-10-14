# To Lee (Argo Navis): five new pre-deployment checklist lines, FRM-00-0168 Rev 9

**From:** Dan Plant, prepared by the reporting-tools session · **Date:** 14 October 2026
**Status:** for Argo Navis's pre-deployment checklist. The same items are **live in SSORT 165 since 14 October**, on the emergency
copy of the checklist, so the two match.

## Dan, 14 October

> *"we need a section with pictures of all ROV panel valve orientation and line up. we also need added pre deployment checklist
> for running and pulling riser, drops inspection and riser has been verified and all seals are of satisfactory condition and are
> of the correct orientation. Advise if riser maintenance was conducted by 3rd party, CBM or Seadrill. make these tick boxes"*

His decisions on the details:

- **The form.** These are **FRM-00-0168 Rev 9** items. The form is going to Rev 9; until document control issues it, SSORT shows
  them as a section headed "FRM-00-0168 Rev 9 Additions" below the unchanged Rev 8 items.
- **ROV photographs.** Free photographs, each with a caption naming the panel and the valve. There is no fixed slot per valve.
- **Riser maintenance by.** Tick all that apply: 3rd party, CBM, Seadrill. Ticking 3rd party asks for the company's name.

## The lines, in the resolved matrix's columns

The ROV line sits with the BOP evidence. The four riser lines are a new section; call it **R · Riser**, or fold it in wherever
fits your sections.

| Line | Checklist line | One row per | Evidence / what is recorded | Complete when | N/A allowed? | SSORT 165 keys (`pdcData`) |
|---|---|---|---|---|---|---|
| **C-05** | ROV panel: valve orientation and line-up | stack | A tick ("all ROV panel valves verified in the correct orientation and line-up for deployment, and photographed"), plus photographs, each captioned with the panel and the valve | Ticked, with photographs of the panel valves | No | `pdc_r9_rov_lineup` (`"1"` / `""`), `pdc_r9_rov_ph` (`[{src, caption}]`) |
| **R-01** | Pre-deployment checklist for running and pulling riser completed | checklist | Tick | Ticked | Only if no riser is run (reason) | `pdc_r9_riser_checklist` |
| **R-02** | Drops inspection completed | checklist | Tick | Ticked | No | `pdc_r9_riser_drops` |
| **R-03** | Riser verified: all seals in satisfactory condition and in the correct orientation | checklist | Tick | Ticked | Only if no riser is run (reason) | `pdc_r9_riser_seals` |
| **R-04** | Riser maintenance conducted by | checklist | Tick all that apply: 3rd party (with the company's name), CBM, Seadrill. Remarks free text | At least one ticked; a 3rd party is named | No | `pdc_r9_riser_by_3p`, `pdc_r9_riser_by_3p_company`, `pdc_r9_riser_by_cbm`, `pdc_r9_riser_by_seadrill`, `pdc_r9_riser_rem` |

The SSORT keys are listed so a SSORT copy and an Argo Navis copy mean the same thing. They are the interchange the dashboard
already asked for (entry 67). Ticks are `"1"` when ticked and `""` when not; text is a string; photos are `{src, caption}`.

## Suggestions, your call

- **R-02 and R-04 can be populated from the plan rather than asked.**
  - If the plan has a drops-inspection task, its completion could tick R-02.
  - The riser PM work orders' executing party (Seadrill, a named 3rd party, or a CBM inspection) could pre-answer R-04, for the
    crew to confirm.

  That is in the spirit of "populated, not asked" from the matrix review.
- **C-05 could get labelled photograph slots later.** Each stack's ROV panel functions are already in SSORT, from the NOV ROV
  function sheets: 23–40 per stack, for every stack except Sevan Louisiana. If you ever want one slot per valve (as the cavity
  photographs have), the list is there. Dan chose free photographs for now.
- **The gate.** In SSORT the only new stop before posting is "3rd party ticked but no company named". The ticks themselves do not
  block a post, because the emergency copy must still post. In Argo Navis, the "pre-deployment complete" rule (Q6: every line
  closed and every required sign-off) would cover them.

## Where to see it

- **SSORT 165**, live at `http://sdrlazneuiis01d.corp.local:8080/SSORT/index.html`: Rig Reporting → 🚀 Pre-Deployment Checklist,
  below Electrical Scope.
- **Screenshots of the section and its PDF:** `pdc-rev9-form.png`, `pdc-rev9-riser.png` and `pdc-rev9-report.png`, sent with
  this file.
