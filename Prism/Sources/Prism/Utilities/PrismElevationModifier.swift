// PrismElevationModifier.swift
// Prism — Design Theme System
// ViewModifier that applies an ElevationLevel as a shadow.

import SwiftUI

/// Applies an `ElevationLevel` token as a shadow.
struct PrismElevationModifier: ViewModifier {
    let elevation: ElevationLevel

    func body(content: Content) -> some View {
        content.shadow(
            color: elevation.color.opacity(elevation.opacity),
            radius: elevation.radius,
            x: elevation.x,
            y: elevation.y
        )
    }
}

extension View {
    /// Applies a Prism elevation token as a shadow.
    func prismElevation(_ level: ElevationLevel) -> some View {
        modifier(PrismElevationModifier(elevation: level))
    }
}
