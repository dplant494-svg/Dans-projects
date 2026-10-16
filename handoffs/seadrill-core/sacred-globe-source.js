var RIG_POSITIONS = {
  // 'West Vela': {lat: 27.2, lon: -90.4}
};
var GLOBE = {
  R: 392, cx: 1090, cy: 440, lambda: -25, phi: -14,      // view: radius/centre in stage px; lambda = longitude facing us; phi = tilt
  degPerSec: 3,                                          // one turn every two minutes
  holdUntil: 0, hovering: false, raf: null, last: 0, pins: [], land: null,
  slowFrames: 0, disabled: false, facing: null
};

function globeLand(){
  if(GLOBE.land) return GLOBE.land;
  var rings = [];
  WORLD_PATHS.forEach(function(d){
    d.split('M').slice(1).forEach(function(sub){
      var pts = sub.replace(/Z/g, '').split('L');
      if(pts.length < 3) return;
      var lon = new Float32Array(pts.length), cl = new Float32Array(pts.length), sl = new Float32Array(pts.length);
      for(var i = 0; i < pts.length; i++){
        var xy = pts[i].split(' ');
        var ln = (+xy[0]) * (MAPV.LON1 - MAPV.LON0) / MAPV.W + MAPV.LON0;
        var lt = MAPV.LAT1 - (+xy[1]) * (MAPV.LAT1 - MAPV.LAT0) / MAPV.H;
        lt = Math.max(-89.5, Math.min(89.5, lt));
        var la = lt * Math.PI / 180;
        lon[i] = ln * Math.PI / 180; cl[i] = Math.cos(la); sl[i] = Math.sin(la);
      }
      rings.push({n: pts.length, lon: lon, cl: cl, sl: sl});
    });
  });
  GLOBE.land = rings;
  return rings;
}

// Unit-sphere point (lon/lat in radians) -> {x, y, z} in view space; z > 0 faces the viewer.
function globeProject(lonR, cosLat, sinLat, sinLam, cosLam, sinPhi, cosPhi){
  var l = lonR, x = cosLat * Math.sin(l) * cosLam - cosLat * Math.cos(l) * sinLam;
  var z0 = cosLat * Math.cos(l) * cosLam + cosLat * Math.sin(l) * sinLam;
  var y = sinLat * cosPhi - z0 * sinPhi;
  var z = sinLat * sinPhi + z0 * cosPhi;
  return {x: x, y: y, z: z};
}

function dl1PctForGroup(g){
  var best = null;
  (DL1 && DL1.plans || []).forEach(function(pl){
    if(!pl || pl.isTest || pl.rig !== g.rig || !pl.progress || pl.progress.pctComplete == null) return;
    var v = Number(pl.progress.pctComplete);
    if(best == null || v > best) best = v;
  });
  return best;
}

function renderGlobe(fleet){
  var groups = groupByVessel(fleet);
  var byRegion = {};
  groups.forEach(function(g){ var loc = g.rows[0].location; (byRegion[loc] = byRegion[loc] || []).push(g); });
  var pins = [];
  Object.keys(byRegion).forEach(function(region){
    var anchor = REGION_ANCHORS[region] || {lat: 0, lon: 0, name: region};
    byRegion[region].forEach(function(g, i){
      var pos = RIG_POSITIONS[g.rig];
      var lat, lon;
      if(pos){ lat = pos.lat; lon = pos.lon; }
      else { var angle = i * 2.399963, radius = 3.6 * Math.sqrt(i); lat = anchor.lat + radius * Math.sin(angle); lon = anchor.lon + radius * Math.cos(angle); }
      var status = headlineStatus(g.rows);
      pins.push({
        g: g, region: region, lat: lat, lon: lon, status: status, color: statusColor(status),
        maint: status === 'On-Deck (Performing Maint.)', pct: dl1PctForGroup(g),
        lonR: lon * Math.PI / 180, cl: Math.cos(lat * Math.PI / 180), sl: Math.sin(lat * Math.PI / 180)
      });
    });
  });
  GLOBE.pins = pins;
  var list = document.getElementById('globeList');
  if(list){
    list.innerHTML = '<div class="globe-list-title">Fleet &middot; ' + pins.length + ' rigs</div>' + pins.map(function(p, i){
      var sub = p.pct != null ? ('Argo Navis ' + p.pct.toFixed(0) + '%') : statusShort(p.status);
      return '<div class="globe-row" data-idx="' + i + '" onclick="openRigModal(\'' + slug(p.g.rig) + '\')" onmouseenter="globeFocusPin(' + i + ')">' +
        '<span class="gr-dot" style="background:' + p.color + '"></span>' +
        '<span><div class="gr-rig">' + p.g.rig + '</div><div class="gr-loc">' + ((REGION_ANCHORS[p.region] || {name: p.region}).name) + '</div></span>' +
        '<span class="gr-pct">' + sub + '</span></div>';
    }).join('');
  }
  globeStart();
}

