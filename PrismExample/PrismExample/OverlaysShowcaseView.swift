// OverlaysShowcaseView.swift
// PrismExample

import Prism
import SwiftUI

struct OverlaysShowcaseView: View {
    @Environment(\.prismTheme) private var theme

    // Alert state
    @State private var showSimpleAlert = false
    @State private var showConfirmAlert = false
    @State private var showInputAlert = false
    @State private var showMultiAlert = false

    // Input alert text
    @State private var inputText = ""

    // Popover state
    @State private var showPopover = false

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                alertsSection
                hudSection
                popoverSection
            }
            .padding(theme.spacing.md)
        }
        .background(theme.colors.background)
        .navigationTitle("Overlays")
        .prismAlert(isPresented: $showSimpleAlert) {
            PrismAlert(
                title: "Hello, Prism!",
                message: "This is a simple informational alert with a single dismiss action.",
                actions: [
                    PrismAlertAction(title: "Got it", role: .cancel) { }
                ]
            )
        }
        .prismAlert(isPresented: $showConfirmAlert) {
            PrismAlert(
                title: "Delete Item?",
                message: "This action is permanent and cannot be undone.",
                actions: [
                    PrismAlertAction(title: "Delete", role: .destructive) { },
                    PrismAlertAction(title: "Cancel", role: .cancel) { }
                ]
            )
        }
        .prismAlert(isPresented: $showInputAlert) {
            PrismAlert(
                title: "Rename Item",
                message: "Enter a new name for the selected item.",
                input: PrismAlertInput(
                    placeholder: "Item name",
                    text: $inputText
                ),
                actions: [
                    PrismAlertAction(title: "Rename") {
                        inputText = ""
                    },
                    PrismAlertAction(title: "Cancel", role: .cancel) {
                        inputText = ""
                    }
                ]
            )
        }
        .prismAlert(isPresented: $showMultiAlert) {
            PrismAlert(
                title: "Choose an Option",
                message: "Select one of the available actions below.",
                actions: [
                    PrismAlertAction(title: "Save Draft") { },
                    PrismAlertAction(title: "Publish Now") { },
                    PrismAlertAction(title: "Schedule") { },
                    PrismAlertAction(title: "Discard", role: .destructive) { },
                    PrismAlertAction(title: "Cancel", role: .cancel) { }
                ]
            )
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

    // MARK: - Demo row helper

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

    // MARK: - Alerts

    private var alertsSection: some View {
        card(
            "Alerts",
            subtitle: "Full-blocking modal alerts: simple, confirm, input, and multi-action."
        ) {
            demoRow(icon: "info.circle", label: "Simple Alert") {
                showSimpleAlert = true
            }

            Divider()
            demoRow(icon: "trash", label: "Confirm Delete") {
                showConfirmAlert = true
            }

            Divider()
            demoRow(icon: "pencil", label: "Alert with Input") {
                showInputAlert = true
            }

            Divider()
            demoRow(icon: "list.bullet", label: "Multi-Action Alert") {
                showMultiAlert = true
            }
        }
    }

    // MARK: - HUD

    private var hudSection: some View {
        card(
            "HUD",
            subtitle: "Non-blocking toast notifications — success, error, warning, and info."
        ) {
            HStack(spacing: theme.spacing.sm) {
                Button("Success") {
                    PrismHUD.show("Item saved!", type: .success)
                }
                .prismButtonStyle(.secondary)
                .frame(maxWidth: .infinity)

                Button("Error") {
                    PrismHUD.show("Something went wrong", type: .error)
                }
                .prismButtonStyle(.secondary)
                .frame(maxWidth: .infinity)
            }

            HStack(spacing: theme.spacing.sm) {
                Button("Warning") {
                    PrismHUD.show("Low storage space", type: .warning)
                }
                .prismButtonStyle(.secondary)
                .frame(maxWidth: .infinity)

                Button("Info") {
                    PrismHUD.show("Syncing changes…", type: .info)
                }
                .prismButtonStyle(.secondary)
                .frame(maxWidth: .infinity)
            }

            Text("Requires .prismHUD() installed in the view hierarchy.")
                .font(theme.typography.caption1)
                .foregroundStyle(theme.colors.onSurface.opacity(0.4))
        }
    }

    // MARK: - Popover

    private var popoverSection: some View {
        card(
            "Popover",
            subtitle: "Anchored callout overlay with arrow, dismissible on tap outside."
        ) {
            HStack {
                Spacer()
                Button("Show Popover") {
                    showPopover = true
                }
                .prismButtonStyle(.primary)
                .prismPopover(isPresented: $showPopover) {
                    popoverContent
                }
                Spacer()
            }
        }
    }

    private var popoverContent: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Theme Tokens")
                .font(theme.typography.headline)
                .foregroundStyle(theme.colors.onSurface)

            Divider()

            tokenRow(label: "Primary", color: theme.colors.primary)
            tokenRow(label: "Accent", color: theme.colors.accent)
            tokenRow(label: "Surface", color: theme.colors.surface)
            tokenRow(label: "Error", color: theme.colors.error)

            Divider()

            Text("Tap outside to dismiss.")
                .font(theme.typography.caption1)
                .foregroundStyle(theme.colors.onSurface.opacity(0.45))
        }
        .padding(theme.spacing.md)
        .frame(width: 220)
    }

    private func tokenRow(label: String, color: Color) -> some View {
        HStack(spacing: theme.spacing.sm) {
            RoundedRectangle(cornerRadius: theme.cornerRadius.xsmall)
                .fill(color)
                .frame(width: 20, height: 20)
            Text(label)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.onSurface)
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        OverlaysShowcaseView()
    }
    .prismTheme(.neo(.light))
    .prismHUD()
}
