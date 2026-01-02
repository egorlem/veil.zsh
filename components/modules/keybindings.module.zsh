# Veil Keybindings Module
#
# Enhanced keyboard bindings for improved terminal workflow.
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

typeset -gi _VEIL_KEYBINDINGS_MODULE_LOADED=${_VEIL_KEYBINDINGS_MODULE_LOADED:-0}

__veilKeybindingsSetup() {
  # Note: History search bindings are commented out as they require
  # history-substring-search plugin. Uncomment if plugin is installed.
  # bindkey '^[[A' history-substring-search-up    # Up arrow - history search
  # bindkey '^[[B' history-substring-search-down  # Down arrow - history search
  
  # Note: Home/End bindings may vary by terminal. These are common defaults.
  # bindkey '^[OH' beginning-of-line              # Home - beginning of line
  # bindkey '^[OF' end-of-line                    # End - end of line
  
  bindkey '^[[3~' delete-char                   # Delete key - delete character
  bindkey '^H' backward-kill-word               # Ctrl+Backspace - delete word backward
  
  bindkey '^I' complete-word                    # Tab - smart completion
  
  return 0
}

veilKeybindingsInit() {
  [[ $_VEIL_KEYBINDINGS_MODULE_LOADED -eq 1 ]] && return 0
  _VEIL_KEYBINDINGS_MODULE_LOADED=1

  __veilKeybindingsSetup
  
  [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/keybindings: module initialized" >&2
  
  return 0
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilKeybindingsInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/keybindings: critical - keybindings module failed to load" >&2
  fi
fi

unset -f __veilKeybindingsSetup