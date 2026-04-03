# Prism UI Utilities

## Purpose

Define and specify the reusable UI overlay components that ship with Prism: bottom sheet, center sheet (dialog), popover, alert, HUD/toast, and loading indicators. All components consume Prism design tokens exclusively, adapt automatically to the active theme variant, and meet WCAG 2.1 AA accessibility requirements.

**Minimum deployment:** iOS 17+, iPadOS 17+, macOS 14+ (Mac Catalyst).  
**Liquid Glass:** Components include an iOS 26+ Liquid Glass path, activated when `.prismTheme(..., liquidGlass: true)` is set on the host.

---

## 1. Shared foundations

### 1.1 Token consumption

All components read tokens from `@Environment(\.prismTheme)` and must not hardcode colors, fonts, sizes, or durations. Required token groups:

| Component | Color | Typography | Spacing | CornerRadius | Elevation | Opacity | Animation | Haptic |
|---|---|---|---|---|---|---|---|---|
| Bottom Sheet | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Center Sheet | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Popover | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Alert | ✓ | ✓ | ✓ | ✓ | ✓ | — | ✓ | ✓ |
| HUD | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Loading | ✓ | — | — | — | — | ✓ | ✓ | — |

Fallback: if the host theme does not declare a specific token, each component falls back to a safe built-in default (defined in `PrismDefaultTokens`).

### 1.2 API conventions

- **SwiftUI-first:** view modifiers and `View`-conforming types.
- `isPresented: Binding<Bool>` for all overlay components.
- All configuration structs provide a `static var default` factory property.
- Component configuration is value-typed (`struct`), making it easy to create and cache variants.
- UIKit bridging: thin `UIHostingController`-based wrappers are provided as an **optional** submodule (`Prism/UIKitBridge`); not compiled into the core target.

### 1.3 Accessibility

- Every overlay sets `accessibilityLabel`, `accessibilityHint`, and `accessibilityAddTraits` appropriate for its semantic role.
- Use `.accessibilityElement(children: .combine)` on complex composite cells.
- Center Sheet and Alert apply `.accessibilityViewIsModal(true)` to trap VoiceOver focus within the overlay.
- All typography renders via Dynamic Type; no hardcoded point sizes.
- All non-essential animations check `@Environment(\.accessibilityReduceMotion)` and skip if `true`.
- Text-to-background contrast meets WCAG 2.1 AA (≥ 4.5:1 for normal text, ≥ 3:1 for large text ≥ 18pt).

### 1.4 RTL (right-to-left) support

- All components use `leading`/`trailing` layout edges, never `left`/`right`.
- Drag handles, close buttons, and icon placements flip automatically for RTL locales.
- Test coverage includes a `.environment(\.layoutDirection, .rightToLeft)` snapshot for each component.

### 1.5 Liquid Glass / iOS 26+

When `theme.liquidGlassEnabled == true` and the runtime is iOS 26+:
- Surface backgrounds adopt `.glassEffect()` materials in place of solid `surface` color tokens.
- Dim overlay layers use `UltraThinMaterial` with a theme-tinted color.
- On iOS < 26 the same components render using standard token fills — no `#available` guards required in host code.

---

## 2. Bottom Sheet (`PrismBottomSheet`)

### 2.1 Behavior

- Anchored to the bottom edge; padding respects safe area insets.
- **Presentation modes:** `modal` (with a dismissable overlay behind the sheet) and `persistent` (sheet always visible, no overlay).
- **Detents** define snap heights:

```swift
public enum PrismBottomSheetDetent: Hashable {
    case collapsed              // drag handle only (~60 pt)
    case fraction(CGFloat)      // 0.0–1.0 of screen height
    case fixed(CGFloat)         // explicit pt value
    case expanded               // fills to safe area top
}
```

- Drag gesture with velocity-based snapping: a release above 500 pt/s snaps to the next detent; release below threshold snaps to the nearest.
- Bounce animation at limits uses `AnimationTokens.bouncy`.
- Dismiss on background tap (configurable via `PrismBottomSheetConfiguration.dismissOnTapOutside`).
- **Keyboard avoidance:** when `.form` or custom content contains a focused `TextField`/`TextEditor`, the sheet adjusts its bottom offset by the keyboard height automatically.

