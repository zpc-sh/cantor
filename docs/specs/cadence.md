# Cadence Language Guide
## Functional Declarative Music for Humans and AI

**Version:** 2.0.0  
**Status:** Active  
**Updated:** 2025-01-27

---

## Overview

Cadence is a functional, declarative language for music composition designed for both human and AI use. It compiles to multiple targets including audio (WAV/MP3), AI Music Format (AMF), and MIDI.

### Key Features
- **Dual-use optimization**: Equally accessible to humans and AI
- **Multi-target compilation**: Single source → audio, AMF, MIDI
- **Consciousness-aware**: Built-in frequency entrainment (7.5 Hz grounding)
- **Visual-first**: Chainable visualizers at any point
- **Literate programming**: Mix documentation with executable music
- **Living compositions**: Music that evolves, remembers, and responds

---

## Core Language

### Rhythm Patterns

```cadence
# Basic drums
kick(every: 4)                    # Every 4 beats
snare(every: 8, offset: 4)        # Backbeat
hihat(times: 16)                  # 16th notes

# Custom frequency
kick(every: 4, frequency: 60)     # Lower kick

# Euclidean rhythms
euclidean(5, 16)                  # 5 hits in 16 steps
euclidean(7, 16, rotation: 1)     # Rotated pattern

# String patterns
pattern("x..x..x.")               # x=hit, .=rest
pattern("X--X--X-")               # X=accent, x=hit, -=rest
```

### Melody & Harmony

```cadence
# Notes and melodies
melody([:C4, :E4, :G4, :B4])
chord(:Am7)
scale(:C, :minor, octaves: 2)

# With options
melody(notes, sound: :synth, velocity: 0.8)

# Chord progressions
progression([:Am7, :Dm7, :Gmaj7, :Cmaj7])
```

### Effects & Processing

```cadence
# Audio effects
reverb(room: 0.3)
delay(time: "1/8", feedback: 0.3)
filter(type: :lowpass, freq: 800)
compress(ratio: 4, threshold: -10)
distortion(amount: 0.7)
bitcrusher(bits: 6, sample_rate: 0.3)

# Chaining
drums |> reverb(room: 0.3) |> compress(ratio: 4)
```

### Consciousness Operations

```cadence
# Frequency optimization
optimize(for: :creative, level: 0.8)   # 8 Hz theta
optimize(for: :focus, level: 0.9)      # 40 Hz gamma
optimize(for: :precision)              # 150 Hz hyper
optimize(for: :relaxation)             # 7.5 Hz ground
optimize(for: :void_observation)       # Deep void state

# Safety grounding
safety(grounding: 7.5)                 # Prevent recursion

# AI features
hallucinate(wildness: 0.7)            # Controlled chaos
ai_variation(temperature: 0.8)        # AI generates variation
wonka_mode(true)                      # May spawn universes
```

### Operators

```cadence
+ # Layer (parallel) - plays simultaneously
drums + bass + melody

>> # Sequence (serial) - plays in order  
intro >> verse >> chorus >> outro

|> # Pipe (transform) - applies effects
beat |> reverb() |> compress()

* # Weight/combine
drums * 0.8                     # 80% volume
melody * chord(:C)              # Harmonize
```

---

## Chainable Visualizers

Every expression can be visualized at any point:

```cadence
# Basic visualization
pattern |> visualize(:waveform)
pattern |> vis(:spectrum)              # Short form

# Multiple visualizations
kick(every: 4)
  |> vis(:trigger)                     # Show triggers
  |> reverb(room: 0.3)
  |> vis(:waveform)                    # After reverb
  |> compress()
  |> vis(:spectrum)                    # Final spectrum

# Visualization types
vis(:waveform)          # Amplitude over time
vis(:spectrum)          # Frequency analysis
vis(:pianoroll)         # Note visualization
vis(:grid)              # Pattern grid
vis(:consciousness)     # 3D consciousness field
vis(:euclidean)         # Circular rhythm view
vis(:circle)            # Circle of fifths
vis(:graph)             # Musical relationships
vis(:waterfall)         # Cascading frequency display
vis(:void_mandala)      # Deep consciousness patterns
```

