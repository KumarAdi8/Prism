// PrismSheetAction.swift
// Prism — Design Theme System
// Shared action model for sheets and alerts.

import SwiftUI

/// Role for an action button in sheets and alerts.
public enum PrismAlertActionRole: Sendable {
    case `default`
    case cancel
    case destructive
}

/// An action button for use in PrismBottomSheet and PrismAlert.
public struct PrismSheetAction: Sendable {
    public let title: String
    public let systemImage: String?
    public let role: PrismAlertActionRole
    public let handler: @Sendable @MainActor () -> Void

    public init(
        title: String,
        systemImage: String? = nil,
        role: PrismAlertActionRole = .default,
        handler: @escaping @Sendable @MainActor () -> Void = {}
    ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.handler = handler
    }
}
