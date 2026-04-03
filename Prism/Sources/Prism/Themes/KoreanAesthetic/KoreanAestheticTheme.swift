// KoreanAestheticTheme.swift
// Prism — Korean Aesthetic Theme
// Root theme struct + all supporting token implementations.
// "Soft pastels, rounded forms, airy whitespace"

import SwiftUI

// MARK: - Spacing

/// Standard 4-point grid spacing tokens.
public struct KoreanAestheticSpacing: SpacingTokens {
    public init() {}
    public var xxs: CGFloat  { 2 }
    public var xs: CGFloat   { 4 }
    public var sm: CGFloat   { 8 }
    public var md: CGFloat   { 16 }
    public var lg: CGFloat   { 24 }
    public var xl: CGFloat   { 32 }
    public var xxl: CGFloat  { 48 }
    public var xxxl: CGFloat { 64 }
}

// MARK: - Corner Radius

/// Corner radius tokens with larger values for the Korean Aesthetic's rounded feel.
public struct KoreanAestheticCornerRadius: CornerRadiusTokens {
    public init() {}
    public var xsmall: CGFloat { 6 }
    public var small: CGFloat  { 12 }
    public var medium: CGFloat { 16 }
    public var large: CGFloat  { 24 }
    public var pill: CGFloat   { 9999 }
}

// MARK: - Elevation

/// Soft, diffuse shadow elevation tokens matching the airy Korean Aesthetic.
public struct KoreanAestheticElevation: ElevationTokens {

    public let variant: PrismVariant

    public init(variant: PrismVariant) {
        self.variant = variant
    }

    private var shadowColor: Color {
        switch variant {
        case .light, .tinted: Color(red: 0.239, green: 0.169, blue: 0.122) // warm brown
        case .dark:           Color(red: 0.000, green: 0.000, blue: 0.063) // near-black
        }
    }

    public var e0: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 0,  x: 0, y: 0, opacity: 0.00)
    }
    public var e1: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 4,  x: 0, y: 1, opacity: 0.06)
    }
    public var e2: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 8,  x: 0, y: 2, opacity: 0.08)
    }
    public var e3: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 12, x: 0, y: 4, opacity: 0.10)
    }
    public var e4: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 16, x: 0, y: 6, opacity: 0.12)
    }
    public var e5: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 24, x: 0, y: 8, opacity: 0.14)
    }
}

// MARK: - Border

/// Border stroke and color tokens derived from the active variant's palette.
public struct KoreanAestheticBorder: BorderTokens {

    public let variant: PrismVariant

    public init(variant: PrismVariant) {
        self.variant = variant
    }

    public var subtle: CGFloat  { 0.5 }
    public var `default`: CGFloat { 1.0 }
    public var strong: CGFloat  { 2.0 }

    public var subtleColor: Color {
        switch variant {
        case .light:  Color(red: 0.910, green: 0.867, blue: 0.835) // matches divider
        case .dark:   Color(red: 0.227, green: 0.231, blue: 0.329)
        case .tinted: Color(red: 0.929, green: 0.847, blue: 0.812)
        }
    }

    public var defaultColor: Color {
        switch variant {
        case .light:  Color(red: 0.851, green: 0.800, blue: 0.769)
        case .dark:   Color(red: 0.310, green: 0.314, blue: 0.424)
        case .tinted: Color(red: 0.878, green: 0.796, blue: 0.757)
        }
    }

    public var strongColor: Color {
        switch variant {
        case .light:  Color(red: 0.910, green: 0.627, blue: 0.749) // primary soft rose
        case .dark:   Color(red: 0.831, green: 0.514, blue: 0.608) // primary dusty rose
        case .tinted: Color(red: 0.910, green: 0.565, blue: 0.502) // primary coral
        }
    }
}

// MARK: - Opacity

/// Standard opacity tokens for UI state representation.
public struct KoreanAestheticOpacity: OpacityTokens {
    public init() {}
    public var disabled: Double { 0.38 }
    public var overlay: Double  { 0.54 }
    public var hover: Double    { 0.08 }
    public var pressed: Double  { 0.12 }
    public var skeleton: Double { 0.14 }
}

