# Veil Environment Module
#
# Environment variable configuration with sensible defaults.
#
# ------------------------------------------------------------------------------
# License: WTFPL — https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------

typeset -gi _VEIL_ENV_MODULE_LOADED=${_VEIL_ENV_MODULE_LOADED:-0}

__veilEnvSetup() {
  export EDITOR='vim'
  export VISUAL='vim'
  export PAGER='less'
  
  export LANG='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
  
  return 0
}

veilEnvInit() {
  [[ $_VEIL_ENV_MODULE_LOADED -eq 1 ]] && return 0
  _VEIL_ENV_MODULE_LOADED=1  
  
  __veilEnvSetup
  
  [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/env: module initialized" >&2
  
  return 0
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilEnvInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/env: critical - environment module failed to load" >&2
  fi
fi

unset -f __veilEnvSetup