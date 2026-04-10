## 2024-04-10 - Native Destructive Action Confirmation
**Learning:** Phoenix LiveView provides a native `data-confirm` attribute on interactive elements (like buttons) that triggers an automatic browser confirmation dialog. This is extremely useful for destructive actions (like deleting items) to prevent accidental clicks without needing to implement a custom JavaScript modal or dialog.
**Action:** Always use `data-confirm="Message"` on destructive action buttons (e.g., delete) to provide immediate, accessible user safety with zero additional dependencies.
