#!/bin/sh
#
# mise
#
# This installs mise and all required plugins for Node.js, Ruby, and other tools using Homebrew.

set -e

# Install mise via Homebrew if not already installed
if ! command -v mise >/dev/null 2>&1; then
  echo "  Installing mise with Homebrew..."
  brew install mise
fi

# Source mise for this session
eval "$(mise activate zsh)"

# Install latest versions
echo "  Installing latest versions..."

# Node.js
mise use --global node@24.4.1
echo "  Installed Node.js 24.4.1"

# Ruby
mise use --global ruby@3.4.5
echo "  Installed Ruby 3.4.5"

# Install global npm packages
echo "  Installing global npm packages..."
npm install -g @anthropic-ai/claude-code

echo "  mise installation complete!"