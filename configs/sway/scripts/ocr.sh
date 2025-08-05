#!/bin/bash

# High accuracy OCR script using Tesseract
# Optimized for Sway keybinding usage (Shift+Print)

set -e

TEMP_DIR="/tmp/ocr_$$"
mkdir -p "$TEMP_DIR"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

show_help() {
    echo "Usage: $0 [OPTIONS] [FILE]"
    echo ""
    echo "High accuracy OCR using Tesseract"
    echo ""
    echo "Options:"
    echo "  -s, --screenshot    Take screenshot and OCR selected region (default)"
    echo "  -c, --clipboard     Copy result to clipboard (default)"
    echo "  -l, --lang LANG     Language(s) for OCR (default: chi_sim+chi_tra+eng+jpn)"
    echo "  -p, --preprocess    Apply image preprocessing for better accuracy"
    echo "  -n, --notify        Show notification with result"
    echo "  -h, --help          Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                    # Screenshot OCR to clipboard (default behavior)"
    echo "  $0 -n                # Screenshot OCR to clipboard with notification"
    echo "  $0 -p image.png      # OCR file with preprocessing"
    echo "  $0 -l eng+fra file.pdf # OCR PDF with English and French"
}

# Default options (optimized for Sway keybinding)
SCREENSHOT=true
CLIPBOARD=true
LANG="chi_sim+chi_tra+eng+jpn"
PREPROCESS=false
NOTIFY=false
INPUT_FILE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--screenshot)
            SCREENSHOT=true
            shift
            ;;
        -c|--clipboard)
            CLIPBOARD=true
            shift
            ;;
        -l|--lang)
            LANG="$2"
            shift 2
            ;;
        -p|--preprocess)
            PREPROCESS=true
            shift
            ;;
        -n|--notify)
            NOTIFY=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            INPUT_FILE="$1"
            SCREENSHOT=false
            shift
            ;;
    esac
done

# Function to preprocess image for better OCR
preprocess_image() {
    local input="$1"
    local output="$2"
    
    # Apply image enhancements for better OCR accuracy
    convert "$input" \
        -colorspace Gray \
        -type Grayscale \
        -contrast-stretch 0 \
        -normalize \
        -despeckle \
        -enhance \
        -sharpen 0x1 \
        -density 300 \
        "$output"
}

# Function to perform OCR
do_ocr() {
    local input_file="$1"
    local processed_file="$TEMP_DIR/processed.png"
    
    if [[ "$PREPROCESS" == true ]]; then
        preprocess_image "$input_file" "$processed_file"
        input_file="$processed_file"
    fi
    
    # Use Tesseract with high accuracy settings
    tesseract "$input_file" stdout \
        -l "$LANG" \
        --psm 6 \
        --oem 3 \
        2>/dev/null
}

# Function to send notification
send_notification() {
    local text="$1"
    local max_length=100
    
    if command -v mako >/dev/null 2>&1; then
        # Truncate text for notification
        local truncated_text
        if [[ ${#text} -gt $max_length ]]; then
            truncated_text="${text:0:$max_length}..."
        else
            truncated_text="$text"
        fi
        
        notify-send "OCR Result" "$truncated_text" -t 5000
    fi
}

# Main execution
if [[ "$SCREENSHOT" == true ]]; then
    # Take screenshot and OCR
    grim -g "$(slurp)" "$TEMP_DIR/screenshot.png" 2>/dev/null || {
        if [[ "$NOTIFY" == true ]]; then
            notify-send "OCR Error" "Failed to capture screenshot" -t 3000
        fi
        exit 1
    }
    result=$(do_ocr "$TEMP_DIR/screenshot.png")
elif [[ -n "$INPUT_FILE" ]]; then
    if [[ ! -f "$INPUT_FILE" ]]; then
        if [[ "$NOTIFY" == true ]]; then
            notify-send "OCR Error" "File '$INPUT_FILE' not found" -t 3000
        fi
        exit 1
    fi
    result=$(do_ocr "$INPUT_FILE")
else
    echo "Error: No input specified. Use -s for screenshot or provide a file."
    show_help
    exit 1
fi

# Handle result
if [[ -n "$result" ]]; then
    if [[ "$CLIPBOARD" == true ]]; then
        echo "$result" | wl-copy
        if [[ "$NOTIFY" == true ]]; then
            send_notification "$result"
        fi
    else
        echo "OCR Result:"
        echo "==========="
        echo "$result"
    fi
else
    if [[ "$NOTIFY" == true ]]; then
        notify-send "OCR Result" "No text detected" -t 3000
    elif [[ "$CLIPBOARD" != true ]]; then
        echo "No text detected"
    fi
fi