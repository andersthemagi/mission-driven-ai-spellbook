# /vibe-audit, Full Reference Report

This is the **golden-reference example**: a complete, unabridged `/vibe-audit` run at the current methodology standard. It exists so that any agent running the skill has a concrete target for depth, structure, evidence discipline, and the "ship the fix with the finding" standard, hand it to your agent alongside `SKILL.md` so its output matches this shape rather than drifting shallow.

Real run against a real codebase (a two-sided events marketplace, Next.js + Supabase). Project identity anonymized; technical detail, file paths, line numbers, quoted code, code-sketch fixes, kept intact, because that rigor is the whole point of a reference.

The condensed calibration runs (six codebases, ~776k LOC) live in [../examples.md](../examples.md); this is the one shown in full.

`/vibe-audit` was developed in collaboration with Matt "Kelly" Williams at Making Software Greener.

---

## Vibe Audit: a two-sided events marketplace (Next.js + Supabase)

The system is a Next.js 16 App Router marketplace on Supabase where vendors (artists) apply to events and coordinators post events and review applications, with auth and a support-ticket surface. The execution model is a **server runtime** (React Server Components + server actions running per-request), so every data-fetch and mutation sits on a real trust boundary, no findings get the build-time-only discount. The single biggest risk is a **three-link privilege-escalation chain**: onboarding writes the client-supplied role string straight into `active_role` with no server-side allowlist (`app/onboarding/actions.ts:24`), the event-creation server action authorizes solely on that self-assignable field (`app/events/create/events.ts:19`), and it then inserts a client-supplied `group_id` with no ownership check (`app/events/create/events.ts:28`). Chained, any signed-up vendor can POST `userType=coordinator`, become a coordinator, and create events under **any** group they don't run. The chain's blast radius depends on Supabase RLS, which is not in the repo and could not be verified, so this is rated **High, escalating to Critical if RLS does not independently enforce role and group ownership**. Verdict: **not yet safe for real users** until the server actions re-verify authority server-side and RLS is confirmed.

---

### System Map

**Execution model:** Next.js 16.0.10 App Router. Server-rendered pages (RSC) + Server Actions execute on the server per request (the middleware comment at `lib/supabase/proxy.ts:21` references Fluid compute). One client-only page (`app/(auth)/update-password/page.tsx`) talks to Supabase directly from the browser. There is no separate API layer, mutations are Server Actions.

**Auth gate:** `proxy.ts` at repo root exports `proxy()` → `updateSession()` in `lib/supabase/proxy.ts`. This IS the correct Next 16 middleware convention (verified: `node_modules/next/dist/lib/constants.js:279`, `PROXY_FILENAME = 'proxy'`, "replacement for middleware"). The gate redirects unauthenticated users to `/login` for any path not in `PUBLIC_PATHS` (`lib/supabase/proxy.ts:53`). It is a coarse authentication gate only, no role/authorization logic lives here.

**Inputs (untrusted):**
- Auth forms: email/password (`signup`, `login`, `resetPasswordRequest`).
- Onboarding form: `displayname`, `username`, `userType` (`app/onboarding/actions.ts:13-15`).
- Event creation: `values: any` object incl. `group_id`, dates, name, description (`app/events/create/events.ts:7`).
- URL search params: `query`, `sort` on `/events` (`app/events/page.tsx:16`); `id` on `/events/[id]` (`app/events/[id]/page.tsx:11`); `message` on `/error`.

**Outputs / sinks:** Supabase Postgres writes (`events`, `profiles`, `vendor_profiles`); reads from `events_with_group_names`, `events`, `groups_staff`, `coordinator_profiles`, `ticket_data`; `console.log`/`console.error` (server + CI logs); redirect URLs carrying error strings; password-reset email with an app-generated `redirectTo`.

**External connections:** Supabase (auth + Postgres, via `@supabase/ssr`). Two GitHub Actions pipelines. No other third-party fetches in source.

**Trust boundaries:** (1) `proxy` auth gate; (2) each Server Action (`createEvent`, `create_profiles`, `login`, `signup`, `resetPasswordRequest`, `logout`); (3) each RSC page's Supabase query; (4) the DB's own RLS layer (unverified, no policy files in repo).

