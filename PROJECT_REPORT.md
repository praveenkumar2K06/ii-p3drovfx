# Project Analysis Report — `ii-p3drovfx`

*Generated 2026-08-29 · Branch `dev` · 2066 tracked files*

---

## 1. Executive Summary

`ii-p3drovfx` is a **fork of the `ii-vynx` Material 3 / Material-You Linux desktop environment**, built on **Quickshell** (a Qt/QML widget framework) for the **Hyprland** Wayland compositor. Its lineage is `ii-vynx` → `illogical-impulse` (end-4/dots-hyprland). It is not a small dotfiles helper — it is a full desktop-shell-class application (bar, sidebars, launcher, lock screen, notifications, OSD, wallpaper engine, settings app, AI assistant, onboarding wizard) plus a sophisticated multi-distro **install / update / fork-manager** system.

**Overall verdict:** Mature, well-engineered, and unusually defensive for a dotfiles project. The QML shell is large (~1,200 QML files, ~283k lines) but architecturally disciplined (lazy loading, memory-unload, IPC contract, Matugen-driven theming). The install system is production-grade (atomic swaps, rolling backups, state files, legacy migration). Soft spots: no CI that actually builds/tests anything, community distros (Fedora/Gentoo/Nix) can lag the Arch reference, a very large central `GlobalStates` singleton, and several stale upstream references.

---

## 2. Purpose & Key Features

- **Material 3 bar** with 4 corner styles incl. a morphing **Dynamic Island** notch, plus vertical-bar mode.
- **Power-user search launcher / Overview** (`Super+D` / `Space`): prefix-less math & unit/currency conversion, secure system controls with two-step confirmation, and 20+ result panels (apps, clipboard, emoji, symbols, translator, tasks, timers, sports, Bluetooth, file browser, calendar, screenshots, AI chat).
- **AI Assistant** — multi-provider LLMs (Gemini / OpenAI-compatible / Anthropic), tool-calling across the shell, RAG over local folders, memory, personas, voice, per-tool approval.
- **Modes & Routines** automation engine (Samsung One UI-style, snapshot/revert semantics).
- **Left "Policies" sidebar** (AI chat, translator, wallpaper browser, anime, player) and **right "Dashboard" sidebar** (Android-style paged quick toggles, volume mixer, notifications, calendar, todos, pomodoro, network/VPN/Tailscale dialogs).
- **Lock screen** with shader stack (blur/vignette/desaturate), ripple, fingerprint, notifications.
- **Wallpaper engine** (image/video, parallax, Matugen theming, separate light/dark wallpapers), **OSDs**, **notifications**, **MPRIS media controls**, **color picker → M3 palettes**, **cheatsheet**, **screen translator**, **region selector w/ annotations**, **OLED saver**, **tiling assistant**, **Discord voice overlay**, **video editor**, **OBS recording**, **Connect mode** (collapses bar+sidebars into a single top surface).
- **Settings app** (~160 files) and **Welcome/onboarding wizard**.

---

## 3. Repository Structure & Scale

```
ii-p3drovfx/
├── setup-ii-p3drovfx.sh   # 2,624-line Quickshell config installer / fork manager / CLI
├── setup                  # base "illogical-impulse" dotfiles dispatcher
├── diagnose               # standalone diagnostic generator
├── update-fork.sh         # compat wrapper → setup-ii-p3drovfx.sh update
├── sdata/                 # distro packages, lib, subcommands, uv lockfiles
│   ├── dist-arch/  dist-fedora/  dist-gentoo/  dist-nix/
│   ├── subcmd-*/  cli/  lib/  uv/
├── dots/                  # the actual dotfiles (hypr, fish, kitty, quickshell/ii, ...)
├── dots-extra/            # opt-in supplemental configs (not auto-installed)
└── .github/workflows/     # issue/distro automation only
```

| Metric | Value |
|---|---|
| Tracked files | 2,066 |
| QML files | ~1,205 (≈283k lines total) |
| Bash scripts | ~85 |
| First-party Python (excl. vendored venv) | 56 |
| SVG assets | 376 |
| Tech-debt markers (TODO/FIXME/XXX/BUG) | **35** (19/2/10/4) |
| Broken symlinks | 0 |
| Hardcoded secrets found | 0 |
| Git-tracked `sdata/uv` files | 4 (recipe/lockfile only — built venv is ignored) |

---

## 4. Architecture

### 4.1 Install / Distribution System
*Source: `setup-ii-p3drovfx.sh`, `setup`, `sdata/`.*

Two cooperating installers:
1. **`setup-ii-p3drovfx.sh`** (v2.0.0, `set -Eeuo pipefail`) — a self-contained Quickshell-config installer, updater, fork manager, and CLI (`ii-p3drovfx`), symlinked to `~/.local/bin`. It:
   - Resolves real paths through symlinks, sets XDG dirs, handles legacy `vynx` migration.
   - Supports fork presets (`p3drovfx`, `end4`, `vynx/upstream`) and arbitrary `github.com/USER/REPO` forks.
   - Performs **atomic swaps** (stage → `rsync`/`cp` → carry protected files → timestamped backup, keep newest 3) and refuses ambiguous `--local` redeploys.
   - Builds Quickshell from source (`outfoxxed/quickshell`) on Arch/Fedora/Debian, swaps to `quickshell-git` on Arch, and uses **IPC shutdown** (`qs kill -c ii`) so `Component.onDestruction` can flush `config.json` cleanly (avoids orphaned children).
   - Has a polished Material TUI (palette via `sed`-parsed `colors.json` so it works on a bare machine), spinner, confirm, legacy migration, doctor/demo commands.
