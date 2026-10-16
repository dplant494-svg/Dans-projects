function bopDeckLabel(status){ return status === 'Deployed' ? 'Deployed' : 'On Deck'; }

function mapLabelHtml(g){
  var multi = g.rows.length > 1;
  var bops = g.rows.map(function(row){
    return '<div class="ml-bop"><span class="ml-dot" style="background:' + statusColor(row.status) + '"></span>' +
      (multi ? ('BOP ' + row.bop + ' &middot; ') : 'BOP &middot; ') + bopDeckLabel(row.status) + '</div>';
  }).join('');
  return '<div class="ml-rig">' + g.rig + '</div>' + bops;
}

function renderWorldMap(fleet){
  var stage = document.getElementById('mapStage');
  var svg = document.getElementById('mapSvg');
  stage.querySelectorAll('.map-label, .map-region-name').forEach(function(el){ el.remove(); });

  var groups = groupByVessel(fleet);
  var byRegion = {};
  groups.forEach(function(g){ var loc = g.rows[0].location; (byRegion[loc] = byRegion[loc] || []).push(g); });

  // One pin per rig, spread on a small golden-angle spiral around the region anchor.
  var pins = [];
  Object.keys(byRegion).forEach(function(region){
    var anchor = REGION_ANCHORS[region] || {lat:0, lon:0, name:region};
    byRegion[region].forEach(function(g, i){
      var angle = i * 2.399963;
      var radius = 1.4 * Math.sqrt(i);
      pins.push({
        g: g, region: region,
        x: projX(anchor.lon + radius * Math.cos(angle)),
        y: projY(anchor.lat + radius * Math.sin(angle)),
        status: headlineStatus(g.rows)
      });
    });
  });

  // Pass 1: insert labels off-screen and measure their real heights (1 vs 2 BOP lines).
  var labelHtml = pins.map(function(pin, i){
    return '<div class="map-label" data-idx="' + i + '" style="left:-9999px; top:0" ' +
      'onclick="openRigModal(\'' + slug(pin.g.rig) + '\')">' + mapLabelHtml(pin.g) + '</div>';
  }).join('');
  stage.insertAdjacentHTML('beforeend', labelHtml);
  pins.forEach(function(pin, i){
    pin.el = stage.querySelector('.map-label[data-idx="' + i + '"]');
    pin.h = pin.el.offsetHeight;
    pin.w = pin.el.offsetWidth;
  });

  // Pass 2: stack each region's labels in a column (ordered by pin latitude so leader
  // lines fan out without crossing), then position + draw.
  var LABEL_GAP = 10, captions = [];
  Object.keys(byRegion).forEach(function(region){
    var regionPins = pins.filter(function(p){ return p.region === region; })
      .sort(function(a,b){ return a.y - b.y; });
    var layout = LABEL_LAYOUT[region] ||
      {x: Math.min(projX((REGION_ANCHORS[region]||{lon:0}).lon) + 60, MAPV.W - 190), y: 80};
    var curY = layout.y;
    regionPins.forEach(function(p){
      p.labelX = layout.x;
      p.labelY = curY;
      curY += p.h + LABEL_GAP;
    });
    captions.push({name: (REGION_ANCHORS[region]||{name:region}).name, x: layout.x, y: layout.y - 24});
  });

  pins.forEach(function(pin){
    pin.el.style.left = pin.labelX.toFixed(1) + 'px';
    pin.el.style.top = pin.labelY.toFixed(1) + 'px';
  });
  captions.forEach(function(c){
    stage.insertAdjacentHTML('beforeend',
      '<div class="map-region-name" style="left:' + c.x + 'px; top:' + c.y + 'px">' + c.name + '</div>');
  });

  // SVG: countries, then leader lines, then pins on top.
  var parts = [];
  WORLD_PATHS.forEach(function(d){ parts.push('<path class="map-country" fill-rule="evenodd" d="' + d + '"/>'); });
  pins.forEach(function(pin){
    var toLeft = pin.x < pin.labelX; // attach the line to whichever label edge faces the pin
    var ax = toLeft ? pin.labelX : pin.labelX + pin.w;
    var ay = pin.labelY + pin.h / 2;
