// PrismBottomSheet.swift
// Prism — Design Theme System
// Bottom sheet overlay with detent-based drag gesture.

import SwiftUI

// MARK: - Detent

/// Snap height position for a bottom sheet.
public enum PrismBottomSheetDetent: Hashable, Sendable {
    /// Drag handle only (~60 pt).
    case collapsed
    /// Fraction of container height (0.0–1.0).
    case fraction(CGFloat)
    /// Explicit point value.
    case fixed(CGFloat)
    /// Fills to safe area top.
    case expanded
}

// MARK: - Theme Adaptation

/// Controls how the bottom sheet derives its visual appearance.
public enum PrismThemeAdaptation: Sendable {
    case auto
    case override(backgroundColor: Color, cornerRadius: CGFloat)
}

// MARK: - Configuration

/// Configuration for PrismBottomSheet.
public struct PrismBottomSheetConfiguration {
    public var detents: [PrismBottomSheetDetent]
    public var startingDetent: PrismBottomSheetDetent?
    public var isDraggable: Bool
    public var showsDragHandle: Bool
    public var dismissOnTapOutside: Bool
    public var allowsDragToDismiss: Bool
    public var overlayColor: Color?
    public var backgroundColor: Color?
    public var cornerRadius: CGFloat?
    public var elevation: ElevationLevel?
    public var themeAdaptation: PrismThemeAdaptation

    public init(
        detents: [PrismBottomSheetDetent] = [.fraction(0.5), .expanded],
        startingDetent: PrismBottomSheetDetent? = nil,
        isDraggable: Bool = true,
        showsDragHandle: Bool = true,
        dismissOnTapOutside: Bool = true,
        allowsDragToDismiss: Bool = true,
        overlayColor: Color? = nil,
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        elevation: ElevationLevel? = nil,
        themeAdaptation: PrismThemeAdaptation = .auto
    ) {
        self.detents = detents
        self.startingDetent = startingDetent
        self.isDraggable = isDraggable
        self.showsDragHandle = showsDragHandle
        self.dismissOnTapOutside = dismissOnTapOutside
        self.allowsDragToDismiss = allowsDragToDismiss
        self.overlayColor = overlayColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.elevation = elevation
        self.themeAdaptation = themeAdaptation
    }

    public static var `default`: Self { Self() }
}

// MARK: - Informational Model

/// Model for the built-in informational bottom sheet type.
public struct PrismBottomSheetInformationalModel {
    public var icon: String?
    public var title: String
    public var subtitle: String?
    public var body: String?
    public var action: PrismSheetAction?

    public init(
        icon: String? = nil,
        title: String,
        subtitle: String? = nil,
        body: String? = nil,
        action: PrismSheetAction? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.action = action
    }
}

// MARK: - View Modifier

/// View modifier that presents a PrismBottomSheet overlay.
struct PrismBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let configuration: PrismBottomSheetConfiguration
    @ViewBuilder let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        content.overlay {
            if isPresented {
                PrismBottomSheetOverlay(
                    isPresented: $isPresented,
                    configuration: configuration,
                    sheetContent: sheetContent
                )
                .transition(.opacity)
                .zIndex(800)
            }
        }
    }
}

extension View {
    /// Presents a bottom sheet overlay with custom content.
    public func prismBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        configuration: PrismBottomSheetConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(PrismBottomSheetModifier(
            isPresented: isPresented,
            configuration: configuration,
            sheetContent: content
        ))
    }

    /// Presents an informational bottom sheet.
    public func prismBottomSheet(
        isPresented: Binding<Bool>,
        model: PrismBottomSheetInformationalModel,
        configuration: PrismBottomSheetConfiguration = .default
    ) -> some View {
        prismBottomSheet(isPresented: isPresented, configuration: configuration) {
            PrismBottomSheetInformationalContent(model: model)
        }
    }

    /// Presents an action-list bottom sheet.
    public func prismBottomSheet(
        isPresented: Binding<Bool>,
        title: String? = nil,
        actions: [PrismSheetAction],
        configuration: PrismBottomSheetConfiguration = .default
    ) -> some View {
        prismBottomSheet(isPresented: isPresented, configuration: configuration) {
            PrismBottomSheetActionContent(title: title, actions: actions, isPresented: isPresented)
        }
    }
}

