# Veil Plugin Adapter
#
# Adapter for using Veil modules with OMZ, Zim, ZComet, and other frameworks
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE
# ------------------------------------------------------------------------------

# Set load mode to plugin
typeset -g VEIL_MODE="plugin"

# Path to the Veil core
typeset -g VEIL_CORE_FILE="${0:A:h}/veil.zsh"

veilCoreInit() {
  if source "$VEIL_CORE_FILE"; then
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: core loaded successfully in plugin mode"
    return 0
  else
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil: error - failed to load Veil in plugin mode" >&2
    return 1
  fi
}

veilCoreInit