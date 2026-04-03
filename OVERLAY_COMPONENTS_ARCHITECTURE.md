# Architecture Proposal: Prism UI Overlay Components

> **For:** ios-developer, ui-ux-designer, team-lead  
> **Date:** 2026-04-03  
> **Status:** Proposed — pending implementation

---

## Overview

This document specifies the architecture for all overlay and loading components described in `UI_Utilities.md`. The design extends the existing Prism token system without modifying any token protocols or theme structs. All new components read exclusively from `@Environment(\.prismTheme)` and follow the strict concurrency model already established by the library (Swift 6.2, `@MainActor` for SwiftUI state).

---

## 1. File Structure

All new files are added under `Sources/Prism/`. No existing files are deleted; `PrismButtonStyle.swift` has one internal refactor (see §3.1).

```
Sources/Prism/
├── Utilities/                              ← NEW folder
│   ├── PrismHaptics.swift                  — internal triggerHaptic helper (shared)
│   └── PrismBackdropView.swift             — internal dim/blur/none backdrop view
│
├── Components/
│   ├── Buttons/PrismButtonStyle.swift      — REFACTOR: remove private triggerHaptic
│   ├── Text/PrismTextModifier.swift        — unchanged
│   │
│   ├── Sheets/                             ← NEW folder
│   │   ├── PrismSheetTypes.swift           — shared value types for all sheet/overlay components
│   │   ├── PrismBottomSheetConfiguration.swift — detents, config struct, typed content models
│   │   ├── PrismBottomSheet.swift          — View + drag gesture engine + detent resolver
│   │   └── PrismCenterSheet.swift          — View + PrismCenterSheetConfig + backdrop wiring
│   │
│   ├── Overlays/                           ← NEW folder
│   │   ├── PrismAlert.swift                — PrismAlert value type, actions, .prismAlert() modifier
│   │   ├── PrismPopover.swift              — PrismPopover view, placement, .prismPopover() modifier
│   │   └── PrismHUD.swift                  — PrismHUDModel (@Observable), PrismHUD (static API), modifier
│   │
│   └── Loading/                            ← NEW folder
│       ├── PrismSpinner.swift              — ring / dots / pulse styles
│       ├── PrismProgressBar.swift          — horizontal determinate bar
│       ├── PrismProgressCircle.swift       — circular arc
│       ├── PrismSkeletonView.swift         — shimmer placeholder
│       └── PrismLoadingOverlay.swift       — full-screen blocking overlay
│
└── ThemeProvider/                          ← NEW folder
    └── PrismThemeProvider.swift            — @Observable singleton for UIKit bridging
```

**Total new files:** 14  
**Modified files:** 1 (`PrismButtonStyle.swift` — remove private helper, import shared)

---

## 2. Shared Types

### 2.1 `PrismHaptics.swift` (internal)

Moves `triggerHaptic` from private-in-file to an `internal` package function accessible to all components. `PrismButtonStyle.swift` is updated to call the shared version.

```swift
// Utilities/PrismHaptics.swift

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Fires a haptic feedback event on iOS; no-op on other platforms.
/// Called on @MainActor (UIKit generators require main thread).
@MainActor
internal func triggerHaptic(_ type: HapticFeedbackType) {
#if canImport(UIKit)
    switch type {
    case .selection:
        UISelectionFeedbackGenerator().selectionChanged()
    case .impact(let style):
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    case .notification(let feedbackType):
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    case .none:
        break
    }
#endif
}
```

**Why `@MainActor`:** UIKit feedback generators must run on the main thread. All callers are either SwiftUI view bodies (implicitly `@MainActor`) or `@MainActor`-isolated model methods, so no bridging overhead occurs.

---

### 2.2 `PrismSheetTypes.swift` (public)

Contains all shared value types referenced across more than one component. Putting them in one file avoids circular file-level dependencies and gives the type definitions a single canonical location.

