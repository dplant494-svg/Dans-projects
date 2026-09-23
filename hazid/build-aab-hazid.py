import zipfile, re, html, shutil, sys

SRC = 'Seadrill_HAZID_Template.docx'   # Lee Arnold's HAZID template, from the Fleet HAZID Tool, 22 Sep 2026
OUT = sys.argv[1] if len(sys.argv) > 1 else 'AAB-HAZID.docx'
z = zipfile.ZipFile(SRC)
x = z.read('word/document.xml').decode('utf8')
styles = z.read('word/styles.xml').decode('utf8')

def esc(t): return html.escape(str(t), quote=False)

def para_text(p): return html.unescape(''.join(re.findall(r'<w:t[^>]*>(.*?)</w:t>', p, flags=re.S)))

def rebuild_para(p, text):
    """Keep pPr and the first run's rPr; one run with the new text (xml:space preserved)."""
    ppr = re.search(r'<w:pPr>.*?</w:pPr>', p, flags=re.S)
    rpr = re.search(r'<w:r>\s*(<w:rPr>.*?</w:rPr>)', p, flags=re.S) or re.search(r'<w:r [^>]*>\s*(<w:rPr>.*?</w:rPr>)', p, flags=re.S)
    head = re.match(r'<w:p[^>]*>', p).group(0)
    run = '<w:r>' + (rpr.group(1) if rpr else '') + '<w:t xml:space="preserve">' + esc(text) + '</w:t></w:r>'
    return head + (ppr.group(0) if ppr else '') + run + '</w:p>'

def find_para(x, needle, start=0):
    i = x.find(esc(needle), start)
    if i < 0: i = x.find(needle, start)
    if i < 0: raise KeyError(needle)
    ps = x.rfind('<w:p ', 0, i); ps2 = x.rfind('<w:p>', 0, i); ps = max(ps, ps2)
    pe = x.find('</w:p>', i) + 6
    return ps, pe

def set_para(x, needle, text, start=0):
    ps, pe = find_para(x, needle, start)
    return x[:ps] + rebuild_para(x[ps:pe], text) + x[pe:]

def del_para(x, needle):
    ps, pe = find_para(x, needle)
    return x[:ps] + x[pe:]

def set_cell(c, text, fill=None):
    paras = re.findall(r'<w:p[ >][^>]*?(?<!/)>.*?</w:p>', c, flags=re.S)
    if paras:
        newp = rebuild_para(paras[0], text)
        c2 = c.replace(paras[0], newp, 1)
        for p in paras[1:]: c2 = c2.replace(p, '', 1)
    else:
        m = re.search(r'<w:p[^>]*/>', c)   # self-closing empty paragraph
        newp = '<w:p><w:r><w:rPr><w:sz w:val="16"/></w:rPr><w:t xml:space="preserve">' + esc(text) + '</w:t></w:r></w:p>'
        c2 = c.replace(m.group(0), newp, 1) if m else c.replace('</w:tcPr>', '</w:tcPr>' + newp, 1)
    if fill:
        if 'w:fill="' in c2: c2 = re.sub(r'w:fill="[0-9A-Fa-f]+"', 'w:fill="%s"' % fill, c2, count=1)
        else: c2 = c2.replace('</w:tcW>', '</w:tcW>', 1).replace('<w:tcPr>', '<w:tcPr><w:shd w:val="clear" w:color="auto" w:fill="%s"/>' % fill, 1)
    return c2

def row_at(x, needle, start=0):
    i = x.find(esc(needle), start)
    rs = x.rfind('<w:tr ', 0, i); rs2 = x.rfind('<w:tr>', 0, i); rs = max(rs, rs2)
    re_ = x.find('</w:tr>', i) + 7
    return rs, re_

def fill_row(row, values, fills=None):
    cells = re.findall(r'<w:tc>.*?</w:tc>', row, flags=re.S)
    assert len(cells) == len(values), (len(cells), len(values))
    out = row
    for i, (c, v) in enumerate(zip(cells, values)):
        out = out.replace(c, set_cell(c, v, (fills or {}).get(i)), 1)
    return out

# ---- the risk matrix as printed in the template (FRM-37-0138 colours, cell shading read from the template) ----
GRID = {  # consequence 1..5 x frequency E D C B A
    1: 'GYRRR', 2: 'GYYRR', 3: 'GGYYR', 4: 'GGGYY', 5: 'GGGGY'}
FREQ_COL = {'E': 0, 'D': 1, 'C': 2, 'B': 3, 'A': 4}
NAME = {'G': 'Green', 'Y': 'Yellow', 'R': 'Red'}
FILL = {'Green': 'C6E0B4', 'Yellow': 'FFE699', 'Red': 'F4B6B6'}
CONFILL = {'G': 'E2EFDA', 'Y': 'FBE4D5', 'R': 'F4B6B6'}
def risk(con, freq): return NAME[GRID[int(con)][FREQ_COL[freq]]]

