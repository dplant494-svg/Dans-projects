/* TSC Help Centre — Plans tab (dashboard session, item 53, 13 Oct 2026).
   Draws window.PLAN_REVIEW_DATA, written by Update-Dashboard.ps1 v2.90 every ten minutes: every Argo Navis (DL-1)
   plan with its sections, progress, the reviewer roster by region (Dan's Reviewers table) and the review state the
   scanner computed. A reviewer presses Verified or Changes needed; that posts one small plan-review record through
   the intake (gate-config.js postUrl), never edits the plan. The scanner counts the reviews; when every required
   reviewer has verified, the Plan Notices flow posts "verified by all, freeze the scope" to the plan's chat and the
   planner freezes it in Argo Navis. Usage: PLAN_REVIEW.render(el, { canAct: true }) */
(function () {
  var STATE = {
    awaiting: ['st-open', 'Awaiting review', 'Posted for review; not every required reviewer has verified yet.'],
    changes: ['st-down', 'Changes requested', 'A reviewer asked for changes; the planner updates the plan in Argo Navis and the reviews start again on the new scope version.'],
    verified: ['st-closed', 'Verified by all', 'Every required reviewer has verified this scope version; the planner freezes the scope in Argo Navis.'],
    frozen: ['st-ack', 'Scope frozen', 'Frozen in Argo Navis; ready for execution. Break-in work and edits go to the plan chat.'],
    closed: ['st-nondt', 'Closed out', 'Close-out posted; the AAR and the project folder follow.'],
    'no-reviewers': ['rc-none', 'No reviewers for this region', 'The Reviewers table has nobody for this rig\'s region yet, or the rig has no region on the BWM tracker.']
  };
  var CSS = '.pr .sec-btn{display:inline-block;margin:0 6px 6px 0;padding:4px 10px;border:1px solid #d0d8e8;border-radius:12px;background:#fff;font-size:11.5px;cursor:pointer}.pr .sec-btn.on{background:#002C77;color:#fff;border-color:#002C77}' +
    '.pr table{border-collapse:collapse;width:100%;font-size:12px;margin:4px 0 8px}.pr th{font-size:10px;text-transform:uppercase;letter-spacing:.06em;color:#5a6880;text-align:left;padding:4px 6px;border-bottom:1px solid #d0d8e8}.pr td{padding:4px 6px;border-bottom:1px solid #eef1f6;vertical-align:top}' +
    '.pr .rv{display:grid;grid-template-columns:auto 1fr auto;gap:4px 12px;align-items:center;font-size:12.5px;padding:4px 0;border-bottom:1px dashed #e4e9f2}.pr .rv .who b{color:#002C77}.pr .rv .who span{color:#5a6880;font-size:11px}.pr .rv .cm{color:#3d4a63;font-size:12px}' +
    '.pr .bar{height:8px;background:#e4eaf4;border-radius:4px;overflow:hidden;margin:4px 0}.pr .bar span{display:block;height:100%;background:#0a7}.pr .bar.t span{background:#0082C0}' +
    '.pr .verified-banner{background:#e6f4ea;border:1px solid #a5d6a7;color:#1b5e20;border-radius:6px;padding:8px 12px;margin:8px 0;font-weight:700}.pr .changes-banner{background:#fde8e6;border:1px solid #f1a9a3;color:#8b1a10;border-radius:6px;padding:8px 12px;margin:8px 0;font-weight:700}' +
    '.pr details{margin:6px 0}.pr summary{cursor:pointer;font-size:12px;color:#002C77;font-weight:700}.pr .req.test{opacity:.8;border-left:5px solid #b00}';
  function mk(tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text != null) e.textContent = text; return e; }
  function when(s) { return s ? String(s).replace('T', ' ').slice(0, 16) : ''; }
  function stamp() { var d = new Date(); function p(n) { return String(n).padStart(2, '0'); } return d.getFullYear() + p(d.getMonth() + 1) + p(d.getDate()) + '-' + p(d.getHours()) + p(d.getMinutes()) + p(d.getSeconds()); }
  function today() { var d = new Date(); function p(n) { return String(n).padStart(2, '0'); } return d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate()); }
  function ensureCss() { if (document.getElementById('pr-css')) return; var st = mk('style'); st.id = 'pr-css'; st.textContent = CSS; document.head.appendChild(st); }
  function chip(cls, text, title) { var c = mk('span', 'chip ' + cls, text); if (title) c.title = title; return c; }
  function stateChip(st) { var s = STATE[st] || STATE.awaiting; return chip(s[0], s[1], s[2]); }

  function render(el, opts) {
    ensureCss(); opts = opts || {};
    var data = window.PLAN_REVIEW_DATA || null;
    var root = mk('div', 'hc pr'); el.innerHTML = ''; el.appendChild(root);
    if (!data) { root.appendChild(mk('div', 'empty', 'plan-review-data.js is not beside this page yet: the scanner (v2.90+) has not run since the Plans tab was installed.')); return; }
    var plans = (data.plans || []).slice();
    var live = plans.filter(function (p) { return !p.isTest; });
    function count(st) { return live.filter(function (p) { return p.review && p.review.state === st; }).length; }
    var k = mk('div', 'kpis');
    function kpi(l, v, s, att) { var d = mk('div', 'kpi' + (att ? ' att' : '')); d.appendChild(mk('div', 'l', l)); d.appendChild(mk('div', 'v', String(v))); d.appendChild(mk('div', 's', s)); k.appendChild(d); }
    kpi('Awaiting review', count('awaiting') + count('no-reviewers'), 'posted, not every required reviewer has verified', count('awaiting') > 0);
    kpi('Changes requested', count('changes'), 'back with the planner', count('changes') > 0);
    kpi('Verified, to freeze', count('verified'), 'every required reviewer verified; planner freezes the scope', count('verified') > 0);
    kpi('Frozen, executing', count('frozen'), 'scope frozen in Argo Navis');
    kpi('Closed out', count('closed'), (data.generatedAt ? 'updated ' + when(data.generatedAt) : ''));
    root.appendChild(k);
    var ro = mk('div', 'note');
    ro.textContent = 'Reviewers by region (Dan\'s Reviewers table' + (data.reviewersAt ? ', exported ' + when(data.reviewersAt) : '') + '): ' + ((data.reviewers || []).map(function (r) { return r.name + ' (' + (r.regions || []).join(', ') + ')'; }).join('; ') || 'none loaded yet, the Reviewers flow has not exported the table');
    root.appendChild(ro);
    if (!plans.length) { root.appendChild(mk('div', 'empty', 'No plan has been posted for review yet. The first Post for review from Argo Navis creates one here.')); return; }
    var order = { changes: 0, awaiting: 1, 'no-reviewers': 1, verified: 2, frozen: 3, closed: 4 };
    plans.sort(function (a, b) { var sa = a.review ? a.review.state : 'awaiting', sb = b.review ? b.review.state : 'awaiting'; return ((a.isTest ? 1 : 0) - (b.isTest ? 1 : 0)) || (order[sa] - order[sb]) || String(b.posted || '').localeCompare(String(a.posted || '')); })
      .forEach(function (p) { root.appendChild(card(p, data, opts)); });
    var lg = mk('div', 'legend');
    Object.keys(STATE).forEach(function (s) { lg.appendChild(stateChip(s)); lg.appendChild(document.createTextNode(' ' + STATE[s][2] + '  ')); });
    root.appendChild(lg);
  }

  function card(p, data, opts) {
    var rv = p.review || { state: 'awaiting', required: [], others: [], requiredCount: 0, verifiedCount: 0, outstanding: [] };
    var box = mk('div', 'req' + (p.isTest ? ' test' : '') + (rv.state === 'changes' ? ' down' : ''));
    var head = mk('div', 'head');
    head.appendChild(mk('h3', '', (p.rig || p.rigKey || 'Unknown rig') + ' · ' + (p.bopNo || 'BOP') + ' · ' + p.planId));
    if (p.isTest) head.appendChild(chip('st-down', 'TEST', 'A test post (dryRun, sample or SSCE Equipment): never notified, never counted'));
    head.appendChild(chip('st-nondt', 'scope v' + p.scopeVersion));
    head.appendChild(stateChip(rv.state));
    if (rv.requiredCount) head.appendChild(chip(rv.allVerified ? 'rc-sent' : 'rc-wait', rv.verifiedCount + ' of ' + rv.requiredCount + ' verified', (rv.outstanding || []).length ? 'Outstanding: ' + rv.outstanding.join(', ') : 'All required reviewers have verified'));
    box.appendChild(head);
    if (rv.state === 'verified') box.appendChild(mk('div', 'verified-banner', 'Verified by all required reviewers. The planner now freezes the scope in Argo Navis; the notice goes to the plan chat.'));
    if (rv.state === 'changes') box.appendChild(mk('div', 'changes-banner', 'Changes requested. The planner updates the plan in Argo Navis; the next scope version comes back here for review.'));
    var g = mk('div', 'grid');
    function f(l, v) { if (v == null || v === '') return; var d = mk('div', 'f'); d.appendChild(mk('div', 'l', l)); d.appendChild(mk('div', 'v', String(v))); g.appendChild(d); }
    f('Window', (p.windowFrom || '') + (p.windowTo ? ' → ' + p.windowTo : ''));
    f('Posted', when(p.posted) + (p.createdBy ? ' · ' + p.createdBy : ''));
    f('Region', rv.region || 'not on the BWM tracker');
    f('Tasks', p.totalTasks != null ? p.totalTasks + (p.totalMaintenance != null ? ' (' + p.totalMaintenance + ' work orders)' : '') : '');
    f('Hours', p.totalHours);
    f('Critical', p.criticalTasks);
    f('Coverage', p.scopeCoveragePct != null ? p.scopeCoveragePct + '%' : '');
    f('Deferred', p.deferredCount || 0);
    f('Frozen', p.frozenAt ? when(p.frozenAt) + (p.frozenBy ? ' by ' + p.frozenBy : '') : '');
    f('Change reason', p.changeReason);
    f('Source', p.rev);
    box.appendChild(g);
    if (p.progress && p.progress.pctComplete != null) { var pb = mk('div'); pb.appendChild(mk('div', 'sub', 'Progress ' + p.progress.pctComplete + '% as of ' + when(p.progress.asOf))); var b = mk('div', 'bar'); var sp = mk('span'); sp.style.width = Math.min(100, p.progress.pctComplete) + '%'; b.appendChild(sp); pb.appendChild(b); box.appendChild(pb); }
    if (p.testingPct != null) { var tb = mk('div'); tb.appendChild(mk('div', 'sub', 'Testing section ' + p.testingPct + '%' + (p.testingPct >= 90 ? ' · pre-deployment call to be arranged' : ''))); var b2 = mk('div', 'bar t'); var sp2 = mk('span'); sp2.style.width = Math.min(100, p.testingPct) + '%'; b2.appendChild(sp2); tb.appendChild(b2); box.appendChild(tb); }

    box.appendChild(mk('h4', '', 'Required reviewers' + (rv.region ? ' for ' + rv.region : '')));
    if (!(rv.required || []).length) box.appendChild(mk('div', 'sub', 'None: the Reviewers table has no one for this region, or the roster is not exported yet.'));
    (rv.required || []).forEach(function (r) { box.appendChild(reviewRow(r)); });
    if ((rv.others || []).length) { box.appendChild(mk('h4', '', 'Other reviews')); rv.others.forEach(function (r) { box.appendChild(reviewRow(r)); }); }

    // v2.96: the fixed-sequence section (type 'fixed') and the daily log show only when they hold tasks; Lee's plans carry the
    // rig's fixed sequence as milestones, so an always-empty 'Rig skeleton' tab was only a question.
    var secs = (p.sections || []).filter(function (s) { return (s.tasks || []).length || (s.id !== 'skeleton' && s.id !== 'daily'); });
    if (secs.length) {
      var dt = mk('details'); dt.appendChild(mk('summary', '', 'Scope: ' + secs.map(function (s) { return s.name + ' ' + (s.tasks || []).length; }).join(' · ')));
      var bar = mk('div'); var tbl = mk('div');
      function show(sec) { bar.querySelectorAll('.sec-btn').forEach(function (b) { b.classList.toggle('on', b.getAttribute('data-id') === sec.id); }); tbl.innerHTML = ''; var t = mk('table'); var tr = mk('tr'); ['Task', 'Description', 'Type', 'Work order', 'Status'].forEach(function (h) { tr.appendChild(mk('th', '', h)); }); t.appendChild(tr); if (!(sec.tasks || []).length) { var e = mk('tr'); var td = mk('td', '', 'Nothing in this section.'); td.colSpan = 5; e.appendChild(td); t.appendChild(e); } (sec.tasks || []).forEach(function (x) { var r = mk('tr'); [x.taskId, x.name, x.type + (x.testType ? ' · ' + x.testType : ''), x.woNum, x.status].forEach(function (v) { r.appendChild(mk('td', '', v == null ? '' : String(v))); }); t.appendChild(r); }); tbl.appendChild(t); }
      secs.forEach(function (s) { var b = mk('button', 'sec-btn', s.name + ' (' + (s.tasks || []).length + ')'); b.type = 'button'; b.setAttribute('data-id', s.id); b.addEventListener('click', function () { show(s); }); bar.appendChild(b); });
      dt.appendChild(bar); dt.appendChild(tbl); box.appendChild(dt);
      var first = secs.filter(function (s) { return (s.tasks || []).length; })[0] || secs[0]; show(first);
    }
    if ((p.deferred || []).length) { var dd = mk('details'); dd.appendChild(mk('summary', '', 'Deferred work orders (' + p.deferred.length + ')')); var t2 = mk('table'); var h2 = mk('tr'); ['Task', 'Work order', 'Reason', 'NC ref'].forEach(function (h) { h2.appendChild(mk('th', '', h)); }); t2.appendChild(h2); p.deferred.forEach(function (d) { var r = mk('tr'); [d.taskId || d.description, d.woNum, d.reason, d.ncRef].forEach(function (v) { r.appendChild(mk('td', '', v == null ? '' : String(v))); }); t2.appendChild(r); }); dd.appendChild(t2); box.appendChild(dd); }
    if ((p.milestones || []).length) { box.appendChild(mk('div', 'sub', 'Milestones: ' + p.milestones.map(function (m) { return m.name + (m.target ? ' ' + when(m.target) : ''); }).join(' · '))); }

    if (opts.canAct && rv.state !== 'frozen' && rv.state !== 'closed') box.appendChild(actForm(p, rv, data));
    box.appendChild(mk('div', 'sub', 'Source file: ' + (p.file || '')));
    return box;
  }

  function reviewRow(r) {
    var row = mk('div', 'rv');
    var who = mk('div', 'who'); who.appendChild(mk('b', '', r.name || r.reviewer || r.email)); who.appendChild(document.createTextNode(' ')); who.appendChild(mk('span', '', (r.position || '') + (r.section && r.section !== 'All' ? ' · ' + r.section : '')));
    row.appendChild(who);
    row.appendChild(mk('div', 'cm', r.comment ? r.comment + (r.at ? ' (' + r.at + ')' : '') : (r.decision ? (r.at || '') : 'not yet reviewed')));
    row.appendChild(r.decision === 'verified' ? chip('st-closed', 'Verified') : r.decision === 'changes' ? chip('st-down', 'Changes needed') : chip('rc-wait', 'Outstanding'));
    return row;
  }

  // One small record per verdict, through the same intake as the Help Centre's acknowledgements; downloaded on any
  // failure so nothing is lost. A review of a test plan is itself flagged dryRun so the scanner keeps it apart.
  function actForm(p, rv, data) {
    var f = mk('form', 'act');
    var lab = function (t) { return mk('label', '', t); };
    f.appendChild(lab('Reviewing as')); f.appendChild(lab('Decision'));
    var sel = mk('select');
    (rv.required || []).forEach(function (r) { var op = mk('option', '', r.name + ' — ' + (r.position || '')); op.value = r.email; op.setAttribute('data-name', r.name); op.setAttribute('data-pos', r.position || ''); op.setAttribute('data-sec', r.section || 'All'); sel.appendChild(op); });
    var other = mk('option', '', 'Someone else (type below)'); other.value = '__other'; sel.appendChild(other);
    f.appendChild(sel);
    var dec = mk('select'); [['verified', 'Verified: the plan is right for my part'], ['changes', 'Changes needed (say what below)']].forEach(function (o) { var op = mk('option', '', o[1]); op.value = o[0]; dec.appendChild(op); }); f.appendChild(dec);
    var l2 = lab('Name and email (only if "someone else")'); l2.className += ' full'; f.appendChild(l2);
    var name = mk('input'); name.placeholder = 'Name'; f.appendChild(name);
    var email = mk('input'); email.placeholder = 'email@seadrill.com'; email.type = 'email'; f.appendChild(email);
    var l3 = lab('Comment (required for changes)'); l3.className += ' full'; f.appendChild(l3);
    var note = mk('textarea'); note.className = 'full'; note.rows = 2; f.appendChild(note);
    var btn = mk('button', '', 'Post review'); btn.type = 'submit'; f.appendChild(btn);
    var msg = mk('div', 'msg'); f.appendChild(msg);
    f.addEventListener('submit', function (e) {
      e.preventDefault();
      var isOther = sel.value === '__other'; var opt = sel.options[sel.selectedIndex];
      var who = { name: isOther ? name.value.trim() : opt.getAttribute('data-name'), email: (isOther ? email.value.trim() : sel.value).toLowerCase(), position: isOther ? 'Reviewer' : opt.getAttribute('data-pos'), section: isOther ? 'All' : opt.getAttribute('data-sec') };
      if (!who.name || !who.email) { msg.className = 'msg err'; msg.textContent = 'Name and email are needed.'; return; }
      if (dec.value === 'changes' && !note.value.trim()) { msg.className = 'msg err'; msg.textContent = 'Say what needs to change.'; return; }
      var record = { meta: { kind: 'plan-review', tool: 'TSC Help Centre', rev: 1, asset: p.rig || '', rigkey: p.rigKey || '', by: who.name, saved: new Date().toISOString() },
        planid: p.planId, scopeversion: p.scopeVersion, reviewer: who, decision: dec.value, comment: note.value.trim(), at: today(), dryRun: !!p.isTest };
      var json = JSON.stringify(record);
      var fileName = 'seadrill-planreview_' + String(p.planId).replace(/[^A-Za-z0-9_-]/g, '') + '_' + stamp() + '.json';
      var url = window.PCGATE && window.PCGATE.postUrl;
      btn.disabled = true; msg.className = 'msg'; msg.textContent = 'Posting…';
      var done = function (ok, why) {
        if (ok) { btn.disabled = false; note.value = ''; msg.className = 'msg ok'; msg.textContent = 'Posted as ' + fileName + '; the count updates within ten minutes.'; }
        else { var a = document.createElement('a'); a.href = URL.createObjectURL(new Blob([json], { type: 'application/json' })); a.download = fileName; document.body.appendChild(a); a.click(); setTimeout(function () { a.remove(); }, 0); btn.disabled = false; msg.className = 'msg err'; msg.textContent = 'Could not post (' + why + '). The record was downloaded as ' + fileName + ': drop it into PostedReports.'; }
      };
      if (!url) { done(false, 'no intake endpoint on this copy, gate-config.js'); return; }
      fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ FileName: fileName, ContentType: 'application/json', FileContent: btoa(unescape(encodeURIComponent(json))) }) })
        .then(function (res) { done(res.ok, res.ok ? '' : 'HTTP ' + res.status + ' ' + res.statusText); })
        .catch(function (err) { done(false, err.name + ': ' + err.message); });
    });
    return f;
  }

  window.PLAN_REVIEW = { render: render, STATE: STATE };
})();
