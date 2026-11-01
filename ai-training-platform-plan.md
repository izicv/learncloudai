# AI Training Platform – Development Plan (Phase 1: Keep It Simple)

> Working document. Update the **Status** of each sub-task when completed and add anything the next sub-task needs under **Notes for next task**.

## 1. Overview

### Goal
A simple AI training website, in the style of any online course marketplace (and modelled on `https://claudecertificationguide.com/`), but about **AI training in general**, not one certification.

Phase 1 delivers:
- A home page with a navigation menu, search, an announcement area, and a paginated grid of clickable training **cards**.
- Each course is organised **unit by unit** (Unit 1 Basics, Unit 2 Intermediate AI topics, Unit 3 Advanced), with a lesson page that has text and a **video** per topic.
- **One admin** who creates and edits everything (cards, units, lessons, announcements). A card appears on the home page once the admin publishes it.
- Courses are **free or paid**. A visitor can see a paid course's description and outline, but must **sign in and pay a one-time registration fee** to open its lessons.

### Principles (per user request)
- Simple first. No heavy-load design: no queues, no caching layers beyond what Next.js gives by default, no background workers.
- Single admin role. Everyone else is a plain user.
- Smallest number of tables and screens that satisfy the above.

### Stack (confirmed with user)
| Concern | Choice |
|---|---|
| Framework | Next.js 16.4.3 (App Router), React 19, TypeScript strict |
| Styling | Tailwind CSS v4 |
| Package manager | Bun |
| Database / Auth / Image upload | Supabase (Postgres, Auth, Storage). Next.js is the frontend only. |
| Payments | Stripe Checkout (hosted payment page), one-time fee per course, access granted by a verified webhook |

### Evidence: what the reference site does (read with `curl`)
- **Home** (`/`): top nav, hero, a card per certification (code, title, audience blurb, key facts, "Start free"), testimonials, FAQ, footer.
- **Course page** (`/ccar-f`): journey steps and a blueprint listing every domain and its lessons.
- **Curriculum** (`/learn`): sidebar of domains, "0 of 30 lessons", domain cards with description and lesson count.
- **Lesson** (`/learn/<domain>/<lesson>`): breadcrumb, long-form text sections. **No video was found**, so video is new work for this project.
- The reference site is itself a Next.js app.

### Next.js 16 conventions that apply (from `node_modules/next/dist/docs`, per `AGENTS.md`)
- `middleware.ts` is now **`proxy.ts`** exporting `proxy(request)`. Use it only for quick redirects, not as the real authorization check.
- `params` and `searchParams` are **Promises** (`await searchParams`), which matters for search and pagination.
- `cookies()` and `headers()` are async.
- `next.config.ts` already sets `cacheComponents: true`: code that reads the session must sit inside a `<Suspense>` boundary, or the build fails.
- Remote images from Supabase Storage must be allowed in `images.remotePatterns` in `next.config.ts`.
- Read before implementing: `01-app/02-guides/authentication.md`, `authentication-with-cache-components.md`, `server-actions.md`, `forms.md`, `01-getting-started/15-route-handlers.md`, `16-proxy.md`.

---

## 2. Phase 1 scope

**In scope:** nav, announcements, cards, search, pagination, course and lesson pages with video, sign in / sign up, single admin CRUD, free/paid courses, Stripe Checkout for paid courses.

**Deferred to Phase 2 (not built now):**
- Users creating their own live-training cards and the admin approval queue
- Lesson progress / "Mark Complete" and a "My learning" page
- Categories and filters (search by text only in Phase 1)
- Protected (private, signed-URL) video hosting
- Free-preview lessons, coupons, refunds, subscriptions, taxes, payouts to other creators
- Blog, testimonials, quizzes, mock exams, certificates

---

## 3. Data model (Supabase / Postgres) – 6 tables