# ================= CONTENT =================
TITLE = 'Priority 3 Advisory AABs — distribution, acknowledgement and tracking through the Seadrill Bulletin Board and the WCE Dashboard'
SUBTITLE = 'Process change risk assessment — Priority 3 (Notification / Advisory) AABs originated by WCE Technical Services move from the Maximo child-case route of DIR-37-0161 to the Bulletin Board tool, the notification flow and the dashboard (a Seadrill system change under DIR-37-0015 §2)'
STD_LINE = 'Prepared in accordance with the Seadrill Risk Assessment Directive DIR-37-0147 v2.02. Governing process documents: DIR-37-0161 Management of Technical Alerts, Advisories and Bulletins v6.07; DIR-37-0015 Management of Change v1.08; DIR-00-0100 Rig Asset Management Platform v8.06.'

REGISTER = [
 # id, guideword/ref, source, threat/cause, existing controls, con, freq, proposed, action, mcon, mfreq
 ('H1','Communication — advisory not received','Notification flow, Rigs sheet contacts, email',
  'Flow run fails; rig contacts blank on the Rigs sheet; email lost or filtered; workbook open when the flow runs. Rig unaware of a known equipment defect; the advisory\'s purpose defeated for that rig.',
  'NO RIG CONTACT branch emails the office instead of failing silently; office and gatekeeper in copy of every issue email; the AAB is visible on the dashboard fleet view; Power Automate failure notification to the flow owner.',
  1,'D',
  'Daily overdue chase to the rig contacts until acknowledged; Rigs sheet reviewed monthly with the sentinel NONE for a deliberate blank; one sent-log row per email in the notification workbook.',
  'D. Plant: chase branch and sent-log in the AAB Notifications flow before go-live; monthly Rigs sheet review on the Technical Services calendar.',1,'E'),
 ('H2','Human error — wrong applicable rigs','Bulletin Board rig selection',
  'Selection error by the gatekeeper; a new unit not yet in the rig list. An omitted rig is never told; an included rig acts on an advisory that does not apply to its equipment.',
  'Preview before Post shows the rig chips; All rigs and Clear shortcuts; rig list held as data; the dashboard shows the applicable rigs per AAB; a revision re-issues to the corrected list.',
  2,'D',
  'Gatekeeper checks the applicable list against the SFI equipment register before posting; a second reader in Technical Services for fleet-wide AABs.',
  'E. Rachall: SFI check written into the issuing procedure; second-reader rule for fleet-wide AABs.',2,'E'),
 ('H3','Procedural — acknowledged but not actioned','Rig acknowledgement page',
  'The rig treats acknowledgement as closure, or closes the action without doing the work. The defect remains on the rig while the dashboard reads green.',
  'Two distinct states, acknowledged and action closed; closure requires a comment and evidence photographs; the due date applies to closure; the Subsea Superintendent verifies on the next rig visit.',
  1,'D',
  'Dashboard shows "acknowledged, action open" as its own state and colour; closure evidence reviewed by the gatekeeper; quarterly sample audit of closed actions against evidence.',
  'D. Plant: the third state on the dashboard AAB tab. E. Rachall: closure evidence review and quarterly sample.',1,'E'),
 ('H4','Change — superseded revision in use','Revision handling',
  'A new revision is posted while the rig has printed or saved the earlier one. The wrong instruction is followed.',
  'Revision number in the tool header, the email subject and on the dashboard; a revision marked requires re-acknowledgement returns every rig to outstanding; the email carries the current bulletin.',
  2,'D',
  'Printed cover states "Rev n — earlier revisions are withdrawn"; the dashboard open list shows the current revision only and keeps earlier ones as history.',
  'D. Plant: cover wording and open-list rule in the dashboard build.',2,'E'),
 ('H5','Human error — wrong or missing attachment','Bulletin Board attachments',
  'The gatekeeper attaches the wrong PDF, or ticks "no attachment" in error. The rig cannot act, or acts on the wrong document.',
  'Attachment names shown in the preview and on the dashboard; a primary bulletin flag; the tool refuses to post without a PDF unless the no-attachment box is explicitly ticked.',
  3,'C',
  'Gatekeeper opens the attachment from the preview before posting; a same-day correction is a revision, never an edit of the posted file.',
  'E. Rachall: preview-open step in the issuing procedure.',3,'D'),
 ('H6','Systems — post fails or is cut short','HTTP intake, network',
  'Network fault, intake endpoint down, post over the size limit, or a file truncated in transit. The AAB is not filed and nobody is told.',
  'Local Save always works with no network; a failed post reports the HTTP status and the server text and downloads the record; size guard warns at 20 MB and refuses at 30 MB; the scanner lists an unparseable file on the dashboard Errors button.',
  4,'C',
  'Gatekeeper confirms the AAB appears on the dashboard within 20 minutes of posting; if not, re-posts from the saved file.',
  'E. Rachall: confirmation step in the issuing procedure.',4,'D'),
 ('H7','Systems — rig cannot reach the dashboard server','Corporate network route (West Gemini today)',
  'West Gemini cannot open the sacred server at present (route or firewall, IT ticket open); any rig with a network fault. The rig cannot acknowledge on the page.',
  'The email carries the bulletin, so the advisory still arrives; acknowledgement by reply email to the gatekeeper, entered on the rig\'s behalf by Technical Services with the reply kept on file.',
  2,'C',
  'IT ticket for the West Gemini route closed before go-live or the reply route formally accepted for that rig; the acknowledgement page works from any browser on the corporate network once the route exists.',
  'D. Plant with IT: West Gemini route ticket.',2,'E'),
 ('H8','Records — loss of the AAB register','SharePoint PostedReports, scanner, retention',
  'Maximo is no longer the register for Priority 3. The SharePoint library is deleted or reorganised, the archive script moves files, or a retention policy removes them. No evidence that a rig was told or acknowledged.',
  'Posted files are never modified; SharePoint version history; the scanner never archives an AAB or acknowledgement file; server copies on sacred; the dashboard data is regenerated every 10 minutes from the files.',
  3,'D',
  'Retention rule for PostedReports agreed with IT for at least the directive\'s retention period; quarterly export of AAB and acknowledgement records to the Technical Services archive.',
  'D. Plant: retention rule with IT; quarterly export on the calendar.',3,'E'),
 ('H9','Security — unauthorised or accidental issue','Intake endpoint, test posts',
  'Anyone holding the tool file and the intake endpoint could post; a test post could reach the rigs. Rigs act on a false or test advisory.',
  'The endpoint is not written in the tool file (gate-config.js or browser storage only); originator name and email on every record; office and gatekeeper in copy of every issue email so a rogue post is seen within the hour; test mode sends to the office only.',
  2,'D',
  'Only the gatekeeper and the change owner hold the endpoint; every test is run in test mode; a withdrawal revision is the correction if a wrong AAB reaches a rig.',
  'E. Rachall / D. Plant: endpoint custody; test-mode rule in the procedure.',2,'E'),
 ('H10','Procedural — acknowledgement by the wrong person','Rig acknowledgement page',
  'Anyone with the page can press Acknowledge and type a name. The rig is shown as acknowledged when the accountable role (both crews\' TSLs, DIR-37-0161 §2.2.4) has not seen the advisory.',
  'Name and role are required; the expected role is shown on the page and carried in the record; the acknowledgement email to the gatekeeper names who acknowledged; the Subsea Superintendent verifies on the next visit.',
  3,'C',
  'Role list fixed to the roles DIR-37-0161 names for a Priority 3 (the TSL of each crew); the page records name and crew; a password gate added if misuse is seen.',
  'D. Plant: role list from the directive revision.',3,'D'),
 ('H11','Change — two registers during cut-over','Maximo and the tool in parallel',
  'No cut-over date, or habit. AABs raised in both Maximo and the tool; neither register complete; a Priority 3 AAB missed.',
  'MOC implementation step: a cut-over date; open Maximo Priority 3 AABs listed and re-issued through the tool or closed in Maximo; the directive revised before the date.',
  2,'C',
  'Compliance Checklist P1 item re-pointed to the dashboard AAB tab; the Maximo Priority 3 workflow marked retired on the cut-over date.',
  'E. Rachall: cut-over list. Reporting-tools session: P1 wording.',2,'E'),
 ('H12','Communication — notification fatigue','Recipient tables',
  'Too many recipients per AAB; fleet-wide AABs to every contact. Emails ignored; a real advisory missed.',
  'One email per rig to that rig\'s own contacts; office in copy, not To; superintendents on their own table, not on every loop; the subject line carries the AAB number and title.',
  3,'B',
  'Recipient tables reviewed quarterly; chase emails only for overdue AABs, once a day.',
  'D. Plant: quarterly recipient review.',3,'D'),
 ('H13','Organisational — single-person dependence','Gatekeeper and dashboard owner roles',
  'Absence, leave or change of role of the gatekeeper or the dashboard owner. AABs not issued; the dashboard not maintained.',
  'Tool file and endpoint held by two people; originator editable in the tool; all documents in the repository; training pack for the office.',
  3,'C',
  'Named deputy for the gatekeeper role written into the directive; dashboard handover document kept current.',
  'E. Rachall: deputy named in the directive revision. D. Plant: handover document.',3,'D'),
 ('H14','Systems — scanner or flow stops','Scheduled task, Power Automate',
  'Scheduled task killed, server copy failure, flow turned off, workbook renamed. No overdue chase; dashboard stale; acknowledgements not shown.',
  'The scanner writes a generated-at stamp the dashboard shows; flow failure notification to the owner; the issue email does not depend on the scanner because the flow reads the posted file directly.',
  3,'B',
  'Dashboard banner when the data is more than two hours old; monthly check of the flow run history; scanner health on the daily task output.',
  'D. Plant: stale-data banner in the dashboard build; monthly flow check.',3,'D'),
 ('H15','Content — advisory wrong or unclear','Bulletin Board advisory text',
  'The three sections written in haste with no review before posting. The rig takes the wrong action.',
  'Mandatory fields: what has happened, why it matters, what the rig must do; preview before post; reference documents listed; the revision route for corrections.',
  2,'C',
  'Second reader in Technical Services before posting a Priority 3 that requires physical intervention; the directive\'s review rule applied.',
  'E. Rachall: second-reader rule in the issuing procedure.',2,'E'),
 ('H16','Change — implemented out of order or untested before go-live','The build and the cut-over',
  'The tool, the board, the flow and the dashboard side are built by three parties; a part goes live before the others, the flow is never run in test mode, the rigs are not told how to acknowledge, the deviation case is not raised. The pilot starts with a route nobody has walked end to end.',
  'Build order fixed in the plan (Bulletin Board Rev 5 → dashboard side → flow in test mode → end-to-end trial on one rig → rig bulletin and office training → cut-over list); test mode proven on the CBM to OEM loop; this HAZID and the MOC precede the pilot; the DIR-00-0011 deviation case is connected to the MOC.',
  2,'C',
  'Go-live gate: no pilot until (1) Rev 5 is proven on the saved test records, (2) the scanner, board register, acknowledgement page and AAB tab are proven on the synthetic records, (3) the AAB Notifications flow has run in test mode with the would-have recipients listed, (4) one real advisory has gone end to end on one rig in test mode, both TSLs acknowledging, the chase firing on a due date set to yesterday, (5) the rig bulletin is issued and the office trained, (6) the deviation case is open and connected.',
  'D. Plant (MOC owner) signs the gate; E. Rachall (Rev 5, bulletin); reporting-tools session (P1 wording).',2,'E'),
]

