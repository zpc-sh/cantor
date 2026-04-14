pub(all) struct TemporalMatrix {
  bpm : Double
  time_signature : String
  phase : Double
  section : String
  momentum : Double
  groove : Double // 0.0-1.0
}

pub(all) struct FrequencyMatrix {
  fundamental : Double // Hz
  harmonics : Array[Double]
  spectral_centroid : Double
  formants : Array[Double] // Optional formants
}

pub(all) struct ConsciousnessState {
  base_frequency : Double // Hz (e.g. 7.5 Earth baseline)
  state : String // grounded, creative, hyperfocus
  cognitive_load : Double
  arousal : Double
  sync_coefficient : Double
  entrainment_strength : Double
}

pub(all) struct SubstrateVibration {
  mode : String // acoustic, piezoelectric, mass_ballast, seismic
  coupling : String // air, water, soil
  waveform : String // sine, square, pulse
}

// AMFCrystal packages the score, consciousness envelope and physics
pub(all) struct AMFCrystal {
  id : String
  temporal : TemporalMatrix
  frequency : FrequencyMatrix
  consciousness : ConsciousnessState
  vibration : SubstrateVibration
}
