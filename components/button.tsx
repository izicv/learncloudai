import Link from "next/link";
import type { ComponentProps } from "react";

type Variant = "primary" | "outline";

const styles: Record<Variant, string> = {
  primary: "bg-primary text-primary-foreground hover:bg-primary-hover",
  outline:
    "border border-border text-foreground hover:border-primary hover:text-primary-hover",
};

export function Button({
  variant = "primary",
  className = "",
  ...props
}: ComponentProps<typeof Link> & { variant?: Variant }) {
  return (
    <Link
      className={`inline-flex items-center justify-center rounded-full px-5 py-2 text-sm font-semibold transition-colors ${styles[variant]} ${className}`}
      {...props}
    />
  );
}
