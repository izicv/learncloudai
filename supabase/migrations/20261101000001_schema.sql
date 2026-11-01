-- LearnCloudAI schema (Sub-task 2, part 1: tables, enums, indexes).
-- Access rules (RLS), storage and the sign-up trigger are in the next migration.

create extension if not exists pg_trgm with schema extensions;

-- ---------------------------------------------------------------- enums ----
create type public.user_role     as enum ('user', 'admin');
create type public.course_level  as enum ('Beginner', 'Intermediate', 'Advanced');
create type public.course_kind   as enum ('course', 'live');
create type public.course_status as enum ('draft', 'published');
create type public.provider      as enum ('anthropic', 'openai', 'google');

-- --------------------------------------------------------------- tables ----
-- One row per auth user. The role is set manually for the single admin.
create table public.profiles (
  id         uuid primary key references auth.users (id) on delete cascade,
  email      text,
  role       public.user_role not null default 'user',
  created_at timestamptz not null default now()
);

-- The cards and the course header.
create table public.courses (
  id                uuid primary key default gen_random_uuid(),
  slug              text not null unique
                      check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  title             text not null check (length(title) between 1 and 200),
  short_description text not null default '',
  thumbnail_url     text,
  footer_text       text not null default '',
  level             public.course_level not null default 'Beginner',
  kind              public.course_kind not null default 'course',
  provider          public.provider not null default 'anthropic',
  -- Price in minor units per currency, e.g. {"USD":1900,"INR":99900}.
  -- An empty object means the course is free.
  prices            jsonb not null default '{}'::jsonb
                      check (
                        jsonb_typeof(prices) = 'object'
                        and (prices - array['USD', 'INR']) = '{}'::jsonb
                        and coalesce(jsonb_typeof(prices -> 'USD'), 'number') = 'number'
                        and coalesce(jsonb_typeof(prices -> 'INR'), 'number') = 'number'
                      ),
  status            public.course_status not null default 'draft',
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

-- Unit 1 Basics, Unit 2 Intermediate, Unit 3 Advanced ...
create table public.units (
  id        uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses (id) on delete cascade,
  position  int  not null check (position > 0),
  title     text not null,
  summary   text not null default '',
  -- Deferred so units can be reordered inside one transaction.
  unique (course_id, position) deferrable initially deferred
);

-- A topic inside a unit. content is markdown; video_url is a YouTube/Vimeo link.
create table public.lessons (
  id               uuid primary key default gen_random_uuid(),
  unit_id          uuid not null references public.units (id) on delete cascade,
  position         int  not null check (position > 0),
  title            text not null,
  content          text not null default '',
  video_url        text,
  duration_minutes int  not null default 0 check (duration_minutes >= 0),
  unique (unit_id, position) deferrable initially deferred
);

-- Home-page slot for a new training or a market product.
create table public.announcements (
  id         uuid primary key default gen_random_uuid(),
  title      text not null,
  body       text not null default '',
  image_url  text,
  link_url   text,
  active     boolean not null default true,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- Who has access to a paid course. Written only by the server (Stripe webhook).
create table public.enrollments (
  user_id           uuid not null references auth.users (id) on delete cascade,
  course_id         uuid not null references public.courses (id) on delete cascade,
  -- Unique, so a webhook delivered twice cannot create two rows.
  stripe_session_id text not null unique,
  created_at        timestamptz not null default now(),
  primary key (user_id, course_id)
);

-- -------------------------------------------------------------- indexes ----
create index units_course_id_idx       on public.units (course_id);
create index lessons_unit_id_idx       on public.lessons (unit_id);
create index enrollments_course_id_idx on public.enrollments (course_id);
create index courses_status_idx        on public.courses (status, created_at desc);
create index announcements_active_idx  on public.announcements (active, sort_order);

-- Search box: substring match on title and description (ILIKE '%word%').
create index courses_search_idx on public.courses
  using gin ((title || ' ' || short_description) extensions.gin_trgm_ops);

-- ------------------------------------------------------------- triggers ----
create function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger courses_set_updated_at
  before update on public.courses
  for each row execute function public.set_updated_at();
