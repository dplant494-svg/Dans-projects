# Training module — the AAB tab and the Seadrill Bulletin Board (Day 2, 13:00 to 14:30, forty minutes)

**Built by:** the dashboard session (Dan, 29 Sep: "we may as well do the AAB, it's pretty much us who's
done it"). Replaces the handoff to Eric; he is welcome to take the review minutes on the day.
**Pack pieces already done:** the two slides (`Seadrill_AAB_Loop_Slides.pptx`: how it works, the ethos)
and the how-to guide (`Seadrill_AAB_Loop_How-To_Guide.pdf`, 13 pages, given to every trainee).
**Demonstration set-up:** Settings B2 `Yes` (test mode) for the whole module, so every email goes to
the office and the class sees them on the trainer's screen; a TEST advisory on **West Vela**; the
trainer posts, trainees never do. B2 `No` at the end of the day. Delete the TEST files from
PostedReports afterwards, as on 28 September.

## Trainer's script

### 1. What an AAB is, and what this loop does (5 minutes, slide: the ethos)

1. DIR-37-0161: Alerts, Advisories and Bulletins. Priority 3 is "not required by Corporate, for
   information": no cost, no work order, no approval chain. Priority 1 and 2 stay in the corporate
   process and are not on the board.
2. What the rig owes: each crew's Technical Section Leader reads it, acknowledges it with a comment,
   attaches evidence when asked (§2.2.4). The rig never closes; Technical Services review and close.
3. Three pages and a tab: the rig page (open), the fleet compliance page (password), the create page
   (same password), the dashboard's AABs tab. One board, two doors.
4. Every action is a small file posted once and never edited. The scanner reads them all every ten
   minutes; the emails are immediate.

### 2. Creating and posting an advisory (12 minutes, live on the create page)

Open the fleet compliance page, type the password, click **Create or revise an AAB**. Say: one
unlock, twelve hours, both pages.

1. **AAB Number** `C1025TEST1` (say: the Synergi case number, the parent case), **Revision** 0,
   **Level** is fixed at Priority 3 (say why: this app creates Priority 3 parents only).
2. **Title** `TEST Ram packer extrusion on 18-3/4in 15K double ram BOP`. **Category** `BOP`.
3. **Issue Date** today, **Due Date** fourteen days out (the usual Priority 3 response period).
4. **eDocs Reference** and **Maximo parent case**: optional, show where they go and why the
   directive wants the parent case number.
5. **SFI codes**: tick 331. Say: names still to be confirmed, the code is what the dashboard shows.
6. Tick **This advisory asks the rig to attach evidence photographs**. Say: with this ticked the
   rig page refuses an acknowledgement with nothing attached; untick it for a read-only advisory.
7. **Applies to**: tick **West Vela** only. Say: only those rigs see it and only their four are
   emailed. Show **All rigs** and **Clear**, do not use them.
8. **Originator**: name and email. Say: this is who the acknowledgement emails come back to.
9. **What has happened**, **Why it matters**, **What the rig must do**: paste the three test
   paragraphs. Say: plain language, the rig reads these on the rig page and in the email.
10. **Reference documents**: one per line.
11. **Attachments**: choose the test bulletin PDF. Show the **BULLETIN** badge; say the first file
    is the one attached to the issued email. Show the "This AAB has no attachments" box and what
    the email carries instead (`no-bulletin.txt`).
12. **Photographs**: add one with a caption.
13. **Preview AAB**: read it as the rig will. **Print AAB**: the printed form. **Save Draft**: a
    file to finish later. **Load AAB file**: reopens a draft or an earlier advisory as the base for a
    revision.
14. **Post AAB**. The green box: *Posted, sent to the intake endpoint (HTTP 202)*. Say: that is the
    advisory issued; the file is the event.
15. Switch to Outlook: the issued email arrives within a minute, `[TEST MODE] [AAB C1025TEST1 rev 0]
    … - West Vela`, bulletin attached, red line naming the West Vela four. Read the red line aloud.

**Mistakes to show on purpose** (3 minutes inside the 12): post with no bulletin (the email carries
`no-bulletin.txt`); tick **withdraws** at revision 0 (the page refuses: a withdrawal is a new
revision); leave the originator email blank (the page refuses).

### 3. On the rig: acknowledging (10 minutes, live on the rig page)

Run the scan (or wait for it), then open `…/sacred/aab/bulletin-board.html?rig=vela` and Ctrl+F5.

1. Show the list: the state chip **outstanding**, the waiting-on line, dates, category, originator,
   the three sections, the reference documents, the bulletin link, the photograph.
2. **Acknowledge this advisory**: name, role from the dropdown (Technical Section Leader first, say
   why), crew A, today, a comment (say: required every time, §2.2.4), one photograph. Post. The
   page says *Posted*; crew A greys out.
3. Outlook: the acknowledgement email, To the originator and the rig's four, the photograph attached.
4. Crew B: comment, and a PDF in **Evidence documents**. Post. "Both crews have acknowledged."
5. Mistakes to show: post without a comment (refused); post with nothing attached when evidence is
   asked for (refused); try crew A again (greyed).

### 4. Technical Services: review and close (8 minutes, live on the fleet compliance page)

Run the scan, open the fleet page, Ctrl+F5.

1. The cards: overdue, open rig states, **Awaiting your review: 1**, percentage, current advisories.
2. The register row: West Vela chip **acknowledged**. Click the chip: who is left (nobody). Click
   the number: the advisory in full.
3. The Rigs table: **Acknowledged by** with both crews by name, role and date; **Evidence** 2
   item(s); **History and evidence** with the photograph and the document link.
4. Close: name, review comment, **Close this rig's case**. Outlook: "West Vela: Technical Services
   have reviewed and closed AAB C1025TEST1 rev 0 - …".
5. Say what closing means and does not: a review decision, never automatic, never the rig's.

### 5. The dashboard (5 minutes)

1. AABs tab: the master register, one row per advisory, West Vela chip **closed** after the scan.
2. Click the number: the whole advisory over the dashboard, documents, photographs, each rig's
   acknowledgements. Read-only.
3. The rig filter: a rig sees its own rows only.
4. The six states, on the legend under the table; overdue is a date, not an opinion.

## Workbook questions (answers for the trainer)

1. **Who has to acknowledge a Priority 3 advisory on a rig, and what must each acknowledgement
   contain?** The Technical Section Leader of each crew, A and B, each once; a comment every time;
   evidence (photograph or document) when the advisory asks for it.
2. **The chip on the fleet page says "acknowledged". Who acts next, and where?** Technical
   Services, from the fleet compliance page: review both crews and the evidence, then close with a
   name and a comment. The rig does nothing more.
3. **An email arrived but the rig page says "No advisory applies". What has happened, and what do
   you do?** The scanner has not run since the post (up to ten minutes) or the browser has an old
   copy; wait, then Ctrl+F5. If the acknowledgement fails to post, the page downloads the file:
   email it to the originator and it is filed by hand.
4. **What is the difference between "partly acknowledged" and "overdue"?** Partly acknowledged is
   one crew done and one not; overdue is any open state (outstanding or partly acknowledged) past
   the due date, shown with the day count. Both can be true at once.
5. **Can a rig close its own case? Can Technical Services acknowledge for a rig?** No and no. The
   rig acknowledges; Technical Services close. The two are never the same person.

## Slide content (one slide beyond the two already built)

"What the TSL does when an AAB email arrives": open the link in the email (already set to your rig);
read the three sections and the bulletin; on your tour, acknowledge as your crew with a comment;
attach a photograph or document if the advisory asks; the other crew's TSL does the same on theirs;
watch for the closure email from Technical Services; if the post fails, email the downloaded file
to the originator.
