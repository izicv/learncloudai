// Trainings (the cards) read from Supabase. Public data only: the anonymous
// client sees published courses (Row Level Security). Results are cached with
// `use cache`; the admin screens will call revalidateTag("courses") after edits.

import { cacheLife, cacheTag } from "next/cache";
import type { Database } from "@/lib/supabase/database.types";
import { createPublicClient } from "@/lib/supabase/public";

type CourseRow = Database["public"]["Tables"]["courses"]["Row"];

export type Training = {
  id: string;
  /** Whose platform the training targets; shown as an icon on the card. */
  provider: "anthropic" | "openai" | "google";
  slug: string;
  title: string;
  shortDescription: string;
  thumbnailUrl: string | null;
  footerText: string;
  level: "Beginner" | "Intermediate" | "Advanced";
  kind: "course" | "live";
  /** Price in minor units per currency. Empty object = free. */
  prices: Partial<Record<"USD" | "INR", number>>;
};

export const PAGE_SIZE = 8;

function toTraining(row: CourseRow): Training {
  const raw =
    row.prices && typeof row.prices === "object" && !Array.isArray(row.prices)
      ? row.prices
      : {};
  const prices: Training["prices"] = {};
  if (typeof raw.USD === "number") prices.USD = raw.USD;
  if (typeof raw.INR === "number") prices.INR = raw.INR;

  return {
    id: row.id,
    provider: row.provider,
    slug: row.slug,
    title: row.title,
    shortDescription: row.short_description,
    thumbnailUrl: row.thumbnail_url,
    footerText: row.footer_text,
    level: row.level,
    kind: row.kind,
    prices,
  };
}

export type TrainingPage = {
  items: Training[];
  total: number;
  page: number;
  totalPages: number;
  query: string;
};

export async function getTrainings(params: {
  q?: string;
  page?: number;
}): Promise<TrainingPage> {
  "use cache";
  cacheLife("minutes");
  cacheTag("courses");

  const query = (params.q ?? "").trim();
  // Characters with a special meaning in a PostgREST filter or an ILIKE pattern.
  const term = query.replace(/[%_,()\\"*]/g, " ").trim();
  const supabase = createPublicClient();

  const filtered = (head: boolean) => {
    let req = supabase
      .from("courses")
      .select("*", { count: "exact", head })
      .eq("status", "published");
    if (term) {
      req = req.or(
        `title.ilike."%${term}%",short_description.ilike."%${term}%"`,
      );
    }
    return req;
  };

  const counted = await filtered(true);
  if (counted.error) throw new Error(`getTrainings: ${counted.error.message}`);

  const total = counted.count ?? 0;
  const totalPages = Math.max(1, Math.ceil(total / PAGE_SIZE));
  const requested = Number.isFinite(params.page) ? Number(params.page) : 1;
  const page = Math.min(Math.max(1, Math.floor(requested)), totalPages);
  const from = (page - 1) * PAGE_SIZE;

  const { data, error } = await filtered(false)
    .order("created_at", { ascending: false })
    .order("title", { ascending: true })
    .range(from, from + PAGE_SIZE - 1);
  if (error) throw new Error(`getTrainings: ${error.message}`);

  return { items: (data ?? []).map(toTraining), total, page, totalPages, query };
}

export async function getTrainingBySlug(
  slug: string,
): Promise<Training | undefined> {
  "use cache";
  cacheLife("minutes");
  cacheTag("courses");

  const { data, error } = await createPublicClient()
    .from("courses")
    .select("*")
    .eq("status", "published")
    .eq("slug", slug)
    .maybeSingle();
  if (error) throw new Error(`getTrainingBySlug: ${error.message}`);
  return data ? toTraining(data) : undefined;
}

export async function getAllTrainingSlugs(): Promise<string[]> {
  "use cache";
  cacheLife("minutes");
  cacheTag("courses");

  const { data, error } = await createPublicClient()
    .from("courses")
    .select("slug")
    .eq("status", "published");
  if (error) throw new Error(`getAllTrainingSlugs: ${error.message}`);
  return (data ?? []).map((r) => r.slug);
}

/** Temporary USD-only display. Currency by location is added in a later part. */
export function formatPrice(prices: Training["prices"]): string {
  const usd = prices.USD;
  if (!usd) return "Free";
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
    maximumFractionDigits: 0,
  }).format(usd / 100);
}
