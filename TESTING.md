# Testing Log

These skills were not vibe-coded from nothing. `/vibe-audit` in particular was built, then run against real codebases of varying size, and refined after each run. This log records what it was tested against.

`/vibe-audit` was developed in collaboration with Matt "Kelly" Williams at Making Software Greener.

## Codebases audited

Lines are tracked source only (git-tracked files with real code extensions, excluding lockfiles, minified bundles, and dependency directories). Larger repos include vendored/framework code committed to the tree; the audits distinguish application code from vendored bulk.

| Codebase (anonymized) | Stack | Tracked LOC | Status |
|---|---|---|---|
| Two-sided events marketplace | Next.js + Supabase | 3,796 | 13 findings, 3 High, 6 Med, 4 Low |
| Fine-arts portfolio site | Static site (Astro) | 1,887 | 4 findings, 1 Med, 3 Low |
| Trading journal SPA | React + Vite + Supabase | 9,879 | 6 findings, 1 High, 2 Med, 3 Low |
| Travel-services platform | React SPA + edge functions + Postgres | 116,733 (~101k authored) | 7 findings, 1 Critical, 1 High, 1 Med, 4 Low |
| Subscription coaching platform | React/Capacitor + Vercel + Supabase | 163,174 (~160k authored) | 16 findings, 7 High, 6 Med, 3 Low |
| Open-source design tool | ClojureScript + Clojure | 480,464 | 15 findings, 1 High, 6 Med, 8 Low (strong posture) |

**Corpus totals: 6 codebases · 776k tracked LOC (~325k authored application code) · 61 findings, 1 Critical, 13 High, 22 Medium, 25 Low.**

All findings counts reflect the current (v5) methodology. The marketplace, fine-arts, and trading-SPA reports were re-run at v5 for consistency; the fine-arts count dropped (6→4) as tighter triage merged low-value items, and the trading SPA's unauthenticated CRM endpoint was re-rated Medium→High under the v5 client-side-gate and blast-radius rules. Demo-mode summaries for all six are in [vibe-audit/examples/demo-reports.md](vibe-audit/examples/demo-reports.md).

The nonprofit/guardianship site (~11k LOC) was cloned but not yet audited, a candidate for a future run.

### The finding the corpus is built around

One pattern recurred in four of the six audits, across unrelated stacks: **a single business rule implemented in several places, where the copy on the real write/read path is the weakest one.** A coordinator check enforced in the UI but not the server; an order total computed from client input while the DB holds the real prices; a paywall enforced in the browser while the content read path is open; an owner-protection guard present in one team-management path and missing in two siblings. Finding the bug is half the job, each of these ships with a concrete fix in its run record.

## Method

Each audit runs the same phased method the skill ships with: scope scan and system map, five specialist lenses (access, input safety, secrets/deployment, observability, tests/maintainability), a merge-and-verify pass that re-reads every cited line before it reaches the report, then the report. Every finding cites a specific file and line. Anything that couldn't be verified from the code available is logged as an assumption, never a finding.

The skill was revised between runs based on what each audit surfaced, see each skill folder's `examples.md` for the anonymized run records and calibration notes.

## Honest limits

- These are static reviews of source code. No audit here executed the app, ran a live database, or verified deployed configuration.
- Row-Level Security policies, environment configuration, and infrastructure sit outside most of these repos and are marked "could not verify" where relevant.
- `/vibe-audit` finds the class of problem common in fast, AI-assisted builds. It is a strong first pass, not a substitute for a professional security engagement on anything handling money, health data, or real personal risk.
