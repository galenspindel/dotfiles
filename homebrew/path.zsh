# Add Homebrew to PATH (architecture-aware)
if command -v brew >/dev/null 2>&1; then
  # Homebrew is already in PATH, get its prefix
  HOMEBREW_PREFIX="$(brew --prefix)"
else
  # Homebrew not in PATH yet, detect by architecture
  if [ "$(uname -m)" = "arm64" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  else
    HOMEBREW_PREFIX="/usr/local"
  fi
fi

export PATH="${HOMEBREW_PREFIX}/bin:$PATH"