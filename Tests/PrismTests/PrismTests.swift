// Smoke test — verifies basic theme creation and property access.

import Testing
import SwiftUI
@testable import Prism

@Suite("Prism Smoke Tests")
struct PrismSmokeTests {

    @Test("A theme can be created and basic properties are accessible")
    func basicThemeCreation() {
        let theme = PrismThemeFamily.koreanAesthetic(.light).resolve()
        #expect(theme.variant == .light)
        #expect(theme.liquidGlassEnabled == false)
        _ = theme.colors.primary
        _ = theme.spacing.md
        _ = theme.cornerRadius.medium
        _ = theme.typography.body
        _ = theme.elevation.e1
    }
}
