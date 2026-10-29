#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/link.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/link.sh"

link "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
link "$DOTFILES/bash/profile" "$HOME/.profile"
