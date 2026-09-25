const fs = require('fs');
const path = require('path');
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, WidthType, AlignmentType,
  BorderStyle, ShadingType, LevelFormat, TabStopType, PageBreak, ImageRun,
} = require('docx');
const LOCKUP = fs.readFileSync('/home/user/Dans-projects/plantworks-studio/site/brand/lockup.png');

const OUT = process.argv[2] || '.';
const NAVY = '1B2A38', SOL = 'E0762E', SOFT = '5B6672', LINE = 'D9D3C5', SAND = 'F5EFE6';
const W = 9638; // A4 content width in DXA with 2cm margins
const NONE = { style: BorderStyle.NONE, size: 0, color: 'FFFFFF' };
const noBorders = { top: NONE, bottom: NONE, left: NONE, right: NONE, insideHorizontal: NONE, insideVertical: NONE };
const hair = { style: BorderStyle.SINGLE, size: 4, color: LINE };

const t = (text, o = {}) => new TextRun({ text, font: o.font || 'Calibri', size: o.size || 21, bold: o.bold, italics: o.italics, color: o.color || '1E2730' });
const ph = (text) => t(text, { color: SOL });               // placeholder to fill in
const P = (children, o = {}) => new Paragraph({ children: Array.isArray(children) ? children : [children], alignment: o.align, spacing: { before: o.before || 0, after: o.after ?? 80 }, border: o.border, numbering: o.numbering, tabStops: o.tabStops });
const display = (text, size = 40) => new Paragraph({ children: [t(text, { font: 'Georgia', size, bold: true, color: NAVY })], spacing: { after: 60 } });
const label = (text) => new Paragraph({ children: [t(text.toUpperCase(), { size: 16, bold: true, color: SOL })], spacing: { before: 200, after: 60 } });
const cell = (children, width, o = {}) => new TableCell({ children: Array.isArray(children) ? children : [children], width: { size: width, type: WidthType.DXA }, borders: o.borders || noBorders, shading: o.shade ? { type: ShadingType.CLEAR, fill: o.shade, color: 'auto' } : undefined, margins: { top: 60, bottom: 60, left: 100, right: 100 }, verticalAlign: o.valign });
const table = (rows, widths, o = {}) => new Table({ rows, columnWidths: widths, width: { size: widths.reduce((a, b) => a + b, 0), type: WidthType.DXA }, borders: o.borders || noBorders });
const rule = () => new Paragraph({ children: [], border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: SOL, space: 1 } }, spacing: { after: 160 } });
const bullets = { config: [{ reference: 'b', levels: [{ level: 0, format: LevelFormat.BULLET, text: '•', alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 400, hanging: 240 } } } }] }] };
const bullet = (children) => P(children, { numbering: { reference: 'b', level: 0 }, after: 60 });

function header(L) {
  return table([new TableRow({ children: [
    cell([
      new Paragraph({ children: [new ImageRun({ type: 'png', data: LOCKUP, transformation: { width: 300, height: 89 } })], spacing: { after: 0 } }),
    ], 5200),
    cell([
      P(t('Plantworks Studio Ltd', { bold: true, size: 20 }), { align: AlignmentType.RIGHT, after: 0 }),
      P([t(L.coNo + ' ', { size: 18, color: SOFT }), ph('[00000000]')], { align: AlignmentType.RIGHT, after: 0 }),
      P([t(L.regOffice + ' ', { size: 18, color: SOFT }), ph('[registered office address, UK]')], { align: AlignmentType.RIGHT, after: 0 }),
      P(t('info@plantworksstudio.com', { size: 18, color: SOFT }), { align: AlignmentType.RIGHT, after: 0 }),
      P(t('plantworksstudio.com', { size: 18, color: SOFT }), { align: AlignmentType.RIGHT, after: 0 }),
    ], 4438),
  ] })], [5200, 4438]);
}

