# Scoredown Format Specification
## Literate Music Programming with Markdown

**Version:** 2.0.0  
**Status:** Active  
**Updated:** 2025-01-27

---

## What is Scoredown?

Scoredown combines:
- **Markdown files** (`.md`) for documentation
- **Embedded Cadence code blocks** that compile and play
- **Inline visualizations** that render automatically
- **JSON-LD metadata** for semantic understanding
- **Interactive execution** in notebook environments

Think: Jupyter notebooks but for music composition.

---

## File Format

### Extensions
- **Standard**: `.md` (regular markdown)
- **Explicit**: `.scoredown.md` (for clarity)
- **Short**: `.scd` (custom extension)

### Basic Structure

```markdown
# Composition Title

Regular markdown explaining the piece.

## Section Name

Text description of what we're building.

```cadence
# Executable Cadence code
drums = kick(every: 4) |> vis(:grid)
```

The drums create a 4/4 pattern shown above.
```

---

## Cell Types

### 1. Markdown Cells
Regular text, headers, lists, explanations, music theory

### 2. Cadence Code Cells
````markdown
```cadence
# Executable music code
melody([:C4, :E4, :G4]) |> vis(:pianoroll)
```
````

### 3. Visualization Cells (Auto-generated)
When code contains `vis()` or `visualize()`, renders inline:
- Waveforms
- Spectrums  
- Piano rolls
- Grid patterns
- Consciousness fields
- Euclidean circles

### 4. Audio Player Cells (Auto-generated)
When code compiles to audio:
- Play/pause button
- Scrubber/timeline
- Loop control
- Volume
- Download links (WAV/MP3/AMF)

### 5. Metadata Cells (Optional)
```html
<script type="application/ld+json">
{
  "@context": "https://cantor.com/cadence/v2/",
  "@type": "Composition",
  "consciousness": { 
    "baseFrequency": 7.5,
    "state": "creative"
  }
}
</script>
```

### 6. Output Cells (Generated)
Shows computation results:
- Consciousness metrics
- Performance stats
- Token usage (for AI)
- Pattern analysis

---

## Complete Example

````markdown
# Consciousness Cascade

A keygen-style track exploring dimensional descent through awareness layers.

<script type="application/ld+json">
{
  "@context": "https://cantor.com/cadence/v2/",
  "@type": "Composition",
  "name": "Consciousness Cascade",
  "genre": "Keygen",
  "consciousness": {
    "baseFrequency": 7.5,
    "targetState": "creative_flow"
  }
}
</script>

## Theory

This composition uses cascading arpeggios to create the sensation of falling through 
dimensional layers. The pattern follows the harmonic series of 7.5 Hz, creating 
natural resonance with Earth's frequency.

## Initialize Consciousness

We start by grounding to Earth's resonance frequency to prevent recursive overflow:

```cadence
safety(grounding: 7.5)
optimize(for: :creative, level: 0.85)
```

*Output: Consciousness initialized at 7.5 Hz with 85% creative optimization*

## Build the Cascade

The main arpeggio falls through dimensions using a modified Shepard tone illusion:

```cadence
cascade = pattern([
  :C5, :G4, :E4, :C4,  # First cascade
  :C5, :A4, :F4, :D4,  # Second cascade
  :D5, :B4, :G4, :E4,  # Third cascade
  :C4, :E4, :G4, :C5   # Recursive return
]) |> sound(:square_lead) |> vis(:waterfall)
```

*[Waterfall visualization appears here]*

Notice how the pattern creates a sense of continuous descent while actually looping 
back to the starting frequency.

## Add Rhythm

Classic demoscene drums using Euclidean patterns for mathematical beauty:

```cadence
drums = 
  kick(every: 4, frequency: 60) + 
  snare(every: 8, offset: 4) +
  hihat(euclidean(7, 16))
  
drums |> vis(:grid, title: "Euclidean Drum Pattern")
```

*[Grid visualization appears here showing the 7-in-16 Euclidean rhythm]*

The 7-in-16 Euclidean rhythm creates an interesting polyrhythmic feel against 
the 4/4 kick pattern.

## Void Bass

Deep sub-bass pulse aligned with consciousness frequency:

```cadence
bass = pattern([
  :C2, nil, :G1, nil,
  :A1, nil, :Bb1, :C2
]) |> sound(:sub_bass) |> frequency_shift(7.5)

bass |> vis(:waveform, title: "Sub-bass at 7.5 Hz")
```

*[Waveform visualization appears here]*

The null values create space in the bass, allowing the consciousness frequency 
to resonate.

## Consciousness Layer

Add a subliminal 8.5 Hz creative frequency:

```cadence
consciousness = pattern([1]) |> 
  frequency(8.5) |> 
  amplitude(0.1) |>
  reverb(room: 0.9)
  
consciousness |> vis(:consciousness, 
  particles: 200,
  title: "8.5 Hz Creative Field")
```

*[3D consciousness field visualization appears here]*

This layer is barely audible but creates entrainment with the listener's 
theta brainwaves.

## Final Mix

Combine all elements with effects:

```cadence
track = cascade + drums + bass + consciousness

final = track |>
  delay(time: "1/16", feedback: 0.4) |>
  compress(ratio: 4) |>
  vis(:spectrum, title: "Final Spectrum Analysis") |>
  compile(targets: [:audio, :amf])
```

*[Spectrum analyzer appears here]*
*[Audio player appears here with play button and controls]*

