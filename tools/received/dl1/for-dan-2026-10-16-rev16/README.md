# Argo Navis REV 16: Lee's handover to Dan, 16 Oct 2026 (filed by SACRED)

Received from Dan as `Handover_to_Dan.zip`. Start with `00_ARGO-NAVIS-HANDOVER-TO-DAN-2026-10-16.md`.

**Filed here:** only what is new since REV 15 (`../for-dan-2026-10-16-rev15/`):

- the deploy package;
- the four replies;
- the REV 16 session save sample;
- the REV 16 screenshots;
- the updated guide and QA/QC page.

The REV 14 / REV 15 samples, the REV 15 screenshots and the two job plan workbooks are byte-identical to the copies already filed under `../for-dan-2026-10-16-rev15/` and `../for-dan-2026-10-14-rev14/`.

## Checked by SACRED

- **Hashes match Lee's note:**
  - zip `d7383205…41a3`;
  - `index.html` and `Seadrill BOP Schedule Builder.html` are identical, `299eed6e…e945`.
- **No intake address** anywhere in the pack or the unzipped tool. The only hosts in the tool are:
  - the SACRED server;
  - infocenter.seadrill.com (eDOCS);
  - the Synergi Life site;
  - the OpenXML schema.
- **The session save sample** (`West-Vela_DL1_session_WVE-BOP1-20261014.json`) is what scanner v3.08 expects:
  - `meta.kind = "plan-session"`, `meta.planid`, a top-level `scheduleBuilderState`, and `dryRun: true`;
  - so it files as a test session and lands in `plans-state/WVE-BOP1-20261014.test.json` and its `index.json`. No scanner change is needed.
- **The REV 15 daily report sample** in this pack is byte-identical to the one Continue refused on REV 15 (sha256 `6a6562f1…`). REV 16 reads the state wherever it sits (top level, `plan`, `session`, or the intake wrapper), so Dan re-tests it on REV 16.

**SACRED's reply:** `handoffs/lee-2026-10-16/ARGO-NAVIS-REV16-REPLY-FROM-SACRED-2026-10-16.md`.