| Table | Purpose | Key fields |
|---|---|---|
| `profiles` | One row per auth user | `id` (= auth user id), `email`, `role` (`user` or `admin`) |
| `courses` | The cards and course header | `id`, `slug`, `title`, `short_description`, `thumbnail_url`, `footer_text`, `level`, `kind` (`course` or `live`), `prices` (JSON map of currency code to price in minor units, for example `{"USD":1900,"INR":99900,"EUR":1700}`; empty or missing = free), `status` (`draft` or `published`), timestamps |
| `units` | Unit 1, 2, 3 … | `id`, `course_id`, `position`, `title`, `summary` |
| `lessons` | Topic inside a unit | `id`, `unit_id`, `position`, `title`, `content` (markdown), `video_url`, `duration_minutes` |
| `announcements` | Home-page slot for new training or market product | `id`, `title`, `body`, `image_url`, `link_url`, `active`, `sort_order` |
| `enrollments` | Who has access to a paid course | `user_id`, `course_id`, `stripe_session_id` (unique), `created_at` |

`kind = live` is a normal admin-created card for a live training (title, description, picture, footer, and the date or join link in the description/footer text). No separate live table in Phase 1.

**Access rules (Row Level Security + server checks)**
- Anyone can read **published** courses, units, and active announcements.
- Lesson `content` and `video_url` can be read when the course is free, or the user has an `enrollments` row for it, or the user is admin.
- Only the admin can create, update or delete courses, units, lessons and announcements.
- A user can read only their own `enrollments`; only the server (from the verified Stripe webhook) writes them.
- Exactly one admin: set manually in the database (`profiles.role = 'admin'`). No admin sign-up screen.

**Storage:** one public bucket `thumbnails` (card and announcement images), admin-only write.

**Currency by location (Phase 1 decision)**
- The visitor's country comes from a request header set by the hosting provider. Next.js 15+ removed `request.geo` and `request.ip` (see `node_modules/next/dist/docs/01-app/02-guides/upgrading/version-15.md`), so the plan reads the host's country header (for example `x-vercel-ip-country` on Vercel, `cf-ipcountry` on Cloudflare), or `geolocation()` from `@vercel/functions` if hosted on Vercel. Hosting is planned as Vercel (not final); if it changes, only the country-header lookup changes.
- Country to currency rule: IN gives INR; every other country gives USD.
- The admin enters a fixed price for each supported currency. No live exchange rates in Phase 1. If a course has no price for the visitor's currency, USD is used.
- Local development has no location header, so a development-only `?country=IN` override and the USD fallback are used.
- Because the price depends on the request, price UI reads headers and must sit inside a `<Suspense>` boundary under `cacheComponents`, like session UI. Page text and the card shell can still prerender.
- A small currency selector (saved in a cookie) lets the visitor override the detected currency, since VPNs and travel make location unreliable.
- Stripe also offers "adaptive pricing" that auto-converts for the buyer, but it uses converted rates rather than the admin's set prices, so it is not used in Phase 1.

**Video (Phase 1 decision):** the admin pastes a video link (YouTube unlisted or Vimeo) per lesson, and the lesson page embeds it. This avoids upload and bandwidth work. Trade-off: anyone who has the link can watch it, so paid videos are not strongly protected. Phase 2 can move to private hosting.

---

## 4. Route map

| Route | Purpose | Access |
|---|---|---|
| `/` | Home: nav, search, announcements, card grid, pagination | Public |
| `/courses/[slug]` | Course page: description, price, units and lesson titles, Enrol or Buy button | Public |
| `/courses/[slug]/lessons/[lessonId]` | Lesson: video, text, previous/next, unit sidebar | Free course: public. Paid: signed in and paid |
| `/courses/[slug]/payment/success`, `/cancel` | Return pages after Stripe Checkout | Signed in |
| `/api/stripe/webhook` | Stripe webhook (route handler) that grants access | Stripe only, signature verified |
| `/login`, `/signup` | Supabase Auth | Public |
| `/admin` | Admin dashboard: list of courses | Admin |
| `/admin/courses/new`, `/admin/courses/[id]` | Edit card, units and lessons, publish toggle | Admin |
| `/admin/announcements` | Manage the announcement slot | Admin |
| `proxy.ts` | Redirect non-signed-in visitors away from `/admin/*` | n/a |

Search and pagination use URL parameters (`/?q=agents&page=2`) read from `searchParams`, so results are shareable and server-rendered.

---

## 5. Sub-tasks

Each sub-task is independent, small, and reviewed before the next begins.

