#!/usr/bin/env bash
# Passi da eseguire una volta su una Fedora appena installata.
#   ./system/post-install.sh            tutto
#   ./system/post-install.sh dnf mise   solo alcuni passi
# Passi: repos dnf flatpak mise services
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$HERE")"

read_list() {
  grep -vE '^\s*(#|$)' "$1"
}

step_repos() {
  local fedora
  fedora=$(rpm -E %fedora)

  sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora}.noarch.rpm"

  # Google Chrome
  sudo dnf install -y fedora-workstation-repositories
  sudo dnf config-manager setopt google-chrome.enabled=1
}

step_dnf() {
  local missing=()
  mapfile -t pkgs < <(read_list "$HERE/packages-dnf.txt")

  sudo dnf install -y --skip-unavailable "${pkgs[@]}"
  sudo dnf install -y google-chrome-stable || echo "google-chrome-stable non installato" >&2

  for p in "${pkgs[@]}"; do
    rpm -q "$p" >/dev/null 2>&1 || missing+=("$p")
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    echo "Pacchetti NON installati (nome diverso o assente su Fedora):" >&2
    printf '  %s\n' "${missing[@]}" >&2
  fi
}

step_flatpak() {
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  read_list "$HERE/flatpaks.txt" | xargs -r flatpak install -y flathub
}

step_mise() {
  if ! command -v mise >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/mise" ]; then
    # Fedora: pacchetto ufficiale dal repo di mise
    sudo dnf copr enable -y jdxcode/mise
    sudo dnf install -y mise
  fi
  "$ROOT/mise/index.sh"
  mise install
}

step_services() {
  sudo systemctl enable --now bluetooth.service
  sudo usermod -aG video "$USER"   # brightnessctl senza sudo
  xdg-user-dirs-update
  echo "Riavvia la sessione per applicare i gruppi."
}

STEPS=("$@")
[ "${#STEPS[@]}" -eq 0 ] && STEPS=(repos dnf flatpak mise services)

for s in "${STEPS[@]}"; do
  echo "== $s"
  "step_$s"
done
