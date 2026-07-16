// Regenerates WORLD_PATHS for bop-dashboard/dashboard.html (see the
// BOP dashboard handoff): Natural Earth 110m country outlines, pre-projected
// equirectangular onto the 1820x880 map stage, crop lon -105..135 / lat -50..55.
// Usage: npm i world-atlas topojson-client && node tools/build_world.js
// The runtime projection constants (MAPV, projX/projY) in the dashboard MUST
// match LON0/LON1/LAT0/LAT1/W/H below.
const fs = require('fs');
const topojson = require('topojson-client');
const topo = JSON.parse(fs.readFileSync('./node_modules/world-atlas/countries-110m.json'));
const geo = topojson.feature(topo, topo.objects.countries);
const LON0=-105, LON1=135, LAT0=-50, LAT1=55, W=1820, H=880;
const sx = W/(LON1-LON0), sy = H/(LAT1-LAT0);
const px = lon => ((lon-LON0)*sx), py = lat => ((LAT1-lat)*sy);
function ringInWindow(ring){
  let minLon=999,maxLon=-999,minLat=999,maxLat=-999;
  for(const p of ring){ if(p[0]<minLon)minLon=p[0]; if(p[0]>maxLon)maxLon=p[0];
    if(p[1]<minLat)minLat=p[1]; if(p[1]>maxLat)maxLat=p[1]; }
  return !(maxLat<LAT0-3 || minLat>LAT1+3 || maxLon<LON0-3 || minLon>LON1+3);
}
function ringPath(ring){
  let d='', last=null;
  ring.forEach((pt,i)=>{
    const x=+px(pt[0]).toFixed(1), y=+py(pt[1]).toFixed(1);
    if(i===0){ d+='M'+x+' '+y; last=[x,y]; return; }
    if(Math.abs(x-last[0])<0.6 && Math.abs(y-last[1])<0.6) return;
    d+='L'+x+' '+y; last=[x,y];
  });
  return d+'Z';
}
const paths=[];
geo.features.forEach(f=>{
  if(!f.geometry) return;
  const polys = f.geometry.type==='Polygon' ? [f.geometry.coordinates] : f.geometry.coordinates;
  let d=''; polys.forEach(poly=>poly.forEach(ring=>{ if(ringInWindow(ring)) d+=ringPath(ring); }));
  if(d) paths.push(d);
});
fs.writeFileSync('world_paths.js', 'var WORLD_PATHS = ' + JSON.stringify(paths) + ';');
console.log('wrote world_paths.js with', paths.length, 'country paths');
