#!/bin/bash

# Dotfiles Sync Script
# Manages syncing configurations between system and repository

set -e  # Exit on error

# Script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/sync_config.toml"
BACKUP_DIR="${SCRIPT_DIR}/backups"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_header() { echo -e "${BOLD}${CYAN}$1${NC}"; }

# Function to show usage
show_usage() {
    print_header "🏠 Dotfiles Sync Tool"
    echo
    echo -e "${BOLD}USAGE:${NC}"
    echo "    $0 <command> [options] [configs...]"
    echo
    echo -e "${BOLD}COMMANDS:${NC}"
    echo -e "    ${GREEN}install${NC} [configs...]     📥 Install configurations from repo to system"
    echo -e "    ${GREEN}backup${NC} [configs...]      📤 Backup system configurations to repo"
    echo -e "    ${GREEN}list${NC}                     📋 List all available configurations"
    echo -e "    ${GREEN}status${NC} [configs...]      📊 Show status of configurations"
    echo -e "    ${GREEN}help${NC}                     ❓ Show this help message"
    echo
    echo -e "${BOLD}OPTIONS:${NC}"
    echo -e "    ${YELLOW}--dry-run${NC}               🔍 Show what would be done without executing"
    echo -e "    ${YELLOW}--force${NC}                 💪 Overwrite existing files without prompting"
    echo -e "    ${YELLOW}--exclude-personal${NC}      🔒 Skip files that might contain personal info"
    echo
    echo -e "${BOLD}EXAMPLES:${NC}"
    echo "    $0 install                    # Install all enabled configurations"
    echo "    $0 install sway waybar        # Install only sway and waybar"
    echo "    $0 backup --dry-run          # Show what would be backed up"
    echo "    $0 list                      # List available configurations"
    echo "    $0 status                    # Check status of all configurations"
    echo
    echo -e "${BOLD}QUICK START:${NC}"
    echo -e "    1. List available configs:    ${CYAN}./sync.sh list${NC}"
    echo -e "    2. Install what you need:     ${CYAN}./sync.sh install sway waybar tmux${NC}"
    echo -e "    3. Check if it worked:        ${CYAN}./sync.sh status${NC}"
    echo
    echo -e "${BOLD}CONFIGURATION:${NC}"
    echo -e "    Edit ${CYAN}sync_config.toml${NC} to customize sync behavior and add/remove configs."
}

# Function to parse TOML (simplified but more robust)
parse_config() {
    local section=""
    local config_name=""
    
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        
        # Section headers
        if [[ "$line" =~ ^\[([^]]+)\] ]]; then
            section="${BASH_REMATCH[1]}"
            if [[ "$section" =~ ^configs\.(.+)$ ]]; then
                config_name="${BASH_REMATCH[1]}"
            fi
            continue
        fi
        
        # Config properties
        if [[ -n "$config_name" && "$section" =~ ^configs\. ]]; then
            if [[ "$line" =~ ^([^=]+)=[[:space:]]*\"?([^\"]+)\"?[[:space:]]*$ ]]; then
                local key="${BASH_REMATCH[1]// /}"
                local value="${BASH_REMATCH[2]}"
                
                case "$key" in
                    "source") eval "CONFIG_${config_name}_SOURCE=\"$value\"" ;;
                    "dest") eval "CONFIG_${config_name}_DEST=\"$value\"" ;;
                    "name") eval "CONFIG_${config_name}_NAME=\"$value\"" ;;
                    "enabled") eval "CONFIG_${config_name}_ENABLED=\"$value\"" ;;
                    "backup_only") eval "CONFIG_${config_name}_BACKUP_ONLY=\"$value\"" ;;
                esac
            fi
        fi
    done < "$CONFIG_FILE"
}