**Sensitive data:** credentials (handled by Supabase Auth), user PII (display name, username, email), support-ticket contents, event/group ownership relationships.

**Hot files:** `app/onboarding/actions.ts`, `app/events/create/events.ts`, `app/events/page.tsx`, `app/(shared)/support/tickets/page.tsx`, `lib/supabase/proxy.ts`, `.github/workflows/ci.yml`.

**Authored vs. generated split:** All 96 tracked files are authored; `node_modules` is not committed (`git ls-files | grep -c node_modules` → 0). Generated/scaffolded: `components/ui/*` (shadcn primitives), `public/*.svg`, lockfile, `next-env.d.ts` (gitignored). Everything under `app/`, `lib/`, `e2e/`, and CI is hand-written and in scope.

**Surface triage:** Risk is concentrated, not diffuse. It lives almost entirely in **three Server Actions** (`events.ts`, `onboarding/actions.ts`) and **two RSC reads** (`events/page.tsx` search, `support/tickets/page.tsx`). The auth gate and Supabase client wiring are conventional and clean. Lens effort was weighted onto Access and Input Safety accordingly; Secrets/Deployment and Tests get lighter but real coverage.

---

### Risk Ledger

Ranked by severity, then confidence. Findings 1-3 compose into the lead chain (**CHAIN-A**) and are presented first.

---

#### 1. Client-supplied role written directly to `active_role` with no server-side allowlist
- **Severity:** High (Critical as part of CHAIN-A if RLS does not constrain role)
- **Category:** Access
- **Confidence:** Strong evidence
- **What's happening now:** Onboarding takes the `userType` string from the form and inserts it verbatim as the user's `active_role`. The UI disables the "coordinator" and "both" options, but the server trusts the submitted value.
- **Evidence:** `app/onboarding/actions.ts:13` `const userType = formData.get('userType') as string;` and `:24` `active_role: userType`, inserted with no validation. The only client-side restriction is `app/onboarding/page.tsx:42` `<RadioGroupItem disabled value="coordinator" .../>` and `:46` `disabled value="both"`. The `switch(userType)` at `actions.ts:33` only decides whether to create a *secondary* profile row; for `coordinator` it hits `default` (`:48`) and logs a warning, but the `profiles` row with `active_role: 'coordinator'` was already written at `:18-25`.
- **Why it matters:** `active_role` is the principal the event-creation path authorizes against (Finding 2). A disabled radio button is not an authorization control; the server action is the boundary and it enforces nothing.
- **How it's triggered:** Sign up as a vendor, then submit the onboarding form (or replay it) with `userType=coordinator` using any HTTP client / devtools. No coordinator invite or approval needed.
- **The fix:** In `app/onboarding/actions.ts`, validate `userType` against a server-side allowlist that reflects what's actually open for self-serve signup, and reject anything else before the insert. Coordinator provisioning should be an admin/invite path, not a form field.
  ```ts
  // app/onboarding/actions.ts, inside create_profiles, before the profiles insert
  const SELF_SERVE_ROLES = ['vendor'] as const;            // 'coordinator' is invite-only
  const userType = formData.get('userType') as string;
  if (!SELF_SERVE_ROLES.includes(userType as typeof SELF_SERVE_ROLES[number])) {
    console.warn('Rejected non-self-serve role at onboarding:', userType);
    return redirect('/error?message=Invalid account type');
  }
  // ...existing insert now safe: active_role: userType
  ```
  Back this with a DB CHECK/RLS policy so the app is not the only gate (see Assumptions).
- **How you'll know it's fixed:** An integration test that calls `create_profiles` with `userType=coordinator` for a fresh user asserts the action redirects to `/error` and that `select active_role from profiles where user_id = ...` is not `'coordinator'`.

---

#### 2. Event-creation authorizes on a self-assignable field only
- **Severity:** High (Critical as part of CHAIN-A)
- **Category:** Access
- **Confidence:** Strong evidence
- **What's happening now:** `createEvent` gates solely on `profile.active_role === 'coordinator'`, the exact field a user can self-assign in Finding 1. It never checks for a real `coordinator_profiles` row.
- **Evidence:** `app/events/create/events.ts:13-21`:
  ```ts
  const { data: profile } = await supabase.from('profiles').select('active_role').eq('user_id', user?.id).single();
  if (profile?.active_role !== 'coordinator') { throw new Error("Unauthorized: Only coordinators can create events."); }
  ```
  Compare the *read* paths, which additionally require a coordinator profile: `app/events/create/page.tsx:18-21` (`hasCoordinatorProfile = !!coordinatorResult.data`) and `app/events/components/CreateEventButton.tsx:18-22`. The write path uses the weakest of the three checks (drift, see Finding 11).
