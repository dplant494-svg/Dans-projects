// planning-rules.js - the Daily Summary Report rules (T6), for Argo Navis.
// Cut from WCGRRT REV 172 (WCE Rig Vist Reporting Tool V0.html) by make-172.js - byte-identical to the tool. Do not edit here; change WCGRRT.
// Use: in a browser, <script src="planning-rules.js"></script> gives window.PlanRules; in Node, require("./planning-rules.js").
(function(root){
const RIG_CODES = {"West Auriga":"WAU","West Vela":"WVE","Sevan Louisiana":"SLO","Sonangol Libongos":"SLI","Sonangol Quenguela":"SQE","West Gemini":"WGE","West Polaris":"WPO","West Carina":"CAR","West Jupiter":"WJU","West Saturn":"WSA","West Phoenix":"WPH","West Capella":"WCA","West Neptune":"WNE","West Tellus":"WTE","SSCE Equipment":"SSCE"};
const ERT_MON = {Jan:1,Feb:2,Mar:3,Apr:4,May:5,Jun:6,Jul:7,Aug:8,Sep:9,Oct:10,Nov:11,Dec:12};
function ertTabDate(name, year){ const m = name.match(/([A-Za-z]{3})(\d{1,2})/); return m ? new Date(year, ERT_MON[m[1]]-1, +m[2]) : null; }
function ertDone(v){ return typeof v === 'string' && /\bA\s*$/.test(v.trim()); }
function ertParseDate(v){ if (v == null) return null; const s = String(v).replace(/\s*A\s*$/,'').trim(); const m = s.match(/(\d{4})-([A-Za-z]{3})-(\d{1,2})/); if (m) return new Date(+m[1], ERT_MON[m[2]]-1, +m[3]); const n = parseFloat(s); if (isFinite(n) && n > 30000) { const d = new Date(Date.UTC(1899,11,30)); d.setUTCDate(d.getUTCDate()+Math.floor(n)); return d; } return null; }
function ertISO(d){ return d ? d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0') : ''; }
function ertHrs(v){ const m=/([\d.]+)\s*h/i.exec(String(v==null?'':v)); return m?parseFloat(m[1]):null; }
function ertLeaves(rows){ const o = {}; let branch=''; rows.forEach(r => { const id = (r.B||'').trim(); const nm = (r.C||'').trim(); if (id && !nm && /\./.test(id)) { branch = id; } else if (id && nm) o[id] = { name:nm, pct:r.D, orig:(r.E||''), rem:ertHrs(r.F), start:r.H, finish:r.I, branch:branch }; }); return o; }
function ertCriticalPath(rawRows, projFinRaw){
  if(!rawRows || !rawRows.length) return '';
  const isA = v => typeof v==='string' && /\bA\s*$/.test(v.trim());
  const clean = v => String(v==null?'':v).replace(/\s*A\s*$/,'').trim();
  const dots = id => (String(id).match(/\./g)||[]).length;
  const isBranch = r => !String(r.C||'').trim() && /^\d[\w-]*\.\d/.test(String(r.B||'').trim());
  const rows = rawRows.map(r => ({ id:String(r.B||'').trim(), name:String(r.C||'').trim(), finRaw:r.I, finA:isA(r.I), branch:isBranch(r) }));
  const projFin = clean(projFinRaw);
  if(!projFin) return '';
  // driving area = deepest WBS branch (1..3 dot-levels) whose finish equals the project finish
  let ai=-1, adepth=-1;
  for(let i=0;i<rows.length;i++){ const x=rows[i]; if(x.branch && clean(x.finRaw)===projFin){ const dd=dots(x.id); if(dd>=1 && dd<=3 && dd>adepth){ adepth=dd; ai=i; } } }
  if(ai<0) return '';
  const areaId=rows[ai].id.split(/\s{2,}/)[0].trim();
  let pod=null, bestT=null, bestPod='';
  for(let j=ai+1;j<rows.length;j++){ const x=rows[j];
    if(x.branch && dots(x.id)<=adepth) break;                          // left the driving area
    if(x.branch && x.id.indexOf(areaId+'.')===0) pod = x.id.replace(/^\S+\s+/,'').trim(); // current pod (sub-branch)
    if(x.name && !x.finA){ const d=ertParseDate(x.finRaw); if(d){ const t=d.getTime(); if(bestT===null||t<bestT){ bestT=t; bestPod=pod||''; } } }
  }
  return bestPod;
}
// ==== PLAN-RULES BEGIN (REV 172) ====
// The Daily Summary Report rules, written once. Nothing in this block touches the page: every function takes its inputs
// and returns a value. WCGRRT calls these; the SACRED print template and planning-rules.js (for Argo Navis) carry this
// block byte-for-byte, cut from the built WCGRRT file, so all three print and calculate the same way.
const PLAN_MON = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
const PLAN_RED = '#c0261f', PLAN_GREEN = '#0a7d32';
// BOP % (Dan, 15 Oct): only BOP work, from BOP on beams to testing complete, drifted, the pre-deployment call and BOP
// ready to deploy. A P6 activity counts when one of its WBS branches (not the project row) matches PLAN_BOP_INCL and
// none matches PLAN_BOP_EXCL. MPD, riser (except the riser adapter, which is LMRP), telescopic joint, diverter and
// surface equipment are not BOP work.
const PLAN_BOP_INCL = /\bBOP\d?\b|LMRP|Lower\s+(?:BOP\d?\s+)?Stack|Beam[\s-]*to[\s-]*Beam|Annular|\bRams?\b|\bPODs?\b|Accumulator|Well[\s-]*Head\s+Connector|Pre[\s-]*Deploy|Drift|Stump\s+Test|Quarantine/i;
const PLAN_BOP_EXCL = /\bMPD\b|Managed\s+Pressure|\bRiser\b(?!\s+Adapter)|Telescopic|Diverter|Surface\s+Equipment/i;
function planPad2(n){ return (n < 10 ? '0' : '') + n; }
// 2026-10-15 -> 2026-Oct-15 (the form's date style). Anything else is returned as it is.
function planFmtDate(iso){
  var m = /^(\d{4})-(\d{2})-(\d{2})/.exec(String(iso || ''));
  return m ? (m[1] + '-' + (PLAN_MON[parseInt(m[2], 10) - 1] || m[2]) + '-' + m[3]) : String(iso || '');
}
// 0.8918 -> "89.18%"; 0.85 -> "85%"
function planPctText(frac){ var n = Number(frac); return isFinite(n) ? (Math.round(n * 10000) / 100) + '%' : ''; }
// Hours as a signed number from the text a planner or the ERT gives: "(−) 81.8 Hrs" -> -81.8, "(+) 3 Days" -> 72,
// "+3 Hrs" -> 3, "-5" -> -5, "0 Days" -> 0. Blank or no number -> null. Days are converted at 24 h.
function planParseHrs(s){
  var t = String(s == null ? '' : s).trim(); if (!t) return null;
  t = t.replace(/−/g, '-');
  var m = t.match(/(\d+(?:\.\d+)?)/); if (!m) return null;
  var n = parseFloat(m[1]); if (/day/i.test(t)) n *= 24;
  var neg = /^\(\s*-\s*\)/.test(t) || /^-/.test(t);
  return Math.round((neg ? -n : n) * 10) / 10;
}
// Maintenance day. Day X counts whole days from Maint. Actual Start to the report date, the start date being Day 1
// (dates only, times ignored). "of Y": Y = P6 Original Duration (ERT project row, hours) / 24, rounded; without it, whole
// days from start to Original Est. Finish inclusive. Hours elapsed = X x 24.
function planMaintDayText(startV, rdV, odhRaw, curV){
  if (!startV) return '';
  const DAY = 86400000;
  const s = new Date(startV); s.setHours(0,0,0,0);
  const now = rdV ? new Date(rdV) : new Date(); now.setHours(0,0,0,0);
  const x = Math.max(1, Math.floor((now - s) / DAY) + 1); // start date = Day 1 (inclusive)
  const hrsEl = x * 24;
  const odh = parseFloat(odhRaw || '');
  if (isFinite(odh) && odh > 0) {           // total from P6 Original Duration (matches planner)
    const totDays = odh / 24;
    const y = Math.max(1, Math.round(totDays));
    return `Day ${x} of ${y} · ${hrsEl} hrs elapsed / ${odh.toFixed(1)} hrs total (${totDays.toFixed(1)} days)`;
  } else if (curV) {
    const y = Math.max(1, Math.floor((new Date(curV) - s) / DAY) + 1);
    return `Day ${x} of ${y} · ${hrsEl} hrs elapsed / ${y*24} hrs total (${y} days)`;
  }
  return `Day ${x} · ${hrsEl} hrs elapsed`;
}
// Plan variance without an ERT: whole days, Original Est. Finish minus Current Est. Finish (+ = ahead, − = behind).
// With an ERT the variance is the ERT project row's column G, in hours, as P6 gives it (see importErt).
function planVarianceFromFinish(orig, cur){
  let txt = '';
  if (orig && cur) {
    const days = Math.round((new Date(orig) - new Date(cur)) / 86400000);
    if (days > 0)      txt = `(+) ${days} Days`;
    else if (days < 0) txt = `(−) ${Math.abs(days)} Days`;
    else               txt = '0 Days';
  }
  return txt;
}
// yyyymmdd_<rig code>_<type code>_<BOP>[_<file type>], blank parts left out.
function planConventionNameFrom(rigCode, typeCode, bop, dateISO, fileType){
  var date = dateISO ? String(dateISO).replace(/-/g, '') : '';
  var segs = [date, rigCode, typeCode, bop].filter(function(x){ return x; });
  if (!segs.length) return '';
  return segs.join('_') + (fileType ? ('_' + fileType) : '');
}
function planTypeCodeFrom(projType){ var m = String(projType || '').match(/\(([A-Za-z]{2,4})\)/); return m ? m[1].toUpperCase() : ''; }
// The report name (T7): the convention name for "Report", then the cut-off, e.g. 20261015_WPO_BOP1_TMP_Report_0600.
function planReportName(rigCode, typeCode, bop, dateISO, cycle){
  var n = planConventionNameFrom(rigCode, typeCode, bop, dateISO, 'Report');
  return n ? n + (cycle ? '_' + cycle : '') : '';
}
// The cut-off: 0600 or 1800 rig local time. Default: 0600 between 06:00 and 17:59 on the device clock, else 1800.
function planDefaultCycle(now){ var h = (now || new Date()).getHours(); return (h >= 6 && h < 18) ? '0600' : '1800'; }
// A local date-time as ISO with the device's UTC offset: 2026-10-15T06:00:00-03:00
function planLocalISO(dt){
  var off = -dt.getTimezoneOffset(), sg = off >= 0 ? '+' : '-', a = Math.abs(off);
  return dt.getFullYear() + '-' + planPad2(dt.getMonth() + 1) + '-' + planPad2(dt.getDate()) + 'T' + planPad2(dt.getHours()) + ':' + planPad2(dt.getMinutes()) + ':00' + sg + planPad2(Math.floor(a / 60)) + ':' + planPad2(a % 60);
}
// meta.dataDateTime (T3): the report date at the cut-off, in the device's time zone (the rig's PC runs rig time).
function planDataDateTime(dateISO, cycle){
  var d = /^(\d{4})-(\d{2})-(\d{2})$/.exec(String(dateISO || '')), c = /^(\d{2})(\d{2})$/.exec(String(cycle || ''));
  if (!d || !c) return '';
  return planLocalISO(new Date(+d[1], +d[2] - 1, +d[3], +c[1], +c[2]));
}
// A break-in is "new since the last report" when it was added in the 12 hours up to this report's cut-off.
function planIsNewSince(addedISO, dataDateTimeISO){
  var t = Date.parse(addedISO || ''), e = Date.parse(dataDateTimeISO || '');
  if (!isFinite(t) || !isFinite(e)) return false;
  return t <= e && t > e - 12 * 3600000;
}
// The values every post carries, worked out from the header and the Planning Report (T3, T5, T7).
function planDerivedMeta(meta, d){
  meta = meta || {}; d = d || {};
  var rd = d.dataDate || d.reportDate || '';
  return {
    cycle: d.cycle || '',
    dataDateTime: planDataDateTime(rd, d.cycle),
    reportName: planReportName((typeof RIG_CODES !== 'undefined' && RIG_CODES[meta.asset]) || '', planTypeCodeFrom(meta.projType), meta.bopNo || '', rd, d.cycle),
    floatHrs: planParseHrs(meta.float)
  };
}
// The two cycle lists, from the current and previous ERT tabs (leaf activities by ID).
//   Previous cycle -> present: finished since the last report, OR worked this cycle (remaining hours dropped, not finished).
//   Projected next cycle: every task in progress (started, not finished). Both show the task's current %.
function planCycleLists(cur, prev){
  const pctStr = p => { const n = parseFloat(p); return isFinite(n) ? Math.round(n*100)+'%' : ''; };
  const completed = [], lookahead = [];
  for (const id in cur){ const v = cur[id]; const pv = prev[id];
    const doneNow = ertDone(v.finish) && !(pv && ertDone(pv.finish));
    const worked = pv && pv.rem != null && v.rem != null && v.rem < pv.rem && !ertDone(v.finish);
    if (doneNow || worked) completed.push({ id, desc: v.name, pct: pctStr(v.pct) });
  }
  for (const id in cur){ const v = cur[id]; if (!ertDone(v.finish) && ertDone(v.start)) lookahead.push({ id, desc: v.name, target: pctStr(v.pct) }); }
  return { completed, lookahead };
}
// Milestones: zero-duration activities under a WBS branch named "Milestone…" (all zero-duration ones if none is).
// Baseline = date on the FIRST ERT tab; Estimated = date on the current tab; Actual = that date once P6 marks it "A".
function planMilestones(cur, first){
  const ms = [];
  const _msZero = Object.keys(cur).filter(id => /^0\.0/.test(cur[id].orig||''));
  let _msPick = _msZero.filter(id => /milestone/i.test(cur[id].branch||''));  // true milestones live under the Milestones WBS branch
  if (!_msPick.length) _msPick = _msZero;                                     // fallback if no Milestones branch is named
  _msPick.forEach(id => { const v = cur[id]; const fr = first[id]; const bl = fr ? ertParseDate(fr.finish || fr.start) : null; const cd = v.finish || v.start; ms.push({ name: v.name, baseline: ertISO(bl), est: ertISO(ertParseDate(cd)), actual: (ertDone(v.finish) || ertDone(v.start)) ? ertISO(ertParseDate(cd)) : '' }); });
  return ms;
}
// BOP % complete (T4), the way P6 computes its own percentages: 1 − Σ remaining hours ÷ Σ original hours, over the BOP
// activities (see PLAN_BOP_INCL / _EXCL). The hierarchy is read from the indentation of column B, as P6 exports it.
// Returns { pct: 0..1 or null, basis: which branches were counted and which left out }.
function planBopPct(rows){
  var ind = function(s){ var m = /^\s*/.exec(String(s)); return m ? m[0].length : 0; };
  var stack = [], tot = 0, rem = 0, counted = {}, left = {};
  (rows || []).forEach(function(r){
    var raw = String(r.B == null ? '' : r.B), b = raw.trim(), c = String(r.C == null ? '' : r.C).trim(); if (!b) return;
    var lv = ind(raw);
    while (stack.length && stack[stack.length - 1].lv >= lv) stack.pop();
    if (!c){ var wid = b.split(/\s+/)[0]; stack.push({ lv: lv, top: !/\./.test(wid), name: b.slice(wid.length).trim() }); return; }
    var anc = stack.filter(function(s){ return !s.top; });
    var od = ertHrs(r.E); if (!(od > 0) || !anc.length) return;
    var hit = anc.filter(function(s){ return PLAN_BOP_INCL.test(s.name); })[0];
    var bad = anc.some(function(s){ return PLAN_BOP_EXCL.test(s.name); });
    if (!hit || bad){ left[anc[0].name] = 1; return; }
    var rh = ertHrs(r.F); if (rh == null){ var p = parseFloat(r.D); rh = isFinite(p) ? od * (1 - p) : od; }
    tot += od; rem += Math.min(Math.max(rh, 0), od); counted[hit.name] = 1;
  });
  var c = Object.keys(counted), l = Object.keys(left).filter(function(n){ return !counted[n]; });
  return { pct: tot ? (1 - rem / tot) : null, basis: tot ? ('Counted: ' + c.join('; ') + (l.length ? ' · Left out: ' + l.join('; ') : '')) : 'No BOP branches found in the ERT' };
}
// General comments as plain lines, from the <ul><li> WCGRRT posts (or <p>/<br> text). Never inserted as HTML.
function planCommentLines(html){
  var s = String(html || ''); if (!s.trim()) return [];
  var lis = s.match(/<li[^>]*>[\s\S]*?<\/li>/gi);
  var parts = (lis && lis.length) ? lis : s.split(/<\/p>|<\/div>|<br\s*\/?>/i);
  return parts.map(function(p){ return p.replace(/<[^>]+>/g, '').replace(/&nbsp;/g, ' ').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&amp;/g, '&').trim(); }).filter(Boolean);
}
// The Daily Summary Report document, from a posted record: meta (the post's meta) and d (tiles[].planningData).
// The same function renders WCGRRT's "Generate Report" and the SACRED PDF.
function planReportDocHTML(meta, d, logo){
  meta = meta || {}; d = d || {};
  var esc = function(s){ return String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); };
  var v = function(s){ s = String(s == null ? '' : s).trim(); return s ? esc(s) : '<span style="color:#8a94a6;">—</span>'; };
  var fd = function(s){ return planFmtDate(s); };
  var hh = function(t){ var m = /^(\d{1,2}):?(\d{2})$/.exec(String(t || '').trim()); return m ? (' @' + planPad2(+m[1]) + m[2] + ' Hrs') : ''; };
  var colr = function(n){ return n == null ? '' : (n < 0 ? PLAN_RED : (n > 0 ? PLAN_GREEN : '')); };
  var hrs = function(n){ return (n > 0 ? '+' : '') + n + ' Hrs'; };
  var none = function(cols){ return '<tr><td colspan="' + cols + '" style="color:#5a6880;font-style:italic;">None reported.</td></tr>'; };
  var rd = d.dataDate || d.reportDate || '';
  var cyc = d.cycle || meta.cycle || '';
  var dataDate = rd ? (fd(rd) + (cyc ? ' @' + cyc + ' Hrs' : '')) : '';
  var dataDT = meta.dataDateTime || planDataDateTime(rd, cyc);
  var vh = (d.planVarianceHrs != null && d.planVarianceHrs !== '' && isFinite(Number(d.planVarianceHrs))) ? Number(d.planVarianceHrs) : planParseHrs(d.planVariance);
  var fh = (meta.floatHrs != null && meta.floatHrs !== '' && isFinite(Number(meta.floatHrs))) ? Number(meta.floatHrs) : planParseHrs(meta.float);
  var p = String(d.pctComplete || '').trim(), bp = String(d.bopPctComplete || '').trim();
  var pTxt = p ? (/complete/i.test(p) ? p : p + ' Complete') : '';
  if (bp && !/bop/i.test(p)) pTxt += (pTxt ? ' / ' : '') + bp + ' BOP Complete';
  var name = meta.reportName || '';
  var h = '<div class="trip-doc plan-dsr">';
  h += '<div class="dr-header"><div class="dr-logo"><img src="' + (logo || '') + '" width="92" height="31" style="height:30px;width:92px;display:block;" alt="Seadrill"></div>'
    + '<div class="dr-title-block"><div class="dr-eyebrow">Technical Services — Planning</div><div class="dr-title">Daily Summary Report</div></div>'
    + '<div class="dr-date">' + esc(dataDate) + '</div></div>';
  h += '<div style="font-style:italic;font-size:11px;color:var(--sd-text-light);margin:8px 0 14px;">The intention of this report is to summarise the project schedule — tasks completed, in progress and approaching — together with milestone, variance and float information.</div>';
  if (d.projectComplete) h += '<div style="display:inline-block;background:#0a7d32;color:#fff;font-weight:700;font-size:12px;padding:6px 14px;border-radius:5px;margin:0 0 14px;">✓ PROJECT COMPLETE</div>';
  var row = function(a, b, c, e){ return '<tr><td class="tm-l">' + a + '</td><td>' + b + '</td><td class="tm-l">' + c + '</td><td>' + e + '</td></tr>'; };
  var cf = meta.curFinish ? esc(fd(meta.curFinish) + hh(d.curFinishTime)) : v('');
  var nd = meta.needDate ? '<span style="color:' + PLAN_GREEN + ';font-weight:700;">' + esc(fd(meta.needDate) + hh(d.needTime)) + '</span>' : v('');
  var vtxt = vh != null ? '<span style="color:' + colr(vh) + ';font-weight:700;">' + esc(hrs(vh)) + '</span>' : v(d.planVariance);
  var ftxt = fh != null ? '<span style="color:' + colr(fh) + ';font-weight:700;">' + esc(hrs(fh)) + '</span>' : v(meta.float);
  h += '<div class="trip-h2">Project Information</div><table class="trip-meta-table"><tbody>'
    + row('Rig', v(meta.asset), 'Data Date', v(dataDate))
    + row('Project Location', v(meta.location), 'Synergi Case #', v(meta.wo))
    + row('Rig Manager', v(meta.rigmgr), '3rd-Party Verifier', v(meta.verifier))
    + row('Asst. Rig Manager', v(meta.arigmgr), 'Project Planner', v(meta.planner))
    + row('OIM', v(meta.oim), 'Project Lead', v(meta.projLead))
    + row('TSL', v(meta.tsl), 'Technical Supt.', v(meta.techSupt))
    + row('DSL', v(meta.dsl), 'Project Type', v([meta.projType, meta.bopNo].filter(Boolean).join(' · ')))
    + row('Subsea Supervisor', v(meta.sss), 'Last Rig Update', v(fd(d.lastRigUpdate)))
    + row('Original Est. Finish', v(fd(meta.origFinish)), 'Maint. Actual Start', v(fd(meta.maintStart)))
    + row('Current Est. Finish', cf, 'Maintenance Day', meta.maintDay ? '<span style="text-decoration:underline;font-weight:700;">' + esc(meta.maintDay) + '</span>' : v(''))
    + row('Plan Variance (Hrs)<br><span style="font-weight:400;text-transform:none;">+ ahead / − behind</span>', vtxt, 'BOP Need Date', nd)
    + row('Total Float, BOP Need', ftxt, 'Report', v(name))
    + '</tbody></table>';
  h += '<div class="trip-h2">Critical Path · SIMOPS · Project %</div><table class="trip-meta-table"><tbody>'
    + '<tr><td class="tm-l">Critical Path</td><td colspan="3">' + v(d.criticalPath) + '</td></tr>'
    + '<tr><td class="tm-l">SIMOPS</td><td>' + v(d.simops) + '</td><td class="tm-l">Project Percentage</td><td style="font-weight:700;">' + v(pTxt) + '</td></tr>'
    + '</tbody></table>';
  if (d.milestones && d.milestones.length) {
    h += '<div class="trip-h2">Milestones</div><div style="font-size:9px;color:var(--sd-text-light);margin:0 0 4px;"><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:#1a9c3e;-webkit-print-color-adjust:exact;print-color-adjust:exact;vertical-align:middle;"></span> Complete &nbsp;&nbsp; <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:#e6b400;-webkit-print-color-adjust:exact;print-color-adjust:exact;vertical-align:middle;"></span> Outstanding &nbsp;&nbsp; <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:#c0261f;-webkit-print-color-adjust:exact;print-color-adjust:exact;vertical-align:middle;"></span> Overdue (past estimate)</div><table class="trip-meta-table"><thead><tr><th style="width:46px;text-align:center;">Status</th><th>Milestone</th><th>Baseline</th><th>Estimated</th><th>Actual</th></tr></thead><tbody>';
    var _now = (function(){ var s = rd; var x = /^\d{4}-\d{2}-\d{2}$/.test(s) ? new Date(s + 'T00:00:00') : new Date(); x.setHours(0,0,0,0); return x; })();
    d.milestones.forEach(function(m){ var done = !!(m.actual && String(m.actual).trim()); var col = '#e6b400'; if (done) col = '#1a9c3e'; else { var es = /^\d{4}-\d{2}-\d{2}$/.test(m.est || '') ? new Date(m.est + 'T00:00:00') : null; if (es && es < _now) col = '#c0261f'; }
      h += '<tr><td style="text-align:center;"><span style="display:inline-block;width:13px;height:13px;border-radius:50%;border:1px solid rgba(0,0,0,0.25);background:' + col + ';-webkit-print-color-adjust:exact;print-color-adjust:exact;"></span></td><td>' + esc(m.name) + '</td><td>' + esc(fd(m.baseline)) + '</td><td>' + esc(fd(m.est)) + '</td><td>' + esc(fd(m.actual)) + '</td></tr>'; });
    h += '</tbody></table>';
  }
  var bk = (d.breakins || []).filter(function(b){ return b && b.status !== 'closed'; });
  h += '<div class="trip-h2">Schedule Changes — Break-in Work or Delays</div><div style="font-size:9px;color:var(--sd-text-light);margin:0 0 4px;">Every open break-in. <strong style="color:' + PLAN_RED + ';">NEW</strong> = added in the 12 hours to this report’s cut-off. Delays are logged as type “Waiting / NPT”.</div>'
    + '<table class="trip-meta-table"><thead><tr><th style="width:64px;">ID</th><th>Type</th><th>Description</th><th>Area</th><th>Proposed Start</th><th style="width:52px;">Dur (h)</th><th>Critical</th><th>Ref</th></tr></thead><tbody>';
  h += bk.length ? bk.map(function(t){ var nw = planIsNewSince(t.added, dataDT) ? ' <span style="color:#fff;background:' + PLAN_RED + ';font-size:8px;font-weight:700;padding:1px 4px;border-radius:3px;-webkit-print-color-adjust:exact;print-color-adjust:exact;">NEW</span>' : '';
    return '<tr><td style="white-space:nowrap;">' + esc(t.id) + nw + '</td><td>' + esc(t.type) + '</td><td>' + esc(t.desc) + '</td><td>' + esc(t.wbs) + '</td><td>' + esc(String(t.start || '').replace('T', ' ')) + '</td><td>' + esc(t.dur) + '</td><td>' + esc(t.critical) + '</td><td>' + esc(t.ref) + '</td></tr>'; }).join('') : none(8);
  h += '</tbody></table>';
  var q = (d.quality || []).filter(function(x){ return x && (x.owner || x.date || x.desc); });
  h += '<div class="trip-h2">Quality / Rig Reliability — Materials, People, Parts, Tools, etc.</div><table class="trip-meta-table"><thead><tr><th style="width:150px;">Action Owner</th><th style="width:110px;">Estimated Date</th><th>Description / Comment</th></tr></thead><tbody>'
    + (q.length ? q.map(function(x){ return '<tr><td>' + esc(x.owner) + '</td><td>' + esc(fd(x.date)) + '</td><td>' + esc(x.desc) + '</td></tr>'; }).join('') : none(3)) + '</tbody></table>';
  var ll = (d.lessons || []).filter(function(x){ return x && (x.id || x.desc); });
  h += '<div class="trip-h2">Lessons Learned Since Last Report</div><table class="trip-meta-table"><thead><tr><th style="width:120px;">Task ID</th><th>Task Description / Comment</th></tr></thead><tbody>'
    + (ll.length ? ll.map(function(x){ return '<tr><td>' + esc(x.id) + '</td><td>' + esc(x.desc) + '</td></tr>'; }).join('') : none(2)) + '</tbody></table>';
  if (d.done && d.done.length) {
    h += '<div class="trip-h2">Previous Report Cycle — to Present</div><table class="trip-meta-table"><thead><tr><th style="width:120px;">Task ID</th><th>Task Description / Comment</th><th style="width:96px;">% Complete</th></tr></thead><tbody>';
    d.done.forEach(function(t){ h += '<tr><td>' + esc(t.id) + '</td><td>' + esc(t.desc) + '</td><td>' + esc(t.pct) + '</td></tr>'; });
    h += '</tbody></table>';
  }
  if (d.next && d.next.length) {
    h += '<div class="trip-h2">Projected for Next Report Cycle</div><table class="trip-meta-table"><thead><tr><th style="width:120px;">Task ID</th><th>Task Description</th><th style="width:96px;">Current %</th></tr></thead><tbody>';
    d.next.forEach(function(t){ h += '<tr><td>' + esc(t.id) + '</td><td>' + esc(t.desc) + '</td><td>' + esc(t.target) + '</td></tr>'; });
    h += '</tbody></table>';
  }
  var cl = (d.breakins || []).filter(function(b){ return b && b.status === 'closed'; });
  if (cl.length) {
    h += '<div class="trip-h2">After Action Review — Break-in Work</div><div style="font-size:9px;color:var(--sd-text-light);margin:0 0 4px;">Break-ins absorbed into the schedule this project.</div><table class="trip-meta-table"><thead><tr><th style="width:60px;">ID</th><th>Type</th><th>Description</th><th style="width:84px;">Became (P6)</th><th style="width:48px;">Dur (h)</th><th style="width:96px;">Date Added</th><th>Outcome / Lesson</th></tr></thead><tbody>';
    cl.forEach(function(t){ h += '<tr><td>' + esc(t.id) + '</td><td>' + esc(t.type) + '</td><td>' + esc(t.desc) + '</td><td>' + esc(t.p6id) + '</td><td>' + esc(t.dur) + '</td><td>' + esc(fd(t.closedDate)) + '</td><td>' + esc(t.lesson) + '</td></tr>'; });
    h += '</tbody></table>';
  }
  var notes = planCommentLines(d.comments);
  h += '<div class="trip-h2">General Comments</div>' + (notes.length ? '<div class="dr-equip-notes"><ul>' + notes.map(function(t){ return '<li>' + esc(t) + '</li>'; }).join('') + '</ul></div>' : '<div style="font-size:11px;color:#5a6880;font-style:italic;">None.</div>');
  h += '<div class="trip-h2">Prepared / Approved</div><table class="trip-meta-table"><tbody>' + row('Project Planner', v(meta.planner), 'Project Lead', v(meta.projLead)) + '</tbody></table>';
  h += '<div class="trip-foot">CONFIDENTIAL — SEADRILL INTERNAL USE ONLY · Daily Summary Report' + (name ? ' · ' + esc(name) : '') + ' · Generated ' + esc(new Date().toLocaleString()) + '</div>';
  return h + '</div>';
}
// ==== PLAN-RULES END ====
var api = { RIG_CODES: RIG_CODES, PLAN_BOP_INCL: PLAN_BOP_INCL, PLAN_BOP_EXCL: PLAN_BOP_EXCL, planFmtDate: planFmtDate, planPctText: planPctText, planParseHrs: planParseHrs,
  planMaintDayText: planMaintDayText, planVarianceFromFinish: planVarianceFromFinish, planConventionNameFrom: planConventionNameFrom, planTypeCodeFrom: planTypeCodeFrom,
  planReportName: planReportName, planDefaultCycle: planDefaultCycle, planLocalISO: planLocalISO, planDataDateTime: planDataDateTime, planIsNewSince: planIsNewSince,
  planDerivedMeta: planDerivedMeta, planCycleLists: planCycleLists, planMilestones: planMilestones, planBopPct: planBopPct, planCommentLines: planCommentLines,
  planReportDocHTML: planReportDocHTML, ertTabDate: ertTabDate, ertDone: ertDone, ertParseDate: ertParseDate, ertISO: ertISO, ertHrs: ertHrs, ertLeaves: ertLeaves, ertCriticalPath: ertCriticalPath };
if (typeof module !== "undefined" && module.exports) module.exports = api; else root.PlanRules = api;
})(typeof window !== "undefined" ? window : this);