function invoice(L) {
  const meta = table([new TableRow({ children: [
    cell([P(t(L.invNo, { size: 16, bold: true, color: SOL }), { after: 0 }), P(ph('PW-2026-001'))], 2409, { shade: SAND }),
    cell([P(t(L.date, { size: 16, bold: true, color: SOL }), { after: 0 }), P(ph('[dd Month yyyy]'))], 2409, { shade: SAND }),
    cell([P(t(L.due, { size: 16, bold: true, color: SOL }), { after: 0 }), P(ph('[dd Month yyyy]'))], 2409, { shade: SAND }),
    cell([P(t(L.currency, { size: 16, bold: true, color: SOL }), { after: 0 }), P(ph(L.cur))], 2411, { shade: SAND }),
  ] })], [2409, 2409, 2409, 2411]);

  const billTo = table([new TableRow({ children: [
    cell([label(L.billTo), P(ph('[Client business name]'), { after: 0 }), P(ph('[Contact name]'), { after: 0 }), P(ph('[Street address]'), { after: 0 }), P(ph('[Town, postcode, country]'), { after: 0 }), P([t(L.taxId + ' ', { color: SOFT }), ph('[client tax ID]')])], 4819),
    cell([label(L.project), P(ph('[Multi-page bilingual website for Client business name]'), { after: 0 }), P([t(L.stage + ' ', { color: SOFT }), ph(L.stageEg)])], 4819),
  ] })], [4819, 4819]);

  const hdr = (x, w, right) => cell(P(t(x, { size: 18, bold: true, color: 'FFFFFF' }), { align: right ? AlignmentType.RIGHT : undefined, after: 0 }), w, { shade: NAVY });
  const row = (d, q, u, a, shade) => new TableRow({ children: [
    cell(P(d, { after: 0 }), 5638, { shade, borders: { bottom: hair } }),
    cell(P(t(q), { align: AlignmentType.RIGHT, after: 0 }), 1000, { shade, borders: { bottom: hair } }),
    cell(P(t(u), { align: AlignmentType.RIGHT, after: 0 }), 1500, { shade, borders: { bottom: hair } }),
    cell(P(t(a), { align: AlignmentType.RIGHT, after: 0 }), 1500, { shade, borders: { bottom: hair } }),
  ] });
  const items = table([
    new TableRow({ children: [hdr(L.desc, 5638), hdr(L.qty, 1000, true), hdr(L.unit, 1500, true), hdr(L.amount, 1500, true)] }),
    row(ph(L.line1), '1', L.m[0], L.m[0]),
    row(ph(L.line2), '1', L.m[1], L.m[1]),
    row(ph(L.line3), '1', L.m[2], L.m[2]),
  ], [5638, 1000, 1500, 1500]);

  const totals = table([
    new TableRow({ children: [cell(P(t(L.subtotal, { color: SOFT }), { align: AlignmentType.RIGHT, after: 0 }), 7138), cell(P(t(L.m[3]), { align: AlignmentType.RIGHT, after: 0 }), 2500)] }),
    new TableRow({ children: [cell(P(t(L.vatLabel, { color: SOFT }), { align: AlignmentType.RIGHT, after: 0 }), 7138), cell(P(t(L.m[2]), { align: AlignmentType.RIGHT, after: 0 }), 2500)] }),
    new TableRow({ children: [cell(P(t(L.total, { bold: true, size: 24, color: NAVY }), { align: AlignmentType.RIGHT, after: 0 }), 7138, { borders: { top: { style: BorderStyle.SINGLE, size: 8, color: NAVY } } }), cell(P(t(L.m[3], { bold: true, size: 24, color: NAVY }), { align: AlignmentType.RIGHT, after: 0 }), 2500, { borders: { top: { style: BorderStyle.SINGLE, size: 8, color: NAVY } } })] }),
  ], [7138, 2500]);

  const pay = table([new TableRow({ children: [
    cell([label(L.payBank), ...L.bank.map(([k, v]) => P([t(k + ' ', { color: SOFT, size: 19 }), v.startsWith('[') ? ph(v) : t(v, { size: 19 })], { after: 0 }))], 4819, { shade: SAND }),
    cell([label(L.payCard), P(ph('[Stripe payment link]'), { after: 40 }), P(t(L.cardNote, { size: 18, color: SOFT }), { after: 120 }), label(L.terms), P(t(L.termsText, { size: 18, color: SOFT }))], 4819, { shade: SAND }),
  ] })], [4819, 4819]);

  return new Document({
    numbering: bullets, styles: { default: { document: { run: { font: 'Calibri', size: 21 } } } },
    sections: [{ properties: { page: { margin: { top: 1134, right: 1134, bottom: 1134, left: 1134 } } }, children: [
      header(L), P([], { after: 120 }), rule(),
      display(L.title), P([], { after: 60 }),
      meta, P([], { after: 120 }),
      billTo, P([], { after: 160 }),
      items, P([], { after: 80 }),
      totals, P([], { after: 200 }),
      P(t(L.vatNote, { size: 18, italics: true, color: SOFT }), { after: 200 }),
      pay, P([], { after: 200 }),
      P(t(L.footer, { size: 16, color: SOFT }), { align: AlignmentType.CENTER }),
    ] }],
  });
}

