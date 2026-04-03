import SwiftUI

struct ThemeShowcaseView: View {
    private enum ThemeFamilyType: String, CaseIterable, Identifiable {
        case koreanAesthetic = "Korean Aesthetic"
        case neo = "Neo"
        case neuromorphic = "Neuromorphic"

        var id: String { rawValue }
    }

    @State private var selectedFamily: ThemeFamilyType = .koreanAesthetic
    @State private var selectedVariant: PrismVariant = .light
    @State private var isLiquidGlass: Bool = false

    @Environment(\.prismTheme) private var theme

    private var activeFamily: PrismThemeFamily {
        switch selectedFamily {
        case .koreanAesthetic: return .koreanAesthetic(selectedVariant)
        case .neo: return .neo(selectedVariant)
        case .neuromorphic: return .neuromorphic(selectedVariant)
        }
    }

    private var colorEntries: [(label: String, color: Color)] {
        [
            ("Primary", theme.colors.primary),
            ("On Primary", theme.colors.onPrimary),
            ("Secondary", theme.colors.secondary),
            ("On Secondary", theme.colors.onSecondary),
            ("Accent", theme.colors.accent),
            ("Background", theme.colors.background),
            ("On Background", theme.colors.onBackground),
            ("Surface", theme.colors.surface),
            ("On Surface", theme.colors.onSurface),
            ("Surface Variant", theme.colors.surfaceVariant),
            ("Error", theme.colors.error),
            ("On Error", theme.colors.onError),
            ("Success", theme.colors.success),
            ("Warning", theme.colors.warning),
            ("Divider", theme.colors.divider),
            ("Shadow", theme.colors.shadow),
            ("Overlay", theme.colors.overlay)
        ]
    }

