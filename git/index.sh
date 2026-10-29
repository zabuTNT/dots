#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/link.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/link.sh"

link "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/git/ignore" "$HOME/.config/git/ignore"

if [ ! -e "$HOME/.gitconfig.local" ] && [ "${DRY_RUN:-0}" != 1 ]; then
  cp "$DOTFILES/git/gitconfig.local.example" "$HOME/.gitconfig.local"
  echo "creato   ~/.gitconfig.local: modifica nome, email e chiave di firma"
fi