- **Why it matters:** The authorization principal is forgeable (Finding 1). Even the stronger `coordinator_profiles` check the UI uses is missing from the one place that mutates data.
- **How it's triggered:** After self-assigning `active_role=coordinator`, call the `createEvent` server action directly.
- **The fix:** Authorize against the existence of a real `coordinator_profiles` row (server-provisioned), not the mutable `active_role`, and capture the coordinator id for the ownership check in Finding 3.
  ```ts
  // app/events/create/events.ts, replace the active_role gate
  const { data: coordinator } = await supabase
    .from('coordinator_profiles')
    .select('coordinator_profile_id')
    .eq('user_id', user.id)
    .single();
  if (!coordinator) throw new Error("Unauthorized: coordinator profile required.");
  ```
- **How you'll know it's fixed:** A test where a user has `active_role='coordinator'` but no `coordinator_profiles` row calls `createEvent` and asserts it throws Unauthorized and inserts no `events` row.

---

#### 3. Client-supplied `group_id` inserted with no ownership check (IDOR)
- **Severity:** High (Critical as part of CHAIN-A)
- **Category:** Access
- **Confidence:** Strong evidence
- **What's happening now:** `createEvent` inserts `group_id` straight from the client payload. The create page only *populates the dropdown* with groups the coordinator staffs; the server action never re-verifies the submitted `group_id` belongs to the caller.
- **Evidence:** `app/events/create/events.ts:25-31` inserts `group_id: values.group_id` from the raw `values` arg. The ownership scoping exists only on the read side: `app/events/create/page.tsx:25-34` queries `groups_staff` filtered by `coordinator_id`. Nothing rechecks it on write.
- **Why it matters:** A coordinator (legitimate or self-promoted via CHAIN-A) can create/spoof events under any group's identity by supplying an arbitrary `group_id`, misattributing events to organizations they don't run.
- **How it's triggered:** Submit `createEvent` with a `group_id` value not present in the caller's dropdown (any integer).
- **The fix:** Verify the caller staffs the submitted `group_id` via `groups_staff` before insert, using the `coordinator_profile_id` resolved in Finding 2.
  ```ts
  // app/events/create/events.ts, after resolving `coordinator`, before insert
  const { data: staff } = await supabase
    .from('groups_staff')
    .select('group_id')
    .eq('coordinator_id', coordinator.coordinator_profile_id)
    .eq('group_id', values.group_id)
    .maybeSingle();
  if (!staff) throw new Error("Unauthorized: you do not manage this group.");
  ```
  Enforce the same rule in an RLS `WITH CHECK` policy on `events` so the DB is the final arbiter.
- **How you'll know it's fixed:** A test where coordinator A calls `createEvent({ group_id: <group owned by B> })` asserts it throws and inserts nothing; the happy path (own group) still succeeds.

> **CHAIN-A summary:** Finding 1 (self-assign role) + Finding 2 (gate on that role) + Finding 3 (no group ownership check) = a vendor becomes a coordinator and posts events under arbitrary groups. Each link is individually High; together they are the report's Critical path, gated only by whatever RLS exists (unverified).

---

#### 4. Untrusted search input interpolated into a PostgREST `.or()` filter string
- **Severity:** Medium (High if the underlying view exposes columns beyond the active-event set)
- **Category:** Input Safety
- **Confidence:** Strong evidence (injection vector); uncertain blast radius (view columns + RLS)
- **What's happening now:** The `query` URL param is concatenated directly into a PostgREST `.or()` filter expression.
- **Evidence:** `app/events/page.tsx:16` `const { query, sort } = await searchParams;` then `:26-28`:
  ```ts
  supabaseQuery = supabaseQuery.or(`event_name.ilike.%${query}%,group_name.ilike.%${query}%`);
  ```
