#!/usr/bin/env bash
# Helper condivisi dagli index.sh dei moduli. Da includere con `source`.

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES

# link <sorgente> <destinazione>
# Crea un symlink; se la destinazione esiste ed è un file/cartella vera la
# sposta in <dest>.bak-<data> invece di sovrascriverla.
# DRY_RUN=1 stampa soltanto cosa farebbe.
link() {
  local src="$1" dst="$2"

  if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
    echo "ok       $dst"
    return 0
  fi

  if [ "${DRY_RUN:-0}" = 1 ]; then
    echo "[dry] ln $src -> $dst"
    return 0
  fi

  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak-$(date +%Y%m%d%H%M%S)"
    echo "backup   $dst"
  fi
  ln -s "$src" "$dst"
  echo "link     $dst"
}
