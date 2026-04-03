// PrismAlert.swift
// Prism — Design Theme System
// Full-blocking modal alert with optional text input and action buttons.

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - PrismAlertAction

/// A button action in a `PrismAlert`.
public struct PrismAlertAction: Sendable {
    public var title: String
    public var role: PrismAlertActionRole
    public var isEnabled: Bool
    public var handler: @Sendable @MainActor () -> Void

    public init(
        title: String,
        role: PrismAlertActionRole = .default,
        isEnabled: Bool = true,
        handler: @escaping @Sendable @MainActor () -> Void = {}
    ) {
        self.title = title
        self.role = role
        self.isEnabled = isEnabled
        self.handler = handler
    }
}

// MARK: - PrismAlertInput

/// Text-input configuration for a `PrismAlert`.
///
/// Use `isSecure: true` to render a `SecureField` instead of a `TextField`.
public struct PrismAlertInput {
    public var placeholder: String
    public var text: Binding<String>
    public var isSecure: Bool

    #if canImport(UIKit)
    public var keyboardType: UIKeyboardType

    public init(
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        self.placeholder = placeholder
        self.text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
    }
    #else
    public init(
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self.text = text
        self.isSecure = isSecure
    }
    #endif
}

// MARK: - PrismAlert

/// Value type describing a `PrismAlert`'s content.
///
/// Create an instance inside the closure passed to `.prismAlert(isPresented:content:)`.
///
/// ```swift
/// .prismAlert(isPresented: $showAlert) {
///     PrismAlert(
///         title: "Delete item?",
///         message: "This cannot be undone.",
///         actions: [
///             PrismAlertAction(title: "Delete", role: .destructive) { delete() },
///             PrismAlertAction(title: "Cancel", role: .cancel) { }
///         ]
///     )
/// }
/// ```
public struct PrismAlert {
    public var title: String
    public var message: String?
    public var input: PrismAlertInput?
    public var actions: [PrismAlertAction]

    public init(
        title: String,
        message: String? = nil,
        input: PrismAlertInput? = nil,
        actions: [PrismAlertAction] = []
    ) {
        self.title = title
        self.message = message
        self.input = input
        self.actions = actions
    }
}

// MARK: - PrismAlertOverlayView (internal)

private struct PrismAlertOverlayView: View {
    @Environment(\.prismTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let alert: PrismAlert
    @Binding var isPresented: Bool

    @State private var scale: CGFloat = 0.85
    @State private var opacity: Double = 0

    private var usesScrollList: Bool { alert.actions.count >= 5 }

    var body: some View {
        ZStack {
            PrismBackdropView(style: .dim, isPresented: isPresented)

            alertCard
                .padding(.horizontal, 40)
                .scaleEffect(scale)
                .opacity(opacity)
                .accessibilityAddTraits(.isModal)
                .accessibilityLabel(alertAccessibilityLabel)
        }
        .onAppear {
            triggerHaptic(theme.haptic.lightImpact)
            animateIn()
        }
    }

    // MARK: Alert Card

    private var alertCard: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: theme.spacing.sm) {
                Text(alert.title)
                    .font(theme.typography.headline)
                    .foregroundStyle(theme.colors.onSurface)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)

                if let message = alert.message {
                    Text(message)
                        .font(theme.typography.body)
                        .foregroundStyle(theme.colors.onSurface)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(theme.spacing.lg)

            // Optional text input
            if let input = alert.input {
                inputField(for: input)
                    .padding(.horizontal, theme.spacing.md)
                    .padding(.bottom, theme.spacing.md)
            }

            Divider()

            // Action buttons
            if usesScrollList {
                ScrollView {
                    actionList
                }
                .frame(maxHeight: 220)
            } else {
                actionList
            }
        }
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.large))
        .prismElevation(theme.elevation.e3)
    }

    // MARK: Input Field

    @ViewBuilder
    private func inputField(for input: PrismAlertInput) -> some View {
        Group {
            if input.isSecure {
                SecureField(input.placeholder, text: input.text)
            } else {
                #if canImport(UIKit)
                TextField(input.placeholder, text: input.text)
                    .keyboardType(input.keyboardType)
                #else
                TextField(input.placeholder, text: input.text)
                #endif
            }
        }
        .padding(theme.spacing.sm)
        .background(theme.colors.surface.opacity(0.6))
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius.large / 2)
                .strokeBorder(
                    theme.colors.onSurface.opacity(theme.opacity.overlay * 0.4),
                    lineWidth: 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius.large / 2))
    }

    // MARK: Action List

    @ViewBuilder
    private var actionList: some View {
        if alert.actions.count == 2 {
            // Side-by-side layout for exactly 2 actions
            HStack(spacing: 0) {
                actionButton(alert.actions[0])
                Divider()
                actionButton(alert.actions[1])
            }
            .fixedSize(horizontal: false, vertical: true)
        } else {
            VStack(spacing: 0) {
                ForEach(alert.actions.indices, id: \.self) { index in
                    if index > 0 { Divider() }
                    actionButton(alert.actions[index])
                }
            }
        }
    }

    private func actionButton(_ action: PrismAlertAction) -> some View {
        Button {
            isPresented = false
            action.handler()
        } label: {
            Text(action.title)
                .font(action.role == .cancel ? theme.typography.headline : theme.typography.body)
                .foregroundStyle(foregroundColor(for: action.role))
                .frame(maxWidth: .infinity)
                .padding(theme.spacing.md)
        }
        .disabled(!action.isEnabled)
        .opacity(action.isEnabled ? 1 : theme.opacity.disabled)
        .accessibilityLabel(action.title)
        .accessibilityHint(accessibilityHint(for: action.role))
    }

    // MARK: Helpers

    private func foregroundColor(for role: PrismAlertActionRole) -> Color {
        switch role {
        case .default:      return theme.colors.primary
        case .cancel:       return theme.colors.secondary
        case .destructive:  return theme.colors.error
        }
    }

    private func accessibilityHint(for role: PrismAlertActionRole) -> String {
        switch role {
        case .destructive:  return String(localized: "Destructive action")
        case .cancel:       return String(localized: "Cancels this alert")
        case .default:      return ""
        }
    }

    private var alertAccessibilityLabel: String {
        var parts = [alert.title]
        if let message = alert.message { parts.append(message) }
        return parts.joined(separator: ". ")
    }

    private func animateIn() {
        guard !reduceMotion else {
            scale = 1
            opacity = 1
            return
        }
        withAnimation(theme.animation.easeOut) {
            scale = 1
            opacity = 1
        }
    }
}

// MARK: - PrismAlertModifier

private struct PrismAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let content: () -> PrismAlert

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                PrismAlertOverlayView(alert: self.content(), isPresented: $isPresented)
                    .transition(.opacity)
                    .zIndex(1000)
            }
        }
    }
}

// MARK: - View Extension

extension View {
    /// Presents a full-blocking `PrismAlert` modal over this view.
    ///
    /// Interaction behind the alert is disabled; the only way to dismiss it
    /// is by tapping one of the supplied action buttons.
    ///
    /// - Parameters:
    ///   - isPresented: Binding that controls presentation. Set to `false` inside
    ///     an action handler (done automatically on tap).
    ///   - content: Closure returning the `PrismAlert` to display.
    public func prismAlert(
        isPresented: Binding<Bool>,
        content: @escaping () -> PrismAlert
    ) -> some View {
        modifier(PrismAlertModifier(isPresented: isPresented, content: content))
    }
}