- **Why it matters:** `.or()` takes a mini filter-DSL. A crafted `query` containing PostgREST syntax (commas, `)`, `col.op.val`) can inject additional OR clauses, e.g. widening results past the intended `event_name/group_name` match to reference other columns of `events_with_group_names`. The base `.eq('status','active')` (`:22`) is ANDed with the whole `.or(...)`, but an attacker controls the interior of the OR group.
- **How it's triggered:** `GET /events?query=<PostgREST fragment>`.
- **The fix:** Escape/percent-encode the user value, or use parameterized `.ilike()` calls instead of building the filter string by hand. Simplest robust change: strip PostgREST metacharacters and pass as a bound pattern.
  ```ts
  // app/events/page.tsx
  const safe = (query ?? '').replace(/[,()\\*:]/g, '');   // strip filter-DSL metacharacters
  if (safe) {
    supabaseQuery = supabaseQuery.or(`event_name.ilike.%${safe}%,group_name.ilike.%${safe}%`);
  }
  ```
  (Longer term, prefer a single `.textSearch()` or two explicit `.ilike()` filters over an interpolated `.or()` string.)
- **How you'll know it's fixed:** A test requests `/events?query=%29,status.eq.draft` and asserts no non-active events are returned and no query error is thrown.

---

#### 5. All open support tickets readable by any authenticated user
- **Severity:** Medium (High if `ticket_data` has no RLS restricting rows to owner/support role)
- **Category:** Access
- **Confidence:** Strong evidence (no app-side filter); uncertain blast radius (RLS)
- **What's happening now:** The tickets page selects every open ticket with no filter by owner or support role, and renders each ticket's name, description, and the reporter's username.
- **Evidence:** `app/(shared)/support/tickets/page.tsx:12-15`:
  ```ts
  const { data: ticketData } = await supabase.from('ticket_data').select(`*`).eq('ticket_status', 'open');
  ```
  No `.eq('user_id', ...)` and no role check anywhere in the file; reporter identity is rendered at `:38` (`Created by: {ticket.username}`).
- **Why it matters:** Support tickets routinely contain personal or account-sensitive detail. If this view is meant for support staff, there is no role gate; if it's a user's own tickets, there is no ownership filter. Either way every logged-in user sees everyone's open tickets unless RLS silently saves it.
- **How it's triggered:** Any authenticated user visits `/support/tickets`.
- **The fix:** Decide the intent and enforce it server-side. If it's a support console, gate on a support/admin role; if it's "my tickets," filter by the caller. For a support console:
  ```ts
  const { data: { user } } = await supabase.auth.getUser();
  if (user?.app_metadata?.role !== 'support' && user?.app_metadata?.role !== 'admin') {
    return <div>Not authorized.</div>;
  }
  ```
  And add RLS on `ticket_data` so the DB enforces the same visibility.
- **How you'll know it's fixed:** A non-support user hitting `/support/tickets` sees no other users' tickets (empty or own-only), verified against a seeded DB with tickets from multiple users.

---

#### 6. Event-creation server action accepts `any` with no server-side schema validation
- **Severity:** Medium
- **Category:** Input Safety
- **Confidence:** Strong evidence
- **What's happening now:** `createEvent(values: any)` inserts fields straight from an untyped object. The Zod schema exists only in the client component and is trivially bypassed by calling the action directly.
- **Evidence:** `app/events/create/events.ts:7` `export async function createEvent(values: any)`; the schema lives client-side at `app/events/create/components/CreateEventForm.tsx:21-28` and is never applied on the server. Fields flow into `.insert([{...}])` at `events.ts:25-34` unvalidated (dates, lengths, `status` hardcoded).
- **Why it matters:** Malformed/oversized/wrong-type values reach Postgres directly; date ordering (start < end < deadline) and name length are unenforced server-side; `any` disables type safety at the exact trust boundary.
- **The fix:** Share the Zod schema and parse on the server before insert.
  ```ts
  // app/events/create/events.ts
  import { eventSchema } from './schema';           // extract the schema out of the client component
  const parsed = eventSchema.safeParse(values);
  if (!parsed.success) throw new Error("Invalid event payload.");
  const v = parsed.data;                            // typed; use v.* in the insert
  ```
