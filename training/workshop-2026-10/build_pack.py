"""Build the WCE workshop pack (19-22 Oct 2026): PDFs from the Markdown sources, plus every file Dan needs, in one folder and one zip.

Run:  python3 training/workshop-2026-10/build_pack.py   (needs: markdown, chromium at /opt/pw-browsers/chromium)
"""
import base64, os, re, shutil, subprocess, sys, zipfile
import markdown

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
HERE = os.path.join(ROOT, 'training', 'workshop-2026-10')
SRC = os.path.join(HERE, 'pack-src')
D1 = os.path.join(ROOT, 'tools', 'received', 'training', 'day1-2026-10-16')
SHOT_DIRS = [os.path.join(D1, 'screenshots-169'), os.path.join(D1, 'screenshots-163'),
             os.path.join(ROOT, 'tools', 'received', 'training', 'day1', 'screenshots')]
PRE = os.path.join(ROOT, 'tools', 'received', 'training', 'precharge')
OUT_NAME = 'WCE-Workshop-Pack-2026-10-19'
OUT = os.path.join(HERE, OUT_NAME)
CHROME = '/opt/pw-browsers/chromium'
TMP = os.environ.get('PACK_TMP', '/tmp/wce-pack-build')

CSS = """
@page { size: A4; margin: 16mm 15mm 18mm 15mm; }
body { font-family: 'Segoe UI', Arial, sans-serif; font-size: 10.5pt; color: #1F2D3D; line-height: 1.38; }
h1 { color: #002C77; font-size: 19pt; border-bottom: 3px solid #EDB71E; padding-bottom: 4px; margin: 0 0 10px; page-break-before: always; }
h1.first, .cover + h1 { page-break-before: auto; }
h2 { color: #002C77; font-size: 13.5pt; margin: 16px 0 6px; page-break-after: avoid; }
h3 { color: #0082C0; font-size: 11.5pt; margin: 12px 0 4px; page-break-after: avoid; }
table { border-collapse: collapse; width: 100%; margin: 6px 0 10px; font-size: 9.5pt; page-break-inside: auto; }
th { background: #002C77; color: #fff; text-align: left; padding: 4px 6px; }
td { border-bottom: 1px solid #d5dde6; padding: 4px 6px; vertical-align: top; }
tr:nth-child(even) td { background: #F4F7FA; }
code { font-family: Consolas, monospace; font-size: 9pt; background: #eef2f6; padding: 0 3px; border-radius: 2px; word-break: break-all; }
pre { background: #eef2f6; padding: 6px 8px; white-space: pre-wrap; font-size: 9pt; }
blockquote { border-left: 4px solid #0082C0; background: #F4F7FA; margin: 6px 0; padding: 4px 10px; }
img.shot { display: block; max-width: 100%; max-height: 105mm; margin: 6px auto 10px; border: 1px solid #b7c3d6; page-break-inside: avoid; }
.shotcap { text-align: center; font-size: 8.5pt; color: #5a6b80; margin-top: -6px; margin-bottom: 10px; }
.cover { height: 250mm; display: flex; flex-direction: column; justify-content: center; page-break-after: always; }
.cover .t1 { color: #0082C0; font-size: 12pt; letter-spacing: 2px; text-transform: uppercase; }
.cover .t2 { color: #002C77; font-size: 30pt; font-weight: bold; margin: 8px 0; border-bottom: 4px solid #EDB71E; padding-bottom: 8px; }
.cover .t3 { font-size: 13pt; margin-top: 10px; }
.cover .name { margin-top: 40px; font-size: 13pt; }
.line { border-bottom: 1px solid #8a99ad; height: 22px; margin: 4px 0; }
li { margin: 2px 0; }
hr { border: 0; border-top: 1px solid #d5dde6; margin: 12px 0; }
"""


def shot_path(sid):
    m = re.match(r'(\d+)(.*)', sid)
    if m:
        sid = '%02d%s' % (int(m.group(1)), m.group(2))
    for d in SHOT_DIRS:
        if os.path.isdir(d):
            for f in sorted(os.listdir(d)):
                if f.lower().startswith(sid.lower() + '-') and f.endswith('.png'):
                    return os.path.join(d, f)
    return None


def shots_to_html(text, label=True):
    def rep(m):
        sid = m.group(1)
        p = shot_path(sid)
        if not p:
            return m.group(0)
        b64 = base64.b64encode(open(p, 'rb').read()).decode()
        return (('`[SHOT %s]`' % sid if label else '') + '<img class="shot" src="data:image/png;base64,%s" alt="Screen %s">' % (b64, sid))
    return re.sub(r'`?\[SHOT ([0-9]+[a-z]?)\]`?', rep, text)


