// CustomThemeTests.swift
// Verifies that a fully custom theme conforming to PrismThemeProtocol
// can be created and used via PrismThemeFamily.custom(_:).

import Testing
import SwiftUI
@testable import Prism

// MARK: - Minimal custom token implementations

private struct CustomColors: ColorTokens {
    var primary:         Color { Color(red: 1.0, green: 0.2, blue: 0.2) }
    var onPrimary:       Color { .white }
    var secondary:       Color { Color(red: 0.2, green: 0.8, blue: 0.4) }
    var onSecondary:     Color { .white }
    var accent:          Color { Color(red: 0.9, green: 0.7, blue: 0.1) }
    var background:      Color { Color(red: 0.98, green: 0.98, blue: 0.98) }
    var onBackground:    Color { Color(red: 0.1, green: 0.1, blue: 0.1) }
    var surface:         Color { .white }
    var onSurface:       Color { Color(red: 0.1, green: 0.1, blue: 0.1) }
    var surfaceVariant:  Color { Color(red: 0.93, green: 0.93, blue: 0.93) }
    var error:           Color { Color(red: 0.9, green: 0.1, blue: 0.1) }
    var onError:         Color { .white }
    var success:         Color { Color(red: 0.2, green: 0.7, blue: 0.3) }
    var warning:         Color { Color(red: 1.0, green: 0.6, blue: 0.0) }
    var divider:         Color { Color(red: 0.85, green: 0.85, blue: 0.85) }
    var shadow:          Color { Color(red: 0.0, green: 0.0, blue: 0.0) }
    var overlay:         Color { Color(red: 0.0, green: 0.0, blue: 0.0).opacity(0.3) }
}

private struct CustomTypography: TypographyTokens {
    var caption2:    Font { .system(.caption2) }
    var caption1:    Font { .system(.caption) }
    var footnote:    Font { .system(.footnote) }
    var subheadline: Font { .system(.subheadline) }
    var callout:     Font { .system(.callout) }
    var body:        Font { .system(.body) }
    var headline:    Font { .system(.headline) }
    var title3:      Font { .system(.title3) }
    var title2:      Font { .system(.title2) }
    var title:       Font { .system(.title) }
    var largeTitle:  Font { .system(.largeTitle) }
}

private struct CustomSpacing: SpacingTokens {
    var xxs: CGFloat  { 2 }
    var xs: CGFloat   { 4 }
    var sm: CGFloat   { 8 }
    var md: CGFloat   { 16 }
    var lg: CGFloat   { 24 }
    var xl: CGFloat   { 32 }
    var xxl: CGFloat  { 48 }
    var xxxl: CGFloat { 64 }
}

private struct CustomCornerRadius: CornerRadiusTokens {
    var xsmall: CGFloat { 4 }
    var small:  CGFloat { 8 }
    var medium: CGFloat { 12 }
    var large:  CGFloat { 20 }
    var pill:   CGFloat { 9999 }
}

private struct CustomElevation: ElevationTokens {
    var e0: ElevationLevel { ElevationLevel(color: .black, radius: 0,  x: 0, y: 0,  opacity: 0.00) }
    var e1: ElevationLevel { ElevationLevel(color: .black, radius: 4,  x: 0, y: 2,  opacity: 0.10) }
    var e2: ElevationLevel { ElevationLevel(color: .black, radius: 8,  x: 0, y: 4,  opacity: 0.14) }
    var e3: ElevationLevel { ElevationLevel(color: .black, radius: 12, x: 0, y: 6,  opacity: 0.18) }
    var e4: ElevationLevel { ElevationLevel(color: .black, radius: 16, x: 0, y: 8,  opacity: 0.22) }
    var e5: ElevationLevel { ElevationLevel(color: .black, radius: 24, x: 0, y: 10, opacity: 0.26) }
}

private struct CustomBorder: BorderTokens {
    var subtle:       CGFloat { 0.5 }
    var `default`:    CGFloat { 1.0 }
    var strong:       CGFloat { 2.0 }
    var subtleColor:  Color   { Color(red: 0.85, green: 0.85, blue: 0.85) }
    var defaultColor: Color   { Color(red: 0.6, green: 0.6, blue: 0.6) }
    var strongColor:  Color   { Color(red: 0.2, green: 0.2, blue: 0.2) }
}

private struct CustomOpacity: OpacityTokens {
    var disabled: Double { 0.38 }
    var overlay:  Double { 0.50 }
    var hover:    Double { 0.08 }
    var pressed:  Double { 0.12 }
    var skeleton: Double { 0.15 }
}

private struct CustomIconSize: IconSizeTokens {
    var small:  CGFloat { 16 }
    var medium: CGFloat { 24 }
    var large:  CGFloat { 32 }
    var xlarge: CGFloat { 44 }
}

private struct CustomAnimation: AnimationTokens {
    var fast:   Double { 0.15 }
    var normal: Double { 0.25 }
    var slow:   Double { 0.40 }

