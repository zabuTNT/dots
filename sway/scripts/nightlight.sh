#!/usr/bin/env bash
# Temperatura colore (sostituisce hueshift.sh basato su xrandr --gamma).
# Wayland non permette di impostare il gamma e uscire: gammastep deve restare
# in esecuzione finché il filtro è attivo.
#
#   nightlight.sh get|apply|day|night|toggle|up|down
set -euo pipefail

STATE="${XDG_CACHE_HOME:-$HOME/.cache}/nightlight"
mkdir -p "$(dirname "$STATE")"
[ -f "$STATE" ] || echo 6500 > "$STATE"
cur=$(cat "$STATE")
case "$cur" in '' | *[!0-9]*) cur=6500 ;; esac

DAY=6500 NIGHT=3400 MIN=2500 MAX=6500 STEP=250

case "${1:-get}" in
  get) echo "$cur"; exit 0 ;;
  apply) ;;
  day) cur=$DAY ;;
  night) cur=$NIGHT ;;
  toggle) if [ "$cur" -gt 5000 ]; then cur=$NIGHT; else cur=$DAY; fi ;;
  up) cur=$((cur + STEP)); [ "$cur" -gt "$MAX" ] && cur=$MAX ;;
  down) cur=$((cur - STEP)); [ "$cur" -lt "$MIN" ] && cur=$MIN ;;
  *) exit 1 ;;
esac
echo "$cur" > "$STATE"

pkill -x gammastep || true
if [ "$cur" -lt "$MAX" ]; then
  setsid gammastep -m wayland -O "$cur" >/dev/null 2>&1 &
fi
