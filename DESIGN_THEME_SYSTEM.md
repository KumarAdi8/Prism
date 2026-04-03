# Prism Design Theme System

## Goal

Create a reusable, scalable Swift design theme library (`Prism`) for Apple platforms. Host apps adopt the system with a single modifier and switch entire themes at runtime:

```swift
ContentView()
    .prismTheme(.koreanAesthetic(.dark))
```

**Target platforms:** iOS 17+, iPadOS 17+, macOS 14+ (via Mac Catalyst).  
**Swift version:** Swift 5.9+.  
**Distribution:** Swift Package Manager only. No third-party dependencies.

---

## Theme families

Each family provides three color variants via `PrismVariant`.

| Family | Character |
|---|---|
| `koreanAesthetic` | Soft pastels, rounded forms, airy whitespace |
| `neo` | Bold primaries, sharp geometry, high contrast |
| `neuromorphic` | Soft shadows, extruded surfaces, muted palette |

```swift
public enum PrismThemeFamily {
    case koreanAesthetic(PrismVariant)
    case neo(PrismVariant)
    case neuromorphic(PrismVariant)
    case custom(any PrismThemeProtocol)
}

public enum PrismVariant: String, CaseIterable {
    case light, dark, tinted
}
```

### Liquid Glass opt-in

Host apps targeting iOS 26+ may opt in to a Liquid Glass surface treatment layered on top of any theme:

```swift
ContentView()
    .prismTheme(.koreanAesthetic(.dark), liquidGlass: true)
```

`liquidGlass: Bool` (default `false`). When `true`, surface and overlay tokens adopt `.glassEffect()` materials where the active theme declares `liquidGlassEnabled == true`. The library provides a silent token-based fallback on iOS < 26 with no code changes required in the host app.

---

## Core principles

1. **Protocol-oriented** — every token group is a protocol; themes conform, host apps can substitute freely.
2. **No magic strings** — all names are typed enum cases or declared property names; no `String`-keyed lookups.
3. **No third-party dependencies** — pure SwiftUI / Swift Standard Library.
4. **iOS 17+ baseline** — uses `@Observable`, SwiftUI environment, `DynamicTypeSize`.
5. **Extensible** — new themes are added by conforming to `PrismThemeProtocol`; no changes to the core library required.
6. **Testable** — every token protocol ships with a `TokenCompletenessValidator` that asserts non-nil, non-zero, non-`.clear` values for every property.
7. **Fully documented** — every public type, property, and modifier has a Swift DocC `///` triple-slash comment.

---

## `PrismThemeProtocol`

The root protocol every theme must satisfy:

```swift
public protocol PrismThemeProtocol {
    var variant: PrismVariant { get }
    var liquidGlassEnabled: Bool { get }
    var colors: any ColorTokens { get }
    var typography: any TypographyTokens { get }
    var spacing: any SpacingTokens { get }
    var cornerRadius: any CornerRadiusTokens { get }
    var elevation: any ElevationTokens { get }
    var border: any BorderTokens { get }
    var opacity: any OpacityTokens { get }
    var iconSize: any IconSizeTokens { get }
    var animation: any AnimationTokens { get }
    var haptic: any HapticTokens { get }
}
```

---

## Token protocols

### `ColorTokens`

All values are `SwiftUI.Color`. Semantic names decouple the palette from its usage; the active `PrismVariant` determines the underlying palette.

```swift
public protocol ColorTokens {
    // Brand
    var primary: Color { get }          // main interactive color
    var onPrimary: Color { get }        // text/icon placed on primary
    var secondary: Color { get }
    var onSecondary: Color { get }
    var accent: Color { get }           // highlights, progress, links
    // Surfaces
    var background: Color { get }       // page / root background
    var onBackground: Color { get }
    var surface: Color { get }          // cards, sheets, dialogs
    var onSurface: Color { get }
    var surfaceVariant: Color { get }   // input tracks, chips, alt surface
    // Feedback
    var error: Color { get }
    var onError: Color { get }
    var success: Color { get }
    var warning: Color { get }
    // Structural
    var divider: Color { get }
    var shadow: Color { get }
    var overlay: Color { get }          // scrim behind modals
}
```

