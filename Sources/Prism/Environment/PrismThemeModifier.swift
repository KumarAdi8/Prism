// PrismThemeModifier.swift
// Prism — Design Theme System
// View modifier that injects a Prism theme into the SwiftUI environment.

import SwiftUI

/// View modifier that injects a Prism theme into the environment.
struct PrismThemeModifier: ViewModifier {
    let theme: any PrismThemeProtocol

    func body(content: Content) -> some View {
        content.environment(\.prismTheme, theme)
    }
}

extension View {
    /// Applies a Prism theme to the view hierarchy.
    public func prismTheme(_ family: PrismThemeFamily) -> some View {
        modifier(PrismThemeModifier(theme: family.resolve()))
    }

    /// Applies a Prism theme with optional Liquid Glass override.
    public func prismTheme(_ family: PrismThemeFamily, liquidGlass: Bool) -> some View {
        let base = family.resolve()
        let resolved: any PrismThemeProtocol = (liquidGlass && !base.liquidGlassEnabled)
            ? LiquidGlassWrapper(wrapped: base)
            : base
        return modifier(PrismThemeModifier(theme: resolved))
    }
}

/// Wrapper that enables Liquid Glass on any theme.
struct LiquidGlassWrapper: PrismThemeProtocol {
    let wrapped: any PrismThemeProtocol

    var variant: PrismVariant { wrapped.variant }
    var liquidGlassEnabled: Bool { true }
    var colors: any ColorTokens { wrapped.colors }
    var typography: any TypographyTokens { wrapped.typography }
    var spacing: any SpacingTokens { wrapped.spacing }
    var cornerRadius: any CornerRadiusTokens { wrapped.cornerRadius }
    var elevation: any ElevationTokens { wrapped.elevation }
    var border: any BorderTokens { wrapped.border }
    var opacity: any OpacityTokens { wrapped.opacity }
    var iconSize: any IconSizeTokens { wrapped.iconSize }
    var animation: any AnimationTokens { wrapped.animation }
    var haptic: any HapticTokens { wrapped.haptic }
}