SUMMARY_MEASURE = {
 'H1': 'Daily overdue chase; monthly Rigs sheet review; sent-log', 'H2': 'SFI register check; second reader for fleet-wide AABs',
 'H3': 'Third state on the dashboard; closure evidence review; quarterly sample', 'H4': 'Cover wording; open list shows current revision only',
 'H5': 'Open the attachment from the preview before posting', 'H6': 'Confirm on the dashboard within 20 minutes; re-post from the saved file',
 'H7': 'West Gemini route ticket; reply route accepted meanwhile', 'H8': 'Retention rule with IT; quarterly export',
 'H9': 'Endpoint held by two people; test mode for every test', 'H10': 'Role list from the directive; gate if misused',
 'H11': 'Cut-over date; P1 item re-pointed; Maximo workflow retired', 'H12': 'Quarterly recipient review; chase once a day',
 'H13': 'Named deputy in the directive; handover document', 'H14': 'Stale-data banner; monthly flow check',
 'H15': 'Second reader for AABs needing physical intervention', 'H16': 'Six-point go-live gate before the pilot'}
SUMMARY_OWNER = {'H1':'D. Plant','H2':'E. Rachall','H3':'D. Plant / E. Rachall','H4':'D. Plant','H5':'E. Rachall','H6':'E. Rachall','H7':'D. Plant / IT','H8':'D. Plant','H9':'E. Rachall / D. Plant','H10':'D. Plant','H11':'E. Rachall','H12':'D. Plant','H13':'E. Rachall / D. Plant','H14':'D. Plant','H15':'E. Rachall','H16':'D. Plant'}

