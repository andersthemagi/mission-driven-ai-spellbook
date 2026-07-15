# /vibe-audit — Demo-Mode Report Gallery

`--demo` mode appends an anonymized, shareable summary to every audit: what kind of system it is, what was found by severity, the verdict, and what couldn't be verified — no project names, no file paths, no fingerprint. It's the block you can put on a slide, in a post, or in front of a room without exposing the codebase.

Below is one demo summary per real codebase `/vibe-audit` was run against this session, all at the current (v5) methodology standard. They range from a 1,900-line static site to a 480,000-line mature open-source platform — the point is to show the shape and honesty of the output across that whole range, including the case where the honest answer is "posture is strong."

For a full-length, unabridged report (all sections, evidence, code-sketch fixes), see [full-report-marketplace.md](full-report-marketplace.md). For the calibration notes on how the methodology evolved run-to-run, see [../examples.md](../examples.md).

---

## 1. Two-sided events marketplace — server-rendered web app + hosted Postgres/auth

A two-sided events marketplace on a server-rendered web framework over a hosted Postgres/auth backend, where vendors apply to events and coordinators post them. The audit found a three-link privilege-escalation chain: onboarding writes a client-supplied role with no server-side allowlist, event creation authorizes on that self-assignable field, and it then inserts a client-supplied group id with no ownership check — so any signed-up vendor can make themselves a coordinator and post events under groups they don't run. The same authorization rule is implemented three times with the weakest copy on the actual write path, support tickets have no server-side access gate, and search input is interpolated into a database filter DSL. The chain's severity hinges on row-level-security policies that weren't in the repo.

**Findings: 13 total — 0 Critical (chain escalates to Critical if RLS is absent) · 3 High · 6 Medium · 4 Low**
**Reviewed: ~30 files (all authored; risk concentrated in 3 server actions + 2 reads) · Could not verify: live RLS policies and table constraints**
**Verdict: not yet safe for real users — re-verify authority server-side and confirm RLS.**

---

## 2. Static fine-arts portfolio site — static-site generator + media CDN

A static fine-arts/portfolio site built on a static-site generator, with its image gallery pulled from a third-party media CDN at build time. The audit found no server runtime and no trust boundary that receives untrusted input — the one contact "form" is just an outbound link to a hosted form, and the CDN API secret is consumed at build and never shipped to the browser, so there are no Critical or High findings. What surfaced instead is build-time and maintainability drift: a dead gallery component whose import points at a file that does not exist, a CDN fetch whose folder filter is commented out so it returns every asset in the account, and debug logging left in with a stale "remove in production" note.

**Findings: 4 total — 0 Critical · 0 High · 1 Medium · 3 Low**
**Reviewed: 14 files + full-tree grep · Could not verify: that the host deploys a static build (an SSR misconfiguration would re-rate the debug logging upward) and the live CDN credential scoping**
**Verdict: safe to ship as a static brochure site — every open item is build-time correctness or hygiene, not runtime exposure.**

---

## 3. Trading-journal SPA — React + hosted Postgres/auth/storage

A trading-journal single-page app (React + Vite, talking directly to a hosted Postgres/auth/storage backend with one serverless edge function and user-uploaded chart images). Per-user data isolation is the strong part: row-level security is correctly enforced on every table and storage-write path, so trades and images can't leak across accounts even though the browser is untrusted. Risk is concentrated at the two spots that sit outside that boundary — a serverless CRM-write endpoint that takes anyone's input with no real user authentication, no origin restriction, and no rate limit (unbounded lead-spam and billed third-party calls), and a "registration closed" switch that lives only in the client while the signup endpoint stays open.

**Findings: 6 total — 0 Critical · 1 High · 2 Medium · 3 Low**
**Reviewed: ~20 files across the app and database layer (auth, data hooks, route guard, upload path, edge function, all migrations, deploy config) · Could not verify: live backend settings — the edge function's deployed JWT-verification mode, the signup toggle, the storage bucket's privacy flag**
**Verdict: not yet safe for public launch — the core data model is sound, but the endpoints outside row-level security need server-side backing first.**

---

## 4. Consumer travel-booking platform — React SPA + serverless functions + Postgres

A consumer travel-booking platform (React SPA + serverless edge functions + Postgres with row-level security, card payments via a hosted gateway and flights via a third-party air API). The audit found the data layer well-built — RLS enabled and correctly scoped on every sensitive table, no hardcoded secrets, admin actions verified server-side — but the checkout path computes each order's charged total from prices the browser submits rather than from the store's own price tables, and the payment step charges that client-derived total verbatim. A second, simpler variant lets the client name its own discount amount. Net effect: a guest can book real inventory for near-zero.

**Findings: 7 total — 1 Critical · 1 High · 1 Medium · 4 Low**
**Reviewed: ~14 files closely across ~101k LOC of authored source · Could not verify: live database state and whether the flight API runs in live or test mode**
**Verdict: not yet safe for real users — derive prices and discounts server-side from the DB.**

---

## 5. Subscription coaching platform — React/Capacitor + serverless + Postgres

A subscription mobile+web platform for a niche coaching vertical: a client-rendered SPA over a serverless API, a managed Postgres with row-level security, third-party auth, two payment processors, and a hosted video provider. The audit found the monetization boundary enforced almost entirely in the untrusted client: the premium media library is world-readable to any free account because a privilege-elevated database function and a public video-playback policy sit behind a browser-only paywall, and the checkout flow trusts client-supplied price and discount values. Around that core sit an unauthenticated destructive media endpoint, an unsigned provider webhook that drives privileged writes, and a payment webhook that fails open when a secret is unset. The worst chain is a pure business-logic bypass rather than a data breach.

**Findings: 16 total — 0 Critical · 7 High · 6 Medium · 3 Low**
**Reviewed: ~45 files across the server trust surface · Could not verify: live RLS policies on the user and content tables, and which webhook/bypass secrets are set in production**
**Verdict: not yet safe for paying users — the monetization boundary is enforced only in the browser.**

---

## 6. Mature open-source design platform — ClojureScript SPA + Clojure RPC backend

A self-hosted, open-source collaborative design/prototyping platform: a client-side SPA over a single authenticated command-RPC backend on a JVM runtime, with server-side media processing, document import/export, and anonymous share links. The audit of the auth, sharing, upload, and deployment boundaries found a fundamentally strong posture — modern password hashing, authenticated-encryption tokens, parameterized queries, disabled XML external entities, a thorough per-hop SSRF blocklist — with one privilege-escalation gap and a cluster of share-link scope weaknesses. The worst chain: an "owner-protection" business rule is enforced in one place but missing in two sibling code paths, letting a mid-tier admin promote themselves to full owner. No critical, unauthenticated, trivially-exploitable vulnerability was found.

**Findings: 15 total — 0 Critical · 1 High · 6 Medium · 8 Low**
**Reviewed: ~35 backend files across 5 lenses · Could not verify: the WASM render engine, plugins/exporter, and live per-deployment config**
**Verdict: safe for real users, conditionally — fix the admin→owner escalation and share-link scope gaps before relying on fine-grained sharing.**

---

## The through-line

Across six unrelated codebases and every size from 1.9k to 480k lines, the same shape recurs in the ones that fail: **a business rule implemented in several places, where the copy on the real write/read path is the weakest one.** A coordinator check the UI enforces and the server skips. An order total the browser gets to set. A paywall the browser enforces while the content path stays open. An owner-guard present in one path and missing in two. Different stacks, same failure — and the tool called the one well-built codebase *clean*, which is what makes the rest credible.