    @MainActor var easeIn:   Animation { .easeIn(duration: normal) }
    @MainActor var easeOut:  Animation { .easeOut(duration: normal) }
    @MainActor var spring:   Animation { .spring(response: 0.35, dampingFraction: 0.75) }
    @MainActor var bouncy:   Animation { .spring(response: 0.40, dampingFraction: 0.60) }
    @MainActor var fadeIn:   Animation { .easeIn(duration: slow) }
    @MainActor var scaleUp:  Animation { .spring(response: 0.30, dampingFraction: 0.80) }
    @MainActor var slideIn:  Animation { .easeOut(duration: normal) }
    @MainActor var bounce:   Animation { .spring(response: 0.45, dampingFraction: 0.55) }
    @MainActor var shimmer:  Animation { .linear(duration: 1.5).repeatForever(autoreverses: false) }
}

private struct CustomHaptic: HapticTokens {
    var selection:    HapticFeedbackType { .selection }
    var lightImpact:  HapticFeedbackType {
        #if canImport(UIKit)
        .impact(.light)
        #else
        .none
        #endif
    }
    var mediumImpact: HapticFeedbackType {
        #if canImport(UIKit)
        .impact(.medium)
        #else
        .none
        #endif
    }
    var heavyImpact:  HapticFeedbackType {
        #if canImport(UIKit)
        .impact(.heavy)
        #else
        .none
        #endif
    }
    var success: HapticFeedbackType {
        #if canImport(UIKit)
        .notification(.success)
        #else
        .none
        #endif
    }
    var warning: HapticFeedbackType {
        #if canImport(UIKit)
        .notification(.warning)
        #else
        .none
        #endif
    }
    var error: HapticFeedbackType {
        #if canImport(UIKit)
        .notification(.error)
        #else
        .none
        #endif
    }
}

// MARK: - Minimal custom theme

/// A fully custom theme that satisfies PrismThemeProtocol using bespoke token types.
private struct MinimalCustomTheme: PrismThemeProtocol {
    let variant: PrismVariant
    let liquidGlassEnabled: Bool = false

    init(variant: PrismVariant = .light) {
        self.variant = variant
    }

    var colors:       any ColorTokens        { CustomColors() }
    var typography:   any TypographyTokens   { CustomTypography() }
    var spacing:      any SpacingTokens      { CustomSpacing() }
    var cornerRadius: any CornerRadiusTokens { CustomCornerRadius() }
    var elevation:    any ElevationTokens    { CustomElevation() }
    var border:       any BorderTokens       { CustomBorder() }
    var opacity:      any OpacityTokens      { CustomOpacity() }
    var iconSize:     any IconSizeTokens     { CustomIconSize() }
    var animation:    any AnimationTokens    { CustomAnimation() }
    var haptic:       any HapticTokens       { CustomHaptic() }
}

// MARK: - Tests

@Suite("Custom Theme Conformance")
struct CustomThemeTests {

    @Test("MinimalCustomTheme conforms to PrismThemeProtocol")
    func customThemeConforms() {
        let custom: any PrismThemeProtocol = MinimalCustomTheme(variant: .light)
        #expect(custom.variant == .light)
        #expect(custom.liquidGlassEnabled == false)
    }

    @Test("PrismThemeFamily.custom resolves to the injected theme")
    func customFamilyResolvesToInjectedTheme() {
        let customTheme = MinimalCustomTheme(variant: .dark)
        let resolved = PrismThemeFamily.custom(customTheme).resolve()
        #expect(resolved.variant == .dark)
        #expect(resolved is MinimalCustomTheme)
    }

    @Test("Custom theme tokens are accessible without crashing")
    func customThemeTokensAccessible() {
        let theme: any PrismThemeProtocol = MinimalCustomTheme(variant: .tinted)
        _ = theme.colors.primary
        _ = theme.typography.headline
        _ = theme.spacing.md
        _ = theme.cornerRadius.large
        _ = theme.elevation.e3
        _ = theme.border.default
        _ = theme.opacity.disabled
        _ = theme.iconSize.medium
        _ = theme.animation.fast
        _ = theme.haptic.selection
    }

    @Test("Custom theme primary color is not .clear")
    func customThemePrimaryNotClear() {
        let theme: any PrismThemeProtocol = MinimalCustomTheme()
        #expect(theme.colors.primary != .clear)
    }

    @Test("Custom theme spacing tokens are positive")
    func customThemeSpacingPositive() {
        let s = MinimalCustomTheme().spacing
        #expect(s.xxs > 0)
        #expect(s.xs > 0)
        #expect(s.sm > 0)
        #expect(s.md > 0)
        #expect(s.lg > 0)
        #expect(s.xl > 0)
        #expect(s.xxl > 0)
        #expect(s.xxxl > 0)
    }

    @Test("Custom theme elevation radius is non-decreasing")
    func customThemeElevationOrdered() {
        let e = MinimalCustomTheme().elevation
        #expect(e.e0.radius <= e.e1.radius)
        #expect(e.e1.radius <= e.e2.radius)
        #expect(e.e2.radius <= e.e3.radius)
        #expect(e.e3.radius <= e.e4.radius)
        #expect(e.e4.radius <= e.e5.radius)
    }

    @Test("Custom theme supports all PrismVariant values")
    func customThemeSupportsAllVariants() {
        for variant in PrismVariant.allCases {
            let theme = MinimalCustomTheme(variant: variant)
            #expect(theme.variant == variant)
        }
    }
}
