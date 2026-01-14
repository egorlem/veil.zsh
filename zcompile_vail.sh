#!/bin/zsh

# ==============================================================================
# Veil ZSH Compiler
#
# Recursive ZSH file compiler with smart caching and exclusions.
# Automatically compiles .zsh and .zsh-theme files for faster loading.
#
# Features:
#   - Smart recompilation (only if source changed)
#   - Recursive dependency compilation (-R flag)
#   - Excludes test directories by default
#   - Clean and informative output
#
# This script was partially generated with AI assistance.
# AI assistance provided by DeepSeek for optimization and documentation.
#
# ------------------------------------------------------------------------------
# Usage
# -----
#
#   ./zcompile.sh [directory] [mode]
#
# Modes:
#   compile    - Compile changed files (default)
#   force      - Force recompile all files
#   clean      - Remove all .zwc files
#   stats      - Show compilation statistics
#
# Examples:
#   ./zcompile.sh                  # Compile current directory
#   ./zcompile.sh ~/.zsh force     # Force recompile
#   ./zcompile.sh . clean          # Clean current directory
#   ./zcompile.sh . stats          # Show stats
#
# ==============================================================================

# Simple symbols (no colors for better compatibility)
readonly CHECK="✓"
readonly CROSS="✗"
readonly ARROW="→"
readonly WARN="⚠"
readonly INFO="i"
readonly GEAR="⚙"
readonly TRASH="T"

# Print header
print_header() {
    echo ""
    echo "╭────────────────────────────────────────────────────────────╮"
    echo "│                    Veil ZSH Compiler                       │"
    echo "│         Intelligent ZSH bytecode compiler                  │"
    echo "╰────────────────────────────────────────────────────────────╯"
    echo ""
}

# Print footer with stats
print_footer() {
    local total=$1 compiled=$2 errors=$3 skipped=$4
    
    echo ""
    echo "──────────────────────────────────────────────────────────────"
    echo "                     Compilation Summary"
    echo "──────────────────────────────────────────────────────────────"
    
    if (( total > 0 )); then
        local percent=$(( (compiled * 100) / total ))
        echo "  $CHECK Success: $compiled files"
        echo "  $WARN Skipped: $skipped files"
        echo "  $CROSS Errors: $errors files"
        echo "  $INFO Total: $total files"
        echo "  $GEAR Progress: $percent% complete"
    else
        echo "  $WARN No ZSH files found to compile"
    fi
    
    echo "──────────────────────────────────────────────────────────────"
    echo ""
}

