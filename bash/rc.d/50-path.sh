for d in /usr/local/tinygo/bin "$HOME/.meteor" "$HOME/go/bin"; do
  [ -d "$d" ] && case ":$PATH:" in *":$d:"*) ;; *) PATH="$PATH:$d" ;; esac
done
unset d

# Google Cloud SDK, se installato a mano
if [ -f "$HOME/google-cloud-sdk/path.bash.inc" ]; then
  . "$HOME/google-cloud-sdk/path.bash.inc"
  . "$HOME/google-cloud-sdk/completion.bash.inc"
fi

[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
