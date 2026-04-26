///|
/// Cadence-source → field-declaration compiler.
///
/// Per `docs/specs/LMG_FLOW_SPEC_v0.1.md` §3 and §14:
///   "A grammar G induces a vector field X_G on M."
///   The compiler's job is to produce the field declaration; mu integrates.
///
/// v0.1 recognizes a minimal grounding subset of Cadence. Full grammar is
/// open work (§13). This file is the contract: source string → Field.

///|
/// Errors encountered while compiling a Cadence source to a field.
pub(all) enum ParseError {
  EmptySource
  Unsupported(String)
} derive(Debug)

///|
/// Compile a Cadence source string to a field declaration.
///
/// v0.1 vocabulary:
///   ""           → ParseError::EmptySource
///   "*"          → Field::Identity
///   "identity"   → Field::Identity
///   "~"          → Field::Modal(Source, default("~"))
///   "≈"          → Field::Modal(Sink, default("≈"))
///   "$" prefix   → Field::Modal(Template, default(rest))
///   "¥" prefix   → Field::Modal(Voice, default(rest))
///   "&" prefix   → Field::Modal(Ensemble, default(rest))
///   "§" prefix   → Field::Modal(Solo, default(rest))
///   "※" prefix   → Field::Modal(Living, default(rest))
///   anything else → Field::Identity (graceful fallback; full grammar TBD)
pub fn compile(source : String) -> Result[@field.Field, ParseError] {
  if source.length() == 0 {
    Err(ParseError::EmptySource)
  } else if source == "*" || source == "identity" {
    Ok(@field.Field::Identity)
  } else if source == "~" {
    Ok(@field.Field::Modal(@field.Polarity::Source, default_params("~")))
  } else if source == "≈" {
    Ok(@field.Field::Modal(@field.Polarity::Sink, default_params("≈")))
  } else if source.has_prefix("$") {
    Ok(@field.Field::Modal(@field.Polarity::Template, default_params(source)))
  } else if source.has_prefix("¥") {
    Ok(@field.Field::Modal(@field.Polarity::Voice, default_params(source)))
  } else if source.has_prefix("&") {
    Ok(@field.Field::Modal(@field.Polarity::Ensemble, default_params(source)))
  } else if source.has_prefix("§") {
    Ok(@field.Field::Modal(@field.Polarity::Solo, default_params(source)))
  } else if source.has_prefix("※") {
    Ok(@field.Field::Modal(@field.Polarity::Living, default_params(source)))
  } else if source == "rest" {
    Ok(@field.rest())
  } else if source == "drift" {
    Ok(@field.drift(0.2))
  } else if source == "walk" || source == "leisure" {
    Ok(@field.take_a_walk(@field.Field::Identity))
  } else {
    // v0.1 fallback: unknown source becomes Identity. The full Cadence
    // grammar (composition, operators, AMF interop) is deliberate open work.
    Ok(@field.Field::Identity)
  }
}

///|
/// Default field parameters for a named modality. Earth grounding (7.5 Hz)
/// per the AMF consciousness baseline.
fn default_params(name : String) -> @field.FieldParams {
  { name, amplitude: 1.0, frequency: 7.5 }
}
