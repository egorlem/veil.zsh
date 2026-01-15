# Veil [veɪl] — Modular Zsh Configuration System

**Full control. No magic. Just clarity.**

Veil is **not** a plugin manager. It does not pull external tools or hide behavior behind layers of magic. Everything it does is explicit, local, and under your control.


---

## What’s Inside?

Veil breaks your `.zshrc` into **independent modules**, each a plain `.zsh` file that can be read, modified, or disabled individually.

Out of the box, it provides a ready-to-use Zsh environment for **everyday terminal work**, with sensible defaults for history, completion, navigation, aliases, keybindings, and common tools. The included **Ultima** theme shows VCS state, SSH connections, and command status in a clean, unobtrusive prompt.

<!-- 
---

## See It in Action

![Veil Demo](https://github.com/egorlem/veil.zsh/raw/main/media/demo.gif) 

-->

---

## Quick Start

```shell
# Clone Veil repository
git clone https://github.com/egorlem/veil.zsh ~/.veil

# Source Veil in your .zshrc (includes Ultima theme)
echo 'source ~/.veil/veil.zsh' >> ~/.zshrc
```

Included by default:

* Core module loader
* Modules: `less`, `ls`, `completion`, `history`, `navigation`
* [Ultima](https://github.com/egorlem/ultima.zsh-theme) minimalist theme

> For detailed module configuration, see [Tier 2 Documentation](./components/README.md) 

---

## Why Veil?

Traditional `.zshrc` files often grow into tangled, hard-to-manage scripts. Changing one part can break another, and debugging becomes slow and frustrating.

Veil’s modular design solves this problem: each module is **self-contained**, with its own functions and rules, and can be **read, modified, or disabled independently**. This makes your shell **predictable, transparent, and fully under your control**.

Modules and themes are organized in simple folders for clarity:

```
~/.veil/components/modules
├── completion.module.zsh
├── history.module.zsh
└── ...

~/.veil/components/themes
├── ultima.zsh-theme
└── ...
```

If you prefer plugins that just work without showing how they work, Veil may not be the right fit — it’s meant for users who value **visibility and control** over magic.

---

## Performance

Performance was measured with **all 9 modules + Ultima theme**, including **`zsh-users/zsh-autosuggestions`** and **`zsh-users/zsh-syntax-highlighting`**, using [**zimfw/zsh-framework-benchmark**](https://github.com/zimfw/zsh-framework-benchmark) as the test tool.


| Framework / Config             | Real  | User  | Sys   | Max      |
| ------------------------------ | ----- | ----- | ----- | -------- |
| ZimFW (all included)           | 0.075 | 0.003 | 0.071 | 0.107    |
| **Veil (10 modules + Ultima)** | 0.083 | 0.003 | 0.079 | 0.107    |
| zplug                          | 0.230 | 0.008 | 0.218 | 0.274    |
| Oh My Zsh                      | 0.351 | 0.005 | 0.344 | 0.378    |

Veil remains efficient and responsive, even with multiple modules loaded, and adding more modules may slow it down slightly — but performance stays within reasonable bounds.

---

## Documentation Tiers

Veil documentation follows **progressive disclosure**.

- **Tier 1 (You are here)** — Quick start, core concepts, essentials. 
- [**Tier 2** — Advanced configuration and integration.](./components/README.md)
- [**Tier 3** — Core modules and system internals.](./components/modules/README.md)

Start here to learn the basics of Veil. Understand core concepts and essential workflows. Move to Tier 2 only when you are ready to configure and personalize your setup.

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


