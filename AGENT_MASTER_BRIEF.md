# 🌐 Ungoogled Chromium macOS (Romeet Arc Edition)
## Master Agent Brief & Product Requirements Document (PRD)

---

## 1. Project Overview & Mission
This project maintains and develops a custom, high-performance, native Apple Silicon (`arm64`) build of **Ungoogled Chromium** optimized for **macOS Tahoe 26** with custom **Arc Browser-inspired UX/UI modifications** (known as **RomeetMods**).

### Core Features & Design Principles:
1. **Arc-Style Vertical Navigation**:
   - Pinned tabs arranged in an Arc-style grid (default $4 \times 2$ layout with larger tiles and icons).
   - Dynamic sidebar width adjustment.
2. **Theme-Adaptive Tab Styling**:
   - **Inactive/Unpinned Tabs**: Borderless sleek subtle greyish background (`SkColorSetARGB(22, 255, 255, 255)` in Dark Mode, `SkColorSetARGB(18, 0, 0, 0)` in Light Mode).
   - **Active/Selected Tabs**: Dynamic fill using Chromium's active theme primary accent color (`ui::kColorSysPrimary` / macOS system accent).
3. **Zero Privacy Compromises**:
   - Pure Ungoogled Chromium base with all Google tracking, telemetry, background pings, and binaries pruned.
4. **Automated Deployment**:
   - Cloud CI builds automatically download, codesign, remove Gatekeeper quarantine, install to `/Applications/Chromium Arc.app`, and launch on desktop.

---

## 2. Codebase & Repository Architecture

### Directory Locations
- **Active Workspace**: `/Users/romeet/AI - Projects/ungoogled-chromium-macos`
- **Installed App**: `/Applications/Chromium Arc.app` (also synced to `/Applications/Chromium.app`)

### Git Remotes & Branching
- **Branch**: `master`
- **Remotes**:
  - `origin`: `https://github.com/romeet9/ungoogled-chromium-macos.git`
  - `org`: `https://github.com/romeet-builds/ungoogled-chromium-macos.git`
- **Rule**: Whenever pushing commits, ALWAYS push to both remotes:
  ```bash
  git push origin master && git push org master
  ```

### CI / CD Infrastructure
- **Workflow File**: `.github/workflows/build-ungoogled-chromium-macos-arm64.yml`
- **Runner Pool**: Bitrise Apple Silicon macOS M-series cloud runners.
- **Compiler Cache**: `sccache` integrated with GitHub Actions Cache (`actions/cache@v4`), storing ~1 GB compressed object cache.
- **Patch Engine**: GNU patch (`gpatch`) via `PATCH_BIN="$(which gpatch || which patch)"`.

---

## 3. Milestones & Progress Ledger

### Milestone 1: macOS Tahoe 26 Platform Bringup (Completed)
- Resolved all 38 compilation and SDK 15.0 compatibility errors across **57,104 build targets**.
- Created custom patches for:
  - POSIX `posix_spawnattr_setcwd_np` API changes
  - Mach exception handler types (`exc_server_variants.cc`)
  - Accessibility inspect utilities & pasteboard APIs
  - Skia CGImage byte order and screen display IDs
  - RemoteCocoa native window bridge & clipboard handlers

### Milestone 2: Compiler Caching & Initial Arc Grid (Completed)
- Initialized `sccache` compiler caching in GitHub Actions.
- Applied $2 \times 3$ pinned tab grid container in `chrome/browser/ui/views/tabs/common/pinned_tab_container_view.cc`.

### Milestone 3: 4x2 Pinned Grid Formation (Completed)
- Upgraded pinned container geometry to a **4-column across ($4 \times 2$) grid** with doubled icon bounds.
- Validated, packaged DMG/ZIP, downloaded, installed, codesigned, and launched on user screen.

### Milestone 4: Tab Styling & Theme Accent Highlight (Active in CI Run `34551604693`)
- Replaced standard tab outline with custom `Tab::OnPaint` rendering:
  - Inactive tabs: Borderless translucent grey background.
  - Active/Clicked tabs: Primary theme accent color.
- Configured CI with GNU `gpatch` for 100% clean patch application.

---

## 4. Operational Rules & Standard Procedures

### Rule 1: Automated App Installation & Launch Procedure
Whenever a GitHub Actions build completes with release artifacts:
1. Fetch latest release: `gh release list --repo romeet-builds/ungoogled-chromium-macos --limit 1`
2. Download `UngoogledChromium-macOS-arm64.zip`.
3. Terminate running instances: `pkill -f Chromium || true`.
4. Extract and copy to `/Applications/Chromium Arc.app` and `/Applications/Chromium.app`.
5. Apply permissions & Gatekeeper bypass:
   ```bash
   chmod -R 755 "/Applications/Chromium Arc.app" "/Applications/Chromium.app"
   xattr -cr "/Applications/Chromium Arc.app" "/Applications/Chromium.app"
   ```
6. Ad-hoc codesign (mandatory for macOS Tahoe):
   ```bash
   codesign --force --deep --sign - "/Applications/Chromium Arc.app"
   codesign --force --deep --sign - "/Applications/Chromium.app"
   ```
7. Launch the app: `open -a "/Applications/Chromium Arc.app"`.

### Rule 2: Patch Integrity
- All custom modifications MUST be placed in `patches/custom/` and listed in `patches/series`.
- Test patch application against Chromium 134 source before pushing.

### Rule 3: Fast Iteration Strategies
- **Instant UI/CSS/Theme tweaks (0–10s)**: Modify `.pak` files in `Chromium Arc.app/Contents/Frameworks/Chromium Framework.framework/Versions/Current/Resources/` or use Chromium Theme picker.
- **Component Builds for 10-Minute C++ Builds**: Set `is_component_build = true` and `symbol_level = 0` in GN args for development runs.

---

## 5. Active Task & Immediate Next Steps for Next Agent
1. **Monitor Active Run**: [`34551604693`](https://github.com/romeet-builds/ungoogled-chromium-macos/actions/runs/34551604693)
2. **Execute Installation**: Once Step 15 publishes the release, execute Rule 1 automatically.
3. **RomeetMods Settings UI**: Build the dedicated `chrome://settings/romeetmods` WebUI subpage for real-time pixel sliders (tile width, tile height, column count).
