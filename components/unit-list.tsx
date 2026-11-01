import Link from "next/link";
import type { Unit } from "@/lib/courses";

/** Units with their lessons. Used on the course page and as the lesson sidebar. */
export function UnitList({
  slug,
  units,
  currentLessonId,
}: {
  slug: string;
  units: Unit[];
  currentLessonId?: string;
}) {
  return (
    <div className="flex flex-col gap-4">
      {units.map((unit) => (
        <section key={unit.id} className="border border-border bg-surface">
          <div className="border-b border-border px-4 py-3">
            <h3 className="font-semibold">{unit.title}</h3>
            <p className="text-sm text-muted">{unit.summary}</p>
          </div>
          <ul>
            {unit.lessons.map((lesson) => {
              const active = lesson.id === currentLessonId;
              return (
                <li key={lesson.id} className="border-b border-border last:border-b-0">
                  <Link
                    href={`/courses/${slug}/lessons/${lesson.id}`}
                    aria-current={active ? "page" : undefined}
                    className={`flex items-center justify-between gap-3 px-4 py-2.5 text-sm transition-colors hover:text-primary ${
                      active ? "bg-surface-2 text-primary" : ""
                    }`}
                  >
                    <span>{lesson.title}</span>
                    <span className="shrink-0 text-xs text-muted">
                      {lesson.durationMinutes} min
                    </span>
                  </Link>
                </li>
              );
            })}
          </ul>
        </section>
      ))}
    </div>
  );
}
