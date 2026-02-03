# Veil — Core Modules & Internals (Tier 3)

This Tier 3 guide covers **Veil’s modules and their functionality**.
Here you’ll find how to:

* Explore [**Core Modules**](#core-modules) — technical modules that manage Zsh behavior (`navigation`, `ls`, `less`, `history`, `completion`)
* Explore [**Customization Modules**](#customization-modules) — personal configuration for environment, aliases, and keybindings (`env`, `aliases`, `keybindings`)
* Explore [**UX Modules**](#ux-modules) — aesthetic tweaks for a smoother terminal experience (`cursor`)
* Add Your [**Own Modules**](#adding-your-own-modules) — how to safely create and load custom `*.module.zsh` files

Each section provides **detailed descriptions, options, and expected behavior**.
Tier 3 is intended for users who want an **in-depth understanding and advanced customization** of Veil.

--- 

## XDG Base Directory Support

Veil configures Zsh to use [XDG directories](https://specifications.freedesktop.org/basedir/latest/) for its files: history `.zsh_history`, completion cache `.zcompdump`, and `.zcompcache`. With `XDG_CACHE_HOME` or `XDG_STATE_HOME` set, files go there; otherwise, Zsh uses `$HOME` or `ZDOTDIR`.

These are Zsh's files — Veil only sets their location.

---

## Core Modules

These modules provide essential Zsh functionality: navigation, command history, completion, and standard utilities (`ls`, `less`).  
For Veil’s overall philosophy of modularity, transparency, and predictable behavior, see [Tier 2 — Configuration & Integration](../README.md).

---

### Navigation (`navigation.module.zsh`)

The `navigation` module modifies Zsh directory navigation, including automatic directory changes and stack management.

---

#### Zsh Options Used

```shell
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
```

---

#### Behavior After Loading

* Typing a directory name immediately changes to that directory
* Each change is pushed onto the directory stack
* Duplicates in the stack are suppressed
* Stack operations execute silently
* The stack can be viewed using `dirs -v`

---

#### Provided Aliases

| Alias   | Purpose                   |
| ------- | ------------------------- |
| `..`    | Move up one directory     |
| `...`   | Move up two directories   |
| `....`  | Move up three directories |
| `.....` | Move up four directories  |
| `d`     | Show the directory stack  |

---

#### Features

* `AUTO_CD` works globally within the shell session
* Stack-number navigation (`1`, `2`, …) works without typing `cd`
* Navigation aliases take precedence over user-defined aliases with the same names

---

#### Side Effects

* Modifies the default Zsh navigation model
* Directory names are interpreted as commands
* Potential conflicts with user-defined navigation aliases

---

#### When Not to Use

* If you don’t want to modify navigation behavior
* If `AUTO_CD` conflicts with your workflow
* If you use an alternative navigation system

---

### Completion (`completion.module.zsh`)

The `completion` module configures and initializes Zsh completion, defining its style, order, sources, and interactive behavior.

---

### File Location
Uses `XDG_CACHE_HOME` if set, otherwise `ZDOTDIR`, falling back to `$HOME`.
- `$XDG_CACHE_HOME/zsh/.zcompdump` (with XDG)  
- `$ZDOTDIR/.zcompdump` (with ZDOTDIR)  
- `$HOME/.zcompdump` (default)

---

#### Zsh Mechanisms Used

* `compinit`
* `zstyle`
* Completion widgets
* Matcher-list and menu-selection

(Detailed logic and motivation for specific settings are documented in the module code.)

---

#### Behavior After Loading

* Completion is initialized once per session
* Context-aware completion is enabled
* Results are sorted and grouped by type
* Case-sensitive, partial, and fuzzy matches are supported
* A selection menu is displayed when multiple matches occur
* Completion does not block input or interrupt command flow

---

#### Features

* Completion affects **all** interactive commands
* Behavior is determined by `zstyle` configurations rather than individual flags
* Settings are applied globally for the shell session
* The order and priority of completion sources affect UX more than the number of sources

---

#### Side Effects

* Default Zsh completion behavior is modified
* Conflicts with user `zstyle` settings may occur
* Plugins that modify completion can override parts of the behavior
* Improper initialization may impact shell performance

---

#### When Not to Use

* If using a custom completion system
* If manually managing completion entirely
* If a minimal, “vanilla” Zsh behavior is desired
* If other plugins require control over `compinit`

---

### History (`history.module.zsh`)

The `history` module extends Zsh command history with persistent storage, deduplication, and convenient interactive aliases.

---

#### File Location  
Uses `XDG_STATE_HOME` if set, otherwise `$HOME`.
- `$XDG_STATE_HOME/zsh/.zsh_history` (with XDG)  
- `$HOME/.zsh_history` (default)

---

#### Zsh Options Used

```shell
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
```

---

#### Behavior After Loading

* Command history persists across sessions
* Duplicates are automatically removed
* Consecutive spaces are collapsed
* Commands starting with a space are ignored
* Aliases `history` and `h` provide easy access with numbering

---

#### Provided Aliases

| Alias     | Purpose                        |
| --------- | ------------------------------ |
| `h`       | Quick history view (`fc -l 1`) |
| `history` | Full numbered history output   |

---

#### Features

* History is global across interactive sessions
* Zsh settings are applied immediately after module load
* Module does not rely on external plugins
* Deduplication and storage are limited by `HISTSIZE` and `SAVEHIST`

---

#### Side Effects

* Default Zsh history behavior is modified
* Commands for saving and re-running history may change
* Module cannot save history if `HISTFILE` permissions are insufficient

---

#### When Not to Use

* If a minimal “vanilla” history is required
* If using a third-party history manager
* If `HISTFILE` is unavailable or write-protected

---

### Ls (`ls.module.zsh`)

The `ls` module extends the standard `ls` command with cross-platform color support and convenient aliases.

---

#### Zsh Mechanisms Used

* OS detection (`uname`)
* Color support check (`LS_COLORS` / `LSCOLORS`)
* Flag determination for macOS/BSD (`-G`) and Linux/GNU (`--color=auto`)

---

#### Behavior After Loading

* `ls` output becomes colored if supported
* Aliases provide detailed, compact, or full file listings
* Output remains functional without color if unsupported

---

#### Provided Aliases

| Alias | Purpose                     |
| ----- | --------------------------- |
| `ls`  | Colored output              |
| `ll`  | Detailed listing (`ls -la`) |
| `la`  | Alternative to `ll`         |
| `l`   | Compact format (`ls -CF`)   |

---

#### Features

* Aliases and flags are auto-detected per platform
* Safe fallback when colors are unsupported
* Integration with `LS_COLORS` / `LSCOLORS` ensures proper color display

---

#### Side Effects

* Default `ls` behavior may change
* Color flags depend on platform
* User-defined `ls`, `ll`, `la`, `l` aliases are overridden

---

#### When Not to Use

* If preserving “vanilla” `ls` behavior
* If using a custom alias or color scheme

---

### Less (`less.module.zsh`)

The `less` module configures the pager for convenient viewing of text, man pages, and files with terminal-specific enhancements.

---

#### Mechanisms Used

* Environment variables: `LESS`, `LESS_TERMCAP_*`, `MANPAGER`, `MANWIDTH`
* Aliases: `less`, `more`
* Terminal capability detection (Kitty, Linux console, etc.)
* Color and termcap support

---

#### Behavior After Loading

* `less` receives optimal terminal settings
* `more` is aliased to `less`
* Man pages display with colors and formatting
* Extra functions:

  * `lessSearch <pattern> <file>` — search with highlighting
  * `lessTail <file>` — real-time file updates (`tail -f`)
* Graceful degradation on limited terminals

---

#### Provided Aliases

| Alias  | Purpose                              |
| ------ | ------------------------------------ |
| `less` | Pager with color and termcap support |
| `more` | Alias for `less`                     |

---

#### Features

* Settings adapt to the detected terminal
* Colors and termcaps adjust for man pages
* Module checks for `less` availability and terminal capabilities
* Aliases safely override defaults

---

#### Side Effects

* Default `less` and `more` behavior is modified
* Some settings may not work on limited terminals
* Incorrect `LESS_TERMCAP_*` may affect man page display

---

#### When Not to Use

* If a “vanilla” `less` is desired
* If the terminal does not support color termcaps
* If using a custom pager setup

---

## Customization Modules

These modules allow users to **customize Zsh to their needs**. Customization modules provide a blank canvas for your environment variables, aliases, and keybindings. Refer to Tier 2 for general guidance on module autonomy and configuration.

---

### Environment (`env.module.zsh`)

The `env` module sets basic environment variables, providing a **clean canvas for personal configuration**.

> Veil does not impose default values.
> This module is minimal, letting you decide which variables you need and how they should behave.

---

#### Philosophy

* Environment variables are a personal preference
* What works for one user may not work for another
* Veil provides **structure**, not predefined values
* The module only sets critical variables by default

---

#### Configuration

Commented blocks show **how variables can be defined**:

```shell
__veilEnvSetup() {
  # export EDITOR='vim'
  # export PAGER='less'
  # export LANG='en_US.UTF-8'
  # ...
  return 0
}
```

> To change a variable, uncomment the line and set your preferred value.

---

### Aliases (`aliases.module.zsh`)

The `aliases` module creates **personal command shortcuts** for everyday terminal work.

> Veil does not impose predefined alias sets.
> This module is a **blank canvas**, letting you define your own shortcuts.

---

#### Philosophy

* Aliases are your personal command vocabulary
* Each user defines aliases to match their habits and frequent tasks
* Veil provides **structure and examples**; the rest is up to you
* Only a small bonus (`stay`) is active by default; the rest are commented

---

#### Configuration

Commented blocks show **how aliases can be created**:

```shell
__veilAliasesSetup() {
  # Fun utility - Matrix reference
  alias stay="printf '\x1b[32mFollow the white rabbit...\x1b[0m\n"

  # Git alias examples
  # alias gs='git status'
  # alias ga='git add'
  # alias gc='git commit'
  # alias gp='git push'
  # ...
  return 0
}
```

> To use an alias, uncomment the line or add new ones.
> The module serves as a **canvas for your collection of terminal shortcuts**.

---

### Keybindings (`keybindings.module.zsh`)

The `keybindings` module provides a **clean canvas for personal keybindings** in Zsh.

> Keybindings are deeply personal. Some terminals, like **Ghostty**, already support many keybindings out of the box.
> Veil does not impose defaults but offers **structure and examples** for convenience.

---

#### Philosophy

* Each user has their own workflow, muscle memory, and preferences
* The module only provides neutral examples for inspiration
* All keybindings are **commented by default**
* Suitable for gradual creation of a personal keybinding system

---

#### Configuration

Commented blocks show **how to define keybindings**:

```shell
__veilKeybindingsSetup() {
  # Edit commands
  # bindkey '^U' backward-kill-line
  # bindkey '^W' backward-kill-word 
  # ...
  return 0
}
```

> To activate a keybinding, uncomment the line or add your own.
> The module serves as a **tool for building a fully personalized command-line environment**.

---

## UX Modules

A little UX magic — just enough to make the terminal more pleasant.

---

### Cursor (`cursor.module.zsh`)

In default terminal behavior, the cursor remains visible after `clear` until the prompt is drawn, creating a visual mismatch: it seems the shell is ready when it isn’t.

The **Cursor** module fixes this by **hiding the cursor on screen clear** and **restoring it just before the new prompt**.

---

#### How It Works

1. **Hide the cursor on `clear`** — the function hides the cursor before clearing and schedules restoration
2. **Restore cursor before prompt** — `precmd` hook restores the cursor when the shell is ready for input
3. **Check and manual restoration** — allows checking cursor state and forcing restoration
4. **Module initialization** — loads once, cleans duplicate hooks, and is ready to use

---

## Adding Your Own Modules

You can create and load custom modules by placing `*.module.zsh` files in the modules directory.
Refer to Tier 2 for guidance on module initialization and variable control.

**Steps:**

1. Create `example.module.zsh`
2. Place it in `~/.veil/components/modules/`
3. Add it to `VEIL_MODULES`:

```shell
VEIL_MODULES="completion history example"
```

**Minimal module example:**

```shell
# ~/.veil/components/modules/example.module.zsh
veilExampleInit() {
  echo "My module loaded"
  return 0
}

[[ -n "$VEIL_CORE_LOADED" ]] && veilExampleInit
```

> Veil simply sources your file — no additional logic is applied.

---

## Documentation Tiers

* [**Tier 1** — Quick start, core concepts, essentials.](../../README.md)
* [**Tier 2** — Advanced configuration and integration.](../README.md)
* **Tier 3 (You are here)** — Core modules and internal mechanics

Dive into Tier 3 to explore Veil’s core modules and internal mechanics. This level is intended for **in-depth understanding and advanced customization**.
