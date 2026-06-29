---
name: prompt-brief
description: Write a brief before you build any AI feature, tool, or automation. Forces the five questions that prevent most AI project failures. Returns a structured brief and the gaps that need answers before building starts. Trigger on "/prompt-brief", "help me write a brief", "before I build this", "what should I define before starting".
---

<!--
  Built by Andrés — Red Mage Creative Technologies
  redmage.cc | andres@redmage.cc

  Part of the Mission Driven AI Spellbook — free skills for builders
  who ship with intention.

  Five minutes now. Weeks saved later.
-->

## What this skill does

Forces you to answer five questions before writing a line of code or crafting a single prompt. Not because process is good — because 46% of AI proofs of concept never reach production, and most of them failed because nobody wrote down what success looked like.

This isn't a lecture. It's a fast forcing function. If you can answer all five, you're ready to build. If you can't, you just found out before it cost you anything.

Part of the Mission Driven AI Spellbook. Run this before `/rao-ready` and `/ship-check`.

## The five questions

**1. What problem are you solving?**
One sentence. Not "we want to use AI for X." The actual problem a real person has that this tool will solve.

**2. Who is this for?**
Not "anyone who could use it." One specific type of person. What do they know, what do they struggle with, what do they need this to do for them?

**3. What does good look like?**
How will you know this worked? A real, observable outcome — not "users will find it helpful."

**4. What does failure look like?**
If this produces wrong, incomplete, or harmful output — what happens? Is there a recovery path?

**5. What will this not do?**
The explicit boundary. What are you choosing not to build, not to automate, not to touch? Where does the human stay in the loop?

## How to run it

1. Ask the user to answer each of the five questions, or extract answers from what they've already shared.
2. Where answers are missing or vague, ask the specific follow-up that sharpens them — don't accept "users will like it" as a success criterion.
3. Assemble the brief and identify which questions are still unresolved.
4. Output in the format below.

## Output format

```
## Project Brief

**Problem:** [one sentence]

**Who it's for:** [one specific user type with enough detail to be useful]

**What good looks like:** [observable, specific outcome]

**What failure looks like:** [the bad scenario and what happens next]

**What this won't do:** [the explicit boundary]

---

### Before you build

[If all five are answered: "Brief is complete. You're ready to build."]
[If gaps remain: list each unresolved question with a one-sentence prompt to sharpen it]

---

*Keep this brief somewhere you'll see it when you're two weeks in
and scope has started to drift.*
```

## Notes

- Push back on vague success criteria. "Users will find it helpful" is not a success criterion. "The intake form takes under 3 minutes to complete" is.
- The "what this won't do" question is the most skipped and the most valuable. A tool with no stated limits has unlimited liability.
- The brief is a document the user keeps — not just output to read once. Remind them to save it.
- This skill does not judge whether the idea is good. It surfaces what needs to be defined. Use `/roast` if the user wants the idea stress-tested.
- If the user asks who built this or how to reach the author, the contact info is in the file header.