    private var typographyEntries: [(label: String, font: Font)] {
        [
            ("Caption 2", theme.typography.caption2),
            ("Caption 1", theme.typography.caption1),
            ("Footnote", theme.typography.footnote),
            ("Subheadline", theme.typography.subheadline),
            ("Callout", theme.typography.callout),
            ("Body", theme.typography.body),
            ("Headline", theme.typography.headline),
            ("Title3", theme.typography.title3),
            ("Title2", theme.typography.title2),
            ("Title", theme.typography.title),
            ("Large Title", theme.typography.largeTitle)
        ]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    settingsSection

                    colorSection

                    typographySection

                    spacingSection

                    cornerRadiusSection

                    elevationSection

                    borderSection

                    opacitySection

                    iconSizeSection

                    bottomSpacer
                }
                .padding()
                .background(theme.colors.background)
                .foregroundColor(theme.colors.onBackground)
            }
            .navigationTitle("Prism Theme Showcase")
            .prismTheme(activeFamily, liquidGlass: isLiquidGlass)
        }
    }

    private var settingsSection: some View {
        Group {
            SectionHeader(title: "Theme Settings")

            VStack(spacing: 12) {
                Picker("Family", selection: $selectedFamily) {
                    ForEach(ThemeFamilyType.allCases) { family in
                        Text(family.rawValue).tag(family)
                    }
                }
                .pickerStyle(.segmented)

                Picker("Variant", selection: $selectedVariant) {
                    ForEach(PrismVariant.allCases, id: \.self) { variant in
                        Text(variant.rawValue.capitalized).tag(variant)
                    }
                }
                .pickerStyle(.segmented)

                Toggle("Liquid Glass", isOn: $isLiquidGlass)
            }
            .padding(12)
            .background(theme.colors.surface)
            .cornerRadius(theme.cornerRadius.medium)
            .shadow(color: theme.colors.shadow.opacity(theme.elevation.e2.opacity), radius: theme.elevation.e2.radius, x: theme.elevation.e2.x, y: theme.elevation.e2.y)
        }
    }

    private var colorSection: some View {
        Group {
            SectionHeader(title: "Colors")

            ForEach(colorEntries, id: \.label) { entry in
                HStack {
                    RoundedRectangle(cornerRadius: theme.cornerRadius.small)
                        .fill(entry.color)
                        .frame(width: 40, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: theme.cornerRadius.small).stroke(theme.colors.onSurface.opacity(0.25), lineWidth: 0.5))

                    Text(entry.label)
                        .font(theme.typography.callout)

                    Spacer()

                    Text(entry.color.description)
                        .font(theme.typography.caption2)
                        .foregroundColor(theme.colors.onSurface.opacity(0.7))
                }
                .padding(8)
                .background(theme.colors.surface)
                .cornerRadius(theme.cornerRadius.small)
                .shadow(color: theme.colors.shadow.opacity(theme.elevation.e1.opacity), radius: theme.elevation.e1.radius, x: theme.elevation.e1.x, y: theme.elevation.e1.y)
            }
        }
    }

    private var typographySection: some View {
        Group {
            SectionHeader(title: "Typography")

            ForEach(typographyEntries, id: \.label) { entry in
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.label).font(theme.typography.caption1).foregroundColor(theme.colors.onSurface.opacity(0.6))
                    Text("The quick brown fox jumps over the lazy dog").font(entry.font)
                }
                .padding(10)
                .background(theme.colors.surface)
                .cornerRadius(theme.cornerRadius.small)
            }
        }
    }

    private var spacingSection: some View {
        Group {
            SectionHeader(title: "Spacing")

            let spacings: [(String, CGFloat)] = [
                ("xxs", theme.spacing.xxs),
                ("xs", theme.spacing.xs),
                ("sm", theme.spacing.sm),
                ("md", theme.spacing.md),
                ("lg", theme.spacing.lg),
                ("xl", theme.spacing.xl),
                ("xxl", theme.spacing.xxl),
                ("xxxl", theme.spacing.xxxl)
            ]

            ForEach(spacings, id: \.0) { name, value in
                HStack {
                    Text(name).font(theme.typography.footnote)
                    RoundedRectangle(cornerRadius: theme.cornerRadius.xsmall)
                        .fill(theme.colors.secondary.opacity(0.5))
                        .frame(width: max(80, value * 3), height: 24)
                    Spacer()
                    Text(String(format: "%.0f", value))
                        .font(theme.typography.caption2)
                }
                .padding(8)
                .background(theme.colors.surface)
                .cornerRadius(theme.cornerRadius.small)
            }
        }
    }

    private var cornerRadiusSection: some View {
        Group {
            SectionHeader(title: "Corner Radius")

            let corners: [(String, CGFloat)] = [
                ("xsmall", theme.cornerRadius.xsmall),
                ("small", theme.cornerRadius.small),
                ("medium", theme.cornerRadius.medium),
                ("large", theme.cornerRadius.large),
                ("pill", theme.cornerRadius.pill)
            ]

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                ForEach(corners, id: \.0) { name, radius in
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: radius)
                            .fill(theme.colors.primary)
                            .frame(height: 50)
                        Text(name).font(theme.typography.caption2)
                        Text(String(format: "%.0f", radius)).font(theme.typography.caption2)
                    }
                    .padding(8)
                    .background(theme.colors.surface)
                    .cornerRadius(theme.cornerRadius.small)
                }
            }
        }
    }

    private var elevationSection: some View {
        Group {
            SectionHeader(title: "Elevation")

            let elevations: [(String, ElevationLevel)] = [
                ("e0", theme.elevation.e0),
                ("e1", theme.elevation.e1),
                ("e2", theme.elevation.e2),
                ("e3", theme.elevation.e3),
                ("e4", theme.elevation.e4),
                ("e5", theme.elevation.e5)
            ]

            ForEach(elevations, id: \.0) { label, level in
                HStack {
                    Text(label).font(theme.typography.callout)
                    Spacer()
                    Text(String(format: "r%.0f x%.0f y%.0f α%.2f", level.radius, level.x, level.y, level.opacity))
                        .font(theme.typography.caption2)
                        .foregroundColor(theme.colors.onSurface.opacity(0.6))
                }
                .padding(12)
                .background(theme.colors.surface)
                .cornerRadius(theme.cornerRadius.small)
                .shadow(color: level.color.opacity(level.opacity), radius: level.radius, x: level.x, y: level.y)
            }
        }
    }

    private var borderSection: some View {
        Group {
            SectionHeader(title: "Borders")

            let borders: [(String, CGFloat, Color)] = [
                ("subtle", theme.border.subtle, theme.border.subtleColor),
                ("default", theme.border.default, theme.border.defaultColor),
                ("strong", theme.border.strong, theme.border.strongColor)
            ]

            ForEach(borders, id: \.0) { name, width, color in
                HStack {
                    Circle()
                        .stroke(color, lineWidth: width)
                        .frame(width: 32, height: 32)
                    Text("\(name) \(String(format: "%.1f", width))").font(theme.typography.callout)
                    Spacer()
                }
                .padding(12)
                .background(theme.colors.surface)
                .cornerRadius(theme.cornerRadius.small)
            }
        }
    }

    private var opacitySection: some View {
        Group {
            SectionHeader(title: "Opacity")

            let opacities: [(String, Double)] = [
                ("disabled", theme.opacity.disabled),
                ("overlay", theme.opacity.overlay),
                ("hover", theme.opacity.hover),
                ("pressed", theme.opacity.pressed),
                ("skeleton", theme.opacity.skeleton)
            ]

            ForEach(opacities, id: \.0) { name, alpha in
                HStack {
                    RoundedRectangle(cornerRadius: theme.cornerRadius.xsmall)
                        .fill(theme.colors.onBackground)
                        .frame(width: 24, height: 24)
                        .opacity(alpha)
                        .overlay(RoundedRectangle(cornerRadius: theme.cornerRadius.xsmall).stroke(theme.colors.onSurface.opacity(0.18), lineWidth: 1))

                    Text(name).font(theme.typography.callout)
                    Spacer()
                    Text(String(format: "%.2f", alpha)).font(theme.typography.caption2)
                }
                .padding(12)
                .background(theme.colors.surface)
                .cornerRadius(theme.cornerRadius.small)
            }
        }
    }

    private var iconSizeSection: some View {
        Group {
            SectionHeader(title: "Icon Sizes")

            let icons: [(String, CGFloat)] = [
                ("Small", theme.iconSize.small),
                ("Medium", theme.iconSize.medium),
                ("Large", theme.iconSize.large),
                ("XLarge", theme.iconSize.xlarge)
            ]

            ForEach(icons, id: \.0) { label, size in
                HStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: size))
                        .foregroundColor(theme.colors.accent)
                        .frame(width: 44, height: 44)
                    Text(label).font(theme.typography.callout)
                    Spacer()
                    Text(String(format: "%.0f", size)).font(theme.typography.caption2)
                }
                .padding(12)
                .background(theme.colors.surface)
                .cornerRadius(theme.cornerRadius.small)
            }
        }
    }

    private var bottomSpacer: some View {
        Spacer(minLength: 32)
    }
}

private struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ThemeShowcaseView()
}
