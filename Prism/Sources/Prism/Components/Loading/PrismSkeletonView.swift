// PrismSkeletonView.swift
// Prism — Design Theme System
// Shimmer placeholder view for content loading states.

import SwiftUI

// MARK: - PrismSkeletonView

/// A skeleton shimmer placeholder. Size and corner radius are applied externally
/// via `.frame()` and `.clipShape()` / `.cornerRadius()`.
public struct PrismSkeletonView: View {
    @Environment(\.prismTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var isShimmering = false

    public init() {}

    public var body: some View {
        // Access @MainActor animation token in body context.
        let shimmerAnim: Animation? = reduceMotion
            ? nil
            : theme.animation.shimmer.repeatForever(autoreverses: false)

        Rectangle()
            .fill(theme.colors.surfaceVariant.opacity(theme.opacity.skeleton))
            .overlay {
                if !reduceMotion {
                    GeometryReader { geo in
                        let width = geo.size.width
                        LinearGradient(
                            stops: [
                                .init(color: .clear,                location: 0.0),
                                .init(color: .white.opacity(0.35), location: 0.35),
                                .init(color: .white.opacity(0.55), location: 0.50),
                                .init(color: .white.opacity(0.35), location: 0.65),
                                .init(color: .clear,                location: 1.0),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .offset(x: isShimmering ? width : -width)
                        .animation(shimmerAnim, value: isShimmering)
                        .allowsHitTesting(false)
                    }
                    .clipped()
                }
            }
            .onAppear { isShimmering = true }
            .onDisappear { isShimmering = false }
            .accessibilityLabel("Loading")
    }
}
