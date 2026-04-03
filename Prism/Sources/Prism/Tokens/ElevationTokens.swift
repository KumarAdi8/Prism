// ElevationTokens.swift
// Prism — Design Theme System
// Shadow elevation value type and elevation level tokens.

import SwiftUI

/// Shadow elevation value type.
public struct ElevationLevel: Sendable, Equatable {
    public var color: Color
    public var radius: CGFloat
    public var x: CGFloat
    public var y: CGFloat
    public var opacity: Double

    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat, opacity: Double) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
        self.opacity = opacity
    }
}

/// Six elevation levels from flat (e0) to highest (e5).
public protocol ElevationTokens: Sendable {
    var e0: ElevationLevel { get }
    var e1: ElevationLevel { get }
    var e2: ElevationLevel { get }
    var e3: ElevationLevel { get }
    var e4: ElevationLevel { get }
    var e5: ElevationLevel { get }
}
