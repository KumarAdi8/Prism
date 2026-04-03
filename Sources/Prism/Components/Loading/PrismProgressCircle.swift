// PrismProgressCircle.swift
// Prism — Design Theme System
// Circular progress indicator drawn with trim arcs and theme tokens.

import SwiftUI

// MARK: - PrismProgressCircle

/// A theme-driven circular progress indicator.
public struct PrismProgressCircle: View {
    @Environment(\.prismTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @Binding var progress: Double
    public let size: CGFloat
    public let lineWidth: CGFloat

    public init(progress: Binding<Double>, size: CGFloat = 64, lineWidth: CGFloat = 6) {
        _progress = progress
        self.size = size
        self.lineWidth = lineWidth
    }

    public var body: some View {
        let clamped = min(max(progress, 0), 1)
        let anim: Animation? = reduceMotion ? nil : theme.animation.easeOut

        ZStack {
            // Track ring
            Circle()
                .stroke(
                    theme.colors.surfaceVariant,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )

            // Progress arc
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(
                    theme.colors.accent,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(anim, value: clamped)
        }
        .frame(width: size, height: size)
        .accessibilityValue(Text("\(Int(clamped * 100)) percent"))
    }
}
