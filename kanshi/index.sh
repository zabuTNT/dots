#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/link.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/link.sh"

link "$DOTFILES/kanshi/config" "$HOME/.config/kanshi/config"
