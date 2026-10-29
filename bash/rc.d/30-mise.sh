# mise gestisce node, python, go, rust, java (vedi mise/config.toml).
# Sostituisce nvm, goenv, sdkman e pyenv.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
elif [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate bash)"
fi
