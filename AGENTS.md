# AGENTS.md — Project Conventions

## Documentation First

- **ALWAYS consult the official Quickshell documentation** before implementing any new feature or fixing issues.
- Use `webfetch` to read https://quickshell.org/docs/v0.3.0/types/ for API reference.
- Do NOT guess or invent APIs. If documentation is unclear, search for examples in the quickshell-examples repo.
- When a feature doesn't work as expected, the first step should always be checking the docs, not trying random fixes.

## File Size

- Keep files **small and focused**. Each file should handle a single responsibility.
- Aim for **under 80 lines** per file. If a file exceeds this, consider splitting.

## Specificity

- Each file must have a **clear, singular purpose**.
- Avoid generic names. Use descriptive filenames that convey intent (e.g., `BatteryIndicator.qml` not `Widget1.qml`).

## Comments

- Add a **header comment** at the top of every file describing its purpose in 1-2 lines.
- Add **inline comments** on key lines: property declarations, functions, bindings, and non-obvious logic.
- Comments must be written in **English**.
- Use the format: `// Description of what this line/block does`

## Language

- **All code, comments, variable names, property names, and documentation must be in English.**
- No Spanish or other languages in any file.

## QML Conventions

- Use `pragma Singleton` for singleton components.
- Place each component in its correct module directory (`Commons/`, `services/`, `modules/`, `utils/`).
- Register new components in the corresponding `qmldir` file.
- Prefer `readonly property` for constants.
- Use descriptive `id` values that reflect the component's role.
- Use `RowLayout` with `Layout.alignment: Qt.AlignVCenter` instead of `Row` when children have different heights and need vertical centering.
- Use `implicitWidth`/`implicitHeight` instead of `width`/`height` for components.
- **All colors must come from `Color` singleton in Commons.** No hardcoded hex values in QML files.
- **Color palette: black, white, gray only.** No accent colors (blue, green, red). Use `#000000` for background, `#ffffff` for text, `#333333` for dividers, `#666666` for inactive, `#999999` for muted text.
- **No borders.** Popups and UI elements must not use `border.color` or `border.width`.
- **Nerd Font glyphs must use Unicode escapes** (e.g., `\uf028`) not raw characters.
- **Do not modify or move icons in Icons.qml.** The user has manually set specific glyphs. Never change them without explicit permission.
- **Always test before committing.** Run `quickshell -c ~/projects/shell` to verify no errors.

## Popup Management

- **PopupManager singleton** (`Commons/PopupManager.qml`) handles mutual exclusion between popups.
- All popups extending `BasePopup` auto-register with PopupManager on `show()` and unregister on hide.
- When a popup opens, `PopupManager.closeOthers(self)` closes all other tracked popups.
- **Volume OSD is independent** — it uses a separate `PopupWindow` + invisible `PanelWindow` anchor, does NOT register with PopupManager, and does not affect other popups.
- Clicking the bar background calls `PopupManager.closeAll()` to close all popups.
- **PopupWindow cannot be referenced by `id` from sibling components** — it's a Wayland surface. Popups must be children of their trigger component (e.g., `BluetoothPopup` inside `BluetoothIndicator`).

## Architecture

- **Commons/** — Shared singletons (Color, Style, Util, BarConfig, Config, PopupManager, PanelKeyCatcher). Module: `qs.Commons`.
- **services/** — System integration singletons (Audio, Battery, Bluetooth, Network, PowerProfile, Time, Workspaces).
- **modules/** — UI feature modules organized by component.
  - `bar/` — Status bar (Bar, Clock, indicators).
  - `bar/audio/` — Volume OSD (AudioOsd via PanelWindow+PopupWindow).
  - `bar/bluetooth/` — Bluetooth popup (BluetoothPopup).
  - `bar/battery/` — Battery popup + power profiles.
  - `bar/network/` — Network popup + WiFi password dialog.
- **utils/** — Shared helpers (Icons, Paths).
- **components/** — Reusable QML primitives (BasePopup, Divider, IconButton, ToggleSwitch).
- **UI/** — Reusable form controls (ConfirmDialog, NumberField, ButtonGroup, SearchableDropdown, MultiSelect). Module: `qs.UI`.
- **Plugins/** — Standalone features (CommandMenu, Clipboard, EmojiPicker, Notifications, LockScreen). Each plugin is a self-contained module.
