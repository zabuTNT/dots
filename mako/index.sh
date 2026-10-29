#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/link.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/link.sh"

link "$DOTFILES/mako/config" "$HOME/.config/mako/config"
