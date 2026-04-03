// NeuromorphicTypography.swift
// Prism — Design Theme System
// Neumorphic typography tokens: rounded, medium-weight — soft and tactile.

import SwiftUI

/// Neumorphic typography tokens.
///
/// All fonts use `.rounded` design and `.medium` weight to match the soft,
/// tactile character of neumorphism — avoiding sharp geometric or heavy strokes.
public struct NeuromorphicTypography: TypographyTokens {

    public init() {}

    public var caption2:    Font { .system(.caption2,    design: .rounded, weight: .regular) }
    public var caption1:    Font { .system(.caption,     design: .rounded, weight: .regular) }
    public var footnote:    Font { .system(.footnote,    design: .rounded, weight: .regular) }
    public var subheadline: Font { .system(.subheadline, design: .rounded, weight: .medium) }
    public var callout:     Font { .system(.callout,     design: .rounded, weight: .medium) }
    public var body:        Font { .system(.body,        design: .rounded, weight: .regular) }
    public var headline:    Font { .system(.headline,    design: .rounded, weight: .medium) }
    public var title3:      Font { .system(.title3,      design: .rounded, weight: .medium) }
    public var title2:      Font { .system(.title2,      design: .rounded, weight: .medium) }
    public var title:       Font { .system(.title,       design: .rounded, weight: .semibold) }
    public var largeTitle:  Font { .system(.largeTitle,  design: .rounded, weight: .semibold) }
}
