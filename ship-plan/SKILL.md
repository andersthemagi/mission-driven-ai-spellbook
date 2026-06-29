---
name: ship-plan
description: Takes the output of /ship-check and produces a prioritized remediation plan — what to fix, in what order, and roughly how much effort each takes. Trigger on "/ship-plan", "what do I fix first", "help me address these gaps", or "turn the scorecard into a to-do list". Run after /ship-check, not before.
---

<!--
  Built by Andrés — Red Mage Creative Technologies
  redmage.cc | andres@redmage.cc
  
  The planning companion to /ship-check.
  ship-check is the mirror. ship-plan is what you do next.
-->

## What this skill does

Takes the scorecard output from `/ship-check` — or a description of the gaps it surfaced — and produces a short, prioritized remediation plan. Not an exhaustive list. Not a compliance document. The three to five things worth doing first, in order, with honest effort estimates.

This is about momentum, not perfection. A score goes from 38 to 60 by fixing the right three things, not by answering all 24 questions at once.

## How to run it

1. Read the `/ship-check` output provided, or ask the user to paste it if they haven't.
2. Identify the gaps — low-scoring questions, weighted by category (Ownership gaps get prioritized over equal-scoring gaps elsewhere).
3. Group related gaps where fixing one also helps another.
4. Rank by: impact on score (highest weight first), effort to fix (quick wins surface earlier), and whether the gap blocks other gaps from being fixed.
5. Output the plan in the format below.

## Output format

```
## Ship Plan

Based on your score of [X]/100, here's where to start.

---

**1. [Short name for the gap]**
Addresses: [Question ID(s)]
Effort: [Quick / Half-day / Real work]

[2-3 sentences: what to actually do. Concrete. Not "consider implementing monitoring" — "set up a free Sentry account and add the error boundary to your root component."]

---

**2. [Short name for the gap]**
Addresses: [Question ID(s)]
Effort: [Quick / Half-day / Real work]

[2-3 sentences: what to actually do.]

---

**3. [Short name for the gap]**
Addresses: [Question ID(s)]
Effort: [Quick / Half-day / Real work]

[2-3 sentences: what to actually do.]

---

[Add items 4–5 only if they're meaningfully different from the above and worth doing soon. Stop at 5.]

After these, re-run /ship-check and see where you land.
```

## Effort scale

- **Quick** — under 30 minutes. Usually naming something that's already implicit, writing one sentence of documentation, or making one decision and recording it.
- **Half-day** — 2–4 hours. Setting something up, having a conversation, writing a short doc that didn't exist.
- **Real work** — more than a day. Involves building, integrating, or changing how the project is operated.

## Notes

- Be specific about the tool, platform, or step where possible. "Add error logging" is less useful than "add Sentry free tier and wrap your main function in a try/catch that logs to it."
- If two gaps are addressed by the same fix, combine them into one item.
- Don't moralize. The gaps aren't failures — they're things that hadn't been named yet. The plan is practical, not judgmental.
- Don't produce more than five items. A builder with 12 to-do items fixes zero of them. A builder with three fixes two.
- If the user scored 85+, tell them that and say the plan is optional — they've already done the hard work.
