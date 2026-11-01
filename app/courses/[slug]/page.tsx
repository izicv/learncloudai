import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { Button } from "@/components/button";
import { Container } from "@/components/container";
import { UnitList } from "@/components/unit-list";
import { getUnits } from "@/lib/courses";
import {
  formatPrice,
  getAllTrainingSlugs,
  getTrainingBySlug,
} from "@/lib/trainings";

export async function generateStaticParams() {
  return (await getAllTrainingSlugs()).map((slug) => ({ slug }));
}

export async function generateMetadata({
  params,
}: PageProps<"/courses/[slug]">): Promise<Metadata> {
  const { slug } = await params;
  const training = await getTrainingBySlug(slug);
  return training
    ? { title: training.title, description: training.shortDescription }
    : {};
}

// Needs a real 404 for unknown courses, so it reads params before streaming.
export const instant = false;

export default async function CoursePage({
  params,
}: PageProps<"/courses/[slug]">) {
  const { slug } = await params;
  const training = await getTrainingBySlug(slug);
  if (!training) notFound();

  const units = await getUnits(training.id);
  const firstLesson = units[0]?.lessons[0];
  const price = formatPrice(training.prices);
  const isFreeCourse = price === "Free";

  return (
    <Container className="py-12">
      <div className="mb-8 border border-border bg-surface p-6 sm:p-8">
        <p className="text-sm text-muted">
          {training.level} ·{" "}
          {training.kind === "live" ? "Live training" : "Course"}
        </p>
        <h1 className="mt-2 text-3xl font-bold tracking-tight">
          {training.title}
        </h1>
        <p className="mt-3 max-w-2xl text-muted">{training.shortDescription}</p>
        <div className="mt-5 flex flex-wrap items-center gap-4">
          <span className="text-xl font-semibold">{price}</span>
          {firstLesson &&
            (isFreeCourse ? (
              <Button href={`/courses/${slug}/lessons/${firstLesson.id}`}>
                Start learning
              </Button>
            ) : (
              <Button href="/login">Sign in to unlock</Button>
            ))}
        </div>
        <p className="mt-4 text-sm text-muted">{training.footerText}</p>
      </div>

      {units.length > 0 ? (
        <>
          <h2 className="mb-4 text-2xl font-bold tracking-tight">
            Course outline
          </h2>
          <UnitList slug={slug} units={units} />
        </>
      ) : (
        <p className="text-muted">
          This is a live session. Join details are in the description above.
        </p>
      )}
    </Container>
  );
}