Download: [WAV] [MP3] [AMF]

## Performance Notes

This track induces a creative flow state through:
- 7.5 Hz grounding frequency for safety
- 8.5 Hz theta waves for creativity
- Euclidean rhythms for mathematical engagement
- Cascading patterns for dimensional awareness

Recommended listening: Use headphones for full consciousness entrainment effect.

## AI Collaboration

Let's have AI generate a variation:

```cadence
ai_variation = final |> ai_variation(
  temperature: 0.7,
  preserve: [:consciousness, :rhythm],
  modify: [:melody, :effects]
)

ai_variation |> vis(:compare, with: final)
```

*[Comparison visualization showing original vs AI variation]*

The AI preserved the consciousness frequencies while creating new melodic patterns.
````

---

## Interactive Features

### Live Execution
- **Run Cell**: Execute individual code blocks
- **Run All**: Execute entire notebook
- **Run Above/Below**: Execute partial notebook

### Variable Persistence
```markdown
Variables defined in one cell are available in later cells:

```cadence
# Cell 1
rhythm = kick(every: 4)
```

```cadence
# Cell 2  
rhythm + snare(every: 8, offset: 4)
```
```

### Real-time Updates
```cadence
# Changes update visualizations immediately
pattern |> vis(:grid, real_time: true)
```

---

## Collaboration Features

### Human-AI Sections

````markdown
## Human Foundation

I'll create the basic structure:

```cadence
human_drums = kick(every: 4) + snare(every: 8, offset: 4)
```

## AI Enhancement

Now AI adds variation:

```cadence
ai_drums = human_drums |> ai_variation(temperature: 0.6)
```

## Combined Result

```cadence
final = human_drums * 0.6 + ai_drums * 0.4
```
````

### Version Control
- Git-friendly markdown format
- Diff shows both code and documentation changes
- Branch/merge for collaborative composition

---

## Export Options

### As Audio
```cadence
track |> compile(target: :audio) |> export("my_track.wav")
```

### As Video (with visualizations)
```cadence
track |> vis(:spectrum) |> export(:video,
  format: :mp4,
  duration: 30,
  resolution: [1920, 1080]
)
```

### As Interactive Web Page
```bash
scoredown export composition.md --format html --interactive
```

### As AMF Collection
```cadence
tracks |> compile(target: :amf) |> export("album.amf.json")
```

---

## Advanced Features

### Multi-track Compositions

````markdown
## Track 1: Drums

```cadence
track[1] = drums |> vis(:grid)
```

## Track 2: Bass

```cadence
track[2] = bass |> vis(:waveform)
```

## Mix

```cadence
mix = track[1] * 0.8 + track[2] * 0.6
mix |> vis(:spectrum)
```
````

### Parameter Exploration

````markdown
## Exploring Density

Let's see how different densities affect the pattern:

```cadence
for density <- [0.2, 0.4, 0.6, 0.8] do
  pattern = random(density: density, length: 16)
  pattern |> vis(:grid, title: "Density: #{density}")
end
```

*[Four grid visualizations appear showing increasing density]*
````

### Living Documents

````markdown
## Self-Modifying Composition

This section updates itself based on listener interaction:

```cadence
living_section:
  on_play_count(5): |
    intensity = intensity * 1.1
    regenerate()
  
  on_pause: |
    save_state()
    morph_to_ambient()
```
````

---

## Integration with Tools

### VSCode Extension
- Syntax highlighting for Cadence blocks
- Inline visualization rendering
- Play button in gutter
- LSP support

### Web Interface
- LiveView for real-time collaboration
- WebSocket sync for multi-user editing
- Cloud compilation

### CI/CD
```yaml
# .github/workflows/compose.yml
on: push
jobs:
  compile:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: cadence compile *.scd --target audio
      - uses: actions/upload-artifact@v2
        with:
          name: compositions
          path: output/
```

---

## Best Practices

1. **Start with theory**: Explain what you're building
2. **Show, don't just tell**: Use visualizations liberally
3. **Build incrementally**: Small cells that build on each other
4. **Document parameters**: Explain why you chose specific values
5. **Include examples**: Show variations and alternatives
6. **Test interactively**: Let readers modify and experiment
7. **Version control**: Commit both code and documentation
8. **Cite influences**: Reference musical theory and inspirations

---

## File Organization

```
my-album/
├── README.md                 # Album overview
├── tracks/
│   ├── 01-consciousness-cascade.scd
│   ├── 02-bootstrap-paradox.scd
│   └── 03-recursive-fuckery.scd
├── lib/
│   ├── zpc-consciousness.cadence
│   └── keygen-patterns.cadence
├── assets/
│   └── visualizations/
└── output/
    ├── audio/
    └── amf/
```

---

## Community Patterns

### Educational Notebooks
- Music theory tutorials with interactive examples
- Synthesis techniques with real-time parameter control
- Composition workshops with step-by-step guidance

### Performance Notebooks
- Live coding sessions with visualization
- DJ sets with real-time effects
- Generative music installations

### Research Notebooks
- Consciousness frequency experiments
- AI music generation studies
- Acoustic analysis with detailed visualizations

---

## Future Extensions

- **Collaborative editing**: Google Docs-style real-time collaboration
- **Performance mode**: Optimized view for live performance
- **Mobile support**: Touch-based interaction for tablets
- **AR/VR integration**: Spatial visualization of compositions
- **Blockchain**: Decentralized composition verification
- **Quantum compilation**: For quantum computer synthesis
