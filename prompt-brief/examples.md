# /prompt-brief, Test Data

Reference runs for calibrating briefs. Add new runs as the skill gets used.

---

## Run 001, AI matching/triage feature (idea stage)

> **ILLUSTRATIVE STAGED RUN, idea-stage walkthrough, not an audit of shipped code.**
> A worked example of `/prompt-brief` applied before the first prompt is written. Nothing here reviews a running system. Where the builder didn't specify something, the skill reasons as a realistic solo builder would and flags the inference so it isn't mistaken for a stated fact.

**Date:** 2026-07-15
**Feature under brief:** the AI matching/triage feature of a solo-built, pre-alpha two-sided events marketplace (artists ↔ in-person market coordinators). Two directions: suggest fitting events to an artist from their profile, and help a coordinator triage applications by surfacing which applicants fit an event's theme and criteria.

---

## Project Brief

**Problem:** Artists waste time hunting for markets that fit their medium and location, and coordinators drown in applications they eyeball one by one, so good fits get missed on both sides.

**Who it's for:** Two distinct users, not one. (a) A working artist with a filled-out profile (medium, location, portfolio images, past events) who wants a short list of markets worth applying to. (b) A coordinator reviewing applications for one event with a set theme, date, location, and booth criteria, who wants help seeing who fits without reading every application cold. *Inferred, flag: the builder didn't describe coordinator volume or time pressure. The triage value depends on enough applications per event that manual review hurts. If most events get 10 applicants, this may solve a problem the coordinator doesn't have yet.*

**What good looks like:** Two observable checks, since there are no users to measure yet.
- Artist side: on seeded profiles, suggested events beat a plain medium-plus-location filter in a blind comparison. If the AI list isn't clearly better than a dumb filter, it isn't earning its cost.
- Coordinator side: the coordinator keeps the tool on after trying it and agrees with surfaced top applicants often enough to stop bypassing it. *Inferred, flag: "often enough" needs a real number before build (e.g. accepts the top-ranked group in 7 of 10 seeded events).*

**What failure looks like:** A real applicant who fits gets ranked low or filtered out and the coordinator never sees them, a person loses a booth to an opaque model. Same shape on the artist side. Recovery path (required): the coordinator always sees the full list, ranking is a suggested order never a hidden filter, every rank comes with a plain-language reason, and the coordinator can reset to unranked in one click. Concrete bias risk: portfolio images + location + past-events history can proxy for who's already had access, quietly favoring established artists over newcomers. That's the harm the builder was right to be nervous about.

**What this won't do (the boundary):**
- **Not auto-reject or auto-hide** any applicant. It ranks and explains; the human decides.
- **Not score artists on quality or talent.** It matches on stated fit, not "is this good art."
- **Not make the final acceptance decision** or notify an applicant of an outcome.
- **Not use protected or proxy attributes** (name, perceived gender, ethnicity, nationality) as ranking signals. *Inferred boundary, flag: the builder named accessibility and EN/ES but no fairness boundary. Added because a people-ranking feature without one has unlimited liability. Confirm.*
- Language and accessibility are **in scope as first-class**: match reasons render in EN/ES, and the ranking UI must be operable for screen-reader and keyboard users, since a ranking a coordinator can't perceive is one they can't override. *Inferred scope decision, flag: builder said these "matter" but not that they gate v1. Treating as gating; confirm.*

---

### Before you build, 4 gaps

1. **What good looks like (coordinator side), needs a number.** Set the agreement threshold before building, or "good matches" is unfalsifiable.
2. **Who it's for, validate the coordinator actually has the pain.** Confirm real events draw enough applications that triage hurts. If not, build the artist side first.
3. **The fairness boundary, confirm the line.** The brief proposes "no protected or proxy attributes; past-events history is a fairness risk, not a pure positive." Confirm, it shapes the prompt and the features fed to the model.
4. **Accessibility and EN/ES, confirm they gate v1.** The brief treats them as launch-blocking. If that's wrong, say so now; it changes what "done" means.

---

**Calibration notes:**
- **The skill surfaces definitions, it doesn't judge the idea.** Whether AI-ranking real people is wise here is a `/roast` question. This run flagged the bias harm as a thing to bound and deliberately stopped short of a GO/KILL verdict.
- **Every blank became a flagged inference, never a silent assumption.** The fairness boundary and accessibility-gates-v1 call were both invented to make the brief usable, and both are labeled "Inferred, flag / confirm this" so the builder can't mistake the skill's guess for their own intent.
- **"What good looks like" was forced to a testable shape despite zero users**, reframed around seeded-data blind comparison and a retention/agreement threshold, rather than accepting "good matches."
