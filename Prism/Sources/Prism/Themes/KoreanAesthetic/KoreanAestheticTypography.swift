// KoreanAestheticTypography.swift
// Prism — Korean Aesthetic Theme
// Clean geometric type with progressively lighter weights at display sizes —
// capturing the airy, editorial quality of contemporary Korean design
// (K-beauty packaging, Seoul fashion, K-pop media apps).
//
// Fonts:
//   Poppins  — geometric sans-serif for all display and body roles.
//   Delius   — handwritten accent font used for callout (soft, personal feel).

import SwiftUI

/// Typography tokens for the Korean Aesthetic theme.
///
/// Uses Poppins throughout — clean and geometric — with Delius as an accent font
/// for callouts, matching the soft, handcrafted warmth found in K-beauty and
/// Seoul editorial design.
/// Large display sizes use Thin weights for characteristic airy elegance;
/// body sizes use Regular for legibility; Delius adds a personal accent touch.
public struct KoreanAestheticTypography: TypographyTokens {

    public init() {
        KoreanAestheticFonts.registerIfNeeded()
    }

    // Display — Poppins Thin creates the airy, editorial Korean aesthetic
    public var largeTitle:  Font { .custom(KoreanAestheticFonts.poppinsThin,    size: 34, relativeTo: .largeTitle) }
    public var title:       Font { .custom(KoreanAestheticFonts.poppinsThin,    size: 28, relativeTo: .title) }
    public var title2:      Font { .custom(KoreanAestheticFonts.poppinsLight,   size: 22, relativeTo: .title2) }
    public var title3:      Font { .custom(KoreanAestheticFonts.poppinsLight,   size: 20, relativeTo: .title3) }

    // Body — Poppins Medium for headline, Regular for comfortable reading
    public var headline:    Font { .custom(KoreanAestheticFonts.poppinsMedium,  size: 17, relativeTo: .headline) }
    public var body:        Font { .custom(KoreanAestheticFonts.poppinsRegular, size: 17, relativeTo: .body) }
    public var callout:     Font { .custom(KoreanAestheticFonts.deliusRegular,  size: 16, relativeTo: .callout) }
    public var subheadline: Font { .custom(KoreanAestheticFonts.poppinsRegular, size: 15, relativeTo: .subheadline) }

    // Small utility — light weight keeps small sizes airy and legible
    public var footnote:    Font { .custom(KoreanAestheticFonts.poppinsLight,   size: 13, relativeTo: .footnote) }
    public var caption1:    Font { .custom(KoreanAestheticFonts.poppinsLight,   size: 12, relativeTo: .caption) }
    public var caption2:    Font { .custom(KoreanAestheticFonts.poppinsLight,   size: 11, relativeTo: .caption2) }
}
