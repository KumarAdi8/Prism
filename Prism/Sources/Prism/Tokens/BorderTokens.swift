// BorderTokens.swift
// Prism — Design Theme System
// Border stroke width and color tokens.

import SwiftUI

/// Border stroke width and color tokens.
public protocol BorderTokens: Sendable {
    var subtle: CGFloat { get }
    var `default`: CGFloat { get }
    var strong: CGFloat { get }
    var subtleColor: Color { get }
    var defaultColor: Color { get }
    var strongColor: Color { get }
}
