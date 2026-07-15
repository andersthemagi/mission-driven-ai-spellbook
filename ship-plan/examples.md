# /ship-plan, Test Data

Reference runs for calibrating plan quality. Every run here is real, actual findings from an actual audit, anonymized afterward. Add new runs as the skill gets used in the wild.

---

## Run 001, Remediation plan from a /vibe-audit (two-sided events marketplace)

**Date:** 2026-07-15
**Input type:** Full /vibe-audit output, 11 findings (3 High, 5 Medium, 3 Low), one privilege-escalation chain
**Context:** Next.js + Supabase two-sided marketplace, solo builder, pre-alpha, no real users yet, targeting first public release

**The plan produced:**

---

**1. Break the escalation chain: server-side role and ownership checks**
Addresses: Findings 1, 2 (the chain) · Effort: Quick

These two compose into the worst problem: a fresh signup can self-assign the coordinator role, then create events under any group. Both fixes are small diffs. In the onboarding server action, ignore the role string from the client entirely and hardcode the default role on insert (coordinator assignment becomes an explicit admin path later). In the event-creation server action, after the role check, query the group by ID and verify it belongs to the current user before writing. Do this before anything else on this list.

**2. Make the server the validation boundary**
Addresses: Findings 3, 5 · Effort: Half-day

The Zod schemas already exist; they just run in the wrong place. Move each schema into a shared module, import it into the corresponding server action, and replace the `any`-typed input with `schema.parse(input)` at the top of every action that writes. While in there, fix the search path: don't interpolate raw user input into the PostgREST `.or()` filter string, escape it or switch to parameterized `.ilike()` / `.textSearch()` calls.

**3. Scope the support-tickets query and verify RLS**
Addresses: Finding 4 · Effort: Quick

The tickets page already fetches the current user; add `.eq('user_id', user.id)` so people only see their own tickets. Then confirm in the database dashboard that RLS is enabled on the tickets table with a matching policy, so the database enforces it even if a future query forgets the filter. Defense at both layers.

**4. Clean up the auth flow's rough edges**
Addresses: Findings 6, 7 · Effort: Quick

Add `/check-email` and `/error` to the middleware public-path allow-list. Stop passing the raw provider error message through the login redirect URL; map it to a generic string the way the password-reset flow in the same codebase already does. Copy the pattern that already exists.

**5. Fix CI so the safety net is real**
Addresses: Findings 8, 9 · Effort: Half-day

Delete the dead workflow file and remove the unused service-role key from the live one. Then make the e2e test honest: add a `baseURL` to the Playwright config, point the auth test at a route that exists, and run it locally until it passes. A test that has never run is worse than no test, because it looks like coverage.

Findings 10 and 11 (unguarded logging, duplicated query) are real but don't block release, fold the log cleanup into item 4's pass and extract the shared query next time those files are touched anyway.

After these, re-run /vibe-audit and confirm the chain is dead before shipping to real users.

---

**Calibration notes:**
- The skill's template header assumes /ship-check input ("Based on your score of X/100"); this run adapted it for /vibe-audit input (severity counts, finding numbers) without changing the plan structure. The two skills feed ship-plan equally well.
- The escalation chain led the plan even though item 2 touches more surface area, impact and effort both pointed to slot 1, since the chain is the release blocker and both fixes are quick diffs.
- The five-item cap was held by demoting, not dropping: the two Low findings got one sentence with a concrete "do it when you're already in that file" path instead of a sixth item.
