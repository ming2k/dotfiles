#!/bin/sh

# Script to backup dotfiles based on the backup_list.toml configuration
# The backups will be stored in the 'assets' directory relative to this script

set -e  # Exit on error

# Get the directory where this script is located (POSIX compatible)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Define the assets directory
ASSETS_DIR="${SCRIPT_DIR}/assets"
# Define the path to the TOML configuration file
CONFIG_FILE="${SCRIPT_DIR}/backup_list.toml"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}Error: Configuration file not found at ${CONFIG_FILE}${NC}"
    exit 1
fi

# Create the assets directory if it doesn't exist
mkdir -p "$ASSETS_DIR"
echo -e "${GREEN}Assets directory: ${ASSETS_DIR}${NC}"

# Function to clear previous backup content
clear_previous_backup() {
    local config_name="$1"
    local dest_path="$2"
    local target_dir="${ASSETS_DIR}/${dest_path}"
    
    if [ -e "$target_dir" ]; then
        echo -e "${YELLOW}  Clearing previous backup for ${config_name}...${NC}"
        rm -rf "$target_dir"
    fi
    
    # Recreate the empty directory
    mkdir -p "$target_dir"
}

# Parse TOML and extract configurations
# We'll use a simple parsing approach since the TOML structure is straightforward
parse_configs() {
    local in_config=false
    local current_config=""
    local source=""
    local dest=""
    local enabled=""
    
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^#.*$ ]] || [[ -z "${line// }" ]]; then
            continue
        fi
        
        # Check if this is a config section
        if [[ "$line" =~ ^\[configs\.([a-zA-Z0-9_]+)\]$ ]]; then
            in_config=true
            current_config="${BASH_REMATCH[1]}"
            source=""
            dest=""
            enabled=""
            continue
        fi
        
        # Extract properties if we're in a config section
        if [ "$in_config" = true ]; then
            # Extract source
            if [[ "$line" =~ ^source[[:space:]]*=[[:space:]]*\"(.*)\"$ ]]; then
                source="${BASH_REMATCH[1]}"
                # Replace $HOME with the actual home directory
                source="${source/\$HOME/$HOME}"
                continue
            fi
            
            # Extract destination
            if [[ "$line" =~ ^dest[[:space:]]*=[[:space:]]*\"(.*)\"$ ]]; then
                dest="${BASH_REMATCH[1]}"
                continue
            fi
            
            # Extract enabled status
            if [[ "$line" =~ ^enabled[[:space:]]*=[[:space:]]*(true|false)$ ]]; then
                enabled="${BASH_REMATCH[1]}"
                
                # If we have all the required properties, process this config
                if [ -n "$source" ] && [ -n "$dest" ] && [ "$enabled" = "true" ]; then
                    backup_config "$current_config" "$source" "$dest"
                fi
                
                # Reset for the next config
                in_config=false
                continue
            fi
        fi
    done < "$CONFIG_FILE"
}

# Function to backup a specific configuration
backup_config() {
    local config_name="$1"
    local source_path="$2"
    local dest_path="$3"
    local target_dir="${ASSETS_DIR}/${dest_path}"
    
    echo -e "${YELLOW}Processing ${config_name}...${NC}"
    
    # Check if source exists
    if [ ! -e "$source_path" ]; then
        echo -e "${RED}  Source does not exist: ${source_path}${NC}"
        return
    fi
    
    # Clear previous backup and recreate target directory
    clear_previous_backup "$config_name" "$dest_path"
    
    # Use rsync to copy files, preserving permissions
    if [ -d "$source_path" ]; then
        # Directory: copy contents recursively
        rsync -a --delete "$source_path/" "$target_dir/"
        echo -e "${GREEN}  Directory backed up: ${source_path} -> ${target_dir}${NC}"
    else
        # File: copy the file
        rsync -a "$source_path" "$target_dir/"
        echo -e "${GREEN}  File backed up: ${source_path} -> ${target_dir}${NC}"
    fi
}

# Main execution
echo -e "${GREEN}Starting dotfiles backup...${NC}"
parse_configs
echo -e "${GREEN}Backup complete!${NC}"
