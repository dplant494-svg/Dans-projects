var REGION_ANCHORS = {
  'GOM':      {lat:25.5, lon:-90.5, name:'Gulf of Mexico'},
  'Angola':   {lat:-9.0, lon:8.0,   name:'Angola'},
  'Brazil':   {lat:-24.5, lon:-40.0, name:'Brazil'},
  'Namibia':  {lat:-23.5, lon:12.5,  name:'Namibia'},   // 12 Oct 2026 (Dan): West Carina is offshore Namibia now; the BWM tracker's Location column drives the pin
  'Malaysia': {lat:6.5,  lon:112.0, name:'Malaysia'}
};

// Equirectangular projection of the crop window (lon -105..135, lat -50..55) onto the
// fixed 1820x880 map stage — must match the window used to pre-project WORLD_PATHS.
var MAPV = { LON0:-105, LON1:135, LAT0:-50, LAT1:55, W:1820, H:880 };
function projX(lon){ return (lon - MAPV.LON0) * MAPV.W / (MAPV.LON1 - MAPV.LON0); }
function projY(lat){ return (MAPV.LAT1 - lat) * MAPV.H / (MAPV.LAT1 - MAPV.LAT0); }

// Hand-tuned label-column origins (in stage px) so each region's callouts sit in clear space.
// Any region not listed falls back to a column just right of its pins.
var LABEL_LAYOUT = {
  'GOM':      {x:200,  y:80},
  'Brazil':   {x:640,  y:472},
  'Angola':   {x:952,  y:400},
  'Namibia':  {x:952,  y:640},
