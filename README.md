# Veil [veɪl] — Modular Zsh (Z Shell) Configuration System

### Gives you full control via logical modules. No magic, just clarity.

---

<!-- 1. Main description block -->
Veil is not a plugin manager or a ready-made framework. It is an architectural system for organizing your Zsh configuration into logical, self-contained modules. It splits settings into components and gives you full control over what loads and how.

**Philosophy:** No magic, only clarity.

## What does Veil do?

Imagine your `.zshrc` has turned into a 500-line monster where everything is mixed together. Veil solves this by dividing the chaos into organized modules.

---

<!-- 2. Installation block -->
## Installation

### Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/egorlem/veil.zsh ~/.veil

# 2. Connect to Zsh
echo 'source ~/.veil/veil.zsh' >> ~/.zshrc

```

### What's installed by default?

**System core** — minimal module loading logic

**3 basic modules:**
- `less` — enhanced file viewing
- `completion` — advanced autocompletion
- `ls` — colored output with smart settings

[**Ultima**](https://github.com/egorlem/ultima.zsh-theme) — minimalist command line theme

> ### More details about configuring Veil and its modules can be found in the [TIER 2](/builtin/README.md) documentation

---

<!-- 3. Motivation and project philosophy -->
## Motivation

### Problems that Veil solves

**The monolith problem**

Traditional .zshrc turns into a huge, unmaintainable file. Veil splits it: instead of one `.zshrc` file, logical modules

```
~/.veil/builtin/modules
├── completion.module.zsh       # Only completion settings
├── history.module.zsh          # Only history settings
└── ...

~/.veil/builtin/themes
├── ultima.zsh-theme            # only what relates to theme settings
└── ...
```

**The complex dependencies problem**

Plugin managers handle external dependencies, which creates:
 - Debugging complexity
 - Dependence on external repositories
 - Overhead for synchronization

**Veil uses only local files**. No external dependencies, no package manager.

**The "magical" behavior problem** 
  - Hidden logic
  - Complicated customization
  - Loading unnecessary components

**Veil is transparent**: every module is a regular `.zsh` file. You see and control everything.

### Key differences from existing solutions

| Aspect | Plugin Managers | Frameworks | Veil |
| --- | --- | --- | --- |
| Approach | Managing external plugins | Ready-made "all-in-one" solution | Organizing local configuration |
| Complexity | High (Turbo Mode, lazy loading) | Low (just works) | Medium (controlled) |
| Transparency | Partial (hidden logic) | Low (lots of "magic") | Full (everything in your files) |
| Dependencies | External repositories | Built-in or external | Only local files |

<!-- 4. Footer -->
## License

This project is licensed under the **Do What The F*ck You Want To Public License**. See the [LICENSE](https://github.com/egorlem/veil.zsh/blob/main/LICENSE) file for details.

---

Maintained by [Egor Lem](https://egorlem.com/)