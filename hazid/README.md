# HAZID on the Seadrill template

`Seadrill_HAZID_Template.docx` and `HAZID_Knowledge_Digest.md` are Lee Arnold's, taken from the
Fleet HAZID Tool (`Seadrill_HAZID_Tool.html`, 22 Sep 2026) that embeds them. The digest condenses
DIR-37-0147 (Risk Assessment) and DIR-00-0100 (RAMP): PIMED, P.E.A.R, frequency A to E,
consequence 1 (high) to 5 (low), the Red / Yellow / Green acceptance criteria, the hierarchy of
controls. The template prints the risk matrix as a shaded table; `build-aab-hazid.py` reads the
grid from that table (consequence 1 to 5 by frequency E to A):

```
1: G Y R R R      G = Green  C6E0B4
2: G Y Y R R      Y = Yellow FFE699
3: G G Y Y R      R = Red    F4B6B6
4: G G G Y Y
5: G G G G Y
```

`build-aab-hazid.py` fills the template for the AAB process change (`../AAB-HAZID.docx`): cover,
revision history, sections 1 to 3, the 13-column register, the summary, ALARP, conclusion,
references, signature block, headers and footers. It also fixes the three template defects Lee's
handoff lists: three sections (portrait, landscape for the register and summary, portrait), the
heading colours in styles.xml set to Seadrill blue, and the register rows left free to split.
Run `python3 build-aab-hazid.py ../AAB-HAZID.docx` from this folder after editing the REGISTER
list. The table of contents refreshes when Word opens the file (right-click, Update field).
