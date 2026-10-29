#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/link.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/link.sh"

link "$DOTFILES/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
link "$DOTFILES/waybar/style.css" "$HOME/.config/waybar/style.css"
