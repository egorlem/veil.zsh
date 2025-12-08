# Veil Completion Module
#
# Enhanced Zsh completion system with caching and customizable styles
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

__veilCompletionDeps() {
  if ! autoload -Uz compinit >/dev/null 2>&1; then
     [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/completion: error - zsh completion system not available" >&2
    return 1
  fi

  return 0
}

__veilCompletionInitSystem() {
  local CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local COMPDUMP="$CACHE_DIR/.zcompdump"
  
  if [[ ! -d "$CACHE_DIR" ]]; then
    if ! mkdir -p "$CACHE_DIR" 2>/dev/null; then
      [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/completion: warning - cannot create cache directory, using default" >&2
      COMPDUMP="$HOME/.zcompdump"
    fi
  fi
  
  if [[ -n "$COMPDUMP"(#qN.mh+24) ]]; then
    compinit -d "$COMPDUMP"
  else
    compinit -d "$COMPDUMP" -C
  fi
  
  if [[ $? -ne 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/completion: error - compinit with cache failed, trying without cache" >&2
    if ! compinit 2>/dev/null; then
      [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/completion: critical - compinit failed completely" >&2
      return 2
    fi
    
    return 1
  fi
  
  return 0
}

__veilCompletionSetupOptions() {
  setopt MENU_COMPLETE
  setopt LIST_TYPES
  setopt GLOB_COMPLETE

  return 0
}

__veilCompletionSetupStyles() {
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*' menu select=2
  zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}" "r:|[-._]=*" "r:|=* r:|[-._]=*" "l:|=* r:|=* l:|=*"
  zstyle ':completion:*' group-name ''
  
  zstyle ':completion:*' completer _expand _complete _correct
  
  zstyle ':completion:*:expand:*' tag-order all-expansions

  zstyle ':completion:*:correct:*' original true
  zstyle ':completion:*:correct:*' insert-unambiguous true

  zstyle ':completion:*:descriptions' format "%F{0} › %d%f"
  zstyle ':completion:*:corrections' format "%F{2} › %d%f"
  zstyle ':completion:*:warnings' format "%F{1} › no matches for: %f%d"
  zstyle ':completion:*:messages' format "%d"
  zstyle ':completion:*' select-prompt "%F{0}position %p%f"

  zstyle ':completion:*' squeeze-slashes true                                    
  
  if [[ -n "$LS_COLORS" ]]; then
    # for ultima ${(s.:.)LS_COLORS} "ma=92;48;5;23"
    zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
  else
    zstyle ':completion:*:*:*:*:default' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
  fi
  
  zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
  zstyle ':completion:*:functions' ignored-patterns '_*' '__veil*' 'veil*'
  
  return 0
}

__veilCompletionSetupHosts() {
  local file
  local HOST_FILES=(
    "/etc/ssh/ssh_known_hosts"
    "/etc/ssh/ssh_known_hosts2" 
    "$HOME/.ssh/known_hosts"
    "$HOME/.ssh/known_hosts2"
  )
  local FOUND_FILES=()
  
  for file in $HOST_FILES; do
    if [[ -f "$file" && -r "$file" ]]; then
      FOUND_FILES+=("$file")
    fi
  done
  
  if [[ ${#FOUND_FILES} -gt 0 ]]; then
    zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts \
      'reply=(${=${${(f)"$(cat ${^FOUND_FILES} 2>/dev/null)"}%%[# ]*}//,/ })'
  fi
  
  return 0
}

veilCompletionInit() {
  local STATUS_CODE=0
  
  if ! __veilCompletionDeps; then
    return 1  # Нет completion системы
  fi
  
  __veilCompletionInitSystem
  STATUS_CODE=$?
  
  if [[ $STATUS_CODE -eq 2 ]]; then
    return 1
  fi
  
  __veilCompletionSetupOptions
  __veilCompletionSetupStyles
  __veilCompletionSetupHosts
  
  if [[ $STATUS_CODE -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/completion: module initialized with cache"
  elif [[ $STATUS_CODE -eq 1 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/completion: module initialized (cache failed but completion works)"
  fi
  
  return 0
}


if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilCompletionInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/completion: critical - module failed to load" >&2
  fi
fi  