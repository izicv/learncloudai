import { Button } from "@/components/button";

/** Shown instead of lesson content on a paid course. Payment arrives in a later part. */
export function LockedPanel({ price }: { price: string }) {
  return (
    <div className="border border-border bg-surface p-8 text-center">
      <h2 className="text-xl font-semibold">This lesson is part of a paid course</h2>
      <p className="mx-auto mt-2 max-w-md text-sm text-muted">
        Sign in and pay the one-time fee ({price}) to unlock every lesson.
      </p>
      <div className="mt-5 flex justify-center">
        <Button href="/login">Sign in to unlock</Button>
      </div>
    </div>
  );
}
