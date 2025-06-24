# Dynamically detect Homebrew prefix for cross-architecture compatibility
HOMEBREW_PREFIX=""
if command -v brew >/dev/null 2>&1; then
  HOMEBREW_PREFIX="$(brew --prefix)"
else
  # Fallback detection based on architecture
  if [ "$(uname -m)" = "arm64" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  else
    HOMEBREW_PREFIX="/usr/local"
  fi
fi

export PATH="./bin:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:$ZSH/bin:$PATH"
export MANPATH="${HOMEBREW_PREFIX}/man:${HOMEBREW_PREFIX}/mysql/man:${HOMEBREW_PREFIX}/git/man:$MANPATH"
