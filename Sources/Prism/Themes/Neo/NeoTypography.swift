// NeoTypography.swift
// Prism — Neo Theme
// Typography tokens for Neo — bold, geometric, high-impact type scale.

import SwiftUI

/// Typography tokens for the Neo theme.
///
/// Uses `.monospaced` design for small utility text (captions, footnote) to reinforce
/// the technical/geometric character, and `.default` for body and display sizes.
/// Weights escalate from `.medium` → `.semibold` → `.bold` → `.heavy` as size increases.
public struct NeoTypography: TypographyTokens {

    public init() {}

    // Small / utility — monospaced for sharp geometric feel
    public var caption2:    Font { .system(.caption2,    design: .monospaced, weight: .medium) }
    public var caption1:    Font { .system(.caption,     design: .monospaced, weight: .medium) }
    public var footnote:    Font { .system(.footnote,    design: .monospaced, weight: .medium) }

    // Mid-range — transition to default design with semibold weight
    public var subheadline: Font { .system(.subheadline, design: .default,    weight: .semibold) }
    public var callout:     Font { .system(.callout,     design: .default,    weight: .semibold) }
    public var body:        Font { .system(.body,        design: .default,    weight: .semibold) }

    // Headlines — bold
    public var headline:    Font { .system(.headline,    design: .default,    weight: .bold) }
    public var title3:      Font { .system(.title3,      design: .default,    weight: .bold) }
    public var title2:      Font { .system(.title2,      design: .default,    weight: .bold) }

    // Display — heavy for maximum impact
    public var title:       Font { .system(.title,       design: .default,    weight: .heavy) }
    public var largeTitle:  Font { .system(.largeTitle,  design: .default,    weight: .heavy) }
}
