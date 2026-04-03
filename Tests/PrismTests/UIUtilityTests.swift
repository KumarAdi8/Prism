// UIUtilityTests.swift
// Prism — Design Theme System
// Tests for UI utility components: configurations, models, enums, and providers.

import Testing
import SwiftUI
@testable import Prism

// MARK: - 1. Configuration Defaults

@Suite("Configuration Defaults")
struct ConfigurationDefaultTests {

    @Test("PrismBottomSheetConfiguration.default has correct values")
    func bottomSheetDefaults() {
        let config = PrismBottomSheetConfiguration.default
        #expect(config.detents.count == 2)
        #expect(config.isDraggable == true)
        #expect(config.showsDragHandle == true)
        #expect(config.dismissOnTapOutside == true)
        #expect(config.allowsDragToDismiss == true)
    }

    @Test("PrismCenterSheetConfig.default has correct values")
    func centerSheetDefaults() {
        let config = PrismCenterSheetConfig.default
        #expect(config.maxWidth == 480)
        #expect(config.showsCloseButton == true)
        #expect(config.dismissOnTapOutside == true)
        #expect(config.backdropStyle == .dim)
        #expect(config.semanticRole == .dialog)
    }

    @Test("PrismPopoverConfiguration.default has correct values")
    func popoverDefaults() {
        let config = PrismPopoverConfiguration.default
        #expect(config.placement == .auto)
        #expect(config.maxWidth == 280)
        #expect(config.showsArrow == true)
        #expect(config.dismissOnTapOutside == true)
        #expect(config.isInteractiveDismissEnabled == true)
    }

    @Test("PrismHUDConfiguration.default has correct maxWidth and position")
    func hudConfigDefaults() {
        let config = PrismHUDConfiguration.default
        #expect(config.maxWidth == 320)
        if case .bottom = config.position {
            // passes — position is .bottom
        } else {
            Issue.record("Expected .bottom position, got \(config.position)")
        }
    }
}

// MARK: - 2. PrismSheetAction

@Suite("PrismSheetAction")
struct PrismSheetActionTests {

    @Test("Default init produces .default role")
    func defaultRole() {
        let action = PrismSheetAction(title: "OK")
        #expect(action.role == .default)
    }

    @Test("systemImage defaults to nil")
    func systemImageDefaultsToNil() {
        let action = PrismSheetAction(title: "OK")
        #expect(action.systemImage == nil)
    }

    @Test("Destructive role is assigned correctly")
    func destructiveRole() {
        let action = PrismSheetAction(title: "Delete", role: .destructive)
        #expect(action.role == .destructive)
    }
}

// MARK: - 3. PrismAlertActionRole

@Suite("PrismAlertActionRole")
struct PrismAlertActionRoleTests {

    @Test("All three cases exist and are distinct")
    func allCasesDistinct() {
        let roles: [PrismAlertActionRole] = [.default, .cancel, .destructive]
        #expect(roles[0] == .default)
        #expect(roles[1] == .cancel)
        #expect(roles[2] == .destructive)
        #expect(roles[0] != roles[1])
        #expect(roles[1] != roles[2])
    }
}

// MARK: - 4. PrismBottomSheetDetent

@Suite("PrismBottomSheetDetent")
struct PrismBottomSheetDetentTests {

    @Test(".collapsed is Hashable (can be used in Set)")
    func collapsedIsHashable() {
        let set: Set<PrismBottomSheetDetent> = [.collapsed, .collapsed]
        #expect(set.count == 1)
    }

    @Test(".fraction equality")
    func fractionEquality() {
        #expect(PrismBottomSheetDetent.fraction(0.5) == .fraction(0.5))
        #expect(PrismBottomSheetDetent.fraction(0.5) != .fraction(0.3))
    }

    @Test(".fixed equality")
    func fixedEquality() {
        #expect(PrismBottomSheetDetent.fixed(200) == .fixed(200))
        #expect(PrismBottomSheetDetent.fixed(200) != .fixed(300))
    }

    @Test(".expanded equality")
    func expandedEquality() {
        #expect(PrismBottomSheetDetent.expanded == .expanded)
        #expect(PrismBottomSheetDetent.expanded != .collapsed)
    }
}

// MARK: - 5. PrismHUDType

@Suite("PrismHUDType")
struct PrismHUDTypeTests {

    @Test("systemImageName for each case", arguments: [
        (PrismHUDType.success, "checkmark.circle.fill"),
        (.error,               "xmark.circle.fill"),
        (.warning,             "exclamationmark.triangle.fill"),
        (.info,                "info.circle.fill"),
        (.custom(systemImage: "star"), "star"),
    ] as [(PrismHUDType, String)])
    func systemImageName(type: PrismHUDType, expected: String) {
        #expect(type.systemImageName == expected)
    }
}

// MARK: - 6. PrismHUDModel

@Suite("PrismHUDModel")
@MainActor
struct PrismHUDModelTests {

    @Test("show() with no current entry sets currentEntry immediately")
    func showSetsCurrentEntryWhenIdle() {
        let model = PrismHUDModel()
        model.show("Hello", type: .success)
        #expect(model.currentEntry != nil)
        #expect(model.currentEntry?.message == "Hello")
    }

