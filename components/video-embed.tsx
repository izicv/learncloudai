import { toEmbedUrl } from "@/lib/courses";

/** Embeds a pasted YouTube or Vimeo link. Shows a note if the link is not supported. */
export function VideoEmbed({ url, title }: { url: string; title: string }) {
  const src = toEmbedUrl(url);

  if (!src) {
    return (
      <div className="border border-border bg-surface p-6 text-sm text-muted">
        This video link is not supported. Use a YouTube or Vimeo link.
      </div>
    );
  }

  return (
    <div className="aspect-video w-full border border-border bg-surface-lowest">
      <iframe
        src={src}
        title={title}
        loading="lazy"
        allow="accelerometer; encrypted-media; picture-in-picture; fullscreen"
        referrerPolicy="strict-origin-when-cross-origin"
        className="h-full w-full"
      />
    </div>
  );
}
