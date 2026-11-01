import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Container } from "@/components/container";
import { LockedPanel } from "@/components/locked-panel";
import { UnitList } from "@/components/unit-list";
import { VideoEmbed } from "@/components/video-embed";
import {
  getAllLessonParams,
  getLessonContent,
  getUnits,
  isUuid,
} from "@/lib/courses";
import { formatPrice, getTrainingBySlug } from "@/lib/trainings";

export async function generateStaticParams() {
  return getAllLessonParams();
}

export async function generateMetadata({
  params,
}: PageProps<"/courses/[slug]/lessons/[lessonId]">): Promise<Metadata> {
  const { slug, lessonId } = await params;
  if (!isUuid(lessonId)) return {};
  const training = await getTrainingBySlug(slug);
  if (!training) return {};
  const title = (await getUnits(training.id))
    .flatMap((u) => u.lessons)
    .find((l) => l.id === lessonId)?.title;
  return title ? { title } : {};
}

// Needs a real 404 for unknown lessons, so it reads params before streaming.
export const instant = false;

export default async function LessonPage({
  params,
}: PageProps<"/courses/[slug]/lessons/[lessonId]">) {
  const { slug, lessonId } = await params;
  if (!isUuid(lessonId)) notFound();

  const training = await getTrainingBySlug(slug);
  if (!training) notFound();

  const units = await getUnits(training.id);
  const flat = units.flatMap((unit) =>
    unit.lessons.map((lesson) => ({ unit, lesson })),
  );
  const index = flat.findIndex((x) => x.lesson.id === lessonId);
  if (index === -1) notFound();

  const { unit, lesson } = flat[index];
  const previous = flat[index - 1]?.lesson ?? null;
  const next = flat[index + 1]?.lesson ?? null;

  // The database decides: Row Level Security returns nothing for a locked lesson.
  const content = await getLessonContent(lessonId);

  return (
    <Container className="py-10">
      <nav aria-label="Breadcrumb" className="mb-6 text-sm text-muted">
        <Link href="/" className="hover:text-primary">
          Home
        </Link>
        {" / "}
        <Link href={`/courses/${slug}`} className="hover:text-primary">
          {training.title}
        </Link>
        {" / "}
        <span>{unit.title}</span>
      </nav>

      <div className="grid gap-8 lg:grid-cols-[1fr_20rem]">
        <article className="min-w-0">
          <h1 className="mb-5 text-3xl font-bold tracking-tight">
            {lesson.title}
          </h1>

          {content ? (
            <>
              {content.videoUrl && (
                <VideoEmbed url={content.videoUrl} title={lesson.title} />
              )}
              <div className="mt-6 flex flex-col gap-4 leading-relaxed">
                {content.content.split(/\n\s*\n/).map((para, i) => (
                  <p key={i}>{para}</p>
                ))}
              </div>
            </>
          ) : (
            <LockedPanel price={formatPrice(training.prices)} />
          )}

          <div className="mt-8 flex justify-between gap-4 border-t border-border pt-5 text-sm">
            {previous ? (
              <Link
                href={`/courses/${slug}/lessons/${previous.id}`}
                className="hover:text-primary"
              >
                ← {previous.title}
              </Link>
            ) : (
              <span />
            )}
            {next && (
              <Link
                href={`/courses/${slug}/lessons/${next.id}`}
                className="text-right hover:text-primary"
              >
                {next.title} →
              </Link>
            )}
          </div>
        </article>

        <aside aria-label="Course outline">
          <UnitList slug={slug} units={units} currentLessonId={lesson.id} />
        </aside>
      </div>
    </Container>
  );
}
