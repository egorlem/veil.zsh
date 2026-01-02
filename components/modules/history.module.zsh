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

typeset -gi _VEIL_HISTORY_MODULE_LOADED=${_VEIL_HISTORY_MODULE_LOADED:-0}

__veilHistorySetupEnv() {
  export HISTFILE="$HOME/.zsh_history"
  export HISTSIZE=100000
  export SAVEHIST=100000
  
  local histDir="${HISTFILE:h}"
  if [[ ! -d "$histDir" ]]; then
    if ! mkdir -p "$histDir" 2>/dev/null; then
      [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/history: error - cannot create history directory $histDir" >&2
      return 1
    fi
  fi
  
  if [[ ! -w "$histDir" ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/history: error - history directory $histDir is not writable" >&2
    return 1
  fi
  
  return 0
}

__veilHistorySetupOptions() {
  setopt EXTENDED_HISTORY                                # timestamps in history
  setopt HIST_EXPIRE_DUPS_FIRST          # remove duplicates first when trimming
  setopt HIST_IGNORE_DUPS                        # ignore consecutive duplicates
  setopt HIST_IGNORE_ALL_DUPS                          # remove older duplicates
  setopt HIST_FIND_NO_DUPS                     # don't show duplicates in search
  setopt HIST_IGNORE_SPACE             # don't save commands starting with space
  setopt HIST_REDUCE_BLANKS                  # remove extra blanks from commands
  setopt HIST_VERIFY                             # show command before execution
  setopt SHARE_HISTORY                          # share history between sessions
  
  return 0
}

__veilHistorySetupAliases() {
  alias h='history'

  if ! alias history >/dev/null 2>&1; then
    alias history='fc -l 1'
  fi

  return 0
}

__veilHistoryVerify() {
  [[ -n "$HISTFILE" ]] || {
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/history: error - HISTFILE not set" >&2
    return 1
  }
  return 0
}

veilHistoryInit() {
  [[ $_VEIL_HISTORY_MODULE_LOADED -eq 1 ]] && return 0
  _VEIL_HISTORY_MODULE_LOADED=1
  
  if ! __veilHistorySetupEnv; then
    return 1
  fi

  if ! __veilHistoryVerify; then
    return 1
  fi
  
  __veilHistorySetupOptions
  __veilHistorySetupAliases

  [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/history: initialized (HISTSIZE: $HISTSIZE)" >&2
  
  return 0
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilHistoryInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/history: critical - module failed to load" >&2
  fi
fi

typeset -a _VEIL_CLEANUP_FUNCS=(
  __veilHistorySetupEnv
  __veilHistorySetupOptions
  __veilHistorySetupAliases
  __veilHistoryVerify
)

unset -f $_VEIL_CLEANUP_FUNCS
unset _VEIL_CLEANUP_FUNCS