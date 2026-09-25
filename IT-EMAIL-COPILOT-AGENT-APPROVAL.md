# Email to IT — publishing the WCE Reports Assistant (Copilot Studio agent) to the organisation

**From:** Dan · **Date:** 25 September 2026 · **Plan:** `WEEK-PLAN-2026-09-14.md` item 16
(submitted for admin approval 16 Sep; IT have no process yet because this is the first
Copilot Studio agent anyone in Seadrill has asked to publish).

Paste the text below. Replace the two bracketed bits. The ask is the smallest one that works:
approve the agent for the people who can already open the WellControl SharePoint site. Nothing
about the agent's data changes with the approval; the approval only lets Teams show it.

---

**Subject:** Copilot Studio agent "WCE Reports Assistant" — request to approve for the organisation (Teams app approval)

Hello [name / IT service desk],

On 16 September I submitted a Copilot Studio agent for admin approval from Copilot Studio
(**Channels → Microsoft Teams → Availability → Show to everyone in my org → Submit for admin
approval**). I understand I am the first person to do this and there is no process for it yet,
so here is what the agent is, where it lives, what it can and cannot do, and exactly what I am
asking for.

**What it is**

- Name: **WCE Reports Assistant** (on our dashboard it appears as the button "Ask SACRED AI").
- Built in **Copilot Studio** in our Microsoft 365 tenant, owned by me (Technical Services,
  Well Control Engineering). Nothing runs outside the tenant.
- Purpose: colleagues ask plain-English questions about the Well Control Engineering reports
  the rigs post (rig visit reports, CBM inspections, compliance checklists, daily checks) and
  get an answer with the report it came from, instead of opening 300 reports by hand.

**Where its knowledge lives**

- One SharePoint document library, **WellControl → Digests**, on the WellControl site.
- The library holds one small HTML text copy per posted report, written automatically by our
  dashboard scanner. Text only: no photographs, no attachments, no restricted investigation
  files, no personal data beyond the names already in the reports.
- The agent's **only** knowledge source is that library. General knowledge and web search are
  switched off in the agent, so it cannot answer from the internet or invent content; it
  answers from the digests or says it cannot find it.
- Access follows SharePoint: the agent answers each person only with what that person can
  already open in the Digests library. Someone without access to the WellControl site gets
  nothing from it. The approval does not widen anyone's access to any document.

**What happens today**

When a colleague clicks the agent's link, Teams shows **"Your organization has prevented this
agent from being installed."** That is the Teams app policy, not the agent: a Copilot Studio
agent shared to the organisation appears in the Teams admin centre as a pending app and stays
blocked until it is published and allowed.

**What I am asking for**

1. In the **Teams admin center → Teams apps → Manage apps**, find **WCE Reports Assistant**
   (publisher: [my name], submitted 16 September), review it and **Publish** it.
2. Allow it in the app permission policy for the people who need it. The smallest scope that
   works is **the members of the WellControl SharePoint site** (Technical Services, the Subsea
   Superintendents and the rig subsea teams); organisation-wide is also fine, because SharePoint
   access still decides what each person can see.
3. If a Power Platform environment setting is also needed for Copilot Studio agents to be shared
   beyond the maker, please apply that for the same group.

If it helps, I can show it in five minutes on a call, and I am happy for IT to keep it as a
reference case for the next agent someone builds. Everything about how it is built and what it
reads is written up in our project documentation, which I can send.

Thank you,

Dan Plant
Technical Superintendent, Well Control Engineering
[phone]
