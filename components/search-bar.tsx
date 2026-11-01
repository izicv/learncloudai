"use client";

import { useRouter } from "next/navigation";
import { useEffect, useRef } from "react";

const DEBOUNCE_MS = 250;

/**
 * Search as you type: after a short pause the URL becomes /?q=... and the
 * server re-renders the cards. Enter works too. Page resets to 1.
 */
export function SearchBar({ q = "" }: { q?: string }) {
  const router = useRouter();
  const timer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined);
  // Last value already pushed to the URL, so we never navigate twice for it.
  const lastPushed = useRef(q.trim());

  useEffect(() => () => clearTimeout(timer.current), []);

  function go(value: string) {
    clearTimeout(timer.current);
    const next = value.trim();
    if (next === lastPushed.current) return;
    lastPushed.current = next;
    router.replace(next ? `/?q=${encodeURIComponent(next)}` : "/", {
      scroll: false,
    });
  }

  return (
    <form
      action="/"
      method="get"
      role="search"
      className="flex"
      onSubmit={(e) => {
        e.preventDefault();
        go(new FormData(e.currentTarget).get("q")?.toString() ?? "");
      }}
    >
      <label htmlFor="q" className="sr-only">
        Search trainings
      </label>
      <input
        id="q"
        name="q"
        type="search"
        autoComplete="off"
        defaultValue={q}
        placeholder="Search trainings, e.g. agents, prompts, RAG"
        onChange={(e) => {
          const value = e.currentTarget.value;
          clearTimeout(timer.current);
          timer.current = setTimeout(() => go(value), DEBOUNCE_MS);
        }}
        className="min-w-0 flex-1 border border-border-strong bg-surface px-5 py-3.5 text-base text-foreground placeholder:text-muted hover:border-primary focus:border-primary focus:outline-none"
      />
    </form>
  );
}
