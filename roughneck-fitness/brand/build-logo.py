import sys, os
from fontTools.ttLib import TTFont
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
F='/tmp/claude-0/-home-user-Dans-projects/63e0b644-232e-5671-b2bc-57a92e161ebf/scratchpad/fonts-rn/'
fonts={w:TTFont(F+f'bc{w}.ttf') for w in (800,600)}
def text(w,s,size,x,y,track=0):
    f=fonts[w];gs=f.getGlyphSet();cmap=f.getBestCmap();upm=f['head'].unitsPerEm;sc=size/upm
    pen=SVGPathPen(gs);cx=0
    for ch in s:
        g=cmap[ord(ch)]
        tp=TransformPen(pen,(sc,0,0,-sc,x+cx,y));gs[g].draw(tp)
        cx+=gs[g].width*sc+track
    return pen.getCommands(), cx-track
MARK=['M48 42H545L677 165V262L528 405L436 319L547 225V190L518 160H164Z','M189 188H331L722 574H546Z','M348 355H492L277 574H118Z','M232 292L288 348L56 566V455Z']
TRI='M56 136L188 266L56 392Z'
K=138/674
MH=532*K
def mark(dx,dy,s,ink,acc):
    t=f'transform="translate({dx} {dy}) scale({s*K}) translate(-48 -42)"'
    return f'<g {t}><path fill="{ink}" d="{" ".join(MARK)}"/><path fill="{acc}" d="{TRI}"/></g>'
def stacked(ink,acc,sub,bg=None):
    # wordmark
    d1,w1=text(800,'ROUGHNECK',100,0,0,2)
    d2,w2=text(600,'FITNESS',40,0,0,14)
    W=w1; mw=138*1.25
    out=[]
    if bg: out.append(f'<rect x="-40" y="-40" width="{W+80}" height="{125+30+100+20+40+80}" fill="{bg}"/>')
    out.append(mark((W-mw)/2,0,1.25,ink,acc))
    out.append(f'<path fill="{ink}" d="{d1}" transform="translate(0 {MH*1.25+30+72})"/>')
    yb=MH*1.25+30+72+20+40
    x2=(W-w2)/2
    out.append(f'<path fill="{sub}" d="{d2}" transform="translate({x2} {yb})"/>')
    out.append(f'<rect fill="{sub}" x="{x2-60}" y="{yb-16}" width="40" height="4"/><rect fill="{sub}" x="{x2+w2+20}" y="{yb-16}" width="40" height="4"/>')
    H=yb+10
    vb=f'-40 -40 {W+80} {H+80}' if bg else f'-4 -4 {W+8} {H+8}'
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{vb}" role="img" aria-label="Roughneck Fitness">{"".join(out)}</svg>'
def horizontal(ink,acc,sub):
    d1,w1=text(800,'ROUGHNECK',70,0,0,1.5)
    d2,w2=text(600,'FITNESS',28,0,0,10)
    mh=MH*0.9; x0=138*0.9+28
    out=[mark(0,0,0.9,ink,acc)]
    out.append(f'<path fill="{ink}" d="{d1}" transform="translate({x0} {mh*0.56})"/>')
    out.append(f'<path fill="{sub}" d="{d2}" transform="translate({x0+2} {mh*0.95})"/>')
    W=x0+w1
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="-4 -4 {W+8} {mh+8}" role="img" aria-label="Roughneck Fitness">{"".join(out)}</svg>'
def markonly(ink,acc):
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="-2 -2 142 {MH+4:.1f}" role="img" aria-label="Roughneck Fitness">{mark(0,0,1,ink,acc)}</svg>'
o=sys.argv[1]; os.makedirs(o,exist_ok=True)
STEEL,ORANGE,CHALK='#14171A','#FF6A13','#E8E4DC'
files={
 'logo-stacked-colour.svg':stacked(STEEL,ORANGE,ORANGE),
 'logo-stacked-reversed.svg':stacked(CHALK,ORANGE,ORANGE),
 'logo-stacked-black.svg':stacked(STEEL,STEEL,STEEL),
 'logo-stacked-chalk.svg':stacked(CHALK,CHALK,CHALK),
 'logo-horizontal-colour.svg':horizontal(STEEL,ORANGE,ORANGE),
 'logo-horizontal-reversed.svg':horizontal(CHALK,ORANGE,ORANGE),
 'mark-colour.svg':markonly(STEEL,ORANGE),
 'mark-reversed.svg':markonly(CHALK,ORANGE),
 'mark-black.svg':markonly(STEEL,STEEL),
 'mark-chalk.svg':markonly(CHALK,CHALK),
 'mark-orange.svg':markonly(ORANGE,ORANGE),
}
for n,s in files.items(): open(os.path.join(o,n),'w').write(s)
print(len(files),'files')
