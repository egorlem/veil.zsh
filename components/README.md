# Veil — Configuration Guide (Tier 2)

This Tier 2 guide covers **advanced configuration and integration** for Veil.  
Here you’ll find how to:

* Select and configure modules
* Customize themes
* Add your own modules
* Integrate Veil with other plugin managers (OMZ, Zim, zcomet)
* Debug module loading and inspect verbose output

All configuration is done via **global variables**, which must be set **before** sourcing `veil.zsh` or `veil.plugin.zsh`.  
Tier 2 assumes you are familiar with Tier 1 concepts, including **modular architecture** and the **Script as Application** philosophy.

---

## Operating System Compatibility & Prerequisites

Veil, including the **Ultima theme**, is compatible with **Linux**, **macOS**, and **FreeBSD**. Other platforms are **untested** and may not work as expected.  
To run Veil, you need **Zsh 5.0.8 or newer** and **Git 2.4.11 or higher**. These versions ensure that Veil modules and the Ultima theme **load correctly** and **behave predictably**.

---

## Configuration via Variables

Veil is configured **entirely through global variables**. All variables must be set **before** sourcing Veil.

### `VEIL_MODULES` — Module Management
Specifies which modules will be loaded.

**Format (both variants are supported):**
```bash
# String (space-separated)
VEIL_MODULES="aliases completion history"

# Zsh array
VEIL_MODULES=(aliases completion history)
````

**Example:**

```bash
VEIL_MODULES="completion history navigation less"
source "$HOME/.veil/veil.zsh"
```

> Full list and description of modules: [Tier 3 Documentation](./components/modules/README.md)

---

### `VEIL_VERBOSE` & `VEIL_MODULES_VERBOSE` — Debugging

Enable verbose output to debug module loading.

* `VEIL_VERBOSE=1` — output from the system core
* `VEIL_MODULES_VERBOSE=1` — output from individual modules

**Example:**

```bash
VEIL_VERBOSE=1
VEIL_MODULES_VERBOSE=1
source "$HOME/.veil/veil.zsh"
```

---

### `THEME` — Theme Selection

Default theme is **`ultima`**, but you can select any `.zsh-theme` file.

```bash
THEME="ultima"
source "$HOME/.veil/veil.zsh"
```

---

### `THEMES_DIR` — Custom Theme Directory

Store themes outside the default Veil installation.

```bash
THEMES_DIR="$HOME/my-zsh-themes"
THEME="my-custom-theme"
source "$HOME/.veil/veil.zsh"
```

**Alternatively:** place a theme in `~/.veil/components/themes/` and specify `THEME="theme-name"`.

---

### `VEIL_MODULES_DIR` — Custom Module Directory

Use this to load modules from a non-standard location.

```bash
VEIL_MODULES_DIR="$HOME/my-zsh-modules"
```

---

## Adding Your Own Modules

Veil loads any `*.module.zsh` file from the modules directory.

**Steps:**

1. Create `example.module.zsh`
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

> Veil simply sources your file — no additional logic is applied.

---

## Veil Usage Modes

### Standalone Mode (default)

A full, self-contained Veil installation.
All modules and themes work out-of-the-box.

### Plugin Mode — Integration with Other Systems

For existing plugin managers, use `veil.plugin.zsh` instead of `veil.zsh`.

* Automatically sets `VEIL_MODE="plugin"`
* Theme auto-loading is **disabled**
* Modules behave normally
* Allows integration with OMZ, Zim, zcomet, etc.

```bash
source "$HOME/.veil/veil.plugin.zsh"
```

---

## Integration with Plugin Managers & Frameworks

### Oh My Zsh

```bash
# 1. Install into custom/plugins/
git clone https://github.com/egorlem/veil.zsh ~/.oh-my-zsh/custom/plugins/veil

# 2. Optionally select modules
VEIL_MODULES="completion history"

# 3. Add to .zshrc
plugins=(git veil)
```

### Zim Framework

```bash
# In .zimrc
zmodule egorlem/veil.zsh -n veil
```

### zcomet

```bash
# In .zshrc
zcomet load egorlem/veil.zsh
```

### Any System

```bash
source /path/to/veil.plugin.zsh
```

> Modules are controlled via `VEIL_MODULES` in all modes.

---

## Documentation Tiers

- [**Tier 1** — Quick start, core concepts, essentials.](./README.md)  
- **Tier 2 (You are here)** — Advanced configuration and integration.  
- [**Tier 3** — Core modules and system internals.](./components/modules/README.md)

Start with Tier 1 to understand the basics.  
Use Tier 2 to configure, customize, and integrate Veil.  
Move to Tier 3 only when you need in-depth module details or internal mechanics.