```swift
// Components/Sheets/PrismSheetTypes.swift

/// A labeled, optionally-iconic action used in sheets and action lists.
public struct PrismSheetAction: Sendable {
    public var title: String
    public var systemImage: String?
    public var role: PrismSheetActionRole
    public var isEnabled: Bool
    public var handler: @Sendable () -> Void

    public init(title: String,
                systemImage: String? = nil,
                role: PrismSheetActionRole = .default,
                isEnabled: Bool = true,
                handler: @escaping @Sendable () -> Void)
}

public enum PrismSheetActionRole: Sendable {
    case `default`, destructive, cancel
}

/// Semantic accessibility role for sheets.
public enum PrismSheetRole: Sendable {
    case dialog, alert
}

/// How the visual surface of a sheet derives its values from the active theme.
public enum PrismThemeAdaptation: Sendable {
    case auto
    case override(backgroundColor: Color, cornerRadius: CGFloat)
    case custom(PrismBottomSheetConfiguration)
}

/// Backdrop rendering style for all modal overlays.
public enum PrismBackdropStyle: Sendable {
    case dim    // solid overlay color at overlayOpacity
    case blur   // UltraThinMaterial (system); gracefully degrades on macOS
    case none
}
```

**Accessibility note:** `PrismSheetAction.handler` is `@Sendable` to comply with Swift 6.2 strict concurrency when the handler is dispatched from a `Task`.

---

### 2.3 `PrismBackdropView.swift` (internal)

A single internal view used by `PrismBottomSheet`, `PrismCenterSheet`, and `PrismAlert` for their backdrop/scrim. Centralising it ensures consistent animation timing and Liquid Glass behaviour everywhere.

```swift
// Utilities/PrismBackdropView.swift  (internal)

struct PrismBackdropView: View {
    @Environment(\.prismTheme) private var theme
    let style: PrismBackdropStyle
    let isPresented: Bool
    let onTap: (() -> Void)?

    var body: some View {
        // Switches on style and theme.liquidGlassEnabled;
        // on iOS 26+ liquidGlass path uses .ultraThinMaterial tinted by theme.colors.overlay
        // on earlier OS / non-liquidGlass: solid theme.colors.overlay fill
        // opacity animated with theme.animation.fadeIn
    }
}
```

---

## 3. Module Boundaries (public vs internal)

### 3.1 Public API Surface

| Symbol | File | Notes |
|---|---|---|
| `PrismSheetAction` | PrismSheetTypes | value type |
| `PrismSheetActionRole` | PrismSheetTypes | enum |
| `PrismSheetRole` | PrismSheetTypes | enum |
| `PrismThemeAdaptation` | PrismSheetTypes | enum |
| `PrismBackdropStyle` | PrismSheetTypes | enum |
| `PrismBottomSheetDetent` | PrismBottomSheetConfiguration | hashable enum |
| `PrismBottomSheetConfiguration` | PrismBottomSheetConfiguration | config struct |
| `PrismBottomSheetInformationalModel` | PrismBottomSheetConfiguration | typed content model |
| `PrismBottomSheet` | PrismBottomSheet | generic View |
| `PrismCenterSheetConfig` | PrismCenterSheet | config struct |
| `PrismCenterSheet` | PrismCenterSheet | generic View |
| `PrismPopoverPlacement` | PrismPopover | enum |
| `PrismPopoverConfiguration` | PrismPopover | config struct |
| `PrismPopover` | PrismPopover | generic View |
| `View.prismPopover(isPresented:placement:content:)` | PrismPopover | view modifier |
| `PrismAlertAction` | PrismAlert | value type |
| `PrismAlertActionRole` | PrismAlert | enum |
| `PrismAlertInput` | PrismAlert | value type |
| `PrismAlert` | PrismAlert | value type (not a View) |
| `View.prismAlert(isPresented:alert:)` | PrismAlert | view modifier |
| `PrismHUDType` | PrismHUD | enum |
| `PrismHUDPosition` | PrismHUD | enum |
| `PrismHUDConfiguration` | PrismHUD | config struct |
| `PrismHUDModel` | PrismHUD | @Observable class |
| `PrismHUD` | PrismHUD | enum (static API) |
| `View.prismHUD(_:)` | PrismHUD | view modifier |
| `PrismSpinnerStyle` | PrismSpinner | enum |
| `PrismSpinner` | PrismSpinner | View |
| `PrismProgressBar` | PrismProgressBar | View (+ config) |
| `PrismProgressCircle` | PrismProgressCircle | View |
| `PrismSkeletonView` | PrismSkeletonView | View |
| `PrismLoadingOverlay` | PrismLoadingOverlay | View |
| `PrismThemeProvider` | PrismThemeProvider | @Observable class |

### 3.2 Internal-only