# ================= COVER =================
x = set_para(x, '[EQUIPMENT / SYSTEM / ACTIVITY NAME]', TITLE)
x = set_para(x, '[Subtitle', SUBTITLE)
x = set_para(x, '[Prepared in accordance with the Seadrill Risk Assessment Directive', STD_LINE)
x = set_para(x, '[FRM/Doc No.]', 'FRM-37-XXXX (number to be allocated by document control)')
x = set_para(x, '[Rev 00]', 'Rev 01 (draft for workshop)')
x = set_para(x, '[Month Year]', 'September 2026')
x = set_para(x, '[Risk Level', 'Risk Level: Yellow untreated, Green after the proposed measures — Confidential')
x = set_para(x, '[Equipment, system, or activity covered', 'The process by which Priority 3 (Notification / Advisory, information only) AABs originated by WCE Technical Services are issued, distributed to the thirteen WCE units, acknowledged by both crews\' Technical Section Leaders, chased and reported. The subjects of AABs are well control equipment classified Safety Critical (SCE / SECE) under RAMP; the process itself is not an equipment item.')
x = set_para(x, 'DIR-37-0147 (Risk Assessment); DIR-00-0100 (RAMP); [applicable API', 'DIR-37-0147 v2.02 (Risk Assessment); DIR-37-0161 v6.07 (Management of Technical Alerts, Advisories and Bulletins); DIR-37-0015 v1.08 (Management of Change); DIR-00-0100 v8.06 (RAMP)')
x = set_para(x, '[Client name', 'Seadrill fleet — thirteen WCE units, all contracts')
x = set_para(x, '[Author / Department]', 'Daniel Plant, Subsea Superintendent, Technical Services (change owner); Eric Rachall, AAB gatekeeper (initiator)')

# ================= REVISION HISTORY =================
rs, re_ = row_at(x, 'Initial Issue')
x = x[:rs] + fill_row(x[rs:re_], ['01', 'September 2026', 'Initial issue — draft for the HAZID workshop; rankings to be agreed in the room', 'D. Plant']) + x[re_:]

