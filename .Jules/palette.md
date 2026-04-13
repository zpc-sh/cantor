## 2024-04-13 - Data Confirm in Phoenix LiveView
**Learning:** Phoenix LiveView provides native `data-confirm` handling for destructive actions without requiring any custom JS. This is highly effective for UX but developers must remember to test with browser dialog interactions.
**Action:** Always prefer `data-confirm` for inline destructive actions (like "Delete") instead of building custom modals when simple confirmation is sufficient.
