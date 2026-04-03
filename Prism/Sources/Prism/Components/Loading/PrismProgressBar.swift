// PrismProgressBar.swift
// Prism — Design Theme System
// Horizontal progress indicator driven by theme tokens.

import SwiftUI

// MARK: - Configuration

/// Configuration for PrismProgressBar appearance and behaviour.
public struct PrismProgressBarConfig: Sendable {
    /// Override the track color. Defaults to `theme.colors.surfaceVariant`.
    public var trackColor: Color?
    /// Override the fill color. Defaults to `theme.colors.accent`.
    public var fillColor: Color?
    /// Override the corner radius. Defaults to `theme.cornerRadius.pill`.
    public var cornerRadius: CGFloat?
    /// Height of the bar in points.
    public var height: CGFloat
    /// Whether progress changes are animated.
    public var animated: Bool

    public init(
        trackColor: Color? = nil,
        fillColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        height: CGFloat = 6,
        animated: Bool = true
    ) {
        self.trackColor = trackColor
        self.fillColor = fillColor
        self.cornerRadius = cornerRadius
        self.height = height
        self.animated = animated
    }

    /// Default configuration.
    public static var `default`: Self { Self() }
}

// MARK: - PrismProgressBar

/// A theme-driven horizontal progress bar.
public struct PrismProgressBar: View {
    @Environment(\.prismTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @Binding var progress: Double
    public let configuration: PrismProgressBarConfig

    public init(progress: Binding<Double>, configuration: PrismProgressBarConfig = .default) {
        _progress = progress
        self.configuration = configuration
    }

    public var body: some View {
        let clamped  = min(max(progress, 0), 1)
        let radius   = configuration.cornerRadius ?? theme.cornerRadius.pill
        let track    = configuration.trackColor   ?? theme.colors.surfaceVariant
        let fill     = configuration.fillColor    ?? theme.colors.accent
        let anim: Animation? = (configuration.animated && !reduceMotion) ? theme.animation.easeOut : nil

        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: radius)
                    .fill(track)
                RoundedRectangle(cornerRadius: radius)
                    .fill(fill)
                    .frame(width: geo.size.width * clamped)
                    .animation(anim, value: clamped)
            }
        }
        .frame(height: configuration.height)
        .accessibilityValue(Text("\(Int(clamped * 100)) percent"))
    }
}
