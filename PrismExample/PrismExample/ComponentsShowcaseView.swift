// ComponentsShowcaseView.swift
// PrismExample

import Prism
import SwiftUI

struct ComponentsShowcaseView: View {
    @Binding var selectedFamily: Int
    @Binding var selectedVariant: PrismVariant
    @Binding var liquidGlass: Bool

    @Environment(\.prismTheme) private var theme

    @State private var progress: Double = 0.5
    @State private var isLoading: Bool = false

    private let familyNames = ["Korean", "Neo", "Neuromorphic"]

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                themeChip
                buttonsSection
                spinnersSection
                progressSection
                skeletonSection
                loadingOverlaySection
            }
            .padding(theme.spacing.md)
        }
        .background(theme.colors.background)
        .navigationTitle("Components")
        .prismLoadingOverlay(isPresented: $isLoading, label: "Loading...")
    }

    // MARK: - Theme chip

    private var themeChip: some View {
        HStack(spacing: theme.spacing.xs) {
            Image(systemName: "paintpalette.fill")
                .font(theme.typography.caption1)
            let name = familyNames.indices.contains(selectedFamily)
                ? familyNames[selectedFamily]
                : "Theme"
            Text("\(name) · \(selectedVariant.rawValue.capitalized)")
                .font(theme.typography.caption1)
            if liquidGlass {
                Text("· Liquid Glass")
                    .font(theme.typography.caption1)
            }
        }
        .foregroundStyle(theme.colors.accent)
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.sm)
        .background(theme.colors.accent.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.pill))
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

    // MARK: - Buttons

    private var buttonsSection: some View {
        card(
            "Buttons",
            subtitle: "Primary, secondary, and destructive variants — enabled and disabled states."
        ) {
            HStack(spacing: theme.spacing.sm) {
                Button("Primary") { }
                    .prismButtonStyle(.primary)
                Button("Secondary") { }
                    .prismButtonStyle(.secondary)
                Button("Delete") { }
                    .prismButtonStyle(.destructive)
            }
            HStack(spacing: theme.spacing.sm) {
                Button("Primary") { }
                    .prismButtonStyle(.primary)
                    .disabled(true)
                Button("Secondary") { }
                    .prismButtonStyle(.secondary)
                    .disabled(true)
                Button("Delete") { }
                    .prismButtonStyle(.destructive)
                    .disabled(true)
            }
        }
    }

    // MARK: - Spinners

    private var spinnersSection: some View {
        card(
            "Spinners",
            subtitle: "Ring, dots, and pulse styles across small, medium, and large sizes."
        ) {
            spinnerRow(style: .ring, label: "Ring")
            Divider()
            spinnerRow(style: .dots, label: "Dots")
            Divider()
            spinnerRow(style: .pulse, label: "Pulse")
        }
    }

    private func spinnerRow(style: PrismSpinnerStyle, label: String) -> some View {
        HStack(spacing: 0) {
            Text(label)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.onSurface)
                .frame(width: 52, alignment: .leading)
            Spacer()
            spinnerCell(style: style, size: .small, sizeLabel: "Small")
            Spacer()
            spinnerCell(style: style, size: .medium, sizeLabel: "Med")
            Spacer()
            spinnerCell(style: style, size: .large, sizeLabel: "Large")
        }
        .padding(.vertical, theme.spacing.xs)
    }

    private func spinnerCell(
        style: PrismSpinnerStyle,
        size: PrismSpinnerSize,
        sizeLabel: String
    ) -> some View {
        VStack(spacing: theme.spacing.xs) {
            PrismSpinner(style: style, size: size)
                .frame(width: 56, height: 56, alignment: .center)
            Text(sizeLabel)
                .font(theme.typography.caption2)
                .foregroundStyle(theme.colors.onSurface.opacity(0.6))
        }
    }

    // MARK: - Progress

    private var progressSection: some View {
        card(
            "Progress",
            subtitle: "Horizontal bar and circular indicator — drag the slider to update both."
        ) {
            PrismProgressBar(
                progress: $progress,
                configuration: PrismProgressBarConfig(height: 8)
            )

            HStack(spacing: theme.spacing.sm) {
                Slider(value: $progress, in: 0...1)
                    .tint(theme.colors.accent)
                Text("\(Int(progress * 100))%")
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.onSurface)
                    .monospacedDigit()
                    .frame(width: 44, alignment: .trailing)
            }

            HStack {
                Spacer()
                VStack(spacing: theme.spacing.sm) {
                    PrismProgressCircle(progress: $progress, size: 80, lineWidth: 8)
                    Text("Progress circle")
                        .font(theme.typography.caption1)
                        .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                }
                Spacer()
            }
        }
    }

    // MARK: - Skeleton

    private var skeletonSection: some View {
        card(
            "Skeleton",
            subtitle: "Shimmer placeholders for loading content states."
        ) {
            // Profile card row
            HStack(alignment: .top, spacing: theme.spacing.md) {
                PrismSkeletonView()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    PrismSkeletonView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 14)
                        .cornerRadius(7)
                    PrismSkeletonView()
                        .frame(width: 160, height: 12)
                        .cornerRadius(6)
                    PrismSkeletonView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 12)
                        .cornerRadius(6)
                    PrismSkeletonView()
                        .frame(width: 200, height: 12)
                        .cornerRadius(6)
                }
            }

            // Media card row
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                PrismSkeletonView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .cornerRadius(theme.cornerRadius.medium)

                HStack(spacing: theme.spacing.sm) {
                    PrismSkeletonView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 12)
                        .cornerRadius(6)
                    PrismSkeletonView()
                        .frame(width: 80)
                        .frame(height: 12)
                        .cornerRadius(6)
                }
            }
        }
    }

    // MARK: - Loading Overlay

    private var loadingOverlaySection: some View {
        card(
            "Loading Overlay",
            subtitle: "Full-screen blocking overlay — auto-dismisses after 2 seconds."
        ) {
            Button("Show Loading Overlay") {
                isLoading = true
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    isLoading = false
                }
            }
            .prismButtonStyle(.primary)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ComponentsShowcaseView(
            selectedFamily: .constant(1),
            selectedVariant: .constant(.light),
            liquidGlass: .constant(false)
        )
    }
    .prismTheme(.neo(.light))
}