// MARK: - Overlay Container

private struct PrismBottomSheetOverlay<SheetContent: View>: View {
    @Environment(\.prismTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Binding var isPresented: Bool
    let configuration: PrismBottomSheetConfiguration
    @ViewBuilder let sheetContent: () -> SheetContent

    @State private var sheetHeight: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var appeared = false

    var body: some View {
        GeometryReader { geometry in
            let containerHeight = geometry.size.height
            let startDetent = configuration.startingDetent ?? configuration.detents.first ?? .fraction(0.5)
            let targetHeight = resolveDetent(startDetent, in: containerHeight)
            let bg = resolvedBackgroundColor
            let cr = resolvedCornerRadius

            ZStack(alignment: .bottom) {
                PrismBackdropView(
                    style: .dim,
                    isPresented: appeared,
                    onTap: configuration.dismissOnTapOutside ? { dismiss() } : nil
                )

                VStack(spacing: 0) {
                    if configuration.showsDragHandle {
                        dragHandle
                    }

                    ScrollView {
                        sheetContent()
                            .padding(theme.spacing.md)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: max(0, targetHeight + dragOffset))
                .background(bg)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: cr,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: cr
                    )
                )
                .prismElevation(configuration.elevation ?? theme.elevation.e3)
                .offset(y: appeared ? 0 : targetHeight)
                .gesture(configuration.isDraggable ? dragGesture(containerHeight: containerHeight) : nil)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            triggerHaptic(theme.haptic.lightImpact)
            if reduceMotion {
                appeared = true
            } else {
                withAnimation(theme.animation.spring) {
                    appeared = true
                }
            }
        }
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel("Bottom sheet")
    }

    // MARK: - Drag Handle

    private var dragHandle: some View {
        RoundedRectangle(cornerRadius: theme.cornerRadius.pill)
            .fill(theme.colors.divider)
            .frame(width: 36, height: 4)
            .padding(.top, theme.spacing.sm)
            .padding(.bottom, theme.spacing.xs)
    }

    // MARK: - Drag Gesture

    private func dragGesture(containerHeight: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = -value.translation.height
            }
            .onEnded { value in
                let velocity = -value.predictedEndTranslation.height / max(0.001, CGFloat(theme.animation.fast))
                let startDetent = configuration.startingDetent ?? configuration.detents.first ?? .fraction(0.5)
                let currentHeight = resolveDetent(startDetent, in: containerHeight) + dragOffset

                if configuration.allowsDragToDismiss && velocity < -500 {
                    dismiss()
                    return
                }

                let targetDetent = nearestDetent(
                    for: currentHeight,
                    velocity: velocity,
                    containerHeight: containerHeight
                )
                let targetHeight = resolveDetent(targetDetent, in: containerHeight)
                let baseHeight = resolveDetent(startDetent, in: containerHeight)
                let newOffset = targetHeight - baseHeight

                if reduceMotion {
                    dragOffset = newOffset
                } else {
                    withAnimation(theme.animation.bouncy) {
                        dragOffset = newOffset
                    }
                }
            }
    }

    // MARK: - Detent Resolution

    private func resolveDetent(_ detent: PrismBottomSheetDetent, in containerHeight: CGFloat) -> CGFloat {
        switch detent {
        case .collapsed:
            return 60
        case .fraction(let f):
            return containerHeight * min(max(f, 0), 1)
        case .fixed(let h):
            return h
        case .expanded:
            return containerHeight
        }
    }

