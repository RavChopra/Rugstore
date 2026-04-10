# Rugstore Shop — Asset Repository

Image assets for the Rugstore Shop eBay listing template.

## Folder structure

```
images/
├── logo/        Brand logos (SVG + PNG variants)
├── tiles/       Category tile images (6 total, reused across every listing)
├── hero/        Per-listing hero product shots
└── cross-sell/  Carousel cards for "You May Also Like" (6 total)
```

## Image URL patterns

Use **jsDelivr CDN** for all eBay listing references — it's a free global CDN that proxies this repo, gives proper caching, no rate limits, and HTTPS.

### jsDelivr (recommended for eBay listings)

```
https://cdn.jsdelivr.net/gh/RavChopra/Rugstore@main/images/logo/logo-teal-bg.png
https://cdn.jsdelivr.net/gh/RavChopra/Rugstore@main/images/tiles/tile-modern.jpg
https://cdn.jsdelivr.net/gh/RavChopra/Rugstore@main/images/hero/hero-listing123.jpg
https://cdn.jsdelivr.net/gh/RavChopra/Rugstore@main/images/cross-sell/cross-1.jpg
```

**Pattern:** `https://cdn.jsdelivr.net/gh/RavChopra/Rugstore@main/{path}`

Pin to a specific commit for cache busting: `@commitsha` instead of `@main`.

### GitHub raw (fallback)

```
https://raw.githubusercontent.com/RavChopra/Rugstore/main/images/logo/logo-teal-bg.png
```

Works, but has rate limits and no proper CDN. Use jsDelivr instead.

## Current contents

### `images/logo/`

| File | Use |
|---|---|
| `logo-teal-bg.png` | Listing banner (teal background baked in) |
| `logo-teal-bg.svg` | Vector source |
| `logo-transparent.png` | Use on dark/gradient backgrounds |
| `logo-transparent.svg` | Vector source |
| `logo-light.png` | Use on cream/light backgrounds |
| `logo-light.svg` | Vector source |

### `images/tiles/`

_Empty — upload these 6 files:_

- `tile-modern.jpg` (500×400, JPG, <150KB)
- `tile-antislip.jpg`
- `tile-traditional.jpg`
- `tile-shaggy.jpg`
- `tile-wool.jpg`
- `tile-kitchen.jpg`

### `images/hero/`

_Empty — one hero image per listing:_

- `hero-{listingId}.jpg` (1200×800, JPG, <200KB)

### `images/cross-sell/`

_Empty — upload 6 square product shots:_

- `cross-1.jpg` through `cross-6.jpg` (400×400, JPG, <100KB)

## Adding new images

```bash
# Drop files into the appropriate folder, then:
git add images/
git commit -m "Add: kitchen rug tile image"
git push
```

jsDelivr picks up new commits within a few minutes. If a URL returns stale content, force-refresh with a commit-pinned URL:

```
https://cdn.jsdelivr.net/gh/RavChopra/Rugstore@{commitsha}/images/...
```

## Image guidelines

- **JPG** for photos, **PNG** for logo/graphics with transparency
- **Compress** everything before committing — use [tinypng.com](https://tinypng.com) or [squoosh.app](https://squoosh.app)
- **Max 150KB** per tile, **200KB** for hero shots — eBay truncates heavy descriptions
- **Consistent aspect ratios** within a set (all tiles 5:4, all cross-sell 1:1)
- **HTTPS only** — jsDelivr and GitHub raw both enforce this
