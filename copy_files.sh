#!/usr/bin/env bash
# Creates a local files/(name)/ directory for each cluster and copies
# the relevant images, data files, and models into it.
# Run from the same directory as lowm.txt, highm.txt, and data.html.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$SCRIPT_DIR/files"
mkdir -p "$FILES_DIR"

count=0
missing=0

# Each entry is "source path relative to data/(name)/ | destination suffix".
# The destination is files/(name)/(name)_(suffix). @NAME@ is replaced by the cluster name.
FILE_MAP=(
  "figures/@NAME@_not_labeled.png|not_labeled.png"
  "figures/cropped_csmoothed.img|adaptively_smoothed.img"
  "specfits/nenpdl_vik06.png|EM.png"
  "specfits/kT_vik06.png|kT.png"
  "specfits/SB.data|EM.txt"
  "specfits/kT.data|kT.txt"
  "specfits/SB.model|EM.model"
  "specfits/ne.model|ne.model"
  "specfits/kT_projected.model|kT_projected.model"
  "specfits/kT_3D.model|kT_3D.model"
  "specfits/all.model|all.model"
)

copy_cluster() {
  local name="$1"
  local base="$2"
  local dest_dir="$FILES_DIR/${name}"
  mkdir -p "$dest_dir"

  local entry rel suffix src
  for entry in "${FILE_MAP[@]}"; do
    rel="${entry%%|*}"
    suffix="${entry##*|}"
    rel="${rel//@NAME@/$name}"
    src="$base/${name}/${rel}"
    if [[ -f "$src" ]]; then
      cp "$src" "$dest_dir/${name}_${suffix}"
      (( count++ ))
    else
      echo "Warning: not found for ${name}: $src" >&2
      (( missing++ ))
    fi
  done
}

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  copy_cluster "$name" "$HOME/homeDropbox/lowmcereal/data"
done < "$SCRIPT_DIR/lowm.txt"

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  copy_cluster "$name" "$HOME/homeDropbox/cereal/data"
done < "$SCRIPT_DIR/highm.txt"

echo "Copied $count files to $FILES_DIR/ ($missing missing)."