    private func nearestDetent(
        for currentHeight: CGFloat,
        velocity: CGFloat,
        containerHeight: CGFloat
    ) -> PrismBottomSheetDetent {
        let heights = configuration.detents.map { ($0, resolveDetent($0, in: containerHeight)) }
        guard !heights.isEmpty else { return .fraction(0.5) }

        // If velocity is strong enough, snap in that direction
        if abs(velocity) > 500 {
            let sorted = heights.sorted { $0.1 < $1.1 }
            if velocity > 0 {
                // Expanding: find next higher detent
                if let next = sorted.first(where: { $0.1 > currentHeight + 10 }) {
                    return next.0
                }
                return sorted.last?.0 ?? .fraction(0.5)
            } else {
                // Collapsing: find next lower detent
                if let next = sorted.last(where: { $0.1 < currentHeight - 10 }) {
                    return next.0
                }
                return sorted.first?.0 ?? .fraction(0.5)
            }
        }

        // Snap to nearest
        return heights.min(by: { abs($0.1 - currentHeight) < abs($1.1 - currentHeight) })?.0 ?? .fraction(0.5)
    }

    // MARK: - Helpers

    private var resolvedBackgroundColor: Color {
        if let bg = configuration.backgroundColor { return bg }
        if case .override(let bg, _) = configuration.themeAdaptation { return bg }
        return theme.colors.surface
    }

    private var resolvedCornerRadius: CGFloat {
        if let cr = configuration.cornerRadius { return cr }
        if case .override(_, let cr) = configuration.themeAdaptation { return cr }
        return theme.cornerRadius.large
    }

    private func dismiss() {
        if reduceMotion {
            appeared = false
            isPresented = false
        } else {
            withAnimation(theme.animation.spring) {
                appeared = false
            }
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(theme.animation.normal))
                isPresented = false
            }
        }
    }
}

// MARK: - Informational Content

private struct PrismBottomSheetInformationalContent: View {
    @Environment(\.prismTheme) private var theme
    let model: PrismBottomSheetInformationalModel

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            if let icon = model.icon {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(theme.colors.accent)
            }

            Text(model.title)
                .font(theme.typography.headline)
                .foregroundStyle(theme.colors.onSurface)

            if let subtitle = model.subtitle {
                Text(subtitle)
                    .font(theme.typography.subheadline)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.7))
            }

            if let body = model.body {
                Text(body)
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.onSurface)
            }

            if let action = model.action {
                Button {
                    action.handler()
                } label: {
                    Text(action.title)
                        .font(theme.typography.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, theme.spacing.sm)
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.colors.primary)
                .padding(.top, theme.spacing.sm)
            }
        }
    }
}

// MARK: - Action Content

private struct PrismBottomSheetActionContent: View {
    @Environment(\.prismTheme) private var theme
    let title: String?
    let actions: [PrismSheetAction]
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            if let title {
                Text(title)
                    .font(theme.typography.headline)
                    .foregroundStyle(theme.colors.onSurface)
                    .padding(.bottom, theme.spacing.xs)
            }

            ForEach(actions.indices, id: \.self) { index in
                let action = actions[index]
                Button {
                    action.handler()
                    isPresented = false
                } label: {
                    HStack(spacing: theme.spacing.sm) {
                        if let image = action.systemImage {
                            Image(systemName: image)
                        }
                        Text(action.title)
                        Spacer()
                    }
                    .font(theme.typography.body)
                    .foregroundStyle(actionColor(for: action.role))
                    .padding(.vertical, theme.spacing.sm)
                }

                if index < actions.count - 1 {
                    Divider()
                        .foregroundStyle(theme.colors.divider)
                }
            }
        }
    }

    private func actionColor(for role: PrismAlertActionRole) -> Color {
        switch role {
        case .default: theme.colors.primary
        case .cancel: theme.colors.secondary
        case .destructive: theme.colors.error
        }
    }
}
