# Veil Navigation Module
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

_veilNavigationSetupOptions() {
  # Настройка опций навигации
  setopt AUTO_CD           # cd без ввода cd
  setopt AUTO_PUSHD        # автоматически пушить директории в стек
  setopt PUSHD_IGNORE_DUPS # не пушить дубликаты в стек
  setopt PUSHD_SILENT      # не выводить стек при pushd/popd
  
  return 0
}

_veilNavigationSetupAliases() {
  # Настройка алиасов для навигации
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
  alias .....='cd ../../../..'
  
  alias d='dirs -v'        # показать стек директорий
  alias 1='cd -'
  alias 2='cd -2'
  alias 3='cd -3'
  
  # Быстрый переход в частые директории (опционально)
  if [[ -d "$HOME/Development" ]]; then
    alias dev='cd ~/Development'
  fi
  
  if [[ -d "$HOME/Documents" ]]; then
    alias docs='cd ~/Documents'
  fi
  
  if [[ -d "$HOME/Downloads" ]]; then
    alias down='cd ~/Downloads'
  fi
  
  return 0
}

_veilNavigationVerify() {
  # Проверка что алиасы установились
  if ! alias .. >/dev/null 2>&1; then
    echo "veil/navigation: error - failed to create navigation aliases" >&2
    return 1
  fi
  
  if ! alias d >/dev/null 2>&1; then
    echo "veil/navigation: error - failed to create dirs alias" >&2
    return 1
  fi
  
  return 0
}

veilNavigationInit() {
  # Основная функция инициализации
  local EXIT_CODE=0
  
  if ! _veilNavigationSetupOptions; then
    EXIT_CODE=1
  fi
  
  if ! _veilNavigationSetupAliases; then
    EXIT_CODE=1
  fi
  
  if ! _veilNavigationVerify; then
    EXIT_CODE=1
  fi
  
  if [[ $EXIT_CODE -eq 0 ]]; then
    echo "veil/navigation: navigation module initialized"
  else
    echo "veil/navigation: navigation module initialized with warnings" >&2
  fi
  
  return $EXIT_CODE
}

# Автоинициализация с обработкой ошибок
if [[ -z "$ULTIMA_CORE_LOADED" ]]; then
  if ! veilNavigationInit; then
    echo "veil/navigation: critical - navigation module failed to load" >&2
  fi
fi