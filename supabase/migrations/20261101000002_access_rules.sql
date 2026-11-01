-- LearnCloudAI access rules (Sub-task 2, part 2).
-- RLS, lesson outline view, storage bucket and the sign-up trigger.
--
-- Rules (ai-training-platform-plan.md, Section 3):
--  * Anyone reads published courses, their units, and active announcements.
--  * Lesson content/video is readable if the course is free, or the user is
--    enrolled, or the user is the admin.
--  * Only the admin writes courses, units, lessons and announcements.
--  * A user reads only their own enrollments; only the server (service role,
--    which bypasses RLS) writes them.
--  * Exactly one admin, set by hand: see supabase/README.md.

-- -------------------------------------------------------------- helpers ----
-- security definer: these read profiles/enrollments without going through
-- their RLS, which would otherwise recurse. search_path is pinned for safety.

create function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.profiles
    where id = (select auth.uid()) and role = 'admin'
  );
$$;

-- A course is free when it has no positive price in any supported currency.
create function public.is_free(prices jsonb)
returns boolean
language sql
immutable
set search_path = ''
as $$
  select coalesce((prices ->> 'USD')::int, 0) <= 0
     and coalesce((prices ->> 'INR')::int, 0) <= 0;
$$;

-- May the current user open the lessons of this course?
create function public.has_course_access(p_course_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select public.is_admin()
      or exists (
        select 1
        from public.courses c
        where c.id = p_course_id
          and c.status = 'published'
          and (
            public.is_free(c.prices)
            or exists (
              select 1 from public.enrollments e
              where e.course_id = c.id and e.user_id = (select auth.uid())
            )
          )
      );
$$;

-- ------------------------------------------------------------------ RLS ----
alter table public.profiles      enable row level security;
alter table public.courses       enable row level security;
alter table public.units         enable row level security;
alter table public.lessons       enable row level security;
alter table public.announcements enable row level security;
alter table public.enrollments   enable row level security;

-- profiles: read your own row (admin reads all). No insert/update/delete
-- policy, so nobody can change a role from the browser.
create policy "profiles: read own or admin" on public.profiles
  for select to authenticated
  using (id = (select auth.uid()) or public.is_admin());

-- courses
create policy "courses: read published or admin" on public.courses
  for select to anon, authenticated
  using (status = 'published' or public.is_admin());
create policy "courses: admin insert" on public.courses
  for insert to authenticated with check (public.is_admin());
create policy "courses: admin update" on public.courses
  for update to authenticated
  using (public.is_admin()) with check (public.is_admin());
create policy "courses: admin delete" on public.courses
  for delete to authenticated using (public.is_admin());

-- units: visible whenever their course is visible (courses RLS applies here).
create policy "units: read if course visible" on public.units
  for select to anon, authenticated
  using (exists (select 1 from public.courses c where c.id = units.course_id));
create policy "units: admin insert" on public.units
  for insert to authenticated with check (public.is_admin());
create policy "units: admin update" on public.units
  for update to authenticated
  using (public.is_admin()) with check (public.is_admin());
create policy "units: admin delete" on public.units
  for delete to authenticated using (public.is_admin());

-- lessons: content and video only with course access.
create policy "lessons: read with course access" on public.lessons
  for select to anon, authenticated
  using (
    exists (
      select 1 from public.units u
      where u.id = lessons.unit_id
        and public.has_course_access(u.course_id)
    )
  );
create policy "lessons: admin insert" on public.lessons
  for insert to authenticated with check (public.is_admin());
create policy "lessons: admin update" on public.lessons
  for update to authenticated
  using (public.is_admin()) with check (public.is_admin());
create policy "lessons: admin delete" on public.lessons
  for delete to authenticated using (public.is_admin());

-- announcements
create policy "announcements: read active or admin" on public.announcements
  for select to anon, authenticated
  using (active or public.is_admin());
create policy "announcements: admin insert" on public.announcements
  for insert to authenticated with check (public.is_admin());
create policy "announcements: admin update" on public.announcements
  for update to authenticated
  using (public.is_admin()) with check (public.is_admin());
create policy "announcements: admin delete" on public.announcements
  for delete to authenticated using (public.is_admin());

-- enrollments: read your own (admin reads all). No write policies: only the
-- service role (Stripe webhook) inserts rows.
create policy "enrollments: read own or admin" on public.enrollments
  for select to authenticated
  using (user_id = (select auth.uid()) or public.is_admin());

-- ------------------------------------------------- lesson outline view ----
-- The course page lists lesson titles to everyone, including locked ones.
-- The view runs with its owner's rights (it bypasses lessons RLS) but exposes
-- only id, unit, position, title and duration - never content or video_url -
-- and only for published courses (admin sees drafts too).
create view public.lesson_outline
with (security_invoker = false) as
select l.id, l.unit_id, l.position, l.title, l.duration_minutes
from public.lessons l
join public.units u   on u.id = l.unit_id
join public.courses c on c.id = u.course_id
where c.status = 'published' or public.is_admin();

grant select on public.lesson_outline to anon, authenticated;

-- -------------------------------------------------------------- storage ----
-- Public bucket for card and announcement pictures; only the admin writes.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'thumbnails', 'thumbnails', true, 2097152,
  array['image/png', 'image/jpeg', 'image/webp']
)
on conflict (id) do nothing;

create policy "thumbnails: admin insert" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'thumbnails' and public.is_admin());
create policy "thumbnails: admin update" on storage.objects
  for update to authenticated
  using (bucket_id = 'thumbnails' and public.is_admin())
  with check (bucket_id = 'thumbnails' and public.is_admin());
create policy "thumbnails: admin delete" on storage.objects
  for delete to authenticated
  using (bucket_id = 'thumbnails' and public.is_admin());

-- -------------------------------------------------------- sign-up trigger --
-- Every new auth user gets a profile with the default role 'user'.
create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email)
  on conflict (id) do nothing;
  return new;
end;
$$;

revoke execute on function public.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Users who signed up before this migration.
insert into public.profiles (id, email)
select id, email from auth.users
on conflict (id) do nothing;
