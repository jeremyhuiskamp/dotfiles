BREW_PREFIX=/usr/local
if type brew &>/dev/null; then
  if [[ -r "$BREW_PREFIX"/etc/bash_completion ]]; then
    . "$BREW_PREFIX"/etc/bash_completion
  elif [[ -r "$BREW_PREFIX"/etc/profile.d/bash_completion.sh ]]; then
    . "$BREW_PREFIX"/etc/profile.d/bash_completion.sh
  else
    for COMPLETION in "$BREW_PREFIX"/etc/bash_completion.d/*; do
      [[ -r "$COMPLETION" ]] && . "$COMPLETION"
    done
  fi
fi