// Hovering a rig in the list turns the globe to it and holds there.
function globeFocusPin(i){
  var p = GLOBE.pins[i]; if(!p) return;
  GLOBE.lambda = p.lon; GLOBE.holdUntil = performance.now() + 10000;
}

function globeDraw(now){
  var cv = document.getElementById('globeCanvas'); if(!cv) return;
  var ctx = cv.getContext('2d'); if(!ctx){ globeDisable('no canvas'); return; }
  var R = GLOBE.R, cx = GLOBE.cx, cy = GLOBE.cy;
  var lam = GLOBE.lambda * Math.PI / 180, phi = GLOBE.phi * Math.PI / 180;
  var sinLam = Math.sin(lam), cosLam = Math.cos(lam), sinPhi = Math.sin(phi), cosPhi = Math.cos(phi);
  ctx.clearRect(0, 0, cv.width, cv.height);

  // Atmosphere halo + ocean disc
  var halo = ctx.createRadialGradient(cx, cy, R * 0.98, cx, cy, R * 1.12);
  halo.addColorStop(0, 'rgba(0,145,218,0.45)'); halo.addColorStop(1, 'rgba(0,145,218,0)');
  ctx.fillStyle = halo; ctx.beginPath(); ctx.arc(cx, cy, R * 1.12, 0, Math.PI * 2); ctx.fill();
  var ocean = ctx.createRadialGradient(cx - R * 0.35, cy - R * 0.35, R * 0.1, cx, cy, R);
  ocean.addColorStop(0, '#0a4aa8'); ocean.addColorStop(0.7, '#073a8a'); ocean.addColorStop(1, '#02225e');
  ctx.fillStyle = ocean; ctx.beginPath(); ctx.arc(cx, cy, R, 0, Math.PI * 2); ctx.fill();

  ctx.save(); ctx.beginPath(); ctx.arc(cx, cy, R, 0, Math.PI * 2); ctx.clip();

  // Graticule every 30 degrees
  ctx.strokeStyle = 'rgba(255,255,255,0.10)'; ctx.lineWidth = 1;
  var step = Math.PI / 36, a, b, pt, prev;
  for(a = -60; a <= 60; a += 30){ var la = a * Math.PI / 180, cla = Math.cos(la), sla = Math.sin(la); ctx.beginPath(); prev = null;
    for(b = -Math.PI; b <= Math.PI + 1e-6; b += step){ pt = globeProject(b, cla, sla, sinLam, cosLam, sinPhi, cosPhi);
      if(pt.z > 0 && prev && prev.z > 0) ctx.lineTo(cx + R * pt.x, cy - R * pt.y); else ctx.moveTo(cx + R * pt.x, cy - R * pt.y); prev = pt; }
    ctx.stroke(); }
  for(b = -180; b < 180; b += 30){ var lo = b * Math.PI / 180; ctx.beginPath(); prev = null;
    for(a = -Math.PI / 2; a <= Math.PI / 2 + 1e-6; a += step){ pt = globeProject(lo, Math.cos(a), Math.sin(a), sinLam, cosLam, sinPhi, cosPhi);
      if(pt.z > 0 && prev && prev.z > 0) ctx.lineTo(cx + R * pt.x, cy - R * pt.y); else ctx.moveTo(cx + R * pt.x, cy - R * pt.y); prev = pt; }
    ctx.stroke(); }

  // Land: fill with back-side points pushed to the limb, then stroke only the front-facing edges.
  var rings = globeLand();
  ctx.fillStyle = 'rgba(255,255,255,0.13)'; ctx.strokeStyle = 'rgba(255,255,255,0.85)'; ctx.lineWidth = 1.1;
  var fillPath = new Path2D(), strokePath = new Path2D();
  rings.forEach(function(r){
    var n = r.n, anyFront = false, sx = new Float32Array(n), sy = new Float32Array(n), front = new Uint8Array(n);
    for(var i = 0; i < n; i++){
      var p = globeProject(r.lon[i], r.cl[i], r.sl[i], sinLam, cosLam, sinPhi, cosPhi);
      if(p.z > 0){ front[i] = 1; anyFront = true; sx[i] = cx + R * p.x; sy[i] = cy - R * p.y; }
      else { var len = Math.sqrt(p.x * p.x + p.y * p.y) || 1; sx[i] = cx + R * p.x / len; sy[i] = cy - R * p.y / len; }
    }
    if(!anyFront) return;
    fillPath.moveTo(sx[0], sy[0]);
    for(var j = 1; j < n; j++) fillPath.lineTo(sx[j], sy[j]);
    fillPath.closePath();
    for(var k = 0; k < n; k++){ var k2 = (k + 1) % n; if(front[k] && front[k2]){ strokePath.moveTo(sx[k], sy[k]); strokePath.lineTo(sx[k2], sy[k2]); } }
  });
  ctx.fill(fillPath, 'evenodd'); ctx.stroke(strokePath);

  // Terminator-style shading on the right edge for depth
  var shade = ctx.createRadialGradient(cx - R * 0.3, cy - R * 0.2, R * 0.6, cx, cy, R * 1.02);
  shade.addColorStop(0, 'rgba(0,0,0,0)'); shade.addColorStop(1, 'rgba(0,10,40,0.55)');
  ctx.fillStyle = shade; ctx.fillRect(cx - R, cy - R, R * 2, R * 2);
  ctx.restore();

  // Pins and labels
  var t = now / 1000, visible = [], facing = null, facingZ = 0;
  GLOBE.pins.forEach(function(p){
    var q = globeProject(p.lonR, p.cl, p.sl, sinLam, cosLam, sinPhi, cosPhi);
    p.vis = q.z > 0.02; p.z = q.z; p.sx = cx + R * q.x; p.sy = cy - R * q.y; p.alpha = Math.min(1, q.z * 2.2);
    if(p.vis){ visible.push(p); if(q.z > facingZ){ facingZ = q.z; facing = p; } }
  });
  // Stack labels that collide (same x band) so a region's rigs read as a column.
  visible.sort(function(a, b){ return a.sy - b.sy; });
  var placed = [];
  visible.forEach(function(p){
    ctx.font = '700 15px "Meta Pro", Arial, sans-serif';
    var line1 = p.g.rig, line2 = p.pct != null ? ('Argo Navis plan ' + p.pct.toFixed(0) + '%') : (statusShort(p.status));
    ctx.font = '700 15px "Meta Pro", Arial, sans-serif'; var w1 = ctx.measureText(line1).width;
    ctx.font = '700 11px "Meta Pro", Arial, sans-serif'; var w2 = ctx.measureText(line2).width;
    var w = Math.max(w1, w2) + 24, h = 44;
    var lx = p.sx + 18, ly = p.sy - h / 2;
    if(lx + w > GLOBE.cx + GLOBE.R + 140) lx = p.sx - 18 - w;
    placed.forEach(function(o){ if(lx < o.x + o.w && lx + w > o.x && ly < o.y + o.h + 6 && ly + h + 6 > o.y) ly = o.y + o.h + 6; });
    p.lx = lx; p.ly = ly; p.lw = w; p.lh = h; placed.push({x: lx, y: ly, w: w, h: h});
  });
  visible.forEach(function(p){
    ctx.globalAlpha = p.alpha;
    // leader
    ctx.strokeStyle = 'rgba(255,255,255,0.55)'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(p.sx, p.sy);
    var ax = p.lx > p.sx ? p.lx : p.lx + p.lw; ctx.lineTo(ax, p.ly + p.lh / 2); ctx.stroke();
    // pulse for a rig under maintenance
    if(p.maint){ var ph = (t % 1.6) / 1.6; ctx.beginPath(); ctx.arc(p.sx, p.sy, 10 + ph * 22, 0, Math.PI * 2); ctx.strokeStyle = 'rgba(226,83,3,' + (0.7 * (1 - ph)) + ')'; ctx.lineWidth = 3; ctx.stroke(); }
    // pin
    ctx.beginPath(); ctx.arc(p.sx, p.sy, 9, 0, Math.PI * 2); ctx.fillStyle = p.color; ctx.fill(); ctx.lineWidth = 2.5; ctx.strokeStyle = '#fff'; ctx.stroke();
    // label
    ctx.shadowColor = 'rgba(0,0,0,0.35)'; ctx.shadowBlur = 10; ctx.shadowOffsetY = 3;
    ctx.fillStyle = '#fff'; globeRoundRect(ctx, p.lx, p.ly, p.lw, p.lh, 6); ctx.fill();
    ctx.shadowColor = 'transparent'; ctx.shadowBlur = 0; ctx.shadowOffsetY = 0;
    ctx.fillStyle = '#002C77'; ctx.font = '700 15px "Meta Pro", Arial, sans-serif'; ctx.textBaseline = 'alphabetic'; ctx.fillText(p.g.rig, p.lx + 12, p.ly + 19);
    ctx.fillStyle = p.pct != null ? '#0a7' : '#5a6880'; ctx.font = '700 11px "Meta Pro", Arial, sans-serif'; ctx.fillText((p.pct != null ? 'Argo Navis plan ' + p.pct.toFixed(0) + '%' : statusShort(p.status)).toUpperCase(), p.lx + 12, p.ly + 35);
    ctx.globalAlpha = 1;
  });
  if(facing !== GLOBE.facing){
    GLOBE.facing = facing;
    var rows = document.querySelectorAll('#globeList .globe-row');
    for(var r = 0; r < rows.length; r++) rows[r].classList.toggle('facing', !!facing && GLOBE.pins[+rows[r].getAttribute('data-idx')] === facing);
  }
}
function globeRoundRect(ctx, x, y, w, h, r){ ctx.beginPath(); ctx.moveTo(x + r, y); ctx.arcTo(x + w, y, x + w, y + h, r); ctx.arcTo(x + w, y + h, x, y + h, r); ctx.arcTo(x, y + h, x, y, r); ctx.arcTo(x, y, x + w, y, r); ctx.closePath(); }

