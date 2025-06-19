# asdf completion
if command -v asdf >/dev/null 2>&1; then
  # Source asdf completions from Homebrew location
    completion='$(brew --prefix)/share/zsh/site-functions/_asdf'

    if test -f $completion
    then
    source $completion
    fi

  # Add asdf completions to fpath for zsh
  fpath=("$(brew --prefix asdf)/completions" $fpath)
  # Initialize completions (zsh only)
  if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz compinit
    compinit
  fi
fi

