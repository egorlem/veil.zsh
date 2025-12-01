# Veil Navigation Module
#
# Enhanced directory navigation with intelligent stack management and shortcuts.
#
# Features:
# • Auto-change directory without typing 'cd'
# • Smart aliases: .., ..., ...., .....
# • Clean stack behavior (no duplicates, silent operations)
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

_veilNavigationSetupOptions() {
  # Configure navigation options
  setopt AUTO_CD           # Change directory without typing 'cd'
  setopt AUTO_PUSHD        # Automatically push directories to stack
  setopt PUSHD_IGNORE_DUPS # Don't push duplicates to stack
  setopt PUSHD_SILENT      # Don't print stack on pushd/popd
  
  return 0
}

_veilNavigationSetupAliases() {
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
  alias .....='cd ../../../..'
  
  alias d='dirs -v'        # Show directory stack
  
  # if [[ -d "$HOME/Development" ]]; then
  #   alias dev='cd ~/dev'
  # fi

  return 0
}

_veilNavigationVerify() {
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
  local EXIT_CODE=0
  
  if ! _veilNavigationSetupOptions; then
    EXIT_CODE=1
  fi
  
  if ! _veilNavigationSetupAliases; then
    EXIT_CODE=1
  fi
  
  if ! _veilNavigationVerify; then
    EXIT_CODE=1
  fi
  
  if [[ $EXIT_CODE -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/navigation: navigation module initialized" >&2
  else
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/navigation: navigation module initialized with warnings" >&2
  fi
  
  return $EXIT_CODE
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilNavigationInit; then
     [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/navigation: critical - navigation module failed to load" >&2
  fi
fi