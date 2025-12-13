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

__veilEnvSetup() {
  export EDITOR='vim'
  export VISUAL='vim'
  export PAGER='less'
  
  export LANG='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
  
  return 0
}

__veilEnvVerify() {
  # Проверяем что ключевые переменные установлены
  if [[ -z "$EDITOR" ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/env: error - EDITOR not set" >&2
    return 1
  fi
  
  if [[ -z "$PAGER" ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/env: error - PAGER not set" >&2
    return 1
  fi
  
  return 0
}

veilEnvInit() {
  local statusCode=0
  
  __veilEnvSetup
  
  if ! __veilEnvVerify; then
    statusCode=1
  fi
  
  if [[ $statusCode -eq 0 ]]; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/env: module initialized" >&2
  fi
  
  return $statusCode
}

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! veilEnvInit; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/env: critical - environment module failed to load" >&2
  fi
fi