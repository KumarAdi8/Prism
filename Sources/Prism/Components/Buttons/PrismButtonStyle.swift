// PrismButtonStyle.swift
// Prism — Design Theme System
// Button styles driven by theme color, spacing, corner radius, and haptic tokens.

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Variant

/// Prism button style variants.
public enum PrismButtonVariant: Sendable {
    case primary
    case secondary
    case destructive
}

// MARK: - Unified ButtonStyle

/// A theme-driven button style that adapts its appearance based on the variant.
public struct PrismButtonStyle: ButtonStyle {
    @Environment(\.prismTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    let variant: PrismButtonVariant

    public init(variant: PrismButtonVariant) {
        self.variant = variant
    }

    public func makeBody(configuration: Configuration) -> some View {
        let colors = buttonColors
        return configuration.label
            .font(theme.typography.headline)
            .foregroundStyle(colors.foreground)
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.sm)
            .background(colors.background, in: RoundedRectangle(cornerRadius: theme.cornerRadius.pill))
            .overlay {
                if variant == .secondary {
                    RoundedRectangle(cornerRadius: theme.cornerRadius.pill)
                        .strokeBorder(colors.border, lineWidth: theme.border.default)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius.pill)
                    .fill(Color.black.opacity(configuration.isPressed ? theme.opacity.pressed : 0))
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(isEnabled ? 1.0 : theme.opacity.disabled)
            .animation(.easeOut(duration: theme.animation.fast), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed { triggerHaptic(hapticType) }
            }
    }

    private var buttonColors: (foreground: Color, background: Color, border: Color) {
        switch variant {
        case .primary:
            (theme.colors.onPrimary, theme.colors.primary, .clear)
        case .secondary:
            (theme.colors.primary, theme.colors.surface, theme.colors.primary)
        case .destructive:
            (theme.colors.onError, theme.colors.error, .clear)
        }
    }

    private var hapticType: HapticFeedbackType {
        switch variant {
        case .primary:     theme.haptic.lightImpact
        case .secondary:   theme.haptic.selection
        case .destructive: theme.haptic.mediumImpact
        }
    }
}

// MARK: - View extension

extension View {
    /// Applies a Prism themed button style to the view.
    public func prismButtonStyle(_ variant: PrismButtonVariant) -> some View {
        buttonStyle(PrismButtonStyle(variant: variant))
    }
}
