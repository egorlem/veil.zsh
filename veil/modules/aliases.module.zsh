# Veil Completion Module
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

initAliasesSettings() {

  # alias rm='rm -i'
  # alias cp='cp -i'
  # alias mv='mv -i'
  
  # # Git shortcuts
  # alias gs='git status'
  # alias ga='git add'
  # alias gc='git commit'
  # alias gd='git diff'
  # alias gl='git log --oneline --graph'
    
  # # Network
  # alias ip='curl -s ifconfig.me'
  # alias localip='ipconfig getifaddr en0'
  # alias ping='ping -c 5'
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
  if ! initAliasesSettings; then
    [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/aliases: critical - module failed to load" >&2
  fi
fi

