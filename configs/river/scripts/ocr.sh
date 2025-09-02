#!/bin/bash

set -e

TEMP_FILE="/tmp/ocr_screenshot.png"

# Take screenshot of selected area
grim -g "$(slurp)" "$TEMP_FILE"

# Perform OCR and copy to clipboard
tesseract "$TEMP_FILE" stdout -l chi_sim+chi_tra+eng+jpn --psm 6 --oem 3 2>/dev/null | wl-copy

# Clean up
rm -f "$TEMP_FILE"

