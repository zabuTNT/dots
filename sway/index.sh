#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/link.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/link.sh"

link "$DOTFILES/sway/config" "$HOME/.config/sway/config"
link "$DOTFILES/sway/scripts" "$HOME/.config/sway/scripts"
