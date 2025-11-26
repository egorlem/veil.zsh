#!/usr/bin/env zsh

# 1. CLEAR VULNERABILITY - Command injection
vulnerableEval() {
    local user_command=$1
    result=$(eval "$user_command")  
    echo "$result"
}

# 2. CLEAR VULNERABILITY - Path traversal  
vulnerableSource() {
    local user_file=$1
    source "$user_file"  
}

# 3. CLEAR VULNERABILITY - Remote execution
vulnerableDownload() {
    local script_url=$1
    # Явно опасный паттерн:
    sh -c "$(curl -fsSL $script_url)"  
}

# 4. UNSAFE variable in command
vulnerableCommand() {
    local dir_name=$1
    rm -rf "/tmp/$dir_name"  
}