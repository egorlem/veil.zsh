# Veil Navigation Module
#
# Enhanced directory navigation with intelligent stack management and shortcuts.
#
# Features:
# - Auto-change directory without typing 'cd'
# - Smart aliases: .., ..., ...., .....
# - Clean stack behavior (no duplicates, silent operations)
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------

typeset -gi _VEIL_NAVIGATION_MODULE_LOADED=${_VEIL_NAVIGATION_MODULE_LOADED:-0}

__veilNavigationSetupOptions() {
  # Configure navigation options
  setopt AUTO_CD                          # Change directory without typing 'cd'
  setopt AUTO_PUSHD                    # Automatically push directories to stack
  setopt PUSHD_IGNORE_DUPS                      # Don't push duplicates to stack
  setopt PUSHD_SILENT                          # Don't print stack on pushd/popd
  
  return 0
}

__veilNavigationSetupAliases() {
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
  alias .....='cd ../../../..'
  
  alias d='dirs -v'                                       # Show directory stack
  
  # if [[ -d "$HOME/Development" ]]; then
  #   alias dev='cd ~/dev'
  # fi

  return 0
}

__veilNavigationVerify() {
  if ! alias .. >/dev/null 2>&1; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/navigation: error - failed to create navigation aliases" >&2
    return 1
  fi
  
  if ! alias d >/dev/null 2>&1; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/navigation: error - failed to create dirs alias" >&2
    return 1
  fi
  
  return 0
}

veilNavigationInit() {
  [[ $_VEIL_NAVIGATION_MODULE_LOADED -eq 1 ]] && return 0
  _VEIL_NAVIGATION_MODULE_LOADED=1

  local statusCode=0
  
  __veilNavigationSetupOptions
  __veilNavigationSetupAliases

  if ! __veilNavigationVerify; then
    statusCode=1
  fi
  
  if [[ $statusCode -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/navigation: module initialized" >&2
  fi
  
  return $statusCode
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilNavigationInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/navigation: critical - navigation module failed to load" >&2
  fi
fi

typeset -a _VEIL_CLEANUP_FUNCS=(
  __veilNavigationSetupOptions
  __veilNavigationSetupAliases
  __veilNavigationVerify
)

unset -f $_VEIL_CLEANUP_FUNCS
unset _VEIL_CLEANUP_FUNCS
