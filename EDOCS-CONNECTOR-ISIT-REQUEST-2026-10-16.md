# Request to ISIT: the OpenText eDOCS connector in Power Automate (SEADRILL-WC-DEV)

**From:** Dan Plant, Technical Services – Subsea. **Date:** 16 Oct 2026.

## Background

- **What it is for.** WCE's BOP maintenance plans (Argo Navis and SACRED) produce controlled PDFs: records, photographs and a close-out pack for each plan.
- **What happens today.** They are filed in SharePoint (WellControl, Between Wells Maintenance).
- **What we need.** When a plan closes, a Power Automate flow should copy them into eDOCS, under **Public Folders > WCE Master Database > Argo Navis Schedule Builder** (folder 11296372, library SEADRILL; test folder 11296373).

The connector **"OpenText eDOCS" (Create folder (V2) / Create document (V2))** is present in the SEADRILL-WC-DEV environment. Creating a connection asks for:

| Field | What we need from you |
|---|---|
| **API Key** (required) | "The API key for your company": the key for Seadrill's OneFox / PPC SaaS subscription that serves this connector |
| **Settings name** (required) | The configured settings name for Seadrill's eDOCS (server and library) in that subscription |
| **EDOCS Username / Password** (required) | **A service account** with rights to create folders and documents under folder 11296372 in library SEADRILL. Not a personal account. |
| **Override host URL** (optional) | Only if Seadrill's host differs from the default PPC SaaS host |

## Questions

1. Does Seadrill hold a OneFox / PPC subscription for this connector? If so, who owns the API key and the settings name?
2. Can a service account be created for this flow, with Create/Edit rights limited to folder 11296372 and below?
3. Is the connector's premium licence covered for SEADRILL-WC-DEV, or does the flow owner need a Power Automate Premium licence?
4. Are any profile fields mandatory on **documents** in library SEADRILL? For example: Document Type, Author, or Client/Matter.

## Handling

- The API key and the service account password are credentials. Please send them **directly into the Power Automate connection** (or to Dan by a secure route), not by email or chat.
- They are never stored in SACRED's files.
