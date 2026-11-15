# Automotive HMI Design Guidelines

Reference for every screen in `my_mg4_dash`. Derived from Apple CarPlay,
Android Automotive OS and general automotive HMI practice, adapted to this
project: a **landscape 960×360** infotainment surface built with
`liquid_glass_easy` + `flutter_screenutil`.

Glass rules (batching, adaptivity sampling, blur budgets) live in
[`AGENTS.md`](../AGENTS.md). This file covers **what to show, where, and how big**.

---

## 1. Minimalism & low cognitive load

- **Critical information dominates.** Navigation next turn, speed / range,
  safety and vehicle alerts own the largest, brightest, most central zones.
- **One primary task per zone.** Secondary settings (advanced climate, audio
  routing, profiles) step back: smaller, lower contrast, or behind a sheet.
- **Generous negative space.** Prefer fewer, larger blocks over dense grids.
  Target ≤ 6 content surfaces visible at once in this layout (4×2 grid is the
  upper bound).
- **Glanceable content.** One idea per tile, no paragraphs. A module that needs
  reading is the wrong module for the home screen.
- **No decorative noise.** Background motion must never compete with text or
  icons (keep the neon waves low-contrast under copy).

## 2. Touch ergonomics & driver-centricity

| Rule | Value |
|---|---|
| Minimum hit target | **48×48 dp** (`48.w` × `48.h`) |
| Preferred target, primary controls | 56–72 dp |
| Minimum gap between targets | 8 dp (`8.w`) |
| Max depth for essential functions | **2 taps** from the current screen |
| Pressed-state feedback | immediate (< 100 ms), visually obvious |

- **Reach first.** Frequently used controls (volume, track skip, map zoom) sit
  in the half of the screen nearest the driver. Left-hand-drive → left half;
  keep this as a layout parameter, not a hardcoded assumption.
- **No precision-only interactions.** No long-press-only actions, no tiny
  drag handles, no edge-swipe-only shortcuts for anything that matters. Sliders
  need a wide track and a large thumb.
- **Flat or shallow hierarchy.** Tabs → content → one sheet. Avoid
  tab → list → detail → sheet chains.
- **No destructive action within one tap** of a frequently used surface.

## 3. Visual consistency & adaptive UI

- **Day / night adaptation.** Support a light and dark appearance and switch
  with ambient-light input, not only with the clock. Use `LiquidGlassAdaptivity`
  palettes (`glassColorOnDark` / `contentColorOnDark` / `...OnLight`) rather than
  hardcoded colors.
- **Contrast.** Meet WCAG AA minimums, aim AAA where possible: 7:1 for body
  text, 4.5:1 for large text and meaningful icons — measured against the
  brightest/darkest part of the backdrop behind the surface.
- **Typography.** Sans-serif, medium/regular weights over glass (avoid thin
  weights), generous sizes, high legibility under direct sunlight. Body text
  ≥ 14 `.sp`, primary values ≥ 24 `.sp`, never rely on color alone to convey
  state.
- **Feedback is multimodal.** Every touch produces a visible state change; add
  a light haptic and, only where it helps confirmation (tab change, toggle),
  a short non-intrusive sound. Never make sound the sole feedback.
- **Motion is restrained.** ~200–300 ms transitions, no auto-playing
  animations in the driver's line of sight, respect reduced-motion settings.

## 4. Multimodal integration

- **Touch is not the only path.** Critical and rapid functions (hazard lights,
  defrost, volume) must remain reachable through physical or steering-wheel
  controls; show them as persistent, always-visible affordances.
- **Voice.** Natural-language entry point always visible (mic affordance),
  one-shot commands for climate / navigation / calls, no multi-level dialogs.
- **Gestures.** Only simple, discoverable ones (swipe to page, two-finger map
  zoom). Gestures are shortcuts, never the only access path.
- **Consistency.** The same gesture, icon and label mean the same thing on
  every screen and in every vehicle state.

## 5. Context-driven (smart) layout

The home screen changes with the driving state:

| State | Priority |
|---|---|
| Highway / driving | Navigation map, next maneuver, range / charging stations ahead |
| Maneuvering / parking | Rear/front cameras, proximity sensors, one-tap camera modes |
| Parked / charging | Media, streaming, advanced settings, user profiles |

- Transition automatically but predictably; never hide a critical alert because
  of a state change.
- Keep the same widget tree and swap module content — layout landmarks should
  not jump between states.
- Restrict non-essential interaction while moving (disable keyboards, long
  lists, video).

## Project conventions

- Sizes always via ScreenUtil: `48.w`, `56.h`, `14.sp`. `48.w` on the 960-wide
  design width ≈ 48 logical px at design scale — do not shrink below it for
  interactive elements.
- Home screen: `lib/home/home_dashboard.dart` slots are the contract; each
  module is a swappable widget with no layout knowledge.
- Glass is chrome: tiles, dock, tab bar. Do not put a lens inside a scrollable
  or inside another lens (see `AGENTS.md`).
- Cards use `HomeGlassTile` / module header / action pill from
  `lib/home/widgets/`, which already encode the internal spacing scale.
- Text over glass must survive both bright and dark backdrops; verify both
  brightnesses before merging.

## Review checklist (PR gate)

- [ ] Critical info (nav, speed/range, alerts) is the most prominent element.
- [ ] Every interactive target ≥ 48×48 dp with ≥ 8 dp separation.
- [ ] No essential function deeper than two taps.
- [ ] Primary controls sit in the driver-near half of the screen.
- [ ] Light and dark appearance both pass contrast review.
- [ ] Pressed/selected state is obvious; haptic or sound added where useful.
- [ ] Voice and/or physical-control path exists for critical functions.
- [ ] Layout adapts to driving state without hiding safety alerts.
- [ ] No thin fonts, no text under 14 `.sp`, no color-only status.
- [ ] `flutter analyze` clean.
