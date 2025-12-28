# Veil — Руководство по конфигурации (Tier 2)

Этот документ описывает расширенную конфигурацию и интеграцию Veil. Вся настройка выполняется через глобальные переменные, которые должны быть объявлены **до** подключения `veil.zsh`.

---

## Переменные конфигурации

### `VEIL_MODULES` — управление модулями
Определяет, какие модули будут загружены.

**Формат (оба варианта поддерживаются):**
```bash
# Строка (пробелы как разделители)
VEIL_MODULES="aliases completion history"

# Массив Zsh
VEIL_MODULES=(aliases completion history)
```

**Пример:**
```bash
VEIL_MODULES="completion history navigation less"
source "$HOME/.veil/veil.zsh"
```

> Полный список и описание модулей: [Tier 3 Documentation](./components/modules/README.md)

---

### Отладка: `VEIL_VERBOSE` и `VEIL_MODULES_VERBOSE`
Включают подробный вывод для отладки загрузки.

- `VEIL_VERBOSE=1` — вывод от ядра системы
- `VEIL_MODULES_VERBOSE=1` — вывод от отдельных модулей

**Пример:**
```bash
VEIL_VERBOSE=1
VEIL_MODULES_VERBOSE=1
source "$HOME/.veil/veil.zsh"
```

---

### `THEME` — выбор темы (по умолчанию: `ultima`)
Veil поддерживает стандартный формат тем `*.zsh-theme`.

**Использование:**
```bash
THEME="ultima"  # Тема по умолчанию
source "$HOME/.veil/veil.zsh"
```

---

### `THEMES_DIR` — кастомная директория для тем
Если требуется хранить темы отдельно от установки Veil.

**Пример:**
```bash
THEMES_DIR="$HOME/my-zsh-themes"
THEME="my-custom-theme"
source "$HOME/.veil/veil.zsh"
```

**Альтернативно:** можно поместить тему в `~/.veil/components/themes/` и указать только `THEME="имя-темы"`.

---

## Добавление собственных модулей

Veil загружает любой файл `*.module.zsh` из директории модулей.

**Процесс:**
1. Создайте файл `example.module.zsh`
2. Поместите в `~/.veil/components/modules/`
3. Добавьте в `VEIL_MODULES`:
```bash
VEIL_MODULES="completion history example"
```

**Минимальный пример модуля:**
```bash
# ~/.veil/components/modules/example.module.zsh
veilExampleInit() {
  echo "Мой модуль загружен"
  return 0
}

[[ -n "$VEIL_CORE_LOADED" ]] && veilExampleInit
```

> Veil просто source'ит ваши файлы. Никакой дополнительной логики.

---

## Режимы использования Veil

### Standalone (режим по умолчанию)
Как описано в Tier 1 — полная автономная установка.

### Plugin mode — интеграция с другими системами
Для использования внутри существующих менеджеров плагинов.

**Активация:** Используйте `veil.plugin.zsh` вместо `veil.zsh`. Этот адаптер автоматически устанавливает `VEIL_MODE="plugin"`.

В plugin-режиме отключается авто-загрузка тем. Модули работают как обычно.

---

## Интеграция с конкретными системами

### Oh My Zsh
```bash
# 1. Установите в custom/plugins/
git clone https://github.com/egorlem/veil.zsh ~/.oh-my-zsh/custom/plugins/veil

# 2. Опционально выберите модули:
VEIL_MODULES="completion history"

# 3. Добавьте в .zshrc:
plugins=(git veil)

```

### Zim Framework
```bash
# В .zimrc:
zmodule egorlem/veil.zsh -n veil
```

### zcomet
```bash
# В .zshrc:
zcomet load egorlem/veil.zsh
```

### Любая система
```bash
source /путь/к/veil.plugin.zsh
```

Для управления модулями в plugin-режиме используйте `VEIL_MODULES` как обычно.

---

## Опциональные переменные

### `VEIL_MODULES_DIR` — кастомная директория модулей
Если требуется хранить модули вне установки Veil.

```bash
VEIL_MODULES_DIR="$HOME/my-zsh-modules"
# Veil будет искать модули здесь
```

---

<!-- ## Что дальше?

- **Нужны готовые модули?** → [Tier 3 Documentation](./components/modules/README.md)
- **Вопросы или проблемы?** → [GitHub Issues](https://github.com/egorlem/veil.zsh/issues) -->