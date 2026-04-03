// OpacityTokens.swift
// Prism — Design Theme System
// Opacity tokens for UI states.

import SwiftUI

/// Opacity tokens. All values `Double` in `0...1`.
public protocol OpacityTokens: Sendable {
    var disabled: Double { get }
    var overlay: Double { get }
    var hover: Double { get }
    var pressed: Double { get }
    var skeleton: Double { get }
}
