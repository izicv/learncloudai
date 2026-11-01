import Link from "next/link";
import { Button } from "@/components/button";
import { Container } from "@/components/container";

const links = [
  { href: "/", label: "Home" },
  { href: "/#trainings", label: "Trainings" },
];

export function SiteHeader() {
  return (
    <header className="sticky top-0 z-40 border-b border-border bg-background/90 backdrop-blur">
      <Container className="flex h-[72px] items-center justify-between gap-4">
        <Link href="/" className="text-lg font-bold tracking-tight">
          Learn<span className="text-primary">Cloud</span>AI
        </Link>

        <nav aria-label="Main" className="hidden items-center gap-6 md:flex">
          {links.map((l) => (
            <Link
              key={l.label}
              href={l.href}
              className="text-sm text-muted transition-colors hover:text-foreground"
            >
              {l.label}
            </Link>
          ))}
        </nav>

        <div className="flex items-center gap-3">
          <Button href="/login" className="hidden md:inline-flex">
            Sign in
          </Button>

          {/* Mobile menu: plain <details>, no client JavaScript needed */}
          <details className="relative md:hidden">
            <summary
              aria-label="Menu"
              className="flex h-10 w-10 cursor-pointer list-none items-center justify-center rounded-lg border border-border text-xl [&::-webkit-details-marker]:hidden"
            >
              ☰
            </summary>
            <nav
              aria-label="Mobile"
              className="absolute right-0 mt-2 flex w-48 flex-col gap-1 rounded-xl border border-border bg-surface p-2 shadow-lg"
            >
              {links.map((l) => (
                <Link
                  key={l.label}
                  href={l.href}
                  className="rounded-lg px-3 py-2 text-sm text-muted hover:bg-surface-2 hover:text-foreground"
                >
                  {l.label}
                </Link>
              ))}
              <Link
                href="/login"
                className="rounded-lg px-3 py-2 text-sm font-semibold text-primary-hover hover:bg-surface-2"
              >
                Sign in
              </Link>
            </nav>
          </details>
        </div>
      </Container>
    </header>
  );
}
