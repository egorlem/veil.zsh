# Veil [veɪl] — Modular Zsh Configuration System

**Full control. No magic. Just clarity.**

Veil is **not** a plugin manager. It’s an **architectural system** to organize your `.zshrc` into **self-contained modules**. Each module is a plain `.zsh` file — editable and easy to read on its own.

* **Modular abstractions:** enable, disable, isolate functions.
* **Transparency:** 100% local, no external dependencies.
* **Full coverage:** 10 built-in modules + Ultima theme cover core Zsh functionality.

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
**Veil covers most core Zsh needs for everyday use without introducing complexity or hidden magic.**

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

Veil treats each configuration module as a **small standalone program**.

A module has a **single responsibility**, a **clear entry point**, its **own functions** and **internal rules**. It configures **one specific aspect of the shell** and can be **read, reasoned about, and maintained in isolation**.

This approach explains why **all of Veil, including its theme,** is structured like **self-contained programs** instead of typical shell scripts.

---

## License

**Do What The F*ck You Want To Public License, Version 2**
See [LICENSE](https://github.com/egorlem/veil.zsh/blob/main/LICENSE) for details.

Maintained by [Egor Lem](https://egorlem.com/)


