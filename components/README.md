# Veil — Configuration & Integration (Tier 2)

This Tier 2 guide covers **advanced configuration and integration** for Veil.
Here you’ll find how to:

* Explore [**Configuration via Variables**](#configuration-via-variables) — set global variables to control module loading and select themes
* Explore [**Veil Usage Modes**](#veil-usage-modes) — run Veil in standalone mode or integrate it with other plugin managers
* Explore [**Integration with Plugin Managers & Frameworks**](#integration-with-plugin-managers--frameworks) — use Veil seamlessly with OMZ, Zim, zcomet, and other systems

Each section provides **examples, recommended practices, and step-by-step instructions**.
Tier 2 assumes you are familiar with Tier 1 concepts. Veil is modular: each module is autonomous, self-contained, and behaves predictably. You control which modules are loaded via VEIL_MODULES. This ensures clarity, composability, and no hidden magic.

---

## Operating System Compatibility & Prerequisites

Veil, including the **Ultima theme**, is compatible with **Linux**, **macOS**, and **FreeBSD**. Other platforms are **untested** and may not work as expected. To run Veil, you need **Zsh 5.0.8 or newer** and **Git 2.4.11 or higher**. These versions ensure that Veil modules and the Ultima theme **load correctly** and **behave predictably**.

---

## Configuration via Variables

Veil is configured **entirely through global variables**. All variables must be set **before** sourcing Veil.

### `VEIL_MODULES` — Module Management
Specifies which modules will be loaded.

**Format (both variants are supported):**
```shell
# String (space-separated)
VEIL_MODULES="aliases completion history"

# Zsh array
VEIL_MODULES=(aliases completion history)
````

**Example:**

```shell
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

```shell
VEIL_VERBOSE=1
VEIL_MODULES_VERBOSE=1
source "$HOME/.veil/veil.zsh"
```

---

### `THEME` — Theme Selection

Default theme is **`ultima`**, but you can select any `.zsh-theme` file.

```shell
THEME="ultima"
source "$HOME/.veil/veil.zsh"
```

---

### `THEMES_DIR` — Custom Theme Directory

Store themes outside the default Veil installation.

```shell
THEMES_DIR="$HOME/my-zsh-themes"
THEME="my-custom-theme"
source "$HOME/.veil/veil.zsh"
```

**Alternatively:** place a theme in `~/.veil/components/themes/` and specify `THEME="theme-name"`.
<!--  
---

### `VEIL_MODULES_DIR` — Custom Module Directory

Use this to load modules from a non-standard location.

```shell
VEIL_MODULES_DIR="$HOME/my-zsh-modules"
```

-->
---

## Veil Usage Modes

### Standalone Mode (default)

A full, self-contained Veil installation.
All modules and themes work out-of-the-box.

### Plugin Mode — Integration with Other Systems

For existing plugin managers, use `veil.plugin.zsh` instead of `veil.zsh`.

* Automatically sets `VEIL_MODE="plugin"`
* Theme auto-loading is **disabled**
* Modules behave normally when loaded via `veil.plugin.zsh`, allowing integration with OMZ, Zim, zcomet, or any system.  
* For details on module behavior and side effects, see Tier 3 — Core Modules & Internals.


```shell
source "$HOME/.veil/veil.plugin.zsh"
```

---

## Integration with Plugin Managers & Frameworks

### Oh My Zsh

```shell
# 1. Install into custom/plugins/
git clone https://github.com/egorlem/veil.zsh ~/.oh-my-zsh/custom/plugins/veil

# 2. Optionally select modules
VEIL_MODULES="completion history"

# 3. Add to .zshrc
plugins=(git veil)
```

### Zim Framework

```shell
# In .zimrc
zmodule egorlem/veil.zsh -n veil
```

### zcomet

```shell
# In .zshrc
zcomet load egorlem/veil.zsh
```

### Any System

```shell
source /path/to/veil.plugin.zsh
```

> Modules are controlled via `VEIL_MODULES` in all modes.

---

## Documentation Tiers

- [**Tier 1** — Quick start, core concepts, essentials.](../README.md)  
- **Tier 2 (You are here)** — Advanced configuration and integration.  
- [**Tier 3** — Core modules and system internals.](./modules/README.md)

Use this tier to configure and personalize Veil for your workflow. Adjust settings and experiment safely. Refer to Tier 3 only if you need a complete picture of the system internals.