# Function to get exclusion patterns
get_exclusions() {
    local config_name="$1"
    local exclusions=""
    
    # Global exclusions - more comprehensive
    exclusions="--exclude=*.log --exclude=*.cache --exclude=.git/ --exclude=.svn/"
    exclusions="$exclusions --exclude=node_modules/ --exclude=__pycache__/ --exclude=*.pyc"
    exclusions="$exclusions --exclude=.DS_Store --exclude=Thumbs.db --exclude=*.tmp"
    exclusions="$exclusions --exclude=lazy-lock.json --exclude=.luarc.json"
    exclusions="$exclusions --exclude=mason/ --exclude=.repro/ --exclude=*.sock"
    
    echo "$exclusions"
}

# Function to sanitize files (remove personal info)
sanitize_file() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    # Only sanitize specific file types
    case "$file" in
        *.lua|*.sh|*.conf|*.config|*.toml|*.css|*.js)
            # Replace email addresses with placeholder
            sed 's/[a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]*\.[a-zA-Z]{2,}/USER@DOMAIN.COM/g' "$file" > "$temp_file"
            
            # Replace hardcoded home paths
            sed "s|/home/[^/]*/|/home/USER/|g" "$temp_file" > "$file"
            
            # Replace GitHub usernames in URLs
            sed 's|github.com/[a-zA-Z0-9_-]*/|github.com/USERNAME/|g' "$file" > "$temp_file"
            
            mv "$temp_file" "$file"
            ;;
    esac
}

