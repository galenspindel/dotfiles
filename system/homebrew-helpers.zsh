# Homebrew helper functions for cross-architecture compatibility

# Get Homebrew prefix reliably
get_homebrew_prefix() {
  if command -v brew >/dev/null 2>&1; then
    brew --prefix
  else
    # Fallback detection when brew is not in PATH yet
    if [ "$(uname -m)" = "arm64" ]; then
      echo "/opt/homebrew"
    else
      echo "/usr/local" 
    fi
  fi
}

# Check if we're on Apple Silicon
is_apple_silicon() {
  [ "$(uname -m)" = "arm64" ]
}

# Check if we're on Intel Mac
is_intel_mac() { 
  [ "$(uname -m)" = "x86_64" ]
}

# Export for use in other scripts
export -f get_homebrew_prefix
export -f is_apple_silicon
export -f is_intel_mac