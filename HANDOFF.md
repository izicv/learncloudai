# Handoff – LearnCloudAI (read this first in a new session)

A short story of what we are building, what is done, and what to do next. Last updated at the end of the home page redesign session.

## The idea
A simple, **dark-mode-only** AI training website (not tied to one certification). Visitors browse and search **cards** for trainings. Each course is split into **units** (Unit 1 Basics, Unit 2 Intermediate, Unit 3 Advanced) with **lessons and a video** per lesson. One **admin** creates and edits everything. Courses are **free or paid**: paid ones need sign-in plus a one-time fee. Keep it **simple** (no heavy-load design).

Full plan, data model, routes and sub-tasks: [`ai-training-platform-plan.md`](ai-training-platform-plan.md). Read it after this file.

## Decisions already made
- Stack: Next.js 16.4.3 (App Router, React 19, TypeScript), Tailwind v4, Bun.
- Backend: Supabase (Postgres, Auth, Storage). Payments: Stripe Checkout, one-time fee, access granted by a verified webhook.
- One admin (set manually in the database). Everyone else is a normal user.
- Currency by location: India gives INR, everyone else USD. Admin sets a fixed price per currency. Planned host: Vercel (header `x-vercel-ip-country`).
- Video in Phase 1: admin pastes a YouTube/Vimeo link per lesson.
- User-created live cards, progress tracking, categories: **Phase 2** (not now).
- The user's template HTML (Udema) is only a layout reference. It lives outside the workspace (`~/Downloads/.../udema_v_1.4/html_menu_1/`), so Bob cannot read it unless it is copied into the workspace.

### Design rules from the user (all in force, do not undo)
- **Dark theme, neutral greys only.** No purple ("I hate purple"), lime, teal or gradients.
- **Space Grotesk is the only font**, everywhere (no mono, no Inter).
- **No rounded corners** on search and cards.
- **Cards are text and icons only** ("do not put color inside card"). Each card has a 3px soft light-blue left line (`--accent-line #8fb4e8`, class `border-l-accent-line`, kept on hover).
- Provider icons use real brand colours: Google four-colour "G", Anthropic `#D97757`, OpenAI `#10A37F`. Live trainings get a red `#EF4444` broadcast icon plus a "LIVE" badge.
- **Search filters as you type** (250 ms debounce), no search button. The search box sits **directly above the card list** (inside `#trainings`), not in the hero, so the user sees results right below it. The user said "focus on mouse over" was NOT what they meant; it was removed.
- Layout reference: https://claudecertificationguide.com/ (left-aligned big hero heading, 72px sticky header, 4-column cards). We copy the layout only, not its mono labels, testimonial marquee or FAQ.

## What is done
| Part | What | State |
|---|---|---|
| 1 | Dark theme tokens (`app/globals.css`), layout, header with mobile menu, footer, `Button`, `Container`, `.env.example`, Supabase packages installed | Built, verified by user |
| 2 | Home page: hero + search, announcement banner, training cards, pagination, backed by Supabase (see 4b). Redesigned to the reference layout: 96px left-aligned H1, "Search trainings →" link to the search box above the cards, 72px header, 4-column grid, 8 cards per page (`PAGE_SIZE`), container `max-w-7xl` | Built, lint/tsc/build pass, tested in real Chrome, awaiting user check |
| 3 | Course page `/courses/[slug]` and lesson page `/courses/[slug]/lessons/[lessonId]`: unit outline, YouTube/Vimeo embed, text, previous/next, locked panel for paid courses. Data from Supabase (see 4b) | Built, lint and build pass, awaiting user check |
| 4a | Supabase SQL applied to the user's project: `supabase/migrations/*.sql`, `supabase/seed.sql`, `supabase/README.md`. RLS verified live as an anonymous visitor | Done |
| 4b | App reads Supabase: `lib/trainings.ts` (cards, search, pagination), `lib/courses.ts` (units via `lesson_outline` view, lesson text via RLS), `lib/supabase/{public,database.types}.ts`. Cached with `use cache` + tag `courses` with `cacheLife('minutes')`. Lesson URLs use UUIDs | Built, lint and build pass, awaiting user check |

File map:
- Home: `app/page.tsx`, `components/{hero,search-bar,announcement-banner,training-card,pagination,trainings-section,provider-icon}.tsx`.
- Course/lesson: `app/courses/[slug]/page.tsx`, `app/courses/[slug]/lessons/[lessonId]/page.tsx`, `lib/courses.ts`, `components/{video-embed,locked-panel,unit-list}.tsx`. Both pages use `generateStaticParams` and `export const instant = false`. Seed data gives every course 3 units x 3 lessons; live cards have no lessons. Lesson text is plain paragraphs (markdown not rendered yet).
- Shell: `components/{site-header,site-footer,button,container}.tsx`. Some of these still use `text-primary` / `hover:border-primary`; `--primary` is near-white `#f4f4f5`, so this is fine.
- Search and pagination use URL params (`/?q=agents&page=2`). Code that reads `searchParams` must be inside `<Suspense>` (needed because `cacheComponents` is on).

