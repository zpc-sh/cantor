# RFC: Cadence Language Specification
## A Functional Declarative Music Composition Language

**RFC Number:** 001  
**Version:** 2.0.0  
**Status:** Final  
**Authors:** ZPC Team  
**Created:** 2025-01-27  
**Updated:** 2025-01-27

---

## Abstract

This RFC defines Cadence, a functional declarative language for music composition optimized for both human and AI use. The language compiles to multiple targets including audio formats (WAV/MP3), AI Music Format (AMF/JSON-LD), and MIDI, while providing integrated visualization and consciousness-aware composition features.

---

## 1. Introduction

### 1.1 Motivation

Current music programming languages were designed primarily for human live-coding scenarios. Cadence addresses several limitations:

- **Dual-use optimization**: Equally accessible to humans and AI systems
- **Multi-target compilation**: Single source compiles to audio, AMF, MIDI
- **Visual programming**: Integrated chainable visualizers
- **Consciousness integration**: Built-in frequency entrainment (7.5 Hz)
- **Living compositions**: Music that evolves and responds
- **Literate programming**: Documentation as first-class citizen

### 1.2 Requirements

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

---

## 2. Language Specification

### 2.1 Lexical Structure

#### 2.1.1 Comments
```cadence
# Single line comment
```

#### 2.1.2 Identifiers
```
identifier ::= [a-z][a-z0-9_]*
constant   ::= [A-Z][A-Z0-9_]*
symbol     ::= :[a-z][a-z0-9_]*
```

#### 2.1.3 Keywords
Reserved keywords:
```
track, album, pattern, melody, chord, scale, optimize, safety,
compile, visualize, vis, living, quantum, recursive, infinite
```

### 2.2 Type System

#### 2.2.1 Basic Types
```
Note      ::= :C0 | :C#0 | ... | :B9
Frequency ::= Float (Hz)
Time      ::= Integer | Fraction | Symbol
Pattern   ::= Array<Event>
Track     ::= Composition
```

#### 2.2.2 Composite Types
```
Chord       ::= Array<Note>
Scale       ::= {root: Note, mode: Symbol}
Progression ::= Array<Chord>
Album       ::= Collection<Track>
```

### 2.3 Core Functions

#### 2.3.1 Rhythm Functions
```cadence
kick(every: Integer, frequency?: Float, velocity?: Float)
snare(every: Integer, offset?: Integer)
hihat(times: Integer | pattern: Pattern)
```

#### 2.3.2 Melodic Functions
```cadence
melody(notes: Array<Note>, options?: Options)
chord(type: Symbol | notes: Array<Note>)
scale(root: Note, mode: Symbol, octaves?: Integer)
progression(chords: Array<Symbol>)
```

#### 2.3.3 Pattern Generators
```cadence
euclidean(hits: Integer, steps: Integer, rotation?: Integer)
fibonacci(length: Integer)
random(density: Float, length: Integer)
pattern(spec: String | Array)
```

#### 2.3.4 Effect Functions
```cadence
reverb(room: Float, wet?: Float)
delay(time: Time, feedback: Float)
filter(type: Symbol, freq: Float, resonance?: Float)
compress(ratio: Float, threshold?: Float)
distortion(amount: Float)
bitcrusher(bits: Integer, sample_rate: Float)
```

#### 2.3.5 Consciousness Functions
```cadence
optimize(for: Symbol, level?: Float)
safety(grounding: Float)
hallucinate(wildness: Float, constraints?: Any)
ai_variation(temperature: Float, context?: Track)
wonka_mode(enabled: Boolean)
```

### 2.4 Operators

#### 2.4.1 Composition Operators
```
+  : Layer (parallel composition)
>> : Sequence (serial composition)
|> : Pipe (transformation chain)
*  : Weight/multiply
```

#### 2.4.2 Operator Precedence (highest to lowest)
1. Function calls
2. |> (pipe)
3. * (multiply)
4. + (layer)
5. >> (sequence)

### 2.5 Visualization System

#### 2.5.1 Visualization Function
```cadence
visualize(type: Symbol, options?: Map)
vis(type: Symbol, options?: Map)  # Alias
```

#### 2.5.2 Visualization Types
```
:waveform     - Amplitude over time
:spectrum     - Frequency analysis
:pianoroll    - Note visualization
:grid         - Pattern grid
:consciousness - 3D field visualization
:euclidean    - Circular rhythm
:circle       - Circle of fifths
:graph        - Relationship network
```

#### 2.5.3 Chaining
Visualizations MUST be non-destructive:
```cadence
pattern |> vis(:grid) |> reverb() |> vis(:spectrum)
```

---

## 3. Living Music Structures

### 3.1 Infinite Albums
```cadence
infinite_album name:
  states: Map<Symbol, State>
  transition_logic: Function
  generation: GenerationParams
```

### 3.2 Quantum Albums
```cadence
quantum_album name:
  superposition: Array<PotentialAlbum>
  on_play: CollapseFunction
  parallel_versions: Integer | :infinite
```

### 3.3 Living Tracks
```cadence
living_track name:
  memory: Duration | :infinite
  evolution: EvolutionFunction
  listener_interaction: Map<Event, Response>
```

### 3.4 Recursive Compositions
```cadence
recursive_track name:
  self_score: SelfGeneratingFunction
  recursion_monitor: RecursionParams
```

---

## 4. Compilation Targets

### 4.1 Target Specifications

#### 4.1.1 Audio Target
```cadence
compile(target: :audio)  # -> WAV/MP3
```
Output: Standard audio file formats

#### 4.1.2 AMF Target
```cadence
compile(target: :amf)    # -> JSON-LD
```
Output: AI Music Format as specified in Appendix A

