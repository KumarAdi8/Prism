// PrismCenterSheet.swift
// Prism — Design Theme System
// Centered modal dialog overlay.

import SwiftUI

// MARK: - Configuration

/// Semantic role for a center sheet.
public enum PrismSheetRole: Sendable {
    case dialog
    case alert
}

/// Configuration for PrismCenterSheet.
public struct PrismCenterSheetConfig {
    public var maxWidth: CGFloat
    public var padding: CGFloat?
    public var showsCloseButton: Bool
    public var dismissOnTapOutside: Bool
    public var overlayOpacity: Double?
    public var backdropStyle: PrismBackdropStyle
    public var haptic: HapticFeedbackType?
    public var semanticRole: PrismSheetRole

    public init(
        maxWidth: CGFloat = 480,
        padding: CGFloat? = nil,
        showsCloseButton: Bool = true,
        dismissOnTapOutside: Bool = true,
        overlayOpacity: Double? = nil,
        backdropStyle: PrismBackdropStyle = .dim,
        haptic: HapticFeedbackType? = nil,
        semanticRole: PrismSheetRole = .dialog
    ) {
        self.maxWidth = maxWidth
        self.padding = padding
        self.showsCloseButton = showsCloseButton
        self.dismissOnTapOutside = dismissOnTapOutside
        self.overlayOpacity = overlayOpacity
        self.backdropStyle = backdropStyle
        self.haptic = haptic
        self.semanticRole = semanticRole
    }

    public static var `default`: Self { Self() }
}

// MARK: - View Modifier

/// View modifier that presents a PrismCenterSheet overlay.
struct PrismCenterSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let config: PrismCenterSheetConfig
    @ViewBuilder let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        content.overlay {
            if isPresented {
                PrismCenterSheetOverlay(
                    isPresented: $isPresented,
                    config: config,
                    sheetContent: sheetContent
                )
                .transition(.opacity)
                .zIndex(900)
            }
        }
    }
}

extension View {
    /// Presents a centered modal dialog sheet.
    public func prismCenterSheet<Content: View>(
        isPresented: Binding<Bool>,
        config: PrismCenterSheetConfig = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(PrismCenterSheetModifier(
            isPresented: isPresented,
            config: config,
            sheetContent: content
        ))
    }
}

// MARK: - Overlay

private struct PrismCenterSheetOverlay<SheetContent: View>: View {
    @Environment(\.prismTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Binding var isPresented: Bool
    let config: PrismCenterSheetConfig
    @ViewBuilder let sheetContent: () -> SheetContent

    @State private var appeared = false

    var body: some View {
        ZStack {
            PrismBackdropView(
                style: config.backdropStyle,
                isPresented: appeared,
                onTap: config.dismissOnTapOutside ? { dismiss() } : nil
            )

            GeometryReader { geometry in
                let maxH = geometry.size.height * 0.8
                let pad = config.padding ?? theme.spacing.lg

                VStack(spacing: 0) {
                    if config.showsCloseButton {
                        HStack {
                            Spacer()
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(theme.colors.onSurface)
                                    .frame(width: 28, height: 28)
                            }
                            .accessibilityLabel("Close dialog")
                        }
                        .padding(.top, theme.spacing.sm)
                        .padding(.trailing, theme.spacing.sm)
                    }

                    ScrollView {
                        sheetContent()
                            .padding(pad)
                    }
                    .scrollIndicators(.hidden)
                }
                .frame(maxWidth: config.maxWidth)
                .frame(maxHeight: maxH)
                .background(theme.colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.large))
                .prismElevation(theme.elevation.e3)
                .scaleEffect(appeared ? 1 : 0.85)
                .opacity(appeared ? 1 : 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityAddTraits(.isModal)
                .accessibilityLabel(config.semanticRole == .alert ? "Alert" : "Dialog")
            }
        }
        .onKeyPress(.escape) {
            dismiss()
            return .handled
        }
        .onAppear {
            let hapticType = config.haptic ?? theme.haptic.lightImpact
            triggerHaptic(hapticType)
            if reduceMotion {
                appeared = true
            } else {
                withAnimation(theme.animation.easeOut) {
                    appeared = true
                }
            }
        }
    }

    private func dismiss() {
        if reduceMotion {
            appeared = false
            isPresented = false
        } else {
            withAnimation(theme.animation.easeIn) {
                appeared = false
            }
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(theme.animation.normal))
                isPresented = false
            }
        }
    }
}