# ================= SECTION 1 =================
x = set_para(x, '[The purpose of this Risk Assessment / HAZID is to identify', 'The purpose of this Risk Assessment / HAZID is to identify the hazards and manage the potential risks associated with a change of process: Priority 3 (Notification / Advisory, information only, DIR-37-0161 §2.2.3) AABs originated by WCE Technical Services will be issued, distributed, acknowledged, actioned and tracked through the Seadrill Bulletin Board tool, the estate\'s posting intake, the AAB Notifications flow and the Well Control Equipment (WCE) Dashboard, in place of the Maximo child AAB cases and their tick-box acknowledgement (DIR-37-0161 §2.2.4). It is prepared in accordance with the Seadrill Risk Assessment Directive (DIR-37-0147), evaluates risk using the Seadrill Risk Matrix (FRM-37-0138) as reproduced in Section 2.1, and is the HAZID DIR-37-0015 §3.4 requires for the Management of Change (a Seadrill system change under §2 of that directive). The equipment that AABs concern is Safety Critical Equipment (SCE / SECE) contributing to the loss-of-well-containment Major Accident Hazards; the process is one of the ways a known equipment defect reaches the rigs that carry the equipment.')
x = set_para(x, '[State the specific objective', 'The objective is to demonstrate, hazard by hazard, that the new route tells every applicable rig, records that the rig has read the advisory and separately that it has acted on it, makes an unacknowledged advisory visible to Technical Services the day it goes overdue, keeps an immutable record of every issue and acknowledgement, and does so at a residual risk that is ALARP and no higher than the Maximo route it replaces. The study asks one question of every step: how could a rig fail to be told, fail to understand, fail to act, or be shown as done when it is not, and would we see it?')
x = set_para(x, '[State exactly what this risk assessment applies to', 'This risk assessment applies to Priority 3 Advisory AABs originated by WCE Technical Services for the thirteen WCE units (West Neptune, West Auriga, West Saturn, West Jupiter, West Tellus, West Carina, West Polaris, West Vela, West Gemini, West Capella, Sonangol Libongos, Sonangol Quenguela, Sevan Louisiana) and to the four parts of the new route. Where Client requirements or local regulations differ, the more stringent applies. The scope covers:')
bul1 = ['Issue: the Seadrill Bulletin Board tool (Rev 5), its record and its Post and Save routes;',
        'Distribution: the AAB Notifications flow, the notification workbook (Office, Superintendents and Rigs tables) and the emails it sends;',
        'Acknowledgement and action closure: the acknowledgement page on the sacred server, its two records (acknowledge, close) and the evidence they carry;',
        'Reporting and chase: the dashboard scanner, the dashboard AAB tab (overdue count first, then percent acknowledged) and the daily overdue chase;',
        'Records: the immutable posted files in SharePoint WellControl / PostedReports as the register for Priority 3 AABs, and their retention.']
for old, new in zip(['[Structural / mechanical integrity', '[Functional / performance testing', '[Material traceability', '[Certification, quality assurance', '[Registration of the equipment/asset'], bul1):
    x = set_para(x, old, new)
x = set_para(x, '[State what is explicitly out of scope.]', 'Out of scope: Priority 1 (Safety Alert) and Priority 2 (Bulletin, Product Obsolescence) AABs, which remain in Maximo under DIR-37-0161 as it stands; external AABs received through the common mailbox and their eDocs filing and Maximo parent case, which are unchanged; the work orders raised as a result of an AAB, which remain in Maximo; other disciplines. Any field activity that an AAB requires is separately controlled by a TBRA and/or 5-Point Check at the worksite per DIR-37-0147.')
x = set_para(x, '[Name the Technical Authority / discipline owner]', 'Lee Arnold, Technical Authority WCE, is responsible for the content of this assessment and for the acceptance decision. Daniel Plant, Subsea Superintendent, is the change owner under DIR-37-0015 and owns the dashboard side: routing, the acknowledgement page, the scanner and the KPI. Eric Rachall, AAB gatekeeper, owns the Bulletin Board tool and the record it posts, and is the only person who issues from it. The Technical Section Leader of each crew acknowledges for the rig, as DIR-37-0161 §2.2.4 requires for a Priority 3; the Rig Manager is responsible for the directive being followed on the rig (§2.1). All actions arising are transferred to Synergi with owners and dates.')

# ================= SECTION 2 tweaks =================
x = set_para(x, 'The risk for all aspects shall be reduced to As Low As Reasonably Practicable (ALARP) before [', 'The risk for all aspects shall be reduced to As Low As Reasonably Practicable (ALARP) before the new process goes live on the cut-over date set in the MOC.')
x = set_para(x, 'In this assessment the principal controls are Engineering', 'In this assessment the principal controls are Engineering in the sense of the system\'s design (a posted file is the event and is never modified; every lookup miss produces an email to the office rather than silence; two distinct states for read and done; test mode that sends to the office only) and Administrative (the issuing procedure, the roles the directive names, the cut-over list, the reviews on the Technical Services calendar). PPE has no part in this assessment.')
x = set_para(x, 'This document is an engineering / equipment acceptance HAZID', 'This document is a process-change HAZID supporting the Management of Change decision under DIR-37-0015. It feeds the Plan step of PIMED for the change. Any field activity that an individual AAB requires of a rig is controlled at the worksite by a TBRA (FRM-37-0015) where the criteria in DIR-37-0147 §2.6 apply, or a 5-Point Check otherwise; this HAZID does not replace either.')

