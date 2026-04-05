// KoreanAestheticFonts.swift
// Prism — Korean Aesthetic Theme
// Registers Poppins and Delius fonts bundled in the Prism SPM target.

import CoreText
import Foundation

enum KoreanAestheticFonts {
    // MARK: – Font names (PostScript names as embedded in the TTF files)
    static let poppinsThin     = "Poppins-Thin"
    static let poppinsLight    = "Poppins-Light"
    static let poppinsRegular  = "Poppins-Regular"
    static let poppinsMedium   = "Poppins-Medium"
    static let deliusRegular   = "Delius-Regular"

    // MARK: – One-time registration
    private static let _register: Void = {
        let fontNames = [
            "Poppins-Thin",
            "Poppins-Light",
            "Poppins-Regular",
            "Poppins-Medium",
            "Delius-Regular",
        ]
        for name in fontNames {
            guard
                let url = Bundle.module.url(
                    forResource: name,
                    withExtension: "ttf"
                )
            else {
                assertionFailure("Prism: missing font resource \(name).ttf")
                continue
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }()

    static func registerIfNeeded() { _register }
}
