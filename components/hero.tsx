import { Container } from "@/components/container";

export function Hero() {
  return (
    <section className="border-b border-border bg-surface-lowest">
      <Container className="py-20 sm:py-28">
        <h1 className="max-w-4xl text-5xl font-bold leading-[1.02] tracking-[-0.04em] sm:text-7xl lg:text-8xl">
          Learn AI, step by step.
        </h1>
        <p className="mt-6 max-w-xl text-lg text-muted">
          Practical AI training from the basics to advanced topics, with
          lessons and video for every unit.
        </p>
        <a
          href="#trainings"
          className="mt-8 inline-block text-xs font-medium uppercase tracking-[0.13em] text-muted transition-colors hover:text-foreground"
        >
          Search trainings →
        </a>
      </Container>
    </section>
  );
}
