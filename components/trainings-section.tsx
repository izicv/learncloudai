import { Container } from "@/components/container";
import { Pagination } from "@/components/pagination";
import { SearchBar } from "@/components/search-bar";
import { TrainingCard } from "@/components/training-card";
import { getTrainings, PAGE_SIZE } from "@/lib/trainings";

type SearchParams = Promise<{ [key: string]: string | string[] | undefined }>;

function first(v: string | string[] | undefined) {
  return Array.isArray(v) ? v[0] : v;
}

/** Reads searchParams, so it must be rendered inside <Suspense>. */
export async function TrainingsSection({
  searchParams,
}: {
  searchParams: SearchParams;
}) {
  const sp = await searchParams;
  const q = first(sp.q) ?? "";
  const pageNumber = Number(first(sp.page) ?? 1);

  const { items, total, page, totalPages, query } = await getTrainings({
    q,
    page: pageNumber,
  });

  return (
    <Container className="pb-12 pt-10">
      <div>
        <div className="mb-6 flex flex-wrap items-end justify-between gap-2">
          <h2 className="text-3xl font-bold tracking-tight">
            {query ? `Results for “${query}”` : "All trainings"}
          </h2>
          <p className="text-sm text-muted">
            {total === 0
              ? "No trainings found"
              : `${total} training${total === 1 ? "" : "s"} · page ${page} of ${totalPages}`}
          </p>
        </div>

        {items.length === 0 ? (
          <div className="border border-border bg-surface p-10 text-center text-muted">
            Nothing matches “{query}”. Try a different word, or clear the
            search.
          </div>
        ) : (
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {items.map((t) => (
              <TrainingCard key={t.id} training={t} />
            ))}
          </div>
        )}

        <Pagination page={page} totalPages={totalPages} q={query} />
      </div>
    </Container>
  );
}

export function TrainingsSkeleton() {
  return (
    <Container className="pb-12 pt-10">
      <div className="mb-6 h-8 w-48 animate-pulse bg-surface" />
      <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
        {Array.from({ length: PAGE_SIZE }, (_, i) => (
          <div
            key={i}
            className="h-80 animate-pulse border border-border bg-surface"
          />
        ))}
      </div>
    </Container>
  );
}

/** Search box that keeps the current query. Also needs <Suspense>. */
export async function HeroSearch({
  searchParams,
}: {
  searchParams: SearchParams;
}) {
  const sp = await searchParams;
  return <SearchBar q={first(sp.q) ?? ""} />;
}
