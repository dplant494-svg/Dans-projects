/* Seadrill Bulletin Board — fleet register (dashboard session, Rev 1, 24 Sep 2026).
   Renders the fleet summary of every current AAB and each rig's state, with the
   acknowledgement history and the evidence photographs, from window.AAB_DATA
   (aab-data.js, written by the scanner every ten minutes). One implementation used by
   the open Bulletin Board page (bulletin-board.html) and by the gated create page (Eric's build,
   Rev 9: <div id="aab-register"></div> and <script src="aab-register.js"></script>
   after aab-data.js). Nothing here posts anything or recomputes a state: the words are
   the scanner's (INTEGRATION-CONTRACT.md, aabStatus[]).
   Usage: AAB_REGISTER.render(document.getElementById('aab-register'), { rigKey: '' })  */
(function () {
  'use strict';
  var STATE_CLASS = { 'outstanding': 'st-outstanding', 'partly acknowledged': 'st-partly', 'acknowledged': 'st-acknowledged', 'action open': 'st-action', 'closed': 'st-closed', 'overdue': 'st-overdue', 'withdrawn': 'st-withdrawn' };
  var STATE_HELP = {
    'outstanding': 'No acknowledgement from this rig yet.',
    'partly acknowledged': 'One crew’s Technical Section Leader has acknowledged; the other crew has not.',
    'acknowledged': 'Both crews have acknowledged. No action was requested, so this is the whole lifecycle.',
    'action open': 'Both crews have acknowledged; the requested action has not been closed with evidence.',
    'closed': 'The rig has closed the requested action with a comment and evidence photographs.',
    'overdue': 'Past the due date and still open: outstanding, partly acknowledged, or action open.',
    'withdrawn': 'The advisory was withdrawn in a later revision; nothing is owed.'
  };
  var CSS = '.aabreg{font:13px/1.45 "Segoe UI",Arial,Helvetica,sans-serif;color:#0a1530}' +
    '.aabreg .kpis{display:grid;grid-template-columns:repeat(auto-fit,minmax(170px,1fr));gap:10px;margin:0 0 14px}' +
    '.aabreg .kpi{border:1px solid #d0d8e8;border-top:3px solid #002C77;border-radius:4px;background:#fff;padding:10px 12px}' +
    '.aabreg .kpi .l{font-size:10px;font-weight:700;letter-spacing:.1em;text-transform:uppercase;color:#5a6880}' +
    '.aabreg .kpi .v{font-size:24px;font-weight:700;color:#002C77;line-height:1.2}.aabreg .kpi.att .v{color:#c0392b}' +
    '.aabreg .kpi .s{font-size:11px;color:#5a6880}' +
    '.aabreg table.reg{width:100%;border-collapse:collapse;background:#fff}' +
    '.aabreg table.reg th{text-align:left;font-size:10px;text-transform:uppercase;letter-spacing:.08em;color:#5a6880;padding:6px 8px;border-bottom:1px solid #d0d8e8;white-space:nowrap}' +
    '.aabreg table.reg td{padding:7px 8px;border-bottom:1px solid #e4e9f2;vertical-align:top}' +
    '.aabreg .num{font-weight:700;color:#002C77;white-space:nowrap}.aabreg .sub{font-size:11px;color:#5a6880}' +
    '.aabreg .chip{display:inline-block;font-size:10.5px;font-weight:700;padding:2px 8px;border-radius:9px;margin:0 4px 4px 0;border:1px solid transparent;white-space:nowrap;cursor:pointer}' +
    '.aabreg .st-outstanding{background:#eef0f4;color:#3d4a63;border-color:#d0d8e8}.aabreg .st-partly{background:#e6f2fa;color:#005f8c;border-color:#9ccbe6}' +
    '.aabreg .st-acknowledged{background:#002C77;color:#fff}.aabreg .st-action{background:#fff1e6;color:#b23f00;border-color:#f4b48a}' +
    '.aabreg .st-closed{background:#e6f4ea;color:#1b5e20;border-color:#a5d6a7}.aabreg .st-overdue{background:#c0392b;color:#fff}.aabreg .st-withdrawn{background:#f4f4f4;color:#777;text-decoration:line-through}' +
    '.aabreg .legend{font-size:11.5px;color:#5a6880;margin:10px 0 0;line-height:1.9}.aabreg .legend .chip{cursor:default}' +
    '.aabreg .detail{background:#fafbfd;border:1px solid #d0d8e8;border-radius:6px;padding:10px 12px;margin:6px 0 10px}' +
    '.aabreg .detail h4{margin:8px 0 4px;font-size:11px;text-transform:uppercase;letter-spacing:.08em;color:#002C77}' +
    '.aabreg .detail ul{margin:0;padding-left:18px;font-size:12px}.aabreg .detail .txt{white-space:pre-wrap;margin:0 0 6px}' +
    '.aabreg .photos{display:flex;flex-wrap:wrap;gap:8px;margin:4px 0 8px}.aabreg .photos figure{margin:0;width:150px}' +
    '.aabreg .photos img{width:150px;height:112px;object-fit:cover;border-radius:4px;border:1px solid #d0d8e8;cursor:zoom-in}.aabreg .photos figcaption{font-size:11px;color:#5a6880}' +
    '.aabreg .rigtab{width:100%;border-collapse:collapse;font-size:12px;background:#fff}.aabreg .rigtab th{text-align:left;font-size:10px;text-transform:uppercase;color:#5a6880;padding:4px 6px;border-bottom:1px solid #d0d8e8}.aabreg .rigtab td{padding:5px 6px;border-bottom:1px solid #e4e9f2;vertical-align:top}' +
    '.aabreg .empty{color:#5a6880;text-align:center;padding:24px 0}.aabreg button.lnk{background:none;border:0;color:#0082C0;cursor:pointer;font:inherit;padding:0;text-decoration:underline}' +
    '.aabreg .lightbox{position:fixed;inset:0;background:rgba(0,0,0,.85);display:flex;align-items:center;justify-content:center;z-index:99999;cursor:zoom-out}.aabreg .lightbox img{max-width:96vw;max-height:96vh}';

  function mk(tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text != null) e.textContent = text; return e; }
  function blobUrl(base64, mime) { var bin = atob(base64); var arr = new Uint8Array(bin.length); for (var i = 0; i < bin.length; i++) arr[i] = bin.charCodeAt(i); return URL.createObjectURL(new Blob([arr], { type: mime || 'application/octet-stream' })); }
  function sizeTxt(bytes) { bytes = Number(bytes || 0); return bytes ? (bytes >= 1048576 ? (bytes / 1048576).toFixed(1) + ' MB' : Math.max(1, Math.round(bytes / 1024)) + ' KB') : ''; }
  function ensureCss(root) { if (document.getElementById('aabreg-css')) return; var st = mk('style'); st.id = 'aabreg-css'; st.textContent = CSS; document.head.appendChild(st); }
  function lightbox(src) { var lb = mk('div', 'lightbox'); var im = mk('img'); im.src = src; lb.appendChild(im); lb.addEventListener('click', function () { lb.remove(); }); document.querySelector('.aabreg').appendChild(lb); }
  // Who is still to act, from the state and the crews recorded (Dan, 26 Sep: click the
  // state and see who is left). Roles only: the record carries the crews that have
  // acknowledged; names come from the rig's own list, not from here.
  function waitingOn(row, rec) {
    var st = row.state, crews = row.ackCrews || [];
    if (st === 'closed') return 'Nothing owed: closed' + (row.closedBy ? ' by ' + row.closedBy : '') + (row.closedAt ? ' on ' + row.closedAt : '') + '.';
    if (st === 'withdrawn') return 'Nothing owed: the advisory was withdrawn.';
    if (st === 'acknowledged') return 'Nothing owed: acknowledged by both crews' + (row.acknowledgedAt ? ', last on ' + row.acknowledgedAt : '') + '.';
    if (st === 'action open') return 'Waiting on the rig to close the requested action with a comment and evidence photographs (Subsea Supervisor or either crew\u2019s Technical Section Leader on the rig page).' + (row.overdue ? ' Overdue by ' + row.daysOverdue + ' days.' : '');
    var left = ['A', 'B'].filter(function (c) { return crews.indexOf(c) === -1; });
    var who = left.map(function (c) { return 'Technical Section Leader, crew ' + c; }).join(' and ');
    var s = 'Waiting on: ' + (who || 'the rig') + ' to acknowledge' + (rec && rec.actionRequested ? ', then the rig to close the action with evidence' : '') + '.';
    if (crews.length) s += ' Acknowledged so far by crew ' + crews.join(' and ') + (row.acknowledgedBy ? ' (' + row.acknowledgedBy + ')' : '') + '.';
    if (row.overdue) s += ' Overdue by ' + row.daysOverdue + ' days (due ' + row.dueDate + ').';
    return s;
  }
  function chip(row, onClick) {
    var st = row.status || row.state || 'outstanding';
    var c = mk('span', 'chip ' + (STATE_CLASS[st] || 'st-outstanding'), (row.rig || row.rigKey || '') + (st === 'overdue' ? ' · ' + (row.daysOverdue || 0) + 'd' : ''));
    c.title = (row.rig || '') + ': ' + st + (st === 'overdue' ? ' (' + row.state + ', ' + (row.daysOverdue || 0) + ' days past ' + (row.dueDate || '') + ')' : '') + ((row.ackCrews || []).length ? ' · crew ' + row.ackCrews.join(' and ') : '') + '\n' + (STATE_HELP[st] || '');
    if (onClick) c.addEventListener('click', onClick);
    return c;
  }
  function photos(list) {
    var wrap = mk('div', 'photos'); var n = 0;
    (list || []).forEach(function (p) { if (!p || !p.data) return; var f = mk('figure'); var im = mk('img'); im.src = p.data; im.alt = p.caption || p.name || 'photo'; im.loading = 'lazy'; im.addEventListener('click', function () { lightbox(p.data); }); f.appendChild(im); if (p.caption || p.name) f.appendChild(mk('figcaption', '', p.caption || p.name)); wrap.appendChild(f); n++; });
    return n ? wrap : null;
  }

  function render(root, opts) {
    opts = opts || {};
    ensureCss(root);
    root.innerHTML = '';
    root.classList.add('aabreg');
    var data = window.AAB_DATA || null;
    if (!data) { root.appendChild(mk('div', 'empty', 'The advisory list (aab-data.js) is not beside this page yet.')); return; }
    var status = data.status || [];
    var records = (data.records || []).filter(function (r) { return r.current; });
    if (opts.rigKey) { status = status.filter(function (r) { return r.rigKey === opts.rigKey; }); records = records.filter(function (r) { return (r.rigsApplicable || []).indexOf(opts.rigKey) !== -1; }); }
    if (!records.length) { root.appendChild(mk('div', 'empty', opts.rigKey ? 'No advisory applies to this rig.' : 'No advisories posted yet. Advisories created on the Bulletin Board appear here within ten minutes.')); return; }

    var counts = {}; status.forEach(function (r) { counts[r.status] = (counts[r.status] || 0) + 1; });
    var open = status.filter(function (r) { return r.state !== 'closed' && r.state !== 'acknowledged' && r.state !== 'withdrawn'; }).length;
    var done = status.filter(function (r) { return r.state === 'closed' || r.state === 'acknowledged'; }).length;
    var scored = status.filter(function (r) { return r.state !== 'withdrawn'; }).length;
    var kpis = mk('div', 'kpis');
    function kpi(l, v, s, att) { var k = mk('div', 'kpi' + (att ? ' att' : '')); k.appendChild(mk('div', 'l', l)); k.appendChild(mk('div', 'v', String(v))); if (s) k.appendChild(mk('div', 's', s)); kpis.appendChild(k); }
    kpi('Overdue', counts.overdue || 0, 'rig states past the due date', (counts.overdue || 0) > 0);
    kpi('Open rig states', open, (counts.outstanding || 0) + ' outstanding · ' + (counts['partly acknowledged'] || 0) + ' partly · ' + (counts['action open'] || 0) + ' action open');
    kpi('Acknowledged or closed', scored ? Math.round(done / scored * 100) + '%' : '—', done + ' of ' + scored + ' rig states');
    kpi('Current advisories', records.length, (data.records || []).length + ' revision(s) on file' + (data.generatedAt ? ' · updated ' + String(data.generatedAt).replace('T', ' ').slice(0, 16) : ''));
    root.appendChild(kpis);

    var byNum = {}; status.forEach(function (r) { (byNum[r.aabNumber] = byNum[r.aabNumber] || []).push(r); });
    records.sort(function (a, b) {
      var ao = (byNum[a.aabNumber] || []).some(function (r) { return r.overdue; }) ? 0 : 1, bo = (byNum[b.aabNumber] || []).some(function (r) { return r.overdue; }) ? 0 : 1;
      if (ao !== bo) return ao - bo;
      return String(b.issueDate || '').localeCompare(String(a.issueDate || ''));
    });
    var table = mk('table', 'reg'); var thead = mk('thead'); var htr = mk('tr');
    ['AAB', 'Title', 'SFI', 'Issued', 'Due', 'Rigs and their state'].forEach(function (h) { htr.appendChild(mk('th', '', h)); });
    thead.appendChild(htr); table.appendChild(thead);
    var tbody = mk('tbody');
    records.forEach(function (rec) {
      var tr = mk('tr');
      var td1 = mk('td'); var b = mk('button', 'lnk', rec.aabNumber); b.type = 'button'; b.className = 'lnk num'; td1.appendChild(b);
      td1.appendChild(mk('div', 'sub', 'rev ' + rec.revision + (rec.status === 'withdrawn' ? ' · withdrawn' : '') + (rec.actionRequested ? ' · action requested' : ' · information')));
      tr.appendChild(td1);
      var td2 = mk('td', '', rec.title || '(untitled)'); if (rec.category) td2.appendChild(mk('div', 'sub', rec.category)); tr.appendChild(td2);
      tr.appendChild(mk('td', '', (rec.sfi || []).map(function (s) { return s.code || s.group; }).filter(Boolean).join(', ') || '—'));
      tr.appendChild(mk('td', '', rec.issueDate || '—'));
      tr.appendChild(mk('td', '', rec.dueDate || '—'));
      var td6 = mk('td'); (byNum[rec.aabNumber] || []).forEach(function (r) { var c = chip(r, function () { toggle(); }); c.title += '\n' + waitingOn(r, rec); td6.appendChild(c); }); tr.appendChild(td6);
      tbody.appendChild(tr);
      var dtr = mk('tr'); dtr.hidden = true; var dtd = mk('td'); dtd.colSpan = 6; dtr.appendChild(dtd); tbody.appendChild(dtr);
      function toggle() { if (dtr.hidden) { dtd.innerHTML = ''; dtd.appendChild(detail(rec, byNum[rec.aabNumber] || [], data)); dtr.hidden = false; } else { dtr.hidden = true; } }
      b.addEventListener('click', toggle);
    });
    table.appendChild(tbody); root.appendChild(table);
    var legend = mk('div', 'legend');
    ['overdue', 'outstanding', 'partly acknowledged', 'action open', 'acknowledged', 'closed', 'withdrawn'].forEach(function (st) { legend.appendChild(mk('span', 'chip ' + STATE_CLASS[st], st)); legend.appendChild(document.createTextNode(' ' + STATE_HELP[st] + '  ')); });
    root.appendChild(legend);
  }

  function detail(rec, rows, data) {
    var d = mk('div', 'detail');
    var acks = (data.acks || []).filter(function (a) { return a.aabNumber === rec.aabNumber; }).sort(function (a, b) { return String(a.saved).localeCompare(String(b.saved)); });
    var revs = (data.records || []).filter(function (r) { return r.aabNumber === rec.aabNumber; }).sort(function (a, b) { return b.revision - a.revision; });
    d.appendChild(mk('div', 'sub', 'Priority ' + (rec.priority || 3) + (rec.corporateMandatory ? '' : ' · not required by Corporate, for information only') + ' · acknowledged by ' + (rec.expectedAcknowledgerRole || 'Technical Section Leader (each crew)') + (rec.requiresReacknowledgement ? ' · re-acknowledgement required on this revision' : '') + ' · originator ' + (rec.originatorName || '—') + (rec.edocsRef ? ' · eDocs ' + rec.edocsRef : '') + (rec.maximoParent ? ' · Maximo ' + rec.maximoParent : '') + ' · posted ' + String(rec.postedAt || '').replace('T', ' ').slice(0, 16)));
    [['What happened', rec.whatHappened], ['Why it matters', rec.whyItMatters], ['Required action', rec.requiredAction]].forEach(function (p) { d.appendChild(mk('h4', '', p[0])); d.appendChild(mk('div', 'txt', p[1] || '—')); });
    if ((rec.referenceDocuments || []).length) { d.appendChild(mk('h4', '', 'Reference documents')); var ul = mk('ul'); rec.referenceDocuments.forEach(function (x) { ul.appendChild(mk('li', '', x)); }); d.appendChild(ul); }
    var files = mk('ul');
    if (rec.pdf) { var l0 = mk('li'); var a0 = mk('a', '', (rec.pdfName || 'AAB ' + rec.aabNumber + '.pdf') + ' — the advisory as issued'); a0.href = blobUrl(rec.pdf, 'application/pdf'); a0.target = '_blank'; l0.appendChild(a0); files.appendChild(l0); }
    (rec.attachments || []).forEach(function (a) { if (!a || !a.data) return; var li = mk('li'); var l = mk('a', '', (a.name || 'attachment') + (a.primary ? ' — the bulletin' : '') + (sizeTxt(a.bytes) ? ' (' + sizeTxt(a.bytes) + ')' : '')); l.href = blobUrl(a.data, a.type); l.target = '_blank'; l.download = a.name || 'attachment'; li.appendChild(l); files.appendChild(li); });
    if (files.childNodes.length) { d.appendChild(mk('h4', '', 'Documents')); d.appendChild(files); }
    var ph = photos(rec.photos); if (ph) { d.appendChild(mk('h4', '', 'Photographs')); d.appendChild(ph); }

    d.appendChild(mk('h4', '', 'Rigs (' + rows.length + ')'));
    var rt = mk('table', 'rigtab'); var th = mk('thead'); var tr0 = mk('tr');
    ['Rig', 'State', 'Crews', 'Last acknowledgement', 'Closed', 'History and evidence'].forEach(function (h) { tr0.appendChild(mk('th', '', h)); }); th.appendChild(tr0); rt.appendChild(th);
    var tb = mk('tbody');
    rows.forEach(function (r) {
      var tr = mk('tr'); tr.appendChild(mk('td', '', r.rig));
      var tds = mk('td'); var stc = chip({ rig: r.status, status: r.status, state: r.state, daysOverdue: r.daysOverdue, dueDate: r.dueDate }); stc.title += '\nClick for who is left to act.';
      var wl = mk('div', 'sub'); wl.hidden = true; wl.textContent = waitingOn(r, rec);
      stc.addEventListener('click', function () { wl.hidden = !wl.hidden; });
      tds.appendChild(stc); tds.appendChild(wl); tr.appendChild(tds);
      tr.appendChild(mk('td', '', (r.ackCrews || []).length ? r.ackCrews.join(' and ') : '—'));
      tr.appendChild(mk('td', '', r.acknowledgedAt ? r.acknowledgedAt + (r.acknowledgedBy ? ' · ' + r.acknowledgedBy : '') : '—'));
      tr.appendChild(mk('td', '', r.closedAt ? r.closedAt + (r.closedBy ? ' · ' + r.closedBy : '') : '—'));
      var tdh = mk('td'); var hist = acks.filter(function (a) { return a.rigKey === r.rigKey; });
      if (!hist.length) tdh.textContent = '—';
      else { var hul = mk('ul'); hist.forEach(function (a) { var li = mk('li', '', (a.at || String(a.saved).slice(0, 10)) + ' · rev ' + a.revision + ' · ' + (a.action === 'close' ? 'closed' : 'acknowledged') + (a.crew ? ' · crew ' + a.crew : '') + (a.by ? ' · ' + a.by : '') + (a.role ? ' (' + a.role + ')' : '') + (a.comment ? ' — ' + a.comment : '')); var ap = photos(a.photos); if (ap) li.appendChild(ap); hul.appendChild(li); }); tdh.appendChild(hul); }
      tr.appendChild(tdh); tb.appendChild(tr);
    });
    rt.appendChild(tb); d.appendChild(rt);
    if (revs.length > 1) { d.appendChild(mk('h4', '', 'Revision history')); var rl = mk('ul'); revs.forEach(function (v) { rl.appendChild(mk('li', '', 'rev ' + v.revision + ' · posted ' + String(v.postedAt || '').replace('T', ' ').slice(0, 16) + (v.requiresReacknowledgement ? ' · re-acknowledgement required' : '') + (v.status === 'withdrawn' ? ' · withdrawn' : '') + (v.current ? ' · current' : ''))); }); d.appendChild(rl); }
    d.appendChild(mk('div', 'sub', 'Source file: ' + rec.file));
    return d;
  }

  window.AAB_REGISTER = { render: render, waitingOn: waitingOn, STATE_CLASS: STATE_CLASS, STATE_HELP: STATE_HELP };
})();
