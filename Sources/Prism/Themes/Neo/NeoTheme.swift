// NeoTheme.swift
// Prism — Neo Theme
// Root theme composition for Neo — bold primaries, sharp geometry, high contrast.

import SwiftUI

// MARK: - Spacing

/// Standard 4pt grid spacing for the Neo theme.
public struct NeoSpacing: SpacingTokens {
    public init() {}
    public let xxs:  CGFloat = 2
    public let xs:   CGFloat = 4
    public let sm:   CGFloat = 8
    public let md:   CGFloat = 16
    public let lg:   CGFloat = 24
    public let xl:   CGFloat = 32
    public let xxl:  CGFloat = 48
    public let xxxl: CGFloat = 64
}

// MARK: - Corner Radius

/// Sharp, angular corner radii for the Neo theme.
/// Values are intentionally small to reinforce neo-brutalist geometry.
public struct NeoCornerRadius: CornerRadiusTokens {
    public init() {}
    public let xsmall: CGFloat = 2
    public let small:  CGFloat = 4
    public let medium: CGFloat = 6
    public let large:  CGFloat = 8
    public let pill:   CGFloat = 9999
}

// MARK: - Elevation

/// Sharp, high-contrast elevation shadows for the Neo theme.
/// Minimal blur radius with stronger offsets for a hard-edged, graphic look.
public struct NeoElevation: ElevationTokens {

    private let shadowColor: Color

    public init(variant: PrismVariant) {
        switch variant {
        case .dark:
            // Slightly cool-tinted black shadow reads on very dark surfaces
            shadowColor = Color(red: 0, green: 0, blue: 0.08)
        case .light, .tinted:
            shadowColor = .black
        }
    }

    public var e0: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 0, x: 0, y: 0, opacity: 0.00)
    }
    public var e1: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 1, x: 1, y: 1, opacity: 0.15)
    }
    public var e2: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 2, x: 2, y: 2, opacity: 0.20)
    }
    public var e3: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 3, x: 3, y: 3, opacity: 0.25)
    }
    public var e4: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 4, x: 4, y: 4, opacity: 0.30)
    }
    public var e5: ElevationLevel {
        ElevationLevel(color: shadowColor, radius: 6, x: 5, y: 5, opacity: 0.35)
    }
}

// MARK: - Border

/// Thick, graphic border tokens for the Neo theme.
/// Bold default and strong widths reinforce the neo-brutalist aesthetic.
public struct NeoBorder: BorderTokens {

    private let variant: PrismVariant

    public init(variant: PrismVariant) {
        self.variant = variant
    }

    public let subtle:   CGFloat = 1.0
    public let `default`: CGFloat = 2.0
    public let strong:   CGFloat = 3.0

    public var subtleColor: Color {
        switch variant {
        case .light:  return Color(red: 0.867, green: 0.867, blue: 0.867)  // #DDDDDD
        case .dark:   return Color(red: 0.173, green: 0.173, blue: 0.173)  // #2C2C2C
        case .tinted: return Color(red: 0.659, green: 0.706, blue: 1.000)  // #A8B4FF
        }
    }

    public var defaultColor: Color {
        switch variant {
        case .light, .tinted: return .black
        case .dark:           return Color(red: 0.933, green: 0.933, blue: 0.933)  // #EEEEEE
        }
    }

    public var strongColor: Color {
        switch variant {
        case .light, .tinted: return .black
        case .dark:           return .white
        }
    }
}

// MARK: - Opacity

/// Standard opacity tokens for the Neo theme.
public struct NeoOpacity: OpacityTokens {
    public init() {}
    public let disabled: Double = 0.38
    public let overlay:  Double = 0.50
    public let hover:    Double = 0.08
    public let pressed:  Double = 0.16
    public let skeleton: Double = 0.12
}

// MARK: - Icon Size

/// Standard icon sizes for the Neo theme.
public struct NeoIconSize: IconSizeTokens {
    public init() {}
    public let small:  CGFloat = 16
    public let medium: CGFloat = 24
    public let large:  CGFloat = 32
    public let xlarge: CGFloat = 44
}

// MARK: - Animation

/// Snappy, fast animation tokens for the Neo theme.
/// Short durations and responsive springs reinforce the sharp, decisive character.
public struct NeoAnimation: AnimationTokens {

    public init() {}

    public let fast:   Double = 0.10
    public let normal: Double = 0.20
    public let slow:   Double = 0.35

    @MainActor public var easeIn:   Animation { .easeIn(duration: normal) }
    @MainActor public var easeOut:  Animation { .easeOut(duration: normal) }
    @MainActor public var spring:   Animation { .spring(response: fast,   dampingFraction: 0.7) }
    @MainActor public var bouncy:   Animation { .spring(response: normal, dampingFraction: 0.5) }
    @MainActor public var fadeIn:   Animation { .easeIn(duration: slow) }
    @MainActor public var scaleUp:  Animation { .spring(response: fast,   dampingFraction: 0.8) }
    @MainActor public var slideIn:  Animation { .easeOut(duration: normal) }
    @MainActor public var bounce:   Animation { .spring(response: normal, dampingFraction: 0.4) }
    @MainActor public var shimmer:  Animation { .linear(duration: 1.2).repeatForever(autoreverses: false) }
}

// MARK: - Haptic

/// Semantic haptic feedback tokens for the Neo theme.
public struct NeoHaptic: HapticTokens {

    public init() {}

    public var selection: HapticFeedbackType { .selection }

    public var lightImpact: HapticFeedbackType {
        #if canImport(UIKit)
        return .impact(.light)
        #else
        return .none
        #endif
    }

    public var mediumImpact: HapticFeedbackType {
        #if canImport(UIKit)
        return .impact(.medium)
        #else
        return .none
        #endif
    }

    public var heavyImpact: HapticFeedbackType {
        #if canImport(UIKit)
        return .impact(.heavy)
        #else
        return .none
        #endif
    }

    public var success: HapticFeedbackType {
        #if canImport(UIKit)
        return .notification(.success)
        #else
        return .none
        #endif
    }

    public var warning: HapticFeedbackType {
        #if canImport(UIKit)
        return .notification(.warning)
        #else
        return .none
        #endif
    }

    public var error: HapticFeedbackType {
        #if canImport(UIKit)
        return .notification(.error)
        #else
        return .none
        #endif
    }
}

// MARK: - NeoTheme

/// The Neo theme — bold primaries, sharp geometry, high contrast.
///
/// Neo draws from neo-brutalist and Memphis design: pure colours, angular radii,
/// thick borders, and snappy animations for a striking, decisive UI character.
public struct NeoTheme: PrismThemeProtocol {

    public let variant: PrismVariant
    public let liquidGlassEnabled: Bool = false

    public init(variant: PrismVariant = .light) {
        self.variant = variant
    }

    public var colors:       any ColorTokens      { NeoColors(variant: variant) }
    public var typography:   any TypographyTokens  { NeoTypography() }
    public var spacing:      any SpacingTokens     { NeoSpacing() }
    public var cornerRadius: any CornerRadiusTokens { NeoCornerRadius() }
    public var elevation:    any ElevationTokens   { NeoElevation(variant: variant) }
    public var border:       any BorderTokens      { NeoBorder(variant: variant) }
    public var opacity:      any OpacityTokens     { NeoOpacity() }
    public var iconSize:     any IconSizeTokens    { NeoIconSize() }
    public var animation:    any AnimationTokens   { NeoAnimation() }
    public var haptic:       any HapticTokens      { NeoHaptic() }
}
