import type { ExtensionAPI } from "@earendil-works/pi-coding-agent"
import { Type } from "typebox"
import { convert as htmlToText } from "html-to-text"

// Time-to-live for the in-memory cache
const CACHE_TTL_MS = 15 * 60 * 1000;

// Default output chars limit
const DEFAULT_OUTPUT_LIMIT_CHARS = 12000;

// Hard limit of download response size. Does not affect LLM context.
const MAX_DOWNLOAD_BYTES = 5 * 1024 * 1024;

// Hard limit on the number of output chars
const MAX_OUTPUT_CHARS = 50000;

const ACCEPTED_CONTENT = "text/html,text/plain,text/markdown,application/json,application/xml;q=0.9,*/*;q=0.8"
const USER_AGENT = "jomag-pi-web-fetch/1.0"

const cache = new Map<string, {
  timestamp: number;
  output: string;
  details: Record<string, unknown>
}>();

function isSafeHttpUrl(raw: string): boolean {
  try {
    const url = new URL(raw);
    return url.protocol === "http:" || url.protocol === "https:";
  } catch {
    return false
  }
}

function looksLikeHtml(contentType: string, body: string): boolean {
  return (
    contentType.includes("text/html") || /^\s*<!doctype html/i.test(body) || /^\s*<html/i.test(body)
  )
}

function looksLikePlainText(contentType: string): boolean {
  const keywords = ["json", "xml", "javascript", "typescript", "markdown"]
  return contentType.startsWith("text/") || keywords.some((kw) => contentType.includes(kw));
}

function getMaxOutputChars(limit: unknown): number {
  if (typeof limit !== "number" || !Number.isFinite(limit)) {
    return DEFAULT_OUTPUT_LIMIT_CHARS;
  }
  return Math.min(Math.max(Math.floor(limit), 1), MAX_OUTPUT_CHARS);
}

// Convert HTML to plain text while preserving useful structure
// like headings, links and preformatted code blocks
function convertHtml(raw: string): string {
  return htmlToText(raw, {
    wordwrap: false,
    preserveNewlines: false,
    selectors: [
      { selector: "a", options: { hideLinkHrefIfSameAsText: true } },
      { selector: "img", format: "skip" },
      { selector: "script", format: "skip" },
      { selector: "style", format: "skip" },
      { selector: "h1", options: { uppercase: false, } },
      { selector: "h2", options: { uppercase: false, } },
      { selector: "h3", options: { uppercase: false, } },
      { selector: "pre", options: { leadingLineBreaks: 2, trailingLineBreaks: 2 } },
    ]
  }).trim();
}

export default function (pi: ExtensionAPI): void {
  pi.registerTool({
    name: "web_fetch",
    label: "Web Fetch",
    description: "Fetch a web URL and return readable text.",
    parameters: Type.Object({
      url: Type.String({ description: "HTTP or HTTPS URL to fetch" }),
      maxChars: Type.Optional(Type.Number({
        description: `Maximum returned text characters. Default limit: ${DEFAULT_OUTPUT_LIMIT_CHARS}`,
      })),
      fresh: Type.Optional(Type.Boolean({
        description: "Bypass the in-memory cache"
      })),
      mode: Type.Optional(Type.Union([
        Type.Literal("auto"),
        Type.Literal("text"),
        Type.Literal("html")
      ], { description: "Extraction mode. Default: auto" })),
    }),

    async execute(_toolCallId, params, signal) {
      if (!isSafeHttpUrl(params.url)) {
        return {
          isError: true,
          content: [{ type: "text", text: "Invalid URL. Only http:// and https:// URLs are allowed" }],
          details: {}
        }
      }

      const maxChars = getMaxOutputChars(params.maxChars);
      const mode = params.mode ?? 'auto';
      const cacheKey = `${params.url}::${mode}::${maxChars}`;

      const now = Date.now();
      const fetchedAt = new Date(now).toISOString()

      const cached = cache.get(cacheKey);
      if (!params.fresh && cached && now - cached.timestamp < CACHE_TTL_MS) {
        return {
          content: [{ type: "text", text: cached.output }],
          details: { ...cached.details, cached: true }
        }
      }

      const response = await fetch(params.url, {
        redirect: "follow",
        signal,
        headers: {
          "user-agent": USER_AGENT,
          "accept": ACCEPTED_CONTENT,
        }
      })

      const finalUrl = response.url;
      const contentType = (response.headers.get("content-type") ?? "").toLowerCase();
      const contentLength = Number(response.headers.get("content-length") ?? 0);

      if (!response.ok) {
        return {
          isError: true,
          content: [{ type: "text", text: `HTTP ${response.status} ${response.statusText}` }],
          details: { status: response.status, finalUrl, contentType }
        }
      }

      if (contentLength > MAX_DOWNLOAD_BYTES) {
        return {
          isError: true,
          content: [{ type: "text", text: `Response too large: ${contentLength} bytes` }],
          details: { finalUrl, contentType, contentLength }
        }
      }

      if (mode === "auto" && contentType && !looksLikePlainText(contentType) && !contentType.includes("html")) {
        return {
          isError: true,
          content: [{ type: "text", text: `Unsupported content type: ${contentType}` }],
          details: { finalUrl, contentType }
        }
      }

      const buffer = await response.arrayBuffer();
      if (buffer.byteLength > MAX_DOWNLOAD_BYTES) {
        return {
          isError: true,
          content: [{ type: "text", text: `Response too large: ${buffer.byteLength} bytes` }],
          details: { finalUrl, contentType, contentLength: buffer.byteLength }
        }
      }

      const raw = new TextDecoder().decode(buffer);
      const isHtml = mode === "html" || (mode === "auto" && looksLikeHtml(contentType, raw));
      const text = isHtml ? convertHtml(raw) : raw.trim();
      const outputMode = isHtml ? "html" : "text";

      const truncated = text.length > maxChars;
      const returnedText = truncated ? `${text.slice(0, maxChars)}\n\n[truncated]` : text;

      const output = [
        `URL: ${finalUrl}`,
        `Content-Type: ${contentType || "unknown"}`,
        `Fetched: ${fetchedAt}`,
        `Mode: ${outputMode}`,
        `Truncated: ${truncated}`,
        "",
        returnedText
      ].join("\n")

      const details = {
        finalUrl,
        contentType,
        truncated,
        mode: outputMode,
        cached: false
      };

      cache.set(cacheKey, { timestamp: now, output, details });

      return {
        content: [{ type: "text", text: output }], details,
      }
    }
  })
}
