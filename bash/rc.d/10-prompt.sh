parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

case "$TERM" in
  xterm-color | *-256color | xterm-kitty) _color_prompt=yes ;;
esac

if [ "$_color_prompt" = yes ]; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\] $(parse_git_branch)\[\033[00m\]\$ '
else
  PS1='\u@\h:\w$(parse_git_branch)\$ '
fi
unset _color_prompt