### Sub-task 1 – Project foundation and design
- **Status:** [-] built, waiting for user verification (Part 1: shell only)
- **Intent:** Replace the create-next-app template with a clean base.
- **Expected outcomes:**
  - Template content removed; shared layout (header, footer) renders.
  - **Dark mode only.** One dark palette defined in Tailwind v4 / `globals.css`, matched to the user's HTML. The template's `prefers-color-scheme` light/dark switch is removed, `<html>` gets `color-scheme: dark`, and there is no theme toggle.
  - Fonts and spacing also matched to the user's HTML.
  - A few shared components: `Button`, `Container`, `Badge`.
  - `.env.example` lists the Supabase and Stripe variable names; `.env*` is git-ignored.
  - `bun run lint` and `bun run build` pass.
- **Todo list:**
  1. Read the user's HTML files and note layout, colours and component styles; reuse their dark palette as theme tokens.
  2. Clean `app/page.tsx`; update metadata in `app/layout.tsx`.
  3. Set theme tokens in `app/globals.css`.
  4. Add shared components and `.env.example`.
  5. Add `@supabase/supabase-js` and `@supabase/ssr` with Bun.
- **Relevant context:** `app/layout.tsx`, `app/page.tsx`, `app/globals.css`, `next.config.ts`, `package.json`, `.gitignore`, user's HTML reference.
- **Notes for next task:** _(fill in after completion)_

### Sub-task 2 – Supabase schema, access rules and seed data
- **Status:** [x] done. SQL applied to the user's Supabase project; RLS verified live as an anonymous visitor (14 published courses, free lessons readable, paid lessons hidden, writes blocked). Hand-written types in `lib/supabase/database.types.ts`. Logged-in roles (user, paid user, admin) get checked once sign-in exists.
- **Intent:** Create the backend that every feature depends on.
- **Expected outcomes:**
  - The 6 tables in Section 3 exist with foreign keys, indexes, and a text-search index on course title and description.
  - Row Level Security enforces the access rules in Section 3.
  - `thumbnails` bucket exists with admin-only write.
  - A trigger creates a `profiles` row on sign-up (default `user`).
  - SQL migrations are stored in the repo (`supabase/migrations`).
  - Seed data: one free course and one paid course, each with Unit 1 Basics, Unit 2 Intermediate and Unit 3 Advanced, with a few lessons.
  - Documented one-line step to make one account the admin.
  - TypeScript types generated from the schema.
- **Todo list:**
  1. Write migrations (tables, enums, indexes).
  2. Write RLS policies; test as anonymous, normal user, paid user, and admin.
  3. Create bucket and policy; write sign-up trigger.
  4. Write seed SQL; generate types.
- **Relevant context:** Section 3. The user creates the Supabase project and provides URL and keys through `.env.local` (never in chat).
- **Notes for next task:** Files: `supabase/migrations/*.sql`, `supabase/seed.sql`, `supabase/README.md` (apply steps, make-admin line, access table). Added a `provider` column (`anthropic|openai|google`) and a `lesson_outline` view so locked courses can still list lesson titles without exposing content or video. `prices` only accepts `USD` and `INR` keys. Lesson ids are now UUIDs, so the lesson route `[lessonId]` will take a UUID once swapped from sample data (`lib/courses.ts` currently uses 1..9).

### Sub-task 3 – Sign in, sign up and admin check
- **Status:** [ ] pending
- **Intent:** Let users register and sign in, and let the code know who the admin is.
- **Expected outcomes:**
  - `/login` and `/signup` work with email and password.
  - Header shows Sign in, or the user menu with Sign out (and an Admin link for the admin).
  - Server helpers `getCurrentUser()` and `requireAdmin()` exist.
  - `proxy.ts` redirects visitors without a session away from `/admin/*`; real checks happen in server code and RLS.
  - Session-reading UI is inside `<Suspense>` so the build passes.
- **Todo list:**
  1. Read the authentication guides and `proxy.md`.
  2. Create server and browser Supabase clients using async `cookies()`.
  3. Build login and signup forms with server actions.
  4. Add helpers, `proxy.ts`, and the header user menu.
- **Relevant context:** `node_modules/next/dist/docs/01-app/02-guides/authentication*.md`, `server-actions.md`, `forms.md`.
- **Notes for next task:** _(fill in after completion)_