def imgs_to_html(text):
    def rep(m):
        p = os.path.join(ROOT, m.group(1).strip())
        if not os.path.exists(p):
            return m.group(0)
        ext = 'jpeg' if p.lower().endswith(('.jpg', '.jpeg')) else 'png'
        b64 = base64.b64encode(open(p, 'rb').read()).decode()
        return '<img class="shot" src="data:image/%s;base64,%s">' % (ext, b64)
    return re.sub(r'`?\[IMG ([^\]]+)\]`?', rep, text)


def md_html(text):
    text = text.replace('- [ ]', '- ☐').replace('- [x]', '- ☑')
    return markdown.markdown(text, extensions=['tables', 'fenced_code', 'sane_lists'])


def strip_answers(text):
    """Workbook copy of a Q&A file: drop the '>' answer blocks, leave three answer lines."""
    out, in_ans = [], False
    for line in text.split('\n'):
        if line.startswith('>'):
            if not in_ans:
                out.append('<div class="line"></div><div class="line"></div><div class="line"></div>')
                in_ans = True
            continue
        in_ans = False
        out.append(line)
    t = '\n'.join(out)
    t = t.replace('Answers are for the trainer\'s copy; the trainee\nworkbook carries the questions and the blank lines only.', '')
    return t.replace(', with answers', '').replace('with answers', '')


def cover(t1, t2, t3, name=False):
    n = '<div class="name">Name: ______________________________ &nbsp; Rig: __________________</div>' if name else ''
    return '<div class="cover"><div class="t1">%s</div><div class="t2">%s</div><div class="t3">%s</div>%s</div>' % (t1, t2, t3, n)


def to_pdf(html_body, out_pdf, title, landscape=False):
    os.makedirs(TMP, exist_ok=True)
    css = CSS.replace('size: A4;', 'size: A4 landscape;') if landscape else CSS
    h = '<!doctype html><html><head><meta charset="utf-8"><title>%s</title><style>%s</style></head><body>%s</body></html>' % (title, css, html_body)
    tmp = os.path.join(TMP, os.path.basename(out_pdf) + '.html')
    open(tmp, 'w', encoding='utf-8').write(h)
    subprocess.run([CHROME, '--headless', '--no-sandbox', '--disable-gpu', '--no-pdf-header-footer',
                    '--print-to-pdf=' + out_pdf, 'file://' + tmp], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=180)
    if not os.path.exists(out_pdf):
        sys.exit('PDF not written: ' + out_pdf)


def read(p):
    return open(p, encoding='utf-8').read()


def first_h1(html):
    return html.replace('<h1>', '<h1 class="first">', 1)


