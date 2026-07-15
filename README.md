# Mission Driven AI Spellbook

Free, portable skills for builders who ship with intention — plain-markdown instructions that run in Claude Code, Cursor, Gemini CLI, or any coding agent.

Seven skills. One question each. The full journey from "should we build this" to "can it last."

Built by [Andrés @ Red Mage Creative Technologies](https://redmage.cc) — bilingual (EN/ES), accessibility-first consulting for nonprofits, B Corps, and mission-driven organizations.

---

## The journey

| When | Skill | The question |
|---|---|---|
| Before deciding | [`/mission-check`](#mission-check) | Should we adopt or build this? |
| Before building | [`/prompt-brief`](#prompt-brief) | Did we actually think this through? |
| Before shipping | [`/rao-ready`](#rao-ready) | Do we have a named owner? |
| At the ship gate | [`/ship-check`](#ship-check) | Are we shipping with intention? |
| At the ship gate | [`/vibe-audit`](#vibe-audit) | What's actually broken in the code? |
| After gaps surface | [`/ship-plan`](#ship-plan) | How do we fix what /ship-check found? |
| Long term | [`/long-run`](#long-run) | Can this last without us watching it? |

---

## Try it in 60 seconds

Have [Claude Code](https://claude.com/claude-code) (or any agent that reads SKILL.md files) and a codebase you shipped fast? This is the whole loop:

```bash
curl -sSL https://raw.githubusercontent.com/andersthemagi/mission-driven-ai-spellbook/main/install.sh | bash
cd your-project
claude
> /vibe-audit
```

Everything runs on **your machine with your own AI inference** — your code never touches anyone's server but your own AI provider's. No signup, no telemetry, no email gate.

Want a summary you can share without exposing your codebase? `/vibe-audit --demo` appends an anonymized 3–4 sentence readout: what kind of platform it is, what the audit found by severity, and the verdict — no file paths, no names, no fingerprint.

---

## Install

**All seven skills:**
```bash
curl -sSL https://raw.githubusercontent.com/andersthemagi/mission-driven-ai-spellbook/main/install.sh | bash
```

**One skill at a time:**
```bash
curl -sSL https://raw.githubusercontent.com/andersthemagi/mission-driven-ai-spellbook/main/install.sh | bash -s -- mission-check
```

Available skill names: `long-run` `mission-check` `prompt-brief` `rao-ready` `ship-check` `ship-plan` `vibe-audit`

Then invoke with `/skill-name` in any Claude Code session.

---

## Run it in any tool

Each skill is a plain-markdown instruction file (`SKILL.md`). Only the small YAML frontmatter (`name`/`description`) and the `/slash-command` invocation are Claude-Code-specific — **the body is portable**, and nothing in the skill logic depends on a particular model or vendor. Point it at whatever inference you already run:

- **Claude Code** — `install.sh` drops each skill in `~/.claude/skills/`; invoke with `/skill-name`.
- **Cursor / Windsurf** — paste a skill's `SKILL.md` body into a project rule (`.cursor/rules/`), or reference the file in chat and say "follow this."
- **Gemini CLI / Cline / Aider / any coding agent** — pass the `SKILL.md` as context or a system instruction, then ask it to run the skill against your repo.
- **Plain chat (any model)** — paste the `SKILL.md` body plus your code (or a repo path the tool can read) and ask for the report.

The `examples.md` in each skill folder shows the target output shape — hand it to the agent alongside the skill to anchor the depth and format.

---

## Updating

The skills improve as new failure patterns surface. To pull the latest, re-run the installer — it overwrites each skill with the current version (a plain copy, so your invocation never changes):

```bash
curl -sSL https://raw.githubusercontent.com/andersthemagi/mission-driven-ai-spellbook/main/install.sh | bash
```

See [CHANGELOG.md](CHANGELOG.md) for what changed between versions; the toolkit version is in [VERSION](VERSION).

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

### /vibe-audit

**For:** Builders who want an actual technical read on a codebase — not a self-assessment.

**The question:** What's really in the code?

Reads a local repo, a GitHub URL, or pasted files and produces an evidence-based risk audit: a system map, a ranked risk ledger with file-and-line citations, an AI-assist fragility check for vibe-coded smells, a "what breaks at 10x" scaling read, and a basic readiness scorecard. Every finding cites a real line of code — no external stats, no borrowed citations. Complements `/ship-check`: that one asks whether you thought about ownership, this one tells you what's actually in the code.

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

## Example runs

Real runs against real projects, anonymized. Each skill folder gains an `examples.md` as runs accumulate — use them to calibrate what good output looks like before running your own.

| Skill | Example |
|---|---|
| `/vibe-audit` | [Full golden-reference report](vibe-audit/examples/full-report-marketplace.md) + [six calibration runs](vibe-audit/examples.md) across ~776k LOC, incl. a 1-cent-checkout bug and a privilege-escalation chain |
| `/ship-check` | [Scoring a draft AI policy](ship-check/examples.md) |
| `/mission-check` | [mission-check/examples.md](mission-check/examples.md) |
| `/prompt-brief` | [prompt-brief/examples.md](prompt-brief/examples.md) |
| `/rao-ready` | [rao-ready/examples.md](rao-ready/examples.md) |
| `/long-run` | [long-run/examples.md](long-run/examples.md) |
| `/ship-plan` | [ship-plan/examples.md](ship-plan/examples.md) |

Every example is a genuine run — real code, real findings, identifying details removed afterward. None are mocked up, because a toolkit about catching unverified AI output shouldn't ship fabricated examples of itself. The full-length report is the depth/format reference: hand it to your agent so its output matches.

---

## What these skills are not

Honest boundaries, stated plainly:

- **Not a professional security audit.** `/vibe-audit` finds the class of problem that ships in fast, AI-assisted builds — authorization gaps, trust-boundary mistakes, validation that only exists in the browser. It is a strong first pass, not a substitute for a qualified security engineer on anything handling money, health data, or real personal risk.
- **AI findings need human verification.** The skills are built to cite file-and-line evidence precisely so you *can* check every claim. Check them. A finding you didn't verify is a rumor with a line number.
- **Scores are mirrors, not certifications.** A 90 on `/ship-check` means you asked the right questions — not that nothing can go wrong.
- **Your AI provider's terms still apply.** The skills run locally, but the model you point them at processes your code under whatever terms you've agreed to with that provider. Know them before auditing anything under NDA.
- **No warranty.** MIT license — free to use, adapt, and share, provided as-is.

---

## The framing

These skills don't judge ideas. They surface what hasn't been named yet.

Most AI project failures aren't technical. They're organizational: nobody owned it, nobody defined what failure looked like, nobody asked the people it was supposed to serve. These skills are the conversation you should have had before the sprint — made fast enough to actually have.

**Tech isn't magic. Your mission is.**

---

## Versioning & contributing

These skills are living documents. `/vibe-audit`, for instance, was refined across audits of ~776k lines of real code (see [TESTING.md](TESTING.md)) and will keep evolving as new failure patterns show up.

- **Versions** are tracked in [CHANGELOG.md](CHANGELOG.md); the toolkit version is in [VERSION](VERSION).
- **Proposing a change** — open a PR against the relevant `skill/SKILL.md`. Keep each skill under ~150 lines, declare its read-vs-write surfaces, and add a real (anonymized) run to that skill's `examples.md` if the change affects output.
- **Improvements welcome** from anyone building adjacent tooling — if your own audit process catches something this one misses, that's exactly the kind of change worth merging.

---

## About

Built by [Andrés Sepúlveda Morales](https://redmage.cc) at Red Mage Creative Technologies — independent consulting for nonprofits, B Corps, and mission-driven organizations. Bilingual (EN/ES), accessibility-first.

Questions, feedback, or want to work together: [andres@redmage.cc](mailto:andres@redmage.cc)

MIT License — free to use, adapt, and share.