# Function to list available configurations
list_configs() {
    print_header "📋 Available Configurations"
    echo
    
    parse_config
    
    local configs=($(compgen -v | grep "^CONFIG_.*_NAME$" | sed 's/CONFIG_//;s/_NAME$//'))
    
    if [[ ${#configs[@]} -eq 0 ]]; then
        print_warning "No configurations found in sync_config.toml"
        return
    fi
    
    # Sort configs alphabetically
    IFS=$'\n' configs=($(sort <<<"${configs[*]}"))
    unset IFS
    
    for config in "${configs[@]}"; do
        display_config_info "$config" ""
    done
}

# Helper function to display config info
display_config_info() {
    local config="$1"
    local prefix="$2"
    
    local name_var="CONFIG_${config}_NAME"
    local enabled_var="CONFIG_${config}_ENABLED"
    local dest_var="CONFIG_${config}_DEST"
    local backup_only_var="CONFIG_${config}_BACKUP_ONLY"
    
    local name="${!name_var:-$config}"
    local enabled="${!enabled_var:-false}"
    local dest="${!dest_var:-unknown}"
    local backup_only="${!backup_only_var:-false}"
    
    local status_icon="✓"
    local status_color="${GREEN}"
    local backup_suffix=""
    
    if [[ "$enabled" != "true" ]]; then
        status_icon="✗"
        status_color="${YELLOW}"
    fi
    
    if [[ "$backup_only" == "true" ]]; then
        backup_suffix="${YELLOW} (backup only)${NC}"
    fi
    
    printf "${prefix}${status_color}${status_icon}${NC} %-15s ${CYAN}%s${NC}${backup_suffix}\n" "$config" "$name"
}

# Function to install configurations with progress
install_configs() {
    local configs=("$@")
    local dry_run=false
    local force=false
    
    # Parse options
    local filtered_configs=()
    for arg in "${configs[@]}"; do
        case "$arg" in
            --dry-run) dry_run=true ;;
            --force) force=true ;;
            *) filtered_configs+=("$arg") ;;
        esac
    done
    configs=("${filtered_configs[@]}")
    
    parse_config
    
    # If no configs specified, install all enabled ones (excluding backup-only)
    if [[ ${#configs[@]} -eq 0 ]]; then
        local all_configs=($(compgen -v | grep "^CONFIG_.*_ENABLED$" | sed 's/CONFIG_//;s/_ENABLED$//'))
        for config in "${all_configs[@]}"; do
            local enabled_var="CONFIG_${config}_ENABLED"
            local backup_only_var="CONFIG_${config}_BACKUP_ONLY"
            if [[ "${!enabled_var}" == "true" && "${!backup_only_var}" != "true" ]]; then
                configs+=("$config")
            fi
        done
    fi
    
    if [[ ${#configs[@]} -eq 0 ]]; then
        print_warning "No configurations found to install. Use './sync.sh list' to see available configs."
        return
    fi
    
    if [[ "$dry_run" == "true" ]]; then
        print_header "🔍 Dry Run - Installation Preview"
    else
        print_header "📥 Installing Configurations"
    fi
    echo
    
    local success_count=0
    local total_count=${#configs[@]}
    
    for config in "${configs[@]}"; do
        local source_var="CONFIG_${config}_SOURCE"
        local dest_var="CONFIG_${config}_DEST"
        local name_var="CONFIG_${config}_NAME"
        local backup_only_var="CONFIG_${config}_BACKUP_ONLY"
        
        local source="${!source_var}"
        local dest="${!dest_var}"
        local name="${!name_var:-$config}"
        local backup_only="${!backup_only_var}"
        
        if [[ -z "$source" || -z "$dest" ]]; then
            print_error "Unknown configuration: $config"
            continue
        fi
        
        # Skip backup-only configurations during install
        if [[ "$backup_only" == "true" ]]; then
            print_warning "Skipping $name (backup-only configuration)"
            continue
        fi
        
        # Expand variables
        source="${source/\$HOME/$HOME}"
        local repo_path="${SCRIPT_DIR}/configs/${dest}"
        
        print_info "Processing ${CYAN}$name${NC} ($config)"
        
        if [[ ! -d "$repo_path" ]]; then
            print_warning "  Repository config not found: $repo_path"
            continue
        fi
        
        if [[ "$dry_run" == "true" ]]; then
            echo "    📁 Would copy: $repo_path → $source"
            success_count=$((success_count + 1))
            continue
        fi
        
        # Create parent directory
        mkdir -p "$(dirname "$source")"
        
        # Copy files with progress
        local exclusions=$(get_exclusions "$config")
        if rsync -av $exclusions "$repo_path/" "$source/" > /dev/null 2>&1; then
            print_success "  Installed ${GREEN}$name${NC}"
            success_count=$((success_count + 1))
        else
            print_error "  Failed to install $name"
        fi
    done
    
    echo
    if [[ "$dry_run" == "true" ]]; then
        print_info "Dry run complete. ${success_count}/${total_count} configurations would be installed."
    else
        print_success "Installation complete! ${success_count}/${total_count} configurations installed successfully."
        if [[ $success_count -gt 0 ]]; then
            echo
            print_info "💡 Tip: Use './sync.sh status' to verify the installation."
        fi
    fi
}

# Function to backup configurations with progress
backup_configs() {
    local configs=("$@")
    local dry_run=false
    local exclude_personal=false
    
    # Parse options
    local filtered_configs=()
    for arg in "${configs[@]}"; do
        case "$arg" in
            --dry-run) dry_run=true ;;
            --exclude-personal) exclude_personal=true ;;
            *) filtered_configs+=("$arg") ;;
        esac
    done
    configs=("${filtered_configs[@]}")
    
    parse_config
    
    # If no configs specified, backup all enabled ones
    if [[ ${#configs[@]} -eq 0 ]]; then
        local all_configs=($(compgen -v | grep "^CONFIG_.*_ENABLED$" | sed 's/CONFIG_//;s/_ENABLED$//'))
        for config in "${all_configs[@]}"; do
            local enabled_var="CONFIG_${config}_ENABLED"
            [[ "${!enabled_var}" == "true" ]] && configs+=("$config")
        done
    fi
    
    if [[ ${#configs[@]} -eq 0 ]]; then
        print_warning "No configurations found to backup. Use './sync.sh list' to see available configs."
        return
    fi
    
    if [[ "$dry_run" == "true" ]]; then
        print_header "🔍 Dry Run - Backup Preview"
    else
        print_header "📤 Backing Up Configurations"
    fi
    echo
    
    local success_count=0
    local total_count=${#configs[@]}
    
    for config in "${configs[@]}"; do
        local source_var="CONFIG_${config}_SOURCE"
        local dest_var="CONFIG_${config}_DEST" 
        local name_var="CONFIG_${config}_NAME"
        
        local source="${!source_var}"
        local dest="${!dest_var}"
        local name="${!name_var:-$config}"
        
        if [[ -z "$source" || -z "$dest" ]]; then
            print_error "Unknown configuration: $config"
            continue
        fi
        
        # Expand variables
        source="${source/\$HOME/$HOME}"
        local repo_path="${SCRIPT_DIR}/configs/${dest}"
        
        print_info "Processing ${CYAN}$name${NC} ($config)"
        
        if [[ ! -e "$source" ]]; then
            print_warning "  System config not found: $source"
            continue
        fi
        
        if [[ "$dry_run" == "true" ]]; then
            echo "    📁 Would copy: $source → $repo_path"
            success_count=$((success_count + 1))
            continue
        fi
        
        # Create destination directory
        mkdir -p "$(dirname "$repo_path")"
        
        # Copy files
        local exclusions=$(get_exclusions "$config")
        
        if [[ -d "$source" ]]; then
            mkdir -p "$repo_path"
            if rsync -av --delete $exclusions "$source/" "$repo_path/" > /dev/null 2>&1; then
                success=true
            else
                success=false
            fi
        else
            if rsync -av $exclusions "$source" "$repo_path" > /dev/null 2>&1; then
                success=true
            else
                success=false
            fi
        fi
        
        if [[ "$success" == "true" ]]; then
            # Sanitize files if requested
            if [[ "$exclude_personal" == "true" ]]; then
                print_info "  🔒 Sanitizing personal information..."
                find "$repo_path" -type f | while read file; do
                    sanitize_file "$file"
                done
            fi
            
            print_success "  Backed up ${GREEN}$name${NC}"
            success_count=$((success_count + 1))
        else
            print_error "  Failed to backup $name"
        fi
    done
    
    echo
    if [[ "$dry_run" == "true" ]]; then
        print_info "Dry run complete. ${success_count}/${total_count} configurations would be backed up."
    else
        print_success "Backup complete! ${success_count}/${total_count} configurations backed up successfully."
    fi
}

# Function to show configuration status with better formatting
show_status() {
    local configs=("$@")
    
    parse_config
    
    # If no configs specified, show all
    if [[ ${#configs[@]} -eq 0 ]]; then
        configs=($(compgen -v | grep "^CONFIG_.*_NAME$" | sed 's/CONFIG_//;s/_NAME$//'))
    fi
    
    print_header "📊 Configuration Status"
    echo
    
    for config in "${configs[@]}"; do
        local source_var="CONFIG_${config}_SOURCE"
        local dest_var="CONFIG_${config}_DEST"
        local name_var="CONFIG_${config}_NAME"
        
        local source="${!source_var}"
        local dest="${!dest_var}"
        local name="${!name_var:-$config}"
        
        if [[ -z "$source" || -z "$dest" ]]; then
            print_error "Unknown configuration: $config"
            continue
        fi
        
        source="${source/\$HOME/$HOME}"
        local repo_path="${SCRIPT_DIR}/configs/${dest}"
        
        echo -e "${BOLD}${CYAN}$name${NC} ($config)"
        
        # System status
        if [[ -e "$source" ]]; then
            echo -e "  💻 System:     $source ${GREEN}[EXISTS]${NC}"
        else
            echo -e "  💻 System:     $source ${YELLOW}[MISSING]${NC}"
        fi
        
        # Repository status
        if [[ -e "$repo_path" ]]; then
            echo -e "  📁 Repository: $repo_path ${GREEN}[EXISTS]${NC}"
        else
            echo -e "  📁 Repository: $repo_path ${YELLOW}[MISSING]${NC}"
        fi
        
        echo
    done
}

# Main script logic
main() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_error "Configuration file not found: $CONFIG_FILE"
        exit 1
    fi
    
    case "${1:-help}" in
        "install")
            shift
            install_configs "$@"
            ;;
        "backup")
            shift
            backup_configs "$@"
            ;;
        "list")
            list_configs
            ;;
        "status")
            shift
            show_status "$@"
            ;;
        "help"|"--help"|"-h"|"")
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            echo
            show_usage
            exit 1
            ;;
    esac
}

main "$@"