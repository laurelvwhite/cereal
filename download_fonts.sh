#!/usr/bin/env bash
# Downloads EB Garamond woff2 files from the project's GitHub repository
# and writes a local CSS file. Only needs to be run once.
# Run from the same directory as your HTML files.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONTS_DIR="$SCRIPT_DIR/fonts"
mkdir -p "$FONTS_DIR"

BASE="https://raw.githubusercontent.com/octaviopardo/EBGaramond12/master/fonts/webfonts"

download() {
  local key="$1"
  local filename="$2"
  local out="$FONTS_DIR/${key}.woff2"
  if [[ ! -f "$out" ]]; then
    curl -s --connect-timeout 10 --max-time 30 "$BASE/$filename" -o "$out"
    if [[ -s "$out" ]]; then
      echo "  Downloaded ${key}.woff2"
    else
      echo "  Error: failed to download ${key}.woff2" >&2
      rm -f "$out"
    fi
  else
    echo "  Skipped ${key}.woff2 (already exists)"
  fi
}

echo "Downloading EB Garamond font files..."
download "eb-garamond-400-normal" "EBGaramond12-Regular.woff2"
download "eb-garamond-400-italic" "EBGaramond12-Italic.woff2"
download "eb-garamond-700-normal" "EBGaramond12-Bold.woff2"

echo "Writing fonts/eb-garamond.css..."
cat > "$FONTS_DIR/eb-garamond.css" << 'CSS'
@font-face {
  font-family: 'EB Garamond';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url('./eb-garamond-400-normal.woff2') format('woff2');
}
@font-face {
  font-family: 'EB Garamond';
  font-style: italic;
  font-weight: 400;
  font-display: swap;
  src: url('./eb-garamond-400-italic.woff2') format('woff2');
}
@font-face {
  font-family: 'EB Garamond';
  font-style: normal;
  font-weight: 600;
  font-display: swap;
  src: url('./eb-garamond-400-normal.woff2') format('woff2');
}
@font-face {
  font-family: 'EB Garamond';
  font-style: italic;
  font-weight: 600;
  font-display: swap;
  src: url('./eb-garamond-400-italic.woff2') format('woff2');
}
@font-face {
  font-family: 'EB Garamond';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url('./eb-garamond-700-normal.woff2') format('woff2');
}
CSS

echo "Done. Font files and CSS written to $FONTS_DIR/."
