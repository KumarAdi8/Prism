// ThemeSwitchTests.swift
// Verifies PrismThemeFamily.resolve() returns correct theme types,
// propagates variants correctly, and that LiquidGlassWrapper works.

import Testing
import SwiftUI
@testable import Prism

@Suite("Theme Switching")
struct ThemeSwitchTests {

    // MARK: - Correct theme type resolution

    @Test("koreanAesthetic resolves to KoreanAestheticTheme")
    func koreanAestheticResolvesCorrectType() {
        for variant in PrismVariant.allCases {
            let resolved = PrismThemeFamily.koreanAesthetic(variant).resolve()
            #expect(resolved is KoreanAestheticTheme, "Expected KoreanAestheticTheme for variant \(variant)")
        }
    }

    @Test("neo resolves to NeoTheme")
    func neoResolvesCorrectType() {
        for variant in PrismVariant.allCases {
            let resolved = PrismThemeFamily.neo(variant).resolve()
            #expect(resolved is NeoTheme, "Expected NeoTheme for variant \(variant)")
        }
    }

    @Test("neuromorphic resolves to NeuromorphicTheme")
    func neuromorphicResolvesCorrectType() {
        for variant in PrismVariant.allCases {
            let resolved = PrismThemeFamily.neuromorphic(variant).resolve()
            #expect(resolved is NeuromorphicTheme, "Expected NeuromorphicTheme for variant \(variant)")
        }
    }

    // MARK: - Variant propagation

    @Test("Variant is propagated correctly for koreanAesthetic", arguments: PrismVariant.allCases)
    func koreanAestheticVariantPropagated(variant: PrismVariant) {
        let resolved = PrismThemeFamily.koreanAesthetic(variant).resolve()
        #expect(resolved.variant == variant)
    }

    @Test("Variant is propagated correctly for neo", arguments: PrismVariant.allCases)
    func neoVariantPropagated(variant: PrismVariant) {
        let resolved = PrismThemeFamily.neo(variant).resolve()
        #expect(resolved.variant == variant)
    }

    @Test("Variant is propagated correctly for neuromorphic", arguments: PrismVariant.allCases)
    func neuromorphicVariantPropagated(variant: PrismVariant) {
        let resolved = PrismThemeFamily.neuromorphic(variant).resolve()
        #expect(resolved.variant == variant)
    }

    // MARK: - liquidGlassEnabled defaults to false

    @Test("Built-in themes have liquidGlassEnabled = false by default", arguments: [
        PrismThemeFamily.koreanAesthetic(.light),
        PrismThemeFamily.koreanAesthetic(.dark),
        PrismThemeFamily.neo(.light),
        PrismThemeFamily.neo(.tinted),
        PrismThemeFamily.neuromorphic(.light),
        PrismThemeFamily.neuromorphic(.dark),
    ] as [PrismThemeFamily])
    func builtInThemesLiquidGlassDisabledByDefault(family: PrismThemeFamily) {
        #expect(family.resolve().liquidGlassEnabled == false)
    }

    // MARK: - LiquidGlassWrapper

    @Test("LiquidGlassWrapper sets liquidGlassEnabled to true")
    func liquidGlassWrapperEnablesGlass() {
        let base = PrismThemeFamily.koreanAesthetic(.light).resolve()
        #expect(base.liquidGlassEnabled == false)

        let wrapped = LiquidGlassWrapper(wrapped: base)
        #expect(wrapped.liquidGlassEnabled == true)
    }

    @Test("LiquidGlassWrapper forwards variant from wrapped theme")
    func liquidGlassWrapperForwardsVariant() {
        for variant in PrismVariant.allCases {
            let base = PrismThemeFamily.neo(variant).resolve()
            let wrapped = LiquidGlassWrapper(wrapped: base)
            #expect(wrapped.variant == variant)
        }
    }

    @Test("LiquidGlassWrapper forwards all token groups from wrapped theme")
    func liquidGlassWrapperForwardsTokens() {
        let base = PrismThemeFamily.neuromorphic(.dark).resolve()
        let wrapped = LiquidGlassWrapper(wrapped: base)

        // Colors must match
        #expect(wrapped.colors.primary == base.colors.primary)
        // Spacing must match
        #expect(wrapped.spacing.md == base.spacing.md)
        // Corner radius must match
        #expect(wrapped.cornerRadius.medium == base.cornerRadius.medium)
    }

    // MARK: - Custom family passthrough

    @Test("custom family resolve() returns the injected theme")
    func customFamilyReturnsInjectedTheme() {
        let original = KoreanAestheticTheme(variant: .tinted)
        let resolved = PrismThemeFamily.custom(original).resolve()
        #expect(resolved.variant == .tinted)
        #expect(resolved is KoreanAestheticTheme)
    }
}
