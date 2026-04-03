// KoreanAestheticColors.swift
// Prism — Korean Aesthetic Theme
// Soft pastels, rounded forms, airy whitespace.
// Inspired by hanok architecture and Korean minimalist design.

import SwiftUI

/// Color tokens for the Korean Aesthetic theme.
/// Supports `.light`, `.dark`, and `.tinted` variants.
public struct KoreanAestheticColors: ColorTokens {

    public let variant: PrismVariant

    public init(variant: PrismVariant) {
        self.variant = variant
    }

    // MARK: - Primary

    public var primary: Color {
        switch variant {
        case .light:  Color(red: 0.910, green: 0.627, blue: 0.749) // #E8A0BF soft rose
        case .dark:   Color(red: 0.831, green: 0.514, blue: 0.608) // #D4839B dusty rose
        case .tinted: Color(red: 0.910, green: 0.565, blue: 0.502) // #E89080 coral
        }
    }

    public var onPrimary: Color {
        switch variant {
        case .light:  Color(red: 0.239, green: 0.169, blue: 0.122) // warm dark brown
        case .dark:   Color(red: 0.961, green: 0.918, blue: 0.941) // near-white blush
        case .tinted: Color(red: 0.239, green: 0.169, blue: 0.122)
        }
    }

    // MARK: - Secondary

    public var secondary: Color {
        switch variant {
        case .light:  Color(red: 0.659, green: 0.773, blue: 0.627) // #A8C5A0 muted sage
        case .dark:   Color(red: 0.482, green: 0.651, blue: 0.620) // #7BA69E muted teal
        case .tinted: Color(red: 0.584, green: 0.722, blue: 0.627) // #95B8A0 sage green
        }
    }

    public var onSecondary: Color {
        switch variant {
        case .light:  Color(red: 0.102, green: 0.180, blue: 0.102) // deep green
        case .dark:   Color(red: 0.910, green: 0.941, blue: 0.933) // near-white with teal tint
        case .tinted: Color(red: 0.102, green: 0.180, blue: 0.102)
        }
    }

    // MARK: - Accent

    public var accent: Color {
        switch variant {
        case .light:  Color(red: 0.769, green: 0.659, blue: 0.847) // #C4A8D8 soft lavender
        case .dark:   Color(red: 0.651, green: 0.545, blue: 0.753) // #A68BC0 muted purple
        case .tinted: Color(red: 0.831, green: 0.722, blue: 0.549) // #D4B88C warm gold
        }
    }

    // MARK: - Background

    public var background: Color {
        switch variant {
        case .light:  Color(red: 1.000, green: 0.973, blue: 0.941) // #FFF8F0 warm cream
        case .dark:   Color(red: 0.102, green: 0.106, blue: 0.180) // #1A1B2E deep navy-charcoal
        case .tinted: Color(red: 1.000, green: 0.941, blue: 0.922) // #FFF0EB warm blush
        }
    }

    public var onBackground: Color {
        switch variant {
        case .light:  Color(red: 0.176, green: 0.106, blue: 0.055) // #2D1B0E warm dark
        case .dark:   Color(red: 0.961, green: 0.937, blue: 0.910) // #F5EFE8 warm light
        case .tinted: Color(red: 0.176, green: 0.106, blue: 0.055)
        }
    }

    // MARK: - Surface

    public var surface: Color {
        switch variant {
        case .light:  Color(red: 1.000, green: 0.988, blue: 0.973) // #FFFCF8 soft white
        case .dark:   Color(red: 0.137, green: 0.141, blue: 0.212) // #232436 slightly lifted
        case .tinted: Color(red: 1.000, green: 0.973, blue: 0.953) // #FFF8F3 blush white
        }
    }

    public var onSurface: Color {
        switch variant {
        case .light:  Color(red: 0.176, green: 0.106, blue: 0.055)
        case .dark:   Color(red: 0.961, green: 0.937, blue: 0.910)
        case .tinted: Color(red: 0.176, green: 0.106, blue: 0.055)
        }
    }

    public var surfaceVariant: Color {
        switch variant {
        case .light:  Color(red: 0.961, green: 0.929, blue: 0.894) // #F5EDE4 warm tint
        case .dark:   Color(red: 0.176, green: 0.180, blue: 0.267) // #2D2E44 muted navy
        case .tinted: Color(red: 0.973, green: 0.910, blue: 0.875) // #F8E8DF warm peach
        }
    }

    // MARK: - Semantic

    public var error: Color {
        switch variant {
        case .light:  Color(red: 0.784, green: 0.353, blue: 0.416) // #C85A6A soft red
        case .dark:   Color(red: 0.878, green: 0.475, blue: 0.541) // #E0798A lighter red
        case .tinted: Color(red: 0.784, green: 0.353, blue: 0.416)
        }
    }

    public var onError: Color {
        switch variant {
        case .light:  .white
        case .dark:   Color(red: 0.239, green: 0.063, blue: 0.094) // #3D1018 deep red-black
        case .tinted: .white
        }
    }

    public var success: Color {
        switch variant {
        case .light:  Color(red: 0.353, green: 0.620, blue: 0.416) // #5A9E6A muted green
        case .dark:   Color(red: 0.478, green: 0.741, blue: 0.541) // #7ABD8A lifted green
        case .tinted: Color(red: 0.353, green: 0.620, blue: 0.416)
        }
    }

    public var warning: Color {
        switch variant {
        case .light:  Color(red: 0.784, green: 0.565, blue: 0.251) // #C89040 warm amber
        case .dark:   Color(red: 0.831, green: 0.659, blue: 0.290) // #D4A84A lifted amber
        case .tinted: Color(red: 0.784, green: 0.565, blue: 0.251)
        }
    }

    // MARK: - Utility

    public var divider: Color {
        switch variant {
        case .light:  Color(red: 0.910, green: 0.867, blue: 0.835) // #E8DDD5 warm separator
        case .dark:   Color(red: 0.227, green: 0.231, blue: 0.329) // #3A3B54 muted blue-grey
        case .tinted: Color(red: 0.929, green: 0.847, blue: 0.812) // #EDD8CF warm peach line
        }
    }

    public var shadow: Color {
        switch variant {
        case .light:  Color(red: 0.239, green: 0.169, blue: 0.122) // #3D2B1F warm dark brown
        case .dark:   Color(red: 0.000, green: 0.000, blue: 0.063) // #000010 near-black blue
        case .tinted: Color(red: 0.239, green: 0.169, blue: 0.122)
        }
    }

    public var overlay: Color {
        switch variant {
        case .light:  Color(red: 0.239, green: 0.169, blue: 0.122).opacity(0.54)
        case .dark:   Color(red: 0.000, green: 0.000, blue: 0.063).opacity(0.70)
        case .tinted: Color(red: 0.239, green: 0.169, blue: 0.122).opacity(0.54)
        }
    }
}
