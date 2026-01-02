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

typeset -gi _VEIL_LS_MODULE_LOADED=${_VEIL_LS_MODULE_LOADED:-0}

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
  local systemType="$1"
  local hasColorSupport=0
  
  if [[ -z "$LS_COLORS" && -z "$LSCOLORS" ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: warning - colors not configured, ls will be without colors" >&2
  fi
  
  case $systemType in
    bsd)
      if command ls -G /dev/null >/dev/null 2>&1; then 
        alias ls='command ls -G'
        alias ll='command ls -laG'
        alias la='command ls -laG'
        hasColorSupport=1
      fi
      ;;
    gnu)
      if command ls --color=auto /dev/null >/dev/null 2>&1; then
        alias ls='command ls --color=auto'
        alias ll='command ls -la --color=auto'
        alias la='command ls -la --color=auto'
        hasColorSupport=1
      fi
      ;;
    *)
      alias ll='command ls -la'
      alias la='command ls -la'
      ;;
  esac
  
  alias l='command ls -CF'
  
  if [[ $hasColorSupport -eq 0 ]]; then
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
  [[ $_VEIL_LS_MODULE_LOADED -eq 1 ]] && return 0
  _VEIL_LS_MODULE_LOADED=1

  local statusCode=0
  local systemType
  
  if ! __veilLsDeps; then
    return 1
  fi
  
  systemType=$(__veilLsDetectSystem)
  __veilLsSetupAliases "$systemType"
  
  if ! __veilLsVerify; then
    statusCode=1
  fi
  
  if [[ $statusCode -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: module initialized ($systemType system)" >&2
  fi
  
  return $statusCode
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilLsInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: critical - ls module failed to load" >&2
  fi
fi

typeset -a _VEIL_CLEANUP_FUNCS=(
  __veilLsDeps
  __veilLsDetectSystem
  __veilLsSetupAliases
  __veilLsVerify
)

unset -f $_VEIL_CLEANUP_FUNCS
unset _VEIL_CLEANUP_FUNCS