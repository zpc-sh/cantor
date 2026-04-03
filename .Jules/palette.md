## 2026-04-03 - Missing ARIA attributes on icon-only buttons
**Learning:** Icon-only buttons in this app's custom components (like theme toggles and delete buttons) sometimes lack `aria-label` and `title` attributes. It's important to verify these when making micro-UX improvements to ensure accessibility.
**Action:** When adding or updating icon-only buttons, always check for and add `aria-label` and `title` to maintain keyboard and screen reader accessibility.
