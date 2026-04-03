// PrismHaptics.swift
// Prism — Design Theme System
// Shared haptic feedback helper.

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// Fires a haptic feedback event on iOS; no-op on other platforms.
@MainActor
func triggerHaptic(_ type: HapticFeedbackType) {
#if canImport(UIKit)
    switch type {
    case .selection:
        UISelectionFeedbackGenerator().selectionChanged()
    case .impact(let style):
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    case .notification(let feedbackType):
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    case .none:
        break
    }
#endif
}
