import { createClient } from "@supabase/supabase-js";
import type { Database } from "@/lib/supabase/database.types";

/**
 * Anonymous Supabase client for public data (published courses, outlines,
 * free lessons). It reads no cookies, so it is safe inside `use cache`.
 * Row Level Security decides what the anonymous role can see.
 *
 * Do NOT use it for signed-in users: their data needs a per-request client
 * that reads the session cookie (added with sign-in), and must not be cached.
 */
export function createPublicClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
  if (!url || !key) {
    throw new Error(
      "Missing NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY in .env.local",
    );
  }
  return createClient<Database>(url, key, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}
