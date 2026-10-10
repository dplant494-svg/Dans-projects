/* TSC Help Centre — the assistance-request register (dashboard session, Rev 1, 29 Sep 2026).
   Draws window.HELP_DATA, written by Update-Dashboard.ps1 v2.71 every ten minutes from the
   seadrill-help_* posts (WCGRRT / SSORT assistance requests), the seadrill-help-ack_* records
   this page posts, and the delivery receipts the TSC Help Notifications flow writes.
   The email is the mechanism; this page is the record. Nothing here is recomputed from the
   payload: every state is the scanner's, and the one live number (hours since the event) is
   labelled as computed. Usage: HELP_CENTRE.render(el, { canAct: true }) */
(function () {
  var STATE_CLASS = { open: 'st-open', acknowledged: 'st-ack', closed: 'st-closed' };
  var STATE_HELP = {
    open: 'Posted by the rig; nobody from Technical Services has acknowledged it yet.',
    acknowledged: 'Technical Services have acknowledged it and are working it; updates are posted below.',
    closed: 'Closed by Technical Services with a closing note. The trail stays here.'
  };
  var CSS = '.hc{font:13px/1.45 "Segoe UI",Arial,Helvetica,sans-serif;color:#0a1530}' +
    '.hc .kpis{display:grid;grid-template-columns:repeat(auto-fit,minmax(170px,1fr));gap:10px;margin:0 0 14px}' +
    '.hc .kpi{border:1px solid #d0d8e8;border-top:3px solid #002C77;border-radius:4px;background:#fff;padding:10px 12px}' +
    '.hc .kpi .l{font-size:10px;font-weight:700;letter-spacing:.1em;text-transform:uppercase;color:#5a6880}' +
    '.hc .kpi .v{font-size:24px;font-weight:700;color:#002C77;line-height:1.2}.hc .kpi.att .v{color:#c0392b}.hc .kpi .s{font-size:11px;color:#5a6880}' +
    '.hc .req{background:#fff;border:1px solid #d0d8e8;border-radius:8px;padding:12px 14px;margin:0 0 12px}.hc .req.down{border-left:5px solid #c0392b}' +
    '.hc .head{display:flex;gap:10px;align-items:center;flex-wrap:wrap}.hc .head h3{margin:0;font-size:15px;color:#002C77}' +
    '.hc .chip{display:inline-block;font-size:10.5px;font-weight:700;padding:2px 8px;border-radius:9px;border:1px solid transparent;white-space:nowrap}' +
    '.hc .st-open{background:#fff1e6;color:#b23f00;border-color:#f4b48a}.hc .st-ack{background:#e6f2fa;color:#005f8c;border-color:#9ccbe6}.hc .st-closed{background:#e6f4ea;color:#1b5e20;border-color:#a5d6a7}' +
    '.hc .st-down{background:#c0392b;color:#fff}.hc .st-nondt{background:#eef0f4;color:#3d4a63;border-color:#d0d8e8}' +
    '.hc .rc-sent{background:#e6f4ea;color:#1b5e20;border-color:#a5d6a7}.hc .rc-failed{background:#c0392b;color:#fff}.hc .rc-none{background:#fff4e0;color:#7a4a00;border-color:#f4c98a}.hc .rc-wait{background:#eef0f4;color:#3d4a63;border-color:#d0d8e8}' +
    '.hc .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:8px 16px;margin:10px 0}.hc .f .l{font-size:10px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;color:#5a6880}.hc .f .v{font-size:13px}' +
    '.hc .txt{white-space:pre-wrap;background:#fafbfd;border:1px solid #e4e9f2;border-radius:6px;padding:8px 10px;margin:6px 0}' +
    '.hc h4{margin:10px 0 4px;font-size:11px;text-transform:uppercase;letter-spacing:.08em;color:#002C77}.hc ul{margin:0;padding-left:18px;font-size:12px}' +
    '.hc .photos{display:flex;flex-wrap:wrap;gap:8px;margin:4px 0}.hc .photos img{width:150px;height:112px;object-fit:cover;border-radius:4px;border:1px solid #d0d8e8;cursor:zoom-in}' +
    '.hc form.act{margin:8px 0 0;padding:8px 10px;border:1px solid #d0d8e8;border-radius:6px;background:#fff;font-size:12px;display:grid;grid-template-columns:1fr 1fr;gap:6px 10px}.hc form.act label{font-size:11px;color:#5a6880;font-weight:700}' +
    '.hc form.act input,.hc form.act select,.hc form.act textarea{font:inherit;width:100%;padding:5px 7px;border:1px solid #d0d8e8;border-radius:4px}.hc form.act .full{grid-column:1/-1}' +
    '.hc form.act button{grid-column:1/-1;justify-self:start;background:#002C77;color:#fff;border:0;border-radius:5px;padding:7px 14px;font-weight:700;cursor:pointer}.hc form.act button:disabled{opacity:.5;cursor:default}' +
    '.hc .msg{grid-column:1/-1;font-size:12px}.hc .msg.ok{color:#1b5e20}.hc .msg.err{color:#c0392b}' +
    '.hc .empty{color:#5a6880;text-align:center;padding:24px 0}.hc .legend{font-size:11.5px;color:#5a6880;margin:10px 0 0;line-height:1.9}.hc .sub{font-size:11px;color:#5a6880}' +
    '.hc .lightbox{position:fixed;inset:0;background:rgba(0,0,0,.85);display:flex;align-items:center;justify-content:center;z-index:99999;cursor:zoom-out}.hc .lightbox img{max-width:96vw;max-height:96vh}';

  function mk(tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text != null) e.textContent = text; return e; }
  function blobUrl(base64, mime) { var bin = atob(base64); var arr = new Uint8Array(bin.length); for (var i = 0; i < bin.length; i++) arr[i] = bin.charCodeAt(i); return URL.createObjectURL(new Blob([arr], { type: mime || 'application/octet-stream' })); }
  function sizeTxt(bytes) { bytes = Number(bytes || 0); return bytes ? (bytes >= 1048576 ? (bytes / 1048576).toFixed(1) + ' MB' : Math.max(1, Math.round(bytes / 1024)) + ' KB') : ''; }
  function ensureCss() { if (document.getElementById('hc-css')) return; var st = mk('style'); st.id = 'hc-css'; st.textContent = CSS; document.head.appendChild(st); }
  function lightbox(src) { var lb = mk('div', 'lightbox'); var im = mk('img'); im.src = src; lb.appendChild(im); lb.addEventListener('click', function () { lb.remove(); }); (document.querySelector('.hc') || document.body).appendChild(lb); }
  function when(s) { return s ? String(s).replace('T', ' ').slice(0, 16) : ''; }
  function stamp() { var d = new Date(); function p(n) { return String(n).padStart(2, '0'); } return d.getFullYear() + p(d.getMonth() + 1) + p(d.getDate()) + '-' + p(d.getHours()) + p(d.getMinutes()) + p(d.getSeconds()); }
  function today() { var d = new Date(); function p(n) { return String(n).padStart(2, '0'); } return d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate()); }

  function receiptChip(row) {
    var r = row.receipt || null;
    if (r && r.ok) { var c = mk('span', 'chip rc-sent', 'Sent to ' + (r.sentCount || 0) + (r.sentAt ? ' at ' + when(r.sentAt) : '')); c.title = (r.sentTo || []).join('; '); return c; }
    if (r && !r.ok) { var f = mk('span', 'chip rc-failed', 'NOT SENT' + (r.error ? ': ' + r.error : '')); return f; }
    if (row.receiptState === 'none') return mk('span', 'chip rc-none', 'No delivery receipt yet');
    return mk('span', 'chip rc-wait', 'Delivery receipt pending');
  }

  function render(el, opts) {
    ensureCss(); opts = opts || {};
    var data = window.HELP_DATA || null;
    var root = mk('div', 'hc'); el.innerHTML = ''; el.appendChild(root);
    if (!data) { root.appendChild(mk('div', 'empty', 'help-data.js is not beside this page yet: the scanner has not run since the Help Centre was installed.')); return; }
    var rows = data.status || [];
    var full = {}; (data.requests || []).forEach(function (r) { full[r.requestId] = r; });
    var acksBy = {}; (data.acks || []).forEach(function (a) { (acksBy[a.requestId] = acksBy[a.requestId] || []).push(a); });
    var open = rows.filter(function (r) { return r.state === 'open'; }), ack = rows.filter(function (r) { return r.state === 'acknowledged'; }), closed = rows.filter(function (r) { return r.state === 'closed'; });
    var down = rows.filter(function (r) { return r.rigDown && r.state !== 'closed'; });
    var failed = rows.filter(function (r) { return r.state !== 'closed' && (r.receiptState === 'failed' || r.receiptState === 'none'); });
    var k = mk('div', 'kpis');
    function kpi(l, v, s, att) { var d = mk('div', 'kpi' + (att ? ' att' : '')); d.appendChild(mk('div', 'l', l)); d.appendChild(mk('div', 'v', String(v))); d.appendChild(mk('div', 's', s)); k.appendChild(d); }
    kpi('Rig down, open', down.length, 'requests with the rig down flag, not yet closed', down.length > 0);
    kpi('Open', open.length, 'posted, not yet acknowledged by Technical Services', open.length > 0);
    kpi('Being worked', ack.length, 'acknowledged, updates below');
    kpi('Delivery problems', failed.length, 'no receipt, or the email did not send', failed.length > 0);
    kpi('Closed', closed.length, (data.generatedAt ? 'updated ' + when(data.generatedAt) : ''));
    root.appendChild(k);
    if (!rows.length) { root.appendChild(mk('div', 'empty', 'No assistance request has been posted yet.')); return; }
    var order = { open: 0, acknowledged: 1, closed: 2 };
    rows.slice().sort(function (a, b) { return (order[a.state] - order[b.state]) || ((b.rigDown ? 1 : 0) - (a.rigDown ? 1 : 0)) || String(b.postedAt).localeCompare(String(a.postedAt)); })
      .forEach(function (r) { root.appendChild(card(r, full[r.requestId], acksBy[r.requestId] || [], opts)); });
    var lg = mk('div', 'legend');
    ['open', 'acknowledged', 'closed'].forEach(function (s) { lg.appendChild(mk('span', 'chip ' + STATE_CLASS[s], s)); lg.appendChild(document.createTextNode(' ' + STATE_HELP[s] + '  ')); });
    root.appendChild(lg);
  }

  function card(r, rec, acks, opts) {
    var box = mk('div', 'req' + (r.rigDown && r.state !== 'closed' ? ' down' : ''));
    var head = mk('div', 'head');
    head.appendChild(mk('h3', '', (r.rig || r.rigKey || 'Unknown rig') + ' · ' + (r.subject || '(no subject)')));
    head.appendChild(mk('span', 'chip ' + (r.rigDown ? 'st-down' : 'st-nondt'), r.rigDown ? 'RIG DOWN' : 'Equipment failure, non-DT'));
    var sc = mk('span', 'chip ' + STATE_CLASS[r.state], r.state); sc.title = STATE_HELP[r.state] || ''; head.appendChild(sc);
    head.appendChild(receiptChip(r));
    if (r.directiveChat && r.directiveChat.created) head.appendChild(mk('span', 'chip rc-sent', 'Six-hour Teams chat created'));
    box.appendChild(head);
    var g = mk('div', 'grid');
    function f(l, v) { if (v == null || v === '') return; var d = mk('div', 'f'); d.appendChild(mk('div', 'l', l)); d.appendChild(mk('div', 'v', String(v))); g.appendChild(d); }
    f('Posted', when(r.postedAt) + (r.by ? ' · ' + r.by : ''));
    f('Event occurred', when(r.occurredAt));
    f('Hours down (as posted)', r.hoursDown != null && r.hoursDown !== '' ? r.hoursDown : '—');
    f('Hours since the event (computed now)', r.hoursSince != null ? r.hoursSince : '—');
    f('Synergi case', r.synergiCase || 'not yet raised');
    f('Kind', r.notifyKind || '');
    f('Tool', r.rev || '');
    box.appendChild(g);
    if (rec) {
      var keys = Object.keys(rec.fields || {});
      if (keys.length) { box.appendChild(mk('h4', '', 'The request as posted')); var gl = mk('div', 'grid'); keys.forEach(function (kk) { var d = mk('div', 'f'); d.appendChild(mk('div', 'l', kk)); d.appendChild(mk('div', 'v', String(rec.fields[kk]))); gl.appendChild(d); }); box.appendChild(gl); }
      if (rec.description) { box.appendChild(mk('h4', '', 'Description')); box.appendChild(mk('div', 'txt', rec.description)); }
      if ((rec.attachments || []).length) { box.appendChild(mk('h4', '', 'Attachments')); var ul = mk('ul'); rec.attachments.forEach(function (a) { if (!a || !a.data) return; var li = mk('li'); var l = mk('a', '', (a.name || 'attachment') + (sizeTxt(a.bytes) ? ' (' + sizeTxt(a.bytes) + ')' : '')); l.href = blobUrl(a.data, a.type); l.target = '_blank'; l.download = a.name || 'attachment'; li.appendChild(l); ul.appendChild(li); }); box.appendChild(ul); }
      if ((rec.photos || []).length) { box.appendChild(mk('h4', '', 'Photographs')); var ph = mk('div', 'photos'); rec.photos.forEach(function (p) { if (!p || !p.data) return; var im = mk('img'); im.src = p.data; im.title = p.caption || p.name || ''; im.addEventListener('click', function () { lightbox(p.data); }); ph.appendChild(im); }); box.appendChild(ph); }
    }
    box.appendChild(mk('h4', '', 'Trail'));
    var tl = mk('ul');
    tl.appendChild(mk('li', '', when(r.postedAt) + ' · request posted from the rig' + (r.by ? ' by ' + r.by : '')));
    if (r.receipt && r.receipt.ok) tl.appendChild(mk('li', '', when(r.receipt.sentAt) + ' · emailed to ' + (r.receipt.sentCount || 0) + (r.receipt.chatCreated ? ' · Teams chat created' : '')));
    if (r.receipt && !r.receipt.ok) tl.appendChild(mk('li', '', when(r.receipt.sentAt) + ' · NOT SENT: ' + (r.receipt.error || 'the flow could not send')));
    acks.slice().sort(function (a, b) { return String(a.saved).localeCompare(String(b.saved)); }).forEach(function (a) {
      var li = mk('li', '', (a.at || when(a.saved)) + ' · ' + (a.action === 'close' ? 'closed' : a.action === 'update' ? 'update' : 'acknowledged') + (a.by ? ' · ' + a.by : '') + (a.role ? ' (' + a.role + ')' : '') + (a.comment ? ' — ' + a.comment : ''));
      if ((a.attachments || []).length) { var dl = mk('ul'); a.attachments.forEach(function (x) { if (!x || !x.data) return; var d = mk('li'); var da = mk('a', '', x.name || 'document'); da.href = blobUrl(x.data, x.type); da.target = '_blank'; da.download = x.name || 'document'; d.appendChild(da); dl.appendChild(d); }); li.appendChild(dl); }
      tl.appendChild(li);
    });
    box.appendChild(tl);
    if (opts.canAct && r.state !== 'closed') box.appendChild(actForm(r));
    box.appendChild(mk('div', 'sub', 'Source file: ' + (r.file || '')));
    return box;
  }

  // Technical Services acknowledge, update or close: one small record per action, posted through the
  // same intake as everything else (gate-config.js postUrl), downloaded on any failure. Never edits the
  // rig's request file.
  var posted = {};
  function actForm(r) {
    var f = mk('form', 'act');
    var lab = function (t) { return mk('label', '', t); };
    f.appendChild(lab('Action')); f.appendChild(lab('Your name'));
    var sel = mk('select'); [['acknowledge', 'Acknowledge: Technical Services are on it'], ['update', 'Post an update to the trail'], ['close', 'Close the request']].forEach(function (o) { var op = mk('option', '', o[1]); op.value = o[0]; sel.appendChild(op); });
    if (r.state === 'acknowledged') sel.value = 'update';
    f.appendChild(sel);
    var name = mk('input'); name.required = true; name.placeholder = 'Name'; f.appendChild(name);
    var l2 = lab('Role'); l2.className += ' full'; f.appendChild(l2);
    var role = mk('input'); role.className = 'full'; role.value = 'Technical Services'; f.appendChild(role);
    var l3 = lab('Note (required: what was done, who was told, what happens next)'); l3.className += ' full'; f.appendChild(l3);
    var note = mk('textarea'); note.className = 'full'; note.rows = 2; note.required = true; f.appendChild(note);
    var btn = mk('button', '', 'Post'); btn.type = 'submit'; f.appendChild(btn);
    var msg = mk('div', 'msg'); f.appendChild(msg);
    f.addEventListener('submit', function (e) {
      e.preventDefault();
      if (!note.value.trim()) { msg.className = 'msg err'; msg.textContent = 'Add a note.'; return; }
      var record = { meta: { kind: 'help-ack', tool: 'TSC Help Centre', rev: 1, asset: r.rig || '', rigkey: r.rigKey || '', saved: new Date().toISOString() },
        requestId: r.requestId, action: sel.value, by: name.value.trim(), role: role.value.trim(), at: today(), comment: note.value.trim(), subject: r.subject || '', attachments: [] };
      var json = JSON.stringify(record);
      var fileName = 'seadrill-help-ack_' + String(r.requestId).replace(/[^A-Za-z0-9_-]/g, '') + '_' + stamp() + '.json';
      var url = window.PCGATE && window.PCGATE.postUrl;
      btn.disabled = true; msg.className = 'msg'; msg.textContent = 'Posting…';
      var done = function (ok, why) {
        // 10 Oct 2026 (Dan): after a post the form stays usable, so a second action (an update after the
        // acknowledgement, a close after the update) can be posted without reloading the page. The note is
        // cleared; the action and name stay. The page still shows the new state only after the next scan.
        if (ok) { posted[r.requestId] = true; btn.disabled = false; note.value = ''; if (sel.value === 'acknowledge') sel.value = 'update'; msg.className = 'msg ok'; msg.textContent = 'Posted as ' + fileName + '; the state updates within ten minutes. You can post another action now.'; }
        else { var a = document.createElement('a'); a.href = URL.createObjectURL(new Blob([json], { type: 'application/json' })); a.download = fileName; document.body.appendChild(a); a.click(); setTimeout(function () { a.remove(); }, 0); btn.disabled = false; msg.className = 'msg err'; msg.textContent = 'Not posted (' + why + '). The record was downloaded instead: send it to Dan Plant and it is filed by hand.'; }
      };
      if (!url) { done(false, 'no intake endpoint on this copy, gate-config.js'); return; }
      fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ FileName: fileName, ContentType: 'application/json', FileContent: btoa(unescape(encodeURIComponent(json))) }) })
        .then(function (res) { done(res.ok, res.ok ? '' : 'HTTP ' + res.status + ' ' + res.statusText); })
        .catch(function (err) { done(false, err.name + ': ' + err.message); });
    });
    return f;
  }

  window.HELP_CENTRE = { render: render, STATE_CLASS: STATE_CLASS, STATE_HELP: STATE_HELP };
})();
