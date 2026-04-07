## 2025-02-14 - Phoenix LiveView Native Confirmations for Destructive Actions
**Learning:** Phoenix LiveView natively supports the `data-confirm` attribute to show a browser-native confirmation dialog before dispatching a `phx-click` event. This is incredibly useful for destructive actions (like deleting items) to prevent accidental clicks without needing to implement a custom modal or custom JavaScript. It also seamlessly handles accessibility.
**Action:** Always add `data-confirm="[Confirmation message]"` to interactive elements that trigger destructive or irreversible actions.
