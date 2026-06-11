#!/usr/bin/env bash
# Collect cluster metadata (name, peak RA, peak dec) from lowm.txt and highm.txt.
# Run this script from the directory that contains lowm.txt and highm.txt, i.e.:
#   bash get_metadata.sh
# Output is written to cereal_metadata.txt in the same directory.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT="$SCRIPT_DIR/files/cereal_metadata.txt"

# Write header
echo "# name  peak_RA  peak_dec" > "$OUTPUT"

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  peak_file="$HOME/homeDropbox/lowmcereal/data/${name}/stacked/peak_wcs_decimal.txt"
  if [[ -f "$peak_file" ]]; then
    read -r peak_ra peak_dec < "$peak_file"
    echo "${name}  ${peak_ra}  ${peak_dec}" >> "$OUTPUT"
  else
    echo "WARNING: peak file not found for ${name}: ${peak_file}" >&2
  fi
done < "$SCRIPT_DIR/lowm.txt"

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  peak_file="$HOME/homeDropbox/cereal/data/${name}/stacked/peak_wcs_decimal.txt"
  if [[ -f "$peak_file" ]]; then
    read -r peak_ra peak_dec < "$peak_file"
    echo "${name}  ${peak_ra}  ${peak_dec}" >> "$OUTPUT"
  else
    echo "WARNING: peak file not found for ${name}: ${peak_file}" >&2
  fi
done < "$SCRIPT_DIR/highm.txt"

echo "Done. Output written to $OUTPUT"
