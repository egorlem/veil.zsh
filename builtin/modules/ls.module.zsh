# Veil Ls Module
#
# Enhanced Zsh ls aliases with cross-platform color support.
#
# Features:
# • Cross-platform color support (BSD -G / GNU --color=auto)
# • Optimized aliases: ls, ll, la, l
# • Graceful fallbacks when color not available
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

__veilLsDeps() {
  if ! command -v ls >/dev/null 2>&1; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: error - 'ls' command not found" >&2
    return 1
  fi
  return 0
}

__veilLsDetectSystem() {
  case "$OSTYPE" in
    darwin*) echo "bsd" ;;
    linux*) echo "gnu" ;;
    freebsd*|openbsd*) echo "bsd" ;;
    *) echo "unknown" ;;
  esac
}

__veilLsSetupAliases() {
  local SYSTEM_TYPE
  SYSTEM_TYPE=$(__veilLsDetectSystem)
  local HAS_COLOR_SUPPORT=0
  
  if [[ -z "$LS_COLORS" && -z "$LSCOLORS" ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: warning - colors not configured, ls will be without colors" >&2
  fi
  
  case $SYSTEM_TYPE in
    bsd)
      if command ls -G /dev/null >/dev/null 2>&1; then 
        alias ls='command ls -G'
        alias ll='command ls -laG'
        alias la='command ls -laG'
        HAS_COLOR_SUPPORT=1
      fi
      ;;
    gnu)
      if command ls --color=auto /dev/null >/dev/null 2>&1; then
        alias ls='command ls --color=auto'
        alias ll='command ls -la --color=auto'
        alias la='command ls -la --color=auto'
        HAS_COLOR_SUPPORT=1
      fi
      ;;
    *)
      alias ll='command ls -la'
      alias la='command ls -la'
      ;;
  esac
  
  alias l='command ls -CF'
  
  if [[ $HAS_COLOR_SUPPORT -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: warning - color support not available for ls" >&2
  fi
  
  return 0
}

__veilLsVerify() {
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
  local STATUS_CODE=0
  local SYSTEM_TYPE
  
  if ! __veilLsDeps; then
    return 1
  fi
  
  __veilLsSetupAliases
  
  if ! __veilLsVerify; then
    STATUS_CODE=1
  fi

  SYSTEM_TYPE=$(__veilLsDetectSystem)
  if [[ $STATUS_CODE -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: module initialized ($SYSTEM_TYPE system)" >&2
  fi
  
  return $STATUS_CODE
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilLsInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: critical - ls module failed to load" >&2
  fi
fi