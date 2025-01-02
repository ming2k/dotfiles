#!/bin/sh
# Check dependencies
if ! command -v yq > /dev/null 2>&1; then
    echo "Please install yq first"
    exit 1
fi

# Get script directory (POSIX compatible)
SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
BACKUP_ROOT="$SCRIPT_DIR/backup"

# Read configuration file
CONFIG_FILE="$SCRIPT_DIR/backup_list.toml"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Set fixed backup directory
if [ ! -d "$BACKUP_ROOT" ]; then
    echo "Backup directory does not exist: $BACKUP_ROOT"
    exit 1
fi

# Create random temp directory for current config backup
RANDOM_STR=$(head -c 16 /dev/urandom | od -An -tx4 | tr -d ' ')
TEMP_BACKUP="/tmp/dotfiles_backup_$RANDOM_STR"
mkdir -p "$TEMP_BACKUP"
echo "Backing up current configurations to: $TEMP_BACKUP"

# Process each configuration
tomlq -r '.configs | keys[]' "$CONFIG_FILE" | while read -r config_key; do
    # Get values for each config
    source=$(tomlq -r ".configs.$config_key.source" "$CONFIG_FILE" | envsubst)
    backup=$(tomlq -r ".configs.$config_key.backup" "$CONFIG_FILE")
    enabled=$(tomlq -r ".configs.$config_key.enabled" "$CONFIG_FILE")
    
    # Check if enabled
    if [ "$enabled" = "true" ]; then
        backup_path="$BACKUP_ROOT/$backup"
        if [ -e "$backup_path" ]; then
            # Backup current config if it exists
            if [ -e "$source" ]; then
                echo "Backing up current config: $source -> $TEMP_BACKUP/$backup"
                mkdir -p "$(dirname "$TEMP_BACKUP/$backup")"
                cp -r "$source" "$TEMP_BACKUP/$backup"
                
                # Remove current config
                echo "Removing current config: $source"
                rm -rf "$source"
            fi
            
            # Create parent directory and restore from backup
            source_dir=$(dirname "$source")
            mkdir -p "$source_dir"
            
            echo "Restoring $config_key: $backup_path -> $source"
            cp -r "$backup_path" "$source"
        else
            echo "Warning: Backup does not exist: $backup_path"
        fi
    fi
done

echo "Original configurations backed up to: $TEMP_BACKUP"
echo "Restoration completed!"