function globeActive(){ var pg = document.getElementById('tvPageGlobe'); return !!pg && pg.classList.contains('active') && !document.hidden && !GLOBE.disabled; }

function globeFrame(now){
  GLOBE.raf = null;
  if(!globeActive()) return;
  var dt = GLOBE.last ? Math.min(0.25, (now - GLOBE.last) / 1000) : 0;
  // Performance guard: a display that cannot draw a frame in 80 ms for 90 frames running hands over to the map.
  if(GLOBE.last && (now - GLOBE.last) > 80 && (now - GLOBE.last) < 2000) GLOBE.slowFrames++; else GLOBE.slowFrames = Math.max(0, GLOBE.slowFrames - 2);
  if(GLOBE.slowFrames > 90){ globeDisable('display too slow'); return; }
  GLOBE.last = now;
  var held = GLOBE.hovering || now < GLOBE.holdUntil;
  if(!held) GLOBE.lambda = ((GLOBE.lambda - GLOBE.degPerSec * dt) + 360) % 360; // the earth turns east, so the longitude facing us moves west
  globeDraw(now);
  GLOBE.raf = requestAnimationFrame(globeFrame);
}
function globeStart(){ if(!GLOBE.raf && globeActive()){ GLOBE.last = 0; GLOBE.raf = requestAnimationFrame(globeFrame); } }
function globeDisable(reason){
  GLOBE.disabled = true;
  var tab = document.getElementById('tabGlobe'); if(tab) tab.style.display = 'none';
  showTvPage('map');
  try { console.warn('Globe view off: ' + reason + ' - showing the map instead.'); } catch(e){}
}

