// NeuromorphicColors.swift
// Prism — Design Theme System
// Neumorphic color tokens: soft gray palette with shadow-pair elevations.

import SwiftUI

/// Neumorphic color tokens. Surfaces match the background so shadows create
/// the illusion of extruded or debossed elements.
public struct NeuromorphicColors: ColorTokens {

    private let variant: PrismVariant

    public init(variant: PrismVariant) {
        self.variant = variant
    }

    // MARK: - Primary

    public var primary: Color {
        switch variant {
        case .light:   Color(hex: 0x6B8CC5)
        case .dark:    Color(hex: 0x5A7FB8)
        case .tinted:  Color(hex: 0xA38B6E)
        }
    }

    public var onPrimary: Color {
        switch variant {
        case .light:   Color(hex: 0xFFFFFF)
        case .dark:    Color(hex: 0xFFFFFF)
        case .tinted:  Color(hex: 0xFFFFFF)
        }
    }

    // MARK: - Secondary

    public var secondary: Color {
        switch variant {
        case .light:   Color(hex: 0x8E99A4)
        case .dark:    Color(hex: 0x7E8A96)
        case .tinted:  Color(hex: 0x8A9470)
        }
    }

    public var onSecondary: Color {
        switch variant {
        case .light:   Color(hex: 0xFFFFFF)
        case .dark:    Color(hex: 0xFFFFFF)
        case .tinted:  Color(hex: 0xFFFFFF)
        }
    }

    // MARK: - Accent

    public var accent: Color {
        switch variant {
        case .light:   Color(hex: 0x7EBAB5)
        case .dark:    Color(hex: 0x6BA8A3)
        case .tinted:  Color(hex: 0xC09070)
        }
    }

    // MARK: - Background

    public var background: Color {
        switch variant {
        case .light:   Color(hex: 0xE0E5EC)
        case .dark:    Color(hex: 0x2D3039)
        case .tinted:  Color(hex: 0xE8E0D4)
        }
    }

    public var onBackground: Color {
        switch variant {
        case .light:   Color(hex: 0x2D3039)
        case .dark:    Color(hex: 0xD8DDE6)
        case .tinted:  Color(hex: 0x3A3028)
        }
    }

    // MARK: - Surface (same as background — neumorphic key principle)

    public var surface: Color {
        switch variant {
        case .light:   Color(hex: 0xE0E5EC)
        case .dark:    Color(hex: 0x2D3039)
        case .tinted:  Color(hex: 0xE8E0D4)
        }
    }

    public var onSurface: Color {
        switch variant {
        case .light:   Color(hex: 0x2D3039)
        case .dark:    Color(hex: 0xD8DDE6)
        case .tinted:  Color(hex: 0x3A3028)
        }
    }

    /// Slightly offset from the background to distinguish inner surfaces.
    public var surfaceVariant: Color {
        switch variant {
        case .light:   Color(hex: 0xD4DAE3)
        case .dark:    Color(hex: 0x353844)
        case .tinted:  Color(hex: 0xDDD5C8)
        }
    }

    // MARK: - Semantic

    public var error: Color {
        switch variant {
        case .light:   Color(hex: 0xC0504D)
        case .dark:    Color(hex: 0xD95F5C)
        case .tinted:  Color(hex: 0xB85040)
        }
    }

    public var onError: Color { Color(hex: 0xFFFFFF) }

    public var success: Color {
        switch variant {
        case .light:   Color(hex: 0x5A9E72)
        case .dark:    Color(hex: 0x62AE7C)
        case .tinted:  Color(hex: 0x6A8C58)
        }
    }

    public var warning: Color {
        switch variant {
        case .light:   Color(hex: 0xC8924A)
        case .dark:    Color(hex: 0xD49A52)
        case .tinted:  Color(hex: 0xC08040)
        }
    }

    // MARK: - Utility

    public var divider: Color {
        switch variant {
        case .light:   Color(hex: 0xC8CDD6).opacity(0.6)
        case .dark:    Color(hex: 0x484D5A).opacity(0.6)
        case .tinted:  Color(hex: 0xCCC4B6).opacity(0.6)
        }
    }

    /// Dark shadow component of the neumorphic shadow pair.
    public var shadow: Color {
        switch variant {
        case .light:   Color(hex: 0xA3B1C6)
        case .dark:    Color(hex: 0x1A1D24)
        case .tinted:  Color(hex: 0xBFB5A5)
        }
    }

    public var overlay: Color {
        switch variant {
        case .light:   Color(hex: 0x000000).opacity(0.16)
        case .dark:    Color(hex: 0x000000).opacity(0.40)
        case .tinted:  Color(hex: 0x000000).opacity(0.20)
        }
    }
}

// MARK: - Color hex convenience

private extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >>  8) & 0xFF) / 255
        let b = Double( hex        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
