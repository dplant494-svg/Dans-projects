#!/usr/bin/env python3
"""
build_gate.py — produces the GATED build of the Seadrill Bulletin Board from
the single ungated source, per PASSWORD-GATE-PATTERN-HANDOFF-2026-09-23.md §6.

Two builds, one source:
  - seadrill-bulletin-board.html          (ungated — offline use, email)
  - seadrill-bulletin-board-GATED.html    (gated — the only one that goes to the share)

Run this whenever the ungated source changes; never hand-edit the gated file.
"""
import hashlib
import re
import sys
from pathlib import Path

HERE = Path(__file__).parent
SOURCE = HERE.parent / "seadrill-bulletin-board.html"
FRAGMENT = HERE / "gate-fragment.html"
OUTPUT = HERE.parent / "seadrill-bulletin-board-GATED.html"

GATE_START = "<!-- PCGATE:START"
GATE_END = "<!-- PCGATE:END -->"

# Strings that must never appear in the gate's own visible text (the parts a
# locked-out visitor can read): UNC paths, drive letters, script extensions,
# literal server/share names. This is a generic net, not a list of Eric's
# actual infrastructure (which this build script has no way to know) — the
# handoff's point (§5.5) is to assert the *outcome*, not name specific strings.
FORBIDDEN_IN_GATE_TEXT_PATTERNS = [
    r"\\\\",            # UNC path start
    r"[A-Za-z]:\\",      # drive letter path
    r"\.ps1\b",
    r"\.py\b",
    r"http://",
    r"https://",
    r"\.corp\.local",
    r"sharepoint",
]


def main():
    source_html = SOURCE.read_text(encoding="utf-8")
    fragment_html = FRAGMENT.read_text(encoding="utf-8")

    if GATE_START not in fragment_html or GATE_END not in fragment_html:
        sys.exit("FAIL: gate fragment is missing its PCGATE:START/END markers")

    # --- Assertion: exactly one <body> tag in the source, and it is not
    # inside a JS string literal disguised as markup. Anchor on the
    # unambiguous sequence that also appears in this file's own structure.
    body_count = len(re.findall(r"<body>", source_html))
    if body_count != 1:
        sys.exit(f"FAIL: expected exactly one literal <body> tag in the source, found {body_count}")

    anchor = "<body>\n\n<header>"
    if anchor not in source_html:
        sys.exit("FAIL: could not find the expected '<body>' -> '<header>' anchor in the source; "
                 "the source layout changed — update this script's anchor deliberately, don't just widen the match")

    # --- Build: inject the fragment immediately after <body>, before <header>
    gated_html = source_html.replace(
        "<body>\n\n<header>",
        "<body>\n" + fragment_html.rstrip("\n") + "\n\n<header>",
        1,
    )

    # --- Assertion: gate is the first thing in <body> (its id appears before
    # the first <header in document order)
    pos_gate = gated_html.find('id="pcgate"')
    pos_header = gated_html.find("<header")
    if pos_gate < 0:
        sys.exit("FAIL: gate markup not found in the built output")
    if not (pos_gate < pos_header):
        sys.exit("FAIL: gate is not the first thing in <body> — a real page could flash before the overlay paints")

    # --- Assertion: byte-identical shared body. Removing exactly the
    # injected fragment from the gated output must reproduce the original
    # ungated source, unchanged.
    start = gated_html.find(GATE_START)
    end = gated_html.find(GATE_END) + len(GATE_END)
    if start < 0 or end < len(GATE_END):
        sys.exit("FAIL: could not locate the injected gate block in the built output to verify byte-identity")
    stripped = gated_html[:start] + gated_html[end:]
    # the injection added the fragment plus one newline before <header>; account for that
    stripped = stripped.replace("<body>\n\n\n<header>", "<body>\n\n<header>", 1)
    if stripped != source_html:
        sys.exit("FAIL: gated build's shared body is NOT byte-identical to the ungated source "
                 "once the gate block is removed — the two builds have silently diverged")

    # --- Assertion: no leaked infrastructure strings in the gate's own
    # VISIBLE text (only need to check the fragment itself, since that's the
    # only new visible text a locked-out visitor can read). HTML comments
    # are excluded — they document the pattern for maintainers and are not
    # rendered to a visitor; the handoff's concern (§5.5) is the login
    # screen's own wording, not code commentary.
    fragment_no_comments = re.sub(r"<!--.*?-->", "", fragment_html, flags=re.S)
    lower_fragment = fragment_no_comments.lower()
    leaks = [pat for pat in FORBIDDEN_IN_GATE_TEXT_PATTERNS if re.search(pat, lower_fragment)]
    if leaks:
        sys.exit(f"FAIL: gate text matches forbidden infrastructure-leak patterns: {leaks}")

    OUTPUT.write_text(gated_html, encoding="utf-8")

    # --- Report
    print("All build-time assertions passed:")
    print(f"  - exactly one <body> tag in source ({body_count})")
    print(f"  - gate is first in <body> (pos {pos_gate} < header pos {pos_header})")
    print("  - gated build's shared body is byte-identical to the ungated source")
    print("  - no infrastructure-leak patterns found in the gate's visible text")
    print(f"Wrote {OUTPUT} ({len(gated_html)} bytes)")
    print(f"SHA-256 of gated build: {hashlib.sha256(gated_html.encode('utf-8')).hexdigest()}")
    print(f"SHA-256 of ungated source: {hashlib.sha256(source_html.encode('utf-8')).hexdigest()}")

    # --- Generate set-password.html by lifting the sha256() function
    # verbatim out of the gate fragment — never retyped, per §5.1.
    m = re.search(r"  function sha256\(str\) \{.*?\n  \}\n", fragment_html, re.S)
    if not m:
        sys.exit("FAIL: sha256() not found in gate-fragment.html - has it changed?")
    sha_fn = m.group(0)

    salt_m = re.search(r"var SALT = '([^']*)';", fragment_html)
    if not salt_m:
        sys.exit("FAIL: SALT not found in gate-fragment.html")
    salt_value = salt_m.group(1)

    tmpl_path = HERE / "set-password-template.html"
    setpw_html = tmpl_path.read_text(encoding="utf-8")
    placeholder = "/*SHA256_FUNCTION_PLACEHOLDER*/"
    if placeholder not in setpw_html:
        sys.exit("FAIL: set-password template is missing its sha256 placeholder")
    setpw_html = setpw_html.replace(placeholder, sha_fn.strip())

    setpw_salt_m = re.search(r"var SALT = '([^']*)';", setpw_html)
    if not setpw_salt_m:
        sys.exit("FAIL: SALT not found in set-password template")
    if setpw_salt_m.group(1) != salt_value:
        sys.exit(f"FAIL: SALT differs between gate-fragment.html ({salt_value!r}) and "
                 f"set-password-template.html ({setpw_salt_m.group(1)!r}) — these must be identical")

    setpw_out = HERE.parent / "set-password.html"
    setpw_out.write_text(setpw_html, encoding="utf-8")
    print(f"Wrote {setpw_out} ({len(setpw_html)} bytes) — sha256() lifted verbatim, {len(sha_fn)} chars")


if __name__ == "__main__":
    main()