# ================= SECTION 3 =================
TOC_END = x.rfind('w:val="TOC')
def set_heading(x, old, new):
    # the TOC entry (before TOC_END) and the real heading (after it)
    x = set_para(x, old, new)
    try: x = set_para(x, old, new, TOC_END)
    except KeyError: pass
    return x
x = set_heading(x, '3. Equipment and Standards Basis', '3. Process and Standards Basis')
x = set_heading(x, '3.1 [Applicable Standard(s)', '3.1 Governing documents')
x = set_para(x, '[Summarise the controlling clauses of each applicable industry/regulatory standard', 'DIR-37-0161 v6.07 governs how a Technical Alert, Advisory or Bulletin is received, filed, evaluated and distributed: three priorities (1 Safety Alert, 2 Bulletin / Product Obsolescence, 3 Notification / Advisory, information only); eDocs filing and a Maximo parent case for every AAB; Maximo child cases per site; for a Priority 3, both TSLs acknowledge by ticking the box and commenting. The MOC amends §2.1, §2.2.3, §2.2.4, §4 and §6 for WCE-originated Priority 3 advisories only (see the MOC §5). DIR-37-0015 v1.08 governs the change itself as a Seadrill system change (§2) and requires this HAZID (§3.4). DIR-37-0147 governs this assessment. DIR-00-0100 (RAMP) governs the equipment the advisories concern: the criticality classification stays in Maximo, and work orders arising from an AAB stay in Maximo; only the Priority 3 AAB register moves.')
x = set_heading(x, '3.2 Equipment Specification and Quality Evidence', '3.2 The process as designed')
x = set_para(x, '[Summarise the equipment/OEM specification supplied', 'The process is described in AAB-LOOP-PLAN.md and drawn in AAB-LOOP-FLOWCHART.html, both attached to the MOC. In outline: the gatekeeper raises the AAB in the Bulletin Board (number, revision, title, SFI codes, category, issue and due dates, the three advisory sections, references, the bulletin PDF and other attachments, photographs, applicable rigs) and presses Post; one record goes through the estate\'s HTTP intake to SharePoint WellControl / PostedReports and is never modified afterwards. The AAB Notifications flow emails each applicable rig\'s contacts from the notification workbook with the bulletin attached and a link to the dashboard, office and gatekeeper in copy; a rig with no contacts produces a NO RIG CONTACT email to the office. The rig acknowledges on the dashboard\'s acknowledgement page (name, role, date) and later closes the action (name, date, comment, evidence photographs); each is a second posted record. The scanner groups revisions by AAB number, joins acknowledgements to AABs per rig, computes each rig\'s state (outstanding, acknowledged, closed, overdue) and shows it on the dashboard AAB tab, overdue count first. Overdue AABs are chased daily. It is the fifth instance of the notification loop already in service for precharge (11 September 2026), rig visit reports, CBM to OEM and SSCE requests.')
x = set_heading(x, '3.3 Alignment with the Rig Asset Management Platform', '3.3 Alignment with RAMP (DIR-00-0100) and Maximo')
x = set_para(x, '[Where the subject of this assessment is equipment, describe', 'The change does not alter how equipment is identified, classified or maintained under RAMP:')
bul3 = ['Equipment identification and criticality stay in Maximo (SAMS); an AAB names its equipment by SFI code and description and does not create or change asset records;',
        'Work orders arising from an AAB are raised and closed in Maximo as today; the acknowledgement record on the dashboard references the AAB, not the work order;',
        'Third-party and service-provider involvement in an AAB\'s required action is managed under DIR-00-0239 as today;',
        'The Priority 3 AAB register moves from Maximo to the immutable posted files in SharePoint WellControl / PostedReports, with SharePoint version history and the dashboard as the reporting view; retention is agreed with IT (register entry H8);',
        'Levels 1 and 2 are unchanged in Maximo.']
for old, new in zip(['Equipment identification &#8212; asset/location record', 'Criticality and Performance Standard &#8212;', 'Third-party / service provider &#8212;', 'Certification tracking &#8212;', 'Maintenance cycle &#8212;'], bul3):
    x = set_para(x, old, new)

# ================= SECTION 4 REGISTER =================
x = set_para(x, 'Requirements from the applicable standard(s) (Section 3.1) are identified', 'The register below walks the ten steps of the process (issue, post, notify, record, acknowledge, post the acknowledgement, notify the gatekeeper, compute status, report, chase) and two further nodes, the transition from Maximo and the organisation around the process. "Existing Risk Controls" are the controls in the design as built or specified in AAB-LOOP-PLAN.md; "Proposed Risk Reducing Measures" are additional. Consequence, frequency and colour follow the matrix in Section 2.1 and are the drafter\'s, to be agreed in the workshop.')
rs, re_ = row_at(x, 'EX-1'); tpl_row = x[rs:re_]
rs2, re2 = row_at(x, 'EX-2')
rows = ''
for (rid, gw, src, thr, ctl, con, fr, prop, act, mcon, mfr) in REGISTER:
    r1 = risk(con, fr); r2 = risk(mcon, mfr)
    fills = {5: CONFILL[r1[0]], 6: CONFILL[r1[0]], 7: FILL[r1], 10: CONFILL[r2[0]], 11: CONFILL[r2[0]], 12: FILL[r2]}
    rows += fill_row(tpl_row, [rid, gw, src, thr, ctl, str(con), fr, r1, prop, act, str(mcon), mfr, r2], fills)
