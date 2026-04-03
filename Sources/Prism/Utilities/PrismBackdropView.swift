// PrismBackdropView.swift
// Prism — Design Theme System
// Shared overlay backdrop for modal components.

import SwiftUI

/// Backdrop style for modal overlays.
public enum PrismBackdropStyle: Sendable {
    case dim
    case blur
    case none
}

/// Shared dim/blur backdrop view for modal overlays.
struct PrismBackdropView: View {
    @Environment(\.prismTheme) private var theme
    let style: PrismBackdropStyle
    let isPresented: Bool
    var onTap: (() -> Void)?

    var body: some View {
        Group {
            switch style {
            case .dim:
                theme.colors.overlay
                    .opacity(isPresented ? theme.opacity.overlay : 0)
            case .blur:
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(isPresented ? 1 : 0)
            case .none:
                Color.clear
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(isPresented && style != .none)
        .onTapGesture { onTap?() }
        .accessibilityHidden(true)
    }
}
