// SheetsShowcaseView.swift
// PrismExample

import Prism
import SwiftUI

struct SheetsShowcaseView: View {
    @Environment(\.prismTheme) private var theme

    // Bottom sheet state
    @State private var showCustomSheet = false
    @State private var showInfoSheet = false
    @State private var showActionSheet = false

    // Center sheet state
    @State private var showDialogSheet = false
    @State private var showInfoDialog = false

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                bottomSheetSection
                centerSheetSection
            }
            .padding(theme.spacing.md)
        }
        .background(theme.colors.background)
        .navigationTitle("Sheets")
        .prismBottomSheet(isPresented: $showCustomSheet) {
            customSheetContent
        }
        .prismBottomSheet(
            isPresented: $showInfoSheet,
            model: PrismBottomSheetInformationalModel(
                icon: "sparkles",
                title: "About Prism",
                subtitle: "A design system for Swift",
                body: "Prism provides theme-driven components, tokens, and overlays to build consistent, beautiful iOS and macOS apps with zero boilerplate."
            )
        )
        .prismBottomSheet(
            isPresented: $showActionSheet,
            title: "Share or Manage",
            actions: [
                PrismSheetAction(
                    title: "Share",
                    systemImage: "square.and.arrow.up"
                ) { },
                PrismSheetAction(
                    title: "Copy Link",
                    systemImage: "link"
                ) { },
                PrismSheetAction(
                    title: "Add to Favourites",
                    systemImage: "star"
                ) { },
                PrismSheetAction(
                    title: "Delete",
                    systemImage: "trash",
                    role: .destructive
                ) { }
            ]
        )
        .prismCenterSheet(isPresented: $showDialogSheet) {
            dialogSheetContent
        }
        .prismCenterSheet(isPresented: $showInfoDialog) {
            infoDialogContent
        }
    }

    // MARK: - Card wrapper

    private func card<C: View>(
        _ title: String,
        subtitle: String,
        @ViewBuilder content: () -> C
    ) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                Text(title)
                    .font(theme.typography.caption1)
                    .foregroundStyle(theme.colors.accent)
                    .textCase(.uppercase)
                    .tracking(1.5)
                Text(subtitle)
                    .font(theme.typography.footnote)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
            }
            content()
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.large))
        .shadow(
            color: theme.elevation.e2.color.opacity(theme.elevation.e2.opacity),
            radius: theme.elevation.e2.radius,
            x: theme.elevation.e2.x,
            y: theme.elevation.e2.y
        )
    }

    // MARK: - Demo row

    private func demoRow(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: icon)
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.accent)
                    .frame(width: 28)
                Text(label)
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.onSurface)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(theme.typography.caption1)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.35))
            }
            .padding(.vertical, theme.spacing.xs)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Bottom Sheet Section

    private var bottomSheetSection: some View {
        card(
            "Bottom Sheet",
            subtitle: "Custom content, informational, and action-list variants with drag-to-dismiss."
        ) {
            demoRow(
                icon: "square.and.pencil",
                label: "Custom Content Sheet"
            ) {
                showCustomSheet = true
            }

            Divider()

            demoRow(
                icon: "info.circle",
                label: "Informational Sheet"
            ) {
                showInfoSheet = true
            }

            Divider()

            demoRow(
                icon: "ellipsis.circle",
                label: "Action List Sheet"
            ) {
                showActionSheet = true
            }
        }
    }

    // MARK: - Center Sheet Section

    private var centerSheetSection: some View {
        card(
            "Center Sheet",
            subtitle: "Centered modal dialog — use for confirmations, forms, and information."
        ) {
            demoRow(
                icon: "rectangle.and.pencil.and.ellipsis",
                label: "Dialog Sheet"
            ) {
                showDialogSheet = true
            }

            Divider()

            demoRow(
                icon: "checkmark.seal",
                label: "Info Dialog"
            ) {
                showInfoDialog = true
            }
        }
    }

    // MARK: - Sheet content views

    private var customSheetContent: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text("Custom Sheet")
                        .font(theme.typography.title3)
                        .foregroundStyle(theme.colors.onSurface)
                    Text("Fully custom SwiftUI content inside a draggable bottom sheet.")
                        .font(theme.typography.footnote)
                        .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                }
                Spacer()
                Image(systemName: "square.and.pencil")
                    .font(theme.typography.title2)
                    .foregroundStyle(theme.colors.accent)
            }

            Divider()

            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                featureRow(icon: "paintbrush.pointed", text: "Themed to match your current palette")
                featureRow(icon: "hand.draw", text: "Draggable with configurable detents")
                featureRow(icon: "arrow.down.to.line", text: "Swipe down or tap outside to dismiss")
                featureRow(icon: "rectangle.3.group", text: "Supports nested ScrollView content")
            }

            Button("Got it") {
                showCustomSheet = false
            }
            .prismButtonStyle(.primary)
            .frame(maxWidth: .infinity)
        }
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: theme.spacing.sm) {
            Image(systemName: icon)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.accent)
                .frame(width: 24)
            Text(text)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.onSurface)
            Spacer()
        }
    }

    // MARK: - Dialog center sheet content

    private var dialogSheetContent: some View {
        VStack(spacing: theme.spacing.lg) {
            VStack(spacing: theme.spacing.sm) {
                Text("Confirm Changes")
                    .font(theme.typography.title3)
                    .foregroundStyle(theme.colors.onSurface)
                    .multilineTextAlignment(.center)

                Text("You have unsaved changes. Would you like to save before leaving this screen?")
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.7))
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: theme.spacing.sm) {
                Button("Save Changes") {
                    showDialogSheet = false
                }
                .prismButtonStyle(.primary)
                .frame(maxWidth: .infinity)

                Button("Discard") {
                    showDialogSheet = false
                }
                .prismButtonStyle(.destructive)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, theme.spacing.sm)
    }

    // MARK: - Info dialog center sheet content

    private var infoDialogContent: some View {
        VStack(spacing: theme.spacing.lg) {
            VStack(spacing: theme.spacing.md) {
                ZStack {
                    Circle()
                        .fill(theme.colors.accent.opacity(0.12))
                        .frame(width: 72, height: 72)
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(theme.colors.accent)
                }

                VStack(spacing: theme.spacing.sm) {
                    Text("All Caught Up")
                        .font(theme.typography.title3)
                        .foregroundStyle(theme.colors.onSurface)
                        .multilineTextAlignment(.center)

                    Text("Your workspace is fully synced and up to date. No pending actions required at this time.")
                        .font(theme.typography.body)
                        .foregroundStyle(theme.colors.onSurface.opacity(0.65))
                        .multilineTextAlignment(.center)
                }
            }

            Button("Continue") {
                showInfoDialog = false
            }
            .prismButtonStyle(.primary)
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, theme.spacing.sm)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SheetsShowcaseView()
    }
    .prismTheme(.neo(.light))
}
