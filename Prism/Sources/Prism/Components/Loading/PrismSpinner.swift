// PrismSpinner.swift
// Prism — Design Theme System
// Animated loading spinner with ring, dots, and pulse styles.

import SwiftUI

// MARK: - Style

/// Visual style for PrismSpinner.
public enum PrismSpinnerStyle: Sendable {
    /// Rotating partial arc stroke.
    case ring
    /// Three circles with staggered bounce.
    case dots
    /// Filled circle that scales in and out.
    case pulse
}

// MARK: - Size

/// Predefined sizes for PrismSpinner.
public enum PrismSpinnerSize: Sendable {
    case small   // 20pt
    case medium  // 36pt
    case large   // 56pt

    var dimension: CGFloat {
        switch self {
        case .small:  20
        case .medium: 36
        case .large:  56
        }
    }
}

// MARK: - PrismSpinner

/// A theme-driven animated loading spinner.
public struct PrismSpinner: View {
    @Environment(\.prismTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var isAnimating = false

    public let style: PrismSpinnerStyle
    public let size: PrismSpinnerSize

    public init(style: PrismSpinnerStyle = .ring, size: PrismSpinnerSize = .medium) {
        self.style = style
        self.size = size
    }

    public var body: some View {
        Group {
            switch style {
            case .ring:  ringView
            case .dots:  dotsView
            case .pulse: pulseView
            }
        }
        .accessibilityLabel("Loading")
        .onAppear {
            guard !reduceMotion else { return }
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }

    // MARK: - Private

    private var dim: CGFloat { size.dimension }

    @ViewBuilder
    private var ringView: some View {
        let strokeWidth = max(dim * 0.1, 2)
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(
                theme.colors.accent,
                style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
            )
            .frame(width: dim, height: dim)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                reduceMotion ? nil : .linear(duration: 1.0).repeatForever(autoreverses: false),
                value: isAnimating
            )
    }

    @ViewBuilder
    private var dotsView: some View {
        let dotSize = dim * 0.22
        let bounce  = dim * 0.25
        HStack(spacing: dim * 0.18) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(theme.colors.accent)
                    .frame(width: dotSize, height: dotSize)
                    .offset(y: isAnimating ? -bounce : 0)
                    .animation(
                        reduceMotion ? nil : .easeInOut(duration: 0.45)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.15),
                        value: isAnimating
                    )
            }
        }
        .frame(width: dim, height: dim)
    }

    @ViewBuilder
    private var pulseView: some View {
        Circle()
            .fill(theme.colors.accent)
            .frame(width: dim, height: dim)
            .scaleEffect(isAnimating ? 1.0 : (reduceMotion ? 1.0 : 0.6))
            .animation(
                reduceMotion ? nil : .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
}
