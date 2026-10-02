# If SACRED is rebuilt on Lovable: what Lovable can and cannot do for it

**Written:** 2 October 2026, dashboard session, after Dan: "we will be handing off the whole thing to Lovable if
it gets the go-ahead; we will have to rebuild this; is there anything Lovable cannot do?" This is a planning note
for the rebuild, not a position on the decision. It describes Lovable as the session understands it (an AI app
builder that produces a React web app with a Supabase backend: Postgres database, authentication, file storage,
server-side functions; hosted by Lovable, with the code exportable to GitHub). **Viren owns the licences and
should confirm the current enterprise features: single sign-on, data region, self-hosting, file size limits.**

## What carries over as-is (no rebuild)

- **The data model.** The scanner's normalised export (21 tables, schema 2) and the Fabric DDL are the schema. A
  Postgres database takes the same tables; the 17,751 rows of history load from the CSVs.
- **The posting contract.** `meta.asset`, the one-file report, the size ceilings, the file naming. A Lovable
  upload endpoint can accept exactly what the tools post today, so the rig tools need not change on day one.
- **The rules.** Everything in `INTEGRATION-CONTRACT.md`, the HAZID, the test-mode rule, "a computed judgement
  is never shown as a recorded fact", the training well names. They are about the data, not the platform.
- **The training material and the ORR.** Most of the workbook is about process and people.

## What is rebuilt

| Part | Today | On Lovable | Effort, honestly |
|---|---|---|---|
| The pages (dashboard, Bulletin Board, Help Centre, precharge pages) | static HTML written by the scanner, about 5,000 lines of rendering | React pages over the database | the main rebuild; the views and their rules are documented, the look is in the dashboard file |
| The scanner | PowerShell every ten minutes over OneDrive sync | gone; an upload endpoint writes the database row and files on arrival | simpler; the digests become database views or a search index |
| Notification flows | five Power Automate flows, test mode, receipts | either keep them (Lovable calls the HTTP triggers, flows unchanged) or rebuild as server functions sending mail | keep them; the mailbox and the Teams posts stay in the tenancy |
| Ask SACRED AI | Copilot Studio over SharePoint digests | either point it at a new source, or an assistant inside the app calling a model with the database as context | new source is the small change; in-app assistant is a rebuild |
| Precharge calculator | Rev 87, arithmetic never touched | ported as-is, then re-verified against the issued sheets and the training wells | port, do not rewrite; the verification set exists |
| Rig tools | single HTML files on rig laptops, local auto-save | unchanged on day one (they post to the new endpoint); later, hosted forms with offline auto-save if wanted | zero on day one; a rebuild of their own later |

## What Lovable cannot do, or cannot do alone

1. **Run inside Seadrill's network.** A Lovable app is hosted on the public internet. It cannot be the IIS server
   on `sdrlazneuiis01d`. If ISIT require internal-only hosting, the code is exported and self-hosted, which hands
   the hosting problem straight back to ISIT. The decision needs that question answered first.
2. **Live inside the Microsoft tenancy.** Reports, photographs and names sit in Supabase (Postgres and storage),
   not SharePoint. Data region can be chosen; residency, retention and the security review have to be done for
   that store. ORR items 16, 27 and the SAML row apply to it in full.
3. **Sign people in with Seadrill accounts without an app registration.** SSO (SAML or OpenID Connect against
   Entra ID) is an enterprise feature of the auth layer and needs an Entra app registration from ISIT: the same
   small ask the dual-write needed. Without it, users have separate passwords, which is what the precharge gate
   is today and the ORR already marks as not acceptable for production.
4. **Send email from a Seadrill mailbox or post to Teams by itself.** That needs Microsoft Graph with an app
   registration, or a third-party mail service (which is a new vendor and a new review). Keeping the Power
   Automate flows avoids both; the app just calls the trigger URL.
5. **Read SharePoint, OneDrive or the Maximo export folder by itself.** Same answer: Graph plus an app
   registration, or the flows do the reading.
6. **Work offline.** A hosted form needs the link. Rigs have Starlink, so it is usually there, but a rig report is
   filled over hours and a half-finished form must survive a dropout. That is why the tools are files with local
   auto-save. A Lovable form can be built to auto-save locally, but it has to be built and tested for it; it is not
   the default.
7. **Take a 40 MB report with photographs without limits being set.** Storage file-size limits are configurable
   but have to be set and paid for; the free and low tiers refuse large uploads. The ceilings in the contract
   (10 MB, 40 MB CBM) must be carried across deliberately.
8. **Be reached from a rig that corporate provisioning blocks.** The "selective test provisioning" that blocks
   rigs from the sacred server will block a public app too unless the rig networks are provisioned for it.
9. **Replace Power BI or Fabric.** The Fabric database exists; a Lovable app with its own Postgres is a second
   copy unless one of them is dropped. Decide which is the system of record before any data is loaded twice.
10. **Guarantee the arithmetic.** Precharge Pro's calculations and the CBM grading rules are ported by hand or by
    the builder; either way they are re-verified, not trusted.

## Governance, which no platform fixes

- **Who maintains it.** Today Dan owns and maintains the tools and the pages through build sessions. On Lovable the
  same model works (prompts and a code export), but Viren owns the platform. The RACI needs the application owner
  named before the rebuild, or ISIT get a hosted app nobody maintains.
- **What the rigs see during the rebuild.** The current SACRED keeps running on the UAT server until the Lovable
  app passes the same parity test planned for the database (M10): the same pages from the new source, files as
  fallback, two clean weeks.
- **The three things to carry across by hand:** the HAZID, the MOC and the training packs. They reference pages
  and buttons by name; a rebuild changes names.

## The decision in one line

Lovable can rebuild the pages and the scanner's job, and it can host them; it cannot by itself sign Seadrill people
in, send Seadrill mail, read Seadrill SharePoint, or sit inside Seadrill's network. Each of those is an ISIT
provisioning ask, the same asks the current build has been waiting on since September. The platform changes where
the work is, not whether ISIT have to do it.
