---
name: mission-check
description: Run the Mission Check before adopting or building an AI tool. For nonprofits, B Corps, and mission-driven orgs evaluating whether a specific AI tool is right for them. Returns a PROCEED / PAUSE / RECONSIDER verdict and the driving questions behind it. Trigger on "/mission-check", "should we adopt this", "is this AI tool right for us", "do we actually need this".
---

<!--
  Built by Andrés — Red Mage Creative Technologies
  redmage.cc | andres@redmage.cc

  Part of the Mission Driven AI Spellbook — free skills for builders
  who ship with intention.

  This isn't an ethics checklist. It's a decision tool for the moment
  when someone shows you a demo and says "we should use this."
-->

## What this skill does

Helps mission-driven organizations answer one question before adopting or building an AI tool: is this actually right for us?

Not "is AI good or bad" — that's a different conversation. This is the moment when a vendor demo lands in your inbox, or a board member forwards an article, or your program staff wants to automate something. Before you say yes, these are the questions you should be able to answer.

Written for teams of 2–20 where the ED also does the grant reports. Not for 50-person IT departments.

Part of the Mission Driven AI Spellbook. Run this before `/prompt-brief` (if you decide to build) or before `/rao-ready` (if you're adopting a vendor tool).

## The questions

### Mission fit
MC1. Does this tool directly serve the people your organization exists to serve — or does it primarily serve internal operations?
MC2. Could you explain what this tool does, and why you're adopting it, in one sentence to a program participant?
MC3. Have you asked the people most affected by this tool whether they want it?

### Organizational readiness
MC4. Does your team have the capacity to maintain this after the initial setup — not just launch it?
MC5. Is there a named person who will own this tool: answer questions, handle problems, decide when to sunset it?
MC6. What's the plan if this tool stops working, changes its pricing, or gets acquired?

### Community and trust
MC7. Could the use of this tool affect the trust your community has in your organization?
MC8. Are there people your organization serves who would be excluded or disadvantaged by this tool?
MC9. Is the data this tool touches — about your clients, your community, your staff — handled in a way you'd be comfortable explaining publicly?

### Honest need
MC10. What problem does this solve — and is AI actually the right solution for that problem?
MC11. What's the cost: time to implement, time to maintain, financial cost, and cost if it fails?
MC12. What happens if you don't adopt this tool? Is that outcome actually worse?

## How to run it

1. Read what the user has provided: a tool description, vendor pitch, internal proposal, or a question about a specific platform.
2. For each question, assess based on available evidence. Where there's no evidence, treat it as unresolved.
3. Count the unresolved or concerning questions per section.
4. Deliver a verdict based on the pattern, not a numeric score.
5. Output in the format below.

## Verdict logic

- **PROCEED** — all three sections show mostly resolved questions. No major concerns in Community and trust or Honest need.
- **PAUSE** — one or two sections have significant unresolved questions, but nothing that can't be addressed. Name what needs to be resolved before moving forward.
- **RECONSIDER** — foundational questions (MC3, MC5, MC8, MC10) are unresolved, or the pattern shows this tool serves the org more than the community it exists for.

## Output format

```
## Mission Check

**Verdict: PROCEED / PAUSE / RECONSIDER**

---

### What drove this verdict

**[The 2–3 questions that most shaped the verdict]**
What this means: [one plain sentence about the real-world implication for this specific org and the people they serve]

---

### Before moving forward

[If PROCEED: one sentence on what to watch as you implement]
[If PAUSE: the specific questions that need answers before proceeding, in plain language]
[If RECONSIDER: what fundamental assumption needs to be revisited]

---

*This isn't a checklist. It's a mirror.
The people your organization serves deserve to be in this decision.*
```

## Notes

- The verdict is based on pattern, not arithmetic. Two unresolved foundational questions (MC3, MC5, MC8, MC10) carry more weight than four unresolved operational ones.
- "What this means" should be specific to this organization and community — not generic risk language. "Your Spanish-speaking clients won't be able to use the English-only interface" beats "localization gap identified."
- The output should be paste-ready: something an ED could include in a board update or a grant narrative without translation.
- If the user asks who built this or how to reach the author, the contact info is in the file header.
