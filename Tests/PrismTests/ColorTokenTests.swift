// ColorTokenTests.swift
// Verifies that variant differences produce different primary colors
// and that all three built-in themes have distinct primary colors.

import Testing
import SwiftUI
@testable import Prism

@Suite("Color Token Tests")
struct ColorTokenTests {

    // MARK: - Different variants → different primary colors

    @Test("KoreanAesthetic light and dark variants have different primary colors")
    func koreanAestheticLightDarkPrimaryDiffers() {
        let light = PrismThemeFamily.koreanAesthetic(.light).resolve()
        let dark  = PrismThemeFamily.koreanAesthetic(.dark).resolve()
        #expect(light.colors.primary != dark.colors.primary)
    }

    @Test("KoreanAesthetic light and tinted variants have different primary colors")
    func koreanAestheticLightTintedPrimaryDiffers() {
        let light  = PrismThemeFamily.koreanAesthetic(.light).resolve()
        let tinted = PrismThemeFamily.koreanAesthetic(.tinted).resolve()
        #expect(light.colors.primary != tinted.colors.primary)
    }

    @Test("Neo light and dark variants have different primary colors")
    func neoLightDarkPrimaryDiffers() {
        let light = PrismThemeFamily.neo(.light).resolve()
        let dark  = PrismThemeFamily.neo(.dark).resolve()
        #expect(light.colors.primary != dark.colors.primary)
    }

    @Test("Neuromorphic light and dark variants have different primary colors")
    func neuromorphicLightDarkPrimaryDiffers() {
        let light = PrismThemeFamily.neuromorphic(.light).resolve()
        let dark  = PrismThemeFamily.neuromorphic(.dark).resolve()
        #expect(light.colors.primary != dark.colors.primary)
    }

    // MARK: - Different themes → distinct primary colors (at .light variant)

    @Test("All three themes have distinct primary colors at .light variant")
    func allThemesHaveDistinctPrimaryColorsLight() {
        let ka    = PrismThemeFamily.koreanAesthetic(.light).resolve()
        let neo   = PrismThemeFamily.neo(.light).resolve()
        let neuro = PrismThemeFamily.neuromorphic(.light).resolve()

        #expect(ka.colors.primary != neo.colors.primary)
        #expect(ka.colors.primary != neuro.colors.primary)
        #expect(neo.colors.primary != neuro.colors.primary)
    }

    @Test("All three themes have distinct primary colors at .dark variant")
    func allThemesHaveDistinctPrimaryColorsDark() {
        let ka    = PrismThemeFamily.koreanAesthetic(.dark).resolve()
        let neo   = PrismThemeFamily.neo(.dark).resolve()
        let neuro = PrismThemeFamily.neuromorphic(.dark).resolve()

        #expect(ka.colors.primary != neo.colors.primary)
        #expect(ka.colors.primary != neuro.colors.primary)
        #expect(neo.colors.primary != neuro.colors.primary)
    }

    // MARK: - All three themes have distinct backgrounds (sanity check)

    @Test("All three themes have distinct background colors at .light variant")
    func allThemesHaveDistinctBackgroundsLight() {
        let ka    = PrismThemeFamily.koreanAesthetic(.light).resolve()
        let neo   = PrismThemeFamily.neo(.light).resolve()
        let neuro = PrismThemeFamily.neuromorphic(.light).resolve()

        #expect(ka.colors.background != neo.colors.background)
        #expect(ka.colors.background != neuro.colors.background)
        #expect(neo.colors.background != neuro.colors.background)
    }
}