def main():
    if os.path.isdir(OUT):
        shutil.rmtree(OUT)
    os.makedirs(OUT)

    # --- 00 Dan's guide
    to_pdf(first_h1(md_html(read(os.path.join(SRC, 'START-HERE-DAN.md')))), os.path.join(OUT, '00-START-HERE-Dan.pdf'), 'Start here')
    shutil.copy(os.path.join(SRC, 'START-HERE-DAN.md'), os.path.join(OUT, '00-START-HERE-Dan.md'))

    # --- 01 agenda (already built)
    shutil.copy(os.path.join(HERE, 'WCE-Workshop-Joining-Instructions-and-Agenda.pdf'), os.path.join(OUT, '01-Joining-Instructions-and-Agenda.pdf'))

    # --- 02 presenter's script, both days (Day 1 Module 4 replaced by the run-through)
    body = cover('WCE SME Workshop · Houston · 19–20 October 2026', "Presenter's script", 'Day 1: the reporting tools · Day 2: precharge, the SACRED dashboards, Argo Navis, the loop<br><br>Demonstration and follow-along: the delegates post nothing<br>Frozen builds: WCGRRT REV 174 · SSORT REV 169 · Argo Navis REV 16 · scanner v3.11<br>Dan Plant, Technical Services – Subsea')
    body += md_html(read(os.path.join(SRC, 'TRAINER-FRONT.md')))
    d1 = read(os.path.join(D1, '02-Walkthrough-Scripts.md'))
    d1 = d1[:d1.index('# Module 4')] + read(os.path.join(SRC, 'DAY1-MODULE4-RUNTHROUGH.md'))
    body += md_html(shots_to_html(d1))
    qa = read(os.path.join(D1, '04-Questions-and-Answers.md')).replace('# Day 1 workbook questions', '# Day 1: questions the room may ask')
    body += md_html(qa)
    body += md_html(imgs_to_html(read(os.path.join(SRC, 'DAY2-TRAINER-SCRIPT.md'))))
    to_pdf(body, os.path.join(OUT, '02-Presenter-Script-Day1-and-Day2.pdf'), "Presenter's script")

    # --- 03 the Training Manual (every how-to guide), one per delegate
    body = cover('WCE SME Workshop · Houston · 19–20 October 2026', 'Training Manual', 'How-to guides: WCGRRT, SSORT, precharge, the SACRED dashboards, Argo Navis and the TSC Help Centre<br><br>Builds: WCGRRT REV 174 · SSORT REV 169 · Argo Navis REV 16', name=True)
    body += md_html(read(os.path.join(SRC, 'MANUAL-FRONT.md')))
    body += md_html(shots_to_html(read(os.path.join(SRC, 'MANUAL-PART1-TOOLS.md')), label=False))
    body += md_html(imgs_to_html(read(os.path.join(SRC, 'MANUAL-PART2-PLATFORM.md'))))
    body += md_html(read(os.path.join(ROOT, 'TRAINING-Day2-Feedback-Sheet.md')).replace('Day 1 · the exercise', 'Day 1 · the run-through: one report of each type'))
    to_pdf(body, os.path.join(OUT, '03-Training-Manual.pdf'), 'Training Manual')

    # --- 04 the Monday card
    to_pdf(first_h1(md_html(read(os.path.join(SRC, 'MONDAY-0745-CARD.md')))), os.path.join(OUT, '04-Monday-0745-Card.pdf'), 'Monday 07:45')

    # --- 05 / 06 decks
    shutil.copy(os.path.join(D1, '06-Day-1-Deck.pptx'), os.path.join(OUT, '05-Day-1-Deck.pptx'))
    shutil.copy(os.path.join(SRC, 'Day-2-Deck.pptx'), os.path.join(OUT, '06-Day-2-Deck.pptx'))

    # --- 07 the P6 hold point half page, 08 UAT sign-off
    to_pdf(first_h1(md_html(read(os.path.join(D1, '11-DAY2-HOLD-POINT-DAILY-SUMMARY-REPORT.md')))), os.path.join(OUT, '07-Day-2-Hold-Point-P6-Route.pdf'), 'Hold point')
    to_pdf(first_h1(md_html(read(os.path.join(SRC, 'UAT-SIGN-OFF.md')))), os.path.join(OUT, '08-UAT-Sign-off-Form.pdf'), 'UAT sign-off')

    # --- files
    usb = os.path.join(OUT, 'Trainer-demo-files')
    shutil.copytree(os.path.join(SRC, 'usb'), usb)
    s1 = os.path.join(OUT, 'Day-1-sample-reports-what-good-looks-like')
    shutil.copytree(os.path.join(D1, 'samples'), s1)
    shutil.copytree(os.path.join(PRE, 'exercise-files'), os.path.join(OUT, 'Day-2-precharge-exercise-files'))
    sd = os.path.join(OUT, 'screenshots-Day-1')
    os.makedirs(sd)
    seen = set()
    for d in SHOT_DIRS:
        for f in sorted(os.listdir(d)):
            if f.endswith('.png') and f.split('-')[0] not in seen:
                seen.add(f.split('-')[0]); shutil.copy(os.path.join(d, f), os.path.join(sd, f))
    src_dir = os.path.join(OUT, 'sources-markdown')
    os.makedirs(src_dir)
    for f in ['02-Walkthrough-Scripts.md', '03-Exercise-Sheet.md', '04-Questions-and-Answers.md', '09-WHATS-NEW-SSORT-169-WCGRRT-174.md', '10-REPLY-WORKSHOP-PACK-2026-10-16.md']:
        shutil.copy(os.path.join(D1, f), os.path.join(src_dir, 'Day1-' + f))
    for f in ['DAY2-TRAINER-SCRIPT.md', 'DAY1-MODULE4-RUNTHROUGH.md', 'MANUAL-PART1-TOOLS.md', 'MANUAL-PART2-PLATFORM.md']:
        shutil.copy(os.path.join(SRC, f), os.path.join(src_dir, f))

    # --- zip
    z = OUT + '.zip'
    if os.path.exists(z):
        os.remove(z)
    with zipfile.ZipFile(z, 'w', zipfile.ZIP_DEFLATED) as zf:
        for dp, _, fs in os.walk(OUT):
            for f in sorted(fs):
                full = os.path.join(dp, f)
                zf.write(full, os.path.join(OUT_NAME, os.path.relpath(full, OUT)))
    print('Built', z, os.path.getsize(z), 'bytes')


if __name__ == '__main__':
    main()
