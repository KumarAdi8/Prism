// PrismHUD.swift
// Prism — Design Theme System
// Non-blocking transient toast/HUD overlay component.

import SwiftUI

// MARK: - PrismHUDType

/// The semantic display type of a HUD notification.
public enum PrismHUDType: Sendable, Equatable {
    case success
    case error
    case warning
    case info
    case custom(systemImage: String)

    var systemImageName: String {
        switch self {
        case .success:              return "checkmark.circle.fill"
        case .error:                return "xmark.circle.fill"
        case .warning:              return "exclamationmark.triangle.fill"
        case .info:                 return "info.circle.fill"
        case .custom(let name):     return name
        }
    }
}

// MARK: - PrismHUDPosition

/// The screen position of a HUD notification.
public enum PrismHUDPosition: Sendable, Equatable {
    case top(offset: CGFloat = 0)
    case center
    case bottom(offset: CGFloat = 0)
}

// MARK: - PrismHUDConfiguration

/// Configuration that controls HUD appearance and placement.
public struct PrismHUDConfiguration: Sendable {
    /// Vertical screen position of the HUD.
    public var position: PrismHUDPosition
    /// Override background color; `nil` uses `theme.colors.surface`.
    public var backgroundColor: Color?
    /// Override text color; `nil` uses `theme.colors.onSurface`.
    public var textColor: Color?
    /// Override corner radius; `nil` uses `theme.cornerRadius.pill`.
    public var cornerRadius: CGFloat?
    /// Override icon color; `nil` derives color from HUD type.
    public var iconColor: Color?
    /// Override elevation level; `nil` uses `theme.elevation.e2`.
    public var elevation: ElevationLevel?
    /// Maximum width of the HUD pill in points.
    public var maxWidth: CGFloat

    /// Default configuration: bottom-docked at 32 pt offset, 320 pt max width.
    public static var `default`: Self {
        PrismHUDConfiguration(position: .bottom(offset: 32), maxWidth: 320)
    }

    public init(
        position: PrismHUDPosition = .bottom(offset: 32),
        backgroundColor: Color? = nil,
        textColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        iconColor: Color? = nil,
        elevation: ElevationLevel? = nil,
        maxWidth: CGFloat = 320
    ) {
        self.position = position
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.iconColor = iconColor
        self.elevation = elevation
        self.maxWidth = maxWidth
    }
}

// MARK: - PrismHUDEntry

struct PrismHUDEntry: Sendable, Identifiable {
    let id: UUID
    let message: String
    let type: PrismHUDType
    let duration: Double
    let configuration: PrismHUDConfiguration

    init(
        message: String,
        type: PrismHUDType,
        duration: Double,
        configuration: PrismHUDConfiguration
    ) {
        self.id = UUID()
        self.message = message
        self.type = type
        self.duration = duration
        self.configuration = configuration
    }
}

// MARK: - PrismHUDModel

/// Observable model that owns the HUD queue and current display state.
///
/// Access the singleton via `PrismHUDModel.shared`, or pass a custom instance
/// to `.prismHUD(model:)` for isolated testing.
@MainActor
@Observable
public final class PrismHUDModel {

    /// Singleton used by `.prismHUD()` and `PrismHUD.show()`.
    public static let shared = PrismHUDModel()

    /// The entry currently on screen (or animating out).
    var currentEntry: PrismHUDEntry?
    /// Pending entries waiting to be shown. Capped at 3; oldest is dropped on overflow.
    var queue: [PrismHUDEntry] = []
    /// Drives the show/hide transition in the overlay view.
    var isVisible: Bool = false

    private var autoDismissTask: Task<Void, Never>?

    public init() {}

    // MARK: Public API

    /// Enqueues a new HUD notification.
    ///
    /// If nothing is currently shown the HUD appears immediately; otherwise the
    /// entry is queued (max 3 pending — oldest is dropped on overflow).
    public func show(
        _ message: String,
        type: PrismHUDType = .info,
        duration: Double = 2.5,
        configuration: PrismHUDConfiguration = .default
    ) {
        let entry = PrismHUDEntry(
            message: message,
            type: type,
            duration: duration,
            configuration: configuration
        )
        if currentEntry == nil {
            showEntry(entry)
        } else {
            if queue.count >= 3 { queue.removeFirst() }
            queue.append(entry)
        }
    }

    /// Immediately dismisses the current HUD and advances the queue.
    public func dismiss() {
        guard currentEntry != nil else { return }
        autoDismissTask?.cancel()
        autoDismissTask = nil
        withAnimation { isVisible = false }
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(300))
            self.currentEntry = nil
            self.dequeueNext()
        }
    }

    // MARK: Private helpers

    private func showEntry(_ entry: PrismHUDEntry) {
        currentEntry = entry
        withAnimation { isVisible = true }
        guard entry.duration.isFinite else { return }
        autoDismissTask?.cancel()
        autoDismissTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(entry.duration))
            if !Task.isCancelled { self.dismiss() }
        }
    }

    private func dequeueNext() {
        guard !queue.isEmpty else { return }
        let next = queue.removeFirst()
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(100))
            self.showEntry(next)
        }
    }
}

