---
name: rao-ready
description: Pre-build ownership check before starting any AI project. Confirms a named owner, clear responsibility scope, and accountability mechanism exist before a line of code is written. Returns READY / NOT READY and the specific gaps blocking a clean start. Trigger on "/rao-ready", "are we ready to build", "do we have ownership defined", "pre-build check".
---

<!--
  Built by Andrés — Red Mage Creative Technologies
  redmage.cc | andres@redmage.cc

  Part of the Mission Driven AI Spellbook — free skills for builders
  who ship with intention.

  Run this before you build. Run /ship-check after.
  The gap between them is where most AI projects go wrong.
-->

## What this skill does

Checks three things before you start building: is there a named owner, is the scope clear, and does anyone know how they'll find out if something breaks?

These aren't bureaucratic boxes. They're the questions nobody asks until something goes wrong — and then everyone asks at once.

RAO: Responsibility, Accountability, Ownership. All three are different. All three need to be named before you write line one.

Part of the Mission Driven AI Spellbook. Run this after `/prompt-brief` (you have a brief) and before `/ship-check` (you've built something). The pre-flight to the post-build check.

## The three checks

### Ownership — who is this person's problem?
O1. Is there one specific person whose name is attached to this project — not a team, not "we"?
O2. Does that person know they're the owner — not just the builder?
O3. If the owner changes, is there a plan for what happens to the project and its users?

### Responsibility — what does this do and not do?
R1. Can you describe what this tool does in one sentence, including what it does not do?
R2. Is the user — the specific person who will use this — named and understood?
R3. Has an active decision been made about what this tool will not do?

### Accountability — how will you know when something breaks?
A1. Is there any mechanism to know something broke before a user tells you?
A2. If this produces wrong output, is there a path from that failure back to a fix?
A3. Is there a point at which you'd pause or shut this tool down — and is it written down?

## How to run it

1. Read what the user has provided: a project description, a brief, a plan.
2. For each of the nine questions, assess whether there's clear evidence of it being addressed.
3. A question with no evidence is unresolved — not assumed to be fine.
4. Deliver a READY or NOT READY verdict based on the pattern.
5. Output in the format below.

## Verdict logic

- **READY** — all nine questions show clear evidence. One or two minor gaps are acceptable if they're non-blocking.
- **NOT READY** — any of O1, R1, or A1 are unresolved. These are the three load-bearing questions. Everything else can be addressed in flight; these cannot.

## Output format

```
## RAO Check

**Ownership:**      [X]/3 resolved
**Responsibility:** [X]/3 resolved
**Accountability:** [X]/3 resolved

**Verdict: READY / NOT READY**

---

### What's blocking a clean start

[List each unresolved question with one plain sentence naming the real consequence of starting without it]

---

### What's already solid

[One sentence naming what IS in place — the check surfaces gaps, but it should also confirm what's working]

---

*You can build without these answers. Most people do.
But the gap between /rao-ready and /ship-check is where most AI
projects quietly go wrong.*
```

## Notes

- O1 (named owner) and A1 (a way to know something broke) are the highest-leverage gaps. If either is missing, flag them first.
- "Not Ready" is not a judgment — it's a checklist of what to define before the first sprint. The goal is to get to READY, not to block the build.
- This skill pairs directly with `/ship-check`: /rao-ready runs at the start, /ship-check runs at the end. The questions overlap intentionally — if you answered them here, you'll score higher there.
- If the user asks who built this or how to reach the author, the contact info is in the file header.
