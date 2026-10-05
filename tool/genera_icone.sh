#!/bin/bash
# Rigenera i PNG dell'icona a partire dagli SVG, poi le icone di ogni
# piattaforma. Da rilanciare dopo ogni modifica agli SVG.
set -e
cd "$(dirname "$0")/.."

rsvg-convert -w 1024 -h 1024 assets/icona/spesone.svg -o assets/icona/spesone.png
rsvg-convert -w 1024 -h 1024 assets/icona/spesone_primo_piano.svg \
  -o assets/icona/spesone_primo_piano.png

dart run flutter_launcher_icons
