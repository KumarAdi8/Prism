// SpacingTokens.swift
// Prism — Design Theme System
// Base 4pt grid spacing tokens.

import SwiftUI

/// Base 4pt grid spacing tokens. All values are `CGFloat`.
public protocol SpacingTokens: Sendable {
    var xxs: CGFloat { get }   // 2
    var xs: CGFloat { get }    // 4
    var sm: CGFloat { get }    // 8
    var md: CGFloat { get }    // 16
    var lg: CGFloat { get }    // 24
    var xl: CGFloat { get }    // 32
    var xxl: CGFloat { get }   // 48
    var xxxl: CGFloat { get }  // 64
}
