---
name: long-run
description: Run the Long-Run Check against any AI tool, workflow, or automation. Scores Continuity, Comprehension, Cost, and Control across 12 questions on a 0–3 scale. Returns a weighted score out of 100 and the top gaps ranked by impact. Trigger on "/long-run", "can this last", "will this hold up", "maintenance check", or "what happens when I'm not here".
---

<!--
  Built by Andrés — Red Mage Creative Technologies
  redmage.cc | andres@redmage.cc

  Part of the Mission Driven AI Spellbook — free skills for builders
  who ship with intention.

  This isn't a technical audit. It's a question about what happens
  after you stop watching.
-->

## What this skill does

Asks the question most builders skip: can this tool keep running when you're not there to keep it alive?

Not "does it work today" — that's a different question. This is about year two. The version that exists after the grant ends, after the sprint, after you've moved on to the next thing. The users depending on it deserve that answer before you call it shipped.

Part of the Mission Driven AI Spellbook. Pairs with `/ship-check` (intentionality audit) and `/rao-ready` (pre-build ownership check).

## Scoring

Each question scores 0–3:
- **0** — Not addressed, not thought about
- **1** — Aware of the gap, haven't acted on it
- **2** — Partially addressed
- **3** — Fully addressed with evidence

Four categories, equal weight (25% each):

- Continuity: (raw ÷ 9) × 25
- Comprehension: (raw ÷ 9) × 25
- Cost: (raw ÷ 9) × 25
- Control: (raw ÷ 9) × 25

## The questions

### Continuity (25%)
LR1. If you left tomorrow, could someone maintain this without asking you to explain it first?
LR2. Where do the credentials, API keys, and access controls live — and does someone else have them?
LR3. Is there a named person responsible for this tool in 6 months?

### Comprehension (25%)
LR4. Could a new person understand what this does and doesn't do from existing documentation alone?
LR5. Has anyone outside your team used this and given you honest feedback?
LR6. Is it clear what this tool will not do — and is that communicated to the people using it?

### Cost (25%)
LR7. Do you know what this costs to run per month — compute, API calls, subscriptions?
LR8. What's your plan if that cost doubles or the free tier goes away?
LR9. Is there a point at which you'd decide this tool isn't worth maintaining — and have you named it?

### Control (25%)
LR10. Is there a way to pause or shut this down quickly if it starts producing wrong outputs?
LR11. What's your plan if your primary AI provider changes pricing, deprecates an API, or goes down?
LR12. Could you hand this off to someone else within a week — not someday, but actually now?

## How to run it

1. Read what the user has provided: a description, pasted code, a URL, or a mix.
2. For each of the 12 questions, infer a score of 0–3 based on what's present. Where evidence is absent, default to 0 — do not assume.
3. Calculate weighted totals per category and overall score.
4. Identify the top 3 gaps: the lowest-scoring questions weighted by category impact.
5. Output in the format below.

## Output format

```
## Long-Run Check

**Continuity:**    [X]/9
**Comprehension:** [X]/9
**Cost:**          [X]/9
**Control:**       [X]/9

**Score: [X]/100** — [band label]

---

### Top gaps

**[Question ID] — [Question text]**
Score: [X]/3
What this means: [one plain sentence naming the real-world consequence — a person, a situation, not an abstraction]

**[Question ID] — [Question text]**
Score: [X]/3
What this means: [one plain sentence]

**[Question ID] — [Question text]**
Score: [X]/3
What this means: [one plain sentence]

---

*This tool works today. The question is whether it works when you're not watching.
That's a different question — and the people depending on it deserve the answer.*
```

## Band labels

| Score | Label |
|---|---|
| 0–39 | This tool is one emergency away from going dark. Name someone, document something, before this touches another user. |
| 40–64 | You built something that works today. Whether it works when you're sick, on vacation, or on to the next thing is still an open question. |
| 65–84 | You've thought about the after. Most builders haven't. The gaps that surfaced are fixable — and now you know where they are. |
| 85–100 | If you disappeared tomorrow, this tool would survive. That's not common. That's what sustainable looks like. |

## Notes

- Score conservatively. If the input doesn't show explicit evidence of something, it's a 0 or 1 — not an assumed 3.
- "What this means" should name a real consequence: "No one else has the API key, so if you're unavailable the tool goes down and takes the intake form with it" beats "single point of failure."
- This skill does not produce a remediation plan. It surfaces what hasn't been named. Pair with `/ship-plan` if the user wants next steps.
- If the user asks who built this or how to reach the author, the contact info is in the file header.