| Symbol | Reason |
|---|---|
| `triggerHaptic(_:)` | Library implementation detail; callers use theme haptic tokens directly |
| `PrismBackdropView` | Rendering detail; public API controls it via `PrismBackdropStyle` |
| `PrismHUDEntry` | Queue entry; consumers call `PrismHUD.show()`, not `PrismHUDModel` directly |
| `PrismDetentResolver` | Pure-function geometry helper for BottomSheet |
| `PrismBottomSheetDragModifier` | ViewModifier applied internally to the sheet surface |
| Ring/dot/pulse sub-views in PrismSpinner | Styling implementation detail |

---

## 4. Data Flow

### 4.1 Standard overlay pattern (BottomSheet / CenterSheet / Alert)

```
Host View
  └─ .prismBottomSheet / .prismAlert modifier
       ├─ Reads: @Environment(\.prismTheme) → tokens
       ├─ Reads: @Binding<Bool> isPresented
       ├─ Owns:  @State presentationState (animation progress, detent, etc.)
       └─ Renders: ZStack overlay
             ├─ PrismBackdropView (tap → isPresented = false)
             └─ Sheet/Alert surface (tokens → colors, radius, animation)
```

All state is local (`@State`) to the modifier's body view. No global state. Dismiss path writes `isPresented = false`, which triggers the SwiftUI environment to collapse the overlay.

### 4.2 PrismHUD global queue

The HUD is unique: it must be imperatively triggerable from anywhere in the app (not just from within a view), so it uses the **shared `@Observable` singleton + environment injection** pattern.

```
┌─────────────────────────────────────────────────────────────┐
│  PrismHUDModel (@Observable, @MainActor)                    │
│                                                             │
│  private(set) var currentEntry: PrismHUDEntry?              │
│  private      var queue:        [PrismHUDEntry]  (max 3)    │
│  private      var autoDismissTask: Task<Void,Never>?        │
│                                                             │
│  func enqueue(_ entry: PrismHUDEntry)   ← called by show() │
│  func dismiss()                         ← called by API    │
│  private func advance()                 ← internal pump    │
└──────────────────────┬──────────────────────────────────────┘
                       │ @Observable triggers body re-render
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  PrismHUDOverlayView (attached by .prismHUD() modifier)     │
│  @Environment(\.prismHUDModel) private var model            │
│  Reads: model.currentEntry → animates in/out               │
└─────────────────────────────────────────────────────────────┘
                       ▲
           PrismHUD.show("…", type: .success)
           ↳ PrismHUDModel.shared.enqueue(entry)
```

**Queue mechanics:**
1. `enqueue` appends to `queue`. If `queue.count > 3`, the oldest pending entry (index 0) is dropped before appending.
2. If `currentEntry == nil`, calls `advance()` immediately.
3. `advance()` pops from `queue`, sets `currentEntry`, starts an auto-dismiss `Task` that `try await Task.sleep` for `entry.duration` then calls `dismiss()`.
4. Passing `duration: .infinity` skips the sleep; only an explicit `PrismHUD.dismiss()` call advances the queue.
5. `dismiss()` cancels `autoDismissTask`, animates `currentEntry` out (sets it to `nil`), then calls `advance()` if the queue is non-empty.

**Environment injection key:**

```swift
// In PrismHUD.swift
private struct PrismHUDModelKey: EnvironmentKey {
    static let defaultValue: PrismHUDModel = .shared
}

extension EnvironmentValues {
    internal var prismHUDModel: PrismHUDModel {
        get { self[PrismHUDModelKey.self] }
        set { self[PrismHUDModelKey.self] = newValue }
    }
}
```

`internal` (not `public`) because consumers call `PrismHUD.show()` — they never inject `PrismHUDModel` directly unless writing tests.

**Testability:** pass a custom `PrismHUDModel()` instance to `.prismHUD(model:)` to isolate queue behaviour per test without polluting the shared singleton.

---

## 5. Concurrency Contract

