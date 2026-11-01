import Link from "next/link";

function href(q: string, page: number) {
  const sp = new URLSearchParams();
  if (q) sp.set("q", q);
  if (page > 1) sp.set("page", String(page));
  const qs = sp.toString();
  return qs ? `/?${qs}#trainings` : "/#trainings";
}

const base =
  "inline-flex h-10 min-w-10 items-center justify-center rounded-full border px-3 text-sm transition-colors";

export function Pagination({
  page,
  totalPages,
  q,
}: {
  page: number;
  totalPages: number;
  q: string;
}) {
  if (totalPages <= 1) return null;

  const pages = Array.from({ length: totalPages }, (_, i) => i + 1);

  return (
    <nav
      aria-label="Pagination"
      className="mt-10 flex flex-wrap items-center justify-center gap-2"
    >
      {page > 1 ? (
        <Link
          href={href(q, page - 1)}
          className={`${base} border-border hover:border-primary`}
        >
          ← Prev
        </Link>
      ) : (
        <span className={`${base} border-border opacity-40`}>← Prev</span>
      )}

      {pages.map((p) => (
        <Link
          key={p}
          href={href(q, p)}
          aria-current={p === page ? "page" : undefined}
          className={
            p === page
              ? `${base} border-primary bg-primary font-semibold text-primary-foreground`
              : `${base} border-border hover:border-primary`
          }
        >
          {p}
        </Link>
      ))}

      {page < totalPages ? (
        <Link
          href={href(q, page + 1)}
          className={`${base} border-border hover:border-primary`}
        >
          Next →
        </Link>
      ) : (
        <span className={`${base} border-border opacity-40`}>Next →</span>
      )}
    </nav>
  );
}
