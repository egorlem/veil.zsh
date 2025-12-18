# Veil — https://github.com/egorlem/veil.zsh
#
# Modular Z Shell Configuration System
# Takes full control of zsh configuration through logical modules
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CORE CONFIGURATION
# ------------------------------------------------------------------------------

if [[ -n "$VEIL_CORE_LOADED" ]]; then
  return 0
fi

typeset -gxr VEIL_DIR="${0:A:h}"
typeset -g MODULES_DIR="${VEIL_MODULES_DIR:-$VEIL_DIR/components/modules}"
typeset -g THEMES_DIR="${VEIL_THEMES_DIR:-$VEIL_DIR/components/themes}"
typeset -g THEME="${THEME:-ultima}"

# ------------------------------------------------------------------------------
# VEIL_MODULES normalization
# ------------------------------------------------------------------------------

__veilNormalizeModules() {
  if ! typeset -p VEIL_MODULES >/dev/null 2>&1; then
    VEIL_MODULES=(less ls completion)
    return 0
  fi

  if [[ "$(typeset -p VEIL_MODULES 2>/dev/null)" != *"-a"* ]]; then
    # shellcheck disable=SC2206,SC2296
    VEIL_MODULES=(${(s: :)VEIL_MODULES})
    return 0
  fi

  if (( ${#VEIL_MODULES[@]} == 0 )); then
    VEIL_MODULES=()
  fi

  return 0
}

# Remove duplicate modules
__veilNormalizeModules
typeset -U VEIL_MODULES

# Warn if empty
if [[ ${#VEIL_MODULES[@]} -eq 0 ]]; then
  [[ -n "$VEIL_VERBOSE" ]] && echo "veil: warning - no modules specified" >&2
fi

# ------------------------------------------------------------------------------
# MODULE SYSTEM
# ------------------------------------------------------------------------------

# Associative array to track loaded modules
typeset -gA VEIL_MODULE_LOADED

__veilLoadModule() {
  local moduleFile="$MODULES_DIR/$1.module.zsh"
  
  # Validate module name to prevent path traversal
  if [[ ! "$1" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: invalid module name: $1" >&2
    return 1
  fi
  
  if [[ ! -f "$moduleFile" ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: error - module $1 not found at $moduleFile" >&2
    return 1
  fi

  if [[ ! -r "$moduleFile" ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: error - cannot read module $1" >&2
    return 1
  fi
  
  if [[ -n "${VEIL_MODULE_LOADED[$1]}" ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: module '$1' already loaded" >&2
    return 0
  fi
  
  # shellcheck source=/dev/null
  if source "$moduleFile"; then
    VEIL_MODULE_LOADED[$1]=1
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: module '$1' loaded successfully"
    return 0
  else
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: error - failed to load module '$1'" >&2
    return 1
  fi
}

__veilLoadTheme() {
  local themeFile="$THEMES_DIR/${THEME}.zsh-theme"
  
  # Validate module name to prevent path traversal
  if [[ ! "$THEME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: invalid theme name: $THEME" >&2
    return 1
  fi
  
  if [[ ! -f "$themeFile" ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: error - theme file not found: $themeFile" >&2
    return 1
  fi
  
  if [[ ! -r "$themeFile" ]]; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: error - cannot read theme file: $themeFile" >&2
    return 1
  fi

  # shellcheck source=/dev/null
  if source "$themeFile"; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: theme '$THEME' loaded successfully"
    return 0
  else
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: error - failed to load theme '$THEME'" >&2
    return 1
  fi
}

# Load modules if available
if [[ -d "$MODULES_DIR" ]]; then
  for module in "${VEIL_MODULES[@]}"; do
    __veilLoadModule "$module"
  done
else
  [[ -n "$VEIL_VERBOSE" ]] && echo "veil: running in minimal mode without modules" >&2
fi

typeset -gr VEIL_CORE_LOADED=1

if ! __veilLoadTheme; then
  [[ -n "$VEIL_VERBOSE" ]] && echo "veil: warning - theme loading failed, continuing without theme" >&2
fi