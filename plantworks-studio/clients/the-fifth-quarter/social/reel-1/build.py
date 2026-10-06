import subprocess, os
from PIL import Image
import imageio_ffmpeg; FF=imageio_ffmpeg.get_ffmpeg_exe()  # pip install imageio-ffmpeg pillow
SEG=2.3; FADE=0.4; END=3.6; FPS=30
def run(args):
    r=subprocess.run([FF,'-hide_banner','-loglevel','error','-y']+args,capture_output=True,text=True)
    if r.returncode: print(r.stderr); raise SystemExit(1)
segs=[]
for i in range(1,15):
    w,h=Image.open(f'panels/p{i:02d}.png').size
    H=min(round(1080*h/w/2)*2,720)
    n=int(SEG*FPS)
    z = f"1+0.0011*on" if i%2 else f"1.08-0.0011*on"
    y = 452 + (720-H)//2
    out=f'segs/s{i:02d}.mp4'
    run(['-i',f'panels/p{i:02d}.png','-loop','1','-i','layers/bg.png','-filter_complex',
         f"[0:v]scale=2160:-2:flags=lanczos,crop=2160:'min(ih,{H*2})',zoompan=z='{z}':d={n}:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1080x{H}:fps={FPS},unsharp=5:5:0.6:5:5:0,eq=saturation=0.92,noise=alls=9:allf=t,vignette=PI/5[img];"
         f"[1:v][img]overlay=0:{y}:shortest=1,format=yuv420p[v]",
         '-map','[v]','-frames:v',str(n),'-r',str(FPS),'-c:v','libx264','-preset','medium','-crf','16',out])
    segs.append((out,SEG))
# end card: slow push, grain, fade from black handled by xfade
n=int(END*FPS)
run(['-i','layers/end.png','-filter_complex',
     f"[0:v]scale=2160:-2:flags=lanczos,zoompan=z='1+0.0004*on':d={n}:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1080x1920:fps={FPS},noise=alls=6:allf=t,vignette=PI/6,format=yuv420p[v]",
     '-map','[v]','-frames:v',str(n),'-c:v','libx264','-preset','medium','-crf','16','segs/s15.mp4'])
segs.append(('segs/s15.mp4',END))
# crossfade chain
inputs=[]; 
for f,_ in segs: inputs+=['-i',f]
fc=[]; prev='[0:v]'; t=0
for k in range(1,len(segs)):
    t+=segs[k-1][1]-FADE
    lab=f'[x{k}]'
    fc.append(f"{prev}[{k}:v]xfade=transition=fade:duration={FADE}:offset={t:.2f}{lab}")
    prev=lab
total=t+segs[-1][1]
fc.append(f"{prev}fade=t=in:st=0:d=0.5,fade=t=out:st={total-0.6:.2f}:d=0.6,format=yuv420p[v]")
run(inputs+['-f','lavfi','-t',f'{total:.2f}','-i','anullsrc=r=48000:cl=stereo','-filter_complex',';'.join(fc),
     '-map','[v]','-map',f'{len(segs)}:a','-c:v','libx264','-preset','slow','-crf','20','-profile:v','high','-pix_fmt','yuv420p',
     '-c:a','aac','-b:a','128k','-shortest','-movflags','+faststart','-r',str(FPS),'fifth-quarter-reel-1.mp4'])
print('total', round(total,2), 's')
