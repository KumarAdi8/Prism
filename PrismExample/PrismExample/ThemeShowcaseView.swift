// ThemeShowcaseView.swift
// PrismExample — Design Token Showcase

import Prism
import SwiftUI

// MARK: - ThemeShowcaseView

struct ThemeShowcaseView: View {
    @Environment(\.prismTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                colorsSection
                typographySection
                spacingSection
                cornerRadiusSection
                borderSection
                elevationSection
                opacitySection
                iconSizeSection
            }
            .padding(theme.spacing.md)
        }
        .background(theme.colors.background)
        .navigationTitle("Design Tokens")
    }

    // MARK: - Colors

    @ViewBuilder
    private var colorsSection: some View {
        sectionCard(title: "Colors") {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: theme.spacing.md
            ) {
                // Paired chips — primary / onPrimary
                colorPairChip(
                    background: theme.colors.primary,
                    foreground: theme.colors.onPrimary,
                    label: "primary / onPrimary"
                )
                // Paired chips — secondary / onSecondary
                colorPairChip(
                    background: theme.colors.secondary,
                    foreground: theme.colors.onSecondary,
                    label: "secondary / onSecondary"
                )
                // Standalone chips
                standaloneColorChip(color: theme.colors.accent, label: "accent")
                standaloneColorChip(color: theme.colors.background, label: "background")
                standaloneColorChip(color: theme.colors.surface, label: "surface")
                standaloneColorChip(color: theme.colors.surfaceVariant, label: "surfaceVariant")
                standaloneColorChip(color: theme.colors.error, label: "error")
                standaloneColorChip(color: theme.colors.onError, label: "onError")
                standaloneColorChip(color: theme.colors.success, label: "success")
                standaloneColorChip(color: theme.colors.warning, label: "warning")
                standaloneColorChip(color: theme.colors.divider, label: "divider")
                standaloneColorChip(color: theme.colors.overlay, label: "overlay")
                standaloneColorChip(color: theme.colors.shadow, label: "shadow")
                standaloneColorChip(color: theme.colors.onBackground, label: "onBackground")
                standaloneColorChip(color: theme.colors.onSurface, label: "onSurface")
            }
        }
    }

    @ViewBuilder
    private func colorPairChip(background: Color, foreground: Color, label: String) -> some View {
        VStack(spacing: theme.spacing.xs) {
            ZStack {
                RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                    .fill(background)
                    .frame(height: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                            .strokeBorder(theme.border.subtleColor, lineWidth: theme.border.subtle)
                    )
                Text("Aa")
                    .font(theme.typography.headline)
                    .foregroundStyle(foreground)
            }
            Text(label)
                .font(theme.typography.caption2)
                .foregroundStyle(theme.colors.onSurface)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }

    @ViewBuilder
    private func standaloneColorChip(color: Color, label: String) -> some View {
        VStack(spacing: theme.spacing.xs) {
            RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                .fill(color)
                .frame(height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                        .strokeBorder(theme.border.subtleColor, lineWidth: theme.border.subtle)
                )
            Text(label)
                .font(theme.typography.caption2)
                .foregroundStyle(theme.colors.onSurface)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }

    // MARK: - Typography

    @ViewBuilder
    private var typographySection: some View {
        sectionCard(title: "Typography") {
            VStack(spacing: 0) {
                typographyRow(name: "largeTitle", font: theme.typography.largeTitle)
                typographyDivider
                typographyRow(name: "title", font: theme.typography.title)
                typographyDivider
                typographyRow(name: "title2", font: theme.typography.title2)
                typographyDivider
                typographyRow(name: "title3", font: theme.typography.title3)
                typographyDivider
                typographyRow(name: "headline", font: theme.typography.headline)
                typographyDivider
                typographyRow(name: "body", font: theme.typography.body)
                typographyDivider
                typographyRow(name: "callout", font: theme.typography.callout)
                typographyDivider
                typographyRow(name: "subheadline", font: theme.typography.subheadline)
                typographyDivider
                typographyRow(name: "footnote", font: theme.typography.footnote)
                typographyDivider
                typographyRow(name: "caption1", font: theme.typography.caption1)
                typographyDivider
                typographyRow(name: "caption2", font: theme.typography.caption2)
            }
        }
    }

    @ViewBuilder
    private func typographyRow(name: String, font: Font) -> some View {
        HStack(alignment: .center, spacing: theme.spacing.md) {
            Text(name)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(theme.colors.accent)
                .frame(width: 96, alignment: .leading)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer()
            Text("The quick brown fox")
                .font(font)
                .foregroundStyle(theme.colors.onSurface)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding(.vertical, theme.spacing.sm)
    }

    private var typographyDivider: some View {
        Rectangle()
            .fill(theme.colors.divider)
            .frame(height: theme.border.subtle)
    }

    // MARK: - Spacing

    @ViewBuilder
    private var spacingSection: some View {
        sectionCard(title: "Spacing") {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                spacingRow(name: "xxs", value: theme.spacing.xxs)
                spacingRow(name: "xs", value: theme.spacing.xs)
                spacingRow(name: "sm", value: theme.spacing.sm)
                spacingRow(name: "md", value: theme.spacing.md)
                spacingRow(name: "lg", value: theme.spacing.lg)
                spacingRow(name: "xl", value: theme.spacing.xl)
                spacingRow(name: "xxl", value: theme.spacing.xxl)
                spacingRow(name: "xxxl", value: theme.spacing.xxxl)
            }
        }
    }

    @ViewBuilder
    private func spacingRow(name: String, value: CGFloat) -> some View {
        HStack(spacing: theme.spacing.md) {
            Text("\(name) — \(Int(value))pt")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(theme.colors.onSurface)
                .frame(width: 88, alignment: .leading)
            Capsule()
                .fill(theme.colors.accent)
                .frame(width: min(value * 2.5, 240), height: 12)
            Spacer()
        }
    }

    // MARK: - Corner Radius

    @ViewBuilder
    private var cornerRadiusSection: some View {
        sectionCard(title: "Corner Radius") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: theme.spacing.lg) {
                    cornerRadiusChip(name: "xsmall", value: theme.cornerRadius.xsmall)
                    cornerRadiusChip(name: "small", value: theme.cornerRadius.small)
                    cornerRadiusChip(name: "medium", value: theme.cornerRadius.medium)
                    cornerRadiusChip(name: "large", value: theme.cornerRadius.large)
                    cornerRadiusChip(name: "pill", value: theme.cornerRadius.pill)
                }
                .padding(.horizontal, theme.spacing.xs)
            }
        }
    }

    @ViewBuilder
    private func cornerRadiusChip(name: String, value: CGFloat) -> some View {
        VStack(spacing: theme.spacing.sm) {
            RoundedRectangle(cornerRadius: value)
                .fill(theme.colors.primary.opacity(0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: value)
                        .strokeBorder(theme.colors.primary.opacity(0.6), lineWidth: theme.border.default)
                )
                .frame(width: 72, height: 72)
            VStack(spacing: 2) {
                Text(name)
                    .font(theme.typography.caption1)
                    .foregroundStyle(theme.colors.onSurface)
                Text("\(Int(min(value, 9999)))pt")
                    .font(theme.typography.caption2)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
            }
            .multilineTextAlignment(.center)
        }
    }

    // MARK: - Border

    @ViewBuilder
    private var borderSection: some View {
        sectionCard(title: "Border") {
            VStack(spacing: theme.spacing.md) {
                borderRow(name: "subtle", width: theme.border.subtle, color: theme.border.subtleColor)
                borderRow(name: "default", width: theme.border.default, color: theme.border.defaultColor)
                borderRow(name: "strong", width: theme.border.strong, color: theme.border.strongColor)
            }
        }
    }

    @ViewBuilder
    private func borderRow(name: String, width: CGFloat, color: Color) -> some View {
        HStack(spacing: theme.spacing.md) {
            Text("\(name) — \(String(format: "%.1f", width))pt")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(theme.colors.onSurface)
                .frame(width: 120, alignment: .leading)
            RoundedRectangle(cornerRadius: theme.cornerRadius.small)
                .strokeBorder(color, lineWidth: width)
                .frame(height: 40)
        }
    }

    // MARK: - Elevation

    @ViewBuilder
    private var elevationSection: some View {
        sectionCard(title: "Elevation") {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                spacing: theme.spacing.md
            ) {
                elevationCard(name: "e0", level: theme.elevation.e0)
                elevationCard(name: "e1", level: theme.elevation.e1)
                elevationCard(name: "e2", level: theme.elevation.e2)
                elevationCard(name: "e3", level: theme.elevation.e3)
                elevationCard(name: "e4", level: theme.elevation.e4)
                elevationCard(name: "e5", level: theme.elevation.e5)
            }
        }
    }

    @ViewBuilder
    private func elevationCard(name: String, level: ElevationLevel) -> some View {
        VStack(spacing: theme.spacing.xs) {
            RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                .fill(theme.colors.surface)
                .frame(height: 64)
                .shadow(
                    color: level.color.opacity(level.opacity),
                    radius: level.radius,
                    x: level.x,
                    y: level.y
                )
                .overlay(
                    Text(name)
                        .font(theme.typography.headline)
                        .foregroundStyle(theme.colors.onSurface)
                )
            Text("r:\(String(format: "%.0f", level.radius)) op:\(String(format: "%.2f", level.opacity))")
                .font(theme.typography.caption2)
                .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Opacity

    @ViewBuilder
    private var opacitySection: some View {
        sectionCard(title: "Opacity") {
            VStack(spacing: theme.spacing.sm) {
                opacityRow(name: "disabled", value: theme.opacity.disabled)
                opacityRow(name: "overlay", value: theme.opacity.overlay)
                opacityRow(name: "hover", value: theme.opacity.hover)
                opacityRow(name: "pressed", value: theme.opacity.pressed)
                opacityRow(name: "skeleton", value: theme.opacity.skeleton)
            }
        }
    }

    @ViewBuilder
    private func opacityRow(name: String, value: Double) -> some View {
        HStack(spacing: theme.spacing.md) {
            Text("\(name)")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(theme.colors.onSurface)
                .frame(width: 72, alignment: .leading)
            Text(String(format: "%.2f", value))
                .font(theme.typography.caption1)
                .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                .frame(width: 36, alignment: .leading)
            RoundedRectangle(cornerRadius: theme.cornerRadius.small)
                .fill(theme.colors.primary.opacity(value))
                .frame(height: 32)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cornerRadius.small)
                        .strokeBorder(theme.border.subtleColor, lineWidth: theme.border.subtle)
                )
        }
    }

    // MARK: - Icon Size

    @ViewBuilder
    private var iconSizeSection: some View {
        sectionCard(title: "Icon Size") {
            HStack(alignment: .bottom, spacing: theme.spacing.xl) {
                iconSizeChip(name: "small", size: theme.iconSize.small)
                iconSizeChip(name: "medium", size: theme.iconSize.medium)
                iconSizeChip(name: "large", size: theme.iconSize.large)
                iconSizeChip(name: "xlarge", size: theme.iconSize.xlarge)
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func iconSizeChip(name: String, size: CGFloat) -> some View {
        VStack(spacing: theme.spacing.sm) {
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(theme.colors.accent)
            VStack(spacing: 2) {
                Text(name)
                    .font(theme.typography.caption1)
                    .foregroundStyle(theme.colors.onSurface)
                Text("\(Int(size))pt")
                    .font(theme.typography.caption2)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
            }
            .multilineTextAlignment(.center)
        }
    }

    // MARK: - Section Card Helper

    @ViewBuilder
    private func sectionCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text(title.uppercased())
                .font(theme.typography.caption1)
                .foregroundStyle(theme.colors.accent)
                .tracking(1.5)
            content()
        }
        .padding(theme.spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.large))
        .shadow(
            color: theme.elevation.e1.color.opacity(theme.elevation.e1.opacity),
            radius: theme.elevation.e1.radius,
            x: theme.elevation.e1.x,
            y: theme.elevation.e1.y
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ThemeShowcaseView()
    }
}
