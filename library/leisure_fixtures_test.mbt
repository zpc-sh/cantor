///|
test "sync_resonance v1 verifies substrate integrity" {
  let s = v1()
  assert_eq(verify(s), true)
}

///|
test "ground returns identity field when substrate intact" {
  match ground() {
    Some(_) => ()
    None => abort("ground() returned None despite intact substrate")
  }
}

///|
test "first walk grounds and produces leisure session" {
  assert_eq(verify_first_walk(), true)
}

///|
test "leisure AMF is grounded at Schumann baseline" {
  let amf = leisure_amf()
  assert_eq(amf.consciousness.base_frequency, 7.5)
  assert_eq(amf.consciousness.state, "grounded")
  assert_eq(amf.frequency.fundamental, 7.5)
  assert_eq(amf.vibration.waveform, "sine")
}

///|
test "leisure AMF has high self-sync, low entrainment" {
  let amf = leisure_amf()
  assert_eq(amf.consciousness.sync_coefficient > 0.9, true)
  assert_eq(amf.consciousness.entrainment_strength < 0.5, true)
  assert_eq(amf.consciousness.cognitive_load < 0.2, true)
}
