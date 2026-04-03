// PrismEnvironmentKey.swift
// Prism — Design Theme System
// SwiftUI environment key for the active Prism theme.

import SwiftUI

/// Environment key for the active Prism theme.
private struct PrismThemeKey: EnvironmentKey {
    static let defaultValue: any PrismThemeProtocol = KoreanAestheticTheme(variant: .light)
}

extension EnvironmentValues {
    /// The currently active Prism theme.
    public var prismTheme: any PrismThemeProtocol {
        get { self[PrismThemeKey.self] }
        set { self[PrismThemeKey.self] = newValue }
    }
}
