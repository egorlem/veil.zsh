# Veil Aliases Module
#
# Common aliases for daily terminal usage.
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

typeset -gi _VEIL_ALIASES_MODULE_LOADED=${_VEIL_ALIASES_MODULE_LOADED:-0}

__veilAliasesSetup() {
  # Fun utility - Matrix reference
  alias stay="printf '\x1b[32mFollow the white rabbit...\x1b[0m\n'"
  
  # Safety aliases (commented out - enable if desired)
  # alias rm='rm -i'
  # alias cp='cp -i'
  # alias mv='mv -i'
  
  # Git shortcuts (commented out - examples for customization)
  # alias gs='git status'
  # alias ga='git add'
  # alias gc='git commit'
  # alias gd='git diff'
  # alias gl='git log --oneline --graph'
    
  # Network utilities (commented out - examples for customization)
  # alias ip='curl -s ifconfig.me'
  # alias localip='ipconfig getifaddr en0'
  # alias ping='ping -c 5'
  
  return 0
}

veilAliasesInit() {
  [[ $_VEIL_ALIASES_MODULE_LOADED -eq 1 ]] && return 0
  _VEIL_ALIASES_MODULE_LOADED=1

  __veilAliasesSetup
  
  [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/aliases: module initialized" >&2
  
  return 0
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilAliasesInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/aliases: critical - aliases module failed to load" >&2
  fi
fi

unset -f __veilAliasesSetup