# Veil Keybindings Module
#
# Enhanced keyboard bindings for improved terminal workflow.
#
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------

typeset -gi _VEIL_KEYBINDINGS_MODULE_LOADED=${_VEIL_KEYBINDINGS_MODULE_LOADED:-0}

__veilKeybindingsValidateTerm() {
    if [[ "$TERM" == "dumb" || "$TERM" == "unknown" ]]; then
        [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/keybindings: warning - terminal $TERM does not support advanced keybindings" >&2
        return 1
    fi
    return 0
}

__veilKeybindingsSpecialKeysSetup() {
    zmodload zsh/terminfo 2>/dev/null || return 1

    [[ -n "${terminfo[kpp]}" ]] && bindkey "${terminfo[kpp]}" up-line-or-history      # PageUp
    [[ -n "${terminfo[knp]}" ]] && bindkey "${terminfo[knp]}" down-line-or-history    # PageDown
    [[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line   # Home
    [[ -n "${terminfo[kend]}" ]] && bindkey "${terminfo[kend]}" end-of-line           # End
    
    bindkey '^[OH' beginning-of-line                                                  # Home (xterm)
    bindkey '^[OF' end-of-line                                                        # End (xterm)

    return 0
}

__veilKeybindingsSetup() {
    # Backspace / Delete
    bindkey '^?' backward-delete-char        # Backspace
    bindkey '^H' backward-kill-word          # Ctrl+H or Ctrl+Backspace
    bindkey '^[[3~' delete-char              # Delete
    bindkey '^[3;5~' delete-char             # Delete (alt)

    # Word operations
    bindkey '^[[3;5~' kill-word              # Ctrl+Delete
    bindkey '^[^?' backward-kill-word        # Alt+Backspace

    # Ctrl+arrows
    bindkey '^[[1;5C' forward-word           # Ctrl+Right
    bindkey '^[[5C' forward-word             # Ctrl+Right (old)
    bindkey '^[OC' forward-word              # Ctrl+Right (app mode)
    bindkey '^[[1;5D' backward-word          # Ctrl+Left
    bindkey '^[[5D' backward-word            # Ctrl+Left (old)
    bindkey '^[OD' backward-word             # Ctrl+Left (app mode)

    # Alt+arrows
    bindkey '^[f' forward-word               # Alt+Right
    bindkey '^[b' backward-word              # Alt+Left
    bindkey '^[[1;3C' forward-word           # Alt+Right (alt)
    bindkey '^[[1;3D' backward-word          # Alt+Left (alt)

    # Line editing
    bindkey '^A' beginning-of-line           # Ctrl+A
    bindkey '^E' end-of-line                 # Ctrl+E
    bindkey '^K' kill-line                   # Ctrl+K
    bindkey '^U' backward-kill-line          # Ctrl+U
    bindkey '^Y' yank                        # Ctrl+Y
    bindkey '^W' backward-kill-word          # Ctrl+W

    # History
    bindkey '^R' history-incremental-search-backward   # Ctrl+R
    bindkey '^S' history-incremental-search-forward    # Ctrl+S
    bindkey '^P' up-history                            # Ctrl+P
    bindkey '^N' down-history                          # Ctrl+N
    bindkey '^[r' history-incremental-search-forward   # Alt+R

    # Completion
    bindkey '^I' complete-word               # Tab

    # Transpose
    bindkey '^T' transpose-chars             # Ctrl+T

    return 0
}

veilKeybindingsInit() {
    [[ $_VEIL_KEYBINDINGS_MODULE_LOADED -eq 1 ]] && return 0
    
    if ! __veilKeybindingsValidateTerm; then
        return 1
    fi
    
    local bindkeyMode
    if bindkey -l | grep -q emacs; then
        bindkeyMode="emacs"
    else
        bindkeyMode="vi"
    fi
    
    if [[ -n "$bindkeyMode" ]]; then
        [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/keybindings: module initialized (${bindkeyMode} mode)" >&2
    else
        [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/keybindings: warning - unable to determine keymap mode" >&2
    fi
    
    __veilKeybindingsSpecialKeysSetup
    __veilKeybindingsSetup
    
    _VEIL_KEYBINDINGS_MODULE_LOADED=1
    
    return 0
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
    if ! veilKeybindingsInit; then
        [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/keybindings: critical - keybindings module failed to load" >&2
    fi
fi

typeset -a _VEIL_CLEANUP_FUNCS=(
  __veilKeybindingsValidateTerm
  __veilKeybindingsSpecialKeysSetup
  __veilKeybindingsSetup
)

unset -f $_VEIL_CLEANUP_FUNCS
unset _VEIL_CLEANUP_FUNCS