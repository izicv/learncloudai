import Link from "next/link";
import {
  LiveIcon,
  ProviderIcon,
  providerNames,
} from "@/components/provider-icon";
import { formatPrice, type Training } from "@/lib/trainings";

/** The whole card is one link to the course page. Icons and text only, no colour. */
export function TrainingCard({ training }: { training: Training }) {
  const price = formatPrice(training.prices);
  const isLive = training.kind === "live";

  return (
    <Link
      href={`/courses/${training.slug}`}
      className="group flex h-full flex-col border border-l-[3px] border-border border-l-accent-line bg-surface transition-colors hover:border-border-strong hover:border-l-accent-line hover:bg-surface-2"
    >
      <div className="flex flex-1 flex-col gap-3 p-6">
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-2.5">
            <ProviderIcon provider={training.provider} className="h-6 w-6" />
            <span className="text-xs font-medium uppercase tracking-widest text-muted">
              {providerNames[training.provider]} · {training.level}
            </span>
          </div>
          {isLive && (
            <span className="flex items-center gap-1.5 border border-border-strong px-2 py-1 text-xs font-medium uppercase tracking-widest">
              <LiveIcon className="h-4 w-4" />
              Live
            </span>
          )}
        </div>
        <h3 className="text-xl font-semibold leading-snug">{training.title}</h3>
        <p className="text-sm leading-relaxed text-muted">
          {training.shortDescription}
        </p>
      </div>

      <div className="mx-6 flex items-center justify-between border-t border-border py-4 text-sm">
        <span className="text-muted">{training.footerText}</span>
        <span className="font-semibold">{price}</span>
      </div>
    </Link>
  );
}