(function(){
  var cv = document.getElementById('globeCanvas'); if(!cv) return;
  if(!cv.getContext || !cv.getContext('2d') || typeof Path2D === 'undefined'){ globeDisable('no canvas'); return; }
  function toStage(e){ var r = cv.getBoundingClientRect(); return {x: (e.clientX - r.left) * 1820 / r.width, y: (e.clientY - r.top) * 880 / r.height}; }
  function hit(pt){
    var pins = GLOBE.pins, best = null, bestD = 1e9;
    for(var i = 0; i < pins.length; i++){ var p = pins[i]; if(!p.vis) continue;
      var dx = pt.x - p.sx, dy = pt.y - p.sy, d = dx * dx + dy * dy;
      if(d <= 14 * 14 && d < bestD){ best = p; bestD = d; } }
    if(best) return best;
    for(var j = pins.length - 1; j >= 0; j--){ var q = pins[j]; if(q.vis && pt.x >= q.lx && pt.x <= q.lx + q.lw && pt.y >= q.ly && pt.y <= q.ly + q.lh) return q; }
    return null;
  }
  cv.addEventListener('mouseenter', function(){ GLOBE.hovering = true; });
  cv.addEventListener('mouseleave', function(){ GLOBE.hovering = false; GLOBE.holdUntil = performance.now() + 10000; });
  cv.addEventListener('mousemove', function(e){ cv.style.cursor = hit(toStage(e)) ? 'pointer' : 'default'; });
  cv.addEventListener('click', function(e){ var p = hit(toStage(e)); if(p) openRigModal(slug(p.g.rig)); });
  cv.addEventListener('touchstart', function(){ GLOBE.holdUntil = performance.now() + 10000; }, {passive: true});
  document.addEventListener('visibilitychange', function(){ if(!document.hidden) globeStart(); });
  var want = new URLSearchParams(location.search).get('view');
  if(want === 'map' || want === 'tiles') showTvPage(want);
