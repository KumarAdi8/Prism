// PrismLoadingOverlay.swift
// Prism — Design Theme System
// Full-screen blocking overlay with spinner and optional label.

import SwiftUI

// MARK: - Standalone View

/// A full-screen modal overlay that blocks interaction and shows a spinner.
///
/// Place inside a `ZStack` at the root of your view hierarchy or use the
/// `.prismLoadingOverlay(isPresented:label:)` convenience modifier instead.
public struct PrismLoadingOverlay: View {
    @Environment(\.prismTheme) private var theme

    @Binding var isPresented: Bool
    let label: String?

    public init(isPresented: Binding<Bool>, label: String? = nil) {
        _isPresented = isPresented
        self.label = label
    }

    public var body: some View {
        Group {
            if isPresented {
                ZStack {
                    theme.colors.background
                        .opacity(theme.opacity.overlay)
                        .ignoresSafeArea()
                    spinnerContent
                }
                .transition(.opacity)
                .accessibilityAddTraits(.isModal)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }

    @ViewBuilder
    private var spinnerContent: some View {
        VStack(spacing: theme.spacing.sm) {
            PrismSpinner(style: .ring, size: .large)
            if let label {
                Text(label)
                    .font(theme.typography.subheadline)
                    .foregroundStyle(theme.colors.onSurface)
            }
        }
    }
}

// MARK: - ViewModifier

/// Applies a full-screen loading overlay as a view modifier.
public struct PrismLoadingOverlayModifier: ViewModifier {
    @Binding var isPresented: Bool
    let label: String?

    public init(isPresented: Binding<Bool>, label: String? = nil) {
        _isPresented = isPresented
        self.label = label
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                PrismLoadingOverlay(isPresented: $isPresented, label: label)
            }
    }
}

// MARK: - View Extension

extension View {
    /// Overlays a full-screen loading indicator that blocks interaction.
    ///
    /// - Parameters:
    ///   - isPresented: Binding that controls overlay visibility.
    ///   - label: Optional status message shown below the spinner.
    public func prismLoadingOverlay(
        isPresented: Binding<Bool>,
        label: String? = nil
    ) -> some View {
        modifier(PrismLoadingOverlayModifier(isPresented: isPresented, label: label))
    }
}
