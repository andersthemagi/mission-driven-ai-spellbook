# Mission Driven AI Spellbook

Free Claude Code skills for builders who ship with intention.

Six skills. One question each. The full journey from "should we build this" to "can it last."

Built by [Andrés @ Red Mage Creative Technologies](https://redmage.cc) — bilingual (EN/ES), accessibility-first consulting for nonprofits, B Corps, and mission-driven organizations.

---

## The journey

| When | Skill | The question |
|---|---|---|
| Before deciding | [`/mission-check`](#mission-check) | Should we adopt or build this? |
| Before building | [`/prompt-brief`](#prompt-brief) | Did we actually think this through? |
| Before shipping | [`/rao-ready`](#rao-ready) | Do we have a named owner? |
| At the ship gate | [`/ship-check`](#ship-check) | Are we shipping with intention? |
| After gaps surface | [`/ship-plan`](#ship-plan) | How do we fix what /ship-check found? |
| Long term | [`/long-run`](#long-run) | Can this last without us watching it? |

---

## Install

Copy any skill folder into your Claude Code skills directory:

```bash
# individual skill
cp -r mission-check ~/.claude/skills/

# or the whole spellbook
cp -r . ~/.claude/skills/
```

Then invoke with `/skill-name` in any Claude Code session.

> These skills use the SKILL.md format and work with Claude Code. The format is model-agnostic markdown — adaptable to Cursor, Gemini CLI, and other tools that support custom skill/instruction files.

---

## The skills

### /mission-check

**For:** Nonprofits, B Corps, and mission-driven orgs evaluating whether to adopt or build an AI tool.

**The question:** Is this actually right for us — our mission, our community, our capacity?

Covers mission fit, organizational readiness, community and trust, and honest need. Returns a **PROCEED / PAUSE / RECONSIDER** verdict with the questions that drove it. Output is paste-ready for a board update or grant narrative.

Written for teams of 2–20 where the ED also does the grant reports. Not for 50-person IT departments.

---

### /prompt-brief

**For:** Founders and builders about to start any AI feature, tool, or automation.

**The question:** Did you actually think this through before writing line one?

Forces five questions in under five minutes: the problem, the user, what good looks like, what failure looks like, and what this explicitly won't do. Returns a structured brief and the gaps that still need answers.

---

### /rao-ready

**For:** Any builder or team before starting an AI project.

**The question:** Do you have a named owner, a clear scope, and a way to know when something breaks?

RAO: Responsibility, Accountability, Ownership — all three are different, all three need to exist before you build. Returns **READY / NOT READY** and the specific gaps blocking a clean start. The pre-flight to `/ship-check`.

---

### /ship-check

**For:** Builders who've shipped AI-generated code and want to audit it.

**The question:** Did you ship this with intention — or did you just ship it?

24 questions across Ownership (40%), Responsibility (30%), and Accountability (30%). Returns a score out of 100, a band label, and the top gaps ranked by weighted impact. This isn't a security audit. It's a mirror.

---

### /ship-plan

**For:** Anyone who just ran `/ship-check` and wants to act on the results.

**The question:** What do we actually do about these gaps?

Turns `/ship-check` output into a prioritized remediation plan. Triages gaps by effort and impact, groups related fixes, and produces a plan you can work from — not just a list of problems.

---

### /long-run

**For:** Builders, teams, and orgs who've shipped something and want to know if it'll last.

**The question:** Can this tool keep running when you're not there to keep it alive?

12 questions across Continuity, Comprehension, Cost, and Control. Returns a score out of 100 and the top gaps. The question most builders skip — and the one the people depending on the tool most need answered.

---

## The framing

These skills don't judge ideas. They surface what hasn't been named yet.

Most AI project failures aren't technical. They're organizational: nobody owned it, nobody defined what failure looked like, nobody asked the people it was supposed to serve. These skills are the conversation you should have had before the sprint — made fast enough to actually have.

**Tech isn't magic. Your mission is.**

---

## About

Built by [Andrés Sepúlveda Morales](https://redmage.cc) at Red Mage Creative Technologies — independent consulting for nonprofits, B Corps, and mission-driven organizations. Bilingual (EN/ES), accessibility-first.

Questions, feedback, or want to work together: [andres@redmage.cc](mailto:andres@redmage.cc)

MIT License — free to use, adapt, and share.