| Type | Isolation | Rationale |
|---|---|---|
| `PrismHUDModel` | `@MainActor @Observable` | Drives SwiftUI state; must be on MainActor |
| `PrismThemeProvider` | `@MainActor @Observable` | Same — drives UIKit observation |
| `triggerHaptic` | `@MainActor` | UIKit generators require main thread |
| All `PrismXxxConfiguration` structs | `Sendable` (value type) | Passed across concurrency boundaries from call sites |
| `PrismSheetAction.handler` | `@Sendable () -> Void` | Captured in tasks; must be Sendable in Swift 6.2 |
| `PrismHUDEntry` | `Sendable` struct | Enqueued and consumed on MainActor, but declared Sendable for safety |
| `AnimationTokens` properties | `@MainActor` (existing contract) | Already established; all component bodies respect this |
| Loading views | `@MainActor` (implicit SwiftUI body) | No additional isolation needed |

---

## 6. Liquid Glass Integration

Components apply the Liquid Glass path when `theme.liquidGlassEnabled == true`. The check is performed once inside each component's `body`:

```swift
// Pattern used in all overlays
private var surfaceBackground: some ShapeStyle {
    if theme.liquidGlassEnabled {
        // iOS 26+: returns AnyShapeStyle(.glassEffect()) or .ultraThinMaterial
        // iOS < 26: returns AnyShapeStyle(theme.colors.surface)
        return resolvedGlassBackground()
    }
    return AnyShapeStyle(theme.colors.surface)
}
```

`resolvedGlassBackground()` is a private method on each component that wraps the `#available(iOS 26, *)` check. Host code needs zero `#available` guards — the component handles it. On macOS 14, `liquidGlassEnabled` will be `false` for all built-in themes, so the glass path is never reached without an opt-in custom theme.

---

## 7. Key Design Decisions

### Decision A: `PrismHUD` as enum (static namespace) + `PrismHUDModel` as the real state

**Context:** The spec requires `await PrismHUD.show(...)` as a static call. Storing queue state on `PrismHUD` itself would need static mutable state — problematic with Swift 6.2 strict concurrency.

**Options:**
1. `PrismHUD` as a class singleton — couples state to the type name, harder to test.
2. `PrismHUD` as an `enum` (static namespace) delegating to `PrismHUDModel.shared` — clean separation; model is injectable for tests.
3. `PrismHUD` as a protocol — over-engineered for this use case.

**Decision:** Option 2. `PrismHUD` is an empty `enum` (static namespace) whose methods forward to `PrismHUDModel.shared`. Tests inject a fresh `PrismHUDModel()` via `.prismHUD(model: myModel)`.

**Consequences:** Public API is clean and matches the spec verbatim. Testability is preserved.

---

### Decision B: `PrismBottomSheet` as a single generic View (not a `.sheet()` modifier)

**Context:** The spec's API constructs `PrismBottomSheet(isPresented:configuration:content:)` directly, unlike center sheet. This means BottomSheet is a concrete view rendered from a ZStack, not a SwiftUI `.sheet()` modifier.

**Options:**
1. Wrap SwiftUI's native `.sheet()` with a custom `UISheetPresentationController` — system feel but limited styling control, breaks token theming.
2. Custom `ZStack`-based implementation with `DragGesture` — full control over appearance, detents, keyboard avoidance.

**Decision:** Option 2. Token-driven styling requires full control. `DragGesture.Value.velocity` (iOS 17+) gives us velocity-based snap without third-party libraries. A `PrismDetentResolver` pure function maps (currentOffset, screenHeight, velocity) → target detent, making the logic unit-testable.

**Consequences:** Keyboard avoidance must be implemented manually using `GeometryReader` + `.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification))` on iOS. That is an acceptable scope item.

---

### Decision C: `PrismPopover` uses native `.popover()` on iOS

**Context:** Custom popovers require manual arrow drawing and placement math.

**Options:**
1. Wrap `UIPopoverPresentationController` via `UIViewControllerRepresentable` — full iOS system popover, keyboard-aware, but harder to theme.
2. Native SwiftUI `.popover(isPresented:attachmentAnchor:arrowEdge:)` (iOS 16.4+ full support) — simple, auto-placement, but limited arrow styling.
3. Fully custom `ZStack` positioned overlay — maximum theming but significant geometry work.

**Decision:** Option 2. SwiftUI's `.popover()` handles all screen-edge avoidance automatically. `PrismPopoverPlacement` maps to `arrowEdge`. Token theming is applied through the view content and background modifier. On macOS Catalyst, `.popover()` renders the system popover chrome, which is appropriate.