// MARK: - Icon Size

/// Standard icon size tokens.
public struct KoreanAestheticIconSize: IconSizeTokens {
    public init() {}
    public var small: CGFloat  { 16 }
    public var medium: CGFloat { 24 }
    public var large: CGFloat  { 32 }
    public var xlarge: CGFloat { 44 }
}

// MARK: - Animation

/// Animation tokens with gentle, slightly slower curves for the Korean Aesthetic's calm mood.
public struct KoreanAestheticAnimation: AnimationTokens {

    public init() {}

    // Durations — slightly slower than default for a more graceful feel
    public var fast: Double   { 0.20 }
    public var normal: Double { 0.35 }
    public var slow: Double   { 0.55 }

    // Curves — all @MainActor because SwiftUI.Animation is not Sendable
    @MainActor public var easeIn: Animation   { .easeIn(duration: fast) }
    @MainActor public var easeOut: Animation  { .easeOut(duration: normal) }
    @MainActor public var spring: Animation   { .spring(duration: normal, bounce: 0.2) }
    @MainActor public var bouncy: Animation   { .spring(duration: normal, bounce: 0.45) }
    @MainActor public var fadeIn: Animation   { .easeIn(duration: slow) }
    @MainActor public var scaleUp: Animation  { .spring(duration: fast, bounce: 0.3) }
    @MainActor public var slideIn: Animation  { .easeOut(duration: normal) }
    @MainActor public var bounce: Animation   { .spring(duration: slow, bounce: 0.6) }
    @MainActor public var shimmer: Animation  {
        .easeInOut(duration: slow).repeatForever(autoreverses: true)
    }
}

// MARK: - Haptic

/// Haptic feedback tokens with conditional UIKit compilation.
public struct KoreanAestheticHaptic: HapticTokens {

    public init() {}

    public var selection: HapticFeedbackType { .selection }

    public var lightImpact: HapticFeedbackType {
        #if canImport(UIKit)
        .impact(.light)
        #else
        .none
        #endif
    }

    public var mediumImpact: HapticFeedbackType {
        #if canImport(UIKit)
        .impact(.medium)
        #else
        .none
        #endif
    }

    public var heavyImpact: HapticFeedbackType {
        #if canImport(UIKit)
        .impact(.heavy)
        #else
        .none
        #endif
    }

    public var success: HapticFeedbackType {
        #if canImport(UIKit)
        .notification(.success)
        #else
        .none
        #endif
    }

    public var warning: HapticFeedbackType {
        #if canImport(UIKit)
        .notification(.warning)
        #else
        .none
        #endif
    }

    public var error: HapticFeedbackType {
        #if canImport(UIKit)
        .notification(.error)
        #else
        .none
        #endif
    }
}

// MARK: - Theme

/// The Korean Aesthetic Prism theme.
/// Evokes hanok architecture — soft pastels, rounded forms, and airy whitespace.
public struct KoreanAestheticTheme: PrismThemeProtocol {

    public let variant: PrismVariant
    public let liquidGlassEnabled: Bool = false

    public init(variant: PrismVariant = .light) {
        self.variant = variant
    }

    public var colors: any ColorTokens       { KoreanAestheticColors(variant: variant) }
    public var typography: any TypographyTokens { KoreanAestheticTypography() }
    public var spacing: any SpacingTokens    { KoreanAestheticSpacing() }
    public var cornerRadius: any CornerRadiusTokens { KoreanAestheticCornerRadius() }
    public var elevation: any ElevationTokens { KoreanAestheticElevation(variant: variant) }
    public var border: any BorderTokens      { KoreanAestheticBorder(variant: variant) }
    public var opacity: any OpacityTokens    { KoreanAestheticOpacity() }
    public var iconSize: any IconSizeTokens  { KoreanAestheticIconSize() }
    public var animation: any AnimationTokens { KoreanAestheticAnimation() }
    public var haptic: any HapticTokens      { KoreanAestheticHaptic() }
}
