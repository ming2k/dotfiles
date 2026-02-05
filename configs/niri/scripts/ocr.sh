#!/bin/bash
#
# ocr.sh - Screen region OCR using RapidOCR (ONNX Runtime)
#
# Captures a user-selected screen region, extracts text via RapidOCR,
# and copies the result to the Wayland clipboard.
#
# Dependencies: grim, slurp, wl-copy, rapidocr_onnxruntime (venv)
# Usage: bound to Super+O in niri config
#

set -e

TEMP_FILE="/tmp/ocr-screenshot.png"
RAPIDOCR_PYTHON="$HOME/.local/share/venvs/rapidocr/bin/python"

# Brief delay to allow keybinding release before slurp grabs input
sleep 0.1

# Capture a screenshot of the user-selected region
grim -g "$(slurp)" "$TEMP_FILE"

# Run RapidOCR on the screenshot and capture extracted text.
# RapidOCR returns a list of [bbox, text, confidence] per detected line;
# we join all text fields with newlines.
OCR_TEXT=$("$RAPIDOCR_PYTHON" -c "
from rapidocr_onnxruntime import RapidOCR
engine = RapidOCR()
result, _ = engine('$TEMP_FILE')
if result:
    print('\n'.join(line[1] for line in result))
")

rm -f "$TEMP_FILE"

if [ -n "$OCR_TEXT" ]; then
    echo "$OCR_TEXT" | wl-copy
    notify-send "OCR" "$OCR_TEXT"
else
    notify-send "OCR" "No text detected"
fi