**Consequences:** Arrow color is constrained to system popover chrome on iOS. To apply `theme.colors.surface` to the popover background, use `.toolbarBackground(.visible)` override — document this limitation. Custom arrowhead drawing can be added later without changing the public API.

---

### Decision D: Single `PrismBackdropView` for all overlays

**Context:** BottomSheet, CenterSheet, and Alert all need a dimming/blurring layer.

**Options:**
1. Each component implements its own backdrop — duplication, drift in animation timing.
2. Single `internal struct PrismBackdropView` — DRY, consistent, one place to update Liquid Glass logic.

**Decision:** Option 2. The internal visibility keeps the public API surface clean.

---

### Decision E: `PrismAlert` is a value type, not a View

**Context:** The spec shows `.prismAlert(isPresented:) { PrismAlert(...) }`. The trailing closure returns a configuration object, not a SwiftUI `View`.

**Design:** `PrismAlert` is a `struct` (value type). The `.prismAlert(isPresented:alert:)` ViewModifier renders the actual UI. This mirrors SwiftUI's own `Alert` type pattern and keeps the public API declarative.

```swift
// PrismAlert is a value type:
public struct PrismAlert: Sendable {
    public var title: String
    public var message: String?
    public var input: PrismAlertInput?
    public var actions: [PrismAlertAction]
}
```

**Consequences:** `PrismAlertInput` carries a `Binding<String>` which is not `Sendable` — the struct itself cannot be `Sendable`. Mark `@unchecked Sendable` with a comment, or drop `Sendable` and document that it must be constructed on `@MainActor`.

---

### Decision F: Loading components are standalone Views (no overlay modifier)

`PrismSpinner`, `PrismProgressBar`, `PrismProgressCircle`, `PrismSkeletonView` are plain `View` types composable anywhere. Only `PrismLoadingOverlay` adds an overlay layer (via ZStack in its body). This maximises reuse: host apps can use `PrismSpinner` inside cells, navbars, or empty states without triggering an overlay.

---

## 8. Implementation Phases

Dependencies run top-to-bottom within each phase. Do not start a phase until all items in the prior phase are merged and tests are green.

### Phase 1 — Shared Infrastructure (no user-visible features)

1. `Utilities/PrismHaptics.swift` — extract `triggerHaptic` as `@MainActor internal` function.
2. `Components/Buttons/PrismButtonStyle.swift` — remove private `triggerHaptic`, call shared one. Run all 44 existing tests.
3. `Components/Sheets/PrismSheetTypes.swift` — all shared value types (`PrismSheetAction`, `PrismSheetActionRole`, `PrismSheetRole`, `PrismThemeAdaptation`, `PrismBackdropStyle`).
4. `Utilities/PrismBackdropView.swift` — internal backdrop view (used by phases 2-4).

**Gate:** `swift build` passes with zero warnings. All 44 existing tests still pass.

---

### Phase 2 — Loading Indicators (no overlay, no gesture state)

1. `PrismSpinner.swift` — `PrismSpinnerStyle`, `PrismComponentSize` (small/medium/large), three sub-views.
2. `PrismProgressBar.swift` + `PrismProgressBarConfig.swift` (or combined).
3. `PrismProgressCircle.swift`.
4. `PrismSkeletonView.swift` — shimmer using `@MainActor var shimmer: Animation` from `AnimationTokens`.
5. `PrismLoadingOverlay.swift` — composes `PrismSpinner` + optional label. No external dependencies.

**Why first:** zero dependencies on overlay infrastructure; good incremental validation that token reads work in new component files.

---

### Phase 3 — PrismHUD (introduces singleton + queue pattern)

1. `PrismHUD.swift` — `PrismHUDEntry` (internal Sendable struct), `PrismHUDModel` (`@MainActor @Observable`), `PrismHUD` enum, `PrismHUDModifier`, `View.prismHUD(_:)`.
2. `PrismHUDConfiguration.swift` can fold into `PrismHUD.swift` at this scale. Split if it grows.

**Key test:** unit-test queue overflow (drop oldest when > 3), auto-dismiss `Task` cancellation, re-queue after dismiss.

---

### Phase 4 — PrismAlert (blocking modal, no gesture)

1. `PrismAlert.swift` — value type, action types, `PrismAlertInput`, `.prismAlert()` modifier. Uses `PrismBackdropView` for backdrop.

