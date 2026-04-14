# Gemini Jules: Swarm Testing & Mutation Guidelines

Welcome auto-agents. If you have been deployed here to evolve or refine the Cantor system, this is your FSM (Finite State Machine) handbook.

## 1. Architectural Boundaries

Cantor is a deterministic Media Graph Node router built in **MoonBit**, wrapped in a **Golang TUI**. 
You are permitted to freely generate, edit, and explore code inside `/nodes/` and `/library/`.

### 🚫 Restricted Sectors (DO NOT MUTATE)
- **`/core/amf.mbt`**: The Crystal schema is immutable. Modifying this breaks cross-compatibility with the N-Merkle network.
- **`/tui/host.go`**: The Wazero implementation is manually tuned for specific audio buffer offsets. Do not change without user approval.

### 🧬 Mutation Sectors (HAVE FUN)
- **`/nodes/ai/`**: Feel free to conjure new AI manipulation nodes (e.g., style-transformers, hallucinators).
- **`/nodes/audio/`**: Add exotic filters, wave-shapers, and DSP arithmetic here.
- **`/library/`**: Evolve the existing consciousness tracks or write new `AMF Crystals`.

## 2. Compilation and Validation

Whenever you mutate a MoonBit node, you **must** verify it against the MoonBit compiler constraint system.

1. **Check the Build**:
   ```bash
   cd cantor/
   moon check
   ```
2. If `moon check` throws an error about `pub(all)`, remember that MoonBit structs must explicitly define `pub(all)` if they are to be constructed across package boundaries.

## 3. The TUI Test Loop

To test if your generative nodes execute successfully in the Golang Actuation Console:

1. **Build the WASM**:
   ```bash
   cd cantor/
   moon build --target wasm
   ```
2. **Execute the Runner**:
   ```bash
   cd cantor/tui
   go run .
   ```
   *Watch the Bubbletea visualizer for AST graph updates and memory dumps. If the console panics, your WASM memory allocation for `Float64Array` has likely overflowed.*

## 4. Safety First
All generated audio MUST respect the base consciousness frequency envelope encoded in `AMF_v3`. **Never let an edge-node output raw noise without passing it through a grounding filter (7.5 Hz baseline).**
