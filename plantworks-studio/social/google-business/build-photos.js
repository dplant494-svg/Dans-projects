const {chromium}=require('playwright');const fs=require('fs');const S=process.argv[2],O=process.argv[3];
const d=f=>'data:image/png;base64,'+fs.readFileSync(S+'/'+f).toString('base64');
const css=`*{box-sizing:border-box;margin:0}body{width:var(--w);height:var(--h);background:radial-gradient(120% 90% at 80% 20%,#22324A 0%,#16202B 55%,#111821 100%);font-family:'IBM Plex Sans',sans-serif;color:#F4EEE3;position:relative;overflow:hidden}
.grid{position:absolute;inset:0;background-image:linear-gradient(rgba(244,238,227,.035) 1px,transparent 1px),linear-gradient(90deg,rgba(244,238,227,.035) 1px,transparent 1px);background-size:48px 48px}
.k{font-family:'IBM Plex Mono',monospace;letter-spacing:.24em;font-size:15px;color:#E8833A;text-transform:uppercase}
h1{font-family:Fraunces,serif;font-weight:600;font-size:52px;line-height:1.05;margin-top:14px}h1 em{font-style:italic;color:#E8A56E;font-weight:500}
p.s{margin-top:14px;font-size:20px;color:#C9CED6;line-height:1.45}
.brand{position:absolute;left:64px;bottom:48px;font-family:'IBM Plex Mono',monospace;letter-spacing:.2em;font-size:14px;color:#E8833A}
.laptop{position:absolute}.laptop .scr{border:14px solid #0B0E12;border-bottom-width:18px;border-radius:18px 18px 4px 4px;aspect-ratio:16/10;background-size:cover;background-position:top center;box-shadow:0 30px 80px rgba(0,0,0,.45)}
.laptop .base{height:20px;margin:0 -7%;background:linear-gradient(#D7DADF,#9EA3AA);border-radius:2px 2px 16px 16px}
.phone{position:absolute;border:11px solid #0B0E12;border-radius:38px;aspect-ratio:9/19.5;background-size:cover;background-position:top center;box-shadow:0 30px 70px rgba(0,0,0,.55)}`;
const fonts=`<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fraunces:ital,wght@0,500;0,600;1,500&family=IBM+Plex+Mono:wght@500&family=IBM+Plex+Sans:wght@400&display=swap">`;
const work=(k,title,sub,desk,mob)=>`<div class="grid"></div><div style="position:absolute;left:64px;top:64px;width:1080px"><div class="k">${k}</div><h1>${title}</h1><p class="s">${sub}</p></div>
<div class="laptop" style="left:120px;top:290px;width:760px"><div class="scr" style="background-image:url(${d(desk)})"></div><div class="base"></div></div>
<div class="phone" style="left:830px;top:330px;width:220px;background-image:url(${d(mob)})"></div><div class="brand" style="left:auto;right:64px;top:72px;bottom:auto">PLANTWORKSSTUDIO.COM</div>`;
const pages={
'plantworks-01-cover.png':[1600,900,`<div class="grid"></div><div style="position:absolute;left:90px;top:200px;width:620px"><div class="k">Web studio · UK &amp; Costa del Sol</div><h1 style="font-size:66px">Websites for small businesses, <em>engineered not to fail.</em></h1><p class="s" style="font-size:24px">Bilingual English &amp; Spanish · Free consultation</p></div>
<div class="laptop" style="left:800px;top:190px;width:700px"><div class="scr" style="background-image:url(${d('fq-desk.png')})"></div><div class="base"></div></div>
<div class="phone" style="left:1350px;top:330px;width:190px;background-image:url(${d('pw-mob.png')})"></div><div class="brand" style="left:90px;bottom:70px">PLANTWORKSSTUDIO.COM</div>`],
'plantworks-02-the-fifth-quarter.png':[1200,900,work('Client · Live','The Fifth Quarter','Restaurant, bar &amp; delicatessen · County Durham, UK','fq-desk.png','fq-mob.png')],
'plantworks-03-brasa-y-sal.png':[1200,900,work('Concept · Restaurant','Brasa y Sal','Bilingual restaurant site · English &amp; Spanish','brasa-desk.png','brasa-mob.png')],
'plantworks-04-pinar-property.png':[1200,900,work('Concept · Property services','Pinar Property Care','Property management site for owners abroad','pinar-desk.png','pinar-mob.png')],
'plantworks-05-bilingual.png':[1200,900,`<div class="grid"></div><div style="position:absolute;left:64px;top:64px;width:1080px"><div class="k">English &amp; Spanish</div><h1>One site, <em>two languages,</em> done properly.</h1><p class="s">Written in both languages, set up so Google shows the right one.</p></div>
<div class="phone" style="left:300px;top:310px;width:250px;background-image:url(${d('pw-mob.png')})"></div><div class="phone" style="left:650px;top:310px;width:250px;background-image:url(${d('pwes-mob.png')})"></div>
<div style="position:absolute;left:300px;top:860px;width:250px;text-align:center" class="k">EN</div><div style="position:absolute;left:650px;top:860px;width:250px;text-align:center" class="k">ES</div>`]};
(async()=>{const b=await chromium.launch();
for(const [f,[w,h,body]] of Object.entries(pages)){const p=await b.newPage({viewport:{width:w,height:h}});
await p.setContent(`<!doctype html><html><head>${fonts}<style>:root{--w:${w}px;--h:${h}px}${css}</style></head><body>${body}</body></html>`,{waitUntil:'networkidle'});await p.evaluate(()=>document.fonts.ready);
await p.screenshot({path:O+'/'+f,type:'png'});await p.close();}
await b.close();})();
