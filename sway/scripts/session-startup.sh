#!/usr/bin/env bash
# Avvio delle app di sessione. Le finestre vanno sul workspace giusto grazie
# alle regole `assign` in sway/config (non esiste append_layout su Sway).
set -u

sleep 2

kitty --class btop -e btop -p 2 &
kitty --class ranger -e ranger &
kitty --class ncmpcpp -e ncmpcpp -s clock &

thunar &
slack &
google-chrome --ozone-platform-hint=auto &

# Lascia il focus sul workspace 2 (chrome)
sleep 1
swaymsg 'workspace 2:二' >/dev/null || true
