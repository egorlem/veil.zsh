# Ultima Zsh Theme p3.c8 – https://github.com/egorlem/ultima.zsh-theme
#
# Yet Another Ultima
# 
# This project won't get you from point A to point B, but it will give you a 
# pleasant experience working in the terminal.
# ------------------------------------------------------------------------------
# License: WTFPL – https://github.com/egorlem/ultima.zsh-theme/blob/main/LICENSE
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Egor Lem <guezwhoz@gmail.com> / egorlem.com
#
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# INITIALIZATION
# ------------------------------------------------------------------------------

if [[ -n "$ULTIMA_THEME_LOADED" ]]; then
  return 0
fi

ULTIMA_THEME_LOADED=1

autoload -Uz add-zsh-hook

# ------------------------------------------------------------------------------
# CONSTANTS
# ------------------------------------------------------------------------------

# Box drawing characters for prompt design
BOX_L="┌"      # Limiter corner (starts top line)                Unicode: \u250c
BOX_P="└"      # Prompt corner (starts prompt line)              Unicode: \u2514
BOX_H="─"      # Horizontal line (fills top limiter)             Unicode: \u2500

SCI_RST="\x1b[0m"                                          #   SGR 0 - Reset all
SCI_BLACK="\x1b[0;30m"                                     # SGR 0;30 - black FG

VCS="${VCS:-git}"
ULTIMA_GIT_NO_UNTRACKED="${ULTIMA_GIT_NO_UNTRACKED:-0}"

# ------------------------------------------------------------------------------
# VCS SETUP FUNCTIONS
# ------------------------------------------------------------------------------

__ultimaSetupVCS() {
  # Validate VCS value
  if [[ "$VCS" != "git" && "$VCS" != "svn" && "$VCS" != "hg" ]]; then
    VCS=""
    return 1  # Invalid VCS
  fi

  # Define VCS variables
  local CHAR_BADGE="%F{0} on %f%F{0}›%f"
  local VC_BRANCH_NAME="%F{2}%b%f"
  local VC_ACTION="%F{0}%a %f%F{0}›%f"
  local VC_UNSTAGED_STATUS="%F{6} M ›%f"
  local VC_GIT_STAGED_STATUS="%F{2} A ›%f"
  local VC_GIT_HASH="%F{2}%6.6i%f %F{0}›%f"
  
  local CURRENT_VCS="\":vcs_info:*\" enable $VCS"

  if [[ $VCS != "" ]]; then
    autoload -Uz vcs_info || return 1
    eval zstyle $CURRENT_VCS
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
  fi

  case "$VCS" in 
    "git")
      if [[ "$ULTIMA_GIT_NO_UNTRACKED" != "1" ]]; then
        zstyle ':vcs_info:git*+set-message:*' hooks useGitUntracked
      fi
      zstyle ':vcs_info:git:*' stagedstr $VC_GIT_STAGED_STATUS
      zstyle ':vcs_info:git:*' unstagedstr $VC_UNSTAGED_STATUS
      zstyle ':vcs_info:git:*' actionformats "  ${VC_ACTION} ${VC_GIT_HASH}%m%u%c${CHAR_BADGE} ${VC_BRANCH_NAME}"
      zstyle ':vcs_info:git:*' formats " %c%u%m${CHAR_BADGE} ${VC_BRANCH_NAME}"
      ;;
    "svn")
      zstyle ':vcs_info:svn:*' branchformat "%b"
      zstyle ':vcs_info:svn:*' formats " ${CHAR_BADGE} ${VC_BRANCH_NAME}"
      ;;
    "hg")
      zstyle ':vcs_info:hg:*' branchformat "%b"
      zstyle ':vcs_info:hg:*' formats " ${CHAR_BADGE} ${VC_BRANCH_NAME}"
      ;;
    *)
      # Should not happen due to validation above
      return 1
      ;;
  esac

  return 0
}

# ------------------------------------------------------------------------------
# GIT HOOK FUNCTIONS
# ------------------------------------------------------------------------------

+vi-useGitUntracked() {
  local VC_GIT_UNTRACKED_STATUS="%F{4} U ›%f"

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if git status --porcelain=v1 2>/dev/null | grep -q "^??"; then
      hook_com[misc]=$VC_GIT_UNTRACKED_STATUS
      return 0
    fi
  fi

  hook_com[misc]=""
  return 1
}

# ------------------------------------------------------------------------------
# PROMPT HELPER FUNCTIONS
# ------------------------------------------------------------------------------

# SSH marker - shows "SSH:" when connected via SSH
# Returns: 0 if SSH connected, 1 otherwise
__u_ssh() {
  if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
    echo "%F{2}SSH%f%F{0}:%f"
    return 0
  fi
  return 1
}

# VCS status line - displays git/svn/hg information
# Returns: 0 if VCS enabled, 1 if disabled
__u_vcs() {
  if [[ -n "$VCS" ]]; then
    echo '${vcs_info_msg_0_}'
    return 0
  fi
  return 1
}

# Draws the horizontal line separator at the top of each prompt
# Returns: always 0 (should not fail)
__ultimaPrintPsOneLimiter() {
  local termwidth spacing="" i
  (( termwidth = COLUMNS - 1 ))

  for (( i = 1; i <= termwidth; i++ )); do
    spacing+=$BOX_H
  done

  echo "${SCI_BLACK}${BOX_L}${spacing}${SCI_RST}"
  return 0
}

# ------------------------------------------------------------------------------
# PROMPT DEFINITION
# ------------------------------------------------------------------------------

setopt PROMPT_SUBST

PROMPT="%F{0}${BOX_P} $(__u_ssh) %f%F{6}%~%f$(__u_vcs)
%F{2} ›%f "

RPROMPT=""

PS2="%F{0} %_ %f%F{6}› "
PS3=" › "

# ------------------------------------------------------------------------------
# HOOKS FUNCTIONS
# ------------------------------------------------------------------------------

# Called before each prompt display
# Updates VCS info and draws the top separator line
# Returns: 0 on success, 1 if vcs_info fails
__ultimaPrecmd() {
  if [[ $VCS != "" ]]; then
    vcs_info || return 1
  fi
  __ultimaPrintPsOneLimiter
  return 0
}

# Sets up zsh hooks for prompt functionality
# Returns: 0 on success, 1 if hook setup fails
__ultimaSetupHooks() {
  add-zsh-hook precmd __ultimaPrecmd || return 1
  return 0
}

# ------------------------------------------------------------------------------
# MAIN EXECUTION
# ------------------------------------------------------------------------------

# Initialize VCS
__ultimaSetupVCS

# Setup hooks
__ultimaSetupHooks

# Cleanup setup functions (no longer needed after execution)
unset __ultimaSetupVCS __ultimaSetupHooks