2. **`setup` + `sdata/`** — the base `illogical-impulse` installer. Reads `/etc/os-release` via `dist-determine.sh` (`arch|gentoo|fedora|suse|debian|fallback`; suse/debian/fallback → Nix). Routes to per-distro `install-deps.sh`:
   - **dist-arch** — primary/reference, 15 PKGBUILDs (meta + build packages), documented in `deps-info.md`.
   - **dist-fedora** — community, builds RPMs from 3 `.spec` files.
   - **dist-gentoo** — community, 20 ebuilds.
   - **dist-nix** — experimental/unsupported (`home-manager` flake).
   - `outdate_detect()` only **warns** (via manual git-commit-time comparison) that community distros may lag Arch — nothing enforces parity.

Python deps are vendored as a **lockfile + recipe** (`requirements.in`/`requirements.txt`/`shell.nix`) and rebuilt into a disposable `uv` venv — clean and reproducible; the heavy binary venv is git-ignored. **Oddity:** a literal `~`-named prebuilt venv tree under `sdata/uv/~/.local/...` is committed-but-ignored (dead/confusing data).

### 4.2 The Quickshell "ii" Shell (QML app)
*Source: `dots/.config/quickshell/ii/`.*

- **Entry point `shell.qml`** (`ShellRoot`): performance-tuned pragmas (`QSG_NO_DEPTH_BUFFER=1`, raised flickable deceleration), "touches" ~20 singletons so their watch loops run even when hidden, lazily loads the active **panel family** by URL (`panelFamilies/IllogicalImpulseFamily.qml`) so the heavy import closure compiles only when active, and **unloads** Settings/Welcome after a capped delay to reclaim memory. Exposes a central `IpcHandler` + `GlobalShortcut` surface.
- **Panel family** instantiates ~40 surfaces as `PanelLoader { component: X{} }`, each gated by an `extraCondition` on config. **`PanelLoader`/`PanelSchedule`** serialize panel compilation through a ticket queue to avoid one giant event-loop stall (notable perf pattern).
- **`modules/common/`** — shared foundation: `Config.qml` (JSON-backed options singleton with aggressive hot-reload write-guards), `Appearance.qml` (whole M3 design system, auto transparency from wallpaper vibrance), `GlobalStates.qml` (~1,050-line cross-surface state "brain"), **~200 reusable Material widgets**, models, functions, utils, and **10+ registries** (`SettingsPageRegistry`, `BarComponentRegistry`, `SearchPanelRegistry`, `QuickToggleRegistry`, …) that act as the app's extension points.
- **`modules/ii/`** — the main UI: `bar/` (highly decomposed, horizontal+vertical, Dynamic-Island style), `overview/` (search launcher + 20+ panels), `dynamicIsland/`, `sidebarPolicies/`, `sidebarDashboard/`, `lock/`, `mediaControls/`, `cheatsheet/`, `modes/`, `background/`, `overlay/`, `topLayer/`, plus many more popups/overlays.
- **`modules/settings/`** — settings app (~160 files) with per-page configs and a large `widgets/` editor library.
- **`modules/welcome/`** — ~32-file onboarding wizard.

### 4.3 Services & AI Subsystem
~110+ singleton services under `services/` covering system/hardware (Battery, Brightness, Audio, Network, Bluetooth, VPN, Tailscale, Tray, Resources, Cava…), Hyprland integration (HyprlandData/Keybinds/Settings/Config/Xkb, TilingAssistant, GameDetector, WorkspaceCompactor…), personal/cloud (Weather, Todo, Sports, Calendar, Email, Translator, GoogleCloud…), media (MusicVideo, Lyrics, Booru, Wallpapers…) and registries (Search, LauncherApps, Commands, Keybinds, Dictation, Keyring…).

The **AI subsystem is the deepest** (`services/ai/` ~71 files + `services/Ai.qml`, 7,425 lines): three wire-format strategies (Gemini / OpenAI-compatible / Anthropic), model catalogs (incl. Ollama), sessions/conversations repository, RAG memory, personas, drafts, voice, diagnostics, a **tool registry** (tool-calling across the shell), and 12 `integrations/` + ~30 `blocks/` (structured M3 result cards). Gated by an `aiPolicy` (0 disabled / 1 online / 2 local-only).

### 4.4 Theming
`MaterialThemeLoader.qml` watches Matugen's `colors.json` (generated from the wallpaper) and applies keys to `Appearance.m3colors`; `Config.options.appearance` drives rounding/transparency; `Appearance.windowRounding` is pushed into Hyprland. 30+ selectable theme presets in `defaults/themes/`. `MaterialSymbol.qml` uses the Material Symbols variable font with animated FILL/weight axes.

