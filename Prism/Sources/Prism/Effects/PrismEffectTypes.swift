// PrismEffectTypes.swift
// Prism — Supporting types for transitions and change effects.
// These mirror Pow's internal types so consumers only depend on Prism.

import SwiftUI
import Pow

// MARK: - PrismParticleLayer

/// A context in which Prism particle effects draw their particles.
///
/// By default, particles render locally around the view. When an ancestor is
/// clipping (e.g. a `List` row), promote particles to a named layer placed
/// higher in the view tree using ``View/prismParticleLayer(name:)``.
///
/// ```swift
/// List { rowView.prismEffect(.spray(layer: .named("list")) { star }, value: count) }
///     .prismParticleLayer(name: "list")
/// ```
public struct PrismParticleLayer {

    // MARK: Internal

    internal var base: ParticleLayer

    private init(_ base: ParticleLayer) { self.base = base }

    // MARK: Public

    /// Renders particles locally, immediately behind or in front of the view.
    public static var local: PrismParticleLayer { .init(.local) }

    /// Renders particles at the ancestor view registered with
    /// ``View/prismParticleLayer(name:)`` using the matching name.
    public static func named(_ name: AnyHashable) -> PrismParticleLayer {
        .init(.named(name))
    }
}

// MARK: - PrismShakeRate

/// Controls the speed of the ``PrismChangeEffect/shake(rate:)`` change effect.
public enum PrismShakeRate {
    /// A moderate shake rate.
    case `default`
    /// A faster, more intense shake.
    case fast
    /// A custom phase length in points.
    case phaseLength(CGFloat)

    // MARK: Internal

    internal var base: AnyChangeEffect.ShakeRate {
        switch self {
        case .default:            return .default
        case .fast:               return .fast
        case .phaseLength(let l): return .phaseLength(l)
        }
    }
}

// MARK: - PrismSpinRate

/// Controls the speed of the ``PrismChangeEffect/spin(axis:anchor:anchorZ:perspective:rate:)``
/// change effect.
public enum PrismSpinRate {
    /// A standard spin rate.
    case `default`
    /// A faster, higher-energy spin.
    case fast
    /// Fully custom velocity curve.
    case velocity(initial: Angle, maximum: Angle, additional: Angle)

    // MARK: Internal

    internal var base: AnyChangeEffect.SpinRate {
        switch self {
        case .default:
            return .default
        case .fast:
            return .fast
        case .velocity(let i, let m, let a):
            return .velocity(initial: i, maximum: m, additional: a)
        }
    }
}

// MARK: - PrismBlindsStyle

/// The slat orientation for the
/// ``AnyTransition/PrismTransitions/blinds(slatWidth:style:isStaggered:)`` transition.
public enum PrismBlindsStyle: Sendable {
    /// Horizontal slats (venetian blinds style).
    case venetian
    /// Vertical slats.
    case vertical

    // MARK: Internal

    internal var base: AnyTransition.MovingParts.BlindsStyle {
        switch self {
        case .venetian: return .venetian
        case .vertical: return .vertical
        }
    }
}

// MARK: - PrismSkidDirection

/// The insertion edge for the
/// ``AnyTransition/PrismTransitions/skid(direction:)`` transition.
public enum PrismSkidDirection {
    /// Slides in from the leading edge.
    case leading
    /// Slides in from the trailing edge.
    case trailing

    // MARK: Internal

    internal var base: AnyTransition.MovingParts.SkidDirection {
        switch self {
        case .leading:  return .leading
        case .trailing: return .trailing
        }
    }
}

// MARK: - PrismSoundEffect

#if os(iOS)
/// An audio effect that plays as feedback when a
/// ``PrismChangeEffect/feedback(_:)-soundeffect`` effect fires.
///
/// Playback is not guaranteed — it respects the user's silent switch and the
/// current audio route. Always pair audio feedback with a visible cue.
public struct PrismSoundEffect: Sendable {

    // MARK: Internal

    internal let base: SoundEffect

    private init(_ base: SoundEffect) { self.base = base }

    // MARK: Public

    /// Creates a sound effect from a named audio resource in a bundle.
    ///
    /// - Parameters:
    ///   - name: The filename of the resource (without extension).
    ///   - bundle: The bundle to search. Defaults to `.main`.
    public init(_ name: String, bundle: Bundle = .main) {
        base = SoundEffect(name, bundle: bundle)
    }

    /// Creates a sound effect from an audio file URL.
    public init(url: URL) {
        base = SoundEffect(url: url)
    }

    /// Returns a copy of this effect at a custom volume level.
    ///
    /// - Parameter value: A value between `0.0` (silent) and `1.0` (full volume).
    public func volume(_ value: Double) -> PrismSoundEffect {
        .init(base.volume(value))
    }
}
#endif
