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
  
  # Basic editing keys
  bindkey '^[[3~' delete-char                   # Delete key - delete character
  bindkey '^H' backward-kill-word               # Ctrl+Backspace - delete word backward
  # bindkey '^[[3;5~' kill-word                   # Ctrl+Delete - delete word forward
  # bindkey '^W' backward-kill-word               # Ctrl+W - delete word backward (alternative)
  
  # Word navigation
  # bindkey '^[b' backward-word                   # Alt+Left - move to previous word
  # bindkey '^[f' forward-word                    # Alt+Right - move to next word
  # bindkey '^[^?' backward-kill-word             # Alt+Backspace - delete word backward
  
  # Line navigation
  # bindkey '^A' beginning-of-line                # Ctrl+A - move to beginning of line
  # bindkey '^E' end-of-line                      # Ctrl+E - move to end of line
  # bindkey '^U' kill-whole-line                  # Ctrl+U - delete to beginning of line
  # bindkey '^K' kill-line                        # Ctrl+K - delete to end of line
  # bindkey '^Y' yank                             # Ctrl+Y - paste (yank)
  
  # History navigation
  # bindkey '^R' history-incremental-search-backward  # Ctrl+R - search history backward
  # bindkey '^P' up-history                       # Ctrl+P - previous command in history
  # bindkey '^N' down-history                     # Ctrl+N - next command in history
  
  # Navigation in completions
  # bindkey '^[[A' up-line-or-search              # Up arrow - history or navigate completions
  # bindkey '^[[B' down-line-or-select            # Down arrow - next line or select completion
  
  # Advanced editing
  # bindkey '^T' transpose-chars                  # Ctrl+T - transpose characters
  # bindkey '^[t' transpose-words                 # Alt+T - transpose words
  # bindkey '^[c' capitalize-word                 # Alt+C - capitalize word
  # bindkey '^[u' up-case-word                    # Alt+U - uppercase word
  # bindkey '^[l' down-case-word                  # Alt+L - lowercase word
  
  # Process management
  # bindkey '^C' send-break                       # Ctrl+C - interrupt/send break
  # bindkey '^D' delete-char-or-list              # Ctrl+D - delete char or exit if line empty
  # bindkey '^Z' undo                             # Ctrl+Z - undo
  
  # Completion
  bindkey '^I' complete-word                    # Tab - trigger completion
  bindkey '^[[Z' reverse-menu-complete          # Shift+Tab - reverse menu completion

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