## What is NOT done yet (suggested order)
1. **Sign in / sign up** with Supabase Auth: `/login`, `/signup`, `getCurrentUser()`, `requireAdmin()`, `proxy.ts` guarding `/admin/*` (not `middleware.ts`), header user menu. Header "Sign in" buttons and the locked panel currently link to `/login`, which is a 404.
2. **Admin**: CRUD for cards, units, lessons and announcements; thumbnail upload (`thumbnails` bucket exists, public, 2 MB); a provider field. Call `revalidateTag("courses")` / `updateTag("courses")` after every edit because data functions are cached with tag `courses`.
3. Make the **announcement banner** read the `announcements` table (still static text).
4. **Stripe Checkout** for paid courses + webhook, then **currency by location** (prices show USD only now).
5. Verify the logged-in roles (user, paid user, admin) on the live Supabase project. Only tested locally so far (40 PGlite checks).
6. Quality pass and README. Optional: generate Supabase types with the CLI, render lesson text as sanitised markdown.

Known gaps: Unknown course/lesson URLs show the not-found page with HTTP 200 + `noindex` (documented Next.js streaming behaviour; a true 404 needs a `proxy.ts` check). Types are hand-written, not generated. Paid lessons stay locked until enrolment exists (Stripe part). Cards show no picture (provider icon instead); the admin thumbnail upload will need a slot added back.

## Current environment state
- Git: nothing is committed yet. All work is uncommitted (modified: `.gitignore`, `app/*`, `bun.lock`, `package.json`; untracked: `components/`, `lib/`, `supabase/`, `app/courses/`, `HANDOFF.md`, plan file, `.env.example`, `.bob/`, `.vscode/`, `.agents/`, `skills-lock.json`). Ask the user before committing.
- A stray untracked `package-lock.json` exists. Bob did not create it and the project uses Bun. Ask before deleting.
- Supabase project host: `nkhrheeankczlbgrlzux.supabase.co`. Schema, seed and RLS are applied. Anonymous check: 14 published courses, 9 lessons of a free course readable, 0 lessons of a paid course, 108 titles in the `lesson_outline` view, writes blocked.
- `.env.local` (git-ignored) holds `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` (not `ANON_KEY`), `SUPABASE_SERVICE_ROLE_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`. The Stripe values are still empty. Never print secret values; only say whether set and its length.
- The dev server may still be running on port 3000 from this session. Check with `curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/`.

## Gotchas for the next session
- `AGENTS.md`: this Next.js version has breaking changes. Read the matching guide in `node_modules/next/dist/docs/` before writing Next code (`proxy.ts` replaces middleware; `params` and `searchParams` are Promises; `cookies()` is async; runtime-data reads need `<Suspense>` or `export const instant = false`).
- Run: `bun run dev` (http://localhost:3000). The dev server often serves stale CSS/JS. Fix: `pkill -f "next dev"; pkill -f "next-server"; rm -rf .next; (nohup bun run dev > /tmp/dev.log 2>&1 &)`, then hard-refresh. Running `bun run build` while the dev server is up can also make it stale.
- Validate before finishing any task: `bun run lint`, `npx tsc --noEmit` and `bun run build`.
- Browser testing: scratch scripts in `/tmp/pgtest/` (puppeteer-core + local Chrome at `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`, e.g. `home.ts`, `ui.ts`). `/tmp` is wiped on reboot, so they may be gone; recreate if needed. `read_file` cannot view files outside the workspace, so compare pages by DOM/computed-style dumps, not screenshots.
- `.gitignore` is protected from the edit tools; use the shell to change it. `.env.example` is allowed in git; real `.env.local` is not.
- Bob can read the reference site only through the shell (`curl` or puppeteer). `.bob/mcp.json` registers `mcp-server-fetch` via `uvx`; it only shows up after Bob restarts.
- Secrets (Supabase service key, Stripe keys) go in `.env.local` only, never in chat.

## Working style the user wants
One small part at a time. Build it, show it, wait for the user to verify, then pick the next part. Update the **Status** lines in the plan file after each part. Be direct and technical; do not open messages with "Great" or "Sure".

## Open questions still waiting for the user
- Is the home page redesign OK, with the search box now above the cards?
- Is a pasted YouTube/Vimeo link OK for lesson video (paid videos are not strongly protected)?
- Is plain markdown OK for lesson text?
- Create your own Stripe account (test mode is enough) before the payment part.

## Suggested first message for tomorrow
"Read HANDOFF.md and ai-training-platform-plan.md, then start with sign in / sign up (item 1 under 'What is NOT done yet')."
