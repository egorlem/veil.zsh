# Veil Evn Module
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

initEnvironmentSettings() {
  export EDITOR='vim' 
  export VISUAL='vim'
  export PAGER='less'
  
  export LANG='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
}

# veilLsInit() {
#   # Основная функция инициализации
#   local EXIT_CODE=0
#   local SYSTEM_TYPE
  
#   if ! _veilLsDeps; then
#     return 1
#   fi
  
#   if ! _veilLsSetupAliases; then
#     EXIT_CODE=1
#   fi
  
#   if ! _veilLsVerify; then
#     EXIT_CODE=1
#   fi

#   SYSTEM_TYPE=$(_veilLsDetectSystem)
#   if [[ $EXIT_CODE -eq 0 ]]; then
#     [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: module initialized ($SYSTEM_TYPE system)" >&2
#   fi
  
#   return $EXIT_CODE
# }

# # Автоинициализация с обработкой ошибок
# if [[ -z "$VEIL_CORE_LOADED" ]]; then
#   if ! veilLsInit; then
#     [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: critical - ls module failed to load" >&2
#   fi
# fi

if [[ -z "$VEIL_CORE_LOADED" ]]; then
  if ! initEnvironmentSettings; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/env: critical - module failed to load" >&2
  fi
fi