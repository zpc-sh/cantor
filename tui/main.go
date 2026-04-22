package main

import (
	"context"
	"fmt"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"os"
	"time"
)

type model struct {
	width  int
	height int
	ticks  int
	host   *WasmHost
}

func initialModel() model {
	return model{}
}

func tickCmd() tea.Cmd {
	return tea.Tick(time.Millisecond*50, func(t time.Time) tea.Msg {
		return tickMsg(t)
	})
}
type tickMsg time.Time

func (m model) Init() tea.Cmd {
	return tickCmd()
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		if msg.String() == "q" || msg.String() == "ctrl+c" {
			return m, tea.Quit
		}
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tickMsg:
		m.ticks++
		if m.host != nil {
			m.host.RunStep(context.Background())
		}
		return m, tickCmd()
	}
	return m, nil
}

func (m model) View() string {
	style := lipgloss.NewStyle().
		Bold(true).
		Foreground(lipgloss.Color("#FAFAFA")).
		Background(lipgloss.Color("#7D56F4")).
		Padding(1).
		Width(m.width).
		Align(lipgloss.Center)

	hintStyle := lipgloss.NewStyle().
		Foreground(lipgloss.Color("#A0A0A0")).
		Align(lipgloss.Center).
		MarginTop(1)

	// Draw an ASCII "spectral" display
	content := fmt.Sprintf("CANTOR ACTUATION CONSOLE | Ticks: %d\n", m.ticks)
	content += "|||||:::||::::::::::||:::::|::::::||||" // placeholder visualizer

	hint := hintStyle.Render("Press q or ctrl+c to quit")

	return lipgloss.JoinVertical(lipgloss.Center, style.Render(content), hint)
}

func main() {
	p := tea.NewProgram(initialModel(), tea.WithAltScreen())
	if _, err := p.Run(); err != nil {
		fmt.Printf("Alas, there's been an error: %v", err)
		os.Exit(1)
	}
}
