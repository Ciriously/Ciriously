#!/usr/bin/env bash
# Embeds the UnifrakturMaguntia gothic font directly into quotes.svg so the
# title renders on GitHub (GitHub blocks externally-loaded fonts in SVGs).
# Run from the folder that contains quotes.svg:   bash embed-blackletter.sh
set -euo pipefail

TTF_URL="https://fonts.gstatic.com/s/unifrakturmaguntia/v22/WWXPlieVYwiGNomYU-ciRLRvEmK7oaVunw.ttf"

if [ ! -f quotes.svg ]; then
  echo "Error: quotes.svg not found in this folder." >&2; exit 1
fi
if ! grep -q "__UM_TTF__" quotes.svg; then
  echo "Font already embedded (no placeholder found). Nothing to do."; exit 0
fi

echo "Downloading the gothic font..."
curl -fsSL "$TTF_URL" -o /tmp/um.ttf

echo "Embedding into quotes.svg..."
B64=$(base64 < /tmp/um.ttf | tr -d '\n')
python3 - "$B64" <<'PY'
import sys
b64 = sys.argv[1]
svg = open("quotes.svg", encoding="utf-8").read()
svg = svg.replace("__UM_TTF__", "data:font/ttf;base64," + b64)
open("quotes.svg", "w", encoding="utf-8").write(svg)
PY

echo "Done. The gothic title is now baked in."
echo "Commit quotes.svg and it will render everywhere, GitHub included."
