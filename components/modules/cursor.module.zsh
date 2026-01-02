# Veil Cursor Module
#
# Terminal cursor visibility control system.
#
# Features:
# • Smart cursor hiding during clear operations
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

typeset -gi _TERMINAL_CURSOR_VISIBLE=1
typeset -gi _VEIL_CURSOR_MODULE_LOADED=${_VEIL_CURSOR_MODULE_LOADED:-0}

# ------------------------------------------------------------------------------
# PRIVATE CURSOR CONTROL FUNCTIONS
# ------------------------------------------------------------------------------

__veilCursorHide() {
  printf '\033[?25l'
  _TERMINAL_CURSOR_VISIBLE=0
}

__veilCursorShow() {
  printf '\033[?25h'
  _TERMINAL_CURSOR_VISIBLE=1
}

__veilCursorEnsureVisible() {
  if (( ! _TERMINAL_CURSOR_VISIBLE )); then
      __veilCursorShow
  fi
}

__veilCursorScheduleRestore() {
  precmd_functions=(${precmd_functions:#__veilCursorRestore})
  precmd_functions+=(__veilCursorRestore)
}

__veilCursorRestore() {
  __veilCursorShow
  precmd_functions=(${precmd_functions:#__veilCursorRestore})
}

# ------------------------------------------------------------------------------
# ENHANCED CLEAR COMMAND (with cursor control)
# ------------------------------------------------------------------------------

clear() {
  __veilCursorHide
  command clear
  __veilCursorScheduleRestore
}

# ------------------------------------------------------------------------------
# PUBLIC CURSOR UTILITIES
# ------------------------------------------------------------------------------

veilCursorFix() {
  # Contract: forces cursor visibility as safety measure
  # Use: when cursor disappears unexpectedly
  # Returns: 0 always
  
  __veilCursorEnsureVisible
  echo "Cursor state reset"
  return 0
}

veilCursorState() {
  # Contract: reports current cursor visibility state
  # Returns: 0 always, prints state to stdout
  
  if (( _TERMINAL_CURSOR_VISIBLE )); then
      echo "Cursor: VISIBLE"
  else
      echo "Cursor: HIDDEN"
  fi
  return 0
}

# ------------------------------------------------------------------------------
# MODULE INITIALIZATION
# ------------------------------------------------------------------------------

__veilCursorSetup() {
  # Initial safety check
  __veilCursorEnsureVisible
  
  # Ensure clean hook registration
  precmd_functions=(${precmd_functions:#__veilCursorRestore})
  
  return 0
}

veilCursorInit() {
  [[ $_VEIL_CURSOR_MODULE_LOADED -eq 1 ]] && return 0
  _VEIL_CURSOR_MODULE_LOADED=1
            
  __veilCursorSetup
  
  [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/cursor: module initialized" >&2
  
  return 0
}

# ------------------------------------------------------------------------------
# AUTO-INITIALIZATION
# ------------------------------------------------------------------------------

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilCursorInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/cursor: critical - cursor module failed to load" >&2
  fi
fi