---

## 5. Code Quality & Tech Debt

| Area | Assessment |
|---|---|
| **Repo hygiene** | **Good.** 13 files currently modified/uncommitted on `dev` (recent widget/refactor work — see §7). Vendored venv correctly git-ignored. No broken symlinks. No hardcoded secrets (all `secret`/`token` hits are local variable names, e.g. `const secret = passwordField.text`). |
| **Tech debt markers** | **Low** — only 35 across 1,200+ QML files. Healthy. |
| **QML file sizes** | A few giants: `Ai.qml` 7,425 lines, `Config.qml` 3,258, `AiChat.qml` 2,790, `SearchWidget.qml` 2,667, `LauncherSearch.qml` 2,425, `RegionSelection.qml` 2,423, `AiMessage.qml` 2,109. Large but internally cohesive. |
| **Bash quality** | High in `setup-ii-p3drovfx.sh` (defensive, well-commented). `diagnose`/venv checks are Arch-centric and partly commented out. Experimental subcommands (`subcmd-exp-update`, `exp-update-tester.sh`) are self-described as AI-generated with redundant logic. |
| **Security** | **No leaked credentials** found in sampling. `hyprset.sh` refuses shell metacharacters/newlines. `update` refuses ambiguous local redeploys. |

### Notable strengths
- Consistent `pragma Singleton` + `pragma ComponentBehavior: Bound` reduces binding/lifetime bugs.
- Lazy, **scheduled** panel instantiation + explicit cache `release()` → real-world perf discipline (code comments reference hitting/avoiding CPU cliffs, e.g. keeping FBO layer active only during sidebar animations).
- Robust config persistence (hot-reload write-guards prevent clobbering user `config.json`).
- Clean, centralized IPC/shortcut contract enabling external tooling.
- Premium Matugen-driven dynamic theming wired into a Qt variable-font M3 palette.

### Complexity / risk hotspots
- **`GlobalStates.qml` (~1,050 lines)** is a central "god object" holding dozens of cross-surface flags, geometry math, IPC, and shortcuts.
- **`Config.options`** is the universal coupling point — nearly every component reads/writes nested JSON.
- **AI subsystem** is by far the most complex/bug-prone surface.
- **Network dependence** for base install (`git`/`yay`/`dnf`/`emerge`, `uv` via `curl|bash`, PyPI rebuild) — breaks air-gapped setups.

---

## 6. Repository Hygiene & Security (detailed)

- **Uncommitted work:** 13 files modified on `dev` vs `HEAD` — recent refactors (`RippleButtonE`, `ConfigListView`/`ConfigPresetsView`/`RelatedChip`, `ExpressiveMedia*`, `AlarmRingingPopup`, `MediaMode`, `ModeIndicator`/`RecordIndicator`, `BarGroupTheme`, `AlarmsCard`, `ExpressivePoliciesPanelButton`). **Recommend committing these.**
- **Vendoring hygiene:** `sdata/uv` built venv is correctly ignored (only 4 recipe/lockfile files tracked); repo is not bloated by binaries (despite `sdata/` being 325M on disk, almost all of it is the ignored venv).
- **No secrets** leaked; secret-scan returned 0 literal credentials.
- **Stale upstream references (fork cruft):** `.github/workflows/*` still guard on `end-4/dots-hyprland` and post to Discussion #2140; `diagnose` is Arch/pacman-only; `sdata/README.md` is minimal/stale; dead literal-`~` venv tree under `sdata/uv`.

---

## 7. Risks & Recommendations

1. **Add real CI.** Current workflows only automate issues/discussion notifications and don't build, lint, or `qmllint` the config or setup scripts. Add a job that runs `qmllint` on `dots/.config/quickshell/ii` and `bash -n`/shellcheck on the scripts.
2. **Commit the 13 pending changes** on `dev` (or stash/branch them) so the working tree is clean.
3. **Decouple from `end-4` references.** Update workflow guards, `diagnose`, and `sdata/README.md` to the `P3DROVFX` fork; remove dead `sdata/uv/~/.local/...` tree.
4. **Tame community-distro drift.** Either enforce/automate distro parity checks beyond manual commit-time warnings, or clearly mark Fedora/Gentoo/Nix as best-effort in user-facing docs.
5. **Split the largest singletons.** Consider decomposing `Ai.qml` (7.4k lines) and `GlobalStates.qml` (1k lines) into focused modules to ease maintenance (incremental — they work today).
6. **Reduce network/offline fragility** for the base installer if broad distribution is a goal (e.g., vendored offline package cache option).
7. **Archive `dots-extra/` expectations.** Document that those configs are manual/opt-in so users don't expect them from `setup`.

---

## 8. Quick Stats

- ~1,200 QML files · ~283,000 QML lines
- 2,624-line primary installer · ~85 shell scripts · 56 first-party Python files
- ~110 singleton services · ~200 reusable widgets · 10+ registries · 30+ theme presets
- 35 tech-debt markers · 0 broken symlinks · 0 hardcoded secrets
- Supported distros: Arch (reference) / Fedora / Gentoo / Nix (experimental)
