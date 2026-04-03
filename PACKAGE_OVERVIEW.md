# Prism — Package Overview

A reusable, scalable Swift design-theme library for Apple platforms. Prism provides a complete design-token system, three opinionated built-in themes, a full suite of UI components, and a clean protocol-based API for creating custom themes — all with zero third-party dependencies.

---

## Table of Contents

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Architecture](#architecture)
5. [Themes](#themes)
   - [Built-in Themes](#built-in-themes)
   - [Variants](#variants)
   - [Liquid Glass](#liquid-glass)
   - [Custom Themes](#custom-themes)
6. [Design Tokens](#design-tokens)
   - [ColorTokens](#colortokens)
   - [TypographyTokens](#typographytokens)
   - [SpacingTokens](#spacingtokens)
   - [CornerRadiusTokens](#cornerradiustokens)
   - [ElevationTokens](#elevationtokens)
   - [BorderTokens](#bordertokens)
   - [OpacityTokens](#opacitytokens)
   - [IconSizeTokens](#iconsizetokens)
   - [AnimationTokens](#animationtokens)
   - [HapticTokens](#haptictokens)
7. [Components](#components)
   - [Buttons](#buttons)
   - [Loading Indicators](#loading-indicators)
   - [Overlays & Alerts](#overlays--alerts)
   - [HUD](#hud)
   - [Popovers](#popovers)
   - [Sheets](#sheets)
   - [Text Styles](#text-styles)
8. [Theme Provider](#theme-provider)
9. [Shared Types](#shared-types)
10. [Public API Reference](#public-api-reference)

---

## Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS      | 17.0+          |
| macOS    | 14.0+          |

- **Swift** 5.9+ (Xcode 15+)
- No third-party dependencies

---

## Installation

Add Prism to your project via Swift Package Manager:

```swift
// Package.swift
.package(url: "https://github.com/your-org/Prism", from: "1.0.0")
```

Then add `"Prism"` to your target's dependencies.

---

## Quick Start

### 1. Apply a theme to your root view

```swift
import Prism

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .prismTheme(.koreanAesthetic(.light))
        }
    }
}
```

### 2. Read the active theme anywhere in the view tree

```swift
struct MyView: View {
    @Environment(\.prismTheme) var theme

    var body: some View {
        Text("Hello")
            .foregroundStyle(theme.colors.primary)
            .font(theme.typography.headline)
            .padding(theme.spacing.md)
    }
}
```

### 3. Switch themes programmatically

```swift
PrismThemeProvider.shared.setTheme(.neo(.dark))
```

---

## Architecture

```
PrismThemeFamily          ← entry point: picks a theme + variant
    └─ PrismThemeProtocol ← protocol all themes conform to
           ├─ ColorTokens
           ├─ TypographyTokens
           ├─ SpacingTokens
           ├─ CornerRadiusTokens
           ├─ ElevationTokens
           ├─ BorderTokens
           ├─ OpacityTokens
           ├─ IconSizeTokens
           ├─ AnimationTokens
           └─ HapticTokens

EnvironmentValues.prismTheme  ← SwiftUI environment key
PrismThemeProvider.shared     ← @Observable singleton for programmatic switching
LiquidGlassWrapper            ← internal decorator that forces liquidGlassEnabled = true
```

Themes are value types (`struct`) conforming to `PrismThemeProtocol`. All protocols and their implementations are `Sendable`. `Animation` properties on `AnimationTokens` are `@MainActor`-isolated because `SwiftUI.Animation` is not `Sendable`.

---

## Themes

### Built-in Themes

#### Korean Aesthetic (`KoreanAestheticTheme`)

Inspired by Korean minimalist design — soft, warm palettes with gentle gradients.

| Token group | Characteristics |
|---|---|
| Colors | Warm creams, dusty rose, sage, soft lavender |
| Typography | `.system(.rounded)` — gentle, approachable |
| Corner radii | Generous rounding (6–24 pt + pill) |
| Elevation | Warm diffuse shadows, subtle opacity |
| Animation | Moderate speed (0.20–0.55 s), spring with light bounce |
| Border | Hairline strokes (0.5–2 pt) |

#### Neo (`NeoTheme`)

Bold, graphic, high-contrast — inspired by neobrutalism and Swiss graphic design.

| Token group | Characteristics |
|---|---|
| Colors | Pure electric primaries (#0055FF, #FF2D55, #FFD60A), true black/white surfaces |
| Typography | `.monospaced` for utility sizes, `.semibold`/`.bold`/`.heavy` for display |
| Corner radii | Very sharp (2–8 pt + pill) |
| Elevation | Hard-edged offset shadows (equal x/y), tightly controlled blur |
| Animation | Snappy and fast (0.10–0.35 s), high-frequency spring |
| Border | Thick graphic strokes (1–3 pt) |

#### Neuromorphic (`NeuromorphicTheme`)

Soft, tactile, depth-through-shadow — inspired by neumorphism.

| Token group | Characteristics |
|---|---|
| Colors | Muted mid-tone surfaces, surface == background (neumorphic principle) |
| Typography | `.system(.rounded)` — varying weights from `.regular` to `.semibold` |
| Corner radii | Generous (8–24 pt + pill) |
| Elevation | Large diffuse diagonal shadows (matching light/shadow color pairs) |
| Animation | Smooth and slower (0.20–0.55 s), high-damping spring |
| Border | Nearly invisible — shadow provides depth (0.0–1.0 pt) |

> **Note:** `NeuromorphicTheme.liquidGlassEnabled` is always `false` because neumorphic depth competes visually with glass blur effects.

---

### Variants

Every built-in theme supports three variants via `PrismVariant`:

```swift
public enum PrismVariant: String, CaseIterable, Sendable {
    case light    // standard light appearance
    case dark     // standard dark appearance
    case tinted   // a distinctive tinted accent appearance
}
```

Usage:

```swift
.prismTheme(.koreanAesthetic(.dark))
.prismTheme(.neo(.tinted))
.prismTheme(.neuromorphic(.light))
```

---

### Liquid Glass

Wrap any theme family with Liquid Glass rendering to enable translucent material effects on overlays and sheets:

```swift
// Via view modifier
.prismTheme(.neo(.light), liquidGlass: true)

// Via PrismThemeProvider
PrismThemeProvider.shared.setTheme(.koreanAesthetic(.dark), liquidGlass: true)
```

When `liquidGlass: true` is set, an internal `LiquidGlassWrapper` decorates the theme, forcing `liquidGlassEnabled = true` while delegating all other tokens to the wrapped theme.

---

### Custom Themes

Conform any struct to `PrismThemeProtocol` and provide implementations for all ten token protocols:

```swift
struct MyBrandTheme: PrismThemeProtocol {
    let variant: PrismVariant
    let liquidGlassEnabled: Bool = false

    var colors: any ColorTokens         { MyBrandColors(variant: variant) }
    var typography: any TypographyTokens { MyBrandTypography() }
    var spacing: any SpacingTokens       { MyBrandSpacing() }
    var cornerRadius: any CornerRadiusTokens { MyBrandCornerRadius() }
    var elevation: any ElevationTokens  { MyBrandElevation(variant: variant) }
    var border: any BorderTokens        { MyBrandBorder(variant: variant) }
    var opacity: any OpacityTokens      { MyBrandOpacity() }
    var iconSize: any IconSizeTokens    { MyBrandIconSize() }
    var animation: any AnimationTokens  { MyBrandAnimation() }
    var haptic: any HapticTokens        { MyBrandHaptic() }
}

// Apply via the .custom case
.prismTheme(.custom(MyBrandTheme(variant: .light)))
```

---

## Design Tokens

Tokens are accessed through `@Environment(\.prismTheme) var theme` and then navigated by category.

### ColorTokens

17 semantic color roles — all `Color` values, available on both iOS and macOS.

```swift
theme.colors.primary          // brand primary action color
theme.colors.onPrimary        // text/icon color on primary background
theme.colors.secondary        // secondary brand color
theme.colors.onSecondary      // text/icon on secondary
theme.colors.accent           // highlight / call-out color
theme.colors.background       // page / screen background
theme.colors.onBackground     // text/icon on background
theme.colors.surface          // card / elevated surface
theme.colors.onSurface        // text/icon on surface
theme.colors.surfaceVariant   // secondary surface / input background
theme.colors.error            // destructive / error state
theme.colors.onError          // text/icon on error
theme.colors.success          // positive / success state
theme.colors.warning          // caution / warning state
theme.colors.divider          // separator lines
theme.colors.shadow           // shadow tint color
theme.colors.overlay          // scrim / backdrop color (opacity pre-baked)
```

---

### TypographyTokens

11 semantic text styles — all `Font` values, Dynamic Type compatible.

```swift
theme.typography.caption2     // smallest label / tag
theme.typography.caption1     // small label
theme.typography.footnote     // footnote / legal copy
theme.typography.subheadline  // section sub-header
theme.typography.callout      // secondary callout
theme.typography.body         // main body text
theme.typography.headline     // list / card headline
theme.typography.title3       // modal / section title
theme.typography.title2       // page sub-title
theme.typography.title        // page title
theme.typography.largeTitle   // hero / marketing display
```

Per-theme typeface personalities:

| Theme | Typeface personality |
|---|---|
| Korean Aesthetic | `.rounded` — soft and friendly |
| Neo | `.monospaced` (utility) / `.default` (display), heavy weights |
| Neuromorphic | `.rounded`, light-to-semibold weight ladder |

---

### SpacingTokens

8-step spacing scale (all `CGFloat`), consistent across all themes.

```swift
theme.spacing.xxs   // 2 pt
theme.spacing.xs    // 4 pt
theme.spacing.sm    // 8 pt
theme.spacing.md    // 16 pt
theme.spacing.lg    // 24 pt
theme.spacing.xl    // 32 pt
theme.spacing.xxl   // 48 pt
theme.spacing.xxxl  // 64 pt
```

---

### CornerRadiusTokens

5 radius steps (all `CGFloat`).

```swift
theme.cornerRadius.xsmall  // ~2–8 pt
theme.cornerRadius.small   // ~4–12 pt
theme.cornerRadius.medium  // ~6–16 pt
theme.cornerRadius.large   // ~8–24 pt
theme.cornerRadius.pill    // 9999 pt (fully rounded)
```

Values vary by theme aesthetic — Neo is very sharp; Korean Aesthetic and Neuromorphic are more generous.

---

### ElevationTokens

6 elevation levels (e0 = flat → e5 = highest).

```swift
theme.elevation.e0  // flat, no shadow
theme.elevation.e1  // subtle lift (e.g. cards)
theme.elevation.e2  // standard card / HUD
theme.elevation.e3  // sheets, dialogs
theme.elevation.e4  // drawers, menus
theme.elevation.e5  // maximum elevation
```

Each level is an `ElevationLevel` value:

```swift
public struct ElevationLevel: Sendable, Equatable {
    public var color: Color      // shadow tint
    public var radius: CGFloat   // blur radius
    public var x: CGFloat        // x offset
    public var y: CGFloat        // y offset
    public var opacity: Double   // shadow opacity
}
```

Apply elevation via the internal view extension (used internally by all Prism components):

```swift
myView.prismElevation(theme.elevation.e2)
// equivalent to: .shadow(color: level.color.opacity(level.opacity),
//                        radius: level.radius, x: level.x, y: level.y)
```

---

### BorderTokens

3 border widths + 3 semantic border colors.

```swift
theme.border.subtle         // hairline (0.0–1.0 pt)
theme.border.default        // standard (0.5–2.0 pt)
theme.border.strong         // emphasized (1.0–3.0 pt)

theme.border.subtleColor    // faint divider-like tint
theme.border.defaultColor   // standard stroke
theme.border.strongColor    // maximum contrast stroke
```

---

### OpacityTokens

5 semantic opacity levels (all `Double`).

```swift
theme.opacity.disabled   // 0.38 — disabled state dimming
theme.opacity.overlay    // 0.50–0.60 — backdrop scrim
theme.opacity.hover      // 0.08 — hover highlight
theme.opacity.pressed    // 0.12–0.16 — press highlight
theme.opacity.skeleton   // 0.12–0.15 — skeleton loader base
```

---

### IconSizeTokens

4 standard icon sizes (all `CGFloat`).

```swift
theme.iconSize.small    // 16 pt
theme.iconSize.medium   // 24 pt
theme.iconSize.large    // 32 pt
theme.iconSize.xlarge   // 44 pt
```

---

### AnimationTokens

Duration constants and 9 pre-built `Animation` curves.

```swift
// Duration constants
theme.animation.fast    // 0.10–0.20 s
theme.animation.normal  // 0.20–0.35 s
theme.animation.slow    // 0.35–0.55 s

// @MainActor Animation values
theme.animation.easeIn    // accelerate in
theme.animation.easeOut   // decelerate out
theme.animation.spring    // standard spring
theme.animation.bouncy    // spring with extra bounce
theme.animation.fadeIn    // slow ease-in fade
theme.animation.scaleUp   // fast spring scale
theme.animation.slideIn   // directional easeOut
theme.animation.bounce    // high-bounce spring
theme.animation.shimmer   // repeating shimmer loop
```

`Animation` properties are `@MainActor`-isolated because `SwiftUI.Animation` does not conform to `Sendable`. These are annotated for correctness but strict enforcement requires Swift 6 language mode.

---

### HapticTokens

7 semantic haptic feedback types (iOS only; no-op on macOS).

```swift
theme.haptic.selection     // UISelectionFeedbackGenerator
theme.haptic.lightImpact   // UIImpactFeedbackGenerator(.light)
theme.haptic.mediumImpact  // UIImpactFeedbackGenerator(.medium)
theme.haptic.heavyImpact   // UIImpactFeedbackGenerator(.heavy)
theme.haptic.success       // UINotificationFeedbackGenerator(.success)
theme.haptic.warning       // UINotificationFeedbackGenerator(.warning)
theme.haptic.error         // UINotificationFeedbackGenerator(.error)
```

`HapticFeedbackType` uses `#if canImport(UIKit)` for cross-platform safety.

---

## Components

All components read the active theme automatically from the SwiftUI environment — no manual theme passing required.

### Buttons

#### `PrismButtonStyle`

A `ButtonStyle` conformance with three semantic variants.

```swift
Button("Sign In") { /* action */ }
    .buttonStyle(PrismButtonStyle(variant: .primary))

// Or via the view extension shorthand:
Button("Delete") { /* action */ }
    .prismButtonStyle(.destructive)
```

**Variants:**

| Variant | Foreground | Background | Border |
|---|---|---|---|
| `.primary` | `onPrimary` | `primary` | none |
| `.secondary` | `primary` | `surface` | `primary` stroke |
| `.destructive` | `onError` | `error` | none |

**Behavior:** scale-on-press (`0.97`), disabled opacity, haptic feedback on press, `theme.animation.fast` spring transition.

---

### Loading Indicators

#### `PrismSpinner`

An animated spinner with three styles and three sizes.

```swift
PrismSpinner()                              // ring, medium
PrismSpinner(style: .dots, size: .large)
PrismSpinner(style: .pulse, size: .small)
```

| Style | Description |
|---|---|
| `.ring` | Rotating partial arc (0.75 trim) — accent colored |
| `.dots` | 3 bouncing circles with staggered phase |
| `.pulse` | Breathing filled circle (scale in/out) |

| Size | Dimension |
|---|---|
| `.small` | 20 pt |
| `.medium` | 36 pt |
| `.large` | 56 pt |

Respects `accessibilityReduceMotion`. Accessibility label: `"Loading"`.

---

#### `PrismProgressBar`

A horizontal determinate progress bar.

```swift
PrismProgressBar(progress: $downloadProgress)

PrismProgressBar(
    progress: $uploadProgress,
    configuration: PrismProgressBarConfig(
        fillColor: .green,
        height: 10,
        animated: true
    )
)
```

`PrismProgressBarConfig` properties:

| Property | Default |
|---|---|
| `trackColor` | `theme.colors.surfaceVariant` |
| `fillColor` | `theme.colors.accent` |
| `cornerRadius` | `theme.cornerRadius.pill` |
| `height` | `6 pt` |
| `animated` | `true` |

Accessibility value: `"\(Int(progress * 100)) percent"`.

---

#### `PrismProgressCircle`

A circular determinate progress indicator.

```swift
PrismProgressCircle(progress: $loadProgress)
PrismProgressCircle(progress: $loadProgress, size: 80, lineWidth: 8)
```

Track ring uses `surfaceVariant`; fill arc uses `accent`. Rotated to start at the top (`-90°`). Accessibility value: `"\(Int(progress * 100)) percent"`.

---

#### `PrismSkeletonView`

A shimmering placeholder for loading states.

```swift
PrismSkeletonView()
    .frame(width: 200, height: 20)
    .clipShape(RoundedRectangle(cornerRadius: 4))
```

Uses a `LinearGradient` shimmer sweep animation (`theme.animation.shimmer`). Respects `accessibilityReduceMotion` (displays a static placeholder instead). Accessibility label: `"Loading"`.

---

#### Loading Overlay

Full-screen loading overlay applied as a view modifier.

```swift
ContentView()
    .prismLoadingOverlay(isPresented: $isLoading)

ContentView()
    .prismLoadingOverlay(isPresented: $isLoading, label: "Uploading…")
```

Renders a dimmed backdrop with a large `.ring` `PrismSpinner` and an optional text label.

---

### Overlays & Alerts

#### `PrismAlert`

A fully themed alert overlay supporting text inputs and multiple actions.

```swift
ContentView()
    .prismAlert(isPresented: $showAlert) {
        PrismAlert(
            title: "Delete Account",
            message: "This action cannot be undone.",
            actions: [
                PrismAlertAction(title: "Cancel", role: .cancel),
                PrismAlertAction(title: "Delete", role: .destructive) {
                    deleteAccount()
                }
            ]
        )
    }
```

**Alert with text input:**

```swift
PrismAlert(
    title: "Rename",
    input: PrismAlertInput(placeholder: "New name", text: $inputText),
    actions: [
        PrismAlertAction(title: "Cancel", role: .cancel),
        PrismAlertAction(title: "Save") { save(inputText) }
    ]
)
```

**Layout rules:**

| Action count | Layout |
|---|---|
| 2 | Side-by-side `HStack` |
| 3–4 | Vertical `VStack` |
| 5+ | Scrollable `VStack` |

Appears with animated scale + opacity. Haptic feedback on appear (`lightImpact`).

---

**`PrismAlertAction`**

```swift
PrismAlertAction(
    title: "Confirm",
    role: .default,           // .default | .cancel | .destructive
    isEnabled: canConfirm,
    handler: { performAction() }
)
```

**`PrismAlertInput`** (iOS: includes `keyboardType`)

```swift
PrismAlertInput(
    placeholder: "Enter code",
    text: $verificationCode,
    isSecure: false,
    keyboardType: .numberPad   // iOS only
)
```

---

### HUD

A lightweight, auto-dismissing heads-up display that queues multiple messages.

#### Display a HUD

```swift
// Static convenience API
PrismHUD.show("Saved!", type: .success)
PrismHUD.show("Connection lost", type: .error, duration: 4.0)
PrismHUD.show("Sync in progress…", type: .info)
PrismHUD.dismiss()

// Custom system image
PrismHUD.show("Copied", type: .custom(systemImage: "doc.on.doc"))
```

#### HUD types

| Type | Icon | Icon color |
|---|---|---|
| `.success` | `checkmark.circle.fill` | `success` |
| `.error` | `xmark.circle.fill` | `error` |
| `.warning` | `exclamationmark.triangle.fill` | `warning` |
| `.info` | `info.circle.fill` | `accent` |
| `.custom(systemImage:)` | custom SF Symbol | `onSurface` |

#### HUD position

```swift
PrismHUDConfiguration(position: .top(offset: 16))
PrismHUDConfiguration(position: .center)
PrismHUDConfiguration(position: .bottom(offset: 32))  // default
```

#### Attach HUD to a view tree

```swift
ContentView()
    .prismHUD()                           // uses PrismHUDModel.shared
    .prismHUD(model: customHUDModel)      // custom model instance
```

#### `PrismHUDConfiguration`

| Property | Default |
|---|---|
| `position` | `.bottom(offset: 32)` |
| `maxWidth` | `320 pt` |
| `backgroundColor` | `theme.colors.surface` |
| `textColor` | `theme.colors.onSurface` |
| `cornerRadius` | `theme.cornerRadius.pill` |
| `iconColor` | (derived from type) |
| `elevation` | `e2` |

Queue capacity: 3 messages. Entry-point transitions are position-aware (`.move(.top)` / `.scale` / `.move(.bottom)` + `.opacity`).

---

### Popovers

A contextual popover anchored to a trigger view.

```swift
triggerView
    .prismPopover(isPresented: $showPopover) {
        VStack { /* popover content */ }
            .padding()
    }

triggerView
    .prismPopover(
        isPresented: $showPopover,
        configuration: PrismPopoverConfiguration(
            placement: .top,
            maxWidth: 240,
            showsArrow: true,
            dismissOnTapOutside: true
        )
    ) {
        Text("Tap to learn more")
    }
```

**`PrismPopoverConfiguration`**

| Property | Default |
|---|---|
| `placement` | `.auto` (`.top`, `.bottom`, `.leading`, `.trailing`) |
| `maxWidth` | `280 pt` |
| `showsArrow` | `true` |
| `dismissOnTapOutside` | `true` |
| `isInteractiveDismissEnabled` | `true` |
| `backgroundColor` | `theme.colors.surface` |
| `cornerRadius` | `theme.cornerRadius.small` |
| `elevation` | `e2` |

Uses native `.popover` with `.presentationCompactAdaptation(.popover)`.

---

### Sheets

#### `prismBottomSheet` — Bottom Sheet

A draggable, detent-based bottom sheet with three usage overloads.

**Custom content:**

```swift
ContentView()
    .prismBottomSheet(isPresented: $showSheet) {
        MySheetContent()
    }
```

**Informational preset (icon + title + body + action):**

```swift
ContentView()
    .prismBottomSheet(
        isPresented: $showSheet,
        model: PrismBottomSheetInformationalModel(
            icon: "bell.fill",
            title: "Notifications",
            subtitle: "Stay in the loop",
            body: "Enable notifications to receive updates.",
            action: PrismSheetAction(title: "Enable") { enableNotifications() }
        )
    )
```

**Action list preset:**

```swift
ContentView()
    .prismBottomSheet(
        isPresented: $showSheet,
        title: "Share",
        actions: [
            PrismSheetAction(title: "Copy Link", systemImage: "link"),
            PrismSheetAction(title: "Send", systemImage: "paperplane"),
            PrismSheetAction(title: "Cancel", role: .cancel)
        ]
    )
```

**`PrismBottomSheetDetent`**

```swift
.collapsed              // ~60 pt
.fraction(0.5)          // 50% of container height
.fixed(320)             // explicit point value
.expanded               // fills to safe area top
```

**`PrismBottomSheetConfiguration`**

| Property | Default |
|---|---|
| `detents` | `[.fraction(0.5), .expanded]` |
| `startingDetent` | first detent |
| `isDraggable` | `true` |
| `showsDragHandle` | `true` |
| `dismissOnTapOutside` | `true` |
| `allowsDragToDismiss` | `true` |
| `elevation` | `e3` |
| `themeAdaptation` | `.auto` |

Drag gesture with velocity-based snapping; velocities > 500 pt/s trigger dismiss. Rounded top corners via `UnevenRoundedRectangle`.

---

#### `prismCenterSheet` — Center Sheet / Dialog

A modal card centered on screen.

```swift
ContentView()
    .prismCenterSheet(isPresented: $showDialog) {
        MyDialogContent()
    }

ContentView()
    .prismCenterSheet(
        isPresented: $showDialog,
        config: PrismCenterSheetConfig(
            maxWidth: 400,
            showsCloseButton: true,
            dismissOnTapOutside: false,
            semanticRole: .alert
        )
    ) {
        MyAlertContent()
    }
```

**`PrismCenterSheetConfig`**

| Property | Default |
|---|---|
| `maxWidth` | `480 pt` |
| `padding` | `theme.spacing.lg` |
| `showsCloseButton` | `true` |
| `dismissOnTapOutside` | `true` |
| `backdropStyle` | `.dim` |
| `semanticRole` | `.dialog` (`.dialog` or `.alert`) |
| `haptic` | `theme.haptic.lightImpact` |

Dismiss on `Escape` key (macOS / hardware keyboard). Accessible: `accessibilityAddTraits(.isModal)` + label of `"Dialog"` or `"Alert"` based on `semanticRole`.

---

### Text Styles

Apply semantic typography from the active theme to any view.

```swift
Text("Welcome back")
    .prismStyle(.largeTitle)

Text("Last updated 3 min ago")
    .prismStyle(.caption1)
```

**`PrismTextStyle` scale:**

```
.caption2  →  .largeTitle
.caption1     .title
.footnote     .title2
.subheadline  .title3
.callout      .headline
.body
```

---

## Theme Provider

`PrismThemeProvider` is a `@MainActor @Observable` singleton for programmatic theme switching — use it when you need to change the theme from outside the SwiftUI view hierarchy (e.g. from a settings screen or on app launch based on a stored preference).

```swift
// Read the current theme
let current = PrismThemeProvider.shared.currentTheme

// Switch themes
PrismThemeProvider.shared.setTheme(.neo(.dark))
PrismThemeProvider.shared.setTheme(.koreanAesthetic(.light), liquidGlass: true)

// Use in a SwiftUI view with @Observable
struct RootView: View {
    var body: some View {
        ContentView()
            .environment(\.prismTheme, PrismThemeProvider.shared.currentTheme)
    }
}
```

> `PrismThemeProvider.init()` is private — always use `.shared`.

---

## Shared Types

### `PrismAlertActionRole`

```swift
public enum PrismAlertActionRole: Sendable {
    case `default`    // standard action
    case cancel       // appears with cancel styling
    case destructive  // appears with error/red styling
}
```

### `PrismSheetAction`

Represents a tappable action row used in bottom sheet action lists and alert buttons.

```swift
PrismSheetAction(
    title: "Delete",
    systemImage: "trash",
    role: .destructive,
    handler: { performDelete() }
)
```

### `PrismBackdropStyle`

Controls the backdrop behind overlays and sheets.

```swift
.dim    // translucent overlay using theme.colors.overlay
.blur   // .ultraThinMaterial blur
.none   // transparent
```

### `PrismThemeFamily`

```swift
public enum PrismThemeFamily: Sendable {
    case koreanAesthetic(PrismVariant)
    case neo(PrismVariant)
    case neuromorphic(PrismVariant)
    case custom(any PrismThemeProtocol)
}
```

---

## Public API Reference

### View Modifiers

| Modifier | Description |
|---|---|
| `.prismTheme(_ family:)` | Apply a theme family to the view tree |
| `.prismTheme(_ family:, liquidGlass:)` | Apply a theme with Liquid Glass overlay |
| `.prismButtonStyle(_ variant:)` | Apply `PrismButtonStyle` shorthand |
| `.prismLoadingOverlay(isPresented:label:)` | Full-screen loading overlay |
| `.prismAlert(isPresented:content:)` | Custom alert overlay |
| `.prismHUD(model:)` | Attach HUD message host to the view tree |
| `.prismPopover(isPresented:configuration:content:)` | Contextual popover |
| `.prismBottomSheet(isPresented:configuration:content:)` | Custom bottom sheet |
| `.prismBottomSheet(isPresented:model:configuration:)` | Informational preset sheet |
| `.prismBottomSheet(isPresented:title:actions:configuration:)` | Action list bottom sheet |
| `.prismCenterSheet(isPresented:config:content:)` | Centered modal dialog |
| `.prismStyle(_ style:)` | Apply semantic text style |

### Environment

| Key | Type | Default |
|---|---|---|
| `\.prismTheme` | `any PrismThemeProtocol` | `KoreanAestheticTheme(.light)` |

### Token Protocols

| Protocol | Properties |
|---|---|
| `ColorTokens` | `primary`, `onPrimary`, `secondary`, `onSecondary`, `accent`, `background`, `onBackground`, `surface`, `onSurface`, `surfaceVariant`, `error`, `onError`, `success`, `warning`, `divider`, `shadow`, `overlay` |
| `TypographyTokens` | `caption2`, `caption1`, `footnote`, `subheadline`, `callout`, `body`, `headline`, `title3`, `title2`, `title`, `largeTitle` |
| `SpacingTokens` | `xxs`, `xs`, `sm`, `md`, `lg`, `xl`, `xxl`, `xxxl` |
| `CornerRadiusTokens` | `xsmall`, `small`, `medium`, `large`, `pill` |
| `ElevationTokens` | `e0`–`e5` |
| `BorderTokens` | `subtle`, `default`, `strong`, `subtleColor`, `defaultColor`, `strongColor` |
| `OpacityTokens` | `disabled`, `overlay`, `hover`, `pressed`, `skeleton` |
| `IconSizeTokens` | `small`, `medium`, `large`, `xlarge` |
| `AnimationTokens` | `fast`, `normal`, `slow`, `easeIn`, `easeOut`, `spring`, `bouncy`, `fadeIn`, `scaleUp`, `slideIn`, `bounce`, `shimmer` |
| `HapticTokens` | `selection`, `lightImpact`, `mediumImpact`, `heavyImpact`, `success`, `warning`, `error` |

### Theme Types

| Type | Description |
|---|---|
| `PrismThemeProtocol` | Protocol all themes conform to |
| `PrismThemeFamily` | Enum for selecting a built-in or custom theme |
| `PrismVariant` | `.light` / `.dark` / `.tinted` |
| `KoreanAestheticTheme` | Korean minimalist built-in theme |
| `NeoTheme` | Neobrutalist graphic built-in theme |
| `NeuromorphicTheme` | Soft/tactile neumorphic built-in theme |
| `PrismThemeProvider` | `@Observable` (Swift 5.9+) `@MainActor` singleton |

### Component Types

| Type | Description |
|---|---|
| `PrismButtonStyle` | Button style conformance |
| `PrismButtonVariant` | `.primary` / `.secondary` / `.destructive` |
| `PrismSpinner` | Animated spinner view |
| `PrismSpinnerStyle` | `.ring` / `.dots` / `.pulse` |
| `PrismSpinnerSize` | `.small` / `.medium` / `.large` |
| `PrismProgressBar` | Horizontal progress bar |
| `PrismProgressBarConfig` | Configuration for `PrismProgressBar` |
| `PrismProgressCircle` | Circular progress indicator |
| `PrismSkeletonView` | Shimmer skeleton placeholder |
| `PrismAlert` | Alert overlay content model |
| `PrismAlertAction` | Alert button definition |
| `PrismAlertInput` | Text input embedded in an alert |
| `PrismHUD` | Static HUD API (`show`, `dismiss`) |
| `PrismHUDModel` | `@Observable` HUD state model |
| `PrismHUDType` | `.success` / `.error` / `.warning` / `.info` / `.custom` |
| `PrismHUDPosition` | `.top` / `.center` / `.bottom` |
| `PrismHUDConfiguration` | HUD appearance configuration |
| `PrismPopoverConfiguration` | Popover appearance + behavior |
| `PrismPopoverPlacement` | `.top` / `.bottom` / `.leading` / `.trailing` / `.auto` |
| `PrismBottomSheetConfiguration` | Bottom sheet behavior config |
| `PrismBottomSheetDetent` | `.collapsed` / `.fraction` / `.fixed` / `.expanded` |
| `PrismBottomSheetInformationalModel` | Preset informational sheet model |
| `PrismThemeAdaptation` | `.auto` / `.override(backgroundColor:cornerRadius:)` |
| `PrismCenterSheetConfig` | Center sheet configuration |
| `PrismSheetRole` | `.dialog` / `.alert` |
| `PrismTextStyle` | Semantic text style enum |
| `PrismSheetAction` | Action row / button definition |
| `PrismAlertActionRole` | `.default` / `.cancel` / `.destructive` |
| `PrismBackdropStyle` | `.dim` / `.blur` / `.none` |
| `ElevationLevel` | Shadow parameters struct |
| `HapticFeedbackType` | `.selection` / `.impact` / `.notification` / `.none` |
