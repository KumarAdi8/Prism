// PrismPopover.swift
// Prism — Design Theme System
// Theme-driven popover overlay.

import SwiftUI

// MARK: - Placement

/// Placement preference for a popover arrow.
public enum PrismPopoverPlacement: Sendable {
    case top, bottom, leading, trailing, auto
}

// MARK: - Configuration

/// Configuration for PrismPopover.
public struct PrismPopoverConfiguration: Sendable {
    public var placement: PrismPopoverPlacement
    public var maxWidth: CGFloat
    public var showsArrow: Bool
    public var dismissOnTapOutside: Bool
    public var isInteractiveDismissEnabled: Bool
    public var backgroundColor: Color?
    public var cornerRadius: CGFloat?
    public var elevation: ElevationLevel?

    public init(
        placement: PrismPopoverPlacement = .auto,
        maxWidth: CGFloat = 280,
        showsArrow: Bool = true,
        dismissOnTapOutside: Bool = true,
        isInteractiveDismissEnabled: Bool = true,
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        elevation: ElevationLevel? = nil
    ) {
        self.placement = placement
        self.maxWidth = maxWidth
        self.showsArrow = showsArrow
        self.dismissOnTapOutside = dismissOnTapOutside
        self.isInteractiveDismissEnabled = isInteractiveDismissEnabled
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.elevation = elevation
    }

    public static var `default`: Self { Self() }
}

// MARK: - View Modifier

extension View {
    /// Presents a theme-driven popover anchored to this view.
    public func prismPopover<Content: View>(
        isPresented: Binding<Bool>,
        configuration: PrismPopoverConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(PrismPopoverModifier(
            isPresented: isPresented,
            configuration: configuration,
            popoverContent: content
        ))
    }
}

private struct PrismPopoverModifier<PopoverContent: View>: ViewModifier {
    @Environment(\.prismTheme) private var theme
    @Binding var isPresented: Bool
    let configuration: PrismPopoverConfiguration
    @ViewBuilder let popoverContent: () -> PopoverContent

    func body(content: Content) -> some View {
        content.popover(isPresented: $isPresented, arrowEdge: arrowEdge) {
            popoverContent()
                .frame(maxWidth: configuration.maxWidth, maxHeight: 480)
                .padding(theme.spacing.sm)
                .background(configuration.backgroundColor ?? theme.colors.surface)
                .clipShape(RoundedRectangle(
                    cornerRadius: configuration.cornerRadius ?? theme.cornerRadius.small
                ))
                .overlay {
                    RoundedRectangle(
                        cornerRadius: configuration.cornerRadius ?? theme.cornerRadius.small
                    )
                    .strokeBorder(
                        theme.border.subtleColor,
                        lineWidth: theme.border.subtle
                    )
                }
                .presentationCompactAdaptation(.popover)
        }
    }

    private var arrowEdge: Edge {
        switch configuration.placement {
        case .top: .bottom
        case .bottom: .top
        case .leading: .trailing
        case .trailing: .leading
        case .auto: .top
        }
    }
}
