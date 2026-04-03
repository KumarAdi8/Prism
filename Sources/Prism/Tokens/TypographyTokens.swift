// TypographyTokens.swift
// Prism — Design Theme System
// Typography tokens using SwiftUI text styles (Dynamic Type compatible).

import SwiftUI

/// Typography tokens using standard SwiftUI text styles that scale with Dynamic Type.
public protocol TypographyTokens: Sendable {
    var caption2: Font { get }
    var caption1: Font { get }
    var footnote: Font { get }
    var subheadline: Font { get }
    var callout: Font { get }
    var body: Font { get }
    var headline: Font { get }
    var title3: Font { get }
    var title2: Font { get }
    var title: Font { get }
    var largeTitle: Font { get }
}
