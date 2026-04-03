// KoreanAestheticTypography.swift
// Prism — Korean Aesthetic Theme
// Rounded, soft typography that scales with Dynamic Type.

import SwiftUI

/// Typography tokens for the Korean Aesthetic theme.
/// Uses `.rounded` font design throughout for a gentle, inviting feel.
public struct KoreanAestheticTypography: TypographyTokens {

    public init() {}

    public var caption2: Font    { .system(.caption2,     design: .rounded) }
    public var caption1: Font    { .system(.caption,      design: .rounded) }
    public var footnote: Font    { .system(.footnote,     design: .rounded) }
    public var subheadline: Font { .system(.subheadline,  design: .rounded) }
    public var callout: Font     { .system(.callout,      design: .rounded) }
    public var body: Font        { .system(.body,         design: .rounded) }
    public var headline: Font    { .system(.headline,     design: .rounded) }
    public var title3: Font      { .system(.title3,       design: .rounded) }
    public var title2: Font      { .system(.title2,       design: .rounded) }
    public var title: Font       { .system(.title,        design: .rounded) }
    public var largeTitle: Font  { .system(.largeTitle,   design: .rounded) }
}
