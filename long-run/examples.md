# /long-run, Test Data

Reference runs for calibrating the check. Every run here is real, an actual project assessed from actual evidence, anonymized afterward.

---

## Run 001, Two-sided events marketplace (pre-alpha, solo builder)

**Date:** 2026-07-15
**Input type:** Full local repository, README, CI config, tests, dependencies, code, git history
**Source:** A Next.js + Supabase two-sided marketplace, solo-built, pre-alpha.

**Output:**

## Long-Run Check

**Continuity:**    1/9
**Comprehension:** 0/9
**Cost:**          0/9
**Control:**       1/9

**Score: 6/100**, This tool is one emergency away from going dark. Name someone, document something, before this touches another user.

---

### Top gaps

**LR11, What's your plan if your primary provider changes pricing, deprecates an API, or goes down?**
Score: 0/3
What this means: Auth, database, and all user data live in one managed backend, and the schema exists only inside that provider's project, no migrations in the repo. If the project is paused, deleted, or the account lapses, the app cannot be rebuilt anywhere. The code survives; the product doesn't.

**LR12, Could you hand this off to someone else within a week, not someday, but actually now?**
Score: 0/3
What this means: A new maintainer gets an unedited framework-boilerplate README, no setup steps, no schema, and a CI pipeline that cannot go green, the only e2e test targets a route that doesn't exist and the test config has no base URL, so it can't even reach the app. The green-checkmark ritual is theater; nobody inheriting this could tell working from broken.

**LR4, Could a new person understand what this does and doesn't do from existing documentation alone?**
Score: 0/3
What this means: The routes show a signup flow, onboarding, events, applications, and messaging, but the only way to learn that is to read the source. The first person who isn't the builder starts from zero.

---

**Full scoring detail:**

| Q | Score | Evidence |
|---|---|---|
| LR1 | 0 | No docs beyond boilerplate README; solo committer |
| LR2 | 1 | Credentials have a defined home (CI secrets + local env), but no evidence a second person holds them |
| LR3 | 0 | Solo project, no named backup owner anywhere |
| LR4 | 0 | README is unedited framework output; zero product or architecture docs |
| LR5 | 0 | Pre-alpha, no evidence of outside users or feedback |
| LR6 | 0 | No scope statement, no docs to communicate limits |
| LR7 | 0 | No cost tracking or notes; presumably free tiers, but nothing named |
| LR8 | 0 | Total single-provider dependence, no abstraction layer, no exported schema |
| LR9 | 0 | No kill criteria named anywhere |
| LR10 | 1 | The managed backend gives a real pause switch, but no monitoring exists to know when to pull it |
| LR11 | 0 | Schema not in repo; auth + data both locked to one provider |
| LR12 | 0 | Boilerplate README, no runbook, CI gate that cannot pass as configured |

---

**Calibration notes:**
- **LR2 and LR10 got 1s, not 0s, on platform-inherent evidence.** Secrets wired through CI is an observable credential home, and a fully managed backend genuinely can be paused from a dashboard. Neither rises to 2 because nothing shows a second person has access or that anyone would know when to act.
- **The broken CI counted against Control and Continuity, not for them.** A pipeline exists, which usually earns partial credit, but this one cannot pass as configured. A gate that can't go green is worse than no gate for a handoff, because it misleads the inheritor.
- **Missing schema ranked as the top gap over missing docs.** Docs can be written after the fact; data and schema locked in a single external project is the one gap that can become unrecoverable, so LR11 leads even though four categories tied near zero.
