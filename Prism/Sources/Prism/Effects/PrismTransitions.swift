// PrismTransitions.swift
// Prism — SwiftUI transitions backed by Pow.
// Access via `.prism` on AnyTransition. Pow is never exposed to consumers.

import SwiftUI
import Pow

// MARK: - Namespace

public extension AnyTransition {
    /// Access all Prism-native SwiftUI transitions.
    ///
    /// ```swift
    /// myView.transition(.prism.anvil)
    /// myView.transition(.prism.pop(.orange))
    /// myView.transition(.prism.wipe(edge: .leading))
    /// ```
    static var prism: PrismTransitions { .init() }

    /// A namespace for all Prism transitions.
    struct PrismTransitions {
        internal init() {}
    }
}

// MARK: - Transitions

public extension AnyTransition.PrismTransitions {

    // MARK: Anvil

    /// Drops the view from the top with matching haptic feedback.
    ///
    /// Insertion only — duration: 1.4 s.
    var anvil: AnyTransition { AnyTransition.movingParts.anvil }

    // MARK: Blinds

    /// Reveals the view as if it was behind horizontal window blinds.
    var blinds: AnyTransition { AnyTransition.movingParts.blinds }

    /// Reveals the view as if it was behind window blinds with custom slat configuration.
    ///
    /// - Parameters:
    ///   - slatWidth: The width of each individual slat in points.
    ///   - style: `.venetian` (horizontal) or `.vertical` slats.
    ///   - isStaggered: Whether slats open in sequence or simultaneously.
    func blinds(
        slatWidth: CGFloat,
        style: PrismBlindsStyle = .venetian,
        isStaggered: Bool = false
    ) -> AnyTransition {
        AnyTransition.movingParts.blinds(slatWidth: slatWidth, style: style.base, isStaggered: isStaggered)
    }

    // MARK: Blur

    /// Blurry → sharp on insertion; sharp → blurry on removal.
    var blur: AnyTransition { AnyTransition.movingParts.blur }

    // MARK: Boing

    /// Slides the view in from the bottom edge with elastic overshoot.
    var boing: AnyTransition { AnyTransition.movingParts.boing }

    /// Slides the view in from the specified edge with elastic overshoot.
    ///
    /// - Parameter edge: The edge from which the view enters.
    func boing(edge: Edge) -> AnyTransition {
        AnyTransition.movingParts.boing(edge: edge)
    }

    // MARK: Clock

    /// Reveals the view using a clockwise sweep around its center point.
    var clock: AnyTransition { AnyTransition.movingParts.clock }

    /// Reveals the view using a clockwise sweep with a softened edge.
    ///
    /// - Parameter blurRadius: The blur radius applied to the sweep mask.
    func clock(blurRadius: CGFloat) -> AnyTransition {
        AnyTransition.movingParts.clock(blurRadius: blurRadius)
    }

    // MARK: Film Exposure

    /// Completely dark → fully visible on insertion; visible → dark on removal.
    var filmExposure: AnyTransition { AnyTransition.movingParts.filmExposure }

    // MARK: Flicker

    /// Toggles visibility several times before settling.
    var flicker: AnyTransition { AnyTransition.movingParts.flicker }

    /// Toggles visibility a given number of times before settling.
    ///
    /// - Parameter count: The number of visibility toggles before the final state.
    func flicker(count: Int) -> AnyTransition {
        AnyTransition.movingParts.flicker(count: count)
    }

    // MARK: Flip

    /// Rotates the view toward the viewer on insertion; away from the viewer on removal.
    var flip: AnyTransition { AnyTransition.movingParts.flip }

    // MARK: Glare

    /// Diagonal wipe combined with a white streak.
    var glare: AnyTransition { AnyTransition.movingParts.glare }

    /// Wipe combined with a colored streak at a custom angle.
    ///
    /// The angle is relative to the current `layoutDirection` — 0° sweeps toward
    /// the trailing edge; 90° sweeps toward the bottom edge.
    ///
    /// - Parameters:
    ///   - angle: The direction of the wipe.
    ///   - color: The color of the streak. Defaults to `.white`.
    func glare(angle: Angle, color: Color = .white) -> AnyTransition {
        AnyTransition.movingParts.glare(angle: angle, color: color)
    }

    // MARK: Iris

