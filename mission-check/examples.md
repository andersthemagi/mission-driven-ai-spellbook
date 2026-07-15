# /mission-check — Test Data

Reference runs for calibrating verdicts. Add new runs as the skill gets used.

---

## Run 001 — Two-sided events marketplace (idea stage)

> **ILLUSTRATIVE STAGED RUN — idea-stage walkthrough, not an audit of shipped code.**
> A worked example of `/mission-check` applied to a founding idea a solo builder brought to the skill. No repository, no users, no deployed product yet. Answers to unspecified questions are reasoned from what a realistic solo bootstrapped builder would say, and flagged as inferences.

**Date:** 2026-07-15
**Input:** A solo-built, pre-alpha two-sided events marketplace connecting independent artists/makers with in-person art-market coordinators, AI-assisted matching. Bootstrapped, no revenue model locked, no users yet, solo maintenance capacity. Competing against free tools (Instagram DMs, Google Forms, existing craft-fair platforms). Motivation includes supporting independent artists and local creative economies.

## Mission Check

**Verdict: PAUSE**

---

### What drove this verdict

**MC3 — Have you asked the artists and coordinators most affected whether they want this?** (unresolved)
You're building for independent artists and market coordinators, but the plan describes no conversations with either side. The "they need this" belief is yours, not theirs. If artists are content in Instagram DMs and coordinators trust their Google Forms, you'll build a marketplace nobody switches to — the classic two-sided cold-start, worse because you have no user on either side to seed it.

**MC10 — What problem does this solve, and is AI actually the right solution?** (partly resolved / concerning)
The real problem is matching-and-triage friction that free tools handle badly at scale — a genuine gap. But the AI-matching layer is the least urgent part: a two-sided marketplace lives or dies on liquidity (enough artists and events in the same place), not match quality. Leading with AI matching before you have ten coordinators and fifty artists solves the year-two problem while ignoring the month-two one that kills you.

**MC4 / MC5 — Solo capacity to maintain, and a named owner when things break** (structurally unresolved)
You are the entire team, so the owner is you by default — which means no coverage. A two-sided marketplace is ongoing operations (disputes, no-show coordinators, artists who feel wrongly rejected), not a ship-once tool. With no revenue model locked, can you sustain support for both sides through the 12–18 months a marketplace needs to reach liquidity, alone, unpaid?

---

### Before moving forward

PAUSE, not stop — the mission fit is real and the friction is real. Resolve before writing more code:

1. **Talk to the affected people first (MC3).** Interview 8–10 artists and 5–8 coordinators. Ask what they use today and what hurts. Don't describe your product; listen for whether the pain is worth switching tools for.
2. **Separate the marketplace from the AI (MC10).** Decide whether the value is "a place where artists and events find each other" (liquidity) or "smarter matching" (a feature). Build the first; the AI is a later layer, not the wedge.
3. **Name the sustainability plan (MC5/MC11/MC12).** Write down the weekly hours to run both sides, what happens to users if you burn out, and whether artists are actually worse off without you than with Instagram plus existing platforms. If the honest MC12 answer is "not much worse," that reshapes the idea.

What's strong and worth protecting: mission fit is direct (MC1) and explainable in one sentence (MC2). The gap isn't purpose — it's evidence and endurance.

---

**Calibration notes:**
- **PAUSE, not RECONSIDER:** two foundational questions (MC3, MC10) are unresolved, which can push toward RECONSIDER — but MC1/MC2 (mission fit) are clearly resolved and strong, and MC10 is "partly resolved" (a real problem exists). The pattern is "right direction, no evidence yet," which is what PAUSE is for.
- **Inferences flagged, not smuggled:** the scenario didn't state whether interviews happened (inferred no), whether there's a named owner (inferred: the builder), or maintenance burden (inferred from solo/no-funding). Each is marked unresolved/inferred, not asserted.
- **Community/trust questions deliberately underweighted:** MC7–MC9 (trust, exclusion, data) are real but not verdict-driving at idea stage with zero users and no data. Kept out of the drivers to avoid inflating the output with generic risk language.