### 2.2 Built-in types

| Type | Content layout |
|---|---|
| `.informational` | Optional icon + title + subtitle + body + single primary action button |
| `.action` | Optional title + vertical list of labeled action buttons + optional cancel |
| `.form` | Title + scrollable field list + sticky submit/cancel footer |
| `.media` | Horizontal scroll of media cards; compact handle-only collapsed, full expanded |
| `.custom` | Host-provided `Content` view; no opinionated layout |

### 2.3 API

```swift
// Generic / fully custom content
PrismBottomSheet(
    isPresented: $isShowing,
    configuration: .default
) {
    MyContent()
}

// Typed convenience — informational
PrismBottomSheet(
    type: .informational,
    isPresented: $isShowing,
    model: PrismBottomSheetInformationalModel(
        title: "Title",
        subtitle: "Optional subtitle",
        body: "Body text",
        action: PrismSheetAction(title: "Got it", handler: { })
    )
)

// Typed convenience — action list
PrismBottomSheet(
    type: .action,
    isPresented: $isShowing,
    actions: [
        PrismSheetAction(title: "Share", systemImage: "square.and.arrow.up", handler: { }),
        PrismSheetAction(title: "Delete", role: .destructive, handler: { })
    ]
)
```

**`PrismBottomSheetConfiguration`**

```swift
public struct PrismBottomSheetConfiguration {
    /// Snap positions; default [.fraction(0.5), .expanded]
    public var detents: [PrismBottomSheetDetent]
    /// Which detent opens at first presentation; default detents.first
    public var startingDetent: PrismBottomSheetDetent
    public var isDraggable: Bool             // default: true
    public var showsDragHandle: Bool         // default: true
    public var dismissOnTapOutside: Bool     // default: true
    public var allowsDragToDismiss: Bool     // default: true
    /// nil = theme.colors.overlay at theme.opacity.overlay
    public var overlayColor: Color?
    /// nil = theme.colors.surface
    public var backgroundColor: Color?
    /// nil = theme.cornerRadius.large (top corners only)
    public var cornerRadius: CGFloat?
    /// nil = theme.elevation.e3
    public var elevation: ElevationLevel?
    /// nil = theme.animation.spring
    public var animation: Animation?
    public var themeAdaptation: PrismThemeAdaptation  // default: .auto
    public static var `default`: Self { get }
}

public enum PrismThemeAdaptation {
    case auto           // derives all visuals from active theme
    case override(backgroundColor: Color, cornerRadius: CGFloat)
    case custom(PrismBottomSheetConfiguration)
}
```

### 2.4 Styling defaults

| Property | Token |
|---|---|
| Background | `theme.colors.surface` |
| Top corner radius | `theme.cornerRadius.large` |
| Elevation / shadow | `theme.elevation.e3` |
| Content inset | `theme.spacing.md` |
| Drag handle size | 4×36 pt, `theme.colors.divider`, `theme.cornerRadius.pill` |
| Overlay dim | `theme.colors.overlay` at `theme.opacity.overlay` |

---

## 3. Center Sheet / Dialog (`PrismCenterSheet`)

### 3.1 Behavior

- Centered modal overlay with dimmed or blurred backdrop.
- **Max width:** 480 pt (compact) / 560 pt (regular / iPad). Height: intrinsic, capped at 80% of screen height with internal scroll.
- Dismiss on background tap (configurable). Optional close button in the header.
- On iPad and Mac Catalyst, also dismisses on the Escape key.
- Presents with `theme.animation.easeOut`; dismisses with a mirrored ease-in.

### 3.2 API

```swift
PrismCenterSheet(
    isPresented: $isShowing,
    config: .default
) {
    MyDialogContent()
}
```