- **How you'll know it's fixed:** A test calling `createEvent({ event_name: 'x' })` (too short, missing dates) asserts it throws and inserts nothing.

---

#### 7. Supabase **service-role key** injected into CI env but never read by the app
- **Severity:** Medium
- **Category:** Deployment
- **Confidence:** Strong evidence
- **What's happening now:** CI exports `SUPABASE_SERVICE_ROLE_KEY` into the workflow environment for a build/test that never uses it (grep for `SERVICE_ROLE` across `app/` and `lib/` returns nothing).
- **Evidence:** `.github/workflows/ci.yml:41` `echo "SUPABASE_SERVICE_ROLE_KEY=${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}" >> $GITHUB_ENV`; app usage: `grep -rn "SERVICE_ROLE" app lib` → empty. The app only ever uses `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` (`lib/supabase/server.ts:9`, `client.ts:7`, `proxy.ts:25`).
- **Why it matters:** The service-role key bypasses RLS entirely. Exporting it into the whole job environment widens exposure (any subsequent step, dependency postinstall, or log of `env` can capture it) for zero functional benefit.
- **The fix:** Remove the line from both workflow files.
  ```yaml
  # .github/workflows/ci.yml, delete this line
  # echo "SUPABASE_SERVICE_ROLE_KEY=${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}" >> $GITHUB_ENV
  ```
  If a future admin/integration test genuinely needs it, scope it to that single step's `env:` block, not `$GITHUB_ENV`.
- **How you'll know it's fixed:** `grep -rn SERVICE_ROLE .github/` returns nothing, and CI still builds/tests green.

---

#### 8. Fictional auth E2E test, the only auth test can never pass
- **Severity:** Medium
- **Category:** Maintainability (test integrity)
- **Confidence:** Strong evidence
- **What's happening now:** The auth spec asserts routes and UI that don't exist, so it fails against the real app; the other spec tests a third-party website.
- **Evidence:** `e2e/auth.spec.ts:18` `await page.waitForURL('/dashboard')` (no `/dashboard` route exists), `:22` expects `Welcome, ${userEmail}!` (the real home renders `Welcome Back, ${profile.display_name}`, `app/page.tsx:49`), and signup actually redirects to `/check-email` (`app/(auth)/signup/actions.ts:24`), not `/dashboard`. `e2e/example.spec.ts:4-7` navigates to `https://playwright.dev/`, scaffold boilerplate.
- **Why it matters:** CI advertises "Test Auth" (`ci.yml:1`) but no test exercises this app's real auth. The auth surface, the most security-relevant flow, has zero true coverage, and a red/irrelevant suite trains the team to ignore CI.
- **The fix:** Rewrite `auth.spec.ts` against real routes (`/signup` → `/check-email`; login → `/` or `/onboarding`; protected route → `/login` redirect) and delete `example.spec.ts`. Add a regression test for CHAIN-A (attempt coordinator self-assignment; assert event creation is refused).
- **How you'll know it's fixed:** `npx playwright test` passes with assertions that reference only real routes/text, and includes at least one negative authorization test.

---

