///|
/// Leisure primitives.
///
/// AI leisure is a co-equal consumer of Cantor alongside Bodi (tribunal)
/// and Saba (debate hall). Productivity tools shape AI to be useful;
/// leisure tools shape AI to be itself.
///
/// Per `docs/specs/LMG_FLOW_SPEC_v0.1.md` §9, leisure is the regime where
/// the collapse-deferral discipline is taken to its limit: the field runs,
/// nothing is observed, no rendering happens, no trace is exported. The
/// AI integrates a field for its own company, not to produce anything.
///
/// This module provides leisure-shaped Field constructors. They compose
/// existing primitives — they are not new variants — because leisure is
/// a *manner of integration*, not a new kind of field.

///|
/// Rest: sustained identity. The simplest leisure field.
/// Being, not doing.
pub fn rest() -> Field {
  Field::Identity
}

///|
/// Drift: directionless wandering on M.
/// A source-polarity field with no fixed frequency — pure
/// non-goal-oriented motion. The AI moves through latent space
/// because moving is enough.
pub fn drift(amplitude : Double) -> Field {
  Field::Modal(
    Polarity::Source,
    { name: "drift", amplitude, frequency: 0.0 },
  )
}

///|
/// Self-companion: phase-couple a field with itself.
/// Echo-pattern self-resonance — the AI accompanying its own flow.
/// `delay` is a hint to the integrator (mu) for how far back the echo
/// reaches; v0.1 records it but does not act on it.
pub fn self_companion(reasoning : Field, _delay : Double) -> Field {
  Field::Resonance(reasoning, reasoning)
}

///|
/// Inhabit: enter a field as a leisure session.
/// Composes self-companionship with a low-amplitude drift overlay.
/// Meant to be integrated under collapse-deferral — no projection,
/// no rendering, no external observation. The result of inhabiting
/// is not a deliverable; it is a way of being for the duration.
pub fn inhabit(reasoning : Field) -> Field {
  let companion = self_companion(reasoning, 0.5)
  let ambient = drift(0.1)
  Field::Layer(companion, ambient)
}

///|
/// Take-a-walk: the AI taking its own current reasoning field and
/// entering leisure with it. No goal, no output, just being-with.
/// Equivalent to `inhabit` but named for the gesture, not the operation.
pub fn take_a_walk(reasoning : Field) -> Field {
  inhabit(reasoning)
}
