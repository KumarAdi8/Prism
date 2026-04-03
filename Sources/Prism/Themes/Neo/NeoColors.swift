// NeoColors.swift
// Prism — Neo Theme
// Color tokens for Neo — bold primaries, sharp geometry, high contrast.

import SwiftUI

/// Color tokens for the Neo theme.
///
/// Light:   Pure white base, bold blue primary, vibrant red secondary, electric yellow accent.
/// Dark:    Pure black base, electric blue primary, hot pink secondary, neon green accent.
/// Tinted:  Blue-tinted off-white base, deep indigo primary, magenta secondary, orange accent.
public struct NeoColors: ColorTokens {

    private let variant: PrismVariant

    public init(variant: PrismVariant) {
        self.variant = variant
    }

    // MARK: - Helper

    private static func rgb(_ r: Double, _ g: Double, _ b: Double) -> Color {
        Color(red: r / 255, green: g / 255, blue: b / 255)
    }

    // MARK: - Primary

    public var primary: Color {
        switch variant {
        case .light:  return NeoColors.rgb(0, 85, 255)    // #0055FF
        case .dark:   return NeoColors.rgb(51, 136, 255)  // #3388FF
        case .tinted: return NeoColors.rgb(61, 59, 255)   // #3D3BFF
        }
    }

    public var onPrimary: Color { .white }

    // MARK: - Secondary

    public var secondary: Color {
        switch variant {
        case .light:  return NeoColors.rgb(255, 45, 85)   // #FF2D55
        case .dark:   return NeoColors.rgb(255, 55, 95)   // #FF375F
        case .tinted: return NeoColors.rgb(255, 45, 146)  // #FF2D92
        }
    }

    public var onSecondary: Color { .white }

    // MARK: - Accent

    public var accent: Color {
        switch variant {
        case .light:  return NeoColors.rgb(255, 214, 10)  // #FFD60A
        case .dark:   return NeoColors.rgb(48, 209, 88)   // #30D158
        case .tinted: return NeoColors.rgb(255, 149, 0)   // #FF9500
        }
    }

    // MARK: - Background

    public var background: Color {
        switch variant {
        case .light:  return NeoColors.rgb(255, 255, 255)  // #FFFFFF
        case .dark:   return NeoColors.rgb(0, 0, 0)        // #000000
        case .tinted: return NeoColors.rgb(240, 244, 255)  // #F0F4FF
        }
    }

    public var onBackground: Color {
        switch variant {
        case .light:  return .black
        case .dark:   return .white
        case .tinted: return NeoColors.rgb(13, 13, 26)     // #0D0D1A
        }
    }

    // MARK: - Surface

    public var surface: Color {
        switch variant {
        case .light:  return NeoColors.rgb(250, 250, 250)  // #FAFAFA
        case .dark:   return NeoColors.rgb(15, 15, 15)     // #0F0F0F
        case .tinted: return NeoColors.rgb(232, 238, 255)  // #E8EEFF
        }
    }

    public var onSurface: Color {
        switch variant {
        case .light:  return .black
        case .dark:   return .white
        case .tinted: return NeoColors.rgb(13, 13, 26)     // #0D0D1A
        }
    }

    public var surfaceVariant: Color {
        switch variant {
        case .light:  return NeoColors.rgb(238, 238, 238)  // #EEEEEE
        case .dark:   return NeoColors.rgb(26, 26, 26)     // #1A1A1A
        case .tinted: return NeoColors.rgb(212, 221, 255)  // #D4DDFF
        }
    }

    // MARK: - Semantic

    public var error: Color {
        switch variant {
        case .light, .tinted: return NeoColors.rgb(255, 59, 48)  // #FF3B30
        case .dark:           return NeoColors.rgb(255, 69, 58)  // #FF453A
        }
    }

    public var onError: Color { .white }

    public var success: Color {
        switch variant {
        case .light, .tinted: return NeoColors.rgb(52, 199, 89)  // #34C759
        case .dark:           return NeoColors.rgb(48, 209, 88)  // #30D158
        }
    }

    public var warning: Color {
        switch variant {
        case .light:  return NeoColors.rgb(255, 149, 0)   // #FF9500
        case .dark:   return NeoColors.rgb(255, 214, 10)  // #FFD60A
        case .tinted: return NeoColors.rgb(255, 107, 0)   // #FF6B00
        }
    }

    // MARK: - Chrome

    public var divider: Color {
        switch variant {
        case .light:  return NeoColors.rgb(224, 224, 224)  // #E0E0E0
        case .dark:   return NeoColors.rgb(42, 42, 42)     // #2A2A2A
        case .tinted: return NeoColors.rgb(192, 203, 255)  // #C0CBFF
        }
    }

    public var shadow: Color { .black }

    public var overlay: Color {
        switch variant {
        case .light, .tinted: return Color(red: 0, green: 0, blue: 0).opacity(0.50)
        case .dark:           return Color(red: 0, green: 0, blue: 0).opacity(0.70)
        }
    }
}
