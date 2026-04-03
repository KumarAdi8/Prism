// PrismThemeFamily.swift
// Prism — Design Theme System
// Built-in theme families with variant selection.

import SwiftUI

/// Built-in theme families with variant selection.
public enum PrismThemeFamily: Sendable {
    case koreanAesthetic(PrismVariant)
    case neo(PrismVariant)
    case neuromorphic(PrismVariant)
    case custom(any PrismThemeProtocol)

    /// Resolves this family + variant into a concrete theme instance.
    public func resolve() -> any PrismThemeProtocol {
        switch self {
        case .koreanAesthetic(let v): KoreanAestheticTheme(variant: v)
        case .neo(let v): NeoTheme(variant: v)
        case .neuromorphic(let v): NeuromorphicTheme(variant: v)
        case .custom(let theme): theme
        }
    }
}