const EN = {
  tagline: 'STUDIO · UK & COSTA DEL SOL', coNo: 'Company no.', regOffice: 'Registered office:',
  title: 'Invoice', invNo: 'Invoice number', date: 'Invoice date', due: 'Due date', currency: 'Currency', cur: 'EUR', m: ['\u20ac1,500.00', '\u20ac150.00', '\u20ac0.00', '\u20ac1,650.00'],
  billTo: 'Bill to', taxId: 'Tax ID / NIF:', project: 'Project', stage: 'Stage:', stageEg: '[50% on brief / 50% on launch / Care, month of ...]',
  desc: 'Description', qty: 'Qty', unit: 'Unit price', amount: 'Amount',
  line1: '[Multi-page bilingual website, up to eight pages — 50% deposit on brief]',
  line2: '[Take payments online — setup]',
  line3: '[Care plan — month of ...]',
  subtotal: 'Subtotal', vatLabel: 'VAT', total: 'Total due',
  vatNote: 'VAT: Plantworks Studio Ltd is not VAT registered. For business customers in Spain and the EU, this supply of services is subject to the reverse charge; the customer accounts for VAT in their own country (Article 196, Council Directive 2006/112/EC). Delete this note for UK and private customers.',
  payBank: 'Pay by bank transfer', bank: [['Account name:', 'Plantworks Studio Ltd'], ['IBAN (EUR):', '[GB00 XXXX 0000 0000 0000 00]'], ['BIC:', '[XXXXGB00]'], ['Sort code / account (GBP):', '[00-00-00 / 00000000]'], ['Reference:', '[invoice number]']],
  payCard: 'Pay by card', cardNote: 'Card, Apple Pay or Google Pay. Care plans are billed monthly by card.',
  terms: 'Terms', termsText: 'Payment within 14 days of the invoice date. Half of the build price is due on brief and half on launch. Care is billed monthly in advance and can be cancelled any month. Files and domain remain the client’s.',
  footer: 'Plantworks Studio Ltd · Registered in England and Wales · Thank you for your business',
};
const ES = {
  tagline: 'STUDIO · COSTA DEL SOL & REINO UNIDO', coNo: 'Nº de sociedad:', regOffice: 'Domicilio social:',
  title: 'Factura', invNo: 'Nº de factura', date: 'Fecha de emisión', due: 'Vencimiento', currency: 'Moneda', cur: 'EUR', m: ['1.500,00 \u20ac', '150,00 \u20ac', '0,00 \u20ac', '1.650,00 \u20ac'],
  billTo: 'Cliente', taxId: 'NIF / CIF:', project: 'Proyecto', stage: 'Fase:', stageEg: '[50% al inicio / 50% a la publicación / Mantenimiento, mes de ...]',
  desc: 'Concepto', qty: 'Cant.', unit: 'Precio unitario', amount: 'Importe',
  line1: '[Web bilingüe de varias páginas, hasta ocho páginas — 50% al inicio]',
  line2: '[Cobros online — instalación]',
  line3: '[Plan de mantenimiento — mes de ...]',
  subtotal: 'Base imponible', vatLabel: 'IVA', total: 'Total a pagar',
  vatNote: 'IVA: operación no sujeta en el Reino Unido. Inversión del sujeto pasivo: el destinatario, empresario o profesional establecido en España, es el sujeto pasivo del IVA (art. 84.Uno.2º Ley 37/1992; art. 196 Directiva 2006/112/CE). Borrar esta nota para clientes particulares.',
  payBank: 'Pago por transferencia', bank: [['Titular:', 'Plantworks Studio Ltd'], ['IBAN (EUR):', '[GB00 XXXX 0000 0000 0000 00]'], ['BIC:', '[XXXXGB00]'], ['Concepto:', '[número de factura]']],
  payCard: 'Pago con tarjeta', cardNote: 'Tarjeta, Apple Pay o Google Pay. El mantenimiento se cobra cada mes con tarjeta.',
  terms: 'Condiciones', termsText: 'Pago a 14 días desde la fecha de emisión. La mitad del precio de la web se abona al inicio y la otra mitad a la publicación. El mantenimiento se factura por adelantado cada mes y se puede cancelar en cualquier momento. Los archivos y el dominio son del cliente.',
  footer: 'Plantworks Studio Ltd · Sociedad registrada en Inglaterra y Gales · Gracias por su confianza',
};
// Spanish number format uses "1.650,00 €" — patch the ES amounts

