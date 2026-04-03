// ColorTokens.swift
// Prism — Design Theme System
// Semantic color tokens backed by SwiftUI.Color.

import SwiftUI

/// Semantic color tokens. All values are `SwiftUI.Color`.
public protocol ColorTokens: Sendable {
    var primary: Color { get }
    var onPrimary: Color { get }
    var secondary: Color { get }
    var onSecondary: Color { get }
    var accent: Color { get }
    var background: Color { get }
    var onBackground: Color { get }
    var surface: Color { get }
    var onSurface: Color { get }
    var surfaceVariant: Color { get }
    var error: Color { get }
    var onError: Color { get }
    var success: Color { get }
    var warning: Color { get }
    var divider: Color { get }
    var shadow: Color { get }
    /// Scrim color for modals and overlays. Should include intended opacity.
    var overlay: Color { get }
}
