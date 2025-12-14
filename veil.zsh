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

VEIL_DIR="${0:A:h}"
MODULES_DIR="${VEIL_MODULES_DIR:-$VEIL_DIR/builtin/modules}"
THEMES_DIR="${VEIL_THEMES_DIR:-$VEIL_DIR/builtin/themes}"
THEME="${THEME:-ultima}"

if [[ -z "$VEIL_MODULES" ]]; then
  VEIL_MODULES=("less" "ls" "completion")
else
  # Split modules string into array (if passed as string)
  VEIL_MODULES=(${(@s: :)VEIL_MODULES})
fi

# Remove duplicate modules
typeset -U VEIL_MODULES

# Check for empty modules array
if [[ ${#VEIL_MODULES[@]} -eq 0 ]]; then
  [[ -n "$VEIL_VERBOSE" ]] && echo "veil: warning - no modules specified" >&2
fi

# ------------------------------------------------------------------------------
# SHARED VARIABLES (available to all modules)
# ------------------------------------------------------------------------------

# Color schemes for LS and completion
LSCOLORS="gxafexdxfxagadabagacad"                                                                   # BSD
LS_COLORS="di=36:ln=30;45:so=34:pi=33:ex=35:bd=30;46:cd=30;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"  # GNU
export LSCOLORS LS_COLORS

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

VEIL_CORE_LOADED=1

if ! __veilLoadTheme; then
  [[ -n "$VEIL_VERBOSE" ]] && echo "veil: warning - theme loading failed, continuing without theme" >&2
fi