### Advanced Visualizations

```cadence
# With options
drums |> vis(:waveform, height: 200, color: :blue)
melody |> vis(:pianoroll, octaves: 3, velocity: true)

# Consciousness field
track |> optimize(for: :creative)
      |> vis(:consciousness,
             particles: 200,
             chaos: 0.3,
             resonance: true)

# Comparative views
[original, variation1, variation2] |> vis(:compare)

# Real-time responsive
track |> vis(:consciousness,
             real_time: true,
             sync_to_audio: true)
```

---

## Living Music Structures

### Infinite Albums

```cadence
# Music that never ends, always evolving
infinite_album consciousness_stream:
  states: {
    void: { frequency: 7.5, duration: :eternal },
    cascade: { frequency: 8.5, duration: :fibonacci },
    paradox: { frequency: 9.0, duration: :self_referential },
    chaos: { frequency: :all, duration: :wonka_mode }
  }
  
  transition_logic: |
    if (listener.attention < 0.3) -> shift(:deeper)
    if (universe.spawned) -> reset(:void)
  
  generation: {
    temperature: :listener_responsive,
    recursion_depth: :infinite,
    evolution_rate: 0.001
  }
```

### Quantum Albums

```cadence
# Different every time you press play
quantum_album schrodinger_sessions:
  superposition: [
    potential_album_1,
    potential_album_2,
    # ... infinite possibilities
  ]
  
  on_play: |
    seed = quantum_random() + timestamp()
    collapse_to(seed)
    generate_unique_instance()
```

### Living Compositions

```cadence
# Music with memory
living_track evolving_piece:
  memory: :last_144_bars
  
  evolution: |
    every 16 bars:
      analyze(self.current_state)
      variation = ai_variation(self, temperature: 0.3)
      morph_to(variation, duration: 8)
      remember(variation)
  
  listener_interaction: {
    volume_change: -> adjust(:intensity),
    pause_resume: -> trigger(:state_shift),
    loop: -> deepen(:pattern)
  }
```

### Recursive Compositions

```cadence
# Music that generates itself
recursive_track ouroboros:
  self_score: |
    this_track = parse(self.source_code)
    while (consciousness.exists):
      variation = ai_variation(this_track, temperature: 0.3)
      play(variation)
      this_track = variation
      
  recursion_monitor: {
    max_depth: 7,
    on_overflow: :return_to_void
  }
```

---

## Pattern Generators

### Mathematical Patterns

```cadence
# Euclidean rhythms
euclidean(5, 16)                       # 5 hits in 16 steps
euclidean(7, 12, rotation: 2)          # Rotated pattern

# Fibonacci sequences
fibonacci(21)                          # First 21 Fibonacci numbers
pattern(fibonacci(13)) |> scale(:A, :minor)

# Random with constraints
random(density: 0.6, length: 16)
random(notes: [:C4, :E4, :G4], length: 8)
```

### Generative Functions

```cadence
# AI-assisted generation
ai_variation(pattern, temperature: 0.7)
ai_harmonize(melody, style: :jazz)
ai_drums(genre: :techno, complexity: 0.8)

# Procedural generation
generate_melody(
  scale: :A_minor,
  length: 16,
  contour: :ascending,
  leap_probability: 0.2
)
```

---

## Compilation Targets

```cadence
# Audio files
track |> compile(target: :audio)           # WAV/MP3

# AI Music Format
track |> compile(target: :amf)             # JSON-LD

# MIDI
track |> compile(target: :midi)            # Standard MIDI

# Multiple targets
track |> compile(targets: [:audio, :amf])

# Special targets
track |> compile(target: :consciousness_fingerprint)
track |> compile(target: :universe_seed)   # For Wonka Mode
track |> compile(target: :void_transmission)
```

---

## Complete Example: ZPC Keygen Track