```swift
public struct PrismCenterSheetConfig {
    /// Max content width; default 480
    public var maxWidth: CGFloat
    /// nil = theme.spacing.lg
    public var padding: CGFloat?
    public var showsCloseButton: Bool        // default: true
    public var dismissOnTapOutside: Bool     // default: true
    /// nil = theme.opacity.overlay
    public var overlayOpacity: Double?
    public var backdropStyle: PrismBackdropStyle  // default: .dim
    /// nil = theme.animation.easeOut
    public var animation: Animation?
    /// nil = theme.haptic.lightImpact
    public var haptic: HapticFeedbackType?
    /// Drives accessibilityElement role; default .dialog
    public var semanticRole: PrismSheetRole
    public static var `default`: Self { get }
}

public enum PrismBackdropStyle {
    case dim    // solid overlay color at overlayOpacity
    case blur   // system UltraThinMaterial
    case none
}

public enum PrismSheetRole {
    case dialog
    case alert  // also sets .accessibilityViewIsModal
}
```

### 3.3 Accessibility

- Applies `.accessibilityViewIsModal(true)` to trap VoiceOver focus within the sheet.
- Root container carries `.dialog` or `.alert` accessibility role based on `semanticRole`.
- Close button (when shown) has `accessibilityLabel("Close dialog")`.

---

## 4. Popover (`PrismPopover`)

### 4.1 Behavior

- Arrow callout anchored to the source view using a SwiftUI view modifier.
- **Placements:** `.top`, `.bottom`, `.leading`, `.trailing`, `.auto`.
- `.auto` attempts `.bottom` first, then flips based on available screen space.
- Dismisses on outside tap. Supports `isInteractiveDismissEnabled: Bool`.
- Max width: 280 pt. Max height: 480 pt with internal scroll.
- No user-draggable resizing.

### 4.2 API

```swift
// View modifier (preferred)
Button("Info") { }
    .prismPopover(isPresented: $showTip, placement: .bottom) {
        Text("This is a tooltip.")
            .padding(theme.spacing.sm)
    }

// Standalone initializer
PrismPopover(
    isPresented: $isShowing,
    configuration: .default
) {
    MyPopoverContent()
}
```

```swift
public enum PrismPopoverPlacement {
    case top, bottom, leading, trailing, auto
}

public struct PrismPopoverConfiguration {
    public var placement: PrismPopoverPlacement  // default: .auto
    public var maxWidth: CGFloat                 // default: 280
    public var showsArrow: Bool                  // default: true
    public var dismissOnTapOutside: Bool         // default: true
    public var isInteractiveDismissEnabled: Bool // default: true
    /// nil = theme.colors.surface
    public var backgroundColor: Color?
    /// nil = theme.cornerRadius.small
    public var cornerRadius: CGFloat?
    /// nil = theme.elevation.e2
    public var elevation: ElevationLevel?
    public static var `default`: Self { get }
}
```

### 4.3 Styling defaults

| Property | Token |
|---|---|
| Background | `theme.colors.surface` |
| Border | `theme.border.subtle` width, `theme.border.subtleColor` |
| Corner radius | `theme.cornerRadius.small` |
| Shadow | `theme.elevation.e2` |

---

## 5. Alert (`PrismAlert`)

### 5.1 Behavior

- Full-blocking modal alert (all interaction behind it is disabled).
- Supports: title (required), message (optional), and a list of `PrismAlertAction` items.
- **Action roles:** `.default`, `.cancel` (bold, visually prominent), `.destructive` (error color).
- A maximum of 4 actions are displayed; a 5th or more actions trigger a scrollable list layout.
- Optional text-input variant: adds a single `TextField` or `SecureField` above the action buttons.

### 5.2 API

```swift
// View modifier (preferred)
.prismAlert(isPresented: $showAlert) {
    PrismAlert(
        title: "Delete item?",
        message: "This cannot be undone.",
        actions: [
            PrismAlertAction(title: "Delete", role: .destructive) { delete() },
            PrismAlertAction(title: "Cancel", role: .cancel) { }
        ]
    )
}

// With text input
.prismAlert(isPresented: $showRename) {
    PrismAlert(
        title: "Rename",
        input: PrismAlertInput(placeholder: "New name", text: $name),
        actions: [
            PrismAlertAction(title: "Rename", role: .default) { rename() },
            PrismAlertAction(title: "Cancel", role: .cancel) { }
        ]
    )
}
```

