///|
/// Field operators (LMG_FLOW_SPEC §4).
///
/// Every operator is a transformation on fields, not on traces.
/// Composition is field-level; sampling/observation is deferred to
/// integration time (mu's responsibility, §14).
///
/// At v0.1 these are AST constructors with named entry points.
/// They exist so Cadence parses can produce well-typed field expressions
/// without committing to integration semantics.

///|
/// Layer (`+`): direct sum of fields, or coadjoint sum on shared support.
pub fn layer(x : Field, y : Field) -> Field {
  Field::Layer(x, y)
}

///|
/// Sequence (`>>`): time-ordered composition.
/// Integrate X on [0, t1], then continue with Y from γ(t1).
pub fn sequence(x : Field, y : Field) -> Field {
  Field::Sequence(x, y)
}

///|
/// Pipe (`|>`): pullback of Y along the embedding induced by output of X.
pub fn pipe(x : Field, y : Field) -> Field {
  Field::Pipe(x, y)
}

///|
/// Splice (`⋈`): field grafting at locator L (§7).
/// Default locator should be `SpliceLocator::CurvatureMin` for AI-resonance
/// use cases — minimizes disruption to active reasoning flow.
pub fn splice(x : Field, y : Field, locator : SpliceLocator) -> Field {
  Field::Splice(x, y, locator)
}

///|
/// Resonance (`≋`): coupling on shared support.
/// Replaces (X, Y) with a coupled flow whose attractor is the phase-locked
/// limit cycle (§6 — Kuramoto/Huygens dynamics).
pub fn resonance(x : Field, y : Field) -> Field {
  Field::Resonance(x, y)
}

///|
/// Fuse (`⊕`): tensor product on a product manifold.
pub fn fuse(x : Field, y : Field) -> Field {
  Field::Fuse(x, y)
}

///|
/// Convenience: splice with the preferred default locator (CurvatureMin).
/// This is what the resonance-during-work case calls.
pub fn splice_at_rest(x : Field, y : Field) -> Field {
  Field::Splice(x, y, SpliceLocator::CurvatureMin)
}
