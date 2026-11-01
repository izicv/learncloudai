// Units and lessons read from Supabase (public, anonymous client).
//  - The outline (titles only) comes from the `lesson_outline` view, which
//    never exposes lesson text or video.
//  - Lesson text and video come from `lessons`. Row Level Security returns a
//    row only when the course is free (or, once sign-in exists, when the user
//    is enrolled or is the admin). No row means "locked": the database, not
//    this code, decides.

import { cacheLife, cacheTag } from "next/cache";
import { createPublicClient } from "@/lib/supabase/public";

export type OutlineLesson = {
  id: string;
  title: string;
  durationMinutes: number;
};

export type Unit = {
  id: string;
  title: string;
  summary: string;
  lessons: OutlineLesson[];
};

export type LessonContent = {
  /** Plain text for now; paragraphs separated by a blank line. */
  content: string;
  /** YouTube or Vimeo link pasted by the admin. */
  videoUrl: string | null;
};

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export function isUuid(value: string): boolean {
  return UUID.test(value);
}

/** Units of a course with their lesson titles (no content, no video). */
export async function getUnits(courseId: string): Promise<Unit[]> {
  "use cache";
  cacheLife("minutes");
  cacheTag("courses");

  const supabase = createPublicClient();

  const unitsRes = await supabase
    .from("units")
    .select("id, position, title, summary")
    .eq("course_id", courseId)
    .order("position");
  if (unitsRes.error) throw new Error(`getUnits: ${unitsRes.error.message}`);

  const units = unitsRes.data ?? [];
  if (units.length === 0) return [];

  const outlineRes = await supabase
    .from("lesson_outline")
    .select("id, unit_id, position, title, duration_minutes")
    .in(
      "unit_id",
      units.map((u) => u.id),
    )
    .order("position");
  if (outlineRes.error) {
    throw new Error(`getUnits: ${outlineRes.error.message}`);
  }

  const lessons = outlineRes.data ?? [];
  return units.map((u) => ({
    id: u.id,
    title: u.title,
    summary: u.summary,
    lessons: lessons
      .filter((l) => l.unit_id === u.id && l.id && l.title)
      .map((l) => ({
        id: l.id as string,
        title: l.title as string,
        durationMinutes: l.duration_minutes ?? 0,
      })),
  }));
}

/**
 * Lesson text and video for an anonymous visitor, or null when the database
 * hides it (paid course). Callers must have checked that `lessonId` is a UUID.
 */
export async function getLessonContent(
  lessonId: string,
): Promise<LessonContent | null> {
  "use cache";
  cacheLife("minutes");
  cacheTag("courses");

  const { data, error } = await createPublicClient()
    .from("lessons")
    .select("content, video_url")
    .eq("id", lessonId)
    .maybeSingle();
  if (error) throw new Error(`getLessonContent: ${error.message}`);
  return data ? { content: data.content, videoUrl: data.video_url } : null;
}

/** Every (course slug, lesson id) pair, for static generation. */
export async function getAllLessonParams(): Promise<
  { slug: string; lessonId: string }[]
> {
  "use cache";
  cacheLife("minutes");
  cacheTag("courses");

  const supabase = createPublicClient();
  const [courses, units, lessons] = await Promise.all([
    supabase.from("courses").select("id, slug").eq("status", "published"),
    supabase.from("units").select("id, course_id"),
    supabase.from("lesson_outline").select("id, unit_id"),
  ]);
  for (const res of [courses, units, lessons]) {
    if (res.error) throw new Error(`getAllLessonParams: ${res.error.message}`);
  }

  const slugByCourse = new Map(courses.data?.map((c) => [c.id, c.slug]));
  const slugByUnit = new Map(
    units.data?.map((u) => [u.id, slugByCourse.get(u.course_id)]),
  );
  return (lessons.data ?? []).flatMap((l) => {
    const slug = l.unit_id ? slugByUnit.get(l.unit_id) : undefined;
    return slug && l.id ? [{ slug, lessonId: l.id }] : [];
  });
}

/** Turns a pasted YouTube or Vimeo link into an embeddable URL, or null. */
export function toEmbedUrl(url: string): string | null {
  try {
    const u = new URL(url);
    const host = u.hostname.replace(/^www\./, "");
    if (host === "youtu.be") {
      const id = u.pathname.slice(1);
      return id ? `https://www.youtube-nocookie.com/embed/${id}` : null;
    }
    if (host === "youtube.com" || host === "m.youtube.com") {
      const id = u.searchParams.get("v");
      return id ? `https://www.youtube-nocookie.com/embed/${id}` : null;
    }
    if (host === "vimeo.com") {
      const id = u.pathname.split("/").filter(Boolean)[0];
      return id && /^\d+$/.test(id)
        ? `https://player.vimeo.com/video/${id}`
        : null;
    }
  } catch {
    // not a valid URL
  }
  return null;
}
