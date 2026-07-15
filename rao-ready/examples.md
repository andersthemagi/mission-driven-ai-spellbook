# /rao-ready — Test Data

Reference runs for calibrating the check. Every run here is real — an actual project assessed from actual evidence, anonymized afterward.

---

## Run 001 — Two-sided events marketplace (pre-alpha, solo builder)

**Date:** 2026-07-15
**Input type:** Full local repository — README, onboarding copy, routes, tests, CI config, git history
**Source:** A Next.js + Supabase two-sided marketplace connecting independent artists with event coordinators. Solo-built, pre-alpha.

**Output:**

## RAO Check

**Ownership:**      2/3 resolved
**Responsibility:** 3/3 resolved
**Accountability:** 0/3 resolved

**Verdict: NOT READY**

---

### What's blocking a clean start

- **A1 — no way to know something broke before a user says so.** No monitoring, alerting, or error-capture anywhere in the repo. Server actions log failures with `console.error` and move on, the error page is a static "Sorry, something went wrong," and the CI e2e suite can't act as a tripwire: the only app-facing spec asserts against a route that doesn't exist in the app. If signup breaks in production, the first alert is an annoyed tester.
- **A2 — a wrong output has no path back to a fix.** Errors are swallowed into server logs with no aggregation, no issue template, no feedback link in the app. A user who hits the failure page has no way to report what happened, and the builder has no artifact to debug from.
- **A3 — no written pause/shutdown criteria.** Nothing in the repo says what would make the builder freeze signups or take the app down. For a pre-alpha holding real user credentials, that line should exist before more testers arrive.
- **O3 — no succession plan.** Solo builder, no CONTRIBUTING, no ops notes, no handoff doc. Common for solo pre-alpha; still unresolved.

---

### What's already solid

Responsibility is the strong suit: the onboarding page states exactly what the product is and what it currently is not — a pre-alpha where only one side of the marketplace is enabled, the privileged role is actively disabled in the UI, and access to it is gated through a direct email to a named, reachable owner. That's a real scope decision plus a real named owner (O1, O2), not an accident of unfinished work.

---

**Calibration notes:**
- **R1 got credit despite a boilerplate README.** The canonical "what is this" surface is untouched framework stock, but the onboarding copy does the R1 job in one paragraph. Evidence in an odd place is still evidence; the gap noted was location, not absence.
- **A failing/misdirected CI suite doesn't count for A1.** CI exists and runs e2e tests on every push, which looks like a breakage tripwire — but the only app-facing spec can never pass, so it's noise, not signal. Metadata lost to the artifact.
- **O2 resolved via behavior, not documentation.** Nothing states "I am the owner," but routing privileged-role signups through the builder's own email inside the product is the owner accepting user-facing responsibility, not just committing code.
