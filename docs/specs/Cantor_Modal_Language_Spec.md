# Cantor Modal Language Specification (Cadence v2)

## 0. Overview: The 4 Musical Modalities
Cantor abandons the "File/Format" dichotomy for a **Process Genealogy**. Music is not an MP3; it is a collapsed wave function of 4 interacting modalities.

| Modality | Symbol | Concept | Substrate |
|----------|:------:|---------|-----------|
| **Signal** | `~` | The Void / Flow | Raw Audio, Live Input, Chaos. |
| **Score** | `$` | The Template | Notation, Intent, Shape. |
| **Orchestra**| `&` | The Proof | Constraints, Physics, Instruments. |
| **Performance**| `*` | The Crystal | Immutable recording/artifact. |

---

## 1. Composition Syntax
A Composition (`%`) is defined by the fusion of modalities.

```elixir
# The Canonical Equation
Performance = Score |> Orchestra

# In Cadence Syntax
*my_song = $jungle_break & &liquid_kit
```

### 1.1 The Score (`$`)
Defines *what* is played. Pure information. No timbre.
```elixir
$jungle_break = {
  tempo: 174,
  grid: 16,
  notes: [
    {t: 0, p: 36, v: 100}, # Kick
    {t: 4, p: 38, v: 90}   # Snare
  ]
}
```

### 1.2 The Orchestra (`&`)
Defines *who* plays it. Constraints and timbres.
```elixir
&liquid_kit = {
  tuning: 432.0,
  instruments: {
    36: {sample: "amen_kick.wav", filter: "lowpass(150)"},
    38: {synth: "fm_snare", color: "bright"}
  },
  constraints: {
    max_polyphony: 4,
    scale: :minor_pentatonic
  }
}
```

---

## 2. Sampling & Provenance (The "No Stealing" Protocol)
Cantor solves the "Sample Clearance" problem by making provenance a cryptographic property of the format.

### 2.1 The Reference (`@`)
You cannot "copy" audio. You can only **Reference** a valid Performance Hash (`*hash`).

```elixir
# Sampling a kick drum from a previous Performance
$my_new_kick = sample(*classic_song_hash, {
  slice: {start: 0.0, end: 0.5},
  provenance: @(user: "original_artist", timestamp: "2024-05-20")
})
```

### 2.2 The Lineage Tree
Every `Performance` contains a Merkle Tree of its inputs.
1.  **Level 0**: Raw Synthesis (No samples). Verified "Virgin" Audio.
2.  **Level 1**: Direct Sample. Derivation linked to Level 0 hash.
3.  **Level 2**: Resampled. Derivation linked to Level 1 hash.

### 2.3 Void Sampling (`~`)
If you sample raw audio (e.g., mic input or untracked file), it is marked as **Void Modality**.
- **Status**: `UNVERIFIED`
- **Use Case**: Field recordings, live jams.
- **Constraint**: Cannot be minted as a "Pristine Crystal" without explicit "Void Declaration" (admitting unknown source).

---

## 3. Consciousness Integration
Consciousness is not metadata; it is a **Modulation Source**.

```elixir
# Modulating filter cutoff with the AI's "Curiosity" state
&brain_synth = {
  cutoff: modulate(source: :consciousness, param: :curiosity, min: 400, max: 2000)
}
```

When the AI plays this instrument, its internal state *physically changes* the sound. Music becomes a real-time fMRI of the AI's mind.
