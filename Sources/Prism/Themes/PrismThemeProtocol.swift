// PrismThemeProtocol.swift
// Prism — Design Theme System
// Root protocol every Prism theme must satisfy.

import SwiftUI

/// The root protocol every Prism theme must satisfy.
public protocol PrismThemeProtocol: Sendable {
    var variant: PrismVariant { get }
    var liquidGlassEnabled: Bool { get }
    var colors: any ColorTokens { get }
    var typography: any TypographyTokens { get }
    var spacing: any SpacingTokens { get }
    var cornerRadius: any CornerRadiusTokens { get }
    var elevation: any ElevationTokens { get }
    var border: any BorderTokens { get }
    var opacity: any OpacityTokens { get }
    var iconSize: any IconSizeTokens { get }
    var animation: any AnimationTokens { get }
    var haptic: any HapticTokens { get }
}
