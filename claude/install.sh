#!/bin/sh
#
# Claude Code CLI
#
# Installs the Claude Code CLI tool using npm (Node.js managed by asdf).

set -e

# Check for npm
if ! command -v npm >/dev/null 2>&1; then
  echo "  npm not found. Installing Node.js (with asdf)..."
  if ! command -v asdf >/dev/null 2>&1; then
    echo "  asdf is required but not found. Please install asdf first."
    exit 1
  fi
  # Ensure nodejs plugin is added
  if ! asdf plugin-list | grep -q "nodejs"; then
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  fi
  # Install latest nodejs and set global
  asdf install nodejs latest
  asdf set nodejs latest --home
  # Reshim to ensure npm is available
  asdf reshim nodejs
fi

# Install Claude Code CLI globally
if ! npm list -g --depth=0 | grep -q '@anthropic-ai/claude-code'; then
  echo "  Installing Claude Code CLI (@anthropic-ai/claude-code) globally with npm..."
  npm install -g @anthropic-ai/claude-code
else
  echo "  Claude Code CLI is already installed."
fi

echo "  Claude Code CLI installation complete!"