function proposal() {
  const sec = (title) => new Paragraph({ children: [t(title, { font: 'Georgia', size: 28, bold: true, color: NAVY })], spacing: { before: 260, after: 80 } });
  const hdr = (x, w) => cell(P(t(x, { size: 18, bold: true, color: 'FFFFFF' }), { after: 0 }), w, { shade: NAVY });
  const r2 = (a, b, shade) => new TableRow({ children: [cell(P(a, { after: 0 }), 3000, { shade, borders: { bottom: hair } }), cell(P(b, { after: 0 }), 6638, { shade, borders: { bottom: hair } })] });
  const r3 = (a, b, c) => new TableRow({ children: [cell(P(a, { after: 0 }), 5638, { borders: { bottom: hair } }), cell(P(b, { align: AlignmentType.RIGHT, after: 0 }), 2000, { borders: { bottom: hair } }), cell(P(c, { align: AlignmentType.RIGHT, after: 0 }), 2000, { borders: { bottom: hair } })] });
  return new Document({
    numbering: bullets, styles: { default: { document: { run: { font: 'Calibri', size: 21 } } } },
    sections: [{ properties: { page: { margin: { top: 1134, right: 1134, bottom: 1134, left: 1134 } } }, children: [
      header(EN), P([], { after: 120 }), rule(),
      P(t('PROPOSAL', { size: 16, bold: true, color: SOL }), { after: 40 }),
      display('A new website for', 40),
      new Paragraph({ children: [t('[Client business name]', { font: 'Georgia', size: 40, bold: true, color: SOL })], spacing: { after: 60 } }),
      P([t('Prepared for ', { color: SOFT }), ph('[Contact name]'), t('  ·  ', { color: SOFT }), ph('[dd Month yyyy]'), t('  ·  Valid for 30 days', { color: SOFT })], { after: 200 }),

      sec('What we heard'),
      P(t('From our conversation on ', {}), { after: 40 }),
      bullet(ph('[The business in one line: what it does, who for, where.]')),
      bullet(ph('[The problem with the current site or the reason for a new one.]')),
      bullet(ph('[What the site must do: bookings, enquiries, menus, listings, be found in Spanish and English.]')),

      sec('What we’ll build'),
      P(t('A fast, hand-built site designed around your brand, not a template. Pages in both English and Spanish, each pair linked so Google shows the right language to the right person.'), { after: 120 }),
      table([
        new TableRow({ children: [hdr('Page', 3000), hdr('What it does', 6638)] }),
        r2(t('Home'), ph('[The pitch, opening hours, one clear action: book / call / enquire]'), SAND),
        r2(t('[Menu / Services / Listings]'), ph('[Laid out properly, easy to update, with prices]')),
        r2(t('[About / The story]'), ph('[Why this business is different, in its own voice]'), SAND),
        r2(t('Contact'), ph('[Form that reaches your inbox, WhatsApp, map, directions]')),
        r2(t('[Further pages]'), ph('[Up to eight in total]'), SAND),
      ], [3000, 6638]),

      sec('Included in every build'),
      bullet(t('Design around your brand, built by hand, tested like equipment before hand-over')),
      bullet(t('English and Spanish with correct hreflang, structured data and sitemap, so both versions rank')),
      bullet(t('Mobile-first, loads in under a second, hosted on a global network at near-zero cost')),
      bullet(t('On-page SEO and Google Business Profile setup')),
      bullet(t('Domain and hosting connected, HTTPS on, two rounds of revisions, native-speaker proofread of Spanish copy')),
      bullet(t('You own everything: files, domain, accounts. No monthly platform fee')),

      sec('Timeline'),
      table([
        new TableRow({ children: [hdr('When', 3000), hdr('What happens', 6638)] }),
        r2(t('Day 1'), t('Brief agreed, deposit received, we start'), SAND),
        r2(t('Week 1'), t('First working version on a private link, on your real content')),
        r2(t('Week 2'), t('Two rounds of changes. Spanish copy to a native speaker for proofing'), SAND),
        r2(t('Week 3'), t('Domain connected, HTTPS on, Google told it exists. Live')),
      ], [3000, 6638]),

      sec('Price'),
      table([
        new TableRow({ children: [hdr('Item', 5638), hdr('List price', 2000), hdr('This proposal', 2000)] }),
        r3(t('Multi-page bilingual website, up to eight pages'), t('€1,500'), ph('[€1,200]')),
        r3(ph('[Take payments online — optional]'), t('€150'), ph('[€150]')),
        r3(t('Care plan — hosting, updates, monthly check. Optional, cancel any month'), t('€40 / month'), t('€40 / month')),
        r3(t('Care Plus — Care plus your Google listing managed. Optional'), t('€75 / month'), t('€75 / month')),
      ], [5638, 2000, 2000]),
      P([t('Launch offer: ', { bold: true }), ph('[This is one of the first five multi-page sites at €1,200 instead of €1,500, in return for a Google review at launch and permission to show the site in our portfolio.]')], { before: 120, after: 40 }),
      P(t('Prices exclude VAT or IVA. Half on brief, half on launch. Photography, copywriting and any paid third-party service at cost.', { size: 18, color: SOFT })),

      sec('What we need from you'),
      bullet(t('Logo and any brand colours, or the sign and we’ll match it')),
      bullet(t('Text you already have: menus, service lists, prices, opening hours, the story. Rough is fine, photos of notes are fine')),
      bullet(t('Photos, if you have them. If not, see below')),
      bullet(t('Access to the domain if you already own one, or we register one for you')),
      bullet(t('One person who can say yes')),

      sec('Next step'),
      P([t('Reply to this email or WhatsApp with “yes” and we’ll send the deposit invoice and a date for the brief. Questions welcome. ', {}), t('info@plantworksstudio.com · +44 7464 435081', { bold: true })]),
      P([], { after: 200 }),
      P(t('Plantworks Studio Ltd · plantworksstudio.com', { size: 16, color: SOFT }), { align: AlignmentType.CENTER }),
    ].filter(Boolean) }],
  });
}

(async () => {
  fs.mkdirSync(OUT, { recursive: true });
  const docs = [['Plantworks-Invoice-EN.docx', invoice(EN)], ['Plantworks-Factura-ES.docx', invoice(ES)], ['Plantworks-Proposal-EN.docx', proposal()]];
  for (const [name, doc] of docs) {
    fs.writeFileSync(path.join(OUT, name), await Packer.toBuffer(doc));
    console.log('wrote', name);
  }
})();