// MARK: - PrismHUD (static namespace)

/// Static namespace for triggering HUD notifications from any call-site.
///
/// ```swift
/// // From a main-actor context (SwiftUI action, etc.)
/// PrismHUD.show("Saved!", type: .success)
///
/// // From a non-isolated async context
/// await PrismHUD.show("Network error", type: .error, duration: 4)
/// await PrismHUD.dismiss()
/// ```
public enum PrismHUD {

    @MainActor
    public static func show(
        _ message: String,
        type: PrismHUDType = .info,
        duration: Double = 2.5,
        configuration: PrismHUDConfiguration = .default
    ) {
        PrismHUDModel.shared.show(
            message,
            type: type,
            duration: duration,
            configuration: configuration
        )
    }

    @MainActor
    public static func dismiss() {
        PrismHUDModel.shared.dismiss()
    }
}

// MARK: - PrismHUDModifier

/// Installs the HUD overlay on the view hierarchy.
public struct PrismHUDModifier: ViewModifier {
    let model: PrismHUDModel

    public init(model: PrismHUDModel = .shared) {
        self.model = model
    }

    public func body(content: Content) -> some View {
        content.overlay {
            PrismHUDOverlayView(model: model)
        }
    }
}

extension View {
    /// Installs the Prism HUD overlay. Call once near the root of your view hierarchy.
    ///
    /// ```swift
    /// ContentView()
    ///     .prismTheme(.neo(.dark))
    ///     .prismHUD()
    /// ```
    ///
    /// - Parameter model: Pass a custom `PrismHUDModel` for isolated testing;
    ///   defaults to the shared singleton.
    public func prismHUD(model: PrismHUDModel = .shared) -> some View {
        modifier(PrismHUDModifier(model: model))
    }
}

// MARK: - PrismHUDOverlayView

private struct PrismHUDOverlayView: View {
    @Environment(\.prismTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let model: PrismHUDModel

    var body: some View {
        ZStack {
            if model.isVisible, let entry = model.currentEntry {
                positionalContainer(for: entry)
                    .transition(transition(for: entry.configuration.position))
            }
        }
        .animation(
            reduceMotion ? .default : theme.animation.slideIn,
            value: model.isVisible
        )
        .allowsHitTesting(false)
        .ignoresSafeArea(edges: .all)
    }

    @ViewBuilder
    private func positionalContainer(for entry: PrismHUDEntry) -> some View {
        switch entry.configuration.position {
        case .top(let offset):
            VStack {
                PrismHUDContentView(entry: entry)
                    .padding(.top, offset)
                Spacer()
            }
            .padding(.horizontal, 16)

        case .center:
            PrismHUDContentView(entry: entry)
                .padding(.horizontal, 16)

        case .bottom(let offset):
            VStack {
                Spacer()
                PrismHUDContentView(entry: entry)
                    .padding(.bottom, offset)
            }
            .padding(.horizontal, 16)
        }
    }

    private func transition(for position: PrismHUDPosition) -> AnyTransition {
        guard !reduceMotion else { return .opacity }
        switch position {
        case .top:      return .move(edge: .top).combined(with: .opacity)
        case .center:   return .scale(scale: 0.8).combined(with: .opacity)
        case .bottom:   return .move(edge: .bottom).combined(with: .opacity)
        }
    }
}

// MARK: - PrismHUDContentView

private struct PrismHUDContentView: View {
    @Environment(\.prismTheme) private var theme

    let entry: PrismHUDEntry

    var body: some View {
        HStack(spacing: theme.spacing.sm) {
            Image(systemName: entry.type.systemImageName)
                .foregroundStyle(resolvedIconColor)
                .font(.system(size: theme.iconSize.medium))

            Text(entry.message)
                .font(theme.typography.subheadline)
                .foregroundStyle(entry.configuration.textColor ?? theme.colors.onSurface)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
        }
        .padding(.vertical, theme.spacing.sm)
        .padding(.horizontal, theme.spacing.md)
        .frame(maxWidth: entry.configuration.maxWidth)
        .background(
            RoundedRectangle(
                cornerRadius: entry.configuration.cornerRadius ?? theme.cornerRadius.pill
            )
            .fill(entry.configuration.backgroundColor ?? theme.colors.surface)
        )
        .prismElevation(entry.configuration.elevation ?? theme.elevation.e2)
        .onAppear {
            triggerHaptic(theme.haptic.lightImpact)
        }
    }

    private var resolvedIconColor: Color {
        if let override = entry.configuration.iconColor { return override }
        switch entry.type {
        case .success:      return theme.colors.success
        case .error:        return theme.colors.error
        case .warning:      return theme.colors.warning
        case .info:         return theme.colors.accent
        case .custom:       return theme.colors.onSurface
        }
    }
}
