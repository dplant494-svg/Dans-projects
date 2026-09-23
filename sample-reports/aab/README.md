# AAB test records (synthetic, 23 Sep 2026)

Built by the dashboard session for Eric's Bulletin Board Rev 5 session and for the dashboard side
to build against. Nothing here came from a tool or a rig; every text field says TEST; the PDFs
are one-page stand-ins; the photographs are the AAB logo standing in for a picture.

| File | What it is |
|---|---|
| `seadrill-aab_C10250746_0_...json` | an AAB, revision 0, applicable to West Vela and West Capella, schema 2.0 with the meta block, sfi, attachments[] (primary bulletin PDF), photos[], rigNames, pdf / pdfName (the generated AAB PDF) |
| `seadrill-aab_C10250746_1_...json` | revision 1 of the same AAB, requires re-acknowledgement |
| `seadrill-aab-ack_..._vela_20260924-...json` | West Vela acknowledges revision 0 (action: acknowledge) |
| `seadrill-aab-ack_..._vela_20260926-...json` | West Vela closes the action on revision 0 (action: close, comment, evidence photo) |

Expected dashboard state after all four: C10250746 current revision 1; West Vela outstanding on
revision 1 (its revision 0 acknowledgement and closure kept as history); West Capella outstanding
on revision 1 with no history; both overdue after 7 Oct 2026 until acknowledged.

Do not upload these to PostedReports. A post to the estate is Dan's, in test mode.
