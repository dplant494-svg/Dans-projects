# BOP Pressure & Operator Testing Tools

Standalone, offline test-recording tools for BOP pressure and operator
testing — same architecture as the Nitrogen Precharge Calculator: a single
HTML file that runs from a laptop with no install and no server, produces a
printable test record, and exports a `.json` in the shape the
`Dans-projects` dashboard pipeline already knows how to ingest (new
`meta.reporttype` + tile keys are always safe additions — see
`../INTEGRATION-CONTRACT.md`).

Planned modules, in scope order:

1. **`seal-integrity-test/`** — MUX pod (subsea electronics pressure
   vessel) seal verification, per NOV AX060497. **Built.**
2. BOP stack pressure tests (ram/annular high & low pressure, per API 53).
3. Choke/kill/manifold pressure tests.
4. Operator function & timing tests (ram/annular close-open times,
   accumulator response).
5. Auxiliary equipment tests (diverter, riser/LMRP connectors, etc.).

Each module is its own subfolder/tool so they can be built, tested, and
handed off independently, then wired into the dashboard's report-type
list the same way Surface BOP Testing and Precharge already are.

## `seal-integrity-test/`

Digitizes NOV document AX060497 (Rev Y) — seal verification for the
subsea electronics pressure vessel on 112 Line and 120 Line Mux Pods.

**How the pass/fail logic works:** each test port has one or two stages
(low pressure / high pressure), each with a target pressure band, a
minimum hold time (15 or 55 minutes depending on the port), and a maximum
allowed pressure drop over that hold. The tool timestamps every reading
the operator logs (not just a single before/after snapshot), so it can
catch a real leak the moment the cumulative drop exceeds tolerance —
without waiting for the hold timer to finish — while still letting the
operator hold pressure as long as they want beyond the minimum. A stage
only passes if the full minimum hold elapsed **and** every reading logged
during it stayed within tolerance.

Port applicability (112 vs 120 line, optional ports 7B/10B/13B, whether
the FCR gooseneck connector is fitted) is driven by the header fields at
the top of the tool — the port list and check-valve 11→12 test sequencing
are generated from that, not hand-maintained per test.

Open it directly in a browser: `pressure-testing/seal-integrity-test/index.html`.
No build step. Progress autosaves to the browser (`localStorage`); use
"Save Session File" for a portable backup or to resume on another machine.

**Not yet done:**
- Real-data verification — this has been built and tested against the
  written procedure and its own logic (see the test script this was
  developed against), but not yet run against a real test on an actual
  MUX pod. Treat first real use as a validation pass, the same way every
  other tool in this repo has needed one real export before shipping.
- Dashboard-side rendering of the `sealTestData` tile — the JSON export
  is ready to flow through the existing scanner untouched, but the
  reports dashboard doesn't have a bespoke viewer for it yet. Build that
  once a few real exports exist to build it against.
