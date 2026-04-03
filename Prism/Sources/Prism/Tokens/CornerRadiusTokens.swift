// CornerRadiusTokens.swift
// Prism — Design Theme System
// Corner radius tokens.

import SwiftUI

/// Corner radius tokens. All values `CGFloat`.
public protocol CornerRadiusTokens: Sendable {
    var xsmall: CGFloat { get }  // 4
    var small: CGFloat { get }   // 8
    var medium: CGFloat { get }  // 12
    var large: CGFloat { get }   // 20
    var pill: CGFloat { get }    // 9999
}
