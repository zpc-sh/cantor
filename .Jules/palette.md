## 2024-05-24 - [TUI Keyboard Accessibility]
**Learning:** TUI applications without visible quit instructions or keyboard shortcut hints can make users feel trapped, leading to poor UX. It is crucial to have an explicit hint about keyboard shortcuts, especially for quitting applications running in full screen mode or alternate screen.
**Action:** When building TUI interfaces, always include an explicit keyboard shortcut hint (like "Press q or ctrl+c to quit") using lipgloss for better visibility.
