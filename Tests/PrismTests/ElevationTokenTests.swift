// ElevationTokenTests.swift
// Verifies elevation token structure: e0 is flat (zero shadow),
// levels increase monotonically, and all 6 levels are present.

import Testing
import SwiftUI
@testable import Prism

@Suite("Elevation Token Tests")
struct ElevationTokenTests {

    static let allFamilies: [PrismThemeFamily] = [
        .koreanAesthetic(.light), .koreanAesthetic(.dark), .koreanAesthetic(.tinted),
        .neo(.light), .neo(.dark), .neo(.tinted),
        .neuromorphic(.light), .neuromorphic(.dark), .neuromorphic(.tinted),
    ]

    // MARK: - e0 is flat

    @Test("e0 has zero shadow radius and zero opacity", arguments: allFamilies)
    func e0IsFlat(family: PrismThemeFamily) {
        let e0 = family.resolve().elevation.e0
        #expect(e0.radius == 0)
        #expect(e0.opacity == 0)
    }

    @Test("e0 has zero or near-zero x and y offsets", arguments: allFamilies)
    func e0HasZeroOffsets(family: PrismThemeFamily) {
        let e0 = family.resolve().elevation.e0
        #expect(e0.x == 0)
        #expect(e0.y == 0)
    }

    // MARK: - Higher levels have positive shadow

    @Test("e5 has positive radius and positive opacity", arguments: allFamilies)
    func e5HasPositiveShadow(family: PrismThemeFamily) {
        let e5 = family.resolve().elevation.e5
        #expect(e5.radius > 0)
        #expect(e5.opacity > 0)
    }

    // MARK: - Radius increases with level

    @Test("Elevation radius increases from e0 to e5", arguments: allFamilies)
    func elevationRadiusStrictlyIncreasing(family: PrismThemeFamily) {
        let e = family.resolve().elevation
        // e0 must be strictly less than e5 (design guarantees non-trivial growth)
        #expect(e.e0.radius < e.e5.radius)
        // Each step must be non-decreasing
        #expect(e.e0.radius <= e.e1.radius)
        #expect(e.e1.radius <= e.e2.radius)
        #expect(e.e2.radius <= e.e3.radius)
        #expect(e.e3.radius <= e.e4.radius)
        #expect(e.e4.radius <= e.e5.radius)
    }

    // MARK: - Opacity increases with level

    @Test("Elevation opacity increases from e0 to e5", arguments: allFamilies)
    func elevationOpacityIncreasing(family: PrismThemeFamily) {
        let e = family.resolve().elevation
        #expect(e.e0.opacity < e.e5.opacity)
        #expect(e.e0.opacity <= e.e1.opacity)
        #expect(e.e1.opacity <= e.e2.opacity)
        #expect(e.e2.opacity <= e.e3.opacity)
        #expect(e.e3.opacity <= e.e4.opacity)
        #expect(e.e4.opacity <= e.e5.opacity)
    }

    // MARK: - All 6 levels are accessible

    @Test("All 6 elevation levels (e0–e5) are accessible", arguments: allFamilies)
    func allSixElevationLevelsAccessible(family: PrismThemeFamily) {
        let e = family.resolve().elevation
        // Verify no crash when accessing all levels; collect radii
        let radii = [e.e0.radius, e.e1.radius, e.e2.radius,
                     e.e3.radius, e.e4.radius, e.e5.radius]
        #expect(radii.count == 6)
    }

    // MARK: - ElevationLevel value semantics

    @Test("e0 equals itself (Equatable conformance)")
    func elevationLevelEquatable() {
        let theme = PrismThemeFamily.neo(.light).resolve()
        let e0a = theme.elevation.e0
        let e0b = theme.elevation.e0
        #expect(e0a == e0b)
    }

    @Test("Different elevation levels are not equal")
    func differentElevationLevelsNotEqual() {
        let theme = PrismThemeFamily.neo(.light).resolve()
        #expect(theme.elevation.e0 != theme.elevation.e1)
        #expect(theme.elevation.e1 != theme.elevation.e5)
    }
}