### Sub-task 4 – Home page: navigation, announcements, card grid
- **Status:** [-] built, now reads real data from Supabase (`getTrainings()`); redesigned to the claudecertificationguide.com layout (96px hero, 4-column grid, 8 per page, search box directly above the cards); lint/tsc/build pass; waiting for user verification. Announcement banner is still static text.
- **Intent:** The public landing page with dynamic cards.
- **Expected outcomes:**
  - Navigation: Home, Trainings, Sign in / user menu (Admin link for the admin).
  - Announcement area shows active items from `announcements`.
  - Card grid from the database. Each card has a header (title), short description, small picture, and footer (level, Free or the price in the visitor's currency, or live date text). The whole card links to `/courses/[slug]`.
  - Price is formatted with `Intl.NumberFormat` in the currency chosen for that visitor (see Section 3, "Currency by location").
  - Only `published` courses appear, so a card the admin publishes shows up without a code change.
  - Loading and empty states.
- **Todo list:**
  1. Build `Nav`, `AnnouncementBanner`, `TrainingCard`, `CardGrid`.
  2. Fetch published courses and active announcements on the server.
  3. Use `next/image` with Supabase `remotePatterns`.
- **Relevant context:** Sub-tasks 1–3; user's HTML reference.
- **Notes for next task:** _(fill in after completion)_

### Sub-task 5 – Search and pagination
- **Status:** [-] built, search (ILIKE on title and description) and pagination now run as Supabase queries; waiting for user verification.
- **Intent:** Find trainings and page through them.
- **Expected outcomes:**
  - Search box filters cards by title and description.
  - Pagination with a fixed page size, previous/next and page numbers, keeping the search term in the URL (`?q=&page=`).
  - "No results" state and total count.
- **Todo list:**
  1. Add a server query with text search, `range()` and exact count.
  2. Read `searchParams` as a Promise; clamp invalid page numbers.
  3. Build `SearchBar` and `Pagination` components.
- **Relevant context:** `page.md` (`searchParams` is a Promise); search index from Sub-task 2.
- **Notes for next task:** _(fill in after completion)_

### Sub-task 6 – Course page and unit-wise lesson page with video
- **Status:** [-] built, now reads Supabase (`lib/courses.ts`); lock is decided by RLS. Waiting for user verification. Enrolled/admin unlock arrives with sign-in and Stripe.
- **Intent:** What a user sees after clicking a card.
- **Expected outcomes:**
  - `/courses/[slug]` shows title, description, price in the visitor's currency or "Free", and the units (Unit 1 Basics, Unit 2 Intermediate, Unit 3 Advanced) with their lesson titles.
  - Lesson page shows the embedded video, markdown text, previous/next links, and a unit sidebar.
  - One access-check function decides whether a user may open a lesson (free course, enrolled, or admin). Sub-task 8 supplies the paid path.
  - A locked paid lesson shows a "Sign in" or "Pay to unlock" panel instead of content.
  - Unpublished courses return 404 for non-admins.
- **Todo list:**
  1. Build course page and unit/lesson list.
  2. Build lesson layout with `VideoEmbed` and markdown renderer (sanitised).
  3. Add `canAccessCourse()` helper and locked state.
- **Relevant context:** reference `/ccar-f` and `/learn` structure; tables `units`, `lessons`, `enrollments`.
- **Notes for next task:** _(fill in after completion)_

### Sub-task 7 – Admin: create and edit everything
- **Status:** [ ] pending
- **Intent:** The single admin controls all content; every card field is editable.
- **Expected outcomes:**
  - `/admin` lists all courses (draft and published) with edit, publish/unpublish, and delete.
  - Card form covers every field: title, slug, short description, thumbnail upload, footer text, level, kind, price per currency (leave empty for free), status.
  - Unit and lesson editor: add, rename, reorder, delete; lesson title, markdown content, video link.
  - Publishing makes the card appear on the home page; unpublishing hides it.
  - `/admin/announcements` manages the announcement slot.
  - Non-admins are blocked by server checks and RLS.
- **Todo list:**
  1. Admin layout guarded by `requireAdmin()`.
  2. Card form with validation and thumbnail upload.
  3. Unit and lesson editor.
  4. Announcements CRUD.
  5. Refresh the home page data after changes (use the Next 16 revalidation APIs; `revalidateTag` now takes a cacheLife profile argument).
- **Relevant context:** server actions guide; storage bucket from Sub-task 2.
- **Notes for next task:** _(fill in after completion)_

### Sub-task 8 – Paid courses: Stripe Checkout and access
- **Status:** [ ] pending
- **Intent:** A signed-in user pays the one-time registration fee and then can view the paid course.
- **Expected outcomes:**
  - A **Buy** button on a paid course page. Signed-out visitors are sent to sign in, then returned.
  - Buy creates a Stripe Checkout Session (hosted payment page) and redirects the user; success and cancel pages return to the course.
  - The Checkout Session is created in the same currency and price the user saw (from `courses.prices`), chosen on the server at Buy time, never taken from the browser.
  - Access is granted only by Stripe's `checkout.session.completed` webhook (signature verified) which inserts an `enrollments` row. The browser redirect alone never grants access. The webhook is safe to receive twice (unique `stripe_session_id`).
  - After payment, the lesson pages unlock for that user.
  - Admin can see who is enrolled in a course (simple list).
- **Todo list:**
  1. Add the Stripe SDK; server action creates the Checkout Session with course id and user id in metadata.
  2. Build `/api/stripe/webhook` route handler: read raw body, verify signature, insert enrolment.
  3. Build success/cancel pages.
  4. Wire the Buy button and unlock logic into Sub-task 6's access check.
  5. Test in Stripe test mode with Stripe CLI webhook forwarding.
- **Relevant context:** `01-getting-started/15-route-handlers.md`; `enrollments` table; secrets `STRIPE_SECRET_KEY` and `STRIPE_WEBHOOK_SECRET` in `.env.local` only. The user must create a Stripe account.
- **Notes for next task:** _(fill in after completion)_

### Sub-task 9 – Quality and release readiness
- **Status:** [ ] pending
- **Intent:** Make the app safe to deploy.
- **Expected outcomes:**
  - Access matrix checked for anonymous, normal user, paid user, and admin.
  - Form input validated; markdown sanitised.
  - Responsive layouts and basic accessibility (keyboard, alt text, focus).
  - Page metadata for course pages.
  - `bun run lint` and `bun run build` pass with no new warnings.
  - README explains setup, env variables, how to make the admin, and how to test Stripe.
- **Todo list:**
  1. Test access rules with real accounts.
  2. Review forms for validation.
  3. Add `generateMetadata` to course and lesson pages.
  4. Fix lint, type and build issues; update README.
- **Relevant context:** all previous sub-tasks.
- **Notes for next task:** _(fill in after completion)_

---

## 6. Decisions and open questions

**Decided**
- Backend is Supabase; payments are Stripe Checkout, one-time fee per course.
- One admin; everyone else is a normal user.
- Free courses are open to all; paid courses need sign-in plus payment.
- Phase 1 is simple; user-created live cards, progress tracking and categories wait for Phase 2.
- The site is **dark mode only**: no light theme and no toggle.
- Currency follows the visitor's location: country maps to a currency; the admin sets a fixed price per currency; unknown countries or unsupported currencies fall back to USD.

**Still open**
1. ~~**Currencies**~~ **Decided:** USD and INR only. India maps to INR; every other country uses USD.
2. **Video:** is "paste a YouTube/Vimeo link" fine for Phase 1, knowing paid videos are not strongly protected?
3. **Lesson text:** markdown in a plain text box is assumed. Is that acceptable?
4. **Your HTML files:** none are in the workspace yet. Add them (for example in a `reference/` folder) before Sub-task 1 so the dark design can be copied from them.
5. **Stripe account:** you will need your own (test mode is enough to start).
6. ~~**Hosting**~~ **Decided for planning:** Vercel (not final). Country comes from `x-vercel-ip-country` / `geolocation()`. If hosting changes, only the country-header lookup needs to change.

---

## 7. Implementation guidance

- Do one sub-task at a time, in order. After each, update its **Status** and **Notes for next task**, then wait for the user's review.
- Before writing Next.js code, read the matching guide in `node_modules/next/dist/docs/` (see `AGENTS.md`); this Next.js version differs from older ones.
- Never commit secrets. Supabase and Stripe keys live in `.env.local` and are referenced by name only. The Stripe webhook secret and the Supabase service-role key are server-only (never `NEXT_PUBLIC_`).
- `.bob/mcp.json` registers `mcp-server-fetch` (via `uvx`) for reading external pages in future sessions.

----

- Make sure that data should be fetch using API and stub data later on can relace database like postgress 
- Apply best code design practice.
- make clean code , remove unwanted part 
