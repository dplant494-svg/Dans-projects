# Day 1 sample reports — "what good looks like"

Four reports, one of each type the exercise produces, built from the **frozen builds**
(WCGRRT REV 167, SSORT REV 156) on asset `SSCE Equipment`. **None of them was posted** — each was
built through the tool's own form and captured from `buildReportPayload()` with the transport
disabled.

| File | Tool | Dated | Bytes | What it shows |
|---|---|---|---|---|
| `…_2026-10-01_daily-report.json` | WCGRRT 167 | 1 Oct | 34,621 | Three equipment entries with manufacturer, name, SFI and a written scope; two captioned photographs on the first |
| `…_2026-10-02_surface-bop-testing.json` | SSORT 156 | 2 Oct | 29,076 | A BOP Function Test — 326 populated `soak` keys |
| `…_2026-10-01_cbm-inspection.json` | SSORT 156 | 1 Oct | 47,330 | Riser Adapter: three condition grades (3 / 2 / 1) with findings, **a test passed (1) and a test failed (5)**, two photographs, two test records in `cbmatt` with task numbers, sign-off complete |
| `…_2026-10-03_pre-deployment-checklist.json` | SSORT 156 | 3 Oct | 43,509 | 52 populated keys, packer attestation, four cavity photographs |

## How to use them

**In the class** — these are the answer, not the route. Trainees post their own; these are what
the trainer shows when someone asks what a finished one should look like. The CBM sample is the
one worth putting on screen, because it is the only one that shows a grade, a finding and an
attached test record together.

**On the dashboard side** — load them into the viewer to check rendering ahead of the class. The
CBM sample exercises `cbmatt` end to end: two files, one PDF and one CSV, each with `name`, `type`,
`bytes`, `note` and `added`, and the note carrying the task number the file evidences.

## The revision stamped on them

**The CBM sample was regenerated on REV 156** and carries `meta.rev = "SSORT REV 156"`, the build
the class trains on. It now shows both kinds of grade in one file, which is the thing REV 156
changed:

- condition grades on the inspection tasks — `1_1_1_gr` = 3, `1_1_4_gr` = 2, `1_1_10_gr` = 1
- a **pass and a fail on two tests** — `1_2_1_gr` = 1, `1_2_2_gr` = 5

**The other three samples still read `SSORT REV 152`**, because they were generated before 153 and
have not needed rebuilding. They remain accurate: nothing between 152 and 156 changed the daily
report, the surface test or the pre-deployment checklist payloads. What changed in those revisions
was the OEM attachment flag (153), two defect fixes (154) and the CBM schedule (155, 156) — none of
which appears in those three files. Say so if a trainee spots it; it is a fair thing to notice.

## Two honest notes

- **The photographs are synthetic.** They are 240×170 labelled gradients generated in the browser,
  not real equipment, so the files stay small enough to read and open quickly. A real CBM report
  with a full photograph set runs to several megabytes; the largest seen in the fleet is 14.27 MB.
  Nothing else in these files is synthetic — the structure, keys and values are exactly what the
  tools produce.
- **The surface test and the pre-deployment checklist were filled programmatically**, so their free
  text is placeholder wording rather than a real day's work. The daily report and the CBM inspection
  carry written scopes and findings that read as a real record would.

## What is deliberately absent

No `seadrill-oem_*` sample. The OEM copy is generated at the moment of sending and carries a
timestamp in its name; producing one without sending would mean building a file the tool never
made. Module 3 demonstrates the button instead, and the OEM payload's shape is documented in
rolling handoff entries 31 and 43.