    @Test("show() when already showing queues the entry")
    func showQueuesWhenAlreadyShowing() {
        let model = PrismHUDModel()
        model.show("First", type: .info)
        model.show("Second", type: .success)
        #expect(model.currentEntry?.message == "First")
        #expect(model.queue.count == 1)
        #expect(model.queue.first?.message == "Second")
    }

    @Test("Queue max depth is 3 — 4th entry drops oldest pending")
    func queueMaxDepth() {
        let model = PrismHUDModel()
        model.show("Current", type: .info)   // becomes currentEntry
        model.show("Q1", type: .info)        // queue[0]
        model.show("Q2", type: .info)        // queue[1]
        model.show("Q3", type: .info)        // queue[2] — queue now at max
        model.show("Q4", type: .error)       // should drop Q1
        #expect(model.queue.count == 3)
        #expect(model.queue.first?.message == "Q2")
        #expect(model.queue.last?.message == "Q4")
    }

    @Test("dismiss() clears currentEntry after animation delay — initial state")
    func dismissClearsCurrentEntry() {
        let model = PrismHUDModel()
        // No entry shown — dismiss is a no-op, currentEntry stays nil
        model.dismiss()
        #expect(model.currentEntry == nil)
    }
}

// MARK: - 7. PrismSpinnerStyle & PrismSpinnerSize

@Suite("PrismSpinnerStyle and PrismSpinnerSize")
struct PrismSpinnerTests {

    @Test("PrismSpinnerSize dimensions are correct")
    func spinnerDimensions() {
        #expect(PrismSpinnerSize.small.dimension == 20)
        #expect(PrismSpinnerSize.medium.dimension == 36)
        #expect(PrismSpinnerSize.large.dimension == 56)
    }

    @Test("All three PrismSpinnerStyle cases exist")
    func spinnerStyleCases() {
        let styles: [PrismSpinnerStyle] = [.ring, .dots, .pulse]
        #expect(styles.count == 3)
    }
}

// MARK: - 8. PrismProgressBarConfig

@Suite("PrismProgressBarConfig")
struct PrismProgressBarConfigTests {

    @Test(".default has height 6 and animated true")
    func progressBarDefaults() {
        let config = PrismProgressBarConfig.default
        #expect(config.height == 6)
        #expect(config.animated == true)
    }
}

// MARK: - 9. PrismBackdropStyle

@Suite("PrismBackdropStyle")
struct PrismBackdropStyleTests {

    @Test("All three cases exist")
    func allCases() {
        let styles: [PrismBackdropStyle] = [.dim, .blur, .none]
        #expect(styles[0] == .dim)
        #expect(styles[1] == .blur)
        #expect(styles[2] == .none)
    }
}

// MARK: - 10. PrismSheetRole

@Suite("PrismSheetRole")
struct PrismSheetRoleTests {

    @Test("Both cases exist and are distinct")
    func bothCasesDistinct() {
        let dialog = PrismSheetRole.dialog
        let alert = PrismSheetRole.alert
        #expect(dialog == .dialog)
        #expect(alert == .alert)
        #expect(dialog != alert)
    }
}

// MARK: - 11. PrismThemeProvider

@Suite("PrismThemeProvider")
@MainActor
struct PrismThemeProviderTests {

    @Test(".shared returns same instance")
    func sharedIsSingleton() {
        let a = PrismThemeProvider.shared
        let b = PrismThemeProvider.shared
        #expect(a === b)
    }

    @Test("After setTheme(.koreanAesthetic(.light)), currentTheme is KoreanAestheticTheme light")
    func koreanAestheticLightResolvesCorrectly() {
        let provider = PrismThemeProvider.shared
        provider.setTheme(.koreanAesthetic(.light))
        #expect(provider.currentTheme is KoreanAestheticTheme)
        #expect(provider.currentTheme.variant == .light)
    }

    @Test("setTheme(.neo(.dark)) changes currentTheme")
    func setThemeChangesCurrentTheme() {
        let provider = PrismThemeProvider.shared
        provider.setTheme(PrismThemeFamily.neo(.dark))
        #expect(provider.currentTheme is NeoTheme)
        #expect(provider.currentTheme.variant == .dark)
    }

    @Test("setTheme with liquidGlass: true enables liquidGlass")
    func setThemeEnablesLiquidGlass() {
        let provider = PrismThemeProvider.shared
        provider.setTheme(PrismThemeFamily.neo(.dark), liquidGlass: true)
        #expect(provider.currentTheme.liquidGlassEnabled == true)
    }
}

// MARK: - 12. PrismElevationModifier

@Suite("PrismElevationModifier")
@MainActor
struct PrismElevationModifierTests {

    @Test("prismElevation() view extension compiles and applies without crash")
    func elevationModifierApplies() {
        let level = ElevationLevel(
            color: .black,
            radius: 4,
            x: 0,
            y: 2,
            opacity: 0.15
        )
        // Verify the modifier can be created and applied to a View without throwing.
        let view = Color.red.prismElevation(level)
        // AnyView wrapping confirms the expression above resolves to a valid View type.
        let _ = AnyView(view)
        // If we reach here, no crash occurred.
        #expect(Bool(true))
    }
}
