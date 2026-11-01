# Supabase setup

Database schema, access rules and sample data for LearnCloudAI.

```
supabase/
  migrations/
    20261101000001_schema.sql        tables, enums, indexes, updated_at trigger
    20261101000002_access_rules.sql  RLS, lesson_outline view, storage bucket, sign-up trigger
  seed.sql                           14 sample trainings, 36 units, 108 lessons, 1 announcement
```

## 1. Create the project and apply the SQL

1. Create a project at https://supabase.com (free tier is fine).
2. Open **SQL Editor** and run, in this order, the full contents of:
   1. `migrations/20261101000001_schema.sql`
   2. `migrations/20261101000002_access_rules.sql`
   3. `seed.sql` (optional sample data; safe to run again)

   Or, with the Supabase CLI: `supabase link` then `supabase db push`, and run `seed.sql` in the SQL Editor.
3. Copy the keys into `.env.local` (never commit it, never paste keys in chat):

   | Variable | Where to find it |
   |---|---|
   | `NEXT_PUBLIC_SUPABASE_URL` | Project Settings > API > Project URL |
   | `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` | Project Settings > API > publishable key (formerly "anon") |
   | `SUPABASE_SERVICE_ROLE_KEY` | Project Settings > API > service_role key (server only) |

## 2. Make one account the admin

There is no admin sign-up screen. Sign up normally on the site first (Sub-task 3), then run this once in the SQL Editor with your own email:

```sql
update public.profiles set role = 'admin' where email = 'you@example.com';
```

Nobody can change a role from the browser: `profiles` has no update policy.

## 3. Who can do what

| | Anonymous | Signed-in user | Paid user | Admin |
|---|---|---|---|---|
| Published courses, units, announcements | read | read | read | read (and drafts) |
| Lesson outline (titles only, `lesson_outline` view) | read | read | read | read |
| Lesson text and video of a **free** course | read | read | read | read |
| Lesson text and video of a **paid** course | no | no | yes, if enrolled | yes |
| Create / edit / delete courses, units, lessons, announcements | no | no | no | yes |
| Upload to `thumbnails` bucket | no | no | no | yes |
| Own enrollments | no | read | read | read all |
| Write enrollments | service role only (Stripe webhook) | | | |

A course is **free** when `prices` is `{}` or has no positive amount. `prices` holds minor units and only the keys `USD` and `INR`, for example `{"USD":1900,"INR":99900}`.

## 4. Notes

- The Next.js app still reads sample data from `lib/`. Swapping `getTrainings()`, `getUnits()` and `canAccessCourse()` to Supabase queries is the next step.
- Lessons are read from `lessons` (RLS protects content and video). The course page should list titles from `lesson_outline`, which never exposes content or video.
- Unit and lesson `position` is unique per parent but checked at commit, so reordering can be done in one transaction.
- Search uses `ILIKE '%word%'` on title and description, backed by a trigram index.
- Tested on a local Postgres (PGlite) with 40 checks for the four roles plus constraints. It has not yet been run on a real Supabase project.
