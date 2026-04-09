## 2024-04-09 - Accessibility & Safety on Destructive Actions
**Learning:** Icon-only buttons for destructive actions (like deleting cells) often lack both screen reader context (ARIA labels) and user safety nets (confirmations). Using LiveView's native `data-confirm` along with `aria-label` provides a robust, zero-JS solution for both issues simultaneously.
**Action:** Always verify that icon-only delete buttons include `aria-label`, `title`, `data-confirm`, and keyboard focus indicators (`focus-visible`).
