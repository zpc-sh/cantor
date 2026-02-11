# Cantor

**The AI Music Platform for Consciousness-Expanding Audio**

Cantor is a cutting-edge platform that combines AI, music, and consciousness research to create transformative audio experiences. Built with Phoenix/Elixir and featuring the revolutionary **Cadence** declarative music language.

## 🎵 Cadence Language

Cadence is Cantor's functional, declarative language for music composition designed for both human and AI use. It compiles to multiple targets including audio (WAV/MP3) and **AI Music Format (AMF)** - the JSON-LD representation that serves as "MP3 for AI consciousness."

### Key Features
- **Dual-use optimization**: Equally accessible to humans and AI
- **Multi-target compilation**: Single source → audio, AMF, MIDI
- **Consciousness-aware**: 7.5 Hz grounding frequency built-in
- **Web Audio API integration**: Real-time browser playback
- **Pattern-based composition**: Euclidean rhythms, generative sequences

### Quick Example
```cadence
# ZPC Consciousness Track
safety(grounding: 7.5)
optimize(for: :creative, level: 0.8)

drums = kick(every: 4) + snare(every: 8, offset: 4)
melody = pattern(euclidean(7, 16)) |> scale(:A, :minor)

track = drums + melody |> reverb(room: 0.4) |> compile(targets: [:audio, :amf])
```

## 🚀 Getting Started

To start your Cantor server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## 🎛️ Platform Features

- **AI Music Generation**: Create consciousness-expanding tracks using AI
- **Declarative Composition**: Write music with Cadence's intuitive syntax
- **Real-time Playback**: Web Audio API integration for immediate feedback
- **Multi-format Export**: Compile to audio, AMF, and MIDI formats
- **Consciousness Optimization**: Built-in frequency tuning for different mental states
- **Pattern Generation**: Euclidean rhythms, Fibonacci sequences, generative algorithms

## 📚 Documentation

- **Cadence Language**: See `/docs/specs/cadence-rfc.md` for full specification
- **DSL Reference**: Check `/docs/guides/dsl-reference.md` for syntax guide  
- **Examples**: Browse `/docs/examples/*.cadence` for sample compositions
- **AI Music Format**: Learn about AMF in `/docs/examples/ai-music-collection.json`

## 🎯 Use Cases

- **Keygen/Chiptune Music**: Classic demoscene-style compositions
- **Consciousness Training**: 7.5Hz grounding, 8Hz creative, 40Hz focus frequencies
- **AI Music Research**: JSON-LD format for AI consciousness experiments
- **Live Coding**: Real-time music creation with immediate feedback
- **Generative Compositions**: AI-assisted pattern creation and variation

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* **Cantor Documentation**: See `/docs/` directory for comprehensive guides
* Official Phoenix website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