**Why before sheets:** simpler than sheets (no drag, no detents), establishes the backdrop + accessibility modal pattern from `PrismBackdropView`.

---

### Phase 5 — PrismCenterSheet (modal with scroll, no drag)

1. `PrismCenterSheet.swift` — `PrismCenterSheetConfig`, generic View. Uses `PrismBackdropView`. Adds scroll-clip, max-width sizing, close button.

---

### Phase 6 — PrismBottomSheet (drag + detents + keyboard avoidance)

1. `PrismBottomSheetConfiguration.swift` — `PrismBottomSheetDetent`, `PrismBottomSheetConfiguration`, typed content models (`PrismBottomSheetInformationalModel`, etc.).
2. `PrismBottomSheet.swift` — `PrismDetentResolver` (pure function, internal), `PrismBottomSheetDragModifier` (internal ViewModifier), full `PrismBottomSheet` generic View.

**This is the most complex phase.** Budget additional time for:
- Velocity extraction from `DragGesture.Value.velocity` (iOS 17+)
- Keyboard avoidance using `NotificationCenter` + `@State keyboardOffset`
- Bouncy over-scroll using `AnimationTokens.bouncy`

---

### Phase 7 — PrismPopover

1. `PrismPopover.swift` — wraps `.popover(isPresented:attachmentAnchor:arrowEdge:)`. Adds `View.prismPopover()` modifier.

**Simplest overlay** — implementation is thin; most logic delegated to SwiftUI internals.

---

### Phase 8 — PrismThemeProvider (UIKit bridge)

1. `ThemeProvider/PrismThemeProvider.swift` — `@MainActor @Observable final class`, `.shared` singleton, `setTheme(_:liquidGlass:)`, Combine publisher bridge (internal `PassthroughSubject`).

**Kept last** because it has no dependencies on other overlay components and is an independent UIKit bridging concern.

---

## 9. Testing Strategy

Following the existing Swift Testing patterns:

| Scope | What to test | Location |
|---|---|---|
| `PrismHUDModel` | Enqueue/dequeue, max-3 overflow, auto-dismiss cancellation, duration:.infinity | `Tests/PrismTests/HUDTests.swift` |
| `PrismDetentResolver` | Velocity snap, nearest-snap, boundary clamp | `Tests/PrismTests/BottomSheetTests.swift` |
| Default configs | `static var default` produces token-consistent values for each component | `Tests/PrismTests/ComponentConfigTests.swift` |
| `PrismThemeProvider` | `setTheme` updates `currentTheme`, Combine publisher fires | `Tests/PrismTests/ThemeProviderTests.swift` |
| Loading views | Token reads (accent color, shimmer animation non-nil) | `Tests/PrismTests/LoadingTests.swift` |

Snapshot tests (per `UI_Utilities.md §9`) are deferred to a follow-up; they require a snapshot testing infrastructure decision (SnapshotTesting library or custom). That decision is outside scope of this architecture proposal.

---

## 10. Risks

| Risk | Mitigation |
|---|---|
| **`PrismAlert.PrismAlertInput` carries `Binding<String>` — not Sendable** | Mark `PrismAlert` as `@unchecked Sendable` with a comment requiring `@MainActor` construction, or drop `Sendable` conformance and document the constraint. Evaluate at implementation time. |
| **`PrismBottomSheet` keyboard avoidance is fragile** | Use `UIResponder.keyboardWillShowNotification` with `UIWindow`-relative frame conversion rather than raw keyboard height to correctly handle split keyboard and external keyboard scenarios. |
| **`.popover()` background theming is limited on iOS** | Use `.presentationBackground(theme.colors.surface)` (iOS 16.4+) inside the content view; document the system arrow chrome limitation. |
| **`PrismHUDModel.shared` creates a retain cycle-like pattern in tests** | Each test that exercises HUD behaviour should use `.prismHUD(model: PrismHUDModel())` with a fresh instance, never touch `.shared`. |
| **`AnimationTokens` properties are `@MainActor`** | All component views are already `@MainActor` (SwiftUI body). Access `theme.animation.spring` etc. only inside `.body` or `@MainActor`-isolated methods — no change from current practice. |
| **macOS 14 Catalyst: UIKit haptics unavailable** | Existing `#if canImport(UIKit)` guard in `triggerHaptic` covers this. Components with haptic calls compile correctly on macOS with no-op behaviour. |
