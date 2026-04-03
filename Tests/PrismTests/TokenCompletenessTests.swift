// TokenCompletenessTests.swift
// Verifies that all 9 (3 families × 3 variants) built-in theme combinations
// satisfy invariants: color tokens not .clear, numeric tokens positive, proper ordering.

import Testing
import SwiftUI
@testable import Prism

@Suite("Token Completeness")
struct TokenCompletenessTests {

    // All 9 built-in family × variant combinations
    static let allFamilies: [PrismThemeFamily] = [
        .koreanAesthetic(.light), .koreanAesthetic(.dark), .koreanAesthetic(.tinted),
        .neo(.light), .neo(.dark), .neo(.tinted),
        .neuromorphic(.light), .neuromorphic(.dark), .neuromorphic(.tinted),
    ]

    // MARK: - Color tokens

    @Test("Color tokens are not .clear", arguments: allFamilies)
    func colorTokensNotClear(family: PrismThemeFamily) {
        let c = family.resolve().colors
        // All semantic colors must be non-clear (not fully transparent system clear)
        #expect(c.primary != .clear)
        #expect(c.onPrimary != .clear)
        #expect(c.secondary != .clear)
        #expect(c.onSecondary != .clear)
        #expect(c.accent != .clear)
        #expect(c.background != .clear)
        #expect(c.onBackground != .clear)
        #expect(c.surface != .clear)
        #expect(c.onSurface != .clear)
        #expect(c.surfaceVariant != .clear)
        #expect(c.error != .clear)
        #expect(c.onError != .clear)
        #expect(c.success != .clear)
        #expect(c.warning != .clear)
        #expect(c.divider != .clear)
        #expect(c.shadow != .clear)
    }

    // MARK: - Spacing tokens

    @Test("Spacing tokens are positive", arguments: allFamilies)
    func spacingTokensPositive(family: PrismThemeFamily) {
        let s = family.resolve().spacing
        #expect(s.xxs > 0)
        #expect(s.xs > 0)
        #expect(s.sm > 0)
        #expect(s.md > 0)
        #expect(s.lg > 0)
        #expect(s.xl > 0)
        #expect(s.xxl > 0)
        #expect(s.xxxl > 0)
    }

    // MARK: - Corner radius tokens

    @Test("Corner radius tokens are positive", arguments: allFamilies)
    func cornerRadiusTokensPositive(family: PrismThemeFamily) {
        let r = family.resolve().cornerRadius
        #expect(r.xsmall > 0)
        #expect(r.small > 0)
        #expect(r.medium > 0)
        #expect(r.large > 0)
        #expect(r.pill > 0)
    }

    // MARK: - Border tokens

    /// `subtle` may be 0 in some themes (e.g. Neuromorphic) by design.
    /// But `default` and `strong` must be positive, and the three must be ordered.
    @Test("Border widths are ordered and non-decreasing", arguments: allFamilies)
    func borderWidthsOrdered(family: PrismThemeFamily) {
        let b = family.resolve().border
        #expect(b.default > 0)
        #expect(b.strong > 0)
        #expect(b.subtle <= b.default)
        #expect(b.default <= b.strong)
    }

    // MARK: - Opacity tokens

    @Test("Opacity tokens are in range (0, 1]", arguments: allFamilies)
    func opacityTokensValid(family: PrismThemeFamily) {
        let o = family.resolve().opacity
        #expect(o.disabled > 0 && o.disabled <= 1)
        #expect(o.overlay > 0 && o.overlay <= 1)
        #expect(o.hover > 0 && o.hover <= 1)
        #expect(o.pressed > 0 && o.pressed <= 1)
        #expect(o.skeleton > 0 && o.skeleton <= 1)
    }

    // MARK: - Icon size tokens

    @Test("Icon size tokens are positive", arguments: allFamilies)
    func iconSizeTokensPositive(family: PrismThemeFamily) {
        let i = family.resolve().iconSize
        #expect(i.small > 0)
        #expect(i.medium > 0)
        #expect(i.large > 0)
        #expect(i.xlarge > 0)
    }

    // MARK: - Animation duration scalars (non-@MainActor)

    @Test("Animation duration scalars are positive", arguments: allFamilies)
    func animationDurationsPositive(family: PrismThemeFamily) {
        let a = family.resolve().animation
        #expect(a.fast > 0)
        #expect(a.normal > 0)
        #expect(a.slow > 0)
        // Durations should be ordered: fast <= normal <= slow
        #expect(a.fast <= a.normal)
        #expect(a.normal <= a.slow)
    }

    // MARK: - Typography tokens

    /// Font is an opaque type — just verify every property is reachable (no crash).
    @Test("Typography font tokens are accessible", arguments: allFamilies)
    func typographyTokensAccessible(family: PrismThemeFamily) {
        let t = family.resolve().typography
        _ = t.caption2
        _ = t.caption1
        _ = t.footnote
        _ = t.subheadline
        _ = t.callout
        _ = t.body
        _ = t.headline
        _ = t.title3
        _ = t.title2
        _ = t.title
        _ = t.largeTitle
    }

    // MARK: - Elevation ordering

    @Test("Elevation radius is non-decreasing from e0 to e5", arguments: allFamilies)
    func elevationRadiusNonDecreasing(family: PrismThemeFamily) {
        let e = family.resolve().elevation
        #expect(e.e0.radius <= e.e1.radius)
        #expect(e.e1.radius <= e.e2.radius)
        #expect(e.e2.radius <= e.e3.radius)
        #expect(e.e3.radius <= e.e4.radius)
        #expect(e.e4.radius <= e.e5.radius)
    }

    @Test("Elevation opacity is non-decreasing from e0 to e5", arguments: allFamilies)
    func elevationOpacityNonDecreasing(family: PrismThemeFamily) {
        let e = family.resolve().elevation
        #expect(e.e0.opacity <= e.e1.opacity)
        #expect(e.e1.opacity <= e.e2.opacity)
        #expect(e.e2.opacity <= e.e3.opacity)
        #expect(e.e3.opacity <= e.e4.opacity)
        #expect(e.e4.opacity <= e.e5.opacity)
    }
}
