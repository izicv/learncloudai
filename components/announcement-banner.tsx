import Link from "next/link";
import { Container } from "@/components/container";

// Sample announcement for Part 2. Later this comes from the `announcements`
// table and is managed by the admin.
export function AnnouncementBanner() {
  return (
    <section aria-label="Announcement" className="border-b border-border">
      <Container className="py-4">
        <Link
          href="/#trainings"
          className="flex flex-col gap-1 border border-border bg-surface px-5 py-4 transition-colors hover:border-primary sm:flex-row sm:items-center sm:justify-between"
        >
          <span className="flex items-center gap-3">
            <span className="bg-primary px-2.5 py-0.5 text-xs font-bold uppercase tracking-wide text-primary-foreground">
              New
            </span>
            <span className="text-sm font-semibold">
              Live Workshop: Hands-on AI Projects
            </span>
          </span>
          <span className="text-sm text-muted">
            Build a small AI project with an instructor. Saturday 10:00 AM IST
            →
          </span>
        </Link>
      </Container>
    </section>
  );
}
