// HapticTokens.swift
// Prism — Design Theme System
// Semantic haptic feedback tokens.

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// Semantic haptic feedback type.
public enum HapticFeedbackType: Sendable, Equatable {
    case selection
    #if canImport(UIKit)
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    #endif
    case none
}

/// Haptic feedback tokens mapping UI events to feedback types.
public protocol HapticTokens: Sendable {
    var selection: HapticFeedbackType { get }
    var lightImpact: HapticFeedbackType { get }
    var mediumImpact: HapticFeedbackType { get }
    var heavyImpact: HapticFeedbackType { get }
    var success: HapticFeedbackType { get }
    var warning: HapticFeedbackType { get }
    var error: HapticFeedbackType { get }
}
