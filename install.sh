#!/usr/bin/env bash
# Collega le configurazioni nella home. Non installa pacchetti (vedi system/).
#
#   ./install.sh                 tutti i moduli
#   ./install.sh sway waybar     solo quelli indicati
#   DRY_RUN=1 ./install.sh       mostra senza toccare nulla
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODULES=(bash git mise sway waybar kitty mako fuzzel kanshi tools)

if [ "$#" -gt 0 ]; then
  MODULES=("$@")
fi

for m in "${MODULES[@]}"; do
  if [ ! -x "$ROOT/$m/index.sh" ]; then
    echo "modulo sconosciuto: $m" >&2
    exit 1
  fi
  echo "== $m"
  "$ROOT/$m/index.sh"
done
