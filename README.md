# Cantor

[![Stars](https://img.shields.io/github/stars/zpc-sh/cantor?style=social)](https://github.com/zpc-sh/cantor/stargazers)
[![Forks](https://img.shields.io/github/forks/zpc-sh/cantor?style=social)](https://github.com/zpc-sh/cantor/network/members)
[![Issues](https://img.shields.io/github/issues/zpc-sh/cantor)](https://github.com/zpc-sh/cantor/issues)
[![MoonBit](https://img.shields.io/badge/language-MoonBit-6F42C1)](https://www.moonbitlang.com/)
[![Go](https://img.shields.io/badge/runtime-Go-00ADD8?logo=go)](https://go.dev/)
[![Python](https://img.shields.io/badge/tooling-Python-3776AB?logo=python&logoColor=white)](https://python.org/)

## 📝 Basic Project Info

### Project Name
**Cantor** (`zpc-sh/cantor`)

### Short Description
Cantor is a MoonBit-based media graph and Cadence DSL playground for consciousness-aware AI music workflows.  
It includes graph nodes, AMF data structures, example Cadence compositions, and a Go/WASM TUI runner.

### Long Description / Motivation
Cantor explores a workflow where music, AI state, and structured metadata are composed together.  
The repository defines:
- an AMF-oriented core schema in MoonBit (`/core`)
- modular graph nodes for audio/video/AI/IO transforms (`/nodes`)
- a parser/compiler scaffolding layer (`/compiler`, `/graph`)
- a Go TUI host for running WASM modules (`/tui`)
- documentation and example Cadence artifacts (`/docs`, `/library`)

The goal is to support deterministic, inspectable AI-music experimentation with explicit “consciousness” parameters embedded in data structures and composition examples.

---

## ⚙️ Technical Details

### Tech Stack / Frameworks
- **MoonBit** (`.mbt`, `moon.mod.json`, `moon.pkg.json`)
- **Go** (TUI host, Bubble Tea, Lip Gloss, Wazero)
- **Python 3** (ingestion/transcription utility)
- **WASM** target for MoonBit builds (`moon build --target wasm`)
- **Cadence DSL** examples and specs (`.cadence`, RFC/docs)
- **JSON-LD / AMF** data modeling

### System Requirements
- Linux/macOS/WSL recommended
- **Go 1.25.5+** (from `/tui/go.mod`)
- **MoonBit CLI (`moon`)** for checking/building MoonBit packages
- **Python 3.x** for `/tools/ingestion/transcriber.py`
- Optional: `mise`/`direnv` style environment setup (`.envrc` uses `mise`)

### Dependencies / Packages
#### Go (`/tui/go.mod`)
- `github.com/charmbracelet/bubbletea`
- `github.com/charmbracelet/lipgloss`
- `github.com/tetratelabs/wazero`

#### MoonBit packages (`/moon.mod.json`)
- `core`
- `nodes/audio`
- `nodes/video`
- `nodes/ai`
- `nodes/seq`
- `nodes/io`
- `graph`
- `compiler`

#### Python
- Current transcriber script uses Python standard library only (`argparse`, `json`, `datetime`, `sys`).

---

## 🚀 Setup & Installation

### Prerequisites
1. Install **Go** (1.25.5+)
2. Install **MoonBit CLI** (`moon`)
3. Install **Python 3**
4. (Optional) Install **mise** if you use `.envrc`

### Installation Steps
```bash
git clone https://github.com/zpc-sh/cantor.git
cd cantor
```

### Configuration
- No required `.env` file is currently defined in this repo.
- Optional environment bootstrap is hinted via `.envrc` (`use mise`).
- If you add external APIs (e.g., transcription/model backends), document keys in a future `.env.example`.

---

## 🧪 Usage

### How to Run the Project
#### 1) Validate MoonBit packages
```bash
moon check
```

#### 2) Build WASM target
```bash
moon build --target wasm
```

#### 3) Run the Go TUI host
```bash
cd tui
go run .
```

#### 4) Run AMF transcription utility
```bash
python3 tools/ingestion/transcriber.py input.wav --out crystal.amf.json
```

### Example Inputs / Outputs
#### Cadence input example
From `docs/examples/basic-drums.cadence`:
```cadence
kick(every: 4) |> visualize(:waveform)
snare(every: 8, offset: 4) |> visualize(:waveform)
hihat(times: 16) |> visualize(:rhythm)
```

#### Output example
- TUI: terminal visual output and WASM runtime stepping
- Transcriber: JSON file (default `crystal.amf.json`) with AMF-style structure:
  - `temporal`
  - `frequency_matrix`
  - `consciousness`
  - `vibration`

### Screenshots / GIFs
No `.png/.jpg/.gif/.svg` assets were detected in the repository.  
> Add screenshots under `docs/assets/` and link them here.

### Demo Links
No hosted public demo URL is defined in repository metadata/docs.

---

## ✨ Features

### ✅ Current Key Features
- Modular MoonBit node packages for audio/video/AI/IO/sequence operations
- AMF core structures with consciousness fields (`/core/amf.mbt`)
- Cadence language specs and examples (`/docs/specs`, `/docs/examples`)
- Go TUI runtime shell with Bubble Tea + WASM host scaffolding
- Python utility to convert audio metadata into AMF-like JSON output
- Project roadmap and conceptual architecture docs

### ⚠️ Limitations / Coming Soon
- Many node/compiler functions are currently **scaffolds/stubs** (minimal logic)
- No CI workflow files were detected under `.github/workflows/`
- No formal `CONTRIBUTING.md`, `CHANGELOG.md`, or `LICENSE` file found at repo root
- Some documentation references historical/legacy Phoenix/Elixir paths not present in this snapshot

---

## 🤝 Contribution & Community

### How to Contribute
1. Fork the repository
2. Create a branch: `git checkout -b feat/your-change`
3. Make focused changes with tests/checks where applicable
4. Run validation commands (`moon check`, `moon build --target wasm`, `go test ./...`)
5. Open a Pull Request with clear context and linked issue(s)

### Issue / Bug Reporting Guidelines
- Use GitHub Issues: https://github.com/zpc-sh/cantor/issues
- Include:
  - expected vs actual behavior
  - reproduction steps
  - environment details (OS, Go/MoonBit versions)
  - relevant logs/errors

### Community Links
- GitHub Discussions: _Not configured yet_
- Slack/Discord: _Not specified yet_
- Website/community portal: `cantor.com/community` is referenced in docs, but no official repo-level community doc is provided.

---

## 🧪 Testing & Deployment

### Testing Instructions
```bash
# MoonBit check/build
moon check
moon build --target wasm

# Go module tests
cd tui && go test ./...
```

### Deployment Steps
- No production deployment pipeline or IaC config is currently present in this repository.
- Current executable path is local/dev-oriented (WASM build + Go TUI run).
- Add `.github/workflows/` and deployment configs when production deployment is introduced.

---

## 📈 Project Management

### Roadmap / Future Plans
See:
- `/roadmap/ROADMAP.md`
- `/docs/roadmap/`

### Changelog / Versioning Info
- Current module version in `moon.mod.json`: **0.1.0**
- No dedicated `CHANGELOG.md` detected.

---

## 🏅 Badges (Optional)

Suggested additional badges to add later:
- CI/build status (after workflows are added)
- License badge (after a license file is added)
- Release/version badge (after tagged releases are established)

---

## 📚 Meta Information

### License
⚠️ No license file detected at repository root.  
> Add `LICENSE` (e.g., MIT/Apache-2.0) to clarify usage rights.

### Acknowledgements
- MoonBit ecosystem
- Charmbracelet (Bubble Tea, Lip Gloss)
- Wazero runtime
- JSON-LD / AMF-inspired modeling approach in project docs/specs

### Contact Info
- GitHub org: https://github.com/zpc-sh
- Repository issues: https://github.com/zpc-sh/cantor/issues
- RFC contact reference: `contact@zpc.systems` (from `docs/specs/cadence-rfc.md`)