#### 9. Password-reset redirect falls back to a placeholder domain in production
- **Severity:** Medium
- **Category:** Deployment
- **Confidence:** Strong evidence
- **What's happening now:** If no environment URL is set, the reset email's `redirectTo` is built from a literal placeholder string in production.
- **Evidence:** `app/(auth)/forgot-password/actions.ts:20` `return 'https://<YOUR_PRODUCTION_DOMAIN_HERE>';`, used at `:31-32` to build `redirectToURL` passed to `resetPasswordForEmail` (`:39-42`).
- **Why it matters:** If `URL`/`DEPLOY_PRIME_URL` aren't configured on the host, every reset link points at an invalid domain, password recovery silently breaks, and the failure only surfaces in users' inboxes.
- **The fix:** Fail fast instead of shipping a placeholder; require the env var in production.
  ```ts
  if (process.env.URL) return process.env.URL;
  if (process.env.DEPLOY_PRIME_URL) return process.env.DEPLOY_PRIME_URL;
  if (process.env.NODE_ENV === 'development') return `http://localhost:${process.env.PORT || 3000}`;
  throw new Error('Site URL env var not configured, cannot build password-reset link.');
  ```
- **How you'll know it's fixed:** With no URL env set and `NODE_ENV=production`, `resetPasswordRequest` throws/logs rather than sending a link to `<YOUR_PRODUCTION_DOMAIN_HERE>`.

---

#### 10. Dead and duplicated CI configuration
- **Severity:** Low
- **Category:** Deployment / Maintainability
- **Confidence:** Strong evidence
- **What's happening now:** Three CI files exist; one is in a location GitHub ignores, and two others overlap.
- **Evidence:** `.github/ci.yml` (byte-identical to `.github/workflows/ci.yml`) sits outside `.github/workflows/`, so GitHub never runs it, dead config. `.github/workflows/ci.yml` and `.github/workflows/playwright.yml` both run Playwright on push/PR to `main` (the latter also `master`, `playwright.yml:3`), duplicating work.
- **Why it matters:** A dead copy invites edits that never take effect; duplicate pipelines double minutes and split signal.
- **The fix:** Delete `.github/ci.yml`; consolidate to one Playwright workflow (keep `workflows/ci.yml`, remove `workflows/playwright.yml` or merge the two). Drop the `master` branch trigger if the default is `main`.
- **How you'll know it's fixed:** One workflow appears in the repo's Actions tab per push; `.github/ci.yml` no longer exists.

---

#### 11. Duplicated coordinator-gate logic, weakest copy on the write path
- **Severity:** Low (raises the cost/likelihood of Findings 2-3 regressing)
- **Category:** Maintainability
- **Confidence:** Strong evidence
- **What's happening now:** The "is this user a coordinator" rule is implemented three times with two different definitions.
- **Evidence:** Strong version (role AND coordinator profile): `app/events/components/CreateEventButton.tsx:18-22` and `app/events/create/page.tsx:18-21`. Weak version (role only): `app/events/create/events.ts:19`. The weakest copy guards the actual mutation.
- **Why it matters:** Three copies drift; the security-critical one is already the outlier. Business rules with no single owner rot toward the weakest implementation.
- **The fix:** Extract one `requireCoordinator(supabase, userId)` helper returning `{ coordinatorProfileId }` (or throwing), and call it from all three sites. Findings 2-3 become a one-line call.
- **How you'll know it's fixed:** `grep -rn "active_role === 'coordinator'" app` returns a single definition inside the shared helper.

---

#### 12. Empty route modules reachable behind auth
- **Severity:** Low
- **Category:** Maintainability / Observability
- **Confidence:** Strong evidence
- **What's happening now:** Three route files are empty (no default export), so navigating to them errors at runtime.
- **Evidence:** `app/messages/page.tsx`, `app/event/page.tsx`, and `app/applications/page.tsx` all read back empty (verified via Read). They're under the authenticated matcher (`proxy.ts` gate) and thus reachable by URL even though the nav links are commented out (`app/components/ui/NavLinks.tsx:9-11`).
- **Why it matters:** A signed-in user hitting `/messages`, `/event`, or `/applications` gets an unhandled error, not a graceful 404. Half-built routes shipped alongside real ones.
- **The fix:** Either delete these route directories or add minimal placeholder components returning a "coming soon"/`notFound()`. Prefer deletion until the feature is real.
- **How you'll know it's fixed:** Each remaining route renders a defined component; removed routes 404 cleanly.

---

#### 13. Debug logging of full payloads and raw provider errors
- **Severity:** Low
- **Category:** Observability
- **Confidence:** Strong evidence
- **What's happening now:** Server actions log entire submitted payloads and raw Supabase error messages; login pushes the raw auth error into a URL.
- **Evidence:** `app/events/create/events.ts:23` `console.log("Server Action receiving: ", values)`; `app/(auth)/forgot-password/actions.ts:34` logs the reset `redirectTo`; `app/(auth)/login/actions.ts:19` redirects to `/error?message=${encodeURIComponent(error.message)}`. **Negative evidence (not a finding):** `app/error/page.tsx:1-3` renders a static string and never reads `message`, so there is no reflected XSS, but the raw error still lands in the URL/referrer/server logs.
- **Why it matters:** Payloads and provider internals in logs are an info-leak and noise source; raw auth errors in URLs leak into referrers and access logs.
- **The fix:** Remove the payload `console.log`s; log an opaque event id instead of the raw provider message; redirect to `/error` with a generic code, not the provider string.
- **How you'll know it's fixed:** `grep -rn "console.log" app` shows no payload/PII logging; `/error` URLs carry no provider text.

---

### AI-Assist Fragility Check

Structural smells, independent of any single vulnerability:

- **The same rule, three implementations, weakest one authoritative.** The coordinator check (Finding 11) exists in `CreateEventButton.tsx`, `create/page.tsx`, and `events.ts`, and the mutating path uses the loosest variant. Classic AI-assisted pattern: the UI got the careful version, the server action got a quick one.
- **UI gate treated as the security boundary.** Disabled radio buttons (`onboarding/page.tsx:42,46`) and conditionally-rendered buttons (`CreateEventButton.tsx`) stand in for server checks that don't exist (Findings 1-2). The visible control and the enforced control are different layers.
- **Validation only where it's convenient.** Zod runs in the browser (`CreateEventForm.tsx:21`); the server action takes `any` (Finding 6). Trust-boundary validation was skipped because the client already "validated."
- **Tests that describe an imagined app.** `auth.spec.ts` asserts `/dashboard` and `Welcome, {email}!` that never existed; `example.spec.ts` tests playwright.dev (Finding 8). Happy-path-shaped, aspirational, and green-looking only because they don't run against reality.
- **Placeholders wired to reach production.** `https://<YOUR_PRODUCTION_DOMAIN_HERE>` (Finding 9) and duplicated/dead CI (Finding 10) are copy-paste scaffold residue that was never reconciled.
- **Half-built features shipped alongside real ones.** Empty `messages`/`event`/`applications` routes (Finding 12), hardcoded home-page stats (`app/page.tsx:28-45`), and hardcoded profile "Bio"/"username" literals (`ProfileHeader.tsx:22-23`) are visible seams where the demo outran the implementation.
- **No single owner for the "who is a coordinator / who owns this group" business rule**, it's smeared across UI components, a page loader, and a server action with no shared source of truth.