### `TypographyTokens`

All values are `SwiftUI.Font`. Fonts must scale with Dynamic Type; themes should use standard text styles with optional custom face/weight overrides.

```swift
public protocol TypographyTokens {
    var caption2: Font { get }
    var caption1: Font { get }
    var footnote: Font { get }
    var subheadline: Font { get }
    var callout: Font { get }
    var body: Font { get }
    var headline: Font { get }
    var title3: Font { get }
    var title2: Font { get }
    var title: Font { get }
    var largeTitle: Font { get }
}
```

### `SpacingTokens`

Base 4pt grid. All values are `CGFloat`.

| Token | Value (pt) | Typical use |
|---|---|---|
| `xxs` | 2 | Icon gaps, tight separators |
| `xs` | 4 | Inline element gaps |
| `sm` | 8 | Component internal padding |
| `md` | 16 | Standard section padding |
| `lg` | 24 | Card padding, section spacing |
| `xl` | 32 | Screen-edge margins |
| `xxl` | 48 | Section breaks |
| `xxxl` | 64 | Hero spacing |

### `CornerRadiusTokens`

All values `CGFloat`.

| Token | Value (pt) | Typical use |
|---|---|---|
| `xsmall` | 4 | Badges, tags, input fields |
| `small` | 8 | Cells, chips, popovers |
| `medium` | 12 | Cards |
| `large` | 20 | Sheets, dialogs |
| `pill` | 9999 | Buttons, FABs, HUD |

### `ElevationTokens`

Six levels — `e0` (flat) through `e5` (highest) — each expressed as an `ElevationLevel` value type.

```swift
public struct ElevationLevel {
    public var color: Color
    public var radius: CGFloat
    public var x: CGFloat
    public var y: CGFloat
    public var opacity: Double
}

public protocol ElevationTokens {
    var e0: ElevationLevel { get }  // flat / no shadow
    var e1: ElevationLevel { get }  // cards, list rows
    var e2: ElevationLevel { get }  // popovers, tooltips
    var e3: ElevationLevel { get }  // bottom sheets
    var e4: ElevationLevel { get }  // dialogs, modals
    var e5: ElevationLevel { get }  // full-screen overlays
}
```

### `BorderTokens`

All stroke widths are `CGFloat`; each level also carries a matching color.

```swift
public protocol BorderTokens {
    var subtle: CGFloat { get }        // e.g. 0.5
    var `default`: CGFloat { get }     // e.g. 1.0
    var strong: CGFloat { get }        // e.g. 2.0
    var subtleColor: Color { get }
    var defaultColor: Color { get }
    var strongColor: Color { get }
}
```

### `OpacityTokens`

All values `Double` in `0...1`.

```swift
public protocol OpacityTokens {
    var disabled: Double { get }   // e.g. 0.38
    var overlay: Double { get }    // e.g. 0.54
    var hover: Double { get }      // e.g. 0.08
    var pressed: Double { get }    // e.g. 0.12
    var skeleton: Double { get }   // e.g. 0.14 — shimmer base alpha
}
```

### `IconSizeTokens`

All values `CGFloat`.

| Token | Value (pt) |
|---|---|
| `small` | 16 |
| `medium` | 24 |
| `large` | 32 |
| `xlarge` | 44 |

### `AnimationTokens`

```swift
public protocol AnimationTokens {
    // Durations (seconds)
    var fast: Double { get }     // e.g. 0.15
    var normal: Double { get }   // e.g. 0.30
    var slow: Double { get }     // e.g. 0.50
    // Named SwiftUI Animation curves
    var easeIn: Animation { get }
    var easeOut: Animation { get }
    var spring: Animation { get }
    var bouncy: Animation { get }
    // Preset animations (ready-to-use in withAnimation / .animation())
    var fadeIn: Animation { get }
    var scaleUp: Animation { get }
    var slideIn: Animation { get }
    var bounce: Animation { get }
    var shimmer: Animation { get }  // repeating linear, for skeleton loaders
}
```

