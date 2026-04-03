# Workspace.md — Prism

Shared handoff memory for all agents working on this repository.

---

## Project

**Name:** Prism — Swift design theme system library  
**Swift Tools:** 6.2 | **Platforms:** iOS 17+, macOS 14+ | **Distribution:** SPM only

---

## Structure

```
Sources/Prism/
  Prism.swift                    — package entry point / documentation
  Themes/
    PrismThemeProtocol.swift     — root protocol (10 token groups + variant + liquidGlass)
    PrismVariant.swift           — .light / .dark / .tinted
    PrismThemeFamily.swift       — .koreanAesthetic / .neo / .neuromorphic / .custom (+ resolve())
    KoreanAesthetic/             — public structs; soft pastels, rounded
    Neo/                         — public structs; bold primaries, sharp geometry
    Neuromorphic/                — mostly private structs; soft shadows, extruded surfaces
  Tokens/                        — 10 protocol files (Color, Typography, Spacing, CornerRadius,
                                   Elevation, Border, Opacity, IconSize, Animation, Haptic)
  Components/
    Buttons/PrismButtonStyle.swift       — now uses shared triggerHaptic()
    Text/PrismTextModifier.swift
    Loading/
      PrismSpinner.swift                 — ring/dots/pulse styles, reduce-motion aware
      PrismProgressBar.swift             — horizontal bar with PrismProgressBarConfig
      PrismProgressCircle.swift          — circular trim arc progress indicator
      PrismSkeletonView.swift            — shimmer placeholder
      PrismLoadingOverlay.swift          — full-screen blocking overlay + .prismLoadingOverlay()
    Sheets/
      PrismBottomSheet.swift             — detent-based bottom sheet with drag gesture
      PrismCenterSheet.swift             — centered modal dialog with backdrop
    Overlays/
      PrismHUD.swift                     — toast/HUD queue system, .prismHUD() modifier
      PrismAlert.swift                   — full-blocking modal alert with actions/input
      PrismPopover.swift                 — theme-driven popover, .prismPopover() modifier
  Utilities/
    PrismHaptics.swift                   — shared @MainActor triggerHaptic() helper
    PrismBackdropView.swift              — shared dim/blur backdrop, PrismBackdropStyle enum
    PrismSheetAction.swift               — PrismSheetAction, PrismAlertActionRole
    PrismElevationModifier.swift         — .prismElevation() view extension
  ThemeProvider/
    PrismThemeProvider.swift             — @Observable singleton for UIKit bridging
  Environment/
    PrismEnvironmentKey.swift    — EnvironmentValues.prismTheme
    PrismThemeModifier.swift     — View.prismTheme(_:) / View.prismTheme(_:liquidGlass:)
                                   LiquidGlassWrapper (internal struct)
Tests/PrismTests/
  PrismTests.swift               — smoke test (1 test)
  TokenCompletenessTests.swift   — 10 parameterized tests × 9 combos
  ThemeSwitchTests.swift         — 11 tests: resolve types, variant propagation, LiquidGlass
  ColorTokenTests.swift          — 7 tests: variant/theme color distinctness
  ElevationTokenTests.swift      — 8 parameterized tests: e0 flat, ordering, Equatable
  CustomThemeTests.swift         — 7 tests: bespoke MinimalCustomTheme conformance
  UIUtilityTests.swift           — 27 tests: configs, actions, detents, HUD queue, spinner, provider
```

---

## Test Status

**Last run:** 2026-04-03 — `swift test`  
**Result:** ✅ **71/71 tests pass, 0 failures, 0 warnings**

---

## Key Facts

- `NeuromorphicBorder.subtle = 0.0` — intentional; only `default` and `strong` are tested > 0
- `LiquidGlassWrapper` is `internal`; accessible in tests via `@testable import Prism`
- `AnimationTokens` has `@MainActor` properties (`Animation` values); duration scalars are not
- Neuromorphic token structs are `private` — accessed only through protocol existentials
- `Color` is `Equatable` on these platforms; theme RGB colors reliably `!= Color.clear`
- `swift build` runs clean; no warnings in source library
- `PrismHUDModel` is `@MainActor @Observable` singleton; queue depth 3, oldest dropped on overflow
- `PrismThemeProvider.init()` is private — tests use `.shared`
- `triggerHaptic()` promoted from private to shared `@MainActor` internal function
- `PrismBackdropStyle`, `PrismSheetRole`, `PrismAlertActionRole` are public enums in Utilities/
- All overlays use `Task.sleep` (not DispatchQueue) for dismiss animation delays
- All animated components check `accessibilityReduceMotion`

---

## Build & Test Commands

```bash
swift build
swift test
```

---

## Completed Phases

### UI Utilities Implementation (2026-04-03)
- **Phase**: Full SDLC — Requirements → Architecture → Implementation → Review → Testing → Build
- **Components added**: PrismBottomSheet, PrismCenterSheet, PrismPopover, PrismAlert, PrismHUD, PrismSpinner, PrismProgressBar, PrismProgressCircle, PrismSkeletonView, PrismLoadingOverlay, PrismThemeProvider
- **Shared infrastructure**: PrismHaptics, PrismBackdropView, PrismSheetAction, PrismElevationModifier
- **Files created**: 15 new files, 1 modified (PrismButtonStyle.swift)
- **Review**: 2 HIGH issues found and fixed (HUD opacity, DispatchQueue→Task.sleep), 3 LOW observations addressed
- **Tests**: 27 new tests added (71 total), all passing

---

## Key Facts

- `NeuromorphicBorder.subtle = 0.0` — intentional; only `default` and `strong` are tested > 0
- `LiquidGlassWrapper` is `internal`; accessible in tests via `@testable import Prism`
- `AnimationTokens` has `@MainActor` properties (`Animation` values); duration scalars are not
- Neuromorphic token structs are `private` — accessed only through protocol existentials
- `Color` is `Equatable` on these platforms; theme RGB colors reliably `!= Color.clear`
- `swift build` runs clean; no warnings in source library

---

## Architecture Documents

| Document | Scope |
|---|---|
| [`DESIGN_THEME_SYSTEM.md`](DESIGN_THEME_SYSTEM.md) | Token system, theme families, variant model |
| [`UI_Utilities.md`](UI_Utilities.md) | Overlay component specification (source of truth) |
| [`OVERLAY_COMPONENTS_ARCHITECTURE.md`](OVERLAY_COMPONENTS_ARCHITECTURE.md) | Architecture proposal: overlay + loading components (14 new files, 8 phases) |

---

## Build & Test Commands

```bash
swift build
swift test
```
