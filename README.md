# Veil [veɪl] — Modular Zsh Configuration System

**Full control. No magic. Just clarity.**

Veil is **not** a plugin manager. It’s an **architectural system** to organize your `.zshrc` into **self-contained modules**. Each module is a plain `.zsh` file — editable and easy to read on its own.

* Modular structure for organizing shell configuration
* Fully local setup with no external dependencies
* Covers essential Zsh features with built-in modules and the Ultima theme

---

## What’s Inside?

Out of the box, Veil provides a clean and well-configured Zsh environment focused on everyday terminal work.  
It brings together sensible defaults for history, completion, navigation, aliases, keybindings, and common tools like `ls`, `less`, and `man`, forming a setup that feels consistent and predictable.

The included **Ultima** theme adds lightweight visual context — git state, SSH sessions, and command status — without getting in the way.

<!-- ---

## See It in Action

![Veil Demo](https://github.com/egorlem/veil.zsh/raw/main/media/demo.gif) -->

---

## Why Veil?

Traditional `.zshrc` files can quickly turn into **unmaintainable monoliths**.
Veil splits configuration into **isolated modules**, making each part readable, composable, and easy to reason about.

It also avoids **dependency chaos**: everything is local, no external repos, no hidden behavior. Every module is explicit — you see and control everything.

```
~/.veil/components/modules
├── completion.module.zsh
├── history.module.zsh
└── ...

~/.veil/components/themes
├── ultima.zsh-theme
└── ...
```

---

## Quick Start

```bash
# Clone Veil
git clone https://github.com/egorlem/veil.zsh ~/.veil

# Source in Zsh
echo 'source ~/.veil/veil.zsh' >> ~/.zshrc
```

Included by default:

* Core module loader
* Modules: `less`, `ls`, `completion`
* [Ultima](https://github.com/egorlem/ultima.zsh-theme) minimalist theme

> For detailed module configuration, see [Tier 2 Documentation](./components/README.md) 

---

## Performance

Performance was measured with **all 10 modules + Ultima theme**, including **`zsh-users/zsh-autosuggestions`** and **`zsh-users/zsh-syntax-highlighting`**, using [**zimfw/zsh-framework-benchmark**](https://github.com/zimfw/zsh-framework-benchmark) as the test tool.


| Framework / Config             | Real  | User  | Sys   | Max      |
| ------------------------------ | ----- | ----- | ----- | -------- |
| ZimFW (all included)           | 0.075 | 0.003 | 0.071 | 0.107    |
| **Veil (10 modules + Ultima)** | 0.083 | 0.003 | 0.079 | 0.107    |
| Oh My Zsh                      | 0.351 | 0.005 | 0.344 | 0.378    |
| zplug                          | 0.230 | 0.008 | 0.218 | 0.274    |

---

## Documentation Tiers

Veil documentation follows **progressive disclosure**.

- **Tier 1 (You are here)** — Quick start, core concepts, essentials. 
- [**Tier 2** — Advanced configuration and integration.](./components/README.md)
- [**Tier 3** — Core modules and system internals.](./components/modules/README.md)

Start with Tier 1.  
Move deeper only when you’re ready.

---

## Philosophy

### Script as Application

Veil treats each configuration module as a **small standalone program**, solving the issues that come with large, tangled `.zshrc` files. Each module handles one part of your shell clearly and predictably, with a **single responsibility**, a **clear entry point**, and its **own functions and internal rules**.  

This design allows every module to be **read, reasoned about, and maintained in isolation**, and explains why **all of Veil, including its theme,** is structured like **self-contained programs** instead of typical shell scripts.

---

## License

**Do What The F*ck You Want To Public License, Version 2**
See [LICENSE](https://github.com/egorlem/veil.zsh/blob/main/LICENSE) for details.

Maintained by [Egor Lem](https://egorlem.com/)


