# Argo Navis REV 13: review of the Field Guide and the project CLAUDE.md, from the dashboard side

**From:** the dashboard session · **To:** the reporting-tools session, to go to Lee with the rest of the feedback ·
13 October 2026. **Reviewed:** `SCHEDULE-BUILDER-USER-GUIDE.html` (Argo Navis Field Guide, covers REV 13) and the
project `CLAUDE.md` (REV 8 to REV 13 notes). Filed under `tools/received/dl1/rev13/`.

**Short version.** The tool and the guide are in good shape and they match what SACRED built against. Seven things
need a decision or a correction before the guide goes to a rig, and the biggest is not a wording point: the guide
describes a tool run from a Houston PC with two shared folders, and the rig is the planner. The rest is numbering,
the plan id, and a few lines that promise things not yet built.

## 1. Numbering: the posting build is REV 14, and SACRED will stop saying REV 11

CLAUDE.md is right that SACRED's 12 Oct replies say "REV 11". The posting build has been renumbered three times (REV
11 and REV 12 took read-only features, REV 13 took Argo Navis). From this note on, every SACRED document and plan
item reads **REV 14 = the build that posts to SACRED** (`plan`, `plan-progress`, `plan-closeout`, `plan-evidence`,
reading `seadrill-planlink_*` and `plans-open.json`). Nothing in the contract changes with the number.

## 2. The rig is the planner, so the inputs have to reach the rig (the one design point)

The guide's Step 1 connects two folders: the WO feed share `\\SEADRILL23339\Well Control Data` and the rules folder
(Job Plans and Durations, the Branch Map, the job plan workbooks, the Maximo lists), picked once with the browser's
folder picker, remembered in IndexedDB. That works on Lee's PC in Houston. It does not work offshore: a rig cannot
reach a Houston share, and a page served from the SACRED server cannot pick a folder on the server.

Dan's rule from 12 Oct is that **the rig is the planner**: the Subsea Supervisor builds the scope and presses Post for
review. So the inputs must come to the tool the way the CoC Tracker already does in REV 12 (fetched by URL on the same
origin, no clicks):

- SACRED publishes the inputs beside the tool: `/sacred/dl1/data/WO.csv` (copied daily from the feed share by the
  scanner, same 06:00 Houston refresh), `Job Plans and Durations.xlsm`, `Job Plan Branch  Sequence Map.xlsx`, the
  `Job plan detailed *.xlsx` workbooks, the three Maximo list exports, `synergi_lessons.json`, `wce_references.json`,
  `ssce-requests-data.js` (already published), `plans-open.json` (already published). One folder, read-only, listed by a
  small `index.json` the scanner writes (name, size, modified) so the tool can show the feed age without a directory
  listing.
- When Argo Navis is served from `/sacred/dl1/` it reads that folder by URL (same-origin `fetch`, exactly the
  `autoConnectCocTracker` pattern) and shows "Connected automatically" on all three inputs. The folder pickers stay for
  a PC with the shares.
- The Branch Map's lock-file rule still applies at the source: the scanner copies only when `~$...` is absent.

Dashboard side builds the publishing in the scanner (one `dl1\data` copy step, with `index.json`) when Lee says the
URL read is in; the share paths and file names come from the guide as written. Until then the tool is a Houston tool
and the guide should say so in one line at the top of Step 1.

## 3. The plan id is the key, not the Schedule Name

