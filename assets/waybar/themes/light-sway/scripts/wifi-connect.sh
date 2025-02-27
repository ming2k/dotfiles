#!/bin/bash
# Enable strict mode for better error handling
set -euo pipefail
IFS=$'\n\t'

# Function to check if iwd service is running using pgrep
check_iwd() {
    if ! pgrep -x "iwd" >/dev/null; then
        notify-send "WiFi Error" "IWD service is not running. Please start the service." -i dialog-error -u critical
        exit 1
    fi
}

# Function to get device name
get_device() {
    device=$(iwctl device list | grep -Eo "wlan[0-9]+" | head -n1)
    if [ -z "$device" ]; then
        notify-send "WiFi Error" "No wireless device found." -i dialog-error -u critical
        exit 1
    fi
    echo "$device"
}

# Function to check if WiFi is enabled
check_wifi_enabled() {
    local device="$1"
    
    if ! rfkill list wifi | grep -q "Soft blocked: no"; then
        notify-send "WiFi" "WiFi is disabled. Attempting to enable..." -i dialog-warning
        rfkill unblock wifi
        sleep 2
        if ! rfkill list wifi | grep -q "Soft blocked: no"; then
            notify-send "WiFi Error" "Failed to enable WiFi. Please check hardware switch." -i dialog-error -u critical
            exit 1
        fi
        notify-send "WiFi" "WiFi has been enabled successfully." -i dialog-information
    fi
}

# Function to check current connection
check_connection() {
    local device="$1"
    local state
    state=$(iwctl station "$device" show | grep -i "State" | sed 's/\x1B\[[0-9;]*m//; s/^ *//' | awk '{print $2}')
    if [ "$state" = "connected" ]; then
        local network_name
        network_name=$(iwctl station "$device" show | grep -i "Connected network" | sed 's/\x1B\[[0-9;]*m//; s/^ *//' | awk '{print $3}')
        notify-send "WiFi" "Already connected to network: $network_name" -i dialog-information
        return 0
    fi
    return 1
}

# Function to scan networks
scan_networks() {
    local device="$1"
    local scanning
    
    notify-send "WiFi" "Scanning for available networks..." -i dialog-information
    scanning=$(iwctl station "$device" show | sed 's/\x1B\[[0-9;]*m//; s/^ *//' | grep -i "Scanning" | awk '{print $2}')
    
    if [ "$scanning" = "no" ]; then
        iwctl station "$device" scan
        sleep 5
    fi
}

# Function to auto-connect to known networks
auto_connect() {
    local device="$1"
    local known_networks available_networks network
    
    # Retrieve known networks and store them in an array
    readarray -t known_networks < <(
        iwctl known-networks list | tail -n +5 | \
        sed 's/\x1B\[[0-9;]*m//; s/^ *//' | \
        awk -F '    +' '{print $1}'
    )
    
    if [ ${#known_networks[@]} -eq 0 ]; then
        notify-send "WiFi" "No known networks found." -i dialog-warning
        return 1
    fi
    
    # Retrieve available networks and store them in an array
    readarray -t available_networks < <(
        iwctl station "$device" get-networks | tail -n +5 | \
        sed -r 's/\x1B\[[0-9;]*m//g' | \
        sed 's/^ *//; s/^> *//' | \
        awk -F '    +' '{print $1}'
    )
    
    if [ ${#available_networks[@]} -eq 0 ]; then
        notify-send "WiFi" "No networks available in range." -i dialog-warning
        return 1
    fi
    
    # Iterate over known networks and attempt to connect to the first available one
    for network in "${known_networks[@]}"; do
        if printf "%s\n" "${available_networks[@]}" | grep -Fxq "$network"; then
            notify-send "WiFi" "Attempting to connect to '$network'..." -i dialog-information
            if iwctl station "$device" connect "$network"; then
                notify-send "WiFi" "Successfully connected to '$network'." -i dialog-information
                return 0
            else
                notify-send "WiFi Error" "Failed to connect to '$network'." -i dialog-error -u critical
            fi
        fi
    done
    
    notify-send "WiFi" "No known networks available to connect." -i dialog-warning
    return 1
}

# Main execution function
main() {
    check_iwd
    device=$(get_device)
    
    # Check if already connected
    if check_connection "$device"; then
        exit 0
    fi
    
    # Check if WiFi is enabled, if not, enable it
    check_wifi_enabled "$device"
    
    # Scan for networks
    scan_networks "$device"
    
    # Try to auto-connect to known networks
    auto_connect "$device"
}

# Execute main function
main
