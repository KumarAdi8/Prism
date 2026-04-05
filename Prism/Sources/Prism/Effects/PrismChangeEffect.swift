// PrismChangeEffect.swift
// Prism — Change effects and particle layer backed by Pow.
// Pow is never exposed to consumers.

import SwiftUI
import Pow

// MARK: - PrismChangeEffect

/// An opaque effect that fires every time a bound `Equatable` value changes.
///
/// Apply effects with ``View/prismEffect(_:value:isEnabled:)``.
///
/// ```swift
/// likeButton
///     .prismEffect(.spray { Image(systemName: "heart.fill") }, value: likes)
///
/// submitButton
///     .prismEffect(.shine.delay(1), value: name.isEmpty, isEnabled: !name.isEmpty)
/// ```
public struct PrismChangeEffect {

    // MARK: Internal

    internal let base: AnyChangeEffect

    private init(_ base: AnyChangeEffect) { self.base = base }
}

// MARK: - Delay

public extension PrismChangeEffect {
    /// Delays the start of this effect by the given number of seconds.
    ///
    /// - Parameter delay: Delay in seconds.
    func delay(_ delay: Double) -> PrismChangeEffect {
        .init(base.delay(delay))
    }
}

// MARK: - Particle Effects

public extension PrismChangeEffect {

    /// Emits particles in varied shades and sizes upward from the origin point.
    ///
    /// - Parameters:
    ///   - origin: The point from which particles originate. Defaults to `.center`.
    ///   - layer: The particle layer on which to render. Defaults to `.local`.
    ///   - particles: A view builder providing the particle views.
    static func spray(
        origin: UnitPoint = .center,
        layer: PrismParticleLayer = .local,
        @ViewBuilder _ particles: () -> some View
    ) -> PrismChangeEffect {
        .init(.spray(origin: origin, layer: layer.base) { particles() })
    }

    /// Emits particles that slowly float upward while drifting side to side.
    ///
    /// - Parameters:
    ///   - origin: The point from which particles originate. Defaults to `.center`.
    ///   - layer: The particle layer on which to render. Defaults to `.local`.
    ///   - particles: A view builder providing the particle views.
    static func rise(
        origin: UnitPoint = .center,
        layer: PrismParticleLayer = .local,
        @ViewBuilder _ particles: () -> some View
    ) -> PrismChangeEffect {
        .init(.rise(origin: origin, layer: layer.base) { particles() })
    }
}

// MARK: - Pulse

public extension PrismChangeEffect {

    /// Adds one or more shapes that slowly grow and fade out behind the view.
    ///
    /// The shape is tinted by the current `.tint` style.
    ///
    /// - Parameters:
    ///   - shape: The shape used for the expanding ring.
    ///   - count: The number of rings to emit. Defaults to `1`.
    static func pulse(shape: some InsettableShape, count: Int = 1) -> PrismChangeEffect {
        .init(.pulse(shape: shape, count: count))
    }

    /// Adds one or more shapes that slowly grow and fade out behind the view,
    /// with a custom fill style.
    ///
    /// - Parameters:
    ///   - shape: The shape used for the expanding ring.
    ///   - style: The `ShapeStyle` used to fill the ring.
    ///   - count: The number of rings to emit. Defaults to `1`.
    static func pulse(shape: some InsettableShape, style: some ShapeStyle, count: Int = 1) -> PrismChangeEffect {
        .init(.pulse(shape: shape, style: style, count: count))
    }
}

// MARK: - Jump

public extension PrismChangeEffect {

    /// Bounces the view up by the given height, then settles back with a few small bounces.
    ///
    /// - Parameter height: The peak height of the jump in points.
    static func jump(height: CGFloat) -> PrismChangeEffect {
        .init(.jump(height: height))
    }
}

// MARK: - Shake

public extension PrismChangeEffect {

    /// Shakes the view laterally at the default rate.
    static var shake: PrismChangeEffect { .init(.shake) }

    /// Shakes the view laterally at a custom rate.
    ///
    /// - Parameter rate: Controls the speed and intensity of the shake.
    static func shake(rate: PrismShakeRate) -> PrismChangeEffect {
        .init(.shake(rate: rate.base))
    }
}

// MARK: - Shine

public extension PrismChangeEffect {

    /// Highlights the view with a diagonal shine streak (top-leading → bottom-trailing).
    static var shine: PrismChangeEffect { .init(.shine) }

    /// Highlights the view with a shine streak of custom duration.
    ///
    /// - Parameter duration: Duration of the shine animation in seconds.
    static func shine(duration: Double) -> PrismChangeEffect {
        .init(.shine(duration: duration))
    }