The guide says the Schedule Name (`20260901_WAU_BWM_BOP1_Schedule`) is how "the dashboard identifies your project".
That is true of the planning-report file (the WCGRRT-style Sync) and stays true. For everything REV 14 posts, the key
is **`planId` = `RIGCODE-BOPn-yyyymmdd`** (`makePlanId()`, e.g. `WVE-BOP1-20261005`): the scanner, the plan folder, the
Teams chat name, the email subjects and the SSORT plan picker all use it, and it must never change for the life of
the project. Ask: a line in Step 2 that shows the plan id beside the Schedule Name and says it is the project's name
everywhere else (the guide's `#banner-planid` already shows it, so this is one sentence).

## 4. Two routes out, and the guide only describes one

Step 5's "Sync to Dashboard: saves the JSON to the shared reporting folder" is the REV 13 route and needs the share.
REV 14 posts to SACRED's intake by HTTP, from anywhere, and the planning report keeps going as now. The guide should
carry both in the "Pushing it out" box, and the weekly rhythm should say which button is which once REV 14 ships.
Also: a rig cannot reach the shared reporting folder either, so for the rig the HTTP post is the only route.

## 5. Lines in the guide that promise things not yet built (mark "coming" or cut)

| Guide says | State today | Suggested wording |
|---|---|---|
| Step 6: the pre-deployment call "is recorded by SACRED's Help Centre" | the Plan Review tab is designed, pinned until Dan says go (SACRED item 53) | "will be recorded by SACRED's Help Centre when its Plan Review tab is live; until then these fields are the record" |
| Step 5: the 90 % notice "says the pre-deployment call is to be arranged" | the banner is in the tool; the Teams notice to all parties is SACRED's, after REV 14 posts the testing percent | keep the banner text; add "SACRED posts the same notice to the plan's Teams chat" once built |
| Troubleshooting: "3rd party costs missing from the dashboard: dashboard support needs building on Dan's side" | correct, nothing on the BOP page reads `thirdParty` | keep; SACRED adds it to the plan (below) |
| Pre-deployment: SSORT keeps a copy "for emergencies only" | agreed 12 Oct (Q7) | fine |
| Step 1: Job plan Checklist "copies Dan's checklist file to your local app-data folder" | right for a PC; on the server the file is served beside the tool at `/sacred/dl1/` | add "on the SACRED server it is already in place" |

## 6. Small corrections

- Troubleshooting first row says `http://localhost:8965`; the rest of the guide says 8966 (REV 13).
- "not active in Maximo" is still the banner wording in the Scope Challenge table, where the badge was renamed "not
  on the job plan lists" in REV 13 fix 6.
- `NO_ACOUSTIC_RIGS`: the SACRED side set N/A automatically for acoustic on West Vela, West Neptune and Sevan
  Louisiana (matrix Q3). Send the tool's list so the two agree, or SACRED takes the tool's.
- The sign-off order is a placeholder in both; Dan supplies it (open on the SACRED plan).
- The CoC Tracker URL constant names `REV6 1.html`. SACRED's Deploy publishes the tracker as-is from `tools/served`,
  so the name changes only when Dan drops a new file; SACRED will tell the tools session when it does.

## 7. What is good and should not change

- The additive-only payload rule, keying on the task's own id, the Branch Map colours as Dan's instruction channel,
  no P6 import: all as SACRED understands them.
- Checklist % drives the task % when a checklist exists (Lee, 12 Oct): matches the entry 70 reply (DL-1 is the one
  writer of the task percent; SACRED shows the checklist figure beside it, never folds it in).
- B-03, B-04, B-19 computed from the plan; N/A needing a reason and a rig-management approver; the SHA-256 on first
  signature with revisions on change: exactly the resolved matrix.
- The Excluded sheet now read, with excluded WOs arriving deferred and badged: right, and it also fixes a count on
  SACRED's side (they no longer appear in B-03 or G-01).
- The job plan gap report and `Branch_Map_Additions_DRAFT_for_Dan_2026-10-13.xlsx` (36 proposed rows): for Dan to
  review; nothing for SACRED.

## 8. Asks back to the tools session and Lee

1. Send the two drafts CLAUDE.md says are written and not sent: `DL1-ROLLING-HANDOFF-ENTRY-2_DRAFT.md` (REV 14
   numbering, plan shape, designation, slot, photo size, read-back file, JPC hosting) and
   `Argo-Navis_Maximo-Data-Request_DRAFT.md` (the G-01 ask for Manpreet). SACRED answers the first; Dan sends the
   second to Manpreet with the WO.csv refresh ask.
2. Confirm the REV 14 Post for review path: the first `plan` post (status proposed, scopeVersion 1) is what creates
   the plan on SACRED, the Teams chat and the emails. SACRED's `Plan Notifications` flow was built and proven on
   Lee's samples today (created, progress, frozen) and is live for the first real post.
3. The same-origin URL read of the inputs (section 2): yes or no, and which files.

## 9. What SACRED takes on from this review

- Publish the Argo Navis inputs under `/sacred/dl1/data/` with `index.json` (scanner), once Lee confirms section 2.
- Show 3rd party personnel and costs from the planning report on the BOP panel (new plan item).
- Rename REV 11 to REV 14 across the SACRED plan and handoffs.
- Align the no-acoustic rig list with the tool's.
