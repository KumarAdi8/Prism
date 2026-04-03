// PrismThemeProvider.swift
// Prism — Design Theme System
// Observable theme provider for UIKit bridging.

import SwiftUI

/// Observable theme provider for UIKit apps that cannot use SwiftUI environment.
@MainActor
@Observable
public final class PrismThemeProvider {
    /// Shared singleton instance.
    public static let shared = PrismThemeProvider()

    /// The currently active theme.
    public private(set) var currentTheme: any PrismThemeProtocol

    private init() {
        self.currentTheme = KoreanAestheticTheme(variant: .light)
    }

    /// Updates the active theme by resolving a theme family.
    public func setTheme(_ family: PrismThemeFamily, liquidGlass: Bool = false) {
        let base = family.resolve()
        if liquidGlass && !base.liquidGlassEnabled {
            currentTheme = LiquidGlassWrapper(wrapped: base)
        } else {
            currentTheme = base
        }
    }
}
