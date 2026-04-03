// IconSizeTokens.swift
// Prism — Design Theme System
// Icon size tokens.

import SwiftUI

/// Icon size tokens. All values `CGFloat`.
public protocol IconSizeTokens: Sendable {
    var small: CGFloat { get }    // 16
    var medium: CGFloat { get }   // 24
    var large: CGFloat { get }    // 32
    var xlarge: CGFloat { get }   // 44
}