# Main compilation function
compile_zsh_files() {
    local dir="$1"
    local force="$2"
    
    if [[ ! -d "$dir" ]]; then
        echo "$CROSS Error: Directory '$dir' does not exist"
        return 1
    fi
    
    if [[ ! -w "$dir" ]]; then
        echo "$WARN Warning: No write permission in '$dir'"
        return 0
    fi
    
    echo "$ARROW Scanning: $dir"
    echo "──────────────────────────────────────────────────────────────"
    
    local total=0 compiled=0 errors=0 skipped=0
    
    # Switch to directory for relative paths
    cd "$dir" || return 1
    
    # Find all .zsh and .zsh-theme files
    for file in **/*.zsh(.) **/*.zsh-theme(.); do
        # Skip test directories
        [[ $file == */test/* ]] && continue
        
        ((total++))
        
        # Check if compilation is needed
        local zwc_file="${file}.zwc"
        local needs_compile=0
        
        if [[ $force == "force" ]] || [[ ! -f "$zwc_file" ]]; then
            needs_compile=1
        elif [[ "$file" -nt "$zwc_file" ]]; then
            needs_compile=1
        fi
        
        if (( needs_compile )); then
            # Compile with visual feedback
            printf "$GEAR Compiling: %-50s" "$file"
            
            if zcompile -R "$file" 2>/dev/null; then
                printf " $CHECK Done\n"
                ((compiled++))
            else
                printf " $CROSS Failed\n"
                ((errors++))
            fi
        else
            printf ">  Current: %-50s (up to date)\n" "$file"
            ((skipped++))
        fi
    done
    
    # Return to original directory
    cd - >/dev/null || return 1
    
    print_footer $total $compiled $errors $skipped
}

# Clean compiled files
clean_compiled_files() {
    local dir="$1"
    
    if [[ ! -d "$dir" ]]; then
        echo "$CROSS Error: Directory '$dir' does not exist"
        return 1
    fi
    
    echo "$TRASH Cleaning: $dir"
    echo "──────────────────────────────────────────────────────────────"
    
    local count=0
    
    find "$dir" -type f -name "*.zwc" | while read -r file; do
        local rel_path="${file#$dir/}"
        printf "$TRASH Removing: %-50s\n" "$rel_path"
        rm -f "$file" && ((count++))
    done
    
    echo ""
    echo "$CHECK Cleaned: $count compiled files removed"
    echo ""
}

# Show statistics
show_statistics() {
    local dir="$1"
    
    if [[ ! -d "$dir" ]]; then
        echo "$CROSS Error: Directory '$dir' does not exist"
        return 1
    fi
    
    echo "$INFO Statistics: $dir"
    echo "──────────────────────────────────────────────────────────────"
    
    local total_files=0 compiled_files=0 source_size=0 compiled_size=0
    
    # Count source files
    for file in "$dir"/**/*.zsh(.) "$dir"/**/*.zsh-theme(.); do
        [[ $file == */test/* ]] && continue
        ((total_files++))
        source_size=$((source_size + $(stat -f%z "$file" 2>/dev/null || echo 0)))
    done
    
    # Count compiled files
    for file in "$dir"/**/*.zwc(.); do
        [[ $file == */test/*.zwc ]] && continue
        ((compiled_files++))
        compiled_size=$((compiled_size + $(stat -f%z "$file" 2>/dev/null || echo 0)))
    done
    
    # Calculate ratios
    local ratio=0
    if (( compiled_size > 0 && source_size > 0 )); then
        ratio=$(( (compiled_size * 100) / source_size ))
    fi
    
    echo "  Source files:     $total_files"
    echo "  Compiled files:   $compiled_files"
    
    # Try to format sizes nicely
    if command -v numfmt >/dev/null 2>&1; then
        echo "  Source size:      $(numfmt --to=iec $source_size)"
        echo "  Compiled size:    $(numfmt --to=iec $compiled_size)"
    else
        echo "  Source size:      ${source_size} bytes"
        echo "  Compiled size:    ${compiled_size} bytes"
    fi
    
    if (( ratio > 0 )); then
        echo "  Compression:      ${ratio}% of original size"
    fi
    
    echo ""
    echo "Note: Compiled files load ~3-5x faster than source files"
    echo ""
}

# Show help
show_help() {
    echo "Veil ZSH Compiler - Usage"
    echo ""
    echo "Syntax:"
    echo "  ./zcompile.sh [directory] [mode]"
    echo ""
    echo "Modes:"
    echo "  compile    - Compile only changed files (default)"
    echo "  force      - Force recompile all files"
    echo "  clean      - Remove all compiled .zwc files"
    echo "  stats      - Show compilation statistics"
    echo "  help       - Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./zcompile.sh                     # Compile current directory"
    echo "  ./zcompile.sh ~/.zsh force        # Force recompile home config"
    echo "  ./zcompile.sh modules clean       # Clean modules directory"
    echo "  ./zcompile.sh . stats             # Show current directory stats"
    echo ""
    echo "──────────────────────────────────────────────────────────────"
    echo "Generated with AI assistance • Part of Veil ZSH Framework"
    echo ""
}

# Main function
main() {
    print_header
    
    local dir="${1:-.}"
    local mode="${2:-compile}"
    
    # Get absolute path
    dir=$(realpath -- "$dir" 2>/dev/null || echo "$dir")
    
    case "$mode" in
        compile|"")
            compile_zsh_files "$dir" ""
            ;;
        force)
            echo "$WARN Force mode enabled - recompiling all files"
            echo ""
            compile_zsh_files "$dir" "force"
            ;;
        clean)
            clean_compiled_files "$dir"
            ;;
        stats)
            show_statistics "$dir"
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            echo "$CROSS Unknown mode: $mode"
            echo "Use ./zcompile.sh help for usage information"
            echo ""
            return 1
            ;;
    esac
}

# Run main function
main "$@"