x = x[:rs] + rows + x[re2:]

# ================= SECTION 5 SUMMARY =================
rs, re_ = row_at(x, 'EX-1'); tpl_row = x[rs:re_]
rs2, re2 = row_at(x, 'EX-2')
rows = ''
for (rid, gw, src, thr, ctl, con, fr, prop, act, mcon, mfr) in REGISTER:
    r1 = risk(con, fr); r2 = risk(mcon, mfr)
    rows += fill_row(tpl_row, [rid, gw, SUMMARY_MEASURE[rid], str(con), fr, r1, SUMMARY_OWNER[rid], str(mcon), mfr, r2], {5: FILL[r1], 9: FILL[r2]})
x = x[:rs] + rows + x[re2:]

# ================= SECTION 6, 7 =================
x = set_para(x, '[State the overall ALARP conclusion', 'All residual risks following implementation of the proposed risk reducing measures are assessed as Green on the matrix in Section 2.1. The untreated risk of the designed process is Yellow at its highest (entries H1, H3, H2, H4, H7, H9, H11, H15, H16) and no entry is Red, because the controls that carry the most weight are in the design itself and not left to the crew. The demonstration rests on the following:')
x = set_para(x, '[Standard compliance: identify', 'Directive compliance: the content of an AAB (the three sections, the bulletin) and the gatekeeper role are unchanged from the AAB directive; only the route changes, and the MOC amends the directive sections that describe the route;')
x = set_para(x, '[Barrier integrity: state how', 'Barrier integrity: the advisory\'s function as a barrier (a known defect reaches the rig that carries the equipment) is verified by the acknowledgement record, the action closure record with evidence, the fleet view of what is outstanding and the daily chase, none of which the Maximo route provides;')
x = set_para(x, '[Independent assurance: identify', 'Independent assurance: the same intake, workbook and dashboard pattern is in service for four other loops since 11 September 2026; the CBM to OEM loop was tested end to end on 22 September 2026 in test mode with the real recipient lists proven and nobody outside the office emailed;')
x = set_para(x, '[Gap closure: list any open items', 'Gap closure before go-live: H16 is the gate (six points: Rev 5 proven, dashboard side proven, flow run in test mode, one advisory end to end on one rig, rig bulletin and office training, deviation case open); H1 (chase branch and sent-log), H3 (third state on the dashboard), H7 (West Gemini route or the reply route accepted), H8 (retention rule with IT), H11 (cut-over list) and H13 (named deputy in the directive revision) must be closed; the remaining measures are procedural and are written into the issuing procedure;')
x = set_para(x, 'Governance: acceptance is governed through Seadrill engineering acceptance / MoC', 'Governance: the change is governed through Management of Change (DIR-37-0015) with Technical Authority WCE sign-off, and all actions are transferred to Synergi.')
x = set_para(x, '[State the overall conclusion', 'This HAZID concludes that the new route for Priority 3 Advisory AABs is acceptable, provided the gap-closure items in Section 6 are completed before the cut-over date and the procedural measures are written into the issuing procedure and the directive revision. The highest-priority actions before go-live are:')
x = set_para(x, 'Priority 1 (Red', 'Priority 1 (Entries H16, H1, H3): the six-point go-live gate; the daily overdue chase with a sent-log; the third state "acknowledged, action open" on the dashboard, signed off by the change owner.')
x = set_para(x, 'Priority 2 (Entries [X, Y])', 'Priority 2 (Entries H7, H8, H11, H13): the West Gemini route or an accepted reply route; the retention rule with IT; the cut-over list of open Maximo Priority 3 AABs; a named deputy for the gatekeeper in the directive revision.')
x = set_para(x, 'Priority 3 (Entries [X, Y, Z])', 'Priority 3 (Entries H2, H4, H5, H6, H9, H10, H12, H14, H15): the procedural measures written into the issuing procedure, the dashboard cover wording and stale-data banner, the quarterly reviews on the Technical Services calendar.')
x = set_para(x, 'All risk reducing measures shall be transferred to Synergi as formal action items', 'All risk reducing measures shall be transferred to Synergi as formal action items with defined owners and close-out dates, and verified complete before the new process goes live. Any subsequent field activity required by an individual AAB shall be controlled by TBRA / 5-Point Check per DIR-37-0147.')

# ================= SECTION 8 REFERENCES =================
rs, re_ = row_at(x, '[Applicable API / industry standard reference]'); tpl_row = x[rs:re_]
rs2, re2 = row_at(x, '[Equipment / quality documentation reference]')
refs = [('DIR-37-0161 (v6.07)', 'Management of Technical Alerts, Advisories and Bulletins; §2.1, §2.2.3, §2.2.4, §4 and §6 amended by the MOC for WCE-originated Priority 3 advisories'),
        ('MOC (Synergi case [number])', 'Management of Change: Priority 3 Advisory AABs through the Seadrill Bulletin Board and the WCE Dashboard, draft 2, 23 September 2026 (AAB-MOC-DRAFT.md)'),
        ('AAB-LOOP-PLAN.md / AAB-LOOP-FLOWCHART.html', 'The process as designed: parts, records, decisions, build order; the printable flowchart'),
        ('AAB-REV5-HANDOFF-FOR-ERIC.md', 'The Bulletin Board Rev 5 record (schema 2.0) and the acknowledgement record'),
        ('NOTIFICATION-LOOP-PATTERN.md; NOTIFICATION-TEST-MODE-GUIDE.md', 'The notification loop design in service since 11 September 2026, and the test mode proven on 22 September 2026'),
        ('AAB-HAZID-Register.xlsx', 'The working register from which Section 4 was drawn')]
