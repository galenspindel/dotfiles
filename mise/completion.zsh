# mise completions
# Load mise completions if available
if command -v mise >/dev/null 2>&1; then
  eval "$(mise completions zsh)"
fi