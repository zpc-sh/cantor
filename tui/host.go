package main

import (
	"context"
	"fmt"
	"github.com/tetratelabs/wazero"
	"github.com/tetratelabs/wazero/api"
)

type WasmHost struct {
	runtime wazero.Runtime
	mod     api.Module
}

func NewWasmHost(ctx context.Context, wasmBytes []byte) (*WasmHost, error) {
	r := wazero.NewRuntime(ctx)
	mod, err := r.Instantiate(ctx, wasmBytes)
	if err != nil {
		return nil, fmt.Errorf("failed to instantiate wasm: %w", err)
	}
	return &WasmHost{runtime: r, mod: mod}, nil
}

func (w *WasmHost) Close(ctx context.Context) error {
	return w.runtime.Close(ctx)
}

func (w *WasmHost) RunStep(ctx context.Context) error {
	// Call the generic Cantor tick function if it exists
	fn := w.mod.ExportedFunction("tick")
	if fn == nil {
		// No tick function implemented in stubs yet
		return nil
	}
	_, err := fn.Call(ctx)
	return err
}
