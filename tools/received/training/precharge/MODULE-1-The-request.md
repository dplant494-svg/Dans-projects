# Module 1 — The request (20 minutes)

**Trainer:** Dan · **Tool:** Seadrill BOP Precharge Request form, **Rev 3** · **Class:** Day 2, 08:00–08:20
**Where the rigs meet it:** inside SSORT (embedded), or as the standalone page

> The request form is **deliberately unbranded**. The rigs meet it inside SSORT and it carries the
> corporate logo only — no product name. That is intentional; do not describe it as "the
> Precharge Pro form" in the room.

---

## What this module has to land

A precharge is only as good as the request. **Every recalculation and every delay we have had
traces to a field on this form**, not to the arithmetic. Twenty minutes, and the whole point is
the three mistakes in Part B.

---

# Part A — What the form asks for, and why (steps 1–10)

**1.** *Open the request form.*
→ **Say:** "This is what the rig fills in. It is not the calculator — it shares no code with it.
It produces a small file that loads straight into the calculator at our end." 📷 **01-01**

**2.** *Point at the **Guide** button in the header. Open it.*
→ **Say:** "Everything I am about to say is in here. If a rig asks what a field means, point them
at this rather than answering from memory." 📷 **01-02**

**3.** *Close the Guide. Walk the top block: Rig, BOP, Well.*
→ **Say:** "The BOP selector only appears for rigs that have two stacks. If you have one, you
will not see it — that is correct, not a missing field."

**4.** *Point at **Requested by** and **email**.*
→ **Say:** "This is who we come back to with a question. Put a person, not a mailbox — we lose
a day every time this is a generic address."

**5.** *The **seven mandatory fields**, which block the file if empty.* 📷 **01-03**

| Field | Why we cannot proceed without it |
|---|---|
| Rig | Selects that rig's hardware. There is no generic asset. |
| Well name | Goes on the sheet, the PDF and the filename; it is how the issued sheet is matched back to this request. |
| Minimum shear pressure | The requirement the whole calculation is checked against. |
| MAWHP | Feeds the blind-seal check. |
| Water depth | Sets the hydrostatic head. |
| Subsea temperature | Sets the gas density at depth. |
| Deck temperature | The temperature you will charge at — the answer is quoted here. |

→ **Say:** "Miss one of these and the form will not produce a file at all. That is deliberate.
An incomplete request that looks complete is worse than no request."

**6.** *Point at **Minimum shear pressure** and **Where it came from**.*
→ **Say:** "Tell us the source. It is not mandatory, but it is the single most useful optional
field on the form — it lets us sanity-check the number against the tubular." 📷 **01-04**

**7.** *Point at the temperature unit selector.*
→ **Say:** "°F or °C, your choice — but set the selector. The form checks the value against the
unit you picked."

**8.** *Point at **Well hop** and the depth list.*
→ **Say:** "A hop is one precharge used across several wells without pulling the BOP. If you
select yes, **you must list every depth** — the form blocks otherwise. We design one precharge
that works at all of them, so a missing depth is a precharge that may not cover where you
actually end up."

**9.** *Point at pump cut-in and cut-out.*
→ **Say:** "Cut-in must be below cut-out. These get swapped often enough that the form checks."

**10.** *Point at the free-text **changes** box.*
→ **Say:** "Anything that has changed on the stack since the last request. Rams, bottles,
anything. If in doubt, write it."

---

# Part B — The three mistakes, demonstrated on purpose (steps 11–22)

> Do each of these live. The warning text matters — read it aloud.

### Mistake 1 — the shear pressure off the wrong estimator column

**11.** *Enter MAWHP **3,500** and minimum shear pressure **5,200**.* 📷 **01-05**

**12.** *The warning appears.* Read it out:

> "The shear pressure looks high for a MAWHP of 3,500 psi. **Check you have read the column
> matching your MASP and not the 15,000 psi column — that is the single most common error on
> this form.**"

→ **Say:** "The estimator gives shear pressure in columns by wellhead pressure. People read the
15,000 column because it is the widest and the worst case. Against a MASP of 3,500 that is a
number thousands of psi too high."

**13.** → **Say:** "What happens if we do not catch it? We size a precharge for a requirement
that does not exist. Best case the rig charges higher than needed. Worst case it does not pass
at all and we spend two days on a problem that was a column."

**14.** *Point out it is a **warning**, not a block.*
→ **Say:** "It does not stop you. It cannot — occasionally the number really is that high. It
makes you look. That is the right balance: a hard block on a legitimate case just teaches people
to work around the form."

### Mistake 2 — temperature unit confusion

**15.** *Set the unit to °F and enter subsea **4**.* 📷 **01-06**

**16.** *Warning:* "Subsea temperature looks unusual. Please confirm the unit."
→ **Say:** "4 °F subsea. That is seawater at minus 15 Celsius. Someone has typed the Celsius
value with the selector on Fahrenheit."

