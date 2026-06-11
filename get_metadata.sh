#!/usr/bin/env bash
# Collect cluster metadata (name, peak RA, peak dec) from lowm.txt and highm.txt.
# Run this script from the directory that contains lowm.txt and highm.txt, i.e.:
#   bash get_metadata.sh
# Output is written to cereal_metadata.txt in the same directory.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT="$SCRIPT_DIR/files/cereal_metadata.txt"

# Write header
echo "# name  center_RA  center_dec  csb_physical  csb_scaled  w" > "$OUTPUT"

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  peak_file="$HOME/homeDropbox/lowmcereal/data/${name}/stacked/peak_wcs_decimal.txt"
  fig_dir="$HOME/homeDropbox/lowmcereal/data/${name}/figures"
  if [[ -f "$peak_file" ]]; then
    read -r peak_ra peak_dec < "$peak_file"
    conc_phys=$(cat "$fig_dir/conc_phys.txt"   2>/dev/null || echo "NA")
    conc_scal=$(cat "$fig_dir/conc_scaled.txt"  2>/dev/null || echo "NA")
    w=$(cat         "$fig_dir/w.txt"            2>/dev/null || echo "NA")
    echo "${name}  ${peak_ra}  ${peak_dec}  ${conc_phys}  ${conc_scal}  ${w}" >> "$OUTPUT"
  else
    echo "WARNING: peak file not found for ${name}: ${peak_file}" >&2
  fi
done < "$SCRIPT_DIR/lowm.txt"

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  peak_file="$HOME/homeDropbox/cereal/data/${name}/stacked/peak_wcs_decimal.txt"
  fig_dir="$HOME/homeDropbox/cereal/data/${name}/figures"
  if [[ -f "$peak_file" ]]; then
    read -r peak_ra peak_dec < "$peak_file"
    conc_phys=$(cat "$fig_dir/conc_phys.txt"   2>/dev/null || echo "NA")
    conc_scal=$(cat "$fig_dir/conc_scaled.txt"  2>/dev/null || echo "NA")
    w=$(cat         "$fig_dir/w.txt"            2>/dev/null || echo "NA")
    echo "${name}  ${peak_ra}  ${peak_dec}  ${conc_phys}  ${conc_scal}  ${w}" >> "$OUTPUT"
  else
    echo "WARNING: peak file not found for ${name}: ${peak_file}" >&2
  fi
done < "$SCRIPT_DIR/highm.txt"

echo "Done. Output written to $OUTPUT"