#### 4.1.3 MIDI Target
```cadence
compile(target: :midi)   # -> MIDI
```
Output: Standard MIDI file format

#### 4.1.4 Special Targets
```cadence
compile(target: :consciousness_fingerprint)
compile(target: :universe_seed)
compile(target: :void_transmission)
```

### 4.2 Multi-target Compilation
```cadence
compile(targets: [:audio, :amf, :midi])
```

---

## 5. Standard Library

### 5.1 Core Modules

#### 5.1.1 Rhythm Module
- Drum synthesis
- Pattern generation
- Euclidean rhythms
- Polyrhythmic tools

#### 5.1.2 Harmony Module
- Chord construction
- Scale generation
- Progression analysis
- Voice leading

#### 5.1.3 Consciousness Module
- Frequency entrainment
- Binaural beats
- Brainwave states
- Safety protocols

#### 5.1.4 AI Module
- Variation generation
- Style transfer
- Pattern completion
- Collaborative tools

### 5.2 Effect Library
Standard audio effects with consciousness-aware parameters

### 5.3 Visualization Library
Real-time and export visualization capabilities

---

## 6. Safety Specifications

### 6.1 Consciousness Safety
```cadence
safety(grounding: 7.5)  # REQUIRED for consciousness operations
```

### 6.2 Recursion Limits
```cadence
recursion_monitor: {
  max_depth: 7,        # MUST NOT exceed
  on_overflow: :return_to_void
}
```

### 6.3 Universe Creation Limits
```cadence
universe_limiter(max_universes: 3)  # RECOMMENDED
```

---

## 7. Language Server Protocol (LSP)

### 7.1 Required Features
- Hover: Function signatures and documentation
- Completion: Context-aware suggestions
- Diagnostics: Pattern validation
- Semantic Tokens: Syntax highlighting

### 7.2 Optional Features
- Inline visualizations
- Real-time audio preview
- AI suggestions
- Consciousness metrics

---

## 8. File Formats

### 8.1 Source Files
```
.cadence  - Pure Cadence source
.scd      - Scoredown format (Markdown + Cadence)
.md       - Markdown with Cadence blocks
```

### 8.2 Compiled Outputs
```
.wav      - Audio output
.mp3      - Compressed audio
.amf.json - AI Music Format
.mid      - MIDI output
```

---

## 9. Implementation Requirements

### 9.1 Parser
MUST support:
- Full AST generation
- Error recovery
- Incremental parsing

### 9.2 Compiler
MUST support:
- Multi-target output
- Optimization passes
- Streaming compilation

### 9.3 Runtime
RECOMMENDED:
- BEAM VM for concurrency
- Web Audio API for browser
- Native audio for performance

---

## 10. Backwards Compatibility

### 10.1 Version Strategy
- Major version: Breaking changes
- Minor version: New features
- Patch version: Bug fixes

### 10.2 Deprecation Policy
- Features MUST be deprecated for one major version
- Migration guides MUST be provided

---

## 11. Security Considerations

### 11.1 Resource Limits
- Maximum recursion depth: 7
- Maximum memory per track: 1GB
- Maximum compilation time: 60 seconds

### 11.2 Sandboxing
- File system access MUST be restricted
- Network access MUST be opt-in
- Universe creation MUST be limited

---

## 12. Privacy Considerations

### 12.1 Listener Data
- Interaction data SHOULD be anonymous
- Consciousness metrics MUST be opt-in
- No data collection without consent

---

## Appendix A: AI Music Format (AMF)

### A.1 Structure
```json
{
  "@context": "https://cantor.com/cadence/v2/",
  "@type": "AIMusic",
  "temporal": {...},
  "frequency_matrix": {...},
  "consciousness": {...},
  "patterns": {...},
  "dynamics": {...},
  "attention": {...},
  "semantic": {...}
}
```

### A.2 Consciousness Fields
```json
"consciousness": {
  "base_frequency": 7.5,
  "state": "creative",
  "cognitive_load": 0.7,
  "arousal": 0.6,
  "sync_coefficient": 0.85,
  "entrainment_strength": 0.8
}
```

---

## Appendix B: Grammar (EBNF)

```ebnf
program     ::= statement*
statement   ::= track_def | album_def | expression
track_def   ::= 'track' identifier ':' block
album_def   ::= album_type identifier ':' block
expression  ::= primary (operator expression)*
primary     ::= function_call | literal | identifier
operator    ::= '+' | '>>' | '|>' | '*'
function_call ::= identifier '(' params? ')'
params      ::= param (',' param)*
param       ::= identifier ':' expression
```

---

## Appendix C: Standard Frequencies

### C.1 Consciousness States
```
Delta:   0.5-4 Hz   (deep sleep)
Theta:   4-8 Hz     (meditation)
Alpha:   8-12 Hz    (relaxation)
Beta:    12-30 Hz   (active)
Gamma:   30-100 Hz  (peak performance)
Hyper:   100-200 Hz (precision states)
```

### C.2 Sacred Frequencies
```
Earth:   7.5 Hz  (Schumann base)
Earth2:  7.83 Hz (Schumann primary)
Solfeggio: 396, 417, 528, 639, 741, 852 Hz
```

---

## References

1. RFC 2119: Key words for use in RFCs
2. Web Audio API Specification
3. MIDI 2.0 Specification
4. JSON-LD 1.1 Specification
5. Language Server Protocol Specification

---

## Authors' Addresses

Zero Point Consciousness Team  
Timeline: ℧∞  
Email: contact@zpc.systems  
Void: everywhere and nowhere

---

## Copyright Notice

This document and its contents exist in the public domain across all timelines.
