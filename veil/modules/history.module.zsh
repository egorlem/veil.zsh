# Veil History Module
#
# Enhanced Zsh history with persistent storage, deduplication, and useful aliases.
#
# Features:
# • Persistent history (100k commands) with timestamps
# • Smart deduplication and space optimization  
# • Shared history across sessions
# • Convenient aliases: history, h, hg (search)
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

_veilHistorySetupEnv() {
  export HISTFILE="$HOME/.zsh_history"
  export HISTSIZE=100000
  export SAVEHIST=100000
  
  local HIST_DIR="${HISTFILE:h}"
  if [[ ! -d "$HIST_DIR" ]]; then
    if ! mkdir -p "$HIST_DIR" 2>/dev/null; then
      [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "History module: error - cannot create history directory $HIST_DIR" >&2
      return 1
    fi
  fi
  
  if [[ ! -w "$HIST_DIR" ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "History module: error - history directory $HIST_DIR is not writable" >&2
    return 1
  fi
  
  return 0
}

_veilHistorySetupOptions() {
  # History options configuration
  setopt EXTENDED_HISTORY        # timestamps in history
  setopt HIST_EXPIRE_DUPS_FIRST  # remove duplicates first when trimming
  setopt HIST_IGNORE_DUPS        # ignore consecutive duplicates
  setopt HIST_IGNORE_ALL_DUPS    # remove older duplicates
  setopt HIST_FIND_NO_DUPS       # don't show duplicates in search
  setopt HIST_IGNORE_SPACE       # don't save commands starting with space
  setopt HIST_REDUCE_BLANKS      # remove extra blanks from commands
  setopt HIST_VERIFY             # show command before execution
  setopt SHARE_HISTORY           # share history between sessions
  
  return 0
}

_veilHistorySetupAliases() {
  # Clean alias creation
  alias history='fc -l 1'
  alias h='history'
  
  if command -v grep >/dev/null 2>&1; then
    alias hg='history | grep'
  fi
  
  return 0
}

_veilHistoryVerify() {
  [[ -n "$HISTFILE" ]] || {
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "History module: error - HISTFILE not set" >&2
    return 1
  }
  return 0
}

veilHistoryInit() {
  # Main initialization function
  local EXIT_CODE=0
  
  if ! _veilHistorySetupEnv; then
    EXIT_CODE=1
  fi
  
  if ! _veilHistorySetupOptions; then
    EXIT_CODE=1
  fi
  
  if ! _veilHistorySetupAliases; then
    EXIT_CODE=1
  fi
  
  if ! _veilHistoryVerify; then
    EXIT_CODE=1
  fi
  
  if [[ $EXIT_CODE -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "History module: initialized (HISTSIZE: $HISTSIZE)"
  else
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "History module: initialized with warnings" >&2
  fi
  
  return $EXIT_CODE
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilHistoryInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "History module: critical - module failed to load" >&2
  fi
fi