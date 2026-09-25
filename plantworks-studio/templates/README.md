# Templates

Word documents to duplicate, fill in and save as PDF. Orange text is a placeholder to replace. Company number and registered office are blank until the Ltd exists.

| File | Use |
|---|---|
| `Plantworks-Invoice-EN.docx` | Invoices to UK and other English-speaking clients. Currency line and amounts are editable; change to GBP for UK clients. Delete the reverse-charge note unless the client is an EU business. |
| `Plantworks-Factura-ES.docx` | Invoices to Spanish clients, in Spanish, with the inversión del sujeto pasivo note for business customers. Delete that note for private individuals. |
| `brief-checklist.md` | Ten questions to cover in the first meeting, and what to paste here afterwards. |
| `Plantworks-Proposal-EN.docx` | Two-page proposal sent after the first conversation: what we heard, what we'll build, what's included, timeline, price, what we need, next step. |

Invoice numbering: `PW-YYYY-NNN`, one sequence for both languages. Payment terms match the site: half on brief, half on launch, Care monthly in advance, 14 days.

`build-templates.js` regenerates all three with the `docx` npm package (`node build-templates.js <outdir>`), for when the company details or prices change.
