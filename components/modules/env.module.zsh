# Veil Environment Module
#
# Environment variable configuration with sensible defaults.
#
# ------------------------------------------------------------------------------
# License: WTFPL — https://github.com/egorlem/veil.zsh/blob/main/LICENSE 
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

typeset -gi _VEIL_ENV_MODULE_LOADED=${_VEIL_ENV_MODULE_LOADED:-0}
typeset -g VEIL_SECRETS_DIR="${VEIL_SECRETS_DIR:-${HOME}/.config/secrets}"

__veilLoadSecrets() {
  [[ ! -d "$VEIL_SECRETS_DIR" ]] && return 0
  
  local secretFile
  
  for secretFile in "$VEIL_SECRETS_DIR"/*.zsh(N); do
    [[ ! -f "$secretFile" ]] && continue
    
    local filename="${secretFile:t}"
    
    if [[ ! "$filename" =~ '^[a-zA-Z0-9._-]+\.zsh$' ]]; then
      [[ -n "$VEIL_VERBOSE" ]] && echo "veil/env: skipping invalid file: $filename" >&2
      continue
    fi
    
    if [[ ! "$(stat -f "%OLp" "$secretFile" 2>/dev/null)" =~ ^[46]00$ ]] && \
       [[ ! "$(stat -c "%a" "$secretFile" 2>/dev/null)" =~ ^[46]00$ ]]; then
      [[ -n "$VEIL_VERBOSE" ]] && echo "veil/env: warning - insecure permissions on $filename (should be 600)" >&2
    fi
    
    source "$secretFile"
    
    [[ -n "$VEIL_VERBOSE" ]] && echo "veil/env: loaded secrets from $filename" >&2
  done
  
  return 0
}

__veilEnvSetup() {
  export EDITOR='vim'
  export VISUAL='vim'
  export PAGER='less'
  
  export LANG='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
  
  __veilLoadSecrets
  
  return 0
}

veilEnvInit() {
  [[ $_VEIL_ENV_MODULE_LOADED -eq 1 ]] && return 0
  _VEIL_ENV_MODULE_LOADED=1  
  
  __veilEnvSetup
  
  [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/env: module initialized" >&2
  
  return 0
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilEnvInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/env: critical - environment module failed to load" >&2
    return 1
  fi
fi

typeset -a _VEIL_ENV_CLEANUP_FUNCS=(
  __veilEnvSetup
  __veilLoadSecrets
)

unset -f $_VEIL_ENV_CLEANUP_FUNCS
unset _VEIL_ENV_CLEANUP_FUNCS