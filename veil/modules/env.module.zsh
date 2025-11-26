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
  
  # Locale
  export LANG='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
  
  # Development
  export NODE_ENV='development'
  export PYTHONSTARTUP="$HOME/.pythonrc"
  
  # Path
  export PATH="$HOME/.local/bin:$PATH"
  
  echo "Veil: environment module initialized"
}