#!/usr/bin/env bash
# Creates a local files/(name)/ directory for each cluster and copies
# the relevant image into it.
# Run from the same directory as lowm.txt, highm.txt, and data.html.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$SCRIPT_DIR/files"
mkdir -p "$FILES_DIR"

count=0
missing=0

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  src="$HOME/homeDropbox/lowmcereal/data/${name}/figures/${name}_labeled.png"
  dest_dir="$FILES_DIR/${name}"
  mkdir -p "$dest_dir"
  if [[ -f "$src" ]]; then
    cp "$src" "$dest_dir/${name}_labeled.png"
    (( count++ ))
  else
    echo "Warning: image not found for ${name}: $src" >&2
    (( missing++ ))
  fi
done < "$SCRIPT_DIR/lowm.txt"

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  src="$HOME/homeDropbox/cereal/data/${name}/figures/${name}_labeled.png"
  dest_dir="$FILES_DIR/${name}"
  mkdir -p "$dest_dir"
  if [[ -f "$src" ]]; then
    cp "$src" "$dest_dir/${name}_labeled.png"
    (( count++ ))
  else
    echo "Warning: image not found for ${name}: $src" >&2
    (( missing++ ))
  fi
done < "$SCRIPT_DIR/highm.txt"

echo "Copied $count images to $FILES_DIR/ ($missing missing)."
