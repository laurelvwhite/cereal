#!/usr/bin/env bash
# Generate clusters/(name).html for every cluster in lowm.txt and highm.txt.
# Run this script from the directory that contains data.html, i.e.:
#   bash make_cluster_pages.sh
# The two data files are expected in the same directory as the script.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLUSTERS_DIR="$SCRIPT_DIR/clusters"
mkdir -p "$CLUSTERS_DIR"

make_page() {
  local name="$1"
  local img_path="$2"
  local dest="$CLUSTERS_DIR/${name}.html"

  # Remove any directory that might exist at this path before writing
  [[ -d "$dest" ]] && rm -rf "$dest"

  # Build the image block only if the file exists
  local img_block=""
  if [[ -f "$img_path" ]]; then
    img_block="    <div class=\"cluster-img\"><img src=\"../files/${name}/${name}_labeled.png\" alt=\"${name}\" /></div>"
  fi

  # Build SB data table rows
  local sb_rows=""
  local sb_file="$SCRIPT_DIR/files/${name}/${name}_SB.data"
  if [[ -f "$sb_file" ]]; then
    while IFS=',' read -r r_in r_out kt z em em_lo em_hi; do
      sb_rows="${sb_rows}          <tr><td>${r_in}</td><td>${r_out}</td><td>${kt}</td><td>${z}</td><td>${em}</td><td>${em_lo}</td><td>${em_hi}</td></tr>
"
    done < "$sb_file"
  fi

  # Build kT data table rows
  local kt_rows=""
  local kt_file="$SCRIPT_DIR/files/${name}/${name}_kT.data"
  if [[ -f "$kt_file" ]]; then
    while IFS=',' read -r r_in r_out kt kt_lo kt_hi z z_lo z_hi em em_lo em_hi; do
      kt_rows="${kt_rows}          <tr><td>${r_in}</td><td>${r_out}</td><td>${kt}</td><td>${kt_lo}</td><td>${kt_hi}</td><td>${z}</td><td>${z_lo}</td><td>${z_hi}</td><td>${em}</td><td>${em_lo}</td><td>${em_hi}</td></tr>
"
    done < "$kt_file"
  fi

  cat > "$dest" << HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>${name} — CEREAL Data Products</title>
  <link rel="stylesheet" href="../fonts/eb-garamond.css" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/3.2.2/es5/tex-svg.min.js"></script>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg: #08050f;
      --ink: #ede8f5;
      --accent: #9b5de5;
      --accent2: #c77dff;
      --muted: #7a5fa0;
      --rule: #2a1a3a;
      --glow: rgba(155, 93, 229, 0.22);
    }

    body {
      background: var(--bg);
      background-image:
        radial-gradient(ellipse 80% 50% at 20% 80%, rgba(100, 30, 180, 0.22) 0%, transparent 70%),
        radial-gradient(ellipse 60% 40% at 80% 20%, rgba(180, 80, 255, 0.10) 0%, transparent 60%);
      color: var(--ink);
      font-family: 'EB Garamond', Georgia, serif;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    header {
      border-bottom: 1px solid var(--rule);
      padding: 2rem 3rem;
      display: flex;
      align-items: baseline;
      gap: 1.5rem;
    }

    .logo {
      font-family: 'EB Garamond', Georgia, serif;
      font-weight: 700;
      font-size: 1.75rem;
      letter-spacing: 0.06em;
      line-height: 1;
      text-transform: uppercase;
      text-decoration: none;
      color: var(--ink);
    }

    .logo span { color: var(--accent); }

    nav {
      margin-left: auto;
      display: flex;
      gap: 2rem;
    }

    nav a {
      font-size: 0.8rem;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      text-decoration: none;
      color: var(--muted);
      transition: color 0.15s;
    }

    nav a:hover { color: var(--accent2); }
    nav a.active { color: var(--accent2); }

    main {
      flex: 1;
      padding: 6rem 3rem 4rem;
      max-width: 1600px;
    }

    .eyebrow {
      font-size: 0.75rem;
      letter-spacing: 0.14em;
      text-transform: uppercase;
      color: var(--accent);
      margin-bottom: 1.25rem;
      font-style: italic;
    }

    h1 {
      font-family: 'EB Garamond', Georgia, serif;
      font-weight: 700;
      font-size: clamp(2rem, 4.5vw, 3.8rem);
      line-height: 1.05;
      letter-spacing: 0.02em;
      margin-bottom: 2rem;
      text-transform: uppercase;
    }

    h2 {
      font-family: 'EB Garamond', Georgia, serif;
      font-weight: 600;
      font-size: 1.45rem;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      color: var(--accent2);
      margin-bottom: 1.25rem;
    }

    .divider {
      width: 3rem;
      height: 1px;
      background: linear-gradient(90deg, var(--accent), var(--accent2));
      margin-bottom: 2rem;
      box-shadow: 0 0 8px var(--glow);
    }

    .section {
      margin-bottom: 4rem;
    }

    p {
      font-size: 1.15rem;
      line-height: 1.9;
      color: var(--ink);
      max-width: 860px;
      opacity: 0.85;
      margin-bottom: 1.5rem;
    }

    .cluster-img {
      margin-bottom: 2rem;
    }

    .cluster-img img {
      max-width: 100%;
      height: auto;
      display: block;
      border: 1px solid var(--rule);
      box-shadow: 0 0 24px var(--glow);
    }

    .table-wrap {
      overflow-x: auto;
      border: 1px solid var(--rule);
      border-radius: 4px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.92rem;
      font-family: 'EB Garamond', Georgia, serif;
    }

    thead tr {
      background: rgba(155, 93, 229, 0.12);
      border-bottom: 1px solid var(--accent);
    }

    thead th {
      padding: 0.75rem 1.1rem;
      text-align: left;
      font-size: 0.75rem;
      letter-spacing: 0.1em;
      color: var(--accent2);
      font-weight: 600;
      white-space: normal;
    }

    tbody tr {
      border-bottom: 1px solid var(--rule);
      transition: background 0.12s;
    }

    tbody tr:last-child { border-bottom: none; }

    tbody tr:hover {
      background: rgba(155, 93, 229, 0.07);
    }

    tbody td {
      padding: 0.55rem 1.1rem;
      color: var(--ink);
      opacity: 0.88;
      font-variant-numeric: tabular-nums;
      white-space: nowrap;
    }

    main a:link    { color: var(--accent2); text-decoration: underline; text-underline-offset: 3px; }
    main a:visited { color: #e0aaff; }
    main a:hover   { color: #fff; }

    footer {
      border-top: 1px solid var(--rule);
      padding: 1.5rem 3rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 0.72rem;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: var(--muted);
      font-style: italic;
    }
  </style>
</head>
<body>

  <header>
    <a class="logo" href="../index.html">CEREAL<span>.</span></a>
    <nav>
      <a href="../index.html">Home</a>
      <a href="../about.html">About</a>
      <a href="../data.html" class="active">Data</a>
    </nav>
  </header>

  <main>
    <p class="eyebrow">Cluster</p>
    <h1>${name}</h1>
    <div class="divider"></div>
${img_block}
    <div class="section">
      <h2>Emission Measure Profiles</h2>
      <p>Here is the best-fit emission measure profile:</p>
      <div class="cluster-img"><img src="../files/${name}/${name}_SB.png" alt="${name} emission measure profile" /></div>
      <p>The annular profile information is given in the table below, or it is available in file format here: <a href="../files/${name}/${name}_SB.data" download style="color: var(--accent2); text-decoration: none; border-bottom: 1px solid rgba(199, 125, 255, 0.3); transition: color 0.15s, border-color 0.15s;">${name}_SB.data</a></p>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>\(r_{\rm inner}\) (pixels)</th>
              <th>\(r_{\rm outer}\) (pixels)</th>
              <th>kT (keV)</th>
              <th>Z</th>
              <th>EM \((\int \mathrm{n}_p \mathrm{n}_e \mathrm{dl}~[10^{60}~\mathrm{cm}^{-5}~\mathrm{kpc}^{-2}])\)</th>
              <th>EM\(_{\rm low}\) \((\int \mathrm{n}_p \mathrm{n}_e \mathrm{dl}~[10^{60}~\mathrm{cm}^{-5}~\mathrm{kpc}^{-2}])\)</th>
              <th>EM\(_{\rm high}\) \((\int \mathrm{n}_p \mathrm{n}_e \mathrm{dl}~[10^{60}~\mathrm{cm}^{-5}~\mathrm{kpc}^{-2}])\)</th>
            </tr>
          </thead>
          <tbody>
${sb_rows}          </tbody>
        </table>
      </div>
    </div>

    <div class="section">
      <h2>Temperature Profiles</h2>
      <p>Here is the best-fit temperature profile:</p>
      <div class="cluster-img"><img src="../files/${name}/${name}_kT.png" alt="${name} temperature profile" /></div>
      <p>The annular profile information is given in the table below, or it is available in file format here: <a href="../files/${name}/${name}_kT.data" download style="color: var(--accent2); text-decoration: none; border-bottom: 1px solid rgba(199, 125, 255, 0.3); transition: color 0.15s, border-color 0.15s;">${name}_kT.data</a></p>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>\(r_{\rm inner}\) (pixels)</th>
              <th>\(r_{\rm outer}\) (pixels)</th>
              <th>kT (keV)</th>
              <th>kT\(_{\rm low}\) (keV)</th>
              <th>kT\(_{\rm high}\) (keV)</th>
              <th>Z</th>
              <th>Z\(_{\rm low}\)</th>
              <th>Z\(_{\rm high}\)</th>
              <th>EM \((\int \mathrm{n}_p \mathrm{n}_e \mathrm{dl}~[10^{60}~\mathrm{cm}^{-5}~\mathrm{kpc}^{-2}])\)</th>
              <th>EM\(_{\rm low}\) \((\int \mathrm{n}_p \mathrm{n}_e \mathrm{dl}~[10^{60}~\mathrm{cm}^{-5}~\mathrm{kpc}^{-2}])\)</th>
              <th>EM\(_{\rm high}\) \((\int \mathrm{n}_p \mathrm{n}_e \mathrm{dl}~[10^{60}~\mathrm{cm}^{-5}~\mathrm{kpc}^{-2}])\)</th>
            </tr>
          </thead>
          <tbody>
${kt_rows}          </tbody>
        </table>
      </div>
    </div>

    <p><a href="../data.html">&larr; Back to Data</a></p>
  </main>

  <footer>
    <span>Laurel White</span>
    <span>&copy; 2026</span>
  </footer>

</body>
</html>
HTML
}

count=0

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  img="$HOME/homeDropbox/lowmcereal/data/${name}/figures/${name}_labeled.png"
  make_page "$name" "$img"
  (( count++ ))
done < "$SCRIPT_DIR/lowm.txt"

while read -r name _rest; do
  [[ -z "$name" ]] && continue
  img="$HOME/homeDropbox/cereal/data/${name}/figures/${name}_labeled.png"
  make_page "$name" "$img"
  (( count++ ))
done < "$SCRIPT_DIR/highm.txt"

echo "Created $count cluster pages in $CLUSTERS_DIR/"
