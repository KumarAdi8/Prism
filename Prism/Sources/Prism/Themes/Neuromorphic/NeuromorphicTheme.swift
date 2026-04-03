// NeuromorphicTheme.swift
// Prism — Design Theme System
// Neumorphic theme: soft shadows, extruded surfaces, muted palette.

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Spacing

private struct NeuromorphicSpacing: SpacingTokens {
    let xxs:  CGFloat = 2
    let xs:   CGFloat = 4
    let sm:   CGFloat = 8
    let md:   CGFloat = 16
    let lg:   CGFloat = 24
    let xl:   CGFloat = 32
    let xxl:  CGFloat = 48
    let xxxl: CGFloat = 64
}

// MARK: - Corner Radius

/// Generous rounding reinforces the soft, touchable neumorphic aesthetic.
private struct NeuromorphicCornerRadius: CornerRadiusTokens {
    let xsmall: CGFloat = 8
    let small:  CGFloat = 12
    let medium: CGFloat = 16
    let large:  CGFloat = 24
    let pill:   CGFloat = 9999
}

// MARK: - Elevation

/// Neumorphic elevation uses the dark shadow of the shadow pair.
/// Shadows are soft and diffuse (large radius, small offset) so elements
/// appear extruded from the surface rather than hovering above it.
private struct NeuromorphicElevation: ElevationTokens {
    private let shadowColor: Color

    init(variant: PrismVariant) {
        switch variant {
        case .light:  shadowColor = Color(red: 0.64, green: 0.69, blue: 0.78)  // #A3B1C6
        case .dark:   shadowColor = Color(red: 0.10, green: 0.11, blue: 0.14)  // #1A1D24
        case .tinted: shadowColor = Color(red: 0.75, green: 0.71, blue: 0.65)  // #BFB5A5
        }
    }

    var e0: ElevationLevel { ElevationLevel(color: shadowColor, radius: 0,  x: 0,  y: 0,  opacity: 0.0) }
    var e1: ElevationLevel { ElevationLevel(color: shadowColor, radius: 5,  x: 3,  y: 3,  opacity: 0.20) }
    var e2: ElevationLevel { ElevationLevel(color: shadowColor, radius: 8,  x: 5,  y: 5,  opacity: 0.25) }
    var e3: ElevationLevel { ElevationLevel(color: shadowColor, radius: 12, x: 7,  y: 7,  opacity: 0.30) }
    var e4: ElevationLevel { ElevationLevel(color: shadowColor, radius: 16, x: 9,  y: 9,  opacity: 0.35) }
    var e5: ElevationLevel { ElevationLevel(color: shadowColor, radius: 20, x: 12, y: 12, opacity: 0.40) }
}

// MARK: - Border

/// Neumorphic UI relies almost entirely on shadows rather than borders.
private struct NeuromorphicBorder: BorderTokens {
    private let variant: PrismVariant

    init(variant: PrismVariant) { self.variant = variant }

    let subtle:  CGFloat = 0.0
    let `default`: CGFloat = 0.5
    let strong:  CGFloat = 1.0

    var subtleColor: Color {
        switch variant {
        case .light:  Color(red: 0.78, green: 0.80, blue: 0.84).opacity(0.0)
        case .dark:   Color(red: 0.28, green: 0.30, blue: 0.35).opacity(0.0)
        case .tinted: Color(red: 0.80, green: 0.77, blue: 0.72).opacity(0.0)
        }
    }

    var defaultColor: Color {
        switch variant {
        case .light:  Color(red: 0.78, green: 0.80, blue: 0.84).opacity(0.3)
        case .dark:   Color(red: 0.28, green: 0.30, blue: 0.35).opacity(0.3)
        case .tinted: Color(red: 0.80, green: 0.77, blue: 0.72).opacity(0.3)
        }
    }

    var strongColor: Color {
        switch variant {
        case .light:  Color(red: 0.64, green: 0.69, blue: 0.78)
        case .dark:   Color(red: 0.42, green: 0.45, blue: 0.52)
        case .tinted: Color(red: 0.75, green: 0.71, blue: 0.65)
        }
    }
}

// MARK: - Opacity

private struct NeuromorphicOpacity: OpacityTokens {
    let disabled: Double = 0.38
    let overlay:  Double = 0.60
    let hover:    Double = 0.08
    let pressed:  Double = 0.12
    let skeleton: Double = 0.15
}

// MARK: - Icon Size

private struct NeuromorphicIconSize: IconSizeTokens {
    let small:  CGFloat = 16
    let medium: CGFloat = 24
    let large:  CGFloat = 32
    let xlarge: CGFloat = 44
}

// MARK: - Animation

/// Neumorphic animations are smooth and slightly slow, matching the tactile,
/// physical quality of soft UI — no snap, all ease.
private struct NeuromorphicAnimation: AnimationTokens {
    let fast:   Double = 0.20
    let normal: Double = 0.35
    let slow:   Double = 0.50

    @MainActor var easeIn:   Animation { .easeIn(duration: normal) }
    @MainActor var easeOut:  Animation { .easeOut(duration: normal) }
    @MainActor var spring:   Animation { .spring(response: 0.45, dampingFraction: 0.82) }
    @MainActor var bouncy:   Animation { .spring(response: 0.50, dampingFraction: 0.70) }
    @MainActor var fadeIn:   Animation { .easeIn(duration: slow) }
    @MainActor var scaleUp:  Animation { .spring(response: 0.40, dampingFraction: 0.80) }
    @MainActor var slideIn:  Animation { .easeOut(duration: normal) }
    @MainActor var bounce:   Animation { .spring(response: 0.55, dampingFraction: 0.60) }
    @MainActor var shimmer:  Animation { .linear(duration: 1.4).repeatForever(autoreverses: false) }
}

// MARK: - Haptic

private struct NeuromorphicHaptic: HapticTokens {
    var selection: HapticFeedbackType { .selection }

    var lightImpact: HapticFeedbackType {
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

    var heavyImpact: HapticFeedbackType {
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

// MARK: - Theme

/// Neumorphic theme: soft shadows, extruded surfaces, muted palette.
///
/// Neumorphism (soft UI) creates the illusion of physical depth by pairing a
/// light highlight shadow (top-left) with a dark shadow (bottom-right), both
/// using the same hue as the background. `NeuromorphicTheme` supplies the dark
/// shadow component via `ElevationTokens` and exposes the highlight via the
/// `shadow` color token (white or near-white equivalent).
///
/// `liquidGlassEnabled` is `false` — neumorphic depth competes with glass blur.
public struct NeuromorphicTheme: PrismThemeProtocol {

    public let variant: PrismVariant

    public init(variant: PrismVariant = .light) {
        self.variant = variant
    }

    public let liquidGlassEnabled: Bool = false

    public var colors:       any ColorTokens        { NeuromorphicColors(variant: variant) }
    public var typography:   any TypographyTokens   { NeuromorphicTypography() }
    public var spacing:      any SpacingTokens      { NeuromorphicSpacing() }
    public var cornerRadius: any CornerRadiusTokens { NeuromorphicCornerRadius() }
    public var elevation:    any ElevationTokens    { NeuromorphicElevation(variant: variant) }
    public var border:       any BorderTokens       { NeuromorphicBorder(variant: variant) }
    public var opacity:      any OpacityTokens      { NeuromorphicOpacity() }
    public var iconSize:     any IconSizeTokens     { NeuromorphicIconSize() }
    public var animation:    any AnimationTokens    { NeuromorphicAnimation() }
    public var haptic:       any HapticTokens       { NeuromorphicHaptic() }
}
