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
  src="$HOME/homeDropbox/lowmcereal/data/${name}/figures/${name}_not_labeled.png"
  dest_dir="$FILES_DIR/${name}"
  mkdir -p "$dest_dir"
  if [[ -f "$src" ]]; then
    cp "$src" "$dest_dir/${name}_not_labeled.png"
    (( count++ ))
  else
    echo "Warning: image not found for ${name}: $src" >&2
    (( missing++ ))
  fi
  for model in ne.model kT_projected.model kT_3D.model all.model; do
    src_model="$HOME/homeDropbox/lowmcereal/data/${name}/specfits/${model}"
    dest_model="${dest_dir}/${name}_${model}"
    if [[ -f "$src_model" ]]; then
      cp "$src_model" "$dest_model"
      (( count++ ))
    else
      echo "Warning: model not found for ${name}: $src_model" >&2
      (( missing++ ))
    fi
  done
  src_model="$HOME/homeDropbox/lowmcereal/data/${name}/specfits/SB.model"
  if [[ -f "$src_model" ]]; then
    cp "$src_model" "${dest_dir}/${name}_EM.model"
    (( count++ ))
  else
    echo "Warning: model not found for ${name}: $src_model" >&2
    (( missing++ ))
  fi
done < "$SCRIPT_DIR/lowm.txt"

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  src="$HOME/homeDropbox/cereal/data/${name}/figures/${name}_not_labeled.png"
  dest_dir="$FILES_DIR/${name}"
  mkdir -p "$dest_dir"
  if [[ -f "$src" ]]; then
    cp "$src" "$dest_dir/${name}_not_labeled.png"
    (( count++ ))
  else
    echo "Warning: files not found for ${name}: $src" >&2
    (( missing++ ))
  fi
  for model in ne.model kT_projected.model kT_3D.model all.model; do
    src_model="$HOME/homeDropbox/cereal/data/${name}/specfits/${model}"
    dest_model="${dest_dir}/${name}_${model}"
    if [[ -f "$src_model" ]]; then
      cp "$src_model" "$dest_model"
      (( count++ ))
    else
      echo "Warning: model not found for ${name}: $src_model" >&2
      (( missing++ ))
    fi
  done
  src_model="$HOME/homeDropbox/cereal/data/${name}/specfits/SB.model"
  if [[ -f "$src_model" ]]; then
    cp "$src_model" "${dest_dir}/${name}_EM.model"
    (( count++ ))
  else
    echo "Warning: model not found for ${name}: $src_model" >&2
    (( missing++ ))
  fi
done < "$SCRIPT_DIR/highm.txt"

echo "Copied $count files to $FILES_DIR/ ($missing missing)."