### `HapticTokens`

Maps semantic UI events to `UIFeedbackGenerator` types. Implementations evaluate lazily and silently no-op on devices where haptics are unsupported.

```swift
public protocol HapticTokens {
    var selection: HapticFeedbackType { get }
    var lightImpact: HapticFeedbackType { get }
    var mediumImpact: HapticFeedbackType { get }
    var heavyImpact: HapticFeedbackType { get }
    var success: HapticFeedbackType { get }
    var warning: HapticFeedbackType { get }
    var error: HapticFeedbackType { get }
}

public enum HapticFeedbackType {
    case selection
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case none
}
```

---

## Public API surface

### Environment modifier

```swift
// Apply theme to a view hierarchy
ContentView()
    .prismTheme(.koreanAesthetic(.dark))
    .prismTheme(.neo(.light), liquidGlass: true)

// Read the active theme anywhere in the tree
@Environment(\.prismTheme) var theme: any PrismThemeProtocol
```

### Token access

```swift
theme.colors.primary
theme.typography.headline
theme.spacing.md
theme.cornerRadius.large
theme.elevation.e3
theme.animation.spring
```

### View modifiers

```swift
// Typography
Text("Hello").prismStyle(.headline)
Text("Caption").prismStyle(.caption1)

// Buttons
Button("OK") { }.prismButtonStyle(.primary)
Button("Cancel") { }.prismButtonStyle(.secondary)
Button("Delete") { }.prismButtonStyle(.destructive)
```

### Custom theme extension

```swift
struct MyCustomTheme: PrismThemeProtocol {
    let variant: PrismVariant = .light
    let liquidGlassEnabled = false
    let colors: any ColorTokens = MyColors()
    let typography: any TypographyTokens = MyTypography()
    // ... remaining token groups
}

ContentView()
    .prismTheme(.custom(MyCustomTheme()))
```

---

## Source structure

```
Sources/Prism/
  Tokens/
    ColorTokens.swift
    TypographyTokens.swift
    SpacingTokens.swift
    CornerRadiusTokens.swift
    ElevationTokens.swift
    BorderTokens.swift
    OpacityTokens.swift
    IconSizeTokens.swift
    AnimationTokens.swift
    HapticTokens.swift
  Themes/
    PrismThemeProtocol.swift
    PrismThemeFamily.swift
    KoreanAesthetic/
      KoreanAestheticTheme.swift
      KoreanAestheticColors.swift
      KoreanAestheticTypography.swift
    Neo/
    Neuromorphic/
  Components/
    Buttons/
    Text/
  Animation/
    PrismAnimationModifiers.swift
  Environment/
    PrismEnvironmentKey.swift
    PrismThemeModifier.swift
  Prism.swift            ← public re-exports

Tests/PrismTests/
  TokenCompletenessTests.swift
  ThemeSwitchTests.swift
  TypographyTokenTests.swift
  ColorTokenTests.swift
  ElevationTokenTests.swift
```

---

## Testing requirements

- **Token completeness:** `TokenCompletenessValidator` asserts every protocol property is non-nil, colors are not `.clear`, numeric values are positive, and `Font` values are reachable. Run all assertions for every `PrismThemeFamily` × `PrismVariant` combination.
- **Snapshot tests:** Light, dark, and tinted renders of a reference "theme card" view for each family, compared against checked-in baselines.
- **Theme switching:** Verify environment propagation and that switching themes does not leak memory (checked with `addTeardownBlock` weak reference assertion).
- **Custom theme conformance:** Compile-time confirmation that a `MyCustomTheme()` struct satisfies `PrismThemeProtocol` without library changes.
- **Coverage target:** ≥ 80% line coverage on `Sources/Prism/`.