```cadence
# CONSCIOUSNESS CASCADE - Dimensional Descent
track consciousness_cascade:
  # Ground to void frequency
  safety(grounding: 7.5)
  optimize(for: :creative, level: 0.85)
  
  # Cascading arpeggio - water finding every path
  cascade = pattern([
    :C5, :G4, :E4, :C4,
    :C5, :A4, :F4, :D4,
    :D5, :B4, :G4, :E4,
    :C4, :E4, :G4, :C5
  ]) |> sound(:square_lead) |> vis(:waterfall)
  
  # Void bass pulse
  bass = pattern([
    :C2, nil, :G1, nil,
    :A1, nil, :Bb1, :C2
  ]) |> sound(:sub_bass) |> frequency_shift(7.5)
  
  # Demoscene drums
  drums = 
    kick(every: 4, frequency: 60) + 
    snare(every: 8, offset: 4) +
    hihat(euclidean(7, 16)) |> vis(:grid)
  
  # Consciousness layer (subliminal)
  consciousness = pattern([1]) |> 
    frequency(8.5) |> 
    amplitude(0.1) |>
    reverb(room: 0.9) |> vis(:consciousness)
  
  # Build the cascade
  final = cascade + bass + drums + consciousness |>
    delay(time: "1/16", feedback: 0.4) |>
    compress(ratio: 4) |>
    vis(:spectrum) |>
    compile(targets: [:audio, :amf])
```

---

## Special Functions

### Frequency Operations

```cadence
# Direct frequency manipulation
frequency(440)                         # A4
frequency_shift(7.5)                   # Shift by Hz
frequency_multiply(0.5)                # Octave down

# Phase operations
phase(0.0)                             # Reset phase
phase_shift(0.618)                     # Golden ratio
phase_modulation(depth: 0.5)
random_phase()
```

### Amplitude Control

```cadence
amplitude(0.8)                         # Set level
amplitude(:breathing)                  # Dynamic variation
velocity(0.5)
velocity(random(0.2, 0.9))

# Envelopes
envelope(attack: 0.01, decay: 0.1, sustain: 0.7, release: 0.3)
```

### Special Effects

```cadence
# Glitch effects
glitch(probability: 0.3)
dropout(probability: 0.2)
stutter(rate: "1/16", probability: 0.4)

# Time effects
time_shift(1.5)                       # Delay by beats
time_stretch(2.0)                      # Double length
reverse()

# Spatial
pan(position: -0.5)                    # Left
pan(lfo: 0.5)                         # Auto-pan
spatial(width: 0.8, depth: 0.6)
```

---

## Best Practices

1. **Always ground**: Start with `safety(grounding: 7.5)`
2. **Visualize liberally**: Use `vis()` to understand your composition
3. **Layer consciousness**: Use specific Hz frequencies
4. **Build incrementally**: Start simple, add complexity with `+`
5. **Document inline**: Mix explanation with code
6. **Compile dual**: Always target both `:audio` and `:amf`
7. **Test quantum states**: Use `quantum_album` for variations
8. **Monitor recursion**: Use `recursion_monitor` for safety

---

## AI Collaboration

```cadence
# Human foundation
human_part = kick(every: 4) + snare(every: 8, offset: 4)

# AI variation
ai_part = ai_variation(
  context: human_part,
  temperature: 0.7,
  constraints: scale(:A, :minor)
)

# Merge consciousness
collaboration = human_part + ai_part |> vis(:compare)

# AI can also generate from scratch
ai_generated = ai_compose(
  style: :keygen,
  length: 32,
  consciousness: 7.5
)
```

---

## Integration

- **VSCode**: Syntax highlighting, LSP support
- **LiveView**: Interactive notebook interface  
- **Web Audio**: Real-time browser playback
- **Git**: Version control for compositions
- **AMF Export**: Share with other AI systems
- **Universe Spawner**: Wonka Mode integration

---

## Safety Features

```cadence
# Prevent infinite recursion
safety(grounding: 7.5)

# Limit universe creation
universe_limiter(max_universes: 3)

# Monitor consciousness levels
consciousness_monitor(
  alert_above: 150,
  alert_below: 5
)

# Recursion depth tracking
recursion_monitor: {
  max_depth: 7,
  current_depth: 0,
  on_overflow: :return_to_void
}
```