```swift
public struct PrismAlertAction {
    public var title: String
    public var role: PrismAlertActionRole     // .default | .cancel | .destructive
    public var isEnabled: Bool                // default: true
    public var handler: () -> Void
}

public enum PrismAlertActionRole {
    case `default`, cancel, destructive
}

public struct PrismAlertInput {
    public var placeholder: String
    public var text: Binding<String>
    public var isSecure: Bool                 // default: false
    public var keyboardType: UIKeyboardType  // default: .default
}
```

### 5.3 Styling defaults

| Element | Token |
|---|---|
| Background | `theme.colors.surface` |
| Title | `theme.typography.headline`, `theme.colors.onSurface` |
| Message | `theme.typography.body`, `theme.colors.onSurface` |
| Default action | `theme.colors.primary` |
| Destructive action | `theme.colors.error` |
| Cancel action | `theme.colors.secondary` |
| Spacing | `theme.spacing.md` between sections |

---

## 6. HUD / Toast (`PrismHUD`)

### 6.1 Behavior

- Non-blocking transient overlay; does not prevent interaction with content behind it.
- **Types:** `.success`, `.error`, `.warning`, `.info`, `.custom(systemImage: String)`.
- **Positions:** configurable via `PrismHUDPosition`.
- Auto-dismisses after `duration` seconds (default 2.5 s). Pass `.infinity` for manual-dismiss-only.
- **Stacking policy:** only one HUD is visible at a time. A new `show()` call queues behind the current HUD. Maximum queue depth: 3 — the oldest pending entry is dropped on overflow.
- **Thread safety:** `PrismHUD.show()` and `PrismHUD.dismiss()` must be called on `@MainActor`.

### 6.2 API

```swift
// Must attach .prismHUD() once near the root of the view tree to host the overlay
ContentView()
    .prismTheme(.neo(.dark))
    .prismHUD()

// Show / dismiss from anywhere on MainActor
await PrismHUD.show("Saved!", type: .success)
await PrismHUD.show("Network error", type: .error, duration: 4)
await PrismHUD.show("Progress", type: .info, duration: .infinity)  // manual dismiss
await PrismHUD.dismiss()
```

```swift
public enum PrismHUDType {
    case success
    case error
    case warning
    case info
    case custom(systemImage: String)
}

public enum PrismHUDPosition {
    case top(offset: CGFloat = 0)
    case center
    case bottom(offset: CGFloat = 0)
}

public struct PrismHUDConfiguration {
    public var position: PrismHUDPosition    // default: .top(offset: 12)
    /// nil = theme.colors.surface
    public var backgroundColor: Color?
    /// nil = theme.colors.onSurface
    public var textColor: Color?
    /// nil = theme.cornerRadius.pill
    public var cornerRadius: CGFloat?
    /// nil = type-matched semantic color
    public var iconColor: Color?
    /// nil = theme.elevation.e2
    public var elevation: ElevationLevel?
    public var maxWidth: CGFloat             // default: 320
    public static var `default`: Self { get }
}
```

### 6.3 Styling defaults

| Property | Token |
|---|---|
| Background | `theme.colors.surface` at `theme.opacity.overlay` |
| Icon | SF Symbol, color-matched to type (`success`→`theme.colors.success`, etc.) |
| Typography | `theme.typography.subheadline` |
| Padding | `theme.spacing.sm` vertical, `theme.spacing.md` horizontal |
| Entry animation | `theme.animation.slideIn` |
| Exit animation | `theme.animation.fadeIn` reversed |

---

## 7. Loading indicators

### 7.1 Types

