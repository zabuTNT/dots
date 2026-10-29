#!/usr/bin/env bash
# screenshot.sh full|window|area: salva in ~/Immagini/Screenshots e copia negli appunti.
set -euo pipefail

dir="$HOME/Immagini/Screenshots"
mkdir -p "$dir"
file="$dir/$(date +%Y%m%d-%H%M%S).png"

case "${1:-full}" in
  full) grim "$file" ;;
  area) grim -g "$(slurp)" "$file" ;;
  window)
    geom=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
    grim -g "$geom" "$file"
    ;;
  *) exit 1 ;;
esac

wl-copy < "$file"
notify-send -a screenshot -t 2000 "Screenshot" "$file"
