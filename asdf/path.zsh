# asdf PATH configuration
if command -v asdf >/dev/null 2>&1; then
  # Add asdf to PATH (Homebrew location)
  export PATH="$(brew --prefix asdf)/bin:$PATH"
  export PATH="$(brew --prefix asdf)/shims:$PATH"
fi 