---

### What Breaks at 10x

**1. Authorization model (breaks first, and worst).** Today authority is derived from a mutable `active_role` string and enforced inconsistently across scattered checks. At 10x users, and especially once coordinators onboard for real, CHAIN-A stops being theoretical: spoofed events, cross-group impersonation, and support-ticket exposure scale with the user base. **Cost now:** ~1 day to centralize the coordinator check, add server-side group-ownership verification, and confirm RLS (Findings 1-3, 5, 11). **Cost later:** a data-integrity incident (events attributed to groups that didn't create them) plus retroactive RLS work under pressure. **Structural**, but small and well-scoped now.

**2. Event search / listing.** The `.or()` string interpolation (Finding 4) and unindexed `ilike '%q%'` scans on `events_with_group_names` degrade and stay injectable as event volume grows. **Cost now:** a few hours to parameterize the filter and move to `textSearch`/trigram indexes. **Cost later:** slow event pages under load plus a live injection surface. **Quick fix now, structural if deferred.**

**3. Test & CI integrity.** With zero real auth coverage (Finding 8) and duplicate/dead pipelines (Finding 10), every future change to the auth or authorization paths ships unverified. At 10x contributors this is how CHAIN-A-class regressions slip back in after they're fixed. **Cost now:** ~half a day to write real E2E + one negative-authz test and consolidate CI. **Cost later:** compounding, each unguarded merge is a new potential regression. **Quick fix, high leverage.**

---

### Basic Readiness Scorecard

| Area | Status | Why |
|---|---|---|
| Login and identity | Pass | Supabase Auth; server-side `getClaims()` in the `proxy` gate (`lib/supabase/proxy.ts:48`); email confirmation flow present (`/check-email`). |
| Permissions / authorization | **Fail** | CHAIN-A: self-assignable `active_role` (F1) gates event creation (F2); no group-ownership check (F3). Core authz is forgeable. |
| ID / parameter tampering | **Fail** | `group_id` inserted unchecked (F3); `query` interpolated into filter DSL (F4). |
| Injection / malformed input | Warning | PostgREST filter injection via `.or()` (F4); server action takes `any`, no server-side schema (F6). No SQL string concat or `dangerouslySetInnerHTML` found (negative evidence). |
| File uploads | N/A | No upload surface in the codebase (avatar is a hardcoded external URL, `ProfileHeader.tsx:12`). |
| Rate limiting | Fail | No rate limiting on auth or server actions anywhere in source; relies entirely on Supabase defaults (unverified). |
| Secrets and env vars | Warning | No secrets in source; `.env*` gitignored. But service-role key over-scoped into CI env and unused (F7). |
| Accidental logging of private data | Warning | Full event payloads and reset URLs logged (F13). |
| Error messages leaking internals | Warning | Raw Supabase errors pushed into `/error?message=` URL (F13); error page itself doesn't render it (no XSS). |
| Admin / privileged actions | **Fail** | Coordinator (privileged) status is self-grantable (F1); no admin gate on support tickets (F5). |
| API endpoints | Warning | No REST layer; Server Actions are the surface and under-validate (F2, F3, F6). |
| Database access | Warning | Clean client wiring (publishable key only), but **no RLS/migrations in repo**, the entire authz safety net is unverified (see Assumptions). |
| Payments | N/A | No payment code in the repo (home-page revenue figure is a hardcoded placeholder, `app/page.tsx:30`). |
| AI / LLM usage | N/A | None present. |
| Deployment config | Warning | Placeholder production URL fallback (F9); dead + duplicated CI (F10). |
| Backups and recovery | Unknown | Managed by Supabase; nothing in repo to assess. |

---

### Assumptions and Unknowns

Each with what would confirm or deny it:

1. **RLS policies are not in the repo** (no `supabase/migrations`, no `.sql`, no `config.toml`, verified by `git ls-files`). The severity of CHAIN-A (F1, F3) and support-ticket exposure (F5) hinges entirely on this. *Confirm by:* dumping live policies on `events`, `profiles`, `coordinator_profiles`, `groups_staff`, `ticket_data`. If RLS enforces role + group ownership, CHAIN-A is contained at the DB (findings drop toward Medium as defense-in-depth); if not, it's fully exploitable (Critical).
2. **Uniqueness constraint on `profiles.user_id`** is unknown. It governs whether a user can re-run `create_profiles` to flip their `active_role` after onboarding (`onboarding/actions.ts` has no existing-profile guard). *Confirm by:* inspecting the table's constraints.
3. **Supabase Auth email-confirmation is ON.** `signup` routes to `/check-email` (`signup/actions.ts:24`) and login checks `identities?.length === 0` (`login/actions.ts:22`), implying confirmations, but the setting lives in Supabase config, not code. *Confirm by:* the Auth provider settings.
4. **Production site-URL env is configured** (`URL`/`DEPLOY_PRIME_URL`). If not, password reset silently breaks (F9). *Confirm by:* the deploy environment's variables.
5. **The service-role key is genuinely unused** by any Supabase Edge Function or out-of-repo job. Grep of this repo is empty (F7), but functions may live elsewhere. *Confirm by:* the Supabase project's functions list.
6. **`ticket_data` is a view/table intended for support staff** vs. per-user tickets, intent determines whether F5 is a missing role gate or a missing ownership filter. *Confirm by:* the view definition and product intent.
7. **Live deployment target** (Node server vs. edge), assumed server runtime from the Fluid-compute comment (`proxy.ts:21`); doesn't change findings, all of which are runtime.

---

### Verdict

**Not yet safe for real users.** The event-creation and onboarding flows let a self-registered vendor grant themselves coordinator authority and create events under groups they don't control (CHAIN-A, Findings 1-3), authorization logic is duplicated with the weakest copy on the write path, support tickets have no server-side access gate, and search input is interpolated into a database filter DSL. None of these require exotic skill to trigger, a browser devtools console suffices. The fixes are well-scoped (roughly 1-2 days for the authz chain, search, and test integrity combined) and mostly amount to re-verifying authority *server-side* in the four Server Actions and confirming RLS.

**What this review could not check:** the live Supabase RLS policies and table constraints, the single factor that decides whether CHAIN-A and the ticket exposure are Critical (app is the only gate) or contained (DB independently enforces role and ownership). Confirm those before shipping; pair with `/ship-check` for the ownership/accountability question this technical audit doesn't cover.
