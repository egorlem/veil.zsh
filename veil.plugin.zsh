# Veil Plugin Adapter
#
# Adapter for using Veil modules with OMZ, Zim, zcomet, and other
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE
# ------------------------------------------------------------------------------

# Set load mode to plugin
# shellcheck disable=SC2034
typeset -g VEIL_MODE="plugin"

# Path to the Veil core
typeset -g VEIL_CORE_FILE="${0:A:h}/veil.zsh"

veilCoreInit() {
  # shellcheck disable=SC1090
  if source "$VEIL_CORE_FILE"; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: core loaded successfully in plugin mode"
    return 0
  else
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: error - failed to load Veil in plugin mode" >&2
    return 1
  fi
}

veilCoreInit