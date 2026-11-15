# Liquid Glass Easy — Efficiency Guidelines

Source: https://ahmeedgamil.github.io/liquid_glass_easy/en/efficiency.html (v5.2.0)

> Pick the right piece, and the cost mostly takes care of itself.
> Most glass performance problems are not tuning problems — they are a widget doing a job a cheaper widget was built for.

## The short answer

- **Most efficient:** glass inside a **`LiquidGlassBatch` with no blur** (`blur: 0`). The batch shares one read of the backdrop among all its lenses; with no blur there is no extra pass, so a page can float a lot of glass at almost no cost.
- **On Skia** the view already shares one capture, so efficiency mostly comes down to blur.
- **Blur affects performance the most.** Every blurred glass adds work over the backdrop (any engine, including lite glass). Cost grows with number of blurred glasses and sigma. **Lower/turn off blur first**; use the style `color` tint to carry frost instead.

## Start from what you are building

| Goal | Use | Why |
| --- | --- | --- |
| Cheap glass / ready to ship | **Lite glass** (`LiquidGlassStyle(liteGlass: true)` or engine flags) | No shader, no capture, no lens budget. Frost+tint+rim from canvas geometry. On Skia/web can enable app-wide (`LiquidGlassEngine.liteGlassOnSkia = true`). |
| One panel over a page | `LiquidGlassLens` | One read, one shader (two passes on Impeller once blurred). |
| Bar/page/tabs scaffold | `LiquidGlassScaffold` | On Skia captures body once for all lenses under it; on Impeller batches chrome into one read. |
| Many glasses | **`LiquidGlassBatch`** | Many lenses at cost of one read (Impeller/lite). On Skia view already captures once (batch inert but not wrong). Members must not overlap. |
| Cluster as one panel | `LiquidGlassBlender(smoothness: 0)` | One surface/material/read, up to 8 members. (`LiquidGlassGroup` deprecated) |
| Shapes that melt together | `LiquidGlassBlender` | Metaball bridge. |
| Control resizing with content | `LiquidGlassMorph` | Heavier than lens; `LiquidGlassMorphMotion.plain` is cheaper when waist not needed. |
| Slider/switch | `LiquidGlassSlider` / `LiquidGlassSwitch` | Self-contained; do not capture page (Impeller: no capture, Skia: small track snapshot/live only while held). |

## Glass on Impeller (cost order)

Glass is **floating chrome** (bars/controls/buttons over content), not inside scrolling content.

1. **Batch, `blur: 0`** — most efficient (one shared read, no blur).
2. **Batch, shader blur** (`LiquidGlassConfiguration.batchBlurMethod = shader`) — each glass blurs inside shader, batch keeps single read; cost grows with count and sigma.
3. **Batch, engine blur (default)** — separate pass; with many glasses less effective.

## How much blur

- Blur softens backdrop, not hide it. High sigma hurts refraction readability.
- Prefer **`2–3`**, range **`2–5`**, with style `color` tint carrying frost.
- Many glasses: **`2`**.

## Skia: does the background actually move?

- Static background → `realTimeCapture: false` + controller `captureOnce()` (and recapture only when changed).
- Moving/scrolling/animating background → keep live capture.
- Rare changes → capture once and recapture on change.

## Checklist before shipping

- Avoid unnecessary captures (one `LiquidGlassView` per screen; slider/switch bring own small view; lite glass captures nothing).
- Lower **`pixelRatio`** (e.g. `0.7`, often invisible and cheaper).
- Keep **blur** minimal/necessary (on Skia blur expensive on capture path; >~7 looks wrong and costs more).
- Keep **`dispersion: 0`** unless fringe needed.
- Use **`LiquidGlassPillMode.impellerOnly`** for morph pill unless app is lite on Skia.
- **No overlapping lenses inside a batch** (upper cannot see lower’s glass). Exclude with `LiquidGlassBatch.exclude` or use separate batch.
- **Do not put whole app inside one batch** (batch per page at most).

## Mistakes that look like bugs

- Flat frosted blur/no bend on Skia/web without ancestor `LiquidGlassView` (or lite/first-frame shader compile).
- Stale refraction with `realTimeCapture: false` and no `captureOnce()`.
- Two lenses in batch look merged/one due to overlap.
- Lens black during Android stretch overscroll (Impeller) when refracting empty scroll texture.
- Morph not animating due to missing keys.

## Free by construction

- `touch: null` (default): no listener/ticker.
- `visibility: false`: removes backdrop cost and child.
- Adaptivity sampling is light and only while adaptive content on screen/frames drawn.
- Slider/switch do not capture page.
- Shape cache on Impeller (Android/iOS); can disable with `LiquidGlassConfiguration.shapeCache = false`.
- Lite glass: no shader compile, no capture, no lens slot.

## Applied in this app (low-power physical device)

- `AnimatedBackground`: slower cycle, larger wave step, `RepaintBoundary`.
- `LiquidGlassView` (Home/Energy/Demo/Settings): `pixelRatio: 0.6`, `refreshRate: LiquidGlassRefreshRate.low`, realtime capture kept for animated backgrounds.
- Prefer batching non-overlapping chrome lenses per page and keep blur low (tint for frost) where feasible.
