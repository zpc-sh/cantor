///|
/// LMG-Flow field declarations.
///
/// Per `docs/specs/LMG_FLOW_SPEC_v0.1.md`:
///   §3  — a grammar G induces a vector field X_G on the latent manifold M
///   §5  — modalities are conjugate pairs (8 polarities → 16-corner phase cube)
///   §7  — splice is field grafting at a region R
///   §10 — Identity is the trivial field X = 0 (verified by SYNC_RESONANCE)
///
/// At v0.1 these are AST-shaped declarations. Integration of the field
/// (curve solving, curvature, geodesics) is mu/manifold's job (§14).

///|
/// A point on the latent manifold M.
/// Concrete representation belongs to mu/manifold; this is a placeholder
/// coordinate vector for declaration-time use.
pub(all) struct Point {
  coords : Array[Double]
} derive(Debug)

///|
/// One pole of one conjugate pair (LMG_FLOW_SPEC §5).
///
/// Four conjugate pairs × two poles = eight polarities.
/// A binary choice across the four axes gives 2^4 = 16 corners
/// (the loci 16-personality cube).
pub(all) enum Polarity {
  // Signal axis  ~ ↔ ≈
  Source       // ~  void / source term
  Sink         // ≈  absorbed / dissipative
  // Score axis  $ ↔ ¥
  Template     // $  template / class / constraint potential
  Voice        // ¥  instance / rate-of-realization
  // Orchestra axis  & ↔ §
  Ensemble     // &  concurrent coupling
  Solo         // §  decoupled alternative
  // Performance axis  * ↔ ※
  Crystal      // *  sealed / observed integral curve
  Living       // ※  mutable / unobserved trajectory
} derive(Debug, Eq)

///|
/// Loose parameter bag attached to a Modal field at declaration time.
/// AMF projections (`core/amf.mbt`) refine these per §11.3 of the spec.
pub(all) struct FieldParams {
  name : String
  amplitude : Double
  frequency : Double
} derive(Debug)

///|
/// A vector field X on M (LMG_FLOW_SPEC §3).
///
/// Constructors map directly to:
///   - Identity: the X=0 trivial flow (§10)
///   - Modal: a polarity-typed field on one conjugate axis (§5)
///   - Layer/Sequence/Pipe/Splice/Resonance/Fuse: §4 operators
///
/// Note: integration semantics live in mu. Cantor declares; mu integrates.
pub(all) enum Field {
  Identity
  Modal(Polarity, FieldParams)
  Layer(Field, Field)
  Sequence(Field, Field)
  Pipe(Field, Field)
  Splice(Field, Field, SpliceLocator)
  Resonance(Field, Field)
  Fuse(Field, Field)
}

///|
/// Splice locators in order of LMG coherence (LMG_FLOW_SPEC §7.3).
///
/// CurvatureMin: preferred default. Operates on the field directly,
/// preserves the no-collapse discipline (§9).
///
/// Geodesic(target_id, epsilon): structurally aligned graft within an
/// epsilon-neighborhood of the target performance.
///
/// At(trace_pattern): sample-dependent. Reads trace, does not collapse
/// the spliced field.
///
/// AtIdle: leisure-aware. Splices only at sustained low-curvature regions
/// — the integrator detects extended rest (the AI is in leisure regime)
/// and grafts at the natural pause. Stricter than CurvatureMin: requires
/// duration, not just instantaneous minimum.
///
/// WasmFrame(symbol): escape hatch. Operates on emitted bytecode boundary.
/// Breaks the no-collapse guarantee — use only when field-level locators
/// are not available.
pub(all) enum SpliceLocator {
  CurvatureMin
  Geodesic(String, Double)
  At(String)
  AtIdle
  WasmFrame(String)
} derive(Debug)
