#!/bin/bash

# High accuracy OCR script using Tesseract
# Supports both screenshot OCR and file OCR

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
    echo "  -s, --screenshot    Take screenshot and OCR selected region"
    echo "  -c, --clipboard     Copy result to clipboard"
    echo "  -l, --lang LANG     Language(s) for OCR (default: chi_sim+chi_tra+eng+jpn)"
    echo "  -p, --preprocess    Apply image preprocessing for better accuracy"
    echo "  -h, --help          Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 -s -c              # Screenshot OCR to clipboard"
    echo "  $0 -p image.png       # OCR file with preprocessing"
    echo "  $0 -l eng+fra file.pdf # OCR PDF with English and French"
}

# Default options
SCREENSHOT=false
CLIPBOARD=false
LANG="chi_sim+chi_tra+eng+jpn"
PREPROCESS=false
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
        if [[ "$CLIPBOARD" != true ]]; then
            echo "Preprocessing image for better accuracy..."
        fi
        preprocess_image "$input_file" "$processed_file"
        input_file="$processed_file"
    fi
    
    if [[ "$CLIPBOARD" != true ]]; then
        echo "Performing OCR with language(s): $LANG"
    fi
    
    # Use Tesseract with high accuracy settings
    tesseract "$input_file" stdout \
        -l "$LANG" \
        --psm 6 \
        --oem 3 \
        2>/dev/null
}

# Main execution
if [[ "$SCREENSHOT" == true ]]; then
    if [[ "$CLIPBOARD" != true ]]; then
        echo "Select region for OCR..."
    fi
    grim -g "$(slurp)" "$TEMP_DIR/screenshot.png"
    result=$(do_ocr "$TEMP_DIR/screenshot.png")
elif [[ -n "$INPUT_FILE" ]]; then
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo "Error: File '$INPUT_FILE' not found"
        exit 1
    fi
    result=$(do_ocr "$INPUT_FILE")
else
    echo "Error: No input specified. Use -s for screenshot or provide a file."
    show_help
    exit 1
fi

# Copy to clipboard if requested, otherwise show result
if [[ "$CLIPBOARD" == true ]]; then
    echo "$result" | wl-copy
else
    echo "OCR Result:"
    echo "==========="
    echo "$result"
fi