    /// Highlights the view with a shine streak at a custom angle and duration.
    ///
    /// The angle is relative to the current `layoutDirection` — 0° sweeps toward
    /// the trailing edge; 90° sweeps toward the bottom edge.
    ///
    /// - Parameters:
    ///   - angle: The direction of the shine sweep.
    ///   - duration: Duration of the shine animation in seconds. Defaults to `1.0`.
    static func shine(angle: Angle, duration: Double = 1.0) -> PrismChangeEffect {
        .init(.shine(angle: angle, duration: duration))
    }
}

// MARK: - Spin

public extension PrismChangeEffect {

    /// Spins the view around the y-axis at the default rate.
    static var spin: PrismChangeEffect { .init(.spin) }

    /// Spins the view around a custom axis.
    ///
    /// - Parameters:
    ///   - axis: The x, y, z elements specifying the rotation axis.
    ///   - anchor: The 2D anchor point. Defaults to `.center`.
    ///   - anchorZ: The z-axis anchor offset. Defaults to `0`.
    ///   - perspective: The vanishing point multiplier. Defaults to `1/6`.
    ///   - rate: Controls the spin speed and momentum. Defaults to `.default`.
    static func spin(
        axis: (x: CGFloat, y: CGFloat, z: CGFloat),
        anchor: UnitPoint = .center,
        anchorZ: CGFloat = 0,
        perspective: CGFloat = 1 / 6,
        rate: PrismSpinRate = .default
    ) -> PrismChangeEffect {
        .init(.spin(axis: axis, anchor: anchor, anchorZ: anchorZ, perspective: perspective, rate: rate.base))
    }
}

// MARK: - Haptic Feedback (iOS only)

#if os(iOS)
public extension PrismChangeEffect {

    /// Triggers a notification-style haptic on each change.
    ///
    /// - Parameter type: `.success`, `.warning`, or `.error`.
    static func feedback(hapticNotification type: UINotificationFeedbackGenerator.FeedbackType) -> PrismChangeEffect {
        .init(.feedback(hapticNotification: type))
    }

    /// Triggers an impact-style haptic on each change.
    ///
    /// - Parameter style: `.light`, `.medium`, `.heavy`, `.rigid`, or `.soft`.
    static func feedback(hapticImpact style: UIImpactFeedbackGenerator.FeedbackStyle) -> PrismChangeEffect {
        .init(.feedback(hapticImpact: style))
    }

    /// Triggers a selection haptic on each change.
    static var feedbackHapticSelection: PrismChangeEffect { .init(.feedbackHapticSelection) }

    /// Plays a sound effect on each change.
    ///
    /// Playback is not guaranteed — it respects the silent switch and current
    /// audio route. Always accompany with a visible cue.
    ///
    /// - Parameter soundEffect: The ``PrismSoundEffect`` to play.
    static func feedback(_ soundEffect: PrismSoundEffect) -> PrismChangeEffect {
        .init(.feedback(soundEffect.base))
    }
}
#endif

// MARK: - View Extensions

public extension View {

    /// Triggers the given change effect each time `value` changes.
    ///
    /// ```swift
    /// likeButton
    ///     .prismEffect(.spray { Image(systemName: "heart.fill") }, value: likes)
    ///
    /// // With isEnabled guard:
    /// submitButton
    ///     .prismEffect(.shine.delay(1), value: name.isEmpty, isEnabled: !name.isEmpty)
    /// ```
    ///
    /// - Parameters:
    ///   - effect: The ``PrismChangeEffect`` to trigger.
    ///   - value: The `Equatable` value to observe.
    ///   - isEnabled: When `false` the effect is suppressed. Defaults to `true`.
    func prismEffect<V: Equatable>(
        _ effect: PrismChangeEffect,
        value: V,
        isEnabled: Bool = true
    ) -> some View {
        self.changeEffect(effect.base, value: value, isEnabled: isEnabled)
    }

    /// Wraps this view in a particle layer with the given name.
    ///
    /// Use to lift particle effects above clipping ancestors such as `List` rows
    /// or `NavigationStack`. Match the name in the effect's `layer` parameter:
    ///
    /// ```swift
    /// List {
    ///     row.prismEffect(
    ///         .spray(layer: .named("listLayer")) { star },
    ///         value: count
    ///     )
    /// }
    /// .prismParticleLayer(name: "listLayer")
    /// ```
    ///
    /// - Parameter name: A hashable identifier shared between the effect and this modifier.
    func prismParticleLayer(name: AnyHashable) -> some View {
        self.particleLayer(name: name)
    }
}
