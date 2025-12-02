# Veil Keybindings Module
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

initKeybindingsSettings() {
  # bindkey '^[[A' history-substring-search-up    # стрелка вверх - поиск по истории
  # bindkey '^[[B' history-substring-search-down  # стрелка вниз - поиск по истории
  
  # bindkey '^[OH' beginning-of-line              # Home - в начало строки
  # bindkey '^[OF' end-of-line                    # End - в конец строки
  
  bindkey '^[[3~' delete-char                   # Del - удалить символ
  bindkey '^H' backward-kill-word               # Ctrl+Backspace - удалить слово
  
  # Умное автодополнение с Tab
  bindkey '^I' complete-word
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
#   else
#     [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/ls: module initialized with warnings ($SYSTEM_TYPE system)" >&2
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
  if ! initKeybindingsSettings; then
     [[ -n "$VEIL_MODULES_VERBOSE" ]] && echo "veil/keybindings: critical - keybindings module failed to load" >&2
  fi
fi