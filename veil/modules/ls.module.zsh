# Veil Ls Module
#
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

_veilLsDeps() {
  # Проверка зависимостей
  if ! command -v ls >/dev/null 2>&1; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: error - 'ls' command not found" >&2
    return 1
  fi
  return 0
}

_veilLsDetectSystem() {
  # Определение типа системы
  case "$OSTYPE" in
    darwin*) echo "bsd" ;;
    linux*) echo "gnu" ;;
    freebsd*|openbsd*) echo "bsd" ;;
    *) echo "unknown" ;;
  esac
}

_veilLsSetupAliases() {
  local SYSTEM_TYPE
  SYSTEM_TYPE=$(_veilLsDetectSystem)
  local HAS_COLOR_SUPPORT=0
  
  # Проверяем что LS_COLORS установлен colors модулем
  if [[ -z "$LS_COLORS" && -z "$LSCOLORS" ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: warning - colors not configured, ls will be without colors" >&2
  fi
  
  case $SYSTEM_TYPE in
    bsd)
      if command ls -G / >/dev/null 2>&1; then 
        alias ls='command ls -G'
        alias ll='ls -laG'
        alias la='ls -laG'
        HAS_COLOR_SUPPORT=1
      else
        alias ll='ls -la'
        alias la='ls -la'
      fi
      ;;
    gnu)
      if command ls --color=auto / >/dev/null 2>&1; then
        alias ls='command ls --color=auto'
        alias ll='ls -la --color=auto'
        alias la='ls -la --color=auto'
        HAS_COLOR_SUPPORT=1
      else
        alias ll='ls -la'
        alias la='ls -la'
      fi
      ;;
    *)
      alias ll='ls -la'
      alias la='ls -la'
      ;;
  esac
  
  alias l='ls -CF'
  
  if [[ $HAS_COLOR_SUPPORT -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: warning - color support not available for ls" >&2
  fi
  
  return 0
}

_veilLsVerify() {
  # Проверка что алиасы установились
  if ! alias ls >/dev/null 2>&1; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: error - failed to create ls aliases" >&2
    return 1
  fi
  
  if ! alias ll >/dev/null 2>&1; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: error - failed to create ll alias" >&2
    return 1
  fi
  
  if ! alias la >/dev/null 2>&1; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: error - failed to create la alias" >&2
    return 1
  fi
  
  return 0
}

veilLsInit() {
  # Основная функция инициализации
  local EXIT_CODE=0
  local SYSTEM_TYPE
  
  if ! _veilLsDeps; then
    return 1
  fi
  
  if ! _veilLsSetupAliases; then
    EXIT_CODE=1
  fi
  
  if ! _veilLsVerify; then
    EXIT_CODE=1
  fi

  SYSTEM_TYPE=$(_veilLsDetectSystem)
  if [[ $EXIT_CODE -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: module initialized ($SYSTEM_TYPE system)" >&2
  else
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: module initialized with warnings ($SYSTEM_TYPE system)" >&2
  fi
  
  return $EXIT_CODE
}

# Автоинициализация с обработкой ошибок
if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  if ! veilLsInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: critical - ls module failed to load" >&2
  fi
fi