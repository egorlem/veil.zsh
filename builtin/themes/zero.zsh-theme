# zero.zsh-theme
# Simple test theme for veil

setopt PROMPT_SUBST

exit_status() {
    if [[ $? -eq 0 ]]; then
        echo "%F{2}.%f"
    else
        echo "%F{1}.%f"
    fi
}

current_dir() {
    echo "%F{4}%~%f"
}

PROMPT='%F{4}%~%f %F{2}›%f '
RPROMPT='$(exit_status)'

PS2="%F{3}... %f"