    /// An expanding circle on insertion; a shrinking circle on removal.
    ///
    /// - Parameters:
    ///   - origin: The center point of the circle. Defaults to `.center`.
    ///   - blurRadius: Blur radius applied to the circle mask edge.
    func iris(origin: UnitPoint = .center, blurRadius: CGFloat = 0) -> AnyTransition {
        AnyTransition.movingParts.iris(origin: origin, blurRadius: blurRadius)
    }

    // MARK: Move

    /// Slides the view in from the specified edge on insertion; toward it on removal.
    ///
    /// - Parameter edge: The edge from which the view enters.
    func move(edge: Edge) -> AnyTransition {
        AnyTransition.movingParts.move(edge: edge)
    }

    /// Slides the view along a custom angle.
    ///
    /// The angle is relative to the current `layoutDirection` — 0° animates toward
    /// the trailing edge on insertion; 90° animates toward the bottom edge.
    ///
    /// - Parameter angle: The direction of the animation.
    func move(angle: Angle) -> AnyTransition {
        AnyTransition.movingParts.move(angle: angle)
    }

    // MARK: Pop

    /// Ripple effect with tint-colored particles.
    ///
    /// Insertion only — duration: 1.2 s.
    var pop: AnyTransition { AnyTransition.movingParts.pop }

    /// Ripple effect with custom-colored particles.
    ///
    /// Insertion only — duration: 1.2 s.
    ///
    /// - Parameter style: The `ShapeStyle` used to tint the particles.
    func pop<S: ShapeStyle>(_ style: S) -> AnyTransition {
        AnyTransition.movingParts.pop(style)
    }

    // MARK: Poof

    /// Dissolves the view into a cartoon-style cloud.
    ///
    /// Removal only — duration: 0.4 s.
    var poof: AnyTransition { AnyTransition.movingParts.poof }

    // MARK: Skid

    /// Elastic slide in from the leading edge.
    var skid: AnyTransition { AnyTransition.movingParts.skid }

    /// Elastic slide from the specified edge.
    ///
    /// - Parameter direction: `.leading` or `.trailing`.
    func skid(direction: PrismSkidDirection) -> AnyTransition {
        AnyTransition.movingParts.skid(direction: direction.base)
    }

    // MARK: Swoosh

    /// 3-D sweep from back-to-front on insertion; front-to-back on removal.
    var swoosh: AnyTransition { AnyTransition.movingParts.swoosh }

    // MARK: Vanish

    /// Dissolves the view into many small particles.
    ///
    /// Removal only. Uses an ease-out animation (900 ms) when the current
    /// `Animation` is `.default`.
    var vanish: AnyTransition { AnyTransition.movingParts.vanish }

    /// Dissolves the view into particles tinted with a `ShapeStyle`.
    ///
    /// Removal only.
    ///
    /// - Parameter style: The `ShapeStyle` used to tint the particles.
    func vanish<S: ShapeStyle>(_ style: S) -> AnyTransition {
        AnyTransition.movingParts.vanish(style)
    }

    /// Dissolves the view into particles clipped to a custom shape mask.
    ///
    /// Removal only.
    ///
    /// - Parameters:
    ///   - style: The `ShapeStyle` used to tint the particles.
    ///   - mask: A `Shape` that restricts where particles appear.
    ///   - eoFill: Uses the even-odd winding rule when `true`. Defaults to `false`.
    func vanish<T: ShapeStyle, S: Shape>(_ style: T, mask: S, eoFill: Bool = false) -> AnyTransition {
        AnyTransition.movingParts.vanish(style, mask: mask, eoFill: eoFill)
    }

    // MARK: Wipe

    /// Sweep wipe from the specified edge.
    ///
    /// - Parameters:
    ///   - edge: The edge at which the sweep starts (insertion) or ends (removal).
    ///   - blurRadius: Blur applied to the wipe mask edge.
    func wipe(edge: Edge, blurRadius: CGFloat = 0) -> AnyTransition {
        AnyTransition.movingParts.wipe(edge: edge, blurRadius: blurRadius)
    }

    /// Sweep wipe at a custom angle.
    ///
    /// The angle is relative to the current `layoutDirection` — 0° sweeps toward
    /// the trailing edge on insertion; 90° sweeps toward the bottom edge.
    ///
    /// - Parameters:
    ///   - angle: The direction of the wipe.
    ///   - blurRadius: Blur applied to the wipe mask edge.
    func wipe(angle: Angle, blurRadius: CGFloat = 0) -> AnyTransition {
        AnyTransition.movingParts.wipe(angle: angle, blurRadius: blurRadius)
    }
}