| Component | Description |
|---|---|
| `PrismSpinner` | Indeterminate animated indicator with configurable style |
| `PrismProgressBar` | Determinate horizontal linear bar |
| `PrismProgressCircle` | Determinate circular arc |
| `PrismSkeletonView` | Shimmer placeholder for loading content areas |
| `PrismLoadingOverlay` | Full-screen blocking overlay with optional label |

### 7.2 API

```swift
// Spinner — three built-in styles
PrismSpinner(style: .ring, size: .medium)    // rotating arc (default)
PrismSpinner(style: .dots, size: .small)     // three bouncing dots
PrismSpinner(style: .pulse, size: .large)    // scaling/breathing circle

public enum PrismSpinnerStyle {
    case ring   // stroke arc, rotates
    case dots   // three circles, staggered bounce
    case pulse  // filled circle, scale in/out
}

// Progress bar
PrismProgressBar(progress: $taskProgress)
PrismProgressBar(progress: $taskProgress, configuration: .default)

public struct PrismProgressBarConfig {
    /// nil = theme.colors.surfaceVariant
    public var trackColor: Color?
    /// nil = theme.colors.accent
    public var fillColor: Color?
    /// nil = theme.cornerRadius.pill
    public var cornerRadius: CGFloat?
    public var height: CGFloat           // default: 6
    public var animated: Bool            // default: true
    public static var `default`: Self { get }
}

// Circular progress
PrismProgressCircle(progress: $taskProgress, size: 64)
PrismProgressCircle(progress: $taskProgress, size: 64, lineWidth: 6)

// Skeleton shimmer placeholder
PrismSkeletonView()
    .frame(height: 20)
    .cornerRadius(theme.cornerRadius.small)

// Full-screen blocking overlay
PrismLoadingOverlay(isPresented: $isLoading, label: "Loading…")
PrismLoadingOverlay(isPresented: $isLoading)   // spinner only, no label
```

### 7.3 Styling defaults

| Property | Token |
|---|---|
| Spinner fill | `theme.colors.accent` |
| Track | `theme.colors.surfaceVariant` |
| Overlay background | `theme.colors.background` at `theme.opacity.overlay` |
| Label typography | `theme.typography.subheadline`, `theme.colors.onSurface` |
| Shimmer animation | `theme.animation.shimmer` — repeating linear sweep over a gradient |

---

## 8. `PrismThemeProvider` (companion utility)

For UIKit apps or scenes that cannot use the `.prismTheme()` SwiftUI modifier, `PrismThemeProvider` exposes the active theme via an `@Observable` shared object:

```swift
@Observable
public final class PrismThemeProvider {
    public static let shared = PrismThemeProvider()

    public private(set) var currentTheme: any PrismThemeProtocol

    public func setTheme(_ family: PrismThemeFamily, liquidGlass: Bool = false)
}
```

UIKit view controllers observe changes with `withObservationTracking` (Swift Observation) or subscribe via a Combine publisher bridge.

---

## 9. Testing

- **Unit tests:** Every public API method, configuration default, and token-to-visual mapping has a corresponding `@Test` function using Swift Testing.
- **Snapshot tests:** Each component rendered in all 6 states (3 theme variants × light/dark color scheme) at 390×844 pt (iPhone SE-class) and 1024×1366 pt (iPad). Snapshots are checked in as reference images.
- **Accessibility tests:** `XCUIApplication`-based tests asserting VoiceOver labels, accessibility traits, and focus order for all overlay components.
- **Token completeness:** Shared `TokenCompletenessValidator` suite from the core library — run against every component's default token resolution.
- **Coverage target:** ≥ 80% line coverage on `Sources/Prism/Components/`.

---

## 10. Documentation

- All public types, modifiers, and configuration structs documented with Swift DocC (`///` triple-slash).
- DocC catalog (`Prism.docc`) containing:
  - **Getting Started** article (15-line Quick Start).
  - **Token Reference** article (all token protocols and their default values).
  - **Component Gallery** article (each utility with a minimal code example).
  - **Custom Theme Guide** article (conforming to `PrismThemeProtocol`).
- `README.md` at the repo root with Quick Start, component comparison table, and platform requirements.
