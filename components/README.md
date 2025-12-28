# Veil — Configuration Guide (Tier 2)

This document describes advanced configuration and integration for Veil. All configuration is done via global variables, which must be declared **before** sourcing `veil.zsh`.

---

## Configuration Variables

### `VEIL_MODULES` — Module Management
Specifies which modules will be loaded.

**Format (both variants are supported):**
```bash
# String (spaces as separators)
VEIL_MODULES="aliases completion history"

# Zsh array
VEIL_MODULES=(aliases completion history)
```

**Example:**
```bash
VEIL_MODULES="completion history navigation less"
source "$HOME/.veil/veil.zsh"
```

> Full list and description of modules: [Tier 3 Documentation](./components/modules/README.md)

---

### Debugging: `VEIL_VERBOSE` and `VEIL_MODULES_VERBOSE`
Enable verbose output for debugging the loading process.

- `VEIL_VERBOSE=1` — output from the system core
- `VEIL_MODULES_VERBOSE=1` — output from individual modules

**Example:**
```bash
VEIL_VERBOSE=1
VEIL_MODULES_VERBOSE=1
source "$HOME/.veil/veil.zsh"
```

---

### `THEME` — Theme Selection (default: `ultima`)
Veil supports the standard `*.zsh-theme` theme format.

**Usage:**
```bash
THEME="ultima"  # Default theme
source "$HOME/.veil/veil.zsh"
```

---

### `THEMES_DIR` — Custom Theme Directory
Use this if you need to store themes separately from the Veil installation.

**Example:**
```bash
THEMES_DIR="$HOME/my-zsh-themes"
THEME="my-custom-theme"
source "$HOME/.veil/veil.zsh"
```

**Alternatively:** you can place a theme in `~/.veil/components/themes/` and simply specify `THEME="theme-name"`.

---

## Adding Your Own Modules

Veil loads any `*.module.zsh` file from the modules directory.

**Process:**
1. Create a file `example.module.zsh`
2. Place it in `~/.veil/components/modules/`
3. Add it to `VEIL_MODULES`:
```bash
VEIL_MODULES="completion history example"
```

**Minimal module example:**
```bash
# ~/.veil/components/modules/example.module.zsh
veilExampleInit() {
  echo "My module loaded"
  return 0
}

[[ -n "$VEIL_CORE_LOADED" ]] && veilExampleInit
```

> Veil simply sources your files. No additional logic.

---

## Veil Usage Modes

### Standalone (default mode)
As described in Tier 1 — a full, self-contained installation.

### Plugin Mode — Integration with Other Systems
For use within existing plugin managers.

**Activation:** Use `veil.plugin.zsh` instead of `veil.zsh`. This adapter automatically sets `VEIL_MODE="plugin"`.

In plugin mode, theme auto-loading is disabled. Modules function as usual.

---

## Integration with Specific Systems

### Oh My Zsh
```bash
# 1. Install into custom/plugins/
git clone https://github.com/egorlem/veil.zsh ~/.oh-my-zsh/custom/plugins/veil

# 2. Optionally select modules:
VEIL_MODULES="completion history"

# 3. Add to .zshrc:
plugins=(git veil)

```

### Zim Framework
```bash
# In .zimrc:
zmodule egorlem/veil.zsh -n veil
```

### zcomet
```bash
# In .zshrc:
zcomet load egorlem/veil.zsh
```

### Any System
```bash
source /path/to/veil.plugin.zsh
```

To manage modules in plugin mode, use `VEIL_MODULES` as usual.

---

## Optional Variables

### `VEIL_MODULES_DIR` — Custom Module Directory
Use this if you need to store modules outside the Veil installation.

```bash
VEIL_MODULES_DIR="$HOME/my-zsh-modules"
# Veil will search for modules here
```

---

<!-- ## What's Next?

- **Need ready-made modules?** → [Tier 3 Documentation](./components/modules/README.md)
- **Questions or issues?** → [GitHub Issues](https://github.com/egorlem/veil.zsh/issues) -->