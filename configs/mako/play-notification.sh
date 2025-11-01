#!/usr/bin/env bash
set -euo pipefail

# Determine which sound to play; default to urgency or fall back to normal.
sound="${1:-${MAKO_URGENCY:-normal}}"

# Resolve the directory containing the audio assets.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
audio_dir="${script_dir}/audio"

case "${sound}" in
  normal)
    audio_file="${audio_dir}/normal.mp3"
    ;;
  critical|high)
    audio_file="${audio_dir}/critical.mp3"
    ;;
  *)
    # Allow passing an explicit filename relative to the audio directory.
    audio_file="${audio_dir}/${sound}"
    ;;
esac

# Quietly bail out if the requested sound is missing.
if [[ ! -f "${audio_file}" ]]; then
  exit 0
fi

# Fire and forget; avoid dumping ffplay output into mako logs.
ffplay -nodisp -autoexit -loglevel error "${audio_file}" >/dev/null 2>&1 &
