import { Suspense } from "react";
import { AnnouncementBanner } from "@/components/announcement-banner";
import { Container } from "@/components/container";
import { Hero } from "@/components/hero";
import { SearchBar } from "@/components/search-bar";
import {
  HeroSearch,
  TrainingsSection,
  TrainingsSkeleton,
} from "@/components/trainings-section";

export default function Home({ searchParams }: PageProps<"/">) {
  return (
    <>
      <Hero />
      <AnnouncementBanner />
      <div id="trainings" className="scroll-mt-24">
        <Container className="pt-12">
          <div className="max-w-xl">
            {/* Static shell shows an empty search box; the query-aware one streams in. */}
            <Suspense fallback={<SearchBar />}>
              <HeroSearch searchParams={searchParams} />
            </Suspense>
          </div>
        </Container>
        <Suspense fallback={<TrainingsSkeleton />}>
          <TrainingsSection searchParams={searchParams} />
        </Suspense>
      </div>
    </>
  );
}
