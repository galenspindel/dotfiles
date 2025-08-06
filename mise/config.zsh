# mise configuration
# Initialize mise if it's installed
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi