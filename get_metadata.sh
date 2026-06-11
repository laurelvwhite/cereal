#!/usr/bin/env bash
# Collect cluster metadata (name, peak RA, peak dec) from lowm.txt and highm.txt.
# Run this script from the directory that contains lowm.txt and highm.txt, i.e.:
#   bash get_metadata.sh
# Output is written to cereal_metadata.txt in the same directory.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT="$SCRIPT_DIR/files/cereal_metadata.txt"

# Write header
echo "# name  center_RA  center_dec  csb_physical  csb_physical_err  csb_scaled  csb_scaled_err  w  w_err  nuc_lum  nuc_lum_err" > "$OUTPUT"

# Nuclear luminosity lookup function (bash 3 compatible)
nuc_file="$HOME/homeDropbox/projects/cerealI/table/nuc_vals.txt"
get_nuc() {
  local needle="$1"
  local col="$2"
  if [[ -f "$nuc_file" ]]; then
    awk -v name="$needle" -v col="$col" '$1 == name { print $col }' "$nuc_file"
  fi
}

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  peak_file="$HOME/homeDropbox/lowmcereal/data/${name}/stacked/peak_wcs_decimal.txt"
  fig_dir="$HOME/homeDropbox/lowmcereal/data/${name}/figures"
  if [[ -f "$peak_file" ]]; then
    read -r peak_ra peak_dec < "$peak_file"
    conc_phys=$(     sed -n '1p' "$fig_dir/conc_phys.txt"   2>/dev/null || echo "NA")
    conc_phys_err=$( sed -n '2p' "$fig_dir/conc_phys.txt"   2>/dev/null || echo "NA")
    conc_scal=$(     sed -n '1p' "$fig_dir/conc_scaled.txt"  2>/dev/null || echo "NA")
    conc_scal_err=$( sed -n '2p' "$fig_dir/conc_scaled.txt"  2>/dev/null || echo "NA")
    w=$(             sed -n '1p' "$fig_dir/w.txt"            2>/dev/null || echo "NA")
    w_err=$(         sed -n '2p' "$fig_dir/w.txt"            2>/dev/null || echo "NA")
    lum=$(get_nuc "$name" 2); [[ -z "$lum" ]] && lum="NA"
    lum_err=$(get_nuc "$name" 3); [[ -z "$lum_err" ]] && lum_err="NA"
    echo "${name}  ${peak_ra}  ${peak_dec}  ${conc_phys}  ${conc_phys_err}  ${conc_scal}  ${conc_scal_err}  ${w}  ${w_err}  ${lum}  ${lum_err}" >> "$OUTPUT"
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
    conc_phys=$(     sed -n '1p' "$fig_dir/conc_phys.txt"   2>/dev/null || echo "NA")
    conc_phys_err=$( sed -n '2p' "$fig_dir/conc_phys.txt"   2>/dev/null || echo "NA")
    conc_scal=$(     sed -n '1p' "$fig_dir/conc_scaled.txt"  2>/dev/null || echo "NA")
    conc_scal_err=$( sed -n '2p' "$fig_dir/conc_scaled.txt"  2>/dev/null || echo "NA")
    w=$(             sed -n '1p' "$fig_dir/w.txt"            2>/dev/null || echo "NA")
    w_err=$(         sed -n '2p' "$fig_dir/w.txt"            2>/dev/null || echo "NA")
    lum=$(get_nuc "$name" 2); [[ -z "$lum" ]] && lum="NA"
    lum_err=$(get_nuc "$name" 3); [[ -z "$lum_err" ]] && lum_err="NA"
    echo "${name}  ${peak_ra}  ${peak_dec}  ${conc_phys}  ${conc_phys_err}  ${conc_scal}  ${conc_scal_err}  ${w}  ${w_err}  ${lum}  ${lum_err}" >> "$OUTPUT"
  else
    echo "WARNING: peak file not found for ${name}: ${peak_file}" >&2
  fi
done < "$SCRIPT_DIR/highm.txt"

echo "Done. Output written to $OUTPUT"