rows = ''.join(fill_row(tpl_row, [a, b]) for a, b in refs)
x = x[:rs] + rows + x[re2:]

# ================= SIGNATURES =================
rs, re_ = row_at(x, '[Name]')
x = x[:rs] + fill_row(x[rs:re_], ['Lee Arnold', 'Technical Authority WCE', '', '']) + x[re_:]
for name, title in [('Daniel Plant', 'Change owner — Subsea Superintendent, Technical Services'), ('Eric Rachall', 'AAB gatekeeper — Technical Services WCE')]:
    rs, re_ = row_at(x, '[Title]')
    x = x[:rs] + fill_row(x[rs:re_], [name, title, '', '']) + x[re_:]

# ================= SECTIONS: portrait -> landscape (register + summary) -> portrait =================
land = re.search(r'<w:p[^>]*>\s*<w:pPr>\s*<w:sectPr w:rsidR="00F645BB">.*?</w:sectPr>\s*</w:pPr>\s*</w:p>', x, flags=re.S)
assert land, 'landscape sectPr paragraph not found'
land_para = land.group(0)
x = x.replace(land_para, '', 1)
portrait_para = ('<w:p><w:pPr><w:sectPr><w:headerReference w:type="default" r:id="rId16"/><w:footerReference w:type="default" r:id="rId17"/>'
                 '<w:pgSz w:w="12240" w:h="15840"/><w:pgMar w:top="2000" w:right="1080" w:bottom="1750" w:left="1080" w:header="360" w:footer="280" w:gutter="0"/>'
                 '<w:cols w:space="720"/><w:docGrid w:linePitch="360"/></w:sectPr></w:pPr></w:p>')
TOC_END = x.rfind('w:val="TOC')
ps, pe = find_para(x, '4. HAZID Risk Register', TOC_END)
x = x[:ps] + portrait_para + x[ps:]
ps, pe = find_para(x, '6. ALARP Demonstration', TOC_END)
x = x[:ps] + land_para + x[ps:]

# ================= STYLES: heading colours to Seadrill blue =================
for c in ('4F81BD', '365F91', '17365D', '1F497D', '243F60'):
    styles = styles.replace('w:val="%s"' % c, 'w:val="002C77"')

# ================= HEADERS / FOOTERS =================
HDR_TITLE = 'Title: Priority 3 Advisory AABs through the Seadrill Bulletin Board and the WCE Dashboard — process change HAZID'
def fix_hf(t):
    t = t.replace('<w:t>Red</w:t>', '<w:t>Yellow</w:t>')
    t = re.sub(r'<w:t[^>]*>Title: Riser Running Tool \(Shaffer FT-H 1000T\) Recertification HAZID</w:t>', '<w:t xml:space="preserve">' + esc(HDR_TITLE) + '</w:t>', t)
    t = re.sub(r'<w:t[^>]*>Title: Riser Running Tool \(Shaffer FT-H 1000T\) </w:t>', '<w:t xml:space="preserve">' + esc(HDR_TITLE) + '</w:t>', t)
    t = t.replace('<w:t>Overhaul</w:t>', '<w:t></w:t>').replace('<w:t xml:space="preserve"> HAZID</w:t>', '<w:t></w:t>').replace('<w:t> HAZID</w:t>', '<w:t></w:t>')
    t = t.replace('<w:t>Doc. No: RA-RRT-VRV-001</w:t>', '<w:t>Doc. No: FRM-37-XXXX (to be allocated)</w:t>')
    t = t.replace('<w:t>Approved by: Director TSC</w:t>', '<w:t>Approved by: Technical Authority WCE</w:t>')
    t = re.sub(r'(<w:t[^>]*>)Approved by: </w:t>', r'\1Approved by: </w:t>', t)
    return t
hf = {}
for n in z.namelist():
    if re.match(r'word/(header|footer)\d\.xml', n):
        hf[n] = fix_hf(z.read(n).decode('utf8'))
        hf[n] = hf[n].replace('<w:t>Director TSC</w:t>', '<w:t>Technical Authority WCE</w:t>')

# ================= WRITE =================
with zipfile.ZipFile(OUT, 'w', zipfile.ZIP_DEFLATED) as out:
    for n in z.namelist():
        if n == 'word/document.xml': out.writestr(n, x.encode('utf8'))
        elif n == 'word/styles.xml': out.writestr(n, styles.encode('utf8'))
        elif n in hf: out.writestr(n, hf[n].encode('utf8'))
        else: out.writestr(n, z.read(n))
print('wrote', OUT, len(x))
