const {chromium}=require('playwright');const fs=require('fs');const B=process.argv[2];
const mk=c=>{let s=fs.readFileSync(B+'/mark-'+c+'.svg','utf8');return s.replace(/<svg[^>]*>/,'').replace('</svg>','');};
const MARK=(x,y,w,c='reversed')=>`<svg x="${x}" y="${y}" width="${w}" height="${w*113/142}" viewBox="-2 -2 142 113">${mk(c)}</svg>`;
const F="font-family:'Barlow Condensed';font-weight:800";
const card=(title,sub,svg)=>`<div class="card"><svg viewBox="0 0 400 440" width="100%">${svg}</svg><div class="t">${title}</div><div class="s">${sub}</div></div>`;
const hoodie=`
<path fill="#22272D" d="M148 98 C146 28 254 28 252 98 Z"/>
<path fill="#16191C" d="M150 80 L110 92 L58 122 L30 330 L26 398 L72 402 L82 300 L98 205 L100 418 L300 418 L302 205 L318 300 L328 402 L374 398 L370 330 L342 122 L290 92 L250 80 C232 94 168 94 150 80 Z"/>
<rect x="100" y="400" width="200" height="18" fill="#101214"/><path fill="#101214" d="M26 384 L72 388 L72 402 L26 398Z M328 388 L374 384 L374 398 L328 402Z"/>
${MARK(166,120,68)}
<text x="200" y="226" text-anchor="middle" style="${F};font-size:25px;letter-spacing:2px" fill="#E8E4DC">TRAIN SMARTER</text>
<text x="200" y="256" text-anchor="middle" style="${F};font-size:25px;letter-spacing:2px" fill="#FF6A13">AND</text>
<text x="200" y="286" text-anchor="middle" style="${F};font-size:25px;letter-spacing:2px" fill="#E8E4DC">HARDER</text>
<text x="200" y="316" text-anchor="middle" style="font-family:'Barlow Condensed';font-weight:600;font-size:12px;letter-spacing:4px" fill="#9AA0A8">ROUGHNECK FITNESS</text>`;
const teeShape=`<path fill="#16191C" d="M142 60 L96 74 L40 112 L66 168 L102 152 L102 404 L298 404 L298 152 L334 168 L360 112 L304 74 L258 60 C246 82 154 82 142 60 Z"/>`;
const teeF=`${teeShape}<path fill="none" stroke="#2A2F35" stroke-width="5" d="M142 62 C152 90 248 90 258 62"/>${MARK(232,128,44)}`;
const teeB=`${teeShape}<path fill="none" stroke="#2A2F35" stroke-width="4" d="M146 62 C160 72 240 72 254 62"/>
${MARK(186,96,28)}
<text x="200" y="196" text-anchor="middle" style="${F};font-size:16px;letter-spacing:1.2px" fill="#E8E4DC">DO WHAT YOU'RE TOLD.</text>
<text x="200" y="222" text-anchor="middle" style="${F};font-size:16px;letter-spacing:1.2px" fill="#FF6A13">FOLLOW THE PROCESS.</text>`;
const cap=`
<path fill="#16191C" d="M70 250 C66 130 140 78 210 78 C280 78 352 130 348 250 Z"/>
<path fill="none" stroke="#24292F" stroke-width="2" d="M210 80 L210 250 M140 100 C120 150 115 200 118 250 M280 100 C300 150 305 200 302 250"/>
<circle cx="210" cy="80" r="7" fill="#22272D"/>
<path fill="#101214" d="M58 246 C110 330 310 330 362 246 C312 276 108 276 58 246 Z"/>
${MARK(162,148,96,'orange')}`;
const shaker=`
<rect x="130" y="40" width="140" height="56" rx="10" fill="#22272D"/><rect x="185" y="22" width="40" height="22" rx="6" fill="#22272D"/>
<path fill="#16191C" d="M134 96 H266 L256 410 C256 420 248 426 238 426 H162 C152 426 144 420 144 410 Z"/>
${MARK(172,112,56)}
<g transform="translate(207 284) rotate(-90)"><text text-anchor="middle" style="${F};font-size:16px;letter-spacing:2.5px" fill="#E8E4DC">TRAIN SMARTER <tspan fill="#FF6A13">AND</tspan> HARDER</text></g>`;

(async()=>{const b=await chromium.launch();const p=await b.newPage({viewport:{width:1500,height:520}});
await p.setContent(`<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@600;800&display=swap">
<style>body{margin:0;background:#E8E4DC;font-family:'Barlow Condensed',sans-serif;padding:40px}
h1{margin:0 0 6px;font-weight:800;letter-spacing:.08em;color:#14171A;font-size:34px}p.h{margin:0 0 26px;color:#5b6168;letter-spacing:.12em;font-size:16px;text-transform:uppercase}
.g{display:grid;grid-template-columns:repeat(5,1fr);gap:22px}.card{background:#F3F0EA;padding:18px 14px 20px;border:1px solid #d6d1c6}
.t{font-weight:800;letter-spacing:.1em;color:#14171A;font-size:19px;text-transform:uppercase;margin-top:6px}.s{color:#5b6168;font-size:15px;letter-spacing:.04em}</style>
<h1>ROUGHNECK FITNESS · DROP 01</h1><p class="h">Train smarter <b style="color:#FF6A13">and</b> harder</p>
<div class="g">${card('Hoodie · back','Slogan back print, mark on chest',hoodie)}${card('Heavyweight tee · front','Mark on left chest',teeF)}${card('Heavyweight tee · back','Coaching ethos, credited to the system',teeB)}${card('Cap','Mark embroidered in safety orange',cap)}${card('Shaker','Mark and slogan',shaker)}</div>`,{waitUntil:'networkidle'});
await p.evaluate(()=>document.fonts.ready);
await p.screenshot({path:B+'/merch/drop-01-mockups.png',fullPage:true});await b.close();})();
