// PrismTextModifier.swift
// Prism — Design Theme System
// Typography modifier for applying theme text styles to SwiftUI views.

import SwiftUI

/// Typography style cases matching TypographyTokens.
public enum PrismTextStyle: Sendable {
    case caption2, caption1, footnote, subheadline, callout
    case body, headline, title3, title2, title, largeTitle
}

/// View modifier that applies a theme typography token.
struct PrismTextStyleModifier: ViewModifier {
    @Environment(\.prismTheme) private var theme
    let style: PrismTextStyle

    func body(content: Content) -> some View {
        content.font(font(for: style))
    }

    private func font(for style: PrismTextStyle) -> Font {
        switch style {
        case .caption2:    theme.typography.caption2
        case .caption1:    theme.typography.caption1
        case .footnote:    theme.typography.footnote
        case .subheadline: theme.typography.subheadline
        case .callout:     theme.typography.callout
        case .body:        theme.typography.body
        case .headline:    theme.typography.headline
        case .title3:      theme.typography.title3
        case .title2:      theme.typography.title2
        case .title:       theme.typography.title
        case .largeTitle:  theme.typography.largeTitle
        }
    }
}

extension View {
    /// Applies a Prism typography style from the current theme.
    public func prismStyle(_ style: PrismTextStyle) -> some View {
        modifier(PrismTextStyleModifier(style: style))
    }
}
