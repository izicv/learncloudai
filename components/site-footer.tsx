import Link from "next/link";
import { Container } from "@/components/container";

export function SiteFooter() {
  return (
    <footer className="mt-auto border-t border-border bg-surface">
      <Container className="flex flex-col items-center justify-between gap-3 py-8 text-sm text-muted sm:flex-row">
        <Link href="/" className="font-semibold text-foreground">
          Learn<span className="text-primary">Cloud</span>AI
        </Link>
        <p>Practical AI training, from basics to advanced.</p>
      </Container>
    </footer>
  );
}
