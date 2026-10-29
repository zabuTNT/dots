#!/usr/bin/env bash
# Config di piccoli strumenti: ranger, btop, htop, k9s.
set -euo pipefail
# shellcheck source=../lib/link.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/link.sh"

link "$DOTFILES/tools/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
link "$DOTFILES/tools/btop/btop.conf" "$HOME/.config/btop/btop.conf"
link "$DOTFILES/tools/htop/htoprc" "$HOME/.config/htop/htoprc"
link "$DOTFILES/tools/k9s/config.yaml" "$HOME/.config/k9s/config.yaml"
link "$DOTFILES/tools/k9s/aliases.yaml" "$HOME/.config/k9s/aliases.yaml"
link "$DOTFILES/tools/k9s/skins" "$HOME/.config/k9s/skins"
