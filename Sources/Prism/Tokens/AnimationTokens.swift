// AnimationTokens.swift
// Prism — Design Theme System
// Animation duration and curve tokens.
// Note: SwiftUI.Animation is not Sendable, so Animation properties are @MainActor-isolated.

import SwiftUI

/// Animation duration and curve tokens.
public protocol AnimationTokens: Sendable {
    var fast: Double { get }
    var normal: Double { get }
    var slow: Double { get }

    @MainActor var easeIn: Animation { get }
    @MainActor var easeOut: Animation { get }
    @MainActor var spring: Animation { get }
    @MainActor var bouncy: Animation { get }
    @MainActor var fadeIn: Animation { get }
    @MainActor var scaleUp: Animation { get }
    @MainActor var slideIn: Animation { get }
    @MainActor var bounce: Animation { get }
    @MainActor var shimmer: Animation { get }
}
