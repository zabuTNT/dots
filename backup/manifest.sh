#!/usr/bin/env bash
# Salva l'elenco di ciò che è installato, per ricostruire la macchina.
set -uo pipefail
OUT="${1:?uso: manifest.sh <cartella>}"
mkdir -p "$OUT"

have() { command -v "$1" >/dev/null 2>&1; }

have apt-mark && apt-mark showmanual | sort > "$OUT/apt-manual.txt"
have snap && snap list > "$OUT/snap.txt"
have flatpak && flatpak list --columns=application,origin > "$OUT/flatpak.txt"
have npm && npm ls -g --depth=0 > "$OUT/npm-global.txt" 2>/dev/null
have uv && uv tool list > "$OUT/uv-tools.txt" 2>/dev/null
have pipx && pipx list --short > "$OUT/pipx.txt" 2>/dev/null
have cargo && cargo install --list > "$OUT/cargo.txt" 2>/dev/null
have code && code --list-extensions > "$OUT/vscode-extensions.txt" 2>/dev/null
have dconf && dconf dump / > "$OUT/dconf.ini"
have crontab && crontab -l > "$OUT/crontab.txt" 2>/dev/null
have gsettings && gsettings list-recursively org.gnome.desktop.interface > "$OUT/gsettings-interface.txt" 2>/dev/null
ls ~/go/bin ~/.local/bin ~/.cargo/bin 2>/dev/null > "$OUT/bin-dirs.txt"
cp /etc/fstab "$OUT/fstab.txt" 2>/dev/null
echo "manifest in $OUT"