**17.** *Now set deck temperature **38** and subsea **50**.* 📷 **01-07**
→ *Warning:* "Deck temperature is below the subsea temperature. Possible, but unusual — please
confirm."
→ **Say:** "Possible in the North Sea in February. Usually it means the two have been swapped."

**18.** → **Say:** "Temperature is not a rounding detail here. Subsea temperature sets the gas
density at depth; deck temperature is what your gauge reads while you charge. Swap them and both
halves of the calculation are wrong in opposite directions."

### Mistake 3 — pump settings transposed

**19.** *Enter cut-in **3,000** and cut-out **2,800**.* 📷 **01-08**
→ *Warning:* "Pump cut-in (3000) is not below cut-out (2800). Check the two have not been
swapped."

**20.** → **Say:** "A classic. The pumps cannot cut in above where they cut out."

**21.** *Also show the hard block: select **Well hop = yes** and leave the list empty.* 📷 **01-09**
→ **Say:** "This one does stop you. A hop with no depths is not a request we can work."

**22.** *Correct every field and generate the file.* 📷 **01-10**
→ **Say:** "That file loads straight into the calculator. Module 2 picks it up from there."

---

## Three questions for the workbook

**Q1.** A rig submits a request with MAWHP 3,500 psi and a minimum shear pressure of 5,200 PSIG.
**What does the form do, what is the likely cause, and why does it not simply reject it?**

> **A.** It raises a **warning** — that the shear pressure looks high for that MAWHP, and to
> check the column matching MASP rather than the 15,000 psi column, which it names as the most
> common error on the form. The likely cause is reading the estimator's 15,000 psi worst-case
> column against a much lower actual MASP. It **warns rather than blocks** because the value can
> legitimately be that high; a hard block on a valid case only teaches people to work around the
> form. It is the requester's job to confirm.

**Q2.** **Name the seven fields that will stop the form producing a file, and say why the well
name is one of them.**

> **A.** Rig, well name, minimum shear pressure, MAWHP, water depth, subsea temperature, deck
> temperature. The **well name** is mandatory because it appears on the sheet, in the PDF and in
> the issued filename, and is the key by which the issued sheet is matched back to this request.
> Without it the sheet cannot be filed against the request, and the notification has nothing to
> name.

**Q3.** A request selects **well hop = yes** but leaves the depth list empty. **How does this
differ from the shear-pressure case, and why?**

> **A.** It is a **hard error and blocks the file**, where the shear-pressure case is only a
> warning. The difference is that there is no legitimate version of a hop request with no depths
> — the whole point is to design one precharge that is valid at *every* depth, so a missing depth
> is a precharge that may not cover where the rig ends up. A high shear pressure can be genuine;
> an empty hop list never is.

---

## Slide content — Module 1

**Slide title: The request — get this right and the rest follows**

- **Seven mandatory fields.** Rig · well · shear pressure · MAWHP · water depth · subsea temp ·
  deck temp. Miss one, no file.
- **Tell us where the shear pressure came from.** Optional, and the most useful thing on the form.
- **Mistake #1, by a distance: the 15,000 psi estimator column** read against a much lower MASP.
- **Mistake #2: temperature units and the two temperatures swapped.** Subsea sets density at
  depth; deck is what your gauge reads.
- **Mistake #3: pump cut-in and cut-out transposed.** Cut-in sits below cut-out.
- **Warnings make you look; errors stop you.** Anything that can legitimately be unusual warns.
  Anything that is never valid blocks.
- **Well hop: list every depth.** One precharge has to be valid at all of them.
- **A person, not a mailbox**, in "requested by".

---

## Screenshot manifest — Module 1

Light mode, 1600 px wide, PNG, in `screenshots/`. **All ten supplied.** Each is a real render of
the delivered Rev 3 form with the stated values typed in and *Check my entries* pressed.

| # | Step | Shows | |
|---|---|---|---|
| 01-01 | 1 | Full request form, empty | ✅ |
| 01-02 | 2 | Guide modal open | ✅ |
| 01-03 | 5 | The seven mandatory fields flagged | ✅ |
| 01-04 | 6 | Shear pressure + "where it came from" block | ✅ |
| 01-05 | 12 | **The 15,000-column warning** — inline *and* in the summary box | ✅ |
| 01-06 | 15 | Subsea 4 °F — unit warning | ✅ |
| 01-07 | 17 | Deck below subsea warning | ✅ |
| 01-08 | 19 | Pump cut-in/cut-out warning | ✅ |
| 01-09 | 21 | **Hard block** — hop yes, no depths | ✅ |
| 01-10 | 22 | Completed form, all clear | ✅ |

> **One thing the shots turned up, worth a minute in the room.** The form **defaults to metric**
> — `m` for water depth and `°C` for temperature. Left alone, a rig typing 7,000 / 38 / 78
> meaning feet and Fahrenheit gets 22,966 ft and two Celsius temperatures, and picks up three
> extra warnings. The form catches it, but **setting the two unit selectors is part of filling
> the form in**, not an afterthought. Add it to step 7.
