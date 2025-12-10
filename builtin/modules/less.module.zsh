# Veil Less Module
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

__veilLessDeps() {
  if ! command -v less >/dev/null 2>&1; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/less: error - 'less' command not found" >&2
    return 1
  fi
  return 0
}

__veilLessValidateTerm() {
  if [[ "$TERM" == "dumb" || "$TERM" == "unknown" ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/less: warning - terminal may not support less features" >&2
    return 1
  fi
  return 0
}

__veilLessSetupEnv() {
  local LESS_OPTS="--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4"
  
  if ! LESS="$LESS_OPTS" less --version >/dev/null 2>&1; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/less: warning - some less options not supported, using minimal set" >&2
    LESS_OPTS="--quit-if-one-screen --ignore-case --LONG-PROMPT --tabs=4"
  fi
  
  export LESS="$LESS_OPTS"
  export GROFF_NO_SGR=1
  
  if __veilLessValidateTerm; then
    export LESS_TERMCAP_mb=$'\x1b[0;36m'    # begin bold
    export LESS_TERMCAP_md=$'\x1b[0;34m'    # begin blink  
    export LESS_TERMCAP_me=$'\x1b[0m'       # reset bold/blink
    export LESS_TERMCAP_so=$'\x1b[0;30m' # begin reverse video
    export LESS_TERMCAP_se=$' \x1b[0m'      # reset reverse video
    export LESS_TERMCAP_us=$'\x1b[0m\x1b[0;32m' # begin underline
    export LESS_TERMCAP_ue=$'\x1b[0m'       # reset underline
  fi
  
  return 0
}

__veilLessSetupAliases() {
  alias less='less --RAW-CONTROL-CHARS'   # Always ensure color support
  alias more='less'                       # Use less instead of more
  
  export MANPAGER="less -s -M +Gg"
  export MANWIDTH=80
  
  return 0
}

__veilLessSetupHelpers() {
  lessSearch() {
    less -p "$1" "$2"
  }

  lessTail() {
    less +F "$1"
  }
  
  return 0
}

__veilLessAdaptToTerminal() {
  case "$TERM" in
    "xterm-kitty")
      # Kitty terminal has better scrollback
      export LESS="--quit-if-one-screen --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4"
      ;;
    "linux"|"console")
      # Simplified for limited terminals
      export LESS="--quit-if-one-screen --ignore-case --LONG-PROMPT --tabs=4"
      export MANPAGER="less -s -M"
      ;;
  esac
  
  return 0
}

__veilLessVerify() {
  if [[ -z "$LESS" ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/less: error - LESS environment variable not set" >&2
    return 1
  fi
  
  return 0
}

veilLessInit() {
  if ! __veilLessDeps; then
    return 1
  fi

  __veilLessSetupEnv
  __veilLessSetupAliases
  __veilLessSetupHelpers
  __veilLessAdaptToTerminal
  
  if ! __veilLessVerify; then
    return 1
  fi

  if [[ $STATUS_CODE -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/less: module initialized" >&2
  fi
  
  return 0
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilLessInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/less: critical - less module failed to load" >&2
  fi
fi