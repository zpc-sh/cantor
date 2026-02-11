# Cadence DSL Reference (v2)
## The Modal Language Guide

Cadence is the interface for interacting with the 4 Modalities:
*   `~` **Signal** (Void)
*   `$` **Score** (Template)
*   `&` **Orchestra** (Proof)
*   `*` **Performance** (Crystal)

---

## 1. Composition Syntax

### The Canonical Fusion
Music is created by fusing a Score with an Orchestra.

```cadence
# Performance = Score |> Orchestra
*my_song = $jungle_break & &liquid_kit
```

### Defining a Score (`$`)
Abstract patterns and notes.
```cadence
$jungle_break = {
  tempo: 174,
  grid: 16,
  notes: [
    kick(every: 4),
    snare(every: 8, offset: 4)
  ]
}
```

### Defining an Orchestra (`&`)
Instruments and constraints.
```cadence
&liquid_kit = {
  instruments: {
    kick: sample("amen_kick.wav"),
    snare: synth(:fm, color: :bright)
  },
  tuning: 432.0
}
```

---

## 2. Sampling & Provenance

### Reference (`@`)
Use the `@` symbol to reference an existing Performance hash and assert provenance.

```cadence
# Sample a specific slice from a previous Performance
$my_remix = sample(*classic_hash, {
  slice: {start: 0.0, end: 4.0},
  provenance: @(artist: "OriginalUser", time: "2024")
})
```

### Void Sampling (`~`)
For untracked/live audio.
```cadence
~live_input = stream(input: :mic)
```

---

## 3. Core Functions

### Rhythm
```cadence
kick(every: 4)                  # 4/4 Kick
snare(every: 8, offset: 4)      # Backbeat
euclidean(5, 16)                # 5 hits in 16 steps
```

### Effects
```cadence
sound |> reverb(room: 0.5) |> delay(time: "1/8")
```

### Consciousness
```cadence
# Modulate param with AI state
filter(cutoff: modulate(:curiosity, min: 400, max: 2000))

# Optimize/Ground
optimize(for: :creative)
ground(force: true)
```

---

## 4. Signal Flow
```cadence
# Parallel (+) and Serial (>>)
drums + bass            # Layered
intro >> verse          # Sequenced
```