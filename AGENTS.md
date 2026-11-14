# AGENTS.md — liquid_glass_demo

Flutter demo app for iOS 26-style **Liquid Glass**, built on the
[`liquid_glass_easy`](https://pub.dev/packages/liquid_glass_easy) package.
This file is the project's working reference: read it before touching glass UI.

## Stack

- Flutter / Dart SDK `^3.13.7`
- `liquid_glass_easy: ^5.2.0` — the ONLY glass implementation
- `flutter_screenutil: ^5.9.3` — all sizes in `.w` / `.h` / `.sp`
- Design size: `Size(960, 360)` (landscape infotainment-style layout)

## Non-negotiable rules

1. **Always use `liquid_glass_easy`.** Never hand-roll glass with
   `BackdropFilter`, `ImageFilter.blur`, `ClipRRect` + gradients, or custom
   shaders. Use `LiquidGlassLens`, the drop-in components, or `LiquidGlassLite`.
2. **Compile shaders before `runApp`:**
   `await LiquidGlassShaders.ensureLoaded();` in `main()`. Otherwise the first
   glass frame is frosted and a `LiquidGlassBlender` may paint nothing.
3. **Use `LiquidGlassScaffold`, not Material `Scaffold`,** for page shells. It
   owns the internal `LiquidGlassView` pipeline. Only use `LiquidGlassView`
   directly when you need a custom stack over a specific background.
4. **On Skia, glass needs a background.** Wrap content in
   `LiquidGlassView(backgroundWidget: ...)`; on Impeller the live backdrop is
   sampled and the view is optional. Write the same widget tree for both.
5. **Sizes** go through ScreenUtil: `24.w`, `16.h`, `14.sp`. Do not hardcode
   logical pixels in UI code unless the package API requires them (blur,
   refraction width, light thickness, `cornerRadius` are logical px).
6. **Colors:** use `Color.withValues(alpha: x)` — `withOpacity` is deprecated.
7. **Glass floats above content.** Do not put lenses inside scrollables/list
   items; layer them in a `Stack` over the page.
8. **Batch or blend sets of glass.** Multiple sibling lenses belong in a
   `LiquidGlassBlender` (2–8, fusing) or `LiquidGlassBatch` (any count, shared
   read, members must not overlap). Standalone lenses each cost a backdrop read.
9. **Adaptivity needs a sampler.** A `style.adaptivity` alone does nothing
   unless `LiquidGlassView.adaptiveSampling` or `LiquidGlassScaffold.adaptivity`
   turns sampling on.
10. **Don't hardcode colors on adaptive content** — `adaptivity` installs
    `IconTheme` + `DefaultTextStyle`; hardcoded colors opt out.
11. **Test both brightnesses.** Verify text/icon contrast over light and dark
    backdrops; widen the hysteresis band if the verdict strobes.
12. **Run `flutter analyze` after edits.**

## Core API

### `LiquidGlassLens` — the surface

```dart
LiquidGlassLens({
  LiquidGlassStyle style = const LiquidGlassStyle(),
  bool visibility = true,   // false = no backdrop cost, child removed
  double opacity = 1,       // fades shader output, still refracts; 0 = free
  bool? useImpellerBackdrop,
  Widget? child,            // clipped to the lens shape
})
```

Size comes from layout (`SizedBox`, `Positioned`, constraints). The child is
clipped to the full lens shape — add `Padding` to inset it.

### `LiquidGlassStyle` — flat styling descriptor

```dart
const LiquidGlassStyle({
  LiquidGlassShape? shape,     // null -> continuous rounded rect
  LiquidGlassLight? specular,  // null -> Light.specular()
  LiquidGlassLight? glow,      // null -> no glow on a plain lens
  double refractionIndex = 1.1,   // 1.0 none; 1.02 clear edge; 1.5 strong
  double refractionWidth = 12,    // px band along the edge
  double magnification = 1.0,
  double dispersion = 0,          // colour fringe, 0 = cheapest
  double saturation = 1.0,
  double blur = 0.0,              // Gaussian sigma
  Color color = Colors.transparent,
  LiquidGlassShadow? shadow,
  LiquidGlassAdaptivity? adaptivity,
  bool liteGlass = false,
})
```

`copyWith` changes one facet; `merge` for theme overrides.

### Shapes

| Constructor | Use |
|---|---|
| `LiquidGlassShape.continuousRoundedRectangle(cornerRadius:)` | Default Apple capsule/squircle-ish; use `clipQuality` default |
| `LiquidGlassShape.squircle(cornerRadius:)` | iOS L^n squircle; consider `LiquidGlassClipQuality.exact` |
| `LiquidGlassShape.roundedRectangle(cornerRadius:)` | Cheapest plain circular corners |

### Border — two lights

```dart
LiquidGlassLight.specular(thickness: 5, sharpness: 0.5, angle: 39, spread: 0.9, intensity: 1)
LiquidGlassLight.glow(thickness: 10, angle: 90, spread: 0.5, intensity: 1)
```

`thickness` is logical px. `angle` is degrees (`0` = left/right, `90` =
top/bottom). For a glow that fills the dark side, keep it 90° from the
specular. Optional `color` replaces the picked-up backdrop colour;
`oppositeIntensity` dims/boosts the far arc.

### `LiquidGlassView` — Skia background pipeline

```dart
LiquidGlassView({
  required Widget backgroundWidget,
  Widget? child,
  double pixelRatio = 1.0,       // 0.8–1.0 quality, 0.5–0.7 perf
  bool realTimeCapture = true,   // false + controller.captureOnce() for static
  bool useSync = true,
  bool? useImpellerBackdrop,
  LiquidGlassRefreshRate refreshRate = LiquidGlassRefreshRate.deviceRefreshRate,
  LiquidGlassAdaptiveSampling? adaptiveSampling, // null = no sampling
})
```

### `LiquidGlassScaffold`

Owns a `LiquidGlassView`; `body` is the refractable background; `appBar`,
`bottomNavigationBar`, `floatingActionButton`, `bottomNavigationBarAction`
float above it. Use `LiquidGlassScaffoldAdaptivity` for chrome palettes and
system-bar strips.

### Blender / Batch — container equivalents

```dart
// Fusing container: 2–8 lenses, metaball bridge. smoothness = merge radius.
LiquidGlassBlender(
  smoothness: 58,          // 0 = shared sheet, no bridge (old LiquidGlassGroup)
  style: LiquidGlassStyle(shape: LiquidGlassShape.continuousRoundedRectangle(cornerRadius: 36)),
  child: Stack(children: [ /* LiquidGlassLens widgets */ ]),
)

// Scale container: unlimited members, one shared read, no fusing, no overlap.
LiquidGlassBatch(child: /* subtree of lenses */)
```

`LiquidGlassGroup` is deprecated: it is `LiquidGlassBlender(smoothness: 0)`.
Shadows are not supported inside a blender (no single ring to cast).

### Morph — size-driven glass transitions

```dart
LiquidGlassMorph(
  alignment: Alignment.bottomRight,   // which edge/corner stays put
  motion: LiquidGlassMorphMotion.fluid, // plain (default), fluid, anchoredPop, droplet, calm
  child: open
      ? const Menu(key: ValueKey('menu'))
      : const Icon(Icons.more_horiz, key: ValueKey('dots')),
)
```

Key identity matters: same type without a `Key` is not treated as a new child.
Content-sized morphs need one measuring frame; pin both axes to avoid it.
Requires a `LiquidGlassView` with `backgroundWidget` (or two separate lenses
double-refract). Shared-element flights use `LiquidGlassMorphShared(tag: ...)`.

### Touch — interactive deformation

```dart
LiquidGlassLens(
  touch: const LiquidGlassTouch(flex: LiquidGlassFlex()),
  ...
)
```

Presets: `LiquidGlassFlex.subtle()`, `.uniform()`, `.pronounced()`.
`null` adds no gesture listener/ticker. Use only on interactive surfaces.

### Drop-in components

`LiquidGlassButton`, `LiquidGlassFab`, `LiquidGlassAppBar`,
`LiquidGlassTabBar`, `LiquidGlassSlider`, `LiquidGlassSwitch`,
`LiquidGlassAlertDialog` / `showLiquidGlassDialog`,
`LiquidGlassSheet` / `showLiquidGlassSheet`, `LiquidGlassMorph`,
`LiquidGlassMotionPill`, `LiquidGlassDraggable`, `LiquidGlassShadow`,
`LiquidGlassScrollEdge`, `LiquidGlassSegmentedControl`, `LiquidGlassDock`.

- Slider/switch size themselves: pass `width` / `height`, not `SizedBox`.
- Tuned looks: `LiquidGlassSlider.defaultStyle`, `LiquidGlassSwitch.defaultStyle`,
  `LiquidGlassTabBar.defaultDarkStyle`; tweak via `copyWith`.
- Slider and switch need no ancestor view on Skia; button, FAB, app bar,
  dialog, sheet and morph do.

### Adaptivity

```dart
LiquidGlassStyle(
  adaptivity: LiquidGlassAdaptivity(
    glassColorOnDark: Color(0x33000000),
    contentColorOnDark: Colors.white,
    glassColorOnLight: Color(0x66FFFFFF),
    contentColorOnLight: Color(0xFF1C1C1E),
  ),
)
```

Sampling switch: `LiquidGlassView(adaptiveSampling: const LiquidGlassAdaptiveSampling())`
or `LiquidGlassScaffold(adaptivity: LiquidGlassScaffoldAdaptivity(...))`.
One tiny capture (`pixelRatio: 0.05`, 8 fps) serves every surface.
Other tools: `LiquidGlassAdaptiveArea` (one verdict for a subtree),
`LiquidGlassAdaptivityLink` (follow across pipelines), `LiquidGlassAdaptivityController`
(pause + `adaptOnce()`), `LiquidGlassAdaptiveContent` (bare text/icons),
`permanentBrightness` (no sampling), `LiquidGlassAdaptivity.none` (opt out).
Threshold pair is `(darkBelow, lightAbove)`, not centre/width.

### Lite glass — no shader

```dart
LiquidGlassEngine.liteGlassOnSkia = true;
LiquidGlassEngine.liteGlassOnImpeller = true;
// or per lens:
LiquidGlassStyle(liteGlass: true)
```

Frost + tint + painted rim; no refraction, no capture, no shader slot.
Blender does not blend under lite glass; morph runs as `plain`.

## Render paths (same widget tree)

| Engine / setup | Behavior |
|---|---|
| Impeller | Refracts the live backdrop anywhere; no view needed |
| Skia + ancestor `LiquidGlassView` | Refracts the captured `backgroundWidget` |
| Skia without view | Frosted fallback + one-time debug notice |
| Lite glass (any engine) | Frost/tint/rim, no shader/capture/view |

### Skia requirements by component

| Component | Needs `LiquidGlassView` on Skia? |
|---|---|
| Slider, switch, scaffold, tab bar, shadow, lite glass | No |
| Button, FAB, app bar, alert dialog, sheet, morph, motion pill | Yes |

## iOS 26 skill → package mapping

The retained `liquid-glass-design` skill describes Apple APIs; translate them
to Flutter as follows:

| Skill concept (SwiftUI/UIKit) | liquid_glass_easy equivalent |
|---|---|
| `.glassEffect()` | `LiquidGlassLens(style: LiquidGlassStyle(...))` |
| `GlassEffectContainer` / `UIGlassContainerEffect` | `LiquidGlassBlender` (fusing) or `LiquidGlassBatch` (shared read) |
| Container `spacing` (merge distance) | `LiquidGlassBlender.smoothness` |
| `.tint(Color)` | `LiquidGlassStyle.color` (or `adaptivity` palettes) |
| `.interactive()` | `touch: LiquidGlassTouch(flex: LiquidGlassFlex())` |
| Morphing / `@Namespace` + `glassEffectID` | `LiquidGlassMorph` + `ValueKey`, `LiquidGlassMorphShared` |
| Specular highlight / glow | `LiquidGlassLight.specular` / `LiquidGlassLight.glow` |
| Widget accented mode | `LiquidGlassAdaptivity` palettes |
| `.buttonStyle(.glass)` | `LiquidGlassButton` |
| Toolbars / tab bars | `LiquidGlassAppBar`, `LiquidGlassTabBar` |
| Scroll edge effect | `LiquidGlassScrollEdge` |
| UIKit `clipsToBounds = true` | shape clipping handled by the lens automatically |

Principles carried over: batch sibling glass, reserve glass for floating
chrome/cards/controls, keep text contrast, test light/dark, avoid nested glass.

## Current project structure

- `lib/main.dart` — `ScreenUtilInit` → `LiquidGlassScaffold`, glass tab bar,
  morphing FAB, body switched by tab index.
- `lib/demo_view.dart` — draggable lens playground over `AnimatedBackground`,
  fused by `LiquidGlassBlender(smoothness: 58)`.
- `lib/energy_view.dart` — same pattern plus `LiquidGlassSlider` and
  `LiquidGlassControlCard`.
- `lib/control_card.dart` — capsule `LiquidGlassLens` with a white progress
  fill and icon.
- `lib/animated_background.dart` — `CustomPainter` neon waves driven by a
  repeating `AnimationController`; loop-safe phases (all `progress` terms
  complete a full `2π` cycle). Use as `LiquidGlassView.backgroundWidget`.

### Known cleanup

`AnimatedBackground.build` currently returns a Material `Scaffold`. As a
`LiquidGlassView.backgroundWidget` it should be a plain widget (e.g.
`AnimatedBuilder` → `CustomPaint` with `SizedBox.expand()`); the page-level
scaffold belongs to `LiquidGlassScaffold`.

## Performance checklist

- Prefer one `LiquidGlassBlender`/`LiquidGlassBatch` over many standalone lenses.
- Keep `blur` modest; on Skia values above ~7 stop matching Impeller and cost
  more.
- Avoid nesting glass inside glass; don't apply glass to everything.
- `LiquidGlassConfiguration` tunes blur method/overrides; shape cache is on by
  default on Impeller (disable only for debugging).
- Use lite glass for large pages with many glass surfaces.
- Realtime capture for moving backgrounds; `realTimeCapture: false` +
  `captureOnce()` for static ones.
- Tab bar glass pill mode `both` is expensive on Skia; ship `impellerOnly`.

## Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d macos   # or chrome / ios simulator
```

## References

- Package README / API: https://pub.dev/packages/liquid_glass_easy
- Full docs + live demos: https://ahmeedgamil.github.io/liquid_glass_easy/
- Adaptivity guide: https://github.com/AhmeedGamil/liquid_glass_easy/blob/main/ADAPTIVITY.md
- Performance guide: https://ahmeedgamil.github.io/liquid_glass_easy/en/efficiency.html
- Local package source: `~/.pub-cache/hosted/pub.dev/liquid_glass_easy-5.2.0/`
